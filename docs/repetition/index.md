---
title: "Unit 05–06 — Iteration (Loops)"
description: "while, do-while, for, nested loops — counters, accumulators, sentinels, break/continue, tracing, and choosing the right loop."
---

# Iteration — `while`, `do-while`, `for`, and Nested Loops

> [← Course home](../index.md) · [← Decisions module](../decisions/index.md) · Unit 05–06/16 · [Syllabus](../syllabus.md#stage-b-control-flow-units-4-6)

Welcome to the engine room of programming. Units 04–05 taught your programs to **choose**; this module teaches them to **repeat**. With these four lessons, Stage B's toolkit is complete — everything after (functions, arrays, files, objects) organizes or scales what you build here.

## In this module you will learn

- the three loops (`while`, `do-while`, `for`) — same engine, different ignition
- **counters** and **accumulators** — the two most reused variables in programming
- sentinel-controlled and input-controlled loops; validation loops that re-prompt instead of quitting
- `break` and `continue` — the two exits and the shortcut
- nested loops and the 2D world they open (tables, patterns, digit and prime work)
- loop tracing (dry-run tables), off-by-one boundaries, and the classic loop errors
- choosing the appropriate loop — a decision procedure, not a guess

## Module map

| Page | What's inside |
| --- | --- |
| [Lesson 1 — The `while` loop and the accumulator](lesson-1-while.md) | Loop anatomy, counters vs accumulators, infinite loops, `do-while`, input-controlled loops, sentinel preview |
| [Lesson 2 — `for`, idioms, and choosing](lesson-2-for.md) | `for` anatomy, the classic idioms (sum/avg/min/max), off-by-one boundaries, choosing the appropriate loop |
| [Lesson 3 — `break`, `continue`, sentinels](lesson-3-break-continue-sentinels.md) | The two exits and the shortcut; sentinel loops; menus; a validation-loop gallery; pattern: prime test |
| [Lesson 4 — Nested loops, digits, patterns](lesson-4-nested-digits-patterns.md) | Nested-loop execution model, tables/patterns, digit processing, primes, factorial, common loop errors gallery |
| [Exercises](exercises.md) | 32 exercises with separated solutions (S1–S32) |
| [Predictions](predictions.md) | 15 predict-the-output problems, answers in a separated answer section |
| [Debugging](debugging.md) | 15 loop bugs — find/fix/reflection format |
| [Challenges](challenges.md) | 15 challenges with separated solutions |
| [Labs](labs.md) | 10 lab scenarios with full dry-run tables |
| [Mini-project](miniproject.md) | The Number Analysis Toolkit — a loop-based menu program |

## Try it yourself first

Every problem page states the rule once: **attempt for 15 minutes before opening any solution**. Attempting first isn't just honesty training — it makes the solution *readable* (you know which step you were missing), and retrieval practice is what turns reading into skill. The solutions in this module are deliberately written to be **complete and separated**, so a stuck student gets a full path — but the order you meet them in is always: problem → attempt → solution.

Each exercise page lists difficulty (★ = first pass, ★★ = needs the idioms, ★★★ = combines ideas), and the hub's [pacing](#pacing) table maps pages to sessions.

## Pacing

Units 05–06 span two weeks (4 sessions). A workable split for self-study:

- **Session 5.1** — Lesson 1 + Ex 1–8
- **Session 5.2** — Lesson 2 + Ex 9–16 · Lab 1
- **Session 6.1** — Lesson 3 + Ex 17–24 · Lab 2
- **Session 6.2** — Lesson 4 + Ex 25–32 · Lab 3; then labs 4–10 and the mini-project across following days
- **Quiz** after the mini-project.

## What comes next

After the mini-project, [Stage C](../syllabus.md#stage-c-structure-units-7-9) begins: the [functions module](../functions/index.md) turns your idioms into named, reusable machines — the accumulator-idiom programs from Lesson 2 will all become three-line programs with a loop in a function.

## Checklist

- [ ] I can write a `while` loop with a correct counter: initialization, condition, update — all three present and in the right place
- [ ] I can trace any loop by dry-run table without running it
- [ ] I know the difference between a counter and an accumulator, and when to use each
- [ ] I can write a sentinel loop and a do-while menu
- [ ] I can use `break` and `continue`, and know when **not** to
- [ ] I can write a nested loop and say how many times the body runs
- [ ] I can classify a bug as compile/run/logic and know the loop-error gallery
- [ ] I can choose between `while`, `do-while`, and `for` for a given task and justify the choice
- [ ] I can process digits, test primality, and print patterns
