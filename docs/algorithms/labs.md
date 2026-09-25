---
title: "Labs — The Algorithm Performance and Comparison Lab"
description: "Sort the same data with bubble, selection, and insertion; count comparisons and moves; time what counting predicts. Plus the Project 2 brief."
---

# The Algorithm Performance and Comparison Lab

> [← Module home](index.md) · One lab, three algorithms, one question: *does the counting actually predict the running time?*

## ⚠ Lab safety

None of the algorithms here is dangerous — but **the lab's conclusions are only as honest as its instrumentation**. Counters must count real comparisons (not loop trips), copies must be made before every run (a sort destroys its input), and timing runs must use the **same build flags** as your other experiments. Fudged instrumentation produces confident nonsense.

---

## Scenario

Your study group argues about sorts: "bubble is slowest," "selection does the least work," "insertion wins on nearly-sorted data." Everyone is partly right — for particular inputs. The lab settles it with **numbers**: run all three elementary sorts on the *same* data, count the work, time the runs, and compare the measurements against the O(n²)/O(n) story from Lesson 3.

## Requirements

- R1 — One program containing all three sorts from Lesson 3, each instrumented with two counters passed by reference: `long long& comparisons` and `long long& moves` (a *move* is a swap counting as 3 moves, or a shift counting as 1 — pick one convention, document it, keep it).
- R2 — Four input generators, each filling an array of size n: **sorted**, **reverse-sorted**, **random** (values 1..10 000; same seed every run for reproducibility), **nearly-sorted** (sorted, then exactly 10 random adjacent swaps).
- R3 — For every (algorithm × input-shape) pair: copy a fresh input, run, record comparisons, moves, and wall-clock time.
- R4 — Sizes: start at n = 200 for correctness testing; for the timing table use n = 2 000, 5 000, 10 000, 20 000 (drop algorithms whose time exceeds your patience — and *record that you dropped them and why*: that is data too).
- R5 — Output: one results table per input shape, plus a short written comparison of measured reality against the complexity predictions.

## The predictions you are testing

| Algorithm | Random data | Sorted data | Reverse data |
| --- | --- | --- | --- |
| Bubble (flag) | ~n²/2 cmp | ~n cmp | ~n²/2 cmp |
| Selection | ~n²/2 cmp — **order-blind** | ~n²/2 cmp | ~n²/2 cmp |
| Insertion | ~n²/4 cmp avg | ~n cmp | ~n²/2 cmp |

Before running, write your predicted ordering (fastest→slowest) for each input shape. After running, mark where reality disagreed. Disagreements are findings, not failures.

## Test data & correctness gate

Before any timing, verify **correctness** on small arrays (n=10, all four shapes × all three algorithms, verified against a hand-sorted copy or your E30 harness). Timing unverified code measures your bugs.

## Student tasks

1. Implement, instrument, and verify (the gate above).
2. Produce the n=200 correctness table.
3. Run the timing matrix (R3–R4) and fill the tables.
4. Answer, with numbers from your tables: (a) Is selection really order-blind? (b) How much does insertion beat bubble on nearly-sorted data, and does the ratio stay stable as n grows? (c) Does doubling n roughly ×4 the O(n²) times? (d) At which size did you personally stop being willing to wait for bubble?
5. Write the ~10-line conclusion: which sort would you ship for a 10 000-student marks sheet, and why — citing your table.

## Sample expected results (shape, not gospel — your machine's numbers will differ)

For random n = 10 000, counting convention "swap = 3 moves":

| Algorithm | comparisons | moves | seconds (typical laptop, -O2) |
| --- | --- | --- | --- |
| Bubble | ~50 000 000 | ~75 000 000 | ~0.15–0.4 |
| Selection | ~50 000 000 | ~30 000 | ~0.05–0.12 |
| Insertion | ~25 000 000 | ~25 000 000 | ~0.08–0.2 |

Reading the table: bubble and selection do the *same* comparison count, yet selection finishes ~3× faster — fewer moves. Insertion does *half* the comparisons of either on random data. All three are the same O(n²) family; the constants differ — and at n = 100 000 all three become minutes. That last observation is the bridge to O(n log n) sorts (challenge C14).

## Solution — the instrumentation skeleton

