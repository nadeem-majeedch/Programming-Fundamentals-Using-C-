---
title: "Algorithms Debugging — 10 Seeded Hunts"
description: "Ten buggy programs across recursion, searching, and sorting — each with a hint ladder and a separated diagnosis."
---

# Debugging — 10 seeded hunts

> [← Module home](index.md) · Each program compiles (or nearly) but misbehaves. Read the code, **predict the symptom**, form a hypothesis, *then* hunt. Hints escalate; the diagnosis is separated at the bottom of its hunt. The module's standing rule applies: trace before you trust.

**The hunts and their prey:** D1 base case · D2 unreachable base · D3 shift-loses-key · D4 loop-bound pairing · D5 binary update error · D6 wrong shrink direction · D7 binary boundary · D8 flag misuse · D9 comparison strictness · D10 the audit.

---

## D1 — The countdown that never lands

```cpp
int countdown(int n) {
    if (n == 0) return 0;
    return countdown(n - 1);
}

int main() {
    cout << countdown(-3) << "\n";   // expected: 0
    return 0;
}
```

The programmer expected 0. The program dies with a stack overflow. Why does `n == 0` never arrive, and what is the *general* rule this violates? (Write the rule as a sentence you could apply to any recursive function.)

<details markdown="1">
<summary>Diagnosis — after you've committed to an answer</summary>

The shrinkage is `n - 1` from a **negative** starting value: −3, −4, −5, … — the base case `n == 0` is *behind* the start, unreachable. The general rule: **the base case must lie on the path the shrinkage takes from every legal input.** Fixes: (a) precondition `n >= 0` documented and checked, or (b) base case `n <= 0` if the contract says negatives also terminate at 0. The bug class: a base case written for *friendly* input only.
</details>

---

## D2 — The skip that skips the door

```cpp
// intent: sum every second element: {1,2,3,4,5} -> 1+3+5 = 9
int everyOther(const int a[], int n, int i) {
    if (n == 1) return a[0];
    return a[i] + everyOther(a, n - 2, i);
}
```

`everyOther(a, 5, 0)` on `{1,2,3,4,5}` returns 9 sometimes... and reads garbage other times. Two distinct defects: the base case tests the wrong variable, and the shrinkage doesn't move `i`. Trace with n=5 and n=4 and name both.

<details markdown="1">
<summary>Diagnosis</summary>

Defect 1: the base case checks `n` but the function's real position is `i` — the recursion walks *i* through the array, so the door should be `if (i >= n) return 0;`. Defect 2: `i` never advances — every level reads `a[0]`. Correct version: `int eo(const int a[], int n, int i){ if (i >= n) return 0; return a[i] + eo(a, n, i + 2); }`. Bug class: **two moving parts, one updated** — when a recursion walks an index, the index is the state that must shrink.
</details>

---

## D3 — The insertion sort that loses a value

```cpp
void insertionSort(int a[], int n) {
    for (int i = 1; i < n; i++) {
        int j = i - 1;
        while (j >= 0 && a[j] > a[i]) {   // no key variable!
            a[j + 1] = a[j];
            j--;
        }
        a[j + 1] = a[i];                  // ...and this reads the wrong thing
    }
}
```

Sorting `{7, 3, 9, 3}` produces `3 7 3 3`? — run the trace by hand and find the exact statement where the value 7's slot gets clobbered. Then state the fix in four words.

<details markdown="1">
<summary>Diagnosis</summary>

Without `key`, the first shift overwrites `a[i]` — the very value being inserted. Tracing `{7,3,9,3}`: i=1, key missing, a[0]=7 > a[1]=3 → `a[1] = 7` destroys the 3 → array `7,7,9,3`; insert reads `a[1]` — now 7 — putting 7 back. The 3 is gone. Fix, four words: **save the key first** (`int key = a[i];` before the while; compare and insert with `key`). Symptom signature of this bug class: output has one value duplicated and one missing.
</details>

---

## D4 — The condition that reads the fence

