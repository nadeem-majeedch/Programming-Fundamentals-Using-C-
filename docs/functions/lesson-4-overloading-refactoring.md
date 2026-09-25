---
title: "Lesson 4 — Overloading, Defaults, and Refactoring"
description: "Function overloading, default arguments, a full giant-main refactor walkthrough, and the common function errors gallery."
---

# Lesson 4 — Overloading, Defaults, and Refactoring

> [← Module home](index.md) · [← Lesson 3 — References](lesson-3-references-testing.md) · [Exercises →](exercises.md)

## In this lesson you will learn

- **function overloading** — same name, different parameter lists, and how the compiler chooses
- **default arguments** — parameters the caller may omit
- how the two interact (and their one genuine trap)
- a complete **refactor walkthrough**: giant `main()` → function team, safely
- the common function errors gallery

---

<a name="1-function-overloading--one-name-several-machines"></a>
## 1. Function overloading — one name, several machines

Real-world verbs are flexible: *print* a number, *print* a receipt, *print* a banner. C++ lets one name own several machines, distinguished by their **parameter lists** (the *signature*):

```cpp
void printValue(int x)        { std::cout << "int: "    << x << '\n'; }
void printValue(double x)     { std::cout << "double: " << x << '\n'; }
void printValue(char x)       { std::cout << "char: "   << x << '\n'; }

printValue(42);        // int version
printValue(3.5);       // double version
printValue('A');       // char version
```

The compiler picks by matching the **argument types** at each call — **overload resolution**:

| Call | Chosen | Why |
| --- | --- | --- |
| `printValue(42)` | `int` | exact match |
| `printValue(3.5)` | `double` | exact match |
| `printValue('A')` | `char` | exact match |
| `printValue(42.0f)` | `double` | `float` promotes to `double` (exact-ish beats conversion) |
| `printValue(true)` | `char` (!) | `bool` converts to `char` more readily than to `int` — the famous surprise |

**Pseudocode**: same name listed once per signature.

**What counts as different**: number of parameters, or their types. **What doesn't**: return type alone — `int f(int)` and `double f(int)` cannot coexist (the compiler couldn't know which you meant from `f(3)` alone).

### Why overload instead of naming differently?

Because the *concept* is one thing — printing a value — and the caller shouldn't memorise `printInt`, `printDouble`, `printChar`. The name carries meaning; the types carry routing. Use it when the behaviour is genuinely the same job; when the jobs differ, use different names. **Overload by meaning, not by convenience.**

### The ambiguity trap

```cpp
void f(int a, double b);
void f(double a, int b);

f(3, 4);      // ERROR: ambiguous — 4 fits double, 3 fits... both lists are one conversion away
```

Two signatures that both need exactly one conversion → the compiler refuses to choose. If callers must write casts to use your function, the overload set is badly designed.

<a name="2-default-arguments"></a>
## 2. Default arguments

A parameter may carry a default the caller may omit:

```cpp
double applyTax(double amount, double rate = 0.15) {
    return amount * (1 + rate);
}

applyTax(1000);          // uses 0.15  → 1150
applyTax(1000, 0.05);    // explicit   → 1050
```

Rules with teeth:

