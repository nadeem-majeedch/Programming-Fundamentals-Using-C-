---
title: "Lesson 2 — Data: Variables & Types"
description: "Variables, identifiers, naming conventions, the basic types, constants, literals, and declaration/initialization/assignment."
---

# Lesson 2 — Data: Variables & Types

> ~90–120 min · [← Lesson 1](lesson-1-structure.md) · [Lesson 3 — Operations →](lesson-3-operators.md)

Nine concepts, one story: a program that *remembers*. Each concept:
explanation → syntax → example → explained → practice.

---

## 2.1 Variables

**Explanation.** A **variable** is a named box in memory that holds one
value of one type. Three properties fix a variable completely: **name**
(what you call it), **type** (what can go in the box), **value** (what's in
it right now — changeable). "Variable" because the value varies; the name
and type never do.

**Syntax.**

```cpp
type name;             // declaration: box created (value undefined!)
type name = value;     // declaration + initialization: box created AND filled
```

**Example.**

```cpp
// boxes.cpp — one box, three moments
#include <iostream>

int main() {
    int score = 10;           // box 'score' (int) created holding 10
    std::cout << score << "\n";   // 10

    score = 25;               // NEW value in the SAME box
    std::cout << score << "\n";   // 25

    score = score + 5;        // read the box, add 5, store back
    std::cout << score << "\n";   // 30
    return 0;
}
```

**Explained.** Line 1 declares `score` and initializes it to 10. Line 3 is
**assignment**: the right side (25) is placed into the existing box — the
old 10 is gone forever. Line 5 shows the fundamental pattern of all
programming: the right side is *evaluated first* (read `score` = 25, add 5
→ 30), then stored back. `score` on the left means "the box"; `score` on
the right means "the value inside".

