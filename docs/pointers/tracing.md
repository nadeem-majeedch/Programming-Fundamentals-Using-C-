---
title: "Pointers Memory-Tracing Exercises"
description: "10 draw-the-diagram exercises — stack and heap, arrows and aliases, including one deliberate leak and one dangling arrow to catch by eye."
---

# Pointers Memory-Tracing Exercises (10)

> [← Module home](index.md) · **The rule of this page: diagram first, verdict second, code never.** You are not asked to write programs — you are asked to *see* them. Every answer includes the reference diagram drawn in the course style; check your arrow work against it.

**Drawing style** (same as the lessons): one box per variable, **address above the box**, value inside, **arrows** for pointers, dashed outline for heap boxes, and heap boxes drawn *lower*, separated from the stack.

```text
   STACK                        HEAP
  ┌──────┐                    ╔══════╗
  │ 1000 │ p                 ║  42  ║  anonymous
  └──────┘                    ╚══════╝
      ↑___________________________|
```

Trace each snippet **statement by statement** — one diagram per state change — then commit to the answers. All solutions are in the [answers section](#answers) (separated so you can't peek by accident).

---

## T1 — Warm-up: names, values, addresses (★)

```cpp
int x = 7;
int y = x;
y = 9;
```
**Draw** the state after each line (choose addresses: x at 1000, y at 1004).
**Answer:** (a) after line 2, what is x? (b) which statement proved y was a copy, not an alias?

## T2 — The alias (★)

```cpp
int x = 7;
int& r = x;
r = 9;
```
**Draw** all three lines (draw r as a *label*, not a box — [Lesson 2 §2](lesson-2-references-functions.md#the-alias)).
**Answer:** (a) after line 3, x = ? (b) how many boxes exist? (c) what does `&r` print?

## T3 — The pointer twin (★)

```cpp
int x = 7;
int* p = &x;
*p = 9;
```
**Draw** after each line.
**Answer:** (a) how many *boxes* exist now (count p!) (b) after line 3, x = ? (c) name the one statement that would make p point at a *new, different* variable y.

## T4 — Two jobs (★)

```cpp
int a = 1, b = 2;
int* p = &a;
p = &b;
*p = 20;
```
**Draw** four diagrams — one per line.
**Answer:** (a) which two lines changed the arrow, and which changed a box? (b) final a and b?

## T5 — The dropped arrow (★★ — the leak, by eye)

```cpp
int* p = new int(10);
p = new int(20);
```
**Draw** after line 1. Then draw after line 2 — and **mark the orphan**.
**Answer:** (a) what happened to the first box? (b) name the family and the one-line fix (two acceptable fixes).

## T6 — Swap, three ways (★★)

Version A: `void swapV(int a, int b)` — plain values, classic swap body.
Version B: `void swapR(int& a, int& b)` — references.
Version C: `void swapP(int* a, int* b)` — pointers, body uses `*a`/`*b`.
Call each with `swap?(x, y)` / `swapP(&x, &y)` from main, x=1, y=2.
**Draw** the moment of the first body line for each version (what boxes exist *inside* the callee?).
**Answer:** (a) which version(s) affect main's boxes, and by what mechanism? (b) for version A, what would x and y be after the call?

## T7 — Reference vs pointer parameter (★★)

```cpp
void refOn(int& r)  { r = r + 1; }
void ptrOn(int* p)  { *p = *p + 1; }

int main() {
    int n = 10;
    refOn(n);
    ptrOn(&n);
}
```
**Draw** both calls at their moment of execution (parameter boxes included; for ptrOn, draw p's own stack box).
**Answer:** (a) after both calls, n = ? (b) which callee has a box holding an address? (c) which callee *cannot* be called on a null target, ever, and why?

## T8 — Array name and arithmetic (★★)

```cpp
int arr[4] = {10, 20, 30, 40};
int* p = arr + 1;
std::cout << *p;      // ?
p = p + 2;
std::cout << *p;      // ?
```
**Draw** the array at 5000 (boxes 5000/5004/5008/5012), then p after each statement.
**Answer:** (a) the two printed values (b) what does `p - 1` point at after the last line? (c) what would `*(p + 1)` read *after* line 4 — and is that read safe?

## T9 — The dynamic block (★★★)

```cpp
int n = 3;
int* data = new int[n];
data[0] = 5;
data[1] = 6;
data[2] = 7;
int* cursor = data;
delete[] data;
data = nullptr;
// ...and the snippet stops. cursor is never touched again.
```
**Draw** at the peak (after line 6), and again after line 8.
**Answer:** (a) at the peak, which stack boxes hold addresses? (b) after line 8, what does `cursor` hold — is it null? (c) name the exact latent bug this snippet ends with, its family, and the two-line repair.

## T10 — The mystery snippet (★★★ — diagnose by eye)

A classmate wrote this and reports it "usually works":

```cpp
int* make() {
    int local = 99;
    return &local;
}

int main() {
    int* p = make();
    std::cout << *p << '\n';     // prints 99?! "works!"
}
```
**Draw** the stack at the moment `make` returns, and the moment after.
**Answer:** (a) what does the *returning* do to `local`'s box, in diagram terms? (b) why does the print often show 99 anyway? (c) which family is this, which lesson section names it, and what are the two honest fixes? (d) why is "it printed 99" worthless as evidence?

---

<a name="answers"></a>
# Answers

<details markdown="1"><summary>A1 — T1 (copy semantics)</summary>

After line 2: x = 7 (at 1000), y = 7 (at 1004) — two boxes, same value. Line 3 changes *only y* to 9; x stays 7. **(a)** x = 7. **(b)** line 3 — an alias would have changed x too; a copy doesn't.
</details>

<details markdown="1"><summary>A2 — T2 (the alias)</summary>

**(a)** x = 9. **(b)** **one** box (1000) — r is a label on it, not a box. **(c)** `&r` prints 1000 — x's address; a reference exposes its target's address. ([Lesson 2 §2](lesson-2-references-functions.md#the-alias))
</details>

<details markdown="1"><summary>A3 — T3 (the pointer twin)</summary>

**(a)** **two boxes**: x at 1000, p at 2004 holding the value 1000. **(b)** x = 9 — the write went *through* the arrow. **(c)** `p = &y;` — Job 1, re-point. (T2's reference *cannot* do this; that's the pair's whole point.)
</details>

<details markdown="1"><summary>A4 — T4 (two jobs)</summary>

**(a)** lines 3 and 1... precisely: line 2 (`p = &a`) and line 3 (`p = &b`) move the arrow; line 4 (`*p = 20`) changes a box (b). **(b)** a = 1, b = 20.
</details>

<details markdown="1"><summary>A5 — T5 (the dropped arrow)</summary>

After line 2: p holds the second box's address; the first heap box has **no incoming arrow** — mark it orphaned. **(a)** it leaked: allocated, unowned, unreturnable. **(b)** Family 1 (leak). Fixes: `int* q = p; p = new int(20);` (hand the arrow to a second owner-pointer) — or `delete p;` before re-pointing. ([Lesson 3 §5](lesson-3-arrays-dynamic.md#failure-families))
</details>

<details markdown="1"><summary>A6 — T6 (swap three ways)</summary>

At the first body line: **A** — the callee has its own two stack boxes (copies of 1 and 2); swapping them touches nobody else. **B** — the callee has *no new boxes*; `a`/`b` are labels on main's boxes. **C** — the callee has two small stack boxes, each holding *an address* of main's boxes; the body follows them. **(a)** B (aliases) and C (copied addresses that still land on the originals) affect main; A affects only its own copies. **(b)** x = 1, y = 2 — the classic [why-swap-needs-references](../functions/lesson-3-references-testing.md) demonstration.
</details>

<details markdown="1"><summary>A7 — T7 (reference vs pointer parameter)</summary>

**(a)** n = 12 (each call adds 1). **(b)** only `ptrOn` — its `p` is a real stack box holding n's address. **(c)** `refOn` — a reference cannot be null, and there is no syntax to even attempt it (`refOn(nullptr)` doesn't compile); the safety is structural, not a runtime check.
</details>

<details markdown="1"><summary>A8 — T8 (arithmetic)</summary>

**(a)** prints **20** (p at 5004) then **40** (p at 5012 — 5004 + 2 strides of 4). **(b)** `p - 1` points at 5008 — value 30. **(c)** `*(p + 1)` would read 5016 — **one past the last box**: unsafe to dereference; the [begin,end) stop mark ([Lesson 3 §1](lesson-3-arrays-dynamic.md)). Diagnosing this by eye is exactly what the diagram is for.
</details>

<details markdown="1"><summary>A9 — T9 (the dynamic block)</summary>

**(a)** at the peak, `data` and `cursor` both hold the heap block's address — two arrows, one block. **(b)** `cursor` still holds the old address — it is **not** null; only `data` was nulled. **(c)** `cursor` is a **dangling pointer**: the block was returned while `cursor` still aims at it (Family 2). Repair: `cursor = nullptr;` on the delete line (or scope `cursor` so it dies with the block, or set both in one habit: `delete[] data; data = nullptr; cursor = nullptr;`). The lesson: **every** arrow to a freed box needs taming, not just the deleting one.
</details>

<details markdown="1"><summary>A10 — T10 (the mystery snippet)</summary>

**(a)** returning pops `make`'s frame — `local`'s box ceases to exist; p's arrow now points at a recycled region of stack. **(b)** the bytes 99 often survive untouched for a while — the print *imitates* correctness. **(c)** Family 2, dangling — the compiler even warns (`address of local variable returned`); fixes: return by value, or a heap box with documented ownership ([Lesson 3 §2](lesson-3-arrays-dynamic.md#stack-heap), [D6](debugging.md#d6)). **(d)** undefined behaviour may imitate correctness today and corrupt tomorrow — the diagram shows the truth the output hides: an arrow to a box that no longer exists.
</details>
