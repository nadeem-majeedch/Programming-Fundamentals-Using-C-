---
title: "Lesson 2 — for, Idioms, and Choosing the Loop"
description: "for anatomy, counting idioms (sum, average, min, max), off-by-one boundaries, and how to choose the appropriate loop."
---

# Lesson 2 — `for`, Idioms, and Choosing the Loop

> [← Module home](index.md) · [← Lesson 1 — while](lesson-1-while.md) · [Lesson 3 — break/continue →](lesson-3-break-continue-sentinels.md)

## In this lesson you will learn

- the `for` loop — what each of its three slots does and when it runs
- why `for` and `while` are the same engine with different packaging
- the four classic counting idioms: sum, average, maximum, minimum
- off-by-one errors: the boundary problem and how to prove your loop correct
- a decision procedure for choosing between `while`, `do-while`, and `for`

---

## 1. The `for` loop — the counting loop

Lesson 1's countdown had three separate lines for initialization, condition, and update. `for` gathers exactly those three slots into one header, in a fixed order:

```cpp
for (int t = 3; t >= 1; t = t - 1) {
    std::cout << t << '\n';
}
std::cout << "Liftoff\n";
```

```text
     ┌──────────────────────────────────────────────┐
     │ for ( A ;  B ;  C ) { body }                 │
     └──────────────────────────────────────────────┘
        A = initialization: runs ONCE, before anything
        B = condition:      checked before EVERY pass
        C = update:         runs AFTER each pass, before B is re-checked

     execution order:  A → B → body → C → B → body → C → B(exit)
```

**Pseudocode**:

```text
FOR t FROM 3 DOWNTO 1
    PRINT t
ENDFOR
PRINT "Liftoff"
```

Dry-run table (rows are condition checks, as always):

| pass | t at check | t >= 1? | prints | after update |
| ---- | ---------- | ------- | ------ | ------------ |
| 1    | 3          | yes     | 3      | 2            |
| 2    | 2          | yes     | 2      | 1            |
| 3    | 1          | yes     | 1      | 0            |
| 4    | 0          | no → exit | —    | —            |

Same output as Lesson 1's `while` countdown — line for line the same engine:

```cpp
{ int t = 3; while (t >= 1) { body; t = t - 1; } }   // while form
for (int t = 3; t >= 1; t = t - 1) { body; }         // for form
```

**When a variable exists only to drive the loop**, `for` is preferred — all its machinery sits in one visible line, and the variable can be declared in the header so it doesn't leak into the rest of `main`. When the loop variable *already exists* (an input value, a sentinel), `while` fits better. That intuition becomes a procedure in §6.

