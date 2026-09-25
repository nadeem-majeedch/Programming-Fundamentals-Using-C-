---
title: "Unit 01 — Revision Sheet"
description: "Two-page summary, common mistakes, and flashcards for Unit 01."
---

<div class="note" markdown="1"><strong>Companion module:</strong> the [C++ Foundations module](../../cpp-foundations/index.md) is the complete, enriched version of this unit's material — study these pages together for extra depth, practice sets, and the variation lab.</div>


# Unit 01 — Revision Sheet

> The whole unit in two pages · [Unit index](index.md) · [Quiz](quiz.md)

## The big picture

A **program** is a precise list of instructions. The computer executes only
**machine code**, so a **compiler** (g++/Clang) translates your C++ **source
file** (`.cpp`) into an **executable**. You develop programs by looping:

```text
EDIT  →  COMPILE  →  RUN  →  (errors or wrong output? back to EDIT)
```

Fix the **first** error, recompile, repeat. Compile with warnings on:
`g++ -std=c++17 -Wall -Wextra file.cpp -o program`.

## Anatomy of the minimal program

| Line | Role |
| --- | --- |
| `// comment` | note for humans; ignored by the compiler |
| `#include <iostream>` | bring in the input/output library |
| `int main() {` | program starts here; `{` opens the body |
| `std::cout << "text\n";` | send text to the console; statement ends with `;` |
| `return 0;` | hand `0` (= success) back to the operating system |
| `}` | closes `main`'s body |

## Output essentials

| You write | Effect |
| --- | --- |
| `<<` | "sends" — chains multiple pieces: `cout << "x = " << 42 << "\n";` |
| `"..."` | string literal; text goes in double quotes |
| `\n` | newline — the course default |
| `std::endl` | newline + flush (rarely needed) |
| `\t` | tab |
| `\"` and `\\` | literal quote / literal backslash |

## Common mistakes checklist

- [ ] I never ran the **executable** instead of the `.cpp` (or vice versa) by mistake
- [ ] I pair every `{` with a `}` before compiling
- [ ] Every statement ends with `;`
- [ ] `std::` before `cout` and `endl` — every time
- [ ] I read compiler errors bottom-up: **first** error first, reported line ≠ mistake line
- [ ] Warnings get fixed, never ignored
- [ ] Strings that should contain `"` or `\` use `\"` / `\\`

## Flashcards

| Prompt | Answer |
| --- | --- |
| What is a program? | A precise list of instructions the computer executes one step at a time |
| What does a compiler do? | Translates C++ source into machine code, producing an executable |
| Edit–compile–run cycle? | Edit the source → compile with g++ → run the executable; errors send you back to edit |
| What is `main`? | The function where every C++ program starts executing |
| What does `return 0;` mean? | `main` reports success (0) to the operating system |
| `std::cout` is…? | The console output stream; push data into it with `<<` |
| `\n` vs `endl`? | Both end the line; `endl` also flushes the output buffer; prefer `\n` |
| Why compile with `-Wall -Wextra`? | Turns on warnings — the compiler flagging suspicious code; fix them all |
| Where does execution start? | In `main`, at its first statement |
| Comment syntax? | `//` to end of line (also `/* ... */` for multi-line) |

---

*[← Unit index](index.md) · [Syllabus](../../syllabus.md)*
