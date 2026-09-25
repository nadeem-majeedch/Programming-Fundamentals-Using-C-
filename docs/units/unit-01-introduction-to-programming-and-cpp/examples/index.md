---
title: "Unit 01 — Example Programs"
description: "The three annotated example programs of Unit 01: hello world, program anatomy, and output basics."
---

# Unit 01 — Example Programs

> [← Unit 01 index](../index.md) · [← Course home](../../../index.md)

Three small programs accompany the Unit 01 sessions. Each is annotated line
by line — read the comments, then compile and run.

| File | Session | The lesson inside |
| --- | --- | --- |
| [`01_hello.cpp`](01_hello.cpp) | [Session 1.1](../sessions/session-1.1.md) | The smallest complete program: include, `main`, one output statement |
| [`02_anatomy.cpp`](02_anatomy.cpp) | [Session 1.2](../sessions/session-1.2.md) | The same program annotated piece by piece — what each line *is* |
| [`03_output_basics.cpp`](03_output_basics.cpp) | [Session 1.2](../sessions/session-1.2.md) | `cout` chaining, `endl` vs `\n`, escapes, and the predict-then-run loop |

Compile any of them with the course's standard command:

```bash
g++ -std=c++17 -Wall -Wextra 01_hello.cpp -o hello
./hello
```

These examples are the Unit 01 teaching set; the complete maintained
[Foundations module](../../../cpp-foundations/index.md) builds directly on them.
