---
title: "Files Exercises"
description: "18 progressive exercises — streams and open checks, reading strategies, CSV, record storage. Solutions separated at the end."
---

# Files Exercises (18)

> [← Module home](index.md) · ★ = first pass · ★★ = needs the toolkit · ★★★ = combines ideas

**How to use this page.** Attempt 15 minutes before opening any [solution](#solutions-s1--s18). The file habit: **write the file's first two lines by hand** before writing code — the format is the contract. Exercises marked ✍ create files: inspect the produced file in an editor afterward, every time.

---

## Part A — Streams, open, close (★, E1–E7)

**E1.** Write the three-line "hello file": create `hello.txt` containing your name and today's date (as text). ✍ Then open it in an editor and confirm. What are the two failure modes of this program (one at open, one you avoid by closing)?

**E2.** The missing-file experiment: write a program that *reads* `does-not-exist.txt` (a) without the open check (b) with it. Describe both behaviours — what prints, what doesn't — and state which failure mode is more dangerous in a real program, and why.

**E3.** The erasure experiment, done deliberately: (a) write `notes.txt` with two lines. (b) Open it again with a plain `ofstream` and write one new line. ✍ (c) Inspect. What happened to the two original lines? Then repeat step (b) with `std::ios::app` and inspect again. State the mode contract in one sentence each.

**E4.** The numbered-copy: read any text file line by line and write a copy with line numbers (`1: ...`). Both files stream through your program at once — one `ifstream`, one `ofstream`, open checks on both. ✍ Test with a 3-line file and an *empty* file (0 lines out — why?).

**E5.** The stream-as-condition drill: without running it, state how many loop iterations each runs for a file containing exactly `10\n20\n30\n` and why:
(a) `while (in >> x)` (b) `while (!in.eof()) { in >> x; ... }` (c) `while (in >> x, !in.eof())` — the comma operator one is the *worst* of the three; say what it loses.

**E6.** A program must add a timestamped line to `events.log` each run. Write it (timestamp = a fixed string like `"2026-09-23 T3"` is fine). ✍ Run it three times, inspect, and confirm all three lines. Which mode flag made this work?

**E7.** Explain, in two sentences each, what `.close()` does and why the course closes explicitly even though streams auto-close on scope exit. Then: why would a long-running program that writes one critical record per transaction close (or flush) more often?

---

## Part B — Reading strategies and formats (★★, E8–E13)

**E8.** Line vs formatted: given `data1.txt` = `Ali\nAyesha Khan\nSana\n` — which strategy reads these three *names* correctly, `>>` or getline, and what exactly does `>>` produce instead? (This is [D4's](debugging.md#d4) seed — state the rule that decides.)

**E9.** Formatted records: `points.txt` contains `3 4\n5 6\n7 8\n`. Write the loop that reads and prints each pair as `(3, 4)` — and then explain why the same loop reads `3 4 5 6 7 8` (one line) *identically*. What does that imply about `>>`-formats and "lines"?

**E10.** The mixing fix: `input.txt` is `92\nAyesha Khan\n78\nAli Raza\n` (score, then full name, per record). Write the read loop with the ignore rhythm, printing `Ayesha Khan scored 92`. Then delete the ignore — one word changes; state the new (broken) output precisely.

**E11.** CSV writing and reading: write `students.csv` with a header `name,score,programme` and three records; then write the reader that skips the header and prints each record's fields on one line. ✍ Inspect the file: exactly where are the commas? What decides "is line 1 data?" — and why must writer and reader *agree*?

**E12.** CSV split, by hand: given the line `"Sana Mir,85,BSDS"`, trace the find/substr calls that extract the three fields — write each intermediate value (`p1`, `p2`, each substr argument and result). Then: what breaks if a field contains a comma, and what is this course's documented answer?

**E13.** The count-first header: write `saveItems`/`loadItems` for `struct Item { std::string name; int qty; };` with the count-first format. Include: the capacity clamp, the ignore rhythm (where does it appear *twice*?), and the missing-file contract for the loader. ✍ Round-trip a 3-item array.

---

## Part C — Errors, records, integration (★★–★★★, E14–E18)

**E14.** The gallery drill: for each, name the mistake (M1–M10) and its one-line prevention:
(a) a log file that's empty after the second run (b) a report whose last record prints twice (c) `"Ayesha Khan"` loaded as `"Ayesha"` with score 0 (d) a corrupted count of 99999 overflowing the roster array.

**E15.** The state-flag drill: after each sequence, state which flags are set (`eof`/`fail`/neither) and what one more `in >> x` would do:
(a) file `10\n20\n`, read 10 then 20 (b) file `10\nabc\n`, read 10 then attempt 20 from `abc` (c) an empty file, one `>>` attempt.

**E16.** Write `bool fileExists(const char* filename)` using only what the course teaches (open + check + close — no filesystem library). What are its two *false* verdicts — when does it say "yes" for something unusable, or "no" for something you can create?

**E17.** The tail reader: print the **last** 3 lines of a file. (You can't seek backwards with course tools — so: read *all* lines into an array of strings — capacity-guarded — then print the last three. Or the clever version: a 3-line rolling buffer. Attempt both.) ✍

**E18.** Capstone drill: a program that (a) appends one expense to `expenses.txt` in the format `description;amount` (semicolon-separated — why semicolon and not comma here?), (b) then loads the whole file and prints all expenses with a running total. Open checks everywhere, format documented in comments at both ends. ✍ This is [Lab 2's](labs.md#lab-2--expense-tracker) seed — do it small here.

---

<a name="solutions-s1--s18"></a>
# Solutions (S1–S18)

<a name="s1"></a>
## S1 — Hello file

```cpp
std::ofstream out("hello.txt");
if (!out.is_open()) { std::cout << "open failed\n"; return 1; }
out << "Ayesha Khan\n2026-09-23\n";
out.close();
```
Failure modes: open can fail (permissions/path — caught by the check); and without `close()` the buffered tail could be lost on an abnormal exit — close flushes. (On normal exits the destructor flushes; the habit exists for the abnormal ones and for clarity.)

<a name="s2"></a>
## S2 — The missing-file experiment

(a) Without the check: no crash, **no output, no error** — every read silently fails; an "empty report" bug that's actually a never-opened file. (b) With it: your message prints and the program exits gracefully. The checked version is safer *because the silence is broken* — silent wrongness beats loud failure only at sounding louder, and here loud is what you want.

<a name="s3"></a>
## S3 — The erasure experiment

(a) two lines. (b→c) after the plain ofstream open: **both original lines gone** — one new line remains (the truncate default). With `std::ios::app`: three lines — the new one appended. Contract: plain ofstream = *replace* (fresh start); `app` = *add to the end* (history survives).

<a name="s4"></a>
## S4 — Numbered copy

```cpp
std::ifstream in("in.txt");
std::ofstream out("out.txt");
if (!in.is_open() || !out.is_open()) { std::cout << "open failed\n"; return 1; }
std::string line;  int n = 1;
while (std::getline(in, line)) out << n++ << ": " << line << '\n';
```
Empty file → zero iterations → `out.txt` exists and is empty: correct, since "0 lines" is the honest copy. (`n++` post-increment: prints 1 first, then increments.)

<a name="s5"></a>
## S5 — Stream-as-condition drill

File `10\n20\n30\n`: (a) **3** iterations — `>>` succeeds on 10, 20, 30, fails on the 4th attempt. (b) **4** bodies run — after reading 30, `eof()` is still false (no *attempt* past the end yet), so a 4th body runs, `in >> x` fails, and the stale x (= 30) gets processed again: the phantom record. (c) the comma version reads *then* checks eof — it also processes the stale value on the last pass, **and** it can drop a record whose read succeeds but lands exactly at EOF (eof set, body skipped even though x was just read). The read-in-condition idiom (a) is the only one that processes exactly the data that exists.

<a name="s6"></a>
## S6 — The event log

```cpp
std::ofstream log("events.log", std::ios::app);
if (!log.is_open()) { std::cout << "open failed\n"; return 1; }
log << "2026-09-23 T3 session started\n";
log.close();
```
`std::ios::app` — each run's write lands at the (growing) end; nothing is erased.

<a name="s7"></a>
## S7 — close()

`close()` disconnects the stream and **flushes** the buffer — file streams collect characters in memory and write to disk in batches; close pushes the remainder. The course closes explicitly because (1) it states "the file is complete" at a readable point in the code, (2) it protects buffered tail data against abnormal exits, and (3) it releases the file for other programs. A long-running transactional program closes (or flushes) per record because a crash must not lose *already-confirmed* data.

<a name="s8"></a>
## S8 — Line vs formatted

`>>` reads `"Ali"`, `"Ayesha"`, `"Sana"` — it stops at the first space, so `"Ayesha Khan"` truncates and the word `Khan` is then read as the *next* name (or worse, mismatches the next field). getline reads each full line — correct. The rule: **a field that can contain spaces forces line-based reading** ([Lesson 2 §2](lesson-2-reading-writing.md#2-two-reading-strategies--match-the-format)).

<a name="s9"></a>
## S9 — Formatted records

```cpp
double x, y;
while (in >> x >> y) std::cout << '(' << x << ", " << y << ")\n";
```
Identical on both files because `>>` skips **all** whitespace — newlines are just whitespace to it. Implication: `>>`-formats live in the *sequence* of values, not in line layout — you can't rely on line breaks to delimit records unless the format says so explicitly (which is exactly why line-based formats exist).

<a name="s10"></a>
## S10 — The mixing fix

```cpp
int score;  std::string name;
while (in >> score) {
    in.ignore(1000, '\n');
    std::getline(in, name);
    std::cout << name << " scored " << score << '\n';
}
```
Without the ignore: `score=92` reads, then getline consumes the leftover newline → `name = ""` → prints `" scored 92"`; the *real* name line `Ayesha Khan` becomes the next `>>` target... which fails (not a number), ending the loop early. One missing word = half the file silently lost.

<a name="s11"></a>
## S11 — CSV round trip

```cpp
std::ofstream out("students.csv");
out << "name,score,programme\n";
out << "Ayesha Khan,92,BSCS\n" << "Ali Raza,78,BSIT\n" << "Sana Mir,85,BSDS\n";
out.close();

std::ifstream in("students.csv");
std::string line;
std::getline(in, line);                    // skip the header — by agreement
while (std::getline(in, line)) std::cout << line << '\n';   // (parsing in E12)
```
Commas sit *exactly* between fields — the writer's separators are the reader's delimiters. "Is line 1 data?" is decided by **convention** (header or not) that both ends must honour; nothing in the file format marks a header. That's why the agreement is documentation, not accident.

<a name="s12"></a>
## S12 — CSV split, by hand

Line = `Sana Mir,85,BSDS`:
- `p1 = line.find(',')` → **9** (after `Sana Mir`)
- `p2 = line.find(',', 10)` → **12**
- `name = line.substr(0, 9)` → `"Sana Mir"`
- `score = stoi(line.substr(10, 12 - 10 - 1))` → `stoi("85")` → **85**
- `prog = line.substr(13)` → `"BSDS"`

A comma *inside* a field shifts every subsequent `find` — `"Khan, Ali,92,BSIT"` splits into four fields. Course answer: **fields never contain commas** — a documented constraint of the format (real-world CSV's quoted-fields answer is noted in [C7](challenges.md#c7)).

<a name="s13"></a>
## S13 — Count-first items

```cpp
// FORMAT (contract — keep beside BOTH functions):
//   line 1: <n>
//   then n records: <name>\n<qty>\n
void saveItems(const Item items[], int n, const char* filename) {
    std::ofstream out(filename);
    if (!out.is_open()) return;
    out << n << '\n';
    for (int i = 0; i < n; i = i + 1)
        out << items[i].name << '\n' << items[i].qty << '\n';
}
int loadItems(Item items[], int cap, const char* filename) {
    std::ifstream in(filename);
    if (!in.is_open()) return 0;            // missing = empty, by contract
    int n = 0;
    in >> n;  in.ignore(1000, '\n');        // ignore #1 (after the count)
    if (n > cap) n = cap;                   // clamp — trust up to the guard
    for (int i = 0; i < n; i = i + 1) {
        std::getline(in, items[i].name);
        in >> items[i].qty;
        in.ignore(1000, '\n');              // ignore #2..n+1 (after each qty)
    }
    return n;
}
```
The ignore appears after the count *and* after every qty — every `>>`-before-getline seam.

<a name="s14"></a>
## S14 — Gallery drill

(a) **M3** — no append mode; open with `std::ios::app`. (b) **M2** — the eof() loop's phantom record; read in the condition. (c) **M4** — missing ignore (with M8's truncation as the mechanism `>>` provides); `ignore(1000, '\n')` at every seam. (d) **M6** — trusting the file's count; clamp to capacity.

<a name="s15"></a>
## S15 — State-flag drill

(a) **eof set** (the read of 20 consumed the final bytes; attempting again trips it — precisely: after reading 20, eofbit may not be set until another attempt; the *next* `in >> x` attempts, fails, sets eof/fail, x unchanged). (b) **failbit set** at the `abc` read — and the *next* `in >> x` does nothing (stream is failed; all reads no-op until cleared). (c) **fail + eof** on the first attempt — nothing was ever there. Practical rule: after any failed read, the stream stays failed — check the read's result at the boundary, don't read on.

<a name="s16"></a>
## S16 — fileExists

```cpp
bool fileExists(const char* filename) {
    std::ifstream in(filename);
    return in.is_open();
}
```
False "yes": opens a **directory** or an unreadable-permission file (is_open may succeed where reading won't). False "no": reports false for a file that doesn't exist *yet* but could be **created** by an ofstream — existence and writability are different questions. (In practice: check by attempting the real operation you wanted — the labs do exactly that.)

<a name="s17"></a>
## S17 — The tail reader

```cpp
std::string lines[1000];
int n = 0;
std::string line;
std::ifstream in("log.txt");
if (!in.is_open()) { std::cout << "open failed\n"; return 1; }
while (n < 1000 && std::getline(in, line)) lines[n++] = line;   // read all, guarded
int start = (n >= 3) ? n - 3 : 0;
for (int i = start; i < n; i = i + 1) std::cout << lines[i] << '\n';
```
Rolling-buffer version: keep a `std::string ring[3]` and `ring[n % 3] = line; n++` — after the loop, print indices `((n-3+k) % 3 + 3) % 3` for k = 0..2 — memory stays 3 lines forever (the classic log-tail trick; try it as the extension).

<a name="s18"></a>
## S18 — Expense capstone drill

```cpp
// FORMAT (contract): each line: <description>;<amount>\n   (append-only file)
// Semicolon, not comma: descriptions may contain commas ("lunch, taxi, tips")
// and our course format forbids separators inside fields — ';' can't appear in a price.
void addExpense(const char* filename, const std::string& desc, double amount) {
    std::ofstream out(filename, std::ios::app);      // append: history survives
    if (!out.is_open()) { std::cout << "open failed\n"; return; }
    out << desc << ';' << amount << '\n';            // every write ends with its separator
    out.close();
}
double printAll(const char* filename) {
    std::ifstream in(filename);
    if (!in.is_open()) { std::cout << "(no expenses yet)\n"; return 0.0; }  // missing = empty
    std::string line;  double total = 0.0;
    while (std::getline(in, line)) {
        std::size_t p = line.find(';');
        if (p == std::string::npos) { std::cout << "malformed: " << line << '\n'; continue; }
        double amt = std::stod(line.substr(p + 1));
        std::cout << line.substr(0, p) << " : " << amt << '\n';
        total += amt;
    }
    return total;
}
```
Semicolon rationale: the *data* may contain commas but never semicolons — the separator must be a character the data can't produce (the same reasoning as the sentinel rule). Round trip: append N lines, load N lines, total = Σ — the labs scale this to records.
