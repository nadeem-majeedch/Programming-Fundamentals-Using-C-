---
title: "Algorithms Exercises — 32 Drills in Three Parts"
description: "Part A recursion, Part B searching, Part C sorting — each with a separated solution, so you can attempt first."
---

# Exercises — 32 drills, three parts

> [← Module home](index.md) · Attempt each part before opening its solutions. Every solution is separated from its problem. Struggle first — that's the tuition.

**Rules of engagement:** write real code for the ★★ and ★★★ items; trace on paper for every trace question. If a solution disagrees with your answer, *your trace of the solution* settles it — not your memory of what you meant.

## Part A — Recursion (E1–E12)

- **E1 ★** Write `factorial(int n)` returning `long long`. State the base case in a comment. What is the largest n that fits in `long long` for factorial?
- **E2 ★** Write a recursive function `sumTo(n)` that returns 1+2+…+n. Trace `sumTo(4)` in a two-phase table.
- **E3 ★** Write recursive `digits(n)` and `digitSum(n)`. Decide and document the contract for `n = 0` and negatives.
- **E4 ★** Write recursive `printDigitsForward(n)` that prints n's digits left to right (for 4729 prints `4 7 2 9`). The printing order is the whole exercise — where does the print statement go, relative to the recursive call?
- **E5 ★★** Write recursive `power(b, e)` computing bᵉ for e ≥ 0 using only multiplication (no loops). How many multiplications does `power(2, 10)` make? Can you do better with "square the half"?
- **E6 ★★** Write recursive `countOccurrences(a, n, x)` over an array. Test: no match, all match, n = 0.
- **E7 ★★** Write recursive `isSorted(const int a[], int n)` (non-decreasing). Then write `isSortedRange(a, lo, hi)` shrinking from *both* ends. Which shrinkage did you pick, and why does either work?
- **E8 ★★** Write recursive `reversePrint(a, n)` that prints an array **in reverse** (last first), using recursion only — no loops, no reverse iteration.
- **E9 ★★** Write recursive `maxOf(const int a[], int n)` returning the largest element (assume n ≥ 1; document it). What is your base case, and what does "shrink by one" mean here?
- **E10 ★★** Write recursive `fib(n)` (fib(1)=fib(2)=1). Print fib(1..15). Then add a global-free counter parameter (`int& calls`) and report the call count for fib(10), fib(20), fib(25). What's the growth shape?
- **E11 ★★★** Write `fibFast(n)` that computes fib(n) with **no repeated work**: keep two variables (a, b) = (fib(1), fib(2)) and walk a loop, or memoize. Compare call counts with E10's for n = 30.
- **E12 ★★★** Recursive `reverseString(string s)`: base case for length ≤ 1, else `reverse(rest) + first`. Trace `reverseString("abcd")` in box form. Then explain (one sentence each) what this costs in copies, and why an index-based version would avoid them.

### Solutions A

**S1.** `long long factorial(int n) { if (n == 0) return 1; return n * factorial(n - 1); }` — base: n==0 by convention 0!=1. Overflow check by doubling: 20! = 2,432,902,008,176,640,000 fits in long long (max ≈ 9.22×10¹⁸); 21! ≈ 5.1×10¹⁹ does not. **Largest n = 20.**

**S2.** `int sumTo(int n) { if (n == 1) return 1; return n + sumTo(n - 1); }` — trace: descend sumTo(4)→(3)→(2)→(1); ascend 1, 3, 6, **10**. (Base n==1; base n==0 returning 0 is equally valid — contract it.)

**S3.** `int digits(int n){ if (n < 10) return 1; return 1 + digits(n/10); }` · `int digitSum(int n){ if (n < 10) return n; return n%10 + digitSum(n/10); }` — contract stated: n ≥ 0; digits(0) = 1 (zero is one digit), digitSum(0) = 0. Negatives: take abs first or reject — either documented.

**S4.** Print **before** recursing: `void pdf(int n){ if (n < 10) { cout << n; return; } pdf(n / 10); cout << " " << n % 10; }` — wait, order: to print left-to-right you must print the *leading* digit first, so recurse first (to reach the leading digit), print on the way **up**: `void pdf(int n){ if (n >= 10) pdf(n/10); cout << n % 10; }` for 4729 prints `4729`. The wrong order (print, then recurse) gives `9274` — that's E4's point.

**S5.** `long long power(int b, int e){ if (e == 0) return 1; return b * power(b, e-1); }` — power(2,10) makes 10 multiplications. Faster ("square the half"): `power(b,e) = square(power(b, e/2)) × (e odd ? b : 1)` — about log₂ e multiplications: 2¹⁰ in ~4–5. (Bases: e==0 → 1.)

