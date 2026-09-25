---
title: "Debugging Exercises — Decisions"
description: "10 buggy decision programs to fix: the = vs == trap, unbraced bodies, stray semicolons, ladder order, flipped boundaries, missing default, and more."
---

# Debugging Exercises — Decisions

> [← Module home](index.md) · [Exercises →](exercises.md)

**How to work:** read the code, *predict the symptom by hand* (a dry run on the given test inputs), then check the hint ladder only as needed — H1 nudges, H2 locates, H3 explains the fix. Each program compiles cleanly unless stated: the bug is in the **logic**, which no compiler can catch. Fix, re-run the tests, and confirm the corrected output.

---

## D1 — The missing `=`

```cpp
// Rule: children under 12 eat free.
int age;
std::cin >> age;
if (age = 12)                     // compiles with a warning under -Wall
{
    std::cout << "Free meal\n";
}
else
{
    std::cout << "Pay 500\n";
}
```

**Task:** the rule says under-12s eat free, but the program prints `Free meal` for age 20 and for age 5 alike. Fix it.

<details markdown="1">
<summary>Hints</summary>

- **H1:** what is the *value* of the condition `age = 12`?
- **H2:** the condition assigns 12 to `age` and evaluates to 12 — non-zero, always true.
- **H3:** `if (age < 12)` — comparison, not assignment. The bug family lives in [Lesson 2 §1](lesson-2-conditions.md#1-comparison-operators--six-ways-to-ask); compile with `-Wall` and gcc flags this as a warning.

</details>

## D2 — The unbraced body

```cpp
// Rule: passing students get PASS and a congratulations line.
int marks;
std::cin >> marks;
if (marks >= 40)
    std::cout << "PASS\n";
    std::cout << "Congratulations!\n";
```

**Task:** a failing student (marks 25) still sees `Congratulations!`. Why, and fix it.

<details markdown="1">
<summary>Hints</summary>

- **H1:** which statements belong to the `if`? Count them with the brace rule from [Lesson 1 §7](lesson-1-branches.md#7-braces-the-silent-killer).
- **H2:** the `if` owns exactly one statement; the congratulations is unconditional.
- **H3:** brace the two-line body. This is why the course rule is *always brace*.

</details>

## D3 — The stray semicolon

```cpp
// Rule: refuse out-of-range marks.
int marks;
std::cin >> marks;
if (marks < 0 || marks > 100);
{
    std::cout << "Invalid marks\n";
    return 1;
}
```

**Task:** the program refuses *every* mark, including valid ones. Find it.

<details markdown="1">
<summary>Hints</summary>

- **H1:** what statement sits between the `if (…)` and the block?
- **H2:** the semicolon is an empty statement — the whole decision is made and discarded; the block runs always.
- **H3:** delete the semicolon. Related trap family: [Lesson 1 §8 M6](lesson-1-branches.md#8-beginner-mistakes-gallery-lesson-1-set).

</details>

## D4 — The unordered ladder

```cpp
// Grading: A >= 80, B >= 70, C >= 60, D >= 40, else F.
int marks;
std::cin >> marks;
if (marks >= 40)
{
    std::cout << "D\n";
}
else if (marks >= 60)
{
    std::cout << "C\n";
}
else if (marks >= 70)
{
    std::cout << "B\n";
}
else if (marks >= 80)
{
    std::cout << "A\n";
}
else
{
    std::cout << "F\n";
}
```

**Task:** every mark from 40 upward prints `D`; 85 prints `D`. Reorder so the intended grading works, and state the ladder property that made the original wrong ([Lesson 1 §5](lesson-1-branches.md#5-else-if--a-ladder-of-questions)).

<details markdown="1">
<summary>Hints</summary>

- **H1:** when is the second question even *asked*?
- **H2:** each `else` means "and not any condition above" — 85 passes `>= 40` first and never reaches `>= 80`.
- **H3:** most-demanding-first: 80, 70, 60, 40, else F.

</details>

## D5 — The impossible condition

```cpp
// Rule: warn when temperature is out of the safe band 10..30.
double temp;
std::cin >> temp;
if (temp >= 10 && temp <= 30)
{
    std::cout << "Warning: outside safe band\n";
}
else
{
    std::cout << "OK\n";
}
```

**Task:** the warning never appears — even for 45°C. One character is the culprit class: which *operator* is wrong?

<details markdown="1">
<summary>Hints</summary>

- **H1:** trace the condition for `temp = 45`: what is `45 >= 10`? `45 <= 30`?
- **H2:** "outside the band" is an OR of two violations, not an AND of two memberships ([Lesson 2 §6](lesson-2-conditions.md#6-compound-conditions-in-the-wild), inverted range).
- **H3:** `if (temp < 10 || temp > 30)` — and the De Morgan flip in [Lesson 2 §4](lesson-2-conditions.md#4--flip-it-logical-not) confirms it's the exact opposite of the in-range test.

</details>

## D6 — The flipped boundary

```cpp
// Rule: scholarship for marks of 60 or more.
int marks;
std::cin >> marks;
if (marks > 60)
{
    std::cout << "Scholarship\n";
}
else
{
    std::cout << "No scholarship\n";
}
```

**Task:** the rule says "60 or more", but marks of exactly 60 get `No scholarship`. Which test value catches this, and what is the one-character fix? Then state the general flip rule ([Lesson 2 §5](lesson-2-conditions.md#5-boundary-conditions-the--vs--trap)).

<details markdown="1">
<summary>Hints</summary>

- **H1:** put 60 into the condition. True or false?
- **H2:** `>` excludes the edge; "or more" includes it.
- **H3:** `marks >= 60`. The opposite of `>= 60` is `< 60` — never `<= 59` mental gymnastics, never keeping the same edge with a flipped family.

</details>

## D7 — The missing default

```cpp
char cmd;
std::cin >> cmd;
switch (cmd)
{
    case 'y':
        std::cout << "Confirmed\n";
        break;
    case 'n':
        std::cout << "Cancelled\n";
        break;
}
```

**Task:** a user types `x` and the program says nothing at all — they can't tell their keypress was received. Add the missing piece and decide what it should print (echo the input!).

<details markdown="1">
<summary>Hints</summary>

- **H1:** what handles "no label matched" in a switch? ([Lesson 3 §1](lesson-3-switch.md#1-switch--routing-on-one-value))
- **H2:** `default:` is the switch's final `else`.
- **H3:** `default: std::cout << "Unknown command: " << cmd << '\n';` — feedback turns silent misfires into visible, fixable ones.

</details>

## D8 — The leaky switch

```cpp
// Rule: level 1 prints Intro, level 2 prints Intro + Standard, level 3 prints all three.
switch (level)
{
    case 1:
        std::cout << "Intro\n";
        break;
    case 2:
        std::cout << "Standard\n";
    case 3:
        std::cout << "Advanced\n";
        break;
}
```

**Task:** level 2 was supposed to print exactly `Standard\nAdvanced` — which it does. But level 3 prints `Advanced` too, and the client now reports: "level 1 must print Intro only" (it does) — *however* the real bug the tester found: entering level 5 prints **nothing**. Two fixes: (1) make level 5 (any other level) print `Invalid level`; (2) the spec changed — level 2 must now print `Standard` only. Fix both without breaking 1 or 3.

<details markdown="1">
<summary>Hints</summary>

- **H1:** what runs for `level = 5` today? What *should*?
- **H2:** (1) is the `default` from D7; (2) — look at what `case 2:` leaks into.
- **H3:** add `default:` with the message; put a `break;` after `Standard\n` (the leak was load-bearing only until the spec changed — now it's just wrong).

</details>

## D9 — The chained comparison

```cpp
// Rule: teenager is age 13..19 inclusive.
int age;
std::cin >> age;
if (13 <= age <= 19)
{
    std::cout << "Teenager\n";
}
else
{
    std::cout << "Not a teenager\n";
}
```

**Task:** age 45 prints `Teenager`. Explain *why the compiler accepts this* and what it actually computes, then fix it. (Full walk-through: [P7](predictions.md#p7--the-chained-comparison).)

<details markdown="1">
<summary>Hints</summary>

- **H1:** evaluate `(13 <= age)` for age 45 first — it's a `bool`. Then evaluate `(that) <= 19`.
- **H2:** `bool` converts to 0 or 1; `1 <= 19` is always true ([Lesson 2 §2](lesson-2-conditions.md#2--both-must-hold-logical-and)).
- **H3:** `age >= 13 && age <= 19`.

</details>

## D10 — The dangling else

```cpp
// Rule: adults with ID enter; adults without ID are turned away; minors denied.
int age;
bool hasId;
std::cin >> age >> hasId;
if (age >= 18)
    if (hasId)
        std::cout << "Enter\n";
else
    std::cout << "Denied\n";
```

**Task:** a minor (age 15) prints nothing at all. To *which* `if` does that `else` bind, and why? Rewrite with braces so the structure matches the rule. (Binding rule: [Lesson 1 §6](lesson-1-branches.md#6-nested-decisions--a-question-inside-an-answer).)

<details markdown="1">
<summary>Hints</summary>

- **H1:** which `if` is *unmatched* when the `else` arrives? Indentation lies; binding is nearest-unmatched.
- **H2:** the `else` belongs to the inner `if (hasId)` — so adults-without-ID get "Denied" and minors fall through both branches to nothing.
- **H3:** brace every level:
```cpp
if (age >= 18)
{
    if (hasId) { std::cout << "Enter\n"; }
    else       { std::cout << "Denied (no ID)\n"; }
}
else
{
    std::cout << "Denied (minor)\n";
}
```

</details>

---

## Fix-list recap

| Hunt | Bug class | Portable lesson |
| --- | --- | --- |
| D1 | `=` vs `==` | `-Wall` is your friend; compare, don't assign |
| D2 | unbraced body | brace every body, even one-liners |
| D3 | stray `;` | empty statement eats the decision |
| D4 | ladder order | most-demanding-first or self-contained ranges |
| D5 | AND vs OR | "outside a band" = OR of violations |
| D6 | boundary flip | the opposite of `>= x` is `< x` |
| D7 | missing default | every menu needs an else |
| D8 | leaky case + missing default | wall every case; handle the unmatched |
| D9 | chained comparison | bools are 0/1 — split the range |
| D10 | dangling else | braces make binding visible |

Each class also appears in the [mistake galleries](lesson-2-conditions.md#7-compound-condition-mistakes) — after your hunt, the table entry reads differently: as confirmation, not revelation.
