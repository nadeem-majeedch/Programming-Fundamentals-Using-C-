---
title: "Lesson 2 — References, Functions, and Pointer Modification"
description: "Re-pointing and writing through pointers, references as aliases, references vs pointers, and pointer/reference parameters in functions."
---

# Lesson 2 — References, Functions, and Pointer Modification

> [← Module home](index.md) · [← Lesson 1 — Memory](lesson-1-memory-addresses.md) · [Lesson 3 — Arrays and dynamic memory →](lesson-3-arrays-dynamic.md)

## In this lesson you will learn

- the two "jobs" of a pointer — **re-pointing** and **writing through** — and how to tell them apart in code
- **references**: the alias, how it differs from a pointer, and the honest **references vs pointers** decision
- **pointers with functions**: the out-parameter pattern, `const` safety, and the in/out pattern
- where each tool already appears in the course — and why [swap](../functions/lesson-3-references-testing.md) is the rite of passage

---

<a name="two-jobs"></a>
## 1. The two jobs of a pointer

Lesson 1 smuggled both jobs into one trace; name them now, because almost every pointer bug is one job mistaken for the other:

```cpp
int a = 5, b = 10;
int* p = &a;

p  = &b;    // JOB 1: re-point — move the arrow (p changes; a, b unchanged)
*p = 99;    // JOB 2: write through — change the TARGET (b changes; p unchanged)
```

Side by side:

| Statement | The arrow | The target box |
| --- | --- | --- |
| `p = &b;` | **moves** to b | unchanged |
| `*p = 99;` | unchanged | b becomes 99 |

The rule of thumb: **the `*` on the left of `=` means "write where it points"**; no `*` means "move the arrow." Diagrams make this impossible to confuse — [Tracing 3–4](tracing.md) are exactly this drill.

One nuance to meet now, met formally in Lesson 3: `*p` on the **left** of `=` is called an **lvalue** — a location you can write into. `*p` on the right is a read. Same syntax, both jobs: `*p = *p + 1;` reads through the arrow, adds, writes back through it.

---

<a name="the-alias"></a>
## 2. References — the alias

A **reference** is a second name for an existing box. Declaration uses `&` on the *type*:

```cpp
int x = 42;
int& r = x;    // r is another name for x — bound at birth, forever
```

```text
        1000
      ┌──────┐
      │  42  │  x
      └──────┘   r  (no new box — just another label on the same one)
```

