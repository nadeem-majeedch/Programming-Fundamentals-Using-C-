---
title: "Level 5 — Integrated Labs (L5-35 to L5-42)"
description: "Eight integrated lab scenarios combining files, classes, records, search, sort, and validation into small complete systems — the capstone rehearsal tier. Every lab with all fifteen parts."
---

# Level 5 — Integrated

> [← Labs home](index.md) · [← Level 4](level-4.md) · **Units first: 12–16** — files, records, classes, search and sort are assumed. These labs are *systems*: persistence plus menu plus validation plus reports — the capstone's weekly rhythm in miniature.

---

## L5-35 — The Expense Tracker Pro

### Scenario
A freelancer tracks business expenses in `expenses.csv` (`category,amount,note`). The tracker loads the file, offers a menu (add, monthly total, category report, save), and validates everything before touching data.

### Problem statement
Build the tracker: load-or-start-empty, then a menu — 1 add expense (validated), 2 total for a month, 3 per-category totals, 4 list all, 0 save and quit. The category report prints each category's total in first-appearance order plus the grand total.

### Learning objectives
- combine file persistence with a menu loop and validation
- aggregate by a string key over file-loaded records
- keep the format contract across load and save

### Requirements
1. Contract: `category,amount,note` (no commas in fields; note may be empty). The contract comment sits above both I/O functions.
2. Amount 0.01–100000; category non-empty; both validated at entry.
3. Malformed lines are skipped and counted at load.
4. Save rewrites the whole file; the confirmation prints the saved record count.

### Input
`expenses.csv`, then menu-driven input.

### Output
Per operation an acknowledgement or report; on quit, `Saved N expenses`.

### Constraints
- The month query asks for a number 1–12 and matches records tagged with that month — since the contract has no month, the report uses the *note* field's leading number if present, else reports "month data unavailable" (documented simplification).
- No classes required — this lab is functions + vectors + files.

### Example
Seed file with 3 expenses → menu shows total, category report with two categories, save confirms 3.

### Test cases
| Scenario | Expected |
| --- | --- |
| load 3 valid records, report | category totals and grand total correct |
| malformed line in file | skipped with count; other records load |
| add expense, save, restart | the new expense survives |
| amount −5 at entry | re-prompt |
| save an empty tracker | file exists, 0 records |

### Student tasks
1. Write `loadExpenses`/`saveExpenses` with the contract comment and skip counting.
2. Write the validators and the add flow.
3. Write the category report (the manual tally) and the grand total.
4. Assemble the menu loop.

### Hints
1. The three-field split is two `find(',')` calls — L4-30's ledger loader, reused.
2. The category tally is L3-20's `indexOf`-then-increment pattern.
3. Save is a whole-file rewrite — the same mechanism as L4-29.

### Extension challenges
1. Add a delete-by-index operation (rewrite without the record).
2. Add a monthly field to the contract and migrate load, save, and the report together.

### Complete solution

```cpp
// L5-35 — The Expense Tracker Pro
// Compile: g++ -std=c++17 -Wall -Wextra L5-35.cpp -o L5-35
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
#include <iomanip>
using namespace std;

// Format contract: "category,amount,note" per line; no commas inside fields.

struct Expense { string category; double amount; string note; };

int loadExpenses(const string& path, vector<Expense>& out) {
    ifstream in(path);
    if (!in) return 0;
    string line; int skipped = 0;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
        if (c1 == string::npos || c2 == string::npos) { ++skipped; continue; }
        try {
            Expense e;
            e.category = line.substr(0, c1);
            e.amount   = stod(line.substr(c1 + 1, c2 - c1 - 1));
            e.note     = line.substr(c2 + 1);
            if (e.category.empty() || e.amount < 0.01 || e.amount > 100000) { ++skipped; continue; }
            out.push_back(e);
        } catch (const exception&) { ++skipped; }
    }
    return skipped;
}

void saveExpenses(const string& path, const vector<Expense>& expenses) {
    ofstream out(path);
    for (const Expense& e : expenses)
        out << e.category << "," << e.amount << "," << e.note << "\n";
}

int indexOfCategory(const vector<string>& cats, const string& c) {
    for (size_t i = 0; i < cats.size(); ++i)
        if (cats[i] == c) return static_cast<int>(i);
    return -1;
}

int main() {
    const string PATH = "expenses.csv";
    vector<Expense> expenses;

    int skipped = loadExpenses(PATH, expenses);
    if (skipped) cout << "Skipped " << skipped << " malformed line(s)\n";
    cout << "Loaded " << expenses.size() << " expenses\n";

    int choice;
    do {
        cout << "\n1 Add · 2 Grand total · 3 Category report · 4 List · 0 Save & quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');

        if (choice == 1) {
            Expense e;
            cout << "Category: ";
            getline(cin, e.category);
            cout << "Amount: ";
            cin >> e.amount;
            while (e.amount < 0.01 || e.amount > 100000) {
                cout << "Amount is 0.01-100000: ";
                cin >> e.amount;
            }
            cin.ignore(1000, '\n');
            cout << "Note: ";
            getline(cin, e.note);
            expenses.push_back(e);
            cout << "Added\n";
        } else if (choice == 2) {
            double total = 0.0;
            for (const Expense& e : expenses) total += e.amount;
            cout << "Grand total: Rs " << fixed << setprecision(2) << total << "\n";
        } else if (choice == 3) {
            vector<string> cats;
            vector<double> totals;
            for (const Expense& e : expenses) {
                int idx = indexOfCategory(cats, e.category);
                if (idx == -1) { cats.push_back(e.category); totals.push_back(e.amount); }
                else totals[static_cast<size_t>(idx)] += e.amount;
            }
            double grand = 0.0;
            for (size_t i = 0; i < cats.size(); ++i) {
                cout << "  " << cats[i] << ": Rs " << totals[i] << "\n";
                grand += totals[i];
            }
            cout << "  (grand: Rs " << grand << ")\n";
        } else if (choice == 4) {
            for (const Expense& e : expenses)
                cout << "  " << e.category << " Rs " << e.amount << " — " << e.note << "\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    saveExpenses(PATH, expenses);
    cout << "Saved " << expenses.size() << " expenses\n";
    return 0;
}
```

### Solution explanation
This lab is the Level 4 persistence labs (L4-29/L4-30) reassembled around a menu: the loader, the validators, the manual category tally, and the whole-file rewrite are each previous patterns — the new skill is *composition*: keeping the contract, the validation, and the aggregation consistent while the menu drives them. The `cin.ignore` after every numeric read before the next `getline` is the IO module's mixing discipline in its natural habitat.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] Added expenses survive a restart
- [ ] The category report's grand total matches the grand-total operation
- [ ] The empty tracker saves a valid empty file

---

## L5-36 — The Bank Simulation

### Scenario
A community bank's teller terminal manages accounts in memory *and* on disk: accounts live in `accounts.csv` (`owner,balance`), transactions are logged to `transactions.log`, and the menu opens accounts, deposits, withdraws, and lists.

