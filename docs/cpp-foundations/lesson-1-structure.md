---
title: "Lesson 1 — A Program's Shape"
description: "C++ program structure, main(), statements, and comments."
---

# Lesson 1 — A Program's Shape

> ~45–60 min · [← Module home](index.md) · [Lesson 2 — Data →](lesson-2-data.md)

Four concepts open the module — the *skeleton* every C++ program you will
ever write hangs on. Each concept below gets: plain-language explanation →
syntax → example → what the example does → practice.

---

<a name="11-c-program-structure"></a>
## 1.1 C++ program structure

**Explanation.** Every C++ program is built from the same few parts, always
in the same jobs: *preprocessor lines* pull in libraries, *functions* hold
instructions, and exactly one function named `main` is where execution
begins. Small programs are one file; big programs are thousands — but the
shape of a single file never changes:

```text
┌─ #include lines ──── what the file needs (libraries)
├─ (constants/helpers) ─ shared definitions  ← later lessons
└─ main() ──────────── where execution starts
```

**Syntax.**

```cpp
#include <library>          // preprocessor line (no semicolon!)

int main() {                // function header: name + parameter list + body {
    statement;              // the instructions
    statement;
    return 0;               // hand 0 (= success) back to the operating system
}                           // body closes
```

**Example.**

```cpp
// shape.cpp — the minimal complete program
#include <iostream>                 // need input/output → include iostream

int main() {
    std::cout << "Program starts\n";  // instruction 1
    std::cout << "Program ends\n";    // instruction 2
    return 0;                         // report success
}
```

**Explained.** `#include <iostream>` pastes in the declarations for
input/output so `std::cout` is known. `int main() {` marks the entry point —
the operating system calls `main` and your statements run top to bottom, one
per line. `return 0;` ends the program with the conventional success code.
Run it (compile line is in the file's first comment) and the two lines print
in order — the *shape* is: include → main → statements → return → brace.

**Practice.** [Exercises 1–4](exercises.md#part-a---concept-checks-1-8) —
rebuild the shape from memory, then deliberately break it in two ways.

---

## 1.2 `main()`

**Explanation.** `main` is a **function** — a named, reusable block of code
— with a special contract: *the program starts by running `main`*. The
pieces of the header each say something precise:

| Piece | Says |
| --- | --- |
| `int` | when `main` finishes it hands back a whole number (to the OS) |
| `main` | the name the system looks for — exactly this spelling, all lowercase |
| `()` | the function takes no arguments here (command-line arguments come much later) |
| `{ … }` | the function body — everything between the braces |

**Syntax.**

```cpp
int main() {
    // body
    return 0;
}
```

**Example.**

```cpp
// onemain.cpp — exactly one main per program
#include <iostream>

int main() {
    std::cout << "A\n";
    return 0;
}

// int main() {                    ← uncommenting this is an ERROR:
//     return 0;                   //    error: redefinition of 'int main()'
// }
```

**Explained.** Two rules you can rely on forever: **exactly one** `main` per
program (the linker refuses two — try it once, on purpose, and read the
error), and `main`'s `return 0` signals success (any other value tells the
OS "something went wrong" — we keep 0 throughout this course). The compiler
doesn't care where `main` sits in the file; humans do — this course puts it
last so helpers appear before use.

**Practice.** [Exercise 5](exercises.md#part-a---concept-checks-1-8) (add a
second `main` and *read* the error) ·
[prediction P1](predictions.md#p1).

---

<a name="13-statements"></a>
## 1.3 Statements

**Explanation.** A **statement** is one complete instruction: *do this one
thing*. In C++, most statements end with a semicolon — the period of the
language. The compiler reads until the `;` and doesn't care how many lines
you took; you may write one statement across three lines (or three tiny
statements on one line) — but *don't*: one statement per line is the
readability habit this course grades.

**Syntax.**

```cpp
expression;              // e.g. a computation
declaration;             // e.g. creating a variable  (Lesson 2)
assignment;              // e.g. storing into one     (Lesson 2)
std::cout << "…\n";      // an output statement
return 0;                // the return statement (no ; on the brace lines!)
```

**Example.**

```cpp
// statements.cpp — three statements, one per line
#include <iostream>

int main() {
    std::cout << "Step 1\n";              // statement 1: print
    std::cout << "Step " << 2 << "\n";    // statement 2: chain two pieces
    return 0;                             // statement 3: finish
}
```

**Explained.** Statement 2 shows chaining — `<<` sends "Step " then the
number `2` then the newline, all in one statement; the statement is still
*one* instruction ("write this sequence to the screen"). Common Week-1
errors are all statement errors: missing `;` (`error: expected ';'`),
one *half* of a statement on each side of a line break (legal but confusing).
Count braces and semicolons as you write; the
[error catalogue](../toolchain/compiler-errors.md) shows what their absence
looks like.

**Practice.** [Exercise 6](exercises.md#part-a---concept-checks-1-8) ·
[debugging D1](debugging.md#d1---the-missing-period) (a missing `;` with
friends).

---

## 1.4 Comments

**Explanation.** A **comment** is text for humans; the compiler throws it
away. Comments answer *why* — the code itself already shows *what*. Two
forms: `//` to end of line (the course default), and `/* … */` which can
span lines. A good ratio to aim for: a comment where you would otherwise
wonder.

**Syntax.**

```cpp
// line comment: from the two slashes to the end of the line
/* block comment: everything between,
   including line breaks, is ignored */
```

**Example.**

```cpp
// comments.cpp — good and bad comments
#include <iostream>

int main() {
    // BAD:  print hello          (repeats the code — adds nothing)
    std::cout << "hello\n";

    // GOOD: greeting must match the letter template of 2026-08
    std::cout << "hello\n";
    return 0;
}
```

**Explained.** Both `std::cout` lines compile identically — the comments
differ only in *value*: the first narrates the what (useless), the second
records a why (the template constraint) that the code cannot show. Block
comments are ideal for file headers (every course file has one) and for
temporarily disabling code while experimenting — *commenting out*. Careful:
`/* /* nested */ */` doesn't nest; the first `*/` ends it.

**Practice.** [Exercises 7–8](exercises.md#part-a---concept-checks-1-8) ·
[challenges C1–C2](challenges.md) are comment-annotating by design.

---

## Check yourself (Lesson 1)

- [ ] I can draw/annotate the four parts of a minimal program
- [ ] I know why exactly one `main` must exist, and what `return 0` means
- [ ] I write one statement per line, every statement ending in `;`
- [ ] I comment *why*, not *what*

**Next:** [Lesson 2 — Data: Variables & Types](lesson-2-data.md) — where
programs start remembering things.

*[← Module home](index.md)*
