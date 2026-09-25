---
title: "Lab 01 — First Program Lab"
description: "Unit 01 lab: build an ID card program, then hunt four seeded bugs in the Debug It file."
---

# Lab 01 — First Program Lab

> Unit 01 · ~45–90 min · attempt before opening the [solution](solution/lab-01-solution.cpp) ·
> [Unit index](../index.md)

## The scenario

The registrar's office prints a simple text **student ID card** for every new
student. You are writing the printer.

## Files

| File | Purpose |
| --- | --- |
| [`starter/lab-01.cpp`](starter/lab-01.cpp) | skeleton with `// TODO` markers — your starting point |
| [`starter/lab-01-debug-it.cpp`](starter/lab-01-debug-it.cpp) | the same program with **4 seeded bugs** — part 2 of the lab |
| [`solution/lab-01-solution.cpp`](solution/lab-01-solution.cpp) | a complete solution — open **only after** your attempt |

## Part 1 — Build the card printer

**Requirements**

1. Print a card with: a title line `==== STUDENT ID ====`; your **name**; a
   **programme** line (e.g. `BS Data Science`); a **year** line; and a
   closing border of the same width as the title.
2. Every output line ends with a newline (`\n`).
3. The program compiles with **zero warnings**:
   `g++ -std=c++17 -Wall -Wextra lab-01.cpp -o lab-01`
4. Use at least one **chained** `<<` statement (two pieces sent in one
   statement) — see [Lesson 2](../sessions/session-1.2.md).

**Expected output** (shape — your details differ):

```text
==== STUDENT ID ====
Name     : Ayesha Khan
Programme: BS Data Science
Year     : First
=====================
```

**Method (from the [Study Guide](../../../getting-started/study-guide.md)):**
write the steps as comments first; compile after *every* line; grow the
program one output line at a time.

## Part 2 — Debug It

Open [`starter/lab-01-debug-it.cpp`](starter/lab-01-debug-it.cpp). It looks
like a working card program but contains **4 seeded bugs** — a mix of
compile errors and a wrong-output mistake.

**Rules of the hunt**

- Find and fix the bugs **by reading** first; write down each bug before you
  fix it.
- Compile after each single fix — and watch how the error list *shrinks*
  (usually the first bug causes the later errors).
- Use a 3-step hint ladder if stuck: reread
  [Lesson 2 §4](../sessions/session-1.2.md#4-reading-compiler-errors-without-panic)
  → check the [error catalogue](../../../toolchain/compiler-errors.md) →
  then (only then) compare with the solution.

**Done means:** the debug file compiles warning-free and prints the card
correctly, and you can say for each of the 4 bugs *what it was* and *how the
compiler told you* (or didn't, for the wrong-output bug).

## Self-check (score yourself, /5)

1. [ ] Card prints with correct shape and my details
2. [ ] Compiles with zero warnings
3. [ ] Used at least one chained `<<`
4. [ ] All 4 Debug It bugs found, fixed, and explained in my own words
5. [ ] My bug diary has ≥ 4 entries from this lab

Score 5/5 and quiz ≥ 90% → Unit 01 done ([how scoring works](../../../assessment.md#self-scoring-bands)).

---

*[← Unit index](../index.md) · [Quiz 01](../quiz.md)*