### Problem statement
Model `class Account` (owner, balance) with a validating constructor, `deposit`, `withdraw` (ask-doors), and `balance()`. The terminal loads accounts (or starts empty), runs the menu (1 open, 2 deposit, 3 withdraw, 4 list, 0 save+log+quit), appends every operation to the log file, and saves accounts on exit.

### Learning objectives
- combine classes, vectors of objects, and file persistence in one system
- log operations to an append-mode file with the flush-verify discipline
- keep the in-memory model and the on-disk model synchronised

### Requirements
1. `Account` refuses negative opening (constructor throws), negative/zero deposits, and withdrawals exceeding the balance (ask-door `bool`).
2. Every accepted *and* refused operation logs one line: `OPERATION owner amount (RESULT)`.
3. Withdrawal lookups are by owner name (first match).
4. Save rewrites `accounts.csv`; the log opens in append mode.

### Input
`accounts.csv` (optional), menu-driven.

### Output
Per operation an acknowledgement; on quit, `Saved N accounts`.

### Constraints
- The log write verifies stream state after flush (the expense-tracker lesson).
- No transfers (that is the Robustness module's transaction lab).

### Example
Open Ali 500 → deposit 250 → withdraw 1000 (refused) → quit → accounts.csv has `Ali,750.0`; log has three lines.

### Test cases
| Scenario | Expected |
| --- | --- |
| the example sequence | balance 750, refusal logged |
| withdraw from unknown owner | `No such account` |
| deposit to refused-balance account | balance unchanged; both lines logged |
| restart after save | the saved balance loads |
| log file absent | created by the first operation |

### Student tasks
1. Write `class Account` (the L4-33 pattern, minus the history vector).
2. Write load/save for `accounts.csv` and the append-mode log writer.
3. Write the find-by-owner helper over the account vector.
4. Assemble the menu with logging on every path.

### Hints
1. The log line format is a contract — write it in a comment above the log function.
2. Logging happens in the *menu*, not the class — the class refuses; the terminal records (layer separation from the Robustness module).
3. Save converts balances with the two-decimal formatting — document the rounding in the contract comment.

### Extension challenges
1. Add `transfer from to amount` with all-or-nothing ordering (fallible first, commits last).
2. Add an account-number field to the contract and migrate both files together.

### Complete solution

```cpp
// L5-36 — The Bank Simulation
// Compile: g++ -std=c++17 -Wall -Wextra L5-36.cpp -o L5-36
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
#include <iomanip>
using namespace std;

// Contract accounts.csv: "owner,balance" — owner one word, balance >= 0 (2 dp).
// Contract transactions.log: "OPERATION owner amount (RESULT)" one line per op.

class Account {
public:
    Account(const string& owner, double opening) : owner_(owner), balance_(opening) {
        if (opening < 0) throw invalid_argument("negative opening balance");
    }
    bool deposit(double amount) {
        if (amount <= 0) return false;
        balance_ += amount;
        return true;
    }
    bool withdraw(double amount) {
        if (amount <= 0 || amount > balance_) return false;
        balance_ -= amount;
        return true;
    }
    double balance() const { return balance_; }
    const string& owner() const { return owner_; }
private:
    string owner_;
    double balance_;
};

void logOperation(const string& line) {
    ofstream log("transactions.log", ios::app);
    if (!log) { cerr << "warning: log unavailable\n"; return; }
    log << line << "\n";
    log.flush();
    if (!log) cerr << "warning: log write failed\n";
}

Account* findAccount(vector<Account>& accounts, const string& owner) {
    for (Account& a : accounts)
        if (a.owner() == owner) return &a;
    return nullptr;
}

int main() {
    const string PATH = "accounts.csv";
    vector<Account> accounts;

    {   // load (or start empty)
        ifstream in(PATH);
        string line;
        while (in && getline(in, line)) {
            if (line.empty()) continue;
            size_t comma = line.find(',');
            if (comma == string::npos) continue;
            try {
                accounts.push_back(Account(line.substr(0, comma),
                                           stod(line.substr(comma + 1))));
            } catch (const exception&) { /* skip malformed */ }
        }
    }
    cout << "Loaded " << accounts.size() << " accounts\n";

    int choice;
    do {
        cout << "\n1 Open · 2 Deposit · 3 Withdraw · 4 List · 0 Save & quit: ";
        cin >> choice;

        if (choice == 1) {
            string owner; double opening;
            cout << "Owner: "; cin >> owner;
            cout << "Opening balance: "; cin >> opening;
            try {
                accounts.push_back(Account(owner, opening));
                logOperation("OPEN " + owner + " " + to_string(opening) + " (OK)");
                cout << "Opened\n";
            } catch (const invalid_argument&) {
                logOperation("OPEN " + owner + " " + to_string(opening) + " (REFUSED)");
                cout << "Refused: opening must be non-negative\n";
            }
        } else if (choice == 2 || choice == 3) {
            string owner; double amount;
            cout << "Owner: "; cin >> owner;
            cout << "Amount: "; cin >> amount;
            Account* a = findAccount(accounts, owner);
            if (!a) {
                cout << "No such account\n";
                logOperation((choice == 2 ? "DEPOSIT " : "WITHDRAW ") + owner + " "
                             + to_string(amount) + " (NO ACCOUNT)");
            } else {
                bool ok = (choice == 2) ? a->deposit(amount) : a->withdraw(amount);
                cout << (ok ? "Done — balance " : "Refused — balance ") << a->balance() << "\n";
                logOperation((choice == 2 ? "DEPOSIT " : "WITHDRAW ") + owner + " "
                             + to_string(amount) + (ok ? " (OK)" : " (REFUSED)"));
            }
        } else if (choice == 4) {
            for (const Account& a : accounts)
                cout << "  " << a.owner() << ": Rs " << fixed << setprecision(2) << a.balance() << "\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    ofstream out(PATH);
    for (const Account& a : accounts)
        out << a.owner() << "," << fixed << setprecision(2) << a.balance() << "\n";
    cout << "Saved " << accounts.size() << " accounts\n";
    return 0;
}
```

### Solution explanation
The system has three models in step: the class (rules), the vector (state), the files (memory across runs). Layer separation is deliberate — `Account` refuses and returns booleans; the *terminal* logs every outcome, accepted or refused, so the log is a complete audit trail rather than a success diary. The log uses append mode with the flush-verify discipline; the account file uses a whole rewrite. Both contracts live in comments at the top. Restarting the program after a session must show the saved balances — that round-trip is the lab's acceptance test.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] Every operation — including refusals — appears in the log
- [ ] Saved balances reload correctly
- [ ] A refused withdrawal leaves both memory and file unchanged

---

## L5-37 — The Library Management System

### Scenario
The departmental library grows into a system: books (`books.csv`: `title,author,copies`) and a lending desk (borrow, return, list, search) — all in one menu program with persistence.

### Problem statement
Load books (or seed three if the file is missing). Menu: 1 list, 2 search by title, 3 borrow (decrement copies; refuse when 0), 4 return (increment; refuse above the original count), 5 add book, 0 save+quit. Borrowing and returning are ask-doors; the report prints copies available per book.

### Learning objectives
- manage a record system with a *state-changing* operation (copies) under persistence
- enforce domain rules (no borrowing beyond stock) at the operation layer
- seed-on-first-run behaviour

### Requirements
1. Contract: `title,author,copies` (1–99); no commas in fields.
2. Borrow refuses when copies = 0; return refuses when copies = the recorded original (store originals in a parallel vector — or add an `initialCopies` field; state the choice).
3. Search prints all matching titles (case-sensitive prefix match allowed).
4. Save rewrites the file; seed happens only when the file is absent.

### Input
`books.csv`, menu-driven.

### Output
Per operation an acknowledgement; the list block.

### Constraints
- The return-cap rule needs the *original* copies count — choose: a parallel vector or a fourth CSV field (the field is cleaner; the migration must update load+save together).
- All mutations flow through functions taking the book vector by reference.

### Example
Seed: `Clean Code,Martin,2`. Borrow it twice → copies 0; third borrow refused; return once → copies 1.

### Test cases
| Scenario | Expected |
| --- | --- |
| borrow until empty then once more | refusal at 0 |
| return up to the original count | accepted; further returns refused |
| add a book, save, restart | persists |
| search `c` | Clean Code matches (prefix) |
| missing file | three seeds created and loaded |

### Student tasks
1. Define `struct Book { string title, author; int copies, initial; };`
2. Write load (with the fourth field) and seed-if-missing.
3. Write `borrowBook`/`returnBook` ask-doors over the vector.
4. Assemble the menu; save on quit.

### Hints
1. The fourth CSV field (`initial`) is one more `find(',')` and one more `stoi` — the two-comma split becomes three.
2. Borrow/return are two `if` guards each: copies bounds and existence.
3. The seed function is the L4-30 pattern — create-then-load.

### Extension challenges
1. Add a borrower log: who borrowed what (a second file, append-only).
2. Add copy *removal* (retire damaged stock) that cannot go below the currently-borrowed count.

### Complete solution

```cpp
// L5-37 — The Library Management System
// Compile: g++ -std=c++17 -Wall -Wextra L5-37.cpp -o L5-37
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
using namespace std;

// Contract books.csv: "title,author,copies,initialCopies" — copies 0..initial, initial 1..99.

struct Book { string title, author; int copies, initial; };

void seedIfMissing(const string& path) {
    ifstream probe(path);
    if (probe) return;
    ofstream out(path);
    out << "Clean Code,Martin,2,2\n";
    out << "Algorithms,Cormen,1,3\n";
    out << "C++ Primer,Lippman,3,3\n";
}

int loadBooks(const string& path, vector<Book>& out) {
    ifstream in(path);
    if (!in) return 0;
    string line; int skipped = 0;
    while (getline(in, line)) {
        if (line.empty()) continue;
        int commas[3]; size_t at = 0; int found = 0;
        for (size_t i = 0; i <= line.size() && found < 3; ++i) {
            if (i == line.size() || line[i] == ',') { commas[found++] = static_cast<int>(i); if (i == line.size()) break; at = i; }
        }
        if (found < 3) { ++skipped; continue; }
        try {
            Book b;
            b.title   = line.substr(0, static_cast<size_t>(commas[0]));
            b.author  = line.substr(static_cast<size_t>(commas[0]) + 1,
                                    static_cast<size_t>(commas[1]) - static_cast<size_t>(commas[0]) - 1);
            b.copies  = stoi(line.substr(static_cast<size_t>(commas[1]) + 1,
                                         static_cast<size_t>(commas[2]) - static_cast<size_t>(commas[1]) - 1));
            b.initial = stoi(line.substr(static_cast<size_t>(commas[2]) + 1));
            if (b.title.empty() || b.author.empty() || b.copies < 0 || b.initial < 1
                || b.initial > 99 || b.copies > b.initial) { ++skipped; continue; }
            out.push_back(b);
        } catch (const exception&) { ++skipped; }
    }
    return skipped;
}

void saveBooks(const string& path, const vector<Book>& books) {
    ofstream out(path);
    for (const Book& b : books)
        out << b.title << "," << b.author << "," << b.copies << "," << b.initial << "\n";
}

Book* findBook(vector<Book>& books, const string& title) {
    for (Book& b : books)
        if (b.title == title) return &b;
    return nullptr;
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
        cout << "\n1 List · 2 Search · 3 Borrow · 4 Return · 5 Add · 0 Save & quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');

        if (choice == 1) {
            for (const Book& b : books)
                cout << "  " << b.title << " by " << b.author
                     << " (" << b.copies << "/" << b.initial << " available)\n";
        } else if (choice == 2) {
            cout << "Title (or prefix): ";
            string q; getline(cin, q);
            bool any = false;
            for (const Book& b : books)
                if (b.title.find(q) == 0) {
                    cout << "  " << b.title << " by " << b.author << "\n";
                    any = true;
                }
            if (!any) cout << "  no matches\n";
        } else if (choice == 3 || choice == 4) {
            cout << "Title: ";
            string t; getline(cin, t);
            Book* b = findBook(books, t);
            if (!b) cout << "No such book\n";
            else if (choice == 3) {
                if (b->copies > 0) { --b->copies; cout << "Borrowed — " << b->copies << " left\n"; }
                else cout << "Refused: no copies left\n";
            } else {
                if (b->copies < b->initial) { ++b->copies; cout << "Returned — " << b->copies << " available\n"; }
                else cout << "Refused: above the original count\n";
            }
        } else if (choice == 5) {
            Book b;
            cout << "Title: ";   getline(cin, b.title);
            cout << "Author: ";  getline(cin, b.author);
            cout << "Initial copies (1-99): ";
            cin >> b.initial;
            while (b.initial < 1 || b.initial > 99) { cout << "1-99: "; cin >> b.initial; }
            b.copies = b.initial;
            books.push_back(b);
            cout << "Added\n";
            cin.ignore(1000, '\n');
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    saveBooks(PATH, books);
    cout << "Saved " << books.size() << " books\n";
    return 0;
}
```

### Solution explanation
The fourth CSV field is the lab's design lesson: the return-cap rule needs a *stored* fact (the original count), and storage means the contract grows — load, save, and validation change in one edit, which is why the contract comment sits above both functions. Borrow/return are two-guard ask-doors over one integer field, but the guards' bounds are domain rules (0 and initial), so the struct carries the evidence. Seed-if-missing keeps the lab self-demonstrating: the first run populates, every later run loads.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] Returns cannot exceed the original count
- [ ] Added books survive a restart
- [ ] Malformed lines never abort the load

