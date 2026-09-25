---
title: "Lesson 2 — The Debugger, Assertions, and the Testing Discipline"
description: "Breakpoints, stepping, and variable inspection in any tool; assert as an executable comment; test cases, boundary tests, invalid-input tests, and regression testing."
---

# Lesson 2 — The Debugger, Assertions, and Testing

> [← Module home](index.md) · [← Lesson 1 — Errors and diagnostics](lesson-1-errors-diagnostics.md) · [Lesson 3 — Better code →](lesson-3-better-code.md)

## In this lesson you will learn

- what a **debugger** is and the four moves that matter: breakpoint, step over, step into, inspect
- how the same four moves look in gdb, lldb, and VS Code — the concepts transfer, the keys don't
- `assert` — a comment the machine enforces
- the testing discipline: test cases, **boundary tests**, **invalid-input tests**, and **regression testing**

---

## 1. What a debugger is

A debugger runs your program under supervision: you can **pause** it at a chosen line, **execute** it step by step, and **look at** every variable's value while it's paused. That's the whole tool. Everything else is convenience.

Why bother, when Lesson 1's printouts work? Because the debugger shows **every** variable at **every** step without editing the code — no label-typed printouts, no recompiles, no forgotten debug lines. After a week of use you will stop writing most diagnostic prints.

### The four moves

| Move | What it does | When to use it |
| --- | --- | --- |
| **Breakpoint** | "Stop here, before this line runs" | Placed at the entry to the suspicious function (not mid-theory — you need to watch the state build) |
| **Step over** (`F10`) | Run the next line; if it calls a function, run the *whole* function | The everyday move — you follow your code's flow without descending into `cout`'s internals |
| **Step into** (`F11`) | Run the next line; if it calls *your* function, pause at its first line | When the bug might be *inside* the called function |
| **Inspect** | While paused: read any in-scope variable's value | Constantly — between every step |

