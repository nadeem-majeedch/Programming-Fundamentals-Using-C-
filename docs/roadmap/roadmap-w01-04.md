---
title: "Roadmap — Weeks 01–04: Foundations"
description: "Sessions 1.1–4.2: your first program, data & arithmetic, input & output, and decisions — each with prerequisites, objectives, concepts, reading, examples, exercises, lab, challenge, self-study time, and completion checklist."
---

# Weeks 01–04 — Foundations (Stage A)

> Four weeks from "never programmed" to writing interactive decision-making
> programs. [← Roadmap home](index.md) · [Weeks 5–8 →](roadmap-w05-08.md)

---

## Week 1 — Your first program

### Session 1.1 — What a program is, and your first compile

| Part | Details |
| --- | --- |
| **Prerequisites** | none — this is the start; only a computer and curiosity |
| **Learning objectives** | explain what a compiler does; run the edit–compile–run cycle; write, compile, and run a Hello-world program; read your first compiler errors without panic |
| **Concepts** | source code, compiler, executable, `main()`, `cout`, statements, the compile command and its flags |
| **Recommended reading** | [Getting Started lesson](../getting-started/getting-started-lesson.md) (sections: what is C++, compiler, source→executable) · [First-program exercise](../getting-started/first-program-exercise.md) |
| **Examples to study** | [Getting Started starter](../getting-started/starter/) · Unit 01 [Session 1.1](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md) examples · [Unit 01 examples](../units/unit-01-introduction-to-programming-and-cpp/examples/) |
| **Exercises** | [Getting Started exercises](../getting-started/getting-started-exercises.md) E1–E5 · [Unit 01 exercises](../units/unit-01-introduction-to-programming-and-cpp/exercises.md) (concept checks) |
| **Lab/practice** | [Getting Started lab](../getting-started/getting-started-lab.md) — first session, first 60 minutes |
| **Challenge** | make Hello-world fail three different ways (remove a semicolon, misspell `cout`, break a quote) — read each error and write down what the compiler was trying to tell you |
| **Estimated self-study time** | 60 min (compile practice + error reading) |
| **Completion checklist** | ☐ compiler installed ([setup checklist](../getting-started/setup-checklist.md)) ☐ Hello-world compiles and runs ☐ 3 deliberate errors produced and understood ☐ [toolchain sanity check](../toolchain/) passes |

