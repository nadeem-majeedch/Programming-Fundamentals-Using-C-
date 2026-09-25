---
title: "Project 8 — The Contact Management System"
description: "The syllabus's Project 3 domain, rehearsed: a validated, persistent contact book with multiple search keys, sorted views, and duplicate guards."
---

# Project 8 — The Contact Management System

> [← Projects home](index.md) · [← Project 7](project-07-library.md) · Tier: Advanced · **Units first: 12–13** — files, records, validation layers. *This is the capstone's own domain — build it before [Project 3 of the syllabus](../syllabus.md#stage-f-capstone-unit-16) and the capstone becomes a refinement.*

## Overview

A personal contact manager over `contacts.csv` (`name,phone,email`): add with *field-level validation* (unique names, digit-only phones, `@`-bearing emails), delete, exact and phone lookups, a sorted listing view, and persistence. The step up from Project 7 is validation depth and *multiple views of one dataset* — the file keeps arrival order, the listing sorts a copy.

## Learning objectives

- enforce per-field validation rules with re-prompting at the entry layer
- maintain two views of one dataset (arrival-order storage, sorted presentation)
- guard a unique key at insert time
- implement delete-by-key over records with clean persistence afterwards

## Prerequisites

| Unit | What you need |
| --- | --- |
| [12](../files/index.md) | the load/mutate/save cycle, CSV parsing |
| [14 · records](../records/index.md) | structs as records |
| [11](../strings/index.md) | character classification for field validation |

## Requirements

1. `struct Contact { string name, phone, email; };`
2. Contract: `name,phone,email` — names unique; phone = 10–13 digits; email contains `@`. The contract comment sits above both I/O functions; the loader enforces it line by line.
3. Menu: 1 list (sorted by name) · 2 find by name · 3 find by phone · 4 add · 5 delete · 6 save now · 0 save & quit.
4. Add runs the three validators with re-prompts; refuses duplicate names (ask-door).
5. Delete removes by exact name and echoes the removed record.
6. The sorted listing works on a copy — the file's arrival order is never reordered by a view.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | sorted listing is alphabetical and leaves the file order intact | T1 |
| F2 | both lookups find or report honestly | T2 |
| F3 | duplicate-name add is refused; valid adds land | T3 |
| F4 | invalid phone/email re-prompt until legal | T4 |
| F5 | delete removes and the removal survives a restart | T5 |
| F6 | malformed file lines are skipped with a count | T6 |

## Suggested data structures

- `vector<Contact>` — the storage in arrival order.
- `findByName` / `findByPhone` — two finders over one vector (the two-key pattern).
- Sorted view: a local copy sorted with a name comparator (the lambda form from the STL module, or a named function — state your choice).

## Milestones

- **M1 — the file layer.** Contract comment, loader (validating!), saver. *Exit: T6 passes.*
- **M2 — the views.** Sorted listing, both lookups. *Exit: T1, T2 pass.*
- **M3 — the entry layer.** The three validators, the duplicate guard, add. *Exit: T3, T4 pass.*
- **M4 — delete + persistence.** Delete by name; save paths; the restart test. *Exit: T5 passes; the full menu is stable.*

## Tasks

1. Write the struct, contract, loader (with line validation), saver.
2. Write the two finders and the sorted view.
3. Write `readPhone`/`readEmail` validators and `addContact`.
4. Write delete; assemble the menu; walk the test plan including restart tests.

## Test plan

| # | Sequence | Expected |
| --- | --- | --- |
| T1 | add Bilal, Aisha → list | Aisha first (sorted); quit; file shows arrival order (Bilal first) |
| T2 | find `Aisha` (hit), `Zed` (miss); find by phone both ways | honest results |
| T3 | add `Aisha` again → refused; add `Sara` → accepted | refusal message; add lands |
| T4 | phone `abc` → re-prompt; email `no-at-sign` → re-prompt | validators hold until legal |
| T5 | delete `Bilal`, quit, restart, list | Bilal gone after restart |
| T6 | file with `Bad,123`, `Ok,03001234567,a@b.pk` | 1 skipped, 1 loaded |

## Edge cases

- A phone of 9 or 14 digits — both refuse (the range is part of the contract).
- An email with `@` but empty local part (`@x.pk`) — this contract accepts it; document the honesty of that choice (the validator checks presence, not shape).
- Deleting from an empty book; listing an empty book — the empty states.
- A name that differs only by case — case-*sensitive* uniqueness; document it.

## Extension ideas

1. Partial-name search (substring) listing all hits.
2. An export-to-sorted-file command — a view written to disk.
3. A birthday field with a "this month" report (the contract migrates: load, save, validation, views together).

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] No invalid phone/email can enter storage from *either* the menu or the file (+1)
- [ ] The sorted view never reorders storage (verifiable by saving after a listing) (+1)
- [ ] Uniqueness is enforced at add-time, not discovered at save-time (+1)

## Hints

1. The loader validating fields means file-borne bad data dies at the door — the same rules, two entrances.
2. Phone validation is a character loop: length check, then `isdigit` over every char.
3. Delete = find + `erase(begin + index)` — compute the index once, use it once.

## Complete reference solution

