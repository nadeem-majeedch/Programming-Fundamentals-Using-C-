---
title: "Lab — The Modular Programming Lab"
description: "Split a working single-file inventory program into modules across five stages, then extend it without breaking it — with the staged build, the dependency diagram, and the regression file as gates."
---

# Lab — the Modular Programming Lab

> [← Module home](index.md) · Five stages: split → guard → namespace → build → extend · The regression file is the harness at every gate

## The scenario

A campus **inventory program** works — one file, 150 lines, the Unit 12 shape: load stock from a CSV, sell items, print a low-stock report, save. Your mission is not to write it (it is given below). It is to **take it apart along the module seams and put it back together better** — then **extend it without breaking it**, which is the skill the capstone will demand weekly.

**The program** (`inventory-vintage.cpp`, deliberately single-file):

```cpp
// inventory-vintage.cpp — Programming Fundamentals Using C++
// Modular Lab · the starting point (single file, pre-modern)
// Compile: g++ -std=c++17 -Wall -Wextra inventory-vintage.cpp -o inventory

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>
#include <stdexcept>
using namespace std;

struct Item {
    string name;
    int quantity;
    double price;
};

const int LOW_STOCK_THRESHOLD = 10;

vector<Item> loadStock(const string& path) {
    ifstream in(path);
    if (!in) throw runtime_error("loadStock: cannot open " + path);
    vector<Item> items;
    string line;
    while (getline(in, line)) {
        if (line.empty()) continue;
        stringstream ss(line);
        Item it;
        string qty, price;
        if (getline(ss, it.name, ',') && getline(ss, qty, ',') && getline(ss, price, ','))
            items.push_back(Item{it.name, stoi(qty), stod(price)});
    }
    return items;
}

void sell(vector<Item>& items, const string& name, int qty) {
    for (Item& it : items) {
        if (it.name == name) {
            if (qty > it.quantity) throw runtime_error("sell: not enough stock for " + name);
            it.quantity -= qty;
            return;
        }
    }
    throw runtime_error("sell: no such item: " + name);
}

void printLowStock(const vector<Item>& items) {
    cout << "LOW STOCK (under " << LOW_STOCK_THRESHOLD << "):\n";
    for (const Item& it : items)
        if (it.quantity < LOW_STOCK_THRESHOLD)
            cout << "  " << it.name << " x" << it.quantity << "\n";
}

void saveStock(const vector<Item>& items, const string& path) {
    ofstream out(path);
    if (!out) throw runtime_error("saveStock: cannot open " + path);
    for (const Item& it : items) out << it.name << "," << it.quantity << "," << it.price << "\n";
}

int main() {
    try {
        vector<Item> stock = loadStock("stock.csv");
        sell(stock, "Notebook", 5);
        sell(stock, "Pen", 25);
        printLowStock(stock);
        saveStock(stock, "stock.csv");
    } catch (const exception& e) {
        cerr << "error: " << e.what() << "\n";
        return 1;
    }
    return 0;
}
```

**Create the regression file first** (the harness at every gate): `stock.csv` with `Notebook,20,0.80`, `Pen,40,0.50`, `Eraser,8,0.30`; run the vintage program; save its exact output; verify `stock.csv` after. **Every stage must reproduce this byte-for-byte.**

---

## Stage 1 — the split (records + inventory + thin main)

**Decision first, drawing second, files third.** Two modules by responsibility:

```text
inventory.h/.cpp  — owns Item, loadStock, sell, saveStock   (the data module)
reports.h/.cpp    — owns printLowStock                       (the presentation module)
main.cpp          — the scenario only
```

Dependency diagram (draw it — then check it is one-way: `reports` *views* `Item`, so it includes `inventory.h`; `main` includes both):

**Tasks.** Move the declarations to the two headers (`#pragma once`, minimal includes — `<string>`, `<vector>`; *not* `<iostream>`, which no header needs); the bodies to the two `.cpp` files (own header first); leave `main` thin. Gate: three-file build; output byte-identical; each `.cpp` compiles alone.

## Stage 2 — the guards

**Tasks.** Write both headers twice — include guards first, then `#pragma once` (keep the pragma version). Then the deliberate accident: include `inventory.h` twice in `main.cpp` (directly and via `reports.h`) with the guards *removed* — record the compiler verdict; restore the pragma. Gate: the accident's error message quoted in your notes; builds green.

## Stage 3 — the namespaces

**Tasks.** Wrap `inventory` in `namespace inventory` and the report in `namespace reports`. Retire `using namespace std;` — spell `std::` everywhere. Qualify every cross-module call (`inventory::Item`, `inventory::sell`, `reports::printLowStock`). Gate: zero using-directives anywhere; output identical.

