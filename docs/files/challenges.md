---
title: "Files Challenges"
description: "10 design challenges — search, merge, statistics, rewrite pipelines, and format design — with separated approach solutions."
---

# Files Challenges (10)

> [← Module home](index.md) · Attempt **30 minutes** before reading any solution — and **write the format contract first** (as a comment): these challenges are won in the format design. Solutions separated at the end; each gives the approach plus key code. ★ = Lesson 1 · ★★ = adds Lesson 2 · ★★★ = combines everything.

---

## C1 — The word-frequency counter (★★)

Read a text file of whitespace-separated words; count how many times each of the user-sought words appears. Interface: the program reads a target word, then counts occurrences in `article.txt` (case-insensitive). Report count + total word count. Test: an article with 40 words, target `"the"` appearing 6 times (verify by hand first!).

## C2 — The count-free loader (★★)

Rebuild `loadRoster` **without** the count-first header — read until EOF instead. Format: `name\nscore\n` repeating. Where does the loop end now (which condition stops it?), and what happens to the capacity guard's *meaning* (clamp to cap, and what does the return value report)? Then state the trade: count-first vs read-until-EOF — which detects a truncated file, and which avoids maintaining the count?

## C3 — The safe rewrite (★★★)

Task: remove all students with score < 50 from `roster.txt` *permanently*. You cannot delete lines in place with course tools — so: load all records, filter in memory, then **rewrite the file from scratch** (fresh ofstream, by design — the one place truncation is a feature). Contract question to answer in writing: what is the *risk window* (crash between open and write), and why is the course answer "acceptable for coursework, dangerous for production" (name the real-world fix: write-to-temp-then-rename)?

## C4 — The CSV date column (★★★)

