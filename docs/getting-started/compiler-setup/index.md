---
title: "Compiler Setup"
description: "Install a C++ compiler on Windows, Linux, or macOS — or use an online compiler."
---

# Compiler Setup

> Choose your platform · part of [Getting Started](../index.md)

The course compiles examples with this command (you'll meet it properly in
Lesson 1):

```bash
g++ -std=c++17 -Wall -Wextra file.cpp -o program
```

Any modern compiler works — the guides below install **g++** (Windows, Linux)
or **Clang** (macOS), both free.

| Platform | Guide | Compiler you get |
| --- | --- | --- |
| 🪟 Windows | [windows.md](windows.md) | g++ (MinGW-w64 via MSYS2) |
| 🐧 Linux | [linux.md](linux.md) | g++ |
| 🍎 macOS | [macos.md](macos.md) | Clang |
| 🌐 Browser only | [online-compilers.md](online-compilers.md) | g++/Clang online |

**Already have a compiler?** Check by opening a terminal and running:

```bash
g++ --version     # or: clang++ --version
```

If you see a version (13 or newer for g++ is comfortable, anything ≥ 9
works for this course), you can go straight to
[Step 2 of Getting Started](../index.md#step-2--verify-your-setup-5-min).

**Editor:** the course recommends [Visual Studio Code](https://code.visualstudio.com/)
(free) with its C++ extension; setup tips live in
[toolchain/vs-code-tips.md](../../toolchain/vs-code-tips.md). Any editor you
already like is fine — the compiler is what matters.

---

*[← Getting Started](../index.md) · [FAQ](../../faq.md)*
