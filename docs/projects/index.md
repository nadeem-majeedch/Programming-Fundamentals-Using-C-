---
title: "Projects — 10 Builds from Beginner to Integrated"
description: "Ten student-complete projects progressing from a four-operation calculator to an integrated OOP management system — each with overview, objectives, prerequisites, requirements, data structures, milestones, tasks, test plan, edge cases, extensions, a self-assessment rubric, hints, a complete reference solution, and the design decisions behind it."
---

# Projects — ten builds from beginner to integrated

> **How to use this section:** a project is where skills *stay* learned. Each project names the units it requires — **do not start one whose prerequisites you haven't finished** ([the syllabus](../syllabus.md) is the map). Build from the requirements and milestones; the reference solution exists to check your *design*, not to replace your attempt.

## The ten projects

| # | Project | Tier | Units first | The skill it certifies |
| --- | --- | --- | --- | --- |
| 1 | [The Calculator](project-01-calculator.md) | Beginner | 01–03 | I/O, arithmetic, decisions |
| 2 | [Number Analysis Toolkit](project-02-number-analysis.md) | Beginner | 05–06 | loops, digit processing, batching |
| 3 | [Student Grade Analyzer](project-03-grade-analyzer.md) | Basic | 05–07 | batch loops + statistics + functions |
| 4 | [Expense Tracker](project-04-expense-tracker.md) | Basic | 05–08 | menus, accumulators, decomposition |
| 5 | [Quiz Application](project-05-quiz-app.md) | Basic | 05–08 | driven flows, counters, ladder grading |
| 6 | [Inventory Management System](project-06-inventory.md) | Intermediate | 09–11 | collections, searching, strings |
| 7 | [Library Management System](project-07-library.md) | Advanced | 10–12 | records + search + file persistence |
| 8 | [Contact Management System](project-08-contacts.md) | Advanced | 12–13 | files, validation, dynamic views (the syllabus's **Project 3 domain**) |
| 9 | [File-Based Student Management System](project-09-student-files.md) | Advanced | 12–14 | the full file/menu/records stack |
| 10 | [Integrated OOP Management System](project-10-oop-system.md) | Integrated | 14–16 | classes, encapsulation, vectors of objects, modern habits — the capstone rehearsal |

**Alignment with the course's three flagship projects:** the syllabus's 🏁 **Project 1** (Electricity Bill Calculator, Week 5) is a close cousin of #1–#2; 🏁 **Project 2** (Student Records Manager, Week 10) is extended by #3–#6; 🏁 **Project 3** (Contact Management System, Week 16) is the domain of #8 — do #8 before the capstone and the capstone becomes a refactor, not a rewrite. Project #10 is the deliberate rehearsal of everything at once.

## The fifteen-part contract

Every project page carries the same sections — the same contract as the [Programming Labs](../labs/index.md), scaled up:

overview · learning objectives · prerequisites · requirements · functional requirements · suggested data structures · milestones · tasks · test plan · edge cases · extension ideas · grading/self-assessment rubric · hints · complete reference solution · explanation of important design decisions.

## How to run a project by yourself

1. **Read the whole page first** — requirements, milestones, and the rubric. You are agreeing to a contract with yourself.
2. **Milestones are the schedule.** Each one ends in a *running, testable* program — never code for days between runs. A milestone is "done" when its checklist items pass, not when the code merely exists.
3. **Keep a build log.** One line per work session: what you attempted, what broke, what you learned. The rubric awards it; future-you will read it.
4. **Test against the plan before inventing cases.** The edge-case list is where grades and bugs live — write those tests *first* if you can.
5. **Open the reference solution only at the end** — then read it as a design review: diff your structure against it and write two sentences per difference about which you'd ship and why. That review, not the code, is the highest-value hour in the project.
6. **Self-assess against the rubric honestly** — the rubric's "Exemplary" column describes what a professional reviewer would praise, not what is merely working.

## The shared rubric (each project page adds its specifics)

| Dimension | Developing (1) | Proficient (2) | Exemplary (3) |
| --- | --- | --- | --- |
| **Functionality** | some requirements work; happy path only | all core requirements work on normal and boundary inputs | all requirements + edge cases handled and *demonstrated* by the test plan |
| **Correctness under attack** | crashes or corrupts on invalid input | invalid input is caught with messages | invalid input is caught *at the right layer*; the program never lies |
| **Structure** | one long function; duplicated logic | sensible functions; data flows by parameter | single-job functions, named data, no duplication; a stranger could navigate it |
| **Style & readability** | magic numbers, unclear names | named constants, clear names, comments where needed | const-correct, self-documenting; the comments explain *why* |
| **Testing discipline** | "it ran once" | the given test plan passes | the plan passes *plus* self-invented edge cases, logged with results |
| **Reflection** | none | build log present | build log + the design review written after reading the reference solution |

**Scoring:** 18 = complete with honour; 15–17 = strong; 12–14 = pass, revisit two dimensions; below 12 = one more pass through the level's units, then retry.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
