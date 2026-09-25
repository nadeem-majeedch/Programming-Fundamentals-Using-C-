---
title: "Object-Oriented Programming — The Bridge from Procedures to Objects"
description: "Unit 15 module: why OOP, classes and objects, encapsulation, constructors and destructors, this, const member functions, object lifetime, and composition — no inheritance, by design."
---

# Object-Oriented Programming — from Procedures to Objects

> Week 15 · [← Course home](../index.md) · [Syllabus](../syllabus.md) · [Glossary](../glossary.md)

Units 07–14 taught you to *organize functions* (the Functions module) and *organize data* (the Records module) — in two separate rooms. Object-oriented programming moves the furniture: **data and the functions that operate on it travel together**, in one package, with rules about who may touch what. That is the whole revolution. Everything else — constructors, `const`, composition — is craftsmanship applied to it.

**One promise and one promise out.** In: every idea in this module is a generalization of something you already own — a `struct` whose functions moved inside, a validated setter from the Records module, the ownership thinking from Pointers. Out: **no inheritance, no polymorphism, no virtual functions** *in this module* — they get their own module, [Inheritance & Polymorphism](../inheritance/index.md), which opens the door once these foundations are yours. (The syllabus says "preview" — the preview is a single honest paragraph at the end of [Lesson 3](lesson-3-design-composition.md).)

## What you already have

| You built | In | It becomes |
| --- | --- | --- |
| `struct StudentRecord` + free functions | [Records module](../records/index.md) | a class with private data and member functions |
| Validated `setMark` guard chains | Records module | setters — same rules, new address |
| The paired `new[]`/`delete[]` cleanup | [Pointers module](../pointers/index.md) | destructors — the pairing, automated |
| Menu-driven managers over records | Records, Files, Algorithms mini-projects | the Object-Oriented Mini Project — the same manager, refactored |

## The module map

| Lesson | What it covers |
| --- | --- |
| [Lesson 1 — Objects, classes, encapsulation](lesson-1-objects-classes.md) | Why OOP; attributes and methods; `public`/`private`; the getter/setter discipline; your first real class |
| [Lesson 2 — Constructors, destructors, lifetime](lesson-2-constructors-lifetime.md) | Default/parameterized/delegating constructors, member initializer lists, destructors, `this`, the object lifetime story |
| [Lesson 3 — Design, const, composition](lesson-3-design-composition.md) | const member functions; the design method (nouns → data → verbs → interface); composition (has-a) and basic class relationships; `operator<<`; vectors of objects; the inheritance preview |
| **Practice** | [Exercises](exercises.md) — 26 graded with separated solutions · [Class design](design.md) — 10 schema-first design drills · [Debugging](debugging.md) — 10 seeded hunts · [Challenges](challenges.md) — 10 with separated solutions |
| **Labs** | [7 labs](labs.md) — BankAccount, Student, Book, Product, Employee, Course, Library — each a full class design with interface tables, test cases, and solutions |
| **Mini-project** | [Object-Oriented Mini Project](miniproject.md) — the Student Record Management System, rebuilt as `Student` + `Roster` classes; file code barely changes |

## The try-it-first protocol (unchanged)

Solutions are separated from problems everywhere in this module. Design questions especially deserve struggle: a schema sketched in five minutes of honest thought teaches more than five borrowed ones. The [design drills](design.md) exist because class design is a *skill*, not a syntax fact.

## Pacing (Week 15, two sessions)

- **Session 15.1** — Lessons 1–2 + Exercises Part A + [Lab 1 (BankAccount)](labs.md). Encapsulation and constructors are the whole conceptual load of the module; the rest is practice.
- **Session 15.2** — Lesson 3 + design drills + one lab of your choice + start the mini-project.
- **Mini-project** — finish after Session 15.2; it is the capstone rehearsal for Unit 16.

## Self-check — you are ready for Unit 16 when…

- [ ] You can say why `mark` lives under `private` *in your own words*, without the word "best practice"
- [ ] You can write a class's constructor with a member initializer list and say why it beats assignment in the body
- [ ] You can mark every member function `const` that can be — and justify the ones that can't
- [ ] You can explain, with a diagram, why `Roster` has-a `Student` but *is not* a `Student`
- [ ] You have refactored a procedural program into classes and can name what got better

## Where this leads

Unit 16's capstone (Contact Management System) is this module's mini-project with a new skin — same classes, same file contract, more features. The vocabulary you built here (`private`, constructors, `const`, composition) is exactly the vocabulary every data-structures course assumes. Inheritance waits outside the door; you don't need it yet.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
