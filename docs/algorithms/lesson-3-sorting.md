---
title: "Lesson 3 — Sorting: Bubble, Selection, Insertion"
description: "The three elementary sorts — concept, pseudocode, dry runs, C++ implementations, comparisons counting, when each wins, and the shared mistakes gallery."
---

# Lesson 3 — Sorting

> [← Module home](index.md) · [← Lesson 2 — Searching](lesson-2-searching.md)

## In this lesson you will learn

- three elementary sorting algorithms — **bubble**, **selection**, **insertion** — as three different answers to one question
- pseudocode, dry runs, and C++ implementations for each
- how to trace a sort by hand (the exam-proof skill)
- comparison counting and the O(n²) intuition
- which sort to pick, and the mistakes common to all three

All three algorithms answer the same question — *rearrange this array into ascending order* — with the same budget: compare two elements, swap or shift, repeat. They differ in **which two elements they compare** and **what they do about it**. Learn them as three personalities, not one blur.

A shared helper for this lesson and the [lab](labs.md):

```cpp
// swap helper — used by bubble and selection
void swapInts(int& a, int& b) {
    int t = a; a = b; b = t;
}
```

---

## 1. Bubble sort — big values float to the end

**Concept.** Walk the array comparing **neighbours**. Any pair out of order swaps, so after one full pass the largest value has bubbled to the last position. Repeat for the rest.

**Pseudocode**

```text
function bubbleSort(arr, n):
    for pass from 1 to n-1:
        for i from 0 to n-1-pass:        // the tail is already in place
            if arr[i] > arr[i+1]:
                swap(arr[i], arr[i+1])
```

**Dry run — one full pass on `{5, 1, 4, 2, 8}`** (the classic):

| compare | before | action | after |
| --- | --- | --- | --- |
| a₀,a₁ | 5,1 | swap | **1**,5,4,2,8 |
| a₁,a₂ | 5,4 | swap | 1,**4**,5,2,8 |
| a₂,a₃ | 5,2 | swap | 1,4,**2**,5,8 |
| a₃,a₄ | 5,8 | ok | 1,4,2,5,8 |

Pass 1 ends `1,4,2,5,8` — and notice **8** was placed, not 5: the last pass position always lands the region's maximum. Full sort: pass 2 on the first four compares 1,4 / 4,2 / 2,5 → one swap → `1,2,4,5,8`; pass 3 makes no swaps → the flag ends it early. **That is exactly why hand-tracing matters** — the table is the truth, the story in your head is not.

**C++ implementation**

```cpp
// bubble.cpp — Programming Fundamentals Using C++
// Unit 10 · Lesson 3 · Bubble sort
// Compile: g++ -std=c++17 -Wall -Wextra bubble.cpp -o bubble

#include <iostream>
using namespace std;

void bubbleSort(int a[], int n) {
    for (int pass = 1; pass <= n - 1; pass++) {
        bool swapped = false;                       // the early-exit flag
        for (int i = 0; i < n - pass; i++) {
            if (a[i] > a[i + 1]) {
                int t = a[i]; a[i] = a[i+1]; a[i+1] = t;
                swapped = true;
            }
        }
        if (!swapped) break;   // a clean pass: already sorted, stop early
    }
}

int main() {
    int a[] = {5, 1, 4, 2, 8};
    bubbleSort(a, 5);
    for (int i = 0; i < 5; i++) cout << a[i] << " ";
    cout << "\n";        // 1 2 4 5 8
    return 0;
}
```

**Explanation notes.** The `swapped` flag is the **early exit**: on already-sorted input one clean pass proves sortedness and stops — bubble's best case is O(n), the only one of the three that can notice. The inner bound `n - pass` skips the sorted tail.

**Complexity.** Worst case (reverse sorted): (n−1)+(n−2)+…+1 = **n(n−1)/2 ≈ O(n²)** comparisons and swaps. Best case with the flag: n−1 comparisons, zero swaps.

