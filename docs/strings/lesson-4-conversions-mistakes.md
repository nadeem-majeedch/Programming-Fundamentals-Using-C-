---
title: "Lesson 4 — Conversions and Mistakes"
description: "Converting between strings and numbers, char arithmetic and the character-code trick, and the common string mistakes gallery."
---

# Lesson 4 — Conversions and Mistakes

> [← Module home](index.md) · [← Lesson 3 — Find & modify](lesson-3-find-modify.md) · [Exercises →](exercises.md)

## In this lesson you will learn

- string ↔ number conversion, both directions — and validating before converting
- **char arithmetic** — the character-code trick that powers digit processing
- the common mistakes gallery

---

<a name="1-string-to-number--and-why-validation-comes-first"></a>
## 1. String to number — and why validation comes first

Text arrives as text — from `getline`, from files. Converting it to a number is a *decision* the program makes, and the safe order is **validate, then convert**:

```cpp
#include <string>

std::string text = "42";
int n = std::stoi(text);              // string-to-int  → 42
double d = std::stod("3.75");         // string-to-double → 3.75
```

`stoi` (and `stod`, `stol`, ...) parse leading numeric characters and **stop at the first non-digit**:

| input | `stoi` returns | the catch |
| --- | --- | --- |
| `"42"` | 42 | fine |
| `"  42abc"` | 42 | leading spaces skipped, **trailing junk ignored** |
| `"abc"` | — | **throws** (ends the program) — nothing numeric to parse |
| `""` | — | throws |

That middle row is the trap: `stoi("42abc")` silently succeeds. So the course order is:

```cpp
// validate-as-text, then convert — the reader-suite philosophy applied to strings
bool allDigits(const std::string& s) {
    if (s.empty()) return false;                 // empty is not a number
    for (int i = 0; i < s.length(); i = i + 1) {
        if (!isdigit(s[i])) return false;        // <cctype> doing its job
    }
    return true;
}
// call site:
if (allDigits(text)) n = std::stoi(text);
else                 std::cout << "Not a whole number.\n";
```

This is exactly the [<cctype> classification](lesson-3-find-modify.md#5-character-processing--cctype) pattern doing input validation — and it's the honest, no-exceptions way to build the robust readers your [toolkit](../functions/labs.md#lab-5--the-validation-suite) already uses.

## 2. Number to string

```cpp
std::string s = std::to_string(42);         // "42"
std::string t = std::to_string(3.75);       // "3.75"
std::string u = std::to_string(1234.5);     // "1234.500000" — note the digits!
```

`to_string` is direct and safe — the catch is formatting: doubles come out with six decimals. When *presentation* matters (`"Total: 3.75"`), format the number with the [<iomanip> tools](../cpp-io/lesson-1-cout.md#4-formatting-columns-setw-left-right-setfill) to a stream — or accept `to_string`'s fixed form for logs and keys. (For the labs: `to_string` for building lines, `iomanip` for the printed table.)

Both directions close the loop that [I/O Lesson 3](../cpp-io/lesson-3-getline.md) left open — "getline gives you the text `'17'`, conversion comes in Unit 11": here it is.

<a name="3-char-arithmetic--the-character-code-trick"></a>
## 3. Char arithmetic — the character-code trick

A `char` *is* a small whole number (its character code). `'7'` is not 7 — but the *distance* between digit chars is exactly the digit:

```cpp
char c = '7';
int digit = c - '0';          // 7 — THE conversion trick
int digit2 = c - 48;          // same thing, magic number — never write this
```

Why it works: `'0'` is 48, `'1'` is 49, ... `'9'` is 57 — consecutive codes. Subtracting `'0'` maps `'0'`→0 through `'9'`→9. It reads like what it does, which is why the course writes `c - '0'` and never the raw number.

The trick in action — converting a whole string of digits *by hand* (what `stoi` does inside):

```cpp
// "4729" → 4729, built digit by digit (the accumulator idiom on chars)
int value = 0;
for (int i = 0; i < text.length(); i = i + 1) {
    value = value * 10 + (text[i] - '0');
}
```

Trace `"472"`: 0 → 4 → 47 → 472. This is the [reverse-digits](../arrays/../repetition/exercises.md#s26--reverse-palindrome) accumulator wearing text — and it's the honest core of every [string-to-number](labs.md#lab-7--basic-text-statistics) exercise.

Letters have the same structure: `'a'`..`'z'` and `'A'`..`'Z'` are consecutive blocks, so `'a' - 'A'` is the exact distance between cases — which is *how `toupper`/`tolower` work inside*:

```cpp
char lower = c - ('a' - 'A');    // what tolower does for A-Z (the library call is still preferred)
```

One boundary to respect: this trick is for **consecutive ranges** (`'0'..'9'`, `'a'..'z'`). Arithmetic across cases like `'a' + 1` (gives `'b'`) is fine; assuming anything about *other* characters (spaces, punctuation) isn't.

<a name="4-the-common-mistakes-gallery"></a>
## 4. The common mistakes gallery

| # | Mistake | Signature symptom |
| --- | --- | --- |
| S1 | `==` on C-strings | always false — addresses compared, not text |
| S2 | Mixing `>>` and `getline` without `ignore` | getline "skips" — it reads the leftover newline |
| S3 | `substr(start, endIndex)` | one char too many/few — second arg is a **length** |
| S4 | `find` result used without the npos check | garbage index / silent wrong slice |
| S5 | `s[i]` with `i == length()` | out of bounds — last index is `length() - 1` |
| S6 | `erase` inside a forward loop | chars skipped as the tail shifts left |
| S7 | `"literal" + number` | compile error — needs a `std::string` side |
| S8 | Comparing `"10" < "9"` expecting numbers | lexicographic truth — convert first |
| S9 | `stoi` without validation | throws on junk; silently ignores `"42abc"` tail |
| S10 | Empty-string indexing (`s[0]` unchecked) | out of bounds on `""` — guard `empty()` first |

S2 and S6 deserve their micro-examples (both are [debugging exercises](debugging.md)):

```cpp
// S2 — the skip
int n; std::cin >> n;
std::string line; std::getline(std::cin, line);   // line == "" — the newline!
// fix: std::cin.ignore(1000, '\n'); between the two

// S6 — the skipping erase
for (int i = 0; i < s.length(); i = i + 1)
    if (s[i] == ' ') s.erase(i, 1);               // tail slides left; i++ skips
// fix: build a new string without spaces
```

## Practice

- [Exercises 20–26](exercises.md) — conversions, char arithmetic, gallery drills
- [Predictions 9–10](predictions.md)
- [Debugging 8–10](debugging.md)
- [Lab 7](labs.md#lab-7--basic-text-statistics) — text statistics

## Key takeaways

- Convert with `stoi`/`stod`/`to_string` — but validate-as-text first: `stoi` throws on junk and ignores trailing junk.
- `c - '0'` turns a digit char into its number; the digit codes are consecutive, and so are the letter cases.
- Ten named mistakes — S2 (the skip), S3 (substr length), and S6 (erase drift) are the trio that will meet you in the wild first.

→ Next: [Exercises](exercises.md) — then the [mini-project](miniproject.md).
