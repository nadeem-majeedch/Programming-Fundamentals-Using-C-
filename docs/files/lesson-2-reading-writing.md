---
title: "Lesson 2 — Reading Strategies and File Formats"
description: "Open modes and append, line-based vs formatted reading, mixing >> with getline, CSV-style data, and the record-storage round trip."
---

# Lesson 2 — Reading Strategies and File Formats

> [← Module home](index.md) · [← Lesson 1 — Streams](lesson-1-streams.md) · [Lesson 3 — File errors and the mistakes gallery →](lesson-3-errors-mistakes.md)

## In this lesson you will learn

- **open modes** as a contract — and **append mode**, the way to add without erasing
- **line-based reading** (whole lines) versus **formatted reading** (`>>` field by field) — and which a format demands
- mixing `>>` and `getline` on one stream — the file-shaped [mixing trap](../cpp-io/lesson-3-getline.md) and its one-line cure
- **CSV-style text data** — reading and writing comma-separated records
- **simple record storage** — saving an array of records and loading it back, the round trip that powers every lab

---

<a name="1-modes--and-append-the-file-open-contract"></a>
## 1. Modes — and append, the file-open contract

Lesson 1's truth bears repeating with its cure: opening an `ofstream` on an existing file **erases it**. The open mode is where you declare your intent, and there are three honest intents:

| Intent | How | Effect on existing data |
| --- | --- | --- |
| Fresh start (replace) | `ofstream out(name);` | **erased**, then written |
| Add to the end | `ofstream out(name, std::ios::app);` | **kept**; writes always land at the end |
| Read | `ifstream in(name);` | never written, never erased |

```cpp
std::ofstream logFile("ledger.txt", std::ios::app);   // append: existing lines survive
logFile << "2026-09-23 lunch -450\n";
logFile.close();
```

Append is *the* mode for logs and ledgers — programs that accumulate history. Two properties make it safe: existing content survives, and every write goes to the **current end** even if the file grew since opening. Run an append program twice and the file holds both runs — that's the point. ([D3](debugging.md#d3) is the bug you get by forgetting the flag.)

And `fstream` — the both-directions type — takes its modes explicitly:

```cpp
std::fstream file("data.txt", std::ios::in | std::ios::out);   // read + write
```

