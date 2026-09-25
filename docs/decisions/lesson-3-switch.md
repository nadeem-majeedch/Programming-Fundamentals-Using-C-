---
title: "Lesson 3 — Switch and the Conditional Operator"
description: "switch/case/break/default and fallthrough, when switch beats a ladder (and when it doesn't), and the conditional operator ?:"
---

# Lesson 3 — Switch and the Conditional Operator

> [← Module home](index.md) · [← Lesson 2 — Conditions](lesson-2-conditions.md) · [Lesson 4 — Requirements →](lesson-4-requirements-to-decisions.md)

## In this lesson you will learn

- the anatomy of `switch`, and what `break` and `default` really do
- why forgetting `break` compiles and still ruins your output (fallthrough)
- when a `switch` genuinely beats an `else-if` ladder — and the many cases where it can't be used at all
- the conditional operator `?:` as a one-line *value* choice — and when a real `if` is better

---

<a name="1-switch--routing-on-one-value"></a>
## 1. `switch` — routing on one value

An `else-if` ladder asks a *different question* at every step. A `switch` asks one question once — *what is this expression's value?* — and jumps straight to the matching `case`:

```cpp
switch (menuChoice)              // the router: one expression, evaluated once
{
    case 1:                      // a label, not a question
        std::cout << "New game\n";
        break;                   // exit the switch here
    case 2:
        std::cout << "Load game\n";
        break;
    case 3:
        std::cout << "Quit\n";
        break;
    default:                     // no label matched
        std::cout << "Invalid choice\n";
}
```

Reading the parts:

- **`switch (expr)`** — the *router*. Evaluated **once**, then compared against the labels.
- **`case value:`** — a **label**, not a condition. No `>`, no `&&` — a case can only ask "is it *equal to this exact value*?"
- **`break;`** — *leave the switch now*. Without it, execution **falls through** into the next case's code (§3).
- **`default:`** — the catch-all, the `switch` equivalent of the final `else`. Put it last (the only conventional position) and give it a body — "invalid choice" is information too.

**What may go in the switch and case values** (the honest fine print for beginners):

- The router expression must evaluate to an **integer-family value**: `int`, `char`, `bool`, or an `enum`. A `switch` **cannot** route on a `double` or a `std::string`. `switch (marks)` with marks as `double` — which grade is 84.5 nearest to? — is not a legal question. Ladders handle that; switches cannot.
- Case labels must be **compile-time constants**. `case marks:` (a variable) won't compile, and neither does `case x > 5:` — a label is a value, not a question. Ranges like `case 1 ... 5:` are a compiler extension, **not** portable C++; don't use them in coursework.

These restrictions are *why* the "switch vs ladder" choice usually makes itself (§5).

## 2. A realistic example — menu + `char` router

`switch` shines with small fixed menus. `char` is a first-class router because keyboard choices *are* characters:

```cpp
#include <iostream>
int main() {
    char cmd;
    std::cout << "Enter command (a = add, d = delete, l = list, q = quit): ";
    std::cin >> cmd;                      // >> skips spaces, reads one char

    switch (cmd)
    {
        case 'a':
            std::cout << "Adding record...\n";
            break;
        case 'd':
            std::cout << "Deleting record...\n";
            break;
        case 'l':
            std::cout << "Listing records...\n";
            break;
        case 'q':
            std::cout << "Bye!\n";
            break;
        default:
            std::cout << "Unknown command: " << cmd << '\n';
    }
    return 0;
}
```

