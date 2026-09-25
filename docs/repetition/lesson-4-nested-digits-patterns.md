---
title: "Lesson 4 — Nested Loops, Digits, and Patterns"
description: "Nested-loop execution model, multiplication tables, pattern printing, digit processing, primes, factorial, and the common loop errors gallery."
---

# Lesson 4 — Nested Loops, Digits, and Patterns

> [← Module home](index.md) · [← Lesson 3 — break/continue](lesson-3-break-continue-sentinels.md) · [Exercises →](exercises.md)

## In this lesson you will learn

- how nested loops execute — and how to count what they do without running them
- the grid mental model: outer = rows, inner = columns
- digit processing with `/ 10` and `% 10` — reverse, digit-sum, digit-count
- primes (the divisor-count method and early exit), and factorial
- pattern printing as a *rule → statement* translation exercise
- the common loop errors gallery — the eight bugs this unit exists to inoculate you against

---

<a name="1-nested-loops--a-loop-inside-a-loop"></a>
## 1. Nested loops — a loop inside a loop

Anything can live inside a loop body — including another loop. The inner loop runs to completion **for every single pass** of the outer loop.

```cpp
// clock.cpp — the clock model of nesting
for (int hours = 1; hours <= 2; hours = hours + 1) {        // outer: 2 passes
    for (int minutes = 1; minutes <= 3; minutes = minutes + 1) {  // inner: 3 per outer pass
        std::cout << hours << ":" << minutes << "  ";
    }
    std::cout << '\n';                                       // end of one hour's row
}
```

Output:

```text
1:1  1:2  1:3
2:1  2:2  2:3
```

**Pseudocode**:

```text
FOR hours FROM 1 TO 2
    FOR minutes FROM 1 TO 3
        PRINT hours ":" minutes
    ENDFOR
    PRINT newline
ENDFOR
```

Dry run — one row per *inner* condition check, with the outer pass recorded:

| outer h | inner m | m <= 3? | prints | then |
| ------- | ------- | ------- | ------ | ---- |
| 1 | 1 | yes | 1:1 | m=2 |
| 1 | 2 | yes | 1:2 | m=3 |
| 1 | 3 | yes | 1:3 | m=4 → inner exits |
| 1 | — | (outer updates h) | newline | h=2 |
| 2 | 1 | yes | 2:1 | ... |
| 2 | 2 | yes | 2:2 | ... |
| 2 | 3 | yes | 2:3 | inner exits again |
| 2 | — | (outer h=3) | newline | outer exits |

**Counting the work** (no code needed): body statements of the *inner* loop ran 2 × 3 = 6 times. In general, `outer passes × inner passes per outer pass`. If the inner loop's trip count *depends on the outer variable* (patterns, below), multiply row by row and add — or derive a formula when you can.

<a name="2-the-grid-mental-model"></a>
## 2. The grid mental model

Most nested loops you meet are **grids**: rows × columns. Learn one sentence and half of this lesson is yours:

> **Outer loop = rows, inner loop = columns, `'\n'` after the inner loop ends each row.**

```cpp
// grid.cpp — a 3 × 4 grid of stars
for (int r = 1; r <= 3; r = r + 1) {        // 3 rows
    for (int c = 1; c <= 4; c = c + 1) {    // 4 stars per row
        std::cout << "* ";
    }
    std::cout << '\n';                      // finish the row
}
```

```text
* * * *
* * * *
* * * *
```

The two classic bugs write themselves out of the same mistake in two places:

```cpp
// BUG A — newline INSIDE the inner loop:  * \n* \n* \n...  (one star per line)
// BUG B — newline OUTSIDE both loops:     * * * * * * * * * * * *  (one long line)
```

The `'\n'` belongs *after the inner loop, inside the outer* — exactly where "end of row" sits in the sentence above.

<a name="3-digit-processing--10-and--10"></a>
## 3. Digit processing — `/ 10` and `% 10`

An integer's last digit is `n % 10`; removing that digit is `n / 10` (integer division throws the fraction away). Alternating these two operations peels a number apart one digit at a time — a **while loop over digits** (input-controlled: the number itself decides when to stop, when it reaches 0):

