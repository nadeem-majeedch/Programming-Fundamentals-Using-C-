---
title: "Practice Bank — Basic Tier (40 problems)"
description: "Ba-01…Ba-40: loop mastery, patterns and digit work, then functions from first call to decomposed design — each with statement, topics, I/O, constraints, samples, graded hints, reference solution, and explanation."
---

# Basic tier — Ba-01 to Ba-40

> **Units first:** [Stage B — Control flow](../syllabus.md#stage-b-control-flow-units-4-6) (iteration, then functions).
> **Attempt protocol:** unchanged — 15 minutes before hints, one hint at a time, samples plus one self-invented test.

## Part 1 — Loop mastery (Ba-01…Ba-10)

### Ba-01 — Sum until a negative sentinel

**Difficulty:** ★★ · **Topics:** loops, sentinels, accumulators

Read integers until a **negative** number arrives (don't include it). Print the count and sum of the non-negative values.

**Input:** integers; guaranteed to end with a negative number.
**Output:** `count: N sum: S` (S fits in long long).
**Sample tests:** `5 10 3 -1` → `count: 3 sum: 18` · `-7` → `count: 0 sum: 0`
**Hints:** ① the loop condition reads *and* filters; ② the sentinel is excluded from both tallies.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long x, count = 0, sum = 0;
    while (cin >> x && x >= 0) {
        count++;
        sum += x;
    }
    cout << "count: " << count << " sum: " << sum << "\n";
    return 0;
}
```

**Explanation:** B-19's sentinel was a value (`0`); this one is a *class* of values (any negative) — the condition generalizes from equality to a predicate. *Distinct idea:* predicate sentinels.

---

### Ba-02 — Average with a first-seeded running min/max

**Difficulty:** ★★★ · **Topics:** loops, accumulators, extremes

Read n, then n integers. Print min, max, and average (two decimals). For n = 0 print `EMPTY`.

**Input:** n (0 ≤ n ≤ 10000), then n integers (−10⁹…10⁹).
**Output:** `min: a max: b avg: c` or `EMPTY`.
**Sample tests:** `4 3 9 1 7` → `min: 1 max: 9 avg: 5.00` · `0` → `EMPTY`
**Hints:** ① seed min/max from the *first* value inside the loop; ② one loop, three accumulators.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    long long n;
    cin >> n;
    if (n == 0) { cout << "EMPTY\n"; return 0; }
    long long mn, mx, sum = 0;
    cin >> mn; mx = mn; sum = mn;
    for (long long i = 2; i <= n; i++) {
        long long x;
        cin >> x;
        if (x < mn) mn = x;
        if (x > mx) mx = x;
        sum += x;
    }
    cout << "min: " << mn << " max: " << mx << " avg: "
         << fixed << setprecision(2) << (double)sum / n << "\n";
    return 0;
}
```

**Explanation:** the read-first-value-then-loop pattern (i from 2) eliminates the "have I seen one yet?" flag entirely — a cleaner idiom than B-37's boolean, worth comparing line by line. *Distinct idea:* seed-by-prefetch.

---

### Ba-03 — Reverse a number

**Difficulty:** ★★ · **Topics:** loops, digit processing

Read a positive integer; print it reversed (leading zeros vanish: 1200 → 21).

**Input:** one integer 1…2,000,000,000.
**Output:** one integer.
**Sample tests:** `1234` → `4321` · `1200` → `21` · `7` → `7`
**Hints:** ① `rev = rev*10 + n%10` while peeling.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n, rev = 0;
    cin >> n;
    while (n > 0) {
        rev = rev * 10 + n % 10;
        n /= 10;
    }
    cout << rev << "\n";
    return 0;
}
```

**Explanation:** the peel loop (B-31) gains a *build* step: each peeled digit becomes the new lowest digit of `rev`. Palindrome problems (Ba-13) stack on this. *Distinct idea:* peel-and-rebuild.

---

### Ba-04 — GCD by subtraction, then Euclid

**Difficulty:** ★★★ · **Topics:** loops, algorithms

Read two positive integers; print their GCD. Implement **Euclid's** method (`while (b) { r = a%b; a = b; b = r; }`), and in a comment explain why repeatedly subtracting the smaller from the larger would also work but is slower.

**Input:** two integers 1…10⁹.
**Output:** one integer.
**Sample tests:** `48 36` → `12` · `17 5` → `1` · `100 100` → `100`
**Hints:** ① when b hits 0, a holds the answer.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long a, b;
    cin >> a >> b;
    while (b != 0) {
        long long r = a % b;
        a = b;
        b = r;
        // Subtraction variant: replace (a,b) with (a-b, b) for a>b each pass.
        // It terminates at the same GCD but may need a%b steps just to chew
        // one multiple — Euclid leaps whole multiples per step.
    }
    cout << a << "\n";
    return 0;
}
```

**Explanation:** Euclid's loop is a three-variable rotation where the *remainder* is the new input. Comparing to the subtraction version makes "fewer, bigger steps" visible — complexity intuition before the course formalizes it. *Distinct idea:* loop as algorithm, not just counting.

---

### Ba-05 — Power without pow()

**Difficulty:** ★★ · **Topics:** loops, accumulators, overflow awareness

Read base b (−10…10) and exponent e (0…15). Compute b^e by repeated multiplication; print it. Note in a comment the largest e for which 10^e still fits in a 32-bit int.

