---
title: "C++ Foundations — Quiz Answers"
description: "Answer key with explanations for the C++ Foundations self-check quiz."
---

# C++ Foundations — Quiz Answers

> The explanations are the lesson · [Quiz](quiz.md) · [Module home](index.md)

| Q | Answer |
| --- | --- |
| Q1 | b |
| Q2 | c |
| Q3 | b |
| Q4 | c |
| Q5 | c |
| Q6 | b |
| Q7 | b |
| Q8 | b |
| Q9 | b |
| Q10 | c |
| Q11 | c |
| Q12 | b |

---

**Q1 — b.** The compiler meets `#include` lines first (preprocessing),
then function definitions — `main` among them — whose statements execute
when the program runs, ending at `return`. (a) and (c) put includes after
use; (d) lists comments as a structural part — comments are *removed*
before compilation.

**Q2 — c.** "Exactly one `main`" is the contract; a second produces
`error: redefinition of 'int main()'`. Nothing runs — the build refuses.
(A linker error, formally: both definitions fight for the entry point.)

**Q3 — b.** `main`'s return value goes to the operating system; 0 is the
conventional success code. Nothing about memory or line counts.

**Q4 — c.** `2ndTotal` starts with a digit — the one identifier rule
beginners actually break. `_hidden` is *legal* (though discouraged by
convention); `MAX_MARKS` is a fine constant name.

**Q5 — c.** A literal with a decimal point is a `double`. `'3.14'` would
be an invalid char; `"3.14"` a string; no cast involved.

**Q6 — b.** Assignment copies the *value at that moment*. `y` is an
independent box; changing `x` afterwards never reaches it. (Linking is
what references do — a later-course idea.)

**Q7 — b.** The three benefits in one line: self-documenting name, single
update point, compile-time protection against accidental change. (a) is
false as a general claim; (c) is backwards; (d) is cosmetic.

**Q8 — b.** `7 / 2` sees two ints → integer division → 3, printed as 3.
(3.5 needs a cast or a decimal-point operand — Lesson 4's crown jewel.)

**Q9 — b.** Precedence: arithmetic before comparison → `(2+3) < (5+1)`
→ `5 < 6` → `true` → promoted to `1` → `1 + 1`… wait — check that again!
`true` is 1, so `1 + 1 = 2`? **No — re-read the expression:** it's
`(2 + 3 < 5) + 1`: `(2+3 < 5)` is `5 < 5` → **false** → `0`; `0 + 1` →
**1**. The printed answer is 1 — but if you computed `5 < 6` you parsed
the *outer* `+ 1` as inside the comparison. The expression as written has
`+ 1` *outside* the parentheses, so the comparison is `5 < 5`. This is
exactly why the course parenthesises everything: the answer key's job is
to make the parsing unambiguous — and this question is the drill.

**Q10 — c.** Postfix: `b` receives the *old* 5, then `a` becomes 6.
(`++a` would have given 6 and 6.)

**Q11 — c.** The cast happens **before** the division, so the division
runs in doubles: 17.0 / 2 = 8.5. (`8` would be uncast; `8.0` is cast-
after-the-fact; 9 is rounding — nothing rounds here.)

**Q12 — b.** `=` stores 50 (truthy) into `marks` and the condition is
always true — the assignment-in-condition bug, Lesson 4's M4. `-Wall`
warns; the fix is `==`.

---

**Scoring:** 1 point each. **11–12** → module complete: on to the
[Lab](lab.md) if not already done, then
[Unit 04](../syllabus.md#stage-b--control-flow). **8–10** → re-read the
flagged sections and retake tomorrow. **≤ 7** → redo
[exercises](exercises.md) + [predictions](predictions.md) +
[debugging](debugging.md) before retaking.
([bands](../assessment.md#self-scoring-bands))

*[← Quiz](quiz.md) · [← Module home](index.md)*
