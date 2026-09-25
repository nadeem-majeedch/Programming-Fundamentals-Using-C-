---
title: "Pointers Exercises"
description: "20 guided exercises — addresses and dereference, the two jobs, references, out-parameters, dynamic arrays, and the failure families. Solutions separated at the end."
---

# Pointers Exercises (20 guided)

> [← Module home](index.md) · ★ = first pass · ★★ = needs the toolkit · ★★★ = combines ideas

**How to use this page.** Every exercise's **first deliverable is the diagram** — boxes, addresses, arrows — then the code. Attempt 15 minutes before opening any [solution](#solutions-s1--s20). ★ items need only Lessons 1–2; ★★★ items combine all three lessons.

---

## Part A — Addresses, pointers, dereference (★, E1–E6)

**E1.** Write the three-line program: declare `int x = 42;`, print `x` and `&x`. Then explain in one sentence why the address changes between runs of the program (hint: [Lesson 1 §2](lesson-1-memory-addresses.md#s2-address-of)).

**E2.** Declare a pointer to `x` from E1, print `p`, `*p`, and `&x` — three outputs, one sentence each: what *is* each output? Then change `x` and print `*p` again.

**E3.** Syntax triage — state whether each compiles, and what it means:
(a) `int* p = &x;` (b) `int p = &x;` (c) `*p = 7;` (given E2's p) (d) `int* p; *p = 7;` (e) `p = nullptr;`.

**E4.** Start from `int a = 5, b = 10; int* p = &a;`. Write the single statement that makes `b` become 99 *without naming b*. Then write the statement that makes `p` point at `b`. Draw before/after diagrams for both.

**E5.** `nullptr` drills: write a pointer that points at nothing; write the guard that prints through it safely; state what happens if the guard is missing (both the symptom and why the symptom is "the good failure mode").

**E6.** Evaluate each expression given `int x = 8; int* p = &x;`: (a) `*p` (b) `&*p` (c) `*&x` (d) `p` (e) `*x`. Two of them are wrong — which, and why?

---

## Part B — The two jobs, references, functions (★–★★, E7–E13)

**E7.** Classify each line as **Job 1 (re-point)** or **Job 2 (write through)**, then give the final values:
```cpp
int a = 1, b = 2;
int* p = &a;
p = &b;      // ?
*p = 20;     // ?
p = &a;      // ?
*p = *p + b; // ?
```

**E8.** Write `void zeroOut(int& n)` and `void zeroOutPtr(int* n)` — the same job in both styles. Call each from `main` correctly. Then list the ceremony differences (the `&` at the call, the `*` in the body, the guard).

**E9.** Write `void divide(int& quotient, int& remainder, int a, int b)` that reports both results of dividing a by b. Guard the b==0 case (set both outputs to 0 and return — document it). Test with 17/5.

**E10.** The **in/out** pattern: write `void normalize(double* value, double minV, double maxV)` that clamps `*value` into [minV, maxV] — reads it, possibly writes it back. Call it on a temperature. Which lesson-2 section is this pattern from?

**E11.** Decision drill — for each requirement, choose **reference or pointer** and justify with the §3 rule: (a) swap two doubles (b) a function returning "the address of the first negative element, or nothing" (c) an out-parameter that always exists (d) a cursor that walks an array inside a loop.

**E12.** Write `const int* findMin(const int* a, int n)` returning the address of the smallest element (or `nullptr` when n ≤ 0). Use it in `main` with the null guard, printing `*result`.

**E13.** The const ladder: for each signature, state in plain words what may and may not change: (a) `void f(int* p)` (b) `void f(const int* p)` (c) `void f(int* const p)` (d) `void f(int& r)` (e) `void f(const int& r)`.

---

## Part C — Arrays and dynamic memory (★★–★★★, E14–E20)

**E14.** Given `int arr[4] = {7, 3, 9, 1};`, evaluate: (a) `arr` (in an expression) (b) `*arr` (c) `arr[2]` (d) `*(arr + 2)` (e) `arr + 2` (f) `&arr[3]`. Draw the array with addresses (start it at 5000) and mark each answer on the drawing.

**E15.** Write the pointer-walking loop that prints an array backward using only pointer arithmetic (no `[i]`, no index variables). Trace it on E14's array.

**E16.** Dynamic basics: read `n` from input, allocate `n` doubles, fill them with `i * 1.5`, print them, release them — pairs counted, same-line idiom used. Why would `double arr[n];` not compile here?

**E17.** Write `int* resized(const int* old, int oldN, int newN)` that allocates a new array of `newN`, copies `min(oldN, newN)` values over, and returns the new handle (the caller still owns the old one — document that contract). Trace the ownership in a diagram.

**E18.** Family identification — for each snippet, name the family (leak / dangling / invalid access) and the fix:
(a) `int* p = new int(5); p = new int(6);`
(b) `int* p = new int(5); delete p; std::cout << *p;`
(c) `int* p = new int[3]; std::cout << p[5];`
(d) `int* make() { int v = 9; return &v; }`

**E19.** Ownership audit: the §4 `readValues` template is used like this —
```cpp
int* a = readValues(n1);
int* b = a;
delete[] a;
delete[] b;      // ?
```
State exactly what goes wrong at the last line, which ownership rule it breaks, and repair the snippet.

**E20.** Capstone drill: write a program that reads `n`, allocates an array, reads the values, prints the average, **and nothing else** — with: the null/degenerate guard, the owner comment, one `delete[]` + same-line nullptr, and a diagram of the stack and heap at the moment of `main`'s peak. (This is the mini-project's seed.)

---

<a name="solutions-s1--s20"></a>
# Solutions (S1–S20)

<a name="s1--three-outputs"></a>
## S1 — Three outputs

```cpp
int x = 42;
std::cout << x << ' ' << &x << '\n';
```
The address differs between runs because the **operating system places the program wherever it likes** each time — the specific number is unreliable by design; the relationship (`&x` is where x lives) is what matters. ([Lesson 1 §2](lesson-1-memory-addresses.md#s2-address-of))

<a name="s2--pointer-to-x"></a>
## S2 — Pointer to x

`p` prints an **address** (the same one `&x` printed — the stored arrow), `*p` prints **42** (the value at that address), `&x` prints x's address. After `x = 50;`, `*p` prints **50** — the pointer wasn't "told"; it aims at the box, and the box changed. ([Lesson 1 §3–4](lesson-1-memory-addresses.md#s3-pointers))

<a name="s3--syntax-triage"></a>
## S3 — Syntax triage

(a) compiles — p is a pointer to int, aimed at x. (b) **compile error** — p would be a plain int; it can't store an address. (c) compiles — writes 7 *into x* through p. (d) compiles (with a warning) — **undefined behaviour**: dereferencing an uninitialized pointer ([Module rule 1](index.md#safety-rules)). (e) compiles — re-points p at nothing; now null, checkable.

<a name="s4--b-becomes-99"></a>
## S4 — b becomes 99

`*p = 99;` after `p = &b;`... precisely: first `p = &b;` (Job 1, move the arrow), then `*p = 99;` (Job 2, write the target). Two statements — but the *first* write-through that lands on b is the answer to "without naming b": `*p = 99` where p aims at b. Diagrams: before, p→a; after Job 1, p→b; after Job 2, b holds 99.

<a name="s5--nullptr-drills"></a>
## S5 — nullptr drills

```cpp
int* q = nullptr;
if (q != nullptr) std::cout << *q;
else              std::cout << "nothing to print\n";
```
Without the guard: dereferencing null is undefined behaviour — typically an immediate **segmentation fault**. That's the "good failure mode": loud, at the guilty line, instead of garbage-pointers' silent misbehaviour. ([Lesson 1 §5](lesson-1-memory-addresses.md#s5-initialization))

<a name="s6--expression-check"></a>
## S6 — Expression check

(a) `8` (b) `&*p` = p (follow, then ask where — back at p) (c) `8` (ask where x lives, then go there — back at x) (d) p's value: x's address (e) **compile error / garbage** — `*x` dereferences a *non-pointer* int; meaningless. So (e) is wrong; and (b)/(c) are the cancellations.

<a name="s7--two-jobs-classify"></a>
## S7 — Two jobs, classified

Line 3 **Job 1** (p→b) · line 4 **Job 2** (b = 20) · line 5 **Job 1** (p→a) · line 6 **Job 2** (a = 1 + 20 = 21 — reads b through p... verify: after line 5, p→a, so `*p` is a; a = a + b = 1 + 20 = 21). Final: **a = 21, b = 20**. ([Lesson 2 §1](lesson-2-references-functions.md#two-jobs))

<a name="s8--zeroout-both"></a>
## S8 — zeroOut both ways

```cpp
void zeroOut(int& n)    { n = 0; }      // alias: plain assignment
void zeroOutPtr(int* n) { if (n) *n = 0; }   // arrow: guard, then write through
// calls:  zeroOut(x);    zeroOutPtr(&x);
```
Ceremony differences: pointer needs `&` at the call, `*` in the body, and the null check; the reference needs none — it *can't* be null. ([Lesson 2 §2, §4](lesson-2-references-functions.md#the-alias))

<a name="s9--divide"></a>
## S9 — divide

```cpp
void divide(int& quotient, int& remainder, int a, int b) {
    if (b == 0) { quotient = 0; remainder = 0; return; }   // documented policy
    quotient  = a / b;
    remainder = a % b;
}
```
17/5 → quotient 3, remainder 2. Two live outputs → references by the §3 rule.

<a name="s10--normalize"></a>
## S10 — normalize

```cpp
void normalize(double* value, double minV, double maxV) {
    if (value == nullptr) return;                 // pointer → guard
    if (*value < minV)      *value = minV;
    else if (*value > maxV) *value = maxV;
}
// caller: normalize(&temp, 16.0, 30.0);
```
This is the **in/out parameter** pattern ([Lesson 2 §4](lesson-2-references-functions.md#out-parameters)): read, then conditionally write back through the same arrow.

<a name="s11--decision-drill"></a>
## S11 — Decision drill

(a) **reference** — targets always exist, no re-aiming. (b) **pointer** — "or nothing" is the null state. (c) **reference** — always exists. (d) **pointer** — traversal needs re-aiming/arithmetic. ([Lesson 2 §3](lesson-2-references-functions.md#the-decision))

<a name="s12--findmin"></a>
<a name="s12"></a>
## S12 — findMin

```cpp
const int* findMin(const int* a, int n) {
    if (a == nullptr || n <= 0) return nullptr;
    const int* best = a;                       // champion by ADDRESS
    for (int i = 1; i < n; i = i + 1)
        if (a[i] < *best) best = &a[i];        // & — the address of the smaller one
    return best;
}
// main: const int* r = findMin(data, n);  if (r) std::cout << *r << '\n';
```
The Unit 09 champion, re-expressed: the index-tracking champion becomes **address-tracking** — `&a[i]` instead of `bestI = i`.

<a name="s13--const-ladder"></a>
## S13 — Const ladder

(a) may change the target and re-point. (b) may **look only** — `*p` read-only (re-pointing still allowed). (c) arrow soldered — may write `*p`, never re-point. (d) may change the target; no null, no re-attach by nature. (e) look only, target exists, no ceremony. ([Lesson 2 §4](lesson-2-references-functions.md#out-parameters))

<a name="s14--array-expressions"></a>
## S14 — Array expressions

Diagram with arr at 5000: boxes 5000:7, 5004:3, 5008:9, 5012:1.
(a) `arr` → **5000** (address of first element) (b) `*arr` → **7** (c) `arr[2]` → **9** (d) `*(arr + 2)` → **9** — same as (c) (e) `arr + 2` → **5008** (address of the third box; arithmetic scales by 4) (f) `&arr[3]` → **5012**. ([Lesson 3 §1](lesson-3-arrays-dynamic.md#arrays-as-addresses))

<a name="s15--backward-walk"></a>
## S15 — Backward walk

```cpp
const int* p = arr + 4;        // last box
const int* end = arr - 1;      // one BEFORE the first — the stop mark
while (p != end) {
    std::cout << *p << ' ';
    p = p - 1;
}
```
Trace: p at 5012 → prints 1 → 5008 prints 9 → 5004 prints 3 → 5000 prints 7 → p == arr−1 → stop. Output: `1 9 3 7`. (Note: `arr - 1` as a *stop mark* is fine; never *dereference* it.)

<a name="s16--dynamic-basics"></a>
## S16 — Dynamic basics

```cpp
int n;  std::cin >> n;
double* a = new double[n];
for (int i = 0; i < n; i = i + 1) a[i] = i * 1.5;
for (int i = 0; i < n; i = i + 1) std::cout << a[i] << ' ';
std::cout << '\n';
delete[] a;
a = nullptr;
```
`double arr[n];` doesn't compile because **stack array sizes must be known at compile time** — runtime size is exactly what the heap is for. Pairs: one `new[]`, one `delete[]` ✓.

<a name="s17--resized"></a>
## S17 — resized

```cpp
// Contract: caller owns BOTH arrays on return — releases the old one itself.
int* resized(const int* old, int oldN, int newN) {
    int* fresh = new int[newN];
    int keep = (oldN < newN) ? oldN : newN;
    for (int i = 0; i < keep; i = i + 1) fresh[i] = old[i];
    return fresh;
}
```
Ownership diagram: two heap blocks; `fresh`'s arrow travels up to the caller; the old block stays owned by whoever owned it before — the function deliberately does *not* delete it (non-owner; `const` says look-only).

<a name="s18--family-identification"></a>
## S18 — Family identification

(a) **leak** — box 1 orphaned by the re-point; fix: `delete` before re-pointing (or hand off). (b) **dangling** — use after delete; fix: `p = nullptr;` on the delete line, then guard. (c) **invalid access** — out of bounds read; fix: respect capacity (the [bounds rule](../arrays/lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does)). (d) **dangling** — address of a dead local; fix: return by value, or take/return a heap box with documented ownership. ([Lesson 3 §5](lesson-3-arrays-dynamic.md#failure-families))

<a name="s19--ownership-audit"></a>
## S19 — Ownership audit

`delete[] b` is a **second delete of the same box** — both pointers own it, which is exactly the "two owners" corruption the ownership rule forbids (heap corruption; often a crash *later*, far away). Repair: one owner —

```cpp
int* a = readValues(n1);
delete[] a;
a = nullptr;      // a is now null, not dangling — and no second delete exists
```
(or copy *values*, not ownership, if both arrays are genuinely needed).

<a name="s20--capstone-drill"></a>
## S20 — Capstone drill

```cpp
#include <iostream>

int main() {
    int n = 0;
    std::cin >> n;
    if (n <= 0) { std::cout << "no data\n"; return 0; }   // degenerate guard

    int* data = new int[n];               // OWN
    for (int i = 0; i < n; i = i + 1) std::cin >> data[i];

    int total = 0;
    for (int i = 0; i < n; i = i + 1) total += data[i];
    std::cout << (1.0 * total / n) << '\n';   // cast rule

    delete[] data;                        // RELEASE — exactly once
    data = nullptr;
    return 0;
}
```
Peak diagram: stack — `n`, `data` (arrow), `i`, `total`; heap — the n-box block, arrowed from `data`. Every requirement ticked: guard ✓, owner comment ✓, one delete[] ✓, same-line nullptr ✓.
