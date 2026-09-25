---
title: "Project Organization Tasks — 8 Structured Refactors"
description: "Eight refactors from single-file programs to organized multi-file projects: the first split, module extraction, the include/ src/ migration, forward declarations, and the capstone rehearsal."
---

# Project organization tasks — 8 structured refactors

> [← Module home](index.md) · Each task: a starting shape, a target shape, and a verification gate. Do them **on real programs you already wrote** — the arrays, strings, records, and OOP labs are the raw material.

The tasks form a ladder — each assumes the previous. The verification gate after every task is identical: **the program's output is unchanged**, the build is warning-free (`-Wall -Wextra`), and each module compiles alone.

---

- **T1 ★ — The first split.** Take any single-file program with 3+ functions (the functions module's toolkit is ideal). Extract every function *except `main`* into `toolkit.h` + `toolkit.cpp`. Gate: build `g++ -std=c++17 -Wall -Wextra main.cpp toolkit.cpp -o app`; output identical; `toolkit.cpp` compiles alone.
- **T2 ★ — Guard consistency.** Take any two headers (T1's, or the example project's). Convert one to include guards, the other to `#pragma once` — then standardise both to the course's rule. During the exercise: deliberately give one guard a colliding name and reproduce hunt [D4](debugging.md). Gate: both headers protected; the collision hunt documented in your notes.
- **T3 ★ — Namespace adoption.** Wrap each module of your T1/T2 project in its own namespace (`records`, `textutil`, ...). Then retire every `using namespace std;` — headers permanently, `.cpp` files by spelling `std::`. Gate: zero using-directives in headers; the qualified calls compile; one sentence on what the qualifiers added to readability.
- **T4 ★★ — Module by responsibility.** Take the strings module's mini-project (Text Analysis Toolkit) — or any program with mixed duties — and split it into at least three modules by *responsibility* (e.g. `textops` (pure string work), `analysis` (word/frequency policy), `report` (presentation)), plus thin `main`. Draw the dependency diagram first; no two-way arrows. Gate: the diagram is one-way; each module compiles alone; the analysis runs identically.
- **T5 ★★ — The include/src migration.** Move all headers of your T4 project into `include/`, sources into `src/`. Rebuild with `-Iinclude`. Then break it on purpose: build *without* the flag, record the error, fix. Gate: the two-folder layout; the one-shot and staged builds both work; the error message from the broken build quoted in your notes.
- **T6 ★★ — The forward declaration.** In your T5 project (or the example project), find a header-to-header include whose consumer only uses pointers/references — and replace it with a forward declaration, moving the include to the `.cpp`. Gate: the include count between headers strictly drops; full builds pass; one sentence on the "headers may name; sources use" rule as you experienced it.
- **T7 ★★★ — The reusable extraction.** Identify the most *domain-independent* logic in any of your projects (a string utility, a stats helper, a validation reader) and extract it as a stranger-usable module: own namespace, complete header contract with per-function comments, no application types, no `main`. Then genuinely reuse it: a *second, tiny* program in another folder that includes only that header. Gate: the stranger program builds against the module alone; the header passes the four modularity tests.
- **T8 ★★★ — The capstone rehearsal.** Take the largest program you have written this course (the records or files mini-project) and perform the full modernisation to the course layout: `include/` + `src/`, one module per responsibility, thin `main` with the top-level error net, namespace per module, `#pragma once`, minimal includes, one-way dependencies — then add `tests/test_module.cpp` exercising one module alone (the Debugging module's regression discipline, in the new layout). Gate: every rule of Lesson 2 §7's build checklist, verified line by line in your notes; the build is two commands; `main` fits on a screen.

---

## Notes on the ladder

- **Tasks T1–T3 are mechanical** — hours, not days. Their value is *speed with the mechanics*: the split, the guards, the namespaces happen without deliberation by the time T4 arrives.
- **T4 is the first design task** — the dependency diagram comes *before* the file moves, because drawing it will change the split (that is the point).
- **T7 is the reusability task** — its gate is a *second program*, because reusability that has never been used twice is a claim, not a property.
- **T8 is the capstone rehearsal.** Your Project 3 will grow in the shape T8 produces: `include/`, `src/`, modules by responsibility, a thin `main`, tests beside the build. Doing T8 on an *existing* program first means the capstone starts organized instead of being refactored under deadline.

## A worked fragment (T1, the toolkit split)

*Before* — one file, prototypes on top, `main` below (the Unit 07 shape). *After*:

```text
toolkit.h:      #pragma once  ·  namespace toolkit  ·  the three prototypes
toolkit.cpp:    #include "toolkit.h"   (FIRST)  ·  the three bodies
main.cpp:       #include "toolkit.h"   ·  main() unchanged
```

The gate's third clause — `g++ -std=c++17 -Wall -Wextra -c toolkit.cpp` succeeding alone — is the step beginners skip and professionals never do: it proves the module's self-containment *before* the program depends on it.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
