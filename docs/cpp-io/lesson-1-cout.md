---
title: "Lesson 1 — Output: cout and Formatting"
description: "cout, <<, endl vs newline, multiple outputs, and formatted output with iomanip."
---

# Lesson 1 — Output: `cout` and Formatting

> [← Module home](index.md) · [Lesson 2 — Input →](lesson-2-cin.md)

## In this lesson you will learn

- what `std::cout` is and what `<<` really does
- how to print several things in one statement — and why spacing is *your* job
- the difference between `'\n'` and `endl`, and when each one matters
- how to line numbers up in columns with `<iomanip>`: `setw`, `left`/`right`,
  `setfill`
- how to control decimal places with `fixed` and `setprecision`
- how to print characters, strings, and computed values together

---

## 1.1 What `cout` is

**Explanation.** `std::cout` is the *character output* stream — the pipe from
your program to the screen. You never call it like a function; you feed it
values using `<<`, the **insertion operator**. Think of `<<` as an arrow:
data flows from the right-hand thing into the stream on the left.

**Syntax**

```cpp
std::cout << value;
```

**Worked example**

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, output!";
    return 0;
}
```

**Explaining the example.** `#include <iostream>` brings the stream library
in. `std::cout << "Hello, output!"` pushes those characters onto the
standard output stream, and the screen shows them. There is no automatic
newline at the end — run it twice and you will see two messages glued
together. Output does **not** end a line unless you say so.