```cpp
// contacts.cpp — Programming Fundamentals Using C++
// Project 8 · The Contact Management System
// Build: g++ -std=c++17 -Wall -Wextra contacts.cpp -o contacts

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <cctype>
using namespace std;

// Format contract — contacts.csv, one record per line:
//   name,phone,email
//   (names unique & case-sensitive; phone = 10..13 digits; email contains '@')
// This comment governs BOTH loadContacts and saveContacts; change them together.

struct Contact {
    string name, phone, email;
};

bool phoneIsLegal(const string& phone) {
    if (phone.size() < 10 || phone.size() > 13) return false;
    for (char ch : phone)
        if (!isdigit(static_cast<unsigned char>(ch))) return false;
    return true;
}

bool emailIsLegal(const string& email) {
    return email.find('@') != string::npos;      // presence, not shape — documented
}

bool contactIsLegal(const Contact& c) {          // the whole-record contract
    return !c.name.empty() && phoneIsLegal(c.phone) && emailIsLegal(c.email);
}

int loadContacts(const string& path, vector<Contact>& out) {
    ifstream in(path);
    if (!in) return 0;
    string line;
    int skipped = 0;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
        if (c2 == string::npos) { ++skipped; continue; }
        Contact c;
        c.name  = line.substr(0, c1);
        c.phone = line.substr(c1 + 1, c2 - c1 - 1);
        c.email = line.substr(c2 + 1);
        if (!contactIsLegal(c)) { ++skipped; continue; }
        out.push_back(c);
    }
    return skipped;
}

void saveContacts(const string& path, const vector<Contact>& contacts) {
    ofstream out(path);
    for (const Contact& c : contacts)
        out << c.name << "," << c.phone << "," << c.email << "\n";
}

Contact* findByName(vector<Contact>& contacts, const string& name) {
    for (Contact& c : contacts)
        if (c.name == name) return &c;
    return nullptr;
}

Contact* findByPhone(vector<Contact>& contacts, const string& phone) {
    for (Contact& c : contacts)
        if (c.phone == phone) return &c;
    return nullptr;
}

void printContact(const Contact& c) {
    cout << "  " << c.name << " — " << c.phone << " — " << c.email << "\n";
}

string readPhone() {                             // the entry-layer validator
    string phone;
    cout << "Phone (10-13 digits): ";
    getline(cin, phone);
    while (!phoneIsLegal(phone)) {
        cout << "Digits only, 10-13 of them: ";
        getline(cin, phone);
    }
    return phone;
}

string readEmail() {
    string email;
    cout << "Email: ";
    getline(cin, email);
    while (!emailIsLegal(email)) {
        cout << "Must contain '@': ";
        getline(cin, email);
    }
    return email;
}

bool addContact(vector<Contact>& contacts, const Contact& candidate) {
    if (findByName(contacts, candidate.name) != nullptr) return false;   // unique key
    if (!contactIsLegal(candidate)) return false;
    contacts.push_back(candidate);
    return true;
}

int main() {
    const string PATH = "contacts.csv";
    vector<Contact> contacts;

    int skipped = loadContacts(PATH, contacts);
    if (skipped) cout << "Skipped " << skipped << " malformed line(s)\n";
    cout << "Loaded " << contacts.size() << " contacts\n";

    int choice;
    do {
        cout << "\n1 List (sorted) · 2 Find by name · 3 Find by phone · "
                "4 Add · 5 Delete · 6 Save · 0 Save & quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');

        if (choice == 1) {
            if (contacts.empty()) { cout << "Contact book empty\n"; continue; }
            vector<Contact> view = contacts;     // sort the COPY — storage keeps arrival order
            sort(view.begin(), view.end(),
                 [](const Contact& a, const Contact& b) { return a.name < b.name; });
            for (const Contact& c : view) printContact(c);
        } else if (choice == 2 || choice == 3) {
            cout << (choice == 2 ? "Name: " : "Phone: ");
            string key; getline(cin, key);
            Contact* c = (choice == 2) ? findByName(contacts, key)
                                       : findByPhone(contacts, key);
            if (c) printContact(*c);
            else   cout << "  not found\n";
        } else if (choice == 4) {
            Contact candidate;
            cout << "Name: ";
            getline(cin, candidate.name);
            if (findByName(contacts, candidate.name)) {   // the unique-key guard, first
                cout << "Refused: name already present\n";
                continue;
            }
            candidate.phone = readPhone();
            candidate.email = readEmail();
            if (addContact(contacts, candidate)) cout << "Added\n";
            else cout << "Refused\n";
        } else if (choice == 5) {
            cout << "Name to delete: ";
            string name; getline(cin, name);
            Contact* c = findByName(contacts, name);
            if (!c) { cout << "  not found\n"; continue; }
            cout << "Deleted " << c->name << " (" << c->phone << ")\n";
            contacts.erase(contacts.begin() + (c - &contacts[0]));
        } else if (choice == 6) {
            saveContacts(PATH, contacts);
            cout << "Saved " << contacts.size() << " contacts\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    saveContacts(PATH, contacts);
    cout << "Saved " << contacts.size() << " contacts — goodbye\n";
    return 0;
}
```

## Explanation of important design decisions

- **The validators are shared by both entrances.** `contactIsLegal` guards the file load *and* backs the menu's re-prompt loops — the same rules for typed and file-borne data. Two entrances, one law: this is the "validate at the boundary" principle where "boundary" means *any* ingress, not just the keyboard.
- **Views sort copies.** The lambda comparator sorts a local vector; storage keeps arrival order. The test that proves it (save right after a listing; the file shows arrival order) is in the plan — a view that reorders storage is the classic subtle bug of two-view systems.
- **The unique-key guard runs before the validators.** Add checks the duplicate *first* so the user isn't made to re-type a legal phone/email for a name that will be refused anyway — validation order is user-experience design at the smallest scale.
- **`@`-presence is the honest minimum.** Full email validation is a rabbit hole this course deliberately avoids; the contract states exactly what is checked (presence) and T-documents the `@x.pk` acceptance. A validator that lies about its scope is worse than a narrow one that tells the truth.

[← Project 7](project-07-library.md) · [Projects home](index.md) · Next: [Project 9 — The File-Based Student Management System](project-09-student-files.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