**S6.** `int countOcc(const int a[], int n, int x){ if (n == 0) return 0; return (a[n-1] == x ? 1 : 0) + countOcc(a, n-1, x); }` — tests: `{1,2,3},x=9` → 0; `{5,5,5},x=5` → 3; n=0 → 0 (base before any read — no a[-1]).

**S7.** Shrink from the back: `bool isSorted(const int a[], int n){ if (n <= 1) return true; if (a[n-2] > a[n-1]) return false; return isSorted(a, n-1); }`. Both-ends version shrinks hi: `bool isr(const int a[], int lo, int hi){ if (lo >= hi) return true; if (a[lo] > a[lo+1]) return false; return isr(a, lo+1, hi); }`. Either works because a failed pair is *somewhere* — every (adjacent-pair) shrinkage eventually inspects every pair.

**S8.** `void rprint(const int a[], int n){ if (n == 0) return; cout << a[n-1] << " "; rprint(a, n-1); }` — print-then-recurse prints last-first. (Recurse-then-print gives forward order — the same before/after lever as S4.)

**S9.** `int maxOf(const int a[], int n){ if (n == 1) return a[0]; int m = maxOf(a, n-1); return a[n-1] > m ? a[n-1] : m; }` — base: exactly one element (n≥1 documented). "Shrink by one" = compare the last element with the max of the rest; n==0 has no answer, hence the precondition.

**S10.** `long long fib(int n){ if (n <= 2) return 1; return fib(n-1) + fib(n-2); }` — with `int& calls` incremented at entry: fib(10) ≈ 109 calls, fib(20) ≈ 13,457, fib(25) ≈ 242,785 — the count **roughly doubles per +2 of n**, the golden-ratio-shaped explosion; growth is exponential, the exact shape of the call tree in Lesson 1 §4.

**S11.** Loop version: `long long fibFast(int n){ long long a=1,b=1; for (int i=3;i<=n;i++){ long long c=a+b; a=b; b=c; } return b; }` — n=30: fibFast makes ~28 additions and **1** call; naive fib(30) makes 1,664,079 calls. Same answer (832,040), five orders of magnitude apart — memoization/iteration kills the overlap.

**S12.** `string rev(string s){ if (s.length() <= 1) return s; return rev(s.substr(1)) + s[0]; }` — trace "abcd": rev(abcd) = rev(bcd)+a = (rev(cd)+b)+a = ((rev(d)+c)+b)+a = d+c+b+a = "dcba". Cost: each level builds a new string (substr + concatenation) — O(len) copies per level, O(len²) total; an index-based version recurses on (lo+1, hi) with no copies — O(len) work.

## Part B — Searching (E13–E20)

- **E13 ★** Implement `linearSearch(const int a[], int n, int x)` returning the first index or −1. Then the **last-match** variant. Both on `{4, 8, 15, 16, 8}` with x = 8.
- **E14 ★** Implement `countMatches` and `allMatches` (print every index). On `{5, 5, 5}` with x=5: what does each do?
- **E15 ★★** Write `linearSearchFirstGreater(a, n, x)`: index of the **first element > x**, or −1. (This is "find where x would be inserted to keep order" — a sorted-array idea hiding in a linear scan.)
- **E16 ★★** Hand-trace `binarySearch` for x=23 on `{3, 7, 11, 19, 23, 42, 57}` as a lo/hi/mid table. Then x=8 on the same array. Count comparisons in both.
- **E17 ★★** Implement binary search (iterative). Your tests must include: first element, last element, one-element array, absent-inside-range, absent-below, absent-above.
- **E18 ★★** Write `isSortedAscending(a, n)` (a loop this time), then a safe `binarySearchSafe(a, n, x)` that **returns −2** (a distinct "precondition violated" code) when the array fails the check, −1 when absent, the index when found. Where does the cost of this safety net show up?
- **E19 ★★★** Write the **recursive** binary search `binRec(a, lo, hi, x)`. Trace binRec's calls for x=57 on `{3,7,11,19,23,42,57}` — list each (lo, hi, mid).
- **E20 ★★★** Guessing-game arithmetic: for n = 10, 100, 1,000, 10⁶, 10⁹, list binary search's worst-case comparison counts (⌈log₂ n⌉ is fine). Then state, in one sentence, why "sorted once, searched many times" is the regime where binary search *earns* its keep.

### Solutions B

**S13.** First: the lesson's function verbatim → index 1 (first 8). Last: `int lsLast(const int a[], int n, int x){ int last = -1; for (int i=0;i<n;i++) if (a[i]==x) last = i; return last; }` → index 4. Same loop, different stop policy.

**S14.** `countMatches` returns 3; `allMatches` prints `0 1 2`. On all-equal input the "first match" contract still returns 0 — policy, not accident.

