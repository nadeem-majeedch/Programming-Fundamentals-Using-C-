---
title: "Debugging Exercises (10)"
description: "Ten seeded-bug programs — find, fix, and classify. Hint ladders before fixes."
---

# C++ Foundations — Debugging

> 10 broken programs · hunt **before** opening the
> [fix list](#fix-list) · [← Module home](index.md)

**The hunt protocol** (from Lab 00, now yours): for each program —
(1) read the code and *predict* the intended output; (2) find the bug(s)
by reading; write down what you'd tell the compiler-finder; (3) compile,
read the *first* error, fix **one** thing, recompile; (4) classify each
bug: *compile error / logic error / data-type mistake*; (5) one bug-diary
line. Only then open the fix list. Hints are per-exercise: use them one at
a time.

---

<a name="d1---the-missing-period"></a>
**D1 — The missing period.** *Doesn't compile.*

```cpp
#include <iostream>

int main() {
    std::cout << "Start\n"
    int total = 5;
    std::cout << total << "\n";
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
Read the error's line number — then read the line *above* it.
</details>

<details markdown="1"><summary>Hint 2</summary>
Every statement ends with `;`. Which one doesn't?
</details>

<a name="d2---the-garbage-value"></a>
**D2 — The garbage value.** *Compiles (with a warning). Prints nonsense.*

```cpp
#include <iostream>

int main() {
    int total;
    total = total + 10;
    std::cout << total << "\n";
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
What was *inside* `total` before `total + 10` ran?
</details>

<details markdown="1"><summary>Hint 2</summary>
Read the warning: "variable 'total' is used uninitialized…". Initialize at
declaration.
</details>

**D3 — The invisible name.** *Doesn't compile.*

```cpp
#include <iostream>

int main() {
    cout << "Hello\n";
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
`error: 'cout' was not declared in this scope`. Where does `cout` live?
(Which namespace?)
</details>

<details markdown="1"><summary>Hint 2</summary>
`std::cout`. Every standard-library name wears the `std::` prefix.
</details>

**D4 — The counter that wasn't.** *Compiles. Wrong output.*

```cpp
#include <iostream>

int main() {
    int count = 0;
    count == 1;             // first data item arrives
    count == 1;             // second
    count == 1;             // third
    std::cout << count << "\n";   // expected: 3
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
Run it: prints 0. Three operations happened and changed *nothing* — what
does `==` do? What did you mean?
</details>

<details markdown="1"><summary>Hint 2</summary>
`==` *compares* and discards the answer. Assignment (or `+= 1`/`++`) is
the updater.
</details>

<a name="d5---the-one-character-bug"></a>
**D5 — The one-character bug.** *Compiles (with a warning). Wrong output.*

```cpp
#include <iostream>

int main() {
    int marks = 50;
    if (marks = 40) {
        std::cout << "exactly 40\n";
    }
    std::cout << marks << "\n";
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
Two surprises: "exactly 40" prints *and* marks becomes 40 — from one
line. What does `=` do inside the `if`?
</details>

<details markdown="1"><summary>Hint 2</summary>
`=` assigns (the expression's value is what was stored — truthy). The
comparison operator is `==`.
</details>

<a name="d6---the-average-that-wasnt"></a>
**D6 — The average that wasn't.** *Compiles. Wrong output.*

```cpp
#include <iostream>

int main() {
    int total = 17;
    int count = 2;
    double average = total / count;
    std::cout << average << "\n";      // expected: 8.5
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
Prints 8. The division happened *before* the storage — in which type?
</details>

<details markdown="1"><summary>Hint 2</summary>
Both operands are ints → integer division → 8 → converted to 8.0 *after*.
Cast an operand **before** the division: `static_cast<double>(total)`.
</details>

**D7 — The vanishing fraction.** *Compiles. Wrong output.*

```cpp
#include <iostream>

int main() {
    const double HALF = 1 / 2;      // should be 0.5
    std::cout << HALF << "\n";
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
Same family as D6, but hidden inside a literal expression. What types are
`1` and `2`?
</details>

<details markdown="1"><summary>Hint 2</summary>
Make one operand floating-point: `1.0 / 2` (or cast). Literals are
*ints* until a decimal point says otherwise.
</details>

**D8 — The character that lied.** *Compiles. Wrong output.*

```cpp
#include <iostream>

int main() {
    char digit = '7';
    int value = digit;              // should be 7
    std::cout << value + 1 << "\n"; // expected: 8
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
Prints 56. What is `'7'` *really*? (Lesson 2 §2.6: a number in a costume.)
</details>

<details markdown="1"><summary>Hint 2</summary>
`'7'` is 55. The standard conversion: `digit - '0'` (55 − 48 = 7).
</details>

**D9 — The mutating constant.** *Doesn't compile.*

```cpp
#include <iostream>

int main() {
    const int MAX_MARKS = 100;
    MAX_MARKS = 50;                 // teacher scaled the exam
    std::cout << MAX_MARKS << "\n";
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
`error: assignment of read-only variable 'MAX_MARKS'` — the compiler is
protecting the constant. Is mutating it even the *right* fix?
</details>

<details markdown="1"><summary>Hint 2</summary>
If the value genuinely changes, it isn't a constant: make it a normal
variable with a proper name — or keep the constant and the decision that
uses it.
</details>

**D10 — The loop-shaped leak.** *Compiles. Infinite loop (Ctrl+C to stop).*

```cpp
#include <iostream>

int main() {
    int minutes = 5;
    while (minutes > 0) {
        std::cout << minutes << "\n";
    }
    return 0;
}
```

<details markdown="1"><summary>Hint 1</summary>
The condition never changes — what's missing from the body? (Lesson 2 of
the Problem-Solving module: "what moves toward the stop?")
</details>

<details markdown="1"><summary>Hint 2</summary>
`minutes = minutes - 1;` (or `minutes--;`) at the body's end.
</details>

---

<a id="fix-list"></a>

## Fix list (after your own fixes)

| # | Bug class | Fix | Lesson |
| --- | --- | --- | --- |
| D1 | compile — missing `;` | add `;` to the "Start" statement | [1.3](lesson-1-structure.md#13-statements) |
| D2 | logic — uninitialized read | `int total = 0;` | [2.11](lesson-2-data.md#211-declaration-initialization-assignment) · M6 |
| D3 | compile — undeclared name | `std::cout` | [2.8](lesson-2-data.md#28-strings-introductory) note + [1.1](lesson-1-structure.md#11-c-program-structure) |
| D4 | logic — `==` vs update | `count += 1;` ×3 (or `count++`) | [3.2](lesson-3-operators.md#32-relational-operators) |
| D5 | logic — `=` in condition | `if (marks == 40)` | [3.2](lesson-3-operators.md#32-relational-operators) · M4 |
| D6 | data-type — int division | `static_cast<double>(total) / count` | [4.3](lesson-4-conversion.md#43-explicit-casting) |
| D7 | data-type — int literals | `1.0 / 2` | [4.2](lesson-4-conversion.md#42-implicit-conversion) · M1 |
| D8 | data-type — char code | `int value = digit - '0';` | [2.6](lesson-2-data.md#26-characters) · M3 |
| D9 | design — const misuse | re-think: variable, or redesign | [2.9](lesson-2-data.md#29-constants) |
| D10 | logic — missing update | `minutes--;` in the body | [Problem-Solving §14](../problem-solving/lesson.md#14-repetition) |

**Scoring:** 8+ found-and-classified alone → ready for the
[Lab](lab.md). 6–7 → re-read the linked sections. ≤5 → redo
[predictions](predictions.md) first (they train the reading eye this page
tests).

---

*[← Module home](index.md) · [Challenges](challenges.md) · [Lab](lab.md)*
