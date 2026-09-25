---
title: "Grading Rubrics"
description: "Self-scoring rubrics for labs and projects in Programming Fundamentals Using C++."
---

# Grading Rubrics

> Score your own labs and projects honestly · [Course home](index.md) · [Assessment](assessment.md)

In self-study mode these rubrics are a **mirror**: they tell you what
"good" means before you call your work done. Instructors adopting the course
can use them unchanged as grading sheets.

Scoring bands: **≥ 90% excellent · 70–89% good — fix the flagged lines ·
< 70% revisit the unit before continuing.**

---

## Lab rubric (all labs)

| Criterion | Excellent (full marks) | Developing (half) | Starting (little) |
| --- | --- | --- | --- |
| **Correctness — 40** | Program meets every requirement; output matches the brief | Runs but misses or misprints some requirement | Does not run / wrong behaviour |
| **Code quality — 25** | Clear names; small single-purpose steps; consistent style; no dead code | Works but names/structure are rough | Unreadable or copy-pasted blocks |
| **Validation & robustness — 15** | All inputs handled; no crash on odd input | Some inputs unhandled | Ignores input handling |
| **Output presentation — 10** | Clean, labelled, aligned output | Readable but rough | Unlabelled dumps |
| **Process — 10** | Compiled early and often; Debug It attempted before fixes; notes on bugs | Sporadic checking | One giant "debug" at the end |

**Total 100.** Record your score and one improvement note per lab.

---

## Project rubrics

### Project 1 — Electricity Bill Calculator (Week 5, 100 points)

| Criterion | Points | What excellent looks like |
| --- | --- | --- |
| Correct bill computation | 40 | Slab tariffs exact for boundary units (e.g. exactly 100, 101, 300, 301); totals verifiable by hand |
| Structure & naming | 20 | Constants for rates; meaningful names; clear step-by-step flow |
| Input validation | 15 | Rejects negative/non-numeric input; reprompts cleanly |
| Formatted output | 15 | Aligned bill with labels, 2-decimal money, units shown |
| Short written report | 10 | `report.md`: what it does, sample runs, one design decision + why |

### Project 2 — Student Records Manager (Week 10, 100 points)

| Criterion | Points | What excellent looks like |
| --- | --- | --- |
| Functionality | 45 | Add / find / list / sort / report all work through a menu loop |
| Design with functions | 20 | One function per menu action; data passed cleanly (vectors by const ref) |
| Input validation | 15 | Menu choice and marks validated; no silent failures |
| Output & reports | 10 | Formatted table; averages to 2 decimals; clear labels |
| Short written report | 10 | Sample session transcript + design notes |

### Project 3 — Capstone: Contact Management System (Week 16, 100 points)

| Criterion | Points | What excellent looks like |
| --- | --- | --- |
| Functionality | 40 | Add, search, sort, edit, delete, list contacts; save + load CSV; menu loop |
| Design | 25 | `Contact` class with encapsulated data; one function per action; `vector<Contact>` |
| Robustness | 20 | File-missing handled; invalid input reprompted; empty-data states handled |
| Written report | 10 | Features, sample runs, design decisions, stretch goals attempted |
| Polish | 5 | Consistent formatting, helpful prompts, README-quality report |

**Stretch goals** (no points — glory): partial-name search, birthday
reminders, statistics, CSV export filters.

---

## Rubric discipline

- Score against the **written lines**, not your mood after a hard session.
- Any line at "Developing" or below = an action item for tomorrow.
- Re-score after fixing; the improvement is the point.

---

*[← Assessment](assessment.md) · [Course home](index.md)*
