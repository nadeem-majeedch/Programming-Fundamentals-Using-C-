---
title: "Lesson 3 — Abstract Classes, Interfaces, and the Composition Decision"
description: "Pure virtual functions, abstract classes, the interface concept, the full composition-vs-inheritance decision procedure, and the common OOP design mistakes gallery."
---

# Lesson 3 — Abstract Classes, Interfaces, and the Composition Decision

> [← Module home](index.md) · [← Lesson 2 — virtual and runtime polymorphism](lesson-2-virtual-polymorphism.md)

## In this lesson you will learn

- **pure virtual functions** and **abstract classes** — bases that refuse to be instantiated
- the **interface** as a C++ design concept — and the two idioms that implement it
- the full **composition vs inheritance decision procedure**, with worked cases
- the **common OOP design mistakes** gallery — the families, named and cured

---

## 1. The problem abstract classes solve

Lesson 2's `Shape` was *usable* — `Shape s;` compiled, with `area()` answering 0. That's a design leak: no honest shape has no area; "0" is a lie waiting in every future collection. The base class exists to *be inherited from*, not to be instantiated — and C++ lets you say exactly that:

```cpp
class Shape {
public:
    virtual double area() const = 0;     // PURE virtual: "= 0" means "no body here — refine me"
    virtual ~Shape() = default;
    void describe() const {              // non-virtual: shared, exact
        cout << "area = " << area() << "\n";
    }
};

// Shape s;                 // ← COMPILE ERROR: Shape is abstract
// new Shape();             // ← same error

class Circle : public Shape {
public:
    double area() const override { return 3.14159265358979 * r * r; }
private:
    double r;
};

class Triangle : public Shape { /* no area() override... */ };
// Triangle t;              // ← COMPILE ERROR: Triangle is still abstract (didn't refine area)
```

**Pure virtual** (`= 0`) declares a function *with no implementation in this class* — a contract the class's children must fulfil. A class with any pure virtual function is **abstract**: it cannot be instantiated; it can only be inherited. The compiler becomes the enforcer of the contract: any derived class that fails to override every pure virtual remains abstract itself — the "you forgot something" is now a compile error instead of a runtime 0.

