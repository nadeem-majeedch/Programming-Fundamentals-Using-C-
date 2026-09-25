---
title: "Programming Labs — 42 Scenarios from Beginner to Integrated"
description: "The course's central lab collection: 42 substantial, realistic lab scenarios in five levels, each with scenario, problem statement, objectives, requirements, input/output, constraints, example, test cases, student tasks, hints, extensions, complete solution, explanation, and a testing checklist."
---

# Programming Labs — the five-level collection

> **How to use this section:** labs are where concepts become skill. Each level names the units it requires — **do not start a lab whose concepts you haven't met** ([the syllabus](../syllabus.md) is the map). Attempt each lab from its task list alone; the complete solution and explanation come *after* your attempt, and the testing checklist is the referee.

## The five levels

| Level | Units first | Labs | The territory |
| --- | --- | --- | --- |
| **1 — Beginner** | 01–04 | 8 | first programs, I/O, arithmetic, decisions — no loops yet |
| **2 — Basic** | 04–06 | 8 | menus, validation, counted and sentinel loops, patterns |
| **3 — Intermediate** | 07–09 | 8 | functions and decomposition, arrays and `vector`, collection statistics |
| **4 — Advanced** | 10–15 | 10 | algorithms, strings, files, pointers, records, classes |
| **5 — Integrated** | 12–16 | 8 | multi-concept systems — the capstone rehearsal tier |

## The fifteen-part shape

Every lab below carries the same fifteen parts — this is the contract:

