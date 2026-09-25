---
title: "Modern C++ Module — What to Know, What to Adopt"
description: "A carefully scoped modern-C++ module: the fundamentals every student must know (const correctness, references, nullptr, enum class, range-for, lambdas, the standard library) and the modern practices to begin adopting (RAII, auto with restraint, constexpr, smart pointers, move semantics conceptually)."
---

# Modern C++ — what to know, what to adopt

> **Prerequisites:** Units 01–15 — the [Pointers module](../pointers/index.md) (you must know what `new`/`delete` cost before learning to avoid them), the [OOP module](../oop/index.md) (classes, `const` members), the [STL module](../stl/index.md) (containers, algorithms, lambdas), and the [Robustness module](../robustness/index.md) (ownership and unwinding).
>
> ⚠️ **Scope promise:** this module is **not** a language-standard tour. No variadic templates, no rvalue-reference derivations, no move *implementations* — the syllabus's Unit 16 toolkit, sized for a fundamentals course. Everything here is standard, portable C++17, chosen because it makes beginner programs **safer and clearer**, not because it is new.

## The module's one distinction

Everything in it sorts into two columns — and the module keeps the columns separate:

| **Fundamental C++ — every student should know** | **Modern practices — begin adopting now** |
| --- | --- |
| `const` correctness (variables, parameters, members) | `auto` — with the restraint rules |
| references (`&`) — parameters, ranges, loop variables | `constexpr` for compile-time constants |
| `nullptr` (never `NULL`, never `0`) | **RAII** — the resource idea that runs modern C++ |
| `enum class` for named categories | `unique_ptr` as the default owner |
| range-based `for` for every traversal | `shared_ptr` — only for genuinely shared ownership |
| lambdas at call sites | move semantics — **conceptually**: what a move is, why `std::move` exists |
| the standard library as the default toolkit | raw `new`/`delete` retired to the "expert corner" |

The rule of thumb the module teaches: **the left column is grammar — you already speak most of it; the right column is style — adopt it one habit at a time, and let RAII be the habit that drives the rest.**

## What's in the module

| Page | Contents |
| --- | --- |
| [Lesson 1 — The fundamentals, consolidated](lesson-1-fundamentals.md) | The left column as one connected picture: const correctness, references, `nullptr`, `enum class`, range-`for`, lambdas, standard-library default — with the "you already know this" links to the units that taught each |
| [Lesson 2 — The modern practices](lesson-2-modern-practices.md) | The right column: RAII as the idea, `auto` with restraint, `constexpr`, the smart pointers, move semantics conceptually, and the retirement ceremony for raw `new`/`delete` |
| [Exercises](exercises.md) | 18 problems in two parts (Fundamental / Modern) with separated solutions |
| [Debugging hunts](debugging.md) | 8 hunts — modern-code bugs and pre-modern bugs the practices prevent |
| [Challenges](challenges.md) | 6 problems with separated solutions |
| [Lab — the Modernisation Lab](labs.md) | A working pipeline program retrofitted in four stages, with the modernization table as the graded deliverable |

## Pacing (two sessions)

- **Session A** — [Lesson 1](lesson-1-fundamentals.md) + Exercises Part A.
- **Session B** — [Lesson 2](lesson-2-modern-practices.md) + Exercises Part B + [the lab](labs.md), stages 1–2.
- **Stretch** — the lab's stages 3–4, [debugging hunts](debugging.md), [challenges](challenges.md).

## How this connects to the capstone

The syllabus parks this material in Unit 16 alongside [Project 3 — the Contact Management System](../syllabus.md#stage-f-capstone-unit-16). The lab here is deliberately *not* the capstone: it is the **modernisation pass you then apply to your own capstone** — same four stages, your own code. A capstone written after this module has no raw `new`, no `constexpr`-shaped magic numbers, and a one-line ownership story.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
