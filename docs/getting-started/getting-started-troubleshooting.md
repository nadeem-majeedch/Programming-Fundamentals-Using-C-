---
title: "Troubleshooting Guide"
description: "Every common Week-0 failure, named, explained, and fixed — plus the general debugging method."
---

# Troubleshooting Guide

> When setup or compilation misbehaves · [← Orientation hub](index.md) ·
> deeper C++ errors: [error catalogue](../toolchain/compiler-errors.md)

**How to use this page:** find the *exact message or symptom* you see; each
scenario names the cause and the fix. Nothing here matches? Work the general
method at the bottom, then ask in the repository
[issue tracker](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/issues)
with your full error text.

---

## Setup scenarios

### Scenario 1 — g++ or clang++ command not found

**Symptom (Windows PowerShell):**

```text
g++ : The term 'g++' is not recognized as a name of a cmdlet, function, ...
```

**Symptom (Linux/macOS):**

```bash
bash: g++: command not found
```

**Cause:** the compiler is not installed, or it is installed but the
terminal doesn't know where to find it (the `PATH`).

**Fix, in order:**

1. **Installed at all?**
   - Windows: does `C:\msys64\ucrt64\bin\g++.exe` exist? No → run the
     [Windows guide](compiler-setup/windows.md) from step 1.
   - Linux: `which g++` prints nothing → install
     (`sudo apt install build-essential` / `dnf install gcc-c++` /
     `pacman -S base-devel`).
   - macOS: run `xcode-select --install`, then check `clang++ --version`.
2. **Installed but not found (Windows)?** → PATH. Start → "environment
   variables" → *User variables* → `Path` → Edit → New →
   `C:\msys64\ucrt64\bin` → OK ×3. Then **open a new PowerShell** — running
   windows never pick up PATH changes. Verify: `g++ --version`.
3. **Windows, MSYS2 installed but no UCRT64 folder?** You installed MSYS2
   but not the toolchain: open **MSYS2 UCRT64** and run
   `pacman -S --needed mingw-w64-ucrt-x86_64-toolchain`.

### Scenario 2 — sanity-check compiles but the run "does nothing" / window flashes

**Symptom:** you double-click `hello.exe`; a window blinks and vanishes.

**Cause:** console programs write to a *console* — double-clicking spawns a
console that closes the instant the program ends.

**Fix:** always run from the terminal you compiled in:
`.\hello.exe` (Windows) / `./hello` (Linux/macOS). You get output *and* it
stays visible.

### Scenario 3 — `no such file or directory` when compiling

**Symptom:**

```text
g++: error: hello.cpp: No such file or directory
```

**Cause:** the terminal is in a different folder than the file. (The #1
false alarm in Week 0 — nothing is broken.)

**Fix:**

```bash
pwd                       # where am I?
ls                        # or: dir (Windows) — is hello.cpp listed?
cd path\to\cpp-course\unit-00   # cd into the folder that HAS the file
```

Then compile again. Prevent it: open the terminal *from* the editor
(VS Code: Terminal → New Terminal) so both share the folder; or use Tab
completion so the shell never misspells a name for you.

### Scenario 4 — `Permission denied` when running

**Symptom (Linux/macOS):**

```bash
bash: ./hello: Permission denied
```

**Causes & fixes:**

- You typed `./hello.cpp` (the source, not the executable) — run
  `./hello`.
- The file exists but isn't marked executable (rare after a fresh compile):
  `chmod +x hello`, then `./hello`.
- On macOS, first-run of a downloaded binary can be blocked by Gatekeeper —
  for *locally compiled* programs this is rare; recompiling resolves it.

### Scenario 5 — warning about unsupported standard / old compiler

**Symptom:**

```text
cc1plus: warning: unrecognized command-line option '-std=c++17'
-- or --
error: unrecognized command line option '-std=c++17'
```

**Cause:** a compiler older than g++ 7 (C++17 needs ≥ 7; this course prefers
≥ 9).

**Fix:** upgrade — Windows: reinstall the current MSYS2 toolchain
([guide](compiler-setup/windows.md)); Linux: your distribution's package
manager gives you a modern g++ (if the distro is ancient, `sudo apt install
g++-12` style versioned packages exist); macOS: update macOS / Command Line
Tools. As a stopgap, `-std=c++11` compiles most early examples, but fix the
compiler properly before Unit 09.

