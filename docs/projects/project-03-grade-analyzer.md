---
title: "Project 3 — The Student Grade Analyzer"
description: "A whole-class statistics program over stored marks — the first project with functions over collections: batch input, averages, histograms, and report formatting."
---

# Project 3 — The Student Grade Analyzer

> [← Projects home](index.md) · [← Project 2](project-02-number-analysis.md) · Tier: Basic · **Units first: 05–07** — loops, plus **functions** (Unit 07): parameters, returns, `const&`

## Overview

A tutor's tool: read a class's marks once, then answer every standard question — average, highest/lowest, pass count, the A–F histogram, the failing roll, and the median. The project's step up from Project 2 is **storage plus functions**: the marks are read into a vector and every statistic is a named function over it.

## Learning objectives

- read and store a batch in a `vector<int>` with per-position validation
- write single-job statistic functions over `const vector<int>&`
- produce a formatted multi-part report from composed function calls
- distinguish computed-on-demand values from stored facts

## Prerequisites

| Unit | What you need |
| --- | --- |
| 05–06 | loops, validation re-prompts |
| [07](../functions/index.md) | functions, parameters, return values, passing collections |

## Requirements

1. Read `n` (1–200) then n marks (0–100, re-prompt per position).
2. Report: average (2 dp), highest, lowest, pass count (≥ 50), A–F histogram (A ≥ 80, B ≥ 70, C ≥ 60, D ≥ 50, F below), the failing positions (1-based), and the median.
3. Every statistic is a function taking the vector; `main` is a call sequence plus the input loop.
4. The median sorts a *copy* — the stored order must survive.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | six marks produce every report value correctly | T1 |
| F2 | an out-of-range mark re-prompts for the same position | T2 |
| F3 | single-student class: median = the mark, all extrema equal | T3 |
| F4 | failing positions list is empty-safe (`Failing: none`) | T4 |
| F5 | even-sized class: median is the mean of the two middles | T5 |

## Suggested data structures

- `vector<int> marks` — the one stored fact.
- The histogram as five local counters inside its function (a `map<char,int>` is the STL module's later answer — not yet).
- Median: a local sorted copy inside its function.

## Milestones

- **M1 — input.** The validated read loop into the vector. *Exit: T2 passes.*
- **M2 — the easy statistics.** Average, highest, lowest, passes — four functions, one call each. *Exit: T1's first four lines correct.*
- **M3 — histogram and failing roll.** The ladder and the position list. *Exit: T1 and T4 pass.*
- **M4 — the median.** Sort-a-copy, middle or mean-of-middles. *Exit: T3 and T5 pass; the original order is provably intact (failing positions unchanged after a median run).*

## Tasks

1. Write `readMarks(vector<int>&, int n)`.
2. Write `averageOf`, `highestOf`, `lowestOf`, `countPasses` — each with a one-line contract comment.
3. Write `printHistogram` and `printFailingPositions`.
4. Write `medianOf` (sorted local copy).
5. Assemble `main`; run the test plan.

## Test plan

| # | Input | Expected |
| --- | --- | --- |
| T1 | n=6: `82 45 91 67 50 38` | average 62.17, high 91, low 38, passes 4, A:2 B:0 C:1 D:1 F:2, Failing: 2, 6, median 58.50 |
| T2 | n=2: `120` then `82`, `45` | re-prompt; then normal report for 82, 45 |
| T3 | n=1: `77` | all extrema 77, median 77.00, passes 1 |
| T4 | n=3: `90 91 92` | `Failing: none`, passes 3 |
| T5 | n=4: `40 60 80 100` | median 70.00, A:1 C:1 F:2 |

## Edge cases

- All identical marks — extremes, median, and histogram agree with each other.
- Marks at exactly the band edges (80, 70, 60, 50) — one number per band boundary in a test run.
- n = 200 (the capacity ceiling) — the loops must not assume smallness.

## Extension ideas

1. Standard deviation (the two-pass formula).
2. A letter-grade-per-student listing.
3. Read the marks from a file instead of the console — then this project has become [Project 9](project-09-student-files.md)'s little sibling.

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] `main` contains no statistics arithmetic — only calls (+1)
- [ ] The median's sort provably does not disturb the stored vector (+1)
- [ ] Every statistic function has a one-line contract comment (+1)

## Hints

1. The average accumulator is `long long` — 200 marks of 100 is only 20,000, but the habit costs nothing and scales.
2. Failing positions need *indices*: a range-for hides them; use an index loop or carry both.
3. Median: `sort(local.begin(), local.end())` on a copy; `size % 2` picks the branch.

