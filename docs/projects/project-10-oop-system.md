---
title: "Project 10 — The Integrated OOP Management System"
description: "The capstone rehearsal: a class-based, file-persisted, validated management system — encapsulation, vectors of objects, modern habits, and the full load-view-mutate-save cycle as one design."
---

# Project 10 — The Integrated OOP Management System

> [← Projects home](index.md) · [← Project 9](project-09-student-files.md) · Tier: Integrated · **Units first: 14–16** — classes and encapsulation, vectors of objects, the modern toolkit. *This is the full rehearsal: the same architecture as the syllabus's Project 3, one domain over.*

## Overview

A **Fee Account Office** for a student society: members hold fee accounts (classes with enforced invariants), the office manages them through a menu (open, deposit, charge, list, arrears report), every operation is logged to an append-only file, and the roster persists to `members.csv`. Project 9's system rebuilt *the OOP way*: the data defends itself, ownership is explicit, and the menu becomes thin.

## Learning objectives

- design classes whose invariants cannot be violated from outside
- manage a `vector` of objects through a thin, delegating menu
- separate the domain layer (classes) from the application layer (menu, logging, files)
- apply the modern toolkit deliberately: `const` correctness, RAII-owned files, no raw owning pointers

## Prerequisites

| Unit | What you need |
| --- | --- |
| [15 · OOP](../oop/index.md) | classes, encapsulation, constructors, `const` members, vectors of objects |
| [12](../files/index.md) | persistence (Projects 7–9 experience assumed) |
| [16 · Modern C++](../modern-cpp/index.md) | RAII, `const`-first, the standard-library-first habit |

## Requirements

1. `class Member` — name (const after construction), roll (const, unique), balance; validating constructor (balance ≥ 0); `deposit` (amount > 0), `charge` (amount > 0 and ≤ balance — e.g. fee charges), `balance()` and `name()` queries; refusals are ask-door `bool`s that change nothing.
2. Contract: `members.csv` = `roll,name,balance` — rolls unique; balances ≥ 0 (2 dp). Contract comment above both I/O functions.
3. `class FeeOffice` — owns the `vector<Member>`; operations: `openMember`, `depositTo`, `chargeTo`, `findByRoll`, `arrearsList` (balance below a named threshold); the menu *only* calls these.
4. Log: `office.log` (append mode) records every operation and refusal, one line each, flush-verified.
5. Persistence: save on quit (and a save-now option); restart restores the roster exactly.
6. Modern habits, enforced by the rubric: `const`-correct signatures, no raw `new`/`delete` anywhere, named constants for the arrears threshold and charge limits.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | an invalid member (negative opening) cannot exist | T1 |
| F2 | deposit/charge refusals leave state untouched and log REFUSED | T2 |
| F3 | charge exactly to zero is legal; below zero refused | T3 |
| F4 | arrears report lists members under the threshold | T4 |
| F5 | every operation and refusal appears in the log | T5 |
| F6 | restart restores the roster exactly | T6 |

## Suggested data structures

- `class Member` as above; the roster is `vector<Member>` *inside* `FeeOffice` — the menu never sees the vector.
- The log writer as a small RAII helper (constructor opens append, method writes+verifies) or as a free function — choose, and defend in the design notes.
- Arrears threshold: `constexpr double ARREARS_BELOW = 500.0;`

## Milestones

- **M1 — the domain class.** `Member` with its gate and ask-doors; a driver `main` exercising it. *Exit: T1–T3 pass without any file code.*
- **M2 — the office.** `FeeOffice` wrapping the vector; the menu delegating. *Exit: the menu body fits on one screen.*
- **M3 — the log.** Append-mode logging of operations and refusals. *Exit: T5 passes.*
- **M4 — persistence.** Contracts, load/save through the office. *Exit: T6 passes.*
- **M5 — the arrears report + polish.** The report, named constants, the const sweep. *Exit: T4 passes; the rubric's modern-habits items are all checkable.*

## Tasks

1. Write `Member` (gate, ask-doors, const queries); the M1 driver.
2. Write `FeeOffice` (own the vector; delegate everything).
3. Write the log writer; wire every office operation to log its outcome.
4. Write both contracts and the load/save pair through `FeeOffice`.
5. Write the arrears report; do the const sweep; run the whole test plan.

## Test plan

