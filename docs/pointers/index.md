---
title: "Unit 13 — Pointers & Dynamic Memory"
description: "Addresses, pointers, references, pointers with functions and arrays, new/delete, dynamic arrays, and the safety rules for memory."
---

# Pointers & Dynamic Memory — Addresses, Arrows, and Ownership

> [← Course home](../index.md) · [← Strings module](../strings/index.md) · Unit 13/16 · [Syllabus](../syllabus.md#stage-e-memory-and-objects-units-13-15)

Every variable you have ever made lives *somewhere* in memory. This unit lifts the floor: what memory really is, what an address is, and the two tools that use them — **pointers** (a variable that holds an address) and **references** (an alias for a variable). Then the grown-up part: **dynamic memory**, where your program asks the operating system for boxes at runtime with `new` and gives them back with `delete` — and the three classic ways to hurt yourself doing it (leaks, dangling pointers, invalid access), with the safety rules that prevent all three.

This is the unit students fear. It doesn't need to be feared — it needs to be **drawn**. Every lesson here runs on memory diagrams, and the standing rule of this module is: **if you haven't drawn the boxes and arrows, you're not working on the problem — you're guessing.**

## In this module you will learn

- what memory is, what an **address** is, and how to see both with `&` (address-of)
- **pointer declaration**, initialization, the **dereference** operator `*`, and `nullptr`
- **pointer modification** — re-pointing, and `*p` used as a *lvalue* (writing through the arrow)
- **references** — the alias — and the honest **references vs pointers** decision
- **pointers with functions**: out-parameters, `const` pointers-to-const, in/out parameters
- **pointers with arrays**: the array-to-pointer conversion, `arr[i]` as `*(arr + i)`, traversal with a pointer
- **dynamic memory**: `new`, `delete`, **dynamic arrays** sized at runtime, `delete[]`
- the three failure families — **memory leaks**, **dangling pointers**, **invalid memory access** — and each one's prevention rule
- **ownership at an introductory level**: one owner per allocation, and why that single idea prevents most bugs

## Module map

| Page | What's inside |
| --- | --- |
| [Lesson 1 — Memory and addresses](lesson-1-memory-addresses.md) | the numbered street, `&` and `*`, declaration, initialization, `nullptr` |
| [Lesson 2 — References and functions](lesson-2-references-functions.md) | pointer modification, references, refs vs pointers, out-parameters |
| [Lesson 3 — Arrays and dynamic memory](lesson-3-arrays-dynamic.md) | pointers with arrays, `new`/`delete`, dynamic arrays, leaks, dangling, ownership |
| [Exercises](exercises.md) | 20 guided exercises with separated solutions (S1–S20) |
| [Debugging](debugging.md) | 10 seeded memory bugs, with the safety-rule fix list |
| [Tracing](tracing.md) | 10 memory-tracing exercises — draw the diagrams, answers separated |
| [Challenges](challenges.md) | 10 challenges with separated solutions |
| [Labs](labs.md) | 4 labs that practice pointers *safely* — printed diagrams, no segmentation-fault roulette |
| [Mini-project](miniproject.md) | The Quiz Runner — a dynamically-sized records app |

## Try it yourself first

Same rule as every module: **attempt 15 minutes before opening any solution** — with one addition. For every pointer exercise, the first deliverable is not code. It is **the diagram**: one box per variable, the address written above each box, one arrow per pointer. The reference solution diagrams in [tracing.md](tracing.md) are drawn in exactly the style your own should be.

<a name="safety-rules"></a>
## ⚠️ Safety rules for this unit

Pointers are the first tool in this course that can crash the program *outside* your logic. These rules are non-negotiable, and every lab and exercise is built to stay inside them:

1. **Never dereference uninitialized.** A pointer with garbage points somewhere random. Initialize at birth: `int* p = nullptr;` or `int* p = &x;`.
2. **Check for `nullptr` before dereferencing.** A function that receives a pointer treats "might be null" as the normal case.
3. **Never use memory after `delete`.** Set the pointer to `nullptr` on the same line — the [Lesson 3 idiom](lesson-3-arrays-dynamic.md#delete).
4. **Every `new` gets exactly one `delete`.** Two deletes corrupt; zero deletes leak. Count them in pairs.
5. **Prefer the tools that can't fail this way.** `std::string`, `std::vector`, and references solve most of these problems by design. `new`/`delete` appears in this course so you understand what those tools do for you — real projects reach for it rarely.

If you follow rule 5 everywhere except the exercises in this unit, you are not cheating — you are graduating.

## Pacing

Unit 13 spans one week (2 sessions):

- **Session 13.1** — Lesson 1 + Lesson 2 to §4 + Ex 1–10 · Tracing 1–5
- **Session 13.2** — Lesson 2 §5 + Lesson 3 + Ex 11–20 · one lab · the mini-project

## What comes next

References and pointers are the vocabulary of everything left: the [Records module](../records/index.md) bundles related data into struct types, **Unit 15** builds classes — where `new`/`delete` are wrapped inside constructors and destructors so *you* stop calling them — and **Unit 16** is the capstone that assumes all of it.

## Checklist

- [ ] I can draw a variable, its address, and a pointer-to-it as boxes and arrows
- [ ] I can declare, initialize, dereference, and re-point a pointer — and explain `nullptr`
- [ ] I can decide reference vs pointer for a function parameter, and justify it
- [ ] I can explain `arr[i]` as `*(arr + i)` and traverse an array with a pointer
- [ ] I can size an array at runtime with `new[]` and release it with `delete[]` — in pairs
- [ ] I can define leak, dangling pointer, and invalid access — and state each prevention rule
- [ ] I can explain ownership in one sentence, and name the course tool for "one owner" memory