---

## L5-38 — The Scheduling Desk

### Scenario
The exams office schedules presentations: each has a student name and a duration (minutes). The desk loads requests from `requests.csv`, sorts them (shortest-job-first or by name), simulates the day's timeline, and saves the ordered plan.

### Problem statement
Load `requests.csv` (`name,duration`, duration 5–60). Menu: 1 load report, 2 sort by duration ascending, 3 sort by name, 4 simulate the day (start 9:00; print each slot's start/end clock times), 0 save+quit. Sorting must preserve the name↔duration pairing; the simulation prints real clock times.

### Learning objectives
- sort records while keeping fields paired
- convert minute offsets into wall-clock times
- keep a file-backed dataset consistent through sorting operations

### Requirements
1. Both sorts are by-value copies with counters (the L4-25 discipline) — the *file order* changes only when saved.
2. Simulation: slot k starts at the sum of all previous durations; print `HH:MM–HH:MM name`.
3. Durations 5–60 validated at load (malformed skipped).
4. Save writes the *current* order (the sorted one, if sorted).

### Input
`requests.csv`, menu-driven.

### Output
Per operation a report; the simulation as a timeline.

### Constraints
- The clock is minutes from 9*60; format as HH:MM with a leading zero.
- A day ends at 17:00 — the simulation prints `OVERRUNS CLOSING` when the last end exceeds it.

### Example
Requests Ali 30, Sara 20 → sort by duration → Sara 9:00–9:20, Ali 9:20–9:50.

### Test cases
| Scenario | Expected |
| --- | --- |
| the example | sorted timeline with correct clock times |
| a 480-minute total day | exactly reaches 17:00 (no overrun) |
| a 485-minute day | `OVERRUNS CLOSING` printed |
| malformed duration (0) | skipped at load |
| sort by name then simulate | alphabetical timeline |

### Student tasks
1. Write load/save for the two-field contract.
2. Write both sorts over records (swap whole structs — the record idiom pays off).
3. Write the clock formatter (`minutesSince9` → `HH:MM`).
4. Write the simulation pass and assemble the menu.

### Hints
1. Swapping whole structs is one line — the records module's argument for structs over parallel vectors, in action.
2. Clock formatting: `h = 9 + total/60; m = total%60;` then `setw(2)/setfill('0')`.
3. The overrun check compares the *final* end against `17*60`.

### Extension challenges
1. Add a lunch break (13:00–14:00) the simulation must skip.
2. Add a priority flag; sort by priority first, duration second.

### Complete solution

```cpp
// L5-38 — The Scheduling Desk
// Compile: g++ -std=c++17 -Wall -Wextra L5-38.cpp -o L5-38
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
#include <iomanip>
using namespace std;

// Contract requests.csv: "name,duration" — name one word, duration 5..60.

struct Request { string name; int duration; };

void loadRequests(const string& path, vector<Request>& out, int& skipped) {
    ifstream in(path);
    if (!in) return;
    string line;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t comma = line.find(',');
        if (comma == string::npos) { ++skipped; continue; }
        try {
            Request r;
            r.name = line.substr(0, comma);
            r.duration = stoi(line.substr(comma + 1));
            if (r.name.empty() || r.duration < 5 || r.duration > 60) { ++skipped; continue; }
            out.push_back(r);
        } catch (const exception&) { ++skipped; }
    }
}

void saveRequests(const string& path, const vector<Request>& requests) {
    ofstream out(path);
    for (const Request& r : requests) out << r.name << "," << r.duration << "\n";
}

void printClock(int minutesFrom9) {
    int total = 9 * 60 + minutesFrom9;
    cout << setfill('0') << setw(2) << total / 60 << ":" << setw(2) << total % 60 << setfill(' ');
}

int main() {
    const string PATH = "requests.csv";
    vector<Request> requests;
    int skipped = 0;
    loadRequests(PATH, requests, skipped);
    if (skipped) cout << "Skipped " << skipped << " malformed line(s)\n";
    cout << "Loaded " << requests.size() << " requests\n";

    int choice;
    do {
        cout << "\n1 List · 2 Sort by duration · 3 Sort by name · 4 Simulate · 0 Save & quit: ";
        cin >> choice;

        if (choice == 1) {
            for (const Request& r : requests) cout << "  " << r.name << " " << r.duration << " min\n";
        } else if (choice == 2 || choice == 3) {
            vector<Request> work = requests;              // sort a copy; file order unchanged
            long long comparisons = 0, swaps = 0;
            for (size_t i = 0; i + 1 < work.size(); ++i) {         // selection sort
                size_t best = i;
                for (size_t j = i + 1; j < work.size(); ++j) {
                    ++comparisons;
                    bool smaller = (choice == 2) ? work[j].duration < work[best].duration
                                                 : work[j].name < work[best].name;
                    if (smaller) best = j;
                }
                if (best != i) { swap(work[i], work[best]); ++swaps; }   // one struct swap
            }
            requests = work;                              // adopt the sorted order
            cout << "Sorted (" << comparisons << " comparisons, " << swaps << " swaps)\n";
        } else if (choice == 4) {
            int cursor = 0;
            const int CLOSING = 17 * 60 - 9 * 60;
            for (const Request& r : requests) {
                cout << "  ";
                printClock(cursor);
                cout << "-";
                printClock(cursor + r.duration);
                cout << "  " << r.name << "\n";
                cursor += r.duration;
            }
            if (cursor > CLOSING) cout << "  OVERRUNS CLOSING\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    saveRequests(PATH, requests);
    cout << "Saved " << requests.size() << " requests\n";
    return 0;
}
```

### Solution explanation
Two lessons compound here. First, records make sorting *safe*: `swap(work[i], work[best])` moves the whole request in one statement — the parallel-vector three-line swap of L4-25 reduced to one, which is the structs module's argument realised. Second, the file order is a *state* the user controls: sorts happen on copies (with counters, so the work is visible), the adoption line is explicit, and only save persists — the same load-view-mutate-save cycle as the other Level 5 labs, now with an ordering dimension. The clock formatter is pure arithmetic plus stream formatting, and the closing-time check is the simulation's one domain rule.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] The timeline's clock times chain exactly (each start = previous end)
- [ ] Sorting by name then by duration produces different, correct orders
- [ ] Save writes the current (possibly sorted) order

