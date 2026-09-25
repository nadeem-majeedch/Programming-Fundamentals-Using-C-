---
title: "Lesson 1 — The Function Machine"
description: "Declaration, definition, calling, parameters vs arguments, return values, void functions, visual call flow, and trace tables for calls."
---

# Lesson 1 — The Function Machine

> [← Module home](index.md) · Lesson 1 of 4 · [Lesson 2 — Copies, scope, prototypes →](lesson-2-scope.md)

## In this lesson you will learn

- what a function is — a named machine with inputs and (usually) an output
- the three verbs of function life: **declaration**, **definition**, **call**
- **parameters vs arguments** — the slots vs the values
- return values, `void`, and the two jobs of `return`
- how to *see* a running call stack — the visual model behind every call
- how to trace functions in a dry-run table

Everything here uses the loop and idiom skills from [Iteration](../repetition/index.md) — functions don't replace loops, they *name* them.

---

## 1. Why functions matter

Three costs grow as a `main()` grows, and functions pay all three down:

1. **Duplication** — the same three lines of tax computation in four places means four places to fix a bug.
2. **Naming** — a comment says what code does; a function name *says it every time it's used*: `printReceipt(cart)` reads like prose.
3. **Testing** — you cannot test "the middle of main". You can test `computeTax(1000)` in isolation, with a table of expected outputs.

A function is a **named machine**: values go in, a value (or an effect) comes out. You've used machines all along — `std::sqrt(x)` takes a double and yields its root; `main` itself is a function (the machine the operating system calls). Now you build your own.

<a name="2-declaration-definition-call"></a>
## 2. Declaration, definition, call

```cpp
// The DEFINITION — the machine's actual recipe
double circleArea(double radius) {
    return 3.14159265358979 * radius * radius;
}

// The CALL — using the machine
double a = circleArea(2.5);
```

The **definition** has three parts: a *return type* (what comes out), a *name*, and a *parameter list* (the input slots). The **call** is an expression — it produces a value you can store, print, or nest in bigger expressions:

```cpp
std::cout << circleArea(1) + circleArea(2) << '\n';   // calls compose
```

C++ reads top to bottom. If the compiler meets a call before it has seen the definition, it doesn't know the machine exists:

```cpp
int main() {
    std::cout << circleArea(2.0) << '\n';   // ERROR: who is circleArea?
}

double circleArea(double radius) { ... }    // defined too late
```

Two fixes: define functions *above* their callers (fine for small programs), or give the compiler a **prototype** — a declaration:

```cpp
double circleArea(double radius);   // prototype: name + slots, no body
```

