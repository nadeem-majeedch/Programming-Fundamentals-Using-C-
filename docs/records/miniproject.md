---
title: "Mini-Project — The Student Record Management System"
description: "The capstone: a complete procedural records program — validated schemas, enum states, derived grades, key lookups, and a report suite — the Unit 14 deliverable."
---

# Mini-Project — The Student Record Management System

> [← Module home](index.md) · Unit 14 capstone · Built in six progressive milestones

The [Utility Toolkit](../functions/miniproject.md) managed numbers. The [Text Analysis Toolkit](../strings/miniproject.md) managed text. The [Quiz Runner](../pointers/miniproject.md) managed a heap roster of scores. This one manages **students** — full records, with enum states, derived grades, unique IDs, and a report suite — procedurally: structs and free functions only, no classes. It is also, deliberately, the **blueprint you will refactor into classes in Unit 15**: every function here has a future as a member function.

## The product

A menu program over a fixed-capacity roster (100):

| # | Command | What it does |
| - | ------- | ------------ |
| 1 | Admit | Validating factory: unique roll number, name, programme (enum), semester 1–8, validated fee status |
| 2 | Record marks | By roll number: 5 quiz scores (0–10 each) — stored in the record's score array |
| 3 | Report card | By roll number: the full record, computed total, percentage, derived letter grade |
| 4 | Programme list | All students of one programme (enum-driven grouping), sorted by percentage descending |
| 5 | Statistics | Per-programme: count, average %, pass count (≥ 50%), highest scorer |
| 6 | Update status | Change ACTIVE/FROZEN/GRADUATED with a guarded transition (GRADUATED is one-way) |
| 7 | Discharge | Remove by roll number (shift-left; contiguous roster) |
| 8 | Quit | Session summary, exits |

**Session summary on quit**: admits, marks recorded, report cards printed, discharges, current roster count.

## The schema — design it *before* milestone 1

```cpp
enum class Programme { BSCS, BSSE, BSIT, BSDS };          // the closed set of degrees
enum class FeeStatus  { PAID, PARTIAL, UNPAID };          // the accounts state
enum class StdStatus  { ACTIVE, FROZEN, GRADUATED };      // the academic state

struct StudentRecord {
    int             roll;          // unique — the key every lookup uses
    std::string     name;          // full name
    Programme       programme;     // the degree programme
    int             semester;      // 1–8
    FeeStatus       fee;           // accounts state
    StdStatus       status;        // academic state — see M6's rules
    double          quizzes[5];    // 0–10 each; −1.0 = not yet recorded (the sentinel)
    int             quizCount;     // how many quizzes are recorded
};
```

