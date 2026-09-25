---
title: "Predict the Output — Decisions"
description: "10 decision programs to trace on paper before running: ladder order, boundary values, fallthrough, ternary printing, and short-circuit evaluation."
---

# Predict the Output — Decisions

> [← Module home](index.md) · [Debugging hunts →](debugging.md)

**How to work:** for each program, write your predicted output **by hand** — a trace table for the trickier ones — *before* opening the answers at the [bottom of the page](#answers). If your prediction disagrees with the compiler, the *explanation* is the lesson; find which line of your mental model was wrong. Input is shown as `input →` lines where the program reads.

---

## P1 — The polite ladder

```cpp
int marks = 73;
if (marks >= 80)
    std::cout << "A\n";
else if (marks >= 70)
    std::cout << "B\n";
else if (marks >= 60)
    std::cout << "C\n";
else
    std::cout << "F\n";
```

## P2 — Boundary sandwich

```cpp
int age = 18;
if (age > 18)
    std::cout << "adult\n";
else
    std::cout << "young\n";
```

## P3 — Two ifs, not a ladder

```cpp
int marks = 85;
if (marks >= 40)
    std::cout << "Pass\n";
if (marks >= 80)
    std::cout << "Distinction\n";
```

## P4 — The ordered ladder

```cpp
int marks = 79;
if (marks >= 70)
    std::cout << "B\n";
else if (marks >= 80)
    std::cout << "A\n";
else
    std::cout << "C\n";
```

## P5 — Fallthrough audit

```cpp
int level = 2;
switch (level)
{
    case 1: std::cout << "one\n";
    case 2: std::cout << "two\n";
    case 3: std::cout << "three\n";
        break;
    case 4: std::cout << "four\n";
        break;
    default: std::cout << "other\n";
}
```

## P6 — The char router

```cpp
char c = 'B';
switch (c)
{
    case 'a': std::cout << "lower a\n"; break;
    case 'A': std::cout << "upper A\n"; break;
    case 'B': std::cout << "upper B\n"; break;
    default:  std::cout << "unknown\n";
}
```

## P7 — The chained comparison

```cpp
int age = 45;
if (13 <= age <= 19)
    std::cout << "teen\n";
else
    std::cout << "not teen\n";
```

## P8 — AND before OR

```cpp
int age = 16; bool hasPass = false;
if (age < 18 || age > 65 && hasPass)
    std::cout << "allowed\n";
else
    std::cout << "denied\n";
```

## P9 — The ternary print

```cpp
int marks = 55;
std::cout << (marks >= 40 ? "PASS" : "FAIL") << '\n';
bool passed = marks >= 40;
std::cout << passed << '\n';
```

## P10 — Short-circuit guard

```cpp
int count = 0;
int total = 100;
if (count != 0 && total / count > 10)
    std::cout << "high average\n";
else
    std::cout << "no average\n";
```

---

## Answers

<details markdown="1">
<summary><strong>Click only after predicting all ten</strong></summary>

**P1 — `B`.** The ladder asks `>= 80` first: false (73). Then `>= 70`: true → `B`, and the rest of the ladder is skipped even though `>= 60` would also be true. First-true wins ([Lesson 1 §5](lesson-1-branches.md#5-else-if--a-ladder-of-questions)).

**P2 — `young`.** 18 is not *greater than* 18 — `>` excludes the boundary; the else takes it. If the requirement were "18 counts as adult", the condition needed `>=`. The [39/40/41 test](lesson-2-conditions.md#5-boundary-conditions-the--vs--trap) in miniature.

**P3 — `Pass` then `Distinction`.** Two *independent* ifs: the second runs even after the first succeeded — 85 qualifies for both. Replace the second `if` with `else if` and only `Pass` prints. Knowing which structure you want *is* the design decision.

**P4 — `B`, and that's a bug-shaped answer.** 79 passes `>= 70` and prints `B` — correct for this input. But 85 also prints `B`: the `>= 80` question is *unreachable*, because everything ≥ 80 is also ≥ 70. Un-ordered ladders don't crash; they quietly misclassify. This is [D4](debugging.md#d4--the-unordered-ladder) in prediction form.

**P5 — `two\nthree`.** Enters at `case 2`, prints `two`, then — no break — falls through to `case 3`'s body: `three`, then the break stops it. `case 4` and `default` are below the break and never run. Labels are doors; breaks are walls ([Lesson 3 §3](lesson-3-switch.md#3-fallthrough--the-default-behaviour-you-must-defeat)).

**P6 — `upper B`.** Char labels are exact characters: `'B'` matches only `'B'` — cases are case-sensitive ('a' ≠ 'A'), and matching jumps straight to the label.

**P7 — `teen`.** The classic. `13 <= age` evaluates first → `(13 <= 45)` is `true`, converted to `1` in the next comparison; `1 <= 19` is true → the whole thing is true. Age 45 is "teen". The fix is `age >= 13 && age <= 19`; the full autopsy is [D9](debugging.md#d9--the-chained-comparison).

**P8 — `allowed`.** `&&` binds tighter than `||`, so the condition is `age < 18 || (age > 65 && hasPass)` — not `(age < 18 || age > 65) && hasPass`. With age 16: `age < 18` is true, so the OR is true regardless of the second half → allowed. A minor walks through the "adults with pass" door because the parentheses nobody wrote grouped differently than intended. Parenthesise mixed AND/OR ([Lesson 2 §4](lesson-2-conditions.md#4--flip-it-logical-not)).

**P9 — `PASS` then `1`.** Line 1: the ternary picks `"PASS"` (55 ≥ 40) — note the parentheses around the whole `?:` are what let it sit inside a `<<` chain ([Lesson 3 §7](lesson-3-switch.md#7-common-switchternary-mistakes), S7). Line 2: `cout` prints `bool` as `1`/`0` by default — the words `true`/`false` need the stream trick from [I/O Lesson 1 §7](../cpp-io/lesson-1-cout.md#6-characters-strings-and-computed-values-together). Both lines say the same thing; only one says it in English.

**P10 — `no average`.** `count != 0` is false → `&&` **short-circuits**: the right side (`total / count`) is never evaluated, so no division by zero ever happens. The guard-then-use ordering isn't just style — it's the mechanism that makes the E4-style guard safe even inside one condition. `||` short-circuits the same way (stops at the first true).

</details>