Extend the CSV student format with an enrolment date — but the date contains commas? No — it contains *dashes*: `name,score,programme,2026-09-01`. Extend writer and reader; the reader validates the date fields with the [records-module `isValid`](../records/challenges.md#c1). Then the design question: why did the *date* need a component format (dashes) while the course forbids commas — what property must a separator have (echo the [sentinel rule](../repetition/lesson-3-break-continue-sentinels.md))?

## C5 — The merge of two files (★★★)

Two sorted score files (each line: `name;score`, descending by score): merge into a third file, preserving order, **without loading everything into one array** — stream both inputs simultaneously (two `ifstream`s, compare current heads, write smaller, advance — the [two-pointer merge](../arrays/challenges.md) with files). Handle the tail drains. Both opens get checks; the output gets the truncate contract comment.

## C6 — The duplicate detector (★★)

Given `emails.txt` (one address per line), report duplicates. Capacity-honest version: read into an array (clamped), O(n²) scan — the [records-module C6 approach](../records/challenges.md#c6). Report each duplicate *once* with its first-seen line number. What's the report for a 5000-line file with a 1000-line array? (State the policy: report duplicates among the *loaded* subset, and say so in the output — honest reporting beats silent truncation.)

## C7 — The quoted-CSV field (★★★)

The real-world CSV wart, solved: a field like `"Khan, Ali"` (quoted because it contains a comma) must split as one field. Upgrade the splitter: if a field starts with `"`, find the *closing* quote and treat the comma inside as data. Test: `name,score` where name = `"Khan, Ali"`, score = 92. Then the honest note: full CSV quoting (embedded quotes, newlines-in-fields) is a rabbit hole — state exactly which cases your parser handles and which it refuses.

## C8 — The config file (★★)

Parse a settings file of `key=value` lines (`#` starts a comment; blank lines ignored):

```text
# roster settings
capacity=100
course=BSCS
pass_mark=50
```

Read it into three variables with defaults (capacity 50, course "BSIT", pass_mark 40) if a key is missing. Design decisions to write down: trim whitespace or not (state it), unknown keys (ignore with a warning), duplicate keys (last wins). This is `>>`-formatted and line-based reading *composed* — getline then split on `'='`.

## C9 — The backup rotation (★★★)

Before each rewrite (C3's pipeline), create `roster.txt.bak` — a copy of the current file. Implement `bool backupFile(const char* src, const char* dst)` (open both, check both, byte-copy by lines, close both, return success). Then the rotation: keep `.bak` only if the *rewrite fully succeeded* — and write the failure policy: if the backup fails, refuse the rewrite (data protection has an order: copy first, destroy second).

## C10 — The file-format designer (★★★)

A clinic needs to persist patients: id, full name, age, ward (one of four strings), critical flag, admission date. **Design the file format** — every choice justified in one sentence each: text vs binary (why text), line-based vs `>>` (which fields force which), separator choices (echo C4's property), header (count-first? version line? none?), missing-file contract, and the capacity clamp. Then write both functions with the contract comments, and the round-trip test table (5 rows: 1 record, 3 records, 0 records, missing file, truncated file — expected result each).

---

<a name="solutions"></a>
# Solutions (approaches + key code)

<details markdown="1"><summary>C1 — Word-frequency counter</summary>

```cpp
std::string word, target;
std::cin >> target;
for (int i = 0; i < target.length(); i = i + 1) target[i] = tolower(target[i]);

std::ifstream in("article.txt");
if (!in.is_open()) { std::cout << "open failed\n"; return 1; }
int count = 0, total = 0;
while (in >> word) {                       // >> = whitespace-delimited words
    total += 1;
    for (int i = 0; i < word.length(); i = i + 1) word[i] = tolower(word[i]);
    if (word == target) count += 1;
}
std::cout << count << " of " << total << '\n';
```
`>>` is exactly right — words are whitespace-delimited by definition. Normalize both sides to lowercase (the [strings-module comparison rule](../strings/index.md)). Hand-verify the 6 before trusting the machine — the counter is only as good as the definition of "word" (is `"the,"` the word `the`? — with punctuation attached it isn't; document your policy or strip punctuation with cctype).
</details>

<a name="c2"></a>
<details markdown="1"><summary>C2 — Count-free loader</summary>

```cpp
int loadRoster(Student roster[], int cap, const char* filename) {
    std::ifstream in(filename);
    if (!in.is_open()) return 0;
    int n = 0;
    while (n < cap && std::getline(in, roster[n].name)) {   // name line: EOF stops here
        in >> roster[n].score;
        in.ignore(1000, '\n');                              // seam before the next getline
        n += 1;
    }
    return n;    // n == cap means "may be more on disk" — the caller decides
}
```
The loop ends when the *name getline* fails — EOF detected on the field that always exists. The clamp moves **into the condition** (`n < cap`): loading stops at capacity, and the return value's meaning changes — it's now "records loaded (possibly capped)", so a full-capacity return is ambiguous (exactly full vs more left). Count-first detects truncation instantly (a short file fails mid-load); count-free never needs the count maintained — the honest trade is validation vs maintenance, and this challenge is where you *feel* it.
</details>

<a name="c3"></a>
<details markdown="1"><summary>C3 — The safe rewrite</summary>

```cpp
// 1. load (clamped), 2. filter in memory, 3. rewrite from scratch
int keep = 0;
for (int i = 0; i < n; i = i + 1)
    if (roster[i].score >= 50) roster[keep++] = roster[i];   // in-memory compaction

std::ofstream out("roster.txt");            // truncate — deliberate, this once
if (!out.is_open()) { std::cout << "rewrite failed\n"; return 1; }
out << keep << '\n';
for (int i = 0; i < keep; i = i + 1)
    out << roster[i].name << '\n' << roster[i].score << '\n';
out.close();
```
The risk window: between the truncating open and the last buffered write, a crash leaves the file **empty or partial** — the old data is already gone. Acceptable here because a lost roster is re-enterable; production's fix: write the new data to `roster.txt.tmp`, then *rename* over the original (atomic on real filesystems) — the [C9 backup](#c9) is the coursework-scale cousin of the same instinct: never destroy the only copy until the replacement exists.
</details>

<details markdown="1"><summary>C4 — The CSV date column</summary>

```cpp
// FORMAT: name,score,programme,yyyy-mm-dd
out << s.name << ',' << s.score << ',' << s.programme << ','
    << s.enrolled.y << '-' << s.enrolled.m << '-' << s.enrolled.d << '\n';
// reading: split into 4 fields as before; field 4 splits on '-':
Date d;
// stoi on the three dash-separated pieces; validate with isValid(d) — reject the line otherwise
```
The separator property: a separator must be a character **the data cannot produce**. Dates contain digits and dashes — never commas — so commas stay the *field* separator while dashes structure *within* the date field. Same reasoning as the sentinel rule (a sentinel must be unreachable as real data): the format's structure lives in characters the data promises not to use, and the promise is documentation.
</details>

<details markdown="1"><summary>C5 — Merge of two files</summary>

```cpp
std::ifstream a("hall1.txt"), b("hall2.txt");
if (!a.is_open() || !b.is_open()) { std::cout << "open failed\n"; return 1; }
std::ofstream out("merged.txt", std::ios::trunc);   // truncate: fresh output, documented
if (!out.is_open()) { std::cout << "open failed\n"; return 1; }

std::string na, nb;  int sa, sb;
bool ha = static_cast<bool>(a >> sa), hb = static_cast<bool>(b >> sb);
// (load the name lines with the ignore rhythm too — elided for shape)
while (ha && hb) {
    if (sa >= sb) { out << na << ';' << sa << '\n'; ha = static_cast<bool>(a >> sa); /* + name */ }
    else          { out << nb << ';' << sb << '\n'; hb = static_cast<bool>(b >> sb); }
}
while (ha) { out << na << ';' << sa << '\n'; ha = static_cast<bool>(a >> sa); }
while (hb) { out << nb << ';' << sb << '\n'; hb = static_cast<bool>(b >> sb); }
```
The two-pointer merge where the pointers are *stream positions*: compare current heads, write the smaller, advance that input. The tail drains handle the file that outlasts the other. Memory: O(1) — two records' worth — which is the entire point of streaming (the array merge needed everything resident). Ties pull from `a` (documented stability).
</details>

<a name="c6"></a>
<details markdown="1"><summary>C6 — Duplicate detector</summary>

```cpp
std::string seen[1000];
int n = 0;
while (n < 1000 && in >> seen[n]) n += 1;      // clamped load

bool reported[1000] = {false};                  // report each duplicate once
for (int i = 0; i < n; i = i + 1) {
    if (reported[i]) continue;
    for (int j = i + 1; j < n; j = j + 1)
        if (seen[j] == seen[i]) {
            std::cout << seen[i] << " first seen at line " << i + 1 << '\n';
            reported[i] = true;
            break;
        }
}
// policy line, printed when n hit the cap:
if (n == 1000) std::cout << "(checked first 1000 lines only)\n";
```
O(n²) — fine at course scale, honest about its ceiling. The `reported` array is the "report once" state machine; line numbers are indices + 1 (humans count from 1). The policy print is the deliverable: truncated checking is fine, *silent* truncated checking is a lie ([gallery M6](lesson-3-errors-mistakes.md#3-the-common-mistakes-gallery)'s principle, transplanted to output).
</details>

<a name="c7"></a>
<details markdown="1"><summary>C7 — Quoted-CSV field</summary>

```cpp
// splits line into fields, honouring a leading quote per field
int splitQuoted(const std::string& line, std::string out[], int maxOut) {
    int count = 0;
    std::size_t i = 0;
    while (i <= line.length() && count < maxOut) {
        std::string field;
        if (i < line.length() && line[i] == '"') {          // quoted field
            std::size_t close = line.find('"', i + 1);
            if (close == std::string::npos) { /* refuse: unterminated */ break; }
            field = line.substr(i + 1, close - i - 1);       // comma inside = data
            i = close + 1;
            if (i < line.length() && line[i] == ',') i += 1; // consume the following comma
        } else {                                             // bare field
            std::size_t p = line.find(',', i);
            field = (p == std::string::npos) ? line.substr(i) : line.substr(i, p - i);
            i = (p == std::string::npos) ? line.length() + 1 : p + 1;
        }
        out[count++] = field;
    }
    return count;
}
```
Handles: `"Khan, Ali",92` → 2 fields ✓; bare fields unchanged. Refuses: unterminated quotes. Doesn't handle (documented): escaped quotes inside quotes (`""`), newlines inside fields — real CSV's full spec is bigger than one splitter, and *saying so* is the deliverable. Test table: 4 rows minimum, including a quoted field as the *last* field.
</details>

<details markdown="1"><summary>C8 — Config file</summary>

```cpp
int capacity = 50;  std::string course = "BSIT";  int passMark = 40;   // defaults
std::string line;
while (std::getline(in, line)) {
    if (line.empty() || line[0] == '#') continue;             // skip blanks/comments
    std::size_t eq = line.find('=');
    if (eq == std::string::npos) continue;                    // malformed: skip (or warn)
    std::string key = line.substr(0, eq);
    std::string val = line.substr(eq + 1);
    if      (key == "capacity")  capacity = std::stoi(val);
    else if (key == "course")    course   = val;
    else if (key == "pass_mark") passMark = std::stoi(val);
    else std::cout << "warning: unknown key " << key << '\n';
}
```
Documented decisions: **no trimming** (values are used verbatim — the file is hand-edited to that standard), **unknown keys warn and continue** (forward compatibility), **duplicate keys: last wins** (each match overwrites — a property of the linear scan, stated in the contract). Defaults make the config *optional* — a missing file loads as pure defaults, the same missing-file contract as the roster loader.
</details>

<a name="c9"></a>
<details markdown="1"><summary>C9 — Backup rotation</summary>

```cpp
bool backupFile(const char* src, const char* dst) {
    std::ifstream in(src);
    if (!in.is_open()) return false;              // nothing to back up = failure? or ok? — decide, document
    std::ofstream out(dst);                       // truncate: the .bak is replaced wholesale
    if (!out.is_open()) { return false; }
    std::string line;
    while (std::getline(in, line)) out << line << '\n';
    return true;                                  // (a flush-checking version would test out.good())
}
// rewrite pipeline:
// 1. if (!backupFile("roster.txt", "roster.txt.bak")) { refuse the rewrite; }
// 2. rewrite roster.txt from the filtered records
```
The order is the whole lesson: **copy first, destroy second**. If the backup fails, the rewrite must not run — the current file is the only good copy, and the pipeline's job is to never reach a state with zero copies. (Failure-policy choice documented above: a missing source *is* a failure here, because the caller believes data exists. The honest alternative — missing source = nothing to protect, proceed — is defensible; pick one and write it down.)
</details>

<details markdown="1"><summary>C10 — The file-format designer</summary>

**The format contract:**

```text
# patients.txt — v1
# line 1: <count>
# then per patient (3 lines):
#   <id> <age> <critical 0|1> <WARD>     (formatted — no spaces in these fields)
#   <yyyy-mm-dd>                          (dash-structured date, validated on load)
#   <full name>                           (line-based — may contain spaces)
```

Justifications, one sentence each: **text** over binary — inspectable in editors, matches every tool this course built; **mixed strategy** — the numeric/enum fields are `>>`-perfect, but the name's spaces force line-based for that field, so the record is a *composed* read (`>>` the scalars, ignore, getline the name, ignore, getline the date, validate); **separators** — space between scalars, dashes inside dates, newlines between line-based fields: each is a character its data cannot produce (C4's property); **count-first header + version comment** — the loader validates the claim against capacity instantly (M6) and the version line is the [D9](debugging.md#d9) amendment mechanism; **missing-file contract** — empty list, by written agreement; **capacity clamp** — `if (n > cap) n = cap;` always.

```cpp
// load core (save is the mirror):
int id, age, crit;  std::string ward, name, date;
in >> id >> age >> crit >> ward;   in.ignore(1000, '\n');
std::getline(in, name);
std::getline(in, date);
// + isValid on the date, ward string -> enum via a mapper, crit != 0 && crit != 1 rejected
```

Round-trip test table:

| Case | Expected |
| --- | --- |
| save 1 record, load | identical record back; file is 4 lines |
| save 3, load | 3 records, order preserved |
| save 0, load | 0 records; file is 1 line (`0`) |
| load, file missing | 0 records, no error — the contract |
| load, truncated mid-record | loader stops or rejects the malformed record — clamp + validation decide; **document which** (validation-reject is the stronger contract, and it's the one your isValid/mapper checks give you) |

The deliverable isn't the code — it's that every design choice has a *sentence*, and the sentences agree with each other. That's the skill [Lab 6](labs.md#lab-6--simple-transaction-log) and the [mini-project](miniproject.md) are built on.
</details>
