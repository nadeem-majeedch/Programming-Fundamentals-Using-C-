---
title: "Lesson 1 — The Four Kinds of Errors and How to Read Diagnostics"
description: "Syntax, compile, runtime, logic, and semantic errors; when each is detected; reading compiler diagnostics properly; and the systematic debugging workflow."
---

# Lesson 1 — Errors, Diagnostics, and the Debugging Workflow

> [← Module home](index.md) · [Lesson 2 — The debugger and testing →](lesson-2-debugger-testing.md)

## In this lesson you will learn

- the difference between **syntax**, **compile**, **runtime**, **logic**, and **semantic** errors — and *when* each is detected
- how to read a real compiler diagnostic: the carets, the notes, the "candidate" lists
- the systematic debugging workflow professionals actually follow

You have been meeting all of these for weeks under different names ("it doesn't compile," "it crashed," "it gives the wrong answer"). The lesson's job is to give them sharp definitions, because the *detection time* of an error determines what tools can help you.

---

## 1. The error taxonomy — classified by when the machine notices

| Kind | Detected when | Example | Who catches it |
| --- | --- | --- | --- |
| **Syntax error** | At compile time — the text violates C++'s grammar | Missing `;`, unbalanced brace, `iff (x > 0)` | The compiler, instantly; the easiest kind |
| **(Compile/semantic-type) error** | At compile time — grammar is fine, meaning is impossible | `x + "hello"` where x is int; calling an undeclared function; wrong argument count | The compiler; still easy — the message is just longer |
| **Runtime error** | While the program runs | Division by zero (integers), out-of-bounds access, infinite loop until crash, failed `new`, unhandled `stoi` | The operating system / crash — *sometimes*; often the program just misbehaves |
| **Logic error** | Never "detected" — the program runs fine and answers wrong | `avg = a + b / 2` instead of `(a + b) / 2`; `>` instead of `>=` | **Only you** — via tests, traces, or suspicion |
| **Semantic error** | Overlap term: the program does something *legal but not what you meant* | Sorting ascending when the spec said descending | Only you — the spec is the oracle |

The ordering that matters: **syntax/compile errors are caught before the program runs; runtime errors are caught during; logic and semantic errors are caught by never** — unless you test. That is why this module spends two pages on testing: the dangerous bugs are precisely the ones no machine will ever flag.

> **The beginner's reframe.** Beginners fear compile errors and tolerate wrong output. Professionals have the opposite attitude: a compile error is *free* (fixed in seconds, costs nothing), a wrong answer that reaches a user is *expensive* (costs trust). Welcome compiler strictness; distrust programs that "seem to work."

### Why the compiler's line number sometimes lies

A missing `}` at the end of a function is often reported *many lines later*, where the compiler finally gave up expecting it. A missing `;` is reported on the line *after* the one you're staring at. Rule: **the reported line is where the compiler became confused, not necessarily where you slipped.** When a line looks perfect, check the line above and the enclosing block.

---

## 2. Reading compiler diagnostics — a real one, dissected

```text
marks.cpp: In function 'int main()':
marks.cpp:12:25: error: no match for 'operator<<' (operand types are
    'std::ostream' {aka 'std::basic_ostream<char>'} and '<unresolved overloaded function type>')
   12 |     cout << "Grade: " << grade;
      |            ~~~~~~~~~~ ^~ ~~~~~
      |            |               |
      |            std::ostream    <unresolved overloaded function type>
marks.cpp:8:7: note: declared here
    8 | int grade(int m) { ... }
      |     ^~~~~
```

Anatomy, piece by piece:

| Piece | Meaning | How to use it |
| --- | --- | --- |
| `marks.cpp:12:25` | File, **line 12, column 25** | Go there — but re-read the whole statement |
| `error:` | Fatal: no program produced | Fix errors before worrying about warnings |
| The message text | What failed and in what *types* | "no match for operator<<" = nothing can print this thing |
| The caret line `^~` | Points at the exact tokens | Column 25 → `grade` is the culprit |
| `note:` | Supporting evidence | "declared here" — the compiler found *a* `grade`, just not a printable one |
| `warning:` | Legal but suspicious | **Treat as errors**: compile with `-Wall -Wextra` |

