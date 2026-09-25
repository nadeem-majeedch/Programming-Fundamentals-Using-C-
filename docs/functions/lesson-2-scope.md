---
title: "Lesson 2 — Copies, Scope, and Prototypes"
description: "Pass-by-value, local and global variables, function prototypes, and decomposition as a design method."
---

# Lesson 2 — Copies, Scope, and Prototypes

> [← Module home](index.md) · [← Lesson 1 — The machine](lesson-1-machine.md) · [Lesson 3 — References →](lesson-3-references-testing.md)

## In this lesson you will learn

- **pass-by-value** — the copy rule, its costs, and the protection it buys
- **scope** — where a variable exists and who may touch it
- local variables vs global variables — and the course's global ban
- **prototypes** — declaring machines before defining them, and why real programs do
- **decomposition** — turning a problem statement into a function list, the design skill of the unit

---

<a name="1-pass-by-value--the-copy-rule"></a>
## 1. Pass-by-value — the copy rule

When you call a function, each argument is **copied** into its parameter. The function works on the copies:

```cpp
void tryToChange(int x) {
    x = 999;                        // changes the COPY
    std::cout << "inside: " << x << '\n';
}

int main() {
    int n = 5;
    tryToChange(n);
    std::cout << "after:  " << n << '\n';   // still 5!
    return 0;
}
```

```text
before call:      main's n ──► [ 5 ]
during call:      main's n ──► [ 5 ]     tryToChange's x ──► [ 999 ]  (separate box)
after return:     main's n ──► [ 5 ]     (x's box destroyed)
```

Output: `inside: 999` then `after: 5`. The function *cannot* reach back into main's box — the parameter is a new box that received a copy. Dry run:

| step | n (main) | x (copy) | effect |
| ---- | -------- | -------- | ------ |
| call | 5 | 5 | copy made |
| body | 5 | 999 | x reassigned |
| return | 5 | destroyed | main unaffected |

**Why this is a feature, not a limitation.** A caller can hand over a variable and *trust it won't be touched*: `printInvoice(total)` can never corrupt your `total`. Big libraries are built on this guarantee. When a function genuinely must *hand back* more than one answer, C++ has a second tool — **references** — and it gets its own lesson ([Lesson 3](lesson-3-references-testing.md#2-reference-parameters--the-write-back-wire)). Until then, one function = one answer via `return`.

<a name="2-scope--where-variables-live"></a>
## 2. Scope — where variables live

A variable's **scope** is the region of code where its name is usable:

```cpp
int globalCount = 0;              // global scope: the whole file

void tick() {
    int localTotal = 0;           // local: born each call, dies at return
    localTotal += 1;
    globalCount += 1;             // legal — and the beginning of trouble
}

int main() {
    tick();
    // std::cout << localTotal;   // ERROR: localTotal doesn't exist here
    return 0;
}
```

The rules:

| Variable | Born | Dies | Visible to |
| --- | --- | --- | --- |
| Local (in a function) | at its declaration, each call | at function return | only that function |
| Local (in a loop body) | each pass | end of pass | only inside the block |
| Parameter | at the call | at return | only that function |
| Global | at program start | at program end | every function below it |

