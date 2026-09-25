---
title: "Project 6 — The Inventory Management System"
description: "A searchable, sortable stockroom over parallel collections — collections, linear/binary search, sorting by key, and string processing, all before persistence arrives."
---

# Project 6 — The Inventory Management System

> [← Projects home](index.md) · [← Project 5](project-05-quiz-app.md) · Tier: Intermediate · **Units first: 09–11** — collections (arrays/`vector`), searching, sorting, strings

## Overview

The campus store's back office: a stockroom of products (name, quantity, price) with a menu for restocking, selling, searching (by name, by price ceiling), a low-stock report, a value report, and sorting (by name, by quantity, by price). No files yet — this project is the *data mechanics* layer that Project 7 and 9 will persist.

## Learning objectives

- keep parallel collections aligned through searches, sorts, and mutations
- implement linear search (by name) and leverage sorted order (by price) honestly
- sort by three different keys without corrupting the pairing
- produce derived reports (value, low stock) from stored state

## Prerequisites

| Unit | What you need |
| --- | --- |
| [09](../arrays/index.md) | arrays/`vector`, passing collections |
| [10](../algorithms/index.md) | linear/binary search, selection sort |
| [11](../strings/index.md) | `std::string` comparison and formatting |

## Requirements

1. Data: up to 100 products — name (unique, one word), quantity (≥ 0), price (0.01–10000). Load by typing `n` products at startup (a seed function).
2. Menu: 1 list · 2 restock · 3 sell · 4 search by name · 5 search "affordable" (price ≤ X) · 6 low-stock report · 7 sort (name/qty/price) · 8 value report · 0 quit.
3. Restock/sell are ask-doors by name; sell refuses beyond stock.
4. Sorting offers all three keys, on copies or in place (state which); the name↔qty↔price pairing must survive.
5. Value report: per-line and total stock value.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | list prints all products in columns | T1 |
| F2 | sell beyond stock is refused, stock unchanged | T2 |
| F3 | search by name finds or reports `not found` | T3 |
| F4 | affordable search lists every product ≤ X | T4 |
| F5 | all three sorts produce correct orders with pairing intact | T5 |
| F6 | value report totals correctly to 2 decimals | T6 |

## Suggested data structures

- Three parallel vectors: `names`, `quantities`, `prices` — the pairing invariant is the project's spine.
- A `findProduct(names, target)` helper returning the index or −1 — every by-name operation flows through it.
- Sorts: selection sort written once per key (or one function taking a "which key" switch).

## Milestones

- **M1 — the seed and the list.** Typed seed data, columnar listing. *Exit: T1 passes.*
- **M2 — the movements.** Restock and sell through `findProduct`, both ask-doors. *Exit: T2 passes.*
- **M3 — the searches.** By name; the affordable scan. *Exit: T3, T4 pass.*
- **M4 — the sorts.** All three keys, pairing verified after each. *Exit: T5 passes.*
- **M5 — the reports.** Low-stock, value. *Exit: T6 passes; the full menu is stable.*

## Tasks

1. Write the seed reader and `listAll`.
2. Write `findProduct`; build restock/sell on it.
3. Write the two searches.
4. Write the sorts — start with by-name selection sort, then generalise the key.
5. Write the two reports; walk the test plan.

## Test plan

