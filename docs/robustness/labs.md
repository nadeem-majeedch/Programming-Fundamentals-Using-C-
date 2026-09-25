---
title: "Lab — The Robust Student/Bank/Inventory Application"
description: "One application, three hardening rings: guards everywhere, the typed exception family, and transaction safety — with test tables, solution, explanation, and extensions."
---

# Lab — the Robust Student/Bank/Inventory Application

> [← Module home](index.md) · Three rings over one program · Attempt each ring before opening its solution

## The scenario

The registrar's office runs **one console program** with three desks that share data:

1. **Student desk** — load students from `students.csv` (name,id,gpa), list them, enrol a student in a course.
2. **Bank desk** — each student has a fee account; pay fees, check balance.
3. **Inventory desk** — the campus store's stock, loaded from `stock.csv` (item,qty,price), sell items to students (which charges their bank desk).

The desks interact — selling decrements inventory *and* the student's account — which is precisely where silent failures become expensive lies. Your job is not to build the program (the pieces all exist in earlier labs); it is to **harden it in three rings**, each ring a full before/after with its own test table.

**The format contract** (Files module rules apply): comma-separated, one record per line, no comma inside fields; `students.csv` → `Aisha,101,3.4`; `stock.csv` → `Notebook,120,0.80`.

---

## Ring 1 — guards everywhere (the boundary ring)

**Requirements.** Every input path the user can touch is guarded: menu choice via the range reader; GPA validated on entry; quantities and amounts positive; every file open checked and *reported* (guard-style return or cerr — throws come in Ring 2). No operation proceeds on unvalidated data.

**Student tasks.**

1. Assemble the three-desk skeleton from your earlier labs; get it running *unvalidated* first.
2. Insert the guard layer: `readIntInRange` for the menu, `readDoubleInRange(0, 4)` for GPA, positivity guards for quantities/amounts.
3. Add the open-check-report ritual at all three loads — collect your findings: how many unguarded opens did your skeleton have?
4. Build Ring 1's test table (below) and record actual vs expected.

**Ring 1 test table.**

| Input | Expected | Actual |
| --- | --- | --- |
| menu choice `9` | re-prompt with range message | |
| GPA entry `-2` | re-prompt (0–4) | |
| `students.csv` missing | program reports, offers fresh-start | |
| `stock.csv` missing | program reports, offers fresh-start | |
| quantity `0` at sell | refused with message | |
| empty file | program reports "no records", desks degrade honestly | |

**What Ring 1 cannot fix** (write this down — it motivates Ring 2): a *corrupt line* mid-file still parses short; a failed *write* still vanishes a fee payment; a desk function called from another desk still has no way to refuse loudly. Guards report at their own layer — they cannot escalate.

---

## Ring 2 — the typed exception family (the report ring)

**Requirements.** Define the application family — `AppError : runtime_error` root; `FileError` (op, path); `ParseError` (path, lineNo, line); `InsufficientFundsError` (requested, available — from Lesson 2); `InsufficientStockError` (item, requested, available); `InvalidAmountError`. Every desk operation that can fail in a way a *caller* must hear about throws the matching type; `main` runs the four-layer net (specific → family → world → catch-all).

**Student tasks.**

