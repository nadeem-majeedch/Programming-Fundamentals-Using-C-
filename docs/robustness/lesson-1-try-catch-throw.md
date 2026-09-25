---
title: "Lesson 1 — Errors, Exceptions, and try/catch/throw"
description: "Error vs exception, the three lines of defence, try/catch/throw anatomy, stack unwinding, the standard exception family, and robust readers compared against the validation suite."
---

# Lesson 1 — errors, exceptions, and `try`/`catch`/`throw`

> [← Module home](index.md) · [Lesson 2 — Custom exceptions and safety →](lesson-2-custom-safety.md)

## In this lesson you will learn

- the difference between an **error** (a condition) and an **exception** (the machinery that reports it)
- the anatomy of `try`, `catch`, and `throw` — and what happens between them
- **stack unwinding**: what the program does between the `throw` and the `catch`
- the **standard exception family** and when to use which member
- how the course's robust readers relate to all of this

## 1. Error vs exception — two words, two jobs

An **error** is a *condition*: the user typed `abc` where a number belonged; a file is missing; a denominator is zero. Errors exist whether or not you have any machinery to report them.

An **exception** is *C++'s machinery for announcing an error upward* — a `throw` creates an exception object, the language carries it up the call stack, and a matching `catch` receives it.

The course's first fifteen units handled errors with **return codes and guards** — and that was honest, because those tools *are* the right answer at the program's edge:

```cpp
// The validation-suite pattern (functions labs, Unit 07) — still the first line of defence:
int readIntInRange(int lo, int hi) {
    int x;
    while (!(cin >> x) || x < lo || x > hi) {   // detect
        if (!cin) { cin.clear(); cin.ignore(1000, '\n'); }  // repair
        cout << "Enter a number " << lo << "-" << hi << ": ";
    }
    return x;
}
```

So when does an error need the exception machinery instead? When the function that *detects* the problem cannot fix it, and its caller's caller's caller is the one that can. Return codes must climb hand-to-hand through every intermediate layer — each of which has to remember to check and forward them. An exception climbs by itself, through layers that do not need to care.

| | Return code / guard | Exception |
| --- | --- | --- |
| Detected by | `if` at the boundary | `throw` anywhere below |
| Travels by | hand, layer by layer | automatically, up the stack |
| Ignorable? | **Yes — silently** (the failure mode this module exists to kill) | No — an uncaught exception stops the program loudly |
| Best for | expected, handle-it-here conditions (user re-entry) | unexpected-but-planned-for failures (missing file, bad data mid-parse) |

## 2. The anatomy: try, catch, throw

```cpp
#include <iostream>
#include <string>
#include <stdexcept>
using namespace std;

// 01_anatomy.cpp — the three keywords, one story.
// Compile: g++ -std=c++17 -Wall -Wextra 01_anatomy.cpp -o anatomy

double divide(int top, int bottom) {
    if (bottom == 0)
        throw invalid_argument("divide: bottom is zero");  // 1. announce
    return (double)top / bottom;                            // 2. never reached when throwing
}

int main() {
    int a = 10, b = 0;
    try {                                        // 3. the guarded zone
        cout << divide(a, b) << "\n";
        cout << "unreachable when the throw fires\n";
    }
    catch (const invalid_argument& e) {          // 4. the reception desk
        cout << "caught: " << e.what() << "\n";  // 5. what() = the message
    }
    cout << "main continues normally\n";         // 6. life after the catch
}
```

Reading it line by line:

- **`throw invalid_argument("...")`** — builds an exception *object* (here from the standard family) and hands it to the machinery. Everything after the `throw` in that function does not run.
- **`try { ... }`** — a guarded zone. If nothing inside throws, the `catch` blocks are skipped entirely; a `try` with no throw costs almost nothing.
- **`catch (const invalid_argument& e)`** — a reception desk for one type. `const&` for the same reason every object parameter in this course is `const&`: no copy, no mutation. **`e.what()`** is the message string the thrower attached — the one piece of information that travels with the object.

**Output:**

```text
caught: divide: bottom is zero
main continues normally
```

Note what is *missing*: `unreachable when the throw fires` never printed. The `throw` didn't just report — it **vacated** the rest of the `try` block and flew out of `divide`.

## 3. Stack unwinding — what happens between throw and catch

The exception doesn't teleport. It **walks up the call stack**, and at each level it runs that level's cleanup:

```text
main ─► loadAndAverage ─► parseLine ─► stoi("abc")  ← throw!
                                          │
        cleanup: locals destroyed ────────┤  (in reverse order of creation)
        cleanup: locals destroyed ────────┤
catch in main ─────────────────────────────┘
```

Two facts to carry for the rest of your programming life:

1. **Only automatic (stack) variables get destroyed.** This is the RAII idea from the pointers and STL modules made life-or-death: a `vector`, `string`, or `unique_ptr` local cleans itself up during unwinding for free. A raw `new` without an owner **leaks** — the Debugging module's leak rule, now with a second way to spring it (see [debugging hunt D7](debugging.md)).
2. **Unwinding skips normal control flow** — no returns, no loops finishing, no `cout`s in between. Code that "must always run" (flushing a log, closing a display) cannot sit *after* the throwing call; it must live in an object's destructor or a `catch`.

## 4. The standard exception family

The standard library ships a hierarchy rooted at `exception` (all in `<stdexcept>` unless noted):

