---
title: "Arrays Labs"
description: "7 analysis labs — marks, sales, temperatures, inventory, survey, matrix, statistics — each with requirements, test data, expected behaviour, solution, explanation, and extensions."
---

# Arrays Labs (7)

> [← Module home](index.md) · Every lab: **function team** ([house rules](../functions/labs.md)): `const` readers, plain writers, narrator `main`. Test data is fixed — expected behaviour is a table you verify against, not a vibe. Solutions are separated inside each lab; attempt the team design first.

---

## Lab 1 — Student marks analyzer

**Scenario.** A class tutor needs a marks report: the syllabus's Unit 09 project in lab form — the [mini-project](miniproject.md) is its full version.

**Requirements.** Read up to 40 marks (validated 0–100; sentinel −1 ends input). Report: count, average (2 dp), highest + *who* (position), lowest + who, pass count (≥ 40), and the full list with pass/fail flags.

**Test data** (fixed): `55 38 91 40 62 -1`

**Expected behaviour:**

| field | value |
| --- | --- |
| count | 5 |
| average | 57.20 |
| highest | 91 (student 3) |
| lowest | 38 (student 2) |
| passed | 4 |

**Solution.**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;

constexpr int MAX_STUDENTS = 40;

int  readMarks(int marks[], int capacity);
void printReport(const int marks[], int n);
int  sumOf(const int marks[], int n);
int  indexMax(const int marks[], int n);
int  indexMin(const int marks[], int n);
int  countAtLeast(const int marks[], int n, int cut);

int main() {
    int marks[MAX_STUDENTS];
    int n = readMarks(marks, MAX_STUDENTS);
    if (n == 0) { cout << "No marks.\n"; return 0; }
    printReport(marks, n);
    return 0;
}

int readMarks(int marks[], int capacity) {
    int n = 0, value;
    cout << "Mark (0-100, -1 to end): ";
    cin >> value;
    while (value != -1 && n < capacity) {
        if (value >= 0 && value <= 100) { marks[n] = value; n += 1; }
        else cout << "0-100 only.\n";
        if (n < capacity) { cout << "Mark (-1 to end): "; cin >> value; }
        else break;
    }
    return n;
}

void printReport(const int marks[], int n) {
    cout << fixed << setprecision(2);
    cout << "Count: " << n << "  average: " << static_cast<double>(sumOf(marks, n)) / n << '\n';
    cout << "Highest: " << marks[indexMax(marks, n)]
         << " (student " << indexMax(marks, n) + 1 << ")\n";
    cout << "Lowest:  " << marks[indexMin(marks, n)]
         << " (student " << indexMin(marks, n) + 1 << ")\n";
    cout << "Passed (>=40): " << countAtLeast(marks, n, 40) << " of " << n << '\n';
    for (int i = 0; i < n; i = i + 1)
        cout << "Student " << setw(2) << i + 1 << ": " << setw(3) << marks[i]
             << (marks[i] >= 40 ? "  pass" : "  FAIL") << '\n';
}

