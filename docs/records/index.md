---
title: "Unit 14 — Records & Enums (the Bridge to OOP)"
description: "struct, members, initialization, arrays of records, nested structures, passing and returning, enum and enum class — organizing related data, procedurally."
---

# Records & Enums — Organizing Related Data

> [← Course home](../index.md) · [← Pointers module](../pointers/index.md) · Unit 14/16 · [Syllabus](../syllabus.md#stage-e-memory-and-objects-units-13-15)

Since Unit 09, related data has travelled in **parallel arrays** — one array per field, indices marching in lockstep. It works, and you have felt its cost: every function needs `names[]`, `scores[]`, *and* `count`; swap one and you must swap all; forget one and the records silently lie. This unit introduces the fix: the **struct** — a type that bundles related fields into one named value — and the **enum** — a type that names the members of a small closed set.

One promise up front: this unit is **procedural**. Structs here are passive data — no member functions, no `private`, no constructors. That machinery is OOP ([Unit 15](../oop/index.md)); what you build here is the *vocabulary* OOP will formalize. Every minute spent on structs is a minute the classes lesson will spend faster.

## In this module you will learn

- why bundling beats parallel arrays — and what a **struct** actually is (a blueprint, not a box)
- declaring structure **members**, variables, and **initialization** (brace lists, member assignment, the ordering rule)
- **arrays of structures** — one array of records replacing three parallel arrays
- **nested structures** — records whose fields are records (`Date` inside `Book`)
- **passing structures to functions** (by value, by pointer, and the `const&` default) and **returning** them
- **enum** — naming a closed set — and **enum class**, the scoped, safer form
- the honest design habit: **organizing related data** before writing any logic that uses it
- the common mistakes gallery: the semicolon, the member-vs-variable confusion, the enum-input trap

## Module map

| Page | What's inside |
| --- | --- |
| [Lesson 1 — The struct](lesson-1-structs.md) | parallel arrays → records, members, dot access, initialization, arrays of records |
| [Lesson 2 — Moving records around](lesson-2-functions-nesting.md) | passing by value/pointer/`const&`, returning records, nested structures, a full worked program |
| [Lesson 3 — Enums and design](lesson-3-enums-design.md) | enum, enum class, the input trap, organizing related data, the mistakes gallery |
| [Exercises](exercises.md) | 22 exercises with separated solutions (S1–S22) |
| [Debugging](debugging.md) | 10 seeded record bugs |
| [Predictions](predictions.md) | 10 output-prediction problems, answers separated |
| [Challenges](challenges.md) | 10 challenges with separated solutions |
| [Labs](labs.md) | 6 record-keeping labs — students, employees, inventory, library, patients, registration |
| [Mini-project](miniproject.md) | The Student Record Management System |

## Try it yourself first

Same rule as every module: **attempt 15 minutes before opening any solution** — with the records habit: **before any code, write the `struct` definition and say each field out loud in one sentence** ("`gpa` — a double, 0.0–4.0, the grade average"). If you can't say the sentence, the field doesn't belong yet. Data design *is* the unit.

## Pacing

Unit 14 spans one week (2 sessions):

- **Session 14.1** — Lessons 1–2 + Ex 1–12 · Lab 1
- **Session 14.2** — Lesson 3 + Ex 13–22 · one lab · the mini-project

## What comes next

[Unit 15](../oop/index.md) turns these passive records into **classes**: the same fields move under `private`, functions attach to the data itself, constructors guarantee initialization, and `struct` vs `class` becomes a one-keyword question. The mini-project's record type is the exact blueprint refactored in the [OOP mini-project](../oop/miniproject.md) — [the Quiz Runner](../pointers/miniproject.md)'s parallel arrays were the last goodbye to the old way.

## Checklist

- [ ] I can define a struct with sensible members — and say what each field means in one sentence
- [ ] I can initialize a record with a brace list and by member assignment (and know the ordering rule)
- [ ] I can replace parallel arrays with one array of records — and feel why it's better
- [ ] I can pass records to functions (value / pointer / `const&`) and return them — and choose per the rules
- [ ] I can nest a record inside a record and traverse the dots
- [ ] I can define an enum and an enum class, and pick between them for state and validation
- [ ] I can design a record set *before* coding — and name the common struct/enum mistakes on sight
