---
title: "Unit 07–08 — Functions"
description: "Why functions, declaration/definition/call, parameters and arguments, return values, scope, pass-by-value, references, overloading, defaults, decomposition, and refactoring."
---

# Functions — Breaking Problems into Machines

> [← Course home](../index.md) · [← Iteration module](../repetition/index.md) · Unit 07–08/16 · [Syllabus](../syllabus.md#stage-c-structure-units-7-9)

You can now write programs of any shape: decisions to choose, loops to repeat. But everything so far has lived in one `main()` — and the mini-project showed what happens at scale: **eighty lines of copy-pasted input readers**, five accumulators in one scope, and no way to test one piece alone. Functions fix all three. This is the unit where programs stop growing *longer* and start growing *structured*.

## In this module you will learn

- the function machine: declaration, definition, call — and parameters vs arguments
- return values and `void`; `return` as both an exit and an answer
- **pass-by-value**: the copy rule, and why it protects callers
- scope: local variables, global variables, and why the course bans the latter
- **decomposition** — breaking a large problem into functions you could test one by one
- basic **references** (`double&`, `string&`): letting one function hand results back
- **function overloading** and **default arguments** — same name, different jobs
- refactoring: turning a giant `main()` into a team of functions — safely, one step at a time
- **testing functions**: the per-function test table, and why small units make testing possible at all

## Module map

| Page | What's inside |
| --- | --- |
| [Lesson 1 — The function machine](lesson-1-machine.md) | Declaration/definition/call, parameters vs arguments, return values, `void`, visual call flow, trace tables |
| [Lesson 2 — Copies, scope, prototypes](lesson-2-scope.md) | Pass-by-value, local/global variables, function prototypes, decomposition as a method |
| [Lesson 3 — References & testing](lesson-3-references-testing.md) | `&` parameters that write back, `const&` for big inputs, per-function test tables, reusable code |
| [Lesson 4 — Overloading, defaults, refactoring](lesson-4-overloading-refactoring.md) | Same name, different signatures; default arguments; a full refactor walkthrough; the common errors gallery |
| [Exercises](exercises.md) | 26 exercises with separated solutions (S1–S26) |
| [Debugging](debugging.md) | 10 seeded function bugs — find/fix/reflect |
| [Refactoring](refactoring.md) | 10 before/after refactoring exercises |
| [Challenges](challenges.md) | 10 challenges with separated solutions |
| [Labs](labs.md) | 8 multi-function design labs |
| [Mini-project](miniproject.md) | The Menu-Driven Utility Toolkit, built progressively with functions |

## Try it yourself first

The same rule as every module: **attempt 15 minutes before opening any solution**. Here it has an extra edge — function *design* has no single right answer, so comparing your decomposition with the solution's is where the learning lives. Ask of any two designs: which names read better, which has fewer parameters, which can be tested alone?

## Pacing

Units 07–08 span two weeks (4 sessions):

- **Session 7.1** — Lesson 1 + Ex 1–7
- **Session 7.2** — Lesson 2 + Ex 8–13 · Lab 1
- **Session 8.1** — Lesson 3 + Ex 14–19 · Lab 2
- **Session 8.2** — Lesson 4 + Ex 20–26 · Lab 3–4; labs 5–8 and the mini-project across following days

## What comes next

The [arrays module](../arrays/index.md) is next — and the moment you have a *collection*, functions that take collections as parameters make every pass testable one function at a time. Everything in the Marks Analyzer is built as a function team.

## Checklist

- [ ] I can write and call a function with parameters and a return value, and trace the call flow
- [ ] I can predict what pass-by-value does to the caller's variables — and when that's the wrong tool
- [ ] I know why globals are banned here and can name the two honest alternatives (parameters, returns)
- [ ] I can use a reference parameter to hand a result back, and explain the two-name-one-box rule
- [ ] I can decompose a problem statement into a function list before writing any code
- [ ] I can test one function alone with a mini-driver and a per-function test table
- [ ] I can overload a function and add default arguments — and know the ambiguity traps
- [ ] I can refactor a giant `main()` one step at a time, re-verifying after each step
