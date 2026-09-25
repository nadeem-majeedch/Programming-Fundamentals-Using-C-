---
title: "First-Program Exercise"
description: "Your guided first C++ program: type, compile, run, break, fix, personalise."
---

# First-Program Exercise

> Week 0 · ~30–45 min · the final proof of your setup · [← Orientation hub](index.md)

This is the last setup step and the first real exercise. You will type,
compile, run — and then deliberately break — your first program. Do it with
the [Getting Started lesson](getting-started-lesson.md#11-your-first-c-program)
open in another tab if you want the "why" behind each line.

**Save it as** `cpp-course/unit-00/hello.cpp` (or any folder — this is a
one-file day). **Type it; don't paste it.** The typos you are about to make
and fix are the lesson — and they go in your bug diary.

## The program

```cpp
// hello.cpp — my first C++ program
// Compile: g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
// Run:     ./hello            (Windows: .\hello.exe)

#include <iostream>

int main() {
    std::cout << "Hello, world!\n";
    return 0;
}
```

## Step 1 — Compile and run

**Windows (PowerShell):**

```powershell
g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
.\hello.exe
```

**Linux:**

```bash
g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
./hello
```

**macOS:**

```bash
clang++ -std=c++17 -Wall -Wextra hello.cpp -o hello
./hello
```

Expected:

```text
Hello, world!
```

A clean compile prints **nothing** first — silence is success — and then
your run prints the line. If the compiler complained: compare your file
character-by-character with the listing above; every difference is a
discovery. Write each one in your bug diary.

## Step 2 — Predict, then check

For each change: **write your prediction first**, then edit, save,
recompile, run, compare. (Remember the loop: every change needs a fresh
compile — the old executable doesn't update itself.)

1. Change the message to `"Hello, C++!\n"`.
2. Add a second output line **before** `return`:
   `std::cout << "I am programming.\n";`
3. Delete the `\n` from the first message. What exactly changes?
4. Change `\n` to `\t` in the first message. What appears between the words?

## Step 3 — Break it on purpose (three classic errors)

Make each change **one at a time**, compile, read the error, write down what
the compiler said, fix it, recompile:

1. **Remove the `;`** at the end of the `std::cout` line.
2. **Misspell** `std::cout` as `std::cuot`.
3. **Remove the closing `}`** of `main`.

Each one produces a different compiler complaint — these three messages will
follow you for weeks, and you have now met them on *your* terms.

## Step 4 — Make it yours

Personalise the program so it prints a three-line introduction:

```text
Hello, I am Ayesha.
I am learning C++.
Wish me luck!
```

Requirements: three output lines, at least one **chained** `<<`
(`std::cout << "Hello, I am " << "Ayesha.\n";`), zero warnings.

## Done means

```text
[ ] Compiles warning-free on my machine
[ ] Runs and prints my three lines
[ ] Predictions from Step 2 written down and checked
[ ] Three deliberate breaks from Step 3 made, read, and fixed
[ ] At least one bug diary entry
```

All five? **Setup is complete** — go to the
[Setup Checklist](setup-checklist.md) and tick section 7, then start
[Unit 01 · Lesson 1](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md)
where this same program is dissected line by line.

Stuck on any step? [Troubleshooting](getting-started-troubleshooting.md)
has the named fix for every common failure.

---

*[← Orientation hub](index.md) · [Exercises](getting-started-exercises.md) ·
[Lab 00](getting-started-lab.md)*
