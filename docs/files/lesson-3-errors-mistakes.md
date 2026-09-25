---
title: "Lesson 3 — File Errors and the Mistakes Gallery"
description: "Basic file errors, EOF and the stream state, the ten common file handling mistakes, and a complete record-processing program."
---

# Lesson 3 — File Errors and the Mistakes Gallery

> [← Module home](index.md) · [← Lesson 2 — Reading strategies and file formats](lesson-2-reading-writing.md) · [Exercises →](exercises.md)

## In this lesson you will learn

- the **basic file errors** — what goes wrong at open and at read, and how each announces itself
- **EOF and the stream state** — the three flags, and why "read past the end" must be *detected*, not predicted
- the **common file handling mistakes** gallery — ten bugs, each with a one-line prevention rule
- a complete record-processing program — the pattern to copy for every lab

---

<a name="1-basic-file-errors--what-can-go-wrong"></a>
## 1. Basic file errors — what can go wrong

File errors come in two families: **open failures** and **read/write failures**.

**Open failures.** An `ifstream` fails to open when: the file doesn't exist (typo, wrong folder, not created yet), you lack permission, or the path is a directory. An `ofstream` rarely fails — it *creates* missing files — but fails on permission (read-only folder) or an invalid path (`"no/such/folder/out.txt"`). The response is always the same, per [Module rule 1](index.md#safety-rules-for-this-unit): check, then decide —

```cpp
std::ifstream in("grades.txt");
if (!in.is_open()) {
    std::cout << "cannot open grades.txt - does it exist? is the path right?\n";
    return 1;                     // or return 0 for the "missing = empty" contract
}
```

**Read failures.** After a successful open, reads fail when the data runs out (**EOF** — normal) or the data is malformed (expecting a number, meeting `"abc"` — the [stoi/validation](../strings/index.md) story, now on a stream: the stream enters fail state, subsequent reads do nothing). The check you already know covers all of it: a stream in any failure state converts to false, and `>>`/`getline` in a condition stop the loop.

**The path mystery** deserves its own warning: file paths resolve against the **working directory** — where the program was *launched*, not where the source lives. IDEs vary. When a file "isn't found" but you can see it right there: print the working directory or use a full path once to diagnose, then go back to filenames + known working directory. Every "file not found" bug in this unit's [debugging page](debugging.md) is fair game for this explanation.

<a name="2-eof-and-the-stream-state"></a>
## 2. EOF and the stream state

Every stream carries a small state machine with three flags worth knowing:

| Flag | Set when | Meaning |
| --- | --- | --- |
| `eofbit` | a read **attempted past** the last byte | the end was reached — by attempting |
| `failbit` | a read failed logically (wrong type, no data) | the *operation* failed |
| `badbit` | a serious I/O error (rare in course work) | the stream is broken |