**S15.** `int fsg(const int a[], int n, int x){ for (int i=0;i<n;i++) if (a[i] > x) return i; return -1; }` — on sorted input this *is* the insertion point (or −1 when x ≥ everything). It's the linear sketch of binary search's "lower bound" cousin; binary does the same question in log n.

**S16.** x=23: (lo0,hi6,mid3,a=19<23→lo4) → (4,6,mid5,a=42>23→hi4) → (4,4,mid4,**23**) → 3 comparisons. x=8: (0,6,mid3,19>8→hi2) → (0,2,mid1,7<8→lo2) → (2,2,mid2,11>8→hi1) → lo>hi → −1, 3 comparisons. Same count, different verdicts — log₂ 7 ≈ 2.8 → 3.

**S17.** Lesson 2's implementation verbatim passes all six: first (0) and last (6) hit on the boundary passes; one-element runs one pass; absent-inside (8) exits with lo>hi; absent-below (x=1) descends left to empty range; absent-above (x=100) right. The edges are all just "range shrinks to empty."

**S18.** `bool sorted(const int a[], int n){ for (int i=0;i+1<n;i++) if (a[i] > a[i+1]) return false; return true; }` then `int bsSafe(...){ if (!sorted(a,n)) return -2; ...binary... }`. Cost: **O(n) check before every O(log n) search** — the safety net costs more than the search. Honest engineering: check once at load time (Project 2 sorts after insert, then searches), not on every query.

**S19.** `int binRec(const int a[], int lo, int hi, int x){ if (lo > hi) return -1; int mid = lo + (hi-lo)/2; if (a[mid]==x) return mid; if (a[mid]<x) return binRec(a, mid+1, hi, x); return binRec(a, lo, mid-1, x); }` — x=57 call chain: (0,6): mid=3, a[3]=19<57 → recurse right → (4,6): mid=5, a[5]=42<57 → recurse right → (6,6): mid=6, a[6]=**57** found. Chain: (0,6)→(4,6)→(6,6). Depth 3 = ⌈log₂ 7⌉.

**S20.** ⌈log₂ n⌉: 10→4, 100→7, 1000→10, 10⁶→20, 10⁹→30. One sentence: *each search pays only log n, so the sort's one-time O(n log n)-or-better cost amortizes across every query — the precondition is an investment, and many queries are the return.*

## Part C — Sorting (E21–E32)