| Exception | Thrown by / for | Typical catch response |
| --- | --- | --- |
| `std::exception` | the root — catch it as a last-resort net | log, apologise, stop gracefully |
| `std::runtime_error` | errors detectable only at run time (you usually derive your own from here) | report and recover or abort |
| `std::logic_error` | *programmer* errors: broken preconditions | fix the code, not the data |
| `std::invalid_argument` | a parameter was unacceptable (`stoi("abc")` throws this) | report the bad value |
| `std::out_of_range` | index/key access outside bounds (`vector::at`, `map::at`) | report, maybe retry |
| `std::bad_alloc` *(in `<new>`)* | `new` could not allocate memory | free something, or stop |
| `std::ios_base::failure` *(in `<ios>`)* | stream failure when exceptions are enabled on a stream | rare by default — streams report via state, Lesson 2 explains why |

Two habits, from the STL module's `at()`-vs-`[]` lesson: the *checking* accessors throw these; the *fast* ones (operator`[]`, front, back) have **no contract** to check and produce undefined behaviour instead. The exception family only protects code that chose to check.

And one naming honesty note: `logic_error` for "the caller broke the contract" vs `runtime_error` for "the world misbehaved" is the split professionals argue about — in this course, **derive domain failures from `runtime_error`** and leave `logic_error` for genuinely impossible-by-construction states.

## 5. Multiple catches, catch order, and the elipses net

```cpp
try {
    process(id);                       // may throw out_of_range or invalid_argument
}
catch (const out_of_range& e) {        // most derived FIRST
    cerr << "bad id: " << e.what() << "\n";
}
catch (const exception& e) {           // the family net comes AFTER
    cerr << "unexpected: " << e.what() << "\n";
}
```

Rules the compiler will not warn you about:

- **Catch order matters.** Handlers are tried top-down, and a base-class handler (`exception`) catches every derived exception below it. Put `out_of_range` *before* `exception`, or the specific block is dead code. (Hunt [D2](debugging.md) is exactly this bug.)
- **Catch by `const&`, always.** By value slices the object (the Inheritance module's slicing rule, applied to exceptions) and copies; by non-const `&` invites accidental mutation.
- **`catch (...)`** — the three-dot net catches *anything*, including things that are not `std::exception`. It cannot name what it caught (`e.what()` is unavailable), so it is for one job only: a last-resort wall around `main` that logs and exits politely. It is not a substitute for specific handlers.

## 6. Robust input: connecting to the validation suite

Here is the connection this lesson promises. The validation-suite readers from the functions labs and the exception machinery are **not competing designs** — they are the two layers of one defence:

```cpp
// The BOUNDARY (unchanged from Unit 07): expected mistakes, handled locally.
int readIntInRange(int lo, int hi) {
    int x;
    while (!(cin >> x) || x < lo || x > hi) {
        if (!cin) { cin.clear(); cin.ignore(1000, '\n'); }
        cout << "Enter a number " << lo << "-" << hi << ": ";
    }
    return x;
}

// The DEPTHS (new): unexpected-but-planned-for failures, announced upward.
vector<int> loadMarks(const string& path) {
    ifstream in(path);
    if (!in) throw runtime_error("loadMarks: cannot open " + path);
    vector<int> marks;
    string line;
    while (getline(in, line)) {
        if (line.empty()) continue;
        try {
            marks.push_back(stoi(line));       // may throw invalid_argument
        } catch (const invalid_argument&) {
            throw runtime_error("loadMarks: non-numeric line in " + path + ": " + line);
        }
    }
    return marks;
}
```

The division of labour, in one table:

| Situation | Tool | Why |
| --- | --- | --- |
| User types `abc` at a menu (expected, *every* session) | guard + re-prompt loop | handle-it-here; no reason to escalate |
| Marks file missing (unexpected, but the *app* knows what to do) | `throw runtime_error` from the loader | the loader can't choose; the app can (fresh start vs abort) |
| Malformed line mid-file (corrupt data) | catch-and-*rethrow-with-context* | `stoi`'s `invalid_argument` says "abc" but not *which file, which line* — add that, then rethrow |
| No marks loaded at all | validate-before-use guard | if the vector is empty, refuse before dividing by `marks.size()` |

The third row — **rethrow with context** — is the quiet professional habit in this lesson: low-level exceptions often say *what* but not *where*; catch, enrich, rethrow, and the higher layer finally has a report worth showing.

## 7. The pre-exception lesson, restated

If you take one sentence from this lesson: **the guards you already write are not beginners' exceptions — they are the first line of defence, and exceptions are the second.** A menu that re-prompts should never throw; a file loader that cannot open its file should never `return` quietly.

## Recap

- An *error* is a condition; an *exception* is the reporting machinery for the ones a function can't fix locally.
- `throw` builds and launches an exception object; `try` guards; `catch` receives, by `const&`, in **most-derived-first** order.
- Stack unwinding destroys stack locals on the way up — stack objects clean up free; raw `new` leaks.
- The standard family: `invalid_argument`, `out_of_range`, `runtime_error` (the derivation root for this course), `bad_alloc`, and the `catch (...)` last-resort net.
- Boundary guards stay `if`-based; depths throw; rethrow enriches.

## Practice

1. Modify `01_anatomy.cpp` to call `divide` twice — once with `b = 0`, once with `b = 3` — inside one `try`. Predict the output, then run. Which parts ran, which didn't, and why?
2. Add a `catch (...)` after the specific handler and throw a plain `int` (`throw 42;`) from a new function. What does the net catch, and what can it report?
3. Extend `loadMarks` to also catch `out_of_range` (a line longer than `stoi` can parse) and rethrow with the line number. *Hint:* `getline` calls can count.

→ Continue to [Lesson 2 — custom exceptions and exception safety](lesson-2-custom-safety.md).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