---

## L5-39 — The Survey Analyzer

### Scenario
The students affairs office runs a satisfaction survey: respondents rate canteen services 1–5. Responses arrive in `survey.csv` (`studentId,rating`). The analyzer validates, reports the distribution, and flags suspicious data (duplicate IDs, out-of-range ratings).

### Problem statement
Load responses (skipping and counting invalid lines). Report: total valid, the 1–5 distribution as a star histogram, the average (1 decimal), and duplicate-ID detection (same ID voting twice — list the duplicated IDs). The office then asks whether to append corrected responses before save.

### Learning objectives
- validate file data against two rule families (range and uniqueness)
- build a star histogram from a counter array
- report data-quality findings alongside statistics

### Requirements
1. Rating outside 1–5 → the line is invalid (skipped, counted separately from malformed lines).
2. Duplicate IDs: reported as `Suspicious: ID voted N times` — the *first* vote counts; later ones are flagged but still counted (document the policy).
3. Histogram: `1: *** (3)` — stars equal the count (cap the stars at 40, print the number always).
4. Save writes all loaded (valid) responses.

### Input
`survey.csv`, then optional interactive appends.

### Output
The data-quality block, the histogram, the average.

### Constraints
- The duplicate check is a manual tally over IDs (the L3-20 pattern).
- Non-numeric ratings are "malformed" (a different counter than out-of-range).

