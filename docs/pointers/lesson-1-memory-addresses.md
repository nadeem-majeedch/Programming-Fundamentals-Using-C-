---
title: "Lesson 1 — Memory and Addresses"
description: "What memory is, what an address is, the & and * operators, pointer declaration and initialization, and nullptr."
---

# Lesson 1 — Memory and Addresses

> [← Module home](index.md) · [Lesson 2 — References and functions →](lesson-2-references-functions.md)

## In this lesson you will learn

- that memory is a giant row of numbered boxes, and a running program is boxes + values
- what an **address** is and how to *see* one with `&` (address-of)
- how to declare a **pointer** and what its type really promises
- how to read and write *through* a pointer with `*` (dereference)
- why pointers must be initialized, and what **`nullptr`** is for

---

## 1. Memory — the numbered street

Your computer's memory (RAM) is one enormous row of tiny boxes. Each box holds one **byte** — enough for one `char`. Every box has a number: its **address**. The numbers start at 0 and run into the billions.

```text
address:  ... 1000  1001  1002  1003  1004 ...
box:      ... [  ] [  ] [  ] [  ] [  ] ...
```

Two facts carry this whole unit:

1. **Every variable lives at some address.** When you write `int x = 42;`, the compiler picks a box (say address 1000), and `x` is the *name* you use for it.
2. **A type tells you how many boxes a variable spans.** An `int` usually takes 4 consecutive boxes; a `double` 8; a `char` exactly 1.

```text
                 x (int, 4 bytes, at address 1000)
                 ┌─────┬─────┬─────┬─────┐
addresses:  1000 │ 42  │  0  │  0  │  0  │ 1004: next variable...
                 └─────┴─────┴─────┴─────┘
```

When this course draws memory, it simplifies: **one box per variable**, the address written above it, the value inside. We leave multi-byte details to the compiler — the *shape* of the reasoning is what matters.

```text
        1000
      ┌──────┐
      │  42  │  x
      └──────┘
```

**A variable has three things**, and this unit is about the third:

| Thing | Example | Seen in |
| --- | --- | --- |
| its **name** | `x` | every unit so far |
| its **value** | `42` | every unit so far |
| its **address** | `1000` | *this unit* |

---

<a name="s2-address-of"></a>
## 2. `&` — the address-of operator

The `&` in front of a variable asks the question this unit is built on: *"where do you live?"*

```cpp
#include <iostream>

int main() {
    int x = 42;
    std::cout << "value:   " << x  << '\n';
    std::cout << "address: " << &x << '\n';
}
```

Typical output (yours will differ — the OS decides):

```text
value:   42
address: 0x7ffee3b4a91c
```

That `0x...` string is an address in hexadecimal notation. Don't try to memorize or "understand" the specific number — understand what it **is**: the number of the box where `x` lives. Run it twice; the address may change between runs, because the operating system places the program differently each time. The *unreliable number* is fine — the *relationship* (`&x` is where `x` is) is what never changes.

> **Which `&` is this?** You have already met `&` twice: reference parameters (`int& out`) and logical AND (`&&`). This third use — `&x` in an *expression* — is the **address-of operator**. Same character, different job; context disambiguates.

```text
        1000
      ┌──────┐
      │  42  │  x        &x  →  1000   ("the address of x")
      └──────┘
```

---

<a name="s3-pointers"></a>
## 3. Pointers — a variable that holds an address

An address is just a number — and any number can be *stored*. A **pointer** is a variable whose value is the address of another variable.

Declaration looks like the pointed-to type with a `*`:

```cpp
int* p;        // p is a "pointer to int" — it can hold the address of an int
double* q;     // pointer to double
char* r;       // pointer to char
```

Read `int* p` as: *"p is a variable; the thing at the address p holds is an int."* The type of a pointer is its **promise**: *"if you follow me, you will find an int."*

Give it something to point at with `&`:

```cpp
int x = 42;
int* p = &x;   // p now holds x's address
```

And draw it — this arrow is the mental model for the entire unit:

```text
        1000                2004
      ┌──────┐            ┌──────┐
      │  42  │  x         │ 1000 │  p      p = &x
      └──────┘            └──────┘            ("p points to x")
            ↑___________________|
```

The pointer is an ordinary variable — it has its own name (`p`), its own box (at, say, 2004), and its own value (`1000`). The only special thing about it is what its value *means*: the location of something else. In diagrams we draw that meaning as an **arrow**.

### Reading pointer syntax without panic

Pointer declarations trip beginners because `*` appears in **two different roles**. Keep them separate:

| Code | Role of `*` | Meaning |
| --- | --- | --- |
| `int* p = &x;` | **in a declaration** | "p is a pointer to int" — the `*` is part of the *type* |
| `*p` (anywhere else) | **in an expression** | "follow the arrow" — the dereference operator (next section) |

One more honesty note: `int* p, q;` declares **p as a pointer and q as a plain int** — the `*` binds to the name, not the type. The course style avoids the trap entirely: **one pointer per line, `*` beside the name**:

```cpp
int* p;      // course style
int* q;      // (never:  int* p, q;)
```

---

## 4. `*` — the dereference operator

If `&` is "where do you live?", `*` is the opposite move: *"go where you point and act on what's there."* `*p` means: *follow the arrow in `p`, land on the box it names, and treat that box as the promised type.*