- **E21 ★** Trace **one full bubble pass** on `{9, 3, 7, 1}` as a compare/action table. State what is guaranteed placed at the end.
- **E22 ★** Trace **selection sort** fully on `{9, 3, 7, 1}` (start / min / swap / array-after rows). How many swaps total?
- **E23 ★** Trace **insertion sort** fully on `{9, 3, 7, 1}` (i / key / shifts / array-after). Which elements never moved?
- **E24 ★** Implement all three sorts (you may take Lesson 3's code as the starting point). Verify each against: `{}`, `{1}`, `{2,1}`, `{1,2}`, `{3,3,3}`, `{5,4,3,2,1}`, `{1,2,3,4,5}`.
- **E25 ★★** Add a comparison counter (a `long long& cmp` parameter) to each of the three sorts. Run all three on `{5,4,3,2,1}` and on `{1,2,3,4,5}`. Report both counts per algorithm.
- **E26 ★★** Bubble with early exit vs without: on `{1,2,3,5,4}` how many passes does each need? What does this tell you about the flag's value on nearly-sorted data?
- **E27 ★★** A classmate claims selection sort is O(n) because "the outer loop moves forward one at a time." Diagnose the confusion in two sentences, and give the correct bound with the counting argument.
- **E28 ★★** Modify selection sort to sort **descending** (largest to front). Then modify insertion sort for descending. Which comparisons flipped in each?
- **E29 ★★** Stability by experiment: sort pairs `{(2,'a'),(1,'x'),(2,'b'),(1,'y')}` by first component with each sort (compare firsts only). Which sorts preserve the original order of equal keys — and which don't? (Record what you observe; the *why* is a data-structures-course question.)
- **E30 ★★★** Write `isSorted` and a **test harness**: for each of the edge arrays in E24, run all three sorts and verify with `isSorted` after each. Print PASS/FAIL per (algorithm, input). This harness is reusable in Project 2.
- **E31 ★★★** A teaching lab needs "nearly sorted": write `void jitter(int a[], int n, int k)` that performs k random adjacent swaps on a sorted array. Use it to build inputs of n = 1,000 with k = 0, 10, 100. Run insertion sort on each (count comparisons). Report the trend and say why it matches insertion's best-case story.
- **E32 ★★★** The counting question at scale: bubble on n=100 does ≈ n(n−1)/2 comparisons. Compute the comparison count for n = 100, 1,000, 10,000 and the **ratio** between consecutive rows. What does a constant ratio (~×100 per ×10 of n) tell you about O(n²) — and about calling bubble "fine" for n=10,000?

### Solutions C

**S21.** `{9,3,7,1}` pass 1: (9,3)swap→`3,9,7,1`; (9,7)swap→`3,7,9,1`; (9,1)swap→`3,7,1,9`. Placed: **9** (the region max) at index 3.

**S22.** start0: min 1 (idx3), swap 9↔1 → `1,3,7,9`; start1: min 3 (idx1), self-guard → no swap; start2: min 7, self. **Swaps: 1.** (Selection's minimal-write personality in miniature.)

**S23.** The full honest trace: i1: key=3, 9 shifts right, insert at 0 → `3,9,7,1`. i2: key=7, 9 shifts, insert → `3,7,9,1`. i3: key=1, 9, 7, 3 all shift, insert at 0 → `1,3,7,9`. **Every element moved at least once** — on reverse-sorted input, insertion shifts everything. Compare with `{1,2,3,4,5}`: zero elements move. "Which elements never move" is a property of the *input*, not the algorithm — that's what the trace teaches.

**S24.** All three lesson implementations handle every edge **provided** the loop bounds are the lesson's: empty and one-element arrays skip their loops entirely; `{2,1}` exercises exactly one comparison in each; all-equal arrays exercise the strict-`>` rule (no swaps anywhere); reverse-sorted is each algorithm's worst case; sorted input is bubble-with-flag's and insertion's best case and selection's unchanged O(n²).

**S25.** Reverse-sorted `{5,4,3,2,1}`: bubble 10 comparisons (4+3+2+1), selection 10 (4+3+2+1 — fixed), insertion 10 (each key shifts past everything). Sorted `{1,2,3,4,5}`: bubble-with-flag **4** (one pass, then exit), selection **10** (unchanged), insertion **4** (each key fails the while immediately). The best-case rows are the lesson's O(n) claims, now counted.

**S26.** With flag: pass 1 fixes 4↔5 → `1,2,3,4,5` clean → **1 pass**. Without: it still runs all n−1 = 4 passes of compares on a sorted tail. Moral: the flag converts "certain O(n²)" into "O(n) on nearly-sorted" — free insurance, always include it.

**S27.** The outer loop's **n−1 iterations** don't measure the work; each iteration's inner min-scan does: (n−1)+(n−2)+…+1 = n(n−1)/2 comparisons **regardless of input order**. Selection is Θ(n²) always — its virtue is few swaps, not speed.

**S28.** Descending selection: flip the inner comparison to `a[i] > a[m]` (select the **max**). Descending insertion: flip the while to `a[j] < key` (shift *smaller* elements right). One comparison flip each — ascending/descending is a sign flip, not a new algorithm.

**S29.** Bubble **swaps equal-key pairs only if the comparison allows it** — with strict `>` it doesn't, so order is preserved (stable, as observed). Selection's long-distance swap can jump an element over equals: `{(2,a),(2,b),(1,x)}` → first pass swaps (2,a) with (1,x) → `(1,x),(2,b),(2,a)` — **(2,a) now follows (2,b): unstable**. Insertion with strict `>` shifts only *strictly greater* elements: equals never cross — **stable**. Observed result: bubble and insertion stable, selection not.

**S30.** Skeleton: `bool ok = true; for each (alg, input): copy the input, run alg, if (!isSorted(copy,n)) { print FAIL; ok = false; } else print PASS;` — copy-per-run is mandatory (a sort destroys its input; testing alg B on alg A's output proves nothing). The harness pattern — *given/when/verify* — is Project 2's and the lab's.

**S31.** Insertion's comparison counts land near: k=0 → 999 (one failed while per key); k=10 → ~1,019; k=100 → ~1,199. Trend: nearly-linear in n, mildly growing with k — each adjacent swap creates roughly one "key must pass one element" event. This *is* insertion's adaptive promise measured, and why real libraries route nearly-sorted small slices to insertion.

**S32.** n(n−1)/2: 100→4,950; 1,000→499,500; 10,000→49,995,000. Ratios ≈ 101, ≈ 100.1 — constant. A constant ratio per ×10 input growth is exactly "proportional to n²": quadratic work *compounds* (each row pays ~100× the previous), while n itself pays only ×10. Verdict for n=10,000: ~50 million comparisons for a job the O(n log n) family does in ~130 thousand — fine for a classroom, a wall in production.

## Where next

- [Trace pack](traces.md): fifteen dry runs in exam format.
- [Debugging hunts](debugging.md): ten seeded bugs, recursion to sorting.
- [Labs](labs.md): count the comparisons yourself.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