**Input:** two integers.
**Output:** one integer.
**Sample tests:** `2 10` → `1024` · `10 9` → `1000000000` · `5 0` → `1`
**Hints:** ① result starts at 1 — the multiplicative identity.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long b, e;
    cin >> b >> e;
    long long result = 1;
    for (long long i = 0; i < e; i++) {
        result *= b;
    }
    // 10^9 fits in int (2,147,483,647); 10^10 does not — hence long long here.
    cout << result << "\n";
    return 0;
}
```

**Explanation:** the accumulator pattern generalizes from `+` (B-34) to `*`; the identity element 1 replaces 0. The constraint comment plants the overflow seed that Level-4 harvests. *Distinct idea:* multiplicative accumulation.

---

### Ba-06 — Collatz steps

**Difficulty:** ★★★ · **Topics:** loops, conditions inside loops

Read a positive integer n. Repeatedly: if even, n → n/2; if odd, n → 3n+1. Count steps until n becomes 1; print the count. (The Collatz conjecture says this always ends — every tested start does.)

**Input:** one integer 1…1,000,000.
**Output:** one integer step count.
**Sample tests:** `6` → `8` (6→3→10→5→16→8→4→2→1) · `1` → `0`
**Hints:** ① loop while n != 1; ② the parity test is *inside* the loop.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n;
    cin >> n;
    long long steps = 0;
    while (n != 1) {
        if (n % 2 == 0) n /= 2;
        else            n = 3 * n + 1;
        steps++;
    }
    cout << steps << "\n";
    return 0;
}
```

**Explanation:** a loop whose iteration count is *unknowable in advance* — not "n times" but "until an event". `long long` is not decoration: 3n+1 on odd values overshoots int range for starts under a million. *Distinct idea:* event-terminated numeric iteration.

---

### Ba-07 — First prime after n

**Difficulty:** ★★★ · **Topics:** loops, nested conditions, primality

Read n ≥ 1; print the smallest prime strictly greater than n. Test each candidate with trial division up to √candidate.

**Input:** one integer.
**Output:** one integer.
**Sample tests:** `8` → `11` · `1` → `2` · `13` → `17`
**Hints:** ① an outer "candidate search" loop; ② an inner divisibility test; ③ a flag or early break decides primality.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n;
    cin >> n;
    long long candidate = n + 1;
    while (true) {
        bool isPrime = true;
        for (long long d = 2; d * d <= candidate; d++) {
            if (candidate % d == 0) { isPrime = false; break; }
        }
        if (isPrime && candidate >= 2) {
            cout << candidate << "\n";
            break;
        }
        candidate++;
    }
    return 0;
}
```

**Explanation:** the nested structure — search loop outside, test loop inside — with `d*d <= candidate` as the √ bound and a flag surviving the inner break. This is the course's first genuinely *two-level* control-flow program. *Distinct idea:* search-until-found wrapping test-and-verdict.

---

### Ba-08 — Count digits, zeros, and evens in one pass

**Difficulty:** ★★ · **Topics:** loops, digit processing, multi-accumulator

Read a positive integer; print three counts in one pass: total digits, zeros among them, even digits among them.

**Input:** one integer 1…10¹⁸ (long long).
**Output:** `digits: d zeros: z evens: e`.
**Sample tests:** `30405` → `digits: 5 zeros: 2 evens: 3` · `7` → `digits: 1 zeros: 0 evens: 0`
**Hints:** ① three counters, one peel loop; ② zero is even — make sure it's counted once in each relevant tally, not twice for zeros.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n;
    cin >> n;
    int digits = 0, zeros = 0, evens = 0;
    while (n > 0) {
        int d = n % 10;
        digits++;
        if (d == 0) zeros++;
        if (d % 2 == 0) evens++;
        n /= 10;
    }
    cout << "digits: " << digits << " zeros: " << zeros
         << " evens: " << evens << "\n";
    return 0;
}
```

**Explanation:** one traversal, three independent tallies — the pattern that later becomes frequency counting (I-09, C-10). Zero counts as a digit, as a zero, *and* as an even; three different questions. *Distinct idea:* multi-tally single pass.

---

### Ba-09 — Fibonacci first k terms

**Difficulty:** ★★ · **Topics:** loops, sequences, two-state update

Read k (1–40). Print the first k Fibonacci numbers (1 1 2 3 5 …) space-separated on one line.

**Input:** one integer.
**Output:** one line, k terms.
**Sample tests:** `7` → `1 1 2 3 5 8 13`
**Hints:** ① keep only two variables — a and b; ② the update is `(a,b) → (b, a+b)`; separate output spacing carefully (no trailing space needed if you print the separator before terms 2…k).
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int k;
    cin >> k;
    long long a = 1, b = 1;
    for (int i = 0; i < k; i++) {
        if (i > 0) cout << " ";
        cout << a;
        long long next = a + b;
        a = b;
        b = next;
    }
    cout << "\n";
    return 0;
}
```

**Explanation:** the two-variable rotation computes the sequence in O(1) memory; `next` is the temporary that B-07's swap taught. Print-separator-before (not after) kills the trailing-space problem cleanly. *Distinct idea:* constant-memory sequence generation.

---

### Ba-10 — Menu loop with quit (number cruncher)

**Difficulty:** ★★ · **Topics:** loops, do-while, switch, interaction

Print a menu: `1-square 2-double 3-negate 0-quit`. Read a number x and a choice, apply the operation, print the result, and show the menu again — until choice 0.

**Input:** repeated lines: choice (0–3) and x (−1000…1000); ends with choice 0.
**Output:** result per operation, then `BYE`.
**Sample tests:** `1 5` → `25` · `2 -3` → `-6` · `3 7` → `-7` · `0` → `BYE`
**Hints:** ① do-while fits "show, act, repeat"; ② switch inside the loop.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int choice;
    double x;
    do {
        cin >> choice;
        if (choice == 0) break;
        cin >> x;
        switch (choice) {
            case 1: cout << x * x << "\n"; break;
            case 2: cout << 2 * x << "\n"; break;
            case 3: cout << -x    << "\n"; break;
            default: cout << "BAD\n";
        }
    } while (true);
    cout << "BYE\n";
    return 0;
}
```

**Explanation:** the do-while + switch menu is the skeleton of every interactive tool the course builds — the Level-5 capstones are this loop grown up. *Distinct idea:* the interactive shell loop.

---

## Part 2 — Patterns and digit work (Ba-11…Ba-20)

### Ba-11 — Number pyramid (centered)

**Difficulty:** ★★★ · **Topics:** loops, nested loops, patterns, spacing

Read rows r (1–9). Print a centered pyramid of row numbers:

```text
    1
   121
  12321
 1234321
```