### Example
File with ratings 5,4,5,3,5 → distribution `5: *** (3)`, `4: * (1)`, `3: * (1)`, average 4.4.

### Test cases
| Scenario | Expected |
| --- | --- |
| the example file | histogram and average as stated |
| an out-of-range rating (7) | invalid count 1; excluded from stats |
| a duplicate ID | flagged line; both votes counted per policy |
| empty file | zeros everywhere, average 0.0 guarded |
| append one response and save | saved count grows; restart sees it |

### Student tasks
1. Write the loader with *two* skip counters (malformed vs out-of-range).
2. Write the duplicate-ID tally (indexOf pattern over IDs).
3. Write the star histogram with the cap rule.
4. Write the append-and-save flow.

### Hints
1. `stoi` failure → malformed; parse success but outside 1–5 → invalid. Two counters, two meanings.
2. The duplicate report needs counts *per ID* — tally first, then print IDs whose count > 1.
3. Star capping: `min(count, 40)` stars, then `" (count)"`.

### Extension challenges
1. Add a second question (two ratings per line) and per-question histograms.
2. Compute the mode and the median of the ratings.

### Complete solution

```cpp
// L5-39 — The Survey Analyzer
// Compile: g++ -std=c++17 -Wall -Wextra L5-39.cpp -o L5-39
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
#include <iomanip>
#include <algorithm>
using namespace std;

// Contract survey.csv: "studentId,rating" — rating 1..5; IDs are unique-by-policy.

struct Response { string id; int rating; };

int main() {
    const string PATH = "survey.csv";
    vector<Response> responses;
    int malformed = 0, outOfRange = 0;

    {
        ifstream in(PATH);
        string line;
        while (in && getline(in, line)) {
            if (line.empty()) continue;
            size_t comma = line.find(',');
            if (comma == string::npos) { ++malformed; continue; }
            try {
                Response r;
                r.id = line.substr(0, comma);
                r.rating = stoi(line.substr(comma + 1));
                if (r.id.empty() || r.rating < 1 || r.rating > 5) { ++outOfRange; continue; }
                responses.push_back(r);
            } catch (const exception&) { ++malformed; }
        }
    }

    cout << "Valid responses: " << responses.size()
         << " (malformed: " << malformed << ", out-of-range: " << outOfRange << ")\n";

    // duplicates: tally IDs, report those seen more than once
    {
        vector<string> ids;
        vector<int> counts;
        for (const Response& r : responses) {
            size_t i = 0;
            while (i < ids.size() && ids[i] != r.id) ++i;
            if (i == ids.size()) { ids.push_back(r.id); counts.push_back(1); }
            else ++counts[i];
        }
        for (size_t i = 0; i < ids.size(); ++i)
            if (counts[i] > 1)
                cout << "Suspicious: " << ids[i] << " voted " << counts[i] << " times\n";
    }

    int dist[5] = {0, 0, 0, 0, 0};
    long long total = 0;
    for (const Response& r : responses) {
        ++dist[r.rating - 1];
        total += r.rating;
    }

    cout << "\nDistribution:\n";
    for (int v = 1; v <= 5; ++v) {
        cout << "  " << v << ": ";
        for (int s = 0; s < min(dist[v - 1], 40); ++s) cout << "*";
        cout << " (" << dist[v - 1] << ")\n";
    }

    cout << "\nAverage rating: " << fixed << setprecision(1)
         << (responses.empty() ? 0.0 : static_cast<double>(total) / responses.size()) << "\n";

    cout << "\nAppend a response? (y/n): ";
    char yn;
    cin >> yn;
    if (yn == 'y' || yn == 'Y') {
        Response r;
        cout << "Student ID: "; cin >> r.id;
        cout << "Rating (1-5): "; cin >> r.rating;
        while (r.rating < 1 || r.rating > 5) { cout << "1-5: "; cin >> r.rating; }
        responses.push_back(r);
    }

    ofstream out(PATH);
    for (const Response& r : responses) out << r.id << "," << r.rating << "\n";
    cout << "Saved " << responses.size() << " responses\n";
    return 0;
}
```

### Solution explanation
Data quality is the lab's theme: the loader distinguishes *malformed* (unparseable) from *out-of-range* (parseable but invalid) — two counters because they mean different things to the office — and the duplicate detection is a tally plus a filter, with the policy (first vote counts, duplicates flagged but tallied) stated in the requirements and honoured by the code. The histogram is the counter array made visual, with the cap rule protecting the screen from a landslide. Everything else — the guarded average, the append, the whole-file save — is the Level 4 toolkit reassembled around an analysis task.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] Malformed and out-of-range counts are separate and correct
- [ ] Duplicated IDs are flagged with their counts
- [ ] The empty-file average prints 0.0, not a crash

---

## L5-40 — The Inventory Control System

### Scenario
The campus store's full inventory system: products (`stock.csv`: `name,qty,price,reorderPoint`) with menu-driven stock movements (receive, sell, adjust) and three reports (reorder list, stock value, price list).

### Problem statement
Load products (or seed three). Menu: 1 list, 2 receive stock (+qty), 3 sell (−qty; refuse below zero), 4 adjust price, 5 reorder report (qty below point, with order-to-target quantities), 6 stock value report (Σ qty×price), 0 save+quit. All movements validated; save rewrites the file.

### Learning objectives
- run a stateful record system with *two* mutation directions (in/out)
- compute derived reports (value, reorder quantities) from stored state
- keep every movement inside the domain's bounds

### Requirements
1. Contract: `name,qty,price,reorderPoint` — qty ≥ 0, price 0.01–10000, point 1–500.
2. Sell refuses when qty insufficient; receive requires amount ≥ 1; adjust requires the new price in range.
3. Reorder report: `name: have Q, point P, order T−Q` for each product below its point; none → `Nothing to reorder`.
4. Value report prints each product's line value and the total.

### Input
`stock.csv`, menu-driven.

### Output
Per operation an acknowledgement; reports on demand.

### Constraints
- All lookups by exact name (first match).
- The reorder target is the constant `TARGET_FACTOR × point` (factor 3) — named, documented.

### Example
Seed `Notebook,20,0.80,10`: sell 15 → 5 left; reorder report shows order 25 (target 30); value 4.00.

### Test cases
| Scenario | Expected |
| --- | --- |
| sell below stock | refused, qty unchanged |
| receive 10, save, restart | qty persists |
| reorder report with one low product | the order line with the correct target |
| adjust price out of range | re-prompt |
| value report over seeded stock | per-line and total correct |

### Student tasks
1. Define `struct Product { string name; int qty; double price; int point; };`
2. Write load/save with the four-field contract.
3. Write the three movement operations as ask-doors.
4. Write the two reports; assemble the menu.

### Hints
1. The four-field split is three commas — L5-37's loader, one field further.
2. The reorder report's target is `3 * point`; the order is `target - qty` (never negative by the below-point filter).
3. Money formatting is per-report (`fixed/setprecision(2)` at the report, not globally).

