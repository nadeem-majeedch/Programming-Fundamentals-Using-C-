---
title: "Strings Exercises"
description: "26 progressive exercises — two ways to hold text, indexing and comparison, find/substr/cctype, conversions. Solutions separated at the end."
---

# Strings Exercises (26)

> [← Module home](index.md) · ★ = first pass · ★★ = needs the toolkit · ★★★ = combines ideas

**How to use this page.** Attempt 15 minutes before opening any [solution](#solutions-s1--s26). **Write out the boxes** — draw the string with indices — before coding anything that slices or indexes.

---

## Part A — Two ways, creation, input (★, E1–E7)

**E1.** Create three strings three ways: empty, from a literal, and as a copy of another. Change the original and prove the copy is independent (print both).

**E2.** Declare a character array holding `"cat"` and draw its boxes including the terminator — how many boxes does the *array* have vs the *string*? Then state what `a == b` compares for two such arrays, and the correct text comparison.

**E3.** Read a username with `>>` and a full name with `getline` in one program — insert the mixing-trap fix and explain in one comment line *why* it's needed. Test with `akhan` / `Ayesha Khan`.

**E4.** Read a line with getline and print: its length, its first char, its last char (careful: which index?), and the result of `empty()` for an empty input line.

**E5.** The five-sentence comparison drill — predict true/false for each, then verify:
(a) `"apple" == "Apple"` (b) `"app" < "apple"` (c) `"10" < "9"` (d) `"b" > "a"` (e) `"Zebra" < "apple"`.

**E6.** Build the string `"Unit-11!"` from pieces: start from `"Unit"`, `+=` the char `'-'`, `+=` the string `"11"`, `+=` the char `'!'`. Print at each step (four states).

**E7.** Read two words with `>>` and print them in dictionary order (the smaller first). Test with `pear apple` and `Apple apple` — the second pair needs one sentence of explanation.

---

## Part B — Indexing, traversal, concatenation (★★, E8–E13)

**E8.** Print a string one char per line with its index: `0: p` style. Then backward. Trace the backward loop's three parts (init/condition/update) in a table first.

**E9.** Count the vowels in a line (case-insensitive — tolower first). Trace on `"Arrays are Fun"` — expected 5.

**E10.** Count words in a line using the space-transition method (state machine): a word starts at a non-space preceded by a space or index 0. Test on `" one  two three "` — expected 3 (double spaces!).

**E11.** Build the acronym of a name: `"Ayesha Khan"` → `"AK"`. Rule: the first char, plus every char that follows a space. (Traversal + a previous-char variable.)

**E12.** Reverse a string by building a new one (backward traversal + `+=`), then check palindrome-ness against the original (compare content — `"mom"` yes, `"hello"` no).

**E13.** Concatenation drills — write the value and the verdict (works / compile error) for:
(a) `"a" + "b"` (b) `s + "b"` (s is a string) (c) `"Total: " + 5` (d) `s += '!'` (e) `"a" + s + "b"`.

---

## Part C — Find, substr, modify, cctype (★★, E14–E19)

**E14.** Find drills on `"the quick brown fox jumps over the lazy dog"`:
(a) index of `"fox"` (b) index of the *second* `"o"` (c) index of `"cat"` and the verdict it returns (d) index of `"the"` starting from index 5.

**E15.** Extract drills on `"Programming-Fundamentals"` — write the exact call and result:
(a) first 11 chars (b) chars from index 12 to the end (c) `"Fund"` (d) the last 11 chars *without* hard-coding the length (use `length()`).

**E16.** The substring-length trap: `text = "abcdef"`. What are `text.substr(1, 3)`, `text.substr(1, 2)`, `text.substr(3, 99)`, and which of the three *clips* silently?

**E17.** Split a line at its first space into first word and rest — with the no-space guard. Test on `"hello world"`, `"oneword"`, and `""`.

**E18.** Normalize a name: read `"  aYeSha kHAN  "` style input (well — read any line) and produce `"AyeshA KHAN"`-style output... precisely: lowercase everything except the first char of the line, which becomes uppercase. (Build-new + cctype.)

**E19.** Insert/erase/replace drills on `"hello world"` — state the result after each *sequential* step:
(a) `insert(5, ",")` (b) `erase(0, 7)` (c) `replace(0, 1, "J")` — then explain why doing these in the *reverse* order on fresh copies gives a different result.

---

## Part D — Conversions and integration (★★–★★★, E20–E26)

**E20.** `stoi` drills — result or behaviour for: `"42"`, `" 42abc"`, `"-17"`, `"3.9"`, `"abc"`, `""`. Which two need validation *before* the call, and what does each look like?

**E21.** Write `bool allDigits(const std::string& s)` ([Lesson 4 §1](lesson-4-conversions-mistakes.md#1-string-to-number--and-why-validation-comes-first)) and a driver testing `""`, `"123"`, `"12a3"`, `" 12"`. Then use it to make a *safe* `toInt` that returns −999 on junk (documented sentinel).

**E22.** Char-arithmetic drills: (a) `'8' - '0'` (b) `'b' - 'a'` (c) what does `'A' + 2` give? (d) convert the digit chars `"2051"` to the int 2051 with the `* 10 + (c - '0')` accumulator — trace three steps.

**E23.** Digit-sum of a numeric *string*: `"4729"` → 22, one pass, no `stoi`. Then: what changes if the string might contain a minus sign? (State the policy; handle it.)

**E24.** Caesar cipher (the [syllabus](../syllabus.md) Unit 11 challenge): shift each letter by 3, wrapping z→c, preserving case, leaving non-letters alone: `"Hello, World!"` → `"Khoor, Zruog!"`. Build-new + cctype + the wrap trick (`(c - 'a' + 3) % 26 + 'a'` — derive it on paper first).

**E25.** The [S24-style](exercises.md) robust reader returns: write `readIntInRange(prompt, lo, hi)` that reads a *line* with getline, validates with `allDigits` (then `stoi`), re-prompts on junk or range miss — the string-based reader your toolkit has been waiting for. Feed it `abc`, `150`, `12` in the test.

**E26.** Gallery drills — name the mistake (S1–S10) in each:
(a) `if (name1 == name2)` where both are `char[20]`
(b) `cin >> n; getline(cin, line);`
(c) `s.substr(2, 5)` intended as "from index 2 to index 5"
(d) `size_t p = s.find('x'); cout << s[p];`
(e) `for (i = 0; i < s.length(); i++) if (s[i] == 'a') s.erase(i, 1);`

---

<a name="solutions-s1--s26"></a>
# Solutions (S1–S26)

<a name="s1--three-creations"></a>
## S1 — Three creations

```cpp
std::string a;                       // empty
std::string b = "origin";            // literal
std::string c = b;                   // independent copy
b = "changed";
// prints: a="" (len 0), b="changed", c="origin"
```
`c = b` copied the *text* — assignment is deep for strings (the array-`=` trap doesn't exist here).

<a name="s2--char-array-boxes"></a>
## S2 — Char-array boxes

`char a[6] = "cat";` — array: **6 boxes** (`c a t \0` + 2 unused); string: **3 chars** (ends at the terminator). `a == b` compares *array addresses* — always false for two separate arrays ([gallery S1](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery)); the text comparison is `strcmp(a, b) == 0`.

<a name="s3--mixed-readers"></a>
## S3 — Mixed readers

```cpp
std::string user, full;
std::cin >> user;
std::cin.ignore(1000, '\n');   // mixing-trap fix: eat the newline >> left behind
std::getline(std::cin, full);
```
Without the ignore, getline reads that leftover newline as an empty line — [gallery S2](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery).

<a name="s4--line-report"></a>
## S4 — Line report

```cpp
std::getline(std::cin, line);
if (line.empty()) { std::cout << "empty\n"; return 0; }
std::cout << line.length() << ' ' << line[0] << ' '
          << line[line.length() - 1] << ' ' << line.empty() << '\n';
```
Last index = `length() - 1` — the [bounds rule](lesson-2-indexing-comparison.md#2-indexing--a-string-is-a-row-of-chars); the emptiness guard before `line[0]` is [gallery S10](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery).

<a name="s5--comparisons"></a>
## S5 — Comparisons

(a) **false** (case) · (b) **true** (prefix smaller) · (c) **true** (`'1' < '9'` — lexicographic!) · (d) **true** · (e) **true** (`'Z'` 90 < `'a'` 97). Rules: [Lesson 2 §4](lesson-2-indexing-comparison.md#4-comparison--the-lexicographic-rules).

<a name="s6--build-unit-11"></a>
## S6 — Build "Unit-11!"

`"Unit"` → `"Unit-"` → `"Unit-11"` → `"Unit-11!"`. Each `+=` appends — a char or a string, both legal (a `std::string` is on the left, so `+=` never has the [literal-trap](lesson-2-indexing-comparison.md#3-concatenation--building-text) problem).

<a name="s7--dictionary-order"></a>
## S7 — Dictionary order

```cpp
if (a <= b) std::cout << a << ' ' << b << '\n';
else        std::cout << b << ' ' << a << '\n';
```
`pear apple` → apple, pear. `Apple apple` → `Apple apple` — already in order *because* `'A' < 'a'`: uppercase sorts before lowercase in code order. One sentence: lexicographic comparison is code-based, not case-blind.

<a name="s8--per-line"></a>
## S8 — Per line

```cpp
for (int i = 0; i < n; i = i + 1) std::cout << i << ": " << s[i] << '\n';
for (int i = n - 1; i >= 0; i = i - 1) std::cout << i << ": " << s[i] << '\n';
```
Backward: init `n-1` (last valid), condition `i >= 0`, update `i -= 1` — the [backward traversal](../arrays/lesson-1-basics.md#4-traversal--the-visit-every-box-loop) unchanged for text.

<a name="s9--vowels"></a>
## S9 — Vowels

```cpp
int vowels = 0;
for (int i = 0; i < line.length(); i = i + 1) {
    char c = tolower(line[i]);
    if (c=='a'||c=='e'||c=='i'||c=='o'||c=='u') vowels += 1;
}
```
`"Arrays are Fun"` → a,a,e,u (lowercased a,r,r,a,y,s… contains a,a,a,e,u) — count: **5** ✓ (a-A-r-r-a-y-s = a,a,a? trace honestly: A→a ✓, r, r, a ✓, y, s, a ✓, r, e ✓, F, u ✓, n → 5).

<a name="s10--words"></a>
## S10 — Words

```cpp
int words = 0;
bool inWord = false;
for (int i = 0; i < line.length(); i = i + 1) {
    bool isSpace = isspace(line[i]);
    if (!isSpace && !inWord) words += 1;
    inWord = !isSpace;
}
```
`" one  two three "`: transitions at indices 1, 6, 10 → **3** ✓. The double-space is handled by the state machine — `inWord` blocks a second count while inside a word.

<a name="s11--acronym"></a>
## S11 — Acronym

```cpp
std::string acronym;
if (!name.empty()) acronym += name[0];
for (int i = 1; i < name.length(); i = i + 1) {
    if (isspace(name[i - 1]) && !isspace(name[i])) acronym += name[i];
}
```
`"Ayesha Khan"` → `A` … `K` → `"AK"`. The previous-char variable (`name[i-1]`) is the boundary detector — [E10](#s10--words)'s method with a build instead of a count.

<a name="s12--reverse-palindrome"></a>
## S12 — Reverse, palindrome

```cpp
std::string rev;
for (int i = line.length() - 1; i >= 0; i = i - 1) rev += line[i];
if (rev == line) std::cout << "palindrome\n";
```
`"mom"` → rev `"mom"` == original ✓; `"hello"` → `"olleh"` ≠. (Case-sensitive here — `"Mom"` fails; a normalization pass is the [E18](#s18--normalize) trick.)

<a name="s13--concat-drills"></a>
## S13 — Concat drills

(a) **compile error** — no string operand. (b) works. (c) **compile error** — literal + int ([S7 trap](lesson-2-indexing-comparison.md#3-concatenation--building-text); fix: `std::to_string(5)`). (d) works — `+=` with a char. (e) works — left-to-right: `"a" + s` is string+string, then `+ "b"` fine.

<a name="s14--find-drills"></a>
## S14 — Find drills

(a) **16** · (b) first `'o'` at 12 (`brown`), second: `find('o', 13)` → **17** (`fox`) — the start-index overload · (c) `"cat"` → **npos** (absent) · (d) `find("the", 5)` → **31** — skipping the index-0 hit.

<a name="s15--substr-drills"></a>
## S15 — Substr drills

(a) `substr(0, 11)` → `"Programming"` · (b) `substr(12)` → `"Fundamentals"` · (c) `substr(12, 4)` → `"Fund"` · (d) `substr(text.length() - 11)` → `"Fundamentals"` (computed, not hard-coded).

<a name="s16--length-trap"></a>
## S16 — Length trap

`substr(1, 3)` → `"bcd"` (3 chars from 1) · `substr(1, 2)` → `"bc"` · `substr(3, 99)` → `"def"` — **this one clips** silently: start 3 valid, length clipped to what exists ([Lesson 3 §2](lesson-3-find-modify.md#2-substr--the-extraction-machine)).

<a name="s17--split"></a>
## S17 — Split

```cpp
std::size_t sp = line.find(' ');
if (sp == std::string::npos) { first = line; rest = ""; }
else { first = line.substr(0, sp); rest = line.substr(sp + 1); }
```
`"hello world"` → `hello`/`world` · `"oneword"` → `oneword`/`` · `""` → ``/`` — all three guarded.

<a name="s18--normalize"></a>
## S18 — Normalize

```cpp
std::string out;
for (int i = 0; i < line.length(); i = i + 1) {
    char c = tolower(line[i]);
    if (i == 0) c = toupper(c);
    out += c;
}
```
Build-new, classify-convert per box — first char uppercased at the one special index.

<a name="s19--modify-sequence"></a>
## S19 — Modify sequence

(a) `"hello, world"` · (b) from that, erase(0,7) → `"world"` · (c) replace(0,1,"J") → `"Jorld"`. Reversed order on fresh copies: replace first gives `"Jello world"`; then erase(0,7) → `"orld"`; then insert(5, ",") → `"orld,"`... — order matters because each edit re-indices the string; there is no "same position" across edits.

<a name="s20--stoi-drills"></a>
## S20 — stoi drills

`"42"`→42 · `" 42abc"`→**42** (leading ws skipped, junk tail ignored — the silent one) · `"-17"`→−17 (sign handled) · `"3.9"`→**3** (stops at `'.'`!) · `"abc"`→**throws** · `""`→**throws**. The last two need validation first ([Lesson 4 §1](lesson-4-conversions-mistakes.md#1-string-to-number--and-why-validation-comes-first)).

<a name="s21--alldigits"></a>
## S21 — allDigits + safe toInt

```cpp
bool allDigits(const std::string& s) {
    if (s.empty()) return false;
    for (int i = 0; i < s.length(); i = i + 1)
        if (!isdigit(s[i])) return false;
    return true;
}
int toInt(const std::string& s) {          // documented sentinel: -999 = junk
    return allDigits(s) ? std::stoi(s) : -999;
}
```
Driver: `""`→false, `"123"`→true, `"12a3"`→false, `" 12"`→**false** (the space fails isdigit — stricter than stoi, which skips leading ws: a *policy* decision, documented).

<a name="s22--char-arithmetic"></a>
## S22 — Char arithmetic

(a) `8` · (b) `1` · (c) `'C'` (code 65+2) · (d) `""`→0; `'4'`: 0×10+4 = 4; `'7'`: 4×10+7 = 47; `'2'`: 47×10+2 = **472**.

<a name="s23--digit-sum-string"></a>
## S23 — Digit sum of a string

```cpp
int sum = 0;
for (int i = 0; i < text.length(); i = i + 1)
    if (isdigit(text[i])) sum += text[i] - '0';
```
`"4729"` → **22**. Minus sign policy: skip non-digits (the `isdigit` guard) — `"−17"` contributes 1+7=8; document that as "digit sum", not "numeric value" — they're different questions ([E23's honesty point](exercises.md)).

<a name="s24--caesar"></a>
## S24 — Caesar

```cpp
for (int i = 0; i < text.length(); i = i + 1) {
    char c = text[i];
    if (islower(c))      c = (c - 'a' + 3) % 26 + 'a';
    else if (isupper(c)) c = (c - 'A' + 3) % 26 + 'A';
    out += c;                              // non-letters pass through
}
```
Derivation: map to 0–25 (`c - 'a'`), shift, wrap (`% 26`), map back. `"Hello, World!"` → **`"Khoor, Zruog!"`** ✓ (H→K, e→h, l→o, o→r; comma/space untouched).

<a name="s25--string-reader"></a>
## S25 — String-based reader

```cpp
int readIntInRange(const char* prompt, int lo, int hi) {
    while (true) {
        std::cout << prompt;
        std::string line;
        std::getline(std::cin, line);
        if (allDigits(line)) {
            int v = std::stoi(line);
            if (v >= lo && v <= hi) return v;
            std::cout << "Between " << lo << " and " << hi << ".\n";
        } else {
            std::cout << "Whole numbers only.\n";
        }
    }
}
```
Feed `abc` → "Whole numbers only." · `150` → range message · `12` → accepted. Survives *everything* — the getline+cctype combination has no fail-state to clear (no [stream flag dance](../cpp-io/lesson-2-cin.md#25-when-input-goes-wrong-fail-clear-ignore) needed at all — that's why professionals convert from lines).

<a name="s26--gallery-drills"></a>
## S26 — Gallery drills

(a) **S1** — C-string `==` · (b) **S2** — the skip (needs ignore) · (c) **S3** — second arg is length; `substr(2, 3)` is "2 to 5" · (d) **S4** — npos unchecked · (e) **S6** — erase drift (build-new instead).