```cpp
// digits.cpp — digit-by-digit processing
#include <iostream>

int main() {
    int n;
    std::cin >> n;                 // e.g. 4729

    int digits = 0;
    int digitSum = 0;

    while (n > 0) {
        int last = n % 10;         // peel the last digit       (9, 2, 7, 4)
        digitSum += last;          // use it
        digits += 1;
        n = n / 10;                // remove it                 (472, 47, 4, 0)
    }

    std::cout << "Digits: " << digits << ", sum: " << digitSum << '\n';
    return 0;
}
```

Trace for `4729`:

| pass | n (at check) | last = n%10 | digitSum | digits | n = n/10 |
| ---- | ------------ | ----------- | -------- | ------ | -------- |
| 1    | 4729         | 9           | 9        | 1      | 472      |
| 2    | 472          | 2           | 11       | 2      | 47       |
| 3    | 47           | 7           | 18       | 3      | 4        |
| 4    | 4            | 4           | 22       | 4      | 0        |
| 5    | 0            | — check fails → exit | 22 | 4 | — |

Note what changed: `n` itself is *consumed* — after the loop it is 0. That's fine when the original is no longer needed; if it is, keep a copy (`int original = n;` before the loop). This consume-the-input pattern is why digit loops are `while (n > 0)` and not `for`.

**Reverse** builds a new number from the peeled digits, each pass multiplying what's built so far by 10 and adding the new digit:

```cpp
int rev = 0;
while (n > 0) {
    rev = rev * 10 + n % 10;   // 4729 → 9 → 92 → 927 → 9274
    n = n / 10;
}
```