```cpp
int x = 42;
int* p = &x;

std::cout << *p << '\n';   // 42 — follow p to x, read the value
*p = 99;                   // follow p to x, WRITE there — x is now 99
std::cout << x << '\n';    // 99  (x itself changed!)
```

That second line is the moment the unit clicks or doesn't: **`*p = 99;` never mentions `x`, and yet `x` changes.** The pointer didn't copy 99 anywhere — it aimed at x's box and wrote into it.

```text
        1000                2004
      ┌──────┐            ┌──────┐
      │  99  │  x         │ 1000 │  p      *p is another name for x
      └──────┘            └──────┘
            ↑___________________|
```

So `x` and `*p` are **two names for the same box** — the exact idea you know from reference parameters ([functions Lesson 3](../functions/lesson-3-references-testing.md)), except here the alias is *stored* and can be re-aimed later. That storage is the whole difference, and Lesson 2 builds on it.

**Trace this classic:**

```cpp
int a = 5, b = 10;
int* p = &a;
*p = *p + 1;      // a becomes 6  (read through p, add 1, write back through p)
p = &b;           // re-aim the arrow — a untouched
*p = 0;           // b becomes 0
```

Final state: `a = 6`, `b = 0`, `p` points to `b`. Note the two jobs on lines 3 and 4: `*p = ...` writes *through* the arrow; `p = &b` *moves* the arrow. If you can say which one a statement does, you understand pointers.

---

<a name="s5-initialization"></a>
## 5. Initialization and `nullptr`

An uninitialized pointer holds **garbage** — whatever bytes happened to be in its box:

```cpp
int* p;          // ⚠️ points SOMEWHERE RANDOM
std::cout << *p; // ⚠️ undefined behaviour: reads memory you don't own
```

This is the single most important safety rule of the unit ([Module rule 1](index.md#safety-rules)): **never dereference uninitialized.** A pointer with garbage in it aims at an arbitrary box; reading or writing through it is undefined behaviour — it may print nonsense, "work" by luck, or crash. There is no compiler error to save you.

The cure has two forms:

```cpp
int x = 42;
int* p = &x;       // 1. aim it immediately — best when you have a target
int* q = nullptr;  // 2. or aim it at NOTHING, on purpose
```

**`nullptr`** is a special constant meaning *"this pointer intentionally points at nothing."* It is the pointer world's zero — but unlike garbage, null is **checkable**:

```cpp
int* q = nullptr;
if (q != nullptr) {          // the guard — check before following the arrow
    std::cout << *q;
} else {
    std::cout << "q points at nothing\n";
}
```

Dereferencing `nullptr` is also undefined behaviour — the program typically dies instantly with a *segmentation fault*. That sounds bad, but it is the *good* failure mode: null is a loud, immediate, debuggable signal ("nothing was here"), while garbage points fail silently and confusingly. That is exactly why the rule is **initialize to `nullptr`, not to nothing** — you are choosing the failure you can diagnose.

The idiom from Lesson 3 onward: a function that searches returns `nullptr` to say *"not found"*; every caller guards before following. You will write that exact pattern in [Exercises 14–15](exercises.md#solutions-s1--s20).

### The two questions on every line of pointer code

| Question | Operator | Answer shape |
| --- | --- | --- |
| *"Where is it?"* | `&x` | an address |
| *"What's there?"* | `*p` | the value at that address |

They cancel each other: `*&x` is `x` (ask where x lives, then go there — you're back at x). And `&*p` is `p` (follow p, then ask for that box's address — you're back at p).

---

## 6. A complete first program

```cpp
// 01_first_pointer.cpp — Unit 13 · Session 13.1
// Compile: g++ -std=c++17 -Wall -Wextra 01_first_pointer.cpp -o first_pointer
#include <iostream>

int main() {
    int x = 42;
    int* p = &x;                 // p holds x's address

    std::cout << "x       = " << x   << '\n';   // the value
    std::cout << "&x      = " << &x  << '\n';   // where x lives
    std::cout << "p       = " << p   << '\n';   // the same address, stored
    std::cout << "*p      = " << *p  << '\n';   // the value AT that address

    *p = 99;                     // write through the arrow
    std::cout << "x again = " << x   << '\n';   // 99 — same box!

    int* q = nullptr;            // points at nothing, on purpose
    if (q == nullptr)
        std::cout << "q is null - safe to test, not safe to dereference\n";
    return 0;
}
```

Run it. Then **draw the two boxes and the arrow** on paper, with the addresses your machine printed. The exercise set assumes that drawing habit from the first problem.

---

## Practice

- [Exercises 1–6](exercises.md) — addresses, declaration, dereference, re-pointing
- [Tracing 1–4](tracing.md) — draw-then-check memory diagrams
- [Lab 1 — the address printer](labs.md#lab-1--the-address-printer) — see `&` at work, safely

## Key takeaways

- Memory is numbered boxes; an **address** is a box's number; `&x` asks for it
- A **pointer** is a variable whose value is an address; its type is a promise about what's at that address
- `*p` follows the arrow — read *or write*; `*p = 99` changes the pointed-to variable
- `*` in a declaration is part of the type; `*` in an expression is "follow the arrow"
- **Initialize at birth** — aim at a target or aim at `nullptr`; never dereference either garbage or null; guard nulls before following