```cpp
// perflab.cpp — Programming Fundamentals Using C++
// Unit 10 · Lab · Algorithm Performance and Comparison
// Compile: g++ -std=c++17 -O2 -Wall -Wextra perflab.cpp -o perflab

#include <iostream>
#include <cstdlib>    // rand, srand
using namespace std;

typedef long long ll;

void bubbleSort(int a[], int n, ll& cmp, ll& mov) {
    for (int pass = 1; pass <= n - 1; pass++) {
        bool swapped = false;
        for (int i = 0; i < n - pass; i++) {
            cmp++;
            if (a[i] > a[i + 1]) {
                int t = a[i]; a[i] = a[i+1]; a[i+1] = t;
                mov += 3;              // convention: swap = 3 moves
                swapped = true;
            }
        }
        if (!swapped) break;
    }
}

void selectionSort(int a[], int n, ll& cmp, ll& mov) {
    for (int start = 0; start < n - 1; start++) {
        int m = start;
        for (int i = start + 1; i < n; i++) {
            cmp++;
            if (a[i] < a[m]) m = i;
        }
        if (m != start) {
            int t = a[start]; a[start] = a[m]; a[m] = t;
            mov += 3;
        }
    }
}

void insertionSort(int a[], int n, ll& cmp, ll& mov) {
    for (int i = 1; i < n; i++) {
        int key = a[i];
        int j = i - 1;
        while (j >= 0) {
            cmp++;
            if (a[j] > key) { a[j + 1] = a[j]; mov++; j--; }
            else break;
        }
        a[j + 1] = key;
        mov++;                          // the final placement counts as a move
    }
}

// input generators -------------------------------------------------
void genSorted(int a[], int n)        { for (int i = 0; i < n; i++) a[i] = i; }
void genReverse(int a[], int n)       { for (int i = 0; i < n; i++) a[i] = n - i; }
void genRandom(int a[], int n)        { srand(42); for (int i = 0; i < n; i++) a[i] = rand() % 10000; }
void genNearly(int a[], int n) {
    genSorted(a, n);
    srand(7);
    for (int k = 0; k < 10 && k < n - 1; k++) {   // exactly 10 adjacent swaps
        int i = rand() % (n - 1);
        int t = a[i]; a[i] = a[i+1]; a[i+1] = t;
    }
}// harness -----------------------------------------------------------
#include <ctime>   // clock, CLOCKS_PER_SEC

bool isSorted(const int a[], int n) {
    for (int i = 0; i + 1 < n; i++) if (a[i] > a[i+1]) return false;
    return true;
}

void runOne(const char* name, void (*sortFn)(int[], int, ll&, ll&),
            const int src[], int n) {
    int* work = new int[n];                 // fresh copy per run
    for (int i = 0; i < n; i++) work[i] = src[i];
    ll cmp = 0, mov = 0;
    clock_t t0 = clock();
    sortFn(work, n, cmp, mov);
    clock_t t1 = clock();
    double secs = double(t1 - t0) / CLOCKS_PER_SEC;
    cout << name << "\tcmp=" << cmp << "\tmov=" << mov
         << "\ttime=" << secs << "s";
    if (!isSorted(work, n)) cout << "  *** NOT SORTED — results void ***";
    cout << "\n";
    delete[] work;                          // paired with new[] — Unit 13's habit
}

int main() {
    const int N = 10000;
    int data[N];

    cout << "=== shape: random ===\n";
    genRandom(data, N);
    runOne("bubble   ", bubbleSort,    data, N);
    runOne("selection", selectionSort, data, N);
    runOne("insertion", insertionSort, data, N);

    cout << "=== shape: sorted ===\n";
    genSorted(data, N);
    runOne("bubble   ", bubbleSort,    data, N);
    runOne("selection", selectionSort, data, N);
    runOne("insertion", insertionSort, data, N);

    cout << "=== shape: reverse ===\n";
    genReverse(data, N);
    runOne("bubble   ", bubbleSort,    data, N);
    runOne("selection", selectionSort, data, N);
    runOne("insertion", insertionSort, data, N);

    cout << "=== shape: nearly-sorted ===\n";
    genNearly(data, N);
    runOne("bubble   ", bubbleSort,    data, N);
    runOne("selection", selectionSort, data, N);
    runOne("insertion", insertionSort, data, N);

    return 0;
}
```

## Explanation

- **Counters by reference** (`ll&`) accumulate across the recursion-free loops without globals — the Functions module's output-parameter pattern doing exactly what it was designed for.
- **The function pointer** (`void (*sortFn)(int[], int, ll&, ll&)`) is challenge C15's idea running the harness — one `runOne` serves all three algorithms, which is why the tables can't drift from each other.
- **Fresh copy per run** is mandatory: algorithm two would otherwise sort algorithm one's output, and the nearly-sorted row would silently become the sorted row. Every lab bug you will ever see in this genre is a missing copy.
- **The verification line inside `runOne`** makes a wrong sort void its own timing — correctness and measurement in one gate.
- **`clock()`** is coarse but adequate here (seconds-scale runs); the honest caveat — wall-clock includes cache effects and machine noise — belongs in your write-up's limitations line.

## Extensions

- ⭐ Add the **binary-search-vs-linear-search** timer to the same harness: build a sorted array of n = 100 000, perform 10 000 searches with each algorithm, and report total comparisons — the Lesson 2 story in lab numbers.
- ⭐ Add **merge sort** (C14) to the matrix and find the n at which it beats insertion sort on random data.
- ⭐ Replace `clock()` with `<chrono>`'s `steady_clock` and explain (two sentences) why `steady_clock` is the right clock for interval measurement.
- ⭐⭐ Plot your results (any tool) — x-axis n, y-axis time, one curve per algorithm. The *shape* of the curves is the O(n²) story made visible.

---

# 🏁 Project 2 — Student Records Manager (brief)

**Week 10's milestone project** — the menu-driven records manager the syllabus promises. You own every piece: records (Unit 14's structs), files (Unit 12), search and sort (this unit), functions and validation (Units 7–8).

**What you build.** A program that manages a class record file (`students.txt`, format: `rollNo;name;marks1;marks2;marks3` per line — your Unit 12 format contract survives). Menu:

1. **Add** a student (validate: unique roll no, marks 0–100; refuse silently-corrupting input)
2. **List** all students (aligned columns; derived average and grade computed, never stored)
3. **Find** by roll no — **binary search**, after maintaining the file (and memory array) in roll-no order
4. **Sort** by name (A→Z) or by average (high→low) — your C13/C15 machinery
5. **Report** — class average, highest, lowest, per-grade counts
6. **Save & exit** (rewrite the file; the format contract is unchanged)

**Non-negotiables:** arrays-of-structs for storage; every menu action is a function taking the record array and count (no globals); search requires the sorted precondition — *enforce* it (sort on load/add, or verify and refuse); the file format survives every refactor.

**Deliverables:** the program; a test table (add → find → sort → report → exit → relaunch → find again — persistence proven); a one-page design note: your array capacity strategy, your search/sort choices, and one thing the pointers unit would let you do better (the honest answer: dynamic growth — the Unit 13 Quiz Runner already showed you how).

**Grading** follows [docs/grading.md](../grading.md#project-rubrics) — Project 2's rubric row.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