1. **Defaults trail**: once a parameter has a default, every parameter to its *right* needs one. `void f(int a, int b = 2, int c)` is illegal.
2. **Declare once**: the default appears in the *prototype* (or the definition if there's no prototype) — **never both** (redefinition error).
3. **Defaults are baked at compile time of the caller** — changing a default means recompiling callers; defaults are constants, not configuration.

Defaults shine for optional behaviour flags and standard rates — *precisely* the cases where "almost always the same, occasionally different" is true. When callers pass different values half the time, drop the default and require the argument.

### The interaction trap — defaults + overloads

```cpp
void greet(std::string name);                        // (1)
void greet(std::string name, std::string greeting = "Hello");

greet("Ayesha");        // ERROR: (1) matches — but so does (2) with the default!
```

Both signatures can serve one argument — ambiguous. **Rule of thumb: grow an existing function with a default argument, not with an overload.** They compete for the same "optional parameter" niche; pick one mechanism per optional.

<a name="3-refactoring--the-walkthrough"></a>
## 3. Refactoring — the walkthrough

**Refactoring** is changing code's *structure* without changing its *behaviour*. The toolkit is now complete enough to do it professionally, so here is the full method on a realistic specimen. (The [refactoring exercises](refactoring.md) give ten more.)

### The patient

```cpp
// before.cpp — one giant main (Units 1-6 style)
#include <iostream>
#include <iomanip>

int main() {
    int units;
    std::cout << "Units: ";
    std::cin >> units;
    while (units < 0) {
        std::cout << "Units can't be negative — again: ";
        std::cin >> units;
    }

    double bill;
    if (units <= 100) {
        bill = units * 6.0;
    } else if (units <= 200) {
        bill = 100 * 6.0 + (units - 100) * 7.0;
    } else {
        bill = 100 * 6.0 + 100 * 7.0 + (units - 200) * 8.0;
    }

    double surcharge = 0;
    if (bill > 1500) surcharge = bill * 0.05;

    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Units: " << units << '\n';
    std::cout << "Energy cost: " << bill << '\n';
    if (surcharge > 0) std::cout << "Surcharge: " << surcharge << '\n';
    std::cout << "TOTAL: " << bill + surcharge << '\n';
    return 0;
}
```

### Step 0 — Baseline first

Run it on a fixed input set and **write the outputs down**. Refactoring guarantees *identical* behaviour; without a baseline you can't prove you kept it. Choose inputs that hit every branch: `50`, `100`, `150`, `200`, `201`, `400`.

| units | energy | surcharge | total |
| --- | --- | --- | --- |
| 50 | 300.00 | 0 | 300.00 |
| 100 | 600.00 | 0 | 600.00 |
| 150 | 950.00 | 0 | 950.00 |
| 200 | 1300.00 | 0 | 1300.00 |
| 201 | 1308.00 | 65.40 | 1373.40 |
| 400 | 2600.00 | 130.00 | 2730.00 |

### Step 1 — One extraction at a time

Extract the smallest, most independent piece first — the slab ladder. *Cut the lines, paste into a function, call the function*:

```cpp
double computeEnergyCost(int units) {
    if (units <= 100) {
        return units * 6.0;
    } else if (units <= 200) {
        return 100 * 6.0 + (units - 100) * 7.0;
    }
    return 100 * 6.0 + 100 * 7.0 + (units - 200) * 8.0;
}
```

**Compile. Re-run the baseline. All six rows identical? Next step. Not identical? Undo — the step was too big.**

### Step 2 — The next independent piece

The surcharge decision:

```cpp
double applySurcharge(double bill) {          // returns the surcharge amount
    if (bill > 1500) return bill * 0.05;
    return 0;
}
```

Note the design decision: return the surcharge *amount*, not a bool — the caller needs the money, and a bool would force the caller to recompute it. Compile, re-run, compare.

### Step 3 — Output block

```cpp
void printReceipt(int units, double bill, double surcharge) {
    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Units: " << units << '\n';
    std::cout << "Energy cost: " << bill << '\n';
    if (surcharge > 0) std::cout << "Surcharge: " << surcharge << '\n';
    std::cout << "TOTAL: " << bill + surcharge << '\n';
}
```

Compile, re-run, compare — byte-identical output or the step was wrong.

### Step 4 — Input block (the validation loop becomes a machine)

```cpp
int readUnits() {
    int units;
    std::cout << "Units: ";
    std::cin >> units;
    while (units < 0) {
        std::cout << "Units can't be negative — again: ";
        std::cin >> units;
    }
    return units;
}
```

### Step 5 — main becomes the narrator

```cpp
int main() {
    int units = readUnits();
    double bill = computeEnergyCost(units);
    double surcharge = applySurcharge(bill);
    printReceipt(units, bill, surcharge);
    return 0;
}
```

Read `main` aloud — it's the problem statement. Final layout per house style: prototypes → `main` → definitions. Total behaviour change: **zero**. Total lines: about the same. What changed is *testability*: `computeEnergyCost` now has its own test table ([computeBill's](lesson-3-references-testing.md#5-testing-functions--the-payoff-of-small-machines) six rows are exactly this function's), and the next program needing a slab ladder steals it in one copy.

### The refactoring checklist (memorise this)

1. **Baseline outputs first** — fixed inputs, written-down results.
2. **One extraction per step** — compile, run, compare, then next.
3. **Pure computation first** — they're the easiest to name and the most valuable to test.
4. **Printers after computers** — extract output blocks once the values they print are stable.
5. **Readers last** — validation loops become machines once the rest is stable.
6. **Never refactor and add features in the same pass** — one intent per editing session.

The [refactoring exercises](refactoring.md) are ten reps of this checklist; [Lab 6](labs.md#lab-6--the-refactor-rescue) is a full rescue.

<a name="4-the-common-function-errors-gallery"></a>
## 4. The common function errors gallery

| # | Bug | Signature symptom |
| --- | --- | --- |
| F1 | Declared, never defined (or name mismatch) | *undefined reference* at link time |
| F2 | Call before any prototype/definition | *was not declared in this scope* |
| F3 | Missing `()` on a call — `printBanner;` | compiles(!), does nothing useful |
| F4 | Ignoring the return value — `max2(a,b);` | computed, discarded |
| F5 | Trying to change a value parameter and reading it after | caller's variable unchanged (pass-by-value) |
| F6 | Parameter/argument count or type mismatch | compile error — or silently converts (`f(3.7)` into `int` param truncates) |
| F7 | Return path missing on some branch | *control reaches end of non-void function* — or garbage on that branch |
| F8 | Function does compute **and** print | untestable; the compute/print split violated |
| F9 | Mutable global smuggled in | works alone, breaks in combination — see [Lesson 2 §3](lesson-2-scope.md#3-global-variables--why-this-course-bans-them) |
| F10 | Overload/defaults ambiguity | *call of overloaded f is ambiguous* |

F7 deserves a glance — the compiler usually warns, and the bug is a ladder missing its final `else`/`return`:

```cpp
int sign(int x) {
    if (x > 0) return 1;
    if (x < 0) return -1;
    // x == 0: no return at all — garbage
}
```

And F3 is the strangest to meet: a function name *without* parentheses is an expression (a function pointer, really — [Unit 13](../syllabus.md#stage-e-memory-and-objects-units-13-15) material) that converts to `bool` — so `if (printBanner)` compiles and is always true. Symptom: "my function never runs but my code compiles."

## Practice

- [Exercises 20–26](exercises.md) — overloads, defaults, and the refactor-plan exercise
- [Debugging 9–10](debugging.md)
- [Refactoring R5–R10](refactoring.md)
- [Lab 6](labs.md#lab-6--the-refactor-rescue) — the refactor rescue

## Key takeaways

- Overloads share a name across different parameter lists; the compiler routes by argument types; return type alone can't distinguish.
- Defaults trail, are declared once, and suit "almost always the same" parameters; grow functions with defaults rather than competing overloads.
- Refactor = baseline, one extraction per step, compare, repeat — computers first, printers second, readers last, main as narrator.
- Ten named errors with symptoms; F7 (missing return path) and F3 (call without parentheses) are the sneaky ones.

→ Next: [Exercises](exercises.md) — then the [mini-project](miniproject.md).