The subtlety that creates the [eof-trap](lesson-1-streams.md#5-reading-until-the-data-runs-out): **`eofbit` is set only *after* a read attempts to read past the end — not when the last byte is merely sitting there.** That's why `while (!in.eof())` loops one time too many: on the final pass, nothing has *attempted* past-the-end yet, so the flag is still false, the body runs, and the read inside fails — leaving stale/empty data that gets processed as if real.

The correct idiom puts the read in the condition, where the *result* of the read — not a prediction about the future — decides the loop:

```cpp
while (std::getline(in, line)) { ... }     // loop runs exactly once per successful read
while (in >> x >> y)           { ... }     // ditto, formatted
```

When the last record is consumed, the *next* read attempts past the end, fails, converts to false, and the loop ends **without processing anything fake**. And the "empty last line" nuance: a file ending `...\n` has *no* extra empty line for getline to return — but a file ending `...\n\n` genuinely has one. Data is data; the idiom reads what is there, no more, no less.

<a name="3-the-common-mistakes-gallery"></a>
## 3. The common mistakes gallery

**M1 — No open check.** Reading a missing file "works" — produces nothing. `if (!in.is_open())` first, always. *Prevention: the four-word discipline — open, check, use, close.*

**M2 — The eof() loop.** `while (!f.eof())` processes one phantom record. *Prevention: the read goes in the condition — always.*

**M3 — Forgetting append mode.** `ofstream` on a log file erases every past entry. *Prevention: logs/ledgers open with `std::ios::app` — say what your open means.*

**M4 — The missing ignore.** `>>` then `getline` on one stream — the name comes up empty. *Prevention: `ignore(1000, '\n')` after every `>>` that precedes a getline.*

**M5 — Filename typo / wrong directory.** The file exists; the program disagrees about where. *Prevention: verify the working directory once; keep data files beside the executable during the course.*

**M6 — Trusting the file's count.** Loading with the count-first header and no capacity clamp — a corrupted count (say 99999) overflows the array. *Prevention: clamp to capacity — trust data, including your own files, only up to the guard.*

**M7 — Reading a numeric field that isn't one.** `"abc"` into an `int` — failbit, silent zeros downstream. *Prevention: validate at the boundary (read the field as text, check, then convert — the [Unit 11](../strings/index.md) gate, stream edition).*

**M8 — Writing without a separator.** `out << name << score;` produces `Ayesha Khan92` — the format contract broken by the writer. *Prevention: every field write ends with its separator — `'\n'` or `','` or `' '` — visibly.*

**M9 — Forgetting to close / relying on close for the data.** Output buffering means a crash (or a missing close + exotic exit) loses buffered tail data. *Prevention: close at the end of the work; for a long-running program writing critical records, close (or flush) after each record.*

**M10 — The one-direction contract drift.** The writer adds a field; the reader doesn't know; loads silently misalign. *Prevention: the format is a *contract* — document it in a comment next to both the save and load functions, and change both ends in the same edit.*

## 4. A complete record-processing program

Every piece, one program — the pattern the labs copy:

```cpp
// 06_marks_file.cpp — Unit 12 · Session 12.2 — load, report, append-log
// Compile: g++ -std=c++17 -Wall -Wextra 06_marks_file.cpp -o marks_file
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>

struct Student { std::string name; int score; };

int loadRoster(Student roster[], int cap, const char* filename) {
    std::ifstream in(filename);
    if (!in.is_open()) return 0;                 // missing = empty, by contract (M6's clamp below)
    int n = 0;
    in >> n;
    in.ignore(1000, '\n');                       // M4 pre-empted
    if (n > cap) n = cap;                        // M6 pre-empted
    for (int i = 0; i < n; i = i + 1) {
        std::getline(in, roster[i].name);
        in >> roster[i].score;
        in.ignore(1000, '\n');
    }
    return n;
}

void printReport(const Student roster[], int n) { // pure console pass — no file work
    std::cout << "--- ROSTER REPORT ---\n";
    for (int i = 0; i < n; i = i + 1)
        std::cout << std::setw(3) << i + 1 << " | "
                  << std::setw(20) << std::left << roster[i].name << " | "
                  << std::setw(3) << std::right << roster[i].score << '\n';
}

void logReport(const Student roster[], int n, const char* logfile) {
    std::ofstream log(logfile, std::ios::app);   // M3 pre-empted: append, never erase
    if (!log.is_open()) { std::cout << "cannot open log\n"; return; }
    int total = 0;
    for (int i = 0; i < n; i = i + 1) total += roster[i].score;
    log << "report: " << n << " students"
        << (n > 0 ? ", avg " : "")
        << (n > 0 ? (1.0 * total / n) : 0.0) << '\n';
    log.close();
}

int main() {
    Student roster[100];
    int n = loadRoster(roster, 100, "roster.txt");
    printReport(roster, n);
    logReport(roster, n, "report.log");
    return 0;
}
```

The shape to remember: **load into records → process in memory → write back / log out**. Files at the edges, logic in the middle — the architecture every lab and the [mini-project](miniproject.md) follow, and the reason the file format can change without touching the logic.

## Practice

- [Exercises 15–18](exercises.md) — errors, EOF discipline, the full round trip
- [Debugging D1–D10](debugging.md) — every gallery mistake, seeded and findable
- [Lab 6 — Transaction Log](labs.md#lab-6--simple-transaction-log) — append mode as a way of life

## Key takeaways

- **Open failures** (missing/permission/path) demand the `is_open()` check; **read failures** (EOF, malformed data) drive the stream-to-bool loop conditions
- **EOF is detected, not predicted** — `eofbit` sets only after an attempted past-the-end read; the read-in-condition idiom makes the trap impossible
- The gallery's big four: **no open check**, the **eof() loop**, **missing append mode**, the **missing ignore** — each has a one-line prevention rule
- The format is a **contract**: document it at both ends, clamp counts, validate fields, end every write with its separator
- Architecture: **load → process in memory → write/log** — files at the edges
