# Implementation Plan — Programming Fundamentals Using C++

> Phased build plan with acceptance criteria. Companion to
> [`course-architecture.md`](course-architecture.md), which defines the course
> structure, unit sequence, and quality gates; this file defines **what gets
> built, in what order, and how we know each phase is done**.
> Last revised: 2026-09-22

---

## How to use this plan

- Build one phase at a time; **each phase ends publishable** (no dead links,
  quality gates from architecture §11 all pass).
- The instructor commits and pushes manually at phase boundaries — no commits
  or pushes are made by the automated agent.
- Every phase updates the three unit maps (root README, `docs/index.md`,
  `docs/syllabus.md`) so they always agree.
- **Standing rule:** link a unit from any map only when that unit's files
  actually exist.

---

## Phase 0 — Repository bootstrap (first commit)

**Goal:** a public repo that looks intentional on first visit and contains the
complete Week-0 orientation pack.

**Files**

- `.gitignore` — `*.exe`, `*.o`, `*.out`, `*.gch`, build dirs, editor files
- `LICENSE` — MIT (pending instructor confirmation, architecture §14.1)
- `README.md` — student-facing: course pitch, outcomes, 16-unit map (links
  only to existing units), quickstart (→ getting-started), where things live.
  **No deployment/CI/maintenance content.**
- `CONTRIBUTING.md` — reporting typos/broken links, suggesting content
- `CHANGELOG.md` — "0.1.0 — course scaffolding"
- `CITATION.cff` — author = Muhammad Nadeem Majeed, title, year, licence
- `docs/index.md` — landing page: welcome, 30-minute quickstart, unit map
- `docs/getting-started/index.md` — setup overview + choose 16-week or self-paced
- `docs/getting-started/study-guide.md` — the study method
- `docs/getting-started/compiler-setup/{index,windows,linux,macos,online-compilers}.md`
- `docs/toolchain/sanity-check.cpp` — compiles with `g++ -std=c++17 -Wall -Wextra`
- `docs/syllabus.md` — full 16-unit table, links only to built units
- `docs/how-to-study.md`, `docs/assessment.md`, `docs/grading.md`,
  `docs/glossary.md` (starter set), `docs/faq.md` (starter set)

**Acceptance criteria**

1. Every internal link resolves (scripted check, `tools/check-links.sh`).
2. The Windows/Linux/macOS setup guides were each followed once end-to-end or
   are explicitly marked "verified on <OS>, <compiler version>".
3. `sanity-check.cpp` compiles warning-free with the documented command.
4. README contains zero CI/deployment/maintenance text.

---

## Phase 1 — Unit 01 + course shell (first publishable course state)

**Goal:** one complete, exemplary unit — it becomes the template for all 15
others — plus the assessment scaffolding.

**Files**

- `docs/units/unit-01-introduction-to-programming-and-cpp/` — full skeleton:
  `index.md`, 2 sessions, `examples/` (3+ .cpp), `exercises.md`, lab
  (brief + starter + solution), quiz + answers, debug activities, challenges,
  revision sheet
- `docs/assessment.md` and `docs/grading.md` finalized (lab rubric reused by
  all labs; project rubric placeholders linked to Phase 4/6/8)
- glossary + FAQ grow with Unit 01 terms

**Acceptance criteria**

1. All Unit 01 `.cpp` files compile warning-free with the documented command.
2. Every session page links its examples; every example file exists.
3. Quiz answers explain *why*, not just *what*.
4. Unit index shows all 10 standard sections (architecture §9.2).
5. Syllabus + README + `docs/index.md` now link Unit 01.
6. **Instructor action after this phase:** enable GitHub Pages
   (`main` `/docs`) and verify the published site.

---

## Phase 2 — Foundation arc (Units 02–05) + Project 1

**Goal:** a student with no experience can now reach real programs: input,
decisions, loops, and their first graded project.

- Units 02–05 built to the full template (sessions, examples, exercises,
  quiz+answers, lab+starter+solution, debug, challenges, revision).
- Project 1 pack: `docs/projects/README.md` + `project-1-electricity-bill-calculator/`
  (brief, starter, solution) + rubric in `docs/grading.md`.
- Unit 05 links the project; maps updated.

**Acceptance:** gates pass for all four units; Project 1 solution compiles;
maps agree.

---

## Phase 3 — Functions arc (Units 06–08)

- Units 06–08 full template. Unit 08's lab refactors Unit 05's lab — verify
  the Unit 05 starter/solution names still match what Unit 08 references.
- Challenge code (`isPrime`) is written to be reused by Unit 09+.

**Acceptance:** gates pass; cross-unit references resolve.

---

## Phase 4 — Data arc (Units 09–12) + Project 2

- Units 09–12 full template.
- Project 2 pack (`project-2-student-records-manager/`: brief, starter,
  solution) + rubric; Unit 10 links it; maps updated.

**Acceptance:** gates pass; Project 2 solution compiles; maps agree.

---

## Phase 5 — Objects arc (Units 13–15)

- Units 13–15 full template. Unit 15's `operator<<` and composition examples
  must compile against the Unit 14 `Student` class conventions (consistent
  naming across units).

**Acceptance:** gates pass.

---

## Phase 6 — Capstone & course completion (Unit 16)

- Unit 16: modern C++ toolkit session, capstone build session, full-course
  revision pack, 20-question practice final + answers, skills checklist.
- Project 3 pack (`project-3-capstone-contact-management/`: brief, starter,
  solution, stretch goals) + rubric.
- `CHANGELOG.md` → "1.0.0 — complete course".
- README gains a "Course complete" banner + certificate-of-completion note
  (self-declared, via the assessment page).

**Acceptance:** gates pass end-to-end; final link check; site shows all 16
units complete.

---

## Standing quality gates (every phase)

1. Every `.cpp` compiles with `g++ -std=c++17 -Wall -Wextra`, zero warnings.
2. Starters **and** solutions compile clean.
3. Every internal link resolves — run `tools/check-links.sh` before declaring
   a phase done.
4. Unit-map consistency: README = `docs/index.md` = `docs/syllabus.md`.
5. Every quiz has an answers page; every lab links starter + solution.
6. Component directories present per unit: `examples/`, `labs/starter/`,
   `labs/solution/`.

---

## Supporting tooling (built in Phase 0)

- `tools/check-links.sh` — walks `docs/**/*.md`, extracts relative links,
  verifies each target exists on disk. Exit non-zero on any dead link so it
  can be run before every push.

---

## Open decisions carried from the architecture doc (§14)

1. Licence choice (MIT recommended) — needed **before Phase 0 commit**.
2. Project rubric point splits — confirm or adjust.
3. Capstone topic — Contact Management System proposed; alternatives fine.
