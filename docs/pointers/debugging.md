---
title: "Pointers Debugging Exercises"
description: "10 seeded memory bugs — the two jobs confused, unguarded nulls, dangling pointers, leaks, out-of-bounds arithmetic — each fixable by drawing the diagram."
---

# Pointers Debugging Exercises (10)

> [← Module home](index.md) · Work each in the [debugging protocol](../arrays/debugging.md): reproduce → form hypotheses → instrument → fix → **reflect**. Here the protocol gains one step, always first: **draw the diagram of what the code *thinks* is true.**

**Format.** Each program compiles (unless stated) but misbehaves or crashes. Hint ladders are collapsible — expand one rung at a time. [Fix-list summary](#solutions-summary) at the end. ⚠️ These are pencil-and-machine exercises: **hand-trace every one before running it**, and run the crashy ones knowing exactly why they crash.

---

## D1 — The switcheroo (the two jobs confused)

```cpp
int main() {
    int a = 1, b = 2;
    int* p = &a;
    *p = &b;        // intent: make p point at b
    std::cout << *p << '\n';
}
// Expected: 2.   Compiler: ERROR (or worse, if it slips through on old compilers).
```

<details markdown="1"><summary>Hint 1 — which job did the author want, and which did they write?</summary>

Intent is Job 1 (re-point): `p = &b;`. Written is Job 2's *syntax* with Job 1's *value*: `*p = &b` tries to write an **address** into `a` — a type mismatch (`int` vs `int*`), rejected by the compiler.
</details>

<details markdown="1"><summary>Hint 2 — the fix and the lesson</summary>

`p = &b;` — no star. The star means "write where it points"; the author wanted "move the arrow." ([Lesson 2 §1](lesson-2-references-functions.md#two-jobs))
</details>

**Reflection.** Every pointer statement is one of the two jobs. Say which one you mean out loud, then write it.

## D2 — The promise not kept (uninitialized dereference)

```cpp
int main() {
    int* p;
    int x = 42;
    *p = x;          // "store x somewhere" — where?
    std::cout << *p;
}
```
Expected: 42. Observed: sometimes 42, sometimes garbage, sometimes a crash — never reliably anything.

<details markdown="1"><summary>Hint 1 — where does the arrow point at the moment of <code>*p = x</code>?</summary>

Nowhere sane — `p` was never initialized; it holds garbage. The write landed in a random box.
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

Initialize at birth ([Module rule 1](index.md#safety-rules)): `int* p = &x;` — then `*p = x;` is even redundant; `int* p = &x;` alone does the job.
</details>

**Reflection.** "It printed 42!" is not evidence — undefined behaviour can imitate correctness. Draw the arrow: if it points at garbage in the diagram, the program is wrong however it behaves.

## D3 — The unguarded helper (null accepted, dereferenced anyway)

```cpp
void setTo(int* target, int value) {
    *target = value;      // crashes when called as setTo(nullptr, 5)
}

int main() {
    int* p = nullptr;     // "no target yet" — a NORMAL pointer state
    setTo(p, 5);
}
```

<details markdown="1"><summary>Hint 1 — whose job is the null check, caller or callee?</summary>

Both can, but the **callee must** if it accepts pointers: "might be null" is a pointer parameter's normal case ([Lesson 2 §4](lesson-2-references-functions.md#out-parameters)).
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

```cpp
void setTo(int* target, int value) {
    if (target == nullptr) return;   // or report the refusal
    *target = value;
}
```
Or change the contract to a reference (`int& target`) if "always exists" is the truth — then the compiler enforces it.
</details>

**Reflection.** The signature is a contract. `int*` promises *maybe nothing* — so guard. `int&` promises *always there* — so don't. Choose the one that matches reality.

## D4 — The leaky loop (re-point without release)

```cpp
int main() {
    for (int i = 0; i < 1000; i = i + 1) {
        int* p = new int(i);
        if (i % 2 == 0) p = nullptr;   // "clean up" — or so the author thought
    }
    std::cout << "done\n";
}
```
Expected (by the author): tidy cleanup. Observed: memory use climbs by ~1000 ints; nothing crashes.

<details markdown="1"><summary>Hint 1 — trace ONE loop pass as a diagram. Where does the heap box go when <code>p</code> is set to null? When <code>p</code> is re-created next pass?</summary>

Setting `p = nullptr` doesn't free the box — it just drops the *only* arrow. Next pass re-points `p` at a new box; the old one is orphaned **every** pass. 1000 leaked boxes, silently.
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

```cpp
for (int i = 0; i < 1000; i = i + 1) {
    int* p = new int(i);
    // ... use p ...
    delete p;          // release BEFORE the arrow is lost
    p = nullptr;
}
```
And the honest design answer: this loop never needed the heap at all — `int value = i;` does the same job with zero risk ([Module rule 5](index.md#safety-rules)).
</details>

**Reflection.** "Setting to null" is cleanup of the *pointer*, never of the *box*. `delete` frees boxes; `= nullptr` tames arrows. Different objects, different verbs.

## D5 — The use-after-free (dangling read)

```cpp
int main() {
    int* p = new int(42);
    delete p;
    if (*p == 42)                 // "just checking..." — checking WHAT?
        std::cout << "still there\n";
    else
        std::cout << "changed\n";
}
```
Expected: neither — the program's behaviour is undefined. Observed: often prints "still there" *today* — and corrupts or crashes next week after an unrelated edit.

<details markdown="1"><summary>Hint 1 — what does <code>p</code> hold after <code>delete</code>?</summary>

The same address — but the box is returned. Reading it is reading memory the system may hand to someone else at any moment. This is Family 2, the delayed-corruption family ([Lesson 3 §5](lesson-3-arrays-dynamic.md#failure-families)).
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`delete p; p = nullptr;` on one line — then the "just checking" becomes `if (p != nullptr)`, which is honest: nothing there.
</details>

**Reflection.** The same-line idiom is not ceremony — it converts the *worst* bug family (silent, delayed) into the *best* failure mode (loud, immediate).

<a name="d6"></a>
## D6 — The return of the local (dangling by function exit)

```cpp
int* makeCounter() {
    int count = 0;
    return &count;       // author: "hand the counter up to the caller"
}

int main() {
    int* c = makeCounter();
    *c = *c + 1;         // "increment the counter"
    std::cout << *c << '\n';
}
```
Expected: 1. Observed: garbage, or a crash, or 1 — with a **compiler warning** (`address of stack memory associated with local variable 'count' returned`) that the author ignored.

<details markdown="1"><summary>Hint 1 — draw the stack. What happens to <code>count</code>'s box the moment <code>makeCounter</code> returns?</summary>

The frame pops — the box evaporates. The caller's arrow points at a ghost. Family 2, way 2 ([Lesson 3 §2](lesson-3-arrays-dynamic.md#stack-heap)).
</details>

<details markdown="1"><summary>Hint 2 — the fixes, best first</summary>

1. Return the value: `int makeCounter() { int count = 0; return count; }` — copies are cheap for small data.
2. Out-parameter: `void init(int& count) { count = 0; }` — caller's box, borrowed honestly.
3. Heap: `new` inside, documented ownership handoff — but only if the data is genuinely big.
</details>

**Reflection.** Heap boxes outlive functions; stack boxes don't. If you need the heap *only* to survive a return, first check whether a copy is simpler ([Module rule 5](index.md#safety-rules)).

<a name="d7"></a>
## D7 — The crossed wires (new[] with delete)

```cpp
int main() {
    int* data = new int[10];
    for (int i = 0; i < 10; i = i + 1) data[i] = i;
    delete data;      // one character off
    data = nullptr;
    std::cout << "ok\n";
}
```
Expected: clean. Observed: usually "ok" — and the heap's bookkeeping for *arrays* is now quietly damaged; crashes appear later, in unrelated allocations.

<details markdown="1"><summary>Hint 1 — which pairs rule does this break?</summary>

Module rule 4: `new[]` ↔ `delete[]` — the bracket-less `delete` on an array block is undefined behaviour ([Lesson 3 §4](lesson-3-arrays-dynamic.md#delete)).
</details>

<details markdown="1"><summary>Hint 2 — the deeper lesson</summary>

Count the pairs *by form*, not just by number. `new int` → `delete`; `new int[n]` → `delete[]`. Say both halves out loud when you write either.
</details>

**Reflection.** "It ran fine" is exactly how heap corruption behaves — the damage surfaces elsewhere, later. Pairs rules exist because the compiler can't check this one for you.

## D8 — The straying pointer (out-of-bounds arithmetic)

```cpp
int main() {
    int* data = new int[5];
    for (int i = 0; i < 5; i = i + 1) data[i] = i * i;
    int* p = data;
    for (int i = 0; i <= 5; i = i + 1) {     // spot it...
        std::cout << *p << ' ';
        p = p + 1;
    }
    delete[] data;
    data = nullptr;
}
```
Expected: `0 1 4 9 16` — five values. Observed: six values — the sixth read from memory past the block.

<details markdown="1"><summary>Hint 1 — how many boxes does the block have, and what does <code>p</code> aim at on the sixth pass?</summary>

Five boxes; on pass six `p` aims one *past the end* — the [begin,end) convention exists precisely to make "one past the last" a stop mark, never a dereference target ([Lesson 3 §1](lesson-3-arrays-dynamic.md)).
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`i < 5` (or the pointer form: `while (p != data + 5)`). The off-by-one you've fought since Unit 05 is the same bug with an arrow instead of an index.
</details>

**Reflection.** Pointer arithmetic has **no bounds checking whatsoever** — the loop condition is the only fence. Draw the block; count the dereferences.

## D9 — The double release (two owners, one box)

```cpp
void process(int* data, int n) {
    int total = 0;
    for (int i = 0; i < n; i = i + 1) total += data[i];
    std::cout << total << '\n';
    delete[] data;                 // "helpfully" cleaning up
}

int main() {
    int n = 3;
    int* data = new int[n]{1, 2, 3};
    process(data, n);
    delete[] data;                 // main also cleans up — it thinks it's the owner
    data = nullptr;
}
```
Expected: prints 6, clean exit. Observed: prints 6, then heap corruption or a crash at exit — the same box was returned twice.

<details markdown="1"><summary>Hint 1 — who does the ownership rule say deletes?</summary>

**Exactly one owner.** Here `main` news the box and `process` deletes it — two owners, one box ([Lesson 3 §6](lesson-3-arrays-dynamic.md#ownership)). The second delete corrupts the heap's records.
</details>

<details markdown="1"><summary>Hint 2 — two honest repairs</summary>

1. `process` is a *user*, not an owner: take `const int* data, int n`, drop its delete (the `const` documents "look only").
2. If `process` should own, *transfer* visibly: document the contract in the name/comment — but then `main` must not delete. Pick one; write the contract down.
</details>

**Reflection.** Ownership isn't a mood — it's a written contract with one name on it. The `const` on a parameter is that contract, enforced.

## D10 — The silent orphan (ownership handoff dropped)

```cpp
int* loadValues(int n) {
    int* data = new int[n];
    for (int i = 0; i < n; i = i + 1) data[i] = i * 10;
    return data;                   // hands the handle AND the ownership up
}

int main() {
    loadValues(5);                 // "just load them in" — the return is discarded
    std::cout << "loaded\n";
}
```
Expected (by the author): values loaded. Observed: prints "loaded"; five heap boxes are leaked — allocated, returned to nobody, unreturnable.

<details markdown="1"><summary>Hint 1 — where did the handle go?</summary>

The return value was discarded — the arrow existed for one expression and vanished. The boxes are now unreachable: Family 1, the leak ([Lesson 3 §5](lesson-3-arrays-dynamic.md#failure-families)).
</details>

<details markdown="1"><summary>Hint 2 — the fix, and the design question behind it</summary>

```cpp
int* data = loadValues(5);   // catch the handle — accept ownership
// ... use ...
delete[] data;
data = nullptr;
```
Then ask the design question: does `main` need a *dynamic* array at all here? If the caller immediately deletes after one pass, a stack array sized to a known cap (or the course's usual `const int` sizes) is simpler — [Module rule 5](index.md#safety-rules).
</details>

**Reflection.** An ownership *handoff* requires a receiver. Discarding a returned heap handle is dropping a live wire — catch it, or don't generate it.

---

<a name="solutions-summary"></a>
# Fix-list summary

| D | Family / lesson | Bug (one line) | Fix (one line) |
| - | --------------- | -------------- | -------------- |
| D1 | two jobs | `*p = &b` — Job 2 syntax, Job 1 intent | `p = &b;` |
| D2 | invalid access | uninitialized dereference | initialize at birth |
| D3 | invalid access | unguarded null in callee | `if (target == nullptr) return;` — or take a reference |
| D4 | leak | re-point/orphan in a loop | `delete` before losing the arrow — or no heap at all |
| D5 | dangling | use after delete | `delete p; p = nullptr;` same line |
| D6 | dangling | returning a local's address | return by value / out-param / heap with contract |
| D7 | heap corruption | `delete` on a `new[]` block | `delete[]` — match the forms |
| D8 | invalid access | off-by-one pointer walk | stop at one-past-the-end; never dereference it |
| D9 | double delete | two owners, one box | one owner — `const` documents users |
| D10 | leak | returned handle discarded | catch it and own it — or don't allocate |
