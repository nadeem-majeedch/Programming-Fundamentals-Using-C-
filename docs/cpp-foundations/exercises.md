---
title: "C++ Foundations — Exercises (24)"
description: "24 exercises in three parts: concept checks, predict-and-code, and code-it tasks."
---

# C++ Foundations — Exercises

> 24 items · attempt everything before
> [the answer key](#answers-to-selected-exercises) · [← Module home](index.md)

Save as `eNN_description.cpp` in your module folder
([naming discipline](../getting-started/getting-started-lesson.md#19-how-students-should-save-their-exercises));
compile line for everything:

```bash
g++ -std=c++17 -Wall -Wextra eNN_description.cpp -o eNN
```

**E1–E8** concept checks (written answers) · **E9–E16** predict + code ·
**E17–E24** code-it tasks. Answers for the *odd* concept checks and all
predict items are in the collapsible key; code tasks are self-checked by
compiling + the stated test.

---

<a name="part-a---concept-checks-1-8"></a>
## Part A — concept checks (1–8)

**E1.** Name the four structural parts of a minimal C++ program, in order,
one phrase each.

**E2.** What exactly does `return 0;` in `main` communicate, and to whom?

**E3.** Give one *good* reason to write a comment and one *useless* reason.

**E4.** Are `total`, `Total`, and `TOTAL` the same variable? What property
of identifiers does this demonstrate?

**E5.** State the two identifier rules the *compiler* enforces, and two
conventions this course enforces.

**E6.** Your teammate writes `int x;` then immediately `std::cout << x;`.
What is wrong, what might print, and what is the course rule that prevents
it?

**E7.** For each value, name its literal type: `42` · `42.0` · `'4'` ·
`"42"` · `true`.

**E8.** Why does the course say constants deserve `UPPER_SNAKE_CASE`?
What two benefits does `const` give beyond naming?

---

<a name="part-b---predict-and-code-9-16"></a>
## Part B — predict and code (9–16)

**E9 · `e09_boxes.cpp`.** Predict, then write a program that: declares
`score` initialized to 10, prints it, assigns 25, prints it, then adds 5
via `score = score + 5`, prints it. Were your predictions right?

**E10 · `e10_identifiers.cpp`.** Circle the illegal identifiers and state
the rule broken: `2fast`, `my_score`, `for`, `Total`, `student count`,
`_hide`, `passMark`, `class`.

**E11 · `e11_rename.cpp`.** Rewrite this fragment with course-convention
names (and say what each variable means):

```cpp
int a = 7, b = 25;
int c = a * b;
std::cout << c;
```

**E12 · `e12_ints.cpp`.** Predict each output, then verify:

```cpp
int a = 1000000;
std::cout << a * 3 << "\n";          // ?
std::cout << a * 3000 << "\n";       // ?  (!!)
long long b = 1000000LL * 3000;      // ?
std::cout << b << "\n";
```

**E13 · `e13_doubles.cpp`.** Predict, then verify: `7 / 2`, `7 / 2.0`,
`7.0 / 2`, `7 % 2`, `7 % 2.0` (this last one won't compile — why?).

**E14 · `e14_chars.cpp`.** Predict, then verify:

```cpp
char c = 'C';
std::cout << c << "\n";        // ?
std::cout << c + 1 << "\n";    // ?
std::cout << static_cast<char>(c + 1) << "\n";   // ?
```

**E15 · `e15_bools.cpp`.** Predict, then verify:

```cpp
bool a = true;
bool b = (3 > 7);
std::cout << a << "\n";        // ?
std::cout << b << "\n";        // ?
std::cout << a + b << "\n";    // ?
```

**E16 · `e16_strings.cpp`.** Write a program with `firstName`, `lastName`,
printing: full name (concatenated with a space), its length, and the
length of your *first* name alone. Then predict-and-check: what does
`firstName + 1` do? (Don't fix it — just record the error message in your
bug diary.)

---

<a name="part-c---code-it-18-24"></a>
## Part C — code it (17–24)

**E17 · `e17_constants.cpp`.** A canteen charges `TEA_PRICE = 15`,
`COFFEE_PRICE = 40`. Read cups of each (two `int`s) and print the bill
line `Tea x 2 : 30` style, plus total. No literal 15/40 anywhere except
the constant definitions.

**E18 · `e18_literals.cpp`.** Write one statement per literal *type*
(int, double, char, string, bool) printing each; then in a comment, write
the type of the expression `'A' + 1` — and verify by printing it.

**E19 · `e19_moments.cpp`.** Demonstrate all three moments
(declaration / initialization / assignment) with one variable `level`,
including one deliberate *read of a garbage variable in a comment*
(explaining what the compiler said when you tried).

**E20 · `e20_arith.cpp`.** Read two ints `a`, `b` (non-zero). Print all
five: `a + b`, `a - b`, `a * b`, `a / b`, `a % b` — one per line, labelled.
Then: what does `a / b` print for 7, 2? For −7, 2? Record both in the
file's comments.

**E21 · `e21_relations.cpp`.** Read marks (int). Print each comparison on
its own line: `marks >= 50`, `marks > 50`, `marks == 50`, `marks != 50`.
Then run with input 50 — how many lines print `1`? Why exactly four?

**E22 · `e22_logic.cpp`.** Read an age and a `y/n` answer (has-ID, as in
the Problem-Solving module). Print the two bools `canEnter` =
`(age >= 18 && hasID)` and `eligible = (age >= 18 || hasID)` as `1`/`0`.
Test all four y/n × two ages (16, 20) — the 2×2 grid.

**E23 · `e23_incdec.cpp`.** Write the four-line experiment from
Lesson 3 §3.4 (postfix `a++` vs prefix `++c` into new ints) from *memory*,
predict all four outputs, then verify. Then add `count += 3;` and
`count -= 7;` starting from 10, printing after each — predict first.

**E24 · `e24_cast.cpp`.** Read `total` and `count` (ints). Print the
average three ways: `total / count`, `static_cast<double>(total) / count`,
`static_cast<double>(total / count)`. Run with 17 and 2; explain the three
outputs in a comment. (This is Lesson 4's crown-jewel exercise.)

---

## Answers to selected exercises

<details markdown="1">
<summary><strong>Reveal (attempt first!)</strong></summary>

**A1.** `#include` lines (libraries) → function definitions → `main()`
(entry point) → statements + `return 0` inside.

**A2.** The value 0 — meaning "finished successfully" — is handed back to
the operating system.

**A3.** Good: recording *why* (a constraint, a source, a decision) that
the code can't show. Useless: restating the *what* (`// print hello`
above a print).

**A4.** Three different variables — identifiers are case-sensitive.

**A5.** Compiler rules: no starting digit; no keywords. Course
conventions: camelCase meaningful names for variables; UPPER_SNAKE for
constants; no single-letter names (except loop counters).

**A6.** `x` is uninitialized — reading it is undefined behaviour (prints
garbage or worse). Rule: initialize at declaration, always.

**A7.** `42` int · `42.0` double · `'4'` char · `"42"` string · `true`
bool.

**A8.** The name carries the meaning (PASS_MARK reads) and `const` makes
accidental change a compile error; one definition = one place to update.

**E12 answers.** `3000000` · `2` (or another garbage-looking value —
`a * 3000` overflows int; the exact print is undefined!) · `3000000000`
(the `LL` forces long-long arithmetic). The middle line is Lesson 4's M5
made real.

**E13 answers.** `3` · `3.5` · `3.5` · `1` · **won't compile** — `%`
requires integer operands (error: invalid operands to binary expression).

**E14 answers.** `C` · `68` (char promotes to int for `+`) · `D` (cast
back to char).

**E15 answers.** `1` · `0` · `1` (true promotes to 1 in arithmetic).

**E21 answer.** Exactly **two** lines print 1 (`>= 50` and `== 50`); the
other two print 0. With 50 exactly on the boundary, `>` and `!=` are
false — the boundary pair logic from the Problem-Solving module, now
observed in your own terminal.

**E24 answers.** `8` (int division) · `8.5` (cast before division) ·
`8.0` (cast after — truncation already happened; the costume change came
too late).

</details>

---

*[← Module home](index.md) · [Output predictions](predictions.md) ·
[Debugging](debugging.md)*