Design memo you should be able to write (and the deliverable asks for): **why is `Grade` absent?** It's *derived* — never stored ([Lab 2's rule](labs.md#lab-2--employee-records)); storing it would drift the moment a quiz is edited. Why is `quizzes` an array *inside* the record? Because five scores are the same fact about one student — the [nested-data rule](lesson-2-functions-nesting.md#3-nested-structures--records-inside-records) applied to repetition. Why −1.0 and not 0.0 for unrecorded? The [sentinel rule](../repetition/lesson-3-break-continue-sentinels.md): a sentinel must be unreachable as real data.

Every function obeys the [Lesson 2 door rules](lesson-2-functions-nesting.md#1-passing-structures--three-doors): factories return records, printers take `const&`, mutators take references, lookups return indices. No globals.

## Milestones

**M1 — Schema + admit.** Enums, record, `programmeText`/`feeText`/`statusText` bridges, `readProgramme` menu mapper ([E19's pattern](exercises.md#s19)), and `admitStudent`: unique-roll scan (refuse duplicates *with the existing holder's name*), validated semester 1–8, fee from the mapper, status = ACTIVE, quizCount = 0. *Test*: admit two students, admit roll 1 again → refused, naming the first student.

**M2 — Record marks.** `recordMarks(StudentRecord& s)`: guard `s.status == ACTIVE` (frozen/graduated students don't sit quizzes), then read exactly 5 scores, each validated 0–10, stored into `quizzes[i]`, `quizCount = 5`. *Test*: recording twice *overwrites* (document: latest attempt wins), recording for a FROZEN student refused.

**M3 — Report card.** `double percentage(const StudentRecord& s)` — total / (quizCount × 10) × 100, cast rule, honest guard for quizCount 0 (return −1.0, documented). `Grade gradeOf(double pct)` — the bands live in exactly one function ([Lab 1's rule](labs.md#lab-1--student-records)). `printReportCard(const StudentRecord&)` — every field, the quiz line, the derived percentage and grade. *Test*: the hand-computed card — scores 8,9,7,10,6 → 40/50 → **80.0%** → A.

**M4 — Programme list + statistics.** `listByProgramme` — the [E17 enum-grouping](exercises.md#s17) outer loop, records sorted by percentage descending **within** the group (a comparator + selection sort on a copied index list, or sort-in-place then restore is *not* allowed — the roster's order belongs to admission, document that). `statsByProgramme` — count, avg %, pass count, and the highest scorer *by name* per programme. *Test*: the four-student two-programme table from the deliverables.

**M5 — Update status.** `updateStatus(StudentRecord& s, StdStatus next)` — the [guarded transition](../records/challenges.md#c4): ACTIVE→FROZEN ✓, FROZEN→ACTIVE ✓, ACTIVE→GRADUATED ✓ (only from ACTIVE), FROZEN→GRADUATED ✓, GRADUATED→anything ✗ (one-way door — print the refusal). *Test*: the 6-transition table including both refusals.

**M6 — Discharge + summary.** `discharge(StudentRecord roster[], int& count, int roll)` — find by roll (−1 convention), shift left, count stays the truth ([Lab 5's discipline](labs.md#lab-5--patient-records)). Quit prints the summary. *Test*: discharge a middle record; verify contiguity by listing; discharge the same roll again → refused.

## Deliverables

1. **The program** — no globals, every record constructed by `admitStudent`, every state change through a guarded function, every print through `const&`.
2. **A test table** — per command: input, expected output (hand-traced), actual, PASS/FAIL. Minimum 15 rows covering: duplicate roll, frozen-student refusal, the 80.0% card, empty-programme listing, every M5 transition, discharge contiguity.
3. **The design memo** (one page): the three schema questions answered (derived Grade; the quiz array; the −1.0 sentinel), the transition table for `StdStatus`, and — the Unit 15 bridge — **which of your functions touch fields directly and which never do**: the ones that never do are already class-ready.
4. **A hand-trace** of one full lifecycle: admit → marks → card → freeze → thaw → graduate → discharge, drawn as a record-state timeline.

## Reference skeleton (start here, then grow)

```cpp
#include <iostream>
#include <string>
#include <iomanip>

const int CAP = 100;

enum class Programme { BSCS, BSSE, BSIT, BSDS };
enum class FeeStatus  { PAID, PARTIAL, UNPAID };
enum class StdStatus  { ACTIVE, FROZEN, GRADUATED };

struct StudentRecord {
    int         roll;
    std::string name;
    Programme   programme;
    int         semester;
    FeeStatus   fee;
    StdStatus   status;
    double      quizzes[5];
    int         quizCount;
};

const char* programmeText(Programme p) {
    switch (p) {
        case Programme::BSCS: return "BSCS";   case Programme::BSSE: return "BSSE";
        case Programme::BSIT: return "BSIT";
    }
    return "BSDS";
}

bool pickProgramme(int choice, Programme& out) {       // menu mapper — E19's pattern
    switch (choice) {
        case 1: out = Programme::BSCS; return true;
        case 2: out = Programme::BSSE; return true;
        case 3: out = Programme::BSIT; return true;
        case 4: out = Programme::BSDS; return true;
    }
    return false;
}

int findByRoll(const StudentRecord roster[], int count, int roll) {
    for (int i = 0; i < count; i = i + 1)
        if (roster[i].roll == roll) return i;
    return -1;
}

bool admitStudent(StudentRecord roster[], int& count, int roll, const std::string& name) {
    if (findByRoll(roster, count, roll) != -1) return false;    // unique-roll gate
    if (count >= CAP) return false;

    StudentRecord s;
    s.roll = roll;  s.name = name;
    int p;
    do { std::cout << "programme (1-BSCS 2-BSSE 3-BSIT 4-BSDS): "; std::cin >> p; }
    while (!pickProgramme(p, s.programme));
    do { std::cout << "semester (1-8): "; std::cin >> s.semester; }
    while (s.semester < 1 || s.semester > 8);
    s.fee = FeeStatus::UNPAID;              // every admission starts here — documented
    s.status = StdStatus::ACTIVE;
    s.quizCount = 0;
    roster[count] = s;                      // one record, fully valid, in one move
    count += 1;
    return true;
}

double percentage(const StudentRecord& s) {
    if (s.quizCount == 0) return -1.0;      // documented: -1 = nothing recorded yet
    double total = 0.0;
    for (int i = 0; i < s.quizCount; i = i + 1) total += s.quizzes[i];
    return total / (s.quizCount * 10.0) * 100.0;
}

int main() {
    StudentRecord roster[CAP];
    int count = 0;
    int admits = 0, cards = 0, discharges = 0;
    int choice;
    do {
        std::cout << "\n1-admit 2-marks 3-card 4-list 5-stats 6-status 7-discharge 8-quit: ";
        std::cin >> choice; std::cin.ignore(1000, '\n');
        switch (choice) {
            case 1: {
                int roll; std::string name;
                std::cout << "roll: "; std::cin >> roll;
                std::cin.ignore(1000, '\n');
                std::cout << "name: "; std::getline(std::cin, name);
                if (admitStudent(roster, count, roll, name)) { admits += 1; std::cout << "admitted\n"; }
                else std::cout << "refused (duplicate roll or full)\n";
                break;
            }
            case 3: { /* findByRoll -> printReportCard */ cards += 1; break; }
            case 7: { /* findByRoll -> shift-left */ discharges += 1; break; }
        }
    } while (choice != 8);
    std::cout << "admits=" << admits << " cards=" << cards
              << " discharges=" << discharges << " roster=" << count << '\n';
}
```

**Three subtleties to notice** (they're in the skeleton on purpose):

1. **`admitStudent` builds `s` completely before the single assignment** — the roster never holds a half-built record, even for one statement. Construction through checkpoints is the Unit 15 constructor preview.
2. **`percentage` returns −1.0 for "nothing recorded"** — a documented sentinel in a *derived* value, so callers must guard before printing; the honest alternative is a separate `bool& ok` — pick one, write the contract.
3. **The roll number is the only key** — every command locates through `findByRoll`, never by position. The moment you trust positions, a discharge shifts the ground under you.

## Self-check before you call it done

- [ ] No record exists outside the factory's output; no state changed outside `updateStatus`; no grade computed outside `gradeOf`
- [ ] Every lookup goes through `findByRoll`; the roster is contiguous after every discharge
- [ ] The test table's 80.0% card matches the machine — and the trace shows *why*
- [ ] The design memo's function list has a visible "never touches fields" group — your Unit 15 member-function shortlist
- [ ] Compare with the [Quiz Runner](../pointers/miniproject.md): one sentence on what the record type removed (the parallel arrays) and one on what it *kept* (the handle + count convention)
