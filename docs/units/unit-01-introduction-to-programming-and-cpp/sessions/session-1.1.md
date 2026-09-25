---
title: "Lesson 1 — What Is a Program, and How Does One Run?"
description: "Unit 01 · Session 1.1 of Programming Fundamentals Using C++"
---

<div class="note" markdown="1"><strong>Companion module:</strong> the [C++ Foundations module](../../../cpp-foundations/index.md) is the complete, enriched version of this unit's material — study these pages together for extra depth, practice sets, and the variation lab.</div>


# Lesson 1 — What Is a Program, and How Does One Run?

> Unit 01 · Session 1.1 · ~90–120 min · [Unit index](../index.md) · Next: [Lesson 2](session-1.2.md)

## In this lesson you will learn

- What a **program** really is — and what it means that a computer "runs" one
- Why computers need a **compiler** to understand C++
- The **edit–compile–run cycle** you'll use every day of this course
- How to write, compile, and run your first C++ program
- What the **terminal** is, and the few commands you need

*(All terms are defined in plain words first, then collected in the
[Glossary](../../../glossary.md).)*

---

## 1. What is a program?

A **program** is a list of instructions, written in a very precise language,
that a computer follows one step at a time.

You already know instruction lists — a recipe is one:

1. Boil water.
2. Add rice.
3. Wait 12 minutes.
4. Drain and serve.

A computer program is the same idea with two crucial differences:

- **The computer follows the steps exactly.** Not roughly — *exactly*. If a
  recipe says "add salt to taste", a cook improvises. A computer cannot
  "taste": every instruction must be precise and complete.
- **The computer is fast beyond intuition.** A modern processor performs
  billions of these steps *per second*. Programs feel clever, but they are
  only very simple steps executed very, very fast.

The language we write the instructions in is a **programming language**. This
course uses **C++** — one of the most widely used languages in the world,
and a superb one for learning fundamentals, because almost nothing is hidden
from you. What you write is (nearly) what happens.

> **Why "nearly"?** You'll meet that idea in Lesson 2, when we look at what
> the compiler turns your text into.

## 2. Why the computer needs a translator

Here is the catch: a processor understands only extremely simple instructions
encoded as binary numbers — the **machine code**. Something like
`10110000 01100001` means "move this value into this register". Humans
learned long ago that writing machine code by hand is slow, painful, and
error-prone.

So we write in a human-friendly language like C++:

```cpp
std::cout << "Hello!\n";
```

…and a **compiler** translates it into machine code for us.

A **compiler** is a program that reads your C++ source file (the text you
write) and produces an **executable** — a file of machine instructions the
computer can run directly. The compilers this course uses are free:

| Compiler | Where you meet it |
| --- | --- |
| **g++** (part of GCC) | [Windows](../../../getting-started/compiler-setup/windows.md) and [Linux](../../../getting-started/compiler-setup/linux.md) setup |
| **Clang** | [macOS](../../../getting-started/compiler-setup/macos.md) setup |

All three of them speak the same C++ we teach, and all accept the same
course command, which you already ran in Week 0:

```bash
g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
```

Reading the command piece by piece:

