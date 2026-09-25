---
title: "Getting Started with C++"
description: "The complete Week-0 lesson: what C++ is, how code becomes a running program, and the workflow every session uses."
---

# Getting Started with C++

> Week 0 · the foundation lesson · ~2–3 h + practice · [← Orientation hub](index.md)

## In this lesson you will learn

Everything behind the one command this course uses most. By the end you can:

1. say what C++ is and why it suits this course
2. explain what a compiler does, and what source code and executables are
3. describe compilation **and linking** — the two half-steps of a build
4. choose between an IDE and a text editor without being locked into either
5. compile from the command line on **Windows, Linux, or macOS**
6. install and verify a compiler on your machine
7. write, compile, and run your first program
8. tell apart the three kinds of errors — **compile**, **runtime**, and **logic** — and know the repair strategy for each
9. read compiler error messages instead of fearing them
10. use the small set of terminal commands the course needs
11. organise a project directory for 16 units of work, and know how labs are organised and submitted
12. use this GitHub Pages site well, and take an optional first look at Git

Everything here is **portable C++**: the same source file compiles unchanged
on Windows, Linux, and macOS. Only the *commands around* the program differ
by platform — and those differences are flagged wherever they occur.

---

## Table of contents

**Part I — The machinery** · [1. What is C++?](#1-what-is-c) ·
[2. What is a compiler?](#2-what-is-a-compiler) ·
[3. Source code](#3-source-code) · [4. Compilation](#4-compilation) ·
[5. Linking](#5-linking) · [6. Executable programs](#6-executable-programs)

**Part II — Your tools** · [7. IDE vs text editor](#7-ide-vs-text-editor) ·
[8. Command-line compilation](#8-command-line-compilation) ·
[9. Installing a compiler](#9-installing-a-c-compiler) ·
[10. Verifying the installation](#10-verifying-the-compiler-installation) ·
[17. Terminal basics](#17-basic-terminalcommand-line-usage-needed-for-the-course) ·
[18. Project directory structure](#18-recommended-project-directory-structure)

**Part III — First program** · [11. First C++ program](#11-your-first-c-program) ·
[12. Compile and run](#12-compile-and-run) ·
[19. Saving exercises](#19-how-students-should-save-their-exercises) ·
[20. Organising lab work](#20-how-students-should-organize-and-submit-lab-work)

**Part IV — Errors** · [13. Compilation errors](#13-compilation-errors) ·
[14. Runtime errors](#14-runtime-errors) · [15. Logic errors](#15-logic-errors) ·
[16. Reading error messages](#16-how-to-read-compiler-error-messages)

**Part V — The course ecosystem** ·
[21. Using this site](#21-how-to-use-the-course-github-pages-site) ·
[22. Optional Git introduction](#22-optional-gitgithub-introduction)

---

# Part I — The machinery

<a name="1-what-is-c"></a>
## 1. What is C++?

A **computer program** is a list of precise instructions the computer
executes one after another. A **programming language** is the language those
instructions are written in — precise enough for a machine, readable enough
for humans.

**C++** is one of the most widely used programming languages in the world.
It appeared in the early 1980s (created by Bjarne Stroustrup) as an
evolution of the C language, and it now runs operating systems, web browsers,
games, databases, trading systems, and spacecraft — which tells you
something important: **C++ is close to the machine**, and what you write is
essentially what the computer does.

Why is it the right language for a fundamentals course?

- **Nothing important is hidden.** Languages that hide memory and types
  behind layers of "convenience" are friendlier for toys and crueler for
  understanding. In C++, you *see* the machinery — which is exactly the
  point of this course.
- **It is fast** — the computer runs your translated program at full speed.
- **It is everywhere**, so the habits you build here transfer directly to
  jobs and later courses.
- **It is strict.** The compiler catches many mistakes before the program
  ever runs — a strict teacher that makes you precise.

One honest warning: C++ is also *large*. Nobody knows all of it — not in a
16-week course, not ever. This course teaches a solid, portable core
(standard **C++17**) and deliberately skips the exotic corners until you
have the foundation that makes them meaningful.

> **A standard, not a product.** "C++" is defined by an international
> standard; compilers from different vendors all implement it. That is why
> the course pins one standard version on the compile line:
> `-std=c++17` — "translate this using the C++17 rules" — so your code means
> the same thing on every machine.

<a name="2-what-is-a-compiler"></a>
## 2. What is a compiler?

Here is the fundamental problem: your computer's processor understands only
**machine code** — extremely simple instructions encoded as binary numbers.
Humans find machine code unreadable, so we write in C++ and let a
**translator** do the conversion.

A **compiler** is a program that:

1. reads your C++ source file,
2. checks that it follows the language's rules,
3. translates it into machine code,
4. writes the result into a new file — the **executable**.

The compilers used in this course, all free:

| Compiler | You meet it on | Note |
| --- | --- | --- |
| **g++** (from the GNU Compiler Collection, GCC) | [Windows](compiler-setup/windows.md), [Linux](compiler-setup/linux.md) | the course's reference compiler |
| **Clang** (`clang++`) | [macOS](compiler-setup/macos.md) | Apple's compiler; for this course, interchangeable with g++ |
| **MSVC** (Microsoft Visual C++) | optionally on Windows | also speaks standard C++; the course commands below use g++/Clang |

Think of the compiler as a very fast, very literal translator: it never
guesses what you *meant* — only what you *wrote*. That literalness is a
feature: when it complains, it is telling you exactly where your words stop
matching your intention.

And a warning that saves frustration: **the compiler understands the
language, not your goal.** A program can be perfectly grammatical and still
do the wrong thing — that is the difference between the error kinds in
Part IV.

<a name="3-source-code"></a>
## 3. Source code

**Source code** is the text you write — the human-readable instructions,
stored in a plain text file.

For C++ the file name ends in **`.cpp`** (a nod to "C plus plus"). Two
little facts worth knowing early:

- **Plain text only.** A `.cpp` file contains characters, nothing else — no
  fonts, no formatting. If you edit it in Word, you must still save it as
  plain text; the compiler cannot read Word's internal formatting. That is
  why programmers use text editors and IDEs (§7), not word processors.
- **The name matters.** `Hello.cpp` and `hello.cpp` are different files on
  Linux and macOS, and the same file on Windows — because two of our three
  platforms are case-sensitive, the course rule is: **always type file names
  exactly**, and prefer lower-case names like `hello.cpp`.

Source code is for **you and the compiler**. The computer that runs your
program never sees it — it sees only the executable built from it (§6).

<a name="4-compilation"></a>
## 4. Compilation

**Compilation** is the act of running the compiler on your source file. It
is not one invisible step but a small pipeline:

```text
 hello.cpp  ──▶  [preprocessor]  ──▶  [compiler proper]  ──▶  object file
 (your text)      handles #include      translates C++          hello.o
                  and #define           checking rules          (machine code,
                (line 1 below)          as it goes              not yet runnable)
```

You will recognise the first stage: `#include <iostream>` (the `#` lines are
*preprocessor directives*) pastes in the declarations of the input/output
library, so the compiler knows what `std::cout` means before it translates
your code.

The **object file** (`.o` on Linux/macOS, `.obj` on Windows) is the
translated-but-not-finished product: machine code for *your* functions, with
holes where library functions must be plugged in. Those holes are filled by
the next step.

Compilation is also where **compile errors** (§13) are caught: if your code
breaks the language's grammar or type rules, the compiler refuses to
continue and tells you why. Nothing runs until it is satisfied.

<a name="5-linking"></a>
## 5. Linking

An object file is not yet a program. Your code says `std::cout << ...` — but
the *actual* code that does the printing lives in the standard library, plus
some startup code that knows how to call your `main`. **Linking** is the
step that stitches all the pieces into one runnable file:

```text
 hello.o          ┐
 libstdc++ (cout) ├─▶  [linker]  ──▶  hello  (the executable)
 startup code     ┘
```

For this course's one-file programs, the compiler conveniently runs both
stages for you when you write:

```bash
g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
```

That single command compiles *and* links. You will meet the distinction
explicitly when you see the classic linker complaint —
`undefined reference to ...` — which means: *your code mentions a name that
no piece of the program provides* (in this course, almost always a
misspelling or a missing piece, not a deep problem).

> **Vocabulary worth keeping:** *building* = compiling + linking, the whole
> journey from source to runnable program.

<a name="6-executable-programs"></a>
## 6. Executable programs

The **executable** is the finished product: machine code, wrapped for your
operating system, ready to run — usually with no extension on Linux/macOS
and `.exe` on Windows.

| | Source (`hello.cpp`) | Executable (`hello`) |
| --- | --- | --- |
| Contents | text, for humans + compiler | machine code, for the processor |
| Editable | yes — this is your work | no (it is *generated*) |
| Portable? | yes — same file compiles anywhere | no — built for one OS (Windows executables do not run on Linux/macOS) |
| In this course | what you write and keep | rebuilt whenever the source changes |

That last row is the habit this course builds: **keep the source, rebuild
the executable.** If you lose an executable, nothing of value is lost. If
you lose the source, everything is lost. (It is also why `.gitignore` skips
build products — they can always be regenerated.)

> **Portability in one line:** the same `hello.cpp` compiles on Windows,
> Linux, and macOS — you re-compile per platform; you never re-type.

---

# Part II — Your tools

<a name="7-ide-vs-text-editor"></a>
## 7. IDE vs text editor

You need somewhere to edit text files. The two families of tool:

| | **Text editor** (VS Code, Notepad++, vim…) | **IDE** (Visual Studio, Code::Blocks, CLion, Dev-C++…) |
| --- | --- | --- |
| What it is | a smart editor of text files | an all-in-one workshop: editor + compiler + debugger wired together |
| Learning value | shows you the real cycle: you *run* the compiler yourself | hides the cycle behind one button |
| Setup | editor + compiler as separate installs | one install (compiler often bundled) |
| Danger | none, really | dependency — some students can only build inside their IDE |

**Which should you use?** Either — the course is IDE-agnostic. But note the
asymmetry: an editor-plus-compiler student can sit down at any IDE and be
productive in minutes (they know what the buttons *do*), while an
IDE-only student is lost at a bare terminal. The course therefore teaches
**command-line compilation** (§8) as the primary skill and treats any IDE as
a convenience layer over it.

Practical recommendations, per platform:

- **Windows / Linux / macOS:** [VS Code](https://code.visualstudio.com/)
  (free) + its C/C++ extension — see [VS Code tips](../toolchain/vs-code-tips.md)
  for one-keystroke builds and a graphical debugger.
- If your school or a future course mandates Visual Studio, Code::Blocks, or
  CLion — use it happily; everything in this course (standard C++17, the
  compile flags, the workflow) applies unchanged. Only the *button* changes.

<a name="8-command-line-compilation"></a>
## 8. Command-line compilation

The one command this course uses for every single program:

```bash
g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
```

| Piece | Meaning | Why it matters |
| --- | --- | --- |
| `g++` | run the compiler (macOS: `clang++` works identically here) | the tool doing the work |
| `-std=c++17` | use the C++17 rules | same language on every machine |
| `-Wall -Wextra` | enable the useful **warnings** | the compiler's polite "this looks wrong"; treat as must-fix |
| `hello.cpp` | the source file to build | |
| `-o hello` | name the output `hello` | without it you get `a.out` (Linux/macOS) or `a.exe` (Windows) |

**Platform differences — the complete list for this course:**

1. **Compiler name:** Windows/Linux → `g++` · macOS → `clang++` (or `g++`,
   which there is an alias for Clang).
2. **Running the program:** Linux/macOS → `./hello` · Windows PowerShell →
   `.\hello.exe` (CMD: `hello.exe`). The `./` / `.\` prefix means "here in
   this folder".
3. **File listing:** Linux/macOS → `ls` · Windows → `dir`.

Everything else — the flags, the source, the C++ itself — is identical.
(And for symmetry: `clang++ -std=c++17 -Wall -Wextra hello.cpp -o hello`
works on Windows and Linux too, if that's the compiler you installed.)

**Online, no install:** [online compilers](compiler-setup/online-compilers.md)
can run every example through Unit 11 — Compiler Explorer and OnlineGDB both
accept the same flags.

<a name="9-installing-a-c-compiler"></a>
## 9. Installing a C++ compiler

Full step-by-step guides with every click live here:

| Platform | Guide | Installs | Time |
| --- | --- | --- | --- |
| 🪟 Windows | [compiler-setup/windows.md](compiler-setup/windows.md) | g++ via MSYS2 (MinGW-w64) | 20–30 min |
| 🐧 Linux | [compiler-setup/linux.md](compiler-setup/linux.md) | g++ via `apt`/`dnf`/`pacman`/`zypper` | 5–10 min |
| 🍎 macOS | [compiler-setup/macos.md](compiler-setup/macos.md) | Clang via Xcode Command Line Tools | 10–15 min |
| 🌐 No install | [online-compilers.md](compiler-setup/online-compilers.md) | nothing — browser | 0 min |

The short form, so you can see the shape of each:

- **Windows:** install [MSYS2](https://www.msys2.org/), then in the
  **MSYS2 UCRT64** shell: `pacman -S --needed
  mingw-w64-ucrt-x86_64-toolchain`, then add `C:\msys64\ucrt64\bin` to your
  PATH (the guide shows every click).
- **Linux:** one command — Debian/Ubuntu: `sudo apt install build-essential`
  · Fedora: `sudo dnf install gcc-c++` · Arch: `sudo pacman -S base-devel`.
- **macOS:** one command — `xcode-select --install` (installs Clang; you do
  not need the full Xcode IDE).

<a name="10-verifying-the-compiler-installation"></a>
## 10. Verifying the compiler installation

Installation is not done until the terminal can *see* the compiler. Open a
**new** terminal (PATH changes only reach new windows) and run:

```bash
g++ --version
```

macOS:

```bash
clang++ --version
```

Expected — a version line, roughly:

```text
g++ (Rev3, Built by MSYS2 project) 14.2.0        ← Windows (MSYS2)
g++ (Ubuntu 13.2.0-23ubuntu4) 13.2.0             ← Linux
Apple clang version 15.0.0                       ← macOS
```

Reading the result:

- **Version prints** → installed and reachable. Any g++ ≥ 9 or Apple Clang
  from recent macOS handles C++17 comfortably.
- **`command not found` / "not recognized"** → not installed, or not on
  PATH. This is the single most common Week-0 problem — the fix is in the
  [troubleshooting scenarios](getting-started-troubleshooting.md#scenario-1--g-or-clang-command-not-found).
- **An App Store opens on macOS** (older macOS) → the tool may be named
  differently there; follow the [macOS guide](compiler-setup/macos.md).

Then prove the whole pipeline with the course's
[sanity-check program](../toolchain/sanity-check.cpp) — instructions are on
the [orientation hub](index.md#step-2--verify-your-setup-5-min).

<a name="11-your-first-c-program"></a>
## 11. Your first C++ program

Enough machinery — time to write one. Create your course folder (§18 has the
recommended shape; a single folder is fine today), open your editor, and
**type** — don't paste — the following into a file named exactly
`hello.cpp`:

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

This is the traditional first program of nearly every C++ course — small,
but it exercises the *entire* pipeline: source → compile → link → run.

What each piece does (Unit 01 re-derives this in depth; here is the
orientation version):

| Line | Job |
| --- | --- |
| `// …` | a **comment** — for humans, ignored by the compiler |
| `#include <iostream>` | bring in the input/output library (lets us print) |
| `int main() {` | every program starts executing **here** |
| `std::cout << "…\n";` | send text to the console; `\n` starts a new line |
| `return 0;` | report success to the operating system |
| `}` | end of `main` |

The same file lives in the course as
[`01_hello.cpp`](../units/unit-01-introduction-to-programming-and-cpp/examples/01_hello.cpp)
— compare your typing against it if the compiler complains.

<a name="12-compile-and-run"></a>
## 12. Compile and run

In the terminal, **in the folder containing `hello.cpp`**:

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

Expected output, on all three:

```text
Hello, world!
```

(If `hello.cpp` already exists as an executable name collision, or a
previous `hello` is running — just rebuild; the compile overwrites.)

**Silence means success.** A clean compile prints nothing: no news is good
news. Then run — and each time you run, predict first. Change the message,
predict, recompile, run. You have just performed the
**edit–compile–run cycle** — the loop every remaining session of the course
runs inside.

Now make it *yours*: from here, jump to the
[first-program exercise](first-program-exercise.md).

<a name="13-compilation-errors"></a>
## 13. Compilation errors

A **compilation error** (compile-time error) is the compiler refusing to
build: your code broke the rules of the language — misspelled a name,
forgot a `;`, mismatched a brace. The executable is **not created**, so
nothing runs. Examples you will meet this week:

```text
error: expected ';' before '}' token          ← missing semicolon
error: 'cout' was not declared in this scope  ← missing std:: or #include
error: invalid preprocessing directive #inclde ← typo in #include
```

The repair loop: read the **first** error → fix → recompile. Later errors
are usually echoes of the first; fixing one often removes five. Errors are
not scolding — they are the compiler saying precisely where it got
confused, and they are caught **before** anything can misbehave. The full
beginner set lives in the
[error catalogue](../toolchain/compiler-errors.md).

<a name="14-runtime-errors"></a>
## 14. Runtime errors

A **runtime error** passes the compiler, starts running, and then fails:
the program *crashes* or aborts mid-flight. The instructions were legal
C++ — they just asked for something the machine cannot do when it gets
there. Classic cases (each gets its unit later):

| Cause | You'll meet it in |
| --- | --- |
| dividing a number by zero | Unit 02 (arithmetic) |
| reading past the end of a collection | Unit 09 (vectors) |
| dereferencing a null pointer | Unit 13 (pointers) |
| opening a file that isn't there without checking | Unit 12 (file I/O) |

Diagnostic signature: **it compiles, it starts, it dies** (or freezes — a
program stuck in an endless loop is a runtime problem too; `Ctrl+C` stops
it). The repair loop adds a new tool: run the program under a **debugger**
and watch variables until the moment of failure —
[VS Code's debugger](../toolchain/vs-code-tips.md#4-debugging-with-f5) or
the [gdb walkthrough](../toolchain/gdb-walkthrough.md).

<a name="15-logic-errors"></a>
## 15. Logic errors

The sneakest kind — and the professional's daily bread. A **logic error**
compiles cleanly, runs to completion, and produces the **wrong result**.
No message is ever printed, because the machine did *exactly* what the code
says — it is the code that says the wrong thing.

```cpp
// Intent: average of 3 and 5, i.e. 4
std::cout << 3 + 5 / 2 << "\n";   // prints 5 — division binds tighter than +
```

Every character is legal; the meaning is wrong. (Unit 02 teaches the
precedence rule and the parentheses that fix this.)

Because nothing alerts you, logic errors get a *process*, not a fix:

1. **predict before you run** — a wrong prediction is the bug announcing itself
2. **test with values whose answer you know** (3, 5 → 4 is checkable by hand)
3. **trace**: step through with a debugger, or by hand with a trace table
4. **explain aloud** to an imaginary friend — where your explanation stalls
   is where the bug hides

**The three kinds at a glance:**

| | Compile error | Runtime error | Logic error |
| --- | --- | --- | --- |
| Caught | by the compiler | while the program runs | only by *you* |
| Message | yes, with line number | crash message / freeze | none |
| Executable created? | no | yes | yes |
| This course's defence | warnings on, fix-first-error | debugger + validation habits | predict-then-check, always |

<a name="16-how-to-read-compiler-error-messages"></a>
## 16. How to read compiler error messages

A g++ error has a fixed anatomy. Take this one:

```text
hello.cpp:5:22: error: expected ';' before '}' token
    5 |     std::cout << "Hello, world!\n"
      |                      ^            ~
      |                                   ;
```

| Part | Meaning |
| --- | --- |
| `hello.cpp:5:22` | file, **line 5**, column 22 — where the compiler got stuck |
| `error:` | it cannot continue (a `warning:` means "suspicious, but continuing") |
| `expected ';'` | what it needed at that point |
| `before '}' token` | where it expected it — its gaze is at the `}` |
| the excerpt with `^` | it showing you the exact spot |

**The five rules:**

1. **Read the first error only.** Fix it, recompile; the rest usually evaporate.
2. **The reported line is often *after* the real mistake** — "expected `;`
   before `}`" means the missing `;` is one line *up*. Read upward.
3. **Distinguish `error` from `warning`** — errors stop the build; warnings
   don't, but this course fixes them anyway.
4. **Names in the message are clues**: `cout was not declared` → spelling?
   `std::`? missing `#include`?
5. **Reproduce in the smallest program** you can; a 3-line failing example
   is half-fixed already.

Then consult the [error catalogue](../toolchain/compiler-errors.md) — and
your **bug diary**: one line per bug (*what I wrote → what the compiler said
→ the fix*). By Unit 16, that diary is your personalised error textbook.

<a name="17-basic-terminalcommand-line-usage-needed-for-the-course"></a>
## 17. Basic terminal/command-line usage needed for the course

The terminal (command line, console, shell — near-synonyms) is where you
compile and run. The course needs only this set:

| Command | Windows (PowerShell) | Linux / macOS | Does |
| --- | --- | --- | --- |
| where am I? | `pwd` | `pwd` | print working directory |
| what's here? | `dir` | `ls` | list files |
| go into a folder | `cd unit-01` | `cd unit-01` | change directory (down) |
| go up / home | `cd ..` / `cd ~` | `cd ..` / `cd ~` | up one level / home |
| make a folder | `mkdir unit-01` | `mkdir unit-01` | create directory |
| show a file | `type hello.cpp` | `cat hello.cpp` | print file contents |
| stop a run-away program | `Ctrl+C` | `Ctrl+C` | interrupt the running program |

Three habits prevent 90% of beginner terminal pain:

1. **Compile in the folder that holds the file.** If `g++` says
   `no such file or directory: hello.cpp`, you are in the wrong folder —
   `cd` there. (Check with `pwd` + `dir`/`ls` first; it is the #1
   false alarm.)
2. **Tab completion is your friend.** Type `he` then **Tab** — the shell
   completes `hello.cpp`. No typos, ever.
3. **↑ recalls the previous command.** Edit it with ←/→ instead of retyping
   the whole compile line — you will press ↑-Enter hundreds of times.

> **macOS users:** the shell is `zsh` but behaves exactly as above.
> **Windows users:** use **PowerShell** (or Windows Terminal), not the older
> CMD; both work for this course, PowerShell matches the guides.

<a name="18-recommended-project-directory-structure"></a>
## 18. Recommended project directory structure

Sixteen units, three projects, dozens of files: a folder per unit keeps the
course navigable from week 1 to week 16. Recommended shape (create as you
go — the empty ones now would just be noise):

```text
cpp-course/                ← one root folder for the whole course
├── unit-01/
│   ├── hello.cpp          ← lesson examples, typed by you
│   ├── 01_hello.cpp
│   ├── e01_greeting.cpp   ← exercises (naming: §19)
│   ├── lab-01.cpp         ← lab work (naming: §20)
│   └── lab-01-debug-it.cpp
├── unit-02/
│   └── …
├── project-1/             ← when Week 5 arrives
├── project-2/ … project-3/
└── notes/
    └── bug-diary.md       ← your bug diary lives here
```

Rules that make it work:

- **One folder per unit, created in Week N** — you never face an intimidating
  skeleton, and each unit's folder is a finished artefact by Sunday.
- **One program per file, one concept per file.** Every `.cpp` compiles on
  its own; you can rebuild any single idea in seconds.
- **Never `cpp-course` inside a synced/one-drive folder you don't control** —
  compilers and cloud-sync fight; a plain local folder is fine.
- **Back up the folder** (see Git, §22 — this folder is exactly what Git
  tracks beautifully).

<a name="19-how-students-should-save-their-exercises"></a>
## 19. How students should save their exercises

Exercise files follow one naming convention all course long:

```text
eNN_description.cpp        e = exercise, NN = two-digit number
```

| File | Holds |
| --- | --- |
| `e01_greeting.cpp` | exercise 1 — a greeting program |
| `e07_caesar.cpp` | exercise 7 |
| `e12_predict.cpp` | … |

Rules and reasons:

- **`e` + zero-padded number** → every file sorts in attempt order; `e1_…`
  would sort after `e12_…`.
- **A short description** → you can find "the tab one" in a second, months later.
- **One exercise = one file** → each is independently compilable and
  gradeable; nothing depends on anything else.
- **Header comment inside** — every exercise file starts with:

  ```cpp
  // e01_greeting.cpp — Unit 00, exercise 1
  // Task: print a three-line greeting using exactly two cout statements
  // Compile: g++ -std=c++17 -Wall -Wextra e01_greeting.cpp -o e01
  ```

  The *task* line matters: in six months, the file should still explain
  what problem it solves.
- **Attempt first, then compare** with published answers where provided —
  the course's [honesty policy](../assessment.md#honesty-policy-the-honour-system)
  applies to yourself, most of all.

<a name="20-how-students-should-organize-and-submit-lab-work"></a>
## 20. How students should organize and submit lab work

Labs are the course's graded-by-you milestones, and they get a fixed shape
so that self-checking (or an instructor's checking, if you're adopting this
course in a class) is mechanical:

```text
unit-01/
├── lab-01.cpp               ← your finished lab program
├── lab-01-debug-it.cpp      ← the Debug It file after YOU fixed it
├── lab-01-notes.md          ← lab write-up (what goes inside: below)
└── bug-diary entries        ← every bug the lab taught you
```

**The lab write-up (`lab-NN-notes.md`)** — half a page, four headings:

```markdown
# Lab 01 — notes
## What it does          two sentences, plain words
## Sample run            paste one real run from your terminal
## How I built it        3–5 bullets: order of steps, one design choice + why
## Debug It              the bugs I found: what each was, how I found it
```

**How "submission" works in self-study:**

1. Build the lab from the starter; compare output with the brief's expected
   output.
2. Fix the Debug It file *before* reading its fix list.
3. Score yourself against the [lab rubric](../grading.md#lab-rubric-all-labs).
4. Diff against the published solution (ideas, not characters) and write
   one improvement note.
5. **Keep everything** — the folder *is* the submission, in your course
   folder or (recommended, §22) your own GitHub repository.

Students in a formal class: your instructor's submission rules override
these — but the folder shape above is precisely what makes copying your work
into any LMS or email trivial.

<a name="21-how-to-use-the-course-github-pages-site"></a>
## 21. How to use the course GitHub Pages site

The same repository serves two views, and knowing the mapping makes you
fast in both:

| On the website (Pages) | In the repository (GitHub) |
| --- | --- |
| `…/getting-started/index.html` | `docs/getting-started/index.md` |
| `…/units/unit-01…/session-1.1.html` | `docs/units/unit-01…/sessions/session-1.1.md` |
| `…/toolchain/compiler-errors.html` | `docs/toolchain/compiler-errors.md` |

- **Everything is plain Markdown** — readable anywhere, forever; the site
  has no ads, no login, no tracking.
- **Working while offline / on a train?** Open the `.md` files in any editor
  (VS Code renders Markdown with `Ctrl+Shift+V`). The course never requires
  a connection.
- **Navigation patterns:** the [Syllabus](../syllabus.md) links every unit;
  every unit index links its lessons and components; every page ends with a
  breadcrumb back up. The README of the repository is the
  [front door](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/blob/main/README.md).
- **Found a typo or broken link?** The site is maintained through the
  repository — [CONTRIBUTING.md](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/blob/main/CONTRIBUTING.md) shows the 60-second
  way to report it.

<a name="22-optional-gitgithub-introduction"></a>
## 22. Optional Git/GitHub introduction

Completely optional this week — the course needs zero Git. But 10 minutes
now pays off for 16 weeks, because Git solves two problems you already have:
**losing work** and **"it worked yesterday"**.

**The vocabulary, honestly minimal:**

| Term | What it really is |
| --- | --- |
| **repository (repo)** | a folder whose entire history of changes is tracked |
| **Git** | the tool that does the tracking — runs on your machine, offline |
| **GitHub** | a website that hosts Git repositories online (backup + sharing) |
| **commit** | a snapshot of your files with a message describing it |
| **`git clone`** | copy a repository (this is how you got this course, if you cloned it) |

**The three commands that give you an undo button and a time machine:**

```bash
cd cpp-course
git init                      # make this folder a repository (once)
git add .                     # stage everything that changed
git commit -m "Unit 00 complete: hello world + exercises"
```

Repeat `add` + `commit` at the end of each study session. To push to GitHub
as an off-site backup, create an empty repository on github.com, then:

```bash
git remote add origin https://github.com/YOURNAME/cpp-course.git
git push -u origin main
```

(These commands are shown so you know they exist; a full intro unit is
beyond this course's scope — the [GitHub Hello World guide](https://docs.github.com/en/get-started/start-your-journey/hello-world)
is a good zero-to-one walkthrough when you want it.)

Why bother: every commit is a save-point you can return to
(`git checkout`), a record of progress (motivating on hard units), and —
with GitHub — a public portfolio of your 16-week journey that employers can
actually read.

---

## Check yourself

- [ ] I can explain: source → compile → link → executable, in four sentences
- [ ] I know the three error kinds and each one's repair strategy
- [ ] `g++ --version` (or `clang++ --version`) prints a version on my machine
- [ ] I can compile and run `hello.cpp` from the terminal, unaided
- [ ] I know which of `ls`/`dir`, `./`/`.\`, `g++`/`clang++` apply to my OS
- [ ] My `cpp-course/` folder exists and `unit-00/` holds my exercise files
- [ ] I know where the troubleshooting guide lives when something breaks

All checked? → **[Setup Checklist](setup-checklist.md)** to make it official,
then the **[first-program exercise](first-program-exercise.md)**.

---

*[← Orientation hub](index.md) · [Setup checklist](setup-checklist.md) ·
[First-program exercise](first-program-exercise.md) ·
[Troubleshooting](getting-started-troubleshooting.md) ·
[Exercises](getting-started-exercises.md) · [Lab 00](getting-started-lab.md)*
