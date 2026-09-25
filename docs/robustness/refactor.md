---
title: "Refactor Workshop — Eight Earlier Programs, Made Robust"
description: "Programs from earlier labs rebuilt with the exception machinery: marks calculator, bank account, inventory file, grade analyzer, string tools, records, and files — before/after with the failure that motivated each change."
---

# Refactor workshop — eight earlier programs, made robust

> [← Module home](index.md) · Each refactor: the original → the failure it invites → the robust version → what changed and why

This page is the module's bridge between theory and your own portfolio. Eight programs you have already built (or can rebuild from the earlier labs) get the robustness treatment. **Work the pattern, not the answers:** for each, read the original, find the silent failure *yourself*, write your own robust version, then compare.

The shared before/after shape:

```text
BEFORE: failure detected → ignored or defaulted → program continues with bad state
AFTER:  failure detected → thrown as a typed exception → caught at the layer that can act
```

---

## R1 — the marks calculator (C++ Foundations lab, Unit 03)

**The original habit.** Read three marks, average, grade. In its first form the program trusted `cin` completely:

```cpp
// BEFORE — trusts everything
double m1, m2, m3;
cin >> m1 >> m2 >> m3;                 // typing "abc" leaves m1 = 0 (C++11+), silently
cout << "average: " << (m1 + m2 + m3) / 3 << "\n";
```

**The failure it invites.** Type `abc 90 80` and the program prints an average of 56.7 with no complaint — species #3 (the defaulted value) with a grade attached. Worse: a mark of 999 or −5 passes straight through.

**The robust version.** The boundary guard (the validation-suite reader, unchanged since Unit 07) plus a domain guard:

```cpp
// AFTER — boundary guards + range guard
double readMark(const string& label) {
    double m = readDoubleInRange(cin, 0.0, 100.0);   // Unit 07's reader, double form
    return m;
}

int main() {
    double m1 = readMark("mark 1"), m2 = readMark("mark 2"), m3 = readMark("mark 3");
    cout << "average: " << (m1 + m2 + m3) / 3 << "\n";
}
```

**What changed.** Here the right tool was still the *guard* layer — user input is expected to be wrong, so re-prompting beats throwing. The lesson: **refactoring to "robust" does not mean sprinkling `try` everywhere**; it means choosing the layer deliberately.

---

## R2 — the bank account (OOP module Lab 1 → this module's Lesson 2)

**The original habit.** The OOP module's `BankAccount::withdraw` defended itself with a `bool`:

```cpp
// BEFORE — the boolean ask-door
bool withdraw(double amount) {
    if (amount <= 0 || amount > balance) return false;
    balance -= amount;
    return true;
}
```

**The failure it invites.** The door itself is honest — but every *caller* must remember to check the `bool`. One forgotten `if` in a ten-call chain and a declined transfer silently corrupts the caller's accounting (species #5). This is exactly the "ignorable" column of Lesson 1's table.

**The robust version.** The Lesson 2 family — `InvalidAmountError` and `InsufficientFundsError` — with `withdraw` throwing instead of returning:

```cpp
// AFTER — typed refusal
void withdraw(double amount) {
    if (amount <= 0)      throw InvalidAmountError(amount);
    if (amount > balance) throw InsufficientFundsError(amount, balance);
    balance -= amount;
}
```

**What changed.** The refusal became **impossible to ignore**: an uncaught `InsufficientFundsError` stops the program loudly instead of letting a wrong total propagate. Callers that *can* act catch the specific type; callers that can't let it fly. Note what did *not* change: the invariant (balance untouched on failure) held in both versions — the throw version just makes the *report* mandatory.

---

## R3 — the inventory file (Files module Lab 3)

**The original habit.** Load stock levels, compute totals:

```cpp
// BEFORE — the open-and-pray
ifstream in("inventory.txt");
int total = 0, qty;
while (in >> qty) total += qty;
cout << "total units: " << total << "\n";
```

