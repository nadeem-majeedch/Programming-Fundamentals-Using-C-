---
title: "Records Predictions"
description: "10 output-prediction problems — brace lists, dot chains, arrow access, enum behaviour. Answers separated."
---

# Records Predictions (10)

> [← Module home](index.md) · **Trace on paper first** — draw the record as a box of boxes — then commit. All 10 answers in the [answers section](#answers) (separated). ★ = first pass · ★★ = needs the toolkit.

**The four rules** these probe: (1) brace lists bind **by position**; missing members **zero**. (2) `=` on records copies **field by field** (nested included). (3) Pointer → arrow `->`; record → dot `.`. (4) Enums print as their **underlying integer** — names live in source only.

---

## P1 — The positional pair (★)

```cpp
struct Pair { int a; int b; };
Pair p = {7, 9};
std::cout << p.a << p.b << '\n';
Pair q = {9};
std::cout << q.a << q.b << '\n';
```
**Trace.** Two output lines. What does the *partial* list do to `q.b`?

## P2 — The copy (★)

```cpp
struct P { int x; int y; };
P a = {1, 2};
P b = a;
b.x = 50;
std::cout << a.x << ' ' << b.x << '\n';
```
**Trace.** One line. What kind of copy did `=` perform?

## P3 — The nested chain (★)

```cpp
struct Date { int y; int m; int d; };
struct Book  { std::string title; Date due; };
Book b = {"C++ Primer", {2026, 1, 31}};
std::cout << b.due.y << '-' << b.due.m << '-' << b.due.d << '\n';
```
**Trace.** How do the dots descend, and which brace-list value lands in `due.m`?

## P4 — The door mix (★★)

```cpp
struct T { int v; };
void byValue(T t)  { t.v = 10; }
void byRef(T& t)   { t.v = 20; }
void byPointer(T* t) { t->v = 30; }

T x = {0};
byValue(x);   std::cout << x.v << ' ';
byRef(x);     std::cout << x.v << ' ';
byPointer(&x); std::cout << x.v << '\n';
```
**Trace.** One line, three numbers — which doors touched the caller's box?

## P5 — The arrow walk (★★)

```cpp
struct T { int v; };
T arr[3] = { {5}, {6}, {7}};
T* p = arr;
std::cout << p->v << ' ';
p = p + 2;
std::cout << p->v << ' ';
std::cout << (*p).v << '\n';
```
**Trace.** Three numbers. What does `p + 2` mean for a *record* array (whose elements are, say, 40 bytes)?

## P6 — The return (★★)

```cpp
struct T { int v; };
T make(int k) { T t = {k}; return t; }

T a = make(9);
T b = a;
b.v += 1;
std::cout << a.v << ' ' << b.v << '\n';
```
**Trace.** Two numbers — and two separate deep copies happened. Where?

## P7 — The const wall (★★)

```cpp
struct T { int v; };
void sneak(const T& t) { /* wants: */ /* t.v = 99; */ }
T x = {1};
sneak(x);
std::cout << x.v << '\n';
```
**Trace.** The assignment is commented out. (a) What *exactly* happens if you uncomment it — runtime change, or compile error? (b) What is `const&` buying the caller here?

## P8 — The enum integer (★)

```cpp
enum class Color { RED, GREEN, BLUE };
Color c = Color::GREEN;
std::cout << c << '\n';
```
**Trace.** What prints — the name, or something else? Why?

## P9 — The switch fall (★★)

```cpp
enum class State { IDLE, RUN, STOP };
State s = static_cast<State>(5);
switch (s) {
    case State::IDLE: std::cout << "idle\n"; break;
    case State::RUN:  std::cout << "run\n";  break;
    case State::STOP: std::cout << "stop\n"; break;
}
std::cout << "end\n";
```
**Trace.** Two lines total. What did the cast build, and where did the switch go?

## P10 — The scoped collision (★★)

```cpp
enum class Color { RED, GREEN };
enum class Light { RED, AMBER };     // does this line survive?

Color c = Color::RED;
Light l = Light::RED;
std::cout << (c == l) << '\n';       // (a) does THIS line survive?
```
**Trace.** Two verdicts: does each marked line compile, and why?

---

<a name="answers"></a>
# Answers

<details markdown="1"><summary>A1 — P1 (positional pair)</summary>

`79` then `90`. The partial list `{9}` binds 9 to the **first** member (a=9) and zero-fills the missing `b`. Positional binding + zero-fill, both in one trace.
</details>

<details markdown="1"><summary>A2 — P2 (the copy)</summary>

`1 50`. `=` copied field by field — `b` is an independent record. The parallel-array equivalent needed two statements; the record needed one and cannot drift.
</details>

<details markdown="1"><summary>A3 — P3 (nested chain)</summary>

`2026-1-31`. The dots descend: b's `due`, then the date's members. The nested brace `{2026, 1, 31}` binds positionally to `{y, m, d}` → m gets **1**.
</details>

<details markdown="1"><summary>A4 — P4 (the door mix)</summary>

`0 20 30`. `byValue` mutated its copy (x untouched); `byRef` wrote through the alias; `byPointer` wrote through the address. Only the value door left the caller's box unchanged — the reason door choice is a design decision, not syntax.
</details>

<details markdown="1"><summary>A5 — P5 (the arrow walk)</summary>

`5 7 7`. `p + 2` moves **two elements** — two strides of `sizeof(T)` (~40 bytes each if the string member were present; here two records), *not* two bytes. `(*p).v` is the explicit spelling of `p->v` — same read. ([Lesson 2 §1](lesson-2-functions-nesting.md#door-2--by-pointer-the-handle-crosses), [Unit 13 §1](../pointers/lesson-3-arrays-dynamic.md#arrays-as-addresses))
</details>

<details markdown="1"><summary>A6 — P6 (the return)</summary>

`9 10`. Copy #1: `return t;` copies the local out. Copy #2: `T b = a;` duplicates it. After that, independence: `b.v += 1` touches only b.
</details>

<details markdown="1"><summary>A7 — P7 (the const wall)</summary>

(a) **Compile error** — assigning through a `const&` is rejected before the program ever runs; the wall is built by the compiler, not the runtime. (b) `const&` buys the caller a **no-copy guarantee plus a compiler-enforced promise** that the callee cannot modify — read-only access at reference speed with value-parameter safety.
</details>

<details markdown="1"><summary>A8 — P8 (the enum integer)</summary>

`1` — the underlying integer. Enum **names live in the source code only**; at runtime the value is a number. Printing a human-readable name needs the `xText()` bridge ([Lesson 3 §2](lesson-3-enums-design.md#2-comparing-switching-printing)).
</details>

<details markdown="1"><summary>A9 — P9 (the switch fall)</summary>

Only `end` prints. The cast laundered 5 into a `State` that **no member has**; no case matches, no `default` exists, so control falls straight through ([D5](debugging.md#d5), [gallery G7](lesson-3-enums-design.md#6-the-common-mistakes-gallery)). Validate before casting — or map through a menu function.
</details>

<details markdown="1"><summary>A10 — P10 (the scoped collision)</summary>

Line 2 (the second enum): **compiles** — enum class members are scoped, so `Light::RED` and `Color::RED` coexist (plain enums would collide here). The comparison: **compile error** — `c == l` compares two *different enum class types*; no implicit conversion exists. Both refusals are the safety working.
</details>
