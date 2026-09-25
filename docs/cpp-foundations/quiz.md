---
title: "C++ Foundations — Self-Check Quiz"
description: "12 questions across the module. Attempt all before opening the answer key."
---

# C++ Foundations — Self-Check Quiz

> 12 questions · ~20 min · attempt **all** before the
> [answer key](quiz-answers.md) — it's a separate file on purpose ·
> [← Module home](index.md)

## Section A — Structure (Q1–Q3)

**Q1.** Which list names the four structural parts of a minimal C++
program in the order the *compiler* encounters them?

- a) statements → main → includes → return
- b) includes → functions (main among them) → statements → return
- c) main → includes → comments → return
- d) comments → statements → main → includes

**Q2.** A program contains two `main` functions. What happens?

- a) the first one runs
- b) the second one runs
- c) compile/link error — exactly one `main` per program
- d) both run in order

**Q3.** `return 0;` at the end of `main` means:

- a) the program used zero memory
- b) success — reported to the operating system
- c) the program has zero lines left
- d) it returns to the start of main

## Section B — Data (Q4–Q7)

**Q4.** Which identifier is **illegal** in C++?

- a) `totalMarks2`
- b) `_hidden`
- c) `2ndTotal`
- d) `MAX_MARKS`

**Q5.** The value `3.14` written in code is:

- a) a char literal
- b) a string literal
- c) a double literal
- d) invalid without a cast

**Q6.** After these two lines, what does `y` hold?

```cpp
int x = 5;
int y = x;
x = 99;
```

- a) 99 — y follows x
- b) 5 — assignment copies the value at that moment
- c) undefined — y is a reference
- d) 0

**Q7.** Why does the course write `const int PASS_MARK = 50;` rather than
using `50` in conditions?

- a) constants run faster in all cases
- b) the name carries meaning, one place to update, and accidental change
   becomes a compile error
- c) `const` values can be changed by the user
- d) it makes the program shorter

## Section C — Operators (Q8–Q10)

**Q8.** What does `std::cout << 7 / 2 << "\n";` print?

- a) 3.5
- b) 3
- c) 4
- d) won't compile

**Q9.** What does `std::cout << (2 + 3 < 5) + 1 << "\n";` print?

- a) 6
- b) 1
- c) 0
- d) 5

**Q10.** After `int a = 5; int b = a++;` — what are `a` and `b`?

- a) a=5, b=5
- b) a=6, b=6
- c) a=6, b=5
- d) a=5, b=6

## Section D — Conversion & mistakes (Q11–Q12)

**Q11.** `double avg = static_cast<double>(total) / count;` with
`total = 17, count = 2` prints:

- a) 8
- b) 8.0
- c) 8.5
- d) 9

**Q12.** Which line contains a bug of the "assignment in a condition"
family?

- a) `if (marks == 50) { ... }`
- b) `if (marks = 50) { ... }`
- c) `if (marks >= 50) { ... }`
- d) `if (marks != 50) { ... }`

---

**When all 12 are answered:** open the
**[answer key](quiz-answers.md)** (separate file — attempt-first protocol),
mark yourself, and follow the bands: ≥ 11 continue; 8–10 revisit flagged
sections; ≤ 7 redo the [exercises](exercises.md) and
[predictions](predictions.md).

*[← Module home](index.md)*