int sumOf(const int m[], int n) { int t = 0; for (int i = 0; i < n; i++) t += m[i]; return t; }
int indexMax(const int m[], int n) { int b = 0; for (int i = 1; i < n; i++) if (m[i] > m[b]) b = i; return b; }
int indexMin(const int m[], int n) { int b = 0; for (int i = 1; i < n; i++) if (m[i] < m[b]) b = i; return b; }
int countAtLeast(const int m[], int n, int cut) { int c = 0; for (int i = 0; i < n; i++) if (m[i] >= cut) c++; return c; }
```

**Explanation.** Five `const` reading machines + one writer + one printer — the [Lesson 3 team](lesson-3-arrays-functions.md#4-a-function-team-on-real-data) verbatim. The champions return *indices*, which is what lets the report say *who*: `indexMax` answers "position", one dereference answers "value". The reader validates per value and *doesn't* count rejects toward n — the capacity check sits before every prompt so the array can never overflow. Note the sum cast inside the printer: 273/5 must be 57.2, not 57 — the [integer-division](../cpp-foundations/lesson-4-conversion.md) rule applied at the display layer.

**Extensions.** ⭐ Grade histogram (A/B/C/D/F tallies — [tally pass](lesson-2-classic-passes.md#4-frequency-counting--the-tally-array)). ⭐⭐ Median without sorting for odd n (the middle box — after *sorting*, which is next unit; here: count how many are ≤ each candidate). ⭐⭐⭐ Find *all* students within 5 marks of the average — two passes over stored data, the [Functions C1 wall](../functions/challenges.md#c1--the-statistics-suite) gone.

---

## Lab 2 — Sales analysis

**Scenario.** A shop logs units sold per day for a week (7 days, Mon–Sun). Report per-day and per-week figures, and find the best day *safely* — including a lookup feature driven by user input.

**Requirements.** Fixed array of 7 sales (read, validated ≥ 0). Report: total, daily average, best day (name + units), worst day. Then a **lookup loop**: read a day number (1–7) and print that day's units — until 0 quits. Out-of-range lookups must be rejected *without* indexing.

**Test data:** `12 8 0 15 9 22 5` (Mon..Sun)

**Expected behaviour:**

| field | value |
| --- | --- |
| total | 71 |
| average | 10.14 |
| best | Saturday, 22 |
| worst | Sunday, 5 |
| lookup 4 | Thursday: 15 |
| lookup 9 | rejected, no crash |
| lookup 0 | quits |

**Solution.**

```cpp
constexpr int DAYS = 7;

int readSales(int sales[], int days);
void printAnalysis(const int sales[], int days);
int indexMax(const int s[], int n);
int indexMin(const int s[], int n);
void lookupLoop(const int sales[], int days);
void printDayName(int i);     // 0-based index -> name

int main() {
    int sales[DAYS];
    readSales(sales, DAYS);
    printAnalysis(sales, DAYS);
    lookupLoop(sales, DAYS);
    return 0;
}

