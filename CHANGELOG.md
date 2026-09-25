# Changelog

All notable changes to this course are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Student-experience audit (`reports/student-experience-audit.md`)** — the
  full course walked as a never-programmed student, all 25 evaluation points
  assessed, concept-before-use scanned across every C++ listing; 1 Critical,
  2 High, and 3 Medium findings fixed (see Fixed).
- **Course completion checklist (`docs/course-completion-checklist.md`)** —
  the one-page student-facing status of the whole course: structure, lessons,
  labs, exercises, projects, quizzes, code validation, links, GitHub Pages,
  accessibility, and self-study readiness; linked from the README's course
  contents and the website's Reference row.
- **Automatic website deployment (`.github/workflows/deploy.yml`, `Gemfile`)** —
  the student website builds and publishes automatically on every push to
  `main` that touches site sources, with manual runs supported (Actions →
  Run workflow). The Jekyll site is built from `docs/` with the same Gemfile
  locally and in CI, the homepage is verified before upload, and publication
  uses the official Pages actions (`checkout`, `configure-pages`,
  `upload-pages-artifact`, `deploy-pages`) with least-privilege permissions
  and the `github-pages` environment. One-time setup: Settings → Pages →
  Source → "GitHub Actions".
- **Website operations documentation (`docs/technical/github-pages.md`)** —
  maintainer-facing page (excluded from the student site): deployment
  mechanics, one-time Pages settings, the expected project URL and the
  baseurl/relative-links contract, local preview, troubleshooting, and
  common 404 causes.
- **GitHub Pages student site (`docs/_layouts`, `docs/_includes`, `docs/assets/css/course.css`, `docs/_data/course.yml`, `docs/_config.yml`, `docs/404.md`)** — the `/docs` folder now builds as a complete student learning website: a clean, accessible documentation layout (system fonts, light/dark via OS preference, no animations, skip-link, print styles, mobile-friendly), site header with student navigation (Roadmap, Syllabus, Practice, Labs, Projects, Quizzes, Glossary, About), breadcrumbs, **module-level previous/next navigation** computed from `_data/course.yml` (24 modules in canonical syllabus order), a styled 404 page with a self-healing `<base>` fix, and planning documents excluded from the published site.

### Changed

- **Main README rewritten as the final course entry point** — restructured
  to the canonical student sections (Start Here · Who This Is For ·
  Prerequisites · What You Will Learn · Learning Path · Roadmap · Course
  Modules · Labs · Practice Problems · Projects · Quizzes & Self-Assessment ·
  How to Study · Progress Checklist · Instructor · License), with every
  link validated and all deployment/maintenance content kept out of the
  student README.