1. Write the family (Lesson 2's pattern: one type per failure *kind*, data carried).
2. Upgrade the loads: missing file → `FileError`; corrupt line → `ParseError` **carrying the line number** (rethrow-with-context around `stoi`/`stod`); zero *parsed* records → your policy decision, stated in one comment.
3. Upgrade the desks: `withdraw`/`sell` throw the typed refusals; the sell-desk *transaction* problem is Ring 3's.
4. Wire `main`'s net: `catch (const InsufficientFundsError&)` (decline politely, return to menu), `catch (const FileError&)` (report and offer re-entry), `catch (const AppError&)`, `catch (const exception&)`, `catch (...)`.
5. Prove the ladder: force one failure of each type and log which handler fired.

**Ring 2 test table.**

| Input | Expected | Actual |
| --- | --- | --- |
| `students.csv` line `Bob,abc,3.0` | `ParseError` caught; report names line 2 | |
| `stock.csv` line `Pen,5,-1.0` | `ParseError` (negative price) or refused record, per stated policy | |
| fee payment over balance | polite decline **computed from the exception** | |
| sell 200 notebooks (120 in stock) | `InsufficientStockError` message with both numbers | |
| any uncaught-programmer slip | world desk reports, program exits cleanly | |

**What Ring 2 cannot fix** (write this down — it motivates Ring 3): if `sell` decrements stock and *then* the fee charge throws, the desk lies — stock gone, money not. The exception was loud; the *state* was still half-written.

---

## Ring 3 — transaction safety (the strong ring)

**Requirements.** The sell-desk operation gets the **strong guarantee**: either the stock is decremented and the fee charged, or both are untouched. Use the challenge-C8 rollback object or the ordering discipline (all fallible work before the irreversible commit). Every destructor in the program is no-fail — audit this explicitly.

**Student tasks.**

1. Write the sell operation as a transaction: capture both pre-states → perform the fallible work → commit both, or restore both.
2. Choose your shape: ordering-only (validate/verify everything fallible first) or rollback-guard (restore on unwind) — write the one-sentence defence.
3. Audit every destructor: can any throw? Fix to no-fail.
4. Run the fault-injection test (challenge C10's harness shape): make the fee charge throw on demand; verify stock restored.

**Ring 3 test table.**

| Input | Expected | Actual |
| --- | --- | --- |
| sell succeeds | stock −1, balance −price, log written | |
| fee charge fails (injected) | **stock unchanged**, user told | |
| log write fails (injected) | **neither changed**, user told | |
| restore itself fails (injected) | CRITICAL report, program still exits cleanly | |

---

## The solution (Ring 3 shape, compressed)

```cpp
// robust-app.cpp — Programming Fundamentals Using C++
// Robustness module · Lab · the Robust Student/Bank/Inventory Application
// Compile: g++ -std=c++17 -Wall -Wextra robust-app.cpp -o robust-app
// (Skeleton: the desks' data structures and guards are from earlier labs.)

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <map>
#include <stdexcept>
using namespace std;

// ---- the exception family (Ring 2) --------------------------------------
class AppError : public runtime_error {
public: explicit AppError(const string& m) : runtime_error(m) {}
};
class FileError : public AppError {
public: FileError(const string& op, const string& path)
        : AppError(op + ": cannot open " + path) {}
};
class ParseError : public AppError {
public: ParseError(const string& path, int lineNo, const string& line)
        : AppError("parse error in " + path + " at line " + to_string(lineNo)
                   + ": \"" + line + "\"") {}
};
class InvalidAmountError : public AppError {
public: explicit InvalidAmountError(double a)
        : AppError("invalid amount: " + to_string(a)) {}
};
class InsufficientFundsError : public AppError {
public: InsufficientFundsError(double req, double avail)
        : AppError("insufficient funds: need " + to_string(req)
                   + ", have " + to_string(avail)), req(req), avail(avail) {}
        double shortfall() const { return req - avail; }
private: double req, avail;
};
class InsufficientStockError : public AppError {
public: InsufficientStockError(const string& item, int req, int avail)
        : AppError("insufficient stock: " + item + " need " + to_string(req)
                   + ", have " + to_string(avail)) {}
};

// ---- the domain objects (guards + typed refusals) ------------------------
struct Student {
    string name; int id; double gpa;
    Student(const string& n, int i, double g) : name(n), id(i), gpa(g) {
        if (g < 0.0 || g > 4.0) throw AppError("student gpa out of range: " + n);
    }
};

class FeeAccount {                       // the bank desk (R2 of the refactor workshop)
public:
    explicit FeeAccount(double opening) : balance(opening) {}
    void charge(double amount) {
        if (amount <= 0)      throw InvalidAmountError(amount);
        if (amount > balance) throw InsufficientFundsError(amount, balance);
        balance -= amount;
    }
    double getBalance() const { return balance; }
private:
    double balance;
};

class Inventory {                        // the stock desk
public:
    void checkStock(const string& item, int qty) const {
        int have = stock.at(item);                       // checked access — throws out_of_range
        if (qty > have) throw InsufficientStockError(item, qty, have);
    }
    void sell(const string& item, int qty) {
        checkStock(item, qty);           // the refusal fires BEFORE anything moves
        stock[item] -= qty;              // the commit
    }
    map<string, int> snapshot() const { return stock; }
    void restore(const map<string, int>& s) { stock = s; }
private:
    map<string, int> stock;
};

class LogFile {                          // the transaction log (Files module Lab 6)
public:
    explicit LogFile(const string& path) : out(path, ios::app) {
        if (!out) throw FileError("open", path);
    }
    void append(const string& what, int id, const string& item, int qty) {
        out << what << "," << id << "," << item << "," << qty << "\n";
        out.flush();
        if (!out) throw AppError("append: write failed");   // loud, never silent
    }
private:
    ofstream out;
};

// ---- the transaction (Ring 3) --------------------------------------------
// Strong guarantee by ordering: every fallible step precedes every commit.
bool sellToStudent(Student& s, FeeAccount& acct, Inventory& inv, LogFile& log,
                   const string& item, int qty, double price) {
    // Phase 1 — fallible work, touching nothing irreversible:
    inv.checkStock(item, qty);               // may throw InsufficientStockError (no state touched)
    log.append("sell", s.id, item, qty);     // may throw (write failure — no state touched)
    // Phase 2 — commits, adjacent and gapless (validated in phase 1):
    acct.charge(price * qty);                // throws leave the balance valid (validate-then-mutate)
    inv.sell(item, qty);                     // the last commit — cannot refuse after checkStock
    return true;
}
```

*(The listing shows the load-bearing shapes: the exception family, the guarded domain objects, the transaction log, and the transaction's phase structure. The desks' menus, the loaders with `ParseError` context, and the fault-injection harness are your assembly work — every piece exists in this module and the Files/STL labs.)*

## Explanation

- **Ring 1's guards and Ring 2's throws are not rivals** — the menu re-prompts (expected input error, handled locally) while the depths throw (the loader cannot decide the app's fate). One boundary, one escalation path, zero silent refusals.
- **The transaction's phase order** is the module's central idea applied: the stock *check* (the typed refusal, before anything moves), then the log append (fallible, no state change), then the two commits — adjacent, with nothing between them. Trace the fault table: stock-refusal → nothing touched; log-failure → nothing touched; fee-failure → the balance is still valid (charge validates before it mutates), so nothing lies. The one seam (a throw *between* the two commits) contains *nothing* — and the empty gap, commented, is the strong guarantee made visible.
- **The destructors are audited to no-fail** because unwinding runs them on every throw path — `map`/`string`/stream members clean up themselves, which is the STL/pointers modules' ownership habit paying its highest dividend yet.
- **Why a rollback guard is still worth building (C8)** when ordering suffices here: ordering breaks the moment a teammate inserts a throwing call into the commit phase. The guard makes the guarantee *structural*. Your defence sentence should take a side and say why.

## ⭐ Extensions

1. **The error budget (challenge C9):** import `students.csv` with a 5% bad-line budget — under budget, succeed and report skips; over budget, throw with the summary.
2. **The context prefix (challenge C4):** every rethrow composes the desk name — `report: bank: charge: ...` — and a catch prints the composed journey.
3. **The daily close:** a "close day" operation that must log the day's totals *or* throw — with the totals held in a no-fail destructor guard so a crash still leaves the audit trail on disk.
4. **Portfolio write-up:** the lab's three rings as a refactor-workshop entry (original → invited failure → robust version → what changed) for your portfolio, exactly as in the workshop page.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