**Input:** one integer.
**Output:** r lines.
**Hints:** ① per row: spaces, then ascending, then descending; ② the descending run reuses the ascending count minus one.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int r;
    cin >> r;
    for (int row = 1; row <= r; row++) {
        for (int s = 0; s < r - row; s++) cout << " ";
        for (int up = 1; up <= row; up++) cout << up;
        for (int dn = row - 1; dn >= 1; dn--) cout << dn;
        cout << "\n";
    }
    return 0;
}
```

**Explanation:** three inner loops per row — pad, ascend, descend — each with a bound derived from `row` and `r`. Composing dependent loops into a shape is the core pattern-printing skill; Ba-12's hollow version tests whether the *bounds* or the *content* varied. *Distinct idea:* per-row loop composition.

---

### Ba-12 — Hollow square outline

**Difficulty:** ★★ · **Topics:** loops, nested loops, boundary conditions

Read n (2–20). Print a hollow n×n square of `*`: border solid, interior spaces.

**Input:** one integer.
**Output:** n lines.
**Sample tests:** n = 4 → `****` / `*  *` / `*  *` / `****`
**Hints:** ① per cell: print `*` if on an edge, else space; ② the edge test is `row==1 || row==n || col==1 || col==n`.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    for (int row = 1; row <= n; row++) {
        for (int col = 1; col <= n; col++) {
            bool edge = row == 1 || row == n || col == 1 || col == n;
            cout << (edge ? '*' : ' ');
        }
        cout << "\n";
    }
    return 0;
}
```

**Explanation:** the cell-classification view — decide *per cell* rather than per run — scales to checkerboards and mazes later. B-39 printed runs; this prints decisions. *Distinct idea:* cell-predicate printing.

---

### Ba-13 — Palindrome check (number)

**Difficulty:** ★★ · **Topics:** loops, digit processing, conditions

Read a positive integer; print `YES` if it reads the same reversed, else `NO`.

**Input:** one integer 1…10¹⁸.
**Output:** `YES` or `NO`.
**Sample tests:** `1221` → `YES` · `1231` → `NO` · `7` → `YES`
**Hints:** ① build the reverse (Ba-03) and compare; or ② peel digits into the compare directly.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n, rev = 0, orig;
    cin >> orig;
    n = orig;
    while (n > 0) {
        rev = rev * 10 + n % 10;
        n /= 10;
    }
    cout << (rev == orig ? "YES" : "NO") << "\n";
    return 0;
}
```

**Explanation:** reuse of Ba-03's builder with one final equality — a small lesson in composing solutions from proven pieces. I-16 repeats the idea for *strings*, where the tool changes but the property doesn't. *Distinct idea:* property checking via derived value.

---

### Ba-14 — Number guessing game (full loop with attempt count)

**Difficulty:** ★★★ · **Topics:** loops, conditions, counters, interaction

The secret is a fixed 3-digit number 377 read as input first, then guesses. For each guess print `HIGHER`, `LOWER`, or `FOUND`. When found, print `FOUND` and `attempts: N`.

**Input:** secret, then guesses until the secret is guessed.
**Output:** one word per guess, then the attempt count.
**Sample tests:** secret `377`, guesses `400 300 377` → `LOWER` `HIGHER` `FOUND` `attempts: 3`
**Hints:** ① count attempts *including* the successful one; ② B-40 is the skeleton — the counter and the read-secret-first are new.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int secret, guess, attempts = 0;
    cin >> secret;
    while (true) {
        cin >> guess;
        attempts++;
        if (guess == secret) break;
        cout << (guess < secret ? "HIGHER" : "LOWER") << "\n";
    }
    cout << "FOUND\nattempts: " << attempts << "\n";
    return 0;
}
```

**Explanation:** attempts counted at read time (before the test) — placement matters, and off-by-one here is the classic. B-40 was the event loop; this adds bookkeeping and the separation of *data* (secret) from *process* (loop). *Distinct idea:* counting inside an event loop.

---

### Ba-15 — Full multiplication grid

**Difficulty:** ★★ · **Topics:** loops, nested loops, formatted output

Read n (1–12). Print the n×n multiplication grid: row i, column j shows `i*j` in width 4, rows separated by newlines.

**Input:** one integer.
**Output:** n lines, each with n right-aligned fields of width 4.
**Sample tests:** n = 3 → row `   1   2   3`, then `   2   4   6`, then `   3   6   9`.
**Hints:** ① `setw(4)` from `<iomanip>` per cell; ② outer rows, inner columns.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    int n;
    cin >> n;
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            cout << setw(4) << i * j;
        }
        cout << "\n";
    }
    return 0;
}
```

**Explanation:** B-36's single table row becomes a grid by nesting the row loop inside a column loop — the same i/j scaffolding that later walks matrices (I-11, L5 grids). `setw` per cell keeps columns aligned. *Distinct idea:* matrix-shaped nested output.

---

### Ba-16 — Digit frequency of one number

**Difficulty:** ★★★ · **Topics:** loops, digit processing, counting arrays (preview)

Read a positive integer; print how many times each digit 0–9 appears, one line per digit, skipping digits that don't appear.

**Input:** one integer 1…10¹⁸.
**Output:** lines `digit D: count` for present digits only, ascending.
**Sample tests:** `122333` → `digit 1: 1` `digit 2: 2` `digit 3: 3`
**Hints:** ① peel all digits first, tallying into ten counters — an array `int cnt[10]` makes this trivial; can you do it with ten plain variables? (Compare after.)
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n;
    cin >> n;
    int cnt[10] = {0};
    while (n > 0) {
        cnt[n % 10]++;
        n /= 10;
    }
    for (int d = 0; d <= 9; d++) {
        if (cnt[d] > 0) cout << "digit " << d << ": " << cnt[d] << "\n";
    }
    return 0;
}
```

**Explanation:** the tally-array is a preview of Unit 09 — but the *problem structure* (map values to slots, count, report) is pure loop thinking, doable with ten named variables if arrays haven't arrived yet. *Distinct idea:* direct-indexed tallying.

---

