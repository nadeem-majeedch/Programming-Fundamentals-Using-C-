---
title: "Project 7 — The Library Management System"
description: "A record-based library with borrowing state and file persistence — structs, search, state transitions, and the load-view-mutate-save cycle."
---

# Project 7 — The Library Management System

> [← Projects home](index.md) · [← Project 6](project-06-inventory.md) · Tier: Advanced · **Units first: 10–12** — records (structs), search/sort, file I/O

## Overview

The departmental library as a small system: books are *records* (title, author, copies, initial copies) loaded from `books.csv`, managed through a menu (list, search, borrow, return, add), and saved back on exit. The step up from Project 6 is twofold — records replace parallel vectors, and *state now survives the program* through files.

## Learning objectives

- model entities as structs and pass them by reference through operations
- enforce state transitions (borrow/return bounds) at the operation layer
- implement the load → view → mutate → save cycle with a written format contract
- handle missing files, malformed lines, and first-run seeding

## Prerequisites

| Unit | What you need |
| --- | --- |
| [14 · records](../records/index.md) | struct definition, passing/returning records |
| [10](../algorithms/index.md) | search over record collections |
| [12](../files/index.md) | ifstream/ofstream, open-check, getline parsing, EOF discipline |

## Requirements

1. `struct Book { string title, author; int copies, initial; };` — copies ∈ [0, initial], initial ∈ [1, 99].
2. Contract: `books.csv` lines are `title,author,copies,initial` (no commas in text fields). The contract comment sits above both I/O functions.
3. Missing file → seed three books, then load.
4. Menu: 1 list · 2 search (title, case-sensitive prefix) · 3 borrow · 4 return · 5 add · 6 save now · 0 save & quit.
5. Borrow refuses at 0 copies; return refuses above `initial`; both report the resulting availability.
6. Malformed lines are skipped and counted at load; `add` refuses duplicate titles.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | first run seeds and loads 3 books | T1 |
| F2 | borrow decrements; refusal at zero | T2 |
| F3 | return increments to at most `initial` | T3 |
| F4 | added books appear in list and file | T4 |
| F5 | malformed lines never abort the load | T5 |
| F6 | everything saved on quit survives a restart | T6 |

## Suggested data structures

- `vector<Book>` — the record collection.
- `findBook(books, title)` returning `Book*` or `nullptr` (views over the vector).
- Load reports: a skipped counter; add-time duplicate check via the finder.

## Milestones

- **M1 — the record and the file.** Struct, contract comment, loader with skip counting, seeder. *Exit: T1 passes.*
- **M2 — list and search.** The columnar listing and prefix search. *Exit: both work on seeded data.*
- **M3 — borrow/return.** The two bounded transitions with their refusals. *Exit: T2, T3 pass.*
- **M4 — add + save.** Duplicate-guarded add; save; quit path. *Exit: T4 and T6 pass.*
- **M5 — hostile files.** A hand-mangled CSV (bad fields, missing commas) loads with skips. *Exit: T5 passes.*

## Tasks

1. Define the struct; write the contract comment; write `seedIfMissing` and `loadBooks`.
2. Write `findBook`; build list and prefix search.
3. Write `borrowBook`/`returnBook` as bounded ask-doors.
4. Write `addBook` and `saveBooks`; assemble the menu.
5. Run the test plan including the hostile-file test.

## Test plan

| # | Scenario | Expected |
| --- | --- | --- |
| T1 | delete `books.csv`, run | "seeded 3", list shows them |
| T2 | borrow twice on a 2-copy book, then again | 1 left, 0 left, then refusal |
| T3 | return up to initial, then once more | accepted to initial, then refusal |
| T4 | add `C++ Primer,Lippman,3`, quit, restart | present after restart |
| T5 | file with `Bad,Line`, `NoCommas`, one valid row | one skip note (2 malformed), the valid row loads |
| T6 | borrow 1, quit, restart, list | availability reflects the borrow |

## Edge cases

- A book whose `copies` in the file exceeds `initial` — the loader's validation refuses the line (skipped).
- Borrowing on an empty library — the menu reports honestly.
- A title that prefixes another (`C++` vs `C++ Primer`) — prefix search lists both; exact operations match exactly.
- Save with zero books — a valid empty file, and the next run must not treat it as "missing".

## Extension ideas

1. A borrower log file (append-only: who borrowed what, when) — the audit-trail habit.
2. Sort the listing by title or by availability.
3. A "my loans" view for one member name.

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] The contract comment exists and both I/O functions honour it (+1)
- [ ] No state transition can leave copies outside [0, initial] (+1)
- [ ] A restart after any menu sequence shows exactly the saved state (+1)

## Hints

1. The four-field split is three `find(',')` calls — guard every one before slicing.
2. `stoi` inside a `try` at load: both `invalid_argument` and `out_of_range` mean "malformed line".
3. The borrow/return guards are one comparison each *because* `initial` is stored — storing derived or missing state is what makes returns unvalidatable.

## Complete reference solution

