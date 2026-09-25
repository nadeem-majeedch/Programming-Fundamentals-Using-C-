---
title: "Iteration Exercises"
description: "32 progressive exercises on loops — counters, accumulators, sentinels, validation, nested loops, digits, primes, and patterns. Solutions separated at the end."
---

# Iteration Exercises (32)

> [← Module home](index.md) · ★ = first pass · ★★ = needs the idioms · ★★★ = combines ideas

**How to use this page.** Attempt each exercise for at least 15 minutes before looking at its solution. Solutions are grouped in a [separated section at the end](#solutions-s1--s32) — each exercise links to its own solution so you don't accidentally see the next answer. For every exercise, dry-run your loop on paper before compiling; the trace-table habit from [Lesson 1 §2](lesson-1-while.md#2-the-while-loop--anatomy) is the whole skill.

Programs may use everything from Units 01–04: variables, decisions, `cin`/`cout`, `switch`. Loop style is your choice unless the exercise names one.

---

## Part A — `while` mechanics (★, E1–E8)

**E1.** Print the numbers 1 to 10, one per line, using a `while` loop. Then print them all on one line, space-separated, with `10` followed by a newline.

**E2.** Print the even numbers from 2 to 20, one per line. Write it twice: once with a counter that skips odds via `if`, once by stepping the counter by 2. Which version would you show a friend, and why?

**E3.** Read `n` (assume 1–20), print a countdown `n, n-1, ..., 1` and then `Liftoff`. Dry-run it for `n = 3` in a full trace table before coding.

**E4.** Compute the sum `1 + 2 + ... + n` with a `while` loop. Show your dry-run table for `n = 4`. Then state the total for `n = 100` *without* running the program — and verify it.

**E5.** Read exactly 5 integers and print their sum and average. Use a `while` loop with a counter (the count is known — `for` comes later, but write this one with `while` to feel what `for` will save you).

**E6.** Read 6 integers. Count how many are positive and how many are negative, and print the sum of the positives only. (Zero is neither.) One loop, two counters, one accumulator.

**E7.** Compute the product `1 × 2 × ... × n` with a `while` loop for `n` between 1 and 10. What must the accumulator start at, and what happens if it starts at 0?

**E8.** Diagnose without running. For each loop, name which part of the rule of three (initialization / condition / update) is broken and what the symptom will be:
(a) `while (k < 5) { std::cout << k; }` — `k` initialized to 0 before.
(b) `int k = 10; while (k > 0) { std::cout << k; k = k + 1; }`
(c) `while (k <= 3) { std::cout << k; k = k + 1; }` — `k` never declared.

---

## Part B — `for` and the idioms (★★, E9–E16)

**E9.** Rewrite your E1 loop as a `for`. Write down exactly where each of the three parts went. Then do the same for your E3 countdown.

**E10.** Sum the squares `1² + 2² + ... + n²` with a `for` loop. What is the total for `n = 5`? (Dry run first; the check value is in the [solution](#s10--sum-of-squares).)

**E11.** Read `n`, then `n` marks (0–100, assume valid). Print the class average and the number of fails (`< 40`). One pass, accumulator + counter. Trace for `n = 4`, marks `55 38 91 40`.

**E12.** Read `n`, then `n` temperatures (any integer, including negatives). Print the highest and lowest. Use the first-value champion — no `max = 0` shortcuts. Trace for `n = 5`, values `-8 12 3 -15 7`.

**E13.** Read `k` and print its multiplication table from `1 × k` to `10 × k`, formatted as `3 x 4 = 12` per line.

**E14.** Sum the even numbers from 1 to 100. Write two versions: (a) loop 1–100 with an `if` filter, (b) loop 2, 4, ..., 100 stepping by 2. Trace both for the first 3 passes. Which does fewer condition checks in total?

**E15.** For each loop, state exactly which values the body sees (the pass set) and how many passes run, for `n = 5`. Which two are equivalent? Which is the off-by-one bug, and what is its correct exit sentence?
(a) `for (int i = 1; i <= n; i++)`
(b) `for (int i = 0; i < n; i++)`
(c) `for (int i = 1; i < n; i++)`

**E16.** Read `n`, then `n` integers. Count how many are divisible by both 3 and 5, and how many are divisible by neither. Print both counts and their sum as a check (what must the two counts plus "divisible by exactly one" add up to?).

---

## Part C — `break`, `continue`, sentinels, validation (★★–★★★, E17–E24)

**E17.** Read marks one per line until the sentinel `-1`, then print how many marks, their total, and their average (guard the division). Use the prime-read rhythm. Trace inputs `60 75 -1`.

**E18.** Rewrite E17 with the `while (true)` + `break` rhythm. Then answer: what changed in the trace table, and where does the sentinel check sit now?

**E19.** Read integers until `-1` and print three counts: positives, negatives, zeros. (Note: the sentinel is -1 precisely because 0 must be countable data — say so in a comment.) Trace `5 -2 0 -1`.

**E20.** Read an age with a do-while validation loop that re-prompts until the age is in 1–120, printing a specific message for out-of-range values. Then print `Adult` (18+) or `Minor`.

**E21.** Write a robust integer reader: keep re-prompting while `cin.fail()` (clear + ignore each time), then use it to read two integers and print their sum. Feed it `abc` then `12` and state exactly what the user sees.

**E22.** Read 10 integers and print the **first** one greater than 100, or `None` if there isn't one. Use `break`. Trace inputs `4 95 210 88 ...` and show which passes never run.

**E23.** Sum the odd numbers from 1 to `n` using `continue` to skip evens. Then rewrite it *without* `continue`. State honestly which you find clearer and why — there is no single right answer.

**E24.** Read a Celsius value, print its Fahrenheit equivalent, then ask `Another? (y/n)`. Repeat until the user answers anything other than `y`/`Y`. Use a do-while. Trace two rounds including a wrong first answer (`t`).

---

## Part D — Nested loops, digits, math (★★★, E25–E32)

**E25.** Read a positive integer and print its digit count and digit sum. Trace `9045` in a full table (n, last, sum, count). What are the outputs for input `0`, and what must the requirement say for that to be correct?

**E26.** Reverse the digits of a positive integer (`4729 → 9274`), then use the reversed copy to decide whether the number is a palindrome (reads the same reversed: `121 → yes`, `123 → no`). Remember to keep a copy of the original.

**E27.** Print the factorials `1!` through `10!`, one per line, as `5! = 120`. Which line surprises most students, and which loop never runs to produce it?

**E28.** Print all primes from 2 to 50, one per line: for each candidate, count its divisors and print only those with exactly two. (Outer loop = candidates, inner loop = divisor test.) Then add the early exit: once the divisor count exceeds 2, stop testing that candidate.

**E29.** Print a right triangle of stars with height `n`: row 1 has 1 star, row n has n stars. Dry-run rows 1–3 for `n = 4` before coding. What is the inner loop's condition in terms of `r`?

**E30.** Print the number triangle `1 / 1 2 / 1 2 3 / 1 2 3 4` for height `n`. Which variable does the printed value track — the row or the column?

**E31.** Print the 5×5 multiplication grid: row r, column c shows `r*c`, formatted in columns with `setw(4)`. Label it: header row `1..5` and row labels in column 0. (This is the [mini-project's](miniproject.md) table module in embryo.)

**E32.** Print numbers 1–30, but print `Fizz` for multiples of 3, `Buzz` for multiples of 5, `FizzBuzz` for multiples of both, and the number otherwise. One line per value. Decide the condition *order* deliberately and state why `if (m % 15 == 0)` must be tested first.

---

<a name="solutions-s1--s32"></a>
# Solutions (S1–S32)

> Attempted everything in your target part first? Good. Compare *approach* before comparing code — a different but correct loop is a win.

<a name="s1--count-up-and-across"></a>
## S1 — Count up and across

```cpp
for (int i = 1; i <= 10; i = i + 1) {
    std::cout << i << '\n';
}
for (int i = 1; i <= 10; i = i + 1) {
    std::cout << i << ' ';
}
std::cout << '\n';
```
Second form: numbers separated by spaces, newline after the loop (the [row-end rule](lesson-4-nested-digits-patterns.md#2-the-grid-mental-model) in miniature). A `while` version moves `i = i + 1` from the header into the body's last line — same engine.

<a name="s2--evens-two-ways"></a>
## S2 — Evens two ways

```cpp
int i = 2;                      // (a) filter version
while (i <= 20) {
    if (i % 2 == 0) std::cout << i << '\n';
    i = i + 1;
}

for (int i = 2; i <= 20; i = i + 2) {   // (b) step version
    std::cout << i << '\n';
}
```
(b) runs 10 condition checks + 10 updates; (a) runs 19 checks. Stepping by 2 halves the work *and* states the intent ("evens") in the header — usually the one to show a friend. But (a)'s technique generalizes (skip by *rule*, not just by step), so both belong in your toolkit.

<a name="s3--countdown"></a>
## S3 — Countdown

```cpp
int n;
std::cin >> n;
for (int t = n; t >= 1; t = t - 1) {
    std::cout << t << '\n';
}
std::cout << "Liftoff\n";
```
Trace for `n = 3`: t=3 yes → prints 3, t=2 → 2, t=1 → 1, t=0 no → exit, then Liftoff. Four condition checks, three body runs — the [exit-certificate row](lesson-1-while.md#2-the-while-loop--anatomy) again.

<a name="s4--sum-1-to-n"></a>
## S4 — Sum 1 to n

```cpp
int n;
std::cin >> n;
int total = 0;
int i = 1;
while (i <= n) {
    total += i;
    i = i + 1;
}
std::cout << total << '\n';
```
Trace `n = 4`: total 0→1→3→6→10. For `n = 100` the answer is **5050** — and the loop confirms it. (The closed formula `n(n+1)/2` gives it instantly; you'll meet that comparison properly in Stage D — for now, notice a loop's result can sometimes be predicted by arithmetic.)

<a name="s5--five-numbers"></a>
## S5 — Five numbers

```cpp
int total = 0;
int i = 1;
while (i <= 5) {
    int x;
    std::cin >> x;
    total += x;
    i = i + 1;
}
std::cout << "Sum: " << total << ", average: "
          << static_cast<double>(total) / 5 << '\n';
```
The `static_cast` (or writing `total / 5.0`) makes the average floating-point — `total / 5` with both ints would truncate. `i` is pure machinery; `total` is the answer.

<a name="s6--positives-negatives-sum"></a>
## S6 — Positives, negatives, sum

```cpp
int pos = 0, neg = 0, sumPos = 0;
int i = 0;
while (i < 6) {
    int x;
    std::cin >> x;
    if (x > 0)      { pos += 1;  sumPos += x; }
    else if (x < 0) { neg += 1; }
    i = i + 1;
}
std::cout << "Positive: " << pos << ", negative: " << neg
          << ", sum of positives: " << sumPos << '\n';
```
The `else if` matters: zero must fall through both counters. This is [Lab 2](labs.md#lab-2--canteen-till)'s core in disguise — counters and accumulators classifying data in one pass.

<a name="s7--product"></a>
## S7 — Product

```cpp
int n;
std::cin >> n;
int product = 1;            // multiplicative identity — NOT 0
int k = 1;
while (k <= n) {
    product *= k;
    k = k + 1;
}
std::cout << product << '\n';
```
Starting at 0 multiplies everything into 0 — the accumulator's start value must be the *identity* of its operation: 0 for `+`, 1 for `×`. This is factorial (S27) in embryo.

<a name="s8--diagnose"></a>
## S8 — Diagnose

- **(a)** Update missing → infinite loop printing `0000...` (k stays 0, condition always true).
- **(b)** Wrong-direction update: k climbs 10, 11, 12... away from the exit → infinite loop. ([E2 symptom table](lesson-1-while.md#2-the-while-loop--anatomy), row 3.)
- **(c)** No initialization (k undeclared) → compile error: *undeclared identifier*.

<a name="s9--for-mapping"></a>
## S9 — for mapping

```cpp
for (int i = 1; i <= 10; i = i + 1) { /* body */ }
//     └── init      └─ cond   └─ update        — from E1's while: i=1 (before), i<=10 (paren), i=i+1 (body's last line)

for (int t = n; t >= 1; t = t - 1) { /* body */ }
```
The countdown maps identically — only the *directions* differ. That's the point of E9: `for` is not a new machine, it's the same three parts in a fixed frame.

<a name="s10--sum-of-squares"></a>
## S10 — Sum of squares

```cpp
int n;
std::cin >> n;
int total = 0;
for (int i = 1; i <= n; i = i + 1) {
    total += i * i;
}
std::cout << total << '\n';
```
For `n = 5`: 1 + 4 + 9 + 16 + 25 = **55**.

<a name="s11--class-stats"></a>
## S11 — Class stats

```cpp
int n;
std::cin >> n;
double total = 0;
int failed = 0;
for (int i = 1; i <= n; i = i + 1) {
    int m;
    std::cin >> m;
    total += m;
    if (m < 40) failed += 1;
}
std::cout << "Average: " << total / n << ", failed: " << failed << '\n';
```
Trace for `55 38 91 40`: total 55, 93, 184, 224; failed 0, 1, 1, 1. Output `Average: 56, failed: 1`.

<a name="s12--high-low"></a>
## S12 — High and low

```cpp
int n;
std::cin >> n;
int hi, lo;
for (int i = 1; i <= n; i = i + 1) {
    int x;
    std::cin >> x;
    if (i == 1)      { hi = x; lo = x; }   // first value seeds both champions
    else if (x > hi) { hi = x; }
    else if (x < lo) { lo = x; }
}
std::cout << "High: " << hi << ", low: " << lo << '\n';
```
Trace `-8 12 3 -15 7`: hi −8→12→12→12→12; lo −8→−8→−8→−15→−15. Output `High: 12, low: -15`. `max = 0` would have reported 0 as the low-side's... no — it would report *high = 0 is beaten by 12* correctly but a data set of all-negatives would print `high: 0` — a value nobody entered. First-value seeding has no such assumption.

<a name="s13--table"></a>
## S13 — Table

```cpp
int k;
std::cin >> k;
for (int i = 1; i <= 10; i = i + 1) {
    std::cout << i << " x " << k << " = " << i * k << '\n';
}
```
Row shape fixed; only the multiplier varies — a 10-row grid with no nesting needed yet (E31 nests it).

<a name="s14--evens-sum"></a>
## S14 — Evens sum

```cpp
int totalA = 0;                          // (a) filter
for (int i = 1; i <= 100; i = i + 1) {
    if (i % 2 == 0) totalA += i;
}

int totalB = 0;                          // (b) step
for (int i = 2; i <= 100; i = i + 2) {
    totalB += i;
}
std::cout << totalA << ' ' << totalB << '\n';   // 2550 2550
```
Both print 2550. (a) checks the condition 100 times; (b) 50 — plus (b) skips 50 body-entry decisions. Same answer, half the checks; the trace's first three passes are 2, 4, 6 in both (values entering the accumulator), differing only in *which* i-values even reach the comparison.

<a name="s15--pass-sets"></a>
## S15 — Pass sets

- (a) body sees 1, 2, 3, 4, 5 → 5 passes.
- (b) body sees 0, 1, 2, 3, 4 → 5 passes.
- (c) body sees 1, 2, 3, 4 → **4 passes — the off-by-one bug** (never touches n).

(a) and (b) are equivalent. (c)'s correct exit sentence: *"for each value from 1 to n inclusive"* → `i <= n`. Full discussion in [Lesson 2 §5](lesson-2-for.md#5-off-by-one--the-boundary-problem).

<a name="s16--divisibility-counts"></a>
## S16 — Divisibility counts

```cpp
int n;
std::cin >> n;
int both = 0, neither = 0;
for (int i = 1; i <= n; i = i + 1) {
    int x;
    std::cin >> x;
    if (x % 3 == 0 && x % 5 == 0)      both += 1;
    else if (x % 3 != 0 && x % 5 != 0) neither += 1;
}
std::cout << "Both: " << both << ", neither: " << neither << '\n';
```
Sanity check: `both + neither + exactlyOne == n` — the four categories partition the data. If your counts ever violate that, one of the conditions isn't the true complement of the other (a [decisions-module lesson](../decisions/lesson-2-conditions.md) replayed here).

<a name="s17--sentinel-prime-read"></a>
## S17 — Sentinel, prime read

```cpp
int total = 0, count = 0;
int m;
std::cin >> m;                       // prime read
while (m != -1) {
    total += m;
    count += 1;
    std::cin >> m;                   // read-again
}
std::cout << "Count: " << count << ", total: " << total << '\n';
if (count > 0)
    std::cout << "Average: " << static_cast<double>(total) / count << '\n';
```
Trace `60 75 -1`: (prime 60) → add → 60,1; 75 → 135,2; −1 → exit. The `count > 0` guard: quitting immediately is legal, and dividing by zero isn't.

<a name="s18--sentinel-break"></a>
## S18 — Sentinel, break

```cpp
int total = 0, count = 0;
while (true) {
    int m;
    std::cin >> m;
    if (m == -1) break;              // sentinel check right after the read
    total += m;
    count += 1;
}
```
Trace rows are the same shape; what changed is *where* the test sits — inside the body, immediately after the read, instead of in the header. One read instead of two; the exit is visible where the data arrives rather than in the condition.

<a name="s19--three-counts"></a>
## S19 — Three counts

```cpp
int pos = 0, neg = 0, zero = 0;
int m;
std::cin >> m;
while (m != -1) {                    // -1 is the sentinel BECAUSE 0 is real data here
    if (m > 0)       pos += 1;
    else if (m < 0)  neg += 1;
    else             zero += 1;
    std::cin >> m;
}
std::cout << pos << ' ' << neg << ' ' << zero << '\n';
```
Trace `5 -2 0 -1`: 5→pos1; −2→neg1; 0→zero1; −1→exit. Output `1 1 1`.

<a name="s20--age-guard"></a>
## S20 — Age guard

```cpp
int age;
do {
    std::cout << "Age (1-120): ";
    std::cin >> age;
    if (age < 1 || age > 120)
        std::cout << "Out of range — try again.\n";
} while (age < 1 || age > 120);

if (age >= 18) std::cout << "Adult\n";
else           std::cout << "Minor\n";
```
The duplicated condition is deliberate: the *test* and the *message* are separate jobs, and keeping both next to the do-while's exit makes the contract readable. (A bool named `valid` folding it is also fine — say which you chose and why.)

<a name="s21--robust-reader"></a>
## S21 — Robust reader

```cpp
int a = 0;
std::cout << "Number: ";
std::cin >> a;
while (std::cin.fail()) {
    std::cin.clear();
    std::cin.ignore(1000, '\n');
    std::cout << "Whole numbers only — try again: ";
    std::cin >> a;
}
// ... repeat for b, then print a + b ...
```
Feeding `abc` then `12`: first read fails, message prints, line cleared, second read succeeds. The user sees one scolding, not a crash and not an infinite scroll ([I/O Lesson 2](../cpp-io/lesson-2-cin.md#25-when-input-goes-wrong-fail-clear-ignore) is the anatomy).

<a name="s22--first-over-100"></a>
## S22 — First over 100

```cpp
int found = -1;
for (int i = 1; i <= 10; i = i + 1) {
    int x;
    std::cin >> x;
    if (x > 100) { found = x; break; }
}
if (found == -1) std::cout << "None\n";
else             std::cout << "First: " << found << '\n';
```
Inputs `4 95 210 88 ...`: passes 1–2 record nothing, pass 3 sets found=210 and breaks — passes 4–10 never run. The trace's missing rows are the whole point of `break` ([Lesson 3 §2](lesson-3-break-continue-sentinels.md#2-break--the-emergency-exit)).

<a name="s23--odd-sum-continue"></a>
## S23 — Odd sum, continue and not

```cpp
int n;
std::cin >> n;
int total = 0;
for (int k = 1; k <= n; k = k + 1) {
    if (k % 2 == 0) continue;
    total += k;
}
// no-continue version:
int total2 = 0;
for (int k = 1; k <= n; k = k + 1) {
    if (k % 2 != 0) total2 += k;
}
```
Honest comparison: for a two-line body the plain `if` reads faster. `continue` earns its keep when the *keep-going* work is long — e.g. ten statements that shouldn't be indented under a negative condition. Either answer with a stated reason is correct.

<a name="s24--another-round"></a>
## S24 — Another round

```cpp
char again;
double c;
do {
    std::cout << "Celsius: ";
    std::cin >> c;
    std::cout << "Fahrenheit: " << c * 9.0 / 5.0 + 32.0 << '\n';
    std::cout << "Another? (y/n): ";
    std::cin >> again;
} while (again == 'y' || again == 'Y');
```
Trace with `25` then `t` then `n`: round 1 runs (25 → 77), prompt answered `t` → neither `y` nor `Y` → loop exits without a second round. The `y/Y` pair handles Caps Lock — the polite version of a compound condition.

<a name="s25--digit-stats"></a>
## S25 — Digit stats

```cpp
int n;
std::cin >> n;
int sum = 0, count = 0;
while (n > 0) {
    sum  += n % 10;
    count += 1;
    n = n / 10;
}
std::cout << "Digits: " << count << ", sum: " << sum << '\n';
```
Trace `9045`: last 5 (sum 5, count 1, n 904) → 4 (9, 2, 90) → 0 (9, 3, 9) → 9 (18, 4, 0) → exit. Output `Digits: 4, sum: 18`. Input `0`: loop runs zero times → `Digits: 0, sum: 0`. Whether "0 has 0 digits" is correct is a **requirements question** — state the assumption ([Problem Solving §7](../problem-solving/lesson.md#47-inputs-processing-outputs-requirements-assumptions-constraints)).

<a name="s26--reverse-palindrome"></a>
## S26 — Reverse and palindrome

```cpp
int n;
std::cin >> n;
int original = n;          // the loop consumes n — copy first
int rev = 0;
while (n > 0) {
    rev = rev * 10 + n % 10;
    n = n / 10;
}
if (rev == original) std::cout << "Palindrome\n";
else                 std::cout << "Not a palindrome\n";
```
`4729`: rev 9 → 92 → 927 → 9274 ≠ 4729 → no. `121`: rev 1 → 12 → 121 == 121 → yes.

<a name="s27--factorials"></a>
## S27 — Factorials

```cpp
int fact = 1;                       // 0! = 1 lives here already
std::cout << "0! = " << fact << '\n';
for (int k = 1; k <= 10; k = k + 1) {
    fact *= k;
    std::cout << k << "! = " << fact << '\n';
}
```
The surprise line: `0! = 1` — produced by a loop that *never runs* (the empty-loop-is-the-answer case from [Lesson 4 §4](lesson-4-nested-digits-patterns.md#4-primes--the-divisor-count-method)). Most students expect 0! to be 0; the multiplying accumulator starting at 1 says otherwise, and mathematics agrees.

<a name="s28--primes-2-to-50"></a>
## S28 — Primes 2 to 50

```cpp
for (int n = 2; n <= 50; n = n + 1) {        // candidates
    int divisors = 0;
    for (int d = 1; d <= n; d = d + 1) {     // divisor test
        if (n % d == 0) divisors += 1;
    }
    if (divisors == 2) std::cout << n << '\n';   // n ≥ 2 guaranteed here
}
```
Early-exit upgrade inside the inner loop:

```cpp
    for (int d = 1; d <= n && divisors <= 2; d = d + 1) {
        if (n % d == 0) divisors += 1;
    }
```
The condition `divisors <= 2` in the *header* is the cleaner early exit — no `break` needed, and the stop-rule is visible in the loop's contract. Expected output starts 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47.

<a name="s29--star-triangle"></a>
## S29 — Star triangle

```cpp
int n;
std::cin >> n;
for (int r = 1; r <= n; r = r + 1) {
    for (int c = 1; c <= r; c = c + 1) {    // rule: row r has r stars
        std::cout << "* ";
    }
    std::cout << '\n';
}
```
Inner condition `c <= r` — the inner bound *depends on the outer variable* ([Lesson 4 §5](lesson-4-nested-digits-patterns.md#5-pattern-printing--rule--statement)). Rows 1–3 for n=4: `*`, `* *`, `* * *`.

<a name="s30--number-triangle"></a>
## S30 — Number triangle

```cpp
int n;
std::cin >> n;
for (int r = 1; r <= n; r = r + 1) {
    for (int c = 1; c <= r; c = c + 1) {
        std::cout << c << ' ';              // prints the COLUMN number
    }
    std::cout << '\n';
}
```
The printed value tracks the *column* (each row counts 1, 2, 3...). Swap `c` for `r` and you get `1 / 2 2 / 3 3 3` — one character apart, completely different triangle. Patterns are decided by *which* variable you print.

<a name="s31--multiplication-grid"></a>
## S31 — Multiplication grid

```cpp
#include <iostream>
#include <iomanip>

int main() {
    std::cout << "    *";
    for (int c = 1; c <= 5; c = c + 1) std::cout << std::setw(4) << c;
    std::cout << '\n';
    for (int r = 1; r <= 5; r = r + 1) {
        std::cout << std::setw(4) << r;
        for (int c = 1; c <= 5; c = c + 1) {
            std::cout << std::setw(4) << r * c;
        }
        std::cout << '\n';
    }
    return 0;
}
```
Two nested loops plus one header loop: outer = rows, inner = columns, `setw(4)` aligns every cell ([I/O Lesson 1](../cpp-io/lesson-1-cout.md#4-formatting-columns-setw-left-right-setfill) doing its job inside a grid).

<a name="s32--fizzbuzz"></a>
## S32 — FizzBuzz

```cpp
for (int m = 1; m <= 30; m = m + 1) {
    if (m % 15 == 0)      std::cout << "FizzBuzz\n";   // both — MUST be first
    else if (m % 3 == 0)  std::cout << "Fizz\n";
    else if (m % 5 == 0)  std::cout << "Buzz\n";
    else                  std::cout << m << '\n';
}
```
`m % 15 == 0` (or `% 3 == 0 && % 5 == 0`) must be tested **first** because the most-demanding-first ladder from [Decisions Lesson 1](../decisions/lesson-1-branches.md) applies: 15 is a multiple of 3, so a `Fizz`-first ladder would swallow every FizzBuzz forever. The compound case outranks its ingredients.
