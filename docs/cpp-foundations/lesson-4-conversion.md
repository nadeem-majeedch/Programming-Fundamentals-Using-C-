---
title: "Lesson 4 — Type Conversion & Common Mistakes"
description: "How values change type: implicit conversion, explicit casting, and the data-type mistakes that cause real bugs."
---

# Lesson 4 — Type Conversion & Common Mistakes

> ~60–90 min · [← Lesson 3](lesson-3-operators.md) · [Module home](index.md)

Values change type constantly — on assignment, in mixed expressions, at
function boundaries. Most changes are silent and helpful; a few are silent
and *wrong*. This lesson makes the silent visible, then collects the
classic mistakes so you recognise them in the wild.

---

## 4.1 Type conversion — the landscape

**Explanation.** **Conversion** is the act of turning a value of one type
into another. It happens in three places: **assignment** (`int x = 3.7;`),
**mixed arithmetic** (`7 / 2.0`), and **function calls** (later). The
direction matters: widening (smaller → larger, e.g. `int` → `double`) is
safe; narrowing (larger → smaller, e.g. `double` → `int`) *loses
information*. C++ allows both — silently — which is why you must know the
rules even when the compiler doesn't complain.

**The three mechanisms this course names:**

| Mechanism | Who does it | When |
| --- | --- | --- |
| **implicit conversion** | the compiler, automatically | mixed expressions, assignment of compatible types |
| **explicit casting** | you, on purpose | when you *mean* the narrowing/change |
| **integer/floating promotion** | the compiler | small types inside arithmetic |

---

<a name="42-implicit-conversion"></a>
## 4.2 Implicit conversion

**Explanation.** **Implicit conversion** is the compiler changing a type
without being asked. The big rule: in `a op b`, if one operand is `double`
and the other `int`, the `int` is *promoted* to `double` **first**, then
the operation runs in doubles. On assignment the same: whatever the right
side produces is converted to the declared variable's type.

**Syntax / Example.**

```cpp
// implicit.cpp
#include <iostream>

int main() {
    double d = 5;             // 5 → 5.0        (widening: safe, silent)
    int    i = 9.7;           // 9.7 → 9        (narrowing: TRUNCATED, silent!)
    std::cout << d << " " << i << "\n";        // 5 9

    double avg = 3 + 4 / 2;   // ints first! 4/2=2, then 3+2=5 → 5.0
    double avg2 = (3 + 4) / 2.0;               // 7/2.0 → 3.5
    std::cout << avg << " " << avg2 << "\n";   // 5 3.5
    return 0;
}
```

**Explained.** Line 2 silently *truncates* 9.7 to 9 — no error, no warning
by default (`-Wconversion` exists but is noisy; the real defence is
awareness). The two averages are the lesson's crown jewels: `3 + 4 / 2`
runs **entirely in ints** (so 5), because `4 / 2` never saw a double;
`avg2` forces the division into double-land by making one operand `2.0`
→ 3.5. When an average comes out wrong by a whole number, this is why.
(Note `-Wall` *will* flag `int i = 9.7;` only if you enable extra
conversion warnings — so train the eye instead.)