(There is also **step out** — finish the current function and pause after it — and **continue** — run to the next breakpoint. You'll use them naturally.)

### The same four moves in three tools

**gdb** (command line — Linux/Windows-MinGW; compile with `-g` first!):

```text
g++ -std=c++17 -g -Wall buggy.cpp -o buggy      # -g embeds debug symbols
gdb ./buggy
  break 14          # breakpoint at line 14       (b 14)
  run               # start, stops at the break   (r)
  next              # step over                   (n)
  step              # step into                   (s)
  print sum         # inspect                     (p sum)
  print i           # (p i)
  continue          # run to next breakpoint      (c)
  quit              #                             (q)
```

**lldb** (macOS default): same workflow, spelled `breakpoint set --file buggy.cpp --line 14`, `run`, `next`, `step`, `frame variable`, `continue`. Concepts identical; vocabulary different.

**VS Code** (all platforms): install the C/C++ extension, press `F5` (choose g++/clang++ build), click left of a line number to set a breakpoint, then use the floating toolbar — *step over/into/out, continue* — while the **Variables panel** shows every local live, updating as you step. This is the gentlest interface and the one this course recommends; the other two are what you'll meet on servers and in exams.

> **The `-g` flag is the whole secret.** Without it the debugger steps through machine soup. Debug builds: `-g`, no optimization. Release builds: `-O2`, no `-g`. Never debug an optimized build — the compiler may rearrange lines to make them faster, and the debugger will honestly report the *rearranged* program.

**A worked scenario.** The average of `{80, 90}` prints as 80. Set a breakpoint at the loop; step; inspect: after the loop, `total = 170`, `count = 2` — but the dividing line shows `total / count` computing `85`... which prints as 80? Re-inspect at the print line: the printed *variable* is `avgRounded`, set earlier. Stepping found in thirty seconds what printouts would have found eventually — and it found it by watching two variables change in time, which prints do poorly.

---

## 2. Assertions — comments the machine enforces

```cpp
#include <cassert>

double average(const int a[], int n) {
    assert(n > 0);                      // the contract, stated and enforced
    ...
}
```

An **assertion** states a condition that *must* be true at that point if your program is correct. If it's false, the program stops immediately with the file, line, and condition — converting a silent corruption into a loud, located failure.

- **What belongs in an assert:** *internal* invariants — things that are true if the program's own code is right (`n > 0` because every caller is required to guarantee it; `index < size` at the top of a helper).
- **What does not:** *user input* handling — a user who types a bad value should get a polite re-prompt, not a crashed program. Validation belongs in the input code (the Decisions module's guard chains); asserts guard *inside* the machine.
- **The bonus:** asserts are self-documenting. `assert(n > 0)` tells the next reader a rule the prose comment could only suggest — and unlike prose, it's checked on every run.
- **NDEBUG:** compiling with `-DNDEBUG` removes all asserts from the program — useful for shipping; irrelevant while studying (keep yours active).

**The habit to build:** every time a debugging session ends with "ah — that variable was out of range," ask whether an `assert` at the function's front door would have caught it instantly. Usually yes. Add it. That is the lesson's cheapest form of progress.

---

## 3. The testing discipline

A **test case** is a *named input* with an *expected output*, chosen in advance — before you run anything. Running the program and nodding at whatever appears is not testing; testing is comparing against an oracle you wrote first.

### The three families every function needs

| Family | Question | Examples for `grade(int mark)` (A ≥ 90, B ≥ 80…) |
| --- | --- | --- |
| **Normal cases** | Does the ordinary middle work? | 95 → A, 72 → C |
| **Boundary tests** | Does each *edge between behaviours* land on the right side? | 90 → A, 89 → B, 100 → A, 0 → F — the **>` vs `>=` frontier, tested from both sides** |
| **Invalid-input tests** | What happens on garbage? | −1 → error message, 101 → error message, non-numeric → handled |

Boundary testing is where correctness lives. Bugs cluster at edges: 0 and 1 (empty and one element), n−1 and n (last index and first overrun), the exact threshold, the empty string. The professional reflex is mechanical: **every `>`, `>=`, `<`, `<=` in your code marks a boundary — test both sides of each.** The Algorithms module's sort tests (empty, one element, all equal, sorted, reverse) were exactly this family applied to sorting.

Invalid-input tests matter for a different reason: they exercise the *defensive* code paths, which normal tests never execute. Untested error handling is error handling that doesn't work — you just haven't met its bug yet.

### Regression testing — the memory that makes fixes stick

**Regression testing** means: every bug you fix contributes its exposing test case to a permanent table, and *all* accumulated tests re-run after every change. The name is literal — testing against re-*gression*, the old bug crawling back.

The student-scale version (from the Functions module's self-judging drivers, grown up):

```cpp
// A regression table is just rows of (input, expected, got, PASS/FAIL).
// Keep it in a test-driver file for each project; re-run it after every fix.
```

The habit scales: three projects from now, your table is 40 rows; a "fix" that breaks row 17 announces itself in seconds. The alternative — fix, spot-check, ship — is how software accumulates silent rot.

> **The rule tying Lessons 1–2 together:** *a fix without a test is a wish.* If the bug you fixed can't fail your test table, the table is incomplete — add the row before you close the session.

---

## Check yourself

- Your program works for sorted input and fails on input with one duplicate at the end. Which test family was missing? (Normal cases covered the ordinary; this is a boundary/special-structure case — your edge list was too short.)
- Why must invalid-input tests exist even though "the program shouldn't get invalid input"? (Because the defensive paths that *handle* them are code too — and the only code never exercised by normal tests.)
- What does `-DNDEBUG` do, and when would you want it? (Removes asserts from the build — for shipped binaries, not for study.)

## Where next

- [Lesson 3 — Writing better C++ →](lesson-3-better-code.md): the bugs you never write.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
