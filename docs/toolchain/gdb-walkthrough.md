---
title: "gdb Walkthrough"
description: "Optional: debug C++ from the terminal with gdb — breakpoints, stepping, watching variables."
---

# gdb Walkthrough (optional)

> For terminal-comfortable students · [VS Code's debugger](vs-code-tips.md) covers the same ideas graphically

`gdb` is the classic terminal debugger. Nothing in the course *requires* it,
but ten minutes here pays off from Unit 05 (loops) onward.

## 1. Compile for debugging

Add the `-g` flag so the executable carries line information:

```bash
g++ -std=c++17 -Wall -Wextra -g myprogram.cpp -o myprogram
```

## 2. Start gdb

```bash
gdb ./myprogram
```

## 3. The five commands that matter

| Command | Effect |
| --- | --- |
| `break 12` (or `b main`) | stop when execution reaches line 12 / function `main` |
| `run` | start the program; it stops at your breakpoint |
| `next` (`n`) | execute the current line, stay inside the function |
| `print total` (`p total`) | show a variable's current value |
| `continue` (`c`) | resume until the next breakpoint / the end |

`quit` (or `q`) leaves gdb. `list` shows the source around the current line.

## 4. A tiny session

```text
(gdb) break main
Breakpoint 1 at 0x401106
(gdb) run
Starting program: ./myprogram
Breakpoint 1, main () at myprogram.cpp:5
5       int total = 0;
(gdb) next
6       total = total + 5;
(gdb) print total
$1 = 0
(gdb) next
7       std::cout << total << "\n";
(gdb) print total
$2 = 5
```

You just watched `total` change from 0 to 5 — this is exactly how you'll
hunt off-by-one bugs in Unit 05 and pointer bugs in Unit 13.

## 5. When your program crashes

Run it inside gdb with `run`; when it crashes, type `backtrace` (`bt`) —
gdb prints the chain of function calls that led to the crash, which is the
fastest possible diagnosis.

---

*[← Toolchain](../getting-started/index.md) · [Compiler errors](compiler-errors.md)*
