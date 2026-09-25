---
title: "Trace Pack — 15 Dry Runs"
description: "Fifteen hand-trace exercises across recursion, searching, and sorting, with a fully separated answer section."
---

# Trace Pack — 15 dry runs

> [← Module home](index.md) · Trace **on paper** before opening the [answers](#answers). Every table you build by hand is a deposited skill; every table you read is a borrowed one.

**Protocol:** copy the data, run the algorithm *by hand* one step at a time, record each step in a table, and only then check. If your table disagrees with the answer, re-trace the answer's steps until you can see where your hand went wrong — that reconciliation is the learning event.

## Recursion (T1–T6)

- **T1.** Draw the box diagram for `factorial(5)`: descent (which boxes stack, what each waits for) and ascent (what each returns). Write the final value.
- **T2.** Trace `sumTo(6)` in a two-phase trace table (call / action / returns).
- **T3.** Trace `digitSum(9182)`. Then trace `digits(9182)`. Which has deeper recursion, and by how much?
- **T4.** Trace `printDigitsForward(4729)` (the corrected S4 version). At which phase — descent or ascent — does each digit print?
- **T5.** Draw the **full call tree** of naive `fib(5)`. Label every duplicate call. How many total calls? How many *distinct* subproblems exist?
- **T6.** Trace `countOccurrences({2,7,2,2,9}, 5, 2)` in table form (call / n / contribution / returns).

## Searching (T7–T11)

- **T7.** Trace linear search for x=16 on `{42, 7, 19, 16, 3}`: one row per comparison. Comparisons used?
- **T8.** Same array, x=100: trace to the −1. Comparisons used?
- **T9.** Trace binary search for x=19 on `{3, 7, 11, 19, 23, 42, 57}` (lo/hi/mid/a[mid]/verdict). Comparisons?
- **T10.** Trace binary search for x=5 on `{3, 7, 11, 19, 23, 42, 57}` until the range empties. Which comparison *proves* absence?
- **T11.** Trace binary search for x=57 (the last element). Then x=3 (the first). Which needed more comparisons, and is that consistent with the ⌈log₂ n⌉ worst case?

## Sorting (T12–T15)

- **T12.** Trace **all of bubble sort** (every pass) on `{9, 3, 7, 1}` with the early-exit flag. Mark where the flag fires. Swaps total?
- **T13.** Trace **all of selection sort** on the same `{9, 3, 7, 1}`. Swaps total? Comparisons total?
- **T14.** Trace **all of insertion sort** on the same `{9, 3, 7, 1}`. Shifts total? (A shift is one `a[j+1]=a[j]`.)
- **T15.** Trace insertion sort on the nearly-sorted `{1, 2, 4, 3, 5, 6}`. Shifts total? Then selection sort on the same array: comparisons total? Write one sentence on why the two numbers tell opposite stories about the same input.

---

<a name="answers"></a>
## Answers

### Recursion

**A1.** Descent stacks f(5)→f(4)→f(3)→f(2)→f(1)→f(0); f(0) returns 1; ascent: f(1)=1, f(2)=2, f(3)=6, f(4)=24, f(5)=**120**. Five boxes deep.

**A2.** Descent: sumTo(6) waits on (5) waits on (4) waits on (3) waits on (2) waits on (1)=1. Ascent: sumTo(2)=2+1=3, sumTo(3)=3+3=6, sumTo(4)=4+6=10, sumTo(5)=5+10=15, sumTo(6)=6+15=**21**.

**A3.** digitSum(9182) = 2 + dS(918) = 2 + (8 + dS(91)) = 2+8+(1 + dS(9)) = 2+8+1+**9** = 20. digits(9182) = 1 + digits(918) = 1+1+1+**1** = 4. Same depth (4 calls each) — both shrink by a factor of 10 per call; digitSum does more combining, digits doesn't.

**A4.** Descent: 4729→472→47→4; 4 < 10 is the base, prints nothing yet (base prints when reached: `4` prints at the base). Ascent prints: after returning from 4, the 47 frame prints `7`, then 472 prints `2`, then 4729 prints `9`. Output: `4729`. **All digits except the leading one print during ascent** — recursion-first-then-print is the whole mechanism.

**A5.** fib(5) tree: fib(5)→{fib(4)→{fib(3)→{fib(2), fib(1)}, fib(2)}, fib(3)→{fib(2), fib(1)}}. **Calls: 15.** Duplicates: fib(3) ×2, fib(2) ×3, fib(1) ×2. **Distinct subproblems: 5** (fib 1..5). The ratio 15/5 is the overlap tax.

**A6.** Calls: (n=5, a[4]=9≠2 → +0, recurse) → (n=4, a[3]=2 → +1) → (n=3, a[2]=2 → +1) → (n=2, a[1]=7 ≠2 → +0) → (n=1, a[0]=2 → +1) → (n=0 → base 0). Ascent: 0, 1, 2, 2, 2 → returns **3**.

### Searching

**A7.** Compare 42≠16, 7≠16, 19≠16, 16==16 → return index 3. **4 comparisons.**

**A8.** All five compared, none match → −1. **5 comparisons** (worst case, n=5).

**A9.** (0,6): mid=3, a[3]=19 → **found**. **1 comparison** — the average-looking case, caught on the first split. (log₂ 7 ≈ 2.8, so worst would be 3; this input is lucky.)

**A10.** (0,6): mid=3, 19>5 → left. (0,2): mid=1, 7>5 → left. (0,0): mid=0, 3<5 → lo=1. Now lo(1) > hi(0) → −1. **Absence is proved by the range emptying** — specifically by the last comparison (3<5) showing even the last candidate is too small; there is no "not found" message, only an empty range.

**A11.** x=57: (0,6,mid3,19<57)→(4,6,mid5,42<57)→(6,6,mid6,57) = **3**. x=3: (0,6,mid3,19>3)→(0,2,mid1,7>3)→(0,0,mid0,3) = **3**. Equal — both are the ⌈log₂ 7⌉ = 3 worst case; ends of the array are *not* lucky for binary search, the middle often is.

### Sorting

**A12.** Bubble, `{9,3,7,1}`: pass1: (9,3)sw, (9,7)sw, (9,1)sw → `3,7,1,9`; pass2: (3,7)ok, (7,1)sw → `3,1,7,9`; pass3: (3,1)sw → `1,3,7,9`; pass4: clean → **flag fires, stop**. Swaps: **6**. Without the flag, pass 4 still runs (5 more comparisons for nothing).

**A13.** Selection, `{9,3,7,1}`: start0: min 1(idx3), swap → `1,3,7,9`; start1: min 3(idx1), self; start2: min 7(idx2), self. Swaps: **1**. Comparisons: 3+2+1 = **6**, fixed — the opposite personality from A12's 6 swaps: selection pays in comparisons, bubble in swaps.

**A14.** Insertion, `{9,3,7,1}`: i1 key=3: 1 shift → `3,9,7,1`; i2 key=7: 1 shift → `3,7,9,1`; i3 key=1: 3 shifts → `1,3,7,9`. **Shifts: 5.**

**A15.** Insertion on `{1,2,4,3,5,6}`: only key=3 shifts one element (4). **1 shift.** Selection on the same: comparisons = 5+4+3+2+1 = **15** — unchanged, because selection never looks at the input's order. Sentence: *insertion's cost reads the data's shape (1 unit of disorder → 1 unit of work); selection's cost ignores it entirely — the same input is one algorithm's best case and another's average.*

---

## Where next

- [Debugging hunts](debugging.md): ten seeded bugs across all three parts.
- [Challenges](challenges.md): fifteen problems, recursion to sorting.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