**Practice.** [Exercise 9](exercises.md#part-b---predict-and-code-9-16) ·
[prediction P3](predictions.md#p3).

---

## 2.2 Identifiers

**Explanation.** An **identifier** is the name you give a variable (or
function, or constant). C++ has few rules and long habits.

**Rules (compiler-enforced):** letters, digits, underscore; **cannot start
with a digit**; cannot be a keyword (`int`, `return`, `while`…); case
sensitive (`total`, `Total`, `TOTAL` are three boxes).

**Example.**

```cpp
int marks2;      // ✓ digit allowed after first character
int _temp;       // ✓ underscore start is legal (avoid — see below)
int 2marks;      // ✗ error: cannot start with a digit
int my score;    // ✗ error: space not allowed
int return;      // ✗ error: keyword
```

**Explained.** The two-star rule: avoid leading underscores (reserved to
the implementation) and avoid names that *look* like keywords or library
names (`cout` as a variable is legal but chaos). If the compiler says
`expected unqualified-id` or a weird cascade, check the name first.

**Practice.** [Exercise 10](exercises.md#part-b---predict-and-code-9-16) —
fix a batch of illegal identifiers.

---

## 2.3 Naming conventions

**Explanation.** Conventions are *style law* — the compiler doesn't care;
your teammates (and future you) do. This course's standard, matching most
professional C++:

| Thing | Convention | Example |
| --- | --- | --- |
| variable | `camelCase`, meaningful | `totalMarks`, `taxRate` |
| constant | `UPPER_SNAKE_CASE` | `MAX_STUDENTS`, `PASS_MARK` |
| avoid | single letters (except loop counters), abbreviations nobody knows | `x`, `tm`, `t2` |

**Example.**

```cpp
// names.cpp — same program, two levels of readability
#include <iostream>

int main() {
    int a = 5, b = 7;             // legal… and meaningless
    std::cout << a + b << "\n";

    int samosaCount = 5;          // the way of the course
    int chaiCount   = 7;
    int orderTotal  = samosaCount * 25 + chaiCount * 15;
    std::cout << orderTotal << "\n";
    return 0;
}
```

**Explained.** Both halves compile; only the second half is *reviewable* —
you can check it against the problem (25 per samosa, 15 per chai) without
asking the author. Rule: **a name should say what the value means**, not
what type it is (`totalCount`, not `intCount`) nor where it sits
(`temp1`).

**Practice.** [Exercise 11](exercises.md#part-b---predict-and-code-9-16) ·
every lab grades this ([lab rubric](../grading.md#lab-rubric-all-labs)).

---

## 2.4 Integer types

**Explanation.** Integers are whole numbers — counts, scores, years. C++
offers several sizes; this course uses two:

| Type | Holds | Typical size | When to use |
| --- | --- | --- | --- |
| `int` | whole numbers, roughly ±2 billion | 4 bytes | the default whole-number type |
| `long long` | whole numbers, roughly ±9 quintillion | 8 bytes | when `int` genuinely overflows |

(`short`, `unsigned`, and friends exist — meet them in Unit 13. Until a
real overflow forces the topic, `int` it is.)

**Syntax / Example.**

```cpp
// ints.cpp
#include <iostream>

int main() {
    int students  = 120;          // count
    int celsius   = -4;           // negatives are fine
    long long big = 8000000000;   // 8 billion: exceeds int's range!
    std::cout << students << " " << celsius << " " << big << "\n";
    return 0;
}
```

**Explained.** `int` quietly *wraps around* past ~2.1 billion (a famous
silent-failure: 2 000 000 000 + 1 000 000 000 does **not** print 3 billion —
[challenge C8](challenges.md) makes you meet it). Until then: counts,
scores, years, money-in-whole-rupees → `int`.

**Practice.** [Exercise 12](exercises.md#part-b---predict-and-code-9-16) ·
[prediction P5](predictions.md#p5).

---

## 2.5 Floating-point types

**Explanation.** Fractional values — averages, percentages, distances — use
`double` (short for double-precision). One caution shapes this whole topic:
floating-point numbers are *approximations*; `0.1 + 0.2` is not exactly
`0.3`. Money gets stored in whole minor units (paisa/cents) when precision
matters; averages and physics get `double`.

**Syntax / Example.**

```cpp
// doubles.cpp
#include <iostream>

int main() {
    double average  = 78.5;
    double quotient = 7.0 / 2.0;      // 3.5 — decimal division
    int    wholeDiv = 7 / 2;          // 3   — integer division! (Lesson 3 §3.1)
    std::cout << average << "\n";     // 78.5
    std::cout << quotient << "\n";    // 3.5
    std::cout << wholeDiv << "\n";    // 3
    return 0;
}
```

**Explained.** The example is the fork in every beginner's road: `7.0 / 2.0`
sees a floating-point operand and gives 3.5; `7 / 2` sees two ints and
gives 3 — the fraction is *discarded* (truncated, not rounded). Lesson 3
§3.1 and Lesson 4 §4.1 build on this; for now burn in: **if either operand
is floating-point, the result is floating-point.**

**Practice.** [Exercise 13](exercises.md#part-b---predict-and-code-9-16) ·
[predictions P4, P6](predictions.md#p4).

---

<a name="26-characters"></a>
## 2.6 Characters

**Explanation.** A `char` holds **one** character — a letter, digit, or
symbol — in single quotes: `'A'`. Under the hood it's a small integer (the
character's code), which is why characters can be compared and (later)
shifted. `char` vs string distinction: `'A'` is one character; `"A"` is a
string of length 1 — different types, different quotes, no mixing.

**Syntax / Example.**

```cpp
// chars.cpp
#include <iostream>

int main() {
    char grade = 'A';
    char digit = '7';                 // a character that looks like a number
    std::cout << grade << "\n";       // A
    std::cout << digit << "\n";       // 7  (prints the character)
    std::cout << grade + 1 << "\n";   // 66 !! — char + int promotes to int
    return 0;
}
```

**Explained.** The last line is the character lesson in one output: adding
`1` to `'A'` yields **66** — the character's integer code ('A' is 65) plus
one. Characters *are* numbers wearing costumes; `char + 1` takes off the
costume. (Cast it back with `static_cast<char>(grade + 1)` → prints `'B'`
— Lesson 4 §4.2.) Also: digits-as-characters (`'7'`) are *not* the number
7 — `'7'`'s code is 55.

**Practice.** [Exercise 14](exercises.md#part-b---predict-and-code-9-16) ·
[prediction P7](predictions.md#p7).

---

## 2.7 Booleans

**Explanation.** A `bool` holds exactly two values: `true` or `false` — the
type of every comparison and every `if` condition (next lesson). Printing a
bool shows `1` or `0` by default.

**Syntax / Example.**

```cpp
// bools.cpp
#include <iostream>

int main() {
    bool passed = true;
    bool isEven  = (8 % 2 == 0);      // a comparison PRODUCES a bool
    std::cout << passed << "\n";      // 1
    std::cout << isEven << "\n";      // 1
    std::cout << (5 > 10) << "\n";    // 0
    return 0;
}
```

**Explained.** `8 % 2 == 0` asks "does 8 divided by 2 leave remainder 0?" —
the answer *is* a bool, stored in `isEven`. This is the bridge to
decisions: an `if` is just "is this bool true?". `true` prints as 1
(booleans are integers under the hood too) — read 1/0 fluently; Unit 04
shows the formatting trick to print `true`/`false` as words.

**Practice.** [Exercise 15](exercises.md#part-b---predict-and-code-9-16) ·
[prediction P8](predictions.md#p8).

---

<a name="28-strings-introductory"></a>
## 2.8 Strings (introductory)

**Explanation.** A `std::string` holds text of any length, in double
quotes: `"Ayesha"`. It comes from the header `<string>`, supports `+` for
joining (concatenation), and is measured with `.length()`. This course's
intro level: create, join, measure — text *processing* is Unit 11.

**Syntax / Example.**

```cpp
// strings.cpp
#include <iostream>
#include <string>                     // required for std::string

int main() {
    std::string firstName = "Ayesha";
    std::string lastName  = "Khan";
    std::string fullName  = firstName + " " + lastName;   // concatenation
    std::cout << fullName << "\n";                        // Ayesha Khan
    std::cout << fullName.length() << "\n";               // 11
    return 0;
}
```

**Explained.** `+` between strings glues them — including the single-space
string `" "` in the middle. `.length()` returns the character count (11 —
count to verify; `.size()` is a synonym). Note the header: `iostream`
alone is *not* guaranteed to fully provide `std::string` — include
`<string>` when you use it. (Why `std::` again? Same namespace as `cout` —
Lesson 1 §1.1's library idea.)

**Practice.** [Exercise 16](exercises.md#part-b---predict-and-code-9-16) ·
[prediction P9](predictions.md#p9).

---

<a name="29-constants"></a>
## 2.9 Constants

**Explanation.** A **constant** is a named value that *cannot* be changed
after initialization — `const` is the keyword. Anything that has a fixed
meaning in the problem (tax rate, pass mark, price) deserves a constant:
one definition, self-documenting name, compiler-enforced immutability.

**Syntax / Example.**

```cpp
// constants.cpp
#include <iostream>

int main() {
    const int PASS_MARK     = 50;
    const double SALES_TAX  = 0.17;

    int marks = 82;
    std::cout << "Pass mark: " << PASS_MARK << "\n";
    std::cout << "Tax on 1000: " << 1000 * SALES_TAX << "\n";

    // PASS_MARK = 40;             // ✗ error: assignment of read-only variable
    return 0;
}
```

**Explained.** `const` moves meaning into the name — `PASS_MARK` reads;
naked `50` doesn't. Try the commented line: the compiler *refuses*
(`assignment of read-only variable 'PASS_MARK'`) — mistakes that used to be
runtime surprises become compile errors. Constant naming is UPPER_SNAKE
(§2.3); every magic number in your labs should become one.

**Practice.** [Exercise 17](exercises.md#part-c---code-it-18-24) ·
[challenge C3](challenges.md).

---

## 2.10 Literals

**Explanation.** A **literal** is a value written directly in the code —
`25`, `3.14`, `'A'`, `true`, `"hello"`. Each literal has a type from its
*form*: whole digits → `int`; a decimal point or exponent → `double`;
single quotes → `char`; double quotes → string; `true`/`false` → `bool`.
Useful suffixes: `8LL` (long long), `2.5f` (float), `100'000'000` (digit
separators, C++14).

**Syntax / Example.**

```cpp
// literals.cpp
#include <iostream>

int main() {
    std::cout << 25        << "\n";   // int literal
    std::cout << 25.0      << "\n";   // double literal (prints 25)
    std::cout << '9' + 1   << "\n";   // char literal → 58 (code of '9' is 57!)
    std::cout << "9" "5"   << "\n";   // string literals glue: 95 (not 14!)
    return 0;
}
```

**Explained.** The example is a trap gallery. `'9' + 1` is *character*
arithmetic → 58, not 10. `"9" "5"` are adjacent **string** literals the
compiler concatenates → `95`, not 14. Same visible glyphs, three
completely different meanings — the *type lives in the literal's form*
(single vs double quotes, decimal point or not). When output surprises you,
ask: what type is each piece?

**Practice.** [Exercise 18](exercises.md#part-c---code-it-18-24) ·
[prediction P10](predictions.md#p10).

---

<a name="211-declaration-initialization-assignment"></a>
## 2.11 Declaration, initialization, assignment

**Explanation.** Three words, three moments:

| Term | Meaning | C++ |
| --- | --- | --- |
| **declaration** | create the box | `int total;` |
| **initialization** | create the box **and** give first value | `int total = 0;` |
| **assignment** | put a (new) value into an existing box | `total = 90;` |

An uninitialized variable holds *garbage* — reading it is undefined
behaviour. The course rule is absolute: **initialize at declaration,
always** (`-Wall` will warn you, warnings are must-fix).

**Syntax / Example.**

```cpp
// three-moments.cpp
#include <iostream>

int main() {
    int a;            // declaration only: a is GARBAGE right now
    // std::cout << a;   ✗ undefined — never read before first write

    int b = 0;        // initialization
    b = 7;            // assignment (b exists)
    b = b + 1;        // assignment, reading itself

    int c = b + 2;    // initialization FROM an expression (c = 10)
    std::cout << b << " " << c << "\n";   // 8 10
    return 0;
}
```

**Explained.** The three moments, in order: declare (danger zone — no
value), initialize (safe now), assign freely afterwards. Note assignment
*direction*: right side evaluated, then stored left (`b = b + 1` reads 7,
makes 8). Multiple variables of one type in one statement is legal —
`int x = 0, y = 0;` — but one-per-line wins the readability grade.

**Practice.** [Exercise 19](exercises.md#part-c---code-it-18-24) ·
[debugging D2](debugging.md#d2---the-garbage-value) (the garbage-value bug
in the wild).

---

## Check yourself (Lesson 2)

- [ ] I can name the three properties of a variable and follow the naming
      conventions
- [ ] I choose `int` vs `double` vs `char` vs `bool` vs `std::string`
      deliberately, and say why
- [ ] I write constants for every fixed meaning, UPPER_SNAKE
- [ ] I never read an uninitialized variable — every declaration initializes

**Next:** [Lesson 3 — Operations](lesson-3-operators.md): arithmetic,
comparisons, logic, and the precedence rules that decide everything.

*[← Lesson 1](lesson-1-structure.md) · [Module home](index.md)*
