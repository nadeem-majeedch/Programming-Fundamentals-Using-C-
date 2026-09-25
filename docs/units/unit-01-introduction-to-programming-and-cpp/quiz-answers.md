---
title: "Quiz 01 — Answer Key"
description: "Full answers with explanations for Quiz 01. Read even the ones you got right."
---

<div class="note" markdown="1"><strong>Companion module:</strong> the [C++ Foundations module](../../cpp-foundations/index.md) is the complete, enriched version of this unit's material — study these pages together for extra depth, practice sets, and the variation lab.</div>


# Quiz 01 — Answer Key

> The explanations are the lesson · [Quiz](quiz.md) · [Unit index](index.md)

| Q | Answer |
| --- | --- |
| Q1 | **b** |
| Q2 | **c** |
| Q3 | **a** |
| Q4 | **False** |
| Q5 | **False** |
| Q6 | **True** |
| Q7 | see below |
| Q8 | see below |
| Q9 | line 3 — missing `;` |
| Q10 | **b** |

---

**Q1 — b.** A compiler *translates* your source file into machine-code
instructions and writes them to an executable file. (a) describes an
*interpreter* — a different execution model, not what g++ does; (c) and (d)
confuse the compiler with other tools in the toolchain. It's worth being
precise here: "the compiler" and "the terminal" are different programs doing
different jobs.

**Q2 — c.** The course's standard line: standard (`-std=c++17`), warnings
(`-Wall -Wextra`), source file (`card.cpp`), output name (`-o card`).
(a) isn't a command that exists; (b) compiles but (i) without our warning
flags and (ii) produces a default-named executable (`a.out` / `a.exe`), not
`card`; (d) jumbles `-o` with the source name — `-o` expects the *output
name* right after it.

**Q3 — a.** Execution of every C++ program starts at the function `main`.
The other options describe things `main` does not do — data lives in
variables, and compiling is entirely the compiler's job.

**Q4 — False.** A comment is ignored by the compiler; it never reaches the
executable and never prints. Printing needs `std::cout`. (Comments exist to
explain code to humans.)

**Q5 — False — and this one matters.** A warning means the compiler *can*
proceed but thinks something looks wrong. It still produces an executable.
This course treats warnings as errors to fix immediately, but that's our
discipline, not a compiler limitation.

**Q6 — True.** The `.cpp` file is the *source* (text for humans + the
compiler). The executable is the machine-code file you actually run:
`./card` (Linux/macOS) or `.\card.exe` (Windows). Running the `.cpp` does
nothing useful.

**Q7.**

```text
Roses are red
Violets are blue
```

The first statement has **no** `\n`, so `Roses` and ` are red` share a line;
each later statement ends with `\n`.

**Q8.**

```text
1       2
3       4
```

`\t` jumps to the next tab stop (columns align); `\n` ends each line. Exact
gap width depends on your terminal's tab stops.

**Q9 — line 3, missing `;`.** The statement
`std::cout << "Hi\n"` is not terminated. Notice the subtlety we practised:
the compiler may *report* the problem at line 4 (`expected ';' before
'return'`) because that's where it became confused — the mistake is one line
**above** the report. Read upward.

**Q10 — b.** `\b` is the backspace escape character. The program compiles
cleanly (it's *legal* C++ — that's why no warning fires) and prints
`Welcome to`, backspaces one position, then ` C++`. On many terminals you'll
see `Welcome to C++` with the `o` overwritten — clearly not intended. This
is your first taste of a **logic/typo bug that the compiler cannot catch**:
it compiles, it runs, and it's wrong. Only comparing actual output with
intended output finds it — which is exactly what the Debug It hunts train.

---

**Scoring:** 1 point each. **≥ 9** → Unit 01 complete. **7–8** → revisit the
flagged lessons. **≤ 6** → redo the [exercises](exercises.md) and
[revision sheet](revision.md), then retake.
([bands](../../assessment.md#self-scoring-bands))

*[← Quiz](quiz.md) · [← Unit index](index.md)*