Course guidance: prefer the specialised types (`ofstream`/`ifstream`) when a task is one-directional — the type *documents* the intent. Reach for `fstream` when you genuinely rewrite a file in place (read, decide, rewrite — [C3](challenges.md#c3)).

**The open-check rule applies in every mode** — `is_open()` after every open, including appends and fstreams.

---

<a name="2-two-reading-strategies--match-the-format"></a>
## 2. Two reading strategies — match the format

Every text file asks one design question first: **what does one unit of data look like?**

**Line-based** — one unit per *line*, possibly containing spaces. Reading unit = `getline`:

```cpp
// file: invitations.txt — one full sentence per line
std::string line;
while (std::getline(in, line))
    std::cout << "[" << line << "]\n";
```

Lines preserve spaces, tabs, everything — what you wrote is what you got. This is the right strategy when a record *is* a line of text (names, addresses, log entries).

**Formatted** — a record is a *sequence of fields*, read with `>>` one at a time:

```cpp
// file: points.txt — each line: x y
double x, y;
while (in >> x >> y)                     // >> skips whitespace AND newlines
    std::cout << '(' << x << ", " << y << ")\n";
```

Key fact: `>>` skips **all** whitespace including newlines, so `in >> x >> y` doesn't care whether the file is `3 4\n5 6` or `3 4 5 6` — it reads the next two numbers wherever they are. Convenient — and it means the *format* lives in the data's order, not its layout. (That loop's condition is the same stream-as-bool idiom as getline: `>>` fails at EOF and stops the loop. Never wrap it in `!in.eof()`.)

| Strategy | Reads | Best for |
| --- | --- | --- |
| Line-based (`getline`) | one line, spaces included | names, sentences, log lines — anything with spaces |
| Formatted (`>>`) | whitespace-delimited fields | numbers, single words, fixed field sequences |

**The decisive rule: if a field can contain spaces, the format must be line-based for that field** — because `>>` stops at the first space, silently truncating `"Ayesha Khan"` to `"Ayesha"` ([D4](debugging.md#d4) is exactly this bug in a marks file).

---

## 3. Mixing `>>` and `getline` — the file-shaped mixing trap

The moment one record has *both* kinds of fields — numbers, then a line with spaces — the [mixing trap](../cpp-io/lesson-3-getline.md) from Unit 03 reappears:

```cpp
// file: roster.txt — each record: score on one line, full name on the next
int score;
std::string name;
in >> score;                 // reads 92, LEAVES the newline
std::getline(in, name);      // reads the LEFTOVER NEWLINE -> name is ""
```

Identical mechanism to the keyboard version — `>>` leaves the newline, `getline` happily consumes it as an empty line — and the identical cure: **`in.ignore(1000, '\n')` between the `>>` and the getline**:

```cpp
while (in >> score) {
    in.ignore(1000, '\n');           // consume the newline >> left behind
    std::getline(in, name);          // now reads the real name line
    std::cout << name << " scored " << score << '\n';
}
```

Trace it on a two-record file: `92\nAyesha Khan\n78\nAli Raza\n` — read 92, ignore to newline, getline `Ayesha Khan`; read 78, ignore, getline `Ali Raza`; next `>>` fails at EOF, loop ends. Clean. The loop *condition* (`in >> score`) is again the EOF-safe shape — the name read happens inside the body only when a score was actually read.

---

## 4. CSV-style text data

**CSV** (comma-separated values) packs a whole record onto **one line**, fields separated by commas:

```text
students.csv
-------------
Ayesha Khan,92,BSCS
Ali Raza,78,BSIT
Sana Mir,85,BSDS
```

CSV is the lingua franca of data exchange — spreadsheets open it, databases export it, every lab this unit uses it. Writing it is trivial (beware the *header* question — decide whether row 1 is column names, and be consistent):

```cpp
std::ofstream out("students.csv");
out << "name,score,programme\n";                      // the header — or none; decide ONCE
for (int i = 0; i < n; i = i + 1)
    out << roster[i].name << ',' << roster[i].score << ',' << roster[i].programme << '\n';
```

Reading it uses Lesson 2's strategies composed: **getline for the record, split for the fields** — the [field splitter](../strings/challenges.md#c7) from the Strings module earns its keep:

```cpp
std::string line;
std::getline(in, line);                 // skip the header (if you wrote one!)
while (std::getline(in, line)) {
    std::size_t p1 = line.find(',');
    std::size_t p2 = line.find(',', p1 + 1);
    std::string name = line.substr(0, p1);
    int score = std::stoi(line.substr(p1 + 1, p2 - p1 - 1));
    std::string prog = line.substr(p2 + 1);
    std::cout << name << " -> " << score << " (" << prog << ")\n";
}
```

`find` + `substr` walk the commas; `stoi` converts the numeric field ([Unit 11's conversion rules](../strings/index.md)). Two CSV honesty notes, full coverage in [C7](challenges.md#c7): real-world CSV can *quote* fields containing commas (the format's famous wart — our course files simply forbid commas inside fields, a documented constraint), and every `find` result should be checked against `npos` before slicing in production code.

---

## 5. Simple record storage — the round trip

Now assemble everything. The [Records module](../records/index.md) defined records as *one value with fields*. Persisting them = choosing a text format for the schema and writing both halves of the round trip.

**The format** (a *line-based schema* — name may contain spaces, so it gets its own line):

```text
roster.txt — each record is 2 lines:
<full name>
<score>
```

**Writing** an array of records, one field per line:

```cpp
void saveRoster(const Student roster[], int n, const std::string& filename) {
    std::ofstream out(filename.c_str());            // see the note below on c_str()
    if (!out.is_open()) { std::cout << "cannot write " << filename << "\n"; return; }
    out << n << '\n';                               // the count line first!
    for (int i = 0; i < n; i = i + 1) {
        out << roster[i].name << '\n' << roster[i].score << '\n';
    }
}
```

**Loading** — read the count, then loop exactly that many times:

```cpp
int loadRoster(Student roster[], int cap, const std::string& filename) {
    std::ifstream in(filename.c_str());
    if (!in.is_open()) return 0;                    // no file yet = empty roster, by contract
    int n = 0;
    in >> n;                                        // the count line
    in.ignore(1000, '\n');                          // the mixing trap, pre-empted
    if (n > cap) n = cap;                           // capacity guard — trust nothing
    for (int i = 0; i < n; i = i + 1) {
        std::getline(in, roster[i].name);
        in >> roster[i].score;
        in.ignore(1000, '\n');                      // before the NEXT getline
    }
    return n;
}
```

Three ideas here are the whole record-storage discipline:

1. **The count-first header** — the file *starts* with how many records follow. The loader trusts it (clamped to capacity). Alternative designs exist (read until EOF — [C2](challenges.md#c2)); count-first is the course standard because it validates instantly.
2. **The ignore rhythm** — every `>>` that precedes a getline gets `ignore(1000, '\n')`. In this function that's *twice* (after the count, after each score). Miss one and the first/next name is empty — [D2](debugging.md#d2) seeds exactly this.
3. **The missing-file contract** — "no file yet" loads as an *empty roster*, not an error: the first run of any persistent program finds nothing. Choose this per program and *write it down* — a missing file is an error for a report, normal for a fresh start.

(A note on `filename.c_str()`: older C++ streams opened from `const char*`; `std::string` filenames open directly in modern compilers. The course passes `.c_str()` for portability with older toolchains — harmless everywhere.)

**The round trip test** — the deliverable in every lab: save, load, print, compare. What you saved is what you loaded, or the format has a bug. [Lab 1](labs.md#lab-1--student-record-file) runs it on students; the [mini-project](miniproject.md) makes it the backbone of the whole system.

---

## Practice

- [Exercises 8–14](exercises.md) — modes, formatted records, CSV, the storage round trip
- [Lab 1](labs.md#lab-1--student-record-file) and [Lab 2 — Expense Tracker](labs.md#lab-2--expense-tracker)

## Key takeaways

- **Modes are the open contract**: plain ofstream erases; `std::ios::app` appends; the open check applies in every mode
- Match the strategy to the format: **line-based** (`getline`) for units containing spaces; **formatted** (`>>`) for whitespace-delimited field sequences — spaces in a field force line-based
- `>>`-then-`getline` on the same stream needs **`ignore(1000, '\n')`** between them — every time
- **CSV** = one record per line, fields comma-separated; read with getline + find/substr + stoi; course files forbid commas inside fields
- Record storage = a **line-based schema** + the count-first header + the ignore rhythm + a written missing-file contract — and the save/load/print **round trip** proves it
