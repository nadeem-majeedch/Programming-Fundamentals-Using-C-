---
title: "Lesson 3 — Class Design, const, and Composition"
description: "const member functions, the six-step design method, composition (has-a) and basic class relationships, operator<<, vectors of objects, and the honest inheritance preview."
---

# Lesson 3 — Class Design, `const`, and Composition

> [← Module home](index.md) · [← Lesson 2 — Constructors, destructors, lifetime](lesson-2-constructors-lifetime.md)

## In this lesson you will learn

- **const member functions** — the promise that a method only reads
- a **six-step design method** for turning requirements into a class
- **composition (has-a)** — objects built from objects
- the basic **class relationships** and how to tell them apart
- `operator<<` — teaching `cout` to print your classes
- **vectors of objects** — the collection idiom this module has been driving toward
- the honest one-paragraph **inheritance preview**

---

## 1. const member functions — marking the readers

```cpp
class BankAccount {
public:
    long long getBalance() const { return balance; }     // promise: no mutation
    bool isOverdrawn() const { return balance < 0; }
    void deposit(long long amount) { balance += amount; } // mutates: no const
private:
    long long balance = 0;
};
```

Writing `const` after a method's parameter list is a **contract made to every caller**: *this method will not modify the object.* Inside the method, `this` becomes a pointer-to-const, and the compiler enforces the promise — an accidental assignment is a compile error, not a 2 a.m. bug hunt.

The payoffs compound:

- **Readers can be called through const references.** Lesson 1 promised big read-only parameters travel as `const&` — and `const BankAccount& acc` may only call `const` methods. A missing `const` on a getter strands every caller who follows the `const&` convention.
- **Intent becomes visible.** The interface separates into *queries* (const) and *commands* (non-const) — the same split the Functions module taught as "machines vs actions," now marked in the code where the compiler checks it.

**The rule for this course:** mark every method `const` that doesn't mutate. When the compiler complains, you will have *found* a mutation you forgot — the rule pays for itself the first week. (The escape hatch for rare caching cases, `mutable`, exists; you don't need it here, and this course never reaches for it.)

---

<a name="2-the-design-method--six-steps-from-requirements-to-class"></a>
## 2. The design method — six steps from requirements to class

Class design is a *skill*, practiced in the [design drills](design.md). The method to practice:

1. **Nouns → candidate classes/attributes.** "A library member borrows books up to a limit" — Member, Book, (limit is an attribute, not a class).
2. **Verbs → candidate methods.** *borrows*, *returns* — methods on whichever class owns the bookkeeping. Verbs with no data to act on are free functions, not methods.
3. **Write the invariants as sentences.** "A member never holds more than 3 books." "A book is borrowed by at most one member at a time." These sentences become the guards in your methods — and the setters' validation.
4. **Choose the interface.** Which methods are public? What does each return — `void`, `bool` (did it work?), or data? The Records module's door logic, now per-class.
5. **Choose the birth.** What must every object know at construction? That set of parameters *is* your parameterized constructor; defaults define the default constructor.
6. **Tabulate the tests.** The Debugging module's three families — normal, boundary (the limit exactly: 3 books ok, 4th refused), invalid — per method.

**Worked in brief — `LibraryMember`:** attributes `name`, `MemberCard card` (composition, §4), `vector<string> borrowedTitles`; methods `borrow(const Book&)` (guard: under limit, book available), `giveBack(const string& title)` (guard: actually held), `hasBook(title) const`, `borrowedCount() const`; invariant "≤ 3 borrowed" enforced inside `borrow`; constructor requires a valid name and card; tests: borrow to the limit, one over, return a non-held title, double-return. Every piece here is something you have written before — the design step is *assembling* it under one roof.

---

## 3. Composition — objects built from objects

**Composition (has-a)** means one object contains another as an attribute — the same way a struct contained another struct in the Records module, now with constructors and invariants attached.

```cpp
class Date {
public:
    Date(int y, int m, int d) : year(y), month(m), day(d) {}
    int getYear() const { return year; }
    ...
private:
    int year, month, day;
};

class Employee {
public:
    Employee(const string& n, int y, int m, int d)
        : name(n), hired(y, m, d) {}          // the member is CONSTRUCTED here
    const Date& getHireDate() const { return hired; }
private:
    string name;
    Date hired;                               // Employee HAS-A Date
};
```

**The mechanics that matter:** a contained object is constructed by the *outer* object's initializer list (`hired(y, m, d)`) and destroyed automatically with the outer object — lifetime is nested, no manual work, ever. If `Date` guards its own validity (month 1–12), then every `Employee` inherits that guarantee through composition — **invariants compose**. That is the quiet superpower of this whole module: walls made of walls.

### The basic relationships — a field guide