**The real bug in the example:** `grade` names a *function*, and the programmer meant to call it: `grade(mark)`. The message "unresolved overloaded function type" is the compiler's way of saying "you handed me a function, not a value." The lesson generalizes: when a diagnostic mentions a type you didn't expect — a function where a value should be, a `double` where you wrote an `int` — the bug is a **mismatch between your mental model and the text**, and the types in the message are the x-ray.

### The three-habits ritual

1. **Fix the first error, ignore the rest, recompile.** Later errors are often dominoes of the first. (But: after fixing, if the *next* error is far away, skim all remaining errors first — sometimes error #1 is a stray brace and errors #2–9 are noise.)
2. **Read the note lines.** Beginners read the error line and stop. The notes often contain the diagnosis.
3. **Keep warnings at zero.** `-Wall -Wextra` catches the classic logic slips (uninitialized variables, `=` in conditions, unused results) before you ever run. Warnings you ignore train you to ignore warnings; warnings at zero make the next real warning *loud*.

The course's [compiler error catalogue](../toolchain/compiler-errors.md) has the full walk-in gallery of common diagnostics; this lesson teaches you to *read any* diagnostic, that page lists the frequent guests.

---

## 3. The debugging workflow — seven steps, in order

When behaviour surprises you, resist the urge to change code. Run the loop:

1. **Reproduce.** Find the exact input that triggers the bug. If it's intermittent, that fact is itself a clue (uninitialized variable? boundary at specific value?).
2. **Shrink.** Reduce the input until it's minimal (7 numbers instead of 700). Small bugs are visible bugs.
3. **Form one hypothesis.** "The average divides by count before count is validated." Say it as a sentence. If you can't say it, you're guessing — go back to tracing.
4. **Test the hypothesis cheaply.** A `cout` of the suspect value, a hand trace of the loop, an `assert` (Lesson 2). One change, one run.
5. **Fix the cause, not the symptom.** `if (x == 5) x = 4;` "fixes" an off-by-one downstream; the cause is the off-by-one. Symptom patches mutate into new bugs.
6. **Re-test: old tests + new test.** The fix must not break what worked. Add the exact case that exposed the bug to your test table.
7. **Log it.** One line in your **bug journal**: symptom → cause → the rule you'll follow to never write it again. (More in Lesson 3 — this journal is the highest-leverage habit in the course.)

### The three low-tech tools that still do most of the work

- **The explanatory printout** — `cout << "i=" << i << " sum=" << sum << "\n";` at the suspect point. Print *labels*, never bare values (a bare `42` tells you nothing at 3 a.m.). Delete prints when done — a forgotten one corrupts the next hour's output.
- **The hand trace** — the trace-table habit from the problem-solving module, applied to the failing input. If the trace on paper matches the buggy output, your mental model of the code is wrong somewhere; find where. If the trace *disagrees* with the machine, the difference *is* the bug.
- **The rubber duck** — explain the code line by line, aloud, to anything. The act of narrating forces assumption-checking; most logic bugs confess mid-sentence.

When those three stall, bring in the debugger (Lesson 2) — which is not a last resort so much as a *faster* printout with perfect timing.

---

## Check yourself

- You flip two arguments in a function call and the program still compiles, runs, and answers wrong. Which kind(s) of error? (Semantic/logic — detected by nobody but your tests.)
- The compiler reports a missing `}` at line 60, but your function ends at line 38. Where do you look? (Inside the block that opened around line 38 — the confusion point is downstream of the slip.)
- Why fix the first error before the others? (Later diagnostics are often consequences of the first; fixing #1 may clear #2–#9.)

## Where next

- [Lesson 2 — The debugger, assertions, and testing →](lesson-2-debugger-testing.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
