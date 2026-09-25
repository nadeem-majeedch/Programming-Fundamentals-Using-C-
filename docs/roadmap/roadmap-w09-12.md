---
title: "Roadmap — Weeks 09–12: Data Structures & Algorithms"
description: "Sessions 9.1–12.2: arrays & vectors, searching & sorting with Project 2, strings & text processing, and file I/O — each with the full eleven-part session contract."
---

# Weeks 09–12 — Data Structures & Algorithms (Stages C/D)

> Storage, ordering, text, and persistence — the working data-handling
> toolkit of a real programmer. [← Weeks 5–8](roadmap-w05-08.md) ·
> [Roadmap home](index.md) · [Weeks 13–16 →](roadmap-w13-16.md)

---

## Week 9 — Arrays & vectors

### Session 9.1 — The C array: storage and classic passes

| Part | Details |
| --- | --- |
| **Prerequisites** | Stage B — loops and functions fluent |
| **Learning objectives** | declare, initialize, and index arrays; traverse, sum, count, and find extremes; explain zero-based indexing and out-of-bounds danger; pass arrays to functions (pointer + length) |
| **Concepts** | array declaration/initialization, indexing, traversal, bounds, arrays with functions, the decay convention |
| **Recommended reading** | [Arrays Lesson 1 — basics](../arrays/lesson-1-basics.md) · [Lesson 2 — classic passes](../arrays/lesson-2-classic-passes.md) |
| **Examples to study** | both lessons' passes — reproduce max, sum, and search from memory afterward |
| **Exercises** | [Practice Bank I-01–I-06](../practice/intermediate.md) · [arrays exercises](../arrays/exercises.md) (basics part) |
| **Lab/practice** | [arrays labs](../arrays/labs.md) — first two |
| **Challenge** | [Practice Bank I-02](../practice/intermediate.md) — maximum *and its position* |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ three classic passes written from memory ☐ 2 labs done ☐ can explain why arrays need a length parameter |

### Session 9.2 — vector, range-for, and the arrays miniproject

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 9.1 |
| **Learning objectives** | use `vector` for growable data; traverse with range-based for (read and write forms); choose array vs vector by the problem; build the marks analyzer |
| **Concepts** | `vector`, `push_back`, `size()`, range-based for, `int&` element writes, array-vs-vector choice |
| **Recommended reading** | [Arrays Lesson 3 — arrays & functions](../arrays/lesson-3-arrays-functions.md) (skim) · [Arrays Lesson 4 — matrices](../arrays/lesson-4-matrices.md) (skim — full treatment in integrated problems) |
| **Examples to study** | Lesson 3's passing examples · the miniproject brief |
| **Exercises** | [Practice Bank I-07–I-12](../practice/intermediate.md) · [arrays predictions](../arrays/predictions.md) |
| **Lab/practice** | [arrays miniproject](../arrays/miniproject.md) — the Marks Analyzer, milestones 1–3 |
| **Challenge** | [Practice Bank I-11](../practice/intermediate.md) — matrix row/column sums |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ analyzer milestones 1–3 ☐ vector version *and* array version of one analyzer ☐ [W09 quiz](../self-assessment/weeklies-3.md) ≥ 90% |

---

<a name="week-10-searching-sorting-project-2"></a>

## Week 10 — Searching & sorting — 🏁 Project 2

### Session 10.1 — Linear and binary search

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 9 — collections fluent |
| **Learning objectives** | implement linear search (counting and first-match forms); implement binary search and state its sorted precondition; feel the complexity difference (linear vs logarithmic) from probe counts |
| **Concepts** | linear search, binary search, loop invariants, sortedness as a precondition, complexity intuition |
| **Recommended reading** | [Algorithms Lesson 1 — recursion](../algorithms/lesson-1-recursion.md) (skim — the call-stack idea returns) · [Lesson 2 — searching](../algorithms/lesson-2-searching.md) |
| **Examples to study** | Lesson 2's probe traces — trace binary search on paper for two keys |
| **Exercises** | [Practice Bank A-25, A-27](../practice/advanced.md) · [algorithms exercises](../algorithms/exercises.md) (searching part) |
| **Lab/practice** | [algorithms labs](../algorithms/labs.md) — searching station |
| **Challenge** | [Practice Bank C-36](../practice/challenge.md) — minimum in a rotated sorted array |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ binary search written from memory with the midpoint guard ☐ two paper traces ☐ can state *why* unsorted input breaks binary search |

