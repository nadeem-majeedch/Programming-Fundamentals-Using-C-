---
title: "The Standard Template Library — Containers, Iterators, Algorithms"
description: "An intermediate-advanced module: the eleven containers students actually use, iterators and range-based loops, the everyday algorithms, introductory lambdas — modern, portable C++."
---

# The Standard Template Library

> A **cross-cutting module** — the toolkit everything after this course assumes · [← Course home](../index.md) · [Syllabus](../syllabus.md) · [Glossary](../glossary.md)

You have been building hand-made versions of this module's contents all course long: the `Box<T>` was a `vector`, the Records module's roster was a `map` waiting to happen, the Algorithms module's `maxOf` was `max_element`. The STL is the professional, tested, generic version of every utility you hand-rolled — and this module teaches it *by connecting each container to the hand-made one you already built*, so nothing feels like new machinery, only better machinery.

**Positioning:** read after the [Generics module](../generics/index.md) (templates and contracts are the STL's native language) and after [Unit 15's OOP module](../oop/index.md) at minimum. Like the Generics module it sits outside the 16-unit week plan — but unlike it, this material is **not optional** for anyone continuing to data structures or real C++ work. It is the last stop before the [Unit 16 capstone](../syllabus.md#stage-f--capstone) and its toolkit review.

## What this module covers

| Lesson | What it covers |
| --- | --- |
| [Lesson 1 — Sequence containers](lesson-1-sequence.md) | `vector`, `array`, `deque`, `list`, `stack`, `queue`, `priority_queue` — with the **big choice table** and the hand-made ancestors |
| [Lesson 2 — Associative containers](lesson-2-associative.md) | `set`, `map`, `unordered_set`, `unordered_map` — with the sorted-vs-hashed comparison tables and the when-to-use rules |
| [Lesson 3 — Iterators, algorithms, lambdas](lesson-3-iterators-algorithms.md) | Iterators as the glue; range-based loops; `sort`, `find`, `count`, `reverse`, `min_element`/`max_element`, `accumulate`; **lambdas at an introductory level** |
| **Practice** | [Exercises](exercises.md) — 26 graded with separated solutions · [Debugging](debugging.md) — 10 seeded hunts · [Challenges](challenges.md) — 15 with separated solutions |
| **Labs** | [6 labs](labs.md) — Contact manager, Inventory manager, Student grade analyzer, Frequency counter, Leaderboard, Task queue — one per major container family |
| **Mini-project** | [The Media Catalogue, professional edition](miniproject.md) — the Inheritance module's design, re-hosted on STL containers |

## Prerequisites checklist

- [ ] You can write and use a class template like `Box<T>` (Generics module)
- [ ] You know what an ordering contract (`<`) promises (Generics module)
- [ ] You can read a declaration like `const vector<Student>&` without slowing down

## The module's three ideas

1. **Containers are data structures with guarantees.** Each one is a promise about *where the fast operations are* — the choice is engineering, not taste. Every table in this module is a promise table.
2. **Iterators are the glue.** Half-open ranges `[begin, end)` — the same convention the search algorithms taught — let one algorithm serve every container.
3. **Algorithms replace loops.** If a loop's shape matches a named algorithm, the named version is shorter, less bug-prone, and *says what it means* — the DRY rule, library-wide.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
