---
title: "Roadmap — Weeks 05–08: Control Flow & Functions"
description: "Sessions 5.1–8.2: while loops and Project 1, nested loops, function fundamentals, and reference-based design — each with the full eleven-part session contract."
---

# Weeks 05–08 — Control Flow & Functions (Stage B)

> Repetition, then decomposition — the two powers that turn scripts into
> programs. Week 5 carries the course's first flagship project.
> [← Weeks 1–4](roadmap-w01-04.md) · [Roadmap home](index.md) · [Weeks 9–12 →](roadmap-w09-12.md)

---

<a name="week-5-loops-i-project-1"></a>

## Week 5 — Loops I — 🏁 Project 1

### Session 5.1 — while, trace tables, and sentinels

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 4 — decisions and compound conditions fluent |
| **Learning objectives** | write `while` loops with correct entry/update/exit; trace loops in a table before running; build sentinel-controlled and validation loops; recognize the infinite-loop shapes on sight |
| **Concepts** | `while`, accumulators, counters, sentinel values, input-controlled loops, infinite loops and their causes, dry-run tables |
| **Recommended reading** | [Repetition Lesson 1 — while](../repetition/lesson-1-while.md) |
| **Examples to study** | Lesson 1's worked loops — trace each in a table before compiling |
| **Exercises** | [repetition exercises](../repetition/exercises.md) (while part) · [Practice Bank B-31–B-38](../practice/beginner.md) (loops) |
| **Lab/practice** | [repetition labs](../repetition/labs.md) — Labs 1–2 |
| **Challenge** | [Practice Bank B-37](../practice/beginner.md) — running maximum from a stream |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ 5 trace tables drawn on paper ☐ 2 labs done ☐ can list the three ingredients every correct loop needs |

