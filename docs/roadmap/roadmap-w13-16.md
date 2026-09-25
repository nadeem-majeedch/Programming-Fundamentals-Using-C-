---
title: "Roadmap — Weeks 13–16: Memory, OOP & the Capstone"
description: "Sessions 13.1–16.2: pointers & dynamic memory, structs/classes & records, applied OOP, and the capstone with practice finals — each with the full eleven-part session contract, plus the beyond-Week-16 enrichment path."
---

# Weeks 13–16 — Memory, OOP & the Capstone (Stages E/F)

> The final quarter: how memory really works, how objects organize programs,
> and the integration project that proves the whole journey.
> [← Weeks 9–12](roadmap-w09-12.md) · [Roadmap home](index.md)

---

## Week 13 — Pointers & dynamic memory

### Session 13.1 — Memory, addresses, and the pointer operators

| Part | Details |
| --- | --- |
| **Prerequisites** | Stage C/D — arrays and functions fluent |
| **Learning objectives** | explain memory as addressed boxes; use `&` and `*` correctly; declare/initialize pointers; use `nullptr`; dereference safely |
| **Concepts** | memory model, addresses, `&` (address-of), `*` (dereference), pointer declaration/initialization, `nullptr`, unsafe operations and their warnings |
| **Recommended reading** | [Pointers Lesson 1 — memory & addresses](../pointers/lesson-1-memory-addresses.md) |
| **Examples to study** | Lesson 1's diagrams — draw three memory diagrams yourself |
| **Exercises** | [pointers exercises](../pointers/exercises.md) (guided set, first half) · [Practice Bank A-01–A-03](../practice/advanced.md) |
| **Lab/practice** | [pointers labs](../pointers/labs.md) — first safe-practice lab |
| **Challenge** | [Practice Bank A-05](../practice/advanced.md) — the dynamic array sized at runtime |
| **Estimated self-study time** | 90 min (new mental model — take the time) |
| **Completion checklist** | ☐ 3 memory diagrams drawn and checked ☐ all dereferences guarded ☐ can predict `p`, `*p`, `&x` outputs on paper |

### Session 13.2 — References, functions, and dynamic memory

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 13.1 |
| **Learning objectives** | contrast references and pointers; write pointer parameters (the C-style out-param); allocate and release dynamic arrays; recognize leaks, dangling pointers, and invalid access |
| **Concepts** | references vs pointers, pointer parameters, `new[]`/`delete[]`, dynamic arrays, memory leaks, dangling pointers, ownership at an introductory level |
| **Recommended reading** | [Pointers Lesson 2 — references & functions](../pointers/lesson-2-references-functions.md) · [Lesson 3 — arrays & dynamic memory](../pointers/lesson-3-arrays-dynamic.md) |
| **Examples to study** | Lesson 3's failure families — reproduce the leak and the dangling return deliberately, then fix each |
| **Exercises** | [Practice Bank A-06–A-10](../practice/advanced.md) · [pointers tracing](../pointers/tracing.md) · [pointers debugging](../pointers/debugging.md) D1–D3 |
| **Lab/practice** | [pointers labs](../pointers/labs.md) — remaining safe-practice labs |
| **Challenge** | [Practice Bank C-27](../practice/challenge.md) — hand-cranked vector growth |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ leak + dangling reproduced *and* fixed ☐ every `new[]` paired on every path ☐ 3 debug hunts ☐ [W13 quiz](../self-assessment/weeklies-4.md) ≥ 90% |

---

## Week 14 — Structs, classes & records

### Session 14.1 — Structs: organizing related data

