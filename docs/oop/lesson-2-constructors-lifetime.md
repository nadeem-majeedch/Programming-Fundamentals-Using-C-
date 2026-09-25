---
title: "Lesson 2 — Constructors, Destructors, and Object Lifetime"
description: "Default and parameterized constructors, member initializer lists, delegating constructors, destructors, the this pointer, and the object lifetime story."
---

# Lesson 2 — Constructors, Destructors, and Object Lifetime

> [← Module home](index.md) · [← Lesson 1 — Objects, classes, encapsulation](lesson-1-objects-classes.md) · [Lesson 3 — Design, const, composition →](lesson-3-design-composition.md)

## In this lesson you will learn

- how a **constructor** guarantees every object is born valid — and how to write the three kinds you need
- the **member initializer list** and why it beats assignment in the body
- **delegating constructors** — one setup story, many doors
- what a **destructor** is, when it runs, and why the Pointers module's cleanup rules automate here
- the **`this` pointer** — what the machine actually passes to every method
- the full **object lifetime** story: scope, storage, and the four birth/death timelines

---

## 1. The problem constructors solve

Lesson 1's `BankAccount` could still be born wrong: `BankAccount acc;` used in `main` before any `setOwner` call has an *empty* owner and a zero balance — usable, if defaults exist for everything. But a `Student` with no roll number, or a `Date` with no month, is a landmine waiting for the first method call. Any object that *can* exist in an invalid state *will*, eventually.

A **constructor** is a special method that runs automatically at the moment an object is created. Its job is one sentence: **make the object valid before anyone can touch it.** You cannot forget to call it; the compiler calls it. You cannot call it late; there is no "later."

```cpp
class BankAccount {
public:
    BankAccount() : owner("Unnamed"), balance(0) {}           // default constructor
    BankAccount(const string& name, long long openingBalance)
        : owner(name), balance(0) {                           // parameterized constructor
        if (openingBalance > 0) balance = openingBalance;     // rules enforced at birth
    }
    ...
private:
    string owner;
    long long balance;
};

BankAccount a;                        // default: Unnamed, 0
BankAccount b("Omar", 1000);          // parameterized: Omar, 1000
BankAccount c("Sana", -50);           // parameterized: Sana, 0 (rule applied at birth)
```

**Rules of the road:**

- A constructor's name **is the class name**, with **no return type** — not even `void`.
- **Overloading applies** (Functions module): several constructors may coexist as long as their parameter lists differ. The call picks the matching one, exactly like overloaded functions.
- If you declare **no constructors at all**, the compiler supplies one that does nothing (the "implicit default constructor") — which is why uninitialized structs were a hazard all course long. Declare *any* constructor and the implicit one disappears: if you also need a no-argument path, write it (or `BankAccount() = default;` and let the member defaults work).

---

## 2. The member initializer list — birth, not renovation

The part after the `)` and before the `{` — `: owner(name), balance(0)` — is the **member initializer list**. It *initializes* members directly; assignment in the body *first default-constructs, then overwrites*.

```cpp
// Preferred: initialize
BankAccount(const string& name) : owner(name), balance(0) {}

// Works, but renovates: members are built empty, then assigned
BankAccount(const string& name) { owner = name; balance = 0; }
```

For `int`s and `double`s the difference is invisible; for `string` and every class-type member it is real work saved, and for two cases it is **the law**: `const` members and reference members *must* be initialized in the list (assignment comes too late for them). The course habit: **always use the initializer list** — it's never wrong, it's often faster, and it's the professional signature.

Order fact worth knowing (and a favourite exam trap): members initialize **in declaration order**, not in the order the list happens to write them. Keep the list in declaration order and the trap cannot exist.

---

## 3. Delegating constructors — one setup story

When several constructors share logic, one may **delegate** to another using the initializer-list syntax with a class name:

```cpp
class BankAccount {
public:
    BankAccount() : BankAccount("Unnamed") {}                 // delegate
    BankAccount(const string& name) : BankAccount(name, 0) {} // delegate
    BankAccount(const string& name, long long opening)        // the one real setup
        : owner(name), balance(opening > 0 ? opening : 0) {}
    ...
};
```

The validation lives in exactly one place; every door into the class passes through it. This is the DRY rule (Debugging module) applied to birth — and the same one-authoritative-home logic the Records module used for derived data.

---

## 4. Destructors — the pairing, automated

A **destructor** — `~ClassName()`, no parameters, no return — runs automatically when an object dies. Its job: **release whatever the object acquired.**

