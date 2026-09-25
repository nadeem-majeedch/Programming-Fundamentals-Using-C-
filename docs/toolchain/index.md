---
title: "Toolchain — Reference Material"
description: "Compiler errors catalogue, the sanity-check program, the gdb walkthrough, and VS Code tips — the course's tool reference shelf."
---

# Toolchain — Reference Material

> [← Course home](../index.md)

Reference material for the tools you use every session. You do not read this
shelf front to back — you reach for a page when something bites.

| Page / file | What it covers |
| --- | --- |
| [`sanity-check.cpp`](sanity-check.cpp) | The one-file compiler verification program — compile and run it after installing a toolchain ([setup checklists](../getting-started/setup-checklist.md)) |
| [`compiler-errors.md`](compiler-errors.md) | The compiler error catalogue: the messages beginners actually meet, decoded line by line |
| [`gdb-walkthrough.md`](gdb-walkthrough.md) | A first session with the debugger: breakpoints, stepping, inspecting variables |
| [`vs-code-tips.md`](vs-code-tips.md) | Editor setup that pays off in every session: build tasks, warnings, run configuration |

Quick start — verify your compiler with:

```bash
g++ -std=c++17 -Wall -Wextra sanity-check.cpp -o sanity
./sanity
```

If any step fails, the [Getting Started troubleshooting guide](../getting-started/getting-started-troubleshooting.md)
walks through the usual causes.
