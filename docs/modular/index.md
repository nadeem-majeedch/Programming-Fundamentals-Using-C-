---
title: "Modular Programming — From One File to Organized Programs"
description: "Headers and source files, declarations vs definitions, include guards, namespaces, separate compilation and linking, project structure, modular design, and avoiding circular dependencies — with a complete multi-file example project, exercises, debugging scenarios, organization tasks, and the Modular Programming Lab."
---

# Modular programming — from one file to organized programs

> **Prerequisites:** Units 01–15 — especially the [Functions module](../functions/index.md) (prototypes), the [OOP module](../oop/index.md) (classes with several methods), and the [Modern C++ module](../modern-cpp/index.md) (the ownership habits the classes here follow).

Every program in this course so far fit in one file. Real programs do not — and neither will your [capstone](../syllabus.md#stage-f-capstone-unit-16) once it grows past a thousand lines. This module is the bridge: **how C++ programs are physically organized** (headers, sources, translation units), **how they are built** (separate compilation, linking), and **how to decide what goes where** (modular design).

**The module in three ideas:**

1. **Declarations travel; definitions stay.** Headers announce what exists; source files deliver it. One definition, many declarations — the one-rule from which everything else follows.
2. **Compile once, link many.** Each `.cpp` compiles independently; the linker stitches them. That is why big projects build at all — and why header hygiene matters.
3. **A module owns one job.** Files are organized by *responsibility* (student data, course rules, text utilities), not by *kind* (all structs here, all functions there).

## What's in the module

| Page | Contents |
| --- | --- |
| [Lesson 1 — The header/source split](lesson-1-headers-sources.md) | Declarations vs definitions; why headers exist; include guards and `#pragma once`; namespaces; the include-what-you-use rule |
| [Lesson 2 — Building and organizing](lesson-2-building-organizing.md) | Separate compilation and the linker; compiling multiple files by command line; project layout; modular design and reusable modules; circular dependencies; organizing classes and functions |
| [Example project](example-project.md) | A **complete multi-file project** — student/course domain + a text utility module — every `.h` and `.cpp` listed in full, with single-command and separate-compilation builds |
| [Exercises](exercises.md) | 15 problems with separated solutions |
| [Debugging scenarios](debugging.md) | 10 hunts — undefined references, multiple definitions, missing includes, guard mistakes, circular includes |
| [Project organization tasks](tasks.md) | 8 structured refactors from single-file to organized |
| [Lab — the Modular Programming Lab](labs.md) | Split a working single-file program into modules, then extend it without breaking it |

## Pacing (two sessions)

- **Session A** — [Lesson 1](lesson-1-headers-sources.md) + the example project's single-command build + Exercises Part A.
- **Session B** — [Lesson 2](lesson-2-building-organizing.md) + separate compilation + Exercises Part B + [the lab](labs.md).
- **Stretch** — [organization tasks](tasks.md), [debugging hunts](debugging.md), and the lab's extension stage.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