Note `'a'` not `"a"` — a `char` label uses single quotes (double quotes make a string, and strings can't label a switch). Also note the `default` echoing the bad input back — a tiny detail that makes mis-typed commands debuggable.

<a name="3-fallthrough--the-default-behaviour-you-must-defeat"></a>
## 3. Fallthrough — the default behaviour you must defeat

Without `break`, the program does **not** stop at the next label — it *falls through* and executes everything below until a `break` or the closing brace:

```cpp
switch (level) {
    case 1:
        std::cout << "Steel ";
    case 2:
        std::cout << "Bronze ";
    case 3:
        std::cout << "Silver ";
        break;
    case 4:
        std::cout << "Gold\n";
}
// level 2 prints "Bronze Silver" — labels are doors, breaks are walls
```

- `level = 1` → **Steel Bronze Silver** (falls through two cases, stopped by the break after Silver)
- `level = 2` → **Bronze Silver**
- `level = 3` → **Silver**
- `level = 4` → **Gold** — and *nothing for the earlier cases*; cases below never run backwards

[Mnemonic: labels are doors, `break`s are walls.](#4-intentional-fallthrough-the-stacking-trick) Every case that shouldn't leak gets a wall. GCC's `-Wimplicit-fallthrough` (in `-Wextra`) warns when a case leaks — another reason the course compiles with `-Wall -Wextra`.

<a name="4-intentional-fallthrough-the-stacking-trick"></a>
## 4. Intentional fallthrough — the stacking trick

Fallthrough is a *feature* when several values should share one body. Stack empty cases, then break once:

```cpp
switch (month)
{
    case 12: case 1: case 2:          // winter: three labels, one wall
        std::cout << "Winter\n";
        break;
    case 3: case 4: case 5:
        std::cout << "Spring\n";
        break;
    case 6: case 7: case 8:
        std::cout << "Summer\n";
        break;
    case 9: case 10: case 11:
        std::cout << "Autumn\n";
        break;
    default:
        std::cout << "Invalid month\n";
}
```

The stacked labels mean "any of these values enters here". This is the one fallthrough pattern that reads clearly; anything cleverer usually deserves a ladder instead. (An equivalent ladder with `month == 12 || month == 1 || month == 2` is *also* fine — compare them in exercise [E14](exercises.md#e14--seasons-two-ways).)

> Legacy syntax you may see in older books: `switch (x) { case 1: { ... } break; }` — the braces group statements but don't stop fallthrough; the `break` still does.

<a name="5-switch-vs-ladder-vs--choosing-honestly"></a>
## 5. Switch vs ladder vs `?:` — choosing honestly

| Situation | Reach for |
| --- | --- |
| one variable compared to several **exact** values (menu, command, digit, month) | `switch` — labels document the value set, `default` catches the rest |
| **ranges** (`>= 80`), mixed variables, double/string conditions | `else-if` ladder — switch legally cannot |
| two-way choice producing a **value** | `if-else`, or `?:` when it fits on one line (§7) |
| compound conditions (`&&`/`||`) | `if` / ladder — case labels can't hold them |
| many conditions on *different* variables | chain of ifs — a switch routes on exactly one |

A fair rule of thumb: **if you can't write the case labels as plain constants, you can't write it as a switch.** Everything else is style — and the compiler won't convert a bad choice into a warning, so the test table ([Lesson 2 §5](lesson-2-conditions.md#5-boundary-conditions-the--vs--trap)) remains the referee.

<a name="6-the-conditional-operator--a-decision-that-yields-a-value"></a>
## 6. The conditional operator `?:` — a decision that yields a value

`if-else` is a *statement* — it runs code. The **conditional operator** is an *expression* — it produces a value, so it can live inside an output, an assignment, or an argument:

```text
condition ? valueIfTrue : valueIfFalse
```

```cpp
int max = (a > b) ? a : b;

std::cout << "You " << (marks >= 40 ? "PASS" : "FAIL") << '\n';
```

Read the second line as: *"marks >= 40 ? then the string is PASS, otherwise FAIL."* The parentheses around the whole `?:` are required here — without them `<<` grabs `marks` first and the types stop matching. This is the exact upgrade the [I/O module's Lab 1 extension](../cpp-io/labs.md#lab-1--the-student-information-system) promised: `Result: true/false` becomes `Result: PASS/FAIL` in one line.

Two honest warnings:

- **`?:` chooses values, not actions.** Use it to pick *what to print* or *what to assign*. The moment either side needs multiple statements, it's an `if-else` job.
- **Nesting `?:` is a code smell for beginners.** `a ? b : c ? d : e` is legal and unreadable. Ladders exist. If you can't read your ternary aloud, write the `if`.

With `bool`, one ternary is redundant: `(passed ? "true" : "false")` prints the same as just printing `passed` (`bool` prints as `1`/`0` unless you use the stream trick from [I/O Lesson 1 §7](../cpp-io/lesson-1-cout.md#6-characters-strings-and-computed-values-together) — compare both forms in [P9](predictions.md#p9--the-ternary-print)).

<a name="7-common-switchternary-mistakes"></a>
## 7. Common switch/ternary mistakes

| # | Mistake | Symptom | Fix |
| --- | --- | --- | --- |
| S1 | missing `break` | output runs into the next case's text | wall every non-stacked case |
| S2 | `case "sun":` (string) | won't compile — strings can't label | switch on `char`, or use a ladder |
| S3 | `case grade >= 80:` | won't compile — labels are constants | ladder for ranges |
| S4 | switch on `double`/`std::string` router | won't compile | ladder |
| S5 | shared variable accidentally shadowed in two cases (same name declared in two cases) | compile error — cases share one scope | put each case's body in `{ }`, or declare before the switch |
| S6 | no `default` on a menu | bad input silently does nothing | `default` + feedback |
| S7 | ternary without outer parentheses in a stream | compile error or wrong precedence | wrap the whole `?:` |
| S8 | ternary with side effects (`x > 0 ? x = 1 : x = 2;`) | confusing, error-prone | `if-else` for actions |

---

## Recap — you can now

- [ ] write a switch with break-walled cases and a feedback-giving `default`
- [ ] use stacked cases for shared behaviour — and explain what fallthrough is
- [ ] list what a switch *cannot* do (doubles, strings, ranges, compound conditions)
- [ ] decide between switch, ladder, and `if-else` with reasons, not vibes
- [ ] use `?:` for one-line value choices and know when to refuse it

**Next:** [Lesson 4 — From requirements to decisions](lesson-4-requirements-to-decisions.md): the full discipline — decision tables, flowcharts, pseudocode, C++, dry runs — the same five-stage pipeline the labs demand.