```cpp
// library.cpp — Programming Fundamentals Using C++
// Project 7 · The Library Management System
// Build: g++ -std=c++17 -Wall -Wextra library.cpp -o library

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
using namespace std;

// Format contract — books.csv, one record per line:
//   title,author,copies,initial
//   (no commas inside title/author; 1 <= initial <= 99; 0 <= copies <= initial)
// This comment governs BOTH loadBooks and saveBooks; change them together.

struct Book {
    string title, author;
    int copies, initial;
};

void seedIfMissing(const string& path) {
    ifstream probe(path);
    if (probe) return;                       // file exists: nothing to seed
    ofstream out(path);
    out << "Clean Code,Martin,2,2\n";
    out << "Algorithms,Cormen,1,3\n";
    out << "C++ Primer,Lippman,3,3\n";
}

int loadBooks(const string& path, vector<Book>& out) {
    ifstream in(path);
    if (!in) return 0;
    string line;
    int skipped = 0;
    while (getline(in, line)) {              // read the line, then the line's end
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
        size_t c3 = (c2 == string::npos) ? string::npos : line.find(',', c2 + 1);
        if (c3 == string::npos) { ++skipped; continue; }
        try {
            Book b;
            b.title   = line.substr(0, c1);
            b.author  = line.substr(c1 + 1, c2 - c1 - 1);
            b.copies  = stoi(line.substr(c2 + 1, c3 - c2 - 1));
            b.initial = stoi(line.substr(c3 + 1));
            bool valid = !b.title.empty() && !b.author.empty()
                         && b.initial >= 1 && b.initial <= 99
                         && b.copies >= 0 && b.copies <= b.initial;
            if (!valid) { ++skipped; continue; }
            out.push_back(b);
        } catch (const exception&) {          // stoi refused: malformed line
            ++skipped;
        }
    }
    return skipped;
}

void saveBooks(const string& path, const vector<Book>& books) {
    ofstream out(path);                       // truncating: the whole library is rewritten
    for (const Book& b : books)
        out << b.title << "," << b.author << "," << b.copies << "," << b.initial << "\n";
}

Book* findBook(vector<Book>& books, const string& title) {
    for (Book& b : books)
        if (b.title == title) return &b;
    return nullptr;
}

void listAll(const vector<Book>& books) {
    if (books.empty()) { cout << "Library empty\n"; return; }
    for (const Book& b : books)
        cout << "  " << b.title << " by " << b.author
             << " (" << b.copies << "/" << b.initial << " available)\n";
}

void searchByPrefix(const vector<Book>& books, const string& prefix) {
    bool any = false;
    for (const Book& b : books)
        if (b.title.find(prefix) == 0) {      // prefix = find at position 0
            cout << "  " << b.title << " by " << b.author << "\n";
            any = true;
        }
    if (!any) cout << "  no matches\n";
}

bool borrowBook(Book& b) {                    // the state transition, bounded
    if (b.copies <= 0) return false;
    --b.copies;
    return true;
}

bool returnBook(Book& b) {
    if (b.copies >= b.initial) return false;
    ++b.copies;
    return true;
}

bool addBook(vector<Book>& books, const Book& candidate) {
    if (findBook(books, candidate.title) != nullptr) return false;   // duplicate title
    if (candidate.initial < 1 || candidate.initial > 99) return false;
    if (candidate.copies < 0 || candidate.copies > candidate.initial) return false;
    books.push_back(candidate);
    return true;
}

int main() {
    const string PATH = "books.csv";
    seedIfMissing(PATH);

    vector<Book> books;
    int skipped = loadBooks(PATH, books);
    if (skipped) cout << "Skipped " << skipped << " malformed line(s)\n";
    cout << "Loaded " << books.size() << " books\n";

    int choice;
    do {
        cout << "\n1 List · 2 Search · 3 Borrow · 4 Return · 5 Add · 6 Save · 0 Save & quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');

        if (choice == 1) {
            listAll(books);
        } else if (choice == 2) {
            cout << "Title (or prefix): ";
            string prefix; getline(cin, prefix);
            searchByPrefix(books, prefix);
        } else if (choice == 3 || choice == 4) {
            cout << "Title: ";
            string title; getline(cin, title);
            Book* b = findBook(books, title);
            if (!b) { cout << "No such book\n"; continue; }
            bool ok = (choice == 3) ? borrowBook(*b) : returnBook(*b);
            if (ok) cout << (choice == 3 ? "Borrowed — " : "Returned — ")
                         << b->copies << " of " << b->initial << " available\n";
            else    cout << "Refused: "
                         << (choice == 3 ? "no copies left" : "already at initial count")
                         << "\n";
        } else if (choice == 5) {
            Book candidate;
            cout << "Title: ";  getline(cin, candidate.title);
            cout << "Author: "; getline(cin, candidate.author);
            cout << "Initial copies (1-99): ";
            cin >> candidate.initial;
            candidate.copies = candidate.initial;
            if (addBook(books, candidate)) cout << "Added\n";
            else cout << "Refused: duplicate title or invalid counts\n";
            cin.ignore(1000, '\n');
        } else if (choice == 6) {
            saveBooks(PATH, books);
            cout << "Saved " << books.size() << " books\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    saveBooks(PATH, books);
    cout << "Saved " << books.size() << " books — goodbye\n";
    return 0;
}
```

## Explanation of important design decisions

- **The contract is a comment with authority.** It sits above `loadBooks` and `saveBooks`, names every field, every bound, and the no-comma rule — and the load-time validation *enforces* it (empty fields, ranges). The Files module's rule — the contract is documentation adjacent to code, changed only in the same edit — is what makes T6 (restart correctness) trustworthy.
- **State transitions live in the record's operations, not the menu.** `borrowBook`/`returnBook` take a `Book&` and know the bounds; the menu only finds the book and reports. When the rules change (a 14-day loan limit someday), they change in one function.
- **`initial` is stored, not derived.** The return-cap rule needs the original count *after* copies have changed; deriving it is impossible, so it is persisted — the rare case where storing redundant state is *correct*, because the alternative is an unenforceable rule.
- **Seed-then-load.** First-run behaviour is part of the system: create-then-load means the program is demonstrable from zero, and the empty-file case (created by saving zero books) is distinguishable from missing (the probe opens it) — the two "no books" states stay distinct.

[← Project 6](project-06-inventory.md) · [Projects home](index.md) · Next: [Project 8 — The Contact Management System](project-08-contacts.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
