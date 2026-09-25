---
title: "The Debugging Challenge Lab"
description: "A timed triage of six programs, a five-stage bug hunt, and the bug journal that turns every fix into a permanent skill."
---

# The Debugging Challenge Lab

> [← Module home](index.md) · One lab, three phases: **triage under time**, **a deep hunt**, and **the bug journal** — the deliverable that outlives the session.

## ⚠ Lab safety

Two rules, both learned the hard way in the Pointers module: (1) you may **read and trace** every program here, but programs you actually *run* must stay within the course's safe subset — none of this lab's programs intentionally corrupt memory, and if one of your own experiments does, run it once, note the symptom, and move on; repeated UB experiments teach your machine, not you. (2) **Never "fix" a program by deleting its checks** — the guard clause that "slows down" the program is the reason the next bug is loud instead of silent.

---

## Scenario

A study partner has sent you their Project 2 submission folder: **six small programs, all misbehaving** (Phase 1), and one larger program with a **subtle, intermittently reported bug** (Phase 2). Your supervisor (this course) wants two deliverables: working programs, and a **bug journal** proving you understand *why* each fix works — not just where the semicolon goes.

## Requirements

- R1 — Phase 1: for each of the six triage programs, write on paper **before running anything**: the predicted symptom, the error kind (syntax / compile / runtime / logic), and the one-line fix.
- R2 — Time-box each triage program to **8 minutes** (a real phone timer). When time expires: write your best hypothesis and move on. The reveal checks your *diagnosis speed*, not your typing.
- R3 — Phase 2: hunt the anomaly program with the full Lesson 1 workflow (reproduce → shrink → hypothesis → cheap test → fix → regression test). You may use the debugger or printouts — your choice, but record which you used and why.
- R4 — Phase 3: start the **bug journal** described below; its first five entries come from this lab.

## Phase 1 — Triage (six programs, 8 minutes each)

For each: predict, classify, fix on paper. **Do not scroll to the reveal until all six are done.**

**T1.** A program prints `Total: 7` for `2.50 + 4.75`.

```cpp
int total = item1 + item2;      // item1, item2 are double
cout << "Total: " << total << "\n";
```

**T2.** A marks loop with sentinel −1 also adds the −1, making every average slightly low.

```cpp
while (mark != -1) {
    cin >> mark;
    total += mark;
    count++;
}
```

**T3.** A grade ladder gives F for 65 and nothing at all for 40.

```cpp
if (mark >= 90)      grade = 'A';
else if (mark >= 80) grade = 'B';
else if (mark >= 70) grade = 'C';
else if (mark >= 60) grade = 'D';
```

**T4.** A triangle printer outputs a 5-wide block instead of a triangle.

```cpp
for (int i = 1; i <= 5; i++)
    for (int j = 1; j <= 5; j++)
        cout << "*";
    cout << "\n";               // ← where does this actually belong?
```

**T5.** `swap(a, b)` leaves both values untouched.

```cpp
void swap(int x, int y) {
    int t = x; x = y; y = t;
}
```

**T6.** A CSV parse of `"Omar;91"` reports mark 0.

```cpp
int mark = stoi(line.substr(line.find(';'), 2));
```

<a name="triage-reveal"></a>
### Triage reveal

| # | Predicted symptom | Error kind | One-line fix | The rule it teaches |
| --- | --- | --- | --- | --- |
| T1 | truncation to 7 | logic (implicit conversion) | `double total = ...` | wrong storage type = silent loss |
| T2 | average low by 1/count | logic (sentinel in totals) | read at the bottom / break after test | test before use |
| T3 | 40 → prints nothing (uninitialized grade) | logic + UB | terminal `else` | ladders must be exhaustive |
| T4 | 5×5 block | logic (indent lies; `\n` inside inner loop's *scope*) | move `cout << "\n";` into the outer loop | braces tell the truth; indent is decoration |
| T5 | no swap | logic (pass-by-value) | `void swap(int& x, int& y)` | mutations need references |
| T6 | stoi throws / garbage | logic (substr offset) | `stoi(line.substr(line.find(';') + 1))` | trace the exact arguments |

Scoring: 6/6 with correct classifications — you're ready for Project 3. 4–5 — re-run the [review checklist](lesson-3-better-code.md#6-basic-code-review--reading-code-like-a-reviewer) on your own latest program. ≤3 — re-do [practice pack](practice.md) sections matching your misses before attempting Phase 2.

## Phase 2 — The deep hunt: "sometimes it's zero"

**The anomaly.** A gradebook computes the class average. Most runs are correct. Once in a while — the report says, "when the class is small" — the average prints as `0`, and once it printed `-nan`. The student insists "the math is right, I checked it by hand."

```cpp
// gradebook.cpp — compile: g++ -std=c++17 -g -Wall -Wextra gradebook.cpp
#include <iostream>
#include <fstream>
using namespace std;

int readMarks(int marks[], int capacity) {
    ifstream in("marks.txt");
    int count = 0;
    int m;
    while (count < capacity && in >> m) {
        marks[count] = m;
        count++;
    }
    return count;
}

double average(const int marks[], int count) {
    int total = 0;
    for (int i = 0; i < count; i++)
        total += marks[i];
    return total / count;
}

int main() {
    const int CAP = 100;
    int marks[CAP];
    int count = readMarks(marks, CAP);
    cout << "Read " << count << " marks.\n";
    cout << "Class average: " << average(marks, count) << "\n";
    return 0;
}
```

**Your tasks:**

1. **Reproduce.** What does `marks.txt` need to contain to produce `0`? To produce `-nan`? (Hint: one is "empty file", one is "missing file" — decide *which is which* and prove it with a trace of `readMarks`.)
2. **Shrink.** State the smallest input that triggers each symptom.
3. **Hypothesis.** Write each bug as one sentence: *because X, Y computes Z instead of W.*
4. **Cheap test.** Which `cout` or trace proves each hypothesis in one run?
5. **Fix.** Both bugs. Defend: why is a guard clause the right tool here, and not an `assert`?
6. **Regression test.** Write the test-table rows that would have caught both — and would still pass after a future refactor.

<a name="hunt-solution"></a>
### Hunt solution — after your own trace

**Bug 1 — the empty-file zero.** `readMarks` returns `count = 0` for an empty file — correct behaviour, honestly reported. But `average(marks, 0)` divides `0 / 0`: integer division `0/0` is **undefined**; in practice the program prints `0` (or garbage) and *keeps going*. The hypothesis sentence: *because `readMarks` legitimately returns 0 for an empty file, `average` divides by zero instead of refusing.* The cheap test: one `cout` of `count` before the call — or an `assert(count > 0)` inside `average`, which converts the mystery into a named, located failure.

**Bug 2 — the missing-file nan.** If `marks.txt` doesn't exist, the `ifstream` opens into a failed state; every `in >> m` fails instantly; `count` stays 0; `average(marks, 0)` computes `0.0 / 0` in the **double** return path (after the int division is avoided by the cast? — trace honestly: `total / count` is `int / int = int` (UB), then converted to double — the printed `-nan` on some machines is the UB's face). *Because the open was never checked, a missing file masquerades as an empty class.* The cheap test: `cout << boolalpha << in.is_open();` in `readMarks`.

