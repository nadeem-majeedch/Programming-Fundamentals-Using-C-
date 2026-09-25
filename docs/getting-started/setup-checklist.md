---
title: "Setup Checklist"
description: "Your Week-0 setup, step by step, with a definition of done for every platform."
---

# Setup Checklist

> Week 0 · tick every box · [← Orientation hub](index.md) · companion to the
> [Getting Started lesson](getting-started-lesson.md)

Work top to bottom; each box has a **check command** — a setup step isn't
done until its check passes. Expected times: Windows 20–30 min, Linux
5–10 min, macOS 10–15 min.

---

## 1. Compiler installed

**Windows** — follow [compiler-setup/windows.md](compiler-setup/windows.md):
MSYS2 → `pacman -S --needed mingw-w64-ucrt-x86_64-toolchain` → PATH includes
`C:\msys64\ucrt64\bin`.

**Linux** — [compiler-setup/linux.md](compiler-setup/linux.md):
`sudo apt install build-essential` (Debian/Ubuntu) · `sudo dnf install
gcc-c++` (Fedora) · `sudo pacman -S base-devel` (Arch).

**macOS** — [compiler-setup/macos.md](compiler-setup/macos.md):
`xcode-select --install`.

**No install possible?** [Online compilers](compiler-setup/online-compilers.md)
carry you through Unit 11 — but plan a local install before Unit 12 (files).

```text
[ ] Compiler installed (guide above)
```

## 2. Compiler verified

Open a **new** terminal and check (new window = PATH changes applied):

| Platform | Check command | You want to see |
| --- | --- | --- |
| Windows / Linux | `g++ --version` | `g++ … 13.x` or newer (≥ 9 works) |
| macOS | `clang++ --version` | `Apple clang version 15.x` (or similar) |

```text
[ ] Version prints (not "command not found")
```

## 3. Toolchain verified end-to-end

Save the course's [sanity-check.cpp](../toolchain/sanity-check.cpp) into a
new folder, then compile **and run** it:

```bash
g++ -std=c++17 -Wall -Wextra sanity-check.cpp -o sanity-check
./sanity-check            # Windows: .\sanity-check.exe
```

Expected:

```text
My C++ toolchain works!
Compiler standard: C++17
Ready for Lesson 1.
```

```text
[ ] sanity-check compiles with ZERO warnings
[ ] sanity-check runs and prints the three lines
```

## 4. Editor ready

```text
[ ] Editor installed (VS Code recommended — any editor is fine)
[ ] C/C++ extension added (VS Code users) — see toolchain/vs-code-tips.md
```

## 5. Course folder created

```text
[ ] cpp-course/ folder created in a plain local location
[ ] Inside it: unit-00/  (this week's work lives here)
[ ] notes/bug-diary.md created (one line per bug, from day one)
```

## 6. Study plan chosen

```text
[ ] 16-week plan or self-paced — chosen and written down
[ ] How to Study read (the read→run→modify→solve→debug→revise method)
```

## 7. First program compiled and run

Do the [first-program exercise](first-program-exercise.md) — it is the
final proof of setup:

```text
[ ] hello.cpp typed by hand (not pasted)
[ ] compiled warning-free
[ ] ran, and the greeting appeared
[ ] first bug diary entry made (the first typo counts!)
```

---

## Definition of done

**All boxes in sections 1–7 ticked.** That is the whole of Week 0 — you are
officially ready for [Unit 01 · Lesson 1](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md).

Something refuses to work? Work through
[Troubleshooting](getting-started-troubleshooting.md) — every common Week-0
failure has a named scenario there.

---

*[← Orientation hub](index.md) · [Getting Started lesson](getting-started-lesson.md) ·
[Troubleshooting](getting-started-troubleshooting.md)*
