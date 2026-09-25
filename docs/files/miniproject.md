---
title: "Mini-Project — The File-Based Student Management System"
description: "The capstone: the Records module's Student Record Management System given persistent storage — one format contract, load-on-start, save-on-change, and an audit log."
---

# Mini-Project — The File-Based Student Management System

> [← Module home](index.md) · Unit 12 capstone · Built in six progressive milestones

The [Records module](../records/miniproject.md) built a Student Record Management System whose data died at exit. This project gives it **memory**: one `roster.txt` that persists between runs, one `audit.log` that records everything done — the same program, now trustworthy.

The design inheritance is deliberate: the schemas, the validating factories, the guarded transitions, and the key lookups all come from the Records module **unchanged**. What's new is the file layer — and the discipline that it demands: a format contract, load-on-start, save-on-change, and an audit trail.

## The product

A menu program over a persistent roster (capacity 100):

| # | Command | What it does |
| - | ------- | ------------ |
| 1 | Admit | Validating factory (unique roll, programme enum, semester 1–8, fee status) — as in the Records module |
| 2 | Record marks | By roll: 5 quiz scores (0–10), ACTIVE students only |
| 3 | Report card | By roll: full record + derived percentage and grade |
| 4 | Programme list | Enum-grouped, sorted by percentage (in-memory, as before) |
| 5 | Statistics | Per-programme count / avg / pass count |
| 6 | Update status | Guarded transitions (GRADUATED is one-way) |
| 7 | Discharge | Remove by roll (shift-left) |
| 8 | Save now | Explicit save (also runs automatically on quit) |
| 9 | Quit | Auto-save + session summary |
| — | audit.log | Every state change is logged: `seq;event;detail` — no menu option; it just happens |

**Session summary on quit**: admits, marks, cards, discharges, saves performed, audit entries written, current roster count.

## The two format contracts — decide them before milestone 1

```text
// roster.txt — v1 (count-first, mixed-strategy records; 4 lines per student):
//   <count>
//   <roll> <semester> <programme-code 0-3> <fee-code 0-2> <status-code 0-2>
//       <quizCount> <q1> <q2> <q3> <q4> <q5>          (formatted: no spaces in these fields)
//   <full name>                                        (line-based: may contain spaces)
//   -                                                  (reserved separator line; see M4)
// audit.log — append-only, per-event close (Lab 6's contract, reused verbatim):
//   <seq>;<event>;<detail>
```

