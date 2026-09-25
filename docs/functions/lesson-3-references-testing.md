---
title: "Lesson 3 — References and Testing"
description: "Reference parameters that write back, const references, per-function test tables and mini-drivers, and building a personal library of reusable functions."
---

# Lesson 3 — References and Testing

> [← Module home](index.md) · [← Lesson 2 — Scope](lesson-2-scope.md) · [Lesson 4 — Overloading →](lesson-4-overloading-refactoring.md)

## In this lesson you will learn

- **reference parameters** — the sanctioned way to let a function write results back
- the two-names-one-box mental model, and when to reach for it
- `const&` — efficient read-only parameters (a preview you can use today)
- **testing functions**: mini-drivers and per-function test tables — the practice the whole unit exists to enable
- your **reusable library**: the functions worth carrying forward forever

---

## 1. The problem references solve

`swap` is the classic demonstration. With copies, it's a no-op:

```cpp
void swapByValue(int a, int b) {       // copies of x and y
    int t = a; a = b; b = t;           // swaps the copies, then destroys them
}

int x = 1, y = 2;
swapByValue(x, y);                     // x and y unchanged
```

The function swapped its own boxes and threw them away. To let a function genuinely change caller variables, C++ offers the **reference parameter** — declare the parameter with `&`:

```cpp
void swap(int& a, int& b) {
    int t = a; a = b; b = t;
}

int x = 1, y = 2;
swap(x, y);                            // x is 2, y is 1 — really changed
```

<a name="2-reference-parameters--the-write-back-wire"></a>
## 2. Reference parameters — the write-back wire

A reference parameter is **not a new box**. It is a **new name for the caller's existing box**:

```text
pass-by-value:   caller's n ──► [ 5 ]        callee's x ──► [ 5 ]   (two boxes)
pass-by-ref:     caller's n ──► [ 5 ] ◄── "x"                       (one box, two names)
```

Whatever the function does to `x`, it does to `n` — same storage. Trace of `swap(x, y)`:

| step | caller's x | caller's y | a refers to | b refers to |
| ---- | ---------- | ---------- | ----------- | ----------- |
| call | 1 | 2 | caller's x | caller's y |
| t = a | 1 | 2 | (t = 1) | |
| a = b | 2 | 2 | | |
| b = t | 2 | 1 | | |
| return | 2 | 1 | (wires die, changes persist) | |

**Pseudocode convention**: mark write-backs explicitly —

```text
FUNCTION swap(REF a, REF b)
```

### When to use which

| You want | Tool |
| --- | --- |
| Function uses a value | value parameter (default) |
| Function produces **one** answer | `return` it |
| Function must change the caller's variable | reference parameter |
| Function produces *two or more* answers | references (or reconsider the design) |
| Function reads a big value unchanged | `const&` (§4) |

The discipline that keeps references safe: **the call site must show the danger**. `swap(x, y)` looks identical to a value call — the `&`s live only in the prototype. Professionals mitigate with names that promise change (`applyDiscount(amount)`) and by reserving references for genuine output (not "input, probably"). In this course: references are for **outputs**, never for inputs you merely read.

### Multiple answers, done right

Compute statistics and hand back the two champions without globals, without a struct (structs are later units):

```cpp
void minMax(int a, int b, int c, int d, int& lo, int& hi) {
    lo = a; hi = a;
    if (b < lo) lo = b;   if (b > hi) hi = b;
    if (c < lo) lo = c;   if (c > hi) hi = c;
    if (d < lo) lo = d;   if (d > hi) hi = d;
}

int low, high;
minMax(8, 3, 9, 1, low, high);     // low 1, high 9
```

The call reads left-to-right: *inputs, then outputs* — a house convention worth keeping.

<a name="3-reference-gotchas"></a>
## 3. Reference gotchas

Three honest warnings:

1. **A reference must be attached at birth.** References bind to a variable when created and can't be re-attached — that's why parameters work (bound at the call) but standalone reference variables are rare.
2. **Arguments must be variables, not values.** `swap(1, 2)` is a compile error — there's no box for the wire to attach to. Likewise `swap(x + 1, y)`. Only nameable variables can be written back to.
3. **The reader can't see the `&` at the call.** The danger is invisible in `main` — mitigations: naming, comments, and the course's inputs-left/outputs-right convention.

## 4. `const&` — the efficient read

Copying is free for `int`s and cheap for `double`s — but imagine a long text: every *read-only* use would copy the whole thing. The fix is a reference that *promises not to write*:

```cpp
void printBanner(const std::string& text) {   // reads text; copies nothing
    std::cout << "=== " << text << " ===\n";
}
```