## Complete reference solution

```cpp
// grades.cpp — Programming Fundamentals Using C++
// Project 3 · The Student Grade Analyzer
// Build: g++ -std=c++17 -Wall -Wextra grades.cpp -o grades

#include <iostream>
#include <iomanip>
#include <vector>
#include <algorithm>
using namespace std;

void readMarks(vector<int>& marks, int n) {
    for (int i = 0; i < n; ++i) {
        int m;
        cout << "Mark " << (i + 1) << ": ";
        cin >> m;
        while (m < 0 || m > 100) {           // marks are 0..100 — the read contract
            cout << "Marks are 0-100. Again: ";
            cin >> m;
        }
        marks.push_back(m);
    }
}

double averageOf(const vector<int>& marks) {   // mean of all marks
    long long total = 0;
    for (int m : marks) total += m;
    return static_cast<double>(total) / marks.size();
}

int highestOf(const vector<int>& marks) {
    int best = marks[0];
    for (int m : marks) if (m > best) best = m;
    return best;
}

int lowestOf(const vector<int>& marks) {
    int worst = marks[0];
    for (int m : marks) if (m < worst) worst = m;
    return worst;
}

int countPasses(const vector<int>& marks) {    // pass mark: 50
    int passes = 0;
    for (int m : marks) if (m >= 50) ++passes;
    return passes;
}

void printHistogram(const vector<int>& marks) {
    int a = 0, b = 0, c = 0, d = 0, f = 0;
    for (int m : marks) {
        if      (m >= 80) ++a;
        else if (m >= 70) ++b;
        else if (m >= 60) ++c;
        else if (m >= 50) ++d;
        else              ++f;
    }
    cout << "A: " << a << "  B: " << b << "  C: " << c << "  D: " << d << "  F: " << f << "\n";
}

void printFailingPositions(const vector<int>& marks) {
    bool any = false;
    for (size_t i = 0; i < marks.size(); ++i) {
        if (marks[i] < 50) {
            if (!any) { cout << "Failing: "; any = true; }
            else cout << ", ";
            cout << (i + 1);
        }
    }
    if (!any) cout << "Failing: none";
    cout << "\n";
}

double medianOf(const vector<int>& marks) {    // sorts a COPY — storage is sacred
    vector<int> sorted = marks;
    sort(sorted.begin(), sorted.end());
    size_t n = sorted.size();
    if (n % 2 == 1) return sorted[n / 2];
    return (sorted[n / 2 - 1] + sorted[n / 2]) / 2.0;
}

int main() {
    int n;
    cout << "Number of students: ";
    cin >> n;
    if (n < 1 || n > 200) { cout << "Invalid count\n"; return 1; }

    vector<int> marks;
    readMarks(marks, n);

    cout << fixed << setprecision(2);
    cout << "Average: " << averageOf(marks) << "\n";
    cout << "Highest: " << highestOf(marks) << "\n";
    cout << "Lowest: "  << lowestOf(marks)  << "\n";
    cout << "Passes: "  << countPasses(marks) << "\n";
    printHistogram(marks);
    printFailingPositions(marks);
    cout << "Median: "  << medianOf(marks)  << "\n";
    return 0;
}
```

## Explanation of important design decisions

- **Storage once, views everywhere.** The vector is written by exactly one function (`readMarks`, by reference) and read by five (`const&`). Nobody but the reader mutates, so every statistic is free to assume a stable dataset — the const-correctness habit doing real work in a small program.
- **The median sorts a copy.** The tempting alternative — sorting the stored vector and reading the middle — silently changes what `printFailingPositions` reports afterwards. The copy costs one vector and buys an invariant; the test plan's T1 ordering (failing positions *before* median) plus T4 would catch the mutation either way, but the design makes it impossible rather than merely tested.
- **Presentation functions can be `void`.** `printHistogram` and `printFailingPositions` compute *and* print — deliberately, because their computed values exist only for the report. Splitting them would create functions whose return values nobody keeps.
- **The separator pattern.** `Failing: 2, 6` prints its comma *before* every element except the first — the standard idiom for joined lists, and the reason T4's empty case needs the `none` fallback written explicitly.

[← Project 2](project-02-number-analysis.md) · [Projects home](index.md) · Next: [Project 4 — The Expense Tracker](project-04-expense-tracker.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
