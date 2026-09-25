---
title: "Lesson 2 — Searching: Linear, Binary, and the Sorted Precondition"
description: "Linear search in full, binary search with its sorted precondition, trace tables, implementations, and honest complexity intuition built from guessing games and counting."
---

# Lesson 2 — Searching

> [← Module home](index.md) · [← Lesson 1 — Recursion](lesson-1-recursion.md) · [Lesson 3 — Sorting →](lesson-3-sorting.md)

## In this lesson you will learn

- linear search — the always-works default, and its useful variants
- binary search — how halving beats scanning, and the **one precondition** it cannot survive without
- how to trace both by hand with lo/hi tables
- complexity intuition: counting steps, best/average/worst cases, and why "logarithmic" is the whole point

---

## 1. Linear search — the complete treatment

You met linear search in the arrays module. Here it is in full, because it is the baseline every other search must justify itself against.

**Concept.** Start at the front, examine every element in order, stop at the first match. If the end arrives first, the value isn't there.

**Pseudocode**

```text
function linearSearch(arr, n, x):
    for i from 0 to n-1:
        if arr[i] == x:
            return i          // found: report the position
    return -1                 // convention: -1 means "absent"
```

**C++ implementation**

```cpp
// linear.cpp — Programming Fundamentals Using C++
// Unit 10 · Lesson 2 · Linear search, complete
// Compile: g++ -std=c++17 -Wall -Wextra linear.cpp -o linear

#include <iostream>
using namespace std;

int linearSearch(const int a[], int n, int x) {
    for (int i = 0; i < n; i++) {
        if (a[i] == x) return i;
    }
    return -1;
}

int main() {
    int a[] = {42, 7, 19, 7, 3};
    cout << linearSearch(a, 5, 19) << "\n";  // 2
    cout << linearSearch(a, 5, 7)  << "\n";  // 1  (first of the two)
    cout << linearSearch(a, 5, 99) << "\n";  // -1
    return 0;
}
```

**Test cases** (keep this table — the lab reuses it):

| Case | Array | x | Expected |
| --- | --- | --- | --- |
| present, middle | `{42, 7, 19, 7, 3}` | 19 | 2 |
| duplicate | `{42, 7, 19, 7, 3}` | 7 | 1 (first) |
| absent | `{42, 7, 19, 7, 3}` | 99 | −1 |
| first element | `{5, 1}` | 5 | 0 |
| last element | `{5, 1}` | 1 | 1 |
| empty | `{}` | anything | −1 |

### The three useful variants

- **All matches** — don't return; record every `i` where `a[i] == x` (into an output array or by printing). The duplicate row above shows why: linear search's answer depends on a policy ("first match"), and other policies need other loops.
- **Count matches** — swap `return i` for `count++`; return the counter.
- **Last match** — keep searching after a hit; remember the last hit's index.

All three keep the same shape: one pass, one comparison per element. Which is exactly the fact that complexity measures.

---

## 2. Complexity intuition — counting instead of vibes

"Complexity" sounds mathematical. At this level it is just **counting the steps an algorithm takes as the input grows**, and noticing the *shape* of that growth.

**Linear search's step count, for input size n:**

| Scenario | Comparisons |
| --- | --- |
| Best case (first element) | 1 |
| Average case (roughly) | n/2 |
| Worst case (absent or last) | n |

The worst case is what you promise users: **grows in step with n**. Double the data, double the worst-case work. We write that as **O(n)** — "order n" — read as "proportional to n." That is all the notation you need today: a *shape* of growth, not a stopwatch time.

**A worked feeling for O(n).** Searching 1,000 items: up to 1,000 comparisons. 1,000,000 items: up to 1,000,000. A million comparisons is still instant for a computer — but if your program searches once per user action, and your data grows a thousandfold, your *responsiveness* grows a thousandfold slower. Shape matters at scale, not at n = 5.

### The guessing game that motivates binary search

I pick a number from 1 to 100; you guess; I say "higher" or "lower." Scan 1, 2, 3, … and bad luck costs you up to 100 guesses. But guess **50** first: whatever my answer, **half the range dies**. Then guess the middle of what's left. Every guess halves. 100 → 50 → 25 → 12 → 6 → 3 → 1: **seven guesses, worst case, guaranteed.**

That is the entire idea of binary search: **each comparison eliminates half of what remains.** One million items → about 20 comparisons. One billion → about 30. The growth shape is **O(log n)** — logarithmic — and no cleverness in the linear scan can ever achieve it.

> **The one-line summary of this lesson:** linear search pays n; binary search pays log n — but binary search charges an entrance fee, and the next section is about the fee.

---

## 3. Binary search — and its non-negotiable precondition

**Concept.** On a **sorted** array, one comparison against the middle element tells you which half the target must be in (or that the middle *is* the target). Repeat on the surviving half.

**The precondition, stated as a rule:** binary search requires the data to be sorted before the first comparison happens. Not "mostly sorted." Not "sorted because it probably will be by the time we look." Sorted, ascending, for every adjacent pair — exactly the property the `isSorted` recursion checked in Lesson 1. On unsorted data binary search gives **wrong answers, silently** — it confidently eliminates the half that happens to contain your value. There is no error message. That silence is why the precondition is a favourite exam and interview question.

