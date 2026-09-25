---
title: "Lesson 1 — Two Ways to Hold Text"
description: "Characters, character arrays (C-strings), std::string, creation, input with >> and getline — and the conceptual comparison."
---

# Lesson 1 — Two Ways to Hold Text

> [← Module home](index.md) · Lesson 1 of 4 · [Lesson 2 — Measuring, indexing →](lesson-2-indexing-comparison.md)

## In this lesson you will learn

- what a `char` is — the atom of text
- what a **character array** (C-string) is — and the `'\0'` terminator that runs it
- what a **`std::string`** is — and why it fixes the C-string's problems
- creation and the two input styles (`>>` vs `getline`)
- which one this course uses, and when you'll still meet the other

---

## 1. The atom: `char`

A `char` holds **one character** — written in single quotes:

```cpp
char grade = 'A';
char digit = '7';        // a character, not the number 7
char newline = '\n';     // an escape character — one char, special meaning
```

The key fact: `'7'` is a *character* whose meaning is the glyph seven — it is **not** the number 7. (The conversion story is [Lesson 4 §3](lesson-4-conversions-mistakes.md#3-char-arithmetic--the-character-code-trick); for now: chars are tiny whole numbers wearing costumes.)

<a name="2-the-old-way--character-arrays-c-strings"></a>
## 2. The old way — character arrays (C-strings)

Before classes existed, C++ inherited C's answer: an **array of chars** with a marker at the end.

```cpp
char name1[10] = "Ayesha";       // character array — a C-string
```

```text
 name1
┌───┬───┬───┬───┬───┬───┬───┬────┬────┬────┐
│ A │ y │ e │ s │ h │ a │\0 │ ?  │ ?  │ ?  │
└───┴───┴───┴───┴───┴───┴───┴────┴────┴────┘
  [0]  [1]  [2]  [3]  [4]  [5]  [6]  (boxes 7-9 unused)
```

The `'\0'` — the **null terminator** — is the *official end-of-text marker*. Everything after it is ignored. The array is 10 boxes; the *string* is 6 characters, because the terminator says so.

**Everything about C-strings follows from that marker:**

| Task | How it works | The catch |
| --- | --- | --- |
| Length | scan until `'\0'` | the length isn't stored — it's *discovered* each time |
| Copy | `strcpy(dst, src)` | dst must be big enough — **no check** |
| Join | `strcat(dst, src)` | overflows silently if dst is small — **no check** |
| Compare | `strcmp(a, b) == 0` | `==` compares *addresses*, not text — the classic trap |

That last row is the famous one:

```cpp
char a[10] = "cat", b[10] = "cat";
if (a == b) { ... }          // compares the ARRAYS' addresses — false, always
if (strcmp(a, b) == 0) { ... }   // compares the TEXT — true
```

And the underlying danger: `strcpy`/`strcat` trust the caller absolutely. Write nine letters into a ten-box array with no terminator room and memory past the array gets overwritten — the same unchecked-bounds world as [Arrays Lesson 1 §6](../arrays/lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does), but triggered by *text*.

## 3. The modern way — `std::string`

`std::string` is a class (your first real meeting with one — [Stage E](../syllabus.md#stage-e-memory-and-objects-units-13-15) makes classes official) that wraps the character array and manages it:

```cpp
#include <string>

std::string name = "Ayesha";     // creation
```

What it fixes, point by point:

| Problem with C-strings | `std::string` answer |
| --- | --- |
| Length not stored | `name.length()` (or `.size()`) — instant |
| Fixed capacity | grows and shrinks by itself |
| Overflow-prone copy/join | `=` and `+` just work, safely |
| `strcmp` for equality | `==`, `<`, `>` compare text directly |
| Out-of-bounds unchecked | `.at(i)` *checks* and throws (§ [Lesson 3](lesson-3-find-modify.md)) |

And the concepts carry over: a `std::string` is still, underneath, **a row of chars with indices 0..length−1** — every traversal and index skill from [Arrays](../arrays/index.md) transfers directly. The [draw-the-boxes](index.md) habit applies to `"cat"` exactly as it did to `int` arrays.

**The conceptual difference in one sentence each:**

- A **character array** is a fixed row of boxes where the text ends at a `'\0'` marker — *you* manage the size, the terminator, and every operation.
- A **`std::string`** is a managed object that owns its row of boxes — it stores the length, resizes itself, and provides safe, named operations.

**Course standard: `std::string` everywhere** — C-strings appear here so you can (a) read old code and library signatures (`const char*` labels in [error messages](../getting-started/getting-started-lesson.md), C library functions), and (b) understand *what* `std::string` is managing for you.

## 4. Creation and initialization

```cpp
std::string s1;                    // empty — length 0
std::string s2 = "hello";          // from a literal
std::string s3("hello");           // same thing, constructor syntax
std::string s4 = s2;               // a real copy (independent — change one, other unaffected)
std::string s5(5, 'a');            // "aaaaa" — count, char
```

`s4 = s2` is worth a beat of silence: it copies the *text* — [the array-assignment trap](../arrays/lesson-1-basics.md#7-the-common-errors-gallery) doesn't exist here. Assignment is honest deep copy.

<a name="5-input--and--getline"></a>
## 5. Input — `>>` and `getline`

The two readers from [I/O Lesson 2–3](../cpp-io/lesson-2-cin.md) now meet their real purpose:

```cpp
std::string word, line;

std::cin >> word;                  // one WORD: stops at whitespace
std::getline(std::cin, line);      // one LINE: reads spaces, consumes the newline
```

| Input typed | `cin >> word` gets | `getline(cin, line)` gets |
| --- | --- | --- |
| `Ayesha Khan` | `Ayesha` | `Ayesha Khan` |
| `  spaced  ` | `spaced` (skips leading ws) | `  spaced  ` (keeps them) |
| *(empty Enter)* | waits for a word | `""` — an empty line |

The [mixing trap](../cpp-io/lesson-3-getline.md) is *the* practical hazard of combining them — `cin >> n;` leaves the newline; a following `getline` reads it as an empty line. The cures (`cin.ignore` / `cin >> ws`) are in [I/O Lesson 3 §4](../cpp-io/lesson-3-getline.md#33-the-cure--cinignore-after) and are assumed knowledge from here on.

**Which reader when:** `>>` for single words (usernames, codes); `getline` for anything with spaces (names, sentences, addresses). A name field must always be `getline` — `"Ayesha Khan"` is two words.

## 6. A complete first program

```cpp
// greet.cpp — creation, input, length
#include <iostream>
#include <string>

int main() {
    std::cout << "First name: ";
    std::string first;
    std::cin >> first;                       // a first name is one word

    std::cin.ignore(1000, '\n');             // clear the newline (mixing trap!)

    std::cout << "Full name: ";
    std::string full;
    std::getline(std::cin, full);            // a full name has spaces

    std::cout << "Hello, " << full << '\n'
              << "(first: " << first
              << ", " << full.length() << " characters in full)\n";
    return 0;
}
```

Run with `Ayesha` / `Ayesha Khan`: prints the greeting and `16 characters in full`. (Count them — spaces are characters.)

## Practice

- [Exercises 1–7](exercises.md) — creation, both readers, the two-ways comparison
- [Predictions 1–3](predictions.md)
- [Debugging 1–2](debugging.md) — both are Lesson-1 bugs
- [Lab 1](labs.md#lab-1--username-validator) after Lesson 2

## Key takeaways

- `char` = one character in single quotes; `'7'` ≠ `7`.
- A character array is a fixed row of chars ending at `'\0'` — length discovered, overflow unchecked, `strcmp` needed for equality (`==` compares addresses).
- `std::string` manages the row: stored length, self-sizing, safe `=`/`+`, text `==`, checked `.at()`.
- `>>` reads one word; `getline` reads one line — and the mixing trap is the price of mixing them.
- Course standard: `std::string`; C-strings understood so old code can be read.

→ Next: [Lesson 2 — Measuring, indexing, joining, comparing](lesson-2-indexing-comparison.md)