### Extension challenges
1. Add a movement log file (append every receive/sell/adjust).
2. Add a sold-out report (qty 0) with a suggested discontinuation flag.

### Complete solution

```cpp
// L5-40 — The Inventory Control System
// Compile: g++ -std=c++17 -Wall -Wextra L5-40.cpp -o L5-40
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
#include <iomanip>
using namespace std;

// Contract stock.csv: "name,qty,price,reorderPoint" — qty>=0, price 0.01..10000, point 1..500.

struct Product { string name; int qty; double price; int point; };

void seedIfMissing(const string& path) {
    ifstream probe(path);
    if (probe) return;
    ofstream out(path);
    out << "Notebook,20,0.80,10\n";
    out << "Pen,40,0.50,15\n";
    out << "Eraser,8,0.30,10\n";
}

int loadStock(const string& path, vector<Product>& out) {
    ifstream in(path);
    if (!in) return 0;
    string line; int skipped = 0;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
        size_t c3 = (c2 == string::npos) ? string::npos : line.find(',', c2 + 1);
        if (c3 == string::npos) { ++skipped; continue; }
        try {
            Product p;
            p.name  = line.substr(0, c1);
            p.qty   = stoi(line.substr(c1 + 1, c2 - c1 - 1));
            p.price = stod(line.substr(c2 + 1, c3 - c2 - 1));
            p.point = stoi(line.substr(c3 + 1));
            if (p.name.empty() || p.qty < 0 || p.price < 0.01 || p.price > 10000
                || p.point < 1 || p.point > 500) { ++skipped; continue; }
            out.push_back(p);
        } catch (const exception&) { ++skipped; }
    }
    return skipped;
}

void saveStock(const string& path, const vector<Product>& stock) {
    ofstream out(path);
    for (const Product& p : stock)
        out << p.name << "," << p.qty << "," << p.price << "," << p.point << "\n";
}

Product* findProduct(vector<Product>& stock, const string& name) {
    for (Product& p : stock)
        if (p.name == name) return &p;
    return nullptr;
}

int main() {
    const string PATH = "stock.csv";
    const int TARGET_FACTOR = 3;

    seedIfMissing(PATH);
    vector<Product> stock;
    int skipped = loadStock(PATH, stock);
    if (skipped) cout << "Skipped " << skipped << " malformed line(s)\n";
    cout << "Loaded " << stock.size() << " products\n";

    int choice;
    do {
        cout << "\n1 List · 2 Receive · 3 Sell · 4 Adjust price · 5 Reorder · 6 Value · 0 Save & quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');

        if (choice == 1) {
            for (const Product& p : stock)
                cout << "  " << p.name << " qty " << p.qty << " Rs " << p.price
                     << " (point " << p.point << ")\n";
        } else if (choice >= 2 && choice <= 4) {
            cout << "Product name: ";
            string name; getline(cin, name);
            Product* p = findProduct(stock, name);
            if (!p) { cout << "No such product\n"; continue; }

            if (choice == 2) {
                cout << "Receive amount: ";
                int amt; cin >> amt;
                if (amt >= 1) { p->qty += amt; cout << "Received — qty " << p->qty << "\n"; }
                else cout << "Refused: amount must be at least 1\n";
            } else if (choice == 3) {
                cout << "Sell amount: ";
                int amt; cin >> amt;
                if (amt >= 1 && amt <= p->qty) { p->qty -= amt; cout << "Sold — qty " << p->qty << "\n"; }
                else cout << "Refused: stock has only " << p->qty << "\n";
            } else {
                cout << "New price: ";
                double price; cin >> price;
                if (price >= 0.01 && price <= 10000) { p->price = price; cout << "Adjusted\n"; }
                else cout << "Refused: price is 0.01-10000\n";
            }
        } else if (choice == 5) {
            bool any = false;
            for (const Product& p : stock)
                if (p.qty < p.point) {
                    cout << "  " << p.name << ": have " << p.qty << ", point " << p.point
                         << ", order " << TARGET_FACTOR * p.point - p.qty << "\n";
                    any = true;
                }
            if (!any) cout << "  Nothing to reorder\n";
        } else if (choice == 6) {
            double total = 0.0;
            cout << fixed << setprecision(2);
            for (const Product& p : stock) {
                double value = p.qty * p.price;
                cout << "  " << p.name << ": " << p.qty << " x Rs " << p.price
                     << " = Rs " << value << "\n";
                total += value;
            }
            cout << "  TOTAL STOCK VALUE: Rs " << total << "\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    saveStock(PATH, stock);
    cout << "Saved " << stock.size() << " products\n";
    return 0;
}
```

### Solution explanation
The system is the L3-24 reorder logic and the L5-35 persistence shape grown into a full stock room: two movement directions (receive/sell) each with their own bound rule, a price adjustment with a range gate, and two *derived* reports that never touch storage — the reorder quantities and stock values are computed from state at report time (the stored-vs-derived discipline: storing derived values would drift). The four-field contract makes the loader the three-comma pattern; seed-if-missing keeps the lab runnable from zero.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] Sell never drives qty negative; receive never accepts 0
- [ ] Reorder orders are never negative and match the target factor
- [ ] Saved movements survive a restart

---

## L5-41 — The Contact Book

### Scenario
A personal contact book persists `contacts.csv` (`name,phone,email`) and offers lookup, sorted listing, and duplicate-guarded adds — the small tool most users actually want.

### Problem statement
Load contacts (or start empty). Menu: 1 list (sorted by name), 2 search by name (exact), 3 search by phone, 4 add (refuses duplicate names), 5 delete by name, 0 save+quit. The sorted listing works on a copy; the file order is arrival order.

### Learning objectives
- maintain multiple views of one dataset (arrival-order file, sorted display)
- enforce uniqueness on a key field at add time
- support two different search keys over the same records

### Requirements
1. Contract: `name,phone,email` — name unique; phone digits (validate: 10–13 chars, all digits); email must contain `@`.
2. Add refuses duplicates by name (ask-door) and validates phone/email with re-prompts.
3. Delete removes by exact name and reports the removed contact.
4. The sorted listing never changes the file order.

### Input
`contacts.csv`, menu-driven.

### Output
Per operation an acknowledgement or the found record; save confirmation on quit.

### Constraints
- Sorting is by name on a copied vector (any elementary sort or `sort` with a comparator — state which you used).
- Phone validation is a character loop (`isdigit` over the field).

### Example
Add `Ali 03001234567 ali@pu.edu.pk`, add `Sara ...`, list → alphabetical; add `Ali ...` again → refused.

### Test cases
| Scenario | Expected |
| --- | --- |
| add two, list | alphabetical order |
| add a duplicate name | refused |
| phone with a letter | re-prompt |
| email without `@` | re-prompt |
| delete then save and restart | the contact is gone |

### Student tasks
1. Define `struct Contact { string name, phone, email; };`
2. Write load/save with the three-field contract.
3. Write the validators (phone digits, email `@`) and the duplicate guard.
4. Write both searches, the sorted listing, delete; assemble the menu.

