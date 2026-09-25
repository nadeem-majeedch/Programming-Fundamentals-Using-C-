---
title: "Algorithms Challenges — 15 Problems"
description: "Fifteen progressively harder challenges across recursion, searching, and sorting, with separated approach-and-solution notes."
---

# Challenges — 15 problems

> [← Module home](index.md) · Difficulty ramps from ★ to ★★★★★. Each challenge has a separated **approach** section — attempt the problem and commit to *some* design before reading it. These are larger than exercises: expect to sketch, trace, and revise.

**Recursion: C1–C6 · Searching: C7–C10 · Sorting: C11–C15.**

- **C1 ★ — The power pair.** Write `power(b, e)` twice: once recursing on `e-1`, once using "square the half" (e even: square(power(b, e/2)); e odd: b × square(power(b, e/2))). Both must handle e = 0. Report the multiplication counts for `power(3, 20)` in each version.
- **C2 ★ — The digit reverse.** Recursively print an integer's digits in reverse (4729 → `9 2 7 4`). Then recursively **build** the reversed number as an `int` (4729 → 9274). The second version forces you to think about where combining happens: `reversed = reversed*10 + n%10` — but *which* frame does that arithmetic?
- **C3 ★★ — The palindrome judge.** Recursively decide whether a `std::string` is a palindrome, shrinking from **both ends** (compare `s[front]` and `s[back]`, recurse on the middle). Contract: ignore nothing — exact characters. Test: `"racecar"`, `"ab"`, `"a"`, `""`, `"aa"`.
- **C4 ★★ — The binary counter.** Recursively print a non-negative integer in **binary** (13 → `1101`). Hint: the recursion order *is* the printing order — decide whether the remainder or the quotient goes first, and prove it with a trace of 13.
- **C5 ★★ — The summoned search.** Recursive binary search on a **descending** array (largest first). The comparisons flip — derive which way before coding. Test on `{57, 42, 23, 19, 11, 7, 3}`.
- **C6 ★★★ — The tower of calls.** Implement `moves(n)` for the Tower of Hanoi **move count**: moves(1)=1, moves(n)=2·moves(n−1)+1 — recursively and then with a closed form you derive by unrolling (state the closed form as a hypothesis tested for n=1..5). Then print the actual move sequence for n=3 recursively (`A→C` style) — the same recurrence, now with side effects.
- **C7 ★★ — The boundary finder.** On a sorted array, return the index of the **first** element ≥ x (the "insertion point"). Linear first, then binary. Contract: x smaller than everything → 0; x larger than everything → n. This is the function binary insertion uses.
- **C8 ★★ — The duplicate hunt.** A sorted array may contain duplicates. Binary-search for x and return the **count of occurrences** in O(log n)-ish time by finding the first and last occurrence. Test: `{1,2,2,2,3}` x=2 → 3; x=1 → 1; x=4 → 0.
- **C9 ★★★ — The rotated probe.** A sorted array was rotated (e.g. `{23, 42, 57, 3, 7, 11, 19}` — sorted, then cut and swapped). Search for x in O(log n) by deciding, at each mid, *which half is normally ordered* and whether x lies inside it. This is the classic "search in rotated sorted array." Test both halves and absent targets.
- **C10 ★★★ — The peak finder.** In an array where neighbours differ (no two adjacent equal), a **peak** is an element greater than both neighbours (ends count with one neighbour). Find any peak in O(log n) by binary-searching on the *slope*: if `a[mid] < a[mid+1]`, a peak exists to the right. Test on strictly increasing, strictly decreasing, and zigzag inputs.
- **C11 ★★ — The stable selector.** Modify selection sort to be **stable**: instead of swapping the minimum into place, *shift* the region right and insert the minimum at the front (like insertion's shift, backwards). Verify stability with E29's pair data. Report the change in move count.
- **C12 ★★★ — The crossover survey.** Insertion sort beats bubble sort on nearly-sorted data and ties it elsewhere; both beat selection on sorted data. Design and run the experiment: for n = 200, generate (a) sorted, (b) reverse, (c) random, (d) nearly-sorted (10 jitters) inputs; run all three sorts with comparison+move counters; produce one table. State the two findings that surprise you most.
- **C13 ★★★ — The joint sort.** Two parallel arrays — `int marks[]` and `string names[]` — must sort together by marks descending. Implement selection sort so swaps move **both** arrays. Then explain (three sentences) why "sort the marks and re-match names after" fails, and why the Records module's *array of structs* makes this whole problem disappear.
- **C14 ★★★ — The merger.** Merge two sorted arrays into one sorted array in linear time (the two-pointer walk). Then use it: **merge sort** = split in half, recursively sort each half, merge. Implement merge sort recursively (it's the natural recursion of Unit 10) and count its comparisons for n = 8 and n = 1000 — compare with the lab's O(n²) counts.
- **C15 ★★★★★ — The toolkit sort.** Write `sortBy(marks, names, n, key)` where `key` selects the comparison: 0 = marks ascending, 1 = marks descending, 2 = names ascending (lexicographic). Pass the comparison as a **function pointer** (or as a `bool less(i, j)` helper chosen by key). Sort a 6-record class by each key and verify. This is a first step toward the standard library's parameterized `sort` — and toward Project 2's sort menu.

---

## Approaches

**A1.** Linear: `power(b,e) = b * power(b, e-1)`, base `e==0 → 1` — 20 multiplications for (3,20). Squaring: even e → `square(power(b, e/2))`; odd → `b * square(power(b, e/2))`; base e==0 → 1 — count: (3,20) needs 20→10→5→2→1→0 ≈ **7 multiplications** (squarings + the odd corrections). Test both against each other for e = 0..10 — agreement is the test (b=e=0 convention: 1).

**A2.** Print-reverse: print `n % 10` **before** recursing on `n / 10` — the mirror image of forward printing. Build-reverse: `int rev(int n, int acc) { if (n == 0) return acc; return rev(n / 10, acc * 10 + n % 10); }` called with `acc = 0`. The combining (`acc*10 + digit`) happens in the *return path* — each frame hands its caller a longer accumulator. Trace 4729: acc 0→9→92→927→9274. The initial `acc=0` must be passed in (or wrapped in a two-argument default) — that's the design decision the challenge is hiding.

**A3.** `bool pal(const string& s, int f, int b) { if (f >= b) return true; if (s[f] != s[b]) return false; return pal(s, f+1, b-1); }` — base cases: pointers crossed (odd length) or adjacent-passed (even). Tests: "racecar" true; "ab" false; "a" true; "" true (empty contract: vacuously — document); "aa" true. The both-ends shrink is the two-pointer pattern's recursive costume.

**A4.** Print `n % 2` **after** recursing on `n / 2`: the low bit is known first but must print last. Trace 13: descent 13→6→3→1→0; base at 0 prints nothing; ascent prints 1, 1, 0, 1 → `1101`. Getting it backwards prints `1011` — the mirror; the trace is the proof. Edge: n=0 → print `0` (special-case the contract, or print nothing — decide and document).

**A5.** On a descending array, `a[mid] < x` means x is in the **left** half (bigger values live left): flip both updates — `if (a[mid] < x) hi = mid - 1; else lo = mid + 1;`. Everything else (loop condition, mid computation, empty-range base) is unchanged. Tests on `{57,42,23,19,11,7,3}`: x=57 → 0 (always-left descent), x=3 → 6, x=20 → −1 with range emptying after ~3 comparisons.

**A6.** `long long moves(int n) { if (n == 1) return 1; return 2 * moves(n - 1) + 1; }` → 1, 3, 7, 15, 31 — the closed form hypothesis: `2ⁿ − 1`, verified for n=1..5 (unrolling: m(n) = 2(2(m(n−2))+1)+1 = … = 2ⁿ⁻¹·m(1) + (2ⁿ⁻²+…+1) = 2ⁿ − 1). Sequence printing: `void hanoi(int n, char from, char to, char via) { if (n == 0) return; hanoi(n-1, from, via, to); cout << from << "→" << to << "\n"; hanoi(n-1, via, to, from); }` — n=3 gives 7 lines; the recursion *is* the textbook strategy (move n−1 aside, move the disk, move n−1 back).

**A7.** Linear: first `a[i] >= x` — one pass, return i; loop ends → n. Binary: search but keep `hi` as a *candidate answer*: `while (lo < hi) { mid; if (a[mid] >= x) hi = mid; else lo = mid + 1; } return lo;` — the half-open convention (note: condition `<`, update `hi = mid`, no exclusion of mid — the *other* consistent formulation from debugging hunt D7). Contracts: x < all → lo stays 0; x > all → lo walks to n. Test both versions against each other on 20 random arrays.

**A8.** Two helpers: `firstGE(x)` (C7) gives the first index ≥ x; `firstGT(x)` gives the first index > x (same function with `>` instead of `>=`). Count = firstGT − firstGE. `{1,2,2,2,3}`: firstGE(2)=1, firstGT(2)=4 → 3. x=4 → 7−7=0. Each probe is O(log n), total O(log n) — the sorted precondition paying dividends twice.

**A9.** At each mid, one of the two halves `[lo..mid]` or `[mid..hi]` is **normally sorted** (check which end pair is ordered: `a[lo] <= a[mid]` → left half is). If x lies inside the ordered half's range, search it; otherwise search the other half. Recurse (or loop) until the range is one element. Tests: `{23,42,57,3,7,11,19}` x=3 → 3 (right half found via the left half being ordered and 3 ∉ [23,57]); x=42 → 1; x=100 → −1; also the un-rotated case (it must still work — the logic degrades to normal binary search).

**A10.** `int peak(const int a[], int lo, int hi) { int mid; while (lo < hi) { mid = lo + (hi - lo) / 2; if (a[mid] < a[mid+1]) lo = mid + 1; else hi = mid; } return lo; }` — the slope decides the half: ascending slope → a peak lies right (the array must eventually fall or end on a peak); descending-or-peak → the peak is at mid or left. Tests: strictly increasing → last index; strictly decreasing → 0; zigzag `{1,3,2,4,1}` → index 1 or 3 (any peak is a valid answer — the contract is *a* peak, not *the* peak).

**A11.** Stable selection: for each start, find min index m; if m != start, **rotate** — save `a[m]`, shift `a[start..m-1]` right by one, place the saved min at start. Shifting (not swapping) means the displaced block keeps its relative order — equal keys never cross. Move count rises from ≤ n−1 swaps to O(n²) worst-case shifts: that is the price of stability in selection — precisely the trade-off the challenge asks you to measure and state.

**A12.** Design: counter-instrumented sorts (like E25), a `copyArray` per run, four input generators, one results table (rows: input shapes; columns: algorithms; cells: comparisons+moves). Expected findings worth stating: insertion ≈ bubble on random but **dramatically better on nearly-sorted**; selection identical across all four rows (order-blind); bubble's early exit makes it insertion's twin on sorted input. Two surprises are yours to find — the honest table is the deliverable, and any finding you can't reproduce is a finding you don't report.

**A13.** Selection by marks descending: inner loop finds the **max** index m; swap `marks[start]↔marks[m]` **and** `names[start]↔names[m]` in the same breath. Why sort-then-rematch fails: after marks are sorted you no longer know which name went with which mark — the correspondence was destroyed by the first sort (this is exactly the parallel-arrays drift from the Records module). The array-of-structs fix: one swap moves the whole record; the pairing is unbreakable by construction — Project 2 should use it.

**A14.** Merge: two pointers i, j walk the sorted inputs, always taking the smaller head (ties: take left), then drain the survivor. Merge sort: `void msort(int a[], int lo, int hi) { if (lo >= hi) return; int mid = lo + (hi-lo)/2; msort(a, lo, mid); msort(a, mid+1, hi); merge(a, lo, mid, hi); }` — base case: one element (sorted). Counts: n=8 ≈ 17 comparisons (vs bubble's 28); n=1000 ≈ 8,700 (n log₂ n ≈ 1000×10) vs bubble's 499,500 — **~57× fewer**, and the gap *widens* as n grows: that widening is O(n log n) beating O(n²).

**A15.** Design: `bool lessMarksAsc(int i, int j) { return marks[i] < marks[j]; }` and siblings; then a generic selection sort taking `bool (*less)(int, int)` — the swap moves marks AND names together (C13's lesson). Key 2 needs `strcmp`-style comparison of names (`names[i] < names[j]` works for `std::string`). Verification: sort the same 6-record class by each key, print all three orderings, check by eye against the expected. The function pointer is the *idea* the standard library's `std::sort` runs on — you've now built its skeleton.

---

## Where next

- [Labs](labs.md): the performance lab — bring C12's counters. The **Project 2 brief** (Student Records Manager) is at the end of that page.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