**Practice.** [predictions P4, P6, P11](predictions.md#p4) ·
[debugging D6](debugging.md#d6---the-average-that-wasnt).

---

<a name="43-explicit-casting"></a>
## 4.3 Explicit casting

**Explanation.** An **explicit cast** says: *I* want this type change —
the human takes responsibility. The C++ style this course uses:

```cpp
static_cast<newType>(expression)
```

Read it as "make a newType-shaped copy of the expression's value". The
classic legit use: forcing decimal division from int operands —
`static_cast<double>(total) / count`. What it is *not* for: papering over
warnings you don't understand.

**Syntax / Example.**

```cpp
// casting.cpp
#include <iostream>

int main() {
    int total = 17;
    int count = 2;

    std::cout << total / count << "\n";              // 8    integer division
    std::cout << static_cast<double>(total) / count << "\n";  // 8.5 ✓
    // order matters: cast BEFORE the division, not after
    std::cout << static_cast<double>(total / count) << "\n";  // 8.0 — too late!

    char letter = static_cast<char>(65 + 1);         // int → char
    std::cout << letter << "\n";                     // B
    return 0;
}
```

**Explained.** The three divisions are the entire exam question. Line 1:
two ints → 8. Line 2: cast the *operand* — the division now happens in
doubles → 8.5. Line 3: cast the *result* — the truncation already happened
inside the int division; you dressed 8 in a double costume (8.0) and
changed nothing. **Cast before the operation, not after.** The `char` line
is Lesson 2 §2.6's promotion, reversed on purpose. (C-style casts
`(double)x` also compile; the course standardises on `static_cast` because
it's searchable and honest.)

**Practice.** [Exercise 23](exercises.md#part-c---code-it-18-24) (23's
cast pair) · [challenge C6](challenges.md).

---

## 4.4 Common data-type mistakes

The gallery — every one of these is a real bug that has cost a real
student a real evening. Collect the whole set in your bug diary.

**M1 — Integer division surprise.**

```cpp
double half = 1 / 2;          // 0.0, not 0.5 — ints divided, then converted
double half2 = 1.0 / 2;       // 0.5 ✓
```
*Defence:* a decimal point on one operand, or `static_cast<double>`.

**M2 — Truncation vs rounding.**

```cpp
int approx = 9.8;             // 9 — truncation (toward zero), NOT rounding
int rounded = 9.8 + 0.5;      // 10 — the manual round for positives
```
*Defence:* know that narrowing drops the fraction; add 0.5 *on purpose*
when rounding is meant (positives only — negatives differ).

**M3 — char vs int vs string confusion.**

```cpp
char d = '9';
int  n = d;                   // 57! the code, not the digit
int  m = d - '0';             // 9 ✓  the standard char-digit trick
std::cout << "9" + 1 << "\n"; // garbage pointer arithmetic — strings aren't chars
```
*Defence:* quotes tell the type — single = char (a number in a costume),
double = string (not arithmetic).

**M4 — Assignment in a condition.**

```cpp
if (marks = 50) { ... }       // stores 50, always true — marks destroyed
if (marks == 50) { ... }      // intended comparison
```
*Defence:* `-Wall` warns; read it. (Some teams write `50 == marks` — the
"yoda" guard; the course relies on warnings + care.)

**M5 — Overflow of int.**

```cpp
int big = 2000000000;
std::cout << big + big << "\n";   // NOT 4 billion — wraps negative!
long long ok = 2000000000LL + 2000000000LL;   // ✓ (note the LL suffix)
```
*Defence:* products of big counts (students × marks, area × prices) —
suspect overflow, use `long long` + `LL` literals.

**M6 — Uninitialized variable.**

```cpp
int total;                    // garbage inside
total += 5;                   // garbage + 5
```
*Defence:* initialize at declaration — Lesson 2 §2.11's absolute rule.

**M7 — bool/int mixing in output.**

```cpp
std::cout << (5 > 3) + 4 << "\n";   // 5 — true promoted to 1 silently
```
*Defence:* parentheses around comparisons; never rely on bool→int for
anything a human reads.

**M8 — Mixing `char` input with numbers** (a preview of Unit 03's
newline pitfall — named here so the symptom is recognised):

```cpp
int age; char grade;
std::cin >> age >> grade;     // if the user typed "18\nA", grade grabs '\n'? — see Unit 03
```
*Defence:* for now, read each `char` with `>>` and know a dedicated
lesson is coming; don't improvise.

**Practice for the whole gallery:** [debugging D2–D10](debugging.md) are
these mistakes, seeded and hint-laddered ·
[challenges C6, C8](challenges.md) make you *cause* M2/M5 deliberately.

---

## Check yourself (Lesson 4)

- [ ] I can trace `3 + 4 / 2` and `(3 + 4) / 2.0` and explain the difference
- [ ] I cast **before** the operation when I need decimal results
- [ ] I know truncation ≠ rounding, and the +0.5 trick and its limits
- [ ] `'9'`, `"9"`, and `9` are three different things — I can prove it
- [ ] I initialize everything, and suspect overflow on big products

**Module practice:** [24 exercises](exercises.md) ·
[10 predictions](predictions.md) · [10 debugging](debugging.md) ·
[10 challenges](challenges.md) · then the [Lab](lab.md) and [Quiz](quiz.md).

*[← Lesson 3](lesson-3-operators.md) · [Module home](index.md)*
