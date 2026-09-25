---
title: "Unit 01 — Introduction to Programming & C++"
description: "Unit index: what a program is, your first C++ program, and how the pieces fit."
---

<div class="note"><strong>Companion module:</strong> the <a href="../../../cpp-foundations/index.md">C++ Foundations module</a> is the complete, enriched version of this unit's material — study these pages together for extra depth, practice sets, and the variation lab.</div>


# Unit 01 — Introduction to Programming & C++

> Week 1 · 2 sessions · [← Syllabus](../../syllabus.md) · Unit 01/16 · [Course home](../../index.md)

By the end of this unit you can:

- explain what a program, a compiler, and an executable are — in your own words
- run the **edit–compile–run cycle** from the terminal: edit, compile, run, repeat
- write, compile, and run a complete C++ program
- name the parts of a minimal program and what each part does
- print output with `std::cout`, and control line breaks with `\n` vs `endl`
- read your first compiler errors calmly and fix them

## Sessions

| | Lesson | You learn |
| --- | --- | --- |
| 1.1 | [What is a program, and how does one run?](sessions/session-1.1.md) | programs, compilers, the cycle, the terminal, Hello world |
| 1.2 | [Anatomy of a program](sessions/session-1.2.md) | every line of Hello world explained; `cout` details; reading errors |

## Examples (compile each as you study)

| File | Demonstrates | Used in |
| --- | --- | --- |
| [`01_hello.cpp`](examples/01_hello.cpp) | the minimal program + output | [Lesson 1](sessions/session-1.1.md) |
| [`02_anatomy.cpp`](examples/02_anatomy.cpp) | the same program, heavily commented | [Lesson 2](sessions/session-1.2.md) |
| [`03_output_basics.cpp`](examples/03_output_basics.cpp) | chaining, `\n` vs `endl`, multi-line output | [Lesson 2](sessions/session-1.2.md) |

## Practice

| Component | Link | Notes |
| --- | --- | --- |
| Exercises | [exercises.md](exercises.md) | 10 items: predict, fix, create |
| Lab 01 | [brief](labs/lab-01.md) · [starter](labs/starter/lab-01.cpp) · [Debug It](labs/starter/lab-01-debug-it.cpp) · [solution](labs/solution/lab-01-solution.cpp) | attempt before opening the solution! |
| Quiz 01 | [quiz](quiz.md) · [answer key](quiz-answers.md) | 10 questions; attempt all first |
| Revision | [revision.md](revision.md) | summary + mistakes checklist + flashcards |

## Status of this unit

- ✅ Lessons 1.1 and 1.2, examples, exercises, lab, quiz, revision — published
- ✅ Debug activities, output predictions, and challenge problems — provided
  by the companion [C++ Foundations module](../../cpp-foundations/index.md)
  ([debugging](../../cpp-foundations/debugging.md),
  [predictions](../../cpp-foundations/predictions.md),
  [challenges](../../cpp-foundations/challenges.md))
- All examples compile with
  `g++ -std=c++17 -Wall -Wextra <file>.cpp -o <program>`

*[← Syllabus](../../syllabus.md) · [How to Study](../../how-to-study.md) ·
Next unit: 02 — Variables, Data Types & Arithmetic (the
[C++ Foundations module](../../cpp-foundations/index.md))]*