- **`docs/_config.yml`** — plugin whitelist added (`jekyll-relative-links`
  plus Jekyll's three defaults), `docs/technical/` excluded from the
  published student site, and comments updated for the Actions-based
  deployment; `.gitignore` now covers Jekyll/CI build artefacts.

- **Course reading order corrected in site navigation and module links** — the
  syllabus order is Strings → Files (U12) → Pointers (U13) → Records (U14);
  `_data/course.yml` and the Files module's back-link were brought in line with it.

- **Instructor/About page reviewed and tightened (`docs/about.md`)** — the
  instructor section now contains only the provided facts (name, title,
  affiliation), the course purpose, the six educational principles,
  attribution/citation, and licence information. Removed inferred details
  (title-body interpretations, teaching-area claims, classroom framing).
  The page remains the single instructor reference; student lessons carry
  only the one-line attribution footer linking to it.

- **How to Learn Programming guide (`docs/learning-guide.md`)** — the
  student-facing learning-skills companion to How to Study: how to use the
  course, read code, type instead of copy, experiment, predict output,
  debug, use compiler errors, practice deliberately, approach difficult
  problems, when to use hints vs solutions, maintain a programming notebook
  (bug diary, surprise log, pattern page), build a portfolio, revise by
  retrieval, study without an instructor, avoid tutorial dependency, and
  develop problem-solving ability — organized around the **Recommended Study
  Cycle** (Read → Predict → Code → Run → Test → Debug → Explain → Extend)
  and closing with a copyable weekly self-study checklist.

- **16-Week Learning Roadmap (`docs/roadmap/`)** — the complete session-by-session
  path for independent study: 32 sessions across 5 stage files, each with title,
  prerequisites, learning objectives, concepts, recommended reading, examples to
  study, exercises, lab/practice, challenge, estimated self-study time, and a
  completion checklist — all linked to the actual course material. Includes the
  visual stage map, week table with the three flagship projects, the five-step
  session protocol, the ~125-hour journey estimate, the progress checklist, and
  the beyond-Week-16 enrichment path.

- **Self-Assessment System (`docs/self-assessment/`)** — 34 instruments totalling 376
  questions: 16 weekly quizzes (10 questions each, mapped to the syllabus's week-by-week
  session topics), 8 topic revision tests (12 questions each, spanning unit clusters:
  variables, control flow, functions, collections, strings, files, memory, OOP), 4
  cumulative tests (15 questions each at Weeks 5/10/13/16 depth), and 2 comprehensive
  practice finals (25 questions each in 8 weighted sections with per-section pacing,
  scoring guides, section-health checks, and post-exam worksheets). Every question
  carries a difficulty label, a hidden answer (collapsible sections), and an
  explanation; question families span recognition, prediction, tracing, debugging,
  code reading, short programming, and mixed revision.

- **Practice Bank (`docs/practice/`)** — 200 categorized programming problems in five
  difficulty tiers (Beginner B-01…40, Basic Ba-01…40, Intermediate I-01…40, Advanced
  A-01…40, Challenge C-01…40) across 17 topics: variables, input/output, conditions,
  loops, functions, arrays, strings, pointers, structures, files, recursion, searching,
  sorting, OOP, STL, exceptions, and integrated problems. Every problem carries the
  complete ten-part format (statement, difficulty, topics, expected input/output,
  constraints, sample tests, graded hints, reference solution, explanation) with
  solutions separated for self-study. A topic × tier matrix and per-topic progress
  checklist anchor the hub (`docs/practice/index.md`).

- **Projects collection (`docs/projects/`)** — 10 student-complete builds
  progressing from beginner to integrated: (1) the Calculator, (2) the
  Number Analysis Toolkit, (3) the Student Grade Analyzer, (4) the Expense
  Tracker, (5) the Quiz Application, (6) the Inventory Management System,
  (7) the Library Management System, (8) the Contact Management System
  (the syllabus Project 3 domain, rehearsed), (9) the File-Based Student
  Management System (two related files joined on a key), and (10) the
  Integrated OOP Management System (capstone rehearsal: domain classes,
  thin menu, audit log, RAII persistence). Every project carries the
  fifteen-part contract — overview, objectives, prerequisites (units
  named), requirements, functional requirements, data structures,
  milestones, tasks, test plan, edge cases, extensions, self-assessment
  rubric (shared rubric + project specifics), hints, complete reference
  solution, and design-decision explanations — with the shared rubric and
  a self-study run-protocol on the hub. Wired into README, docs index,
  syllabus.
- **Programming Labs collection (`docs/labs/`)** — 42 substantial scenarios in
  five levels (Beginner L1-01–08, Basic L2-09–16, Intermediate L3-17–24,
  Advanced L4-25–34, Integrated L5-35–42), every lab with the full
  fifteen-part contract: scenario, problem statement, learning objectives,
  requirements, input/output, constraints, example, test cases, student
  tasks, hints, extension challenges, complete solution, solution
  explanation, and a testing checklist. Realistic contexts throughout:
  canteen receipts, ID cards, admissions, cinema/utility/fee billing,
  payroll, queues, voting, marks and matrix analysis, inventory reorder,
  sorting and dictionary desks, recursion workshop, text toolkit,
  gradebook/library ledgers, dynamic-memory store, student registry,
  fee-account classes, course catalogue, and the integrated tier (expense
  tracker, bank simulation, library system, scheduling desk, survey
  analyzer, inventory control, contact book, and the result-processing
  capstone rehearsal). Level prerequisites name the units each lab needs;
  no lab introduces an untaught concept. Wired into README, docs index,
  syllabus.
- **Modular Programming module (`docs/modular/`)** — from small programs to
  organized programs, capstone prep: declarations vs definitions, the
  header/source split, translation units, include guards and #pragma once,
  namespaces (and the header using-directive retirement), include-what-
  you-use hygiene; separate compilation, the linker's verdicts (undefined
  and multiple references), staged multi-file builds from the command
  line, the include/ + src/ project layout, modular design's four tests,
  reusable modules, circular dependencies and their three refactors,
  organizing classes and functions; a complete multi-file example project
  (records/courses/textutil) with every .h and .cpp listed and one-shot +
  staged builds, 15 exercises with separated solutions, 10 debugging
  hunts (undefined references, duplicate definitions, guard collisions,
  header/source mismatches, namespace leaks, accidental includes, header
  cycles, stale objects, a three-bug audit), 8 project organization tasks
  (T1–T8, the capstone rehearsal), and the Modular Programming Lab
  (split-guard-namespace-build-extend with a regression file as referee).
  Wired into README, docs index, syllabus Stage F.