**The fix.**

```cpp
int readMarks(int marks[], int capacity) {
    ifstream in("marks.txt");
    if (!in) {                                    // check the open — P16's lesson
        cout << "Error: marks.txt could not be opened.\n";
        return -1;                                // a distinct "no data" signal
    }
    int count = 0, m;
    while (count < capacity && in >> m) {
        marks[count] = m;
        count++;
    }
    return count;
}

double average(const int marks[], int count) {
    if (count <= 0) return 0.0;                   // guard clause — refuse the impossible
    int total = 0;
    for (int i = 0; i < count; i++)
        total += marks[i];
    return static_cast<double>(total) / count;    // explicit, intentional division
}

int main() {
    const int CAP = 100;
    int marks[CAP];
    int count = readMarks(marks, CAP);
    if (count < 0) return 1;                      // the caller honours the contract
    if (count == 0) { cout << "No marks in file.\n"; return 0; }
    cout << "Read " << count << " marks.\n";
    cout << "Class average: " << average(marks, count) << "\n";
    return 0;
}
```

**Why guard clauses, not asserts?** The count reaching `average` comes from *data on disk* — outside the program's control. Asserts are for internal invariants the program's own code guarantees; disk contents are inputs, and inputs get validated (Lesson 3's boundary rule). The `assert` would crash on a bad file; the guard clause *reports and continues*. (An `assert` *during debugging* is still useful — add it temporarily, watch it fire on your first reproduction, then let the guard replace it.)

**The regression rows.**

| Input | Expected |
| --- | --- |
| `marks.txt` = `80 90 70` | `Read 3 marks.` + `Class average: 80` |
| `marks.txt` exists, empty | `No marks in file.` |
| `marks.txt` missing | error line, exit code 1, **no** average line |
| 101 marks in file | `Read 100 marks.` (capacity honoured, no overrun) |

## Phase 3 — The bug journal (the real deliverable)

One file, `bug-journal.md`, one row per bug you personally fix from now until the capstone:

```text
| Date | Program | Symptom | Kind | Cause (one sentence) | The rule I take away |
```

The discipline that makes it work:

- **Write the entry when you find the bug**, not at day's end — the connection between symptom and cause decays in hours.
- **The rule column is the whole point.** "Off-by-one" is not a rule; "inner bounds that depend on the outer variable get traced per-row" is.
- **Re-read the journal before every project.** Your past bugs are the precise map of your blind spots; a rule you re-read before writing is the cheapest test you will ever run.
- **Mine it for the checklist.** Every rule in your journal that keeps recurring graduates into your personal copy of the [review checklist](lesson-3-better-code.md#6-basic-code-review--reading-code-like-a-reviewer) — the checklist becomes yours, not the course's.

## Deliverables checklist

- [ ] Six triage predictions with kinds and one-line fixes, *before* the reveal
- [ ] Triage score computed; follow-up chosen accordingly
- [ ] Phase 2: reproduction inputs for both symptoms; both hypothesis sentences; the fix with the guard/assert reasoning written out
- [ ] Four regression rows written and verified against the fixed program
- [ ] `bug-journal.md` started — first five entries are this lab's

## Extensions

- ⭐ Instrument the fixed gradebook with `assert(count > 0)` in `average`, compile normally, run the missing-file case, and read the assert's output — then compile with `-DNDEBUG` and run again. Two sentences on what changed and why.
- ⭐⭐ Debug P6's original (the eof loop) under gdb: breakpoint on the `while`, `next` ten times, `print n` twice — watch the hang happen. Write the journal entry.
- ⭐⭐ Take your Project 2 code and run the [review checklist](lesson-3-better-code.md#6-basic-code-review--reading-code-like-a-reviewer) aloud against it; fix what the review finds; journal the top three.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
