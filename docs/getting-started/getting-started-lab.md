---
title: "Lab 00 — Your First Build Lab"
description: "The Week-0 mini lab: build a name poster, then debug a seeded file. Your first full edit-compile-run cycles."
---

# Lab 00 — Your First Build Lab

> Week 0 · ~45–60 min · starter + Debug It + self-check ·
> [← Orientation hub](index.md) · [lab brief below](#part-1build-the-poster)

The course's labs follow one shape from now on: **build a program → hunt
bugs in a seeded file → write up → self-check against the rubric.** Lab 00
is that shape, at Week-0 size. Everything is saved in
`cpp-course/unit-00/` (see [lab work layout](getting-started-lesson.md#20-how-students-should-organize-and-submit-lab-work)).

## Files

| File | Purpose |
| --- | --- |
| [`starter/lab-00-poster.cpp`](starter/lab-00-poster.cpp) | Part 1 — skeleton with `TODO` comments, you fill it in |
| [`starter/lab-00-debug-it.cpp`](starter/lab-00-debug-it.cpp) | Part 2 — a "working" poster program with **4 seeded bugs** |
| — | Part 3 — your `lab-00-notes.md` write-up (template below) |

<a name="part-1build-the-poster"></a>
## Part 1 — Build the poster

**Scenario.** Terminals have no graphics — but they have *characters*. Your
program prints a **name poster**: a framed card with your name, your city,
and a goal for this course.

**Requirements**

1. Six output lines exactly, in this shape:

   ```text
   =========================
   |                       |
   |   AYESHA KHAN         |
   |   Lahore · BS Data Sci|
   |                       |
   =========================
   ```

   *(yours will differ — the *shape* is the spec: top border, blank wall,
   name line, city + goal line, blank wall, bottom border)*
2. Your name on one line; your city + your course goal on the next.
3. Both borders are the **same width**, and the widest content line fits
   inside them (count the characters — this is the exercise's quiet lesson).
4. Compiles with **zero warnings**:
   `g++ -std=c++17 -Wall -Wextra lab-00-poster.cpp -o lab00`
5. At least one **chained** `<<` statement.

**Method** (this is the real curriculum): add **one output line**, compile,
run, look. Repeat. Small steps, always compiling — the habit all 16 units
run on.

## Part 2 — Debug It

Open
[`starter/lab-00-debug-it.cpp`](starter/lab-00-debug-it.cpp). It should print
a poster — but contains **4 seeded bugs**: two compile errors, a
linker-flavoured mistake, and a wrong-output bug the compiler cannot catch.

**Rules of the hunt**

- Read the code and **write down all four** before fixing anything.
- Fix **one bug**, recompile, and note what the compiler said (or didn't).
- Stuck? Hint ladder: re-read
  [reading error messages](getting-started-lesson.md#16-how-to-read-compiler-error-messages)
  → [troubleshooting scenarios](getting-started-troubleshooting.md) →
  [error catalogue](../toolchain/compiler-errors.md) → *then* compare with
  your Part 1 solution's techniques.

**Done means:** it compiles warning-free, prints a correct poster, and you
can say for each bug *what kind* it was (compile / link / logic) and *how
you found it*.

## Part 3 — Write it up

Create `lab-00-notes.md` (half a page, the course's standard lab write-up):

```markdown
# Lab 00 — notes
## What it does        two sentences, plain words
## Sample run          paste one real run from your terminal
## How I built it      3–5 bullets: order of steps, one design choice + why
## Debug It            the 5 bugs: kind (compile/link/logic), how found, fix
```

## Self-check (score yourself, /5)

| # | Criterion | ✓ |
| --- | --- | --- |
| 1 | Poster prints with correct shape; borders equal width | ☐ |
| 2 | Compiles with zero warnings; runs cleanly | ☐ |
| 3 | All 5 Debug It bugs found, fixed, *classified* | ☐ |
| 4 | Write-up has all four headings; sample run is a real paste | ☐ |
| 5 | Bug diary has ≥ 5 entries from this lab | ☐ |

5/5 → Week 0 is complete: tick the
[setup checklist](setup-checklist.md) and begin
[Unit 01 · Lesson 1](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md)
— where the same `cout` lines become a subject of study instead of a tool.

---

*[← Orientation hub](index.md) · [Exercises](getting-started-exercises.md) ·
[Getting Started lesson](getting-started-lesson.md)*