| # | Sequence | Expected |
| --- | --- | --- |
| T1 | open `Ali, −100` | refused at the gate; Ali does not exist |
| T2 | open `Ali,500` → deposit 250 → charge 9999 | balance 750; the charge refused; log has all three lines |
| T3 | charge 750 exactly, then charge 1 | balance 0.00; the second refused |
| T4 | three members, balances 750 / 300 / 0 | arrears lists the 300 and the 0 |
| T5 | any five operations | the log shows five lines, refusals included |
| T6 | operations → quit → restart → list | identical roster |

## Edge cases

- A member whose balance is *already* under the threshold at open — the arrears report includes them immediately.
- Deposit of exactly 0.00 — refused (the rule is `> 0`); document why zero is not a deposit.
- The log file's directory made read-only — the flush-verify reports the failure and the program continues honestly.
- A roll that differs only by case — case-sensitive uniqueness, documented.

## Extension ideas

1. `transferTo` with all-or-nothing ordering (the Robustness module's transaction shape).
2. A monthly summary line appended to the log on quit (totals of deposits/charges).
3. Member types (`enum class Tier`) with different charge limits — the records module's enum discipline, class-hosted.

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] The menu contains zero direct balance arithmetic (+1)
- [ ] No raw `new`/`delete` anywhere; files are RAII-owned (+1)
- [ ] Every `Member` method is const-correct; the roster is touched only by `FeeOffice` (+1)
- [ ] The log is a complete audit trail — refusals included (+1)

## Hints

1. `Member`'s constructor gate *throws*; `FeeOffice::openMember` catches and logs — the class refuses to exist invalid, the office decides what that means (layer separation from the Robustness module).
2. The menu's read of names/rolls precedes every `getline`-after-`>>` with `cin.ignore` — the IO habit, at every prompt.
3. Save writes balances with `fixed/setprecision(2)`; load parses with `stod` in a try — the contract's two ends.

## Complete reference solution

