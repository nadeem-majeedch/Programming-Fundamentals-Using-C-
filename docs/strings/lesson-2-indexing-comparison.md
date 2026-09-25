---
title: "Lesson 2 — Measuring, Indexing, Joining, Comparing"
description: "length, indexing and traversal, concatenation, and comparison — the daily-driver string operations."
---

# Lesson 2 — Measuring, Indexing, Joining, Comparing

> [← Module home](index.md) · [← Lesson 1 — Two ways](lesson-1-two-ways.md) · [Lesson 3 — Find & modify →](lesson-3-find-modify.md)

## In this lesson you will learn

- `length()` / `size()` — and when an empty string matters
- **indexing** a string and **traversing** it char by char (plus the range-for preview)
- **concatenation** — `+`, `+=`, and the literal-on-the-left trap
- **comparison** — the lexicographic rules, case sensitivity, and `==`

---

## 1. `length()` — and the empty string

```cpp
std::string s = "hello";
std::cout << s.length() << '\n';     // 5
std::cout << s.size() << '\n';       // 5 — identical, two names, one job

std::string t;
std::cout << t.length() << '\n';     // 0 — empty is a real, safe state
if (t.empty()) { ... }               // the readable emptiness test
```

Length counts **every char including spaces and punctuation** — `"Ayesha Khan"` is 11. The empty string is legal and useful: getline returning `""` (an empty line), a search with no result, an accumulator of text that hasn't started.

<a name="2-indexing--a-string-is-a-row-of-chars"></a>
## 2. Indexing — a string is a row of chars

Exactly like the arrays you own:

```cpp
std::string word = "program";
//                  0123456   ← indices (length 7, last index 6)

char first = word[0];      // 'p'
char last  = word[6];      // 'm'  — or word[word.length() - 1]
word[0] = 'P';             // UPDATE a box — "Program"
```

The same [bounds](../arrays/lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does) law applies: valid indices are `0..length()-1`. `word[7]` on a length-7 string is out of bounds — `[]` doesn't check; `.at(7)` *does* (checked access — it ends the program with an exception rather than touching foreign memory; the safer default when an index's validity isn't proven):

```cpp
word.at(7);        // ends the program with a clear error — loud, not undefined
```

**Traverse char by char** — the workhorse of text processing:

```cpp
for (int i = 0; i < word.length(); i = i + 1) {   // note the int vs unsigned note below
    std::cout << word[i] << '-';
}
// p-r-o-g-r-a-m-
```

The course style keeps the counting loop you know. (The modern **range-for** — `for (char c : word)` — is a preview you may meet in later code; it means "visit every char". Both are fine; this unit drills the indexed form because [analyzers](labs.md) need *positions*, not just chars.)

### The signed/unsigned warning — one honest note

`word.length()` returns an *unsigned* type. Mixing it into signed arithmetic can produce warnings (e.g. `i < word.length() - 1` when the string is empty computes a huge positive number). Two defences, both course-legal:

- guard emptiness first (`if (word.length() > 0)` before any `length() - 1`), or
- compare with `int` as shown (the compiler converts; a warning may appear — silence it by casting: `i < static_cast<int>(word.length())`).

The [labs](labs.md) guard emptiness first — it's also the *logical* fix.

<a name="3-concatenation--building-text"></a>
## 3. Concatenation — building text

```cpp
std::string a = "data", b = "base";
std::string c = a + b;             // "database" — a NEW string
a += "base";                       // append onto a — now "database"
```

`+` makes a new string from two operands; `+=` appends in place. Both feel natural — with one genuine trap:

```cpp
std::string msg = "Total: " + 42;        // ❌ compile error — no + for literal + int
std::string msg = std::to_string(42);    // ✅ — conversion (Lesson 4)
std::string msg = "Total: " + std::string("(v2)");   // ✅ at least one std::string operand
```

**Rule: `+` needs a `std::string` on at least one side.** Two literals (or literal + number) don't chain — and the left-to-right evaluation order means the *first* addition is the one that fails: `"a" + "b" + s` errors even though `s` is a string.

<a name="4-comparison--the-lexicographic-rules"></a>
## 4. Comparison — the lexicographic rules

All six relational operators work, comparing **text, box by box, left to right**:

```cpp
std::string a = "apple", b = "apply";
if (a == b) { ... }        // false — differ at index 4
if (a <  b) { ... }        // true — 'e' (101) < 'y' (121)
```

The rules, in order of importance:

1. **`==` compares content** — no `strcmp` needed (the [C-string trap](lesson-1-two-ways.md#2-the-old-way--character-arrays-c-strings) is gone).
2. **Ordering is lexicographic (dictionary) order by character codes**: compare box by box; the first differing chars decide; a prefix is *smaller* than its extension (`"app" < "apple"`).
3. **Case matters**: `'A'` (65) < `'a'` (97) — so `"Zebra" < "apple"` is *true*, and `"Apple" == "apple"` is *false*. Case-insensitive comparison is a [character-processing](lesson-3-find-modify.md#5-character-processing--cctype) job (normalize both sides first).
4. **Digits sort by code**: `"10" < "9"` is *true* — `'1' < '9'` — numeric order is a *conversion* job ([Lesson 4](lesson-4-conversions-mistakes.md)), not a comparison job.

| Expression | Result | Why |
| --- | --- | --- |
| `"cat" == "cat"` | true | content equal |
| `"cat" != "Cat"` | true | case differs |
| `"app" < "apple"` | true | prefix smaller |
| `"10" < "9"` | true | `'1' < '9'` |
| `"Zebra" < "apple"` | true | `'Z' < 'a'` |

## 5. A complete worked program

```cpp
// initials.cpp — indexing + concatenation
#include <iostream>
#include <string>

int main() {
    std::string first, last;
    std::cout << "First name: ";
    std::cin >> first;
    std::cout << "Last name: ";
    std::cin >> last;

    std::string initials;
    initials += first[0];          // box 0 of each — the machine-grade answer
    initials += last[0];
    initials += '.';               // a char appends cleanly

    std::cout << "Initials: " << initials << '\n';      // e.g. "A.K."
    return 0;
}
```

Trace for `Ayesha` / `Khan`: initials = `""` → `A` → `AK` → `AK.`. Three appends, each reading one box — indexing and concatenation composing.

## Practice

- [Exercises 8–13](exercises.md) — measure, index, join, compare
- [Predictions 4–6](predictions.md)
- [Debugging 3–4](debugging.md)
- [Lab 1](labs.md#lab-1--username-validator) — username validator · [Lab 6](labs.md#lab-6--student-name-processor) — name processor

## Key takeaways

- `length()`/`size()` count every char; `empty()` is the readable zero test — guard before any `length() - 1`.
- Strings index and traverse exactly like arrays; `.at()` is the checked accessor.
- `+`/`+=` build text — a `std::string` must be on one side of each `+`.
- Comparison is content-based, lexicographic, case-sensitive, and *code-ordered* for digits — normalize or convert before comparing what you mean.

→ Next: [Lesson 3 — Finding, cutting, changing](lesson-3-find-modify.md)
