---
title: "Unit 12 — File Handling"
description: "ifstream, ofstream, fstream, open/close/check, line-based and formatted reading, CSV data, record storage, file errors, and the common mistakes gallery."
---

# Files — Data That Outlives the Program

> [← Course home](../index.md) · [← Strings module](../strings/index.md) · Unit 12/16 · [Syllabus](../syllabus.md#stage-d-algorithms-and-data-units-10-12)

Every program you have written had one sad property: when it ended, its data vanished. A roster of 30 students, a ledger of 200 expenses — gone at exit, rebuilt by hand tomorrow. **Files** fix this: variables live in memory while the program runs; **files live on disk between runs**. This unit connects the two with *streams* — `ifstream` to read, `ofstream` to write — and teaches the discipline that keeps file programs honest: **open, check, use, close**, and read until the data runs out.

Everything you know transfers. `cin`/`cout` taught you streams in [Unit 03](../cpp-io/index.md); a file stream *is* the same idea pointed at a file. `getline` taught you line reading; file `getline` is the same function with a stream swap. Records taught you [schemas](../records/index.md); a file is just a schema written as text, line by line.

## In this module you will learn

- **files and persistent data** — what a file is, and what "persistence" buys a program
- **ofstream** (writing), **ifstream** (reading), **fstream** (both)
- **opening** and **closing** files — and **checking whether a file opened successfully** before trusting it
- **reading** and **writing** — with `<<` and `>>`, and **line-based reading** with `getline`
- **formatted reading** of mixed types from a file — and the pitfalls of mixing `>>` with `getline`
- **append mode** — adding to a file without erasing it
- **basic file errors** — missing files, permission failures, reading past the end
- **CSV-style text data** and **simple record storage** — the file formats every lab uses
- the **common mistakes gallery** — ten file bugs you can now diagnose on sight

## Module map

| Page | What's inside |
| --- | --- |
| [Lesson 1 — Streams: writing and reading files](lesson-1-streams.md) | persistence, ofstream/ifstream/fstream, open-check-close, the first full examples |
| [Lesson 2 — Reading strategies and file formats](lesson-2-reading-writing.md) | modes & append, line-based vs formatted reading, CSV files, record storage |
| [Lesson 3 — File errors and the mistakes gallery](lesson-3-errors-mistakes.md) | basic file errors, the EOF discipline, ten seeded mistakes, the complete program |
| [Exercises](exercises.md) | 18 exercises with separated solutions (S1–S18) |
| [Debugging](debugging.md) | 10 seeded file bugs |
| [Challenges](challenges.md) | 10 challenges with separated solutions |
| [Labs](labs.md) | 6 file labs — student records, expenses, inventory, marks report, contacts, transaction log |
| [Mini-project](miniproject.md) | The File-Based Student Management System |

## Try it yourself first

Same rule as every module: **attempt 15 minutes before opening any solution** — with the file habit: **before writing any file code, write the file's first two lines by hand** (in an editor, as literal text). If you can't write the exact format your program will read, your schema isn't decided yet. Files make formats *contracts* — the writer and reader must agree character for character.

<a name="safety-rules-for-this-unit"></a>
## ⚠️ Safety rules for this unit

Files can't crash your program the way pointers can — but they can *destroy your data* silently. The unit's non-negotiables:

1. **Check every open.** `is_open()` before any use, on reading *and* writing streams — silent failure is the enemy.
2. **Say what your open means.** A plain `ofstream` erases the file; `std::ios::app` appends. There is no undo.
3. **Put the read in the loop condition.** `while (getline(in, line))` — never `while (!in.eof())`.
4. **End every field write with its separator.** A format without separators is soup.
5. **Never destroy the only copy.** Rewrite pipelines back up first (or write-to-temp); append-only logs stay append-only.

## Pacing

Unit 12 spans one week (2 sessions):

- **Session 12.1** — Lessons 1–2 + Ex 1–9 · Lab 1
- **Session 12.2** — Lesson 3 + Ex 10–18 · one lab · the mini-project

## What comes next

Files close Stage D's toolkit: [Unit 15](../oop/index.md) adds classes and vectors — the Student Management System you build here becomes a class in the [OOP mini-project](../oop/miniproject.md), and its file code barely changes (the format is the contract, and contracts survive refactors).

## Checklist

- [ ] I can explain what a stream is and why files make data persistent
- [ ] I can write a file with `ofstream`, read it with `ifstream`, and use `fstream` in append mode
- [ ] I always check `is_open()` before using a file — and close it when done
- [ ] I can read a file line by line with `getline`, and tell the EOF-as-data trap from honest EOF
- [ ] I can read formatted records (`>>` with mixed types) and whole CSV lines (getline + split)
- [ ] I can define a record file format, write it, and read it back — the round trip
- [ ] I can name the ten common file mistakes — and the one-line rule that prevents each
