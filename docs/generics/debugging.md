---
title: "Generics Debugging — 8 Seeded Hunts"
description: "Eight broken operators and templates — dangling returns, deduction mismatches, contract violations, stream slips — with separated diagnoses."
---

# Debugging — 8 seeded hunts

> [← Module home](index.md) · Each snippet compiles (or nearly) but misbehaves. Predict the symptom, form a hypothesis, *then* read the separated diagnosis. Several diagnoses involve reading template errors — Lesson 2 §4's skill, exercised.

---

## D1 — The sum that evaporated

```cpp
#include <iostream>
using namespace std;

class Money {
public:
    Money(long long p = 0) : paisa(p) {}
    long long getPaisa() const { return paisa; }
private:
    long long paisa;
};

Money& operator+(const Money& a, const Money& b) {
    Money result(a.getPaisa() + b.getPaisa());
    return result;
}

int main() {
    Money m = Money(100) + Money(250);
    cout << m.getPaisa() << "\n";     // expected 350
    return 0;
}
```

The compiler *warned*. What dangles, when does the symptom appear, and which two signature families are honest?

<details markdown="1">
<summary>Diagnosis</summary>

`operator+` returns a reference to the local `result`, which **dies at the closing brace** — the caller receives a reference to a destroyed object; reading `getPaisa()` is undefined behaviour (350, garbage, anything). The warning: *"reference to local variable 'result' returned."* Honest families: binary arithmetic returns **by value** (`Money operator+`); reference returns exist only for `*this` (the `+=` family) and the stream in `<<`/`>>` — both of which outlive the call. (Gallery #2 of Lesson 1 — the hunt's whole payload.)
</details>

---

## D2 — The asymmetric equality

```cpp
class Temperature {
public:
    Temperature(double c) : celsius(c) {}          // note: NOT explicit
    bool operator==(const Temperature& o) const { return celsius == o.celsius; }
private:
    double celsius;
};

int main() {
    Temperature t(36.6);
    if (t == Temperature(36.6)) cout << "A";        // prints A
    if (t == 36.6)              cout << "B";        // prints B (conversion serves)
    if (36.6 == t)              cout << "C";        // ← fails to compile?
    return 0;
}
```

Explain exactly why `C` fails while `B` works, name the structural cause, and give the two honest cures.

<details markdown="1">
<summary>Diagnosis</summary>

`B` compiles because the *right* operand converts: the non-explicit constructor turns `36.6` into `Temperature` for the member `operator==`. `C` cannot compile: for a **member** operator the left operand must *be* the class — a conversion may apply to the right side only, and `36.6` has no member functions to call. Structural cause: members fix their left operand (Lesson 1 §2's symmetry argument). Cures: (1) move `==` to a non-member taking `(const Temperature&, const Temperature&)` — then the conversion serves both sides; (2) keep `explicit` and add the deliberate non-member pair `==(const Temperature&, double)` / `==(double, const Temperature&)`. The design decision (explicit or converting) and the comparison set go together — E10's rule, now with the failing line in hand.
</details>

---

## D3 — The chain that stopped

```cpp
#include <iostream>
using namespace std;

class Die {
public:
    friend ostream& operator<<(ostream& out, const Die& d);
private:
    int face = 4;
};

ostream& operator<<(ostream& out, const Die& d) {
    out << "die shows " << d.face;
}

int main() {
    Die d;
    cout << d << "\n";        // expected: die shows 4, then a newline
    return 0;
}
```

The first run printed the face. The newline never came — and on some compilers this doesn't compile at all. Diagnose both behaviours and the four-word rule.

<details markdown="1">
<summary>Diagnosis</summary>

`operator<<` **forgot `return out;`** — it returns "nothing", which is a compile error outright ("return-statement with no value in a function returning 'ostream&'"). The versions that "printed the face then lost the newline" are the even sneakier sibling: a `return;` (void return) that some compilers accept in a warning-only mode — the chain `(cout << d) << "\n"` then calls `<<` on a destroyed stream reference. Four-word rule: **`operator<<` returns the stream.** (Gallery #4; the OOP module's chaining requirement, now the debugging hunt.)
</details>

---

## D4 — The contract that wasn't

```cpp
#include <iostream>
#include <string>
using namespace std;

template <typename T>
const T& myMax(const T& a, const T& b) {
    return (a < b) ? b : a;
}

class Wallet {
public:
    Wallet(long long p = 0) : paisa(p) {}
    long long getPaisa() const { return paisa; }
private:
    long long paisa;
};

int main() {
    Wallet w1(100), w2(250);
    cout << myMax(w1, w2).getPaisa() << "\n";   // expected 250
    return 0;
}
```

The template itself is fine. The stamp fails — name the error's *shape*, locate the one line of *your* code inside the wall of instantiation noise, and give the fix (both the operator and the contract comment).

<details markdown="1">
<summary>Diagnosis</summary>

The error is a **deduction-stage failure**: the compiler tries to stamp `myMax<Wallet>` and inside the pattern body finds `a < b` with no `operator<` for `Wallet` — the message ("no match for 'operator<'") arrives buried under template-instantiation context lines. The skill: the *first* mention of your own file/line (`mymax.cpp:19` or wherever the call is) is the real location; the rest is the stamping trail. Fix: give `Wallet` a `bool operator<(const Wallet& o) const { return paisa < o.paisa; }` — and write the template's contract comment (*"`T` requires `<`"*) so the next user meets the requirement before the compiler does. (Lesson 2 §4's limitation 1 and mistake 1, exercised together.)
</details>

---

## D5 — The deduction that couldn't agree

```cpp
template <typename T>
const T& myMin(const T& a, const T& b) {
    return (a < b) ? a : b;
}

int main() {
    cout << myMin(3, 4.5) << "\n";      // the line
    return 0;
}
```

Why exactly does deduction fail here (name the two competing deductions), and what are the three cures — including the honest one-paragraph answer for which cure preserves the *no-copy* property?

<details markdown="1">
<summary>Diagnosis</summary>

Arg 1 deduces `T = int`; arg 2 deduces `T = double` — one parameter, two contradictory demands, deduction fails ("no matching function... deduced conflicting types"). Cures: (1) matching literals — `myMin(3.0, 4.5)`; (2) explicit `T` — `myMin<double>(3, 4.5)` (the `int` converts); (3) the two-parameter template `template <typename A, typename B> A myMin2(const A&, const B&)` — returning `A`, the first argument's type, the caller's chosen common currency. The no-copy note: all three preserve `const&` parameters — nothing is copied *in*; the explicit-T and two-parameter forms may convert *one argument into a temporary* (which the `const&` legally binds) — the honest answer names that temporary and its lifetime (the full expression, like any temporary).
</details>

---

## D6 — The Box that leaked

```cpp
template <typename T>
class Box {
public:
    Box(int cap) : cap(cap > 0 ? cap : 1) { data = new T[cap]; }
    ~Box() { delete[] data; }
    bool add(const T& item) { if (count >= cap) return false; data[count++] = item; return true; }
private:
    T* data;
    int cap, count = 0;
};

int main() {
    Box<int> a(5);
    Box<int> b = a;          // ← the line
    b.add(9);
    return 0;
}
```

This compiles, runs, and corrupts. Name the event, trace the two objects' lifelines, and connect the hunt to the Inheritance module's D4 — then state the two honest postures for this course level.

<details markdown="1">
<summary>Diagnosis</summary>

`Box<int> b = a;` **copies the Box by value** — the compiler-generated copy copies the **pointer**: two Boxes, one heap block. `b.add(9)` writes through the shared block (a corrupts); both destructors `delete[]` it (double-free, undefined behaviour). Same hunt as the Inheritance module's D4 (`SessionLog` by value) — generalized: *every resource-owning template poisons its copies*. Honest postures at this level: (1) pass Boxes by reference/`const&` and never copy them (the ownership comment at the class head); (2) the proper machinery — user-defined copy constructor/assignment (the "rule of three"), named here, built next course.
</details>

---

## D7 — The template in the wrong file

```cpp
// mymath.cpp
#include "mymath.hpp"

template <typename T>
T clampTo(T v, T lo, T hi) {
    return v < lo ? lo : (v > hi ? hi : v);
}
// (definition lives ONLY here; the header declares nothing)

// main.cpp
#include "mymath.hpp"
int main() {
    // int x = clampTo(15, 0, 10);   // ← the line, currently commented
    return 0;
}
```

The program links fine today. Uncomment the line in `main.cpp` and describe the exact failure, its cause (the §2 scope note), and the layout that fixes it.

<details markdown="1">
<summary>Diagnosis</summary>

**Linker error**: *"undefined reference to `int clampTo<int>(int, int, int)`"* — not a compile error. Cause: templates are *stamped where used*, so the compiler must see the **definition** in every translation unit that stamps it; `main.cpp` saw only nothing (the header declared nothing), so it emitted a call to a function no file ever generated. Fix: template definitions live in the **header** (`mymath.hpp`) — the §2 scope note's rule, now felt. (Secondary fix: the header needs *some* declaration for the definition to make sense; in practice the whole template — `template` line and body — moves into the header.)
</details>

---

## D8 — The audit: three bugs, one file

```cpp
#include <iostream>
#include <string>
using namespace std;

template <typename T>
class Score {
public:
    Score(const T& value) : value(value) {}
    bool operator<(const Score& o) { return value < o.value; }   // line A
    friend ostream& operator<<(ostream& out, const Score& s) {
        out << s.value;
    }                                                            // line B
private:
    T value;
};

template <typename T>
T best(const Score<T> arr[], int n) {
    Score<T> champion(0);                        // line C
    for (int i = 0; i < n; i++)
        if (arr[i] < champion) champion = arr[i];
    return champion;                             // line D
}

int main() {
    Score<int> scores[3] = { Score<int>(50), Score<int>(90), Score<int>(70) };
    cout << best(scores, 3) << "\n";             // expected 90
    return 0;
}
```

Find all three defects before reading the list — classify each: comparison-logic bug, stream bug, or generic-design bug.

<details markdown="1">
<summary>Diagnosis</summary>

**Line A — comparison-logic bug, twice over:** `operator<` is **not const**, so it cannot be called where a const `Score` appears (a `const Score<T>&` parameter, a const array element — the compiled build only survives because every object here is mutable); and the loop *direction* tracks the **minimum**, not the best — it keeps `arr[i]` when `arr[i] < champion`, so expected 90 prints 50. Fixes: `bool operator<(const Score& o) const` and flip the comparison (`champion < arr[i]`). **Line B — stream bug:** the friend `operator<<` returns nothing (the D3 hunt again) — add `return out;`. **Line C/D — generic-design bug:** `Score<T> champion(0)` assumes `T` constructible from `0` — a requirement the template never stated, and one `string` fails outright; returning `T` (line D) also copies. Honest design: seed from the first element (`if (n <= 0) throw; Score<T> champion = arr[0]; for (int i = 1; ...) if (champion < arr[i]) champion = arr[i];`) and state the contract in a comment (*"`T`: copyable, `<`, `<<`"*) — the seed-from-first-element pattern the Algorithms module taught, now in generic dress. Verdict order: logic → stream → design.
</details>

---

## Fix-list recap

| Hunt | Bug class | Prevention rule |
| --- | --- | --- |
| D1 | reference to local | `+` by value; `&` only for `*this`/streams |
| D2 | member asymmetry | comparisons are non-members (or pairs) |
| D3 | stream returns nothing | `operator<<` returns the stream |
| D4 | unstated contract | comment the requirements; read your line in the wall |
| D5 | deduction conflict | match literals / explicit T / two-parameter form |
| D6 | copied resource owner | never copy boxes; rule-of-three next course |
| D7 | template in a .cpp | definitions live in headers |
| D8 | three-for-one audit | logic → stream → design; seed from the first element |

## Where next

- [Design problems](design.md): six operator/template judgements.
- [The five labs](labs.md): build them properly.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
