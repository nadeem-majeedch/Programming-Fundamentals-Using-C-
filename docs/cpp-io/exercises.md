---
title: "Exercises — C++ Input and Output"
description: "Twenty-four graded exercises: output basics, formatting, input basics, lines and getline, with answers to selected items."
---

# Exercises

> [← Module home](index.md) · [Answers to selected exercises](#answers-to-selected-exercises)

Graded: ★ routine · ★★ needs thought · ★★★ stretches. Code every ★ and ★★
before peeking at any answer — the
[try-first rule](../problem-solving/index.md#try-it-yourself-before-looking-at-the-solution).
Save files as `eNN_description.cpp` in your exercises folder
([naming convention](../getting-started/getting-started-lesson.md#19-how-students-should-save-their-exercises)).

---

<a name="e-output-basics-1-6"></a>
## E1–E6 · Output basics ★

**E1.** Print your name, then your city, on two lines — using a single
`cout` statement and `'\n'`. Then print the same thing using **three**
`cout` statements, where only the last ends a line.

**E2.** Print exactly this shape (no trailing spaces):

```text
*
**
***
```

**E3.** `int apples = 12; double price = 15.5;` — print
`12 apples cost 186 rupees` using one chained statement that *computes*
the 186 rather than typing it.

**E4.** Print the words `tab`, `sep`, `end` separated by tab characters
(`'\t'`), then print them separated by ` | ` — two lines total.

**E5.** Predict-then-verify: write a program that prints `A`, then
`std::endl`, then `B`, then `"\n"`, then `C`, then `'\n'` — as six
separate `<<` items. Your prediction first, compiler second.

**E6.** Print a 3-line "business card": name, one-line role, and a
fun-fact line, with a `=====` border line above and below (use whatever
border length you like — but keep it *consistent*).

---

<a name="e-formatting-9-12"></a>
## E7–E12 · Formatting ★★

**E7.** Print `7` and `1234` right-aligned in a column of width 6, then
left-aligned in width 6 — four lines total, pads visible in your
prediction.

**E8.** `double unit = 2.5; int qty = 6;` — print a receipt line:
`6 x 2.50 = 15.00`, where both money figures always show two decimals.

**E9.** Print the header `Item   Qty   Price` as three columns of width
8 (left, right, right), then one data row `Chai`, `3`, `90` beneath it.

**E10.** Using `setfill('.')`, print `Subtotal` left-aligned in width 16
and `450` right-aligned in width 8, so the gap fills with dots:
`Subtotal........450`.

**E11.** Show the difference between default and `fixed` formatting of
`double x = 2.0/3.0;` — print `x` twice: once before any manipulator,
once with `fixed << setprecision(4)`.

**E12.** A marks table: print three students (name width 12 left; marks
width 5 right) with names `Ayesha`, `Bilal`, `Chen` and marks `88`,
`61`, `95`. Header row included; columns must line up.

---

<a name="e-input-basics-13-18"></a>
## E13–E18 · Input basics ★★

**E13.** Ask for a whole number and print its square and its cube, e.g.
input `5` → `square 25, cube 125`. Prompts on their own line, answers
formatted as shown.

**E14.** Ask for two whole numbers and print their sum, difference, and
product on one line each — labels padded to width 10 with dots
(`Sum.......18`).

**E15.** Ask for width and height **in one prompt**; user may type `12 9`
or `12⏎9`. Print `Area: 108` either way. Then explain (comment in the
code) why both input styles work.

**E16.** Ask for a temperature and a unit letter (`C` or `F`); echo them
back exactly: `Reading: 37.5 C`. (No conversion yet — Lab 3 owns that.)

**E17.** Ask for an item name (one word) and a price; print
`3 x chai @ 40 = 120` style output for quantity 3. Name may contain no
spaces — say that constraint in your prompt.

**E18.** Copy the validation-loop pattern from
[Lesson 2 §2.5](lesson-2-cin.md#25-when-input-goes-wrong-fail-clear-ignore)
into a program that asks for a positive *even* number: reject non-numbers
by failure, reject odd numbers by… try it and see what happens without an
`if` inside the loop, then read the pattern again and fix it.

---

<a name="e-lines-19-24"></a>
## E19–E24 · Lines and `getline` ★★–★★★

**E19.** Read one whole line (a poem title with spaces) and print it in
quotes with its length: `"The Rime of the Ancient Mariner" (31 chars)`.

**E20.** Fix the trap: ask for an age (`>>`), then a full name. Your
first version must contain the bug on purpose (print what the name
variable holds to prove it), your second version must cure it with
`cin.ignore(1000, '\n')`, your third with `getline(std::cin >> ws, name)`.
Three files, three comments explaining the difference.

**E21.** Read an address in three lines (house/street, city, country)
with three `getline`s; print them as `house | city | country` on one
line.

**E22.** Read a one-word username (`>>`) and then a full display name
(`getline`, cured); print `[username] displays as [display name]`.

**E23.** **★★★** Read a full line, then print its first word, a
separator, and the *rest* of the line. (You may use `line.find(' ')` and
`line.substr(...)` — look them up, they are standard `string` tools, or
solve it with two reads: a word then a line.)

**E24.** **★★★** A two-item form: item name (may contain spaces), then
quantity. Input arrives name-first (`Chai 250ml⏎3⏎`). Print the order
line. Which reader gets which field, and what must you cure?

---

<a name="answers-to-selected-exercises"></a>
## Answers to selected exercises

<details markdown="1">
<summary><strong>E1, E3, E8, E13, E15, E20 — after your own attempt</strong></summary>

**E1.** Single statement:

```cpp
std::cout << "Nadeem\nLahore\n";
```

Three statements:

```cpp
std::cout << "Nadeem\n";
std::cout << "Lahore";
std::cout << "\n";
```

The point: a line ends wherever a `'\n'` (or `endl`) appears — statements
and lines are independent.

**E3.**

```cpp
std::cout << apples << " apples cost " << apples * price << " rupees\n";
```

⚠️ With `apples * price` the `int` converts to `double` — output is
`12 apples cost 186 rupees` only because 186.0 prints as `186`. With
`price = 15.75` the text would say `189`… and be wrong in format. Fix
with `std::fixed << std::setprecision(2)` when money is involved.

**E8.**

```cpp
#include <iostream>
#include <iomanip>

int main() {
    double unit = 2.5;
    int qty = 6;
    std::cout << qty << " x " << std::fixed << std::setprecision(2)
              << unit << " = " << qty * unit << "\n";
    return 0;
}
```

Output: `6 x 2.50 = 15.00`. `fixed/setprecision` set once, sticky for
both money figures; `qty` is an int and unaffected.

**E13.**

```cpp
#include <iostream>

int main() {
    int n;
    std::cout << "Whole number: " << std::endl;
    std::cin >> n;
    std::cout << "square " << n * n << ", cube " << n * n * n << "\n";
    return 0;
}
```

Input `5` → `square 25, cube 125`.

**E15.** `cin >> width >> height` skips *any* whitespace between the two
numbers — one space, many spaces, or a newline — so both input styles
fill both variables. The program never knows or cares which one the user
chose; only line-based reading (`getline`) cares where the line ends.

**E20.** Bugged version (name prints empty):

```cpp
std::cin >> age;
std::getline(std::cin, name);          // reads the leftover '\n' -> ""
```

Cure 1 — broom (destroys the rest of the age line):

```cpp
std::cin >> age;
std::cin.ignore(1000, '\n');           // discard remainder of the line
std::getline(std::cin, name);          // now reads the real name line
```

Cure 2 — skip-whitespace (keeps the remainder):

```cpp
std::cin >> age;
std::getline(std::cin >> ws, name);    // skip leading ws, then read line
```

Difference: `ignore` throws away everything after the number on that
line; `>> ws` throws away only whitespace at the front. For "user typed
junk after the number" both work; for "meaningful text may follow on the
same line", only `>> ws` keeps it.

</details>

---

*[← Module home](index.md) · [Debugging hunts →](debugging.md)*