| Piece | Meaning |
| --- | --- |
| `g++` | run the compiler |
| `-std=c++17` | use the C++17 standard of the language (the course's version) |
| `-Wall -Wextra` | turn on the useful **warnings** — the compiler politely telling you about suspicious code |
| `hello.cpp` | the source file to translate |
| `-o hello` | name the resulting executable `hello` |

> **Warnings matter.** A *warning* means "this will run, but it looks
> wrong". Professionals treat warnings as errors to fix immediately — this
> course adopts that rule, and your future self will thank you.

## 3. The edit–compile–run cycle

Every program you ever write — here or in your career — is built by
repeating the same three-step loop:

```text
  ┌────────────┐      ┌───────────────┐      ┌──────────────┐
  │  1. EDIT   │ ───▶ │  2. COMPILE   │ ───▶ │  3. RUN      │
  │ write/fix  │      │ g++ … -o prog │      │ ./prog       │
  │  the code  │      │  fix errors ◀ │      │ test it  ◀   │
  └────────────┘      └───────┬───────┘      └──────┬───────┘
        ▲                     │ compile errors?     │ wrong behaviour?
        └─────────────────────┴─────────────────────┘
                    (back to step 1 — always)
```

- **Edit** — write or change the source file in your editor.
- **Compile** — run the compiler. If it reports **errors**, you go back to
  Edit. Errors are normal: every programmer on Earth sees them daily. The
  [error catalogue](../../../toolchain/compiler-errors.md) is your friend.
- **Run** — execute the program and look at what it does. Wrong output? Back
  to Edit.

Notice what the cycle teaches: **a program is never "finished" in one
pass.** You grow it in small steps, compiling constantly. Small steps mean
small errors — that is the whole craft.

## 4. The terminal, in sixty seconds

The **terminal** (also called command line or console) is a window where you
type commands to the operating system. The course uses it for two things:
compiling and running.

You only need four commands for now:

| You type | What it does |
| --- | --- |
| `cd code/cpp-course/unit-01` | **c**hange **d**irectory — move into your unit folder |
| `ls` (Linux/macOS) or `dir` (Windows) | list the files in the current folder |
| `g++ -std=c++17 -Wall -Wextra hello.cpp -o hello` | compile (from §2) |
| `./hello` — Windows: `.\hello.exe` | run the program you just built |

Two things surprise beginners:

1. **Running means naming the *executable*, not the source.** `./hello` runs
   the program; `hello.cpp` is just the text you edited.
2. **The `./` matters.** It means "the file here in this folder". On Windows
   the equivalent is `.\`.

> Full terminal walkthroughs with pictures of these commands in action are
> in your platform's setup guide:
> [Windows](../../../getting-started/compiler-setup/windows.md) ·
> [Linux](../../../getting-started/compiler-setup/linux.md) ·
> [macOS](../../../getting-started/compiler-setup/macos.md). You already
> did this once with `sanity-check.cpp` — today is the same loop, on your
> own file.

## 5. Your first program

Create a folder `unit-01` inside your course folder, open your editor, and
type — **do not paste; typing is the exercise** — the following into a file
named exactly `hello.cpp`:

```cpp
// hello.cpp — my very first C++ program
// Compile: g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
// Run:     ./hello

#include <iostream>

int main() {
    std::cout << "Hello, world!\n";
    return 0;
}
```

Save it, then compile and run:

```bash
g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
./hello
```

You should see:

```text
Hello, world!
```

🎉 **That's it — you are a programmer.** Everything from here is "just" more
of the same: more words in the language, more patterns in the cycle. The
same file is in the course's examples as
[`01_hello.cpp`](../examples/01_hello.cpp) — compare your typing with it
character by character if the compiler complains.

This exact program (with its two-line history) is famous enough to have a
name: it is the traditional **"Hello, world!"** program — the first program
in nearly every programming course and book since the 1970s, because it
exercises the entire cycle: edit, compile, run, output. You just joined a
very long tradition.

### What if it didn't work?

Excellent — errors are the lesson. Compare your file against the example
above; the most common first-program typos are:

| You wrote | Compiler says (g++ wording) | The fix |
| --- | --- | --- |
| missing `;` on the `std::cout` line | `error: expected ';' before '}' token` | add the semicolon |
| `sting` or `cuot` | `error: 'sting' was not declared in this scope` | fix the spelling |
| `#inclde` | `error: invalid preprocessing directive #inclde` | `#include` |
| ran `hello.cpp` instead of `./hello` | `bash: ./hello.cpp:Permission denied` (or a flood of garbage) | run the **executable** |

More in the [FAQ](../../../faq.md#troubleshooting-quick-answers) and the
[error catalogue](../../../toolchain/compiler-errors.md).

## 6. Run it the professional way: predict, then check

From today on, you never run code without first guessing what it will do.
Let's practise immediately. For each change below, **write down your
prediction first**, then edit, compile, run, and compare:

1. Change `"Hello, world!\n"` to `"Hello, C++!\n"`.
2. Add a second line inside `main` (before `return`):
   `std::cout << "I am programming.\n";`
3. Remove the `\n` from the first line. What changes about the output?
4. Remove the `;` from the `std::cout` line. What does your compiler say,
   and on which line does it *report* the problem?

Keep your answers — Lesson 2 explains exactly *why* each behaved the way it
did, including what `\n` does and why `return 0;` is there.



---

## Check yourself

You're ready for [Lesson 2](session-1.2.md) when you can:

- [ ] explain "program" in one sentence a friend would understand
- [ ] say what the compiler does, and what an executable is
- [ ] name the three steps of the edit–compile–run cycle — and what you do
      when a step fails
- [ ] compile and run `hello.cpp` from the terminal without looking anything up
- [ ] predict the output of change 2 above correctly

Any box unchecked? Re-run the relevant section, or ask in the
[repository issues](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/issues).
Then continue: **[Lesson 2 — Anatomy of a Program](session-1.2.md)** →

---

*[← Unit 01 index](../index.md) · [Glossary](../../../glossary.md) ·
[FAQ](../../../faq.md)*