void lookupLoop(const int sales[], int days) {
    int d;
    cout << "Day to look up (1-7, 0 to quit): ";
    cin >> d;
    while (d != 0) {
        if (d >= 1 && d <= days) cout << "Day " << d << ": " << sales[d - 1] << '\n';
        else                     cout << "Days are 1-7.\n";   // NO indexing on the bad path
        cout << "Day (0 to quit): ";
        cin >> d;
    }
}
// readSales: validated fill (as Lab 1); printAnalysis: sum/average + champions + names.
```

**Explanation.** The lab's teaching point is the **lookup loop**: user input as index is the classic [bounds](lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does) hazard, and the fix is procedural — validate `1..7` *before* touching `sales[d-1]`. Note the conversion dance: humans count 1–7, boxes count 0–6; `d - 1` is the bridge, and it's the *validated* d. Day names come from a `printDayName` switch — an array of names arrives properly with the [Strings module](../strings/index.md), so the switch is the honest course-tool for today.

**Extensions.** ⭐ Flag days below half the average (`Below target`) — two passes over stored data. ⭐⭐ Week-over-week: read a *second* week and print per-day change (+/−) — two arrays, one pass. ⭐⭐⭐ Best *pair* of consecutive days (the [C14](challenges.md#c14--the-window-analyst) window with k = 2).

---

## Lab 3 — Temperature analysis

**Scenario.** A weather station logs one temperature per hour for 24 hours. Report daily statistics and detect a cold snap.

**Requirements.** Read 24 integers (−50..50, validated). Report: min, max, average (1 dp), the hours (0–23) at which min and max occurred (if ties, first), and the count of "freezing" readings (< 0). Then: *longest cold streak* — most consecutive hours below 0 (print start hour and length; 0 if never).

**Test data:** `5 6 4 -1 -2 -3 1 8 12 14 15 16 17 16 15 13 11 9 6 4 2 0 -1 -2`

**Expected behaviour:**

| field | value |
| --- | --- |
| min | −3 (hour 5) |
| max | 17 (hour 12) |
| average | 6.9 |
| freezing count | 5 (hours 3, 4, 5, 22, 23) |
| longest cold streak | hours 3–5, length 3 |

**Solution (the streak core).**

```cpp
// longest run of consecutive values < 0
int run = 0, bestRun = 0, bestStart = -1, start = -1;
for (int i = 0; i < 24; i = i + 1) {
    if (temp[i] < 0) {
        if (run == 0) start = i;      // streak begins
        run += 1;
        if (run > bestRun) { bestRun = run; bestStart = start; }
    } else {
        run = 0;                      // streak broken
    }
}
// report bestRun (0 = never) and bestStart
```

**Explanation.** Min/max/average/count are the standard passes; the **cold streak** is the new machine — the [run-tracking pattern](../repetition/challenges.md#c10--the-run-detector) (current run vs best run, two counters with different lifetimes) wearing temperatures. The trace discipline: `run` resets on any non-negative box; `bestRun` only grows; `bestStart` is captured the moment the best grows. Ties for min/max resolve to the first occurrence because champions update on *strict* comparisons — a policy, stated.

**Extensions.** ⭐ Print a 24-hour sparkline: one char per hour (`_` ≥ 0, `*` < 0). ⭐⭐ Diurnal range per half-day (hours 0–11 vs 12–23) — two half-grid passes. ⭐⭐⭐ Second-largest temperature ([C4](challenges.md#c4--the-second-champion)) and the hour it occurred.

---

## Lab 4 — Inventory analysis

**Scenario.** A warehouse tracks stock for 10 product codes (100–109). Report stock levels, flag reorder lines, and support a restock transaction loop.

**Requirements.** `int stock[10]` parallel to codes 100–109 (read initial levels, validated ≥ 0). Report: per-product line (code, level, `REORDER` if < 5), total items, and the code needing restock most urgently (lowest level; ties → lowest code). Then a **transaction loop**: read `code qty` — positive qty adds stock, negative removes (floor at 0, report attempted over-removal), code 0 quits, unknown codes rejected *without indexing*.

**Test data:** levels `12 3 45 0 8 3 60 7 2 20`

**Expected behaviour:**

| field | value |
| --- | --- |
| reorder flags | codes 101, 103, 105, 108 |
| total items | 160 |
| most urgent | code 103 (0) |
| transaction 101 +10 | level 13 |
| transaction 103 −5 | rejected: only 0 in stock |
| transaction 999 +4 | rejected: unknown code |

**Solution (the index-bridge core).**

```cpp
// code 100..109  ->  box index 0..9
int idx = code - 100;
if (idx >= 0 && idx < 10) { /* safe to use stock[idx] */ }
else cout << "Unknown code\n";
```

**Explanation.** The lab formalizes **code-to-index bridging**: when data *is* an index in disguise, the bridge (`code - 100`) plus a range guard is the whole safety story — the [tally](lesson-2-classic-passes.md#4-frequency-counting--the-tally-array) mechanic with transactions. The over-removal floor (`level = max(0, level + qty)`-shaped decision) is a business rule living in the transaction machine, not the reader. "Most urgent" is `indexMin` over the levels with the tie policy (first wins → lowest code, because the array is code-ordered).

**Extensions.** ⭐ Restock suggestion: print order quantities to bring every flagged product to 10. ⭐⭐ Two warehouses: parallel arrays, consolidated report — function signatures unchanged, `main` grows (the [stateless test](../functions/labs.md#lab-8--the-bank-at-the-desk)). ⭐⭐⭐ Value the inventory: read a price per code and report total stock value — three parallel arrays, one pass.

---

## Lab 5 — Survey response analysis

**Scenario.** 10 students answer a 5-question survey; each answer is 1–5 (with 0 = skipped). Report per-question tallies and the overall skip rate.

**Requirements.** Read 10×5 answers into `int answers[10][5]` (validated 0–5). Report per question: tally of 1–5 and skip count; the mode per question (ties → lowest option); overall: total skips and skip percentage. Then print a per-student completion list (`Student 4: 3/5`).

**Test data** (10 rows, one per student): `1 3 2 4 5 / 0 3 2 4 5 / 1 0 2 4 5 / 1 3 0 4 0 / 5 3 2 4 5 / 1 3 2 0 5 / 1 3 2 4 5 / 2 3 3 4 5 / 1 3 2 4 5 / 1 3 2 4 5`

**Expected behaviour (for the 10 rows):**

| field | value |
| --- | --- |
| Q1 tally (1..5) | 6, 1, 0, 0, 1 · skips 2 |
| Q2 mode | 3 (9 votes) |
| Q4 skips | 1 |
| total skips | 6 |
| skip rate | 12.0% |
| Student 4 | 3/5 |

**Solution (per-question tally core).**

```cpp
int tally[6] = {0};                       // index = answer (0 = skip)
for (int r = 0; r < students; r = r + 1) {
    int a = answers[r][q];                // freeze question q (outer loop over q)
    if (a >= 0 && a <= 5) tally[a] += 1;  // data-as-index, guarded
}
// mode: champion over tally[1..5]; skips = tally[0]
```

**Explanation.** The 2D array organizes the data; the analysis is still 1D passes — **freeze one dimension, walk the other** ([Lesson 4 §3](lesson-4-matrices.md#3-row-and-column-operations)): outer loop over questions, inner over students, `tally` reset per question (the [M2](lesson-4-matrices.md#6-the-2d-errors-gallery) reset trap is *the* bug this lab catches). Data-as-index with 0 = skip makes `tally[0]` the skip counter for free — the category is just another index. Completion per student is the mirrored pass (freeze r, walk c).

**Extensions.** ⭐ Star-bar per option per question (`#####: 5`) — printer over the tally. ⭐⭐ Questions ranked by skip rate — sort is next unit; here: find max/min skip counts and print their question numbers ([champion over question totals](lesson-2-classic-passes.md#2-minimum-and-maximum--the-champion-with-an-address)). ⭐⭐⭐ Agreement score: for each pair of questions, count students who answered both identically — a 5×5 co-occurrence matrix (the tally idea squared).

