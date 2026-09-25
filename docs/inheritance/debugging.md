---
title: "Inheritance Debugging — 10 Seeded Hunts"
description: "Ten broken hierarchies — hiding masquerading as overriding, slicing, missing virtual destructors, fat contracts — with separated diagnoses."
---

# Debugging — 10 seeded hunts

> [← Module home](index.md) · Each snippet compiles (or nearly) but misbehaves. Predict the symptom, form a hypothesis, *then* read the separated diagnosis. Compile with `-Wall -Wextra` — a few of these announce themselves.

---

## D1 — The override that never fires

```cpp
#include <iostream>
using namespace std;

class Animal {
public:
    void speak() const { cout << "generic sound\n"; }
};

class Dog : public Animal {
public:
    void speak() const { cout << "Woof\n"; }    // intended as an override
};

int main() {
    Dog d;
    Animal* a = &d;
    a->speak();
    return 0;
}
```

The programmer expected "Woof". What prints, which single keyword fixes it, and which second keyword makes the compiler the guardian?

<details markdown="1">
<summary>Diagnosis</summary>

Prints **"generic sound"**: `speak` is non-virtual, so the call through `Animal*` follows the *pointer's type* at compile time — Dog's version is mere name-hiding, invisible through the base window. Fix: `virtual void speak() const` in `Animal`. Guardian: `override` on Dog's `speak` — with it, the compiler would have *failed the build* the moment `Animal::speak` lost its `virtual` ("only virtual member functions can be marked 'override'"), turning this silent bug into a loud one. The pair — `virtual` in the base, `override` in the derived — is the module's standing rule.
</details>

---

## D2 — The collection that shrank

```cpp
#include <iostream>
#include <vector>
using namespace std;

class Shape {
public:
    virtual double area() const { return 0.0; }
    virtual ~Shape() = default;
};
class Circle : public Shape {
public:
    Circle(double r) : r(r) {}
    double area() const override { return 3.14159265358979 * r * r; }
private:
    double r;
};

int main() {
    vector<Shape> shapes;
    shapes.push_back(Circle(2.0));
    cout << shapes[0].area() << "\n";   // expected 12.5664
    return 0;
}
```

Why does the correct code print `0`, and what two containers fix it?

<details markdown="1">
<summary>Diagnosis</summary>

**Slicing**: `push_back(Circle(2.0))` into a `vector<Shape>` copies *only the Shape part* of the Circle — the `r` member and the Circle's vptr never survive the by-value copy. `shapes[0]` is a genuine (plain) Shape: `area()` answers 0, no warning. Fixes: `vector<Shape*> shapes; shapes.push_back(new Circle(2.0));` — addresses keep whole objects (with the ownership loop that implies, E14) — or, next course, `vector<unique_ptr<Shape>>`, which automates exactly that ownership. The container *type* is a design decision about identity: store values ⇒ uniform base objects; store addresses ⇒ polymorphic family.
</details>

---

## D3 — The typo that hid

```cpp
class Resource {
public:
    virtual void load(const string& path) { /* ... */ }
    virtual ~Resource() = default;
};

class Image : public Resource {
public:
    void load(const string& path) override { /* ... */ }   // A
    // ...later, during a "quick refactor"...
    void lode(const string& path) override { /* ... */ }   // B — the "fix"
};

int main() {
    Image img;
    Resource* r = &img;
    r->load("photo.png");      // which version runs? and which line failed the build?
    return 0;
}
```

Line B was meant to replace line A. What fails to compile, and what would have shipped if line A had been quietly deleted instead of renamed?

<details markdown="1">
<summary>Diagnosis</summary>

Line B **fails to compile**: `lode` overrides nothing (`override` checks), so the compiler names the error immediately — the keyword doing its job. The dangerous alternative: delete A entirely, ship B with `override` removed — then `r->load(...)` runs **`Resource::load`'s body** (an empty stub, or worse, base logic) for every Image, forever, with no diagnostic anywhere. The lesson generalizes: `override` is to hierarchies what `-Wall` is to locals — you pay one keyword to be told about a whole bug family.
</details>

---

## D4 — The leak through the base pointer

```cpp
#include <string>
using namespace std;

class Job {
public:
    Job() { cout << "Job acquired\n"; }
    ~Job() { cout << "Job released\n"; }
};
class PrintJob : public Job {
public:
    PrintJob() : pages(new int[64]) { cout << "PrintJob acquired\n"; }
    ~PrintJob() { delete[] pages; cout << "PrintJob released\n"; }
private:
    int* pages;
};

int main() {
    Job* j = new PrintJob();
    delete j;
    return 0;
}
```

What prints, what leaks, which keyword fixes it, and which *combination* of properties makes this bug class uniquely nasty?

<details markdown="1">
<summary>Diagnosis</summary>

Prints "Job released" only: `delete` through `Job*` follows the pointer's type — `~PrintJob` never runs, so `pages`' 64 ints **leak** every time (and the base-part-only destroy is formally undefined behaviour). Fix: `virtual ~Job()` — then `~PrintJob` runs (releasing `pages`), then `~Job`, the Lesson 1 death order. The nasty combination: the bug is **silent** (no error), **intermittent** (only paths deleting through base pointers leak), and **located elsewhere** (the leak surfaces in the profiler, not at the delete site). Hence the course's no-exceptions rule: *polymorphic base ⇒ virtual destructor, every time.*
</details>