| Part | Details |
| --- | --- |
| **Prerequisites** | Weeks 9–12 — collections, strings, files fluent |
| **Learning objectives** | define and use structs; pass/return structs to functions; nest structs; move from parallel arrays to record arrays and say why |
| **Concepts** | struct definition/members, initialization, arrays of structs, nested structures, struct parameters and returns, parallel-arrays cohesion failure |
| **Recommended reading** | [Records Lesson 1 — structs](../records/lesson-1-structs.md) · [Lesson 2 — functions & nesting](../records/lesson-2-functions-nesting.md) |
| **Examples to study** | both lessons' record examples |
| **Exercises** | [Practice Bank I-29–I-33](../practice/intermediate.md) · [records exercises](../records/exercises.md) (first part) |
| **Lab/practice** | [records labs](../records/labs.md) — student + employee record labs |
| **Challenge** | [Practice Bank I-32](../practice/intermediate.md) — the parallel-arrays verdict written in code comments |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ one program *migrated* from parallel arrays to struct arrays ☐ 2 labs done ☐ cohesion argument stated in your own words |

### Session 14.2 — From structs to classes: encapsulation

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 14.1 |
| **Learning objectives** | define classes with private state and public methods; write constructors; enforce an invariant through the type; use member functions that read naturally |
| **Concepts** | `class` vs `struct` (the one default), private/public, methods, constructors and initializer lists, encapsulation with teeth, invariants |
| **Recommended reading** | [OOP Lesson 1 — objects & classes](../oop/lesson-1-objects-classes.md) · [Records Lesson 3 — enums & design](../records/lesson-3-enums-design.md) |
| **Examples to study** | Lesson 1's BankAccount evolution — the struct→class transformation is the lesson |
| **Exercises** | [Practice Bank A-33–A-35](../practice/advanced.md) · [oop exercises](../oop/exercises.md) (first part) |
| **Lab/practice** | [oop labs](../oop/labs.md) — BankAccount + Student |
| **Challenge** | [Practice Bank A-38](../practice/advanced.md) — the cannot-exist-invalid factory |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ one invariant enforced and *tested* (try to break it) ☐ 2 class labs ☐ [W14 quiz](../self-assessment/weeklies-4.md) ≥ 90% |

---

## Week 15 — Applied OOP

### Session 15.1 — Object lifetime, `this`, and const members

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 14 — classes fluent |
| **Learning objectives** | trace object construction/destruction across scopes; use `this` for chaining; write const member functions; compose objects (has-a); overload `operator<<` |
| **Concepts** | constructors/destructors, object lifetime, `this`, `const` member functions, composition, `operator<<`, vectors of objects |
| **Recommended reading** | [OOP Lesson 2 — constructors & lifetime](../oop/lesson-2-constructors-lifetime.md) · [Lesson 3 — design & composition](../oop/lesson-3-design-composition.md) |
| **Examples to study** | both lessons' lifetime traces and the composition example |
| **Exercises** | [Practice Bank A-36, A-37, C-04](../practice/advanced.md) · [oop exercises](../oop/exercises.md) (remaining) |
| **Lab/practice** | [oop labs](../oop/labs.md) — Book, Product, Employee labs |
| **Challenge** | [Practice Bank C-05](../practice/challenge.md) — the university object graph |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ lifetime trace (born/gone) predicted correctly on paper ☐ `operator<<` working for one class ☐ 3 labs done |

### Session 15.2 — The OO miniproject: classes in concert

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 15.1 |
| **Learning objectives** | design a small class family (2–3 classes); keep `main` thin; persist objects through files; complete the Object-Oriented Mini Project |
| **Concepts** | class design, thin main, object files (records persisted), integration of Weeks 12–15 |
| **Recommended reading** | [oop miniproject](../oop/miniproject.md) — the records system refactored to classes |
| **Examples to study** | the miniproject's design walkthrough |
| **Exercises** | [oop debugging](../oop/debugging.md) D1–D3 · [oop design](../oop/design.md) — one design problem |
| **Lab/practice** | [oop miniproject](../oop/miniproject.md) — all milestones |
| **Challenge** | [oop challenges](../oop/challenges.md) — one of your choice |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ miniproject complete with rubric self-score ☐ 3 debug hunts ☐ [W15 quiz](../self-assessment/weeklies-4.md) ≥ 90% |

---