**Practice.** [Prediction P1](predictions.md#p1) · [Exercise E1](exercises.md#e-output-basics-1-6).

---

## 1.2 Chaining: multiple outputs in one statement

**Explanation.** `<<` hands the stream back after each insert, so you can
chain as many pieces as you like. The stream prints them **left to right,
in order, with no spaces added** — the spacing between words comes only
from the text you type.

**Syntax**

```cpp
std::cout << piece1 << piece2 << piece3;
```

**Worked example**

```cpp
#include <iostream>

int main() {
    int age = 19;
    double height = 1.72;

    std::cout << "Age: " << age << "\n";
    std::cout << "Height: " << height << " m" << "\n";
    std::cout << "Next year: " << age + 1 << "\n";
    return 0;
}
```

**Explaining the example.** Line 1 prints the label, then the variable,
then a newline. Note `"Age: "` — the colon *and space* are part of the
string; the stream inserts nothing on its own. The third statement shows
that `<<` can take an **expression**: `age + 1` is computed first, then the
result (20) is printed.

Output:

```text
Age: 19
Height: 1.72 m
Next year: 20
```

**Practice.** [Prediction P2](predictions.md#p2) · [Exercise E2](exercises.md#e-output-basics-1-6).

---

## 1.3 `endl` and `'\n'` — two ways to end a line

**Explanation.** Both move output to the next line. The difference is a
guarantee called **flushing**: `std::endl` writes the newline *and* forces
the stream to deliver everything to the screen immediately; `'\n'` just
writes the newline character and lets the library decide when to deliver.

For console programs the practical difference is usually invisible — the
console is flushed often anyway. The two habits worth forming now:

- prefer `'\n'` inside long output (it is cheaper, and it composes nicely
  inside strings: `"a\nb\n"`);
- use `endl` where the *timing* matters, e.g. printing a prompt **before**
  asking the user for input, so the prompt is guaranteed on screen.

**Syntax**

```cpp
std::cout << "line one\n";        // newline character
std::cout << "line two" << '\n';  // same thing, separate piece
std::cout << "prompt: " << std::endl;  // newline + forced flush
```

**Worked example**

```cpp
#include <iostream>

int main() {
    std::cout << "A\nB\nC" << '\n';
    std::cout << "Enter your mark: " << std::endl;  // flush before input
    // int mark;  std::cin >> mark;   -- input comes in Lesson 2
    return 0;
}
```

**Explaining the example.** The first line shows the three spellings of
"end this line" in action: inside a string, as a separate char, and as
`endl`. A prompt printed with `'\n'` would work on virtually every setup,
but `endl` is the promise: *nothing is left in the pipeline*.

**Watch out.** `'n'`, `"\n"`, and `'\n'` are three different things — a
letter, a string, and the newline character. Typing `"Hello" << '/n'`
(a slash) prints `/n`. [Debugging D1](debugging.md#d1---the-wrong-slash)
is exactly this bug.

**Practice.** [Prediction P3](predictions.md#p3) · [Exercise E3](exercises.md#e-output-basics-1-6).

---

<a name="4-formatting-columns-setw-left-right-setfill"></a>
## 1.4 Formatting columns: `setw`, `left`, `right`, `setfill`

**Explanation.** `std::setw(n)` (from `<iomanip>`) says: *the next single
piece of output is padded to at least n characters wide*. Extra space is
added on the left by default (`right`-aligned, like a column of numbers);
`std::left` flips the padding to the right side (text usually wants this).
`std::setfill(c)` changes the padding character.

Two rules beginners must memorise:

1. `setw` applies to the **next item only**, then forgets itself — repeat
   it before every column.
2. It sets a **minimum** width. Longer output simply overflows and is
   printed in full.

**Syntax**

```cpp
#include <iostream>
#include <iomanip>
std::cout << std::setw(8) << value;
std::cout << std::left << std::setw(10) << name;   // sticky alignment
```

**Worked example** — a mini marksheet, columns of width 12:

```cpp
#include <iostream>
#include <iomanip>
#include <string>

int main() {
    std::string names[3]  = {"Ayesha", "Bilal", "Chen"};
    int marks[3]          = {88, 61, 95};

    std::cout << std::left  << std::setw(12) << "Name"
              << std::right << std::setw(12) << "Mark" << "\n";

    for (int i = 0; i < 3; i++) {
        std::cout << std::left  << std::setw(12) << names[i]
                  << std::right << std::setw(12) << marks[i] << "\n";
    }
    return 0;
}
```

**Explaining the example.** The header prints the name column left-aligned,
the mark column right-aligned — the classic table shape. Inside the loop,
each row re-applies `setw(12)` for both columns. (The `for` loop is a sneak
preview — Unit 05 makes it official; for now read it as "do the body three
times, i = 0, 1, 2".) Output:

```text
Name                Mark
Ayesha               88
Bilal                61
Chen                 95
```

With `std::setfill('.')` before the mark column, missing width becomes
dots — receipts use this trick constantly.

**Practice.** [Trace T2](traces.md#t2) · [Exercise E10](exercises.md#e-formatting-9-12).

---

## 1.5 Decimals: `fixed` and `setprecision`

**Explanation.** By default `cout` prints `double` values with up to 6
significant digits and drops trailing zeros — `4.5` prints `4.5`, but so
does `4.500001`… and money looks wrong. Two manipulators fix the rules:

- `std::fixed` — always print in decimal notation (never scientific),
- `std::setprecision(n)` — with `fixed` active, exactly **n digits after
  the decimal point** (rounded, not truncated).

Unlike `setw`, these two are **sticky**: set them once and they stay until
you change them. Money wants `fixed << setprecision(2)` exactly once.

**Syntax**

```cpp
#include <iostream>
#include <iomanip>
std::cout << std::fixed << std::setprecision(2) << amount;
```

**Worked example**

```cpp
#include <iostream>
#include <iomanip>

int main() {
    double a = 4.5, b = 10.0 / 3.0, c = 1234.56789;

    std::cout << a << " | " << b << " | " << c << "\n";
    std::cout << std::fixed << std::setprecision(2)
              << a << " | " << b << " | " << c << "\n";
    std::cout << std::setprecision(0) << b << "\n";
    return 0;
}
```

**Explaining the example.** First line, default formatting: `4.5`,
`3.33333`, `1234.57` — the library chooses. Second line: `4.50`,
`3.33`, `1234.57` — exactly two decimals everywhere, properly rounded.
The last line prints `3` (zero decimals). Notice `10.0 / 3.0` needs the
`.0`s: `10 / 3` is integer division — the Foundations module's
[conversion rules](../cpp-foundations/lesson-4-conversion.md#42-implicit-conversion)
strike again.

**Practice.** [Prediction P4](predictions.md#p4) · [Exercise E11](exercises.md#e-formatting-9-12).

---

<a name="6-characters-strings-and-computed-values-together"></a>
## 1.6 Characters, strings, and computed values together

**Explanation.** Everything so far composes: you can interleave `char`,
`string`, `int`, `double`, and expressions freely in one chain. Three
small facts that prevent surprises:

- a `char` prints as its character (`'A'`, not 65); `+ '0'`-style tricks
  belong to later units;
- `true`/`bool` prints as `1`/`0` by default; `std::boolalpha` makes it
  print `true`/`false`;
- an expression is evaluated before printing, so `marks / 3` inside `<<`
  obeys integer division unless you cast.

**Worked example**

```cpp
#include <iostream>
#include <iomanip>

int main() {
    int total = 267, count = 3;
    char grade = 'A';

    std::cout << "grade " << grade
              << "  average " << std::fixed << std::setprecision(1)
              << static_cast<double>(total) / count
              << "  passed " << std::boolalpha << (total >= 180) << "\n";
    return 0;
}
```

**Explaining the example.** Prints `grade A  average 89.0  passed true`.
The cast converts to `double` *before* the division (267 / 3 in ints would
be 89 — the same here, but with total = 268 the difference shows). The
comparison produces a `bool`, and `boolalpha` renders it as the word
`true` instead of `1`.

**Practice.** [Prediction P5](predictions.md#p5) · [Challenge C1](challenges.md#c1).

---

## Check yourself (Lesson 1)

Answer in one written sentence each — no compiler.

1. Why does `std::cout << "Age:" << age;` print `Age:19` — and what would
   you change?
2. You print a progress dot with `<< '.'` inside a long loop and never see
   dots until the program ends. Which spelling of "newline" would have
   forced them out, and which one is cheaper in general?
3. `setw(6)` prints `923` as three spaces then `923`. Which manipulator
   flips those spaces to the right side of the number, and which one turns
   them into asterisks?
4. Which two manipulators make every later `double` print with exactly two
   decimals, and are they sticky or one-shot?

---

*[← Module home](index.md) · [Lesson 2 — Input: `cin` and the Buffer](lesson-2-cin.md) →*