## Stage 4 — the staged build (the professional rhythm)

**Tasks.** Build the project both ways — one-shot (`-Iinclude` if you adopted the include/ layout) and staged (`-c` each, then link). Then perform the **incremental edit**: add a `restock(vector<Item>&, const string&, int)` function to `inventory` only, rebuild staged, and record exactly which commands ran. Gate: the build recipe (your command list) written down; incremental rebuild is two commands, not four.

## Stage 5 — the extension without breakage

A new requirement arrives, as it will in the capstone: **"the low-stock report needs prices and a total value."**

**Tasks.**

1. Decide *which module changes*: the answer is `reports` only — and check your instinct against the dependency diagram (the data module needs *nothing*; the price already travels on `Item`).
2. Extend the report: `printLowStock` gains the price column and the total value line — using `std::fixed`/`setprecision` for money (the IO module's formatting habit).
3. Rebuild staged; run the regression file. **Byte-compare against a *newly recorded* expected output** (the report legitimately changed — record the new baseline *after* confirming the unchanged lines are unchanged).
4. Then the harder extension: **"sell needs a transaction log"** — decide the module (new leaf `audit.h/.cpp`, or a function inside `inventory`?), draw the diagram *before* coding, implement, rebuild, re-run the regression.

Gate: both extensions land without touching the other module's header; the diagrams for both are one-way; the regression file is the referee.

---

## The solution pass (stages 1+3 shape, compressed)

```text
inventory-lab/
├── include/
│   ├── inventory.h
│   └── reports.h
└── src/
    ├── main.cpp
    ├── inventory.cpp
    └── reports.cpp
```

```cpp
// include/inventory.h
#pragma once

#include <string>
#include <vector>

namespace inventory {

struct Item {
    std::string name;
    int quantity;
    double price;
};

std::vector<Item> loadStock(const std::string& path);   // throws on missing file
void sell(std::vector<Item>& items, const std::string& name, int qty);
void saveStock(const std::vector<Item>& items, const std::string& path);

}  // namespace inventory
```

```cpp
// include/reports.h
#pragma once

#include <vector>
#include "inventory.h"        // the one-way arrow: reports views inventory's Item

namespace reports {

void printLowStock(const std::vector<inventory::Item>& items);

}  // namespace reports
```

The `.cpp` files deliver the vintage bodies unchanged — except every `std::` is spelled, every cross-module name is qualified, and each file opens with its own header. `main.cpp` keeps the vintage scenario, qualified. **The staged build:**

```bash
g++ -std=c++17 -Wall -Wextra -c -Iinclude src/main.cpp     -o main.o
g++ -std=c++17 -Wall -Wextra -c -Iinclude src/inventory.cpp -o inventory.o
g++ -std=c++17 -Wall -Wextra -c -Iinclude src/reports.cpp   -o reports.o
g++ main.o inventory.o reports.o -o inventory
```

## Explanation

- **The seams were already there.** `printLowStock` never mutated, `loadStock`/`sell`/`saveStock` never printed — the vintage program *was* two modules wearing one file. The lab's real lesson: modularization is not rewriting; it is *noticing* the responsibilities the one-job rule already named.
- **The regression file is why the split is safe.** Every stage's gate is a byte-comparison — the Debugging module's regression discipline, doing for structure what it did for bugs. Refactoring without a referee is rewriting with extra steps.
- **Stage 5's quiet point:** the first extension touched *one module* because the dependency diagram promised it could. When the second extension needed a decision (leaf vs function), the diagram *before coding* was what made the decision cheap. That — not the code — is the modular-design skill.
- **The incremental rebuild is the dividend.** Two commands after one file changes; the vintage program paid four every time. At capstone scale the gap is minutes vs seconds — the engineering reason the header/source split exists.

## ⭐ Extensions

1. **The stranger test:** extract `loadStock`/`saveStock`'s CSV parsing into a reusable `csvutil` leaf module (split/join, the [example project](example-project.md)'s `textutil::split` shape) and have `inventory` consume it. Diagram first; both modules compile alone.
2. **The forward declaration:** change `reports::printLowStock` to take `const inventory::Item* items, size_t count` — then attempt to drop `inventory.h` from `reports.h` with a forward declaration of `struct Item`. Explain exactly why it works for the pointer signature and fails the moment the report holds values.
3. **The capstone rehearsal:** run this lab's five stages on your own Project 3 code (or T8 of the [organization tasks](tasks.md)) — the regression file, the diagram, and the build recipe are the deliverables.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