### Ba-17 — Coin change, minimal coins for arbitrary denominations

**Difficulty:** ★★★ · **Topics:** loops, greedy, conditions

Read amount (1–10000) and then 4 denominations (each ≥1, given largest first). Print the number of coins used by the greedy approach, or `IMPOSSIBLE` if greedy leaves a remainder.

**Input:** amount, then 4 integers.
**Output:** one integer or `IMPOSSIBLE`.
**Sample tests:** `87 50 25 10 1` → `5` (50+25+10+1+1) · `6 4 3 2 1` → `IMPOSSIBLE`? — no: 4+2 = 2 coins. Careful: greedy takes one 4, leaves 2, takes one 2 → `2`.
**Hints:** ① loop the denominations; ② after the loop, remainder must be 0.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long amt;
    int coins = 0;
    cin >> amt;
    for (int i = 0; i < 4; i++) {
        long long d;
        cin >> d;
        coins += amt / d;
        amt %= d;
    }
    if (amt == 0) cout << coins << "\n";
    else          cout << "IMPOSSIBLE\n";
    return 0;
}
```

**Explanation:** B-30's fixed ladder becomes a loop over *data* — the algorithm is unchanged; the denominations are input. The remainder test exposes greedy's boundary honestly (the sample's 6 with {4,3,2,1} resolves greedily, but sets like `6 4 3 1` fail greedy: 4+1+1 = 3 coins vs 3+3 = 2 — stated as an extension: find such a case). *Distinct idea:* parameterized greedy with failure detection.

---

### Ba-18 — Armstrong numbers in a range

**Difficulty:** ★★★ · **Topics:** loops, nested loops, digit processing

Read lo, hi (1 ≤ lo ≤ hi ≤ 100000). Print all Armstrong numbers in the range — numbers equal to the sum of their digits each raised to the digit-count power (153 = 1³+5³+3³).

**Input:** two integers.
**Output:** one per line, ascending; if none, print `NONE`.
**Range truth:** 1–9, 153, 370, 371, 407 (3-digit), 1634, 8208, 9474 (4-digit), 54748, 92727, 93084 (5-digit).
**Hints:** ① outer loop candidates; ② inner loop: count digits, then sum digits^digitCount; ③ `pow` returns double — build integer powers with a small loop instead.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int lo, hi;
    cin >> lo >> hi;
    bool any = false;
    for (int n = lo; n <= hi; n++) {
        int digits = 0, t = n;
        while (t > 0) { digits++; t /= 10; }
        long long sum = 0;
        t = n;
        while (t > 0) {
            int d = t % 10, p = 1;
            for (int i = 0; i < digits; i++) p *= d;
            sum += p;
            t /= 10;
        }
        if (sum == n) { cout << n << "\n"; any = true; }
    }
    if (!any) cout << "NONE\n";
    return 0;
}
```

**Explanation:** three nested levels — candidate loop, digit loops, power loop — each doing one job. The integer-power inner loop avoids `pow`'s floating-point rounding, a real bug source at exactly these sizes. *Distinct idea:* three-level composition with an integer power helper inline.

---

### Ba-19 — Zigzag sum (alternating signs)

**Difficulty:** ★★ · **Topics:** loops, accumulators, sign alternation

Read n (1–1000) and then n integers. Print their alternating-sign sum: first +, second −, third +, …

**Input:** n, then n integers (−1000…1000).
**Output:** one integer.
**Sample tests:** `4 1 2 3 4` → `-2` (1−2+3−4) · `3 10 10 10` → `10`
**Hints:** ① a sign variable flipped each pass, or `i % 2` as the sign selector.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    long long sum = 0;
    for (int i = 0; i < n; i++) {
        long long x;
        cin >> x;
        sum += (i % 2 == 0) ? x : -x;
    }
    cout << sum << "\n";
    return 0;
}
```

**Explanation:** position-dependent accumulation — the loop index itself participates in the arithmetic. The `i%2` selector is the seed of later "even-indexed" element work on arrays. *Distinct idea:* index-driven sign.

---

### Ba-20 — Collatz peak

**Difficulty:** ★★★ · **Topics:** loops, extremes over an unknown trajectory

Read n (1…1,000,000). Run the Collatz sequence (Ba-06's rules) and print two things: the number of steps to reach 1, and the **peak value** seen along the way (including the start, including 1).

**Input:** one integer.
**Output:** `steps: S peak: P`.
**Sample tests:** `6` → `steps: 8 peak: 16` · `1` → `steps: 0 peak: 1` · `27` → `steps: 111 peak: 9232`
**Hints:** ① Ba-06's loop plus a running maximum (Ba-02's seeding); ② peak can dwarf the start — long long.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n, steps = 0, peak = n;
    cin >> n;
    while (n != 1) {
        if (n % 2 == 0) n /= 2;
        else            n = 3 * n + 1;
        if (n > peak) peak = n;
        steps++;
    }
    cout << "steps: " << steps << " peak: " << peak << "\n";
    return 0;
}
```

**Explanation:** two analytics over one trajectory — Ba-06 supplied the walk, Ba-02 the extreme-tracking. The 27→9232 sample is the hook: short starts can spike enormous peaks, which is why the type matters. *Distinct idea:* composing a walk with an analyzer.

---

## Part 3 — Functions, first contact (Ba-21…Ba-30)

### Ba-21 — First function: square and cube

**Difficulty:** ★ · **Topics:** functions, parameters, return

Write `int square(int x)` and `int cube(int x)`, then read one integer and print `square: s` and `cube: c` using them.

**Input:** one integer −1000…1000.
**Output:** two lines.
**Sample tests:** `3` → `square: 9` `cube: 27`
**Hints:** ① a function's body is a mini-program with a return value; ② call sites are just expressions.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int square(int x) { return x * x; }
int cube(int x)   { return square(x) * x; }