```cpp
void insertionSort(int a[], int n) {
    for (int i = 1; i < n; i++) {
        int key = a[i];
        int j = i - 1;
        while (a[j] > key && j >= 0) {    // conditions swapped
            a[j + 1] = a[j];
            j--;
        }
        a[j + 1] = key;
    }
}
```

Most inputs sort fine. The crash (or garbage) happens on exactly one kind of input — which, and why? What does this teach about condition order?

<details markdown="1">
<summary>Diagnosis</summary>

`a[j]` is evaluated **before** `j >= 0`, so when the key is smaller than every element, `j` reaches −1 and `a[-1]` is read — out of bounds, undefined. The input that triggers it: any array whose smallest element is its first key or travels to the front (e.g. `{5, 1, 2, 3}`). Lesson: **guard conditions first** — the cheap, safe test before the data test. (C++'s `&&` guarantees left-to-right evaluation *only if you put the guard on the left*.)
</details>

---

## D5 — The binary search that walks in circles

```cpp
int binSearch(const int a[], int n, int x) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (a[mid] == x) return mid;
        if (a[mid] < x)  lo = mid;      // ← the bug
        else             hi = mid;
    }
    return -1;
}
```

On `{3, 7, 11, 19, 23}`, searching for 23 never returns. Trace (lo, hi, mid) for three iterations and describe the stall; then state the two-character fix and the invariant each update preserves.

<details markdown="1">
<summary>Diagnosis</summary>

Trace x=23: (0,4) mid=2, 11<23 → lo=2. (2,4) mid=3, 19<23 → lo=3. (3,4) mid=3, 19<23 → lo=3 — **stalled: lo never moves past mid, and mid is inside the range forever.** The updates must *exclude* the already-checked mid: `lo = mid + 1` and `hi = mid - 1`. Invariant: every update must shrink the range (hi−lo strictly decreases); `mid` is the element you've already compared, so the surviving half starts *beyond* it. Without exclusion, the range can stop shrinking → infinite loop.
</details>

---

## D6 — The recursion that grows

```cpp
// intent: digits(n) — how many digits?
int digits(int n) {
    if (n == 0) return 0;
    return 1 + digits(n * 10);   // ← the shrinkage
}
```

`digits(5)` should be 1. What actually happens, and what does the erroneous expression compute instead of shrinking? Give the fix and the one-sentence test that catches this class before running.

<details markdown="1">
<summary>Diagnosis</summary>

`n * 10` **grows** the argument — the recursion runs away from the base case until signed overflow (then undefined behaviour) or the stack dies. Shrinkage for digit problems is division: `n / 10` (with base `n < 10 → 1`, or keep base 0 and accept digits(0)=0 — but document it). The pre-run test: *state, in one sentence, why the argument moves toward the base case.* If you can't, it doesn't.
</details>

---

## D7 — The boundary that loses the first element

```cpp
int binSearch(const int a[], int n, int x) {
    int lo = 0, hi = n;          // ← starts wrong for this loop
    while (lo < hi) {
        int mid = lo + (hi - lo) / 2;
        if (a[mid] == x) return mid;
        if (a[mid] < x)  lo = mid + 1;
        else             hi = mid - 1;
    }
    return -1;
}
```

On `{3, 7, 11, 19}`, this finds 3... sometimes, and misses it other times. Trace x=3 carefully, name the inconsistency (the loop condition and the updates belong to *two different* standard formulations), and give one consistent version.

<details markdown="1">
<summary>Diagnosis</summary>

Trace x=3: (0,4) mid=2, 11>3 → hi=1. (0,1) mid=0, a[0]=3 → found. Now x=7: (0,4) mid=2, 11>7 → hi=1. (0,1) mid=0, 3<7 → lo=1. (1,1): loop condition `lo < hi` **false** → −1, but 7 is present. Mixed formulation: `hi = n` (half-open style) with `hi = mid - 1` updates (closed style) loses candidates. Consistent version A (closed): `hi = n - 1; while (lo <= hi); updates mid±1`. Consistent version B (half-open): `hi = n; while (lo < hi); updates lo = mid + 1, hi = mid`. Bug class: **formulation mixing** — pick one convention, apply it to condition *and* updates.
</details>

---

## D8 — The flag that fires too late

```cpp
void bubbleSort(int a[], int n) {
    bool swapped = true;
    int pass = 0;
    while (swapped) {
        swapped = false;
        for (int i = 0; i < n - 1 - pass; i++) {
            if (a[i] > a[i+1]) {
                int t = a[i]; a[i] = a[i+1]; a[i+1] = t;
                // missing line here
            }
        }
        pass++;
    }
}
```

On sorted input this version does **n−1 full passes** instead of one. Which line is missing, what does its absence cost exactly, and where must it sit?

<details markdown="1">
<summary>Diagnosis</summary>

`swapped = true;` inside the swap branch. Without it, `swapped` is false at every pass end, the while never exits early, and the early-exit optimization is dead — the algorithm degenerates to fixed (n−1) passes (still correct, still O(n²) always). It must sit inside the `if`, immediately after the swap, so that "this pass moved something" is recorded *per movement*. Cost on sorted input: n−1 passes × (n−1−pass) comparisons ≈ n²/2 comparisons for a job that costs n−1 with the flag.
</details>

---

## D9 — The sort that chews equals

```cpp
void insertionSort(int a[], int n) {
    for (int i = 1; i < n; i++) {
        int key = a[i];
        int j = i - 1;
        while (j >= 0 && a[j] >= key) {   // note: >=
            a[j + 1] = a[j];
            j--;
        }
        a[j + 1] = key;
    }
}
```

The output is still correctly sorted — so what's wrong? Construct the input where this version does strictly more work than the lesson's, and connect the observation to the stability idea from Exercise E29.

<details markdown="1">
<summary>Diagnosis</summary>

With `>=`, an element equal to the key is **shifted right** and the key lands *before* it — equal elements cross. Output stays sorted (values don't care), but (1) extra shifting on duplicate-heavy input: `{2,2,2,2,2}` shifts 10 times vs 0 with strict `>`; (2) **stability is lost**: records that compared equal come out in reversed original order. The lesson's strict `>` shifts only *strictly greater* elements — equals never cross. Symptom class: "correct output, wasted motion, broken equal-order" — the bugs that only a *work-counting* test catches.
</details>

---

## D10 — The audit: three bugs, one file

```cpp
// A lab submission. Find all three defects before reading the list.
void selectionSort(int a[], int n) {
    for (int start = 0; start <= n; start++) {          // line A
        int m = start;
        for (int i = start; i < n; i++) {               // line B
            if (a[i] < a[m]) m = i;
        }
        int t = a[start]; a[start] = a[m]; a[m] = t;    // line C
    }
}
```

<details markdown="1">
<summary>Diagnosis</summary>

**Line A:** `start <= n` runs one pass too many; on the final pass `start == n` and `m = n`, so line C reads `a[n]` — out of bounds. Must be `start < n - 1`. **Line B:** the inner scan starts at `start` instead of `start + 1` — harmless for correctness (comparing a[i] with itself changes nothing) but wasteful, and it *masks* nothing: it's the tell that the author copied the min-scan template without adapting the bound. **Line C:** no `if (m != start)` guard — self-swaps happen on nearly every pass of sorted input. Wasteful but correct; the guard is cheap professionalism. Verdict order: A is a crash bug, B is a waste bug, C is a hygiene bug — audit in that order.
</details>

---

## Fix-list recap

| Hunt | Bug class | Prevention rule |
| --- | --- | --- |
| D1 | base case off the shrink path | sentence-test the shrinkage |
| D2 | one of two moving parts updated | name the state that shrinks |
| D3 | shift destroys the key | save the key first |
| D4 | guard after the data test | conditions: guard first |
| D5 | update doesn't exclude mid | shrink or stall |
| D6 | grow instead of shrink | sentence-test the shrinkage |
| D7 | mixed loop formulations | one convention, fully applied |
| D8 | early-exit flag never set | set the flag inside the swap |
| D9 | `>=` in shifting loops | strict comparison, stable order |
| D10 | bound/guard hygiene | audit crashes → waste → hygiene |

## Where next

- [Challenges](challenges.md): fifteen problems to apply the repairs to.
- [Labs](labs.md): measure, don't guess.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
