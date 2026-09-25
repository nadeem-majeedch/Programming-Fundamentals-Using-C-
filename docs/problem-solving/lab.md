---
title: "Problem-Solving Lab"
description: "Four practical tasks that run the full method — understand, plan, trace, test, then code."
---

# Problem-Solving Lab

> ~60–90 min · 4 tasks · submit as a folder + write-up · [← Module home](index.md)

This lab is deliberately **method-graded, not answer-graded**: the
deliverable is evidence of thinking — IPO, pseudocode, trace tables, test
plans — with the code last. Each task states what to hand in; the
[self-check](#self-check-score-yourself-5) at the end is the rubric.

**Where work lives** (Week-0 folder discipline from the
[Getting Started lesson](../getting-started/getting-started-lesson.md#18-recommended-project-directory-structure)):

```text
cpp-course/
└── problem-solving-lab/
    ├── task1-water-tank/
    │   ├── plan.md              ← IPO + assumptions + pseudocode + trace + tests
    │   └── task1.cpp
    ├── task2-phone-plan/
    │   ├── plan.md · task2.cpp
    ├── task3-lab-attendance/
    │   ├── plan.md · task3.cpp
    ├── task4-minibus/
    │   ├── plan.md · task4.cpp
    └── LAB-NOTES.md             ← the write-up (template below)
```

**Task 1 is walked through the whole way** (you have seen every step in the
[lesson](lesson.md) and
[Set A](scenarios-a.md)); Tasks 2–4 hand over progressively more
responsibility.

---

## Task 1 — The water tank (guided, ★★)

**Scenario.** A rooftop tank holds **1200 litres** when full. It drains at
exactly **8 litres per minute**. Given the **current water level** (0–1200
litres), print how many **whole minutes** of water remain, and a verdict:
`REFILL SOON` if that is **30 minutes or fewer**, otherwise `OK`.

**Your plan must include** (write it in `plan.md` *before* any code):

- [ ] **IPO** — one line each: inputs, processing, outputs
- [ ] **Assumptions** — at least two (what about level 0? level 1200? the
      30-minute boundary — inclusive or not? *you* decide and *document*)
- [ ] **Pseudocode** — with the division and the decision visible
- [ ] **One trace-table row set** for level = 300, and one for the boundary
      you identified
- [ ] **Test table** — at least 5 cases including: level 0, the exact
      30-minute level (compute it: 8 × 30 = 240 — is 240 minutes-remaining
      REFILL SOON or OK? your assumption decides), one above it, one below,
      level 1200

**Then code it** (`task1.cpp` — whole numbers throughout; the
whole-minutes rule is "how many *full* 8-litre minutes fit", i.e. floor
division), compile clean, run your five tests, tick them off in the plan.

**Thinking starters** (answer in the plan, not in your head):

1. Which Set-A scenario is this a cousin of, and what does it teach about
   division?
2. The verdict needs "minutes remaining ≤ 30" — but you computed minutes
   with floor division. Can floor division *hide* a partial minute? Does
   that affect the boundary? (Trace level 245: 245 ÷ 8 = 30.625 → 30 whole
   minutes. Is that REFILL SOON? Say why in the plan.)

---

## Task 2 — The phone plan (independent, ★★)

**Scenario.** A mobile plan costs **500 Rs** base and includes **5 GB**.
Data beyond that costs **70 Rs per additional GB or part thereof** (0.3 GB
extra is billed as a full GB — you cannot buy part of a gigabyte). Given
**total GB used** (whole number, 0–500), print the bill: base, extra data
charge, total.

**Hand in:** full `plan.md` (IPO, ≥ 2 assumptions, pseudocode, trace for
one ordinary and one boundary case, ≥ 5 tests) + `task2.cpp` + all tests
run.

**Design questions to settle in the plan:**

1. At exactly 5 GB, is there an extra charge? (Requirement reads "beyond
   that" — decide, document, test it.)
2. Which earlier scenario already taught the "part thereof → round up"
   trick? Reuse its pattern *and cite it in the plan* (building on your own
   past work is a professional habit).
3. What are the bill values at 0, 5, 6, and 12 GB? Compute by hand first —
   these are your first four test cases.

---

## Task 3 — The lab-attendance report (★ ★★)

**Scenario.** A physics lab runs **10 sessions**. For each session the
demonstrator types the **number of students present** (0–40). The report
prints, **per session**, a bar of `#` marks — one per 5 students (so 22
students → 4 `#`; the bar shows *whole fives*, remainder ignored) — and at
the end: **total attendance** and the **session number with the highest
attendance** (ties → earliest, Scenario 17's rule).

**Expected shape** *(for inputs 22, 5, 40, 0, 18, 12, 30, 7, 25, 3)*:

```text
Session  1: ####        (22)
Session  2: #           (5)
Session  3: ########    (40)
Session  4:             (0)
...
Total attendance: 162
Best session: 3
```

**Hand in:** full `plan.md` + `task3.cpp` + tests.

**Design questions to settle:**

1. Per-session bar and the final report — which is *inside* the loop, which
   after? (Set C, Scenario 14's placement rule.)
2. The bar length is a **derived value**: `attendance ÷ 5` — no
   accumulator needed for it. Which accumulator(s) *do* you need across
   the loop? (Two — name their kinds: sum? champion? counter?)
3. Trace 3 sessions by hand (22, 40, 0) — every column — before coding.
4. Session 4's line: a *zero-length* bar is a legal, meaningful output —
   make sure your design prints the line anyway (empty between the
   colons), and list it as a test.

---

## Task 4 — The minibus dispatcher (★★★)

**Scenario.** A university shuttle loads students in **minibuses of 15
seats**. Students arrive one at a time; the dispatcher types each
arrival's group size (1–15 seats wanted) until **0** ends the day. Every
group fits in one minibus (groups never split across buses; a bus leaves
when the next group wouldn't fit). The report prints: **groups
transported**, **students transported**, **buses used**, and **students
left waiting** — where the *last* unfinished bus counts as used if it
carried anyone.

**Worked micro-example** *(groups 10, 4, 8, 12, 0 — capacity 15)*:

```text
Bus 1: 10 + 4        (14) → leaves (8 won't fit)
Bus 2: 8             (8)  → leaves (12 won't fit)
Bus 3: 12            (12) → day ends, bus used (carried someone)
Groups: 4 · Students: 34 · Buses: 3 · Waiting: 0
```

**Hand in:** full `plan.md` (IPO, ≥ 3 assumptions — state what happens to
the *final* bus, and what "waiting" can ever mean under these rules —
pseudocode, **full trace table for the micro-example above**, ≥ 6 tests) +
`task4.cpp` + all tests run.

**Design questions to settle:**

1. Two accumulators per bus (seats used, bus number) plus three report
   totals (groups, students, buses). Which update *when* — on boarding?
   on a bus leaving? on the day ending? The "when does a bus count as
   used" decision is the heart of the task: **write it as a sentence
   before writing any pseudocode.**
2. Trace the micro-example *at bus granularity*: one row per event (group
   arrives / bus leaves / day ends), columns: event, current bus load,
   buses-so-far, students-so-far. If your trace disagrees with the worked
   example, your *design* is wrong — fix the plan, not the example.
3. Edge probes: first group is 15 (fills a bus exactly — does it leave
   immediately?); a group of 15 arriving when the bus is empty; the day
   ending exactly at a bus departure (0 right after a bus left — did a
   phantom empty bus get counted?); an empty day (first input 0: buses 0,
   students 0, groups 0).

*Why ★★★: this task has a state machine hiding in it — the bus's load —
and the hardest bug class in the set (counting something that shouldn't
count, or missing something that should). The trace table is not
ceremony here; it is the difference between a working dispatcher and a
confident wrong one.*

---

## LAB-NOTES.md — the write-up (all four tasks)

One file, four sections *per task* plus the shared reflection:

```markdown
# Problem-Solving Lab — notes

## Task 1 — water tank
### What it does       two sentences, plain words
### Key decisions      the boundary/assumption choices I made, and why
### Sample run         paste ONE real terminal run
### Test results       table: case, expected, actual, ✓/✗
### What tripped me    the one thing that went wrong on the way (there's always one)

(repeat × 4)

## Reflection
- Which scenario from Sets A–D helped most, and where exactly?
- Which mistake from lesson §19 did I personally make this lab?
- One question I still have about my own Task 4 design.
```

---

## Self-check (score yourself, /5)

| # | Criterion | ✓ |
| --- | --- | --- |
| 1 | Every `plan.md` written **before** its code; IPO + assumptions + pseudocode present | ☐ |
| 2 | Trace tables done by hand for the required cases — and they changed at least one design decision | ☐ |
| 3 | Test tables include every named boundary; all tests actually **run** and are recorded ✓/✗ | ☐ |
| 4 | All programs compile with `g++ -std=c++17 -Wall -Wextra`, zero warnings | ☐ |
| 5 | Reflection names a §19 mistake you actually made, with the fix | ☐ |

**5/5** → the module is complete: return to the
[module home](index.md#where-this-fits-in-the-course) and begin
[Unit 01 · Lesson 1](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md)
— you now know *why* every lesson will ask you to predict before you run.

**Honesty note** (same honour system as
[Assessment](../assessment.md#honesty-policy-the-honour-system)): the
value of this lab is entirely in the *attempts*. A plan.md with wrong
guesses and a fixed design beats a perfect plan copied from a friend —
one is learning, the other is calligraphy.

---

*[← Module home](index.md) · [Lesson](lesson.md) ·
[Scenarios A](scenarios-a.md) · [B](scenarios-b.md) · [C](scenarios-c.md) ·
[D](scenarios-d.md)*
