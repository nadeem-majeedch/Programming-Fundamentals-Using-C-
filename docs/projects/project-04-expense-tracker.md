---
title: "Project 4 — The Expense Tracker"
description: "A menu-driven expense tracker with categories, budgets, and reports — the first menu-system project: do-while flows, parallel vectors, decomposition into a small module of functions."
---

# Project 4 — The Expense Tracker

> [← Projects home](index.md) · [← Project 3](project-03-grade-analyzer.md) · Tier: Basic · **Units first: 05–08** — loops, functions, references, top-down design

## Overview

A freelancer's daily ledger: add expenses (amount + category + note), list them, total them, break them down by category, and check a monthly budget warning. Everything runs from a `do-while` menu; the data lives in parallel vectors; every menu option is one well-named function.

## Learning objectives

- structure a program around a menu loop with one function per option
- manage parallel collections (amounts, categories, notes) that must stay index-aligned
- aggregate over a stored batch by key (category totals)
- validate menu choices and data entry without ever crashing

## Prerequisites

| Unit | What you need |
| --- | --- |
| 05–06 | the menu loop shape, validation |
| 07–08 | functions, references, top-down decomposition, stubs and drivers |

## Requirements

1. Menu: 1 add expense · 2 list · 3 total · 4 category report · 5 budget check · 0 quit.
2. Add: amount (0.01–100000), category (one word), note (one line, optional).
3. List: index, category, amount, note — aligned columns.
4. Category report: totals per category in first-appearance order, then the grand total.
5. Budget check: a monthly budget (typed once at first check, remembered) with remaining/warning state.
6. No option may crash on empty data — each reports its empty state.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | two adds then list shows both, columns aligned | T1 |
| F2 | total equals the sum to 2 decimals | T1 |
| F3 | category report groups correctly, first-appearance order | T2 |
| F4 | budget: first use asks; later uses remember | T3 |
| F5 | every option on empty data prints its empty message | T4 |
| F6 | invalid menu choice re-prompts the menu | T5 |

## Suggested data structures

- Three parallel vectors: `vector<double> amounts`, `vector<string> categories`, `vector<string> notes` — one push per add, always together.
- The category report: two more parallel vectors (names, totals) built at report time.
- Budget: one `double` + one `bool budgetSet` — asked once, remembered.

## Milestones

- **M1 — the shell.** The menu loop with stubs for all six options. *Exit: every option answers "not implemented yet"; the loop quits cleanly.*
- **M2 — add + list.** The aligned vectors and the listing. *Exit: T1 passes.*
- **M3 — totals + category report.** The two aggregations. *Exit: T2, T2 pass.*
- **M4 — the budget.** The ask-once-then-remember state. *Exit: T3 passes.*
- **M5 — the empty states.** Every option's empty guard. *Exit: T4 passes.*

## Tasks

1. Write the menu skeleton with six stub functions (`addExpense`, `listExpenses`, ...).
2. Fill `addExpense` with the validated three-field read.
3. Fill `listExpenses` with `setw` columns.
4. Fill `totalOf` and `categoryReport` (the tally pattern).
5. Fill `budgetCheck` with the ask-once logic.
6. Walk the test plan; log the results.

## Test plan

| # | Sequence | Expected |
| --- | --- | --- |
| T1 | add 250.50 Transport "fuel", add 80 Food "lunch" → list → total | both listed; total Rs 330.50 |
| T2 | add 80 Food, add 120 Transport, add 60 Food → category report | Food 140.00, Transport 120.00, grand 260.00 |
| T3 | budget check: 500 → add 250.50 → budget check | asks once; remaining 249.50; no warning |
| T4 | fresh run → options 2,3,4,5 before any add | four empty-state messages |
| T5 | choice 9 → 0 | invalid message, then clean quit |

## Edge cases

- A note containing spaces (the `getline` after `>>` discipline — the IO module's mixing rule).
- An amount exactly at the budget boundary — remaining 0.00, which state prints?
- A category typed with different case (`food` vs `Food`) — the project's contract is case-*sensitive* matching; document it.

## Extension ideas

1. Delete an expense by index (the erase idiom — after Unit 09 this is one line).
2. Persist to a file — the bridge to [Project 6](project-06-inventory.md) and [Project 9](project-09-student-files.md).
3. A largest-expense line in the category report.

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] The three vectors are only ever appended together (+1)
- [ ] No menu option crashes or lies on empty data (+1)
- [ ] The budget is asked exactly once and remembered (+1)

## Hints

1. `cin.ignore(1000, '\n')` after every numeric read that precedes a `getline` — the tracker hits the mixing rule immediately.
2. The category tally is `indexOf`-then-increment-or-append — write it as a helper the report owns.
3. Budget state lives in `main` and travels by reference to `budgetCheck` — or becomes a tiny struct; either is defensible, choose and say why.

## Complete reference solution

