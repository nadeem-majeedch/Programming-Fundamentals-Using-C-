---
title: "Lesson 1 — Objects, Classes, and Encapsulation"
description: "Why OOP, objects vs classes, attributes and methods, public/private, the getter/setter discipline, and the first real class built from a struct you already own."
---

# Lesson 1 — Objects, Classes, and Encapsulation

> [← Module home](index.md) · [Lesson 2 — Constructors, destructors, lifetime →](lesson-2-constructors-lifetime.md)

## In this lesson you will learn

- **why OOP** — the two organizational problems it solves
- the difference between a **class** (the blueprint) and an **object** (the built thing)
- **attributes** and **methods** — data and behaviour traveling together
- `public` vs `private` — and **encapsulation** as a debugging guarantee, not a style tip
- the getter/setter discipline, in the version you already know from the Records module

---

## 1. Why OOP — the two problems you have already felt

**Problem 1: data and functions live apart.** In every project since the Functions module, you maintained a `struct` (or parallel arrays) *and* a set of functions that operate on it — `printStudent(const StudentRecord&)`, `isValidMark(int)`, `findByName(...)`. The pairing is enforced only by discipline: any function *anywhere* can read or write any field. When a bug corrupts a `mark` to −40, the search space is the whole program.

**Problem 2: nothing stops invalid data.** The Records module taught you validation — but a free function like `setMark(StudentRecord&, int)` must be *called* to work. Nothing stops a careless line elsewhere from doing `student.mark = -40;` directly.

OOP answers both with one move: **put the data and the functions inside one package, and let the package enforce its own rules.** The functions that belong to the data become *methods*; the data becomes *attributes* hidden behind them; the language itself now enforces what discipline used to. The bug search space shrinks from "the whole program" to "the class" — the Debugging module's modularity dividend, now with a wall the compiler polices.

> **The honest framing for this course:** OOP is not a new kind of computing. It is your existing toolbox — structs, functions, guard chains — rearranged so the compiler enforces the organization you were already doing by hand.

---

## 2. Class and object — blueprint and building

```text
        CLASS  =  the blueprint (written once)          OBJECTS  =  the buildings
   ┌───────────────────────────────┐              ┌─────────────┐  ┌─────────────┐
   │ class BankAccount {           │              │ acc1        │  │ acc2        │
   │   string owner;               │   build →    │ owner:"Sana"│  │ owner:"Omar"│
   │   long long balance = 0;      │              │ balance:500 │  │ balance:1200│
   │   void deposit(long long a);  │              └─────────────┘  └─────────────┘
   │ };                            │                   each object owns its OWN data
   └───────────────────────────────┘                   and shares the SAME methods
```

A **class** is a *type you define*: it names the attributes every instance will have and the methods every instance can perform. An **object** (instance) is one concrete realization — `acc1` and `acc2` each hold their own `owner` and `balance`, but `deposit` is written once. Exactly the struct/array relationship you know: `StudentRecord` was the blueprint; `roster[3]` was a built thing. A class is a struct that *also* carries its functions.

---

## 3. Attributes and methods — the first class, fully explained

```cpp
// bankaccount.cpp — Programming Fundamentals Using C++
// Unit 15 · Lesson 1 · The first class
// Compile: g++ -std=c++17 -Wall -Wextra bankaccount.cpp -o bankaccount

#include <iostream>
#include <string>
using namespace std;

class BankAccount {
public:                              // the interface: what the outside world may do
    void deposit(long long amount) {
        if (amount <= 0) return;     // the object defends itself
        balance += amount;
    }
    bool withdraw(long long amount) {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;
        return true;
    }
    long long getBalance() const { return balance; }
    string getOwner() const { return owner; }
    void setOwner(const string& name) {
        if (!name.empty()) owner = name;      // validation lives here now
    }

private:                             // the interior: only methods may touch this
    string owner;
    long long balance = 0;
};

int main() {
    BankAccount acc1;                       // an object exists
    acc1.setOwner("Sana");
    acc1.deposit(500);
    acc1.withdraw(120);
    cout << acc1.getOwner() << ": " << acc1.getBalance() << "\n";  // Sana: 380
    return 0;
}
```

**Explanation, line group by line group:**