### Session 1.2 — Program anatomy and clean output

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 1.1 — you can compile and run |
| **Learning objectives** | annotate every line of a small program; chain `cout` output; use `\n` and `endl` correctly; begin reading error messages systematically |
| **Concepts** | `#include`, namespaces and `using namespace std;`, `return 0`, comments, string literals, escape sequences |
| **Recommended reading** | [C++ Foundations Lesson 1 — A Program's Shape](../cpp-foundations/lesson-1-structure.md) · [Unit 01 Session 1.2](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.2.md) |
| **Examples to study** | Unit 01 [examples](../units/unit-01-introduction-to-programming-and-cpp/examples/) (anatomy + output programs) · [Getting Started lesson examples](../getting-started/getting-started-lesson.md) |
| **Exercises** | [Unit 01 exercises](../units/unit-01-introduction-to-programming-and-cpp/exercises.md) (output section) · [C++ Foundations exercises](../cpp-foundations/exercises.md) (structure part) |
| **Lab/practice** | [Unit 01 Lab 01](../units/unit-01-introduction-to-programming-and-cpp/labs/lab-01.md) |
| **Challenge** | [C++ Foundations challenges](../cpp-foundations/challenges.md) — structure entries |
| **Estimated self-study time** | 60 min |
| **Completion checklist** | ☐ can annotate a program line by line ☐ can predict simple `cout` chains on paper ☐ Lab 01 done vs solution ☐ [W01 quiz](../units/unit-01-introduction-to-programming-and-cpp/quiz.md) ≥ 90% |

---

## Week 2 — Data & arithmetic

### Session 2.1 — Variables, types, and constants

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 1 — programs compile and run |
| **Learning objectives** | declare and initialize `int`, `double`, `char`, `bool`; choose sensible names; use `const` for fixed values; explain declaration vs initialization |
| **Concepts** | types, literals, identifiers and naming conventions, `const`, declaration vs initialization vs assignment |
| **Recommended reading** | [C++ Foundations Lesson 2 — Data](../cpp-foundations/lesson-2-data.md) (first half) |
| **Examples to study** | Lesson 2's worked examples — type each and modify one thing |
| **Exercises** | [C++ Foundations exercises](../cpp-foundations/exercises.md) — data part · [Practice Bank B-01–B-10](../practice/beginner.md) (variables) |
| **Lab/practice** | [C++ Foundations lab](../cpp-foundations/lab.md) — first variation |
| **Challenge** | [Practice Bank B-07](../practice/beginner.md) — the three-variable swap dance |
| **Estimated self-study time** | 60 min |
| **Completion checklist** | ☐ all four base types used in one program ☐ 10 Bank problems attempted ☐ can explain `const`'s two benefits in your own words |

### Session 2.2 — Operators, precedence, and conversion

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 2.1 |
| **Learning objectives** | use arithmetic, compound assignment, increment/decrement; predict expressions with precedence; explain integer division, remainders, and implicit vs explicit conversion |
| **Concepts** | operator precedence and associativity, `/` vs `%`, integer vs floating division, implicit conversion, explicit casting, common type mistakes |
| **Recommended reading** | [C++ Foundations Lesson 3 — Operators](../cpp-foundations/lesson-3-operators.md) · [Lesson 4 — Conversion](../cpp-foundations/lesson-4-conversion.md) |
| **Examples to study** | both lessons' worked examples · [C++ Foundations predictions](../cpp-foundations/predictions.md) (attempt before key) |
| **Exercises** | [Practice Bank B-02, B-05, B-09](../practice/beginner.md) · [C++ Foundations debugging](../cpp-foundations/debugging.md) D1–D3 |
| **Lab/practice** | [C++ Foundations lab](../cpp-foundations/lab.md) — complete with variations |
| **Challenge** | [Practice Bank B-10](../practice/beginner.md) — the expression evaluator |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ [predictions](../cpp-foundations/predictions.md) ≥ 8/10 before the key ☐ 3 debug hunts diagnosed ☐ Lab variations done ☐ [W02 quiz](../cpp-foundations/quiz.md) ≥ 90% |

---

## Week 3 — Input & output

### Session 3.1 — cin and the input buffer

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 2 — variables and operators fluent |
| **Learning objectives** | read values with `cin >>`; explain the whitespace rules; read multiple values; validate failed reads with `fail()`/`clear()`/`ignore()` |
| **Concepts** | `cin`, extraction operator, whitespace skipping, multiple inputs, the input buffer, stream fail state |
| **Recommended reading** | [C++ I/O Lesson 2 — cin and the Buffer](../cpp-io/lesson-2-cin.md) |
| **Examples to study** | Lesson 2's worked examples · [cpp-io traces](../cpp-io/traces.md) |
| **Exercises** | [Practice Bank B-11–B-20](../practice/beginner.md) (I/O set) · [cpp-io exercises](../cpp-io/exercises.md) (cin part) |
| **Lab/practice** | [cpp-io labs](../cpp-io/labs.md) — temperature conversion desk |
| **Challenge** | [Practice Bank B-12](../practice/beginner.md) — half-up rounding |
| **Estimated self-study time** | 60 min |
| **Completion checklist** | ☐ can predict buffer behavior on paper ☐ I/O Bank problems attempted ☐ validation pattern (fail→clear→ignore) used once from memory |

### Session 3.2 — getline, formatting, and the mixing trap

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 3.1 |
| **Learning objectives** | read whole lines with `getline`; mix `>>` and `getline` correctly; format output with `fixed`, `setprecision`, `setw`; recognize the classic input mistakes on sight |
| **Concepts** | `getline`, `cin.ignore()`, output formatting, field widths, common input mistakes gallery |
| **Recommended reading** | [C++ I/O Lesson 3 — getline and the Mixing Trap](../cpp-io/lesson-3-getline.md) · [Lesson 1 — cout](../cpp-io/lesson-1-cout.md) (skim — most was Week 1–2) |
| **Examples to study** | Lesson 3's trap gallery — reproduce two of the mistakes deliberately, then fix them |
| **Exercises** | [cpp-io exercises](../cpp-io/exercises.md) (getline + formatting parts) · [Practice Bank B-11, B-13, B-15](../practice/beginner.md) |
| **Lab/practice** | [cpp-io labs](../cpp-io/labs.md) — student information system + billing calculator |
| **Challenge** | [cpp-io challenges](../cpp-io/challenges.md) — first three |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ can explain *why* `getline` after `>>` fails (the buffered newline) ☐ two labs completed ☐ [cpp-io debugging](../cpp-io/debugging.md) D1–D2 ☐ [W03 quiz](../self-assessment/weeklies-1.md) ≥ 90% |

---

## Week 4 — Decisions

### Session 4.1 — if, else, and compound conditions

| Part | Details |
| --- | --- |
| **Prerequisites** | Weeks 2–3 — expressions and input fluent |
| **Learning objectives** | write `if`/`else`/`else-if` ladders; build compound conditions with `&&`/`||`/`!`; test boundaries deliberately (the `>` vs `>=` trap); read a flowchart into an if-ladder |
| **Concepts** | boolean expressions, comparison and logical operators, short-circuit evaluation, boundary conditions, validation guards |
| **Recommended reading** | [Decisions Lesson 1 — Branches](../decisions/lesson-1-branches.md) · [Lesson 2 — Conditions and Boundaries](../decisions/lesson-2-conditions.md) |
| **Examples to study** | both lessons' worked examples · [decisions predictions](../decisions/predictions.md) |
| **Exercises** | [Practice Bank B-21–B-26](../practice/beginner.md) · [decisions exercises](../decisions/exercises.md) (first part) |
| **Lab/practice** | [decisions labs](../decisions/labs.md) — grading system + age/category classification |
| **Challenge** | [Practice Bank B-23](../practice/beginner.md) — the full leap-year rule |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ boundary test cases written for every decision ☐ two decision labs done ☐ predictions ≥ 8/10 |

### Session 4.2 — switch, menus, and requirements→decisions

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 4.1 |
| **Learning objectives** | write `switch` statements (and know when an if-ladder is better); build a repeat-until-quit menu with `do-while`; convert written requirements into decision tables and then into C++ |
| **Concepts** | `switch`/`case`/`break`/`default`, fallthrough, the conditional operator `?:`, nested if, decision tables, requirements-to-logic translation |
| **Recommended reading** | [Decisions Lesson 3 — Switch](../decisions/lesson-3-switch.md) · [Lesson 4 — Requirements to Decisions](../decisions/lesson-4-requirements-to-decisions.md) |
| **Examples to study** | Lesson 4's requirements walkthrough — follow the table→pseudocode→C++ path yourself on paper first |
| **Exercises** | [decisions exercises](../decisions/exercises.md) (remaining) · [decisions debugging](../decisions/debugging.md) D1–D3 · [Practice Bank B-27–B-30](../practice/beginner.md) |
| **Lab/practice** | [decisions labs](../decisions/labs.md) — electricity billing + cinema ticket pricing |
| **Challenge** | [decisions challenges](../decisions/challenges.md) — first two |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ one requirement translated table→code without peeking ☐ 3 debug hunts ☐ **[Stage A checkpoint](index.md): W04 quiz ≥ 90% and all four weekly quizzes closed** — Stage B unlocks |

---

**Next:** [Weeks 05–08 — Control flow and functions →](roadmap-w05-08.md) · [Roadmap home](index.md)