```cpp
// tracker.cpp — Programming Fundamentals Using C++
// Project 4 · The Expense Tracker
// Build: g++ -std=c++17 -Wall -Wextra tracker.cpp -o tracker

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
using namespace std;

void addExpense(vector<double>& amounts, vector<string>& categories, vector<string>& notes) {
    Expense-in-place:                       // (see explanation: the three vectors move together)
    double amount;
    string category, note;

    cout << "Amount (0.01-100000): ";
    cin >> amount;
    while (amount < 0.01 || amount > 100000) {
        cout << "Amount is 0.01-100000: ";
        cin >> amount;
    }
    cin.ignore(1000, '\n');

    cout << "Category (one word): ";
    cin >> category;
    cout << "Note: ";
    getline(cin, note);

    amounts.push_back(amount);              // the three appends are one transaction
    categories.push_back(category);
    notes.push_back(note);
    cout << "Added\n";
}

void listExpenses(const vector<double>& amounts, const vector<string>& categories,
                  const vector<string>& notes) {
    if (amounts.empty()) { cout << "No expenses recorded\n"; return; }
    cout << left << setw(4) << "#" << setw(12) << "Category"
         << right << setw(12) << "Amount" << "  Note\n";
    for (size_t i = 0; i < amounts.size(); ++i) {
        cout << left << setw(4) << (i + 1) << setw(12) << categories[i]
             << right << setw(12) << fixed << setprecision(2) << amounts[i]
             << "  " << notes[i] << "\n";
    }
}

double totalOf(const vector<double>& amounts) {
    double total = 0.0;
    for (double a : amounts) total += a;
    return total;
}

void categoryReport(const vector<double>& amounts, const vector<string>& categories) {
    if (amounts.empty()) { cout << "No expenses recorded\n"; return; }

    vector<string> names;                    // the tally, built at report time
    vector<double> totals;
    for (size_t i = 0; i < amounts.size(); ++i) {
        size_t j = 0;
        while (j < names.size() && names[j] != categories[i]) ++j;
        if (j == names.size()) { names.push_back(categories[i]); totals.push_back(amounts[i]); }
        else totals[j] += amounts[i];
    }

    double grand = 0.0;
    for (size_t i = 0; i < names.size(); ++i) {
        cout << "  " << names[i] << ": Rs " << fixed << setprecision(2) << totals[i] << "\n";
        grand += totals[i];
    }
    cout << "  (grand: Rs " << grand << ")\n";
}

void budgetCheck(const vector<double>& amounts, double& budget, bool& budgetSet) {
    if (!budgetSet) {
        cout << "Set your monthly budget: ";
        cin >> budget;
        while (budget <= 0) { cout << "Budget must be positive: "; cin >> budget; }
        budgetSet = true;
    }
    double spent = totalOf(amounts);
    double remaining = budget - spent;
    cout << fixed << setprecision(2);
    cout << "Budget: Rs " << budget << ", spent: Rs " << spent
         << ", remaining: Rs " << remaining << "\n";
    if (remaining < 0)      cout << "WARNING: over budget!\n";
    else if (remaining == 0) cout << "Exactly at budget\n";
}

int main() {
    vector<double> amounts;
    vector<string> categories, notes;
    double budget = 0.0;
    bool budgetSet = false;

    cout << "=== Expense Tracker ===\n";
    int choice;
    do {
        cout << "\n1 Add · 2 List · 3 Total · 4 Category report · 5 Budget · 0 Quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');              // every option may getline next

        if      (choice == 1) addExpense(amounts, categories, notes);
        else if (choice == 2) listExpenses(amounts, categories, notes);
        else if (choice == 3) {
            if (amounts.empty()) cout << "No expenses recorded\n";
            else cout << "Total: Rs " << fixed << setprecision(2) << totalOf(amounts) << "\n";
        }
        else if (choice == 4) categoryReport(amounts, categories);
        else if (choice == 5) budgetCheck(amounts, budget, budgetSet);
        else if (choice != 0) cout << "Invalid choice\n";
    } while (choice != 0);

    cout << "Goodbye — " << amounts.size() << " expense(s) tracked this session\n";
    return 0;
}
```

*(One editing note for self-study readers: the line `Expense-in-place:` inside `addExpense` is a planning comment, not C++ — delete it when you type the file. The reference listing keeps it so the three-vector "one transaction" moment is visible where it happens.)*

## Explanation of important design decisions

- **Parallel vectors over a struct — deliberately.** Unit 08's world has no structs yet; the alignment discipline (three appends together, three indices together) is the *motivation* the records module later answers. The project documents the invariant in a comment at the append site, where it is enforced.
- **One function per menu option.** The stubs-first milestone makes the architecture exist before any feature does — the top-down design lesson from Unit 08, and the reason the final `main` fits on one screen.
- **The budget's state is asked, not assumed.** `budgetSet` turns "have we asked?" into data. The alternative (budget 0 = unset) conflates a legitimate zero with the unset state — the unrepresentable-illegal-state habit in miniature.
- **Empty states are options' own responsibility.** Each aggregation function guards its own emptiness — so the menu stays a dispatcher and the honesty lives with the code that knows what "nothing yet" means.

[← Project 3](project-03-grade-analyzer.md) · [Projects home](index.md) · Next: [Project 5 — The Quiz Application](project-05-quiz-app.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
