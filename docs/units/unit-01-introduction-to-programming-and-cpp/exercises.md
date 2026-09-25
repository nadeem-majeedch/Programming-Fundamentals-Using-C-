---
title: "Unit 01 — Exercises"
description: "10 practice items for Unit 01: concept checks, predict-the-output, short coding."
---

<div class="note"><strong>Companion module:</strong> the <a href="../../../cpp-foundations/index.md">C++ Foundations module</a> is the complete, enriched version of this unit's material — study these pages together for extra depth, practice sets, and the variation lab.</div>


# Unit 01 — Exercises

> Attempt everything **before** checking any answer · [Unit index](index.md) ·
> Answers for the predict items are in [§4](#4-answers-to-predict-the-output);
> coding tasks check themselves by compiling.

## 1. Concept checks (answer in one written sentence)

1. In your own words: what is a program?
2. What does a compiler do, and what file does it produce?
3. Name the three steps of the edit–compile–run cycle and say what you do
   when a step fails.
4. What is the difference between `hello.cpp` and `hello` (the executable)?
5. Why does this course compile with `-Wall -Wextra` — what is a *warning*?

## 2. Predict the output

Write each answer down **before** running anything. (You may run afterwards
to check — that's the point of the answer table.)

6.

```cpp
std::cout << "One";
std::cout << "Two\n";
std::cout << "Three\n";
```

7.

```cpp
std::cout << "A\tB\nC\tD\n";
```

8.

```cpp
std::cout << "She said \"C++ is fun\"\n";
```

9. How many output lines does this produce?

```cpp
std::cout << "x\n\ny\n";
```

10. This program has **one** bug. Which line, and what is it?

```cpp
#include <iostream>

int main() {
    std::cout << "Ready\n"
    return 0;
}
```

## 3. Short coding tasks

Compile each with
`g++ -std=c++17 -Wall -Wextra task.cpp -o task` and check the output
yourself against the requirement.

**T1 — Timetable.** Print a two-column mini timetable using `\t`, with a
title line and one line per day, e.g. `Mon\tAlgorithms`. At least four days.

**T2 — Quote me.** Print exactly this line (quote characters included):

```text
My teacher said: "Practice daily."
```

**T3 — Card upgrade.** Take the Student Card example from
[Lesson 2](sessions/session-1.2.md) and add a fourth line with your city.
Keep the `====` borders the same width as the title.

**T4 — The missing semicolons.** The program below produces three compiler
errors when compiled. Predict what the *first* error will be and on which
line; then compile, fix only the first error, recompile, and repeat until
clean. (Write in your bug diary how many rounds it took.)

```cpp
#include <iostream>

int main() {
    std::cout << "One\n"
    std::cout << "Two\n"
    std::cout << "Three\n"
    return 0;
}
```

<a name="4-answers-to-predict-the-output"></a>
## 4. Answers to predict-the-output

<details markdown="1">
<summary><strong>Reveal answers (attempt everything first!)</strong></summary>

**A6.**

```text
OneTwo
Three
```

The first statement prints `One` with **no** newline, so `Two` continues on
the same line; `\n` after `Two` moves the next output down.

**A7.**

```text
A       B
C       D
```

`\t` jumps to the next tab stop — the gap's exact width depends on your
terminal, the *columns* are what matters.

**A8.**

```text
She said "C++ is fun"
```

`\"` prints one literal quote.

**A9.** **Three** lines: `x`, then an empty line (the extra `\n`), then `y`.

**A10.** Line 4: the statement `std::cout << "Ready\n"` is missing its
closing `;`. (Depending on your compiler you may see
`expected ';' before 'return'` — notice the *reported* line may be 6 while
the mistake is on 4. Read upward.)

</details>

---

*[← Unit index](index.md) · Next: [Lab 01](labs/lab-01.md)*
