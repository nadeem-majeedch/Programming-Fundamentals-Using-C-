---
title: "Project 1 — The Calculator"
description: "A four-operation, validation-guarded, decision-driven calculator — the first project: I/O, arithmetic, and branching with a repeat-until-quit flow."
---

# Project 1 — The Calculator

> [← Projects home](index.md) · Tier: Beginner · **Units first: 01–03** — output, variables, arithmetic, input, decisions

## Overview

A console calculator the user runs repeatedly: it asks for two numbers and an operation, prints the result (or an honest error), and offers another calculation until the user quits. It is deliberately small — the point is *finishing something whole*: validation, division-by-zero honesty, clean formatting, and a quit path, all in one program you wrote end to end.

## Learning objectives

After completing this project you can:

- build a complete, repeatable console interaction from input to formatted output
- validate numeric input and division-by-zero at the right moments
- structure a program as decisions over arithmetic — and keep the arithmetic in one place
- run a program against a written test plan and record the results

## Prerequisites

| Unit | What you need from it |
| --- | --- |
| [01](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md) | edit–compile–run, program anatomy |
| [02](../syllabus.md) | variables, `double`, arithmetic, precedence |
| [03](../cpp-io/index.md) | `cin`, validation basics, output formatting |
| 04 (decisions) | `if`/`else` ladders, the comparison operators |

## Requirements

A single-file program `calculator.cpp` that:

1. greets the user and enters a calculation loop;
2. per round: reads two `double` operands and one operator (`+ - * /`);
3. computes and prints the result with 2-decimal money-safe formatting;
4. refuses an unknown operator with a message and no crash;
5. refuses division by zero with a message — the program must not print `inf`;
6. offers `y/n` after each calculation; `n` (or any non-`y`) quits with a goodbye line.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | `12 5 +` prints `12.00 + 5.00 = 17.00` | T1 |
| F2 | `12 5 -` prints `7.00`; `*` prints `60.00` | T1 |
| F3 | `12 5 /` prints `2.40` | T1 |
| F4 | `12 0 /` prints the division-by-zero message; no result line | T2 |
| F5 | operator `^` prints the unknown-operator message; no crash | T3 |
| F6 | `y` continues; anything else quits with a goodbye | T4 |
| F7 | every result is formatted to exactly 2 decimals | T1 |

## Suggested data structures

None beyond variables — deliberately. Three `double`s, one `char`, one accumulator-free loop. The project's structural lesson is *flow control*, not data organization.

## Milestones

Each milestone ends in a running program.

- **M1 — one calculation.** Read two numbers and an operator; print a bare result for `+` only. *Exit: compiles, runs once, quits.*
- **M2 — the operator ladder.** All four operations via `if/else if`. *Exit: T1 passes.*
- **M3 — the refusals.** Division-by-zero and unknown-operator branches. *Exit: T2 and T3 pass.*
- **M4 — the loop.** Wrap in the repeat-until-quit flow. *Exit: T4 passes; the program never needs restarting.*

## Tasks

1. Write the file header comment (name, date, purpose) and `main` skeleton.
2. M1: the three reads and the `+` result.
3. M2: complete the ladder; add `fixed << setprecision(2)`.
4. M3: insert the guard *before* the division branch; add the final `else`.
5. M4: wrap in `do { ... } while (again == 'y');` reading the choice at the loop's end.
6. Run the full test plan; fill in the actual-output column.

## Test plan

| # | Input sequence | Expected |
| --- | --- | --- |
| T1 | `12 5 +` → y → `12 5 -` → y → `12 5 *` → y → `12 5 /` → n | 17.00, 7.00, 60.00, 2.40, then goodbye |
| T2 | `12 0 /` | zero-divisor message only |
| T3 | `12 5 ^` → n | unknown-operator message only |
| T4 | one calculation answered `Y` (uppercase), then `n` | continues on `Y` or quits — decide and document which |
| T5 | `0 0 *` → n | `0.00 * 0.00 = 0.00` (a legitimate calculation) |

## Edge cases

- Negative operands (`-3.5 2 *`) — formatting and the minus sign.
- Very large values (`1e9 1e9 *`) — overflow is *not* your problem to fix at this tier, but note what prints.
- The choice prompt answered with Enter-as-first-char of a word (`yes`) — document how `cin >> char` behaves and why.

## Extension ideas

1. Add `%` (integer-only: validate both operands are whole numbers first).
2. Add a running session count of calculations performed, printed at goodbye.
3. A "memory" feature: recall the previous result as either operand (`r`).

## Grading / self-assessment

Score against the [shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics). Project-specific additions:

- [ ] Division by zero produces a *message*, never `inf` (+1)
- [ ] The unknown operator never produces a result line (+1)
- [ ] The loop is honest: `y` continues, everything else quits, and the behaviour is documented (+1)

## Hints

1. `fixed << setprecision(2)` set once before the first result print stays set for the session.
2. The zero check belongs *before* the `/` branch — inside it, the division has already happened.
3. The quit test runs on the *choice character*, not on the calculation result.

## Complete reference solution

```cpp
// calculator.cpp — Programming Fundamentals Using C++
// Project 1 · The Calculator
// Build: g++ -std=c++17 -Wall -Wextra calculator.cpp -o calculator

#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    cout << "=== Console Calculator ===\n";
    cout << fixed << setprecision(2);

    bool again = true;
    do {
        double a = 0.0, b = 0.0;
        char op = '?';

        cout << "\nFirst number: ";
        cin >> a;
        cout << "Operator (+ - * /): ";
        cin >> op;
        cout << "Second number: ";
        cin >> b;

        if (op != '+' && op != '-' && op != '*' && op != '/') {
            cout << "Unknown operator: " << op << "\n";
        } else if (op == '/' && b == 0.0) {
            cout << "Cannot divide by zero\n";
        } else {
            double result = 0.0;
            if      (op == '+') result = a + b;
            else if (op == '-') result = a - b;
            else if (op == '*') result = a * b;
            else                result = a / b;
            cout << a << " " << op << " " << b << " = " << result << "\n";
        }

        cout << "Another calculation? (y/n): ";
        char choice;
        cin >> choice;
        again = (choice == 'y' || choice == 'Y');
    } while (again);

    cout << "Goodbye — " << "thanks for calculating!\n";
    return 0;
}
```

## Explanation of important design decisions

- **The vocabulary check comes first.** Testing `op` against the four legal symbols *before* any arithmetic means the ladder's `else` is genuinely unreachable-bad-input, and the zero-division test only runs for a legal operator. Ordering the guards cheapest-and-broadest first is the validation habit the whole course builds on.
- **One result variable, one print.** The ladder assigns; the print happens once after it. Every alternative (printing inside each branch) quadruples the formatting surface and is where students first meet "why does this line differ from that one?"
- **`do-while` for the conversation.** The user must see the prompts before any exit condition can exist — the repeat-until shape matches the domain (a conversation), and the choice read at the *end* of the body keeps the exit test next to the data it tests.
- **`Y` is accepted.** Strictly `y`-only is defensible; accepting both cases and *documenting it in the test plan* is the professional choice — the program's vocabulary is its contract, and T4 records it.

[← Projects home](index.md) · Next: [Project 2 — Number Analysis Toolkit](project-02-number-analysis.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
