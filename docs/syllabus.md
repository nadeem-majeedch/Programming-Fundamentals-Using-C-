---
title: "Syllabus"
description: "The complete 16-unit, 32-session plan for Programming Fundamentals Using C++."
---

# Syllabus

> The complete plan for the course · [Course home](index.md) · [How to study it](how-to-study.md)

## At a glance

- **16 units**, one per week at a steady pace — **32 sessions** total
  (2 per unit, each ≈ 90–120 minutes).
- Every unit: lessons → examples → exercises → lab → quiz → debug activities
  → challenges → revision sheet.
- **Cross-cutting modules:** the [Debugging & Testing module](debugging/index.md)
  trains the error taxonomy, diagnostics, the debugger, assertions, boundary
  and regression testing, and clean-code habits — recommended after Unit 10,
  useful from Unit 03 onward. The [Inheritance & Polymorphism module](inheritance/index.md)
  opens the door the OOP module left ajar (virtual dispatch, abstract
  classes, interfaces, composition-vs-inheritance) — after Unit 15, before
  data-structures courses. The [Operator Overloading & Templates module](generics/index.md)
  is **explicitly advanced, optional enrichment**: member/non-member
  operators, comparison and stream operators, function and class templates,
  and generic contracts — best alongside or after Unit 16's toolkit review.
  The [Standard Template Library module](stl/index.md) — also explicitly
  advanced enrichment — gives the containers, iterators, algorithms, and
  lambdas their natural home: the professional standard library built on
  the generic-contract idea from the templates module. The
  [Robustness module](robustness/index.md) completes the toolkit with the
  error machinery — try/catch/throw, custom exception families, exception
  safety, and the end of silent failures — refactoring earlier-lab
  programs to survive the real world.
- **Three projects** (Weeks 5, 10, 16) and a practice final in Week 16.
- **The [Programming Labs collection](labs/index.md)** — 42 substantial scenarios in five
  levels (beginner → integrated), every lab with the full fifteen-part contract
  (scenario, requirements, test cases, hints, solution, explanation, checklist).
  Each level names the units it requires — labs are the practice layer for every unit.
- **The [Projects collection](projects/index.md)** — 10 self-study builds from a calculator
  to an integrated OOP management system, each with milestones, test plan, edge cases,
  a self-assessment rubric, hints, a complete reference solution, and the design
  decisions behind it. Project 8 rehearses this syllabus's Project 3 domain;
  Project 10 is the capstone's full rehearsal.
- **The [Practice Bank](practice/index.md)** — 200 categorized problems in five difficulty
  tiers (beginner → basic → intermediate → advanced → challenge) across 17 topics, each
  with statement, difficulty, topics, I/O, constraints, sample tests, graded hints,
  reference solution, and explanation — plus a per-topic progress checklist. Problems
  match the units that teach them; work the bank alongside each stage.
