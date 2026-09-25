---
title: "Lesson 2 — virtual Functions and Runtime Polymorphism"
description: "Overriding, the non-virtual call problem drawn in two diagrams, virtual dispatch through base pointers, the Shape loop, slicing, virtual destructors, and override/final."
---

# Lesson 2 — `virtual` Functions and Runtime Polymorphism

> [← Module home](index.md) · [← Lesson 1 — Base and derived](lesson-1-base-derived.md) · [Lesson 3 — Abstract classes and design →](lesson-3-abstract-design.md)

## In this lesson you will learn

- **method overriding** — and the one keyword (`virtual`) that separates true overriding from accidental shadowing
- why the call `basePtr->method()` goes to the wrong function without `virtual` — drawn in two diagrams
- **runtime polymorphism**: one loop, many behaviours
- **slicing** — the assignment that quietly amputates a derived object
- **virtual destructors** — the rule that has no exceptions
- `override` and `final` — the compiler as a design reviewer

---

## 1. The problem `virtual` solves — two diagrams

Start from Lesson 1's hierarchy, used through **base-class pointers** (which is how every collection of mixed animals, shapes, or accounts must be stored):

```cpp
Animal* a = &dog;      // a Dog, seen through an Animal window
a->speak();            // which speak()?
```

**Without `virtual` — the call follows the *pointer's type*:**

```text
        a is an Animal*            the compiler decides at COMPILE time
             │
             ▼
   ┌──────────────────┐
   │  Animal::speak   │  ← the call lands here, whatever the object really is
   └──────────────────┘
        (the Dog's "Woof" never fires — the window decided, not the object)
```

**With `virtual` — the call follows the *object's actual type*:**

```text
        a is an Animal*            the object decides at RUNTIME
             │   "speak is virtual: ask the OBJECT"
             ▼
   ┌──────────────────┐      ┌─────────────────────────────┐
   │  Animal part     │      │ Dog part                    │
   │   ...            │◄─────│ vptr ──► Dog::speak  ★ the call lands here
   └──────────────────┘      └─────────────────────────────┘
```

The mechanism (worth one honest paragraph): every object of a class with virtual functions carries one hidden pointer (**the vptr**) to its class's **vtable** — a table of that class's virtual functions. The call `a->speak()` compiles to *"follow the vptr, call slot #2"* — and the Dog's vtable has Dog's `speak` in slot #2. The compiler emits the same instructions for every Animal*; the *object's table* picks the function. That is **dynamic dispatch**, and it is the machinery under the word "polymorphism."

> **Polymorphism**, precisely: *one call site, many behaviours, chosen by the object at runtime.* The Greek is honest — many forms of `speak`, one line of calling code.

---

## 2. Overriding — the complete first example

```cpp
// shapes.cpp — Programming Fundamentals Using C++
// Inheritance module · Lesson 2 · virtual dispatch
// Compile: g++ -std=c++17 -Wall -Wextra shapes.cpp -o shapes

#include <iostream>
#include <vector>
using namespace std;

class Shape {
public:
    virtual double area() const { return 0.0; }     // virtual: subclasses may refine
    virtual ~Shape() = default;                     // rule with no exceptions (§5)
    void describe() const {                          // NOT virtual: shared, exact
        cout << "area = " << area() << "\n";         // ...but it CALLS a virtual!
    }
private:
    string name = "shape";
};

class Circle : public Shape {
public:
    Circle(double r) : radius(r) {}
    double area() const override { return 3.14159265358979 * radius * radius; }
private:
    double radius;
};

class Rect : public Shape {
public:
    Rect(double w, double h) : w(w), h(h) {}
    double area() const override { return w * h; }
private:
    double w, h;
};

int main() {
    vector<Shape*> gallery = { new Circle(2.0), new Rect(3.0, 4.0), new Circle(0.5) };
    double total = 0.0;
    for (const Shape* s : gallery) {
        s->describe();            // one call site...
        total += s->area();       // ...three behaviours
    }
    cout << "total = " << total << "\n";
    for (Shape* s : gallery) delete s;    // virtual ~Shape makes each right
    return 0;
}
```

**Output:**

```text
area = 12.5664
area = 12
area = 0.785398
total = 25.3518
```

**The three facts that make this the module's centrepiece:**

