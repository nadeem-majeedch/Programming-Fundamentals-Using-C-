---
title: "Inheritance & Polymorphism — Building on Classes"
description: "Base and derived classes, protected, constructor/destructor order, virtual functions, runtime polymorphism, abstract classes and interfaces, and the honest composition-vs-inheritance decision."
---

# Inheritance & Polymorphism — building on classes

> A **cross-cutting module** — the next door after the [OOP module](../oop/index.md) · [← Course home](../index.md) · [Syllabus](../syllabus.md) · [Glossary](../glossary.md)

The [OOP module](../oop/index.md) ended with a promise: inheritance waits outside the door, and you don't need it yet. This module opens that door — **now that HAS-A and encapsulation are instinctive**. The sequencing is the lesson: most inheritance bugs are composition decisions made carelessly, so this module spends as much time on *when not to inherit* as on the machinery itself.

**Positioning:** study this after the [OOP module's mini-project](../oop/miniproject.md). It sits outside the 16-unit week plan (Unit 16's capstone remains the course's final project) — it is the bridge to every data-structures and software-engineering course that follows, where virtual functions and abstract interfaces are the daily vocabulary.

## What this module covers

| Lesson | What it covers |
| --- | --- |
| [Lesson 1 — Base classes, derived classes, order](lesson-1-base-derived.md) | The is-a test; `public` inheritance; `protected`; **constructor and destructor order** with diagrams; what is *not* inherited |
| [Lesson 2 — virtual and runtime polymorphism](lesson-2-virtual-polymorphism.md) | Overriding vs hiding; why `virtual` exists (the non-virtual call problem, drawn); the `Shape*` loop; **slicing**; virtual destructors; `override` and `final` |
| [Lesson 3 — Abstract classes, interfaces, design](lesson-3-abstract-design.md) | Pure virtual functions; abstract classes; the interface concept; **composition vs inheritance — the full decision procedure**; the common OOP design mistakes gallery |
| **Practice** | [Exercises](exercises.md) — 22 graded with separated solutions · [Debugging](debugging.md) — 10 seeded hunts · [Design problems](design.md) — 10 with separated reviews · [Challenges](challenges.md) — 10 with separated solutions |
| **Labs** | [5 labs](labs.md) — Shape, Employee, Payment methods, Vehicle, University role hierarchies — each built twice where it matters: once with inheritance, once with the composition alternative |
| **Mini-project** | [Mini-project](miniproject.md) — the **Media Library**: a polymorphic collection with an abstract interface, persistence, and a written design-defence |

## The try-it-first protocol (unchanged)

Design questions especially: every [design problem](design.md) and lab asks for the is-a test *in writing* before any class is typed. The [reviews](design.md) grade the reasoning, not just the class diagram.

## Pacing

- **Session A** — Lesson 1 + Exercises Part A + the [Shape lab](labs.md). Constructor order and the is-a test are the foundations.
- **Session B** — Lesson 2 + Exercises Part B + the [Employee or Vehicle lab](labs.md). Virtual dispatch is the conceptual heart — give it a full session.
- **Session C** — Lesson 3 + design problems + the [Payment lab](labs.md) (where composition wins) + the mini-project.

## Self-check — you own this module when…

- [ ] You can state the is-a test and cite a case where it *fails* while code reuse tempts you
- [ ] You can draw the constructor/destructor order of a three-level hierarchy from memory
- [ ] You can explain, with the two-diagram picture, what `virtual` changes about the call
- [ ] You never declare a polymorphic base class without a virtual destructor
- [ ] You can name the composition alternative for an inheritance design — and say why you'd pick it

## Where this leads

`virtual`, pure virtual, and abstract bases are the exact vocabulary of data-structures courses (containers over `Comparable`/`Iterable` interfaces) and of every framework you will ever extend. The [mini-project](miniproject.md)'s design-defence is the first entry in the portfolio habit: *justify the relationships, don't just draw them.*

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
