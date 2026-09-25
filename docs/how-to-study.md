---
title: "How to Study This Course"
description: "The study method, weekly planner, and self-scoring system for Programming Fundamentals Using C++."
---

# How to Study This Course

> Read this once before Unit 01 · [Course home](index.md) · [Syllabus](syllabus.md)

This course is built for self-study: every unit gives you the material, the
practice, and the answer keys you need to verify your own progress. This page
explains the method that makes it work. (For the underlying *learning
skills* — reading code, predicting, debugging, when to peek at hints, the
notebook and portfolio — see the companion guide, [How to Learn
Programming](learning-guide.md).)

---

## The method, in one line

**Read → Run → Modify → Solve → Debug → Revise**

| Step | What you do | Why |
| --- | --- | --- |
| 1 · **Read** | Study the lesson slowly. Don't skim. | Programming is precise; every word usually carries meaning. |
| 2 · **Run** | Compile and run **every** example as you meet it. | Reading code you haven't run is reading a rumour. |
| 3 · **Modify** | Change something in each example, predict the new output, then check. | Prediction is where real understanding forms. |
| 4 · **Solve** | Do the unit's exercises — attempt everything before checking any answer. | Struggle first; the answer then sticks. |
| 5 · **Debug** | Fix the unit's Debug It programs *before* reading their fixes. | Finding bugs is the core professional skill. |
| 6 · **Revise** | Finish with the unit's revision sheet and flashcards. | Two pages now save hours before the next unit and the final. |

**The golden rule:** never move on while something still feels like magic. If
a line of code surprises you, run it, change it, run it again.

---

## The weekly rhythm (16-week plan)

Each unit = **one week**, two sessions. Sessions are ≈ 90–120 minutes each;
the whole week is ≈ 5–7 hours.

> The session-by-session version of this rhythm — with prerequisites,
> objectives, reading, exercises, labs, challenges, and completion checklists
> for all 32 sessions — is the **[16-Week Roadmap](roadmap/index.md)**.

| Day | Task | Time |
| --- | --- | --- |
| Day 1 | Session N.1: read, run, modify every example | 90–120 min |
| Day 2 | Session N.1 exercises (attempt, then check) | 45–60 min |
| Day 3 | Session N.2: read, run, modify every example | 90–120 min |
| Day 4 | Session N.2 exercises + unit **Debug It** activities | 45–60 min |
| Day 5 | **Lab**: brief → starter → build → compare with solution → self-score | 45–90 min |
| Day 6 | **Quiz** (all 10 questions), read answer key, score yourself | 30–45 min |
| Day 7 | Revision sheet + flashcards; preview next unit's first page | 20–30 min |

**Self-paced plan?** Keep the *order*, drop the calendar. A "week" may take
two days or three weeks of evenings — the sequence is what matters.

---

<a name="weekly-planner"></a>
## Study planner (copy into your own notes)

```text
Week __  Unit __  ────────────────────────────────  dates: __ to __
[ ] Session 1 read + all examples run        ( )
[ ] Session 1 exercises done                 ( )
[ ] Session 2 read + all examples run        ( )
[ ] Session 2 exercises + Debug It done      ( )
[ ] Lab built + checked against solution     ( )
[ ] Quiz attempted, scored ____ /10          ( )
[ ] Revision sheet + flashcards done         ( )
Notes / things that surprised me:
____________________________________________________________
```

---

## Self-scoring: when is a unit "done"?

| Quiz score | Meaning | Action |
| --- | --- | --- |
| **9–10 / 10** | Ready | Move to the next unit. |
| **7–8 / 10** | Almost | Re-read the sections the wrong answers point to; retake the quiz tomorrow. |
| **≤ 6 / 10** | Not yet | Redo the exercises and the revision sheet, re-run the examples you modified, then retake the quiz. |

The same idea applies to labs: complete it, compare with the published
solution, and score yourself with the [lab rubric](grading.md#lab-rubric-all-labs).
A lab is "done" when your version satisfies every rubric line — not when it
merely runs.

---

## Rules of thumb that separate learners who finish from learners who stall

1. **Type every example by hand.** Muscle memory is real; the typos you make
   and fix are the lesson.
2. **Never copy-paste code you are learning.** Copy-paste after you
   understand — for your own projects, not for practice.
3. **Predict before you run.** Say the expected output out loud, then check.
   Being wrong is the useful part.
4. **Fix bugs in this order:** read the error message → check the line and
   the lines just before it → simplify → explain the code aloud → search the
   [error catalogue](toolchain/compiler-errors.md) → ask.
5. **Stuck > 30 minutes?** Move to the hint. Stuck > 1 hour? Read the
   solution, close it, rebuild from memory. That's not cheating; it's a
   technique.
6. **A unit is done when the lab works and the quiz is ≥ 90%** — not when the
   pages have been read.
7. **Keep a bug diary.** One line per bug: what you wrote, what the compiler
   said, what the fix was. By Unit 16 you'll be your own best teacher.
8. **Practice in bursts, not marathons.** 60–90 focused minutes beats 4
   fading hours.

---

## What to do when something breaks

1. **Read the error message fully** — the first error is usually the real
   one; later errors are often echoes.
2. Check the line number, then the **few lines before** it (many errors are
   reported after their cause).
3. Reduce the program: comment out half; does the error move?
4. Consult the [compiler error catalogue](toolchain/compiler-errors.md) and
   the [FAQ](faq.md).
5. Still stuck? Reproduce the error in a fresh 5-line program and search
   that — or ask in the repository's
   [issue tracker](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/issues).

---

## Before you start

- [ ] [Getting Started](getting-started/index.md) — compiler installed and
      `sanity-check.cpp` runs.
- [ ] A code editor configured — [VS Code tips](toolchain/vs-code-tips.md).
- [ ] A folder for your work, e.g. `cpp-course/unit-01/`, `cpp-course/unit-02/`…
- [ ] The study method above, printed or bookmarked.

**Then begin:** [Lesson 1 — What is a program?](units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md) 🚀

---

*[← Course home](index.md) · [Syllabus](syllabus.md) · [Assessment](assessment.md)*
