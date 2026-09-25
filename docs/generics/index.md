---
title: "Operator Overloading & Templates — Writing Code That Works for Many Types"
description: "An advanced module: member and non-member operator functions, comparison and stream operators, function and class templates, generic programming concepts, and their honest limitations."
---

# Operator Overloading & Templates

> A **cross-cutting module** · [← Course home](../index.md) · [Syllabus](../syllabus.md) · [Glossary](../glossary.md)

> ## ⚠️ This is an advanced section
>
> Everything before this point in the course is essential. **Everything in this module is optional enrichment** — the material the syllabus parks under "Modern C++ toolkit." It assumes the whole course: classes and const (OOP module), interfaces and comparisons (Inheritance module), the standard library's own habits (`vector`, `string`, `operator<<` — met throughout). Work through it *after* the capstone, or in parallel with a data-structures course — not instead of finishing the 16 units.
>
> If you are still building the core skills, stop here with no guilt: [Unit 16's capstone](../syllabus.md) matters more. This module will wait; it has no dependencies on being read this week.

## What this module covers

| Lesson | What it covers |
| --- | --- |
| [Lesson 1 — Operator overloading](lesson-1-operator-overloading.md) | Why overload; **member vs non-member** operators (the decision table); arithmetic and **comparison operators**; **stream operators**; the rules and the mistakes gallery |
| [Lesson 2 — Templates](lesson-2-templates.md) | **Function templates**; **class templates**; type independence and what "generic" costs; **limitations and common mistakes** — honestly named |
| **Practice** | [Exercises](exercises.md) — 20 graded with separated solutions · [Debugging](debugging.md) — 8 seeded hunts · [Design problems](design.md) — 6 with separated reviews · [Challenges](challenges.md) — 8 with separated solutions |
| **Labs** | [5 labs](labs.md) — Complex numbers, Generic calculator, Generic max/min, Generic container, Student/result comparison |

## Prerequisites checklist — be honest with yourself

- [ ] You can write a class with `const` member functions and `operator<<` without notes (OOP module)
- [ ] You can explain what a *contract* is between a function and the types it serves (Inheritance module)
- [ ] You have read compiler template errors before and not closed the terminal (a sense of humour counts)

## The module's three ideas

1. **Operators are functions.** `a + b` is notation for a call; overloading lets *your types* join the notation — subject to strict rules that keep the notation honest.
2. **Templates are patterns for code.** One function/class shape, stamped out per type by the compiler — type independence by *generation*, not by runtime polymorphism.
3. **Generic code trades control for reach.** A template works for every type that meets its (implicit) requirements — and tells you *nothing* about unmet ones except a wall of errors. The module's lesson is designing requirements you can name, and diagnosing the errors when they bite.

## Pacing

- **Session A** — Lesson 1 + Exercises Part A + the [Complex-number lab](labs.md).
- **Session B** — Lesson 2 + Exercises Part B + [Generic max/min and the container lab](labs.md).
- **Stretch** — [Design problems](design.md), [challenges](challenges.md), the [calculator and comparison labs](labs.md).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