1. **Scenario** — the realistic situation and who the software serves
2. **Problem statement** — the precise task in one paragraph
3. **Learning objectives** — what you can do afterwards
4. **Requirements** — numbered, testable statements
5. **Input** — the exact input contract
6. **Output** — the exact output contract
7. **Constraints** — the limits and honesty rules (ranges, error handling)
8. **Example** — one worked run
9. **Test cases** — normal, boundary, invalid (the Debugging module's three families)
10. **Student tasks** — the build order
11. **Hints** — graded, one at a time
12. **Extension challenges** — for after the checklist passes
13. **Complete solution** — full, compilable code
14. **Solution explanation** — why, not just what
15. **Testing checklist** — the pass/fail list before you move on

## The protocol

1. **Read the whole lab before typing anything.** Requirements and constraints are the contract.
2. **Build in task order** — every task ends in a *running* program. The tasks are compiled, not aspirational.
3. **Test with the given cases before inventing your own.** Then invent your own — the boundary rows are where marks and bugs live.
4. **Open the solution only after the checklist is green** — or after two honest failed attempts (then diff your version against it; the diff is the lesson).
5. **Log the bugs you hit** in the bug journal — the [Debugging Challenge Lab](../debugging/lab.md)'s Phase 3 discipline applies course-wide.

## The progress checklist

- [ ] **Level 1:** L1-01 ☐ · L1-02 ☐ · L1-03 ☐ · L1-04 ☐ · L1-05 ☐ · L1-06 ☐ · L1-07 ☐ · L1-08 ☐
- [ ] **Level 2:** L2-09 ☐ · L2-10 ☐ · L2-11 ☐ · L2-12 ☐ · L2-13 ☐ · L2-14 ☐ · L2-15 ☐ · L2-16 ☐
- [ ] **Level 3:** L3-17 ☐ · L3-18 ☐ · L3-19 ☐ · L3-20 ☐ · L3-21 ☐ · L3-22 ☐ · L3-23 ☐ · L3-24 ☐
- [ ] **Level 4:** L4-25 ☐ · L4-26 ☐ · L4-27 ☐ · L4-28 ☐ · L4-29 ☐ · L4-30 ☐ · L4-31 ☐ · L4-32 ☐ · L4-33 ☐ · L4-34 ☐
- [ ] **Level 5:** L5-35 ☐ · L5-36 ☐ · L5-37 ☐ · L5-38 ☐ · L5-39 ☐ · L5-40 ☐ · L5-41 ☐ · L5-42 ☐

## Level index

| # | Lab | Context | Core concepts |
| --- | --- | --- | --- |
| **Level 1 — [Beginner](level-1.md)** | | | |
| L1-01 | [The Canteen Receipt](level-1.md#l1-01--the-canteen-receipt) | billing | cout, arithmetic |
| L1-02 | [Student ID Card](level-1.md#l1-02--the-student-id-card) | student systems | cout, string output |
| L1-03 | [Temperature Desk](level-1.md#l1-03--the-temperature-desk) | utility conversion | cin, arithmetic |
| L1-04 | [Market Money](level-1.md#l1-04--market-money) | small business | arithmetic, formatting |
| L1-05 | [Cinema Pass](level-1.md#l1-05--the-cinema-pass) | billing rules | if/else-if |
| L1-06 | [Load Shedding Checker](level-1.md#l1-06--the-load-shedding-checker) | utility schedule | switch |
| L1-07 | [Admission Desk](level-1.md#l1-07--the-admission-desk) | student systems | compound conditions |
| L1-08 | [Word Wizard](level-1.md#l1-08--the-word-wizard) | text analysis | getline, char counting |
| **Level 2 — [Basic](level-2.md)** | | | |
| L2-09 | [The Menu Canteen](level-2.md#l2-09--the-menu-canteen) | billing | do-while menus |
| L2-10 | [Fee Counter](level-2.md#l2-10--the-fee-counter) | student fees | sentinel sums |
| L2-11 | [Utility Bill Desk](level-2.md#l2-11--the-utility-bill-desk) | utility calculation | tiered loops + validation |
| L2-12 | [Quiz Machine](level-2.md#l2-12--the-quiz-machine) | student practice | counters, do-while |
| L2-13 | [Number Properties Desk](level-2.md#l2-13--the-number-properties-desk) | algorithmic | digit loops |
| L2-14 | [Pattern Press](level-2.md#l2-14--the-pattern-press) | pattern printing | nested loops |
| L2-15 | [Stock Take](level-2.md#l2-15--stock-take) | inventory | counted input loops |
| L2-16 | [Guess Desk](level-2.md#l2-16--the-guess-desk) | algorithmic | loops + decisions |
| **Level 3 — [Intermediate](level-3.md)** | | | |
| L3-17 | [Marks Analyzer](level-3.md#l3-17--the-marks-analyzer) | student systems | vectors, statistics |
| L3-18 | [Payroll Desk](level-3.md#l3-18--the-payroll-desk) | small business | parallel vectors, functions |
| L3-19 | [Temperature Station](level-3.md#l3-19--the-temperature-station) | data processing | min/max/average over collections |
| L3-20 | [Word Frequency Counter](level-3.md#l3-20--the-word-frequency-counter) | text analysis | parallel arrays, searching |
| L3-21 | [Queue Simulator](level-3.md#l3-21--the-queue-simulator) | scheduling | array shifting, simulation |
| L3-22 | [Voting Booth](level-3.md#l3-22--the-voting-booth) | record management | frequency counting, validation |
| L3-23 | [Matrix Marks Grid](level-3.md#l3-23--the-matrix-marks-grid) | student systems | 2D arrays |
| L3-24 | [Inventory Reorder](level-3.md#l3-24--the-inventory-reorder) | inventory | vectors, searching, thresholds |
| **Level 4 — [Advanced](level-4.md)** | | | |
| L4-25 | [The Sorting Desk](level-4.md#l4-25--the-sorting-desk) | algorithmic | sorting algorithms, comparisons |
| L4-26 | [Dictionary Lookups](level-4.md#l4-26--the-dictionary-lookups) | text analysis | binary search, strings |
| L4-27 | [Recursion Workshop](level-4.md#l4-27--the-recursion-workshop) | algorithmic | recursion, call stack |
| L4-28 | [Text Toolkit Pro](level-4.md#l4-28--the-text-toolkit-pro) | text analysis | string algorithms, cctype |
| L4-29 | [The Persistent Gradebook](level-4.md#l4-29--the-persistent-gradebook) | student systems | file I/O, CSV |
| L4-30 | [The Library Ledger](level-4.md#l4-30--the-library-ledger) | library systems | file records, search |
| L4-31 | [The Safe Ledger](level-4.md#l4-31--the-safe-ledger) | record management | pointers, dynamic arrays |
| L4-32 | [The Student Registry](level-4.md#l4-32--the-student-registry) | student systems | structs, records |
| L4-33 | [The Fee Account Family](level-4.md#l4-33--the-fee-account-family) | banking simulation | classes, encapsulation |
| L4-34 | [The Course Catalogue](level-4.md#l4-34--the-course-catalogue) | student systems | vectors of objects, design |
| **Level 5 — [Integrated](level-5.md)** | | | |
| L5-35 | [The Expense Tracker Pro](level-5.md#l5-35--the-expense-tracker-pro) | small business | files + functions + validation |
| L5-36 | [The Bank Simulation](level-5.md#l5-36--the-bank-simulation) | banking simulation | classes + files + vectors |
| L5-37 | [The Library Management System](level-5.md#l5-37--the-library-management-system) | library systems | classes + files + search |
| L5-38 | [The Scheduling Desk](level-5.md#l5-38--the-scheduling-desk) | scheduling | sorting + structs + files |
| L5-39 | [The Survey Analyzer](level-5.md#l5-39--the-survey-analyzer) | data processing | files + statistics + validation |
| L5-40 | [The Inventory Control System](level-5.md#l5-40--the-inventory-control-system) | inventory | structs + files + reports |
| L5-41 | [The Contact Book](level-5.md#l5-41--the-contact-book) | record management | search + sort + files |
| L5-42 | [The Result Processing System](level-5.md#l5-42--the-result-processing-system) | student systems | everything — the capstone rehearsal |

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