---

## Lab 6 — Matrix calculator

**Scenario.** A 3×3 matrix workbench: enter two matrices, compute sums, transposes, diagonal facts, and (the summit) the product.

**Requirements.** Read two 3×3 integer matrices (row by row, validated). Menu: 1 sum, 2 difference, 3 transpose of A, 4 main-diagonal sums of A and B, 5 product A×B, 0 quit. All operations as functions against `constexpr int N = 3`; after each operation print the result matrix with aligned columns.

**Test data:** A = `{ {1,2,3},{4,5,6},{7,8,9}}`, B = `{ {9,8,7},{6,5,4},{3,2,1}}`

**Expected behaviour:**

| operation | result |
| --- | --- |
| A + B | all boxes 10 |
| A − B | `{-8,-6,-4},{-2,0,2},{4,6,8}` |
| Aᵀ | `{ {1,4,7},{2,5,8},{3,6,9}}` |
| diag sums | A: 15, B: 15 |
| A×B | `{ {30,24,18},{84,69,54},{138,114,90}}` |

**Solution (product core).**

```cpp
void multiply(const int a[][N], const int b[][N], int prod[][N]) {
    for (int r = 0; r < N; r = r + 1)
        for (int c = 0; c < N; c = c + 1) {
            prod[r][c] = 0;                        // per-box accumulator
            for (int k = 0; k < N; k = k + 1)
                prod[r][c] += a[r][k] * b[k][c];
        }
}
// sumOf, subtract, transpose, diagonalSum: from Lesson 4 §4 / [S30-S32](exercises.md#s30--add-and-transpose)
```

