---
title: "Lesson 3 — Finding, Cutting, Changing"
description: "find and npos, substr (length, not index!), insert/erase/replace, and character processing with <cctype>."
---

# Lesson 3 — Finding, Cutting, Changing

> [← Module home](index.md) · [← Lesson 2 — Indexing](lesson-2-indexing-comparison.md) · [Lesson 4 — Conversions →](lesson-4-conversions-mistakes.md)

## In this lesson you will learn

- **searching** with `find` — and the `npos` "not found" value
- extracting with **`substr`** — the length-not-index rule
- **modification**: `insert`, `erase`, `replace`
- **character processing** with `<cctype>`: classify and convert char by char

---

<a name="1-find--the-search-machine"></a>
## 1. `find` — the search machine

```cpp
std::string text = "the quick brown fox";

std::size_t pos = text.find("quick");     // 4 — index where the match STARTS
pos = text.find("slow");                  // npos — the "not found" answer
pos = text.find('o');                     // 13 — a char version exists too
pos = text.find("o", 14);                 // 17 — search STARTING from index 14
```

`find` returns the **starting index of the first match** — or `std::string::npos` ("no position"), a special constant meaning *absent*. The test is mandatory:

```cpp
if (text.find("quick") != std::string::npos) {
    std::cout << "found\n";
}
```

`npos` is why: it's the largest possible value of its type — converting it to `int` yields −1, but comparing directly against `std::string::npos` is the honest test (the [search-miss discipline](../arrays/lesson-2-classic-passes.md#1-linear-search--the-find-machine) from arrays, wearing a library type).

**All-matches scan** — find from the last hit + 1, until npos:

```cpp
std::size_t p = text.find("o");
while (p != std::string::npos) {
    std::cout << "o at " << p << '\n';
    p = text.find("o", p + 1);
}
```

(The count-a-char job is often cleaner *char by char* — §5.)

<a name="2-substr--the-extraction-machine"></a>
## 2. `substr` — the extraction machine

```cpp
std::string text = "Programming";

// substr(start, LENGTH) — length, NOT end index!
std::string a = text.substr(0, 7);     // "Program"  — 7 chars from index 0
std::string b = text.substr(3);        // "gramming"  — from 3 to the end
std::string c = text.substr(3, 4);     // "gramm"
```

**The rule that prevents the classic bug: the second argument is a *length*, not an ending index.** `substr(0, 7)` takes seven chars; `substr(0, 7)` ≠ `substr(0, index 7)`. The two student questions to ask every time:

1. *Where does it start?* (index)
2. *How many chars?* (length — compute it: `endIndex - startIndex`)

Bounds: `start` must satisfy `start <= length()`; the length is **clipped** — `text.substr(9, 99)` quietly yields `"ng"` rather than erroring. Generous clipping for substr, hard checking for `.at()` — know which library call forgives and which enforces.

### The splitting pattern

`find` + `substr` compose into the fundamental text operation — *splitting*:

```cpp
// first word of a line
std::string line = "Ayesha Khan 92";
std::size_t space = line.find(' ');
std::string firstWord = line.substr(0, space);            // "Ayesha"
std::string rest      = line.substr(space + 1);           // "Khan 92"
```