Shadowing (met in [Iteration D6](../repetition/debugging.md#d6--the-vanishing-total)) applies inside functions too: a local named `total` hides a global `total` for the whole function — a bug factory. Two variables with the same name in one program is a design smell unless one deliberately shadows a *parameter* for a good reason (rare).

<a name="3-global-variables--why-this-course-bans-them"></a>
## 3. Global variables — why this course bans them

A global is readable *and writable* by every function in the file. That sounds convenient and is precisely the problem:

```cpp
// WHY NOT — the tangle
int balance = 1000;

void withdraw(int amount) { balance -= amount; }
void audit() { std::cout << balance << '\n'; }
void resetDay() { balance = 0; }             // surprise!
```

After twenty calls, *which* function moved the balance? The answer requires reading every function. Globals:

- make any function's behaviour depend on hidden state — you can't understand a function by reading it alone;
- make testing impossible — a test of `withdraw` must first arrange the global *just so*, and the next test inherits the leftovers;
- create action-at-a-distance bugs: `resetDay` changing `balance` breaks `audit` even though they never call each other.

**The two honest alternatives** cover every case:

1. **Data a function needs → pass it in** (a parameter).
2. **Data a function produces → hand it back** (a `return`, or a reference in [Lesson 3](lesson-3-references-testing.md)).

```cpp
// the same program, no globals
int withdraw(int balance, int amount) { return balance - amount; }
```

Every program in this course passes its own tests because every function declares its inputs and outputs openly. (One nuance for honesty: `constexpr` constants like `constexpr double TAX_RATE = 0.15;` at file scope are fine and encouraged — they're fixed *values*, not changing *state*. The ban is on mutable globals.)

<a name="4-prototypes--telling-the-compiler-early"></a>
## 4. Prototypes — telling the compiler early

[Lesson 1 §2](lesson-1-machine.md#2-declaration-definition-call) showed the order problem: calls must come after the compiler knows the machine. Real programs solve it with **prototypes** — the function's signature without a body — collected above `main`:

```cpp
#include <iostream>

// --- prototypes: the program's table of contents ---
double lineCost(double unitPrice, int qty);
double applyDiscount(double amount);
void   printInvoice(double unitPrice, int qty);

int main() {
    printInvoice(120.0, 10);        // compiler already knows all three
    return 0;
}

// --- definitions: the actual recipes, in any order ---
double lineCost(double unitPrice, int qty) {
    return unitPrice * qty;
}

double applyDiscount(double amount) {
    return (amount >= 1000) ? amount * 0.90 : amount;
}

void printInvoice(double unitPrice, int qty) {
    double sub = lineCost(unitPrice, qty);
    std::cout << "Net: " << applyDiscount(sub) << '\n';
}
```

Why professionals prefer this layout:

- `main` reads first — the program's story is up top;
- definitions can sit in **any order** — no more "define above your caller" gymnastics;
- mutual callers (A calls B, B calls A) become possible at all;
- a mismatch between prototype and definition is a *compile error* — the compiler catches lying documentation.

House style from here on: **prototypes block → `main` → definitions**, with one comment line per function.

One rule with teeth: the compiler accepts a prototype whose parameter names differ from the definition's (`void f(int a);` defined as `void f(int b)`) — parameters' names are ignored in signatures. But *you* shouldn't: keep prototype and definition names identical; the names are your only documentation at the call site.

<a name="5-decomposition--designing-with-functions"></a>
## 5. Decomposition — designing with functions

Decomposition is the unit's central skill: given a problem, **list the functions before writing any code**. The method:

**Step 1 — Underline the verbs and nouns.** The problem statement's verbs are functions; the nouns are parameters and returns.

> *"The program reads a customer's units consumed, computes the bill from slab rates, prints an itemised receipt, and repeats until the clerk enters 0."*

Verbs: read, compute, print, repeat. Nouns: units, bill, receipt.

**Step 2 — Draft the function list** (name, parameters, return):

| Function | Takes | Returns | Job |
| --- | --- | --- | --- |
| `readUnits` | — | `int` | validated input (0 = quit signal handled by caller) |
| `computeBill` | `int units` | `double` | the slab ladder — pure computation |
| `printReceipt` | `int units, double bill` | `void` | itemised output |

**Step 3 — Check each function against the two tests:**

- *Single job*: can you state what it does in one sentence without "and then"? `computeBill` passes; "computeAndPrintBill" fails.
- *Alone-testable*: could you write a five-row test table for it right now? `computeBill(units)` — yes, pure. `readUnits` — needs a console, so its logic core should be minimal (validation loop) and everything else lives in pure functions.

**Step 4 — Wire main as the conductor:**

```cpp
int main() {
    int units = readUnits();
    while (units != 0) {
        printReceipt(units, computeBill(units));
        units = readUnits();
    }
    std::cout << "Day closed.\n";
    return 0;
}
```

Read `main` aloud: it *is* the problem statement. That is the goal of decomposition — `main` narrates; functions act.

**The grain of the decomposition is a judgement call**, and two heuristics keep it sane: a function longer than about a screen is usually two functions; a function called once *and* trivial (`double double_it(double x) { return 2*x; }`) is usually noise. Between those poles, name-by-responsibility.

## Practice

- [Exercises 8–13](exercises.md) — copy-rule traces, scope reading, prototypes, a decomposition plan
- [Debugging 3–5](debugging.md)
- [Refactoring R1](refactoring.md) — your first before/after
- [Lab 1](labs.md#lab-1--the-conversion-desk) — the conversion desk

## Key takeaways

- Arguments are copied into parameters; the function can never change the caller's variable — protection by default.
- Scope: locals live and die with their function; globals are banned because hidden state kills comprehension and testing.
- Prototypes are the program's table of contents: prototypes → `main` → definitions.
- Decompose by verbs-and-nouns: function list first, main-as-narrator last, single-job and alone-testable as the quality bar.

→ Next: [Lesson 3 — References and testing](lesson-3-references-testing.md)