### Scenario 6 — VS Code shows red squiggles although the program compiles

**Cause:** the editor's IntelliSense hasn't found your compiler; the
*compiler's* verdict is the one that counts.

**Fix:** follow [vs-code-tips.md](../toolchain/vs-code-tips.md) — select the
compiler (Command Palette → *C/C++: Select a Compiler* → the MSYS2/UCRT64 or
system g++), and build with `Ctrl+Shift+B`. Squiggles that disagree with a
clean `g++` compile are the editor's problem, not yours.

### Scenario 7 — Windows: `.\hello.exe : cannot be loaded... running scripts is disabled`

**Symptom:** appears when using `.\` in some locked-down PowerShell setups.

**Explanation:** that policy error concerns PowerShell *scripts*, not your
program — but it can mask the run. Workarounds: use `cmd` (`hello.exe`) or
run the program from the VS Code terminal; if it persists,
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` (one-time, per-user)
restores normal behaviour. The compile itself is unaffected either way.

---

## Compilation-error scenarios (first week's classics)

### Scenario 8 — `expected ';' before '}' token` (or before anything)

```text
hello.cpp:5:22: error: expected ';' before '}' token
```

**Cause:** the statement **one line above** the reported spot lacks its `;`.
**Fix:** add it. Remember: the reported line is *after* the mistake — read
upward.

### Scenario 9 — `... was not declared in this scope`

```text
error: 'cout' was not declared in this scope
error: 'sting' was not declared in this scope
```

**Cause, in order of likelihood:** (1) typo (`sting` → `string`, `cuot` →
`cout`); (2) missing `std::` prefix; (3) missing `#include <iostream>`.
**Fix:** check spelling letter by letter, add `std::`, add the include.

### Scenario 10 — `invalid preprocessing directive #inclde`

**Cause:** a typo in a `#` line. **Fix:** `#include <iostream>` — note
spelling, the `< >`, and no `;` on `#` lines ever.

### Scenario 11 — `undefined reference to 'main'` (or to some function)

```text
/usr/lib/.../collect2 ... undefined reference to `main'
```

**Cause:** a **linker** error — you compiled a file that has no `main`
(misspelled it? `int Main()`?), or the compile command is missing the file.
In this course it's nearly always: check that the function is really named
`main` and that you're compiling the file you think you are.

### Scenario 12 — a dozen errors from one tiny typo

**Cause:** cascading echoes — compilers keep translating after the first
mistake and everything downstream confuses them. **Fix:** read only the
**first** error, fix, recompile. Normal to watch 12 errors become 1 become 0.

---

## Runtime & logic (a taste of what's coming)

- **Program loops forever** → `Ctrl+C` stops it; you probably never update
  the loop variable. Unit 05 is devoted to this family.
- **Compiles, runs, wrong answer, no message** → a *logic* error. Predict
  the output by hand first, test with values you can check, trace in the
  debugger ([VS Code](../toolchain/vs-code-tips.md#4-debugging-with-f5) /
  [gdb](../toolchain/gdb-walkthrough.md)).
- **Crash with a number (`exit code -1073741819`, `Segmentation fault`)** →
  runtime error; the program did something the OS forbids. You'll earn the
  tools to pin these down in Units 09–13.

---

## The general method (when no scenario matches)

1. **Read the *first* error, fully.** Line number → message → the `^` marker.
2. **Look at that line and the line above it.**
3. **Fix one thing, recompile.** Never fix five things at once.
4. **Shrink the problem:** comment out half the program; does it build?
   Re-add until it breaks — the bug is in the last block you added.
5. **Explain it aloud** (rubber-duck style): what should this line do?
6. **Search the catalogues:**
   [setup scenarios](#setup-scenarios) ·
   [compile scenarios](#compilation-error-scenarios-first-weeks-classics) ·
   [error catalogue](../toolchain/compiler-errors.md) ·
   [FAQ](../faq.md#troubleshooting-quick-answers).
7. **Still stuck after ~30 focused minutes?** Ask — with the *exact* command,
   the *full* error text, and your OS. (And add a bug-diary line: future-you
   will smile.)

---

*[← Orientation hub](index.md) · [Setup checklist](setup-checklist.md) ·
[Getting Started lesson](getting-started-lesson.md)*