Guard the no-space case (`space != npos`) before slicing — a [Lab 5](labs.md#lab-5--the-simple-search-tool) workhorse.

<a name="3-modification--insert-erase-replace"></a>
## 3. Modification — insert, erase, replace

```cpp
std::string s = "hello world";

s.insert(5, ",");          // "hello, world"  — put text AT index 5
s.erase(5, 1);             // "hello world"   — remove LENGTH chars from index 5
s.erase(5);                // "hello"         — from index 5 to the end
s.replace(0, 5, "Howdy");  // "Howdy world"   — LENGTH chars from 0 become the new text
```

All three change the string **in place** and shift the tail — which means **indices after the edit point go stale**. The single most common modification bug:

```cpp
// BUG: erase inside a forward loop skips the char after each removal
for (int i = 0; i < s.length(); i = i + 1) {
    if (s[i] == ' ') s.erase(i, 1);      // erases; the next char slides INTO i; i++ skips it
}
```

The fixes, in order of preference: **build a new string** (the course idiom — §5's filter pattern), or walk backward when erasing in place. Length also changes with every edit — any stored length or cached end-index must be re-derived, not remembered.

## 4. `getline` + string methods — one loop

Composing the unit so far — the analyze-a-line skeleton:

```cpp
std::string line;
while (std::getline(std::cin, line) && !line.empty()) {
    std::cout << line.length() << " chars, first '" << line[0] << "'\n";
}
```

`getline` returns the stream; the loop reads lines until an empty one — the text cousin of the [sentinel loops](../repetition/lesson-3-break-continue-sentinels.md#4-sentinel-controlled-loops-properly) you own, and the exact shape [Unit 12's](../syllabus.md#stage-d-algorithms-and-data-units-10-12) file-reading loops take.

<a name="5-character-processing--cctype"></a>
## 5. Character processing — `<cctype>`

Many text questions are per-character questions. `<cctype>` provides the classifiers and converters:

| Function | Question / action |
| --- | --- |
| `isalpha(c)` | a letter? |
| `isdigit(c)` | a digit `0-9`? |
| `isupper(c)` / `islower(c)` | upper/lowercase letter? |
| `isspace(c)` | space/tab/newline? |
| `ispunct(c)` | punctuation? |
| `toupper(c)` | uppercase copy of c (unchanged if not a letter) |
| `tolower(c)` | lowercase copy of c |

The signature pattern — **classify, convert, build a new string**:

```cpp
// shout.cpp — uppercase everything (the filter idiom, string edition)
#include <iostream>
#include <string>
#include <cctype>

int main() {
    std::string line;
    std::getline(std::cin, line);

    std::string shouted;
    for (int i = 0; i < line.length(); i = i + 1) {
        shouted += toupper(line[i]);       // classify/convert, then BUILD
    }
    std::cout << shouted << '\n';
    return 0;
}
```

Why build-new rather than edit-in-place: no index staleness, no length drift, no direction worries — the [in-place traps](#3-modification--insert-erase-replace) simply don't apply. Course idiom for all transformations: **new string, box by box**.

Two more patterns worth naming:

**Counting** — a question per char plus a counter (vowel counts, digit counts — [Lab 3](labs.md#lab-3--text-analyzer)):

```cpp
int vowels = 0;
for (int i = 0; i < line.length(); i = i + 1) {
    char c = tolower(line[i]);
    if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') vowels += 1;
}
```

**Word boundaries** — a word's first char is a non-space *preceded by* a space (or index 0); detect transitions, not just chars ([Lab 4](labs.md#lab-4--the-word-counter)'s core):

```cpp
bool inWord = false;   // the [state machine](../repetition/challenges.md#c15--the-state-machine) you built in C15
// word starts when: !isspace(c) && !inWord  →  words += 1; inWord = true
// word ends when:   isspace(c) && inWord    →  inWord = false
```

## Practice

- [Exercises 14–19](exercises.md) — find, substr, modify, cctype
- [Predictions 7–8](predictions.md)
- [Debugging 5–7](debugging.md)
- [Lab 2](labs.md#lab-2--password-rule-checker) · [Lab 3](labs.md#lab-3--text-analyzer)

## Key takeaways

- `find` returns a start index or `npos`; the `!= std::string::npos` test is mandatory; start-index overloads power all-matches scans.
- `substr(start, length)` — **length, not end index**; start must be in range, length is clipped.
- `insert`/`erase`/`replace` shift tails and stale indices — prefer building new strings.
- `<cctype>` classifies and converts one char at a time; the course idiom is classify → convert → build.

→ Next: [Lesson 4 — Conversions and mistakes](lesson-4-conversions-mistakes.md)
