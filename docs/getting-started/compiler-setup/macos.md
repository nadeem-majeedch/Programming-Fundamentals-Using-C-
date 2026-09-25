---
title: "Setup on macOS"
description: "Install the Clang compiler via Xcode Command Line Tools and verify C++17."
---

# Setup on macOS

> Apple Clang via Xcode Command Line Tools · ~10–15 minutes · part of
> [Compiler Setup](index.md)

## 1. Install the Command Line Tools

Open **Terminal** (Applications → Utilities → Terminal) and run:

```bash
xcode-select --install
```

A dialog appears — choose **Install** (you do *not* need the full Xcode
IDE). When it finishes, the `clang++` compiler and `make` are installed.

**Note:** on Apple Silicon Macs, the Command Line Tools include a `g++`
command that is actually Clang. That's fine — it compiles this course
perfectly. Wherever the course says `g++`, `clang++` (or that `g++` alias)
behaves the same for our purposes.

## 2. Verify

```bash
clang++ --version
```

You should see `Apple clang version 15.x.x` (or similar). Any Apple Clang
from recent macOS versions compiles C++17 out of the box.

## 3. First compile

```bash
mkdir -p ~/code/cpp-course/unit-01 && cd ~/code/cpp-course/unit-01
nano hello.cpp        # paste the sanity-check program; Ctrl+O to save, Ctrl+X to exit
clang++ -std=c++17 -Wall -Wextra hello.cpp -o hello
./hello
```

You should see the program's output. Errors? See
[FAQ troubleshooting](../../faq.md#troubleshooting-quick-answers).

## 4. Editor (recommended, 5 min)

Install [Visual Studio Code](https://code.visualstudio.com/) and the
**C/C++ extension**, then follow
[toolchain/vs-code-tips.md](../../toolchain/vs-code-tips.md) for a
one-keystroke build and a working debugger.

---

**Next:** [verify with the course's sanity check](../index.md#step-2--verify-your-setup-5-min)
→ then [Lesson 1](../../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md).