**Test cases:** `{5,1,4,2,8}` → `1 2 4 5 8` · `{1,2,3}` → unchanged, 1 pass · `{3,2,1}` → sorted, max passes · `{7,7,7}` → unchanged (note `>` not `>=`: equal neighbours don't swap) · single element → untouched.

---

## 2. Selection sort — pick the best, put it in place

**Concept.** Find the **minimum** of the unsorted region; swap it to the region's front; the sorted region grows by one. It is the arrays module' "index-tracking minimum" wearing a sorting costume — selection is that exact min-finding pass, repeated, with a shrinking boundary.

**Pseudocode**

```text
function selectionSort(arr, n):
    for start from 0 to n-2:
        m = index of minimum in arr[start..n-1]
        swap(arr[start], arr[m])
```

**Dry run — `{64, 25, 12, 22, 11}`:**

| start | unsorted region | min | swap | array after |
| --- | --- | --- | --- | --- |
| 0 | 64,25,12,22,11 | 11 (idx 4) | 64↔11 | 11,25,12,22,64 |
| 1 | 25,12,22,64 | 12 (idx 2) | 25↔12 | 11,12,25,22,64 |
| 2 | 25,22,64 | 22 (idx 3) | 25↔22 | 11,12,22,25,64 |
| 3 | 25,64 | 25 (idx 3) | self | 11,12,22,25,64 |

**C++ implementation**

```cpp
// select.cpp — Programming Fundamentals Using C++
// Unit 10 · Lesson 3 · Selection sort
// Compile: g++ -std=c++17 -Wall -Wextra select.cpp -o select

#include <iostream>
using namespace std;

void selectionSort(int a[], int n) {
    for (int start = 0; start < n - 1; start++) {
        int m = start;                          // assume the front is the min
        for (int i = start + 1; i < n; i++) {
            if (a[i] < a[m]) m = i;             // remember the INDEX, not the value
        }
        if (m != start) {                       // swap only when needed
            int t = a[start]; a[start] = a[m]; a[m] = t;
        }
    }
}

int main() {
    int a[] = {64, 25, 12, 22, 11};
    selectionSort(a, 5);
    for (int i = 0; i < 5; i++) cout << a[i] << " ";
    cout << "\n";    // 11 12 22 25 64
    return 0;
}
```

**Explanation notes.** Track the **index** of the minimum — swapping values directly loses the position. The `m != start` guard skips self-swaps. The min-finding inner loop uses strict `<`, so with duplicates it keeps the *first* minimum — relevant for stability discussions later; at this level, just be consistent.

**Complexity.** Comparisons are fixed: n(n−1)/2 regardless of input — **O(n²) always**. But swaps are at most **n−1** (one per pass, sometimes zero) — the fewest of the three. That trade defines selection's personality: minimal *movement*, maximal *comparison*. Ideal when writes are expensive; useless when data is nearly sorted (it still scans everything).

**Test cases:** `{64,25,12,22,11}` → `11 12 22 25 64` · `{2,1}` → one swap · `{1,2}` → guard skips the swap · `{5}` → untouched · duplicates `{3,1,3}` → `1 3 3`.

---

## 3. Insertion sort — the card-player's sort

**Concept.** Keep a sorted region at the left (initially just `a[0]`). Take the next element — **the key** — and shift bigger elements right until the key's home appears; insert. It is exactly how people sort a hand of cards: the hand is sorted, the new card slides into place.

**Pseudocode**

```text
function insertionSort(arr, n):
    for i from 1 to n-1:
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key:
            arr[j+1] = arr[j]        // shift right
            j = j - 1
        arr[j+1] = key               // drop the key into its gap
```

**Dry run — `{7, 3, 9, 3}`:**

| i | key | shifts | array after |
| --- | --- | --- | --- |
| 1 | 3 | 7→right | 3,7,9,3 |
| 2 | 9 | none (7 ≤ 9) | 3,7,9,3 |
| 3 | 3 | 9,7 right | 3,3,7,9 |

**C++ implementation**

```cpp
// insert.cpp — Programming Fundamentals Using C++
// Unit 10 · Lesson 3 · Insertion sort
// Compile: g++ -std=c++17 -Wall -Wextra insert.cpp -o insert

#include <iostream>
using namespace std;

void insertionSort(int a[], int n) {
    for (int i = 1; i < n; i++) {
        int key = a[i];
        int j = i - 1;
        while (j >= 0 && a[j] > key) {   // both conditions, in this order
            a[j + 1] = a[j];             // shift right
            j--;
        }
        a[j + 1] = key;                  // insert into the gap
    }
}

int main() {
    int a[] = {7, 3, 9, 3};
    insertionSort(a, 4);
    for (int i = 0; i < 4; i++) cout << a[i] << " ";
    cout << "\n";    // 3 3 7 9
    return 0;
}
```

**Explanation notes.** The shifting loop is where all the care lives. Condition order matters: `j >= 0` **first**, or `a[j]` reads `a[-1]` on the smallest key. The key is saved in `key` because shifting overwrites `a[i]`'s slot. The insert lands at `j+1` — the gap the last shift opened.

**Complexity.** Worst case (reverse sorted): each key shifts past everything before it — **O(n²)**. Best case (already sorted): each key fails the while immediately — **O(n)**. Nearly-sorted data: only small shifts — **close to O(n)**. This "excellent when almost sorted, fine when small" profile is insertion's whole identity — and the reason many real libraries' sort functions hand small slices to insertion sort internally.

**Test cases:** `{7,3,9,3}` → `3 3 7 9` · `{1,2,3,4}` → untouched, n−1 key checks · `{4,3,2,1}` → max shifts · `{2,2,2}` → unchanged (strict `>` never shifts equals) · `{5}` → untouched.

---

## 4. The three, compared — personalities and use cases

| | Bubble | Selection | Insertion |
| --- | --- | --- | --- |
| Core move | swap neighbours | swap min to front | shift right, insert key |
| Worst comparisons | O(n²) | O(n²), **always** | O(n²) |
| Best case | **O(n)** with early exit | O(n²) | **O(n)** |
| Swaps/moves | many (every inversion) | **fewest (≤ n−1)** | many shifts, but cheap ones |
| Nearly-sorted data | good with flag | poor | **best** |
| Signature virtue | simplest to explain | minimal writes | adaptive |
| Pick it when | teaching; tiny data | writes are expensive; tiny data | data is small or nearly sorted |

Three honest truths to carry forward:

- **All three are O(n²) in the worst case.** For 1,000,000 items that is ~500 billion comparisons — the [lab](labs.md) makes you watch the wall. The professional sorts (merge, quick, heap — and the standard library's `sort`) reach **O(n log n)**; the merge challenge you've already solved is that family's seed.
- **The O(n²) family is not obsolete.** For small n (dozens), constants and simplicity win, and real sorts switch to insertion sort for exactly those slices.
- **Tracing is the transferable skill.** Exams, interviews, and debugging all pay out on hand-traced tables, not on memorized code.

**A counting game for intuition (do it once, really):** compare-and-count both searches and sorts on the same paper. Linear search of 64 items: ≤ 64 comparisons. Binary search: ≤ 6. Bubble on 64: ~2,016 comparisons. Insertion on nearly-sorted 64: ~64. The same "count the comparisons" muscle that told you binary beats linear now tells you *which sort fits your data's shape*.

---

## 5. Common mistakes — shared by all three sorts

1. **Off-by-one bounds.** Bubble's inner loop must stop at `n - pass`; selection's inner loop starts at `start + 1`; insertion's outer loop starts at `i = 1` (a one-element prefix is already sorted). Each violation reads or writes a neighbour it shouldn't.
2. **Shifting overwrites the key.** In insertion, `a[i]` is destroyed by the first shift — save the `key` first. Symptom: the sorted output has one value repeated and one missing.
3. **Strict vs non-strict comparisons.** `>` vs `>=` decides whether equal elements swap/shift. Use strict comparisons for stability-friendly, wasted-motion-free sorts — and be consistent.
4. **Forgetting the loop condition pairing.** Insertion's `while (j >= 0 && a[j] > key)` — reversing the order reads `a[-1]`. Symptom: intermittent crashes on the smallest element.
5. **Testing only on the lesson's array.** Every algorithm here must survive: empty, single element, two elements, all equal, already sorted, reverse sorted, negatives, duplicates. The [trace pack](traces.md) and [challenges](challenges.md) keep the pressure on.

**The ritual, same as recursion's:** pseudocode → one hand trace → implementation → the edge-case list. Not because the code is hard, but because the *boundaries* are.

---

## Check yourself

- Which sort does the fewest writes? Which notices sorted input fastest? (selection; bubble with the flag)
- Why does insertion's outer loop start at `i = 1`? (a one-element prefix is trivially sorted)
- On `{2,1,3}`, which sort moves the fewest elements? Trace all three: bubble swaps once (2,1) then compares (1,3); selection finds min 1 and swaps once; insertion shifts 2 right to place the key 1 — one move, no swap. All three do comparable work here; "fewest moves" is insertion's edge, but on tiny inputs the difference is a coin toss — which is exactly why small arrays are all three algorithms' home turf.

## Where next

- [Labs](labs.md): the Algorithm Performance and Comparison Lab — count the comparisons yourself.
- [Exercises](exercises.md): Part C drills all three personalities.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