- **Attributes** (`owner`, `balance`) are the data each object owns. The `= 0` default initializes every account's balance even before constructors (Lesson 2 formalizes this).
- **Methods** are functions declared inside the class — they run *on behalf of a specific object* (`acc1.deposit(500)` adjusts **acc1's** balance; `acc2` never hears about it). Inside a method body, the bare names `balance` and `owner` mean *this object's* fields.
- **`public:`** opens the interface — the list of things outsiders may call. **`private:`** closes the interior — from here to the end of the class (or the next label), only the class's own methods may touch the names.
- **The object defends itself.** `deposit` refuses non-positive amounts; `withdraw` refuses overdrafts *and* returns a `bool` so the caller learns the outcome; `setOwner` refuses empty names. The Records module's guard chains didn't disappear — they moved inside the front door, where they can no longer be bypassed.

### Test cases for the class (the Debugging module's families, applied)

| Case | Call | Expected |
| --- | --- | --- |
| normal deposit | `deposit(500)` then `getBalance()` | 500 |
| invalid deposit | `deposit(-50)` then `getBalance()` | unchanged (0) |
| valid withdrawal | deposit 500, `withdraw(120)` | true, balance 380 |
| overdraft attempt | deposit 100, `withdraw(500)` | **false**, balance still 100 |
| empty-name setter | `setOwner("")` then `getOwner()` | unchanged |

---

## 4. public/private and encapsulation — the wall that pays rent

**Encapsulation** is the combination: *attributes private, behaviour public, invariants enforced at the interface.* `mark` under `private` is not about secrecy — every user of your program could always type any value. It is about **who must obey the rules**: with the field private, the *only* path to it is through a method, so the rules on that path are mandatory, not optional.

The concrete payoffs, each one you have already paid for procedurally:

1. **Invariants become guaranteed.** "Balance is never negative" stops being a hope and becomes a structural fact — `balance` cannot change except through `deposit`/`withdraw`, which enforce it.
2. **Debugging narrows to the class.** If `balance` is wrong, Lesson 1 of the Debugging module's workflow now shrinks to: *which method wrote it?* Four methods, one wall.
3. **You may change the interior freely.** Rename `balance` to `balanceCents`, cache a computed value, switch the storage — no code outside the class can break, because no outside code ever touched the field. This is why the Files module's *format contract* idea and encapsulation are cousins: both let the inside change while the interface holds.

**The course's two naming rules** (Records module convention, now standard C++ practice): attribute names in `camelCase` starting lowercase (`balance`, `ownerName`); getters named `get...`, setters `set...`, predicates `is...`/`has...`. Consistency here is what makes an unfamiliar class readable.

### The getter/setter discipline — and when *not* to write them

- A **getter** returns the value of an attribute (usually `const` — Lesson 3). A **setter** validates and assigns. Write them *when the outside world genuinely needs that door* — not reflexively for every field.
- **Design smell, named honestly:** a class where every attribute has a plain getter and setter, and no method does anything the attributes couldn't say, is a `struct` with extra steps. The Records module's warning holds: *methods should carry behaviour* (`withdraw`, `isOverdrawn`, `applyMonthlyFee`), not just plumbing. The [design drills](design.md) grade this directly.
- **Derived data is never stored** — the mini-project's "derived `grade` is computed, never stored" rule becomes: provide `char grade() const` as a method; there is no setter because there is no storage.

---

## 5. `struct` vs `class` — the one-keyword truth

The only mechanical difference: in a `struct`, members are `public` by default; in a `class`, `private` by default. Everything else — methods, constructors, all of it — is identical. The convention this course follows: use `struct` for passive bundles of data (the Records module's world), `class` when there is an invariant to protect (everything in this module). When you refactor a Records-module struct into a class, the fields keep their names; you add the labels, the methods, and the constructors.

---

## Check yourself

- Why can `main` no longer execute `acc1.balance = -999;`? (the field is private; assignment outside the class is a compile error — the wall is the compiler's, not a convention)
- `acc1.deposit(500)` and `acc2.deposit(500)` run the *same* function. How does each know whose balance to change? (methods run on behalf of an object; the bare `balance` inside means that object's field — formalized as `this` in Lesson 2)
- Your `Account` exposes `getBalance()` but no `setBalance()`. Defend the omission. (an arbitrary setter would bypass every rule `deposit`/`withdraw` enforce; balance changes only through behaviour)

## Where next

- [Lesson 2 — Constructors, destructors, lifetime →](lesson-2-constructors-lifetime.md): birth, initialization, and death, handled by the class itself.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