| # | Seed & sequence | Expected |
| --- | --- | --- |
| T1 | seed 3 products → list | all three, aligned columns |
| T2 | sell 5 of qty 3 | refusal; list unchanged |
| T3 | search `Pen` (exists), `Zed` (doesn't) | found with details / not found |
| T4 | affordable ≤ 1.00 | every product ≤ 1.00 listed |
| T5 | sort by qty → list → sort by name → list | both orders correct, pairings right |
| T6 | value report with known data | per-line and total exact |

## Edge cases

- Selling *exactly* the full quantity (to zero) — legal.
- Two products with the same price — the affordable search lists both; sorting must be stable enough that pairing (not order) is the contract.
- A product name that prefixes another (`Pen`, `Pencil`) — exact-name matching must not confuse them.
- Sorting an empty or single-product stockroom.

## Extension ideas

1. A reorder report with target quantities (the Level 3 lab's rule, revisited here).
2. Binary search on the price-sorted copy (the algorithms module's precondition, exercised).
3. Undo the last movement (a small action history).

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] Every by-name operation flows through one `findProduct` (+1)
- [ ] After any sort, listing shows correct name↔qty↔price triplets (+1)
- [ ] Sell-to-zero is legal; sell-below-zero refused (+1)

## Hints

1. The sort's swap is three swaps (name, qty, price) — miss one and the stockroom lies. Write a `swapProduct(i, j)` helper so the three swaps exist once.
2. The affordable search is a *filter scan* (print every match), not a find-one — different shape than `findProduct`.
3. Value report: `qty * price` per line; accumulate in `double`; print with `setprecision(2)`.

## Complete reference solution

```cpp
// stockroom.cpp — Programming Fundamentals Using C++
// Project 6 · The Inventory Management System
// Build: g++ -std=c++17 -Wall -Wextra stockroom.cpp -o stockroom

#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
using namespace std;

const int MAX_PRODUCTS = 100;
const double PRICE_MIN = 0.01, PRICE_MAX = 10000.0;

int findProduct(const vector<string>& names, const string& target) {
    for (size_t i = 0; i < names.size(); ++i)
        if (names[i] == target) return static_cast<int>(i);
    return -1;
}

void seed(vector<string>& names, vector<int>& quantities, vector<double>& prices) {
    int n;
    cout << "How many products to enter (1-" << MAX_PRODUCTS << "): ";
    cin >> n;
    while (n < 1 || n > MAX_PRODUCTS) { cout << "1-" << MAX_PRODUCTS << ": "; cin >> n; }

    for (int i = 0; i < n; ++i) {
        string name; int qty; double price;
        cout << "Product " << (i + 1) << " name: ";
        cin >> name;
        while (findProduct(names, name) != -1) {   // uniqueness at entry
            cout << "Name already exists. Again: ";
            cin >> name;
        }
        cout << "quantity: ";
        cin >> qty;
        while (qty < 0) { cout << "Cannot be negative: "; cin >> qty; }
        cout << "price: ";
        cin >> price;
        while (price < PRICE_MIN || price > PRICE_MAX) {
            cout << "Price is 0.01-10000: ";
            cin >> price;
        }
        names.push_back(name);                    // the pairing transaction
        quantities.push_back(qty);
        prices.push_back(price);
    }
}

void listAll(const vector<string>& names, const vector<int>& quantities,
             const vector<double>& prices) {
    if (names.empty()) { cout << "Stockroom empty\n"; return; }
    cout << left << setw(12) << "Name" << right << setw(8) << "Qty"
         << setw(12) << "Price" << "\n";
    for (size_t i = 0; i < names.size(); ++i)
        cout << left << setw(12) << names[i] << right << setw(8) << quantities[i]
             << setw(12) << fixed << setprecision(2) << prices[i] << "\n";
}

void moveStock(vector<string>& names, vector<int>& quantities, bool receiving) {
    cout << "Product name: ";
    string name; cin >> name;
    int idx = findProduct(names, name);
    if (idx == -1) { cout << "No such product\n"; return; }

    cout << "Amount: ";
    int amt; cin >> amt;
    while (amt < 1) { cout << "At least 1: "; cin >> amt; }

    if (receiving) {
        quantities[idx] += amt;
        cout << "Received — qty " << quantities[idx] << "\n";
    } else if (amt > quantities[idx]) {
        cout << "Refused: only " << quantities[idx] << " in stock\n";
    } else {
        quantities[idx] -= amt;                   // sell-to-zero is legal
        cout << "Sold — qty " << quantities[idx] << "\n";
    }
}

void affordableSearch(const vector<string>& names, const vector<int>& quantities,
                      const vector<double>& prices) {
    cout << "Maximum price: ";
    double cap; cin >> cap;
    bool any = false;
    for (size_t i = 0; i < names.size(); ++i)
        if (prices[i] <= cap) {
            cout << "  " << names[i] << " (qty " << quantities[i]
                 << ", Rs " << fixed << setprecision(2) << prices[i] << ")\n";
            any = true;
        }
    if (!any) cout << "Nothing at or under that price\n";
}

void sortStock(vector<string>& names, vector<int>& quantities, vector<double>& prices,
               int key) {
    for (size_t i = 0; i + 1 < names.size(); ++i) {       // selection sort by key
        size_t best = i;
        for (size_t j = i + 1; j < names.size(); ++j) {
            bool smaller = false;
            if (key == 1)      smaller = names[j] < names[best];
            else if (key == 2) smaller = quantities[j] < quantities[best];
            else               smaller = prices[j] < prices[best];
            if (smaller) best = j;
        }
        if (best != i) {                                   // the pairing swap, once
            swap(names[i], names[best]);
            swap(quantities[i], quantities[best]);
            swap(prices[i], prices[best]);
        }
    }
    cout << "Sorted\n";
}

void valueReport(const vector<string>& names, const vector<int>& quantities,
                 const vector<double>& prices) {
    if (names.empty()) { cout << "Stockroom empty\n"; return; }
    double total = 0.0;
    cout << fixed << setprecision(2);
    for (size_t i = 0; i < names.size(); ++i) {
        double value = quantities[i] * prices[i];
        cout << "  " << names[i] << ": " << quantities[i] << " x Rs " << prices[i]
             << " = Rs " << value << "\n";
        total += value;
    }
    cout << "  TOTAL: Rs " << total << "\n";
}

int main() {
    vector<string> names;
    vector<int> quantities;
    vector<double> prices;

    cout << "=== Stockroom ===\n";
    seed(names, quantities, prices);

    int choice;
    do {
        cout << "\n1 List · 2 Restock · 3 Sell · 4 Find · 5 Affordable · "
                "6 Sort · 7 Value · 0 Quit: ";
        cin >> choice;

        if (choice == 1) {
            listAll(names, quantities, prices);
        } else if (choice == 2 || choice == 3) {
            moveStock(names, quantities, choice == 2);
        } else if (choice == 4) {
            cout << "Product name: ";
            string name; cin >> name;
            int idx = findProduct(names, name);
            if (idx == -1) cout << "Not found\n";
            else cout << "  " << names[idx] << " qty " << quantities[idx]
                      << " Rs " << fixed << setprecision(2) << prices[idx] << "\n";
        } else if (choice == 5) {
            affordableSearch(names, quantities, prices);
        } else if (choice == 6) {
            cout << "Sort by 1 name / 2 quantity / 3 price: ";
            int key; cin >> key;
            if (key >= 1 && key <= 3) sortStock(names, quantities, prices, key);
            else cout << "Invalid key\n";
        } else if (choice == 7) {
            valueReport(names, quantities, prices);
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    cout << "Goodbye — " << names.size() << " product(s) on file\n";
    return 0;
}
```

## Explanation of important design decisions

- **`findProduct` is the single lookup.** Restock, sell, and the search option all call it — the low-stock rule ("exact name, first match") is written once. When a rule exists once, it can be *changed* once (a future case-insensitive version touches one function).
- **The pairing swap is a named operation.** `swapProduct`-in-place (three `swap` calls at one site) means a fourth field someday extends one place, not every sort. The parallel-vector era's central risk — desynchronised columns — is contained by making the move atomic.
- **Sorting is in place and stated.** The requirement asks the student to *choose and document* copy-vs-in-place; the reference chooses in place (the stockroom's order is presentation-irrelevant) and the test plan verifies pairings after each sort — the check that matters more than the choice.
- **The affordable search is a filter, not a finder.** Printing every match is a different algorithm shape than find-first; conflating them is how "first match only" bugs are born. The two searches coexist in this project precisely to make the distinction physical.

[← Project 5](project-05-quiz-app.md) · [Projects home](index.md) · Next: [Project 7 — The Library Management System](project-07-library.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
