---
title: "Arrays Exercises"
description: "32 progressive exercises — boxes and bounds, the classic passes, arrays with functions, and matrices. Solutions separated at the end."
---

# Arrays Exercises (32)

> [← Module home](index.md) · ★ = first pass · ★★ = needs the passes · ★★★ = combines ideas

**How to use this page.** Attempt 15 minutes before opening any [solution](#solutions-s1--s32). **Draw the boxes first** — indices above, values below — then code. Solutions S17+ are function teams; compare signatures, not just bodies.

---

## Part A — Boxes, indexing, traversal (★, E1–E8)

**E1.** Declare an array of 6 integers, initialize it to `{4, 8, 15, 16, 23, 42}` with an initializer list, and print the third and last boxes. State both indices *before* coding.

**E2.** Draw the boxes for `int a[5] = {2};` — what does each box hold? Then the same for `int b[5];` (local, uninitialized). What may you legitimately say about `b`'s contents?

**E3.** Write the traversal that prints an array's values on one line, space-separated, with a newline only at the end. Then the backward traversal printing the same values in reverse.

**E4.** Read `n` (validated 1–20) and `n` values into an array; print them back with their positions: `box 0: 72` per line. Then print only the odd-*positioned* boxes (indices 1, 3, ...).

**E5.** Given `int a[8] = {5, 3, 8, 1, 9, 2, 7, 4};` — without running code, write the values of `a[0]`, `a[3]`, `a[7]`, `a[8]` (mark the last one's verdict), and `a[a[1]]`.

**E6.** Update pass: read `n` values, then add 5 to *every* box (in place), then print. Then a second variant: double only the boxes whose current value is even.

**E7.** Bounds audit — for each, say whether it compiles, and what may happen at run time:
(a) `int a[4]; std::cout << a[4];`
(b) `int a[4]; std::cin >> a[3];`
(c) `int a[4]; int i = 2; a[i + 1] = 0;`
(d) `int a[4]; a[-1] = 0;`

**E8.** Read values until sentinel −1 into an array of capacity 10, printing `Array full` if a 11th value (before the −1) is attempted. Print how many landed. Then state which gallery bug the capacity check prevents.

---

## Part B — The classic passes (★★, E9–E16)

**E9.** Write `linearSearch` (from [Lesson 2 §1](lesson-2-classic-passes.md#1-linear-search--the-find-machine)) and a driver that searches `{4, 8, 15, 16, 23, 42}` for 15, for 42, and for 7 — three calls, expected results written first.

**E10.** Count-the-matches variant: count how many boxes equal a target. Trace on `{3, 7, 3, 9, 3}` for target 3.

**E11.** Write `indexMax` and `indexMin` ([Lesson 2 §2](lesson-2-classic-passes.md#2-minimum-and-maximum--the-champion-with-an-address)) and use them to print the *values* of the largest and smallest boxes of `{72, 85, 91, 67, 88}`.

**E12.** Sum and average of `{72, 85, 91, 67, 88}` — write the expected sum by hand first, then verify. State the division fix that makes the average 80.6 instead of 80.

**E13.** Frequency: 12 answers each 1–5 arrive in an array; print a tally per option and name the mode. Trace the tally array for `{1, 3, 3, 5, 2, 3, 4, 1, 3, 5, 3, 2}` — mode 3 with 5 votes.

**E14.** Copy `{1, 2, 3, 4, 5}` into a second array with the element loop; prove the copy is independent by changing `copy1[0]` and reprinting both.

**E15.** Write `double averageOf(const int a[], int n)` and `int countAtLeast(const int a[], int n, int cut)`. Then: how many of `{72, 85, 91, 67, 88}` are at least the class average? (Two passes over stored data — the [Functions C1 wall](../functions/challenges.md#c1--the-statistics-suite) falling.)

**E16.** Merge-two-counters: one pass that computes the sum of the even boxes and the sum of the odd boxes of `{1..10}`. (Expected: 30 and 25 — verify by hand.)

---

## Part C — Arrays and functions (★★, E17–E24)

**E17.** Sign and write `void fillWithSquares(int a[], int n)` (box i gets i²) and a driver printing the first 6 squares. What is `a[0]`, and why does the identity start there?

**E18.** The handle experiment: write `void tryZero(int data[])` that sets `data[0]` to 0, and a `main` that proves the *caller's* array changed. One sentence: what actually got passed?

**E19.** Add `const` where it belongs — sign these three correctly and justify each:
(a) a function printing all boxes; (b) a function filling random-ish test values; (c) a function counting boxes equal to x.

**E20.** Write `int readData(int data[], int capacity)` reading until sentinel −1 or capacity; return the logical size. Then `printMarks(const int a[], int n)` printing `n` boxes. Wire both in a `main` that reads, prints, and reports the count.

**E21.** Trace the boxes for:

```cpp
void twist(int a[], int n) {
    for (int i = 0; i < n; i = i + 1) a[i] = a[i] * 2;
}
int main() {
    int v[3] = {1, 2, 3};
    twist(v, 3);
    std::cout << v[0] << v[1] << v[2] << '\n';
    return 0;
}
```

**E22.** A teammate writes `int sumOf(const int a[], int n)` but *inside* uses `sizeof(a) / sizeof(a[0])` instead of `n`. Explain precisely why this is wrong inside a function (what does `sizeof(a)` return there?), and test their version against yours on a 3-box and a 100-box array.

**E23.** Write `void minMax(const int a[], int n, int& lo, int& hi)` — one pass, two reference outputs ([Functions minMax](../functions/lesson-3-references-testing.md#2-reference-parameters--the-write-back-wire) over an array). Contract for n = 0?

**E24.** Function team plan (signatures only): a program reads up to 30 temperatures, then reports count, average, hottest index, coldest index, and how many were above average. Write the prototype block in house order and mark each function const/plain and why.

---

## Part D — Matrices (★★–★★★, E25–E32)

**E25.** Declare `int g[2][3] = { {1,2,3},{4,5,6}};` and print it as a grid. Then print `g[1][0]` and `g[0][2]` — state both coordinates in row, column order *before* running.

**E26.** Read a 3×3 grid from input row by row, then print it with column headers. Which loop is outer, and why?

**E27.** Row sums and column sums of `{ {1,2,3},{4,5,6},{7,8,9}}` — compute all six by hand first, then verify. (Rows: 6, 15, 24. Columns: 12, 15, 18.)

**E28.** The whole-grid pass: total of all boxes, plus the box count. Then the max of all boxes *and its coordinates* (two answers — which loop structure finds coordinates naturally?).

**E29.** Row and column reports: given a 4×3 marks grid (4 students, 3 subjects), print each student's total and each subject's average. Which accumulator resets where?

**E30.** Write `void addMatrices(const int a[][3], const int b[][3], int sum[][3], int rows)` — box-by-box sum. Then transpose: `void transpose(const int a[][3], int t[][3], int rows)` with *asymmetric* test data; explain why symmetric data would have hidden a swapped-index bug ([gallery M1](lesson-4-matrices.md#6-the-2d-errors-gallery)).

**E31.** Diagonal pass: for a 4×4 grid, print the main diagonal (`r == c`) and the anti-diagonal (`r + c == 3`) — one traversal, two conditions.

**E32.** Matrix multiplication, by hand then in code, for `A = { {1,2},{3,4}}`, `B = { {5,6},{7,8}}`. Write the expected `prod` (first row: 19, 22) *before* coding the triple loop.

---

<a name="solutions-s1--s32"></a>
# Solutions (S1–S32)

<a name="s1--boxes-and-indices"></a>
## S1 — Boxes and indices

```cpp
int a[6] = {4, 8, 15, 16, 23, 42};
std::cout << a[2] << ' ' << a[5] << '\n';    // 15 and 42
```
Third box = index 2 (offset from the start); last = index `6 − 1 = 5` — the [last-index rule](lesson-1-basics.md#3-indexing--reading-and-updating).

<a name="s2--initializer-vs-garbage"></a>
## S2 — Initializer vs garbage

`a` = `{2, 0, 0, 0, 0}` — the listed value lands in box 0, *the rest become 0*. `b` = five boxes of **garbage**; the only honest statement is "their values are undefined until assigned" — reading them before writing is a bug ([gallery A6](lesson-1-basics.md#7-the-common-errors-gallery)).

<a name="s3--two-traversals"></a>
## S3 — Two traversals

```cpp
for (int i = 0; i < n; i = i + 1) std::cout << a[i] << ' ';
std::cout << '\n';
for (int i = n - 1; i >= 0; i = i - 1) std::cout << a[i] << ' ';
std::cout << '\n';
```
Backward bound: start at `n − 1` (the last valid index), continue while `i >= 0`. The `i < n` style has no backward twin — this is why both [traversal patterns](lesson-1-basics.md#4-traversal--the-visit-every-box-loop) belong in your hands.

<a name="s4--positions"></a>
## S4 — Positions

```cpp
for (int i = 0; i < n; i = i + 1)
    std::cout << "box " << i << ": " << a[i] << '\n';
for (int i = 1; i < n; i = i + 2)     // odd positions: start 1, step 2
    std::cout << a[i] << ' ';
```
The step-2 loop is [Iteration S2's](../repetition/exercises.md#s2--evens-two-ways) step idiom wearing an index.

<a name="s5--index-arithmetic"></a>
## S5 — Index arithmetic

`a[0]` = 5 · `a[3]` = 1 · `a[7]` = 4 · **`a[8]` = out of bounds — undefined, do not use** · `a[a[1]]` = `a[3]` = 1 (the index is itself a box's value — data-as-index, the [tally](lesson-2-classic-passes.md#4-frequency-counting--the-tally-array) mechanic in miniature).

<a name="s6--updates"></a>
## S6 — Updates

```cpp
for (int i = 0; i < n; i = i + 1) a[i] += 5;                    // everyone
for (int i = 0; i < n; i = i + 1)
    if (a[i] % 2 == 0) a[i] *= 2;                               // evens only
```
Both are in-place update passes — the box is read and written in the same statement.

<a name="s7--bounds-audit"></a>
## S7 — Bounds audit

(a) compiles; reads past the end — garbage or worse ([undefined](lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does)). (b) fine — `a[3]` is the *last* box of four. (c) fine — `i + 1` = 3, the last box. (d) compiles; writes *before* the array — the most dangerous class: corrupts whatever lives there.

<a name="s8--capacity-guard"></a>
## S8 — Capacity guard

```cpp
int data[10], n = 0, value;
std::cin >> value;
while (value != -1) {
    if (n >= 10) { std::cout << "Array full\n"; break; }
    data[n] = value; n += 1;
    std::cin >> value;
}
std::cout << n << " value(s)\n";
```
Prevents [gallery A7](lesson-1-basics.md#7-the-common-errors-gallery) — the sentinel read past capacity. Note the check sits *before* the write: the 11th value is rejected, never stored.

<a name="s9--search-driver"></a>
## S9 — Search driver

Expected first: 15 → index 2; 42 → index 5; 7 → −1. Then the three calls confirm. The [miss convention](lesson-2-classic-passes.md#1-linear-search--the-find-machine) (−1) is exercised by the third row — and every caller must check it.

<a name="s10--count-matches"></a>
## S10 — Count matches

```cpp
int count = 0;
for (int i = 0; i < n; i = i + 1)
    if (a[i] == target) count += 1;
```
Trace `{3,7,3,9,3}`, target 3 → count 3. No early return — a count is global ([Functions C3](../functions/challenges.md#c3--the-two-output-analyzer)'s stopping-power lesson).

<a name="s11--champions"></a>
## S11 — Champions

```cpp
int imax = indexMax(a, n);   // 2  → a[imax] = 91
int imin = indexMin(a, n);   // 3  → a[imin] = 67
```
Seed at box 0; challengers from box 1; the *index* is the answer, the value one dereference away.

<a name="s12--sum-average"></a>
## S12 — Sum, average

Hand sum: 72+85+91+67+88 = 403. Average = 403/5 = 80.6 — so `static_cast<double>(total) / n` is required; plain `total / n` would print 80 ([integer division](../cpp-foundations/lesson-4-conversion.md)).

<a name="s13--tally"></a>
## S13 — Tally

`tally[1..5]` ends as `{2, 2, 5, 1, 2}` — sums to 12 ✓ (sanity check: tallies must sum to n). Mode = 3 (5 votes) via `indexMax` over `tally[1..5]` — note box 0 excluded by construction (answers are 1-based).

<a name="s14--independent-copy"></a>
## S14 — Independent copy

```cpp
for (int i = 0; i < n; i = i + 1) copy1[i] = a[i];
copy1[0] = 99;
// print both: a = {1,2,3,4,5}, copy1 = {99,2,3,4,5}
```
Independence is the *proof* that the loop made new boxes — `=` wouldn't compile, and a "copy" sharing boxes would show 99 in both.

<a name="s15--above-average"></a>
## S15 — Above average

Average = 80.6 → `countAtLeast(a, 5, 81)` = 2 (85, 91)… but hold on: "at least the average" with the true 80.6 means 85 and 91 → **2**. The cast decision (compare against 80.6 directly vs a rounded int) *changes the answer* — document which policy you chose. The two passes over *stored* data are exactly what [Functions C1](../functions/challenges.md#c1--the-statistics-suite) couldn't do.

<a name="s16--even-odd-sums"></a>
## S16 — Even/odd sums

```cpp
int evenSum = 0, oddSum = 0;
for (int i = 0; i < n; i = i + 1) {
    if (a[i] % 2 == 0) evenSum += a[i];
    else               oddSum  += a[i];
}
```
{1..10}: even boxes (values) 2+4+6+8+10 = 30; odd 1+3+5+7+9 = 25. Two accumulators, one pass.

<a name="s17--squares"></a>
## S17 — Squares

```cpp
void fillWithSquares(int a[], int n) {
    for (int i = 0; i < n; i = i + 1) a[i] = i * i;
}
```
`a[0]` = 0 — zero squared; the identity of "start counting at 0" appearing in the *values*. Plain (non-const) parameter: the function is a *writer* ([Lesson 3 §2](lesson-3-arrays-functions.md#2-const--the-safety-belt)).

<a name="s18--the-handle"></a>
## S18 — The handle experiment

`main`'s array prints 0 in box 0 — because what got passed was the **address of the caller's first box** (a handle), not a copy ([Lesson 3 §1](lesson-3-arrays-functions.md#1-what-gets-passed--the-surprise)). Same boxes, second name.

<a name="s19--const-placement"></a>
## S19 — Const placement

(a) `void printAll(const int a[], int n)` — reader. (b) `void fillTest(int a[], int n)` — writer. (c) `int countEqual(const int a[], int n, int x)` — reader. Rule: const for every read-only array parameter; writers plain.

<a name="s20--read-and-print"></a>
## S20 — Read and print

```cpp
int readData(int data[], int capacity) {
    int n = 0, value;
    std::cin >> value;
    while (value != -1 && n < capacity) {
        data[n] = value; n += 1;
        std::cin >> value;
    }
    return n;
}
void printMarks(const int a[], int n) {
    for (int i = 0; i < n; i = i + 1) std::cout << a[i] << ' ';
    std::cout << '\n';
}
```
Writer plain, reader const; the logical size flows from one to the other ([Lesson 3 §3](lesson-3-arrays-functions.md#3-the-size-travels-separately--and-how)).

<a name="s21--twist"></a>
## S21 — twist

Prints **`246`**. `twist` received a handle; each `a[i] *= 2` doubled the *caller's* boxes. Compare with [Functions E8](../functions/exercises.md#s8--bump) — ints copied, arrays aliased.

<a name="s22--sizeof-trap"></a>
## S22 — sizeof trap

Inside the function, `a` is just the handle — `sizeof(a)` is the size of the *handle* (typically 4 or 8 bytes), not the row. On a 3-int array, `sizeof(a)/sizeof(a[0])` yields something like 1 or 2, not 3 — and it's *constant* regardless of `n`: the 100-box test exposes it (the teammate's "sum" adds 1–2 boxes). The size parameter exists precisely because the handle carries no length.

<a name="s23--minmax"></a>
## S23 — minMax

```cpp
void minMax(const int a[], int n, int& lo, int& hi) {
    // contract: n >= 1 (an empty array has no champion)
    lo = a[0]; hi = a[0];
    for (int i = 1; i < n; i = i + 1) {
        if (a[i] < lo) lo = a[i];
        if (a[i] > hi) hi = a[i];
    }
}
```
One pass, two reference outputs; inputs left, outputs right. n = 0: contract violated — the caller guards (or the function could return a bool).

<a name="s24--team-plan"></a>
## S24 — Team plan

```cpp
int    readTemps(int t[], int capacity);                 // writer
double averageOf(const int t[], int n);                  // reader (uses sum)
int    indexMax(const int t[], int n);                   // reader
int    indexMin(const int t[], int n);                   // reader
int    countAbove(const int t[], int n, double cut);     // reader — cut is double: the true average
```
One writer, four readers; `countAbove` takes the *unrounded* average — the [S15](#s15--above-average) policy lesson baked into a signature.

<a name="s25--grid-declare"></a>
## S25 — Grid declare

`g[1][0]` = 4 (row 1, column 0) · `g[0][2]` = 3 (row 0, column 2). Row first, always.

<a name="s26--grid-read"></a>
## S26 — Grid read

Outer = rows: input arrives "row by row", so the row loop must be the slow one — three rows, each consuming 3 values in its inner loop. Headers: print `c` values before the row loop, then per row print the row label and boxes.

<a name="s27--six-sums"></a>
## S27 — Six sums

Rows 6/15/24, columns 12/15/18 — verified by hand before coding. Structure: per-row pass (reset inside outer); per-column pass with `c` frozen in the *outer* loop.

<a name="s28--whole-grid"></a>
## S28 — Whole grid

```cpp
int total = 0, best = g[0][0], br = 0, bc = 0;
for (int r = 0; r < R; r = r + 1)
    for (int c = 0; c < C; c = c + 1) {
        total += g[r][c];
        if (g[r][c] > best) { best = g[r][c]; br = r; bc = c; }
    }
```
Coordinates come from tracking *two* champions — position, not just value ([Lesson 2 §2](lesson-2-classic-passes.md#2-minimum-and-maximum--the-champion-with-an-address) in 2D).

<a name="s29--row-and-column-reports"></a>
## S29 — Row and column reports

```cpp
for (int r = 0; r < 4; r = r + 1) {          // per-student totals
    int rowTotal = 0;                         // RESET per row
    for (int c = 0; c < 3; c = c + 1) rowTotal += marks[r][c];
    std::cout << "Student " << r + 1 << ": " << rowTotal << '\n';
}
for (int c = 0; c < 3; c = c + 1) {          // per-subject averages
    int colTotal = 0;                         // RESET per column
    for (int r = 0; r < 4; r = r + 1) colTotal += marks[r][c];
    std::cout << "Subject " << c + 1 << " avg: "
              << static_cast<double>(colTotal) / 4 << '\n';
}
```
The accumulator resets at the top of *each* outer pass — [gallery M2](lesson-4-matrices.md#6-the-2d-errors-gallery).

<a name="s30--add-and-transpose"></a>
## S30 — Add and transpose

```cpp
void addMatrices(const int a[][3], const int b[][3], int sum[][3], int rows) {
    for (int r = 0; r < rows; r = r + 1)
        for (int c = 0; c < 3; c = c + 1)
            sum[r][c] = a[r][c] + b[r][c];
}
void transpose(const int a[][3], int t[][3], int rows) {
    for (int r = 0; r < rows; r = r + 1)
        for (int c = 0; c < 3; c = c + 1)
            t[c][r] = a[r][c];
}
```
Test `transpose` on `{ {1,2,3},{4,5,6}}` (2×3 → its transpose is 3×2 with `t[0][1] == 4`): asymmetric data *proves* the index order — symmetric data can't tell `t[c][r]` from `t[r][c]`.

<a name="s31--diagonals"></a>
## S31 — Diagonals

```cpp
for (int r = 0; r < 4; r = r + 1) {
    if (r == c_pattern) ...        // see below
}
// one traversal:
for (int r = 0; r < 4; r = r + 1)
    for (int c = 0; c < 4; c = c + 1) {
        if (r == c)         std::cout << g[r][c] << ' ';   // main diagonal
        if (r + c == 3)     std::cout << g[r][c] << ' ';   // anti-diagonal
    }
```
Diagonals are *index conditions*, not loops ([Lesson 4 §4](lesson-4-matrices.md#4-matrices--the-vocabulary)); a 4×4 has 4 boxes per diagonal, 7 visited boxes total in this pass (the centre boxes of odd squares would coincide).

<a name="s32--multiply"></a>
## S32 — Multiply

By hand: prod[0][0] = 1×5 + 2×7 = 19; prod[0][1] = 1×6 + 2×8 = 22; prod[1][0] = 3×5 + 4×7 = 43; prod[1][1] = 3×6 + 4×8 = 50 → `{ {19,22},{43,50}}`.

```cpp
for (int r = 0; r < 2; r = r + 1)
    for (int c = 0; c < 2; c = c + 1) {
        prod[r][c] = 0;                              // accumulator per box
        for (int k = 0; k < 2; k = k + 1)
            prod[r][c] += a[r][k] * b[k][c];
    }
```
The triple loop: r, c select the output box; k walks the shared dimension. The reset-to-0 before the k-loop is the per-box accumulator — forget it and every box accumulates garbage on top of garbage.
