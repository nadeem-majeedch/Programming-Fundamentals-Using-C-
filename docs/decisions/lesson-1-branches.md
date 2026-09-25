---
title: "Lesson 1 — The Decision Statement"
description: "if, if-else, else-if ladders, and nested decisions: syntax, control flow, dry runs, and the mistakes that come with each."
---

# Lesson 1 — The Decision Statement

> [← Module home](index.md) · [Lesson 2 — Conditions →](lesson-2-conditions.md)

## In this lesson you will learn

- the shape of `if`, `if-else`, and `else-if` — and what "takes the other branch" means
- why the condition must be in parentheses and the body should be in braces
- how `else-if` ladders pick **exactly one** branch — and why order matters
- how to nest decisions safely and when nesting beats a ladder
- how to dry-run a decision like a [trace table](../problem-solving/lesson.md#1516-dry-runs-and-trace-tables) does

Everything here builds on the decision-making ideas from [Problem Solving, Lesson §8](../problem-solving/lesson.md#13-decision-making); today we write them in C++.

---

## 1. A program that chooses

So far your programs have been *highways*: every statement runs, top to bottom, every time. A decision statement builds a fork in the road:

```text
              ┌──────────────┐
              │  condition?  │      the question — always true or false
              └──────┬───────┘
              true   │   false
          ┌──────────┴──────────┐
          ▼                     ▼
   ┌─────────────┐       ┌─────────────┐
   │  branch A   │       │  branch B   │   exactly one runs
   └──────┬──────┘       └──────┬──────┘
          └──────────┬──────────┘
                     ▼
              code continues here          both roads rejoin
```

The question is a **condition** — an expression whose value is `true` or `false` (Lesson 2 covers building them). In C++, the fork is written with `if` / `else`.

## 2. `if` — do this *if*, otherwise skip

```cpp
if (condition)
{
    statements;   // runs only when condition is true
}
// execution always continues here
```

- **`if`** — keyword that starts the decision.
- **`(condition)`** — the question, in parentheses (required).
- **`{ ... }`** — the **body**: statements that run only when the answer is `true`. With braces, the body may be one line or twenty.
- Nothing is printed and nothing fails when the condition is `false` — the body is simply *skipped*, and the program continues after the block.

**Example — exam eligibility:**

```cpp
#include <iostream>
int main() {
    int marks;
    std::cout << "Enter marks (0-100): ";
    std::cin >> marks;

    if (marks >= 40)                       // condition: question about marks
    {
        std::cout << "You passed.\n";      // body: runs only for 40..100
    }

    std::cout << "Done.\n";                // NOT in the body: always runs
    return 0;
}
```

- `marks = 72` → condition `72 >= 40` is `true` → prints **You passed.** then **Done.**
- `marks = 25` → condition is `false` → body skipped → prints only **Done.**

**Practice:** before running, [predict the output](#4-dry-run-a-decision) for `marks = 40`. (The boundary — Lesson 2 §5 — says `>=` includes it.)

## 3. `if-else` — one of exactly two roads

```cpp
if (condition)
{
    // A: runs when condition is true
}
else
{
    // B: runs when condition is false
}
```

Exactly **one** branch runs — never both, never neither. That guarantee is the whole point of `else`: it makes "the other case" explicit instead of leaving it to luck.

**Example — even or odd (the `%` remainder trick):**

```cpp
if (number % 2 == 0)
{
    std::cout << "even\n";     // remainder 0 when dividing by 2
}
else
{
    std::cout << "odd\n";      // remainder 1 — any other case
}
```

> The `==` (double equals) **compares**; the single `=` **assigns**. Writing `if (number = 2)` is one of the two classic mistakes — Lesson 2 §7 and [D1](debugging.md#d1--the-missing-) hunt it.

<a name="4-dry-run-a-decision"></a>
## 4. Dry-run a decision before you trust it

Take this tiny program and fill the table by hand — no compiler:

```cpp
std::cin >> marks;
if (marks >= 40) { std::cout << "PASS\n"; }
else             { std::cout << "FAIL\n"; }
std::cout << "checked\n";
```

| marks | `marks >= 40` | branch taken | output lines |
| --- | --- | --- | --- |
| 95 | true | if | PASS, checked |
| 40 | | | |
| 39 | | | |
| 0 | | | |

Fill every row yourself; the **the row for 40 is the one people get wrong** (it's `true` — `>=` includes 40; see [boundary conditions](lesson-2-conditions.md#5-boundary-conditions-the--vs--trap)). Checking both sides of a boundary like this is the cheapest test you will ever write.

<a name="5-else-if--a-ladder-of-questions"></a>
## 5. `else-if` — a ladder of questions

When there are more than two outcomes, chain questions into a **ladder**. C++ runs it top to bottom and takes the **first** condition that is true; everything after is skipped — even if their conditions would also be true:

```cpp
if (marks >= 80)
{
    grade = 'A';               // tried first
}
else if (marks >= 70)
{
    grade = 'B';               // reached only when marks < 80
}
else if (marks >= 60)
{
    grade = 'C';
}
else if (marks >= 40)
{
    grade = 'D';
}
else
{
    grade = 'F';               // every question above answered false
}
```

Two properties make ladders work:

- **Descending order does the range work for you.** By the time the `>= 70` question is asked, we already know `marks < 80` (the first question failed). Each `else` carries an invisible *"and not any condition above"*. Writing `else if (marks >= 70 && marks < 80)` is legal but redundant — the ladder already guarantees it.
- **The final `else` is the catch-all.** With it, every possible value gets exactly one grade. Omit it and `marks = 33` gives `grade` no value at all — a bug that shows up later, far from the cause.

**Why order matters:** flip the ladder (`>= 40` first) and every passing mark grabs `'D'` and leaves — the later questions never get a chance. **Rule: from most specific/most demanding to least, or make every condition self-contained.**

> **Gap discipline:** a ladder should *partition* its inputs — every value falls in exactly one branch. Check your ladder with the boundary values of each band: 79, 80, 69, 70, … plus one value below the lowest band. [P4](predictions.md#p4--the-ordered-ladder) walks exactly this.

<a name="6-nested-decisions--a-question-inside-an-answer"></a>
## 6. Nested decisions — a question inside an answer

Any branch may contain further decisions — a question you only *need to ask* after the first is answered:

```cpp
if (age >= 18)                        // outer gate: adult?
{
    if (hasId)                        // inner question: only worth asking for adults
    {
        std::cout << "Entry allowed\n";
    }
    else
    {
        std::cout << "Adult, but bring ID\n";
    }
}
else
{
    std::cout << "Entry denied: under 18\n";
}
```

The inner `if` runs **only when the outer condition is true**. Structure matters more than syntax here:

- **Indent every nesting level** — the indentation *is* the logic diagram. If you can't tell at a glance which `else` belongs to which `if`, the compiler still can (each `else` binds to the *nearest unmatched* `if`), but you can't, and that's how bugs survive.
- **Nest when the second question is genuinely conditional** ("adults: do they have ID?"). If both questions are always worth asking, prefer `&&` in one condition (Lesson 2 §3).

**Rewrite check:** the same rule can also be expressed as `if (age >= 18 && hasId)` / `else if (age >= 18)` / `else`. All correct — pick the shape that mirrors how the *requirement* phrases it.

<a name="7-braces-the-silent-killer"></a>
## 7. Braces: the silent killer

The braces are optional for a **single** statement — and that "feature" is a trap:

```cpp
if (marks >= 40)
    std::cout << "PASS\n";
    std::cout << "Well done!\n";      // NOT guarded! always prints
```

The `if` owns only the *one* statement after it. The second line is unconditional. It compiles, it runs, it lies. **House rule for this course: always use braces**, even for one-line bodies. The compiler won't save you here; only the habit will. Hunt [D2](debugging.md#d2--the-unbraced-body) for the full crime scene.

> Related C++ fact, so it doesn't surprise you later: a stray semicolon gives an `if` an *empty* body — `if (cond); { ... }` — and the block then runs unconditionally. [D3](debugging.md#d3--the-stray-semicolon) hunts one.

<a name="8-beginner-mistakes-gallery-lesson-1-set"></a>
## 8. Beginner mistakes gallery (Lesson 1 set)

| # | Mistake | Symptom | Fix |
| --- | --- | --- | --- |
| M1 | `=` instead of `==` in the condition | condition is the *assigned* value; with `if (x = 0)` the body never runs | compare with `==`; compile with `-Wall` so gcc warns |
| M2 | unbraced second statement "inside" the if | second line always runs | brace every body |
| M3 | ladder bands unordered | high marks get low grades; some values fall through | most-demanding-first, or self-contained ranges |
| M4 | missing final `else` | some inputs leave the outcome unset | end with a catch-all, or prove every case is covered |
| M5 | `else` dangling to the wrong `if` after nesting | inner `else` swallows the outer case | indent, brace, and dry-run both sides |
| M6 | `;` after `if (…)` | body runs always (or never) | no semicolon before the block |

Every one of these appears as a full [debugging hunt](debugging.md) with hints — but try each hunt *before* this table spoils it.

---

## Recap — you can now

- [ ] write `if`, `if-else`, and `else-if` ladders with braces
- [ ] explain why a ladder takes exactly one branch and why order matters
- [ ] nest decisions with clean indentation
- [ ] dry-run a decision on paper before compiling
- [ ] list the six Lesson-1 mistakes on demand

**Next:** [Lesson 2 — Conditions and boundaries](lesson-2-conditions.md): building the *questions* themselves — comparison, logical, compound, and the `>` vs `>=` trap that decides pass/fail.