### Hints
1. Uniqueness is enforced *at add* by searching before insert — the constructor-gate idea at the collection layer.
2. `sort(copy.begin(), copy.end(), [](const Contact& a, const Contact& b) { return a.name < b.name; });` — or a named comparator function.
3. Delete is find-then-erase — the L4-34 roster idiom.

### Extension challenges
1. Add a partial-name search (substring match) listing all hits.
2. Export the book sorted to a second file (the view becomes a file).

### Complete solution

```cpp
// L5-41 — The Contact Book
// Compile: g++ -std=c++17 -Wall -Wextra L5-41.cpp -o L5-41
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <cctype>
using namespace std;

// Contract contacts.csv: "name,phone,email" — names unique; phone 10-13 digits; email has '@'.

struct Contact { string name, phone, email; };

void loadContacts(const string& path, vector<Contact>& out, int& skipped) {
    ifstream in(path);
    if (!in) return;
    string line;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
        if (c2 == string::npos) { ++skipped; continue; }
        Contact c;
        c.name  = line.substr(0, c1);
        c.phone = line.substr(c1 + 1, c2 - c1 - 1);
        c.email = line.substr(c2 + 1);
        bool phoneOk = c.phone.size() >= 10 && c.phone.size() <= 13;
        for (char ch : c.phone) if (!isdigit(static_cast<unsigned char>(ch))) phoneOk = false;
        if (c.name.empty() || !phoneOk
            || c.email.find('@') == string::npos) { ++skipped; continue; }
        out.push_back(c);
    }
}

void saveContacts(const string& path, const vector<Contact>& contacts) {
    ofstream out(path);
    for (const Contact& c : contacts) out << c.name << "," << c.phone << "," << c.email << "\n";
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

string readPhone() {
    string phone;
    cout << "Phone (10-13 digits): ";
    getline(cin, phone);
    bool ok = phone.size() >= 10 && phone.size() <= 13;
    for (char ch : phone) if (!isdigit(static_cast<unsigned char>(ch))) ok = false;
    while (!ok) {
        cout << "Digits only, 10-13 of them: ";
        getline(cin, phone);
        ok = phone.size() >= 10 && phone.size() <= 13;
        for (char ch : phone) if (!isdigit(static_cast<unsigned char>(ch))) ok = false;
    }
    return phone;
}

string readEmail() {
    string email;
    cout << "Email: ";
    getline(cin, email);
    while (email.find('@') == string::npos) {
        cout << "Must contain '@': ";
        getline(cin, email);
    }
    return email;
}

int main() {
    const string PATH = "contacts.csv";
    vector<Contact> contacts;
    int skipped = 0;
    loadContacts(PATH, contacts, skipped);
    if (skipped) cout << "Skipped " << skipped << " malformed line(s)\n";
    cout << "Loaded " << contacts.size() << " contacts\n";

    int choice;
    do {
        cout << "\n1 List (sorted) · 2 Find by name · 3 Find by phone · 4 Add · 5 Delete · 0 Save & quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');

        if (choice == 1) {
            vector<Contact> view = contacts;
            sort(view.begin(), view.end(),
                 [](const Contact& a, const Contact& b) { return a.name < b.name; });
            for (const Contact& c : view)
                cout << "  " << c.name << " — " << c.phone << " — " << c.email << "\n";
        } else if (choice == 2 || choice == 3) {
            cout << (choice == 2 ? "Name: " : "Phone: ");
            string key; getline(cin, key);
            Contact* c = (choice == 2) ? findByName(contacts, key) : findByPhone(contacts, key);
            if (c) cout << "  " << c->name << " — " << c->phone << " — " << c->email << "\n";
            else   cout << "  not found\n";
        } else if (choice == 4) {
            Contact c;
            cout << "Name: ";
            getline(cin, c.name);
            if (findByName(contacts, c.name)) {
                cout << "Refused: name already present\n";
                continue;
            }
            c.phone = readPhone();
            c.email = readEmail();
            contacts.push_back(c);
            cout << "Added\n";
        } else if (choice == 5) {
            cout << "Name to delete: ";
            string name; getline(cin, name);
            Contact* c = findByName(contacts, name);
            if (c) {
                cout << "Deleted " << c->name << " (" << c->phone << ")\n";
                contacts.erase(contacts.begin() + (c - &contacts[0]));
            } else cout << "  not found\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    saveContacts(PATH, contacts);
    cout << "Saved " << contacts.size() << " contacts\n";
    return 0;
}
```

### Solution explanation
The lab's teaching point is *views versus storage*: the file and vector keep arrival order, the listing sorts a copy with a lambda comparator — the STL module's algorithm doing L4-25's job in one line, which is itself a lesson in having both tools. Uniqueness is enforced where the data enters (add-time search, the collection-layer gate), and the two validators are character-level loops with re-prompt loops — the boundary layer doing its job so no invalid contact ever enters storage. The delete's pointer arithmetic (`c - &contacts[0]`) is the honest array-index view of iterators; a size_t find would be equally fine — both are named choices.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] The sorted listing never reorders the file
- [ ] Invalid phones/emails never enter storage
- [ ] Deleted contacts stay deleted after a restart

---

## L5-42 — The Result Processing System

### Scenario
The examination cell's capstone rehearsal: a result system that loads student marks from `results.csv` (`roll,name,m1,m2,m3`), computes totals/grades/merit, produces the reports the cell needs, and saves a processed `report.csv`. This is the syllabus's Project 3 in miniature — every course concept, one system.

### Problem statement
Load marks (validated; malformed skipped). Compute per student: total, average, grade (A ≥ 80, B ≥ 70, C ≥ 60, D ≥ 50, F). Reports: the class summary (count, average, pass rate), the merit list (sorted by total descending, with ranks), the grade distribution, and per-subject averages. Save `report.csv` (`roll,name,total,average,grade`) in merit order.

### Learning objectives
- integrate records, validation, computation, sorting, and persistence in one system
- produce an *output artifact* (report.csv) distinct from the input data
- structure a system as load → compute → report → save

### Requirements
1. Contract in: `roll,name,m1,m2,m3` (rolls unique, marks 0–100); contract out: `roll,name,total,average,grade` in merit order. Both comments live above their functions.
2. Duplicate rolls at load: the *first* stays, later ones are flagged in a warnings list.
3. Merit ranks: 1-based after sorting; ties share the higher rank (standard competition ranking).
4. `report.csv` is written even when the load is empty (a valid empty artifact).

### Input
`results.csv`, menu optional — this lab may run as a single batch (load → process → report → save) with a `--demo` style flow on stdout.

### Output
The four reports on stdout, `report.csv` on disk, and a processing summary (loaded, flagged, saved).

### Constraints
- Sorting the merit list must not reorder the input file's data (sort a copy).
- Grade boundaries are a named table (constants), not scattered literals.

### Example
Two students (totals 245 and 180) → merit list ranks 1, 2; class average over six marks; report.csv has two lines in merit order.

