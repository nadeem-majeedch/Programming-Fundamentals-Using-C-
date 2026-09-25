---
title: "Unit 11 — Strings & Text Processing"
description: "Character arrays vs std::string, the full std::string toolkit, char-by-char processing, conversions, and text analysis."
---

# Strings — Working with Text

> [← Course home](../index.md) · [← Arrays module](../arrays/index.md) · Unit 11/16 · [Syllabus](../syllabus.md#stage-d-algorithms-and-data-units-10-12)

You've handled text at the edges — `getline`, the [mixing trap](../cpp-io/lesson-3-getline.md), one string method in a challenge. This unit puts text at the centre: the two ways C++ holds it, the `std::string` toolkit in full, and character-by-character processing — the foundation for every analyzer, validator, and parser to come.

## In this module you will learn

- the **conceptual difference** between character arrays (C-strings) and `std::string` — and why the course standardizes on `std::string`
- creation, input (`>>` vs `getline`), `length`, **indexing**, concatenation, comparison
- **searching** (`find` + `npos`) and **substring** (`substr` + the length-not-index rule)
- **modification**: insert, erase, replace
- character processing with `<cctype>`: classify and convert chars
- conversion basics (string ↔ number), and the common mistakes gallery

## Module map

| Page | What's inside |
| --- | --- |
| [Lesson 1 — Two ways to hold text](lesson-1-two-ways.md) | chars, character arrays, `std::string`, creation, input, getline |
| [Lesson 2 — Measuring, indexing, joining, comparing](lesson-2-indexing-comparison.md) | `length`, indexing + traversal, concatenation, comparison |
| [Lesson 3 — Finding, cutting, changing](lesson-3-find-modify.md) | `find` + `npos`, `substr`, `insert`/`erase`/`replace`, `<cctype>` processing |
| [Lesson 4 — Conversions and mistakes](lesson-4-conversions-mistakes.md) | string↔number conversion, the common mistakes gallery |
| [Exercises](exercises.md) | 26 exercises with separated solutions (S1–S26) |
| [Debugging](debugging.md) | 10 seeded string bugs |
| [Predictions](predictions.md) | 10 output/trace problems, answers separated |
| [Challenges](challenges.md) | 10 challenges with separated solutions |
| [Labs](labs.md) | 7 text labs, each with solution + explanation |
| [Mini-project](miniproject.md) | The Text Analysis Toolkit |

## Try it yourself first

Same rule as every module: **attempt 15 minutes before opening any solution**. Strings add one habit to the pre-code routine: **write out the boxes** — a string is a row of chars with a length, and drawing `"cat"` as `c·a·t` with indices 0, 1, 2 turns most off-by-one and boundary bugs into things you can see.

## Pacing

Unit 11 spans one week (2 sessions):

- **Session 11.1** — Lessons 1–2 + Ex 1–13 · Lab 1 or 2
- **Session 11.2** — Lessons 3–4 + Ex 14–26 · one analysis lab + the mini-project

## What comes next

The [Files module](../files/index.md) applies this entire toolkit to *files* — reading and writing lines is `getline` at scale. And the password/validator labs here are the direct ancestors of input-handling in every later project.

## Checklist

- [ ] I can explain what a character array is, what a `std::string` is, and why the course uses `std::string`
- [ ] I can create, read (`>>` and `getline`), measure, index, and traverse strings
- [ ] I can concatenate and compare strings — and know the comparison rules
- [ ] I can search with `find`/`npos` and extract with `substr` (length, not index!)
- [ ] I can modify strings with insert/erase/replace
- [ ] I can classify and convert characters with `<cctype>`
- [ ] I can convert between strings and numbers — and know the common string mistakes
