---
title: "Functions Debugging Exercises"
description: "10 seeded function bugs — signature mismatches, copy-rule misunderstandings, scope traps, overload ambiguity. Find, fix, reflect."
---

# Functions Debugging Exercises (10)

> [← Module home](index.md) · Find → Fix → Reflect. Trace on paper before compiling — most function bugs are visible without a compiler. Hints are progressive.

---

## D1 — The vanishing definition

```cpp
#include <iostream>

double triple(double x);        // the only mention of triple

int main() {
    std::cout << triple(4) << '\n';
    return 0;
}
```

Compiles cleanly... then the linker refuses. What does it say, and what's missing?

<details markdown="1"><summary>Hints</summary>

1. The compiler believed the prototype. Who checks promises *after* compilation?
2. [Gallery F1](lesson-4-overloading-refactoring.md#4-the-common-function-errors-gallery) — declared, never defined.

</details>

<a name="d1--the-vanishing-definition"></a>
**Fix:** add the definition `double triple(double x) { return 3 * x; }`. **Reflect:** compiler = per-file grammar; linker = promise-keeping across the program.

---

## D2 — The silent non-call

```cpp
void banner() {
    std::cout << "=========================\n";
}
int main() {
    banner;            // "call" the banner
    std::cout << "Program started\n";
    return 0;
}
```

No banner appears, and yet: no error. Why?

<details markdown="1"><summary>Hints</summary>

1. Look at the call very closely — what's missing?
2. A function name *without* parentheses is a thing in C++ (gallery F3).

</details>

<a name="d2--the-silent-non-call"></a>
**Fix:** `banner();` — calls need parentheses. **Reflect:** the bare name is an address expression, not an instruction; C++ happily evaluates and discards it.

---

## D3 — The mutated nothing

```cpp
void zeroOut(int n) { n = 0; }
int main() {
    int errors = 5;
    zeroOut(errors);
    std::cout << errors << '\n';     // programmer expects 0
    return 0;
}
```

Prints 5. The function *ran* — trace exactly where the 0 went.

<details markdown="1"><summary>Hints</summary>

1. Draw the two boxes at the moment of the call.
2. Which of them does `n = 0` write into?
3. [Copy rule](lesson-2-scope.md#1-pass-by-value--the-copy-rule) — gallery F5.

</details>

<a name="d3--the-mutated-nothing"></a>
**Fix:** the intent is write-back → `void zeroOut(int& n)`. (Or better: `int zeroed() { return 0; }` / assign in caller — a function whose only job is "set to 0" barely deserves to exist.) **Reflect:** value parameters are for reading; writing back needs `&` or a return.

---

## D4 — The prototype that lied

```cpp
int areaOf(int side);

int main() {
    std::cout << areaOf(3.7) << '\n';    // prints 9 — where did 3.7 go?
    return 0;
}

int areaOf(int side) { return side * side; }
```

`3.7` became `3` silently. Diagnose and give two fixes with different trade-offs.

<details markdown="1"><summary>Hints</summary>

1. The argument's type vs the parameter's type.
2. Implicit conversion — 3.7 → 3 at the call ([Foundations Lesson 4](../cpp-foundations/lesson-4-conversion.md)).
3. Gallery F6: mismatch by conversion, not by error message.

</details>

<a name="d4--the-prototype-that-lied"></a>
**Fix (a):** `double areaOf(double side)` — honest for real-valued sides. **(b):** keep `int` and make the caller truncate explicitly: `areaOf(static_cast<int>(side))` — loud, reviewable. **Reflect:** silent conversions at call sites are the quiet way arithmetic goes wrong; make truncation a decision, not an accident.

---

## D5 — The global gang

```cpp
int total = 0;                    // "just this once"
void add(int amount)  { total += amount; }
void reset()          { total = 0; }
void report()         { std::cout << total << '\n'; }

int main() {
    add(50); add(30);
    report();       // 80 — fine...
    reset();
    report();       // 0 — but WHY is it 0? who asked?
    return 0;
}
```

The program "works", yet the diagnosis is still: design bug. Explain it in two sentences and de-globalise.

<details markdown="1"><summary>Hints</summary>

1. Who can change `total`? (Everyone.) Who *must* know when it changes? (Everyone.)
2. [Lesson 2 §3](lesson-2-scope.md#3-global-variables--why-this-course-bans-them) — hidden state.

</details>

<a name="d5--the-global-gang"></a>
**Fix:**

```cpp
int add(int total, int amount) { return total + amount; }
// main: total = add(total, 50); total = add(total, 30); ...
```
**Reflect:** the fixed version can be tested in one line (`check(add(0, 50), 50, ...)`) — the global version needs a ritual before every test.

---

## D6 — The half-traced ladder

```cpp
int band(int score) {
    if (score >= 80) return 'A' - '0';   // hmm
    if (score >= 60) return 2;
    // ... more bands ...
}
```

Wait — `return 'A' - '0';`? That's 17. This one's a *reading* exercise: list every problem you can find in this function before compiling anything. (There are at least three.)

<details markdown="1"><summary>Hints</summary>

1. Return type vs what's returned.
2. Missing return paths — which scores reach the end?
3. Would a `char` return type serve better?

</details>

<a name="d6--the-half-traced-ladder"></a>
**Fix:** the honest version is the [S5](exercises.md#s5--gradeof) ladder: `char band(int score)` with a `return` for every path. **Reflect:** three real bugs in eight lines (type mismatch, arithmetic on chars as magic numbers, missing returns) — and none of them is a *syntax* error. Compiling is not reviewing.

---

## D7 — The ambiguous greeter

```cpp
void greet(std::string name);
void greet(std::string name, std::string prefix = "Hello, ");

greet("Ayesha");
```

Compile error: *call of overloaded greet is ambiguous*. Walk the compiler's dilemma out loud, then fix two ways and say which you'd ship.

<details markdown="1"><summary>Hints</summary>

1. Both signatures can serve one argument — how?
2. [Defaults + overloads trap](lesson-4-overloading-refactoring.md#2-default-arguments).

</details>

<a name="d7--the-ambiguous-greeter"></a>
**Fix (a):** delete the one-arg overload (default covers it). **(b):** delete the default, keep both overloads with *distinct* meanings. Ship (a): one mechanism per optional ([Lesson 4 §2](lesson-4-overloading-refactoring.md#2-default-arguments)).

---

## D8 — The reader that ate the menu

```cpp
int readChoice() {
    int c;
    std::cin >> c;
    if (std::cin.fail()) {
        std::cin.clear();
        std::cin.ignore(1000, '\n');
        return readChoice();      // "try again"
    }
    return c;
}
```

Type `abc` twenty times fast, and... the program freezes. (This uses recursion — a function calling itself — which you haven't formally met; treat it as "the function restarts itself.") What's the risk in this pattern, and what loop-shaped fix do you already know?

<details markdown="1"><summary>Hints</summary>

1. Each failed attempt * stacks* another unfinished function call — the stack grows.
2. The [validation gallery](../repetition/lesson-3-break-continue-sentinels.md#6-validation-loop-gallery--patterns-you-will-reuse-forever) solved re-prompting with a *loop*, not restarts.

</details>

<a name="d8--the-reader-that-ate-the-menu"></a>
**Fix:**

```cpp
int readChoice() {
    int c;
    std::cin >> c;
    while (std::cin.fail()) {
        std::cin.clear();
        std::cin.ignore(1000, '\n');
        std::cout << "Numbers only — try again: ";
        std::cin >> c;
    }
    return c;
}
```
**Reflect:** same behaviour, constant memory. Recursion is a real tool ([later units](../syllabus.md#stage-d-algorithms-and-data-units-10-12)) — but "repeat" usually means loop, and inside a *reader* function, stack-per-keystroke is a freeze waiting for a bad day.

---

## D9 — The function that prints its answer

```cpp
double applyDiscount(double amount) {
    if (amount >= 1000) {
        std::cout << "Discount applied!\n";
        return amount * 0.90;
    }
    return amount;
}
```

Tests of `applyDiscount` print surprise lines, and the ⭐⭐ extension in the labs wants the discount *without* the message. Diagnose; refactor into the testable shape.

<details markdown="1"><summary>Hints</summary>

1. [Gallery F8](lesson-4-overloading-refactoring.md#4-the-common-function-errors-gallery) — compute and print in one machine.
2. Who should own the message — and when?

</details>

<a name="d9--the-function-that-prints-its-answer"></a>
**Fix:**

```cpp
double applyDiscount(double amount) {           // pure, silent, testable
    return (amount >= 1000) ? amount * 0.90 : amount;
}
// caller:
if (amount >= 1000) std::cout << "Discount applied!\n";
std::cout << applyDiscount(amount) << '\n';
```
(The condition is cheap to repeat; purity is worth it. Alternatively return the *surcharge* — 0 means no discount — and let the caller print accordingly.) **Reflect:** the message is a *policy of the display*, not a fact of the arithmetic.

---

## D10 — The order-dependent orchestra

```cpp
void partA() { std::cout << partB(2) + 1; }     // uses partB...
void partB(int x) { std::cout << x * 10; }      // ...defined BELOW
int main() { partA(); return 0; }
```

Compile error. Two legal fixes; which one matches the house layout, and why is the other one a trap at scale?

<details markdown="1"><summary>Hints</summary>

1. The compiler reads top-down — what does it know when it reaches `partA`?
2. [Prototypes](lesson-2-scope.md#4-prototypes--telling-the-compiler-early).

</details>

<a name="d10--the-order-dependent-orchestra"></a>
**Fix (house style):** add `int partB(int x);` to the prototypes block. **(Trap fix):** physically reorder definitions (partB above partA) — works now, and shatters the next time anyone adds a function; ordering gymnastics don't scale, a table of contents does. **Reflect:** prototypes make definition order irrelevant — that's their whole job.

---

## Fix-list recap

| D | Bug family | Gallery |
| --- | --- | --- |
| D1 | declared, never defined | F1 |
| D2 | call without parentheses | F3 |
| D3 | expecting write-back from a copy | F5 |
| D4 | silent argument conversion | F6 |
| D5 | mutable global state | F9 |
| D6 | type mismatch + magic numbers + missing returns | F7 (+review discipline) |
| D7 | overload/defaults ambiguity | F10 |
| D8 | recursion where a loop belongs | design |
| D9 | compute-and-print coupling | F8 |
| D10 | definition-order dependence | F2 (prototypes) |