**The failure it invites.** Missing file: the loop body never runs and the program prints `total units: 0` — a *plausible lie* (species #1 plus #4: an empty report that looks like data). Corrupt line: `>>` fails, the loop stops early, and the total silently covers only the prefix that parsed.

**The robust version.** Throw at the open; count and report at the parse:

```cpp
// AFTER — loud open, loud parse
int loadTotalUnits(const string& path, int& linesRead) {
    ifstream in(path);
    if (!in) throw runtime_error("loadTotalUnits: cannot open " + path);
    int total = 0, qty;
    linesRead = 0;
    while (in >> qty) { total += qty; ++linesRead; }
    if (in.bad()) throw runtime_error("loadTotalUnits: read error in " + path);
    return total;                       // caller decides whether linesRead is plausible
}
```

**What changed.** A missing file is now an *event*, not a zero. And the caller receives `linesRead` alongside the total, so "0 units from 0 lines" (suspicious) is distinguishable from "0 units from 240 lines" (a real empty warehouse). The same upgrade pattern applies verbatim to the expense tracker and contact list labs.

---

## R4 — the grade analyzer (STL module Lab 3)

**The original habit.** `count_if`, `accumulate`, `min_element` over a marks vector — with one division at the end:

```cpp
// BEFORE — the divide-by-nothing
double avg = (double)accumulate(marks.begin(), marks.end(), 0) / marks.size();
```

**The failure it invites.** An empty input file (or a path typo) gives an empty vector — and `marks.size()` is 0. Division by zero on doubles yields `inf`/`nan`, which **prints** politely and then poisons every downstream comparison (species #4 again: a computed garbage that passes as output).

**The robust version.**

```cpp
// AFTER — refuse before dividing
double averageOf(const vector<int>& marks) {
    if (marks.empty()) throw runtime_error("averageOf: no marks loaded");
    return (double)accumulate(marks.begin(), marks.end(), 0L) / marks.size();
}
```

**What changed.** One guard at the *cheapest layer that understands the failure* — the function whose mathematics break on empty input. The menu layer (which can re-prompt for a better file) catches and reports. The accumulator also grows a `0L` seed: the long-seed habit from the STL module, kept.

---

## R5 — the word counter (Strings module mini-project)

**The original habit.** Split a line into words, tally in a map, print the top word.

```cpp
// BEFORE — the silent empty
string line;
getline(cin, line);
// ... split into words, tally ...
cout << "most frequent: " << bestWord << "\n";    // empty input prints "most frequent: "
```

**The failure it invites.** Enter (or paste) an empty line and the program reports an empty champion with a straight face.

**The robust version.**

```cpp
// AFTER — empty input is a refused operation, not a report
map<string, int> tally = countWords(line);
if (tally.empty()) throw runtime_error("countWords: no words in input");
```

**What changed.** "No words" is a *condition the caller must know about* — the report layer now either prints a real champion or prints "no input" because an exception said so. Small program, but the discipline is identical to a production log analyzer's.

---

## R6 — the student record system (Records module mini-project)

**The original habit.** A `struct Student` with a `gpa` field, filled from input:

```cpp
// BEFORE — the unvalidated record
Student s;
cout << "name: ";  getline(cin, s.name);
cout << "gpa: ";   cin >> s.gpa;                  // −3.0 accepted
students.push_back(s);
```

**The failure it invites.** A `gpa` of −3 or 99 enters the collection and every later statistic silently absorbs it. The record is *born invalid* — and no later layer knows to re-check.

**The robust version.** Prevention layer: make an invalid record **unrepresentable**.

```cpp
// AFTER — the constructor is the gate
class Student {
public:
    Student(const string& name, double gpa) : name(name), gpa(gpa) {
        if (gpa < 0.0 || gpa > 4.0) throw InvalidGpaError(gpa);
        if (name.empty())           throw InvalidNameError();
    }
    // getters; no setter that could un-validate (or one that re-validates identically)
private:
    string name;
    double gpa;
};
```

**What changed.** This is Layer 1 (prevent) doing Layer 3's job permanently: a `Student` object that exists is valid, full stop. The vector-of-objects idiom from the OOP module carries the guarantee into every container.

---

## R7 — the expense tracker (Files module Lab 2)

**The original habit.** Append an expense, then read the total back. Two file operations, both unchecked in the first version:

```cpp
// BEFORE — the double silent
ofstream out("expenses.txt", ios::app);
out << category << " " << amount << "\n";         // disk full? nothing said
out.close();
// ... later: total read back and printed as if it included the new row
```

**The failure it invites.** If the open or the write fails (disk full, permissions), the user's expense is *not recorded* — and the next total read makes it look like it was. A financial record that vanishes silently is the worst species on the list.

**The robust version.**

```cpp
// AFTER — the append is acknowledged or the program says so
void appendExpense(const string& path, const string& category, double amount) {
    ofstream out(path, ios::app);
    if (!out) throw runtime_error("appendExpense: cannot open " + path);
    out << category << " " << amount << "\n";
    out.flush();
    if (!out) throw runtime_error("appendExpense: write failed for " + category);
}
```

**What changed.** The stream-state checks the Files module taught (`if (!out)` *after* the write — flush first) are now failure *events*. The strong-guarantee shape from Lesson 2 is visible here too: verify before the caller moves on to the next irreversible step.

---

## R8 — the media library, transaction log edition (Inheritance / Files modules)

**The original habit.** The mini-projects' "remove item X, then log the removal" sequence, written as two independent calls:

```cpp
// BEFORE — two steps, one truth
library.remove(title);              // suppose this succeeds...
log.append("removed " + title);     // ...and this throws (disk full, file missing)
```

**The failure it invites.** The library lost the item but the log never heard about it — or, reversed order, the log records a removal that never happened. Two systems, one truth each, disagreeing forever.

**The robust version.** The strong guarantee, as a transaction:

```cpp
// AFTER — the fallible step goes first
void removeAndLog(MediaLibrary& library, LogFile& log, const string& title) {
    log.append("removing " + title);       // 1. the fallible work FIRST (may throw)
    library.remove(title);                 // 2. the in-memory commit LAST (basic-safe)
}
```

**What changed.** If the log append throws, the library was never touched — the operation is as-if-never-called, and a retry is safe. The ordering rule of Lesson 2's strong guarantee in miniature: **arrange the sequence so the irreversible step is the last one.**

---

## The workshop's pattern card

| Refactor | Silent species killed | Layer that throws | Level aimed for |
| --- | --- | --- | --- |
| R1 marks | #3 defaulted value | — (guard layer; deliberately no throw) | basic |
| R2 bank | #5 lying success | `InvalidAmountError`, `InsufficientFundsError` | strong (invariant held) |
| R3 inventory | #1 + #4 | `runtime_error` at open/parse | basic |
| R4 grade | #4 computed garbage | `runtime_error` before divide | basic |
| R5 word count | #4 empty report | `runtime_error` | basic |
| R6 records | born-invalid state | custom family in constructor | prevention |
| R7 expense | #4 partial write | `runtime_error` after flush | strong (verify before proceeding) |
| R8 media+log | #4 half-updated pair | reordering + rethrow | strong (transaction shape) |

**Your turn:** pick any two of your own earlier programs and produce the same four-part write-up — original, invited failure, robust version, what-changed. That pair is [the lab's](labs.md) warm-up.