## Week 16 — Capstone & the final lap

### Session 16.1 — Capstone build: Project 3

| Part | Details |
| --- | --- |
| **Prerequisites** | the whole course — everything is in scope |
| **Learning objectives** | integrate classes, collections, files, validation, and menus into one complete program; manage a multi-milestone build independently |
| **Concepts** | integration, domain classes with invariants, one ingestion path, persistence, thin main, the course's architecture habits |
| **Recommended reading** | [Project 3 brief](../syllabus.md) (Stage F: Contact Management System) · [Projects collection #8](../projects/project-08-contacts.md) and [#10](../projects/project-10-oop-system.md) as rehearsals · [Projects collection](../projects/index.md) shared rubric |
| **Examples to study** | the rehearsal projects' design-decision sections |
| **Exercises** | [Practice Bank C-19–C-24](../practice/challenge.md) (integrated set) — pick two as warm-ups |
| **Lab/practice** | **🏁 [Project 3 — the capstone](../projects/index.md)** — all milestones, test plan, edge cases, rubric |
| **Challenge** | capstone extensions from the project brief |
| **Estimated self-study time** | 150 min |
| **Completion checklist** | ☐ **Capstone: all milestones, full test plan, rubric self-scored** ☐ zero compiler warnings ☐ design-decisions paragraph written |

### Session 16.2 — The final lap: review and practice finals

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 16.1 — capstone built |
| **Learning objectives** | consolidate the whole course under exam conditions; convert mistakes into a study plan; close the journey honestly |
| **Concepts** — | the full course map; mixed revision; self-assessment under time |
| **Recommended reading** | your own post-exam worksheets · [the four cumulative tests](../self-assessment/cumulative-1.md) (skim misses) · [roadmap checklist](index.md#the-progress-checklist-mark-each-as-you-close-the-week) |
| **Examples to study** | your capstone — read your own code as a stranger and improve two names |
| **Exercises** | [Practice Bank C-25–C-40](../practice/challenge.md) — pick three cross-topic items |
| **Lab/practice** | **[Final Exam A](../self-assessment/final-exam-1.md)** — full 90 minutes, closed book, then the post-exam worksheet |
| **Challenge** | **[Final Exam B](../self-assessment/final-exam-2.md)** — on a later day, after A's worksheet |
| **Estimated self-study time** | 120 min (final A + worksheet) |
| **Completion checklist** | ☐ **Final A taken under exam conditions** ☐ worksheet written ☐ Final B scheduled ☐ **roadmap checklist complete — the course is yours** 🎓 |

---

<a name="beyond-week-16-the-enrichment-path"></a>

## Beyond Week 16 — the enrichment path

The course continues for readers who want more. Each module says "advanced"
inside itself and can be taken in any order *after* the capstone — or woven
in earlier by confident students, exactly as marked:

| Order | Module | One-line promise |
| --- | --- | --- |
| 1 | [Inheritance & polymorphism](../inheritance/index.md) | is-a hierarchies, virtual functions, when *not* to inherit |
| 2 | [Exceptions & robustness](../robustness/index.md) | try/catch/throw, custom exception types, the end of silent failures |
| 3 | [Modern C++ practices](../modern-cpp/index.md) | RAII, smart pointers, `auto`, `constexpr` — what to adopt and why |
| 4 | [The Standard Template Library](../stl/index.md) | containers, iterators, algorithms, lambdas — the professional toolbox |
| 5 | [Operator overloading & templates](../generics/index.md) | types that behave like built-ins; generic programming |
| 6 | [Modular programming](../modular/index.md) | headers, sources, separate compilation, multi-file projects |

Plus the standing collections: the [Programming Labs](../labs/index.md)
(42 scenarios), the [Practice Bank](../practice/index.md) (200 problems),
and the [Projects](../projects/index.md) you have not yet built.

---

**[← Weeks 9–12](roadmap-w09-12.md) · [Roadmap home](index.md) · [Course home](../index.md)**