- Study rhythm and weekly planner: [How to Study](how-to-study.md#weekly-planner).
- Session-by-session detail for every week — objectives, reading, exercises,
  labs, challenges, self-study time, and completion checklists: the
  **[16-Week Roadmap](roadmap/index.md)**.

---

## The six stages

| Stage | Units | Weeks | Focus |
| --- | --- | --- | --- |
| [A — Foundations](#stage-a--foundations) | 01–03 | 1–3 | programs, variables, types, input/output |
| [B — Control flow](#stage-b--control-flow) | 04–06 | 4–6 | decisions, loops, patterns (+ **Project 1**) |
| [C — Structure](#stage-c--structure) | 07–09 | 7–9 | functions, collections |
| [D — Algorithms & data](#stage-d--algorithms--data) | 10–12 | 10–12 | searching, sorting, strings, files (+ **Project 2**) |
| [E — Memory & objects](#stage-e--memory--objects) | 13–15 | 13–15 | pointers, classes, object-oriented design |
| [F — Capstone](#stage-f--capstone) | 16 | 16 | integration (+ **Project 3**, practice final) |

---

<a name="stage-a-foundations-units-1-3"></a>
## Stage A — Foundations

**Unit 01 · Introduction to Programming & C++** — what a program and compiler
are; the edit–compile–run cycle; Hello, world; program anatomy; `std::cout`;
reading your first compiler errors. Lab 01: *First Program Lab*.
→ [Unit index](units/unit-01-introduction-to-programming-and-cpp/index.md)

**Unit 02 · Variables, Data Types & Arithmetic** — declaring and
initializing variables; `int`, `double`, `char`, `bool`; naming;
`const`; arithmetic operators; integer vs floating division; precedence;
compound assignment. Lab 02: *Receipt Calculator*.
**Deep-dive:** the [C++ Foundations module](cpp-foundations/index.md)
condenses Units 01–02's language mechanics — structure, types, literals,
operators, conversions — with 60+ practice items, a variation lab, and a
self-check quiz.

**Unit 03 · Input, Output & Simple Programs** — `std::cin` for all basic
types; the input buffer and its pitfalls; `std::getline`; mixing `>>` and
`getline`; formatted output with `<iomanip>`. Lab 03: *Interactive Grade
Reporter*. **Deep-dive:** the [C++ Input/Output
module](cpp-io/index.md) covers all of Unit 03's machinery — cout and
formatting, cin and the buffer, getline and the mixing trap, validation
basics — with traces, predictions, 24 exercises, 10 debugging hunts, 10
challenges, and 5 lab scenarios.

<a name="stage-b-control-flow-units-4-6"></a>
## Stage B — Control flow

**Unit 04 · Selection: `if`, `else`, `switch`** — boolean expressions;
comparison and logical operators; short-circuit evaluation; `if`/`else if`/
`else`; nesting; `switch` and menus. Lab 04: *Decision Lab*.
→ The [Decisions deep-dive module](decisions/index.md) covers all of
Unit 04: four lessons ending in a requirements-to-decisions pipeline
(decision tables → flowcharts → pseudocode → C++ → dry runs),
25 exercises, 10 debugging hunts, 10 predictions, 10 challenges, and
8 realistic labs (grading, electricity billing, cinema pricing, ATM
validation, sports-day categories, admission eligibility, shipping
costs, restaurant billing).

**Unit 05 · Loops I: `while`, `do-while`** — loop anatomy; off-by-one and
infinite loops; trace tables; sentinel-controlled loops; input validation;
`do-while` menus. Lab 05: *Sentinel Marks Processor*.
**🏁 Project 1: Electricity Bill Calculator.**

**Unit 06 · Loops II: `for`, Nested Loops** — `for` anatomy; counting
up/down/step; `break`/`continue`; nested loops; shape and table patterns.
Lab 06: *Pattern & Table Studio*.

<a name="stage-c-structure-units-7-9"></a>
## Stage C — Structure

**Unit 07 · Functions I** — why functions; defining and calling;
parameters vs arguments; return values; `void`; local scope; prototypes;
`<cmath>`. Lab 07: *Function Toolbox*.

**Unit 08 · Functions II: References & Design** — default arguments;
overloading; reference parameters; pass-by-value vs pass-by-reference;
top-down design with stubs and drivers; testing your own functions.
Lab 08: *Refactor Lab* (restructure Lab 05's program into functions).

**Unit 09 · Arrays & Vectors** — C-style arrays and bounds; iteration;
passing arrays to functions; `std::vector`; `push_back`, `size()`,
range-for; `.at()` vs `[]`; choosing between them. Lab 09: *Marks Analyzer*.

<a name="stage-d-algorithms-and-data-units-10-12"></a>
## Stage D — Algorithms & data

**Unit 10 · Searching & Sorting** — linear search; binary search and its
sorted precondition; selection sort; bubble sort; tracing sorts by hand;
comparisons counting. Lab 10: *Marks Analyzer Plus*.
**🏁 Project 2: Student Records Manager.**

**Unit 11 · Strings & Text Processing** — `std::string` operations
(`length`, indexing, `substr`, `find`, …); range-for over strings;
`<cctype>`; char arithmetic; char-by-char processing; why `std::string`
beats C-strings. Lab 11: *Text Toolkit*.

**Unit 12 · File I/O** — `ifstream`/`ofstream`; the open-check pattern;
reading to EOF; words vs lines; append mode; CSV-style records with
`getline` + `stringstream`; the read-all→process→rewrite pattern.
Lab 12: *Persistent Gradebook*.

<a name="stage-e-memory-and-objects-units-13-15"></a>
## Stage E — Memory & objects

**Unit 13 · Pointers & Dynamic Memory** — addresses; `&` and `*`; null
pointers; pointer parameters; `new`/`delete` pairing — and why `vector` and
`string` are usually the better tools. Lab 13: *Pointer Lab*.

**Unit 14 · Structs, Records & the Bridge to Classes** — from parallel arrays
to records; `struct` definition and members; passing/returning/nesting;
`enum` and `enum class`; then the step up to classes — private data, public
interface, member functions, constructors, getters/setters with validation;
`struct` vs `class`. Labs 14: *record-keeping labs + first class labs
(BankAccount, Student)*.
→ The [Records module](records/index.md) teaches the records/enum bridge and
the [OOP module's](oop/index.md) first lessons complete the step to classes.

**Unit 15 · Applied OOP** — vectors of objects; passing objects by const
reference; composition (has-a); `const` member functions; `operator<<`;
inheritance and polymorphism *preview*. Lab 15: *class labs + the
Object-Oriented Mini Project*.

<a name="stage-f-capstone-unit-16"></a>
## Stage F — Capstone

**Unit 16 · Capstone, Modern C++ Toolkit & Review** — `auto`, structured
bindings, uniform initialization, `constexpr` used with restraint; capstone
build sessions; full-course revision pack; 20-question practice final.
**🏁 Project 3 (Capstone): Contact Management System.**
The [Modern C++ module](modern-cpp/index.md) is the toolkit's home: the
fundamentals every student should know (const correctness, references,
`nullptr`, `enum class`, range-`for`, lambdas, library-first) clearly
separated from the modern practices to begin adopting (RAII, `auto` with
restraint, `constexpr`, smart pointers, move semantics conceptually, the
retirement of raw `new`/`delete`) — sized for a fundamentals course, with
the Modernisation Lab as the capstone's retrofit pass. The
[Modular Programming module](modular/index.md) completes the capstone
preparation: headers and sources, declarations vs definitions, include
guards, namespaces, separate compilation and linking, project layout,
modular design, and circular dependencies — with a complete multi-file
example project and the Modular Programming Lab.

---

## Unit map

| Week | Unit | Title | Sessions | Lab | Project | Status |
| --- | --- | --- | --- | --- | --- | --- |
| 0 | — | [Setup & orientation](getting-started/index.md) | — | sanity check | — | ✅ available |
| 1 | 01 | Introduction to Programming & C++ | [1.1](units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md) · [1.2](units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.2.md) | [Lab 01](units/unit-01-introduction-to-programming-and-cpp/labs/lab-01.md) | — | ✅ available |
| 2 | 02 | Variables, Data Types & Arithmetic | 2.1 · 2.2 | Receipt Calculator | — | ✅ [cpp-foundations module](cpp-foundations/index.md) — lessons 2–4, 60+ practice items, lab with variations, quiz |
| 3 | 03 | Input, Output & Simple Programs | 3.1 · 3.2 | Interactive Grade Reporter | — | ✅ [cpp-io module](cpp-io/index.md) — 3 lessons, traces, predictions, 24 exercises, 10 debugging hunts, 10 challenges, 5 labs |
| 4 | 04 | Selection: `if`, `else`, `switch` | 4.1 · 4.2 | Decision Lab | — | ✅ [decisions module](decisions/index.md) — 4 lessons, requirements-to-decisions pipeline, 25 exercises, 10 debugging hunts, 8 labs |
| 5 | 05 | Loops I: `while`, `do-while` | 5.1 · 5.2 | Sentinel Marks Processor | 🏁 P1 | ✅ [repetition module](repetition/index.md) — Lessons 1–2, Labs 1–2 |
| 6 | 06 | Loops II: `for`, Nested Loops | 6.1 · 6.2 | Pattern & Table Studio | — | ✅ [repetition module](repetition/index.md) — Lessons 3–4, Labs 3–10 + mini-project |
| 7 | 07 | Functions I | 7.1 · 7.2 | Function Toolbox | — | ✅ [functions module](functions/index.md) — Lessons 1–2, Labs 1–2, 5 |
| 8 | 08 | Functions II: References & Design | 8.1 · 8.2 | Refactor Lab | — | ✅ [functions module](functions/index.md) — Lessons 3–4, refactoring exercises, Labs 3–8 + mini-project |
| 9 | 09 | Arrays & Vectors | 9.1 · 9.2 | Marks Analyzer | — | ✅ [arrays module](arrays/index.md) — 4 lessons, 7 labs + Marks Analyzer mini-project |
| 10 | 10 | Searching & Sorting | 10.1 · 10.2 | Marks Analyzer Plus | 🏁 P2 | ✅ [algorithms module](algorithms/index.md) — 3 lessons (recursion: base/recursive cases, call stack, factorial/Fibonacci/digits, recursive search & arrays; searching: linear, binary, the sorted precondition, complexity intuition; sorting: bubble/selection/insertion, comparison table), 32 exercises, 15 trace drills, 10 debugging hunts, 15 challenges, the Algorithm Performance and Comparison Lab + **Project 2 brief** |
| 11 | 11 | Strings & Text Processing | 11.1 · 11.2 | Text Toolkit | — | ✅ [strings module](strings/index.md) — 4 lessons (two ways, indexing/comparison, find/modify/cctype, conversions/mistakes), 26 exercises, 10 debugging hunts, 10 predictions, 10 challenges, 7 labs + Text Toolkit mini-project |
| 12 | 12 | File I/O | 12.1 · 12.2 | Persistent Gradebook | — | ✅ [files module](files/index.md) — 3 lessons (streams, open-check-close; modes/append, reading strategies, CSV, record storage; file errors, EOF discipline, mistakes gallery), 18 exercises, 10 debugging hunts, 10 challenges, 6 file labs + File-Based Student Management System |
| 13 | 13 | Pointers & Dynamic Memory | 13.1 · 13.2 | Pointer Lab | — | ✅ [pointers module](pointers/index.md) — 3 lessons (memory & addresses; references & out-parameters; arrays, `new`/`delete`, the failure families, ownership), 20 guided exercises, 10 debugging hunts, 10 memory-tracing drills, 10 challenges, 4 safe labs + Quiz Runner mini-project |
| 14 | 14 | Structs, Records & the Bridge to Classes | 14.1 · 14.2 | Record-keeping labs + first class labs | — | ✅ [records module](records/index.md) — the records/enum bridge (3 lessons: struct basics; passing/returning/nesting; enums & design), 22 exercises, 10 debugging hunts, 10 predictions, 10 challenges, 6 record-keeping labs + Student Record Management System; the step to classes comes from the [OOP module's](oop/index.md) first lessons (BankAccount, Student labs) |
| 15 | 15 | Applied OOP | 15.1 · 15.2 | Class labs + Object-Oriented Mini Project | — | ✅ [OOP module](oop/index.md) — 3 lessons (objects/classes/encapsulation; constructors, destructors, `this`, lifetime; design, const members, composition, `operator<<`, vectors of objects, the inheritance preview), 26 exercises, 10 class-design drills, 10 debugging hunts, 10 challenges, 7 class labs (BankAccount → Library) + the Object-Oriented Mini Project (the records system refactored to classes) |
| 16 | 16 | Capstone + Modern C++ Toolkit | 16.1 · 16.2 | Capstone build | 🏁 P3 | ✅ [modern-cpp module](modern-cpp/index.md) + [modular module](modular/index.md) + [Project 3 rehearsal](projects/project-08-contacts.md) + [practice finals](self-assessment/final-exam-1.md) |

---

## Session-topic table

| Unit | Session 1 | Session 2 |
| --- | --- | --- |
| 01 | What is a program/compiler; edit–compile–run; Hello world | Program anatomy; `cout`; reading first errors |
| 02 | Variables, types, `const` | Arithmetic, precedence, compound assignment |
| 03 | `cin`, input pitfalls | `getline`, mixing `>>`, formatting |
| 04 | Booleans, `if`/`else-if`, short-circuit | Nested `if`, `switch`, menus |
| 05 | `while`, trace tables, sentinels | `do-while`, menus, validation |
| 06 | `for`, `break`/`continue` | Nested loops, patterns |
| 07 | Functions, parameters, return, `void` | Scope, prototypes, `<cmath>` |
| 08 | Default args, overloading, references | Top-down design, stubs, drivers, testing |
| 09 | C arrays + bounds | `vector`, range-for, passing collections |
| 10 | Linear + binary search | Selection/bubble sort |
| 11 | `std::string` operations | `<cctype>`, char processing, C-strings |
| 12 | `ifstream`/`ofstream`, open-check, EOF | CSV parsing, read-all→rewrite |
| 13 | `&` and `*`, null pointers | Pointer parameters, `new`/`delete` |
| 14 | Parallel arrays → records → classes; constructors | Validation in setters; `struct` vs `class` |
| 15 | Vectors of objects, composition, `const` members | `operator<<`; inheritance preview |
| 16 | Modern C++ toolkit | Capstone build + review + practice final |

---

## Assessment overview

| Component | Mode | Where |
| --- | --- | --- |
| Exercises | self-practice | every session |
| Lab | self-checked vs solution + rubric | every unit 01–15 |
| Quiz | 10 questions + full answer key | every unit (16th = final) |
| Projects 1–3 | rubric-based | Units 05 / 10 / 16 |
| Practice final | 20 questions + answers · plus the [self-assessment system](assessment.md): 16 weekly quizzes, 8 topic tests, 4 cumulative tests, 2 practice finals | Unit 16 (weeklies & cumulative tests scheduled throughout) |

Details: [Assessment](assessment.md) · Rubrics: [Grading](grading.md).

---

*[← Course home](index.md) · [How to Study](how-to-study.md) ·
[Getting Started](getting-started/index.md)*
