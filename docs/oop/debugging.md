---
title: "OOP Debugging — 10 Seeded Hunts"
description: "Ten broken classes — encapsulation leaks, constructor mistakes, const violations, lifetime traps — with separated diagnoses."
---

# Debugging — 10 seeded hunts

> [← Module home](index.md) · Each snippet compiles (or nearly) but misbehaves. Predict the symptom, form a hypothesis, *then* read the separated diagnosis. Compile with `-Wall -Wextra` — several of these bugs announce themselves there.

---

## D1 — The account with a side door

```cpp
class BankAccount {
public:
    void deposit(long long a) { if (a > 0) balance += a; }
    long long getBalance() const { return balance; }
    long long balance = 0;        // ← the reviewer's eyebrow
private:
};

int main() {
    BankAccount acc;
    acc.deposit(500);
    acc.balance = 0;              // "reconciliation"
    cout << acc.getBalance() << "\n";
    return 0;
}
```

Why does the guard in `deposit` fail to protect anything, and what one-line move fixes the class?

<details markdown="1">
<summary>Diagnosis</summary>

`balance` sits **above the `private:` label** — members are public by default in a class until a label says otherwise, so the attribute is reachable from `main`. The assignment wipes the guarded balance; the invariant "balance changes only through deposit/withdraw" was never structural. Fix: move the attribute under `private:`. The meta-lesson: in a `class`, the *first* members are public unless you say otherwise — placement of the label *is* the design. (In a `struct` the default is public; that's the whole struct-vs-class difference.)
</details>

---

## D2 — The constructor that never runs

```cpp
class Point {
public:
    void Point(int x, int y) {      // ← suspect
        this->x = x; this->y = y;
    }
    int getX() const { return x; }
private:
    int x = 0, y = 0;
};

int main() {
    Point p(3, 4);
    cout << p.getX() << "\n";
    return 0;
}
```

The programmer expected `p` to be `(3, 4)`. The program doesn't even compile — why, and what exactly did `void` break?

<details markdown="1">
<summary>Diagnosis</summary>

Constructors have **no return type** — writing `void` makes `Point(int, int)` an ordinary *method* named after the class, and `Point p(3, 4);` then finds no matching constructor. The compiler error is a friend here: it names the missing constructor. Remove `void`. (If the class had been used via `p.Point(3,4);` it would compile — and the object would spend its first moments uninitialized-by-design — the worst version of the bug.) Rule: a function named exactly like its class, with any return type, is not a constructor.
</details>

---

## D3 — The getter that writes

```cpp
class Counter {
public:
    int getCount() {                // ← missing const, but there's more
        accesses++;                 // "instrumentation"
        return count;
    }
    void increment() { count++; }
private:
    int count = 0, accesses = 0;
};

int main() {
    const Counter c;
    c.increment();                  // ← fails first
    return 0;
}
```

Two separate defects here — one is the missing `const`, one is a design decision pretending to be instrumentation. Find both.

<details markdown="1">
<summary>Diagnosis</summary>

Defect 1: `c` is `const`, so `increment()` — a non-const method — cannot be called through it (compile error, correctly). Defect 2: `getCount()` **mutates** (`accesses++`), so it *cannot* be const — and because it isn't, even a read like `c.getCount()` through a const object is refused. The design lie: a "getter" with a side effect is a command wearing a query's name. Honest fixes: drop the counter (the Debugging module's YAGNI), or split — a const `getCount()` and a separate non-const `int getAndLogCount()`. The lesson: the const system exposes intent mismatches; when it complains, redesign rather than strip const.
</details>

---

## D4 — The destructor that fires too late to matter

```cpp
#include <iostream>
using namespace std;

class Leak {
public:
    Leak() { data = new int[100]; cout << "acquired\n"; }
    ~Leak() { delete[] data; cout << "released\n"; }
private:
    int* data;
};

void process(Leak copyMe) {         // ← suspect signature
    cout << "processing\n";
}

int main() {
    Leak obj;
    process(obj);
    cout << "done\n";
    return 0;
}
```

Run it. The output shows two "acquired"? No — one "acquired", but **two "released"**. Explain every line, then name the failure and the course-level rule.

<details markdown="1">
<summary>Diagnosis</summary>

`process` takes `Leak` **by value** — the parameter is a *copy* of `obj`, and copying copies the **pointer**: two objects, one heap block (Lesson 2's scope note, live). The copy's destructor runs at the end of `process` ("released" #1) and frees the block; `obj`'s destructor runs at `main`'s end ("released" #2) and frees the **same block again** — undefined behaviour. (Only one "acquired" prints because the copy is pointer-deep, not resource-deep.) Course-level rule: classes that own raw resources pass by reference/`const&` — and the full machinery (copy constructor, rule of three) is the next course's opening story, now with a felt reason to care.
</details>

---

## D5 — The setter that trusts its parameter name

```cpp
class Student {
public:
    void setName(string name) {
        name = name;                // ← suspect
    }
    string getName() const { return name; }
private:
    string name = "Unnamed";
};

int main() {
    Student s;
    s.setName("Aisha");
    cout << s.getName() << "\n";    // prints: Unnamed
    return 0;
}
```

Why does `setName("Aisha")` leave the name untouched, and what are the two cures — plus the course's preferred one?

<details markdown="1">
<summary>Diagnosis</summary>

The parameter `name` **shadows** the member `name`, so `name = name;` assigns the parameter to itself; the member never hears about "Aisha". `-Wshadow` (under `-Wextra`) warns about the shadowing; some compilers warn about self-assignment. Cures: (1) rename the parameter — `void setName(const string& newName)` — the course's preference, because names are documentation and shadowing means the naming failed; (2) `this->name = name;` — correct but routine use of `this->` as a disambiguator usually signals the rename was the real fix. (While you're in there: `const string&` for the parameter — S11's cost rule.)
</details>

---

## D6 — The validator on the wrong door

```cpp
class Exam {
public:
    Exam(int totalMarks) { total = totalMarks; }
    void setTotal(int t) { if (t > 0 && t <= 500) total = t; }
    int getTotal() const { return total; }
private:
    int total = 0;                  // default 0 — "safe"
};

int main() {
    Exam e(-100);                   // birth with nonsense
    e.setTotal(120);
    cout << e.getTotal() << "\n";   // prints 120 — so where's the bug?
    return 0;
}
```

The setter validates; the output looks right. State precisely when the class's invariant "0 < total ≤ 500" is broken — and why the constructor is the guilty door.

<details markdown="1">
<summary>Diagnosis</summary>

The invariant is broken **between construction and the first setter call**: `Exam e(-100)` exists with `total = -100`, because the constructor — the *other* door — validates nothing. Between those two lines, `getTotal()` returns −100 to any caller; the setter's guard is a moat around a gate that was left open at birth. Fix: validate in the constructor too (`if (t > 0 && t <= 500) total = t; else total = 0;`) — or better, delegate both doors to one guard (Lesson 2's delegating constructors), so the invariant holds at every moment of the object's life, not just after the first setter. Meta-lesson: *every* path that writes an attribute must enforce the invariant — the Debugging module's boundary rule, pointed at constructors.
</details>

---

## D7 — The composition that forgot to initialize

```cpp
class Engine {
public:
    Engine(int hp) : horsepower(hp) {}
    int getHorsepower() const { return horsepower; }
private:
    int horsepower;
};

class Car {
public:
    Car(const string& m) : model(m) {}     // ← suspect
    void honk() const { cout << model << " says beep\n"; }
    Engine engine;                          // public "for convenience"
private:
    string model;
};

int main() {
    Car car("Civic");
    cout << car.engine.getHorsepower() << "\n";
    return 0;
}
```

Two design failures: one won't compile, one is a wall missing. Find both, then fix.

<details markdown="1">
<summary>Diagnosis</summary>

Failure 1 (compile error): `Car`'s initializer list never initializes `engine`, and `Engine` has **no default constructor** — the compiler cannot build a `Car` because the member can't be born. Fix: `Car(const string& m, int hp) : model(m), engine(hp) {}` — the contained object is constructed in the outer object's initializer list (Lesson 3's composition mechanics). Failure 2 (design): `engine` is **public** — the has-a member is exposed, so any code can (attempt) engine surgery outside the class, and the Car's invariants about its own engine are unenforceable. Fix: `private:` the member, expose behaviour (`getHorsepower() const` relay) if the interface genuinely needs it. The lesson: composition members are interior — they are born by the constructor and hidden by `private:`, exactly like flat attributes.
</details>

---

## D8 — The derived data that drifted

```cpp
class Student {
public:
    void setMark(int quiz, int m) {
        if (quiz >= 0 && quiz < 3 && m >= 0 && m <= 100) marks[quiz] = m;
        average = (marks[0] + marks[1] + marks[2]) / 3;   // ← two bugs live here
    }
    double getAverage() const { return average; }
private:
    int marks[3] = {-1, -1, -1};
    double average = 0;
};

int main() {
    Student s;
    s.setMark(0, 80);
    cout << s.getAverage() << "\n";   // expected 80, got -0.33... 
    return 0;
}
```

Why does the average go *negative*, and what does the fix (the Records module's rule) delete from the class entirely?

<details markdown="1">
<summary>Diagnosis</summary>

`average` is recomputed over **all three slots**, including the two still holding the −1 sentinel: (80 + −1 + −1)/3 with **integer division** = 26, then stored as 26.0 — and before *any* mark is set, (−1−1−1)/3 = −1. The deeper bug is architectural: `average` is **derived data**, and storing it guarantees drift (the Records module's "derived Grade never stored", the Files module's same rule). Fix: delete the `average` attribute entirely; replace with `double average() const` that sums only entered marks and guards the empty case (E6's solution). The class then cannot drift — there is nothing to drift. Meta-lesson: a stored copy of something computable is a second fact that must be kept true forever; compute instead.
</details>

---

## D9 — The method that broke the chain

```cpp
class Builder {
public:
    Builder& addPart(const string& p) { parts.push_back(p); return *this; }
    Builder finish() {                 // ← suspect return type
        cout << "finished with " << parts.size() << " parts\n";
        return *this;                  // copies *this* — then the copy dies...
    }
private:
    vector<string> parts;
};

int main() {
    Builder b;
    b.addPart("wheel").addPart("engine").finish().addPart("spoiler");
    return 0;
}
```

What's wrong with `finish()`'s contract — and what did the trailing `.addPart("spoiler")` actually append to?

<details markdown="1">
<summary>Diagnosis</summary>

`finish()` returns `Builder` **by value** — a *copy* of the object. The trailing `.addPart("spoiler")` therefore appends to the **temporary copy**, which is destroyed at the end of the statement: the spoiler vanishes; `b` keeps two parts. (This is E17/S17's value-vs-reference return, weaponized by chaining.) Fix by design, not just signature: `finish()` is a *terminal* action — it should return `void` (or the product it finishes), and the chain should end there. The rule: `return *this;` is only meaningful through a **reference** return; and any method whose name says "this is the end" shouldn't invite another `.` after it.
</details>

---

## D10 — The audit: three bugs, one class

```cpp
class LibraryBook {
public:
    LibraryBook(string t) { title = t; }          // line A
    bool borrow() {
        if (status == Borrowed) return false;
        status = Borrowed;
        return true;
    }
    bool giveBack() {
        status = Available;                        // line B
        return true;
    }
    string title;                                  // line C
private:
    enum Status { Available, Borrowed };
    Status status = Available;
};
```

Find all three defects before reading the list — classify each as compile bug, invariant hole, or design smell.

<details markdown="1">
<summary>Diagnosis</summary>

**Line C — invariant hole:** `title` is public (above no `private:` label... it *is* above it — placed before the label), so the title can be rewritten mid-loan; an attribute with no reason to change after construction should be set once by the constructor and hidden. **Line B — invariant hole:** `giveBack()` doesn't check that the book *is* borrowed — "returning" an Available book reports success (compare S26's guarded transitions; the one-way doors must check the current room before opening). **Line A — design smell + inefficiency:** the constructor takes `string` by value and assigns (copy then move at best), instead of `const string& t` with an initializer list (`: title(t)`) — Lesson 2's initializer rule plus S11's cost rule; it also fails to state any validation the title might need. Verdict order (Debugging module): compile issues → invariant holes → hygiene.
</details>

---

## Fix-list recap

| Hunt | Bug class | Prevention rule |
| --- | --- | --- |
| D1 | label placement leak | attribute placement *is* the design |
| D2 | constructor with return type | constructors have no return type |
| D3 | query with side effects | getters are const and pure |
| D4 | by-value copy of a resource owner | resource owners pass by reference |
| D5 | parameter shadows member | rename before reaching for `this->` |
| D6 | unvalidated constructor door | every write path validates |
| D7 | uninitialized composed member | has-a members are born in the initializer list |
| D8 | stored derived data | compute, never store |
| D9 | chain broken by value return | `*this` needs a reference return |
| D10 | three-for-one audit | audit: compile → invariants → hygiene |

## Where next

- [Challenges](challenges.md): ten design-and-build problems.
- [Labs](labs.md): seven classes, built properly.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