Design sentences your write-up must include: why the *name* gets its own line (spaces force line-based — [Lesson 2 §2](lesson-2-reading-writing.md#2-two-reading-strategies--match-the-format)); why programme/fee/status are stored as **codes** (ints) rather than text (compact + unambiguous, decoded by the enum bridges on load — the [D9](debugging.md#d9) amendment discipline applies to codes too); why the grade is absent (derived — never stored, never drifted); why the audit log is append-only (evidence — [Lab 6](labs.md#lab-6--simple-transaction-log)).

## Milestones

**M1 — Load.** `loadRoster(roster, cap)` from the contract: open check, count clamp, the formatted line, ignore, name getline, ignore — the [Lab 3 mixed-strategy rhythm](labs.md#lab-3--inventory-file) with one more field group. Codes decode through the enum mappers. Missing file → empty roster (the first-run contract). *Test*: hand-write a 2-student roster file; load; list. The file you wrote by hand is the ground truth.

**M2 — Save.** `saveRoster(...)` mirrors the contract exactly; save-on-quit wired. *Test*: load 2 → admit 1 → quit → **inspect the file** (3 students, codes correct) → restart → list shows all 3. The round trip *is* the test.

**M3 — Admit + record marks + report card.** Ported from the Records module nearly verbatim — plus one `logEvent` per state change. *Test*: admit, record 8/9/7/10/6, card prints **80.0% / A** (the hand-computed card), audit.log gains 2 lines.

**M4 — The separator line's purpose.** The contract reserves a `-` line per record. Now use it: extend the record with `std::string guardian;` (may contain spaces *and* digits), save it on that line, load it back. The point: the contract changed — so change **the contract comment, the writer, and the reader in the same edit** ([D9](debugging.md#d9) experienced from the designer's side). Old v1 files (no guardian line) load with an empty guardian — the version-tolerance decision, documented. *Test*: load a v1 file, admit a guardian-bearing student, save, inspect.

**M5 — Status transitions + discharge, with audit.** Ported; every transition and discharge logs `STATUS`/`DISCHARGE` with the roll and before/after. *Test*: the full Records-module transition table, plus audit lines matching; discharge a middle record, verify contiguity, save, restart, verify persistence of the removal.

**M6 — The audit menu + polish.** Option 8 (save now) added; a hidden option 99 prints the audit log (all entries + counts by event type — the [findEvents](labs.md#lab-6--simple-transaction-log) pass). Quit summary finalized. *Test*: a full lifecycle (admit → marks → freeze → thaw → graduate → discharge) with the audit log telling the story back to you.

## Deliverables

1. **The program** — no globals; all Records-module disciplines intact (factories, `const&` printers, guarded transitions, key lookups); all file code inside `loadRoster`/`saveRoster`/`logEvent`/`readLog`.
2. **The contract comments** — verbatim, beside both file functions and the audit functions.
3. **A test table** — minimum 18 rows covering every milestone's tests plus: missing roster file (first run), hand-corrupted count (clamp), malformed audit line (marked, skipped), v1 file after M4 (tolerated), quit-with-unsaved-changes (auto-save).
4. **A design memo** (one page): the format-decision sentences (codes, derived grade, line-based name, separator line, append-only audit); the load-failure table (open fail / bad count / malformed line / truncated file — behaviour each); and the reflection: **which functions never touched a file and which never touched a field** — the two clean layers that Unit 15's classes will formalize.

## Reference skeleton (start here, then grow)

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>

const int CAP = 100;

enum class Programme { BSCS, BSSE, BSIT, BSDS };
enum class StdStatus  { ACTIVE, FROZEN, GRADUATED };

struct StudentRecord {
    int         roll;
    std::string name;
    Programme   programme;
    int         semester;
    StdStatus   status;
    double      quizzes[5];
    int         quizCount;
};

// ---- FILE LAYER --------------------------------------------------------
// roster.txt — v1 contract: (see module text; kept verbatim beside BOTH functions)
//   <count> / <roll> <semester> <prog> <status> <quizCount> <q1..q5> / <name> / -

int loadRoster(StudentRecord roster[], int cap, const char* filename) {
    std::ifstream in(filename);
    if (!in.is_open()) return 0;                     // first run: empty roster, by contract
    int n = 0;
    in >> n;  in.ignore(1000, '\n');                 // seam after the count
    if (n > cap) n = cap;
    for (int i = 0; i < n; i = i + 1) {
        int prog, status;
        in >> roster[i].roll >> roster[i].semester >> prog >> status >> roster[i].quizCount;
        for (int q = 0; q < 5; q = q + 1) in >> roster[i].quizzes[q];
        in.ignore(1000, '\n');                       // seam after the formatted line
        std::getline(in, roster[i].name);
        roster[i].programme = static_cast<Programme>(prog);
        roster[i].status    = static_cast<StdStatus>(status);
    }
    return n;
}

void saveRoster(const StudentRecord roster[], int n, const char* filename) {
    std::ofstream out(filename);
    if (!out.is_open()) { std::cout << "save failed\n"; return; }
    out << n << '\n';
    for (int i = 0; i < n; i = i + 1) {
        out << roster[i].roll << ' ' << roster[i].semester << ' '
            << static_cast<int>(roster[i].programme) << ' '
            << static_cast<int>(roster[i].status) << ' ' << roster[i].quizCount << ' ';
        for (int q = 0; q < 5; q = q + 1) out << roster[i].quizzes[q] << ' ';
        out << '\n' << roster[i].name << '\n' << '-' << '\n';
    }
    out.close();
}

void logEvent(const char* logfile, int& seq, const std::string& event,
              const std::string& detail) {
    std::ofstream out(logfile, std::ios::app);
    if (!out.is_open()) return;                      // audit is best-effort, never fatal
    out << seq << ';' << event << ';' << detail << '\n';
    out.close();
    seq += 1;
}

// ---- LOGIC LAYER (ported from the Records module — unchanged) -----------
// admitStudent, recordMarks, percentage, gradeOf, printReportCard,
// listByProgramme, statsByProgramme, updateStatus, discharge
// (with one logEvent call added after each state change)

int main() {
    StudentRecord roster[CAP];
    int count = loadRoster(roster, CAP, "roster.txt");
    std::cout << "loaded " << count << " student(s)\n";

    int seq = 1;                                     // real version: recount from the log (Lab 6)
    // ...menu loop as in the Records module, plus:
    //   case 8: saveRoster(...); "saved\n";
    //   quit:  saveRoster(...); summary;
    return 0;
}
```

**Three subtleties to notice** (they're in the skeleton on purpose):

1. **The load/save pair is the *only* place that knows the file** — the logic layer deals purely in records. When M4's contract changes, exactly two functions (and two comment blocks) change. That layering is why the Records-module logic survived this unit untouched.
2. **`logEvent` takes `int& seq`** — the sequence counter lives in `main` (or is recounted from the file, Lab 6's choice); it is state that belongs to the *session*, not to the log function.
3. **Codes go in, enums come out, at the boundary** — `static_cast` after load and before save, with the validation gate on load (a code of 9 must be rejected *before* it becomes a fake enum member — the [laundering rule](../records/debugging.md#d5) applies to files too).

## Self-check before you call it done

- [ ] The hand-written roster file loads; the program's own save loads; the round trip is byte-verifiable
- [ ] A missing roster file, a corrupted count, and a malformed audit line all behave per the documented contracts
- [ ] Every state change in the test table has a matching audit line — the log tells the story back
- [ ] No function touches both the file layer and the record fields (the two-layer test)
- [ ] The design memo's load-failure table covers open-fail, bad-count, malformed-line, truncated-file
- [ ] Compare with the [Records module's](../records/miniproject.md) self-check: which checks became *unnecessary* once data persisted (e.g. "discharge then re-add" now spans runs) — and which became *possible* (persistence bugs)?
