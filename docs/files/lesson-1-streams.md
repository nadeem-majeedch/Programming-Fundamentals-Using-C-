---
title: "Lesson 1 — Streams: Writing and Reading Files"
description: "Files and persistent data, the stream concept, ofstream, ifstream, fstream, opening/closing/checking, and the first complete round trip."
---

# Lesson 1 — Streams: Writing and Reading Files

> [← Module home](index.md) · [Lesson 2 — Reading strategies and file formats →](lesson-2-reading-writing.md)

## In this lesson you will learn

- what **files and persistent data** are — and what changes when data survives the program
- the **stream** idea: file I/O is `cin`/`cout` with a different destination
- **ofstream** — opening a file for writing (and what that does to an existing file!)
- **ifstream** — opening a file for reading, and **checking whether it opened**
- **fstream** — one object, both directions, with **modes** (append previewed here, detailed next lesson)
- **closing** files, and the first complete write→read round trip

One `#include` powers the unit: `<fstream>`. It brings in `ofstream`, `ifstream`, and `fstream`.

---

## 1. Files and persistent data

A **file** is a named sequence of bytes on disk. A **text file** is one whose bytes are characters — lines separated by `\n` — the kind this course works with (binary files are real; they're a later story).

The word that changes everything is **persistent**. Compare the two homes your data can have:

| | Variables (memory) | Files (disk) |
| --- | --- | --- |
| Lifetime | while the program runs | **after the program ends** |
| Size | limited by RAM | limited by disk |
| Speed | very fast | slower |
| Created by | your declarations | `ofstream` / `new` (files) |

Until now, "save" has been impossible: exit the program, lose the roster. Files give programs a *memory of their own* — the [Student Record Management System](../records/miniproject.md) rebuilt its roster by hand every run; this unit's mini-project won't have to.

**The working model for this unit:** a text file is just what you see in a text editor — numbered lines of characters. Every file skill here is really the skill of *agreeing on those lines*: what each line contains, in what order, separated by what.

---

## 2. Streams — the idea you already know

A **stream** is a sequence of data flowing in one direction, with an interface you have used since Unit 03:

```cpp
std::cout << "hello";      // characters flow OUT to the console
std::cin  >> x;            // characters flow IN from the keyboard
```

`cin` and `cout` are streams — you just never had to care. The file streams are the same three operators pointed at a file:

```cpp
outFile << "hello";        // characters flow OUT to a FILE on disk
inFile  >> x;              // characters flow IN from a FILE on disk
```

The verbs are identical: `<<` writes, `>>` reads (whitespace-delimited, exactly as with `cin`), `getline(stream, s)` reads a line. If you understood the [I/O module](../cpp-io/index.md), you understand file I/O — the stream is just *plugged into a different wall*. Even the mixing trap survives: a `>>` on a file stream leaves a newline that a following file-`getline` will read as an empty line — [S12](exercises.md#s12) makes you fix it.

---

## 3. Opening files — three stream types

### ofstream — output (writing)

```cpp
#include <fstream>

std::ofstream outFile("notes.txt");
outFile << "first line\n";
outFile << "second line\n";
outFile.close();
```

Run it: a file named `notes.txt` appears beside your program (or in the **working directory** — where the program was launched; on some IDEs that is *not* the source folder, the classic "where did my file go?" mystery). Two names matter: the *filename string* is the disk name; the *stream variable* (`outFile`) is your handle to it in code.

⚠️ **The default open erases.** `ofstream outFile("notes.txt");` on an **existing** file **truncates it to zero** before you write a word. There is no undo. If the goal is "add to what's there", that's **append mode** — [Lesson 2 §1](lesson-2-reading-writing.md#1-modes--and-append-the-file-open-contract). For now: the plain ofstream open *is* the fresh-start operation — one of its legitimate jobs.

### ifstream — input (reading)

```cpp
std::ifstream inFile("notes.txt");
std::string line;
while (std::getline(inFile, line))          // read until the file runs out
    std::cout << line << '\n';
inFile.close();
```

`getline` works here exactly as with `cin` — one line per call, newline consumed. The `while (getline(...))` loop is *the* file-reading idiom: it runs once per line and stops when the data ends. Why the loop condition looks like that is §5 — it's the most important subtlety of the unit.

### fstream — both directions

```cpp
std::fstream file("log.txt", std::ios::in | std::ios::out);  // read AND write
std::fstream appender("log.txt", std::ios::out | std::ios::app);  // append
```

An `fstream` opens with **modes** joined by `|` (bitwise-or — treat the idiom as vocabulary for now):

| Mode flag | Meaning |
| --- | --- |
| `std::ios::in` | allow reading |
| `std::ios::out` | allow writing |
| `std::ios::app` | **append** — every write lands at the end, existing data survives |
| `std::ios::trunc` | truncate — the ofstream default |

You have already used this dance without knowing it — every `cin`/`cout` operation consults the stream's state, and files do too. An `ifstream` opened on a missing file fails *at open*; an `ofstream` almost always succeeds (it *creates* the file) but can fail on permissions or a bad path. Which brings us to the rule that tops the module.

## 4. The open check — always, before any use

⚠️ **Module rule #1, stated once, in bold, forever: check whether the file opened before using it.**

```cpp
std::ifstream inFile("grades.txt");
if (!inFile.is_open()) {                       // or: if (!inFile)
    std::cout << "could not open grades.txt\n";
    return 1;                                  // the guard-chain exit — [decisions module](../decisions/index.md)
}
// ...only NOW read from it...
```

Why, when ofstream creates files anyway? Because reading a **missing** file (a typo'd name, wrong folder, file not created yet by a previous step) fails *silently by default* — the subsequent reads do nothing, produce no data, no error, and your "empty report" bug is actually a never-opened-file bug. `is_open()` converts that silence into a message you control. The one-line version — `if (!inFile)` — uses the stream-to-bool conversion: a stream *is* true while healthy, false after failure.

**Closing** with `.close()` disconnects the handle. For output it matters concretely: file streams **buffer** — they collect characters in memory and flush them to disk in batches, and `.close()` flushes the remainder. (Streams also auto-close when the variable goes out of scope — but explicit close at the end of the work, before you claim the file is written, is the course habit. Close also *releases* the file so other programs — and your own next run — can open it.)

The full discipline, four words, every time: **open → check → use → close.**

---

<a name="5-reading-until-the-data-runs-out"></a>
## 5. Reading until the data runs out

The file-reading loop you will write for the rest of your career:

```cpp
std::string line;
while (std::getline(inFile, line)) {
    // process line — this runs once per line, in order
}
```

Why the read is *in the condition*: `getline` (and `>>`) return the stream, and the stream converts to true while healthy. When `getline` hits end-of-file (**EOF**), it fails — sets the fail state — and the stream converts to false, ending the loop. One line: read, test, process — no off-by-one, no leftover-partial-line.

⚠️ The beginner-shaped alternative breaks:

```cpp
while (!inFile.eof()) {                    // ⚠️ the classic trap
    std::getline(inFile, line);            // when the LAST read consumed the final newline,
    std::cout << line << '\n';             // eof() is still false — this processes an EMPTY line
}
```

`eof()` only becomes true *after* a read **attempted to read past** the end. Just before the end, it's false, so the loop body runs one more time on an empty line (the [mixing-trap's cousin](../cpp-io/lesson-3-getline.md)). The condition-idiom can't have this bug. The full story — including "an empty last line *is* data" — is [Lesson 3 §2](lesson-3-errors-mistakes.md#2-eof-and-the-stream-state).

---

## 6. A complete first round trip

Write it, then read it back — the unit's fundamental experiment:

```cpp
// 01_roundtrip.cpp — Unit 12 · Session 12.1
// Compile: g++ -std=c++17 -Wall -Wextra 01_roundtrip.cpp -o roundtrip
#include <iostream>
#include <fstream>
#include <string>

int main() {
    // ---- WRITE ----
    std::ofstream outFile("todo.txt");
    if (!outFile.is_open()) { std::cout << "write open failed\n"; return 1; }
    outFile << "buy milk\n";
    outFile << "finish C++ worksheet\n";
    outFile << "call the registrar\n";
    outFile.close();

    // ---- READ BACK ----
    std::ifstream inFile("todo.txt");
    if (!inFile.is_open()) { std::cout << "read open failed\n"; return 1; }
    std::string line;
    int n = 1;
    while (std::getline(inFile, line)) {
        std::cout << n << ": " << line << '\n';
        n += 1;
    }
    inFile.close();
    return 0;
}
```

```text
todo.txt (as the editor sees it)
buy milk
finish C++ worksheet
call the registrar

program output:
1: buy milk
2: finish C++ worksheet
3: call the registrar
```

Open the produced file in an editor and *verify with your eyes* — the file's contents are now part of your program's contract. Then the round trip closes: what you wrote is what you read. [Lab 1](labs.md#lab-1--student-record-file) scales exactly this skeleton to records.

---

## Practice

- [Exercises 1–7](exercises.md) — streams, open-check, the round trip
- [Lab 1 — Student Record File](labs.md#lab-1--student-record-file)

## Key takeaways

- **Files make data persistent** — disk outlives the program; memory doesn't
- File streams are `cin`/`cout` with a different destination: **ofstream** writes, **ifstream** reads, **fstream** does both with mode flags (`app` for append)
- The plain ofstream open **truncates** — fresh start by default; append mode comes next lesson
- **Open → check → use → close**: `is_open()` turns silent failure into a message; `close()` flushes the buffer
- Read with `while (std::getline(in, line))` — the read *in the condition* is the EOF-safe idiom; `eof()` as a loop condition is the classic trap