| Relationship | Read as | Signature in code | Course example |
| --- | --- | --- | --- |
| **Composition** | has-a, owns, dies with | attribute, by value | `Employee` has-a `Date` |
| **Aggregation** | has-a, but independent lifetime | attribute by pointer/reference, or by index into an external collection | `Roster` has-a `Student` that could outlive the roster |
| **Association** | uses, knows | parameter or reference, no ownership | `Library` *tracks* `Book`s stored elsewhere |
| **Inheritance** | is-a | *(not in this course — see the preview below)* | — |

The only judgement that matters at this level: **who owns the lifetime?** If the inner object's life is exactly the outer's, compose by value and let the machine do the work. If not, hold a reference or an index — and name the ownership decision in a comment, exactly as the Pointers module taught.

---

## 4. `operator<<` — teaching cout about your classes

`cout << acc;` doesn't work until you define what `<<` means for your class:

```cpp
#include <iostream>
#include <string>
using namespace std;

class BankAccount { ... };   // as in Lessons 1–2, with getOwner/getBalance

ostream& operator<<(ostream& out, const BankAccount& acc) {
    out << acc.getOwner() << " #" << acc.getBalance();
    return out;              // MUST return the stream — chaining depends on it
}

int main() {
    BankAccount acc("Sana", 380);
    cout << "Account: " << acc << "\n";      // Account: Sana #380
    return 0;
}
```

**Explanation of the signature, piece by piece:** the first parameter is the stream (left of `<<`), the second is your object — taken by **`const&`**, the convention this course has drilled since the Functions module. Returning `ostream&` is what makes chaining work: `cout << acc << "\n"` is evaluated left-to-right as `(cout << acc) << "\n"`, and the inner result must be the stream. The function uses *getters* rather than befriending the class — printing via the public interface keeps the wall intact. (Inside this function, `<<` means the built-in stream operators; no recursion.)

---

## 5. Vectors of objects — the collection idiom

Everything converges here: the collection (Arrays module), the record (Records module), the class (Lessons 1–2):

```cpp
#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Student {
public:
    Student(const string& n, int r) : name(n), rollNo(r) {}
    const string& getName() const { return name; }
    int getRollNo() const { return rollNo; }
    void setMark(int quiz, int m) {
        if (quiz < 0 || quiz > 2 || m < 0 || m > 100) return;   // guards inside
        marks[quiz] = m;
    }
    double average() const;                 // derived — computed, never stored
private:
    string name;
    int rollNo;
    int marks[3] = {-1, -1, -1};            // -1 = not yet entered
};

double Student::average() const {
    int total = 0, count = 0;
    for (int m : marks)
        if (m >= 0) { total += m; count++; }
    return count == 0 ? 0.0 : static_cast<double>(total) / count;
}

int main() {
    vector<Student> roster;                 // the vector manages the objects
    roster.push_back(Student("Aisha", 101));
    roster.push_back(Student("Omar", 102));
    roster[0].setMark(0, 85);
    roster[0].setMark(1, 91);

    for (const Student& s : roster)         // const& : read-only, no copying
        cout << s.getRollNo() << "  " << s.getName() << "  avg "
             << s.average() << "\n";
    return 0;
}
```

**The three idiom notes:** (1) `push_back(Student(...))` constructs the object and the vector *copies it into itself* — fine here, and the reason classes that own raw resources get careful later (the Lesson 2 scope note). (2) The range-for loop uses **`const&`** — the collections lesson's no-copy rule applied to class type. (3) `average()` is a const method over an embedded array — Records module's derived-data rule, now under a `const` promise. This is exactly the shape of the [mini-project](miniproject.md)'s `Roster`.

---

## 6. The inheritance preview — one honest paragraph

Sometimes two classes share a core and differ at the edges — `SavingsAccount` and `CurrentAccount` both *are* `BankAccount`s plus extra rules. **Inheritance** lets one class extend another, inheriting its interface and data; **polymorphism** lets a collection of mixed accounts respond to the same method call each in its own way. It is the famous face of OOP — and deliberately **not in this module**. The reason is the same one the syllabus has repeated all along: IS-A decisions made before HAS-A and encapsulation are instinctive produce the tangle every later course spends weeks untangling. Master composition and design here; meet inheritance in the [Inheritance & Polymorphism module](../inheritance/index.md) — next door, with foundations under you. Every exercise in this module is solvable — and best solved — without it.

---

## Check yourself

- Why must `average()` be `const` for the range-for in §5 to compile? (the loop variable is `const Student&`; only const methods may be called through it)
- `Roster` holds `vector<Student>` — which relationship row is that, and who dies when the roster dies? (aggregation-by-value leaning composition; every `Student` in the vector dies with the roster — vector owns its elements)
- Your `print()` method mutates a "last printed" timestamp. Honest marking? (it cannot be `const` — the compiler will say so the moment a `const&` caller appears; then redesign rather than reach for `mutable`)

## Where next

- [Exercises](exercises.md): 26 drills, from first classes to composed systems.
- [Class-design drills](design.md): the six-step method, exercised.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
