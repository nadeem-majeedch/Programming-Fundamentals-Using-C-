---
title: "Lesson 1 — Base Classes, Derived Classes, and the Order of Construction"
description: "The is-a test, public inheritance, protected members, constructor and destructor order with diagrams, and what is not inherited."
---

# Lesson 1 — Base Classes, Derived Classes, and the Order of Construction

> [← Module home](index.md) · [Lesson 2 — virtual and runtime polymorphism →](lesson-2-virtual-polymorphism.md)

## In this lesson you will learn

- what **inheritance** is — and the **is-a test** that decides when it's honest
- **base** and **derived** classes; `public` inheritance and what it means
- **`protected`** — the third access level, and why it's a loan, not a gift
- the exact **constructor and destructor order** in a hierarchy, with diagrams
- which members are **not inherited** — and what "inherited" actually means

---

## 1. What inheritance is — and the test that keeps it honest

**Inheritance** defines a class *in terms of* another: the derived class receives the base class's attributes and methods, then adds or refines. The sentence it encodes is **"is-a"**: a `Dog` **is an** `Animal`; a `SavingsAccount` **is an** `Account`.

That sentence is not decoration — it is the **design test**:

> *Everywhere the base class makes sense, the derived class must make sense too.*
> (Barbara Liskov's principle, at student scale.)

- `Dog` where an `Animal` is expected (a vet's patient list): makes sense. ✓
- `SavingsAccount` where an `Account` is expected (a statement generator): makes sense. ✓
- A `Stack<T>` inheriting from `Vector<T>` "to reuse the storage"? A stack *is-not* a vector — a vector promises insertion anywhere; a stack forbids it. **The test fails; the inheritance lies.** ✗ (This is the classic textbook example of inheritance abuse — and you'll build the honest alternative in [Design problem D3](design.md).)

The temptation that produces lying hierarchies is always the same: **code reuse**. Inheritance *does* reuse code — but reuse is what **composition** (Lesson 3) is for. Inheritance is for *substitutability*. When the honest answer to "is it a?" is "no, but it needs the same data," the is-a test has just saved you from a tangle.

**Notation used throughout this module:**

```text
        ┌──────────┐
        │  Animal  │        base class (superclass, parent)
        ├──────────┤
        │ name     │
        │ eat()    │
        └────▲─────┘
             │ "is-a" — arrow points UP to the base
        ┌────┴─────┐
        │   Dog    │        derived class (subclass, child)
        ├──────────┤
        │ breed    │        added attribute
        │ fetch()  │        added method
        └──────────┘
```

---

## 2. public inheritance — the mechanics

```cpp
// animals.cpp — Programming Fundamentals Using C++
// Inheritance module · Lesson 1 · First base/derived pair
// Compile: g++ -std=c++17 -Wall -Wextra animals.cpp -o animals

#include <iostream>
#include <string>
using namespace std;

class Animal {
public:
    Animal(const string& name) : name(name) {}
    void eat() const { cout << name << " eats.\n"; }
    void sleep() const { cout << name << " sleeps.\n"; }
    const string& getName() const { return name; }
private:
    string name;                    // private: even Dog cannot touch this directly
};

class Dog : public Animal {         // "Dog is-an Animal, publicly"
public:
    Dog(const string& name, const string& breed) : Animal(name), breed(breed) {}
    void fetch() const { cout << getName() << " fetches the " << breed << " way.\n"; }
private:
    string breed;
};

int main() {
    Dog d("Rex", " Labrador");
    d.eat();                        // inherited: Dog can do what Animal can do
    d.sleep();                      // inherited
    d.fetch();                      // added by Dog
    cout << d.getName() << "\n";    // inherited
    return 0;
}
```

**Explanation, piece by piece:**

- **`class Dog : public Animal`** — the header declares the base and the *kind* of inheritance. `public` inheritance means "is-a": every public member of `Animal` is public in `Dog`. (There are `protected` and `private` inheritances; they model "implemented-in-terms-of" rather than "is-a" — this course uses `public` and sends the others to the next course with a warning label.)
- **`Animal(name)` in Dog's initializer list** — the base is a *subobject* of Dog: every Dog contains a complete Animal part, and that part is **constructed** like any other member. You cannot skip it; you may choose *which* base constructor runs (exactly like composing a `Date` inside `Employee` — the OOP module's composition mechanics, now with a keyword).
- **Inherited methods just work.** `d.eat()` calls Animal's code with Rex's data. Dog didn't copy it — it *has* it.
- **`private` stays private.** Dog's methods cannot write `name` directly; they call `getName()` like any outsider. Inheritance does not pierce the base's wall — which is precisely why `protected` exists (§4).

### What is *not* inherited

| Member | Inherited? | Why |
| --- | --- | --- |
| Attributes and ordinary methods | yes (subject to access) | the is-a substance |
| **Constructors** | no — the base's are *called* | birth is per-class; the derived decides how to build the base part |
| **Destructors** | no — but they *all* run (§5) | death is per-class, bottom-up |
| Assignment operator | not as-is | copying involves both parts; next-course detail, named here for honesty |
| Friends | no | friendship isn't hereditary |
| `static` members | one shared copy | belongs to the class family, not the instance |

---

## 3. Adding members — and the shadowing trap

A derived class may add attributes and methods freely. It may also **redeclare** a name the base already uses — which creates *shadowing* (called **hiding** in inheritance), not overriding:

```cpp
class Animal {
public:
    void speak() const { cout << "...\n"; }
};

class Cat : public Animal {
public:
    void speak() const { cout << "Meow\n"; }   // same signature — this IS overriding (Lesson 2 makes it virtual)
};
```

Same signature in the derived = **overriding** (Lesson 2's subject). But watch what happens with a *different* signature:

```cpp
class Animal2 {
public:
    void speak() const { cout << "...\n"; }
    void speak(int times) const { for (int i = 0; i < times; i++) cout << "...\n"; }
};

class Cat2 : public Animal2 {
public:
    void speak() const { cout << "Meow\n"; }   // HIDES BOTH base overloads!
};

// Cat2 c; c.speak(3);   // ← COMPILE ERROR: speak(int) is hidden by Cat2::speak
```

**The rule that surprises everyone:** a derived-class name hides *all* base-class overloads of that name, even different signatures. The cure, when hiding isn't intended: `using Animal2::speak;` in the derived class to un-hide them. (Chapter 2 of the [debugging pack](debugging.md) seeds exactly this.) For now, file the shape: **same signature = override; any new overload of a base name = hidden base overloads until you say otherwise.**

---

## 4. `protected` — the loan you must repay

```cpp
class Account {
public:
    bool withdraw(long long amount) {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;              // the rule lives HERE
        return true;
    }
protected:
    long long balance = 0;              // visible to derived classes only
};

class SavingsAccount : public Account {
public:
    void addMonthlyInterest() {
        balance += balance / 100;       // legal: protected member, derived class
    }
};
// Outside code: acc.balance = 0;   ← still a compile error. protected ≠ public.
```

**`protected`** sits between `private` and `public`: *derived classes* may touch the member; the world may not. Use it for exactly one purpose — **giving derived classes a controlled hook into the base's interior** when the base's public interface genuinely can't express what subclasses need (here: a balance adjustment that isn't a withdrawal).

**The honest warning — the course's line on `protected`:** every `protected` attribute is a **promise that all future subclasses will maintain the base's invariants**. `Account`'s invariant ("balance changes only through guarded methods") now depends on *every class that ever inherits* being careful with `balance`. One careless subclass writes `balance = -999;` and the invariant is dead — with the bug search space expanded across the whole hierarchy. The discipline: **prefer `private` attributes + `protected` *methods*** (small, guarded operations like `protected: void adjustBalance(long long delta)`) so the wall is thinner but still a wall. Reserve `protected` *attributes* for cases you can defend in a comment — the [design reviews](design.md) will ask for that defence.

---

## 5. Constructor and destructor order — the diagrams

The derived object is **base part + added parts**. C++ builds and dismantles it in one exact order:

**Construction: base first, then members in declaration order, then the derived's own body.**
**Destruction: exact reverse — derived body first, then members, then the base.**

```text
  Construction of Dog d("Rex", "Labrador")        Destruction of d (reverse!)

  ┌─────────────────────────┐                    ┌─────────────────────────┐
  │ 1. Animal part built    │  base FIRST        │ 6. ~Dog body runs       │  derived FIRST
  │    ("Rex" stored)       │                    └─────────────────────────┘
  ├─────────────────────────┤                    ┌─────────────────────────┐
  │ 2. Dog members built    │  declaration order │ 5. Dog members destroyed│
  │    (breed)              │                    └─────────────────────────┘
  ├─────────────────────────┤                    ┌─────────────────────────┐
  │ 3. Dog body runs        │                    │ 4. Animal part destroyed│  base LAST
  │    (constructor stmts)  │                    │    (~Animal body)       │
  └─────────────────────────┘                    └─────────────────────────┘
```

**Why the order is forced:** the derived class's members and body may *use* the base part — so the base must exist before anything derived runs. Symmetrically, the derived part may be in a state the base's destructor doesn't expect, so the base is dismantled *last*, standing on the wreckage-free ground. It is the same nesting logic as composition (Employee's `Date` dies with the Employee) — extended up the family tree.

**A three-level hierarchy observed:**

```cpp
// order.cpp — the order, observed with Tracers
#include <iostream>
#include <string>
using namespace std;

class Tracer {
public:
    Tracer(const string& n) : name(n) { cout << "  build " << name << "\n"; }
    ~Tracer() { cout << "  raze  " << name << "\n"; }
private:
    string name;
};

class A {
public:
    A() { cout << "A body\n"; }
    ~A() { cout << "~A body\n"; }
protected:
    Tracer t{"A's member"};
};

class B : public A {
public:
    B() { cout << "B body\n"; }
    ~B() { cout << "~B body\n"; }
protected:
    Tracer t{"B's member"};
};

class C : public B {
public:
    C() { cout << "C body\n"; }
    ~C() { cout << "~C body\n"; }
protected:
    Tracer t{"C's member"};
};

int main() {
    cout << "construct C:\n";
    {
        C c;
    }                          // C dies at the closing brace
    cout << "C is gone\n";
    return 0;
}
```

**Output:**

```text
construct C:
  build A's member
A body
  build B's member
B body
  build C's member
C body
  raze  C's member
~C body
  raze  B's member
~B body
  raze  A's member
~A body
C is gone
```

**Reading the output:** construction climbs the chain — each level builds its *base* completely (member, then body) before its own additions; destruction descends in exact mirror. **Exam-proof summary sentence:** *bases before bodies on the way up, bodies before bases on the way down.*

---

## Check yourself

- `class Rectangle { ... }; class Square : public Rectangle { ... };` — argue both sides of the is-a test. (Mathematically a square *is* a rectangle; but a Rectangle that promises `setWidth` won't change `height` is a promise a Square cannot keep — the substitutability fails *behaviourally*. The classic warning that is-a is about the contract, not the math.)
- Why can't `Dog::fetch` write `name = "Rex Jr.";` directly? (`name` is private in Animal; inheritance doesn't pierce privacy — call the accessor or make the attribute protected, with the §4 caveat)
- In the three-level trace, where does `C body` appear relative to `build B's member`? (after — C's body runs only after its complete base part, B, exists)

## Where next

- [Lesson 2 — virtual and runtime polymorphism →](lesson-2-virtual-polymorphism.md): the same call, two very different destinations.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
