---
title: "Challenge Problems (10)"
description: "Ten open challenges across the module's concepts — no published solutions; your tests are the judge."
---

# C++ Foundations — Challenges

> 10 open problems · ★ think · ★★ sweat a little · ★★★ sleep on it ·
> [← Module home](index.md)

No solutions are published — by design. Each challenge lists what
*self-verification* looks like: the tests or invariants that convince you
(and a reviewer) it works. Keep every attempt; wrong versions with a
diagnosis beat one magic correct version.

**C1 ★ — Annotated autobiography.** Write a program printing five lines
about you, where every statement carries a comment explaining *why* it
exists (not what it does). The verify step: hand it to a friend — can they
reconstruct the output from comments alone?

**C2 ★ — The constant catalogue.** Take any Scenario 1–5 solution from the
[Problem-Solving module](../problem-solving/scenarios-a.md) and convert
*every* magic number into a named constant. Verify: changing
`PRICE_CHAI = 15` to `18` must alter exactly the outputs it should — and
require zero other edits.

**C3 ★ — Naming tournament.** The same program written three times: once
with names `a, b, c`, once with `x1, x2, x3`, once with proper course
names. Then a comment block at the top: which version is checkable
against the problem statement, and what made the difference? (The grade
is the *explanation*, not the code.)

**C4 ★★ — The honest calculator.** Read two ints and print all four
operations, but with the division done **both** ways (integer and
decimal), each labelled. Verify with (7, 2), (−7, 2), (0, 5): your output
must explain *why* the two divisions differ — in printed words, not just
numbers.

**C5 ★★ — Digit autopsy.** Read one positive three-digit int. Using only
`/` and `%`, print its hundreds, tens, and ones digits — one per line.
Verify with 947 (→ 9, 4, 7) and the tricky pair 100 and 999; add 070
cases by trying 70 (a *two*-digit input — is that in your assumptions?
document what happens).

**C6 ★★ — Cast archaeology.** Write one program printing the Lesson 4
trio for *five* different (total, count) pairs: `total/count`,
`static_cast<double>(total)/count`, `static_cast<double>(total/count)`.
Verify: for every pair, output 2 and 3 must differ whenever `total % count
!= 0` — and your comment block must say why in one sentence.

**C7 ★★ — The accumulator race.** Starting from `x = 1`, apply: `x += 4;
x *= 3; x -= 7; x /= 2;` — predict on paper first. Then the challenge:
find *another* sequence of compound operations with the same five
operators that lands on the same final value, and prove both paths equal
by printing after every step. Verify: both traces agree line by line.

**C8 ★★★ — The overflow boundary.** Find — by experiment, not by copying —
the smallest positive `int` value `v` where `v + v` prints a *negative*
number. Then explain (in comments) what the real boundary must be
arithmetically, and why your experiment agrees or disagrees with the
theory. Verify: `long long` arithmetic at your found value must NOT
overflow — the pair of outputs is the proof.

**C9 ★★★ — The self-documenting receipt.** Rebuild the Problem-Solving
module's cafeteria bill ([lesson](../problem-solving/lesson.md#20-translating-a-problem-into-a-c-solution))
so that: every number is either input, a named constant, or a derived
variable with a comment; the service-charge boundary is expressed with a
constant `SERVICE_THRESHOLD`, not `500`. Verify: the four test cases from
the lesson pass *unchanged*, and swapping `SERVICE_THRESHOLD` to 600
changes only the boundary test's outcomes.

**C10 ★★★ — Teach the bug.** Choose three of Lesson 4's mistake gallery
(M1–M8). For each: write a program *containing* the mistake, record the
actual (wrong) output or compile error, then write the corrected version
in the same file (guarded by comments), and a one-sentence lesson in your
bug diary. Verify: a classmate reads only your *wrong* output and your
sentence — and can state the fix.

---

## How challenges are "graded"

| Rating | Evidence of done |
| --- | --- |
| ★ | runs clean, output matches your stated intent |
| ★★ | runs clean + the listed verify cases pass + a comment block explains the design/finding |
| ★★★ | runs clean + verify passes + the explanation would convince a sceptical classmate |

Record all ten in your bug diary / LAB-NOTES; the
[Capstone rubric's polish line](../grading.md#project-3--capstone-contact-management-system-week-16-100-points)
starts here — habits, not heroics.

*[← Module home](index.md) · [Lab](lab.md) · [Quiz](quiz.md)*