int main() {
    int n;
    cin >> n;
    cout << "square: " << square(n) << "\n";
    cout << "cube: "   << cube(n)   << "\n";
    return 0;
}
```

**Explanation:** `cube` calls `square` — functions composing functions from day one, not a later refinement. The parameter is a fresh local; the argument's value travels in. *Distinct idea:* call-chaining from the first lesson.

---

### Ba-22 — Temperature desk as a function pair

**Difficulty:** ★ · **Topics:** functions, double math, reuse

Write `double toF(double c)` and `double toC(double f)` (exact inverses). Read a Celsius value; print F then, converting that F back, print C — it should match the input to two decimals.

**Input:** one Celsius value −89.0…57.0.
**Output:** two lines, two decimals.
**Sample tests:** `100` → `212.00` then `100.00`
**Hints:** ① the round-trip is the test: C → F → C must land back home.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;

double toF(double c) { return c * 9.0 / 5.0 + 32.0; }
double toC(double f) { return (f - 32.0) * 5.0 / 9.0; }

int main() {
    double c;
    cin >> c;
    cout << fixed << setprecision(2) << toF(c) << "\n" << toC(toF(c)) << "\n";
    return 0;
}
```

**Explanation:** inverse functions are the strongest cheap test in beginner code — the round-trip equality catches formula errors instantly. The nested call `toC(toF(c))` reads like the data's journey. *Distinct idea:* functions as verifiable inverses.

---

### Ba-23 — Boolean-returning predicates: isEven, isLeap

**Difficulty:** ★★ · **Topics:** functions, bool returns, conditions

Write `bool isEven(int)` and `bool isLeap(int year)` (full Gregorian rule). Read a year; print `leap` or `common`; read an integer; print `even` or `odd`.

**Input:** one year (1–3000) and one integer (−1000…1000).
**Output:** two words on separate lines.
**Sample tests:** `2024 7` → `leap` `odd` · `1900 8` → `common` `even`
**Hints:** ① return the condition *directly* — `return year % 4 == 0 && ...` — no if needed.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

bool isEven(int x) { return x % 2 == 0; }

