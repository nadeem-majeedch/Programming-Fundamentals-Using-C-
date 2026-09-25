---
title: "Strings Labs"
description: "7 lab scenarios — username validator, password-rule checker, text analyzer, word counter, search tool, student name processor, text statistics — each with solution and explanation."
---

# Strings Labs (7 scenarios)

> [← Module home](index.md) · Attempt each scenario's **student tasks** before opening its solution. Every lab: scenario → requirements → inputs/outputs → constraints → test cases → student tasks → solution → explanation. All arithmetic and expected outputs below are hand-traced.

**Ground rules.** `std::string` + `<cctype>` only — no vectors, no maps, no regex (arrays where storage is needed, per [Unit 09](../arrays/lesson-1-basics.md)). Every lab ends with a ⭐ extension that previews the next stage.

---

<a name="lab-1--username-validator"></a>
## Lab 1 — The Username Validator

**Scenario.** A campus portal needs new usernames checked before account creation. You are the validator service.

**Requirements.**
R1. Read one username per line until the sentinel `DONE`.
R2. A username is valid when: length 3–12, letters/digits only (starts with a letter), all lowercase.
R3. Report per candidate: `VALID` or the **first** failed rule, named: `BAD-LENGTH`, `BAD-CHARACTER`, `BAD-START`, `NOT-LOWERCASE`.
R4. End with a tally: valid count, invalid count, and the most common failure reason (a per-reason counter — 4 counters, the [tally trick](../arrays/lesson-2-classic-passes.md#4-frequency-counting--the-tally-array) in miniature).

**Inputs / outputs.** In: one candidate per line. Out: verdict per line + final tally.

**Constraints.** No trimming needed — input is clean words (use `>>`). Sentinel `DONE` is never a legal candidate (it would fail R2's uppercase rule anyway).

**Test cases.**

| Input | Expected verdict | Why |
| ----- | ---------------- | --- |
| `ali` | VALID | 3 chars, letter-start, all ok |
| `ab` | BAD-LENGTH | too short |
| `abcdefghijKl` | BAD-LENGTH | 12 chars is ok — this is 13 → too long |
| `1ali` | BAD-START | digit start |
| `ali_khan` | BAD-CHARACTER | `_` not letters/digits |
| `Ali` | NOT-LOWERCASE | uppercase 'A' |
| `al1` | VALID | digits allowed after start |
| `DONE` | (sentinel) | stops |

**Student tasks.**
1. Write the four rule-checks as four small functions (predicate per rule — [functions module style](../functions/lesson-1-machine.md)).
2. Order them so the *first failure* names the right rule (R3) — sequence matters: length before character? Decide and justify.
3. Wire the tally (four counters), print the report, and the most-common-failure (champion logic [Lesson 2 §2 of arrays](../arrays/lesson-2-classic-passes.md#2-minimum-and-maximum--the-champion-with-an-address)).
4. Dry-run the full test table on paper first.

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <cctype>

bool lengthOk(const std::string& s) { return s.length() >= 3 && s.length() <= 12; }
bool startsOk(const std::string& s) { return isalpha(s[0]); }
bool charsOk(const std::string& s) {
    for (int i = 0; i < s.length(); i = i + 1)
        if (!isalnum(s[i])) return false;
    return true;
}
bool lowerOk(const std::string& s) {
    for (int i = 0; i < s.length(); i = i + 1)
        if (!islower(s[i])) return false;
    return true;
}

int main() {
    int valid = 0, badLen = 0, badChar = 0, badStart = 0, badLower = 0;
    std::string u;
    while (std::cin >> u && u != "DONE") {
        if (!lengthOk(u))        { std::cout << "BAD-LENGTH\n";     badLen   += 1; }
        else if (!startsOk(u))   { std::cout << "BAD-START\n";      badStart += 1; }
        else if (!charsOk(u))    { std::cout << "BAD-CHARACTER\n";  badChar  += 1; }
        else if (!lowerOk(u))    { std::cout << "NOT-LOWERCASE\n";  badLower += 1; }
        else                     { std::cout << "VALID\n";          valid    += 1; }
    }
    std::cout << "valid=" << valid << " invalid=" << (badLen + badChar + badStart + badLower) << '\n';
    int counts[4] = {badLen, badChar, badStart, badLower};
    const char* names[4] = {"BAD-LENGTH", "BAD-CHARACTER", "BAD-START", "NOT-LOWERCASE"};
    int champ = 0;
    for (int i = 1; i < 4; i = i + 1) if (counts[i] > counts[champ]) champ = i;
    std::cout << "most common failure: " << names[champ] << '\n';
}
```

**Explanation.** Four one-job predicates keep `main` readable — the R3 ordering (length → start → character → case) is *cheap-to-expensive and structural-to-stylistic*: a bad start means the character scan would also flag it, so start must run first. The tally reuses arrays + champion logic exactly as [Unit 09](../arrays/lesson-2-classic-passes.md#2-minimum-and-maximum--the-champion-with-an-address) taught. Trace of the table: `abcdefghijKl` — length 13 → BAD-LENGTH ✓; `Ali` — start ok, chars ok, lowercase fails → NOT-LOWERCASE ✓.

**⭐ Extension.** Add a "suggestion" mode: on NOT-LOWERCASE, print the lowercase version; on BAD-CHARACTER, print which character (and its index) failed first.

---

<a name="lab-2--password-rule-checker"></a>
## Lab 2 — The Password Rule Checker

**Scenario.** The portal's passwords need a stricter gate. Rules are a checklist; your program is the checklist runner.

**Requirements.**
R1. Read one password per line (words — `>>`) until sentinel `QUIT`.
R2. Rules: (a) length ≥ 8; (b) at least one uppercase; (c) at least one lowercase; (d) at least one digit; (e) no spaces. (Words can't contain spaces — so rule (e) is enforced *by the reader*; document that honestly.)
R3. Report per password: `STRONG` if all pass, otherwise a numbered list of *every* failed rule (not just the first).
R4. End with the pass rate as a percentage (1 decimal place, `fixed` + `setprecision` — [formatted output](../cpp-io/lesson-1-cout.md)).

**Inputs / outputs.** In: candidates, one per line. Out: verdict + failed-rule list per line; final pass rate.

**Constraints.** Maximum 100 passwords (store them? No — process and tally as you read; nothing needs storing).

**Test cases.**

| Input | Expected |
| ----- | -------- |
| `Passw0rd` | STRONG |
| `password` | fail (b), (d) |
| `PASSWORD1` | fail (c) |
| `Pass1` | fail (a) |
| `P4ssw0rdX` | STRONG |
| `pass word1` | fail (a)? no — 10 chars: fail (b) only — no uppercase |
| `Password` | fail (d) |
| `QUIT` | sentinel |

Pass rate: 2 of 7 → `28.6%`.

*Note on `pass word1`: with `>>` that input line becomes one candidate, `pass` (4 chars, no digit) → fails (a), (b), (d). Multi-word passwords arrive as separate candidates — rule (e) is enforced by the reader, as R2 documents.*

**Student tasks.**
1. One flag per rule (a)–(d), set in a single traversal — the [D6 lesson](debugging.md#d6--the-password-that-accepts-anything-predicate--prompt): every clause gets its flag.
2. Report *all* failures in order, then decide STRONG/WEAK.
3. Compute the pass rate — careful: integer division! Cast before dividing.

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <cctype>
#include <iomanip>

int main() {
    int total = 0, strong = 0;
    std::string pw;
    while (std::cin >> pw && pw != "QUIT") {
        total += 1;
        bool lenOk = (pw.length() >= 8);
        bool hasUp = false, hasLow = false, hasDig = false;
        for (int i = 0; i < pw.length(); i = i + 1) {
            if (isupper(pw[i])) hasUp = true;
            if (islower(pw[i])) hasLow = true;
            if (isdigit(pw[i])) hasDig = true;
        }
        bool fails[4] = {!lenOk, !hasUp, !hasLow, !hasDig};
        const char* msgs[4] = {"length<8", "no uppercase", "no lowercase", "no digit"};
        int failCount = 0;
        for (int i = 0; i < 4; i = i + 1)
            if (fails[i]) { std::cout << "  fail: " << msgs[i] << '\n'; failCount += 1; }
        if (failCount == 0) { std::cout << "  STRONG\n"; strong += 1; }
    }
    if (total > 0)
        std::cout << "pass rate: " << std::fixed << std::setprecision(1)
                  << (100.0 * strong / total) << "%\n";
}
```

**Explanation.** The single-traversal-sets-all-flags pattern is the clean way to evaluate a multi-clause rule. `100.0 * strong / total` forces floating-point division *before* the integer truncation — the classic [cast rule](../arrays/lesson-2-classic-passes.md#3-sum-and-average--the-accumulator-over-boxes). Trace check: `Passw0rd` — 8 chars ✓, `P` ✓, lowercase ✓, `0` ✓ → STRONG; `Password` — no digit → fail (d) ✓. If you switch to getline (the extension), `"pass word1"` fails (b) *and* (e) — update your trace table to match.

**⭐ Extension.** Switch to getline and *actually* enforce rule (e): scan for `isspace` too. Then `"pass word1"` fails (b) *and* (e) — and your trace table from above changes. Update it.

---

<a name="lab-3--text-analyzer"></a>
## Lab 3 — The Text Analyzer

**Scenario.** An editor plugin prototype: read one line of text and produce a character-level report.

**Requirements.**
R1. Read one line with getline (text can contain spaces and punctuation).
R2. Report: total characters, letters, digits, spaces, punctuation (everything else), uppercase, lowercase.
R3. Report the longest run of consecutive letters and its length (e.g. `"ab12cde"` → longest letter-run `ab`, length 2... and `cde` is 3 — report `cde`, 3: **maximum** run, not first).
R4. If the line is empty: print `EMPTY LINE` and stop gracefully.

**Inputs / outputs.** In: one line. Out: the seven counts + longest letter run (text and length).

**Constraints.** Single pass for counts; the run detection may take its own pass. No storing needed.

**Test cases.**

| Input line | Key expected values |
| ---------- | ------------------- |
| `Hello, World! 42` | letters 10, digits 2, spaces 3, punctuation 3 (`!` + `,` + `!`? trace: `,` `!` are punctuation, `42` digits) — totals must add up |
| `ab12cdefg9xy` | longest letter run `cdefg` (5) |
| `AAAaaa` | uppercase 3, lowercase 3, run `AAAaaa` (6) |
| *(empty line)* | `EMPTY LINE` |

**Student tasks.**
1. The single-pass classifier loop (cctype chain — if/else if/else over the classes).
2. The run detector: current-run length vs champion — [min/max champion pattern](../arrays/lesson-2-classic-passes.md#2-minimum-and-maximum--the-champion-with-an-address) applied to runs, plus tracking the run's start index to slice with substr.
3. The sums-must-add-up invariant: characters = letters + digits + spaces + punctuation — assert it in your dry run.

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <cctype>

int main() {
    std::string line;
    std::getline(std::cin, line);
    if (line.empty()) { std::cout << "EMPTY LINE\n"; return 0; }

    int letters = 0, digits = 0, spaces = 0, punct = 0, upper = 0, lower = 0;
    for (int i = 0; i < line.length(); i = i + 1) {
        char c = line[i];
        if (isalpha(c)) {
            letters += 1;
            if (isupper(c)) upper += 1; else lower += 1;
        } else if (isdigit(c)) digits += 1;
        else if (isspace(c))   spaces += 1;
        else                   punct  += 1;
    }

    int bestLen = 0, bestStart = 0, curLen = 0, curStart = 0;
    for (int i = 0; i <= line.length(); i = i + 1) {
        bool isLetter = (i < line.length() && isalpha(line[i]));
        if (isLetter) {
            if (curLen == 0) curStart = i;
            curLen += 1;
        } else {
            if (curLen > bestLen) { bestLen = curLen; bestStart = curStart; }
            curLen = 0;
        }
    }

    std::cout << "chars=" << line.length()
              << " letters=" << letters << " digits=" << digits
              << " spaces=" << spaces << " punct=" << punct
              << " upper=" << upper << " lower=" << lower << '\n';
    if (bestLen > 0)
        std::cout << "longest letter run: [" << line.substr(bestStart, bestLen)
                  << "] length " << bestLen << '\n';
}
```

**Explanation.** Two clean passes beat one tangled one: classification has no memory, run-detection is the state machine (current run + champion) with the virtual-end flush (`i == length()` closes a final run — the [C2 trick](challenges.md#solutions-approaches--key-code)). Trace `"ab12cdefg9xy"`: runs `ab`(2), `cdefg`(5), `xy`(2) → champion `cdefg`, 5 ✓. Trace `"Hello, World! 42"`: letters 10 (Hello5 + World5), digits 2, spaces 3, punct 2 (`,` `!`) → 10+2+3+2 = 17 = length ✓ (the invariant catches counting bugs).

**⭐ Extension.** Report the *longest word* too (letters/digits/apostrophes count as word chars) — you already have the machinery; what changes?

---

## Lab 4 — The Word Counter

**Scenario.** A lightweight `wc` — the classic Unix tool, student edition.

**Requirements.**
R1. Read lines until an empty line (sentinel). Accumulate over *all* lines: line count, word count, character count (including spaces; count the newline? No — this version counts visible chars per line; document it).
R2. Words = space-separated runs (the [E10 state machine](exercises.md#s10--words), any whitespace counts as a separator).
R3. Also track: longest word overall (and which line it appeared on) and the average word length (1 decimal).
R4. Empty input (immediate blank line): report zeros, average `0.0`, no longest word.

**Inputs / outputs.** In: lines until blank. Out: summary block with all five statistics.

**Constraints.** Max reasonable input (100 lines × 200 chars) — fine. Longest-word tie: keep the *first* seen (strict `>` comparison — document the tie policy).

**Test cases.**

| Input | Expected |
| ----- | -------- |
| `the quick brown fox` ⏎ `jumps over` ⏎ *(blank)* | lines 2, words 7, chars 29, longest `quick`(5) line 1, avg 3.6 |
| `hi` ⏎ *(blank)* | lines 1, words 1, chars 2, longest `hi`(2) line 1, avg 2.0 |
| *(blank immediately)* | all zeros, avg 0.0 |

**Student tasks.**
1. Per-line word state machine + global accumulators — the two-level pattern (per-line locals, across-line globals).
2. Longest-word tracking with its line number: when the current word beats the champion, record word, length, line.
3. Average = total word *characters* / word count — so you need a per-word length accumulator too.

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <cctype>
#include <iomanip>

int main() {
    int lines = 0, words = 0, chars = 0, wordChars = 0;
    std::string bestWord = "";
    int bestLen = 0, bestLine = 0;

    std::string line;
    while (std::getline(std::cin, line) && !line.empty()) {
        lines += 1;
        chars += line.length();
        bool inWord = false;
        std::string cur = "";
        for (int i = 0; i <= line.length(); i = i + 1) {
            bool isSpace = (i == line.length()) || isspace(line[i]);
            if (!isSpace) { cur += line[i]; inWord = true; }
            else if (inWord) {
                words += 1; wordChars += cur.length();
                if (cur.length() > bestLen) { bestLen = cur.length(); bestWord = cur; bestLine = lines; }
                cur = ""; inWord = false;
            }
        }
    }
    std::cout << "lines=" << lines << " words=" << words << " chars=" << chars << '\n';
    if (words > 0) {
        std::cout << "longest word: [" << bestWord << "] (" << bestLen
                  << ") on line " << bestLine << '\n';
        std::cout << std::fixed << std::setprecision(1)
                  << "avg word length: " << (1.0 * wordChars / words) << '\n';
    } else {
        std::cout << "avg word length: 0.0\n";
    }
}
```

**Explanation.** The per-line loop is [Lab 3's](#lab-3--the-text-analyzer) classifier state machine plus word accumulation; the virtual-space flush (`i == length()`) closes the final word. Trace the 2-line input: line 1 words the(3) quick(5) brown(5) fox(3); line 2 jumps(5) over(4); chars 19 + 10 = 29; avg = (3+5+5+3+5+4)/7 = 25/7 = **3.6**; champion strict `>` keeps `quick` (5, first seen) ✓.

**⭐ Extension.** Count occurrences of each of the five most common... without arrays-of-words: track the longest *line* as well, and report words-per-line averages. Then imagine needing per-word counts — that's the [arrays-module tally](../arrays/lesson-2-classic-passes.md#4-frequency-counting--the-tally-array) hitting its limit; the honest motivation for maps (Unit 14+).

---

## Lab 5 — The Simple Search Tool

**Scenario.** A mini grep: find lines containing a target substring.

**Requirements.**
R1. Read the target (one word, `>>`), consume the rest of its line with ignore, then read lines until an empty line.
R2. Print each matching line **prefixed by its line number** (`3: text...`).
R3. After the scan: report total matches and, for the first match only, the character position of the hit.
R4. Case-insensitive option: if the target is all-lowercase, match case-insensitively; if it contains any uppercase, match exactly. (A documented heuristic — real tools have flags; you have a convention.)

**Inputs / outputs.** In: target, then lines. Out: numbered matching lines + summary.

**Constraints.** Line length ≤ 200. Empty target after `>>` can't happen (words are non-empty).

**Test cases.**

Target `at`:
| Line | Content | Match? |
| ---- | ------- | ------ |
| 1 | `The cat sat` | yes (positions 5, 9) |
| 2 | `dogs run` | no |
| 3 | `at the start` | yes (position 1) |
| 4 | `attack` | yes (position 1) |
| 5 | *(blank)* | stop |

Expected output: lines 1, 3, 4; total 3; first hit at line 1 position 5.

Target `Cat` (has uppercase → exact): line 1 `The cat sat` → **no** match. Document: exact mode.

**Student tasks.**
1. The reader choreography: `>>` for the target + `cin.ignore` for its newline ([S3's pattern](exercises.md#s3--mixed-readers)) — then getline loop.
2. Case policy: a function that scans the target for uppercase to choose the mode; lowercase-mode builds a lowercased copy of each line ([D8's copy rule](debugging.md#d8--the-compare-that-changed-normalize-in-place)).
3. First-match position reporting via the find result.

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <cctype>

bool hasUpper(const std::string& s) {
    for (int i = 0; i < s.length(); i = i + 1)
        if (isupper(s[i])) return true;
    return false;
}

std::string toLower(const std::string& s) {
    std::string out;
    for (int i = 0; i < s.length(); i = i + 1) out += tolower(s[i]);
    return out;
}

int main() {
    std::string target;
    std::cin >> target;
    std::cin.ignore(1000, '\n');
    bool exact = hasUpper(target);

    int lineNo = 0, matches = 0;
    int firstLine = 0, firstPos = 0;
    std::string line;
    while (std::getline(std::cin, line) && !line.empty()) {
        lineNo += 1;
        std::size_t pos = exact ? line.find(target)
                                : toLower(line).find(toLower(target));
        if (pos != std::string::npos) {
            matches += 1;
            std::cout << lineNo << ": " << line << '\n';
            if (matches == 1) { firstLine = lineNo; firstPos = pos; }
        }
    }
    std::cout << "matches: " << matches << '\n';
    if (matches > 0)
        std::cout << "first at line " << firstLine << ", position " << firstPos << '\n';
}
```

**Explanation.** The mixing-trap ignore is the lab's hidden first lesson — forget it and the first content line vanishes ([D1](debugging.md#d1--the-disappearing-first-word-skip)). The case heuristic falls out of one predicate + one normalizing helper; note `toLower(line).find(...)` builds a *temporary copy* per line — fine at this scale, and the honest seam where optimization (not building) would later matter. Trace target `at` exact? No — `at` is all-lowercase → insensitive mode: `dogs run` has no `at` (check: d-o-g-s… no) ✓; `attack` contains it ✓.

**⭐ Extension.** Print all *hit positions* per matching line (loop the find with start index `pos + 1`) — `1: The cat sat [5, 9]`.

---

<a name="lab-6--student-name-processor"></a>
## Lab 6 — The Student Name Processor

**Scenario.** A records-office batch job: clean up a class list of names.

**Requirements.**
R1. Read names one per line until a line that is just `END`.
R2. Normalize each to **Title Case**: first letter uppercase, rest lowercase (`mUHAMMAD aLI` → `Muhammad Ali`).
R3. Build the class register output: `Sr. | Name` rows, numbered 1..n, right-aligned number in width 3 ([setw](../cpp-io/lesson-1-cout.md)).
R4. Report: total names, and the most common first name (case-insensitive after normalization — if no repeats, say so). Store names in a `std::string` array (capacity 100) — [arrays + count convention](../arrays/lesson-3-arrays-functions.md#3-the-size-travels-separately--and-how).

**Inputs / outputs.** In: raw names, one per line, `END` sentinel. Out: register table + stats.

**Constraints.** Max 100 names. Names have no leading/trailing spaces (batch is pre-cleaned); internal single spaces only.

**Test cases.**

| Input | Normalized |
| ----- | ---------- |
| `mUHAMMAD aLI` | `Muhammad Ali` |
| `ayesha khan` | `Ayesha Khan` |
| `MUHAMMAD umar` | `Muhammad Umar` |
| `zain` | `Zain` |
| `END` | sentinel |

Register: 4 rows. Most common first name: `Muhammad` (2).

**Student tasks.**
1. The per-word Title-Case machine — first-char-of-word boundary detection ([E11's previous-char idea](exercises.md#s11--acronym), inverted).
2. Array storage + count; the register loop with `setw(3)`.
3. Most-common-first-name: nested comparison over the *first words* — extract first word per name ([S17's split](exercises.md#s17--split)), then the O(n²) champion scan ([C6's method](challenges.md#solutions-approaches--key-code)).

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <iomanip>
#include <cctype>            // the title-case machines call toupper/tolower

std::string titleCaseWord(const std::string& w) {
    std::string out;
    for (int i = 0; i < w.length(); i = i + 1) {
        char c = w[i];
        if (i == 0) c = toupper(c); else c = tolower(c);
        out += c;
    }
    return out;
}

std::string titleCaseName(const std::string& name) {
    std::string out, word;
    for (int i = 0; i <= name.length(); i = i + 1) {
        if (i == name.length() || name[i] == ' ') {
            out += titleCaseWord(word);
            if (i < name.length()) out += ' ';
            word = "";
        } else word += name[i];
    }
    return out;
}

std::string firstWord(const std::string& s) {
    std::size_t p = s.find(' ');
    return (p == std::string::npos) ? s : s.substr(0, p);
}

int main() {
    std::string names[100];
    int n = 0;
    std::string line;
    while (std::getline(std::cin, line) && line != "END" && n < 100) {
        names[n] = titleCaseName(line);
        n += 1;
    }
    for (int i = 0; i < n; i = i + 1)
        std::cout << std::setw(3) << (i + 1) << " | " << names[i] << '\n';

    std::string firsts[100];                       // first words, as-is (normalized)
    for (int i = 0; i < n; i = i + 1) firsts[i] = firstWord(names[i]);
    int best = 0; std::string bestName = "";
    for (int i = 0; i < n; i = i + 1) {
        int count = 0;
        for (int j = 0; j < n; j = j + 1)
            if (firsts[j] == firsts[i]) count += 1;
        if (count > best) { best = count; bestName = firsts[i]; }
    }
    std::cout << "total: " << n << '\n';
    if (best > 1) std::cout << "most common first name: " << bestName
                            << " (" << best << ")\n";
    else          std::cout << "no repeated first names\n";
}
```

**Explanation.** Three one-job helpers — titleCaseWord (per-word), titleCaseName (word accumulation over the name), firstWord (split) — compose into the batch job; that's the [functions-module](../functions/lesson-1-machine.md) discipline doing real work. The O(n²) champion is fine at n=100 and *honest* about being the simple tool. Trace `mUHAMMAD aLI`: word machine → `Muhammad` + `Ali` ✓. Tie policy: strict `>` keeps the first-seen champion — document it in your write-up.

**⭐ Extension.** Sort the register alphabetically before printing — selection sort over the name array ([Unit 10 preview](../syllabus.md): you've met selection sort's idea in the [arrays challenges](../arrays/challenges.md)).

---

## Lab 7 — Basic Text Statistics

**Scenario.** The toolkit's reporting front-end: one command that reads a text block and prints a statistical profile.

**Requirements.**
R1. Read lines until an empty line; accumulate *everything*: characters, letters, digits, spaces, punctuation, words, sentences (a sentence ends at `.`, `!`, or `?`), lines.
R2. Derived stats: average word length (1 dp), average words per line (1 dp), average sentence length in words (1 dp).
R3. The Flesch-reading-ease *simplification*: report average syllables-per-word approximated as **vowels-per-word** (count aeiou letters, case-insensitive, per word) to 2 dp — with a comment honestly labelling it an approximation, not the real formula.
R4. Graceful zero-division: empty input prints a single line `NO DATA`.

**Inputs / outputs.** In: text block, blank-line terminated. Out: the profile block (raw counts, then derived stats).

**Constraints.** One pass over the text plus per-line word machines (Lab 4's machinery). No storage.

**Test cases.**

Input:
```text
Hello world. C++ rocks!
Numbers: 42 and 7.
```
*(then a blank line to end input)*

**Expected** (hand-verified — the sums-must-add-up invariant checks it):

| Raw counts | Derived |
| ---------- | ------- |
| lines 2, chars 41, letters 26, digits 3, spaces 6, punct 6 | avg word length **4.4** |
| words 8, sentences 3, vowels 7 | avg words/line **4.0**, avg sentence length **2.7**, vowels/word **0.88** |

**Student tasks.**
1. Compose Lab 4's accumulators with Lab 3's classifier — you're building the *pipeline*, mostly from parts you already own.
2. The sentence counter: state machine — a sentence *ends* at a terminator; consecutive terminators (`!?`) must not double-count (count *transitions* from "inside" to "ended" — or count terminators that follow a non-terminator).
3. The vowel-per-word accumulator inside the word machine — one more per-word counter.
4. Verify your trace against the machine (see the corrected table in the solution's explanation).

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <cctype>
#include <iomanip>

int main() {
    int lines = 0, chars = 0, letters = 0, digits = 0, spaces = 0, punct = 0;
    int words = 0, wordChars = 0, vowels = 0, sentences = 0;

    std::string line;
    while (std::getline(std::cin, line) && !line.empty()) {
        lines += 1;
        chars += line.length();

        bool inWord = false;
        int curLen = 0;                        // length of the word being built
        for (int i = 0; i <= line.length(); i = i + 1) {
            if (i == line.length()) {          // virtual end: flush a trailing word only
                if (inWord) { words += 1; wordChars += curLen; inWord = false; }
            } else if (isspace(line[i])) {
                spaces += 1;                   // EVERY real space counts, exactly once
                if (inWord) { words += 1; wordChars += curLen; inWord = false; }
            } else {
                char c = line[i];
                if (!inWord) { inWord = true; curLen = 0; }
                curLen += 1;
                if (isalpha(c)) {
                    letters += 1;
                    char lc = tolower(c);
                    if (lc=='a'||lc=='e'||lc=='i'||lc=='o'||lc=='u') vowels += 1;
                } else if (isdigit(c)) digits += 1;
                else punct += 1;
            }
        }

        // sentence ends in THIS line: a terminator preceded by a non-terminator
        for (int i = 0; i < line.length(); i = i + 1) {
            char c = line[i];
            bool term = (c == '.' || c == '!' || c == '?');
            bool prevTerm = (i > 0) && (line[i-1]=='.' || line[i-1]=='!' || line[i-1]=='?');
            if (term && !prevTerm) sentences += 1;
        }
    }

    if (lines == 0) { std::cout << "NO DATA\n"; return 0; }
    std::cout << "lines=" << lines << " chars=" << chars
              << " letters=" << letters << " digits=" << digits
              << " spaces=" << spaces << " punct=" << punct << '\n';
    std::cout << "words=" << words << " sentences=" << sentences
              << " vowels=" << vowels << '\n';
    if (words > 0) {
        std::cout << std::fixed << std::setprecision(1)
                  << "avg word length: "    << (1.0 * wordChars / words) << '\n'
                  << "avg words per line: " << (1.0 * words / lines)     << '\n';
        if (sentences > 0)
            std::cout << "avg sentence length: "
                      << (1.0 * words / sentences) << " words\n";
        std::cout << std::setprecision(2)
                  << "vowels per word (approx syllables): "
                  << (1.0 * vowels / words) << '\n';
    }
}
```

**Explanation.** Three machines compose (each from an earlier lab):

- **Classifier** (Lab 3): every non-space char lands in exactly one of letters/digits/punct, and **every real space is counted exactly once** — spaces that *end* a word count too. The invariant `letters + digits + punct + spaces = chars` must hold; run it on the test input: 26 + 3 + 6 + 6 = 41 ✓. (A first draft of this very solution lost word-ending spaces — the invariant is not decoration; it's the bug detector.)
- **Word machine** (Lab 4): non-space runs are words; `curLen` accumulates each word's length and is flushed to `wordChars` when the word ends. The virtual-end space (the `i == length()` step) flushes the final word but must not count as a *real* space — note the `else { spaces += 1; }` branch only runs for actual spaces inside the line.
- **Sentence counter**: a terminator counts only when the previous char is *not* a terminator — a transition rule, so `!?` and `...` each count once.

Trace the test input against your machine before trusting the table: words are non-space runs (`Hello`, `world.`, `C++`, `rocks!`, `Numbers:`, `42`, `and`, `7.` → 8), so word length includes attached punctuation — that is the documented policy (state yours explicitly if you choose letters-only words; the numbers change, the method doesn't).

**⭐ Extension.** Add the longest word overall (compose Lab 4's champion in), and a *word count per sentence* report: walk the line tracking words since the last terminator — the state machine grows one more state.

---

# Lab index

| Lab | Focus | The one pattern it drills |
| --- | ----- | ------------------------- |
| 1 | Username validator | Predicate functions + first-failure ordering |
| 2 | Password checker | One flag per rule clause |
| 3 | Text analyzer | Classifier + run-champion state machines |
| 4 | Word counter | Per-line machines + global accumulators |
| 5 | Search tool | Reader choreography + normalize-then-find |
| 6 | Name processor | Helper composition + array batch processing |
| 7 | Text statistics | Full pipeline composition (all of the above) |

**After the labs:** [Text Analysis Toolkit](miniproject.md) — the mini-project that composes Labs 3, 4, 5, and 7 into one menu program.
