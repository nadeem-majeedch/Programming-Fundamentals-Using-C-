---
title: "Week 0 Exercises"
description: "10 beginner exercises and 5 challenges for the Getting Started module."
---

# Week 0 Exercises

> 10 beginner + 5 challenge · save as `eNN_description.cpp` in `unit-00/` ·
> attempt everything before the [answers](#answers-to-selected-exercises) ·
> [← Orientation hub](index.md)

All programs compile with the course command:

```bash
g++ -std=c++17 -Wall -Wextra eNN_description.cpp -o eNN
./eNN            # Windows: .\eNN.exe
```

(If any exercise needs it, the [Getting Started lesson](getting-started-lesson.md)
sections are linked inline. Predict before running — that habit starts now.)

---

## Part A — 10 beginner exercises

**E1 · `e01_greeting.cpp` — two-statement greeting.** Print exactly:

```text
Hello, student!
Welcome to C++.
```

…using **exactly two** `std::cout` statements. (§11–12 of the lesson.)

**E2 · `e02_oneline.cpp` — same output, one statement.** Print the same two
lines using **one** `std::cout` statement and one `"\n"`.

**E3 · `e03_escape.cpp` — escape artist.** Print exactly this text,
including the quotes and the backslash:

```text
The file is "C:\cpp\hello.cpp"
```

You will need both `\"` and `\\`. (Lesson §2, special characters table in
[Unit 01 Lesson 2](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.2.md#2-stdcout--output-piece-by-piece)
helps.)

**E4 · `e04_errors.cpp` — error safari (compile errors).** Start from the
first-program listing. Make each change **separately**, compile, and write
down the compiler's *first* error message; then undo the change. Four
safaris: (a) delete the `;` on the cout line; (b) `#inclde` instead of
`#include`; (c) `std::cuot`; (d) remove the closing `}` of `main`.
Deliverable: your bug diary now has four entries with the exact messages.

**E5 · `e05_predict.cpp` — predict before running.** What does this print?
Write the prediction **on paper first**, then run and check:

```cpp
std::cout << "A" << "B" << "\n";
std::cout << "C";
std::cout << "D\nE\n";
```

**E6 · `e06_menu.cpp` — menu mock.** A menu is just formatted text (real
menus arrive in Unit 04). Print exactly:

```text
==== MAIN MENU ====
1) Start
2) Options
3) Exit
===================
```

Border lines are the same width; use one statement per line.

**E7 · `e07_tabs.cpp` — tabular.** Using `\t` and two statements, print:

```text
Name    Marks
Ayesha  91
Bilal   84
```

Your column alignment should look tidy in the terminal — the *columns*
align; exact spacing depends on your terminal's tab stops.

**E8 · `e08_platform.cpp` — platform report.** Print three lines: your
operating system, your compiler's name (`g++` or `clang++`), and the compile
command you use (as text). Example:

```text
OS       : Windows
Compiler : g++
Command  : g++ -std=c++17 -Wall -Wextra e08_platform.cpp -o e08
```

**E9 · `e09_breakfix.cpp` — one bug, three ways.** Write a correct
three-line greeting program. Then produce its broken copy **three times**,
each broken differently but so that each still fails to compile: a missing
`;`, a missing `"`, a misspelled `main`. Record all three messages. (You
are building an error vocabulary on purpose.)

**E10 · `e10_explain.cpp` — annotate.** Take the first-program listing and
add a `//` comment to *every* line explaining it in your own words — no
copying the lesson's wording. If a comment needs the word "magic", rewrite
it until it doesn't.

---

## Part B — 5 challenge exercises

Open-ended, ★-rated. No published solutions — your output and a clean
compile are the judges. *(★ = think + tinker; ★★ = one new idea; ★★★ =
real design.)*

**C1 ★ · `c01_poster.cpp`.** Print a centered-ish poster of your name (five
lines: border, blank-ish padding line, name, padding, border), all borders
the same width, using only `cout`, `\n`, spaces, and `=`. Bonus: make the
borders exactly match the widest line — count characters by hand.

**C2 ★ · `c02_silent.cpp`.** Write a program that compiles with **zero
warnings** but prints nothing at all (no output, exit code 0 — it must
still be a valid program). Then write your one-sentence explanation of how
a valid program can produce no output. *(Hint: a program can be a complete,
correct... no-op.)*

**C3 ★★ · `c03_cascade.cpp`.** Produce a program with **at least five
compiler errors from a single root cause**, then diagnose it: which single
fix makes how many errors disappear? Document the cascade in comments —
this is forensic training for the error messages you'll meet all course.

**C4 ★★ · `c04_hexagon.cpp`** *(platform-smart)*. Write one source file
that prints your OS name in a decorative box, e.g.:

```text
+------------------+
|                  |
|    Windows       |
|                  |
+------------------+
```

The **portability challenge**: the same file must compile unchanged on all
three platforms (that's automatic — `cout` is `cout`), but pick box widths
that don't wrap in any terminal. Verify once on a second platform (a lab
machine, a friend's, or an [online compiler](compiler-setup/online-compilers.md))
if you can, and note what was identical and what differed (the *commands*,
never the code).

**C5 ★★★ · `c05_workflow.cpp`.** Demonstrate the full professional loop on
one file, documented: write the program to print a four-line motivational
quote **one line at a time**, compiling after each added line (`git` users:
commit after each compile). Then break it in a new way of your choosing,
capture the error, fix it, and finish with a `// LESSON:` comment at the
bottom summarising what the cycle taught you. The deliverable is the
*process*, visible in your bug diary / commit log.

---

## Answers to selected exercises

<details markdown="1">
<summary><strong>Reveal (attempt E1–E7 first!)</strong></summary>

**E1.**

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, student!\n";
    std::cout << "Welcome to C++.\n";
    return 0;
}
```

**E2.** One statement, newline inside the string:

```cpp
std::cout << "Hello, student!\nWelcome to C++.\n";
```

**E3.**

```cpp
std::cout << "The file is \"C:\\cpp\\hello.cpp\"\n";
```

`\"` for each quote; `\\` for the single backslash.

**E5.**

```text
AB
CDE
```

Statement 1 sends `A`, `B`, newline — one line `AB`. Statement 2 prints `C`
with **no** newline; statement 3 continues `D`, newline, `E`, newline — so
line 2 is `CDE` and line 3 is `E`.

**E6.**

```cpp
#include <iostream>

int main() {
    std::cout << "==== MAIN MENU ====\n";
    std::cout << "1) Start\n";
    std::cout << "2) Options\n";
    std::cout << "3) Exit\n";
    std::cout << "===================\n";
    return 0;
}
```

**E7.**

```cpp
std::cout << "Name\tMarks\n";
std::cout << "Ayesha\t91\nBilal\t84\n";
```

(One or two statements both fine — columns come from `\t`, not from
statement count.)

</details>

---

*[← Orientation hub](index.md) · [Lab 00](getting-started-lab.md) ·
[Setup checklist](setup-checklist.md)*