```cpp
// office.cpp — Programming Fundamentals Using C++
// Project 10 · The Integrated OOP Management System
// Build: g++ -std=c++17 -Wall -Wextra office.cpp -o office

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
#include <iomanip>
using namespace std;

// Contract members.csv: "roll,name,balance" — rolls unique (case-sensitive),
// balance >= 0 stored with 2 decimals. Governs loadMembers and saveMembers together.

constexpr double ARREARS_BELOW = 500.0;
const string LOG_PATH = "office.log";

class Member {                                   // the domain layer: it defends itself
public:
    Member(const string& roll, const string& name, double opening)
        : roll_(roll), name_(name), balance_(opening) {
        if (opening < 0)
            throw invalid_argument("negative opening balance for " + roll);
    }

    bool deposit(double amount) {
        if (amount <= 0) return false;           // zero is not a deposit — documented
        balance_ += amount;
        return true;
    }

    bool charge(double amount) {
        if (amount <= 0 || amount > balance_) return false;
        balance_ -= amount;
        return true;
    }

    double balance() const { return balance_; }
    const string& roll() const { return roll_; }
    const string& name() const { return name_; }

private:
    const string roll_;                          // const: identity is born, not edited
    const string name_;
    double balance_;
};

void logOperation(const string& line) {          // the audit trail: RAII file, flush-verified
    ofstream log(LOG_PATH, ios::app);
    if (!log) { cerr << "warning: log unavailable\n"; return; }
    log << line << "\n";
    log.flush();
    if (!log) cerr << "warning: log write failed\n";
}

class FeeOffice {                                // the application layer: owns the roster
public:
    bool openMember(const string& roll, const string& name, double opening) {
        try {
            members_.push_back(Member(roll, name, opening));
            return true;
        } catch (const invalid_argument&) {
            return false;                        // the gate refused; the office reports
        }
    }

    bool depositTo(const string& roll, double amount) {
        Member* m = findByRoll(roll);
        return m && m->deposit(amount);
    }

    bool chargeTo(const string& roll, double amount) {
        Member* m = findByRoll(roll);
        return m && m->charge(amount);
    }

    const Member* findByRoll(const string& roll) const {
        for (const Member& m : members_)
            if (m.roll() == roll) return &m;
        return nullptr;
    }

    Member* findByRoll(const string& roll) {     // the mutating twin (two const-nesses)
        for (Member& m : members_)
            if (m.roll() == roll) return &m;
        return nullptr;
    }

    void arrearsList() const {
        bool any = false;
        for (const Member& m : members_)
            if (m.balance() < ARREARS_BELOW) {
                cout << "  " << m.roll() << " " << m.name()
                     << " — Rs " << fixed << setprecision(2) << m.balance() << "\n";
                any = true;
            }
        if (!any) cout << "  nobody in arrears\n";
    }

    void listAll() const {
        if (members_.empty()) { cout << "  no members\n"; return; }
        for (const Member& m : members_)
            cout << "  " << m.roll() << " " << m.name()
                 << " — Rs " << fixed << setprecision(2) << m.balance() << "\n";
    }

    size_t size() const { return members_.size(); }

    int loadMembers(const string& path) {
        ifstream in(path);
        if (!in) return 0;
        string line;
        int skipped = 0;
        while (getline(in, line)) {
            if (line.empty()) continue;
            size_t c1 = line.find(',');
            size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
            if (c2 == string::npos) { ++skipped; continue; }
            try {
                if (!openMember(line.substr(0, c1),
                                line.substr(c1 + 1, c2 - c1 - 1),
                                stod(line.substr(c2 + 1))))
                    ++skipped;                   // duplicate roll or bad balance
            } catch (const exception&) {
                ++skipped;                       // unparseable balance
            }
        }
        return skipped;
    }

    void saveMembers(const string& path) const {
        ofstream out(path);
        for (const Member& m : members_)
            out << m.roll() << "," << m.name() << ","
                << fixed << setprecision(2) << m.balance() << "\n";
    }

private:
    vector<Member> members_;                     // the office owns; the menu never sees it
};

int main() {
    const string PATH = "members.csv";
    FeeOffice office;

    int skipped = office.loadMembers(PATH);
    if (skipped) cout << "Skipped " << skipped << " malformed line(s)\n";
    cout << "Loaded " << office.size() << " members\n";

    int choice;
    do {
        cout << "\n1 Open · 2 Deposit · 3 Charge · 4 List · 5 Arrears · "
                "6 Save · 0 Save & quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');

        if (choice == 1) {
            string roll, name;
            double opening;
            cout << "Roll: ";  getline(cin, roll);
            cout << "Name: ";  getline(cin, name);
            cout << "Opening balance: "; cin >> opening;
            if (office.openMember(roll, name, opening)) {
                logOperation("OPEN " + roll + " " + to_string(opening) + " (OK)");
                cout << "Opened\n";
            } else {
                logOperation("OPEN " + roll + " " + to_string(opening) + " (REFUSED)");
                cout << "Refused: duplicate roll or negative balance\n";
            }
        } else if (choice == 2 || choice == 3) {
            string roll;
            double amount;
            cout << "Roll: "; getline(cin, roll);
            cout << "Amount: "; cin >> amount;
            bool ok = (choice == 2) ? office.depositTo(roll, amount)
                                    : office.chargeTo(roll, amount);
            string verb = (choice == 2) ? "DEPOSIT" : "CHARGE";
            logOperation(verb + " " + roll + " " + to_string(amount)
                         + (ok ? " (OK)" : " (REFUSED)"));
            cout << (ok ? "Done\n" : "Refused\n");
        } else if (choice == 4) {
            office.listAll();
        } else if (choice == 5) {
            office.arrearsList();
        } else if (choice == 6) {
            office.saveMembers(PATH);
            cout << "Saved " << office.size() << " members\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    office.saveMembers(PATH);
    logOperation("SESSION CLOSED");
    cout << "Saved " << office.size() << " members — goodbye\n";
    return 0;
}
```

## Explanation of important design decisions

- **Two classes, two jobs.** `Member` is the domain (an account defends its own balance; an invalid one cannot exist); `FeeOffice` is the application (owns the collection, finds, delegates, answers the menu). The menu touches neither the vector nor the balance — it translates user intent into office calls. When this program grows, the layers grow independently — the architecture the capstone will use.
- **The gate throws; the office catches.** A negative opening balance is a *construction* failure — `Member` refuses to exist. `FeeOffice::openMember` translates that refusal into a `false` the menu can log and report. Each layer handles the failure it understands — the Robustness module's boundary rule, at class scale.
- **Two `findByRoll`s, by design.** The `const` overload serves reads (arrears, listing); the mutating twin serves deposit/charge. The pair is the const-correctness lesson made structural: callers get exactly as much access as their intent requires.
- **The log is an audit trail, not a diary.** Every operation *and refusal* is recorded at the application layer — the class enforces, the office records, the menu reports. Reading `office.log` after a session reconstructs the day truthfully, refusals included.
- **RAII everywhere, `new` nowhere.** The roster is a vector (owns its members), the files are streams (own their handles), the log opens per-write (its lifetime is the write). The Modern C++ module's retirement table, honoured in a whole program.

[← Project 9](project-09-student-files.md) · [Projects home](index.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
