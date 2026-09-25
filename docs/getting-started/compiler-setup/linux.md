---
title: "Setup on Linux"
description: "Install g++ and build-essential with your distribution's package manager."
---

# Setup on Linux

> g++ via your package manager · ~5–10 minutes · part of [Compiler Setup](index.md)

## 1. Install the toolchain

Open a terminal and use your distribution's command:

**Debian / Ubuntu / Mint / WSL (Ubuntu):**

```bash
sudo apt update
sudo apt install -y build-essential gdb
```

**Fedora / RHEL / CentOS:**

```bash
sudo dnf install -y gcc-c++ make gdb
```

**Arch / Manjaro:**

```bash
sudo pacman -S --needed base-devel gdb
```

**openSUSE:**

```bash
sudo zypper install -y gcc-c++ make gdb
```

(The course only *requires* the compiler; `gdb` is optional and used by the
[debugging walkthrough](../../toolchain/gdb-walkthrough.md) later.)

## 2. Verify

```bash
g++ --version
```

Any g++ ≥ 9 works for this course; 13+ is comfortable. Most distributions
from the last few years already qualify.

## 3. First compile

```bash
mkdir -p ~/code/cpp-course/unit-01 && cd ~/code/cpp-course/unit-01
nano hello.cpp        # paste the sanity-check program, save with Ctrl+O, exit Ctrl+X
g++ -std=c++17 -Wall -Wextra hello.cpp -o hello
./hello
```

You should see the program's output. Errors? See
[FAQ troubleshooting](../../faq.md#troubleshooting-quick-answers).

## 4. Editor (recommended, 5 min)

Install [Visual Studio Code](https://code.visualstudio.com/) (or use your
favourite editor), add the **C/C++ extension**, and follow
[toolchain/vs-code-tips.md](../../toolchain/vs-code-tips.md) for a
one-keystroke build and a working debugger.

> **On Windows but using WSL?** Everything above works inside WSL Ubuntu.
> Compile and run inside the WSL terminal; the
> [VS Code Remote-WSL](https://code.visualstudio.com/docs/remote/wsl) setup
> keeps editing comfortable.

---

**Next:** [verify with the course's sanity check](../index.md#step-2--verify-your-setup-5-min)
→ then [Lesson 1](../../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md).
