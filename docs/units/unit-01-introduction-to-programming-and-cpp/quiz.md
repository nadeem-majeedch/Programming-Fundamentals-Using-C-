---
title: "Quiz 01 — Introduction to Programming & C++"
description: "10 questions on Unit 01. Attempt all before opening the answer key."
---

<div class="note"><strong>Companion module:</strong> the <a href="../../../cpp-foundations/index.md">C++ Foundations module</a> is the complete, enriched version of this unit's material — study these pages together for extra depth, practice sets, and the variation lab.</div>


# Quiz 01 — Introduction to Programming & C++

> 10 questions · ~15 min · attempt ALL before opening the [answer key](quiz-answers.md) ·
> [Unit index](index.md)

## Section A — Multiple choice

**Q1.** A compiler is…

- a) the program that runs your C++ file line by line while you watch
- b) a program that translates your C++ source into machine-code instructions
- c) the editor where you type C++
- d) the terminal window where output appears

**Q2.** Which command compiles `card.cpp` into an executable named `card`,
using the course's flags?

- a) `run card.cpp`
- b) `g++ card.cpp`
- c) `g++ -std=c++17 -Wall -Wextra card.cpp -o card`
- d) `g++ -o card.cpp -std=c++17 card`

**Q3.** What does `main` do in a C++ program?

- a) it is where the program starts executing
- b) it stores the program's data
- c) it is required only in programs that print
- d) it compiles the other functions

## Section B — True or false

**Q4.** `// This is a note` makes the program print the note on the screen.

**Q5.** A warning means the program cannot be compiled.

**Q6.** After a successful compile, you run the **executable** (e.g.
`./card`), not the `.cpp` file.

## Section C — Predict the output

**Q7.**

```cpp
std::cout << "Roses";
std::cout << " are red\n";
std::cout << "Violets are blue\n";
```

**Q8.**

```cpp
std::cout << "1\t2\n";
std::cout << "3\t4\n";
```

## Section D — Find the bug

**Q9.** This program fails to compile. Which line has the error, and what
is missing?

```cpp
#include <iostream>       // line 1

int main() {              // line 2
    std::cout << "Hi\n"   // line 3
    return 0;             // line 4
}                         // line 5
```

**Q10.** This program compiles cleanly with zero warnings but prints
something the programmer did not intend:

```cpp
#include <iostream>

int main() {
    std::cout << "Welcome to\b C++\n";
    return 0;
}
```

a) nothing is wrong — it prints `Welcome to C++`
b) `\b` is a typo for `\n` and prints an unexpected control character
c) `std::` is missing somewhere
d) the string is too long to print

---

When you've answered all ten: **[Answer key with explanations](quiz-answers.md)**.

*[← Unit index](index.md) · [Lab 01](labs/lab-01.md) · [Revision](revision.md)*
