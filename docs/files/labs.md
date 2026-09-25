---
title: "Files Labs"
description: "6 file labs — student record file, expense tracker, inventory file, marks report, contact list, transaction log — each with realistic test data and expected results."
---

# Files Labs (6 scenarios)

> [← Module home](index.md) · Attempt each lab's **student tasks** before opening its solution. Every lab: scenario → format contract → requirements → test data & expected results → student tasks → solution → explanation → ⭐ extensions. The **first deliverable in every lab is the format contract** — the exact bytes of the file, written as comments beside both the save and load code.

**Ground rules.** `open → check → use → close` on every stream, every time. Line-based reading for anything with spaces; the ignore rhythm at every `>>`-before-getline seam. Every lab ends with a **round-trip verification**: what you saved is what you loaded, or the format is buggy.

---

## Lab 1 — Student Record File

**Scenario.** The [Records module's](../records/index.md) roster lives only while the program runs. Persist it: the roster survives between runs — the lab that turns the record round trip into a reflex.

**Format contract.**

```text
// roster.txt — count-first, then per record (2 lines):
//   <n>
//   <full name>
//   <score>
```

**Requirements.**
R1. `saveRoster(const Student[], int n, const char*)` — count line first; every field ends with its separator.
R2. `loadRoster(Student[], int cap, const char*)` — returns the count; missing file → 0 (documented contract); clamped to cap; ignore rhythm at every seam.
R3. Menu program: 1-add (validated) · 2-list · 3-save · 4-load · 5-quit. Quit **auto-saves** (the safety net — an owner that persists even when the user forgets).
R4. Round-trip proof built in: option 6 loads, lists, and compares against the in-memory count — printing `round trip: OK` or the mismatch.

**Test data & expected results.**

| Step | Input | Expected result |
| --- | --- | --- |
| add 3 | Ayesha Khan/92, Ali Raza/78, Sana Mir/85 | in-memory list shows 3 |
| save | — | `roster.txt` = 7 lines: `3`, then name/score pairs |
| **inspect the file** | (editor) | exactly: `3\nAyesha Khan\n92\nAli Raza\n78\nSana Mir\n85\n` |
| quit (auto-save) | — | file unchanged (idempotent save) |
| restart, load | — | list shows the same 3, `round trip: OK` |
| delete file, load | — | 0 records, no error (the contract) |
| hand-edit count to 99, load | — | loads 0 real records without crashing (clamp + EOF stop) |

**Student tasks.**
1. Write the contract comment first, then `saveRoster`; inspect the file byte-for-byte against it.
2. `loadRoster` with all three guards (open, clamp, ignore seams) — then the hand-edited-count test.
3. Reflection: the auto-save on quit duplicates option 3. Why keep both (explicit user control + safety net) — and what would you ask the *user* if the file existed but the in-memory roster was unsaved? (The dirty-flag idea — next unit's file.)

**Solution (core).**

```cpp
void saveRoster(const Student roster[], int n, const char* filename) {
    std::ofstream out(filename);                       // truncate: a save replaces the file
    if (!out.is_open()) { std::cout << "cannot save\n"; return; }
    out << n << '\n';
    for (int i = 0; i < n; i = i + 1)
        out << roster[i].name << '\n' << roster[i].score << '\n';
    out.close();
}

int loadRoster(Student roster[], int cap, const char* filename) {
    std::ifstream in(filename);
    if (!in.is_open()) return 0;                       // missing = empty, by contract
    int n = 0;
    in >> n;  in.ignore(1000, '\n');                   // seam 1
    if (n > cap) n = cap;
    for (int i = 0; i < n; i = i + 1) {
        std::getline(in, roster[i].name);
        in >> roster[i].score;
        in.ignore(1000, '\n');                         // seams 2..n+1
    }
    return n;
}
```

**Explanation.** This is [E13's](exercises.md#s13) round trip scaled to a menu. The lab's teaching point is the **contract as artifact**: the inspection row of the test table (file = exactly 7 specific lines) is what makes the load code provable — when the file's bytes match the contract and the loader follows the contract, correctness is two local checks, not a mystery. The hand-edited count test is the [D6](debugging.md#d6) bug experienced from the defender's side.

**⭐ Extensions.** ⭐ Add a version comment line (`# v1`) that the loader skips — the [D9](debugging.md#d9) amendment mechanism. ⭐⭐ Merge on load: loading into a non-empty roster appends, refusing duplicate names — a policy choice to document.

---

## Lab 2 — Expense Tracker

**Scenario.** A daily ledger: append one expense per entry, load-and-report on demand. Append mode is the protagonist — history is the product.

**Format contract.**

```text
// expenses.txt — append-only; one expense per line:
//   <description>;<amount>
// ';' chosen because descriptions may contain commas/periods but never semicolons
```

**Requirements.**
R1. `addExpense(desc, amount)` — append mode, open check, close per record (durability: a crash must not lose a confirmed expense).
R2. `loadExpenses(items[], cap)` — returns count; splits each line on `';'` (find/substr, [Unit 11](../strings/index.md)); malformed lines **reported and skipped**, not fatal.
R3. Report: all expenses + count + total (1 dp) + largest expense (the champion pass).
R4. Description may contain spaces (line-based!) — and the tracker runs entirely on the file (no in-memory master; load, report, exit).

**Test data & expected results.**

| Input (appended over 3 runs) | File grows to | Report shows |
| --- | --- | --- |
| `lunch at cafe, with tip;450` | 1 line | 450 |
| `bus card recharge;1200` | 2 lines | total 1650.0 |
| `stationery, pens and pads;310.5` | 3 lines | total 1960.5, largest 1200.0 |

Reload after "crash" (re-run the report alone): all 3 present — per-record close earned its keep. Malformed test: hand-add line `broken line no semicolon` → report prints `skipped: broken line no semicolon`, total unchanged.

**Student tasks.**
1. Contract first; then `addExpense` with the close-per-record decision *written down* (why per-record here and not in Lab 1's save? — because this file is the only copy of history; Lab 1's roster lives in memory too).
2. The split + `stod` reader with the malformed-line policy.
3. Reflection: this format is **append-only** — no update, no delete. What operations does that trade away, and why is it still the right shape for a ledger? (History is append-only by nature; C3's rewrite is the tool when editing is truly needed.)

**Solution (core).**

```cpp
void addExpense(const char* filename, const std::string& desc, double amount) {
    std::ofstream out(filename, std::ios::app);
    if (!out.is_open()) { std::cout << "cannot open ledger\n"; return; }
    out << desc << ';' << amount << '\n';
    out.close();                       // durability: confirmed = on disk
}

double loadExpenses(Expense items[], int cap, const char* filename, int& countOut) {
    std::ifstream in(filename);
    if (!in.is_open()) { countOut = 0; return 0.0; }   // missing = empty ledger, by contract
    std::string line;
    double total = 0.0;
    countOut = 0;
    while (countOut < cap && std::getline(in, line)) {
        std::size_t p = line.find(';');
        if (p == std::string::npos) { std::cout << "skipped: " << line << '\n'; continue; }
        items[countOut].description = line.substr(0, p);
        items[countOut].amount = std::stod(line.substr(p + 1));
        total += items[countOut].amount;
        countOut += 1;
    }
    return total;
}
```

**Explanation.** Two format lessons live here: the **separator choice** (`';'` — a character the data can't produce; the test data's comma-bearing descriptions prove it) and the **malformed-line policy** (report-and-skip — a ledger tolerates one bad line better than it tolerates refusing to open). The champion pass and running total ride the load loop — one traversal, three outputs.

**⭐ Extensions.** ⭐ Month filter: report only entries whose description contains a given substring. ⭐⭐⭐ The C3 rewrite: add `removeExpense(index)` — load, compact, rewrite — with the backup-first order from [C9](challenges.md#c9).

---

## Lab 3 — Inventory File

**Scenario.** The campus store's stock room, persisted: products with quantities and reorder levels, updated across runs — the [Records module's Lab 3](../records/labs.md) with a file backbone.

**Format contract.**

```text
// inventory.txt — count-first; per record (3 lines):
//   <n>
//   <name>            (line-based: may contain spaces)
//   <qty> <reorderAt>  (formatted: two ints, space-separated)
```

**Requirements.**
R1. Load with all guards; save with the count-first header; the [enum-derived state](../records/labs.md#lab-3--product-inventory) (OK/LOW/OUT) stays **derived** — never stored in the file (it's computable from qty/reorderAt; storing it would be a [D9](debugging.md#d9) drift waiting to happen).
R2. Menu: 1-load · 2-list (with state text) · 3-receive (by index, qty += n) · 4-sell (validate-then-mutate) · 5-save · 6-reorder report (LOW and OUT) · 7-quit (auto-save).
R3. The reorder report writes **`reorder.txt`** — a second file, one product per line (`name;qty;reorderAt`), plus a console summary.
R4. Selling uses the Lab-3-of-Records gate: refuse oversell without mutating.

**Test data & expected results.**

| Start file | Action | Expected |
| --- | --- | --- |
| `2\nNotebook\n10 4\nBall Pen\n50 20\n` | load + list | Notebook 10 OK, Ball Pen 50 OK |
| sell 7 Notebooks | list | Notebook 3 LOW |
| sell 3 Notebooks | list | Notebook 0 OUT |
| sell 1 Notebook | refused — `out of stock` | qty stays 0 |
| receive 20 Notebooks | list | 20 OK |
| reorder report | `reorder.txt` written | `Notebook;20;4` — wait: state is OK now; report shows it only if LOW/OUT. **After selling 1 Ball Pen ×45**: `Ball Pen;5;20` LOW |
| quit (auto-save) | file | `2\nNotebook\n20 4\nBall Pen\n5 20\n` |

**Student tasks.**
1. Contract first — and the design memo sentence: why `state` is absent from the file (derived data; the one-updater discipline in memory).
2. The mixed-strategy record read: `>>` the two ints, ignore, getline the name — the seam order *between* records (trace where each newline lands).
3. Reflection: two files in one program (inventory + reorder report) — what differs in their open *modes* and why? (One truncates-by-design — a report is regenerated; one is the master store, saved wholesale.)

**Solution (core — the mixed-strategy read).**

```cpp
int loadInventory(Product items[], int cap, const char* filename) {
    std::ifstream in(filename);
    if (!in.is_open()) return 0;
    int n = 0;
    in >> n;  in.ignore(1000, '\n');
    if (n > cap) n = cap;
    for (int i = 0; i < n; i = i + 1) {
        std::getline(in, items[i].name);              // line-based field first
        in >> items[i].qty >> items[i].reorderAt;     // then the formatted pair
        in.ignore(1000, '\n');                        // seam: the newline after reorderAt
    }
    return n;
}
```

**Explanation.** The new skill is the **mixed record**: line-based where spaces exist, formatted where they don't — in one record. Trace the seam: `getline` consumes through the name's newline; the `>>` pair reads across the *next* newline (whitespace-transparent); the ignore then eats that pair's trailing newline so the *next* getline starts clean. Getting this rhythm right is the lab's whole difficulty — and the reason the test table starts from a hand-written file (you read what you can write by hand).

**⭐ Extensions.** ⭐ Price per product (a third field — amend writer, reader, and *the contract comment in the same edit*). ⭐⭐ Transaction count per product (how many sold all-time) — appended as a fourth field, loaded into the record's new member.

---

## Lab 4 — Marks Report

**Scenario.** The tutor's gradebook: read a class's marks from a file, produce a **report file** — files on *both* ends, none on the console except a summary. The lab where formatted reading carries the load.

**Format contract (input).**

```text
// marks.txt — formatted, one student per line:
//   <roll> <score>
```

**Format contract (output).**

```text
// report.txt — generated; header + per student + summary:
//   ROLL  NAME-IS-ABSENT (this format has no names — see extension)
//   <roll> <score> <grade-letter>
//   ...
//   average <avg>  high <h>  low <l>  pass <p>/<n>
```

**Requirements.**
R1. Read all records until EOF (formatted loop — `while (in >> roll >> score)`), capacity-clamped; validate each score 0–100 *at load* — invalid records reported and skipped.
R2. Compute per-record grade letters ([Records Lab 1's](../records/labs.md#lab-1--student-records) bands, one source of truth) and the four statistics.
R3. Write the report file; console prints only "report written: 12 records, average 71.3".
R4. The report is regenerated every run (truncate by design) — the marks file is never modified.

**Test data & expected results.**

Input `marks.txt`:
```text
101 82
102 49
103 74
104 91
105 63
106 55
107 100
108 38
```

Expected `report.txt` (grades: 82→B, 49→F, 74→C, 91→A, 63→D, 55→F? — 55 ≥ 50 → D; 100→A, 38→F):

| roll | score | grade |
| --- | --- | --- |
| 101 | 82 | B |
| 102 | 49 | F |
| 103 | 74 | C |
| 104 | 91 | A |
| 105 | 63 | D |
| 106 | 55 | D |
| 107 | 100 | A |
| 108 | 38 | F |

Statistics: high 100, low 38, average 552/8 = **69.0**, pass (≥50) 6/8.

Malformed test: append line `109 abc` → load reports `skipped record: roll 109 (bad score)`, statistics unchanged (still 8 records).

**Student tasks.**
1. Both contracts as comments; the read loop with in-loop validation (the skip policy from Lab 2).
2. Statistics in one pass; the grade bridge reused, not reinvented.
3. Reflection: two files, two roles — *input* (read-only contract, never written) vs *output* (regenerated, truncate-by-design). Write the two one-line contracts side by side and note how the modes express them.

**Solution (core).**

```cpp
int n = 0;
while (n < CAP && in >> roll >> score) {
    if (score < 0 || score > 100) { std::cout << "skipped: " << roll << '\n'; continue; }
    roster[n].roll = roll;  roster[n].score = score;  n += 1;
}
int total = 0, high = -1, low = 101, pass = 0;
for (int i = 0; i < n; i = i + 1) {
    total += roster[i].score;
    if (roster[i].score > high) high = roster[i].score;
    if (roster[i].score < low)  low  = roster[i].score;
    if (roster[i].score >= 50)  pass += 1;
    out << roster[i].roll << ' ' << roster[i].score << ' '
        << gradeText(letterOf(roster[i].score)) << '\n';
}
out << "average " << (n ? 1.0 * total / n : 0.0) << " high " << high
    << " low " << low << " pass " << pass << "/" << n << '\n';
```

**Explanation.** Formatted reading shines here: `while (in >> roll >> score)` reads every line with zero ceremony because *no field has spaces* — the format was designed for the reader. The validation-at-the-boundary (skip `abc`) is the stream-state lesson applied: after a failed `>>`, the loop condition ends it — so *detect* the bad record by reading the roll, then checking the score read (try `if (!(in >> score)) { report; break; }` as the sharper version). Average check: 82+49+74+91+63+55+100+38 = 552; 552/8 = 69.0 ✓.

**⭐ Extensions.** ⭐ Name column (amend the input format to `roll;name;score` — semicolon CSV, the splitter returns). ⭐⭐ A grade-histogram file section (count per letter — the enum tally).

---

## Lab 5 — Contact List

**Scenario.** A personal address book: names and phone numbers, searched and appended — line-based reading with a *lookup* purpose. The lab where you feel why the format is lines.

**Format contract.**

```text
// contacts.txt — one contact per line:
//   <full name>;<phone>
// ';' separator: names contain spaces and commas; phones contain only digits/+
```

**Requirements.**
R1. Load all contacts (clamped) into a record array (`Contact { std::string name; std::string phone; }` — *both* fields are strings; the phone is text, not a number — state why in the contract: leading zeros and `+`).
R2. Menu: 1-add (append) · 2-list · 3-search by name (case-insensitive **substring**, all matches) · 4-find exact (first match only) · 5-quit (auto-save as a *rewrite* — sorted by name).
R3. Search uses the [Unit 11](../strings/index.md) normalize-then-search: lowercase copies on both sides.
R4. Quit's rewrite is sorted — the [selection sort](../records/challenges.md#c2) over records by name — and prints how many were written.

**Test data & expected results.**

Start file:
```text
Ayesha Khan;+92 300 1234567
Ali Raza;0321-9876543
Sana Mir;+92 333 5551212
Umar Farooq;0300-1112223
```

| Action | Expected |
| --- | --- |
| search `an` | Ayesha Kh**an**; Sana Mir? — no: "Sana" contains *an*? s-a-n-a → yes at index 1. Matches: Ayesha Khan, Sana Mir (2) |
| search `ALI` (uppercase) | Ali Raza (case-insensitive) |
| find exact `Ali Raza` | 1 match, `0321-9876543` |
| find exact `ali raza` | **0 matches** — exact mode is case-sensitive by design (documented heuristic from [Strings Lab 5](../strings/labs.md#lab-5--the-simple-search-tool)) |
| add `Zainab Ahmed;0333-7778888`, quit | rewrite sorted: Ali Raza, Ayesha Khan, Sana Mir, Umar Farooq, Zainab Ahmed |

**Student tasks.**
1. Contract first — including the phone-as-text sentence.
2. The two search modes sharing one traversal (flag for case sensitivity), reporting line numbers.
3. Reflection: this program *rewrites on quit* (sorted) — unlike Lab 2's append-only ledger. Same data, opposite file strategies: what property of the data decides (mutability — contacts change; history doesn't)?

**Solution (core).**

```cpp
int searchContacts(const Contact list[], int n, const std::string& needle,
                   bool exact, int hits[], int maxHits) {
    std::string needleLower = toLower(needle);
    int found = 0;
    for (int i = 0; i < n && found < maxHits; i = i + 1) {
        if (exact) { if (list[i].name == needle) hits[found++] = i; }
        else {
            std::string hay = toLower(list[i].name);
            if (hay.find(needleLower) != std::string::npos) hits[found++] = i;
        }
    }
    return found;
}
```

**Explanation.** Everything here is a rerun of earlier modules wearing a file: the splitter (Lab 2), the normalize-then-compare search ([Strings D2](../strings/debugging.md#d2--never-equal-no-matter-what-you-type-compare)), the record sort ([C2 of records](../records/challenges.md#c2)) — composed around one contract. The search test table's trick row is the uppercase `ALI` — it *proves* the normalization; and the `ali raza` exact-mode row proves the documented heuristic's asymmetry. Phone-as-text: `0321-9876543` as an int is 3219876543 (leading zero gone) — the contract sentence exists because the data forced it.

**⭐ Extensions.** ⭐ Email field (three fields per line). ⭐⭐⭐ Dedup on rewrite: contacts with identical names AND phones collapse to one — report how many were merged ([C6's](challenges.md#c6) duplicate discipline).

---

## Lab 6 — Simple Transaction Log

**Scenario.** An audit trail for any of the previous labs: every notable event appended, timestamped, never edited. The lab where **append mode + durability** are the entire design, and the log becomes evidence.

**Format contract.**

```text
// audit.log — append-only, never rewritten, never sorted:
//   <sequence-number>;<event>;<detail>
// sequence number: 1, 2, 3... — assigned by the program at write time
// (the log is evidence: no rewrite path exists in this program at all)
```

**Requirements.**
R1. `logEvent(event, detail)` — append, check, write, close **per event**; the sequence number = count of existing lines + 1 (read the log's line count first — or maintain a counter file? Decide, document).
R2. `readLog()` — prints all entries, numbered, plus a count; malformed lines reported (evidence is never silently skipped — print them marked `[malformed]`).
R3. `findEvents(event)` — all entries of one event type (e.g. every `DISCHARGE`).
R4. The program offers **no** edit/delete/rewrite operations — write the design-memo sentence explaining why (an audit log that can be edited proves nothing).

**Test data & expected results.**

| Sequence of calls | audit.log after |
| --- | --- |
| logEvent("ADMIT", "roll 101 Ayesha") | `1;ADMIT;roll 101 Ayesha` |
| logEvent("MARKS", "roll 101 quiz1 8") | + `2;MARKS;roll 101 quiz1 8` |
| program restarted, logEvent("ADMIT", "roll 102 Ali") | + `3;ADMIT;roll 102 Ali` — sequence survived the restart |
| findEvents("ADMIT") | lines 1 and 3 |

Malformed test: hand-insert `garbage` mid-file → readLog prints `4:[malformed] garbage` and continues numbering honestly; findEvents counts only well-formed matches.

**Student tasks.**
1. The sequence-number decision: count-lines-first (recount on every write — simple, robust, O(n) per event) vs a counter file (O(1) but a *second* file to keep consistent). Pick one and write the sentence.
2. Per-event open/close — and the reflection: measure the trade (five logEvents = five opens) against the durability guarantee. When would you batch instead?
3. Reflection: this file is the one format in the course with **no rewrite, no sort, no dedup**. What do the other labs' files assume that this one refuses? (Mutability. An audit log's value *is* its immutability.)

**Solution (core).**

```cpp
void logEvent(const char* filename, const std::string& event, const std::string& detail) {
    std::ifstream in(filename);                    // recount: robust across restarts
    int seq = 1;
    if (in.is_open()) {
        std::string line;
        while (std::getline(in, line)) seq += 1;
        in.close();
    }
    std::ofstream out(filename, std::ios::app);
    if (!out.is_open()) { std::cout << "log unavailable\n"; return; }
    out << seq << ';' << event << ';' << detail << '\n';
    out.close();                                   // durability per event
}
```

**Explanation.** The recount strategy (chosen above) survives crashes, hand-edits, and restarts because it never *trusts memory* — the file is the truth. The counter-file alternative is faster but creates two files whose agreement is another contract to maintain ([D9's](debugging.md#d9) drift, invited). Per-event close is the [D10](debugging.md#d10) fix made policy; the malformed-line policy (marked, never skipped) is evidence discipline. This lab is small — five lines of writing — but it's the first file whose *design philosophy* (immutable, append-only, self-numbering) does the work.

**⭐ Extensions.** ⭐ Datestamps: prepend `yyyy-mm-dd` from the user (a Date record's text form). ⭐⭐⭐ Log rotation: when the log exceeds 100 lines, rename it `audit-1.log` and start fresh ([C9's](challenges.md#c9) backup order — copy, then continue).

---

# Lab index

| Lab | File role | The pattern it drills |
| --- | --- | --- |
| 1 | Student record file | count-first round trip; the contract as artifact |
| 2 | Expense tracker | append-only + separator choice + malformed-line policy |
| 3 | Inventory file | mixed-strategy records; derived state kept out of the file |
| 4 | Marks report | formatted reading at scale; input vs output file contracts |
| 5 | Contact list | line-based search; rewrite-on-mutability |
| 6 | Transaction log | immutability as design; per-event durability |

**After the labs:** [The File-Based Student Management System](miniproject.md) — the capstone that makes one format contract carry a whole program.
