---
title: "Algorithms — Recursion, Searching & Sorting"
description: "Unit 10 module: recursion from first principles, linear and binary search, the three elementary sorts, hand tracing, and honest complexity intuition."
---

# Algorithms — Recursion, Searching & Sorting

> Week 10 · **🏁 Project 2 week** · [← Course home](../index.md) · [Syllabus](../syllabus.md) · [Glossary](../glossary.md)

Everything before this unit was about *storing* data — boxes, strings, records, files. This unit is about *doing things to* data: finding it, ordering it, and (with recursion) solving problems by shrinking them.

**Project 2 lives here.** The syllabus places the Student Records Manager in Unit 10: a menu-driven records manager with a real **search** command and a real **sort** command, built over the arrays, functions, records, and files you already own. It is not an afterthought in this module — it is the destination the whole unit drives toward. You'll find its brief after the labs.

## What you already have (the honest checklist)

Recursion needs **functions** (a function that calls itself is just the machine calling the machine). Searching and sorting need **arrays** and **vectors**, **loops**, and **swap**. Dry runs need the **trace-table habit** from the problem-solving module. Nothing here is new machinery — it is new *uses* of machinery you own.

## The module map

| Part | Pages | What it covers |
| --- | --- | --- |
| **A — Recursion** | [Lesson 1](lesson-1-recursion.md) | The shrink-the-problem idea; base case, recursive case; the call stack *felt* as boxes; tracing; factorial, Fibonacci, digit processing, recursive search, array recursion; the mistakes gallery |
| **B — Searching** | [Lesson 2](lesson-2-searching.md) | Linear search (and its all-variants); binary search; the **sorted precondition**; complexity intuition with guessing games |
| **C — Sorting** | [Lesson 3](lesson-3-sorting.md) | Bubble, selection, insertion — pseudocode, dry runs, implementations, trade-offs; when each is the right tool |
| **Practice** | [Exercises](exercises.md) — 30+ graded with separated solutions · [Traces](traces.md) — 15 dry runs to do by hand · [Debugging](debugging.md) — 10 seeded hunts · [Challenges](challenges.md) — 15 with separated solutions |
| **Lab** | [Labs](labs.md) | **The Algorithm Performance and Comparison Lab** — sort the same data with all three algorithms, count comparisons, and *see* why O(n²) vs O(n log n) matters |

## The try-it-first protocol (unchanged from every module)

1. **Attempt before reading the solution.** Every solution in this module is *separated* from its problem for a reason: a solution read too early teaches nothing.
2. **Trace before you trust.** A dry run on paper (a trace table, a box diagram for recursion) is worth more than a lucky correct output. Every algorithm here gets traced by hand in the lessons; the [trace pack](traces.md) makes you do it fifteen more times.
3. **Test the edges.** Empty input, one element, already sorted, reverse sorted, duplicates, target absent. The [challenge statements](challenges.md) tell you the edges to try; your own programs should try them without being told.

## Pacing (Week 10, two sessions)

- **Session 10.1** — Lesson 1 (recursion) + Exercises Part A + Traces T1–T8. Recursion is the hardest idea in this course so far; give it the whole session.
- **Session 10.2** — Lessons 2–3 (searching and sorting) + Exercises Parts B–C + the [comparison lab](labs.md).
- **Project 2** — start after Session 10.2; it needs search and sort, and it reuses the Records module's data designs.

## Self-check — you are ready to move on when…

- [ ] You can write factorial's base case *and* explain what breaks without it
- [ ] You can trace `fib(5)` on paper and say why the tree explodes
- [ ] You can state binary search's precondition in one sentence
- [ ] You can hand-sort 6 items with each of the three algorithms, without the lesson open
- [ ] You can say which sort you'd pick for nearly-sorted data — and why

## Where this leads

Selection sort's "select the best remaining" idea is the seed of **heaps**; the [merge challenge](challenges.md#approaches) (C14) is the seed of **merge sort** in any data-structures course. Unit 15's classes will carry these algorithms into a **container class** with methods like `search()` and `sortByName()` — the exact shape of Project 2's command set. Nothing you write in this unit is throwaway.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
