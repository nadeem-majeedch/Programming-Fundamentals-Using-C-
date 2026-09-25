---
title: "Mini-Project — The Marks Analyzer"
description: "Unit 09's capstone: a menu-driven marks analyzer built as a function team over arrays — statistics, search, histogram, and matrix mode, built progressively."
---

# Mini-Project — The Marks Analyzer

> [← Module home](index.md) · Unit 09 capstone · Built in five progressive milestones

The syllabus promised this project from [Unit 07](../functions/index.md): the analyzer that needed arrays to exist. Now it exists. A menu-driven marks manager built as a **function team** over stored data — every tool from this unit, one program, and the walls from [Functions' toolkit](../functions/miniproject.md) finally down: the session *remembers* its numbers.

## What you're building

```text
==== Marks Analyzer ====
1. Enter marks (replaces current session)
2. Full report (count, mean, min/max + who, pass count, above-mean count)
3. Search: does mark X exist? Where (all positions)?
4. Histogram (10 bands over the data's own range)
5. Subject matrix mode (up to 10 students × 5 subjects: per-student totals, per-subject averages)
0. Quit
```

- **1 Enter marks** — validated fill via `readMarks(marks, capacity)`; reports how many landed. Re-entering replaces the session (state is the arrays + n, owned by `main`).
- **2 Full report** — the [Lab 1](labs.md#lab-1--student-marks-analyzer) report *plus* above-mean count ([E15](exercises.md#s15--above-average)'s two passes).
- **3 Search** — read a target; print every matching position or a clean "not found" ([all-matches variant](lesson-2-classic-passes.md#1-linear-search--the-find-machine)).
- **4 Histogram** — the [Lab 7](labs.md#lab-7--simple-statistics-calculator) band formula, star bars, aligned labels.
- **5 Subject matrix mode** — read a 2D session `int grid[MAX][SUBJECTS]`, print per-student totals and per-subject averages ([S29](exercises.md#s29--row-and-column-reports)'s two half-passes). Uses its own fill; 1D tools (search, histogram) run on *flattened choice* is out of scope — document that boundary honestly.
- **0 Quit** — session summary: how many marks entered, how many searches ran, how many reports printed.

**Global rules.** Prototypes → `main` → definitions; no mutable globals; `const` on every reading machine; `main` owns all state; every pure function ships with its test table *before* its code.

## The progressive milestones

**M1 — Skeleton + state.** Menu loop, `main` owning `int marks[MAX]` and `int n = 0`, stub handlers. *Done when:* every option runs, quit prints an honest zero-state summary.

**M2 — The 1D team.** `readMarks`, `printMarks`, `sumOf`, `averageOf`, `indexMax`, `indexMin`, `countAtLeast`, `countAbove`, `linearSearchAll`. Test each against its table in a throwaway driver ([driver pattern](../functions/lesson-3-references-testing.md#5-testing-functions--the-payoff-of-small-machines)). *Done when:* handler 2 reproduces Lab 1's expected table exactly on the fixed dataset `55 38 91 40 62`.

**M3 — Search + histogram.** Handlers 3 and 4 wired. *Done when:* searching 91 on the fixed data prints position 3 (1-based); searching 100 prints not-found; the histogram matches Lab 7's bands on Lab 7's data.

**M4 — Matrix mode.** The 2D fill and the two half-passes. *Done when:* on the 4×3 grid `{ {72,85,91},{60,55,40},{88,91,79},{67,78,80}}`, per-student totals are 248, 155, 258, 225 and per-subject averages are 71.75, 77.25, 72.50.

**M5 — Polish + write-up.** Summary counters, `setw` alignment throughout, named constants, full test-table pass, then the [write-up](#write-up).

## Deliverable test table (minimum rows)

Fixed dataset (1D): `55 38 91 40 62` — full report row; searches for 91, 38, 100, 55 (first-and-only, last, absent, repeated?); histogram bands. 2D dataset: the M4 grid — both half-passes. Boundary: empty session handlers (report/search/histogram on n = 0 must print clean messages, never divide); full capacity (40th mark accepted, 41st rejected by the reader); matrix at max dimensions. Invalid input: one non-numeric and one out-of-range per input site — identical reader behaviour everywhere.

## Write-up (deliverable)

<a name="write-up"></a>
1. **Function inventory** — every function: signature, single-job sentence, const/plain + why, table-attached?
2. **Walls, final report** — compare all three toolkit builds ([iteration](../repetition/miniproject.md), [functions](../functions/miniproject.md), this one): what each stage's architecture could and couldn't do. Which wall *still* stands here? (Sorting — [Unit 10](../syllabus.md#stage-d-algorithms-and-data-units-10-12); the marks-to-student *mapping* only working via positions — structs, [Stage E](../syllabus.md#stage-e-memory-and-objects-units-13-15).)
3. **Bounds audit** — list every place an index is data-derived (search results, histogram bands, matrix coordinates) and the guard at each.
4. **Design decisions** — three, justified (e.g. why search prints all matches; why the matrix mode owns its fill; why capacity is a constant).

## Reference skeleton

> **Attempt M1–M2 before reading.** Signatures and wiring are the lesson; bodies are your milestone work.

```cpp
// analyzer.cpp — Marks Analyzer (Unit 09 capstone)
// Build:  g++ -std=c++17 -Wall -Wextra analyzer.cpp -o analyzer
// House rules: prototypes -> main -> definitions; no mutable globals;
// const readers; main owns all state; every pure machine has a table.

#include <iostream>
#include <iomanip>

constexpr int MAX_MARKS    = 40;   // 1D capacity
constexpr int MAX_STUDENTS = 10;   // 2D rows
constexpr int SUBJECTS     = 5;    // 2D cols — REQUIRED constant in parameters
constexpr int PASS_MARK    = 40;

// ---------- prototypes ----------
int    readMarks(int marks[], int capacity);                  // writer; returns n
void   printMarks(const int marks[], int n);
int    sumOf(const int marks[], int n);
double averageOf(const int marks[], int n);                    // guards n == 0? caller's job — decide, document
int    indexMax(const int marks[], int n);
int    indexMin(const int marks[], int n);
int    countAtLeast(const int marks[], int n, int cut);
int    countAbove(const int marks[], int n, double cut);
int    searchAll(const int marks[], int n, int target);        // prints matches; returns count
void   histogram(const int marks[], int n);
void   matrixMode();
void   printMenu();

int main() {
    int marks[MAX_MARKS];
    int n = 0;
    int reports = 0, searches = 0, histograms = 0;

    int choice;
    do {
        printMenu();
        std::cin >> choice;
        switch (choice) {
            case 1: n = readMarks(marks, MAX_MARKS); break;
            case 2:
                if (n == 0) { std::cout << "No marks yet.\n"; break; }
                printMarks(marks, n);
                // ... full report via the team ...
                reports += 1;
                break;
            case 3:
                if (n == 0) { std::cout << "No marks yet.\n"; break; }
                searches += searchAll(marks, n, /* read target */ 0);
                break;
            case 4:
                if (n == 0) { std::cout << "No marks yet.\n"; break; }
                histogram(marks, n);
                histograms += 1;
                break;
            case 5: matrixMode(); break;
            case 0: break;
            default: std::cout << "0-5, please.\n";
        }
    } while (choice != 0);

    std::cout << "Session: " << n << " mark(s), " << reports << " report(s), "
              << searches << " search(es), " << histograms << " histogram(s). Bye!\n";
    return 0;
}

// ---------- definitions: M2's team, M3's search/histogram, M4's matrix mode ----------
```

**Three subtleties to notice in the skeleton:**

- Every data handler guards `n == 0` **in `main`** — the empty-session policy lives with the state owner, one place, consistent.
- `searchAll` returns the match count so the session summary counts *searches with hits* — a design decision you may reverse; the write-up asks you to defend whichever you choose.
- `matrixMode()` is self-contained (own fill, own report) rather than sharing `main`'s 1D state — the honest boundary between the two data shapes; the write-up asks what sharing would have cost.

When [Unit 10](../syllabus.md#stage-d-algorithms-and-data-units-10-12) arrives, the analyzer grows sorting — and the histogram, median approximation, and "top k" all collapse into passes over *ordered* data. The function team you built here survives that upgrade unchanged.
