---
title: "Arrays Challenges"
description: "15 challenges — reversal, shifting, two-pointer passes, dedup, histograms, matrix ops, and the algorithms Unit 10 will formalize. Solutions separated at the end."
---

# Arrays Challenges (15)

> [← Module home](index.md) · Attempt on paper (boxes + passes sketch) before code. [Solutions](#solutions-c1--c15) describe approaches.

## The problems

<a name="c1--the-reverser"></a>
**C1 ★ — The reverser.** Write `void reverse(int a[], int n)` that reverses *in place* (no second array). Then the extra-array version. When does each earn its keep?

<a name="c2--the-shifter"></a>
**C2 ★ — The shifter.** `void rotateRight(int a[], int n, int k)` — shift every box right by k, wrapping (n = 5, k = 2: `{1,2,3,4,5}` → `{4,5,1,2,3}`). Watch the direction rule from [D9](debugging.md#d9--the-backwards-copy).

<a name="c3--the-pair-hunter"></a>
**C3 ★ — The pair hunter.** In `{8, 3, 11, 6, 1, 9}`, find whether any *two* boxes sum to 10 — print each pair once. (Nested pass; think about which pairs you've already checked.)

<a name="c4--the-second-champion"></a>
**C4 ★ — The second champion.** Find the second-largest *value* in one pass, handling duplicates honestly (`{9, 9, 5}` → second-largest is 5? or 9? Decide, document, test).

<a name="c5--the-deduplicator"></a>
**C5 ★★ — The deduplicator.** Remove duplicates from a sorted array in place (`{1, 2, 2, 3, 3, 3}` → `{1, 2, 3}`, n shrinks). Then the *unsorted* version (order must survive). What does the sorted version's n-returning signature look like?

<a name="c6--the-merger"></a>
**C6 ★★ — The merger.** Merge two *sorted* arrays into one sorted array without re-sorting — the walk-two-pointers pass (the seed of [Unit 10's](../syllabus.md#stage-d-algorithms-and-data-units-10-12) merge sort).

<a name="c7--the-histogram"></a>
**C7 ★★ — The histogram.** Marks 0–100 arrive in an array. Print a *banded* histogram (0–9, 10–19, …, 90–100) as star rows. The tally idea ([Lesson 2 §4](lesson-2-classic-passes.md#4-frequency-counting--the-tally-array)) with an index formula instead of raw values.

<a name="c8--the-majority-report"></a>
**C8 ★★ — The majority report.** Find the majority value — one appearing more than n/2 times — or report none. (Tally pass, then a champion pass over the tally.)

<a name="c9--the-saddle-hunter"></a>
**C9 ★★ — The saddle hunter.** In a matrix, find "saddle points": boxes that are the *maximum of their row* and the *minimum of their column*. One example exists in `{ {4,5,6},{1,2,3},{7,8,9}}` — find it by hand first.

<a name="c10--the-multiplication-prover"></a>
**C10 ★★★ — The multiplication prover.** Implement matrix multiply ([Lesson 4 §4](lesson-4-matrices.md#4-matrices--the-vocabulary)) and *prove it on paper* for `{ {1,2},{3,4}} × { {5,6},{7,8}}` before running. Then the boundary probe: what does multiplying by the identity matrix `{ {1,0},{0,1}}` yield, and why is that a correctness check?

<a name="c11--the-diagonal-inspector"></a>
**C11 ★★★ — The diagonal inspector.** Report whether a square matrix is (a) a diagonal matrix (non-diagonal boxes all zero), (b) symmetric (`a[r][c] == a[c][r]` for all r, c). One traversal each — and say why asymmetric test data is *mandatory* for (b).

<a name="c12--the-magic-square"></a>
**C12 ★★★ — The magic square.** Verify a 3×3 magic square: all rows, all columns, and both diagonals sum to the same value. Structure the check as a function team — and count how many sums you're comparing (9 lines total: can you collect them in one array?).

<a name="c13--the-stable-partitioner"></a>
**C13 ★★★ — The stable partitioner.** Rearrange an array so all even values precede all odd values, *preserving relative order* (`{3, 8, 5, 2}` → `{8, 2, 3, 5}`), using one extra array. Then attempt it in-place and describe honestly what breaks.

<a name="c14--the-window-analyst"></a>
**C14 ★★★ — The window analyst.** Given daily sales, find the k-day window (k read from input) with the highest total — the sliding-window pass: compute the first window's sum, then *slide* (add the entering box, subtract the leaving one). Compare its pass-count with the brute-force nested version.

<a name="c15--the-local-maxima-cartographer"></a>
**C15 ★★★ — The local-maxima cartographer.** Print the *positions* of all local maxima — boxes strictly greater than both neighbours (ends count with one neighbour). `{3, 7, 4, 9, 2}` → positions 1 and 3. Edge boxes are the exercise.

## Solutions (C1–C15)

<a name="solutions-c1--c15"></a>

### C1 — The reverser

In place: swap box i with box n−1−i for i = 0 .. n/2−1 — `for (i = 0; i < n/2; i++) { int t = a[i]; a[i] = a[n-1-i]; a[n-1-i] = t; }`. Odd n: the middle box swaps with itself harmlessly. Extra-array: backward copy into `b` — clearer, costs n boxes. In-place earns its keep when memory is the constraint or mutation is the contract; the copy when the original must survive. Direction discipline: the swap version is direction-proof *because* it swaps pairs, it never overwrites a needed source.

### C2 — The shifter

Naive: repeat k times, one right-shift each (backward loop, temp = a[n−1] saved first) — O(n·k). Better: each box's source is `a[(i - k + n) % n]` — copy into a *fresh* array, then copy back (in-place without the fresh array kinks into index-cycle chasing, which is beyond today). Trace n=5, k=2: new[0] = a[3], new[1] = a[4], new[2] = a[0]... → `{4,5,1,2,3}` ✓. The `% n` wrap is the whole trick; test k = 0 (identity), k = n (identity), k > n (reduces to k % n).

### C3 — The pair hunter

```cpp
for (int i = 0; i < n; i = i + 1)
    for (int j = i + 1; j < n; j = j + 1)      // j starts at i+1: pairs (i, j), i < j, each once
        if (a[i] + a[j] == 10) print a[i], a[j];
```
`{8, 3, 11, 6, 1, 9}` → (8, ... 8+3=11 no; 8+11 no; 8+6 no... 3+... 3+11=14; 3+6=9; 3+1=4; 3+9=12; 11+6=17; 11+1=12; 11+9=20; 6+1=7; 6+9=15; 1+9=10 ✓ → pair (1, 9)). Starting j at i+1 is the "each pair once" rule — starting at 0 would double-count and self-pair.

### C4 — The second champion

Decision first: with `{9, 9, 5}`, is the second-largest 9 (two boxes hold it) or 5 (second *distinct* value)? Pick the **distinct** reading (more useful, harder) and document. One pass, three champions: `best`, `second` (both seeded from the first *two distinct* values — seed carefully), challenger v: `if (v > best) { second = best; best = v; } else if (v > second && v != best) second = v;`. Test: `{9, 9, 5}` → 5; `{5, 9, 9}` → 5; `{1, 2}` → 1; `{7}` → none (contract: n ≥ 2 distinct — document). The three-way champion is the exercise: two `if`s with the *demotion* order right.

### C5 — The deduplicator

Sorted version — two-pointer read/write:

```cpp
int w = 1;                                  // write position (box 0 always stays)
for (int r = 1; r < n; r = r + 1) {
    if (a[r] != a[w - 1]) { a[w] = a[r]; w += 1; }   // keep first of each run
}
return w;                                    // new logical size
```
Sorted input makes duplicates *adjacent*, so one comparison against the last *kept* value suffices. Unsorted: keep a "seen" tally/scan — O(n²) with the tools so far (`for each r, scan kept boxes a[0..w-1]`), fine at course scale. The n-returning signature: `int dedup(int a[], int n)` — shrink the logical size, boxes beyond w are simply unused.

### C6 — The merger

```cpp
int i = 0, j = 0, w = 0;
while (i < nA && j < nB) {
    if (a[i] <= b[j]) c[w++] = a[i++];       // <= keeps the merge stable
    else              c[w++] = b[j++];
}
while (i < nA) c[w++] = a[i++];              // drain the leftovers — one of these runs
while (j < nB) c[w++] = b[j++];
```
Two pointers each own a sorted array; the smaller head advances. The two drain loops handle the tails (only one can have leftovers). Trace `{1,4,7} + {2,3,9}` → 1, (1<2) then 2, 3, 4, 7, 9 ✓. This is merge — [Unit 10](../syllabus.md#stage-d-algorithms-and-data-units-10-12) will recurse it into merge sort.

### C7 — The histogram

Ten bands: `int bands[10] = {0};` — the index formula converts a mark to a band: `band = mark / 10` for 0–99, with **100 folded into band 9** (`mark == 100 ? 9 : mark / 10` — the boundary the division misses). Guard the range (gallery A3, data-as-index), tally, then print `band*10`–`band*10+9` labels with `setw`-aligned star rows. Test rows: 0 → band 0; 99 → band 9; 100 → band 9; 55 → band 5.

### C8 — The majority report

Pass 1: tally into `count[value]` (values bounded — say 0..99; guard as in C7). Pass 2: champion over the tally; report the value if `count[champion] > n / 2` — strictly greater, so a 50/50 split reports none. Trace `{2,2,3,2,3}`: counts 2→3, 3→2; champion 2; 3 > 5/2 = 2 ✓ → majority 2. `{1,2,1,2}`: no value exceeds 2 → none. Two passes, one array of counters — the tally idiom answering a *victory* question.

### C9 — The saddle hunter

Hand: row maxima are 6, 3, 9; column minima are 1, 2, 3 — the box (row 1, col 2) = 3 is both (max of its row 3 ≥ 6? no — recheck: row 1 is {1,2,3}, max 3 ✓; column 2 is {6,3,9}, min 3 ✓) → saddle at (1, 2) with value 3. Code: per row, find the max and *its column*; then scan that column for the min; saddle iff the two agree. Rows with tied maxima need all their columns checked (test `{ {3,3},{3,3}}` — every box is a saddle!). The composition: two champion passes with a shared coordinate.

### C10 — The multiplication prover

By hand: row 0 · col 0 = 1×5 + 2×7 = 19; (0,1) = 6+16 = 22; (1,0) = 15+28 = 43; (1,1) = 18+32 = 50 → `{ {19,22},{43,50}}` ✓ (matches [S32](exercises.md#s32--multiply)). Identity check: `A × I` — row 0 · col 0 = 1×1 + 2×0 = 1; row 0 · col 1 = 0 → `{ {1,2},{3,4}}` = A itself. Multiplying by the identity is the matrix world's ×1: any *correct* implementation must return A unchanged — a zero-cost regression test baked into mathematics.

### C11 — The diagonal inspector

(a) Diagonal matrix: one full-grid pass, `if (r != c && a[r][c] != 0) return false;`. (b) Symmetric: `for r, for c: if (a[r][c] != a[c][r]) return false;` — early exit on the first mismatch. Asymmetric data is mandatory for (b)'s test: on a symmetric matrix *every* implementation passes; on `{ {1,2},{3,4}}` a wrong version (say, testing only `r < c`) still passes half the checks but must fail the honest one — design test data so each comparison is exercised both ways.

### C12 — The magic square

Team: `int rowSum(const int g[][3], int r)`, `int colSum(..., int c)`, `int diagSum(g, bool main)`, then `bool isMagic(const int g[][3])` — collect all nine sums into an array `int sums[9]` (rows 0–2, cols 3–5, diag 6, anti 7… that's 8 — the ninth comparison is each *against the first*), and verify `sums[i] == sums[0]` for all i. Lo Shi test: `{ {8,1,6},{3,5,7},{4,9,2}}` → rows 15/15/15, cols 15/15/15, diagonals 15/15 → magic ✓. The array-of-sums trick is the lesson: *even your checks* become data a loop can walk.

### C13 — The stable partitioner

Extra array, two write pointers: `for r in 0..n-1: if (a[r] even) tmp[we++] = a[r];` then a second pass for odds (`tmp[wo++]`, wo starting at we). One extra array, two stable passes, order preserved: `{3, 8, 5, 2}` → evens 8, 2 then odds 3, 5 → `{8, 2, 3, 5}` ✓. In-place stable partition with O(1) extra space is a genuinely hard classical problem — attempting it honestly *and failing informatively* (the rotations needed scramble order) is the point: stability costs either time or space, pick one knowingly.

### C14 — The window analyst

Brute force: for each start, sum k boxes — O(n·k). Sliding window: sum boxes 0..k−1 once; then for each slide `sum += a[i] − a[i-k]` — O(n) total. Trace n=7, k=3, `{4, 2, 7, 1, 9, 5, 8}`: first window 13; slides: 10 (−4+1), 17 (−2+9), 17 (−7+5), 22 (−1+8) → best 22, window starting at index 4. Two test traps: k = n (one window) and k > n (reject in the reader). The sliding trick — *add the entering, subtract the leaving* — is the difference between re-summing and updating an accumulator.

### C15 — The local-maxima cartographer

Interior boxes: `a[i] > a[i-1] && a[i] > a[i+1]`. End boxes are the exercise: index 0 is a local max iff `a[0] > a[1]`; index n−1 iff `a[n-1] > a[n-2]`. Trace `{3, 7, 4, 9, 2}`: i=0: 3 > 7 no; i=1: 7>3 && 7>4 ✓; i=2: no; i=3: 9>4 && 9>2 ✓; i=4: 2>9 no → positions 1 and 3 ✓. Test the flat-top case `{5, 5, 1}` — *strictly* greater means neither 5 qualifies; document the plateau policy. Structure: one pass with three guarded branches (two edges, one interior) — bounds discipline at both ends of the same loop.
