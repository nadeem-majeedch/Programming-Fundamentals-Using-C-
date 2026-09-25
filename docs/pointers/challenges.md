---
title: "Pointers Challenges"
description: "10 design challenges — address-based algorithms, two-pointer passes, ownership-heavy designs, and the family-detective drills — with separated solutions."
---

# Pointers Challenges (10)

> [← Module home](index.md) · Attempt **30 minutes** before reading any solution — and **draw first**: every challenge here is solved on paper before it compiles. Solutions separated at the end; each gives the approach plus key code. ★ = Lesson 1–2 · ★★ = adds Lesson 3 · ★★★ = combines everything.

---

## C1 — The pointer swap (★)

Write `void swapPtr(int* a, int* b)` — swap two caller variables using only pointer syntax — and prove it with a three-case test: (a) two distinct variables (b) the *same* variable passed twice (`swapPtr(&x, &x)`) (c) a null passed — document what your function does.

## C2 — The address-of-maximum walk (★★)

Given an `int` array, find the address of its maximum element **using only pointer arithmetic** — no `[]`, no index variables. Return `nullptr` for an empty range. Then report the maximum's *position* by subtracting: `pos = maxPtr - arr` — and explain why pointer subtraction yields a count.

## C3 — The two-pointer partition (★★)

The [arrays module's stable partitioner](../arrays/challenges.md) used indices. Redo it with pointers: move all even numbers of an array to its front (order within each group preserved), walking with a `read` cursor and a `write` cursor. Report how many writes happened.

## C4 — The dynamic roster (★★)

Read an unknown count of exam scores (sentinel −1), storing them in a **dynamic array that grows by doubling** (start capacity 4; when full, allocate double, copy, delete[] the old, re-point). Return both the handle and the final count through an out-parameter. Document the ownership contract in one comment line.

## C5 — The leak detective (★★★)

Study this snippet and produce a **written audit**: every heap box, its owner at each line, and a final verdict (clean / leaked / dangling / double-delete):

```cpp
int* a = new int(1);
int* b = a;
delete a;
a = nullptr;
b = new int(2);
delete[] b;
```
Then repair it to a clean version with the same behaviour.

## C6 — The null-safe toolkit (★★)

Three functions, one contract style: `countNeg`, `sumPos`, `firstZero` — each takes `(const int* a, int n)`, each treats `nullptr` **or** `n <= 0` as "empty range" (returning 0 / 0 / nullptr respectively). Prove all six degenerate paths with a test driver.

## C7 — The reverse-in-place (★★)

Reverse a dynamic array **in place** with two pointers walking from the ends, swapping through dereference — no second array, no indices. Then state, in one sentence, why the two pointers' meeting condition is `left < right` and not `left != right`.

## C8 — The ownership chain (★★★)

Design (on paper, then code) a tiny sequence: `int* makeFilled(int n, int start)` returns a heap array filled `start, start+1, ...`; `int* append(int* base, int& baseN, int value)` returns a **new** array one longer (old one's fate: your documented choice — but no leaks, no dangling); `main` uses both and ends clean. Diagram the ownership at every handoff.

## C9 — The const-propagation puzzle (★★★)

Given `const int* data` (size n), write `int countAbove(const int* data, int n, int t)` — and then explain each `const` in the *full* signature `const int* countAbovePtr(const int* data, int n, int t, const int* limit)` returning the address of the first element above `*limit`... **or** argue, in writing, why returning an address into const data forces the *caller's* pointer to be `const int*` too — the const is contagious, and that's a feature.

## C10 — The family triage (★★★)

Five snippets, no running allowed — for each: family (leak/dangling/invalid/double-delete/clean), one-line reason, one-line fix:

(a) `int* p = new int[4]; p[4] = 0; delete[] p;`
(b) `int* f() { int* q = new int(3); return q; }` — called as `f();` with the result discarded
(c) `int* p = new int(1); int* q = p; delete p; delete q;`
(d) `int* p = new int(1); delete p; p = nullptr; if (p) std::cout << *p;`
(e) `void g(int* p) { *p = 5; }` — called as `g(nullptr);`

---

<a name="solutions"></a>
# Solutions (approaches + key code)

<details markdown="1"><summary>C1 — Pointer swap</summary>

```cpp
void swapPtr(int* a, int* b) {
    if (a == nullptr || b == nullptr) return;   // documented: null = no-op
    if (a == b) return;                          // same box: swapping with itself is a no-op anyway
    int t = *a; *a = *b; *b = t;
}
```
(a) works — two arrows into two boxes, rotate the values. (b) the `a == b` guard makes it explicitly safe; even without it, the classic body is self-neutralizing (t = *a; *a = *a; *a = t). (c) the null guard makes the call a no-op — **write that in the contract comment**. The whole point of the pointer version: it works where references can't even *say* "maybe".
</details>

<details markdown="1"><summary>C2 — Address of maximum</summary>

```cpp
const int* maxAddr(const int* arr, int n) {
    if (arr == nullptr || n <= 0) return nullptr;
    const int* best = arr;
    for (const int* p = arr + 1; p != arr + n; p = p + 1)   // begin+1 .. one-past-end
        if (*p > *best) best = p;
    return best;
}
// position:  int pos = maxAddr(arr, n) - arr;    // pointer difference = element count
```
Why subtraction yields a count: `p - arr` asks "how many **strides** between the two addresses?" — the compiler divides the byte distance by the type's size. It's the arithmetic twin of `i - 0`. ([Lesson 3 §1](lesson-3-arrays-dynamic.md))
</details>

<details markdown="1"><summary>C3 — Two-pointer partition</summary>

```cpp
int evensFirst(int* a, int n) {
    int* write = a;                          // next slot for an even value
    int writes = 0;
    for (int* read = a; read != a + n; read = read + 1) {
        if (*read % 2 == 0) {
            int t = *write; *write = *read; *read = t;   // swap into the write slot
            write = write + 1;
            writes += 1;
        }
    }
    return writes;
}
```
`read` scans every box once; `write` lags behind, marking where the next even belongs. When `read` finds an even, swap it into `*write` and advance `write`. Order within evens is preserved because `read` moves forward only. Trace `{3, 8, 5, 2}`: read hits 8 → swap into slot 0 → `{8, 3, 5, 2}`; hits 2 → swap into slot 1 → `{8, 2, 5, 3}`; writes = 2 ✓.
</details>

<a name="c4"></a>
<details markdown="1"><summary>C4 — Doubling roster</summary>

```cpp
// Contract: caller owns the returned array and must delete[] it exactly once.
void readScores(int*& data, int& count) {      // data is an in/out HANDLE — see below
    int cap = 4;
    data  = new int[cap];
    count = 0;
    int v;
    std::cin >> v;
    while (v != -1) {
        if (count == cap) {                    // full: grow by doubling
            int* bigger = new int[cap * 2];
            for (int i = 0; i < count; i = i + 1) bigger[i] = data[i];
            delete[] data;                     // release the old block
            data = bigger;                     // re-point — old arrow replaced AFTER the delete
            cap  = cap * 2;
        }
        data[count] = v;
        count += 1;
        std::cin >> v;
    }
}
```
The subtle syntax: `int*& data` is a **reference to a pointer** — so the function can re-aim the *caller's* arrow (Job 1 on a parameter!). Without the `&`, the doubling would re-aim a local copy and leak. Trace one growth: capacity 4 full at count 4 → allocate 8, copy 4, delete old 4-block, re-point, continue. Pairs stay balanced: every old block is deleted exactly when replaced. This is, in miniature, how `std::vector` grows — the [course's automation](lesson-3-arrays-dynamic.md#ownership) of exactly this.
</details>

<details markdown="1"><summary>C5 — Leak detective audit</summary>

Line-by-line ownership:

| Line | Heap boxes alive | Owner(s) | Verdict |
| --- | --- | --- | --- |
| 1 | box₁(1) | a | ok |
| 2 | box₁ | a **and** b | two arrows, one box — not yet a bug |
| 3 | — (box₁ freed) | none | ok — but **b now dangles** |
| 4 | — | — | a cured; b still dangling |
| 5 | box₂(2) | b (re-point *after* old box deleted — no orphan here) | ok |
| 6 | — | — | **form mismatch**: `delete[]` on a non-array `new` |

**Verdict: one form-mismatch (undefined behaviour) + a transient dangling window (harmless here because b was re-pointed before use, but a loaded gun on the floor).** Clean repair:

```cpp
int* a = new int(1);
delete a;          // release before losing the arrow — b never needed
a = nullptr;
int* b = new int(2);
delete b;          // matching form: new ↔ delete (no brackets!)
b = nullptr;
```
If both pointers must co-exist, the ownership rule says one owner deletes; the other's arrow must be tamed (nulled or scoped away) before the delete happens.
</details>

<details markdown="1"><summary>C6 — Null-safe toolkit</summary>

```cpp
int countNeg(const int* a, int n) {
    if (a == nullptr || n <= 0) return 0;      // the empty-range contract
    int c = 0;
    for (int i = 0; i < n; i = i + 1) if (a[i] < 0) c += 1;
    return c;
}
int sumPos(const int* a, int n) {
    if (a == nullptr || n <= 0) return 0;
    int s = 0;
    for (int i = 0; i < n; i = i + 1) if (a[i] > 0) s += a[i];
    return s;
}
const int* firstZero(const int* a, int n) {
    if (a == nullptr || n <= 0) return nullptr;
    for (int i = 0; i < n; i = i + 1) if (a[i] == 0) return &a[i];
    return nullptr;
}
// driver: run each with (nullptr, 5), (data, 0), (data, -3), (data, n) — 12 rows, all survive
```
The design idea: degenerate inputs get **one guarded line**, uniformly — then the body can assume reality. This is the guard-chain pattern ([decisions module](../decisions/index.md)) applied to pointers.
</details>

<details markdown="1"><summary>C7 — Reverse in place</summary>

```cpp
void reverse(int* a, int n) {
    int* left  = a;
    int* right = a + n - 1;            // last box
    while (left < right) {
        int t = *left; *left = *right; *right = t;
        left  = left + 1;
        right = right - 1;
    }
}
```
Why `left < right`: with `left != right`, on an **even** length the pointers cross and *never compare equal* — they swap past each other and keep swapping outward pairs a second time (the array un-reverses!), then walk off both ends into invalid memory. `left < right` makes the middle (and the cross) a clean stop. Trace `{1,2,3,4}`: swap (1,4) → swap (2,3) → left(5008) == right(5004) fails `left<right`? — precisely: after the second swap left points past right, so `<` is false → stop ✓. With `!=` they'd pass through each other and re-swap (1,4) again.
</details>

<details markdown="1"><summary>C8 — Ownership chain</summary>

```cpp
int* makeFilled(int n, int start) {
    int* a = new int[n];
    for (int i = 0; i < n; i = i + 1) a[i] = start + i;
    return a;                       // HANDOFF → caller owns
}

// Contract: consumes the caller's block and returns a REPLACEMENT handle.
// After the call, base's old block is FREED — the returned pointer is the only owner.
int* append(int* base, int& baseN, int value) {
    int* grown = new int[baseN + 1];
    for (int i = 0; i < baseN; i = i + 1) grown[i] = base[i];
    grown[baseN] = value;
    baseN = baseN + 1;
    delete[] base;                  // the transfer: old owner consumes itself
    return grown;
}

int main() {
    int n = 3;
    int* a = makeFilled(n, 10);     // main owns: 10 11 12
    a = append(a, n, 99);           // hand UP and catch the replacement — 10 11 12 99
    // ... use a ...
    delete[] a;                     // the single surviving owner releases
    a = nullptr;
}
```
Ownership diagram per handoff: `makeFilled` → arrow travels up, one owner. `append` → receives ownership *in*, allocates, releases the consumed block, hands the replacement up — at every instant exactly one arrow owns each live block. The dangerous alternative (append deletes nothing, caller must remember the old handle changed) is how leaks are born; "consume and replace" keeps it impossible to hold a stale arrow. (`std::vector::push_back` does this dance so you never see it.)
</details>

<details markdown="1"><summary>C9 — Const propagation</summary>

```cpp
int countAbove(const int* data, int n, int t) {
    int c = 0;
    for (int i = 0; i < n; i = i + 1) if (data[i] > t) c += 1;
    return c;
}
const int* firstAbove(const int* data, int n, const int* limit) {
    if (limit == nullptr) return nullptr;
    for (int i = 0; i < n; i = i + 1)
        if (data[i] > *limit) return &data[i];
    return nullptr;
}
```
The const in `const int* data` promises *this function* won't write through the handle. The return type `const int*` extends the same promise to the **caller**: "what I'm handing you is a window into data you must not modify (it may itself be const)." If it returned plain `int*`, the caller could `*result = 0` — punching a hole in someone else's const. **The const is contagious on purpose**: write-protection that survives the handoff. This is why [Unit 09's](../arrays/lesson-3-arrays-functions.md) array parameters were `const T arr[]` all along — same rule, pre-existing the vocabulary.
</details>

<details markdown="1"><summary>C10 — Family triage</summary>

(a) **invalid access** — `p[4]` on a 4-box block (indices 0–3): out of bounds *before* a correct delete; fix the index. (b) **leak** — handle discarded; catch and own, or don't allocate. (c) **double delete** — two owners; exactly one deletes, the other tames its arrow. (d) **clean** — the same-line idiom made the "just checking" honest (`p` is null, `if (p)` is false, no dereference). (e) **invalid access** — callee dereferences null; guard inside (`if (p == nullptr) return;`) or take a reference if "always exists" is the truth.
</details>
