---
title: "Getting Started"
description: "Install a C++ compiler, verify it works, choose your study plan, and begin Lesson 1."
---

# Getting Started

> Week 0 · about 30–45 minutes to first program · [Course home](../index.md)

Welcome! This hub gets your machine ready, and the **Getting Started with
C++ module** (below) teaches you how everything works. You are three small
steps from running your first program.

---

## The Getting Started with C++ module

The complete Week-0 module — read it alongside the setup steps below:

| Piece | What it is |
| --- | --- |
| 📖 **[Getting Started lesson](getting-started-lesson.md)** | the full lesson: what C++ is, source → compile → link → run, IDEs vs editors, command-line compilation, installing & verifying, first program, the three error kinds, reading error messages, terminal basics, project folders, saving exercises, lab organisation, using this site, optional Git |
| ☑️ **[Setup checklist](setup-checklist.md)** | every setup step with a check command and a definition of done |
| 🎯 **[First-program exercise](first-program-exercise.md)** | guided build of `hello.cpp` — type, compile, run, break, fix, personalise |
| 🧯 **[Troubleshooting guide](getting-started-troubleshooting.md)** | 12 named scenarios (from `command not found` to cascading errors) + the general method |
| ✏️ **[Exercises](getting-started-exercises.md)** | 10 beginner + 5 challenges, with selected answers |
| 🧪 **[Lab 00 — Your First Build Lab](getting-started-lab.md)** | poster build + seeded-bug Debug It + write-up + self-check |
| 🧠 **[Problem-Solving module](../problem-solving/index.md)** | think before you code: decomposition, IPO, algorithms, pseudocode, trace tables, testing — 20 worked scenarios + lab |

---

## Step 1 — Install a C++ compiler (15–30 min)

Pick your operating system and follow the guide top to bottom:

| Platform | Guide | What it installs |
| --- | --- | --- |
| 🪟 **Windows** | [Windows setup](compiler-setup/windows.md) | g++ via MSYS2 (MinGW-w64) |
| 🐧 **Linux** | [Linux setup](compiler-setup/linux.md) | g++ via your package manager |
| 🍎 **macOS** | [macOS setup](compiler-setup/macos.md) | Clang via Xcode Command Line Tools |
| 🌐 **No install / blocked machine** | [Online compilers](compiler-setup/online-compilers.md) | nothing — runs in the browser |

The course teaches the **command line** way of compiling, because it works
everywhere and teaches you what the tools really do. A few minutes of
[VS Code tips](../toolchain/vs-code-tips.md) later, you can have a one-keystroke
build as well.

## Step 2 — Verify your setup (5 min)

Create a folder for the course, save this as `sanity-check.cpp`
([full file with comments](../toolchain/sanity-check.cpp)):

```cpp
#include <iostream>

int main() {
    std::cout << "My C++ toolchain works!\n";
    return 0;
}
```

Compile and run it in a terminal:

```bash
g++ -std=c++17 -Wall -Wextra sanity-check.cpp -o sanity-check
./sanity-check            # Windows: .\sanity-check.exe
```

You should see:

```text
My C++ toolchain works!
```

**If anything went wrong** — the exact error is usually one of the named
scenarios in the [Troubleshooting guide](getting-started-troubleshooting.md)
or the [FAQ table](../faq.md#troubleshooting-quick-answers).

## Step 3 — Choose your study plan (5 min)

| Plan | Rhythm | Best for |
| --- | --- | --- |
| **16-week plan** | 1 unit per week · 2 sessions of 90–120 min · lab + quiz on the weekend | students following a semester |
| **Self-paced plan** | same order, your calendar | working professionals, irregular schedules |

The method is identical either way — read
[How to Study](../how-to-study.md) once, then follow it per unit.

---

## Orientation checklist

The full, check-command-by-check-command version lives at the
[Setup Checklist](setup-checklist.md); the quick form:

```text
[ ] Compiler installed (guide above)
[ ] sanity-check.cpp compiles and runs
[ ] Getting Started lesson read
[ ] Editor ready (VS Code recommended — see toolchain tips)
[ ] Course folder created, e.g.  cpp-course/unit-00/
[ ] Study plan chosen (16-week / self-paced)
[ ] First-program exercise done, Lab 00 self-checked 5/5
[ ] Problem-Solving module started (lesson + scenarios) — or planned as your first self-paced week
```

All boxes ticked? **You are ready.**

---

## 🚀 Begin: Week 1 → Lesson 1

**[Lesson 1 — What is a program, and how does one run?](../units/unit-01-introduction-to-programming-and-cpp/sessions/session-1.1.md)**

*(After Lesson 1 you'll know what every line above actually does — the
sanity-check program is itself your first specimen.)*

---

*[← Course home](../index.md) · [Syllabus](../syllabus.md) ·
[Setup checklist](setup-checklist.md) · [Troubleshooting](getting-started-troubleshooting.md) · [FAQ](../faq.md)*
