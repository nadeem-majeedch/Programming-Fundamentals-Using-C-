---
title: "C++ Input and Output"
description: "cout, cin, endl, formatting with iomanip, whitespace, getline, mixing >> and getline, input validation basics — with traces, predictions, debugging, 24 exercises, 10 challenges, and 5 lab scenarios."
---

# C++ Input and Output

> The conversation module · ~6–8 h of study + practice · [← Course home](../index.md)

## What this module is

A program that never talks to anyone is a very expensive way to heat the
room. This module teaches the two directions of that conversation:

- **Output** — `std::cout`, `'\n'` vs `endl`, and *formatted* output
  (columns, decimals, fill characters) with `<iomanip>`
- **Input** — `std::cin` and how `>>` really behaves with whitespace,
  multiple inputs on one line, `getline()` for whole lines, the famous
  trap of **mixing `cin >>` and `getline`**, and input-validation basics

Every lesson keeps the four beats: **plain-language explanation → syntax →
worked example → explanation of the example → practice pointer**.

## Try-first protocol (same as always)

Traces, predictions, exercises, and labs all include or reference full
answers — attempt, write, compile *before* opening them. The rule and why:
[Try It Yourself](../problem-solving/index.md#try-it-yourself-before-looking-at-the-solution).

## The module map

| # | Lesson | Covers |
| --- | --- | --- |
| 1 | [Output: `cout` and Formatting](lesson-1-cout.md) | `cout` · `<<` · `endl` vs `'\n'` · multiple outputs · `<iomanip>`: `setw`, `left`/`right`, `setfill`, `fixed`, `setprecision` |
| 2 | [Input: `cin` and the Buffer](lesson-2-cin.md) | `cin` · `>>` · whitespace rules · multiple inputs · the input buffer · validation basics (`fail`, `clear`, `ignore`) |
| 3 | [Lines: `getline` and the Mixing Trap](lesson-3-getline.md) | `getline()` · why `>>` stops at spaces · the leftover `'\n'` · `cin >> ws` · `cin.ignore` · common input mistakes gallery |

| Practice | Items | Format |
| --- | --- | --- |
| [Traces](traces.md) | **5** | hand-run programs with given input, build the trace table |
| [Output predictions](predictions.md) | **12** | read code, write the output, then check |
| [Exercises](exercises.md) | **24** | concept → predict → code, graded |
| [Debugging](debugging.md) | **10** | find & fix seeded IO bugs, hint-laddered |
| [Challenges](challenges.md) | **10** | ★–★★★ open problems, no solutions |
| [Labs](labs.md) | **5 scenarios** | student info · billing · temperature · travel · utility bill — full briefs + solutions |

Suggested rhythm (alongside [How to Study](../how-to-study.md)): one lesson
per day with its practice; traces + predictions on day 4; exercises +
debugging on days 5–6; one lab per day on days 6–10; challenges whenever
you feel dangerous.

## Prerequisites and where this fits

You need the toolkit from the
[C++ Foundations module](../cpp-foundations/index.md) (types, operators,
conversions) and the habits from
[Problem-Solving](../problem-solving/index.md). This module is the deep
dive for [Unit 03](../syllabus.md#stage-a-foundations-units-1-3); after it,
Unit 04 (decisions) and Unit 05 (loops) turn the validation "borrowed
patterns" from Lesson 2 into proper control flow.

---

*[← Course home](../index.md) · [Lesson 1 — Output](lesson-1-cout.md)*
