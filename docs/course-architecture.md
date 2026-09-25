# Programming Fundamentals Using C++ — Course Architecture

> Master planning document for a complete, public, student-facing self-study course.
> **Course:** Programming Fundamentals Using C++ · **Duration:** 16 units · 32 sessions · ~5–7 h/week
> **Audience:** Absolute beginners through early-intermediate programmers, studying without an instructor.
> **Instructor:** Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science, PUCIT, University of the Punjab, Lahore.
> **Status:** `Architecture / planning` — this document is the source of truth for what gets built next.
> Last revised: 2026-09-22

---

## Table of Contents

1. [Repository Assessment](#1-repository-assessment)
2. [Design Principles](#2-design-principles)
3. [Top-Level Repository Layout](#3-top-level-repository-layout)
4. [Unit Directory Template](#4-unit-directory-template)
5. [Component Definitions & File-Naming Conventions](#5-component-definitions--file-naming-conventions)
6. [The 16-Unit / 32-Session Progression](#6-the-16-unit--32-session-progression)
7. [Per-Unit Component Map](#7-per-unit-component-map)
8. [Website Design (GitHub Pages)](#8-website-design-github-pages)
9. [Student Navigation Design](#9-student-navigation-design)
10. [Assessment System](#10-assessment-system)
11. [Gap Analysis & Quality Gates](#11-gap-analysis--quality-gates)
12. [Build Order & Milestones](#12-build-order--milestones)
13. [Documentation & Code Standards](#13-documentation--code-standards)
14. [Open Questions for the Instructor](#14-open-questions-for-the-instructor)

---

<a name="1-repository-assessment"></a>
## 1. Repository Assessment

Inspected 2026-09-22 by cloning
`https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-.git`:

| Finding | Value |
| --- | --- |
| Branch | `main` (default) |
| Commits | **0** — the repository is empty |
| Files | none |
| Licence / `.gitignore` | none |
| GitHub Pages | not enabled |

**Consequence:** nothing needs to be retained, migrated, or deleted — there is
no risk of overwriting useful existing work. Everything below is greenfield
design. (The only local untracked item is the assistant workspace marker
`.freebuff/`, which is machine-local and must not be committed.)

### What an empty repo means for the build

- The initial history is free-form, so we **commit in stages** (milestone
  order, §12). Every pushed milestone must be self-consistent: the website is
  published only after the pages it links to actually exist.
- **Rule: no dead links in a public course.** Unit links are added to the
  README, syllabus, and site navigation only when the target unit exists.
- `.gitignore`, `LICENSE`, and the root `README.md` form the first commit;
  then the Unit 01 skeleton; then units in milestone order.

---

<a name="2-design-principles"></a>
## 2. Design Principles

1. **Zero-assumption start.** Unit 01 explains what a program *is*, how to run
   one, and what the terminal is, before any C++ syntax. Jargon is defined at
   first use and again in the glossary.
2. **Every concept → example → exercise.** No topic appears without at least
   one complete, compilable example and at least three practice items.
3. **Two sessions per unit, weekly rhythm.** 1 unit ≈ 1 week at 5–7 h/week;
   each session ≈ 90–120 min of study plus practice.
4. **Hands-on units.** Every unit ships a lab scenario with starter code,
   expected output, self-check questions, and a "Debug It" broken file.
5. **Self-study first.** Full worked solutions exist (in a separate
   `solution/` folder, linked as "attempt first!"), model answers for every
   quiz, and hint ladders for every debugging activity — a student can
   progress without an instructor.
6. **Modern, portable C++, introduced only when needed.** C++17 baseline
   (range-for, `auto`, structured bindings, `<random>`, `std::vector`,
   `constexpr`). No templates, inheritance-based design, or memory-model
   material before the foundation that makes it meaningful. No C++20+ features.
7. **One file per concept.** Examples are small, single-purpose files named by
   concept (`05_switch_statement.cpp`), so students compile one thing at a time.
8. **Compile-early habit.** From Unit 02, students compile on every change;
   every lab includes a Debug It section with a deliberately broken file and a
   3-hint ladder.
9. **Predictable structure.** Every unit has the identical file skeleton
   (§4), so navigation learned in Unit 01 works for all 16 units.
10. **No invented facts or links.** External references are limited to
    long-established free resources (cppreference.com, learncpp.com) plus
    official installer pages verified at content time. No book/standard
    citations unless verified.
11. **Student-facing README.** The root README covers the course itself; repo
    maintenance/deployment details live only in `docs/course-architecture.md`
    and `CONTRIBUTING.md`.

---

<a name="3-top-level-repository-layout"></a>
## 3. Top-Level Repository Layout

```text
Programming-Fundamentals-Using-C-/
├── README.md                        ← STUDENT HOME: overview, outcomes, unit map, quickstart
├── LICENSE                          ← MIT (pending instructor confirmation, §14)
├── .gitignore                       ← build artefacts (*.exe, *.o, *.out, *.gch), editor files
├── CONTRIBUTING.md                  ← how to report typos, broken links, suggest content
├── CHANGELOG.md                     ← dated course "edition" history
├── CITATION.cff                     ← machine-readable citation metadata (author, title, year)
│
└── docs/                            ← ENTIRE browsable course; becomes the GitHub Pages root
    ├── index.md                     ← landing page: welcome, quickstart, full unit map
    ├── course-architecture.md       ← this document (planning; linked from About/Instructor info)
    ├── implementation-plan.md       ← phased build plan with acceptance criteria
    │
    ├── getting-started/             ← Week-0 orientation pack (before Unit 01)
    │   ├── index.md                 ← setup overview + choose-your-study-plan (16-week / self-paced)
    │   ├── study-guide.md           ← the study method: read → run → modify → solve → debug → revisit
    │   └── compiler-setup/
    │       ├── index.md             ← hub: choose your operating system
    │       ├── windows.md           ← MSYS2/MinGW-w64 g++ + VS Code
    │       ├── linux.md             ← g++ via apt/dnf/pacman + VS Code
    │       ├── macos.md             ← Apple Clang via Xcode CLT + VS Code
    │       └── online-compilers.md  ← no-install fallback
    │
    ├── syllabus.md                  ← 16 units, 32 sessions, week-by-week (student view)
    ├── how-to-study.md              ← explicit method + weekly planner table
    ├── assessment.md                ← how quizzes/labs/projects work in self-study mode
    ├── grading.md                   ← rubrics: labs, Project 1, Project 2, Capstone
    ├── glossary.md                  ← every term, defined simply, with unit back-links
    ├── faq.md                       ← troubleshooting + common questions
    │
    ├── units/
    │   ├── unit-01-introduction-to-programming-and-cpp/
    │   │   ├── index.md             ← unit home: objectives, session map, all component links
    │   │   ├── sessions/
    │   │   │   ├── session-1.1.md
    │   │   │   └── session-1.2.md
    │   │   ├── examples/            ← 2–8 compilable .cpp files, one concept each
    │   │   ├── exercises.md         ← 8–12 practice items
    │   │   ├── labs/
    │   │   │   ├── lab-01.md        ← scenario, requirements, expected output, self-check
    │   │   │   ├── starter/         ← compileable starter + one deliberately broken file
    │   │   │   └── solution/        ← complete worked solution ("attempt first!")
    │   │   ├── quiz.md              ← 10 questions
    │   │   ├── quiz-answers.md      ← model answers with explanations
    │   │   ├── debug-activities.md  ← broken-program catalogue + hint ladders
    │   │   ├── challenge-problems.md ← 3–5 open-ended, difficulty-rated ★/★★/★★★
    │   │   └── revision.md          ← 1–2 page summary + mistakes checklist + flashcard table
    │   └── unit-02-…unit-16/        ← identical skeleton; unit-16 adds capstone material
    │
    ├── projects/
    │   ├── README.md                ← project hub: purpose, levels, links to all three
    │   ├── project-1-electricity-bill-calculator/
    │   │   ├── brief.md             ← scenario, requirements, deliverables
    │   │   ├── starter/
    │   │   └── solution/
    │   ├── project-2-student-records-manager/
    │   │   ├── brief.md · starter/ · solution/
    │   └── project-3-capstone-contact-management/
    │       ├── brief.md · starter/ · solution/
    │
    ├── toolchain/
    │   ├── sanity-check.cpp         ← the "does my setup work?" program
    │   ├── vs-code-tips.md          ← build task, launch config, useful settings
    │   ├── compiler-errors.md       ← common g++/MSVC errors → causes → fixes
    │   ├── gdb-walkthrough.md       ← optional, for advanced students
    │   └── online-compilers.md      ← when a local compiler is impossible
    │
    └── site-assets/                 ← shared images/diagrams (kept out of unit folders)
```

---

<a name="4-unit-directory-template"></a>
## 4. Unit Directory Template

Every unit (01–16) uses exactly this skeleton, so students always know where
to find things:

```text
docs/units/unit-NN-<slug>/
├── index.md                ← 10-section unit home (see §9.2)
├── sessions/
│   ├── session-N.1.md
│   └── session-N.2.md
├── examples/               ← 2–8 standalone .cpp files, one concept per file
├── exercises.md            ← 8–12 items: concept, predict-the-output, short coding
├── labs/
│   ├── lab-NN.md           ← brief + requirements + expected output + self-check
│   ├── starter/            ← compilable starter + one broken "Debug It" file
│   └── solution/           ← complete solution, linked with "attempt first!"
├── quiz.md                 ← 10 questions: MCQ, T/F, predict-output, find-the-bug
├── quiz-answers.md         ← model answers with explanations
├── debug-activities.md     ← 2–4 broken programs + 3-hint ladders
├── challenge-problems.md   ← 3–5 open-ended problems rated ★ / ★★ / ★★★
└── revision.md             ← summary + common-mistakes checklist + flashcard table
```

Units **05, 10, 16** additionally contain a project section linking to
`docs/projects/`; Unit 16 also contains the final-exam pack.

---

<a name="5-component-definitions--file-naming-conventions"></a>
## 5. Component Definitions & File-Naming Conventions

| Component | Definition | Volume target |
| --- | --- | --- |
| **Session** | The core reading for one study sitting: explanation first, terminology second, runnable code inline | 1,250–1,750 words; 2–5 examples |
| **Example** | Standalone compilable `.cpp`, one concept per file, header comment with unit/topic/compile line | 2–8 per unit |
| **Exercises** | Practice items in three types: (a) concept/vocabulary, (b) predict-the-output, (c) short coding | 8–12 per unit |
| **Lab** | One realistic scenario, 45–90 min: brief, requirements, expected output, self-check questions, Debug It file | 1 per unit (01–15) |
| **Quiz** | 10 questions: MCQ, true/false, predict-output, find-the-bug | 1 per unit (16th = final) |
| **Debug activities** | Deliberately broken programs with a 3-hint ladder, then the fix | 2–4 per unit |
| **Challenges** | Open-ended problems rated ★/★★/★★★ for stretch practice | 3–5 per unit |
| **Revision** | 1–2 page summary, common-mistakes checklist, flashcard table (term ↔ definition) | 1 per unit |
| **Project** | Multi-session graded work with brief, starter, solution, rubric | Units 05, 10, 16 |

**File-naming conventions**

- Unit directories: `unit-NN-<kebab-slug>` (zero-padded, e.g. `unit-01-…`).
- Example files: `NN_concept_name.cpp` matching teaching order.
- Sessions: `session-N.M.md` (e.g. `session-5.2.md`).
- Labs: `lab-NN.md` matching the unit number.
- All links relative; no absolute paths (works on GitHub and Pages alike).

---

<a name="6-the-16-unit--32-session-progression"></a>
## 6. The 16-Unit / 32-Session Progression

**Rhythm:** 2 sessions per unit; 1 unit per week; each session 90–120 min.
**"Unit 00"** below is the pre-course orientation pack delivered via
`docs/getting-started/` — it is not part of the 16-unit syllabus body.

### Unit 00 — Orientation (Week 0, `docs/getting-started/`)

Compiler setup per OS, `sanity-check.cpp` compiling cleanly, the study method,
study planner (16-week table + self-paced guidance), FAQ. **Exit test for the
student:** `sanity-check.cpp` compiles and runs on their machine.

### Unit 01 — Introduction to Programming & C++

- **S1.1** What a program, compiler, and language are · why C++ · the
  edit–compile–run cycle · writing, compiling, running "Hello, world".
- **S1.2** Program anatomy (comments, `main`, statements, braces) · `std::cout`
  with `<<`, `\n` vs `endl` · first compiler errors and how to read them.
- **Objectives:** describe the edit–compile–run cycle; create, compile, and run
  a program; identify the parts of a minimal program; print multi-line output.
- **Examples:** `01_hello.cpp`, `02_anatomy.cpp`, `03_output_basics.cpp`.
- **Exercises (10):** predict-the-output, fix-the-typo, print-your-timetable,
  ASCII-art box, student record card.
- **Lab 01 — First Program Lab:** a 3-line bio card + Debug It file with 4
  seeded typos.
- **Challenges:** ASCII-art scene; countdown program.
- **Quiz focus:** compile vs run, `main`, cout chaining, why errors cite lines.

### Unit 02 — Variables, Data Types, and Arithmetic

- **S2.1** Variables and initialization · `int`, `double`, `char`, `bool` ·
  identifiers and naming · `const` constants.
- **S2.2** Arithmetic operators, integer vs floating division, precedence,
  compound assignment, increment/decrement.
- **Objectives:** declare/initialize each type; choose the right type; evaluate
  arithmetic expressions; use `const`; predict integer vs floating division.
- **Examples:** `variables_intro.cpp`, `types_demo.cpp`, `arithmetic.cpp`,
  `division_types.cpp`, `compound_assignment.cpp`.
- **Exercises (12):** swap with/without temp, temperature conversion,
  seconds→h:m:s, digit extraction with `/` and `%`, mixed-division predictions.
- **Lab 02 — Receipt Calculator:** subtotal, const tax rate, total; Debug It:
  uninitialized variable.
- **Challenges:** digit-sum of a 3-digit number; last-digit checker.
- **Quiz focus:** `%` behaviour, implicit conversions, precedence.

### Unit 03 — Input, Output, and Simple Programs

- **S3.1** `std::cin` for `int`/`double`/`char`/`string` · the input buffer and
  the classic "skipped input" pitfall.
- **S3.2** `std::getline`, mixing `>>` and `getline`, output formatting
  (`fixed`, `setprecision`, field width from `<iomanip>`).
- **Objectives:** read all basic types; explain why mixing `>>` and `getline`
  fails without care; write a full input→process→output program; format to
  2 decimal places.
- **Examples:** `cin_basics.cpp`, `cin_pitfalls.cpp`, `getline_demo.cpp`,
  `mixing_cin_getline.cpp`, `formatting.cpp`.
- **Exercises (12):** dialog programs, unit conversions, gross/net pay,
  predict-the-output of buffer states.
- **Lab 03 — Interactive Grade Reporter:** name + three marks → formatted
  report; Debug It: skipped-input bug.
- **Challenges:** mad-libs story program; interactive receipt.

### Unit 04 — Selection: `if`, `if/else`, Nested & `switch`

- **S4.1** Boolean expressions, comparison and logical operators,
  short-circuit evaluation · `if`/`else`/`else if` · the `=` vs `==` bug.
- **S4.2** Nested `if` vs else-if ladders · `switch` with `break`/`default` ·
  menu programs · conditional operator (read/recognize only).
- **Objectives:** write boolean expressions; choose between ladder, nesting,
  and `switch`; avoid dangling-else and `=`/`==` traps; build a text menu.
- **Examples:** `if_basics.cpp`, `else_if_ladder.cpp`, `nested_if.cpp`,
  `switch_menu.cpp`, `conditional_operator.cpp`.
- **Exercises (12):** grade classifier, leap year, triangle type, quadrant
  finder, mini-calculator menu, ladder-order predictions.
- **Lab 04 — Decision Lab:** BMI calculator + grade classifier; Debug It:
  `if (x = 5)` and dangling-else files.
- **Challenges:** leap year with nesting only; validated switch menu.

### Unit 05 — Loops I: `while`, `do-while`, Loop Design + **Project 1**

- **S5.1** `while` loops · loop anatomy (init/condition/update) · off-by-one
  and infinite loops · sentinel-controlled loops · trace tables.
- **S5.2** `do-while` for menus · menus with `switch` + `do-while` ·
  input-validation loops.
- **Objectives:** trace loops by hand; write count- and sentinel-controlled
  `while` loops; validate input with `do-while`; combine menus with `switch`.
- **Examples:** `while_basics.cpp`, `trace_table_demo.cpp`, `sentinel.cpp`,
  `do_while_menu.cpp`, `input_validation.cpp`.
- **Exercises (12):** sum 1..N, digit sum, count digits, reverse a number
  arithmetically, trace tables.
- **Lab 05 — Sentinel-Controlled Marks Processor:** read marks until −1;
  report count/sum/avg/max/min; Debug It: infinite loop + off-by-one.
- **Challenges:** number-guessing game; Collatz step counter.
- **Project 1 — Smart Electricity Bill Calculator:** tariff slabs, usage loop,
  validated input, formatted bill. Rubric: correctness 40 · structure/naming 20
  · validation 15 · output 15 · report 10.

### Unit 06 — Loops II: `for`, Nested Loops, `break`/`continue`

- **S6.1** `for` anatomy · counting up/down/step · for vs while ·
  `break`/`continue`.
- **S6.2** Nested loops for tables and shapes (rectangles, triangles,
  pyramids) · tracing nested iteration counts.
- **Objectives:** choose for vs while; write nested loops; trace iteration
  counts; generate shape/table patterns; use `break`/`continue` sensibly.
- **Examples:** `for_basics.cpp`, `multiplication_table.cpp`, `shapes.cpp`,
  `break_continue_demo.cpp`, `nested_trace.cpp`.
- **Exercises (12):** conversion table, 4-shape printing set, digit-frequency
  count, nested-loop predictions.
- **Lab 06 — Pattern & Table Studio:** parameterized shape printer; Debug It:
  swapped loop bounds.
- **Challenges:** prime check by trial division; Armstrong numbers; hollow
  square; Floyd's triangle.

### Unit 07 — Functions I: Definition, Parameters, Return Values

- **S7.1** Why functions (decomposition, reuse, testing) · defining/calling ·
  parameters vs arguments · `void` functions · return values.
- **S7.2** Multiple parameters · local scope · prototypes · `<cmath>`
  functions (`sqrt`, `pow`).
- **Objectives:** define and call functions; distinguish parameters vs
  arguments; explain local scope; order code freely with prototypes.
- **Examples:** `functions_basics.cpp`, `parameters_vs_arguments.cpp`,
  `void_functions.cpp`, `return_values.cpp`, `prototypes.cpp`, `cmath_demo.cpp`.
- **Exercises (12):** cube, max of 3, is-even, C→F converter function,
  distance formula, scope predictions.
- **Lab 07 — Function Toolbox:** 6 utility functions + menu driver; Debug It:
  missing return path, use-before-declaration.
- **Challenges:** integer power; hypotenuse; `isPrime` as a function (reused
  in Unit 08+).

### Unit 08 — Functions II: Defaults, Overloading, References & Design

- **S8.1** Default arguments · overloading · reference parameters for
  out-values · pass-by-value vs pass-by-reference semantics.
- **S8.2** Top-down design with stubs and drivers · black-box thinking ·
  simple function testing.
- **Objectives:** use defaults/overloads judiciously; use references for
  multiple outputs; apply stubs/drivers; write basic test cases.
- **Examples:** `default_args.cpp`, `overloading.cpp`, `reference_params.cpp`,
  `swap_with_references.cpp`, `stubs_and_drivers.cpp`.
- **Exercises (12):** convert a monolithic program into functions; write a
  driver for a given stub; pass-by-ref min/max/avg.
- **Lab 08 — Refactor Lab:** restructure the Lab 05 marks processor into
  functions, preserving behaviour; Debug It: reference-parameter bug.
- **Challenges:** stats function set (min/max/avg by reference); unit
  conversion family with overloads.

### Unit 09 — Arrays and Vectors

- **S9.1** Why collections · C-style arrays: declaration, indexing, bounds
  discipline, iteration · passing arrays (with size) to functions.
- **S9.2** `std::vector`: `push_back`, `size()`, indexing, range-for · vector
  parameters (const reference) · `.at()` vs `[]` · array vs vector choice.
- **Objectives:** declare/index/iterate arrays and vectors; pass collections
  to functions; explain bounds behaviour; use range-for.
- **Examples:** `array_basics.cpp`, `array_functions.cpp`, `vector_basics.cpp`,
  `vector_functions.cpp`, `range_for_demo.cpp`, `at_vs_index.cpp`.
- **Exercises (12):** fill/print/sum/avg/max/min, reverse in place, search,
  frequency array, vector building loops.
- **Lab 09 — Marks Analyzer:** read N marks into a vector, compute stats,
  count above-average; Debug It: off-by-one + `.size()-1` misuse.
- **Challenges:** grade histogram; remove duplicates; merge two vectors.

### Unit 10 — Searching & Sorting + **Project 2**

- **S10.1** Linear search · counting/matching patterns · binary search
  (loop form) and its sorted-data precondition.
- **S10.2** Selection sort · bubble sort · swap via references · hand-tracing
  sorts. Project 2 brief released.
- **Objectives:** implement linear/binary search and selection/bubble sort;
  trace sorts by hand; reason about comparison counts (intuition, no Big-O).
- **Examples:** `linear_search.cpp`, `binary_search.cpp`,
  `selection_sort.cpp`, `bubble_sort.cpp`, `search_sort_menu.cpp`.
- **Exercises (12):** first/last/all-occurrence search, comparison counting,
  sort trace tables, second-largest.
- **Lab 10 — Marks Analyzer Plus:** extend Lab 09 with a search/sort menu;
  Debug It: binary-search boundary bug.
- **Challenges:** insertion sort; median via sorted copy (original untouched).
- **Project 2 — Student Records Manager:** menu program over parallel
  vectors (name + marks): add/find/list/sort/report. Rubric: functionality 45
  · design 20 · validation 15 · output 10 · report 10.

### Unit 11 — Strings and Text Processing

- **S11.1** `std::string` operations: `length`, indexing, `substr`, `find`,
  `insert`, `erase`, concatenation, comparison · range-for over strings.
- **S11.2** `<cctype>` classification and conversion · char arithmetic ·
  char-by-char processing · why `std::string` over C-strings (what C-strings
  are, briefly).
- **Objectives:** manipulate strings with the standard library; classify and
  transform characters; process text char-by-char; explain `npos` and bounds.
- **Examples:** `string_basics.cpp`, `string_methods.cpp`, `char_processing.cpp`,
  `cctype_demo.cpp`, `palindrome.cpp`.
- **Exercises (12):** count vowels/digits, capitalize words, reverse,
  palindrome, name formatting, `find`/`substr` predictions.
- **Lab 11 — Text Toolkit:** menu program with 5 string utilities; Debug It:
  `substr` off-by-one, `.at()` out-of-range.
- **Challenges:** word counter; initials extractor; Caesar cipher.

### Unit 12 — File I/O with `<fstream>`

- **S12.1** `ifstream`/`ofstream` basics · the open-check pattern
  (`if (!file)`) · reading to EOF · words vs lines · append mode.
- **S12.2** CSV-style records: parse lines with `getline` +
  `stringstream` · the read-all→process→rewrite update pattern.
- **Objectives:** open/read/write/append text files; detect open failures;
  parse record lines; explain the update pattern.
- **Examples:** `ofstream_basics.cpp`, `ifstream_basics.cpp`, `read_to_eof.cpp`,
  `words_vs_lines.cpp`, `csv_parse.cpp`, `append_demo.cpp`.
- **Exercises (12):** write/read numbers, count lines/words, copy a file,
  filter marks, parse a student CSV, missing-file predictions.
- **Lab 12 — Persistent Gradebook:** Lab 09/10 data now loaded from and saved
  to CSV; Debug It: missing open-check.
- **Challenges:** log-file analyzer; CSV merger; find-and-replace in a file.

### Unit 13 — Pointers and Dynamic Memory (gentle, fundamentals-appropriate)

- **S13.1** What an address is · `&` and `*` · null pointers · pointers with
  arrays/vectors.
- **S13.2** Pointer parameters · `new`/`delete` pairing · when **not** to use
  raw `new`/`delete` (prefer `vector`/`string`).
- **Objectives:** explain addresses; use `&` and `*` correctly; trace pointer
  assignment; use pointer parameters; explain why containers are preferred.
- **Examples:** `address_of.cpp`, `dereference.cpp`, `null_pointer.cpp`,
  `pointer_params.cpp`, `new_delete_demo.cpp`.
- **Exercises (12):** address printing, swap via pointers, max via pointer
  out-param, pointer tracing predictions.
- **Lab 13 — Pointer Lab:** trace + fix pointer exercises; Debug It: null
  dereference, `new` without `delete`.
- **Challenges:** growable dynamic marks array; reverse traversal with a
  pointer.

### Unit 14 — Introduction to OOP: Classes (data + behaviour)

- **S14.1** From parallel arrays to objects · class definition · private data
  + public interface · member functions · constructors.
- **S14.2** Getters/setters with validation · interface vs implementation
  within one file (multi-file OOP deferred) · `struct` vs `class`.
- **Objectives:** define a class with private data and public member
  functions; write default + parameterized constructors; validate in setters;
  explain encapsulation in plain language.
- **Examples:** `class_basics.cpp`, `constructor_demo.cpp`,
  `getters_setters.cpp`, `struct_vs_class.cpp`, `encapsulation_demo.cpp`.
- **Exercises (12):** Rectangle (area/perimeter), Student with validated
  marks, BankAccount with guards, constructor-order predictions.
- **Lab 14 — Student Class Library:** build `Student` + test driver; Debug
  It: initialization order, setter validation bug.
- **Challenges:** Fraction class; Date class with validity checks.

### Unit 15 — Applied OOP: Vectors of Objects, Composition & Preview

- **S15.1** Vectors of objects · passing objects (const reference) ·
  composition (has-a) · `const` member functions.
- **S15.2** `operator<<` for output (friend-function form) · inheritance and
  polymorphism **preview** (is-a, `virtual` — minimal example, explicitly
  marked as a preview of further study).
- **Objectives:** manage collections of objects; use composition; write
  `operator<<`; recognize inheritance/polymorphism at concept level.
- **Examples:** `vector_of_objects.cpp`, `composition_demo.cpp`,
  `const_member_functions.cpp`, `operator_output.cpp`,
  `inheritance_preview.cpp`.
- **Exercises (12):** roster class over `vector<Student>`; Book/Member
  composition; const-correctness predictions.
- **Lab 15 — Roster & Report Lab:** `vector<Student>` manager with report
  functions; Debug It: missing `const`, `operator<<` signature.
- **Challenges:** Department-has-Teachers composition; `operator<<` for a
  custom class.

### Unit 16 — Capstone, Modern C++ Toolkit & Course Review + **Project 3**

- **S16.1** Modern C++ toolkit with restraint: `auto`, range-for revisited,
  structured bindings, uniform initialization, `nullptr`, `constexpr`.
- **S16.2** Capstone build session + full-course revision pack and practice
  final.
- **Objectives:** read/write modern-idiomatic code; complete a multi-feature
  capstone integrating Units 01–15; self-assess against the rubric.
- **Project 3 — Capstone: Contact Management System** (or
  instructor-approved equivalent): menu-driven console app; `Contact` class;
  `vector` storage; CSV persistence; search (U10), sort (U10), validation
  (U03), formatted reports (U03/U15). Stretch goals: partial-name search,
  birthday reminders, CSV export, statistics. Rubric: functionality 40 ·
  design 25 · robustness 20 · report 10 · polish 5.
- **Review:** all-unit one-pagers, 20-question practice final with answers,
  skills checklist.

### 6.1 Content volume targets (per unit)

| Component | Target |
| --- | --- |
| Sessions ×2 | 2,500–3,500 words total, 4–10 runnable examples inline |
| Exercises | 8–12 items in the 3 standard types |
| Quiz | 10 questions + full model answers |
| Lab | 1 scenario, 45–90 min, starter + expected output + self-check + Debug It |
| Debug activities | 2–4 broken programs with 3-hint ladders |
| Challenges | 3–5 problems rated ★/★★/★★★ |
| Revision | 1–2 page summary + mistakes checklist + flashcard table |
| Examples directory | 2–8 standalone compilable `.cpp` files |

---

<a name="7-per-unit-component-map"></a>
## 7. Per-Unit Component Map

| # | Unit (slug) | Lab | Challenge focus | Project |
| --- | --- | --- | --- | --- |
| 01 | introduction-to-programming-and-cpp | First Program Lab | ASCII art, countdown | — |
| 02 | variables-data-types-and-arithmetic | Receipt Calculator | digit-sum, last-digit | — |
| 03 | input-output-and-simple-programs | Interactive Grade Reporter | mad-libs, receipt | — |
| 04 | decision-making-if-else-switch | Decision Lab (BMI + grades) | leap year, validated menu | — |
| 05 | loops-i-while-do-while | Sentinel Marks Processor | guessing game, Collatz | **Project 1** |
| 06 | loops-ii-for-nested-loops | Pattern & Table Studio | primes, Armstrong, Floyd | — |
| 07 | functions-i-basics | Function Toolbox | integer power, isPrime | — |
| 08 | functions-ii-design-and-references | Refactor Lab 05 | stats set, overload family | — |
| 09 | arrays-and-vectors | Marks Analyzer | histogram, dedupe, merge | — (P2 rehearsal) |
| 10 | searching-and-sorting | Marks Analyzer Plus | insertion sort, median | **Project 2** |
| 11 | strings-and-text-processing | Text Toolkit | Caesar cipher, word count | — |
| 12 | file-io | Persistent Gradebook | log analyzer, CSV merge | — |
| 13 | pointers-and-dynamic-memory | Pointer Lab | dynamic array, reverse walk | — |
| 14 | introduction-to-oop-classes | Student Class Library | Fraction, Date | — |
| 15 | applied-oop-collections | Roster & Report Lab | composition, operator<< | — |
| 16 | capstone-modern-cpp-review | — (capstone replaces lab) | capstone stretch goals | **Project 3 (Capstone)** |

### Session-topic table

| Unit | Session 1 | Session 2 |
| --- | --- | --- |
| 01 | What is a program/compiler; edit–compile–run; Hello world | Program anatomy; cout; reading first errors |
| 02 | Variables, types, `const` | Arithmetic, precedence, compound assignment |
| 03 | `cin`, input pitfalls | `getline`, mixing `>>`, formatting |
| 04 | Booleans, if/else-if/else, short-circuit | Nested if, switch, menus, `?:` (read-only) |
| 05 | while, trace tables, sentinels | do-while, menus, validation → **P1** |
| 06 | for, break/continue | Nested loops, patterns |
| 07 | Functions, params/return/void | Scope, prototypes, `<cmath>` |
| 08 | Default args, overloading, references | Top-down design, stubs, drivers, testing |
| 09 | C arrays + bounds | `vector`, range-for, passing collections |
| 10 | Linear + binary search | Selection/bubble sort → **P2** brief |
| 11 | `std::string` operations | cctype, char processing, C-strings |
| 12 | ifstream/ofstream, open-check, EOF | CSV parsing, read-all→rewrite |
| 13 | `&` and `*`, null pointers | Pointer params, new/delete (and when not to) |
| 14 | Parallel arrays → classes; constructors | Validation in setters; struct vs class |
| 15 | Vectors of objects, composition, const members | `operator<<`; inheritance/polymorphism preview |
| 16 | Modern C++ toolkit | Capstone build + review + practice final |

---

<a name="8-website-design-github-pages"></a>
## 8. Website Design (GitHub Pages)

### 8.1 Hosting choice

**GitHub Pages from `main /docs` folder** (Settings → Pages → Deploy from a
branch → `main` → `/docs`). Chosen over GitHub Actions/Jekyll toolchains
because the course is plain Markdown + static files: no build step, no
maintenance, and — critically — **no CI/CD content anywhere near the student
README**. The layout is plain-Markdown and engine-agnostic, so migrating to a
docs generator later remains possible without rewriting content.

**URL after publishing:** `https://nadeem-majeedch.github.io/Programming-Fundamentals-Using-C-/`
(verify after first push — GitHub may normalize the repository name; the site
URL always follows the repo name).

### 8.2 What goes in `docs/` vs repo root

| Location | Content | Rationale |
| --- | --- | --- |
| Repo root | README (student course map + quickstart), LICENSE, CONTRIBUTING, CHANGELOG, CITATION.cff, `.gitignore` | root files serve GitHub browsing + repo metadata |
| `docs/` | the entire browsable course | `/docs` becomes the Pages site root |
| `docs/site-assets/` | shared images/diagrams | central assets, no duplication |

The root README links into `docs/` paths so GitHub blob view and the
published site show the same content from the same files.

### 8.3 Page-level conventions

- **Front matter:** minimal — `title` (+ optional `description`), 2–4 lines.
- **Theme:** none required; a minimal `docs/_config.yml` is acceptable. No
  content-critical feature may depend on the theme.
- **Links:** relative only (`../../toolchain/...`), so GitHub blob view and
  Pages resolve identically.
- **Every page links down to its components and up to unit index → syllabus →
  site index.** No orphans, no dead ends.
- **Code:** session pages embed runnable code in fenced blocks **and** link
  the same code as files in the unit's `examples/` directory; the file is the
  source of truth.

### 8.4 Navigation aids

- Every unit index: `← Syllabus · Unit N/16 · ← Prev unit · Next unit →`.
- Every session page: `← Unit index · Session N.M · prev/next session`.
- Syllabus table links every built unit; unit indexes link back.
- README quickstart → getting-started hub; `docs/index.md` landing → syllabus
  → units. README map and syllabus are kept consistent (quality gate, §11).

### 8.5 Site map (published)

```text
/                      → docs/index.md (landing: welcome, quickstart, unit map)
/getting-started/      → setup hub → windows | linux | macos | online-compilers
/syllabus/             → docs/syllabus.md (linked only for built units)
/units/unit-01-…/      → unit index → sessions → components
/projects/             → hub → P1 | P2 | P3 briefs
/toolchain/            → sanity-check.cpp, error catalogue, VS Code tips, gdb
/glossary/ /faq/ /assessment/ /grading/ /how-to-study/  → single pages
```

---

<a name="9-student-navigation-design"></a>
## 9. Student Navigation Design

Goals: a first-time visitor reaches running code in ≤ 30 minutes; a returning
student reaches their next step in ≤ 2 clicks.

### 9.1 Three entry paths

| Who | Path |
| --- | --- |
| **New student** | README → docs/index.md → getting-started → Unit 01 S1.1 → exercises → lab |
| **Returning student** | README unit map → unit index → next unfinished component |
| **Refresher** | syllabus → unit revision sheet → flashcards → quiz |

### 9.2 Standard unit index layout (identical for all 16 units)

1. **Objectives** — "By the end of this unit you can: …" (measurable verbs)
2. **Session map** — S N.1 / N.2 with one-line summaries and links
3. **Examples** — link to `examples/` with file list + one-line purpose each
4. **Exercises** — link, count, suggested attempt order
5. **Quiz** — link (+ answers linked with "attempt first!")
6. **Lab** — brief → starter → solution ("attempt first!")
7. **Debug activities** — link, with the known-bugs warning
8. **Challenges** — difficulty-rated list
9. **Revision** — summary + mistakes checklist + flashcards
10. **What's next** — one line on what the next unit assumes from this one

### 9.3 Discovery aids

- `docs/index.md`: "start here" box + full unit map + progress table students
  can copy into their own notes.
- Glossary and FAQ grow with the units and are cross-linked from sessions.
- Every quiz answer explains *why*, not just *what*, so self-marking teaches.

---

<a name="10-assessment-system"></a>
## 10. Assessment System

This is a self-study course: nothing is graded by the repository. "Assessment"
means self-checking, and the rubrics exist so instructors who adopt the course
can grade if they wish.

| Component | Mode | Frequency |
| --- | --- | --- |
| Session exercises | self-practice | every session |
| Unit quizzes | self-check with model answers | 15 quizzes (Unit 16 = final) |
| Labs | self-checked against published solution + self-check questions | every unit 01–15 |
| Projects P1/P2/P3 | rubric-based self- or instructor-grading | Units 05, 10, 16 |
| Practice final | self-check, 20 questions + answers | Unit 16 |

**Self-scoring bands** (documented in `docs/assessment.md`): each quiz question
or lab self-check item counts 1 point; ≥ 90% = ready to advance; 70–89% =
revisit flagged sections; < 70% = redo exercises + revision sheet before
advancing.

**Rubrics** live in `docs/grading.md`: one lab rubric (reused for all labs) and
one rubric per project, each with criteria, point bands, and a "what excellent
looks like" column.

---

<a name="11-gap-analysis--quality-gates"></a>
## 11. Gap Analysis & Quality Gates

The philosophy (§2) vs the empty repo (§1) — everything is a gap. Grouped by
priority:

### P0 — required before the site goes live

1. `LICENSE`, `.gitignore`, root `README.md` (student-facing), CONTRIBUTING,
   CHANGELOG, CITATION.cff
2. `docs/index.md` landing page
3. `docs/getting-started/` complete (hub, 3 OS guides, online compilers,
   study guide, planner)
4. Unit 01 complete (all components, all examples compile)
5. `docs/syllabus.md`, `docs/assessment.md`, `docs/grading.md`,
   `docs/glossary.md` (starter), `docs/faq.md` (starter)
6. Link-verification pass, then enable Pages (`main` `/docs`)

### P1 — required for a serious self-study course

1. Units 02–05 complete (foundation arc, includes Project 1)
2. Project 1 brief/starter/solution/rubric in `docs/projects/`
3. Repo metadata completeness (CONTRIBUTING/CHANGELOG/CITATION if not done in P0)
4. Unit-map consistency checks each push

### P2 — required for completeness

1. Units 06–08 (functions arc)
2. Units 09–12 (collections/search-sort/strings/files arc, includes Project 2)
3. Units 13–15 (pointers/OOP arc)
4. Unit 16 + capstone + final exam pack
5. `docs/toolchain/` complete (error catalogue, VS Code tips, gdb walkthrough)

### Quality gates — applied at every milestone

1. Every `.cpp` compiles with `g++ -std=c++17 -Wall -Wextra`, zero warnings.
2. Starters and solutions both compile clean.
3. Every internal link resolves (scripted check; no dead links published).
4. Unit map consistency: README map = syllabus = unit indexes.
5. Solution-reveal policy: every quiz has an answers page; every lab has a
   solution linked "attempt first!".
6. Component directories present per unit: `examples/`, `labs/starter/`,
   `labs/solution/`.

---

<a name="12-build-order--milestones"></a>
## 12. Build Order & Milestones

Build-order authority. Milestones are cumulative; each is **publishable**
(all §11 quality gates pass). The instructor commits and pushes manually at
milestone boundaries.

| Milestone | Scope | Publishes |
| --- | --- | --- |
| **M0 — Bootstrap** | `.gitignore`, LICENSE, root README v1, CONTRIBUTING, CHANGELOG, CITATION.cff, `docs/index.md`, `docs/getting-started/**`, toolchain sanity-check, starter glossary/FAQ, syllabus skeleton (no unit links) | Not yet on Pages; README links only to existing pages |
| **M1 — Unit 01 + course shell** | Unit 01 complete; syllabus with Unit 01 linked; assessment + grading + glossary/FAQ grown | **Enable GitHub Pages** after link check |
| **M2 — Foundation arc** | Units 02–05 complete; Project 1 pack; maps updated | Live update |
| **M3 — Functions arc** | Units 06–08 complete | Live update |
| **M4 — Data arc** | Units 09–12 complete; Project 2 pack | Live update |
| **M5 — Objects arc** | Units 13–15 complete | Live update |
| **M6 — Capstone & finish** | Unit 16, Project 3 pack, final exam pack, full-course revision, CHANGELOG v1.0 | Live update; course complete |

**M0 exit criteria:** all files exist; every internal link resolves; the
setup guide has been followed once end-to-end on one machine (the "does this
actually work?" test); no unit links exist yet.

**M1 exit criteria:** Unit 01 passes all §11 quality gates; syllabus links
exactly Unit 01; Pages enabled; site reachable.

---

<a name="13-documentation--code-standards"></a>
## 13. Documentation & Code Standards

### 13.1 Markdown page template (all pages)

1. H1 title.
2. Blockquote context line: `> Unit N · Session N.M · ~90–120 min study time`.
3. Table of contents for pages longer than ~60 lines.
4. Short paragraphs; tables for enumerations; relative links only.
5. Sessions end with a **"Check yourself"** mini-list and a pointer to
   exercises.

### 13.2 Code standards (all `.cpp` files)

- One concept per file: `NN_concept_name.cpp`.
- Header comment: unit, session, topic, and the compile line
  `g++ -std=c++17 -Wall -Wextra file.cpp -o program`.
- C++17 baseline; no C++20+ features (portability).
- No feature before the unit that introduces it (principle 6).
- All examples compile clean with `-Wall -Wextra`.

### 13.3 External references policy

Supplementary links are limited to long-established free resources:
cppreference.com (reference) and learncpp.com (extra reading), plus official
installer pages verified at content time. No invented citations, no unverified
URLs.

---

<a name="14-open-questions-for-the-instructor"></a>
## 14. Open Questions for the Instructor

1. **Licence** — MIT recommended for a public educational repository;
   confirm (or specify another).
2. **Assessment weights** — the rubric point splits in §6 (Projects 1–3) and
   `docs/grading.md` are proposals; adjust if the course will be used for
   credit-bearing instruction.
3. **Capstone topic** — Contact Management System proposed; alternatives
   (library, hotel, inventory system) are fine.
4. **Instructor information placement** — currently planned for the README
   author line, `docs/index.md` about section, and `CITATION.cff` only,
   matching the requirement that instructor info appears in appropriate
   places, never dominating student material.

---

*End of architecture document. Course-sequence authority: §6/§7. Build-order
authority: §12. Where any summary conflicts with those sections, those
sections win.*