### Session 10.2 — The elementary sorts and Project 2

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 10.1 |
| **Learning objectives** | implement bubble, selection, and insertion sorts; trace each on the same data; choose a sort by data properties; build the Project 2 records manager |
| **Concepts** | bubble/selection/insertion sort, pass mechanics, swap counting, stability intuition, adaptivity, records + sort keys |
| **Recommended reading** | [Algorithms Lesson 3 — sorting](../algorithms/lesson-3-sorting.md) · [Project 2 brief](../syllabus.md) (Stage D: Student Records Manager) · [Projects collection #3](../projects/project-03-grade-analyzer.md) as rehearsal |
| **Examples to study** | Lesson 3's three dry runs on one shared array |
| **Exercises** | [Practice Bank A-28–A-31](../practice/advanced.md) · [algorithms traces](../algorithms/traces.md) |
| **Lab/practice** | **🏁 [Project 2 — Student Records Manager](../projects/project-03-grade-analyzer.md)** (rehearsal) then the syllabus brief — milestones, test plan, rubric |
| **Challenge** | [Practice Bank A-31](../practice/advanced.md) — two-key record sort |
| **Estimated self-study time** | 120 min (project week) |
| **Completion checklist** | ☐ **Project 2: milestones, tests, rubric self-scored** ☐ all three sorts instrumented with counters ☐ [W10 quiz](../self-assessment/weeklies-3.md) ≥ 90% |

---

## Week 11 — Strings & text processing

### Session 11.1 — std::string: the working operations

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 9–10 — collections fluent |
| **Learning objectives** | create, read, index, concatenate, compare, and slice strings; use `find`, `substr`, and modification; process characters with `<cctype>` |
| **Concepts** | string creation/input, indexing, `+` and `+=`, `==`/`<` value comparison, `find`/`substr`, per-character processing, case conversion |
| **Recommended reading** | [Strings Lesson 1 — two ways](../strings/lesson-1-two-ways.md) · [Lesson 2 — indexing & comparison](../strings/lesson-2-indexing-comparison.md) |
| **Examples to study** | both lessons' worked examples |
| **Exercises** | [Practice Bank I-13–I-18](../practice/intermediate.md) · [strings exercises](../strings/exercises.md) (first part) |
| **Lab/practice** | [strings labs](../strings/labs.md) — username validator + password checker |
| **Challenge** | [Practice Bank I-16](../practice/intermediate.md) — palindrome line, letters-only |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ token scanner (word-start rule) written from memory ☐ 2 labs done ☐ can contrast `>>` vs `getline` input for strings |

### Session 11.2 — Text tools and the miniproject

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 11.1 |
| **Learning objectives** | split lines into tokens; convert between strings and numbers (`stoi`, `to_string`); avoid the common string mistakes; build the Text Analysis Toolkit |
| **Concepts** | tokenization, string↔number conversion, C-strings at a glance, common mistakes gallery |
| **Recommended reading** | [Strings Lesson 3 — find & modify](../strings/lesson-3-find-modify.md) · [Lesson 4 — conversions & mistakes](../strings/lesson-4-conversions-mistakes.md) |
| **Examples to study** | Lesson 4's mistake gallery — reproduce two, fix two |
| **Exercises** | [Practice Bank I-19–I-24](../practice/intermediate.md) · [strings debugging](../strings/debugging.md) D1–D3 |
| **Lab/practice** | [strings miniproject](../strings/miniproject.md) — Text Analysis Toolkit, milestones 1–3 |
| **Challenge** | [strings challenges](../strings/challenges.md) — two of your choice |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ toolkit milestones 1–3 ☐ 3 debug hunts ☐ [W11 quiz](../self-assessment/weeklies-3.md) ≥ 90% |

---

## Week 12 — File I/O

### Session 12.1 — Streams: writing and reading files

| Part | Details |
| --- | --- |
| **Prerequisites** | Weeks 9–11 — data handling fluent |
| **Learning objectives** | write and read text files with `ofstream`/`ifstream`; check opens; read token-grain and line-grain; choose append vs truncate deliberately |
| **Concepts** | file streams, open modes, `ios::app`, open checks, `>>` vs `getline` on files, close discipline |
| **Recommended reading** | [Files Lesson 1 — streams](../files/lesson-1-streams.md) · [Lesson 2 — reading & writing](../files/lesson-2-reading-writing.md) |
| **Examples to study** | both lessons' worked programs — run the write-then-read cycle yourself |
| **Exercises** | [Practice Bank A-11–A-14](../practice/advanced.md) · [files exercises](../files/exercises.md) (streams part) |
| **Lab/practice** | [files labs](../files/labs.md) — student record file + expense tracker |
| **Challenge** | [Practice Bank A-14](../practice/advanced.md) — the append-mode log |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ write→close→read cycle performed ☐ 2 labs done ☐ open-check habit demonstrated in every file program this week |

### Session 12.2 — CSV records, errors, and the miniproject

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 12.1 |
| **Learning objectives** | parse CSV-style records (find/split/stoi); handle missing files and malformed lines; persist records and reload them; build the File-Based Student Management System |
| **Concepts** | CSV parsing, record storage, file error handling, bad-line tolerance, the load→process→save cycle |
| **Recommended reading** | [Files Lesson 3 — errors & mistakes](../files/lesson-3-errors-mistakes.md) |
| **Examples to study** | Lesson 3's failure gallery |
| **Exercises** | [Practice Bank A-15–A-18](../practice/advanced.md) · [files debugging](../files/debugging.md) D1–D3 |
| **Lab/practice** | [files miniproject](../files/miniproject.md) — milestones 1–3 |
| **Challenge** | [files challenges](../files/challenges.md) — two of your choice |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ miniproject milestones 1–3 ☐ round-trip test written (save→load→compare) ☐ **[Stages C/D checkpoint](index.md): W12 quiz ≥ 90%** — Stage E unlocks |

---

**Next:** [Weeks 13–16 — Memory, OOP, and the capstone →](roadmap-w13-16.md) · [Roadmap home](index.md)
