---
title: "Course Completion Checklist"
description: "The one-page status of the course — structure, lessons, labs, exercises, projects, quizzes, code validation, links, GitHub Pages, accessibility, and self-study readiness."
---

# Course Completion Checklist

> Status of the whole course as a deliverable · [Course home](index.md) · [Audit reports on GitHub](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/tree/main/reports)

**Everything on this page is in place.** The course is complete for
self-study: a student with no programming experience can start at the main
README and reach the capstone without an instructor.

---

## Course structure

- [x] **16 units · 32 sessions** planned and mapped to teaching modules
- [x] **Six stages** (Foundations → Capstone) defined in the [syllabus](syllabus.md)
- [x] Canonical reading order agreed by syllabus, roadmap, website pager, and homepage
- [x] **Week 0 orientation** ([Getting Started](getting-started/index.md)): per-OS compiler guides, online-compiler option, sanity check, setup checklist, troubleshooting guide, Lab 00
- [x] **Problem-Solving module** before any syntax: 20 progressively harder scenarios, pseudocode, trace tables, test design, lab
- [x] **Beyond-Week-16 enrichment path** (inheritance, exceptions, modern C++, STL, templates, multi-file projects) defined in the [roadmap](roadmap/roadmap-w13-16.md)

## Lessons

- [x] **24 module homes** with objectives, lesson maps, and practice tables
- [x] **C++ Foundations** — 4 lessons (structure, data, operators, conversion) + [Unit 01's two sessions](units/unit-01-introduction-to-programming-and-cpp/index.md)
- [x] **C++ Input/Output** — 3 lessons (`cout`, `cin`, `getline`)
- [x] **Decisions** — 4 lessons + requirements-to-decisions pipeline
- [x] **Iteration** — 4 lessons (while/do-while, for, break/continue, nested)
- [x] **Functions** — 4 lessons (parameters, scope, references, overloading/design)
- [x] **Arrays** — 4 lessons; **Algorithms** — 3 lessons (recursion, searching, sorting)
- [x] **Strings** — 4 lessons; **Files** — 3 lessons
- [x] **Pointers** — 3 lessons; **Records** — 3 lessons; **OOP** — 3 lessons (no inheritance by design)
- [x] **Enrichment:** Inheritance & Polymorphism, Operator Overloading & Templates, STL, Robustness (exceptions), Modern C++, Modular Programming
- [x] Every concept follows: plain-language explanation → syntax → worked example → explanation → practice pointer

## Labs

- [x] **Unit labs inside every module** (decisions 8, iteration 10, functions 8, arrays 7, I/O 5, strings 7, files 6, pointers 4, records 6, OOP 7 class labs)
- [x] **[Programming Labs collection](labs/index.md): 42 scenarios** in five levels (beginner → integrated)
- [x] Every lab: scenario, requirements, inputs/outputs, constraints, example, test cases, student tasks, hints, extension challenges, **complete solution, explanation, testing checklist**
- [x] Seeded-bug "Debug It" starters with verified bug counts and fix lists
- [x] Mini-projects per module (Marks Analyzer, Text Toolkit, Quiz Runner, Menu-Driven Toolkit, Modernisation Lab, …)

## Exercises

- [x] Per-module exercise sets (30–36 in the core modules), **graded beginner → challenge**
- [x] **Output-prediction sets** with worked answers (separate keys)
- [x] **Debugging hunts** — 10 per module, hint-laddered, with the fix and the why
- [x] **Challenge sets** — 10–15 per module, ★/★★★ rated
- [x] **[Practice Bank](practice/index.md): 200 categorized problems** — five tiers, 17 topics, each with statement, difficulty, I/O, constraints, sample tests, numbered hints, reference solution, explanation
- [x] Getting Started exercises (10 beginner + 5 challenges) with selected answers

## Projects

- [x] **[10 project briefs](projects/index.md)** from calculator to integrated OOP management system
- [x] Each with overview, objectives, prerequisites, functional requirements, suggested data structures, milestones, tasks, test plan, edge cases, extension ideas, **self-assessment rubric**, hints, complete reference solution, design decisions
- [x] Three flagship projects (Weeks 5 / 10 / 16) with rehearsal projects mapped in the collection

## Quizzes & assessment

- [x] **[Self-Assessment System](self-assessment/index.md): 34 instruments · 366 questions**
- [x] 16 weekly quizzes (W01–W16), 8 topic revision tests, 4 cumulative tests, **2 comprehensive practice finals**
- [x] Every question difficulty-labelled with a **hidden answer key and explanation**
- [x] Unit 01's own quiz + [revision sheet](units/unit-01-introduction-to-programming-and-cpp/revision.md); scoring bands (≥ 90% move on · 70–89% revisit · < 70% redo)
- [x] Lab & project rubrics in [grading](grading.md); post-exam worksheets

## Code validation

- [x] **1,576 embedded C++ listings + 9 standalone files validated** (static suite: comment/string-aware balance, include-vs-usage, namespace discipline, API scan, memory pairing) — 14 genuine defects found and fixed
- [x] Seeded-bug files verified to match their published diagnoses
- [x] [Validation report on GitHub](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/blob/main/reports/cpp-validation.md)
- [ ] **Optional next layer:** a CI compile sweep (`g++ -fsyntax-only`) on the deploy runner — the only check this environment could not run

## Links

- [x] **3,052 relative links verified resolving** (`tools/check-links.sh`)
- [x] **1,063 fragment anchors valid on github.com and Jekyll/Pages** (`tools/check-anchors.sh`)
- [x] Case-sensitivity walk of every path segment: clean
- [x] All course links are relative — they work on GitHub, on the website, and on project-pages URLs

## GitHub Pages

- [x] Student learning website in `docs/`: custom lightweight layout, breadcrumbs, **prev/next module pager**, mobile-friendly CSS, dark-mode support, no animations
- [x] **Deployment workflow** (`.github/workflows/deploy.yml`): official Pages actions, correct permissions, Jekyll build with `--baseurl`, homepage-entry-point check
- [x] Planning documents and technical material **excluded from the published site**
- [x] Maintainer ops page: `docs/technical/github-pages.md` (not published)
- [ ] **One manual step remains:** Settings → Pages → Source: *GitHub Actions* (first deploy), then the post-deploy checklist in the technical page

## Accessibility

- [x] Skip-to-content link; semantic headings; single H1 per page
- [x] Viewport meta + responsive layout down to phone widths; wide tables scroll safely
- [x] Light/dark via OS preference; no animations or tracking; system fonts
- [x] Collapsible answers that keep questions spoiler-free while remaining keyboard-usable

## Student self-study readiness

- [x] **Day-1 path explicit:** README → Getting Started → Problem-Solving → **Unit 01 · Lesson 1** — no guesswork about where to begin
- [x] Prerequisites stated everywhere ("none — this is the start" for Session 1.1)
- [x] **Try-first protocol** ("Try It Yourself Before Looking at the Solution") stated in Week 0 and enforced by every module
- [x] Hints always precede solutions; answers separated or hidden so self-testing works
- [x] **Study method taught explicitly:** [How to Study](how-to-study.md) + [How to Learn Programming](learning-guide.md) (the Read → Predict → Code → Run → Test → Debug → Explain → Extend cycle), plus a weekly planner
- [x] Common beginner mistakes galleries and the [compiler error catalogue](toolchain/compiler-errors.md)
- [x] Student-experience audit completed with all Critical/High/Medium findings fixed ([report on GitHub](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/blob/main/reports/student-experience-audit.md))

---

*Course home · [Syllabus](syllabus.md) · [16-Week Roadmap](roadmap/index.md) · [How to Study](how-to-study.md) · [Getting Started](getting-started/index.md)*