Abstract bases may still have: non-virtual methods with bodies (`describe` — shared code calling the hooks), attributes, constructors (they run as the base step of derived construction — Lesson 1's order), and a virtual destructor. **Pure virtual functions may even have a body** (called explicitly as `Shape::area()` — a default implementation subclasses may invoke); the "= 0" forbids *instantiation*, not implementation. At this course's level, keep pure virtuals bodyless and reserve shared code for non-virtuals.

---

## 2. Interfaces — the concept, and its two C++ idioms

An **interface** is a pure contract: *what you can ask of an object, with no data and no behaviour of its own.* Classes across the program agree on it, and code written against the interface works with every implementer — the polymorphic `gallery` loop, promoted to a design principle.

**Idiom 1 — the pure-abstract interface class:**

```cpp
class Printable {
public:
    virtual void print(ostream& out) const = 0;
    virtual ~Printable() = default;
};

class Invoice : public Printable {
public:
    void print(ostream& out) const override { out << "INVOICE #" << number << "\n"; }
private:
    int number = 1;
};

// works with EVERY Printable, present and future:
void printAll(const vector<Printable*>& docs) {
    for (const Printable* d : docs) d->print(cout);
}
```

Conventions that mark the idiom: name interfaces for capability (`Printable`, `Saveable`, `Comparable`); **no attributes**; all functions pure virtual; **a virtual destructor**; multiple inheritance of *interfaces* is safe and common (a class can be `Printable` and `Saveable` — pure contracts carry no state to conflict). Heavy multiple inheritance of *implementation* classes is the tangle this course skips; you should be able to say why the interface case is different (nothing is inherited but promises).

**Idiom 2 — the one you already own: `operator<<` via the hook.**

```cpp
ostream& operator<<(ostream& out, const Printable& p) {
    p.print(out);
    return out;
}
// cout << invoice; works for every current and future Printable
```

The OOP module's `operator<<` pattern becomes *generic over the hierarchy*: one operator, infinite implementers. This is the exact architecture of the [mini-project](miniproject.md)'s report layer.

---

## 3. Composition vs inheritance — the decision, in full

The OOP module's field guide gets its final table. Both mechanisms route calls to other code; they encode different **relationships**, and the wrong one calcifies:

| | Inheritance (`is-a`) | Composition (`has-a`) |
| --- | --- | --- |
| Sentence | "Dog **is an** Animal" | "Car **has an** Engine" |
| Binds | derived to base **forever** (compile-time, fixed) | held by reference — swappable **at runtime** |
| Exposes | the base's interface *plus* (via protected) its interior | only what the wrapper chooses to expose |
| Reuse | comes with substitutability obligations | comes with zero obligations |
| Breaks when | base changes (all children feel it — the **fragile base class**) | the wrapped class changes *its contract* (rare — that's why interfaces exist) |
| Test | **Liskov**: base everywhere ⇒ derived everywhere | no test — any use is legal |

### The decision procedure

1. **Run the is-a test — in writing.** *"X is a Y" spoken as a full sentence, then the substitutability check: can X appear everywhere Y appears, keeping every promise?* Fail or hesitate ⇒ inheritance is wrong, whatever the reuse savings.
2. **Hesitating between is-a and has-a? Choose has-a.** (The course's standing heuristic — "favour composition" — is not a fashion: composites stay swappable and base changes stay local.)
3. **Is the variation *kind* or *degree*?** Kinds (Circle/Rect/Triangle — different *rules* for the same question) → inheritance from an abstract base. Degrees (an account with a fee schedule *value*) → a composed strategy object (the Payment lab makes you feel both).
4. **Will the family grow?** Expecting new kinds monthly ⇒ an interface earns its abstraction. A stable pair of classes ⇒ maybe neither mechanism; two honest classes with one shared free function beat a ceremony hierarchy.
5. **Need to swap behaviour at runtime?** Composition with an interface reference (`PaymentMethod*` switchable per checkout — [Lab 3](labs.md)) — inheritance cannot re-pick a base class after birth.

### The two worked cases you will meet in the labs

- **`Square : Rectangle`** — is-a passes mathematically, fails behaviourally (a Rectangle promising independent `setWidth`/`setHeight` is a promise a Square can't keep). Verdict: **don't inherit**; either make shapes immutable or treat Square as data, not a subclass. ([Design D4](design.md) defends it in full.)
- **`Car : Engine`** ("to reuse the engine's methods") — absurd is-a; the honest sentence is *has-a*: `Car` contains an `Engine` and exposes `start()`. Verdict: composition, instantly. ([Design D2](design.md) walks it.)

---

## 4. Common OOP design mistakes — the gallery

1. **Inheriting for code reuse alone.** The `Stack : Vector` classic. Symptom: the derived class exposes methods that break its own rules. Cure: composition + a thin interface.
2. **Fat base classes.** A base with twenty methods where subclasses override two and are forced to stub eighteen. Symptom: `// does nothing` everywhere. Cure: split the interface; small contracts (`Printable`) compose.
3. **`protected` attributes as a habit.** Every subclass now co-owns the base's invariants (Lesson 1 §4). Symptom: invariant bugs that move between classes. Cure: `private` data + `protected` guarded hooks.
4. **Non-virtual destructors on polymorphic bases.** The delete-through-base leak (Lesson 2 §4). Cure: the no-exceptions rule.
5. **God hierarchies.** One base ("`Object`", "`Manager`", "`Data`") that everything inherits because it's *convenient*. Symptom: the hierarchy diagram needs a legend. Cure: relationships must each pass the is-a test *individually* — convenience is not a relationship.
6. **Overriding without `override`.** The typo that silently hides (D3). Cure: the keyword, always.
7. **Slicing by container.** `vector<Shape>` of mixed shapes (Lesson 2 §3). Cure: pointers (smart ones, next course).
8. **Virtual everything.** Marking every method virtual "for flexibility" — a vtable on a class with two children, and a base interface nobody abstracts. Cure: virtual is a design decision (polymorphic intent), not a default.
9. **Deep hierarchies.** Five levels of single inheritance where two sufficed; the middle layers exist to pass data through. Symptom: "who actually implements this?" spelunking. Cure: prefer two shallow families plus composition over one deep family.
10. **Refused-to-abstract — the mirror error.** Ten classes each with `if (kind == CIRCLE) ... else if (kind == RECT) ...` — the kind enum doing polymorphism's job by hand (the switch the virtual table automates). Symptom: every new kind edits every switch. Cure: that's the is-a family Lesson 2 built; use it.

> **The meta-rule tying the gallery together:** *every inheritance decision must pass the is-a test in a spoken sentence, and every hierarchy earns its depth one justified level at a time.* The [design problems](design.md) grade exactly this discipline.

---

## Check yourself

- Why can't `Shape s;` compile after `area()` becomes pure virtual? (a class with a pure virtual is abstract — instantiation is forbidden; only derived classes that refine it can exist)
- Your class must be both `Printable` and `Saveable` — what do you inherit, and why is that case safe? (both interfaces — pure contracts, no data, no implementation conflicts)
- A checkout must switch payment method *after* construction. Which mechanism can do that — and why can't inheritance? (composition holding an interface reference; a base class is fixed at birth)

## Where next

- [Exercises](exercises.md) → [Design problems](design.md) → [Labs](labs.md) → [the Media Library mini-project](miniproject.md).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