### Test cases
| Scenario | Expected |
| --- | --- |
| two-student file | correct totals, grades, ranks, and artifact |
| a duplicate roll | first kept, second flagged in warnings |
| a malformed line | skipped, counted, processing continues |
| all-equal totals | shared rank 1 for all, then 3 (competition ranking) |
| empty input | empty reports, empty-but-valid report.csv |

### Student tasks
1. Define `struct Student { string roll, name; int m[3]; int total; double average; char grade; };` — compute fields filled after load.
2. Write the loader with validation, skipping, and duplicate flagging.
3. Write the compute pass (total/average/grade), then the merit sort on a copy.
4. Write the four reports and the artifact writer; assemble the batch flow.

### Hints
1. Competition ranking: rank[i] = 1 + (number of students with a strictly greater total). Two passes, no special cases.
2. The grade table is three constants per band — write them once, above the grade function.
3. The artifact's average field is 1 decimal (`fixed/setprecision(1)` at the writer).

### Extension challenges
1. Add subject-wise highest/lowest to the reports (position-tracking max over columns).
2. Add a "provisional result" flag for students with any mark below 50 but a passing total.

### Complete solution

```cpp
// L5-42 — The Result Processing System
// Compile: g++ -std=c++17 -Wall -Wextra L5-42.cpp -o L5-42
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <iomanip>
#include <stdexcept>
using namespace std;

// In-contract results.csv:  "roll,name,m1,m2,m3" — rolls unique, marks 0-100.
// Out-contract report.csv:  "roll,name,total,average,grade" in merit order.

struct Student {
    string roll, name;
    int m[3] = {0, 0, 0};
    int total = 0;
    double average = 0.0;
    char grade = 'F';
};

char gradeFor(int total) {                      // out of 300
    const int A = 240, B = 210, C = 180, D = 150;
    if (total >= A) return 'A';
    if (total >= B) return 'B';
    if (total >= C) return 'C';
    if (total >= D) return 'D';
    return 'F';
}

int loadStudents(const string& path, vector<Student>& out, vector<string>& warnings) {
    ifstream in(path);
    if (!in) return 0;
    string line;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
        size_t c3 = (c2 == string::npos) ? string::npos : line.find(',', c2 + 1);
        size_t c4 = (c3 == string::npos) ? string::npos : line.find(',', c3 + 1);
        size_t c5 = (c4 == string::npos) ? string::npos : line.find(',', c4 + 1);
        if (c5 == string::npos) { warnings.push_back("malformed: " + line); continue; }
        try {
            Student s;
            s.roll = line.substr(0, c1);
            s.name = line.substr(c1 + 1, c2 - c1 - 1);
            s.m[0] = stoi(line.substr(c2 + 1, c3 - c2 - 1));
            s.m[1] = stoi(line.substr(c3 + 1, c4 - c3 - 1));
            s.m[2] = stoi(line.substr(c4 + 1, c5 - c4 - 1));
            bool valid = !s.roll.empty() && !s.name.empty();
            for (int k = 0; k < 3; ++k) valid = valid && s.m[k] >= 0 && s.m[k] <= 100;
            if (!valid) { warnings.push_back("invalid values: " + line); continue; }
            bool duplicate = false;
            for (const Student& prev : out) duplicate = duplicate || prev.roll == s.roll;
            if (duplicate) { warnings.push_back("duplicate roll kept out: " + s.roll); continue; }
            out.push_back(s);
        } catch (const exception&) {
            warnings.push_back("unparseable: " + line);
        }
    }
    return static_cast<int>(warnings.size());
}

void computeAll(vector<Student>& students) {
    for (Student& s : students) {
        s.total = s.m[0] + s.m[1] + s.m[2];
        s.average = s.total / 3.0;
        s.grade = gradeFor(s.total);
    }
}

void writeReport(const string& path, const vector<Student>& merit) {
    ofstream out(path);
    out << fixed << setprecision(1);
    for (const Student& s : merit)
        out << s.roll << "," << s.name << "," << s.total << ","
            << s.average << "," << s.grade << "\n";
}

int main() {
    const string IN_PATH = "results.csv", OUT_PATH = "report.csv";
    vector<Student> students;
    vector<string> warnings;

    loadStudents(IN_PATH, students, warnings);
    cout << "Loaded " << students.size() << " students, "
         << warnings.size() << " warning(s)\n";
    for (const string& w : warnings) cout << "  ! " << w << "\n";

    computeAll(students);

    long long grandTotal = 0;
    for (const Student& s : students) grandTotal += s.total;

    cout << fixed << setprecision(2);
    cout << "\n=== CLASS SUMMARY ===\n";
    cout << "Students: " << students.size() << "\n";
    if (!students.empty())
        cout << "Class average: " << static_cast<double>(grandTotal) / (students.size() * 3) << "\n";

    cout << "\n=== GRADE DISTRIBUTION ===\n";
    for (char g : {'A', 'B', 'C', 'D', 'F'}) {
        int count = 0;
        for (const Student& s : students) if (s.grade == g) ++count;
        cout << "  " << g << ": " << count << "\n";
    }

    cout << "\n=== SUBJECT AVERAGES ===\n";
    for (int k = 0; k < 3; ++k) {
        long long subjectTotal = 0;
        for (const Student& s : students) subjectTotal += s.m[k];
        cout << "  Subject " << (k + 1) << ": "
             << (students.empty() ? 0.0 : static_cast<double>(subjectTotal) / students.size()) << "\n";
    }

    vector<Student> merit = students;                 // sort a copy; input order untouched
    sort(merit.begin(), merit.end(),
         [](const Student& a, const Student& b) { return a.total > b.total; });

    cout << "\n=== MERIT LIST ===\n";
    for (size_t i = 0; i < merit.size(); ++i) {
        int rank = 1;
        for (const Student& s : students)
            if (s.total > merit[i].total) ++rank;     // competition ranking
        cout << "  " << rank << ". " << merit[i].name << " (" << merit[i].roll
             << ") total " << merit[i].total << " grade " << merit[i].grade << "\n";
    }

    writeReport(OUT_PATH, merit);
    cout << "\nWrote " << merit.size() << " line(s) to " << OUT_PATH << "\n";
    return 0;
}
```

### Solution explanation
This is the course's architecture in one program: *load* (the files module's contract + skip + flag discipline), *compute* (a derived-data pass that fills the struct's computed fields once — the stored-vs-derived rule applied inside a record), *report* (four independent views: summary, distribution, per-subject scans, merit), *save* (an output artifact in a different format and order than the input — the round-trip asymmetry that distinguishes a processor from a storage tool). Competition ranking is the lab's algorithmic garnish: rank = 1 + count of strictly-better students, two passes, no tie special cases. The sort happens on a copy so the input order survives — the same view-versus-storage discipline as L5-41, at system scale. Running this lab's flow on the real Project 3 data is the capstone's first hour, rehearsed.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] Warnings name their lines without stopping the batch
- [ ] Merit ranks follow competition ranking on ties
- [ ] report.csv is merit-ordered and reloadable by eye

---

[← Level 4](level-4.md) · [Labs home](index.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