### Session 5.2 — do-while, validation loops, and Project 1

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 5.1 |
| **Learning objectives** | choose `do-while` when one pass is guaranteed; build re-prompting validation loops; write the Project 1 calculator with a repeat-until-quit structure |
| **Concepts** | `do-while`, menu skeletons, validation loops, program structuring for projects |
| **Recommended reading** | [Repetition Lesson 2 — for](../repetition/lesson-2-for.md) (skim ahead — for arrives next week) · [Project 1 brief](../syllabus.md) (Stage B: Electricity Bill Calculator) · [Projects collection #1](../projects/project-01-calculator.md) as the self-study rehearsal |
| **Examples to study** | Lesson 2's early examples · the project brief's sample runs |
| **Exercises** | [Practice Bank B-32, B-40](../practice/beginner.md) · [repetition debugging](../repetition/debugging.md) D1–D2 |
| **Lab/practice** | **🏁 [Project 1 — Electricity Bill Calculator](../projects/project-01-calculator.md)** — follow the milestones; use the test plan; score with the rubric |
| **Challenge** | Project 1's extension ideas (tiered tariffs, billing history) |
| **Estimated self-study time** | 120 min (project week) |
| **Completion checklist** | ☐ **Project 1 submitted to yourself: all milestones, test plan passed, rubric self-scored ≥ Proficient** ☐ re-prompt loop written from memory ☐ [W05 quiz](../self-assessment/weeklies-2.md) ≥ 90% |

---

## Week 6 — Loops II

### Session 6.1 — for, break, and continue

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 5 — while and sentinels fluent |
| **Learning objectives** | write counting `for` loops over arbitrary ranges; choose between while/for/do-while by the problem's shape; control flow with `break` and `continue` |
| **Concepts** | `for` anatomy, counting down, step sizes, `break`, `continue`, loop selection criteria |
| **Recommended reading** | [Repetition Lesson 2 — for](../repetition/lesson-2-for.md) · [Lesson 3 — break/continue/sentinels](../repetition/lesson-3-break-continue-sentinels.md) |
| **Examples to study** | both lessons' worked examples · [repetition predictions](../repetition/predictions.md) |
| **Exercises** | [Practice Bank B-33, B-34, B-36](../practice/beginner.md) · [repetition exercises](../repetition/exercises.md) (for part) |
| **Lab/practice** | [repetition labs](../repetition/labs.md) — Lab 3 |
| **Challenge** | [Practice Bank Ba-06](../practice/basic.md) — Collatz steps |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ loop-choice rule stated in your own words ☐ predictions ≥ 8/10 ☐ Lab 3 done |

### Session 6.2 — Nested loops, digits, and patterns

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 6.1 |
| **Learning objectives** | trace and write nested loops; process digits with peel loops; print shape patterns with dependent inner bounds; multiply via nested accumulation |
| **Concepts** | nested loops, inner/outer pass counting, digit processing (`% 10`, `/ 10`), pattern printing, multiplication tables |
| **Recommended reading** | [Repetition Lesson 4 — Nested Loops, Digits, and Patterns](../repetition/lesson-4-nested-digits-patterns.md) |
| **Examples to study** | Lesson 4's pattern gallery — reproduce the triangle and the table from scratch |
| **Exercises** | [Practice Bank B-39, Ba-11–Ba-20](../practice/basic.md) (patterns & digits) · [repetition exercises](../repetition/exercises.md) (nested part) |
| **Lab/practice** | [repetition labs](../repetition/labs.md) — pattern + number-properties labs |
| **Challenge** | [Practice Bank Ba-18](../practice/basic.md) — Armstrong numbers in a range |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ two patterns + one table printed without reference ☐ digit-peel loop written from memory ☐ [W06 quiz](../self-assessment/weeklies-2.md) ≥ 90% |

---

## Week 7 — Functions I

### Session 7.1 — The function machine

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 6 — loops fluent |
| **Learning objectives** | define, declare, and call functions; distinguish parameters from arguments; write `void` and value-returning functions; explain why decomposition beats one giant `main` |
| **Concepts** | function declaration/definition/call, parameters vs arguments, return values, `void`, prototypes, call flow |
| **Recommended reading** | [Functions Lesson 1 — the machine](../functions/lesson-1-machine.md) |
| **Examples to study** | Lesson 1's call-flow diagrams — trace two calls on paper, box by box |
| **Exercises** | [Practice Bank Ba-21–Ba-25](../practice/basic.md) · [functions exercises](../functions/exercises.md) (first part) |
| **Lab/practice** | [functions labs](../functions/labs.md) — first two |
| **Challenge** | [Practice Bank Ba-27](../practice/basic.md) — scope shadowing demonstration |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ two call traces drawn ☐ 5 function problems attempted ☐ 2 labs done |

### Session 7.2 — Scope, lifetime, and decomposition

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 7.1 |
| **Learning objectives** | explain local vs global scope and lifetime; write multi-function programs where `main` only coordinates; refactor an existing loop-heavy program into functions |
| **Concepts** | local variables, global variables (and why the course bans new ones), scope shadowing, top-down decomposition, main-as-coordinator |
| **Recommended reading** | [Functions Lesson 2 — scope](../functions/lesson-2-scope.md) |
| **Examples to study** | Lesson 2's refactor walkthrough |
| **Exercises** | [Practice Bank Ba-30, Ba-37](../practice/basic.md) · [functions exercises](../functions/exercises.md) (scope part) |
| **Lab/practice** | [functions labs](../functions/labs.md) — decomposition lab |
| **Challenge** | [functions challenges](../functions/challenges.md) — first two |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ one program refactored behavior-preserving ☐ can state the course's globals rule and its reason ☐ [W07 quiz](../self-assessment/weeklies-2.md) ≥ 90% |

---

## Week 8 — Functions II

### Session 8.1 — References and out-parameters

| Part | Details |
| --- | --- |
| **Prerequisites** | Week 7 — function mechanics fluent |
| **Learning objectives** | pass by reference with `&`; build multi-result functions with out-parameters; contrast pass-by-value and pass-by-reference from live examples |
| **Concepts** | reference parameters, out-parameters, value vs reference semantics, swap-through-function |
| **Recommended reading** | [Functions Lesson 3 — references & testing](../functions/lesson-3-references-testing.md) |
| **Examples to study** | Lesson 3's value-vs-reference demonstration — reproduce both versions |
| **Exercises** | [Practice Bank Ba-35, Ba-36](../practice/basic.md) · [functions exercises](../functions/exercises.md) (references part) |
| **Lab/practice** | [functions labs](../functions/labs.md) — statistics lab |
| **Challenge** | [Practice Bank Ba-38](../practice/basic.md) — factorial both ways |
| **Estimated self-study time** | 75 min |
| **Completion checklist** | ☐ swap-by-reference written from memory ☐ one multi-out-param function designed and tested |

### Session 8.2 — Overloading, default arguments, and refactoring

| Part | Details |
| --- | --- |
| **Prerequisites** | Session 8.1 |
| **Learning objectives** | overload functions by parameter list; use default arguments; test functions with drivers and stubs; complete a behavior-preserving refactor of a full program |
| **Concepts** | function overloading, default arguments, drivers, stubs, testing functions, refactoring discipline |
| **Recommended reading** | [Functions Lesson 4 — overloading & refactoring](../functions/lesson-4-overloading-refactoring.md) · [functions refactoring page](../functions/refactoring.md) |
| **Examples to study** | the refactoring page's before/after pairs |
| **Exercises** | [functions refactoring exercises](../functions/refactoring.md) · [Practice Bank Ba-28, Ba-29, Ba-39, Ba-40](../practice/basic.md) |
| **Lab/practice** | [functions labs](../functions/labs.md) — remaining labs + [functions miniproject](../functions/miniproject.md) (menu toolkit, milestones 1–3) |
| **Challenge** | [functions challenges](../functions/challenges.md) — one more |
| **Estimated self-study time** | 90 min |
| **Completion checklist** | ☐ refactor completed behavior-identical ☐ mini-project milestones 1–3 ☐ **[Stage B checkpoint](index.md): W08 quiz ≥ 90%** — Stage C unlocks |

---

**Next:** [Weeks 09–12 — Data structures and algorithms →](roadmap-w09-12.md) · [Roadmap home](index.md)