bool isLeap(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

int main() {
    int year, n;
    cin >> year >> n;
    cout << (isLeap(year) ? "leap" : "common") << "\n";
    cout << (isEven(n) ? "even" : "odd") << "\n";
    return 0;
}
```

**Explanation:** a function that returns a bool *is* a named condition — usable directly in `if` and here even in the conditional operator. B-23's leap rule becomes reusable vocabulary. *Distinct idea:* predicates as named, reusable conditions.

---

### Ba-24 — Max of two, then max of three, by reuse

**Difficulty:** ★ · **Topics:** functions, reuse, overloading-free design

Write `int maxOf2(int a, int b)`. Write `int maxOf3(int a, int b, int c)` **calling maxOf2 twice**. Read three integers; print the max.

**Input:** three integers −10⁶…10⁶.
**Output:** one integer.
**Sample tests:** `4 9 2` → `9` · `-5 -2 -9` → `-2`
**Hints:** ① `maxOf3(a,b,c) = maxOf2(maxOf2(a,b), c)`.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int maxOf2(int a, int b) { return (a > b) ? a : b; }

int maxOf3(int a, int b, int c) {
    return maxOf2(maxOf2(a, b), c);
}

int main() {
    int a, b, c;
    cin >> a >> b >> c;
    cout << maxOf3(a, b, c) << "\n";
    return 0;
}
```

**Explanation:** building a three-way max *from* a two-way max is the smallest possible example of layered abstraction — the same move that grows `maxOfN` over an array in I-06. *Distinct idea:* composing functions to raise arity.

---

### Ba-25 — void function: printDivider and printBanner

**Difficulty:** ★ · **Topics:** void functions, parameters, output design

Write `void printDivider(int n)` (n dashes) and `void printBanner(string title)` (a line of `=` the title's length, the title, another line). Read n and a one-word title; call both.

**Input:** n (1–60) and one word (1–30 chars).
**Output:** banner then divider.
**Sample tests:** `12 REPORT` → `======` ×6 (6 equals) / `REPORT` / `------------`
**Hints:** ① `string(n, '-')` builds the dash run; ② `title.size()` for the equals count.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

void printDivider(int n) { cout << string(n, '-') << "\n"; }

void printBanner(string title) {
    cout << string(title.size(), '=') << "\n"
         << title << "\n"
         << string(title.size(), '=') << "\n";
}

int main() {
    int n; string title;
    cin >> n >> title;
    printBanner(title);
    printDivider(n);
    return 0;
}
```

**Explanation:** void functions that *format* are the first reusable UI kit — the course's labs later share exactly these helpers. A function can own presentation, not just computation. *Distinct idea:* presentation functions.

---

### Ba-26 — Pass-by-value proof

**Difficulty:** ★★★ · **Topics:** functions, pass-by-value, scope

Write `void tryToZero(int x) { x = 0; }`. In main, read n, call `tryToZero(n)`, then print n. Explain in a comment what was printed and why the copy's change never traveled back.

**Input:** one integer 1…100.
**Output:** the unchanged value.
**Sample tests:** `42` → `42`
**Hints:** ① the parameter is a *copy* made at call time.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void tryToZero(int x) {
    x = 0;   // dies here: x was a copy, destroyed at the closing brace
}

int main() {
    int n;
    cin >> n;
    tryToZero(n);
    cout << n << "\n";   // prints the original — value semantics
    return 0;
}
```

**Explanation:** the copy semantics demonstrated by a function that *tries* and fails to mutate — the negative-space proof. The Level-4 pointer module later shows the two honest ways to let a function change its caller's data (return, or reference). *Distinct idea:* value semantics as an observable property.

---

### Ba-27 — Scope shadowing demonstration

**Difficulty:** ★★ · **Topics:** functions, scope, shadowing

Given this code, predict the output **on paper first**, then run:

```cpp
int x = 10;              // global
void bump() { x++; }     // touches the global
int main() {
    int x = 100;         // shadows the global inside main
    bump();
    cout << x << "\n";   // line A
    ::x++;
    cout << x << "\n";   // line B
    cout << ::x << "\n"; // line C
}
```

**Input:** none.
**Output:** three lines — `100`, `100`, `12` (verify!).
**Hints:** ① which `x` does each line name? ② `::x` is the explicit global.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int x = 10;

void bump() { x++; }     // the global's x: 10 -> 11

int main() {
    int x = 100;         // local shadow
    bump();
    cout << x << "\n";   // 100 — the local, untouched
    ::x++;
    cout << x << "\n";   // 100 — still the local
    cout << ::x << "\n"; // 12 — global went 10 -> 11 -> 12
    return 0;
}
```

**Explanation:** three observers, two objects — the output only makes sense once the two `x`es are distinguished. The course's rule (no new globals; pass parameters) exists precisely because this confusion is *cheap to create and expensive to debug*. *Distinct idea:* name resolution as a runtime trace.

---

### Ba-28 — Default arguments: a flexible greeting

**Difficulty:** ★★ · **Topics:** functions, default arguments

Write `void greet(string name, string punctuation = "!")` and call it three ways: one argument, two arguments, and with `"?"`. Print each call's result.

**Input:** none — hardcode three calls with names `Ayesha`, `Bilal`, `Sara`.
**Output:** `Hello, Ayesha!` / `Hello, Bilal.` / `Hello, Sara?`
**Hints:** ① defaults live in the *declaration*; ② rightmost parameters only.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

void greet(string name, string punctuation = "!") {
    cout << "Hello, " << name << punctuation << "\n";
}

int main() {
    greet("Ayesha");          // default applies
    greet("Bilal", ".");      // override
    greet("Sara", "?");       // override
    return 0;
}
```

**Explanation:** defaults shrink call sites for the common case while keeping flexibility — a mild convenience feature, but it plants the *interface* idea: the caller's view vs the function's obligations. *Distinct idea:* call-site economics.

---

### Ba-29 — Function overloading: area of circle vs rectangle

**Difficulty:** ★★ · **Topics:** functions, overloading

Write `double area(double radius)` (circle, πr²) and `double area(double length, double width)` (rectangle). Read `c 3` or `r 4 5` (shape letter then values) and print the area to two decimals.

**Input:** a char then one or two numbers.
**Output:** one number, two decimals.
**Sample tests:** `c 2` → `12.57` · `r 4 5` → `20.00`
**Hints:** ① same name, different parameter lists — the compiler picks by count/types.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
#include <cmath>
using namespace std;

double area(double radius)            { return M_PI * radius * radius; }
double area(double l, double w)       { return l * w; }

int main() {
    char shape;
    double a, b;
    cin >> shape >> a;
    if (shape == 'r') {
        cin >> b;
        cout << fixed << setprecision(2) << area(a, b) << "\n";
    } else {
        cout << fixed << setprecision(2) << area(a) << "\n";
    }
    return 0;
}
```

**Explanation:** overloading keeps one *concept* (`area`) under one name while signatures distinguish the shapes. `M_PI` needs `<cmath>` on POSIX compilers; if your toolchain objects, `3.14159265358979` is the course's stated fallback — say so in a comment. *Distinct idea:* one concept, many signatures.

---

### Ba-30 — Decomposition drill: bill with tip and split

**Difficulty:** ★★★ · **Topics:** functions, decomposition, main as coordinator

Read bill amount, tip percent (0–100), and number of people (1–20). Print total with tip and per-person share (two decimals each). **Structure it:** `double withTip(double bill, int pct)` and `double perPerson(double total, int people)`, with main only reading, calling, printing.

**Input:** `1200 12 4`
**Output:** `total: 1344.00` / `each: 336.00`
**Hints:** ① main should be four statements; ② perPerson receives withTip's *result*.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;

double withTip(double bill, int pct)  { return bill * (1.0 + pct / 100.0); }
double perPerson(double total, int n) { return total / n; }

int main() {
    double bill; int pct, people;
    cin >> bill >> pct >> people;
    double total = withTip(bill, pct);
    cout << fixed << setprecision(2)
         << "total: " << total << "\n"
         << "each: "  << perPerson(total, people) << "\n";
    return 0;
}
```

**Explanation:** main as *coordinator* — read, delegate, print — is the architecture rule the course keeps from here to the capstone. The `pct / 100.0` decimal literal is B-05's promotion lesson recurring inside a function. *Distinct idea:* layered computation with a thin main.

---

## Part 4 — Functions in design (Ba-31…Ba-40)

### Ba-31 — isPrime as a function

**Difficulty:** ★★ · **Topics:** functions, loops inside functions, primality

Write `bool isPrime(long long n)` (trial division to √n, with n < 2 false). Read n; print `PRIME` or `COMPOSITE` (n ≥ 2 but not prime), or `NEITHER` (n < 2).

**Input:** one integer −10…10¹².
**Output:** one word.
**Sample tests:** `97` → `PRIME` · `91` → `COMPOSITE` (7×13) · `1` → `NEITHER` · `0` → `NEITHER`
**Hints:** ① the function owns the loop; main owns only I/O and wording.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

bool isPrime(long long n) {
    if (n < 2) return false;
    for (long long d = 2; d * d <= n; d++) {
        if (n % d == 0) return false;
    }
    return true;
}

int main() {
    long long n;
    cin >> n;
    if (n < 2)          cout << "NEITHER\n";
    else if (isPrime(n)) cout << "PRIME\n";
    else                 cout << "COMPOSITE\n";
    return 0;
}
```

**Explanation:** early `return false` replaces Ba-07's flag — inside a function, the return *is* the flag, and the code reads shorter. Classifying 1 as neither is a boundary rule the samples enforce. *Distinct idea:* flags retire when functions arrive.

---

### Ba-32 — Ranged prime printer via reuse

**Difficulty:** ★★ · **Topics:** functions, reuse, loops

Using Ba-31's `isPrime` unchanged, read lo, hi (1 ≤ lo ≤ hi ≤ 100000) and print all primes in range, one per line, or `NONE`.

**Input:** two integers.
**Output:** primes or `NONE`.
**Sample tests:** `10 30` → `11 13 17 19 23 29` (one per line)
**Hints:** ① zero new math — the loop and the word choice live in main.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

bool isPrime(long long n) {
    if (n < 2) return false;
    for (long long d = 2; d * d <= n; d++) if (n % d == 0) return false;
    return true;
}

int main() {
    int lo, hi;
    cin >> lo >> hi;
    bool any = false;
    for (int n = lo; n <= hi; n++) {
        if (isPrime(n)) { cout << n << "\n"; any = true; }
    }
    if (!any) cout << "NONE\n";
    return 0;
}
```

**Explanation:** the reuse problem: Ba-07 inlined its test; here the same search is *built from* a written-once function. When the next problem needs primality (and the Level-4 recursion set will), it costs nothing. *Distinct idea:* the function library habit.

---

### Ba-33 — Digit-count and digit-sum functions

**Difficulty:** ★ · **Topics:** functions, digit processing, pair of returns

Write `int digitCount(long long n)` and `int digitSum(long long n)`. Read n; print `digits: d sum: s`.

**Input:** one integer 1…10¹⁸.
**Output:** one line.
**Sample tests:** `4729` → `digits: 4 sum: 22`
**Hints:** ① two peel loops, one per function — resist the urge to share state.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int digitCount(long long n) {
    int c = 0;
    while (n > 0) { c++; n /= 10; }
    return c;
}

int digitSum(long long n) {
    int s = 0;
    while (n > 0) { s += n % 10; n /= 10; }
    return s;
}

int main() {
    long long n;
    cin >> n;
    cout << "digits: " << digitCount(n)
         << " sum: "   << digitSum(n) << "\n";
    return 0;
}
```

**Explanation:** two traversals instead of one shared pass — each function is independently testable, and clarity outranks the micro-optimization. Ba-08's fused version is the honest contrast to discuss. *Distinct idea:* independent single-purpose functions.

---

### Ba-34 — Validation function: readMark

**Difficulty:** ★★★ · **Topics:** functions, validation, do-while, references preview

Write `int readMark()` that *loops* reading an integer until it lands in 0–100, re-prompting `retry: ` on failure, then returns it. Main reads three marks through the function and prints their average (two decimals).

**Input:** a stream of integers; the first three valid ones (each 0–100) end the reads — invalid ones may precede them.
**Output:** `retry: ` before each re-read, then `avg: X`.
**Sample tests:** `150 -1 80 90 70` → `retry: retry: avg: 80.00`
**Hints:** ① do-while: read, test, maybe repeat; ② the function owns the *whole* conversation for one mark.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;

int readMark() {
    int m;
    do {
        cin >> m;
        if (m < 0 || m > 100) cout << "retry: ";
    } while (m < 0 || m > 100);
    return m;
}

int main() {
    double sum = 0;
    for (int i = 0; i < 3; i++) sum += readMark();
    cout << fixed << setprecision(2) << "avg: " << sum / 3 << "\n";
    return 0;
}
```

**Explanation:** validation concentrated *inside* the function means every caller inherits it for free — the pattern the robustness module later formalizes into layers. `readMark`'s loop is the first function that *converses* with the user. *Distinct idea:* encapsulated input discipline.

---

### Ba-35 — Swap via reference parameters

**Difficulty:** ★★★ · **Topics:** functions, references, mutation

Write `void swapVals(int& a, int& b)` using a temp. Read two integers, print them, swap via the function, print again.

**Input:** two integers −1000…1000.
**Output:** the pair before and after, space-separated.
**Sample tests:** `3 8` → `3 8` then `8 3`
**Hints:** ① the `&` makes the parameter an alias — now writes travel back.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void swapVals(int& a, int& b) {
    int temp = a;
    a = b;
    b = temp;
}

int main() {
    int x, y;
    cin >> x >> y;
    cout << x << " " << y << "\n";
    swapVals(x, y);
    cout << x << " " << y << "\n";
    return 0;
}
```

**Explanation:** the same three-line dance as B-07, now *through a function* — possible only because `&` parameters are aliases for the caller's variables. Ba-26's failed mutation is the before; this is the after. *Distinct idea:* out-parameters by reference.

---

### Ba-36 — Statistical trio via reference out-params

**Difficulty:** ★★★ · **Topics:** functions, references, multiple results

Write `void analyze(int a, int b, int c, int& mn, int& mx, int& sum)` filling the three out-params in one pass. Read three integers; print `min: m max: M sum: s`.

**Input:** three integers −10⁶…10⁶.
**Output:** one line.
**Sample tests:** `4 9 1` → `min: 1 max: 9 sum: 14`
**Hints:** ① seed mn/mx from the first parameter; ② three returns are impossible — references are the C++ answer.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void analyze(int a, int b, int c, int& mn, int& mx, int& sum) {
    mn = a; mx = a; sum = a;
    if (b < mn) mn = b;  if (b > mx) mx = b;
    if (c < mn) mn = c;  if (c > mx) mx = c;
    sum += b + c;
}

int main() {
    int a, b, c, mn, mx, sum;
    cin >> a >> b >> c;
    analyze(a, b, c, mn, mx, sum);
    cout << "min: " << mn << " max: " << mx << " sum: " << sum << "\n";
    return 0;
}
```

**Explanation:** one function, three results — the reference-parameter idiom for multi-output functions, used constantly in the labs (e.g., payroll and queue simulators). Contrast with returning a struct (I-29): same need, two tools. *Distinct idea:* multi-result via aliases.

---

### Ba-37 — Menu calculator, function-organized

**Difficulty:** ★★ · **Topics:** functions, menus, switch, decomposition

Rewrite Ba-10's menu with each operation as a function (`double applySquare(double)`, `applyDouble`, `applyNegate`) and main reduced to menu-loop + dispatch.

**Input:** repeated `choice x` lines, ending with choice 0.
**Output:** per-operation results, then `BYE`.
**Sample tests:** `1 4` → `16` · `3 -2` → `2` · `0` → `BYE`
**Hints:** ① the switch *dispatches*; the functions *compute*; main *coordinates*.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

double applySquare(double x) { return x * x; }
double applyDouble(double x) { return 2 * x; }
double applyNegate(double x) { return -x;   }

int main() {
    int choice;
    double x;
    do {
        cin >> choice;
        if (choice == 0) break;
        cin >> x;
        switch (choice) {
            case 1: cout << applySquare(x) << "\n"; break;
            case 2: cout << applyDouble(x) << "\n"; break;
            case 3: cout << applyNegate(x) << "\n"; break;
            default: cout << "BAD\n";
        }
    } while (true);
    cout << "BYE\n";
    return 0;
}
```

**Explanation:** the refactor of Ba-10 is deliberately trivial in behavior so the *structural* change is the whole point — same output, three reusable operations, a main that reads like the menu it serves. *Distinct idea:* dispatch vs compute separation.

---

### Ba-38 — Recursive-feeling loop: factorial both ways

**Difficulty:** ★★ · **Topics:** functions, loops, iteration vs recursion (preview)

Write `long long factLoop(int n)` (a loop) and `long long factRec(int n)` (recursion: n ≤ 1 → 1, else n·factRec(n−1)). Read n (0–20); print both results — they must match.

**Input:** one integer.
**Output:** two equal numbers on one line.
**Sample tests:** `5` → `120 120` · `0` → `1 1` · `20` → `2432902008176640000 2432902008176640000`
**Hints:** ① the recursive version needs a *base case* guard first; ② 20! overflows int by a factor of ~10¹² — long long required.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

long long factLoop(int n) {
    long long r = 1;
    for (int i = 2; i <= n; i++) r *= i;
    return r;
}

long long factRec(int n) {
    if (n <= 1) return 1;
    return n * factRec(n - 1);
}

int main() {
    int n;
    cin >> n;
    cout << factLoop(n) << " " << factRec(n) << "\n";
    return 0;
}
```

**Explanation:** the same computation in two shapes — the recursion is a *preview* (Unit 13 owns it), planted here so the formal lesson lands on familiar ground. The overflow comment explains why the constraint stops at 20. *Distinct idea:* dual implementations as mutual verification.

---

### Ba-39 — Text stats functions: countVowels, countWords (preview)

**Difficulty:** ★★ · **Topics:** functions, strings, traversal

Write `int countVowels(string s)` (aeiou, case-insensitive) and `int countWords(string s)` (space-separated runs). Read one line; print `vowels: v words: w`.

**Input:** one line, up to 200 chars, words separated by single spaces, letters and spaces only.
**Output:** one line.
**Sample tests:** `The Quick Brown Fox` → `vowels: 5 words: 4` · `a` → `vowels: 1 words: 1`
**Hints:** ① vowels: index loop + tolower; ② words: a character is a word-start if it's not a space *and* (it's first *or* the previous was a space).
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <cctype>
using namespace std;

int countVowels(string s) {
    int v = 0;
    for (size_t i = 0; i < s.size(); i++) {
        char c = tolower(s[i]);
        if (c=='a'||c=='e'||c=='i'||c=='o'||c=='u') v++;
    }
    return v;
}

int countWords(string s) {
    int w = 0;
    for (size_t i = 0; i < s.size(); i++) {
        bool isStart = s[i] != ' ' && (i == 0 || s[i-1] == ' ');
        if (isStart) w++;
    }
    return w;
}

int main() {
    string line;
    getline(cin, line);
    cout << "vowels: " << countVowels(line)
         << " words: " << countWords(line) << "\n";
    return 0;
}
```

**Explanation:** the word-start rule is a *boundary condition on characters* — the same shape of thinking as B-27's range edges, applied to text. Both functions are pure (input → return), which is why they test so easily. *Distinct idea:* character-boundary predicates.

---

### Ba-40 — The toolkit functions exam (composite)

**Difficulty:** ★★★ · **Topics:** functions, composition, dispatch

Write four functions: `long long gcd(long long, long long)` (Euclid), `long long lcm(long long, long long)` (a/gcd·b), `bool isPerfect(long long)` (sum of proper divisors equals n), and `int digitRev(long long)`-style `long long reverseNum(long long)`. Read `op a b` where op is one of `g l` (gcd, lcm) or `p r` (perfect, reverse — a only).

**Input:** one op line as specified (b present only for g/l).
**Output:** the result; for perfect, print `YES`/`NO`.
**Sample tests:** `g 48 36` → `12` · `l 4 6` → `12` · `p 28` → `YES` · `r 1200` → `21`
**Hints:** ① lcm = a / gcd(a,b) * b — divide first to avoid overflow; ② perfect: sum divisors d < n with n%d==0; ③ reuse, don't rewrite.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

long long gcd(long long a, long long b) {
    while (b != 0) { long long r = a % b; a = b; b = r; }
    return a;
}

long long lcm(long long a, long long b) { return a / gcd(a, b) * b; }

bool isPerfect(long long n) {
    if (n < 2) return false;
    long long sum = 1;
    for (long long d = 2; d * d <= n; d++) {
        if (n % d == 0) { sum += d; if (d != n / d) sum += n / d; }
    }
    return sum == n;
}

long long reverseNum(long long n) {
    long long r = 0;
    while (n > 0) { r = r * 10 + n % 10; n /= 10; }
    return r;
}

int main() {
    char op; long long a, b = 0;
    cin >> op >> a;
    if (op == 'g' || op == 'l') cin >> b;
    if (op == 'g') cout << gcd(a, b) << "\n";
    else if (op == 'l') cout << lcm(a, b) << "\n";
    else if (op == 'p') cout << (isPerfect(a) ? "YES" : "NO") << "\n";
    else cout << reverseNum(a) << "\n";
    return 0;
}
```

**Explanation:** four proven algorithms under one dispatcher — this file *is* the habit the Menu-Driven Utility Toolkit mini-project scales up. The `d != n/d` guard counts square-root divisors once; the lcm divide-first ordering is an overflow lesson stated in one line. *Distinct idea:* the personal function library.

---

**Tier check:** 40 problems · Ba-01–Ba-40 · tick [the checklist](index.md) as you clear each one, then climb to [intermediate.md](intermediate.md).