1. **One loop, many kinds.** The `gallery` mixes Circles and Rects; the loop neither knows nor cares which. A new `Triangle` class slots in with **zero changes** to the loop — that extensibility is what polymorphism is *for*.
2. **`describe()` is non-virtual but calls a virtual.** The shared code stays shared (one implementation of `describe`), and the *varying* part (`area`) dispatches. This split — **non-virtual template method calling virtual hooks** — is the workhorse pattern of real frameworks; you have now written its skeleton.
3. **`override` on every overriding method.** It adds no behaviour; it makes the compiler *verify* the signature really overrides a virtual (catching the typo-override that silently becomes hiding — [hunt D3](debugging.md)). Non-virtual rule for the course: **always write `override`; never write `virtual` twice** (mark it in the base, prove it with `override` in the derived).

---

## 3. Slicing — the quiet amputation

```cpp
Circle c(2.0);
Shape s = c;          // ← compiles. What is s?
cout << s.area() << "\n";    // 0 — not 12.5664
```

**What happened:** assigning a derived object **by value** to a base variable copies only the **base part** — the Circle's `radius` never fits, so it is sliced off. `s` is a genuine Shape: no vptr to Circle's table, no radius, `area()` answers 0. No error, no warning — just a wrong answer.

**The rule, and the habits that enforce it:**

| Want | Do | Never do |
| --- | --- | --- |
| mixed collection | `vector<unique_ptr<Shape>>` or (course level) `vector<Shape*>` | `vector<Shape>` — the vector slices on insert |
| pass to a function | `const Shape&` or `Shape*` | `Shape` by value — the parameter slices |
| copy a derived | through pointers/references | by-value base assignment |

Slicing is the inheritance-world version of a bug you already know: the struct-copy that fooled the test (P20, [Debugging pack](../debugging/practice.md)) — two objects that look like one. There the cure was references; here it is the same cure plus a smarter container.

---

## 4. Virtual destructors — the rule with no exceptions

```cpp
Shape* s = new Circle(2.0);
delete s;          // WHICH destructor?
```

`delete` through a base pointer calls the destructor the same way it calls any method. Non-virtual destructor → **only `~Shape` runs** — the Circle part (its `double radius`, trivial here; its `string name` and heap blocks in real classes) is never destroyed: **undefined behaviour**, leaking in practice. Virtual destructor → the call dispatches, `~Circle` runs, *then* `~Shape` runs — the Lesson 1 death order, triggered correctly through the base pointer.

**The course rule, absolute:** *any class intended as a polymorphic base gets a virtual destructor* — `virtual ~Shape() = default;` is enough. If a class has no virtual functions and is never deleted through a base pointer, a plain destructor is fine (and cheaper). The [debugging hunts](debugging.md) and [labs](labs.md) enforce this every time.

---

## 5. Hiding vs overriding — the one-table difference

| | Hiding (non-virtual name match) | Overriding (virtual + same signature) |
| --- | --- | --- |
| Requires | any same-signature redeclaration | `virtual` in base + same signature (+ `override`) |
| Decided by | the pointer/reference **type** (compile time) | the **object's** type (runtime, via vtable) |
| Works through base pointer? | no — base version runs | yes — derived version runs |
| Hides base overloads? | yes (Lesson 1 §3) | no — `override` keeps the family intact |
| Detectable typo? | silent — becomes hiding | caught by `override` |

The design intent separates them too: **overriding is a public promise** — "through this base interface, my version answers." **Hiding is usually an accident** (or a deliberate new overload, which needs `using` to stay honest). When you write a same-signature method in a derived class, say which one you mean: `override`, or a *different* name.

---

## Check yourself

- `Animal* a = &cat; a->speak();` with non-virtual `speak` — who decides the function, and when? (the pointer's type, at compile time — Animal::speak runs)
- Why does `vector<Shape>` break the gallery, while `vector<Shape*>` works? (by-value storage slices each derived object on insert; pointers store addresses, and the object keeps its vptr)
- A base has `virtual ~Base() = default;`. Through `Base* p = new Derived; delete p;` — how many destructors run? (both, in the Lesson 1 order: ~Derived body/members first, then ~Base)

## Where next

- [Lesson 3 — Abstract classes, interfaces, and design →](lesson-3-abstract-design.md): shapes that refuse to be instantiated, and the composition decision.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
