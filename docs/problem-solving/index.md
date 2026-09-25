---
title: "Programming and Problem-Solving Fundamentals"
description: "Learn to think about problems before writing code: decomposition, IPO, algorithms, pseudocode, flowcharts, trace tables, testing — with 20 worked scenarios and a lab."
---

# Programming and Problem-Solving Fundamentals

> The bridge module between "my compiler works" and Unit 01 · ~3–4 h + practice
> · [← Course home](../index.md)

## The one idea of this module

> **Programming is not typing code. Programming is thinking, and then
> typing the thinking.**

Students who struggle in Unit 02 are almost never struggling with C++ —
they are struggling with the *thinking that happens before C++*. This
module teaches that thinking: how to take a fuzzy, human request like
"figure out the electricity bill" and turn it into precise steps a computer
can execute. Then, and only then, does it become code.

You will practise on **20 progressively harder scenarios**, each fully
worked — statement, inputs/outputs, thinking questions, approach,
pseudocode, explanation, C++, tests, edge cases — and finish with a
**problem-solving lab**. No C++ knowledge beyond the
[Week-0 first program](../getting-started/first-program-exercise.md) is
required; every C++ feature used is explained where it first appears, and
the same ideas are re-taught formally in Units 02–06.

---

## Try It Yourself Before Looking at the Solution

> **This section is the most important thing on this page.** The 20
> scenarios below are fully worked — which makes them wonderful for
> learning and dangerous for *thinking* if you read them like a novel.

**The rule: your brain must meet every scenario before your eyes do.**
Reading a solution and nodding produces the *feeling* of competence without
the substance — educators call it the illusion of fluency. A solution you
read is a story; a solution you almost-wrote is a skill.

**The protocol — before opening any scenario:**

```text
1. READ the problem statement only.        (stop before "Thinking questions")
2. RESTATE it aloud in your own words — one or two sentences.
3. SKETCH the IPO: what comes in? what must come out? what happens between?
4. ANSWER the thinking questions in writing — guesses are fine, silence isn't.
5. WRITE pseudocode in your notes — ugly is fine, vague is not.
6. NOW open the scenario. Compare, don't grade:
   - Where did we agree? (reinforces what you already own)
   - Where did they differ? (that difference is the lesson — study it)
   - Which test case would break MY version? (then check if it breaks theirs)
7. Only now: type the C++, compile, run the tests yourself.
```

Total honest attempt: **5–10 minutes per scenario.** Too easy? Good — that
confidence is real now. Stuck? Write down *where* you got stuck and *what
you would ask*, then read. That question in your notes is worth more than
the solution is.

**Difficulty honesty:** Sets A and B (scenarios 1–10) need nothing but
arithmetic and the idea of a choice. Set C (11–15) needs repetition — the
lesson's §14 prepares you, Unit 05 teaches it formally. Set D (16–20)
combines everything; even experienced students should attempt these before
reading. ★ = think · ★★ = sweat a little · ★★★ = sleep on it.

---

## What's in the module

| Piece | What you do | Time |
| --- | --- | --- |
| 📖 **[The Lesson](lesson.md)** | all 20 concepts — computational problems, decomposition, IPO, requirements/assumptions/constraints, algorithms, pseudocode, flowcharts, decisions, repetition, dry runs, trace tables, test cases, edge cases, classic mistakes, translation to C++ — threaded through **one worked example** (the Cafeteria Bill) | 60–90 min |
| ✏️ **Scenarios 1–5** — [Set A: First steps](scenarios-a.md) | pure input→process→output problems; ★ | 5–10 min each |
| ✏️ **Scenarios 6–10** — [Set B: Decisions](scenarios-b.md) | problems that branch: thresholds, categories, choices | 10 min each |
| ✏️ **Scenarios 11–15** — [Set C: Repetition](scenarios-c.md) | problems that loop: totals, counting, tables | 10–15 min each |
| ✏️ **Scenarios 16–20** — [Set D: Combining everything](scenarios-d.md) | full problems: validation, multi-step processing, trace tables | 15 min each |
| 🧪 **[Problem-Solving Lab](lab.md)** | 4 practical tasks + write-up + self-check | 60–90 min |

Suggested pace: lesson on day 1, one scenario set per day, lab on day 5 —
one "pre-course week" alongside the
[setup checklist](../getting-started/setup-checklist.md).

---

## The method in one line (the whole module, compressed)

```text
UNDERSTAND  →  DECOMPOSE  →  IPO  →  ALGORITHM  →  (pseudocode / flowchart)
   →  DRY RUN (trace table)  →  TEST PLAN  →  CODE  →  TEST  →  FIX
```

The [lesson](lesson.md) unpacks every arrow; the scenarios run it 20 times;
the lab makes it yours.

---

## Where this fits in the course

| This module | Later |
| --- | --- |
| thinking in IPO and steps | Unit 01–03: variables, types, input/output — the machinery of I, P, O |
| decisions on paper (§13) | Unit 04: `if`/`else`/`switch` in C++ |
| repetition on paper (§14) | Unit 05–06: `while`/`for` in C++ |
| dry runs and trace tables (§15–16) | a habit used in every unit to Unit 16 |
| test cases and edge cases (§17–18) | every lab's "self-check" section |

Finish the [lab](lab.md), and continue to
[Unit 01 · Lesson 1](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md)
— now knowing exactly why the course insists on *predict before you run*.

---

*[← Course home](../index.md) · [Lesson](lesson.md) ·
[Scenarios A](scenarios-a.md) · [B](scenarios-b.md) · [C](scenarios-c.md) ·
[D](scenarios-d.md) · [Lab](lab.md)*
