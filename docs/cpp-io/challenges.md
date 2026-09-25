---
title: "Challenges — Open IO Problems"
description: "Ten challenge problems on output formatting, input handling, and the getline trap — difficulty-rated, no solutions."
---

# Challenges

> [← Module home](index.md) · [Labs →](labs.md)

Open problems — no solutions exist on these pages on purpose. Rate
yourself honestly: ★ warm-up · ★★ solid · ★★★ stretch. Every one is
answerable with this module plus the Foundations toolkit. When you solve
one, write the solution so a classmate could follow it — that *is* the
next level.

The standing rule:
[Try It Yourself](../problem-solving/index.md#try-it-yourself-before-looking-at-the-solution).

---

<a name="c1"></a>
**C1 ★ — The Multiplication Poster.** Ask for a number; print its times
table 1–10 as a perfectly aligned two-column table (factor width 3 right,
product width 6 right). No loops exist in your toolkit yet — ten output
statements are allowed; alignment is the point.

<a name="c2"></a>
**C2 ★ — The Fallback Receipt.** Read item, quantity, unit price (one
word, one int, one double); print a receipt with `fixed`/`setprecision`
money, a dot-filled line to a 30-character subtotal, and a grand total.
Money columns must survive the swap `Chai 3 40` → `Mango Shake 2 125.5`
without editing code.

<a name="c3"></a>
**C3 ★★ — The Echo Machine.** Read one line; print it back enclosed in
`>>> <<<`. Then read a second line; print it in reverse-word order. You
may split with `>>` in a loop, or use `find`/`substr` — or read words
until the line ends (think: how does `>>` behave at a newline?).

<a name="c4"></a>
**C4 ★★ — The Form That Cannot Be Filled Wrong.** Build the data-entry
part of Lab 1 (name, roll no, marks) such that *every* read survives the
user typing the fields on one line, on separate lines, or with junk
after numbers. Document the exact input formats your program tolerates,
in a comment header.

<a name="c5"></a>
**C5 ★★ — The Buffer Forensics Report.** Write a program that reads, in
order: `int`, `string` (word), `double`, `string` (line, cured), and
after **each** read prints what your paper model says the buffer holds
(you can't print the buffer itself — print your *claim*, then design
inputs that prove or disprove it). Deliverable: code + a filled trace
table + a one-paragraph verdict on where your mental model was wrong.

<a name="c6"></a>
**C6 ★★ — The Two Cures, Compared.** Implement the age-then-name program
three times: buggy, `ignore`-cured, `>> ws`-cured. Then craft **one**
input transcript where the two cures produce *different* visible results
(hint: junk after the number on the age line). Report the transcripts
and explain which cure is right for which promise.

<a name="c7"></a>
**C7 ★★ — The Silent Grand Total.** Read expenses until the user types a
negative number (sentinel — a borrowed loop is allowed), then print the
total money-formatted. The trap: your numeric loop uses `>>`, so the
newline left by the *last* expense is still there when you try to read
the final confirmation line. Design the interaction; cure the buffer;
show three test transcripts.

<a name="c8"></a>
**C8 ★★★ — The Teacher's Explainer.** Write (in Markdown, in your repo
notes) a one-page explanation of the `cin`/`getline` mixing trap aimed at
the student *one week behind you*: buffer diagrams, the table of readers
from [Lesson 3 §3.5](lesson-3-getline.md#35-whitespace-end-to-end), and
two worked transcripts. Test it on a classmate; revise where they got
lost.

<a name="c9"></a>
**C9 ★★★ — The Robust Ask.** Write `int askInRange(string prompt, int
lo, int hi)` — a function that prints the prompt, reads, rejects
non-numbers (fail/clear/ignore) and out-of-range values, and loops until
legal — then use it to build a 3-question "course rating" form. Functions
arrive officially in Unit 07; consider this the installation preview.
(Yes, this is a deliberate bridge forward.)

<a name="c10"></a>
**C10 ★★★ — The Column Test Suite.** Design and print a 4-column report
(name w12 left, roll w6 right, marks w5 right, grade w4 centre-by-hand)
for five hard-coded students whose name lengths are 4, 6, 9, 12, and 14
— the last one *must visibly overflow* column 1, and your write-up must
explain what overflow means for tables. Then swap in `setfill('.')` for
the marks column only, and explain what had to change.

---

*[← Module home](index.md) · [Labs →](labs.md)*
