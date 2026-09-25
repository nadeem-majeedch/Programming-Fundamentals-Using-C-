---
title: "Unit 04 Deep Dive — Decision Making"
description: "Module hub: turning requirements into decisions — if, else, else-if, nested decisions, switch, the conditional operator, compound conditions, and boundary discipline."
---

# Unit 04 Deep Dive — Decision Making

> [← Course home](../index.md) · [Problem-solving module](../problem-solving/index.md) · [C++ Foundations](../cpp-foundations/index.md) · [Unit 04 in the syllabus](../syllabus.md#stage-b-control-flow-units-4-6)

**Where this fits.** You can already print, read, and calculate ([Foundations](../cpp-foundations/index.md), [I/O](../cpp-io/index.md)), and you have thought through problems before coding ([Problem Solving](../problem-solving/index.md)). Now your programs learn to *choose*: grading rules, ticket prices, bill slabs, eligibility checks. Decision making is where a specification stops being a description and becomes logic you can get wrong — so this unit is heavier on **discipline** than on syntax.

## The one rule of this module

> **Try first.** Every lesson's practice, every exercise, every prediction, every lab task: write your decision, dry-run it on paper, *then* open the answer. A decision you borrowed is a decision you don't own; on the next boundary case it will fail and you won't know why.

The three-pass habit from [Problem Solving](../problem-solving/lesson.md#13-decision-making) applies to every exercise below:

1. **Restate** the rule in plain words (which inputs, which outcomes).
2. **Decide on paper** — a decision table or trace table, not code.
3. **Code it**, then dry-run your code against the same table.

## Module map

| Part | File | You will be able to |
| --- | --- | --- |
| Lesson 1 | [The decision statement](lesson-1-branches.md) | write `if`, `if-else`, `else-if` ladders and nested decisions; name every part |
| Lesson 2 | [Conditions and boundaries](lesson-2-conditions.md) | build comparison, logical, and compound conditions; dodge boundary and range bugs |
| Lesson 3 | [Switch and the conditional operator](lesson-3-switch.md) | choose `switch` vs ladder vs `?:` honestly; write fallthrough-free switches |
| Lesson 4 | [From requirements to decisions](lesson-4-requirements-to-decisions.md) | convert any rule set: decision tables → flowcharts → pseudocode → C++ → dry runs |
| Practice | [25 exercises](exercises.md) · [10 debugging hunts](debugging.md) · [10 predictions](predictions.md) · [10 challenges](challenges.md) | rehearse until boundaries stop surprising you |
| Labs | [8 realistic scenarios](labs.md) | grading, electricity billing, cinema pricing, bank validation, age categories, admission, shipping, restaurant rules |

## Suggested pacing (Week 4 · 2 sessions + self-study)

| Session | Focus |
| --- | --- |
| 4.1 | Lessons 1–2 + exercises E1–E10 + Lab 1 or 2 |
| 4.2 | Lessons 3–4 + predictions P1–P10 + Lab 3–5 (pick) |
| Self-study | Debugging hunts D1–D10, remaining exercises, challenges C1–C10, Labs 6–8 |

## Prerequisites checklist

- [ ] I can compile and run a program from the command line ([setup](../getting-started/setup-checklist.md))
- [ ] I can read input and print output ([I/O module](../cpp-io/index.md))
- [ ] I can write and dry-run a trace table ([Problem Solving](../problem-solving/lesson.md#1516-dry-runs-and-trace-tables))
- [ ] I know `int`, `double`, `char`, `bool` and how `>>` stops at whitespace

## What's next

[Unit 05 — Repetition](../syllabus.md#stage-b-control-flow-units-4-6): decisions that run *inside* loops — validation loops, sentinels, menus.
