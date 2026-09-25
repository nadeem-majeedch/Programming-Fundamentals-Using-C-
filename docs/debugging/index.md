---
title: "Debugging, Testing & Writing Better C++ Programs"
description: "The cross-cutting module: the four error kinds, compiler diagnostics, the debugger, assertions, a testing discipline, defensive programming, and clean-code habits — with 20 broken programs to fix."
---

# Debugging, Testing & Writing Better C++ Programs

> A **cross-cutting module** — no unit number, no deadline · [← Course home](../index.md) · [Syllabus](../syllabus.md) · [Glossary](../glossary.md)

Every module in this course shipped its own debugging hunts. This module is the *general theory* behind all of them: what errors actually are, how professionals find them, how to prove code works instead of hoping, and how to write code that has fewer bugs in the first place.

**When to study it:** any time after the [Functions module](../functions/index.md). The ideal moment is right after the [Algorithms module](../algorithms/index.md) / Project 2 — old enough to have real bugs of your own, early enough for the habits to compound. The [Debugging Challenge Lab](lab.md) is designed as a capstone-style workout: twenty broken programs and a timed triage.

## What this module covers

| Part | Pages | What it covers |
| --- | --- | --- |
| **Errors & diagnostics** | [Lesson 1](lesson-1-errors-diagnostics.md) | Syntax vs compile vs runtime vs logic vs semantic errors; reading compiler diagnostics properly; the systematic debugging workflow |
| **The debugger** | [Lesson 2](lesson-2-debugger-testing.md) | Breakpoints, stepping, variable inspection (gdb/lldb/VS Code concepts); `assert` as an executable comment |
| **Testing discipline** | [Lesson 2](lesson-2-debugger-testing.md) | Test cases, boundary tests, invalid-input tests, regression testing; the test-table habit |
| **Writing better code** | [Lesson 3](lesson-3-better-code.md) | Defensive programming; meaningful names; honest comments; functions and modularity; the DRY rule; basic code review |
| **Practice** | [Practice pack](practice.md) | **20 broken programs** — description, expected behaviour, buggy code, hints, corrected code, explanation |
| **Lab** | [Lab](lab.md) | **The Debugging Challenge Lab** — triage, timed hunts, and a bug-journal deliverable |

## The module's five laws

1. **Read the error message.** All of it. Twice. The compiler is not mocking you — it is describing exactly what confused it, at a specific line.
2. **Reproduce before you fix.** A bug you cannot trigger on demand, you cannot verify gone. Find the smallest input that makes it happen.
3. **Change one thing, then re-test.** Shotgun edits destroy the evidence. One hypothesis → one change → one run.
4. **A fix without a test is a wish.** Every bug you fix earns a test case that would have caught it — that test joins your regression set forever.
5. **The best debugging is not writing the bug.** Defensive habits (Lesson 3) are cheaper than any debugger.

## The try-it-first protocol

The [practice pack](practice.md) is engineered so the corrections are separated and hint-laddered. Do not open a fix because you're curious — open it because you formed a hypothesis, tested it, and were wrong. Wrong *after* committing is the only way the correct model replaces the wrong one.

## Self-check — you own this module when…

- [ ] You can name the four error kinds and say *when* each is detected
- [ ] You can read a multi-line compiler diagnostic and find the real error, not just the first one
- [ ] You can set a breakpoint, step over/into, and inspect a variable — in any tool, not just one
- [ ] You write boundary tests (0, 1, n−1, n, n+1) without being reminded
- [ ] You have a personal bug journal and have re-read it at least once

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