Draw the difference immediately: **a reference is not a box.** It gets no address of its own (syntactically `&r` yields x's address); it is a *label stuck on* x's box. Three consequences, all different from pointers:

1. **Must be initialized at birth** — `int& r;` doesn't compile. A pointer can be born empty; a reference is born attached.
2. **Can never re-attach.** `r = 99;` doesn't move r to another variable — it *writes 99 into x*. Assignment through a reference always writes the target. A reference is a pointer whose arrow was soldered at birth.
3. **No null, no check.** A reference always refers to something real, so code using it never guards. (Honesty note: a *dangling* reference is possible if the target dies — Lesson 3's warning applies; in course code, references are always bound to live, caller-owned variables.)

Using it needs no special operator at all:

```cpp
r = 99;                 // x is now 99 — no *, no ceremony
std::cout << r;         // prints 99 — r IS x, in every respect
```

Why does this feel familiar? Because you have been using references since [Unit 08](../functions/lesson-3-references-testing.md):

```cpp
void swap(int& a, int& b) { int t = a; a = b; b = t; }
```

`swap` works because `a` and `b` are **aliases for the caller's boxes**. The function-lesson framing was "no copy is made"; the memory framing is sharper: *the caller's box now has a second name while the function runs.*

### `&` — the full family tree

| Syntax | Name | Job |
| --- | --- | --- |
| `int& r = x;` | reference (declaration) | another name for a box |
| `void f(int& out)` | reference parameter | the alias crosses the call |
| `&x` (expression) | address-of | asks for x's address |
| `a && b` | logical AND | unrelated — same character |

Same symbol, four jobs, disambiguated by position. When reading unfamiliar code, locate the symbol against this table before interpreting anything else.

---

<a name="the-decision"></a>
## 3. References vs pointers — the honest decision

Both tools answer "act on somebody else's box." Here is the full comparison — and then the course rule:

| Property | Reference `int&` | Pointer `int*` |
| --- | --- | --- |
| New box created? | **no** — a label only | **yes** — its own box holds an address |
| Can be null? | no | yes — `nullptr` is normal |
| Re-attachable? | never | anytime |
| Must be initialized? | at birth, by law | yes (to a target or `nullptr`) |
| Syntax at use | plain — `r = 5` | `*` everywhere — `*p = 5` |
| Can "not be pointing at anything"? | no such state | the null state, checkable |

**The course rule:**

> **Default to references.** Choose a pointer only when you need one of the three abilities references lack: to **re-aim** during life, to **say "nothing yet"** (`nullptr`), or to **traverse raw memory** with arithmetic (Lesson 3). If your parameter just needs to modify the caller's variable — reference. If your function might not have a target — pointer, and check it.

Concrete examples of the rule in action:

- `swap(int&, int&)` — two targets, always exist → references. (Pointer version works but adds `*` ceremony for nothing.)
- "find the first even number in a range" — might not exist → return a **pointer** (`nullptr` = not found) or return an index (−1, the [arrays-module convention](../arrays/lesson-2-classic-passes.md#2-minimum-and-maximum--the-champion-with-an-address)); both say "nothing" honestly, the pointer does it in the pointer's own vocabulary.
- A `next` link in a linked structure (Unit 15 preview) — the last node has no next → pointer, null-terminated. This is the pattern references *cannot* express, and it is why data structures are pointer territory.

---

<a name="out-parameters"></a>
## 4. Pointers with functions — the out-parameter

References entered functions in Unit 08. Now watch the *same* machinery run with pointers, because you will read both in real code:

```cpp
void getSize(int* out) {        // the pointer is copied — but the COPY points at the caller's box
    *out = 42;                  // write through the copy — caller's box changes
}

int main() {
    int n = 0;
    getSize(&n);                // hand over n's ADDRESS
    std::cout << n;             // 42
}
```

Trace the mechanism — it is Lesson 1's pass-by-value with one twist:

1. `&n` produces n's address (a value like 1000).
2. `getSize` receives that address **as a copy** (the parameter `out` is a new box holding 1000).
3. `*out = 42` follows the copy's arrow — which lands on n. **The caller's box changes.**

So pointers are pass-by-value too — but what gets copied is an address, and following the copied address lands on the original. The arrow survives the copy; that is the entire trick, and it is the same trick the [array handle](../arrays/lesson-3-arrays-functions.md) performs.

```text
  main:                    getSize:
  ┌──────┐   &n=1000       ┌──────┐
  │ 1000 │ n's address      │ 1000 │ out (parameter copy)
  └──────┘                  └──────┘
      ↑__________________________|     *out = 42 writes through BOTH names
   ┌──────┐
   │  42  │ n
   └──────┘
```

**Reference version of the same function** — compare the ceremony:

```cpp
void getSizeRef(int& out) { out = 42; }  // the alias IS the box — no dereference
// caller:  getSizeRef(n);                // no & at the call site
```

Pointer ceremony checklist: `&` at the call, `*` at every use, **a null check** in the body if there is any chance of `nullptr`:

```cpp
void safeSet(int* out, int v) {
    if (out == nullptr) return;     // the guard — "might be nothing" is a pointer's normal case
    *out = v;
}
```

### The const ladder (reading real signatures)

Real code marks which pointers may write and which may only look. Three rungs, read right-to-left:

```cpp
void f1(int* p);            // may change the TARGET (and may re-point p)
void f2(const int* p);      // pointer to const: LOOK only — *p is read-only
void f3(int* const p);      // const pointer: arrow soldered — may write *p, never re-point
```

You have lived on rung two since Unit 09: `const std::string arr[]` and `const int a[]` parameters are rung-two pointers to const — the compiler enforces "look, don't touch." The course rule stays the one you already know: **mark everything `const` that a function shouldn't change.**

### The in/out parameter

Real functions often *read* a value, use it, and *write back* an updated one — one parameter doing both jobs:

```cpp
void applyDiscount(double* price) {   // reads *price, writes *price
    *price = *price * 0.9;            // 10% off, in place
}
// caller: applyDiscount(&total);
```

In diagrams: one arrow in, used for a read and then a write. The reference twin is `void applyDiscount(double& price)` — same behaviour, no ceremony; which to choose is the §3 rule.

---

## 5. Reference vs pointer in the wild — a worked decision

Requirements: *a function `minMax(a, b, minOut, maxOut)` reports both the smaller and larger of two values.* Two outputs, so the return value alone can't carry them. Walk the decision:

1. Do the outputs always exist? Yes — both are computed from live inputs. → No need for `nullptr`.
2. Re-aiming needed? No. → No need for pointers.
3. → **References**, with the plain syntax doing the work:

```cpp
void minMax(int a, int b, int& minOut, int& maxOut) {
    if (a <= b) { minOut = a; maxOut = b; }
    else        { minOut = b; maxOut = a; }
}
```

Then the counter-case: *a function `findEven(a, n)` returns the address of the first even element, or nothing.* "Or nothing" is the pointer's native state:

```cpp
const int* findEven(const int* a, int n) {   // const ladder rung 2 + pointer params
    for (int i = 0; i < n; i = i + 1)
        if (a[i] % 2 == 0) return &a[i];     // & on an element — its address
    return nullptr;                          // "not found", the pointer way
}
// caller:
const int* hit = findEven(data, n);
if (hit != nullptr) std::cout << *hit << '\n';
```

One function chose references, one chose pointers — **the requirements decided, not habit.** That is the skill this lesson teaches; [Exercises 8–13](exercises.md) run it six more times.

---

## Practice

- [Exercises 7–13](exercises.md) — the two jobs, reference drills, out-parameters, the decision
- [Tracing 5–7](tracing.md) — reference vs pointer diagrams side by side
- [Lab 2 — the swap clinic](labs.md#lab-2--the-swap-clinic) — all three swap variants, traced
- [Debugging D1–D3](debugging.md) — the classic two-jobs and alias mistakes

## Key takeaways

- `p = &b` moves the arrow; `*p = 99` writes the target — **the `*` on the left means "write where it points"**
- A **reference** is a soldered alias: born attached, never re-attached, no null, no `*`
- Pointers are pass-by-value of an *address* — the copy still lands on the caller's box
- Read the const ladder right-to-left; `const int*` = look only (it's your array parameter, revealed)
- **Default to references; choose pointers for re-aiming, nullability, or memory traversal** — let the requirements decide
