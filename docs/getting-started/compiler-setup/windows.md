---
title: "Setup on Windows"
description: "Install g++ (MinGW-w64) via MSYS2 and verify it compiles C++17."
---

# Setup on Windows

> MSYS2 + MinGW-w64 g++ · ~20–30 minutes · part of [Compiler Setup](index.md)

## 1. Install MSYS2

1. Go to **<https://www.msys2.org/>** and download the installer
   (`msys2-x86_64-*.exe`).
2. Run it, keep the default install location (`C:\msys64`), and finish.
3. Open **MSYS2 UCRT64** from the Start menu (important: UCRT64, not plain
   MSYS2) and update the package database:

   ```bash
   pacman -Syu
   ```

   If it asks to close the window, close and reopen **MSYS2 UCRT64**, then run:

   ```bash
   pacman -Su
   ```

## 2. Install the compiler and tools

Still in **MSYS2 UCRT64**:

```bash
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
```

Press Enter to accept the default package group. This installs `g++`,
`gdb` (a debugger), and `make`.

## 3. Add the compiler to your PATH (so PowerShell/CMD find it)

1. Press Start, type **"environment variables"**, open
   *"Edit the system environment variables"* → **Environment Variables…**
2. Under *User variables*, select **Path** → **Edit** → **New**
3. Add exactly: `C:\msys64\ucrt64\bin`
4. OK → OK → OK.

## 4. Verify

Open a **new** PowerShell window (PATH changes apply to new windows only):

```powershell
g++ --version
```

You should see something like `g++.exe (Rev3, Built by MSYS2 project) 14.x.x`.
Any 13+ version is comfortable; ≥ 9 works for this course.

## 5. First compile

```powershell
mkdir C:\code\cpp-course\unit-01; cd C:\code\cpp-course\unit-01
notepad hello.cpp        # paste the sanity-check program, save
g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
.\hello.exe
```

You should see the program's output. If `g++` is not recognized, re-check
step 3 (and open a fresh window). More help:
[FAQ troubleshooting](../../faq.md#troubleshooting-quick-answers).

## 6. Editor (recommended, 5 min)

Install [Visual Studio Code](https://code.visualstudio.com/) and the
**C/C++ extension** (publisher: Microsoft), then follow
[toolchain/vs-code-tips.md](../../toolchain/vs-code-tips.md) for a
one-keystroke build and a working debugger.

---

**Next:** [verify with the course's sanity check](../index.md#step-2--verify-your-setup-5-min)
→ then [Lesson 1](../../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md).