```cpp
#include <iostream>

class SessionLog {
public:
    SessionLog(const string& path) : entries(new string[64]) {
        cout << "log opened for " << path << "\n";
    }
    ~SessionLog() {
        delete[] entries;                    // the Pointers module's rule, automated
        cout << "log closed\n";
    }
private:
    string* entries;
};

int main() {
    SessionLog log("session.txt");
    cout << "working...\n";
    return 0;
}
// output:
// log opened for session.txt
// working...
// log closed            ← destructor ran by itself, in death order
```

**When destructors run — the lifetime story, four timelines:**

| Object | Born | Dies |
| --- | --- | --- |
| Local variable | when execution reaches its declaration | at the end of its scope (closing brace) |
| Temporary | when the expression needs it | at the end of the full expression |
| Element of an array of objects | each in order | each, in reverse order |
| `new`-allocated object | at `new` | **only** at `delete` — the ownership rule |

You saw this order in the Pointers module's stack/heap tables; here it is with functions attached. **The payoff:** every cleanup rule the Pointers module made you enforce by hand — *whoever acquires, releases; owners clean up even when the user doesn't* (the Quiz Runner's safety net) — becomes a method you write once. The object carries its own funeral instructions.

> **Honest scope note:** a class that acquires raw memory *and* gets copied can double-free (two objects, one block). The course's rule is the practical one — at this level, classes own their resources and are passed by reference or `const&`; the copy problem (and its rule-of-three machinery) is a later-course topic, named here so you recognize the cliff when you meet it.

---

## 5. The `this` pointer — what every method secretly receives

When you call `acc1.deposit(500)`, the machine must know *which object's* `balance` to change. The answer: every non-static method receives a hidden parameter — **`this`** — a pointer to the object on whose behalf the method runs.

```cpp
bool BankAccount::withdraw(long long amount) {
    if (amount <= 0 || amount > this->balance) return false;
    this->balance -= amount;      // exactly what the bare 'balance' already meant
    return true;
}
```

`this->balance` and the bare `balance` are the same thing; the bare name is the polite form. `this` earns its keep in three situations:

1. **Disambiguation** — when a parameter shadows a member (`void setOwner(string owner)` — the course's naming rules say avoid this by renaming the parameter, but `this->owner = owner;` is the standard cure when you meet it in the wild).
2. **Method chaining** — `return *this;` hands the current object back so calls can chain (`acc.deposit(100).deposit(50);` — a design choice, not magic).
3. **Self-reference checks** — in methods that compare or combine objects, `if (this == &other)` detects an object operating on itself.

**The mental model to keep:** a method is *almost* an ordinary function with one extra invisible parameter — `BankAccount* this` — and the call syntax `object.method(args)` is sugar for passing that address. (That is, in fact, roughly how the compiler compiles it.) Nothing mysterious survives this framing.

---

## 6. A complete program — lifetime from birth to death

```cpp
// lifetime.cpp — Programming Fundamentals Using C++
// Unit 15 · Lesson 2 · Object lifetime, observed
// Compile: g++ -std=c++17 -Wall -Wextra lifetime.cpp -o lifetime

#include <iostream>
#include <string>
using namespace std;

class Tracer {
public:
    Tracer(const string& name) : name(name) { cout << "  born: " << name << "\n"; }
    ~Tracer() { cout << "  died: " << name << "\n"; }
private:
    string name;
};

int main() {
    cout << "main begins\n";
    Tracer a("a (main scope)");
    if (true) {
        Tracer b("b (inner scope)");
        cout << "  working in inner scope\n";
    }                                     // b dies HERE — inner scope ends
    cout << "back in main\n";
    return 0;
}                                         // a dies HERE — main's scope ends
```

**Output:**

```text
main begins
  born: a (main scope)
  born: b (inner scope)
  working in inner scope
  died: b (inner scope)
back in main
  died: a (main scope)
```

**Explanation:** objects die in the **reverse** order of their birth within nested scopes — b before a — and each dies *exactly* at its scope's closing brace. Run this program whenever lifetime doubts arise; it is the ground truth.

---

## Check yourself

- Why does `BankAccount c("Sana", -50);` end with balance 0 — and which design decision made that possible? (the parameterized constructor validates; the rule is enforced at birth, before any method can be called)
- What breaks if you write a class-type member as an assignment in the constructor body instead of the initializer list? (it is default-constructed first, then overwritten — wasted work; and `const`/reference members make it a compile error)
- In `acc1.withdraw(120)`, what is `this`? (a pointer to `acc1`; the hidden first parameter of every method)

## Where next

- [Lesson 3 — Design, const, composition →](lesson-3-design-composition.md): marking methods honest, composing objects, and `operator<<`.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