Prototypes get their own section in [Lesson 2 §4](lesson-2-scope.md#4-prototypes--telling-the-compiler-early) — for this lesson, define above the call.

## 3. Parameters vs arguments

The most-confused pair in the unit. Keep the two words for the two sides of the machine wall:

- **Parameters** are the *slots* in the definition — the function's local names for its inputs: `double radius`.
- **Arguments** are the *actual values* at the call site: `2.5`, or a variable, or any expression.

```cpp
double circleArea(double radius);      // radius = parameter (slot)

double r = 10;
double a = circleArea(r);              // r = argument (value 10 copied in)
double b = circleArea(r / 2);          // an expression is fine: 5.0 copied in
```

**Pseudocode** (course house style):

```text
FUNCTION circleArea(radius)
    RETURN 3.14159 * radius * radius
ENDFUNCTION
```

Trace table for `circleArea(2.5)`:

| step | where | radius | computes | yields |
| ---- | ----- | ------ | -------- | ------ |
| 1 | call from main | — | copy 2.5 into radius | enter body |
| 2 | body | 2.5 | π × 2.5 × 2.5 | 19.635 |
| 3 | return | — | hand back 19.635 | back in main |

<a name="4-the-visual-model--the-call-stack"></a>
## 4. The visual model — the call stack

Every call is a trip. The program remembers where it was, runs the machine, and comes back with the answer. Drawn for `main` calling `circleArea(2.5)`:

```text
main                        circleArea
────                        ──────────
a = circleArea(2.5);  ──┐
                        ▼   radius = 2.5 (a COPY lives in the function)
                        │   compute 19.635
a = 19.635;  ◄──────────┘   return 19.635
(next statement)
```

Two calls in a row stack up and unwind:

```text
      call f(3)          call g(4)
main ────┬────────────────┬──────────────►
         ▼                ▼
      f runs            g runs
         │ return        │ return
main ◄───┴────────────────┴──────────────►
```

And functions call functions — the stack grows *down* and returns back up:

```text
main → printInvoice() → computeTax() → roundTo2()
                              ◄────────┘
                     ◄────────┘
            ◄────────┘
```

Each machine gets its **own** parameters and locals — `radius` inside `circleArea` is a different box from any `r` in `main`. That fact is pass-by-value, and it's the whole of [Lesson 2 §1](lesson-2-scope.md#1-pass-by-value--the-copy-rule).

## 5. Return values

`return` does two jobs at once: **hands the value back** and **ends the function now**. Anything after a taken `return` never runs.

```cpp
int max2(int a, int b) {
    if (a > b) {
        return a;          // exits here if a wins
    }
    return b;              // exits here otherwise
}
```

The returned value's type must match the promised return type (or convert to it):

```cpp
double average(int total, int count) {
    return static_cast<double>(total) / count;   // int math, double answer
}
```

**The champion idiom as a function** — your [Iteration Lesson 2](../repetition/lesson-2-for.md#2-the-classic-idioms--learn-once-reuse-forever) idioms become reusable machines:

```cpp
int maxOf5(int m1, int m2, int m3, int m4, int m5) {
    int best = m1;                     // first value seeds the champion
    if (m2 > best) best = m2;
    if (m3 > best) best = m3;
    if (m4 > best) best = m4;
    if (m5 > best) best = m5;
    return best;
}
```

Write it once, call it in every program from now on.

<a name="6-void-functions--machines-that-only-act"></a>
## 6. `void` functions — machines that only act

Some machines answer questions; others *do things* — print a menu, print a receipt. A function that returns nothing is declared `void`:

```cpp
void printDivider(int width) {
    for (int i = 1; i <= width; i = i + 1) {
        std::cout << '-';
    }
    std::cout << '\n';
}
```

Call it as a *statement* — it produces no value to store:

```cpp
printDivider(30);
```

A `void` function can still use bare `return;` to leave early:

```cpp
void printIfPositive(int x) {
    if (x <= 0) {
        return;                    // early exit, no value
    }
    std::cout << x << '\n';
}
```

**The compute/print split** — the most valuable habit in this lesson. Keep machines that *compute* separate from machines that *print*:

```cpp
double gradePoint(int marks) { ... }              // computes: testable
void printGradeReport(int marks) {                // prints: uses the computer
    std::cout << "Grade point: " << gradePoint(marks) << '\n';
}
```

Why split? `gradePoint` can be tested in a table with 20 rows and no console noise. `printGradeReport` needs eyes, not assertions. Mixing computation into a printer makes both harder. (The labs enforce this split.)

## 7. A complete worked program

```cpp
// invoice.cpp — functions composing a small receipt
#include <iostream>
#include <iomanip>

double lineCost(double unitPrice, int qty) {
    return unitPrice * qty;
}

double applyDiscount(double amount) {
    if (amount >= 1000) {
        return amount * 0.90;      // 10% off big orders
    }
    return amount;
}

void printInvoice(double unitPrice, int qty) {
    double sub = lineCost(unitPrice, qty);
    double net = applyDiscount(sub);
    std::cout << std::fixed << std::setprecision(2)
              << qty << " x " << unitPrice
              << " = " << sub << "\nAfter discount: " << net << '\n';
}

int main() {
    printInvoice(120.0, 10);       // sub 1200 → net 1080
    printInvoice(120.0, 5);        // sub 600  → no discount
    return 0;
}
```

Call-flow diagram for the first call:

```text
main → printInvoice(120, 10)
          ├─→ lineCost(120, 10)      returns 1200
          ├─→ applyDiscount(1200)    returns 1080
          └─ prints both lines
◄────── back in main
```

**Trace table** (both calls, one row per machine finish):

| call | unitPrice | qty | lineCost yields | applyDiscount yields | printed net |
| ---- | --------- | --- | --------------- | -------------------- | ----------- |
| 1 | 120.0 | 10 | 1200 | 1080 | 1080.00 |
| 2 | 120.0 | 5 | 600 | 600 | 600.00 |

Note `applyDiscount`'s boundary: 1000 exactly gets the discount (`>=`) — the [boundary-ownership](../decisions/lesson-2-conditions.md) discipline now lives inside a function, testable with a two-row table.

## Practice

- [Exercises 1–7](exercises.md) — first machines, traces, void vs value
- [Debugging 1–2](debugging.md)
- [Lab 1](labs.md#lab-1--the-conversion-desk) after Lesson 2

## Key takeaways

- A function = return type + name + parameter list + body; the call copies arguments into parameters.
- `return` hands the answer back *and* ends the function; `void` functions act instead of answering and may `return;` early.
- The call stack: each call is a trip — own parameters, own locals, back to the exact spot after the call.
- Split computation from printing: computers are testable, printers are for people.

→ Next: [Lesson 2 — Copies, scope, and prototypes](lesson-2-scope.md)