---

## D5 — The base class that forgot itself

```cpp
class Account {
protected:
    long long balance = 0;
public:
    bool withdraw(long long amount) {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;
        return true;
    }
};

class ChequeAccount : public Account {
public:
    void bounce() { balance = -5000; }        // "overdraft facility"
    void cheatFix() { balance = 0; }          // "reset for testing"
    long long getBalance() const { return balance; }
};
```

The `Account` invariant ("balance changes only through guarded withdrawal") is dead. Name the design mistake, its blast radius, and the two-step cure.

<details markdown="1">
<summary>Diagnosis</summary>

The mistake: **`protected` attributes as a habit** (gallery #3) — `balance` under `protected` made every subclass a co-owner of the invariant, and two lines of "convenience" killed it (`balance = -5000` bypasses every rule; the subclass doesn't even need malice). Blast radius: now *and future* — every class that ever inherits Account can rewrite the balance, and debugging the invariant means searching the whole family. Cure, two steps: (1) `private long long balance;` — the wall returns; (2) expose a **guarded hook**: `protected: void setBalanceHard(long long b) { if (b >= -overdraftLimit) balance = b; }` — the overdraft *facility* becomes a rule the base enforces, not a hole the subclass digs. Lesson: `protected` methods can carry rules; `protected` attributes carry hope.
</details>

---

## D6 — The overload family that vanished

```cpp
#include <iostream>
using namespace std;

class Logger {
public:
    void log(const string& msg) { cout << "MSG: " << msg << "\n"; }
    void log(int code) { cout << "CODE: " << code << "\n"; }
};

class FileLogger : public Logger {
public:
    void log(const string& msg) { cout << "[file] MSG: " << msg << "\n"; }  // refine one
};

int main() {
    FileLogger f;
    f.log("start");
    f.log(42);          // expected: CODE: 42
    return 0;
}
```

The `log(int)` worked before `FileLogger` existed. Why doesn't it now, and what one line restores it?

<details markdown="1">
<summary>Diagnosis</summary>

`FileLogger`'s `log(const string&)` **hides all base overloads** of `log` (Lesson 1 §3) — name lookup stops at the derived class once the name is found, so `f.log(42)` sees only the string overload; the `int` argument converts via `string`'s integer constructor, and it prints `MSG: 42` — the *wrong function*, silently. One-line fix: `using Logger::log;` in `FileLogger`'s public section — the base overloads rejoin the lookup, and both behaviours coexist (`CODE: 42` restored). Rule: adding any overload of a base's name in a derived class requires the `using` declaration unless hiding is the intent.
</details>

---

## D7 — The constructor that skipped a step

```cpp
#include <iostream>
#include <string>
using namespace std;

class Employee {
public:
    Employee(const string& name) : name(name) {}
    const string& getName() const { return name; }
private:
    string name;
};

class Manager : public Employee {
public:
    Manager(int reports) { this->reports = reports; }   // ← suspect
    int getReports() const { return reports; }
private:
    int reports = 0;
};

int main() {
    Manager m(5);
    cout << m.getName() << "\n";
    return 0;
}
```

This doesn't compile. What exactly is missing, what does the compiler say, and what is the fix — including the variant if `Employee` had *both* a default and a parameterized constructor?

<details markdown="1">
<summary>Diagnosis</summary>

`Manager`'s initializer list never mentions the base, so the compiler seeks `Employee`'s **default** constructor — which doesn't exist (a user constructor suppresses the implicit one). Error: *"no matching constructor for initialization of 'Employee'"*. Fix: `Manager(const string& name, int reports) : Employee(name), reports(reports) {}` — the base is constructed in the initializer list, Lesson 1's rule. Variant: with `Employee() = default;` present, the original *would* compile — `name` born empty — which is worse: a manager who exists nameless. The base-part-must-be-built rule doesn't shrink when a default appears; the design question "what must every Manager know at birth?" still has the answer *its name*.
</details>

---

## D8 — The virtual everything class

```cpp
class StringBox {
public:
    virtual size_t length() const { return s.size(); }          // virtual #1
    virtual bool empty() const { return s.empty(); }            // virtual #2
    virtual char at(size_t i) const { return s[i]; }            // virtual #3
    virtual void clear() { s.clear(); }                         // virtual #4
    virtual ~StringBox() = default;
protected:
    string s;
};

// Used exclusively as:  StringBox box; box.length(); box.at(3); ...
// No subclass exists. None is planned.
```

Nothing here is *wrong* — diagnose the design debt: what each `virtual` costs, what the `protected` member promises, and the shape of the honest version.

<details markdown="1">
<summary>Diagnosis</summary>

Debt, not bug: (1) each `virtual` is a promise that subclasses will vary the method — with zero subclasses, it's four unfulfilled promises (vtable overhead is trivial; the *design noise* is the cost — every reader hunts for the family that isn't coming); (2) `protected: string s` promises all future subclasses will maintain StringBox's invariants (D5's blast radius) for no benefit yet. Honest shape: a plain class — all `private`, all non-virtual, destructor unvirtual — until a second kind of box actually exists. The rule behind the drill: **virtual and protected are design decisions with recurring costs; make them when the variation arrives** (gallery #8). The counter-case to know: `Shape` earned its virtuals by having children on day one.
</details>

---

## D9 — The hierarchy that argued with a bool

```cpp
#include <iostream>
using namespace std;

class BaseEntity {
public:
    BaseEntity(const string& id) : id(id) {}
    virtual bool isValid() const { return !id.empty(); }
    virtual ~BaseEntity() = default;
protected:
    string id;
};

class Invoice : public BaseEntity {
public:
    Invoice(const string& id, long long amount) : BaseEntity(id), amount(amount) {}
    bool isValid() const override { return BaseEntity::isValid() && amount > 0; }  // ← the line
private:
    long long amount;
};

int main() {
    Invoice bad("", -5);
    cout << boolalpha << bad.isValid() << "\n";   // expected: false. prints: ?
    return 0;
}
```

This one actually works — the exercise is explaining **why the explicit `BaseEntity::isValid()` call is the load-bearing piece**. Remove it (mentally) and re-trace. Then name the mistake class when someone writes `isValid() const override { return isValid() && amount > 0; }`.

<details markdown="1">
<summary>Diagnosis</summary>

With the explicit qualification: base check (`id` non-empty? false) `&&` amount check → **false**, correct. Without the `BaseEntity::` qualification, `isValid()` inside `Invoice::isValid` resolves to... **itself** — unqualified name lookup finds the nearest declaration, which in `Invoice`'s scope is `Invoice::isValid`. That's infinite recursion: stack overflow at runtime, on any call — the compile passes, the tests pass for the *other* branch (amount ≤ 0 short-circuits before the recursion? no: `isValid() && amount > 0` calls isValid *first* — it dies on every call). Mistake class: **calling an override through its own name expecting the base version** — the base must be *qualified* (`BaseEntity::isValid()`) or reached via a different name. Compare S12's `describe()` calling virtual `area()`: there the unqualified call was *correct* (dispatch was the intent); here identity is the bug — same syntax, opposite intent, and the distinguishing question is "which function did I *mean*?"
</details>

---

## D10 — The audit: three bugs, one hierarchy

```cpp
class Shape {
public:
    double area() const { return 0; }              // line A
    void describe() const { cout << area() << "\n"; }
};

class Square : public Shape {
public:
    Square(double side) { this->side = side; }     // line B
    double area() const { return side * side; }
private:
    double side;
};

int main() {
    Square* s = new Square(4.0);
    Shape* p = s;
    p->describe();                                  // expected: 16
    vector<Shape> kept;
    kept.push_back(*s);                             // line C
    delete s;
    return 0;
}
```

Find all three defects before reading the list — classify each: dispatch bug, construction bug, or storage bug.

<details markdown="1">
<summary>Diagnosis</summary>

**Line A — dispatch bug:** `area` is non-virtual, so `p->describe()` prints **0** (the Shape window answers; Square's override hides). Fix: `virtual double area() const` in Shape, `override` in Square — and since Shape is now a polymorphic base, a `virtual ~Shape() = default;` is the rule-with-no-exceptions rider. **Line B — construction bug:** `this->side = side` works (D7's disambiguator) but skips the initializer list — style debt at best; the real danger it *suggests* is the D7 pattern (forgetting the base pass-through when the base gains a constructor). Fix: `Square(double side) : side(side) {}` — same name, initializer list, no shadow dance. **Line C — storage bug:** `vector<Shape>` + `push_back(*s)` **slices** the Square into a plain Shape (kept[0].area() would print 0); the `delete s` afterward is also a leak-in-waiting with no virtual destructor in force. Fix: store pointers (`vector<Shape*>` + explicit ownership, or `unique_ptr` next course) and never copy derived objects by base value. Verdict order: dispatch → construction → storage, same audit order as every pack.
</details>

---

## Fix-list recap

| Hunt | Bug class | Prevention rule |
| --- | --- | --- |
| D1 | hiding ≠ overriding | `virtual` + `override`, always |
| D2 | by-value storage slices | mixed families live behind pointers |
| D3 | typo-override ships silent | `override` makes the compiler the reviewer |
| D4 | non-virtual base destructor | polymorphic base ⇒ virtual destructor |
| D5 | protected attributes co-owned | guarded `protected` methods, not open data |
| D6 | overload family hidden | `using Base::name;` when adding overloads |
| D7 | base part never initialized | base construction lives in the initializer list |
| D8 | speculative virtual/protected | decide when the variation arrives |
| D9 | unqualified self-call in an override | qualify base calls; name the intent |
| D10 | three-for-one audit | dispatch → construction → storage |

## Where next

- [Design problems](design.md): ten is-a judgements on paper.
- [Labs](labs.md): five hierarchies, built honestly.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
