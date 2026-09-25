---
title: "Robustness Module — Errors, Exceptions, and Programs That Refuse to Lie"
description: "The course's validation habits meet the language's error machinery: try/catch/throw, standard and custom exceptions, exception safety, and the end of silent failures — with earlier labs refactored to survive the real world."
---

# Robustness — errors, exceptions, and programs that refuse to lie

> **Prerequisites:** Units 01–15 (especially the [Debugging & Testing module](../debugging/index.md)'s validation discipline, the [OOP module](../oop/index.md)'s classes, and the [Files module](../files/index.md)'s open-check discipline) · this module is **advanced enrichment**, best after the capstone.

Everything before this point handled errors with the tools the early units provided: guard clauses, `if (!file)`, validation loops, the ask-door. Those tools remain the *first* line of defence. This module adds the language's **second** line: the exception machinery — what it is, what it is for, and, just as important, what it is *not* for.

**The module in three laws:**

1. **Refuse silently, or refuse loudly — never refuse quietly.** Every failure path in a program either recovers, reports loudly, or stops. A function that "fails" without anyone noticing is a bug wearing a disguise.
2. **Validate at the boundary; throw from the depths.** User input is checked with the `if` tools you already own (that hasn't changed). Exceptions carry failures that a *caller* must hear about — up through layers that cannot fix them.
3. **Leave no mess behind.** A function that throws must not leak memory, leave data half-written, or abandon an invariant. This is *exception safety*, and the course's habits (RAII-flavoured ownership, validate-before-mutate) already point at it.

## What's in the module

| Page | Contents |
| --- | --- |
| [Lesson 1 — The error machinery](lesson-1-try-catch-throw.md) | Errors vs exceptions; `try`/`catch`/`throw` anatomy; the standard exceptions; the stack unwinding story; robust readers compared against the [validation suite](../functions/labs.md#lab-5--the-validation-suite) |
| [Lesson 2 — Custom exceptions and safety](lesson-2-custom-safety.md) | Exception types as classes (the OOP module's inheritance, finally earning its keep); `stdexcept`; the four safety levels; validation layers; the silent-failure gallery |
| [Refactor workshop](refactor.md) | **8 programs from earlier labs rebuilt** — the marks calculator, the bank account, the inventory file, the grade analyzer, and more: before/after with the failure that motivated each change |
| [Exercises](exercises.md) | 15 exercises with separated solutions |
| [Debugging scenarios](debugging.md) | 10 hunts — swallowed exceptions, wrong catch order, throwing destructors, leaks through throw paths |
| [Challenges](challenges.md) | 10 problems with separated solutions |
| [Lab — the Robust Application](labs.md) | The Student/Bank/Inventory application hardened in three rings |

## Pacing (two sessions)

- **Session A** — Lesson 1 + Exercises Part A + the first two refactors.
- **Session B** — Lesson 2 + Exercises Part B + [the lab](labs.md), ring one.
- **Stretch** — the remaining refactors, [challenges](challenges.md), and the lab's ring three.

## The one-paragraph honesty note

Exception *handling* is a mid-level feature that sits on top of nearly everything this course taught — which is why it waits until now. It is also a feature professional code uses **selectively**: the standard library's containers are value-based precisely so everyday code needs no `try` blocks, and the course's own guard-clause style remains the default. Learn the machinery here; deploy it where failure genuinely must travel.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