**Pseudocode**

```text
function binarySearch(arr, n, x):
    lo = 0, hi = n - 1
    while lo <= hi:
        mid = (lo + hi) / 2        // integer division
        if arr[mid] == x: return mid
        if arr[mid] < x:  lo = mid + 1   // target is in the right half
        else:             hi = mid - 1   // target is in the left half
    return -1
```

**C++ implementation**

```cpp
// binary.cpp — Programming Fundamentals Using C++
// Unit 10 · Lesson 2 · Binary search on a sorted array
// Compile: g++ -std=c++17 -Wall -Wextra binary.cpp -o binary

#include <iostream>
using namespace std;

int binarySearch(const int a[], int n, int x) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;   // same value as (lo+hi)/2, no overflow risk
        if (a[mid] == x) return mid;
        if (a[mid] < x)  lo = mid + 1;
        else             hi = mid - 1;
    }
    return -1;
}

int main() {
    int a[] = {3, 7, 11, 19, 23, 42, 57};   // sorted — the precondition
    cout << binarySearch(a, 7, 23) << "\n"; // 4
    cout << binarySearch(a, 7, 8)  << "\n"; // -1
    return 0;
}
```

> **Why `lo + (hi - lo) / 2`?** `(lo + hi) / 2` can overflow `int` for huge indices. At this course's scale it never will, but the safe form costs nothing and is the professional habit — a one-line note in your toolkit.

**Dry run — `binarySearch(a, 7, 23)` on `{3, 7, 11, 19, 23, 42, 57}`:**

| pass | lo | hi | mid | a[mid] | verdict |
| --- | --- | --- | --- | --- | --- |
| 1 | 0 | 6 | 3 | 19 | 19 < 23 → lo = 4 |
| 2 | 4 | 6 | 5 | 42 | 42 > 23 → hi = 4 |
| 3 | 4 | 4 | 4 | 23 | **found → return 4** |

**Test cases:**

| Case | Array (sorted!) | x | Expected |
| --- | --- | --- | --- |
| present, middle | `{3, 7, 11, 19, 23, 42, 57}` | 19 | 3 |
| present, first | same | 3 | 0 |
| present, last | same | 57 | 6 |
| absent (inside range) | same | 8 | −1 |
| absent (outside range) | same | 100 | −1 |
| one element, hit | `{5}` | 5 | 0 |
| one element, miss | `{5}` | 4 | −1 |
| **unsorted input** | `{9, 3, 7}` | 3 | *wrong or −1 — and that's the point* |

The last row is the exercise: run it, watch it answer −1 (or nonsense), and engrave the rule — **sort first, binary-search second**.

### Boundary care — where binary searches go wrong

The loop condition (`lo <= hi` vs `<`), the updates (`mid + 1`/`mid - 1` vs `mid`), and the empty-range start (`hi = n - 1` with `n = 0` gives `lo > hi` immediately — correct!) must all agree. Off-by-one here doesn't crash; it returns −1 for values that are present. The [trace pack](traces.md) makes you trace the boundaries by hand, and [debugging hunt D7](debugging.md) seeds exactly this class of bug.

### Recursive binary search (a moment of symmetry)

Binary search's structure — "check middle, recurse on one half" — is the recursion skeleton from Lesson 1:

```cpp
int binRec(const int a[], int lo, int hi, int x) {
    if (lo > hi) return -1;                 // base: empty range
    int mid = lo + (hi - lo) / 2;
    if (a[mid] == x) return mid;            // base: found
    if (a[mid] < x) return binRec(a, mid + 1, hi, x);  // shrink to right half
    return binRec(a, lo, mid - 1, x);                  // shrink to left half
}
```

Depth is about log₂ n — the halving bounds the stack. Same algorithm, two costumes; use whichever reads better in context.

---

## 4. Choosing a search — the honest table

| | Linear | Binary |
| --- | --- | --- |
| Precondition | none | **sorted** |
| Worst-case comparisons | n | ~log₂ n |
| Small n (< ~50) | fine | fine — but the sort costs more than it saves |
| Data changes often | fine | **re-sorting after each change eats the advantage** |
| Cost when data is unsorted | just search | sort (Lesson 3) + search |

The decision rule students should carry: **binary search earns its precondition**. If the data is sorted once and searched many times (a phone book, a marks sheet), binary wins enormously. If data arrives unsorted and is searched once, linear search *is* the efficient choice — sorting first is more work, not less. Searching is never free; the question is always *when* you pay.

---

## Check yourself

- Linear search on 8 elements, worst case: how many comparisons? Binary search on 8: how many? (8; 3 — 8→4→2→1)
- What does binary search do on unsorted data — crash, loop forever, or something worse? (something worse: returns wrong answers confidently)
- In the dry run, why does the final pass have `lo == hi == 4`? (a one-element range is a legal range)

## Where next

- [Lesson 3 — Sorting →](lesson-3-sorting.md): how data *becomes* sorted — the fee, paid honestly.
- [Trace pack](traces.md): T7–T11 are search traces.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