- **Modern C++ module (`docs/modern-cpp/`)** — the Unit 16 toolkit, scoped
  for a fundamentals course: two clearly separated columns — fundamental
  C++ every student should know (const correctness in five placements,
  references, `nullptr`, `enum class`, range-`for`, call-site lambdas,
  the standard library as the default answer) and modern practices to
  begin adopting (RAII, `auto` with restraint rules, `constexpr` +
  `static_assert`, `unique_ptr`/`make_unique` as the default owner,
  `shared_ptr` only for genuine sharing, move semantics conceptually, and
  the retirement of raw `new`/`delete` to non-owning-view roles); 18
  exercises in two parts with separated solutions, 8 debugging hunts
  (the auto that lied, the ghost value, the immortal shared_ptr cache,
  the raw owner's last leak, the const that caught it, nullptr
  archaeology, the moved-from return, the constexpr that wasn't), 6
  challenges with separated solutions (RAII log wrapper, ownership
  redesign, constexpr table, move-aware pipeline, smart-pointer policy,
  the modernisation kata), and the Modernisation Lab retrofitting an
  11-target vintage pipeline in four stages with the modernization table
  as the graded deliverable. Wired into README, docs index, syllabus
  Stage F.
- **Robustness module (`docs/robustness/`)** — advanced enrichment after the
  capstone: errors vs exceptions, try/catch/throw anatomy with stack
  unwinding, the standard exception family, custom domain exception types
  (one type per failure kind, data-carrying), the four exception-safety
  levels, validation layering (prevent/guard/throw/net), and the
  six-species silent-failure gallery; 15 exercises with separated
  solutions, 10 debugging hunts (dead handlers, flattened rethrows,
  throwing destructors, leaks through throw paths, half-transfers,
  constructor half-births), 10 challenges with separated solutions (the
  typed file layer, the transaction engine, the rollback scope-guard, the
  exception-safety audit harness), an 8-program refactor workshop that
  hardens earlier-lab programs (marks calculator, bank account, inventory
  file, grade analyzer, word counter, records, expense tracker, the
  media-log transaction), and the Robust Student/Bank/Inventory
  Application lab in three hardening rings (guards → typed exceptions →
  transaction safety) with fault-injection test tables. Wired into
  README, docs index, syllabus cross-cutting note.
- **Standard Template Library module (`docs/stl/`)** — advanced, explicitly
  optional enrichment (bannered at the hub, after the capstone): 3 lessons
  (sequence containers — vector/array/deque/list with the O-notation table
  and the choice rules; associative containers — set/map/unordered_set/
  unordered_map with the four-quadrant choice table; iterators and the
  range [begin, end) model, the workhorse algorithms — sort, find, count,
  reverse, min/max, accumulate — with the iterator-invalidations table and
  introductory lambdas), 25 exercises with separated solutions, 10 debugging
  hunts (the end()-deref, lost growth, mutated-key chaos, erase-while-
  iterating, invalidate-then-use, sorting const, find's address-return,
  wrong-order comparators, silently-sorted unordered_map, a three-bug
  audit), 15 challenges with separated solutions (topper finder, duplicate
  cleaner, anagram grouper, the phone book that must be sorted, most-
  frequent word, first-missing-positive with O(n) discussion, merging,
  stable sorting by hand, the menu state machine, reverse-word sentence,
  running median, missing-number arithmetic, task scheduler, student
  report cards, and the book word-index), 6 labs (contact manager,
  inventory manager, grade analyzer, frequency counter, leaderboard,
  task queue) and the Media Catalogue mini-project rebuilding the
  Inheritance module's design on unordered_map + unique_ptr + multiset
  with the graded container-choice defence. Wired into README, docs index,
  syllabus cross-cutting note, glossary (6 new terms).
- **Operator Overloading & Templates module (`docs/generics/`)** — advanced,
  explicitly optional enrichment (bannered at the hub): 2 lessons (operators
  as functions, the member-vs-non-member decision table, arithmetic and
  comparison operator families with the two-ground-truths derivation, the
  symmetry problem, stream-operator anatomy, and the mistakes gallery;
  function templates and the stamping model, implicit contracts, deduction
  rules, class templates, generic programming's three-part discipline, and
  the honest limitations — the error wall, code bloat, headers-only
  definitions — and seven common mistakes), 20 exercises with separated
  solutions, 8 debugging hunts (dangling operator returns, asymmetric
  equality, silent stream returns, contract failures and the error wall,
  deduction conflicts, copied containers, templates in .cpp files, a
  three-bug audit), 6 design problems with separated reviews, 8 challenges
  (the complete Money vault, generic compare/accumulate/findIf, the safe
  Box, the generic Tally, unit-safe lengths, the grid-of-grids), and 5 labs
  (Complex numbers, Generic calculator, Generic max/min toolkit, Generic
  container with the pointer-returning max, Student/result comparison with
  a generic comparator sort). Wired into README, docs index, syllabus
  cross-cutting note, glossary.
- **Inheritance & Polymorphism module (`docs/inheritance/`)** — cross-cutting
  deep-dive, the door the OOP module left ajar: 3 lessons (base/derived
  classes, the is-a test, `protected` and its defence, constructor/
  destructor order with observed diagrams, what is not inherited; overriding
  vs hiding, `virtual` dispatch drawn in two diagrams, the vtable in one
  honest paragraph, slicing, virtual destructors, `override`/`final`;
  pure virtual functions, abstract classes, the interface concept with two
  C++ idioms, the full composition-vs-inheritance decision procedure, and
  the ten-mistake design gallery), 22 exercises with separated solutions,
  10 debugging hunts (hiding ≠ overriding, slicing, leaks through base
  pointers, protected co-ownership, hidden overloads), 10 design problems
  with separated reviews (Stack:Vector, Square:Rectangle, the god-base
  audit), 10 challenges with defence sentences, 5 hierarchy labs (Shape,
  Employee, Payment — the composition lab, Vehicle — hybrid composition,
  University), and the Media Library mini-project with a graded design
  defence. Wired into README, docs index, syllabus cross-cutting note,
  glossary.
- **OOP module (`docs/oop/`)** — Unit 15 deep-dive, the procedural→object bridge:
  3 lessons (why OOP, objects vs classes, attributes/methods, public/private,
  encapsulation and the getter/setter discipline, struct vs class;
  constructors — default/parameterized/delegating — member initializer
  lists, destructors, the `this` pointer, the object-lifetime story;
  const member functions, the six-step design method, composition has-a
  and the relationship field guide, `operator<<`, vectors of objects, and
  the honest one-paragraph inheritance preview), 26 exercises with
  separated solutions, 10 schema-first class-design drills with separated
  reviews, 10 debugging hunts (encapsulation leaks, constructor traps,
  const violations, lifetime bugs), 10 challenges, 7 class labs
  (BankAccount, Student, Book, Product, Employee, Course, Library — each
  with interface tables, test tables, solutions, explanations), and the
  Object-Oriented Mini Project (the Records-module Student Record
  Management System refactored to `Student` + `Roster` classes with the
  file format contract preserved). No inheritance/polymorphism, by design.
  Wired into README, docs index, syllabus (Unit 15 now ✅), glossary.
- **Debugging & Testing module (`docs/debugging/`)** — cross-cutting deep-dive:
  3 lessons (the error taxonomy — syntax/compile/runtime/logic/semantic —
  with a dissected compiler diagnostic and the seven-step debugging workflow;
  the debugger — breakpoints, stepping, inspection across gdb/lldb/VS Code —
  plus `assert` and the testing discipline with boundary and invalid-input
  families and regression testing; writing better code — defensive
  programming, meaningful names, comments that earn their lines, modularity,
  the DRY rule, and a code-review checklist), a 20-program debugging
  practice pack (description, expected behaviour, buggy code, hint ladders,
  corrected code, explanation), and the Debugging Challenge Lab (timed
  six-program triage, a two-bug deep hunt with a guarded fix and regression
  rows, and the bug-journal deliverable). Wired into README, docs index,
  and the syllabus's cross-cutting note.
- **Algorithms module (`docs/algorithms/`)** — Unit 10 deep-dive (Part A
  recursion, Part B searching, Part C sorting): 3 lessons (recursion from
  first principles — base/recursive cases, the call stack as stacked boxes,
  factorial, Fibonacci with the overlap warning, digit processing,
  recursive search and array recursion, mistakes gallery; searching —
  linear search in full, complexity intuition by counting, binary search
  with the sorted precondition, the recursive variant, the honest choice
  table; sorting — bubble/selection/insertion with pseudocode, dry runs,
  implementations, the three-personalities comparison, shared mistakes),
  32 exercises with separated solutions, 15 hand-trace drills, 10
  debugging hunts, 15 challenges (through merge sort and a function-pointer
  toolkit sort), the Algorithm Performance and Comparison Lab with an
  instrumented harness, and the **Project 2 brief** (Student Records
  Manager). Wired into README, docs index, syllabus (Unit 10 now ✅).
- **Files module (`docs/files/`)** — Unit 12 deep-dive: 3 lessons (streams,
  ofstream/ifstream/fstream, open-check-close; modes and append, line-based
  vs formatted reading, the mixing-trap seams, CSV, record storage; file
  errors, EOF discipline, the ten-mistake gallery), 18 exercises with
  separated solutions, 10 debugging hunts, 10 challenges, 6 file labs
  (student records, expenses, inventory, marks report, contacts, audit
  log) with realistic test data, and the File-Based Student Management
  System mini-project. Wired into README, docs index, syllabus (Unit 12
  now ✅), and the glossary.
- **Records module (`docs/records/`)** — Unit 14 bridge: 3 lessons (structs,
  members, initialization, arrays of records; passing by value/pointer/
  `const&`, returning, nested structures; enum, enum class, the design
  habit and the mistakes gallery), 22 exercises with separated solutions,
  10 debugging hunts, 10 predictions, 10 challenges, 6 record-keeping labs
  (students, employees, inventory, library, patients, registration), and
  the Student Record Management System mini-project. Wired into README,
  docs index, syllabus (Unit 14 records/enum bridge now ✅), glossary.
- **Pointers module (`docs/pointers/`)** — Unit 13 deep-dive: 3 lessons (memory
  and addresses, `&`/`*`, `nullptr`; the two pointer jobs, references,
  refs-vs-pointers, out-parameters and the const ladder; pointers with
  arrays, `new`/`delete`, dynamic arrays, the three failure families and
  ownership), 20 guided exercises with separated solutions, 10 debugging
  hunts, 10 memory-tracing drills, 10 challenges, 4 engineered-safe labs,
  and the Quiz Runner mini-project with an explicit ownership contract.
  Wired into README, docs index, syllabus (Unit 13 now ✅), and the glossary.
- **Strings module (`docs/strings/`)** — Unit 11 deep-dive: 4 lessons (char
  arrays vs `std::string`; creation, two readers, one buffer; indexing and
  the lexicographic rules; find/substr/insert/erase/replace; the cctype
  workshop; string↔number conversions and the mistakes gallery), 26
  exercises with separated solutions, 10 debugging hunts, 10 predictions,
  10 challenges, 7 labs (username validator, password checker, text
  analyzer, word counter, search tool, name processor, text statistics),
  and the Text Analysis Toolkit mini-project. Wired into README, docs
  index, syllabus (Unit 11 now ✅), and the glossary.
- **Arrays module (`docs/arrays/`)** — Unit 09 deep-dive: 4 lessons (boxes/bounds/
  errors; the five classic passes; arrays as function parameters with const
  and size conventions; 2D arrays and matrices), 32 exercises with separated
  solutions, 10 debugging hunts, 10 predictions, 15 challenges, 7 analysis
  labs with solutions, and the Marks Analyzer mini-project. Wired into README,
  docs index, syllabus (Unit 09 now ✅), and the glossary.
- **Functions module (`docs/functions/`)** — Units 07–08 deep-dive: 4 lessons
  (the function machine; copies/scope/prototypes/decomposition; references +
  per-function testing; overloading/defaults/refactoring + errors gallery),
  26 exercises with separated solutions, 10 debugging hunts, 10 refactoring
  exercises, 10 challenges, 8 multi-function design labs, and the progressive
  Menu-Driven Utility Toolkit mini-project. Wired into README, docs index,
  syllabus (Units 07–08 now ✅), and the glossary.
- **Iteration module (`docs/repetition/`)** — Units 05–06 deep-dive: 4 lessons
  (while/accumulators, for + idioms + loop choice, break/continue/sentinels,
  nested loops + digits + patterns + error gallery), 32 exercises with fully
  separated solutions, 15 debugging hunts, 15 predictions with a separated
  answer section, 15 challenges, 10 labs with dry-run skeletons, and the
  menu-driven Number Analysis Toolkit mini-project. Wired into README,
  docs index, syllabus (Units 05–06 now ✅), and the glossary.
- Course architecture and phased implementation plan
  (`docs/course-architecture.md`, `docs/implementation-plan.md`).
- Student-facing foundation: root README as the course landing page;
  site core pages (`docs/index.md`, `docs/about.md`, `docs/syllabus.md`,
  `docs/how-to-study.md`, `docs/assessment.md`, `docs/grading.md`,
  `docs/glossary.md`, `docs/faq.md`); getting-started pack (setup guides for
  Windows, Linux, macOS, and online compilers); `docs/toolchain/` with
  `sanity-check.cpp` and build/reference pages; Unit 01 with Lesson 1
  published and the unit scaffold in place.
- "Getting Started with C++" module (Week 0): comprehensive lesson covering
  source → compilation → linking → executables, IDE vs editor, command-line
  compilation per platform, error kinds, reading compiler errors, terminal
  basics, project/exercise/lab organisation, site usage, optional Git;
  plus setup checklist, first-program exercise, troubleshooting guide with
  12 named scenarios, 10 beginner exercises + 5 challenges, and Lab 00
  (starter + Debug It + write-up template).
- "Programming and Problem-Solving Fundamentals" module: lesson threading
  all 20 fundamentals (computational problems, decomposition, IPO,
  requirements/assumptions/constraints, algorithms, pseudocode, flowcharts,
  decisions, repetition, dry runs, trace tables, test cases, edge cases,
  common mistakes, translation to C++) through one worked example; 20
  progressively harder problem-solving scenarios in four sets with full
  worked solutions; "Try It Yourself Before Looking at the Solution"
  protocol; and a 4-task problem-solving lab with write-up template and
  self-check rubric.
- "C++ Foundations" module: four lessons (program structure/main/statements/
  comments; variables, identifiers, naming, types, constants, literals,
  declaration/initialization/assignment; arithmetic, relational, logical,
  increment/decrement, compound assignment, precedence; implicit and
  explicit conversion + an eight-item mistake gallery), 24 exercises,
  10 output predictions, 10 debugging exercises, 10 challenge problems,
  a four-variation marks/grade-calculator lab with test tables, and a
  12-question self-check quiz with a separate answer key.
- "Decision Making" module (`docs/decisions/`): four lessons — branches
  (if/else-if/nested, braces discipline), conditions and boundaries
  (comparison/logical/compound, the 39-40-41 boundary test), switch and
  the conditional operator (fallthrough, stacked cases, honest tool
  choice), and a five-stage requirements-to-decisions pipeline (decision
  tables → flowcharts → pseudocode → C++ → dry runs) worked on a blood-
  donor example; 25 exercises, 10 debugging hunts, 10 predictions,
  10 challenges, and 8 fully-briefed labs (grading, electricity billing,
  cinema pricing, ATM withdrawal validation, sports-day categories,
  admission eligibility, shipping costs, restaurant billing) — each with
  requirements, inputs/outputs, constraints, edge-row test tables,
  student tasks, extensions, and collapsed solutions; also unlocked the
  PASS/FAIL extension promised in the cpp-io module's Lab 1.
- "C++ Input and Output" module (`docs/cpp-io/`): three progressive lessons
  (cout/endl/formatting with iomanip; cin, whitespace rules, the buffer,
  validation basics; getline, the mixing trap, both cures, and a
  ten-item mistakes gallery), 5 trace exercises with buffer columns, 12
  output predictions, 24 graded exercises, 10 seeded debugging hunts,
  10 challenges, and 5 fully-briefed lab scenarios (student info system,
  billing counter, temperature assistant, travel expenses, utility bill)
  with test tables, extensions, and solutions.
- In-page anchor checker (`tools/check-anchors.sh`): validates every
  `#fragment` link under BOTH GitHub and Jekyll slug algorithms and accepts
  explicit `<a name>` anchors; 100 portable anchors added across README,
  syllabus, lessons, and reference pages. Prediction drills P11–P15 added to
  complete the arithmetic/logical/increment/precedence set referenced by the
  operators lesson.
- Internal-link checker (`tools/check-links.sh`).
- MIT Licence, contribution guide, citation metadata.

### Fixed

- **GitHub Pages build fixed (“Dependency Error: jekyll-coffeescript is
  missing”)** — the deploy workflow's Jekyll build failed because
  `docs/_config.yml` whitelisted three plugins (`jekyll-coffeescript`,
  `jekyll-gist`, `jekyll-github-metadata`) that were never declared in the
  `Gemfile` and that no course page uses; Jekyll requires every whitelisted
  plugin at startup. The whitelist is now exactly `jekyll-relative-links`,
  with the whitelist/Gemfile lockstep rule documented in both files; the
  Gemfile pins `jekyll ~> 3.10` (the version GitHub Pages currently ships);
  `Gemfile.lock` is committed so local and CI builds resolve identical gem
  versions. The rebuilt site also surfaced and repaired 17 link defects the
  link checker could not see: 7 Unit 01 companion-module banners used raw
  HTML anchors the link rewriter mishandles (5 with an escaping `../../../`
  path) — now proper markdown in `markdown="1"` blocks; 6 links to
  repository-root files (`CONTRIBUTING.md`, `README.md`) would have 404'd
  on the published site — now absolute GitHub links; and 4 link texts
  wrapped across lines slipped past link rewriting and lost the site
  baseurl. `tools/check-links.sh` now also scans raw-HTML anchor hrefs
  (including root-absolute detection) and `tools/check-anchors.sh` skips
  tooling directories. Local Jekyll build verified end-to-end: 264 pages,
  correct baseurl on every link, student homepage intact
  (`reports/github-pages-build-fix.md`).
- **README “Start here” chain now reaches Lesson 1 third, not last** — the
  chain previously listed all 22 modules before “Unit 01 · Lesson 1” and
  ended on the legacy duplicate; it now goes Getting Started →
  Problem-Solving → **Lesson 1** (maintained Foundations lesson) → the
  remaining modules in canonical order, with enrichment modules labelled
  *after the course*.
- **README no longer claims Units 02–16 are “published unit by unit”** — the
  units table now maps every unit 2–16 to its teaching module, labs,
  quizzes, and project; the progress checklist has real per-unit blocks;
  the learning-sequence schematic names real pages.
- **Website homepage module order matches the canonical syllabus order**
  (Strings → Files → Pointers → Records; Algorithms before Strings).
- **Syllabus Units 14–15 aligned with the modules students actually study**
  (Unit 14: records bridge + first class labs; Unit 15: class labs + the
  Object-Oriented Mini Project); “🔜 coming” rows for Units 2–4 and 16
  replaced with links to the live material.
- **Unit 01 pages re-framed as companions, not corpses** — the “Legacy path
  — superseded” banners became “Companion module: study these pages
  together”, matching the Foundations module's own “alongside, not
  instead” guidance.
- **C++ example validation (`reports/cpp-validation.md`)** — technical
  validation of all 1,585 C++ examples (1,576 embedded listings + 9 standalone
  files). Genuine defects found and fixed: the Lab 00 debug hunt seeded 4 bugs
  but its header, bug diary, and lab brief promised 5 (count corrected
  everywhere); and 13 listings were missing headers they use — six reference
  solutions called `tolower`/`isdigit`/`isalpha`/`toupper` without
  `<cctype>` (non-portable), two `iostream`-only Syntax boxes lacked the
  `<iostream>` they show, and the modular module's own example files violated
  its include-what-you-use rule (D7) by relying on transitive includes.
  Intentional constructs (deliberately buggy hunts, include-elision
  demonstrations, idiom fragments) were classified and left untouched.

- **Repository-wide audit (`reports/course-audit.md`)** — full audit of content,
  links, code blocks, navigation, and deployment readiness: 0 critical / 0 high
  findings. Fixed during the audit: three missing directory index pages
  (getting-started/starter, toolchain, unit-01 examples), the Week-3 weekly-
  quiz link, 44 code fences tagged `text` (diagrams, file formats, program
  output), one terminology outlier, and the README footer's planning-doc link
  replaced with the contributor guide. Judgment items documented in the report,
  notably that the C++ listings were verified statically (no compiler on the
  audit machine) and a compile sweep on a g++ machine remains recommended.

- **Links that would break on the published site** — licence/citation links
  pointed outside `docs/` (the Pages root) and now target GitHub; the 404
  page's root-absolute links now use relative paths backed by a `<base>` fix;
  the homepage's Start-here lesson and self-assessment question count
  (376 → 366) were corrected; legacy `units/` pages carry visible pointers
  to their maintained replacements.

### Planned

- Unit 01 remaining components (Lesson 1.2, exercises, lab, quiz, debug
  activities, challenges, revision sheet) — see `docs/implementation-plan.md`.
- Units 02–16, Projects 1–3, and the final exam pack, published in the
  milestone order of `docs/implementation-plan.md`.
