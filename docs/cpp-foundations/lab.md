---
title: "Lab — The Marks & Grade Calculator (4 Variations)"
description: "One scenario, four variations that change the design — so you solve problems, not copy a solution."
---

# Lab — The Marks & Grade Calculator

> ~2–3 h across the variations · folder + plans + programs + test log ·
> [← Module home](index.md)

## Why four variations

A single lab can be copied. Four **design-changing** variations cannot:
each one breaks the previous solution in a specific, instructive way —
integer division, boundary conditions, constants, type choice — so a
copied V1 *fails* V2. That is the point: you will solve, not transcribe.
(The lab rubric: [grading.md](../grading.md#lab-rubric-all-labs).)

**Folder layout** (module discipline):

```text
cpp-foundations-lab/
├── v1-basic/         plan.md · marks-v1.cpp · tests.md
├── v2-average/       …
├── v3-weighted/      …
├── v4-census/        …
└── LAB-NOTES.md
```

Every variation: **plan.md first** (IPO + assumptions + pseudocode + trace
of one case — the Problem-Solving method), then code, then *run the test
table* and record ✓/✗ in `tests.md`.

---

## Variation 1 — The basic grade calculator (★★)

**Scenario.** Read **three whole-number marks** (each 0–100) and print
them with the total.

**Expected session** *(input 70, 85, 90)*:

```text
Mark 1: 70
Mark 2: 85
Mark 3: 90
Marks   : 70 85 90
Total   : 245
```

**Test cases** (record actual-vs-expected for all):

| Input | Expected total |
| --- | --- |
| 70, 85, 90 | 245 |
| 0, 0, 0 | 0 |
| 100, 100, 100 | 300 |

**Design notes to settle in plan.md:** one variable per mark, or reuse
one? (Either works — *say which and why*; this choice returns in V4.)
Compile with `-Wall -Wextra`, zero warnings.

---

## Variation 2 — Average, honestly rounded (★★)

**Scenario.** Extend V1: also print the **average as a percentage with the
decimal part shown** — but the course computer prints whole numbers only,
so print the average **truncated** *and* state the truncation explicitly.

**Expected session** *(input 70, 85, 90 → 245/3 = 81.666…)*:

```text
Marks   : 70 85 90
Total   : 245
Average (truncated): 81
Note: exact average is 81.666...; whole-number display truncates.
```

**Test cases:**

| Input | Truncated average |
| --- | --- |
| 70, 85, 90 | 81 |
| 99, 99, 100 | 99 (298/3 = 99.33… → 99) |
| 50, 50, 50 | 50 (exact — no truncation to hide) |
| 1, 1, 1 | 1 (0.33… → 0? no — wait: 3/3 = 1. Add this case to catch yourself.) |

**The design question:** `total / 3` with ints gives the truncated value
directly — but *why*, and what would `static_cast<double>(total) / 3`
print instead? Your plan.md must answer both, citing
[Lesson 4](lesson-4-conversion.md#42-implicit-conversion). (Notice how a
copied V1 — which never divided — must actually be *understood* here.)

---

## Variation 3 — Grade bands + the boundary switch (★★★)

**Scenario.** Extend V2 with letter grades per the university's scheme:

| Average (truncated) | Grade |
| --- | --- |
| 80 or more | A |
| 70–79 | B |
| 60–69 | C |
| 50–59 | D |
| below 50 | F |

**Expected session** *(input 70, 85, 90 → average 81)*:

```text
Marks   : 70 85 90
Total   : 245
Average (truncated): 81
Grade   : A
```

**Test cases — the boundary grid is the lab:**

| Marks | Avg | Grade |
| --- | --- | --- |
| 80, 80, 80 | 80 | A ← **boundary: A's floor** |
| 79, 79, 81 | 79 | B ← one below |
| 69, 70, 70 | 69 | C ← pair |
| 49, 50, 51 | 50 | D ← pair |
| 49, 49, 49 | 49 | F |
| 100, 100, 100 | 100 | A |

**The design questions:** an else-if ladder checked **top-down**
(Problem-Solving Scenario 7) — which single condition per band? And the
motto of the whole variation: *the boundary pairs are the test set.*
A V2 copy dies here: no comparison operators were used yet.

---

## Variation 4 — The census run (★★★)

**Scenario.** The tutor processes **5 students** (a known count → loop
discipline from [Set C](../problem-solving/scenarios-c.md)); for each,
read the three marks (V3's logic) and print one line per student:
`Student 3: avg 81, grade A`. After all five, print **how many achieved
grade A or B** (the "distinction count") and the **class average of the
truncated averages** (truncated again — exactly, deliberately, per V2's
rule).

**Expected session** *(abridged)*:

```text
Student 1 marks: 70 85 90
Student 1: avg 81, grade A
Student 2 marks: 60 60 59
Student 2: avg 59, grade D
...
Distinctions (A or B): 3
Class average: 71
```

**Test cases** *(five-student sets you design, but they must include)*:
one all-boundary student (79,80,81), one perfect (100×3), one failing
(49×3), and a set whose class average lands exactly on a whole number.

**The design questions:** accumulators — how many, which kinds (sum?
counter?), what start values? Reuse-one-variable-per-mark vs
fresh-variables-each-student (V1's choice, now load-bearing: which design
*survives* being inside a loop?). And the honest trace: one row per
student in plan.md before coding.

---

## LAB-NOTES.md (write-up, one file)

Per variation: *What it does · key decisions (with the "why" from your
plan) · one pasted sample run · test table with ✓/✗ · what tripped you.*
End with: **which variation broke the previous solution, and what that
taught about design assumptions.** (That reflection is the lab's real
deliverable.)

## Self-check (/5)

| # | Criterion | ✓ |
| --- | --- | --- |
| 1 | All four plan.md files written *before* code; traces present | ☐ |
| 2 | All test tables run and recorded ✓/✗ — boundaries included by name | ☐ |
| 3 | Every magic number is a named constant; names follow conventions | ☐ |
| 4 | All four programs compile `-Wall -Wextra` clean | ☐ |
| 5 | Reflection names the assumption each variation attacked | ☐ |

5/5 → take the [Quiz](quiz.md), then proceed to
[Unit 04](../syllabus.md#stage-b--control-flow).

---

*[← Module home](index.md) · [Challenges](challenges.md) · [Quiz](quiz.md)*