`for` slots are optional (`for (;;)` is a legal infinite loop) but *don't*: a missing slot is how [D4's](debugging.md#d4--the-off-by-one-table) bug hides.

<a name="2-the-classic-idioms--learn-once-reuse-forever"></a>
## 2. The classic idioms — learn once, reuse forever

An **idiom** is a small pattern you recognize and reuse rather than re-derive. These four appear in some form in almost every program that processes a known number of values. All assume `n` values are coming.

### Sum and average (accumulator idiom)

```cpp
// avg.cpp — average of n marks
#include <iostream>

int main() {
    int n;
    std::cout << "How many marks? ";
    std::cin >> n;

    double total = 0;                    // accumulator starts at 0
    for (int i = 1; i <= n; i = i + 1) {
        int m;
        std::cout << "Mark " << i << ": ";
        std::cin >> m;
        total = total + m;               // collect each value
    }

    std::cout << "Average: " << total / n << '\n';
    return 0;
}
```

One subtlety worth knowing now: `total / n` divides a `double` by an `int`, so the result is floating-point — good. `int / int` would have thrown away the fraction ([Foundations Lesson 4](../cpp-foundations/lesson-4-conversion.md) has the full story).

### Maximum (champion idiom)

Keep a *champion* — the best value seen so far — and challenge it with every new value:

```cpp
int max;                              // will hold the champion
for (int i = 1; i <= n; i = i + 1) {
    int x;
    std::cin >> x;
    if (i == 1) {
        max = x;                      // first value becomes the initial champion
    } else if (x > max) {
        max = x;                      // challenger wins
    }
}
```

Why not initialize `max = 0`? Because the data might be all negative — `max = 0` would answer a question nobody asked. **The first data value is the only honest starting champion.** (Alternatively read one value before the loop; the `i == 1` form keeps everything inside one loop.)

### Minimum

The same idiom with the comparison flipped — the champion is the *lowest* so far:

```cpp
    } else if (x < min) {
        min = x;
    }
```

### Counting matches (counter idiom)

```cpp
int passed = 0;                       // counter starts at 0
for (int i = 1; i <= n; i = i + 1) {
    int m;
    std::cin >> m;
    if (m >= 40) {
        passed = passed + 1;          // event: one more pass
    }
}
```

**Idiom summary:**

| Idiom | Variable starts | Update | Question answered |
| --- | --- | --- | --- |
| Accumulator | `0` | `total += x` | "how much altogether?" |
| Counter | `0` | `count += 1` | "how many times?" |
| Max champion | first value | `if (x > max)` | "how high did it go?" |
| Min champion | first value | `if (x < min)` | "how low did it go?" |

Average = accumulator ÷ counter. "Max of positives only" = counter + champion together. The idioms *compose* — that composition is what the labs and mini-project drill.

## 3. Looping patterns you can compose

Two small extensions multiply the idioms' reach:

**Running output** — print progress as you go (the fuel gauge pattern):

```cpp
for (int day = 1; day <= 7; day = day + 1) {
    // ... read or compute one day's value v ...
    std::cout << "Day " << day << ": " << v << '\n';
}
```

**Index-value pairs** — when position matters, `i` and the value travel together:

```cpp
for (int i = 1; i <= n; i = i + 1) {
    int x;
    std::cin >> x;
    std::cout << "Value #" << i << " is " << x << '\n';
    // i is also the "position" for questions like "is it even-numbered?"
}
```

Neither is new machinery — `i` is just another counter, but one whose *meaning* (day number, position) the program exploits.

## 4. Worked example — composing the idioms

**Task**: read `n` marks; print the average, the highest, and how many failed (`< 40`).

This composes all four idioms in one loop — one pass, one question each:

```cpp
// classStats.cpp
#include <iostream>

int main() {
    int n;
    std::cout << "How many marks? ";
    std::cin >> n;

    double total = 0;         // accumulator
    int failed = 0;           // counter
    int max = 0;              // champion — see caveat below

    for (int i = 1; i <= n; i = i + 1) {
        int m;
        std::cin >> m;
        total += m;
        if (m < 40)  failed += 1;
        if (m > max) max = m;
    }

    std::cout << "Average: " << total / n << '\n';
    std::cout << "Highest: " << max << '\n';
    std::cout << "Failed:  " << failed << '\n';
    return 0;
}
```

Two honest notes about this version (spotting them is itself practice):

- `max = 0` is safe *here* because marks can't be negative — but that's a data assumption, and [Problem Solving §7](../problem-solving/lesson.md#47-inputs-processing-outputs-requirements-assumptions-constraints) taught you to make assumptions explicit. The first-value form from §2 has no assumption to make.
- If `n` is 0, the loop never runs and the program divides by zero. Guarding `n` is [Lab 7](labs.md#lab-7--the-robust-reader)'s job.

Trace for `n = 4`, marks `55, 38, 91, 40`:

| i | m | total | failed | max |
| - | - | ----- | ------ | --- |
| — | — | 0     | 0      | 0   |
| 1 | 55 | 55   | 0      | 55  |
| 2 | 38 | 93   | 1      | 55  |
| 3 | 91 | 184  | 1      | 91  |
| 4 | 40 | 224  | 1      | 91  |

Output: `Average: 56`, `Highest: 91`, `Failed: 1`. (224/4 = 56 exactly; a mixed set like 224/3 exercises the decimal.)

<a name="5-off-by-one--the-boundary-problem"></a>
## 5. Off-by-one — the boundary problem

Off-by-one errors run a loop one time too many or too few. They compile, they don't crash — they just quietly do the wrong amount of work. Three boundary styles, one question:

```cpp
for (int i = 1; i <= n; i++)   // A: counts 1..n        → n passes
for (int i = 0; i < n; i++)    // B: counts 0..n-1      → n passes
for (int i = 1; i < n; i++)    // C: 1..n-1             → n-1 passes  (usually a BUG)
```

A and B are both correct and both common. The rule that keeps you safe:

> **Match the loop to its exit sentence, then prove it with n = 1, n = 2, and the final value.**

- Style A exits when `i = n + 1`; body ran for `1..n`. Sentence: *"do the body once for each value from 1 to n."*
- Style B exits when `i = n`; body ran for `0..n-1`. Sentence: *"do the body n times."*

Prove it mechanically: for n = 1, style A runs {1}; style B runs {0} — one pass each. For n = 2: A runs {1,2}, B runs {0,1}. The `i = 1; i <= n` form is the course default because it matches how humans count *items* ("mark 1", "mark 2", ...).

The dry-run table's last row is your off-by-one detector: write down what the body did on the final pass and what the first *skipped* value would have been. If either surprises you, the boundary is wrong. The [boundary stress-test challenge](../decisions/challenges.md#c8--the-boundary-stress-test-harness) from the decisions module applies to loops too — and [Debugging 4–6](debugging.md) are all off-by-one cases.

## 6. Choosing the appropriate loop

Not a matter of taste — a short decision procedure:

```text
1. Does the body need to run before any condition can be judged?
   (menus, "read a value first")
        YES → do-while
        NO  → continue to 2

2. Does something in the DATA decide when to stop?
   (sentinel value, a flag, "until the user says stop", validation)
        YES → while
        NO  → continue to 3

3. Do you know (or can you compute) the pass count in advance?
   ("n times", "from 1 to 10", "for each day of the week")
        YES → for
```

Examples through the lens of this procedure:

| Task | Step 1 | Step 2 | Step 3 | Loop |
| --- | --- | --- | --- | --- |
| Show a menu until Quit | yes | — | — | do-while |
| Total orders until 0 | no | yes (sentinel) | — | while |
| Sum of the first 10 squares | no | no | yes (10) | for |
| Average of n marks | no | no | yes (n) | for |
| Re-prompt until age is 1–120 | yes | — | — | do-while |

All three loops can technically imitate each other — the procedure produces the *clearest* choice, and clarity is a correctness tool: the loop whose shape matches its reason for stopping is the loop a reader can verify at a glance.

## Practice

- [Exercises 9–16](exercises.md) (★★: idioms, boundaries, composition)
- [Predictions 4–7](predictions.md#questions)
- [Debugging 4–6](debugging.md) — the off-by-one family
- [Lab 1](labs.md#lab-1--the-drilling-instructor) — the drilling instructor
- [Lab 2](labs.md#lab-2--canteen-till) — canteen till

## Key takeaways

- `for` packs initialization; condition; update into one header — same engine as `while`, best when a counter drives the loop.
- The four idioms — accumulator, counter, max champion, min champion — start (0 / 0 / first value / first value) and compose freely.
- Off-by-one is a boundary decision, not bad luck: pick a style, state its exit sentence, prove it with small n and the last row of a dry run.
- Choose the loop by asking: must the body run first (do-while)? does data decide (while)? is the count known (for)?

→ Next: [Lesson 3 — `break`, `continue`, and sentinels](lesson-3-break-continue-sentinels.md)