**Explanation.** Every operation is a [Lesson 4](lesson-4-matrices.md) translation, and the lab's discipline is the **2D parameter rule**: `constexpr int N = 3` at file scope, every function signed `(...[][N], ...)` — the column count is law. A×B verifies by hand first (prod[0][0] = 1×9+2×6+3×3 = 30 ✓) — the [C10 prover](challenges.md#c10--the-multiplication-prover) habit. The per-box reset before the k-loop is the third accumulator-in-a-nest of the course; forgetting it is the lab's seeded-bug classic. Reading is a nested fill (row by row), printing a nested walk with `setw` — the grid pair from [iteration D11](../repetition/debugging.md#d11--the-flat-grid), now with real data.

**Extensions.** ⭐ Scalar multiply (k read). ⭐⭐ Symmetry and diagonal-matrix checks on A ([C11](challenges.md#c11--the-diagonal-inspector)). ⭐⭐⭐ Power: A² = A×A, then A³ — and verify A² × A == A³ (multiplication *associativity*, one more correctness check for free).

---

## Lab 7 — Simple statistics calculator

**Scenario.** A statistics bench: any dataset in, the full classic report out. This is the convergence lab — every pass from [Lesson 2](lesson-2-classic-passes.md) in one program.

**Requirements.** Read up to 100 values (validated; sentinel −1). Report: n, min, max, range, sum, mean (2 dp), the count above mean, and a 10-band histogram (like [C7](challenges.md#c7--the-histogram), bands of the data's own range: `band = (v - min) * 10 / (range + 1)` — derive and defend this formula). Guard every division.

**Test data:** `12 5 8 20 3 15 8 12 -1`

**Expected behaviour:**

| field | value |
| --- | --- |
| n, min, max, range | 8, 3, 20, 17 |
| sum, mean | 83, 10.38 |
| above mean | 3 (12, 20, 15) |
| histogram | band 0:1, band 1:1, band 2:2, band 3:0, band 4:0, band 5:2, band 6:1, band 7:0, band 8:0, band 9:1 |

**Solution (band formula core).**

```cpp
// after computing min, max, range = max - min:
int band = (v - min) * 10 / (range + 1);    // 0..9, never 10 (the +1)
hist[band] += 1;
```

**Explanation.** The band formula is the lab's intellectual core: `(v - min)` shifts the data's floor to 0; `* 10 / (range + 1)` squeezes it into exactly 10 bands, and the `+1` guarantees `v == max` lands in band 9, never 10 — work it for min=3, max=20: v=20 → 17×10/18 = 9 ✓. Every guard from the unit appears: n ≥ 1 before mean, range ≥ 0 always (max ≥ min by construction), data-as-index validated by the formula's own construction (but keep the assert-style comment). The histogram is the [tally](lesson-2-classic-passes.md#4-frequency-counting--the-tally-array) over *derived* indices — the same trick as [C7](challenges.md#c7--the-histogram), generalized to any range.

**Extensions.** ⭐ Print the histogram with `setw`-aligned labels and star bars. ⭐⭐ Median without sorting for odd n: the box at position n/2 *of the sorted data* — approximate honestly here by counting how many values are ≤ each candidate (or descope with a comment naming sorting). ⭐⭐⭐ Standard deviation via the two-pass formula: mean first, then the sum of squared differences — the accumulator idiom over a *derived* series, and the naturalpreview of [Stage D](../syllabus.md#stage-d-algorithms-and-data-units-10-12)'s statistical work.

---

## After the labs

Seven datasets, one toolkit: draw the boxes, freeze-or-walk, guard every index, `const` the readers. The [mini-project](miniproject.md) now assembles the full marks-analyzer with a menu, persistence of your choice, and a write-up — the Unit 09 capstone the syllabus promised.
