---
title: "Files Debugging Exercises"
description: "10 seeded file bugs — the silent missing file, the eof() phantom, the erased log, the missing ignore, the unclamped count, the drift contract."
---

# Files Debugging Exercises (10)

> [← Module home](index.md) · Work each in the [debugging protocol](../arrays/debugging.md): reproduce → form hypotheses → instrument → fix → **reflect**. Files add one instrument: **inspect the file in an editor between steps** — the file's bytes are the ground truth your program is lying about.

**Format.** Each program compiles but misbehaves. Hint ladders are collapsible — one rung at a time. [Fix-list summary](#fix-list-summary) at the end.

---

## D1 — The report that's always empty (no open check)

```cpp
int main() {
    std::ifstream in("roster.txt");      // the file does NOT exist
    int n;  in >> n;
    std::cout << "loaded " << n << " students\n";
}
// Prints: loaded 0 students   — every single time, on every machine. No error. Ever.
```
The user believes the roster is empty. It is worse: it was never opened.

<details markdown="1"><summary>Hint 1 — what did the failed open do to the stream, and what do failed reads return?</summary>

The open set failbit; every subsequent `>>` is a no-op and leaves `n` uninitialised (garbage, or 0 by luck). Nothing ever announces the problem.
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

```cpp
if (!in.is_open()) { std::cout << "roster.txt not found\n"; return 1; }
```
Gallery **M1** — silence is the enemy; the check converts it to a message ([Lesson 3 §1](lesson-3-errors-mistakes.md#1-basic-file-errors--what-can-go-wrong)).
</details>

**Reflection.** "It printed 0" and "it printed my data" are the only two *visible* states; the file bug lives in the gap. Instrument the gap — always.

<a name="d2"></a>
## D2 — Every name is blank (missing ignore)

```cpp
// roster.txt:  2\nAyesha Khan\n92\nAli Raza\n78\n
std::ifstream in("roster.txt");
int n;  in >> n;  in.ignore(1000, '\n');     // ignore #1 present...
Student roster[10];
for (int i = 0; i < n; i = i + 1) {
    std::getline(in, roster[i].name);
    in >> roster[i].score;                    // ...but the loop's seam is bare
}
// names print: "Ayesha Khan" then "" — and record 2 is entirely wrong
```
Trace it: record 1 loads perfectly, record 2's name is empty and its score is... find it.

<details markdown="1"><summary>Hint 1 — what is left in the stream after <code>in >> roster[0].score</code>?</summary>

The newline after `92`. The next `getline` (record 2's name) consumes it → `""`. Then `in >> roster[1].score` attempts to read `Ali` as an int → **fails**; the stream is dead; record 2 gets a stale score. (One missing ignore killed record 2 *and* the loop.)
</details>

<details markdown="1"><summary>Hint 2 — the rule</summary>

`in.ignore(1000, '\n');` after the score, inside the loop. Every `>>`-before-getline seam gets one — count the seams, count the ignores ([gallery M4](lesson-3-errors-mistakes.md#3-the-common-mistakes-gallery)).
</details>

**Reflection.** The mixing trap is not a one-time lesson — it recurs at **every** seam. Files have more seams than the keyboard; count them.

<a name="d3"></a>
## D3 — The disappearing ledger (missing append)

```cpp
void recordExpense(double amount) {
    std::ofstream out("expenses.txt");     // intent: keep a running ledger
    out << "2026-09-23 lunch " << amount << '\n';
    out.close();
}
// called daily. At day's end, expenses.txt has ONE line — today's.
```

<details markdown="1"><summary>Hint 1 — what does the daily open do to yesterday's entries?</summary>

The plain ofstream open **truncates** — each day erases the ledger. The intent was append; the code says replace ([gallery M3](lesson-3-errors-mistakes.md#3-the-common-mistakes-gallery)).
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`std::ofstream out("expenses.txt", std::ios::app);` — and re-run the *test* that proves it: two calls, two lines.
</details>

**Reflection.** The open mode is a *sentence about intent*: "replace" or "append". Say the sentence, then write the flag.

<a name="d4"></a>
## D4 — The truncated names (>> on a field with spaces)

```cpp
// students.txt:  Ayesha Khan 92\nAli Raza 78\n
std::ifstream in("students.txt");
std::string name;  int score;
while (in >> name >> score)
    std::cout << name << " -> " << score << '\n';
// output: Ayesha -> 92 / Khan -> ??? — trace it. (It gets weird.)
```
Output: `Ayesha -> 92`, then `Khan -> 78` (the stray surname becomes a name, the second score mis-pairs), then `Raza -> ` fails silently. Half the data, misaligned.

<details markdown="1"><summary>Hint 1 — where does <code>in >> name</code> stop?</summary>

At the first whitespace — `"Ayesha"`. `Khan` then becomes the next name-read... and the format is now misaligned by one field forever.
</details>

<details markdown="1"><summary>Hint 2 — the format decision</summary>

Names contain spaces → the format **must** be line-based: `getline` for the name, then `>> score`, with the ignore rhythm — or CSV with the splitter. The bug was choosing `>>` for a spaces-allowed field ([Lesson 2 §2](lesson-2-reading-writing.md#2-two-reading-strategies--match-the-format)).
</details>

**Reflection.** The reader doesn't fix the format — the format decides the reader. Design the format for the *worst* legal value, then pick the strategy.

## D5 — The phantom record (eof loop)

```cpp
// marks.txt:  80\n90\n
int m;
std::ifstream in("marks.txt");
while (!in.eof()) {
    in >> m;
    std::cout << "processed " << m << '\n';
}
// output: 80, 90, 90 — the last one processed TWICE
```

<details markdown="1"><summary>Hint 1 — when does eofbit actually set?</summary>

Only when a read **attempts past the end**. After reading 90, no attempt has gone past — the flag is false, the body runs once more, the read fails, and the stale `m` (90) prints ([Lesson 3 §2](lesson-3-errors-mistakes.md#2-eof-and-the-stream-state)).
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`while (in >> m)` — the read's own result is the condition; no stale value is ever processed.
</details>

**Reflection.** eof() answers "did the *previous* attempt go too far?", never "will the next read succeed?". Loop on results, not predictions.

<a name="d6"></a>
## D6 — The count that lied (unclamped load)

```cpp
// roster.txt line 1 (corrupted by an editor crash): 99999
int loadRoster(Student roster[], int cap, std::ifstream& in) {
    int n;  in >> n;  in.ignore(1000, '\n');
    for (int i = 0; i < n; i = i + 1)              // n = 99999
        std::getline(in, roster[i].name);          // ...and roster[100..] ???
    return n;
}
```
Called with `cap = 100`. Runs "fine" on small files — and on the corrupted file, writes far past the array.

<details markdown="1"><summary>Hint 1 — which two guarantees does the loop condition need?</summary>

Data present (the stream stays healthy) *and* space present (`i < cap`). The count from the file is a claim, not a fact.
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`if (n > cap) n = cap;` before the loop — the clamp ([gallery M6](lesson-3-errors-mistakes.md#3-the-common-mistakes-gallery)). Trust data only up to your guard.
</details>

**Reflection.** The capacity clamp is the file-reading cousin of the loop-bounds rule: arrays end where they end, whatever the data claims.

## D7 — The broken writer (no separators)

```cpp
void save(const Student& s, std::ofstream& out) {
    out << s.name << s.score;         // intended: name on one line, score on the next
}
// roster.txt after save:  Ayesha Khan92Ali Raza78
// loadRoster then reads ONE record: name "Ayesha Khan92Ali Raza78"?? — trace the mess.
```
The file is one 24-character line; the loader (line-based, count-first) mis-parses everything downstream.

<details markdown="1"><summary>Hint 1 — what makes the loader see two records where the writer wrote none?</summary>

The loader splits on newlines; the writer wrote none. Separators *are* the format — `<<` writes values flush against each other ([gallery M8](lesson-3-errors-mistakes.md#3-the-common-mistakes-gallery)).
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`out << s.name << '\n' << s.score << '\n';` — every field ends with its separator, visibly. Then round-trip test: save, load, compare.
</details>

**Reflection.** A format lives in its separators. A writer without them writes *soup* — and soup is loadable as *anything*, which is the bug.

## D8 — The ignored failure (writing to a bad path)

```cpp
std::ofstream out("archive/2026/roster.txt");   // archive/ doesn't exist
out << "data";
std::cout << "saved\n";
// prints "saved". roster.txt appears nowhere. No error anywhere.
```

<details markdown="1"><summary>Hint 1 — ofstream creates files. What does it NOT create?</summary>

Directories. The open failed (bad path) — and without the check, the writes went nowhere while the program claimed success ([gallery M5](lesson-3-errors-mistakes.md#3-the-common-mistakes-gallery)'s path family).
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

The open check — `if (!out.is_open())` — plus the working-directory sanity check from Lesson 3. Yes, ofstream needs the check too; "it creates the file" is not "it succeeds".
</details>

**Reflection.** Every open can fail — reading *and* writing. The four-word discipline has no exceptions, only frequencies.

<a name="d9"></a>
## D9 — The contract drift (writer changed, reader didn't)

```cpp
// VERSION 1 format:  <name>\n<score>\n
// VERSION 2 writer (updated last week):
out << s.name << '\n' << s.score << '\n' << s.programme << '\n';   // new field added
// VERSION 1 loader (never touched):
for (int i = 0; i < n; i = i + 1) {
    std::getline(in, roster[i].name);
    in >> roster[i].score;
    in.ignore(1000, '\n');
}
// loads 10 records from a 10-record file... until record 2's score meets "BSCS".
```
Records misalign from the first extra field; scores become garbage; names shift.

<details markdown="1"><summary>Hint 1 — why does the loader mis-parse from the first record, and why is it silent?</summary>

Streams are position-blind: after the score, `ignore` skips to the next newline — which is now the *programme* line — so the next name read is record 2's... wait, trace carefully: the loader reads name, score, skips programme; next iteration reads record 2's name as a name — but record 1's programme was *eaten as a skip*. The seam count no longer matches the field count, so every subsequent field is off by one line. Silent, because every read still "succeeds".
</details>

<details markdown="1"><summary>Hint 2 — the fix, and the discipline</summary>

Update **both ends in one edit**, and keep the format contract as a comment beside both functions ([gallery M10](lesson-3-errors-mistakes.md#3-the-common-mistakes-gallery)):

```cpp
// FORMAT v2: <name>\n<score>\n<programme>\n   (BOTH save() and load() follow v2)
```
Optionally a version header line in the file itself — the extension asks for it.
</details>

**Reflection.** A file format is a contract between two programs *written at different times* — often by different yous. Contracts change by amendment, not telepathy.

<a name="d10"></a>
## D10 — The log that lies (no check, wrong mode, no flush)

```cpp
void audit(const std::string& event) {
    std::ofstream out("audit.log");            // (a)
    out << event << '\n';                      // (b) no open check; (c) no close/flush
}
// used in a program that sometimes crashes mid-run. audit.log is empty after crashes
// — and, separately, holds only the LAST event after normal runs. Two bugs, one function.
```

<details markdown="1"><summary>Hint 1 — which gallery entries are (a) and (b)?</summary>

(a) is **M3** — every call truncates; only the final call's line survives a normal run. (b) is **M1** — if the open fails (permissions after a chmod, say), events vanish silently.
</details>

<details markdown="1"><summary>Hint 2 — and the crash-emptiness? (c)</summary>

**M9** — the buffered event dies with the crash before the (missing) close flushes it. For per-event durability: open in **append**, check, write, **close — inside the function**. Costly per call; correct per event.
</details>

**Reflection.** One five-line function held three gallery bugs. File code is short — its bugs are dense. The checklist exists because density is real.

---

<a name="fix-list-summary"></a>
# Fix-list summary

| D | Gallery / lesson | Bug (one line) | Fix (one line) |
| - | ---------------- | -------------- | -------------- |
| D1 | M1 | no open check on read | `if (!in.is_open())` + message |
| D2 | M4 | missing ignore after the score | `in.ignore(1000, '\n')` at every seam |
| D3 | M3 | daily open truncates the ledger | `std::ios::app` |
| D4 | strategy rule | `>>` on a spaces-allowed field | line-based (or CSV) format for names |
| D5 | M2 | `while (!in.eof())` phantom | `while (in >> m)` |
| D6 | M6 | file's count trusted past capacity | `if (n > cap) n = cap;` |
| D7 | M8 | writes without separators | every field ends with its separator |
| D8 | M5 | write to a bad path, unchecked | open check + verify working directory |
| D9 | M10 | writer gained a field, reader didn't | amend both ends together; comment the contract |
| D10 | M1+M3+M9 | audit log unchecked, truncating, unflushed | append + check + close per event |