One caution: `n = 0` input makes both loops run **zero** times — sum 0, digits 0, reverse 0. Whether that is correct depends on the requirement; state it as an assumption ([Problem Solving §7](../problem-solving/lesson.md#47-inputs-processing-outputs-requirements-assumptions-constraints)).

<a name="4-primes--the-divisor-count-method"></a>
## 4. Primes — the divisor-count method

A prime is a whole number above 1 whose only divisors are 1 and itself. The beginner method is a **counting idiom in disguise**: count the divisors of `n` by testing every candidate from 1 to n:

```cpp
// isPrime by divisor count — 7 has divisors {1, 7} → count 2 → prime
int divisors = 0;
for (int d = 1; d <= n; d = d + 1) {
    if (n % d == 0) {
        divisors += 1;
    }
}
if (n > 1 && divisors == 2) {
    std::cout << n << " is prime\n";
} else {
    std::cout << n << " is not prime\n";
}
```

Dry run for `n = 7`: divisors found at d = 1 and d = 7 → count 2 → prime. For `n = 9`: d = 1, 3, 9 → count 3 → not prime. For `n = 1`: count 1 → the `n > 1` guard correctly rejects it.

Two upgrades you should know exist (both are [challenge](challenges.md) material):

- **Early exit**: once `divisors` passes 2, no further checking can change the answer — `break` out ([Lesson 3 §2](lesson-3-break-continue-sentinels.md#2-break--the-emergency-exit) in action).
- **Square-root bound**: divisors of n come in pairs (d, n/d), so testing up to √n suffices — the standard efficiency trick, introduced properly in [Stage D](../syllabus.md#stage-d-algorithms-and-data-units-10-12).

**Factorial** is the *multiplying* accumulator — same accumulator ritual, multiplicative identity start:

```cpp
int fact = 1;                       // 1, not 0 — 0 is multiplication's black hole
for (int k = 1; k <= n; k = k + 1) {
    fact = fact * k;                // 1 → 1×2 → 1×2×3 ...
}
// n! for n = 5: 120. 0! = 1 — the loop runs zero times and fact is already 1.
```

Note the beautiful accident: `0! = 1` comes out *automatically* because a loop over zero passes never touches the accumulator. The empty-loop-is-the-answer case again — now it's a feature.

<a name="5-pattern-printing--rule--statement"></a>
## 5. Pattern printing — rule → statement

Patterns are pure translation: a verbal rule per row becomes a *statement about the loop variables*. The grid loop from §2 with a changing inner bound:

```cpp
// triangle — row r has r stars
for (int r = 1; r <= 4; r = r + 1) {
    for (int c = 1; c <= r; c = c + 1) {     // inner bound DEPENDS on r
        std::cout << "* ";
    }
    std::cout << '\n';
}
```

```text
*
* *
* * *
* * * *
```

```text
* * * *
* * *
* *
*
```

**Reading rule → statement**, the skill the exercises drill:

| Rule (per row r of N) | Inner loop condition |
| --- | --- |
| "r stars in row r" | `c <= r` |
| "N − r + 1 stars" (first row full, shrinking) | `c <= N - r + 1` |
| "stars only in columns ≤ r" — same as rule 1 | `c <= r` |
| "number equal to its column" | print `c` with `c <= r` |
| "row number repeated r times" | print `r` with `c <= r` |

The number triangle that follows from the last two rules:

```text
1
1 2
1 2 3
1 2 3 4
```

The method is always: (1) write what row 1, 2, 3 look like; (2) express the row's *contents* as a formula in r; (3) put that formula in the inner loop's bound or print statement. [Lab 9](labs.md#lab-9--the-pattern-studio) and the exercises give you a full gallery.

<a name="6-the-common-loop-errors-gallery"></a>
## 6. The common loop errors gallery

Eight bugs account for nearly every loop problem a beginner writes. Each has a signature symptom — learn to diagnose from the symptom, not by staring:

| # | Bug | Signature symptom |
| --- | --- | --- |
| E1 | Missing update | hangs forever, same value scrolling |
| E2 | Wrong-direction update | hangs forever (condition never false) or zero passes |
| E3 | Off-by-one bound | output has one extra/missing item — `i < n` vs `i <= n` |
| E4 | Uninitialized accumulator | total looks like garbage (starts from a junk value) |
| E5 | Accumulator reset *inside* the loop | final total equals just the last item |
| E6 | Sentinel that collides with data | loop stops early on a legitimate value (a 0 mark with sentinel 0) |
| E7 | Semicolon after the loop header | `for (...);` — loop "runs" nothing, body runs once after |
| E8 | `continue` in `while` below the update | hangs on the first skipped value ([Lesson 3 §3](lesson-3-break-continue-sentinels.md#3-continue--skip-this-pass)) |

E7 deserves one glance — the most surprising of the eight:

```cpp
for (int i = 1; i <= 3; i = i + 1);   // ← that semicolon IS the whole body
    std::cout << "Hello\n";           // runs ONCE, after the empty loop finishes
```

The loop executes three times doing nothing; the print (not inside braces, so it's *not* in the loop) runs once. Symptom: "my loop only printed one line." The braces rule from [Decisions Lesson 1](../decisions/lesson-1-branches.md) applies doubly to loops: **always brace the body**, even one statement.

And the meta-error across all eight: **debugging by re-compiling**. When a loop misbehaves, run the dry-run table first — E1–E8 are all visible on paper, and the table tells you *which* bug before you touch the code. [Debugging](debugging.md) is 15 reps of exactly this.

## Practice

- [Exercises 25–32](exercises.md) (★★★: digits, primes, patterns, factorial)
- [Predictions 13–15](predictions.md#questions)
- [Debugging 11–15](debugging.md) — nesting and integration bugs
- [Lab 9](labs.md#lab-9--the-pattern-studio) — pattern studio · [Lab 10](labs.md#lab-10--the-number-lab) — number lab
- [Mini-project](miniproject.md) — the Number Analysis Toolkit

## Key takeaways

- Nested loops: inner completes fully per outer pass; body count = outer × inner (per-row when inner depends on outer). Rows outside, columns inside, `'\n'` between.
- `% 10` peels the last digit; `/ 10` consumes it — digit loops are `while (n > 0)` and eat their input (copy it first if you need it back).
- Primes by divisor count (with early exit and √n as upgrades); factorial is the multiplying accumulator starting at 1 — and gives `0! = 1` for free.
- Patterns: translate each row's verbal rule into a statement about the loop variables; write rows 1–3 out first.
- Eight named bugs, eight signature symptoms — diagnose from the dry-run table before touching code.

→ Next: [Exercises](exercises.md) — then the [mini-project](miniproject.md).
