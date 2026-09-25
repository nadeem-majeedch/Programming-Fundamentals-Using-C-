---
title: "Unit 09 — Arrays & Vectors"
description: "The array concept, declaration through traversal, searching, min/max, frequency, copying, bounds errors, arrays with functions, and multidimensional matrices."
---

# Arrays — Many Values, One Name

> [← Course home](../index.md) · [← Functions module](../functions/index.md) · Unit 09/16 · [Syllabus](../syllabus.md#stage-c-structure-units-7-9)

Every wall the last two units asked you to name comes down here: the statistics session that couldn't re-list its numbers, the five-`m1..m5` parameter signature, the tie *list* that needed "Stage D's arrays". This unit removes the wall. One name, many boxes, and the loops you already own become the natural way to work through all of them.

## In this module you will learn

- the **array concept** — a row of same-typed boxes with one name and numbered positions
- declaration, initialization, indexing, traversal, and updating elements
- **bounds**: why index 0 exists, why `marks[n]` doesn't, and the out-of-bounds error class
- the classic workhorses: **searching**, **minimum/maximum**, **sum/average**, **frequency counting**, **copying**
- **arrays as function parameters** — what actually gets passed, why `const` matters, and why the size travels separately
- **multidimensional arrays**: matrices, rows × columns, nested loops as their native language
- the common array errors gallery

## Module map

| Page | What's inside |
| --- | --- |
| [Lesson 1 — The row of boxes](lesson-1-basics.md) | Concept, declaration, initialization, indexing, traversal, bounds, updating, the errors gallery |
| [Lesson 2 — The classic passes](lesson-2-classic-passes.md) | Linear search, min/max champions, sum/average, frequency counting, copying |
| [Lesson 3 — Arrays and functions](lesson-3-arrays-functions.md) | Array parameters, `const`, size-passing conventions, partial fills |
| [Lesson 4 — Two dimensions](lesson-4-matrices.md) | Multidimensional arrays, matrices, nested loops, row/column operations |
| [Exercises](exercises.md) | 32 exercises with separated solutions (S1–S32) |
| [Debugging](debugging.md) | 10 seeded array bugs |
| [Predictions](predictions.md) | 10 trace/output problems, answers separated |
| [Challenges](challenges.md) | 15 challenges with separated solutions |
| [Labs](labs.md) | 7 analysis labs, each with solution + explanation |
| [Mini-project](miniproject.md) | The Marks Analyzer — the syllabus's Unit 09 capstone |

## Try it yourself first

Same rule as always: **attempt 15 minutes before opening any solution**. Arrays add one new ritual to the pre-code routine — **draw the boxes first**. A five-element array drawn on paper, with indices *and* values, turns most off-by-one and bounds bugs into things you can *see* before compiling.

## Pacing

Unit 09 spans one week (2 sessions):

- **Session 9.1** — Lessons 1–2 + Ex 1–16 · Lab 1 or 7
- **Session 9.2** — Lessons 3–4 + Ex 17–32 · one lab of your choice + the mini-project

The [7 labs](labs.md) are deliberately parallel in shape — pick by interest; every one practises the same passes.

## What comes next

The [Algorithms module](../algorithms/index.md) takes your linear search and selection instincts and makes them *fast and ordered*: searching and sorting. The Marks Analyzer here becomes Marks Analyzer Plus there — and the Project 2 brief in that module is the destination both modules drive toward.

## Checklist

- [ ] I can declare, initialize, traverse, and update an array — and draw it
- [ ] I can explain why valid indices are `0..n-1` and what out-of-bounds access really does
- [ ] I can write linear search, min/max, sum/average, and frequency passes from memory
- [ ] I can copy an array correctly (and name the `=` trap)
- [ ] I can pass arrays to functions, protect them with `const`, and handle partial fills
- [ ] I can work a 2D array with nested loops — rows, columns, and the whole grid
- [ ] I can trace any array loop in a table with an index column
