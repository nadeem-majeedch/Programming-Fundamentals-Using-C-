---
title: "FAQ & Troubleshooting"
description: "Quick answers to common questions and problems in Programming Fundamentals Using C++."
---

# FAQ & Troubleshooting

> Quick answers · [Course home](index.md) · [Compiler error catalogue](toolchain/compiler-errors.md)

## Getting started

**Do I need prior programming experience?**
No. The course assumes zero experience and starts from "what is a program?"

**Do I need to install anything?**
A C++ compiler and an editor — the
[Getting Started guide](getting-started/index.md) covers every step for
Windows, Linux, and macOS. Genuinely stuck on installation? Use an
[online compiler](getting-started/compiler-setup/online-compilers.md) and
start Unit 01 today.

**Which C++ standard does the course use?**
Portable **C++17**, compiled with warnings on:
`g++ -std=c++17 -Wall -Wextra file.cpp -o program`. Every example compiles
cleanly with this command.

**How long does the course take?**
16 weeks at 5–7 hours per week — or your own pace. Each session is designed
for 90–120 minutes of study plus practice.

**Can I skip units?**
Not recommended — later units assume earlier ones. If Unit 01 feels slow,
skimming its revision sheet and scoring ≥ 90% on its quiz is the honest way
to move ahead quickly.

---

## Study questions

**I read the lesson but the exercises are hard. Is that normal?**
Yes — exercises are supposed to be attempted before answers are checked.
Struggling for a few minutes per item is the learning. Re-read the section
the exercise points at, then try again.

**Solutions are published. Why attempt anything first?**
Because the attempt is where learning happens, and the
[self-scoring bands](assessment.md#self-scoring-bands) only mean something
if your first score is honest. See the
[honesty policy](assessment.md#honesty-policy-the-honour-system).

**How do I know I'm ready for the next unit?**
Your lab matches the rubric's excellent column and your quiz score is ≥ 90%.
If it's 70–89%, revisit the flagged sections first — see
[How to Study](how-to-study.md#self-scoring-when-is-a-unit-done).

**I can write the code but can't explain it. Is that OK?**
It's a warning sign. Explain each line aloud to an imaginary friend; where
the explanation stalls is where understanding is missing. The
[revision sheets](syllabus.md) exist exactly for this.

---

## Troubleshooting quick answers

**`g++: error: hello.cpp: No such file or directory`**
You're in the wrong folder, or the filename is misspelled. `cd` into the
folder that contains the file, or check the spelling with `ls` (Linux/macOS)
or `dir` (Windows).

**`g++` is not recognized / command not found**
The compiler isn't installed or isn't on your PATH. Re-follow your OS page:
[Windows](getting-started/compiler-setup/windows.md) ·
[Linux](getting-started/compiler-setup/linux.md) ·
[macOS](getting-started/compiler-setup/macos.md). Then reopen the terminal
(so the PATH change takes effect).

**The program compiled but the window closes instantly / I see no output**
Run it from the terminal, not by double-clicking. `./program` (Linux/macOS)
or `.\program.exe` (Windows PowerShell).

**It compiled but prints nothing / prints garbage**
Check that every `std::cout` line ends with `<< std::endl;` or `\n` where
you expected a new line, and that you initialized variables before using
them (Unit 02 covers this in depth).

**I get dozens of errors from one tiny typo**
Normal. Fix the **first** error, recompile — the rest usually vanish.

**My program loops forever**
You probably forgot to update the loop variable. `Ctrl+C` stops the program
in the terminal. Unit 05 teaches the fix patterns.

**Chinese/other characters look wrong in my console output**
The course output is plain ASCII — stick to plain letters in program output
for now. Console encodings are a rabbit hole you can skip.

**VS Code shows red squiggles but the program compiles fine**
The editor's IntelliSense may be misconfigured; follow
[VS Code tips](toolchain/vs-code-tips.md). The compiler's opinion is the one
that counts.

---

## Course logistics

**Is there a certificate?**
The course is self-contained; there is no certificate. Your proof of
completion is real: three projects, a capstone, and a final practice exam —
all published in your own repository if you keep your work on GitHub.

**Can teachers use this course?**
Yes — that's why solutions and rubrics are public. See
[Assessment](assessment.md) and [Grading](grading.md), and the
[licence](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/blob/main/LICENSE).

**How do I report a typo or broken link?**
[CONTRIBUTING.md](https://github.com/nadeem-majeedch/Programming-Fundamentals-Using-C-/blob/main/CONTRIBUTING.md) has a 60-second recipe.

---

*[← Course home](index.md) · [Compiler errors](toolchain/compiler-errors.md)*