`const&` gives reference efficiency with value-parameter safety: the compiler *forbids* modification, so nothing can be corrupted. (The labs' `std::string` functions use `const&`; your `int`/`double` functions stay pass-by-value.) Full story in the [Strings module](../strings/index.md) — for now, the pattern is yours.

<a name="5-testing-functions--the-payoff-of-small-machines"></a>
## 5. Testing functions — the payoff of small machines

[Lesson 1 §6](lesson-1-machine.md#6-void-functions--machines-that-only-act) split compute from print so computation could be tested. Here's what that testing *looks like*.

### The mini-driver

A tiny `main` whose whole job is exercising one function:

```cpp
// driver for computeBill — replaced by real main later
#include <iostream>

double computeBill(int units);          // prototype under test

int main() {
    std::cout << computeBill(50)  << '\n';   // expect 300
    std::cout << computeBill(100) << '\n';   // expect 600
    std::cout << computeBill(101) << '\n';   // expect 610
    std::cout << computeBill(0)   << '\n';   // expect 0 (edge)
    return 0;
}
```

Run it; compare the four numbers with the expectations. Even better — *make the driver judge*:

```cpp
void check(double got, double want, const char* label) {
    if (got == want) { std::cout << "PASS " << label << '\n'; }
    else             { std::cout << "FAIL " << label
                                  << " got " << got << " want " << want << '\n'; }
}

int main() {
    check(computeBill(50),  300, "slab1");
    check(computeBill(101), 610, "boundary 100/101");
    return 0;
}
```

`check` itself is a function — a two-parameter machine — and this exact pattern scales up to professional test frameworks.

### The per-function test table

Every pure function deserves a table *before* the code, from its requirements:

**computeBill (slabs: first 100 @6.00, then @7.00)**

| units | expected bill | why |
| --- | --- | --- |
| 50 | 300.00 | inside slab 1 |
| 100 | 600.00 | boundary — slab 1 owns exactly-100 |
| 101 | 610.00 | first unit of slab 2 |
| 200 | 1300.00 | mid slab 2 |
| 0 | 0.00 | edge (caller rejects, function tolerates) |
| -5 | 0.00 | garbage tolerance documented |

Boundary ownership, [garbage tolerance](../problem-solving/lesson.md#47-inputs-processing-outputs-requirements-assumptions-constraints), edges — the test table is where all the course's habits meet. **Write the table first, and it becomes the spec you code against.**

### What to do with a failing row

A `FAIL` row is a gift. The sequence: reproduce → trace the function by hand with that input ([trace table](../repetition/lesson-1-while.md#2-the-while-loop--anatomy)) → fix → *rerun the whole table* (fixes often break the neighbours). Debugging D6–D10 rehearse exactly this loop.

<a name="6-reusable-code--your-personal-library"></a>
## 6. Reusable code — your personal library

Every machine you write well becomes a permanent asset. Keep a `toolbox.cpp` of course-tested functions; from now on, **write it once**:

| Function | Signature | From |
| --- | --- | --- |
| `max2`, `max3` | `int max2(int a, int b)` | Lesson 1 §5 |
| `swap` | `void swap(int& a, int& b)` | Lesson 3 §2 |
| `minMax` | `void minMax(int,int,int,int, int&, int&)` | Lesson 3 §2 |
| `toCelsius` / `toFahrenheit` | `double toCelsius(double f)` | [Lab 1](labs.md#lab-1--the-conversion-desk) |
| `computeBill` (slab family) | `double computeBill(int units)` | Lesson 3 §5 |
| `readInRange`-shaped readers | `int readInt(...)` patterns | [Lab 5](labs.md#lab-5--the-validation-suite) |
| digit machines | `int digitSum(long long n)`, `int digitCount(long long n)`, `long long reverseDigits(long long n)` | [Iteration S25/S26](../repetition/exercises.md#s25--digit-stats) |
| prime test | `bool isPrime(long long n)` | [Iteration S28](../repetition/exercises.md#s28--primes-2-to-50) |
| `check` | `void check(double got, double want, const char* label)` | Lesson 3 §5 |

Two rules for library entries:

1. **Single job, honest name** — the alone-testable test of [Lesson 2 §5](lesson-2-scope.md#5-decomposition--designing-with-functions).
2. **Carry its test table with it** — a function without its table can't be safely reused after edits.

## Practice

- [Exercises 14–19](exercises.md) — reference traces, minMax, drivers
- [Debugging 6–8](debugging.md)
- [Refactoring R2–R4](refactoring.md)
- [Lab 2](labs.md#lab-2--the-statistics-team) — the statistics team · [Lab 3](labs.md#lab-3--the-wire-tracing-desk) — reference wiring

## Key takeaways

- `T&` binds a parameter to the caller's box: write-back with no return. Reserve it for outputs; arguments must be variables.
- Inputs left, outputs right at the call site; `const&` for big read-only parameters.
- Test with mini-drivers and self-judging `check` calls against a table written *first*.
- Curate a library: single-job functions that travel with their test tables.

→ Next: [Lesson 4 — Overloading, defaults, refactoring](lesson-4-overloading-refactoring.md)
