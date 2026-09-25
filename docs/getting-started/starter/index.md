---
title: "Starter Files — Getting Started Lab"
description: "The two starter programs for the Getting Started lab: a skeleton to complete and a seeded-debug exercise."
---

# Starter Files — Getting Started Lab

> [← Getting Started module](../index.md) · [← Course home](../../index.md)

Two small programs support the [Getting Started lab](../getting-started-lab.md).
Download (or retype — retyping is the course's recommendation) each file into
your own practice folder, then compile it yourself:

| File | What it is | What you do with it |
| --- | --- | --- |
| [`lab-00-poster.cpp`](lab-00-poster.cpp) | A skeleton "about me" poster program with `TODO` comments marking the gaps | Complete each `TODO`, compile, and run — your first edit–compile–run cycle |
| [`lab-00-debug-it.cpp`](lab-00-debug-it.cpp) | A small program with seeded errors | Find and fix the errors using the [compiler error catalogue](../../toolchain/compiler-errors.md) |

Both files compile with the course's standard command:

```bash
g++ -std=c++17 -Wall -Wextra lab-00-poster.cpp -o poster
```

After finishing both, continue with the [first-program exercise](../first-program-exercise.md).
