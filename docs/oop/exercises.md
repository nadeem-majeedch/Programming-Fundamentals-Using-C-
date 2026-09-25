---
title: "OOP Exercises — 26 Drills in Three Parts"
description: "Part A first classes and encapsulation, Part B constructors/lifetime/this, Part C design/composition/collections — each with a separated solution."
---

# Exercises — 26 drills, three parts

> [← Module home](index.md) · Attempt before opening solutions — they are separated below their parts. For ★★ items, write real code and compile with `-Wall -Wextra`; the compiler is the first reviewer.

## Part A — First classes and encapsulation (E1–E9)

- **E1 ★** Write a `Counter` class: one `private` attribute `int count = 0;`, methods `increment()`, `reset()`, and `getCount() const`. Write a test `main` covering all three methods.
- **E2 ★** Add to `Counter` a `decrement()` that refuses to go below zero. Which Records-module guard pattern did you reuse?
- **E3 ★** Write a `Temperature` class with a `private` `double celsius`, a getter, and a setter that refuses values below −273.15 (absolute zero). Explain in one comment *why* the guard belongs in the class and not in `main`.
- **E4 ★★** Write a `Rectangle` class: `private` width/height, constructor, `area() const`, `perimeter() const`, and a setter that refuses non-positive dimensions. Prove with test cases that no `Rectangle` can exist with negative width.
- **E5 ★★** Write a `Dice` class with a `roll()` method returning 1–6 (use `rand()`) and a `getFace() const`. Which attribute must exist, and why is there no setter for it?
- **E6 ★★** Convert the Records module's `StudentRecord` (name, rollNo, three marks) into a class: private attributes, constructor, getters, `setMark(int quiz, int m)` with the 0–100 guard, and `average() const` (derived — computed, never stored). Tabulate the test cases.
- **E7 ★★** A classmate's `Circle` class exposes `double radius;` as public and computes area in `main`. Diagnose two problems, then fix the class so the invariant "radius > 0" is guaranteed.
- **E8 ★★** Write `class Stopwatch` with `start()`, `stop()`, `elapsedSeconds() const` (use `clock()`), guarding against `stop()` before `start()`. Which two methods mutate, and which two must be `const`?
- **E9 ★★★** Write `class Password` whose `set(const string& candidate)` accepts only strings of length ≥ 8 containing at least one digit. Provide `bool ok() const`. Then answer: why is there no `get()` method at all?

### Solutions A

**S1.** `class Counter { public: void increment() { count++; } void reset() { count = 0; } int getCount() const { return count; } private: int count = 0; };` — the `= 0` default means even the implicit constructor leaves it valid; `getCount` is const because it only reads.

**S2.** `void decrement() { if (count > 0) count--; }` — the floor guard is a boundary rule (count = 0 is the edge), exactly the Records module's guard chain minus the return-early shape; returning `bool` would also be fine if callers need to know.

**S3.** `void set(double c) { if (c >= -273.15) celsius = c; }` — the guard lives in the class because the class is the *only* path to the attribute: with `celsius` private, a bypassing `main` line is a compile error, so the invariant "celsius ≥ absolute zero" is structural, not hopeful. In `main` it would be one more rule every caller must remember.

**S4.** `class Rectangle { public: Rectangle(double w, double h) { setWidth(w); setHeight(h); } void setWidth(double w) { if (w > 0) width = w; } void setHeight(double h) { if (h > 0) height = h; } double area() const { return width * height; } double perimeter() const { return 2 * (width + height); } private: double width = 1, height = 1; };` — the constructor *delegates its guarding* to the setters (call them in the body); negative width is impossible because the only two paths (constructor, setter) both pass the guard. Tests: `Rectangle(-3, 4)` → width stays 1; `setWidth(0)` → no change; `area()` on defaults → 1.

**S5.** `int face = 1;` must exist (the state), and `roll()` assigns it `rand() % 6 + 1`. No setter: the face is *produced by the die's behaviour*, not chosen by callers — a setter would let outsiders "roll" a six at will, breaking the one thing a die means. (Seeding with `srand` stays in `main` — the class shouldn't re-seed per object.)

**S6.** Interface: `StudentRecord(const string& n, int roll)`, `getName/ getRollNo const`, `setMark(int quiz, int m)` guarding `quiz ∈ {0,1,2}` and `m ∈ [0,100]`, `average() const` over entered marks (−1 sentinel = not entered; count them, don't average sentinels). Tests: valid set → reflected; `setMark(2, 101)` → unchanged; `setMark(3, 50)` → unchanged; `average()` with no marks → 0.0 (division guarded); average with two marks → mean of the two, not divided by 3. The derived-data rule from the mini-project carries over: `grade` would likewise be a const method, never a stored attribute.

**S7.** Problems: (1) public attribute — any line anywhere can set `radius = -2`, so the invariant is unenforced and the debugging search space is the whole program; (2) area logic lives outside the class — behaviour that belongs to the object's data was left in `main`, so every caller reimplements it (DRY violation). Fix: private radius, `setRadius` with `> 0` guard (or constructor-time guard), `area() const` and `circumference() const` as members.

**S8.** `clock_t started = 0; bool running = false;` plus methods: `start()` (mutates; also guards re-start), `stop()` (mutates; refuses if not running), `elapsedSeconds() const` (reads), `isRunning() const`. The guard that matters: `stop()` before `start()` — refused via `running` flag, so `started = 0` never masquerades as an elapsed time. Two const methods: the readers.

**S9.** `bool set(const string& c) { bool hasDigit = false; if (c.length() < 8) return false; for (char ch : c) if (isdigit((unsigned char)ch)) hasDigit = true; if (!hasDigit) return false; value = c; return true; }` and `bool ok() const { return !value.empty(); }`. No getter: the *whole point* of the class is that the cleartext password is not handed out — it is stored for verification, not for reading. Encapsulation hiding something on purpose is the concept with teeth; a `get()` would undo it. (This is also the honest answer to "getters for every attribute": no.)

## Part B — Constructors, lifetime, `this` (E10–E18)

- **E10 ★** Give `Counter` from E1 a parameterized constructor `Counter(int start)` that refuses negative starts. Keep the zero-argument path working. Which two constructors now exist, and which is the *default* constructor?
- **E11 ★** Write a `Book` class with constructor taking title, author, year; getters for all three. Explain why every parameter is `const string&`.
- **E12 ★★** Rewrite E11's constructor using a **member initializer list**. Then break it deliberately: reorder the list so it doesn't match declaration order, and note the compiler warning you get (or don't). What is the honest lesson?
- **E13 ★★** Write a `Timer` class with a **destructor** that prints "timer released". Create two `Timer` objects in an inner scope and one in the outer; predict the destruction order in writing before running; then run and compare.
- **E14 ★★** Add to `BankAccount` (Lessons 1–2) a delegating constructor so that `BankAccount("Sana")` creates an account with balance 0 through the two-parameter constructor. Verify that validation still runs for `BankAccount("Sana", -99)`.
- **E15 ★★** Write `class Point` with `int x, y;`, a constructor, `distanceFrom(const Point& other) const` (use `<cmath>` `sqrt`), and a `moveBy(int dx, int dy)` that refuses to move x or y outside `[0, 100]`. Which method needs `cmath`, and which is const?
- **E16 ★★** In `setOwner(string owner) { owner = owner; }`, what actually happens, what does the compiler warn, and what are the two cures? Then state the course's preferred cure and why.
- **E17 ★★★** Write `class ChainedCounter` whose `increment()` returns `*this` so that `c.increment().increment().increment();` works (reference return). What is the return type, and why not `Counter` by value?
- **E18 ★★★** A `SessionLog` (Lesson 2) holds `string* entries;` allocated in its constructor with `new string[64]`. Write its destructor. Then answer: what happens if a `SessionLog` object is copied by value (e.g. passed by value to a function) — name the two objects and the one heap block, and say why this course's rule is "pass logs by reference."

### Solutions B

**S10.** `Counter() = default;` plus `Counter(int start) { if (start > 0) count = start; }` — with the member default `int count = 0;` in place, `Counter() = default;` leaves count 0. Both constructors exist; **`Counter()` is the default constructor** (callable with no arguments); `Counter(int)` is a second overload. Testing: `Counter c1;` → 0; `Counter c2(-5);` → 0 (guard); `Counter c3(7);` → 7.

**S11.** `Book(const string& t, const string& a, int y) : title(t), author(a), year(y) {}` — every `string` parameter is `const&` to avoid copying each argument (the Functions module's cost rule), while `const` promises not to modify; `int` would pass by value happily (cheap, and a copy is the point).

**S12.** `Book(const string& t, const string& a, int y) : title(t), author(a), year(y) {}` with members declared `title, author, year` — the list matches declaration order. Reordering the *list* doesn't reorder the *initialization* (members initialize in declaration order); with `-Wall` g++ warns `-Wreorder` only when the mismatch is detectable. The honest lesson: the compiler's warning is a service, not a correction — the *order* is declaration order regardless, so keep the list visually aligned with the declarations and the trap cannot exist.

**S13.** `class Timer { public: Timer(const string& n) : name(n) { cout << "born " << name << "\n"; } ~Timer() { cout << "released " << name << "\n"; } private: string name; };` — with `Timer outer("outer");` then `{ Timer t1("t1"), t2("t2"); ... }` inside `main`, destruction is **reverse of construction within each scope**: t2, t1 at the inner closing brace; outer at `main`'s end. The prediction must be written before running — that's the exercise.

**S14.** `BankAccount() : BankAccount("Unnamed") {} BankAccount(const string& name) : BankAccount(name, 0) {} BankAccount(const string& name, long long opening) : owner(name), balance(opening > 0 ? opening : 0) {}` — `BankAccount("Sana", -99)` routes through the real constructor's guard → balance 0. Verification test: three constructions, three `getBalance()` reads (0, 0, expected opening where positive).

**S15.** `double distanceFrom(const Point& o) const { return sqrt(pow(x - o.x, 2) + pow(y - o.y, 2)); }` — needs `<cmath>`, and is `const` (it reads both points, mutates nothing — including *other*, which is itself `const&`). `moveBy` mutates, so it is not const, and its guards keep both coordinates in `[0, 100]`. Note the parameter is also `const&` even for a small object — consistency with the convention.

**S16.** The statement assigns the **parameter to itself** — the member is never touched, the setter silently does nothing. The compiler warns ("-Wself-assign-overloaded" on some compilers; at minimum the shadowing warning `-Wshadow` under `-Wextra` flags the parameter hiding the member). Cures: rename the parameter (`void setOwner(const string& name) { owner = name; }`) or write `this->owner = owner;`. Course-preferred: **rename** — the name is documentation, and `this->` as a routine disambiguator suggests the naming was wrong.

**S17.** `ChainedCounter& increment() { count++; return *this; }` — the return type is a **reference**: returning `Counter` by value would return a *copy*, and the chained calls would increment the copy — each a separate temporary — leaving the original moved once at best. `*this` is the current object itself; the reference return keeps the chain on one object. (One sentence: value return = hand back a photo; reference return = hand back the object.)

**S18.** `~SessionLog() { delete[] entries; }` — the matcher for `new string[64]`. If a `SessionLog` is passed **by value**, the parameter is a *copy* whose `entries` pointer holds **the same address**: both objects now believe they own one block; when both die, `delete[]` runs **twice** on it — undefined behaviour, typically a crash or heap corruption. The course's rule follows directly: objects owning raw resources pass by reference (or `const&` when read-only). The full machinery for making copies safe (copy constructor/assignment, the rule of three) is named in Lesson 2's scope note and left for the next course.

## Part C — Design, composition, collections (E19–E26)

- **E19 ★** Write `class Date` with a constructor validating `month ∈ [1,12]` and `day ∈ [1, 31]` (crude: per-month upper bounds not required yet), getters, and `toString() const` returning `"2026-09-23"` style. Which method is const, and what does the validation guarantee about every `Date` that exists?
- **E20 ★★** Compose: write `class Employee` **has-a** `Date` (hiring date) plus name and salary, with `const Date& getHireDate() const`. Construct an `Employee` and print hire year through the getter only.
- **E21 ★★** Write `ostream& operator<<(ostream&, const Employee&)` printing `name (hired YYYY-MM-DD)` using only public getters. Verify chaining: `cout << e1 << " | " << e2 << "\n";`.
- **E22 ★★** Build a `vector<Student>` (E6's class) of three students, set two marks on each, and range-for print roll no, name, average. State why the loop variable must be `const Student&` rather than `Student`.
- **E23 ★★** Write `class Product` (name, unitPrice, stock) with `buy(int qty)` returning `bool` (refuses qty ≤ 0 or qty > stock; decrements stock on success) and `restock(int qty)` (refuses non-positive). Tabulate boundary tests for `buy`.
- **E24 ★★★** Write `class Cart` **has-a** `vector<Product>` with `add(const Product& p)`, `total() const` (sum of unitPrice), and `count() const`. Which relationship is this (composition or aggregation), and what is your ownership answer?
- **E25 ★★★** Design and write `class LibraryAccount` **has-a** `vector<string>` of borrowed titles with the invariant "at most 3 borrowed": `borrow(const string& title) -> bool`, `giveBack(const string& title) -> bool`, `hasBook(title) const`, `borrowedCount() const`. Every guard from the invariant sentence, in the right methods.
- **E26 ★★★** Take the Records module's `LibraryBook` lab schema (title, author, isbn, status) and refactor it into a class where the status transitions (Available → Borrowed → Returned) can *only* happen through methods that check the current status first. Answer in writing: what illegal transition did the struct version permit that the class now makes impossible?

### Solutions C

**S19.** `Date(int y, int m, int d) : year(y), month(clamp(m,1,12)), day(clamp(d,1,31)) {}` — where `clamp` is a small private static-style helper or inline ternaries: `month = m < 1 ? 1 : (m > 12 ? 12 : m)`. `toString` is const (builds a string, mutates nothing): `return to_string(year) + "-" + string(month < 10 ? "0" : "") + to_string(month) + "-" + ...`. The guarantee: **every Date that exists has month 1–12 and day 1–31** — because those are the only two paths to existence, and both validate.

**S20.** `Employee(const string& n, int y, int m, int d) : name(n), hired(y, m, d) {}` — the member `hired` is constructed in the initializer list; there is no way to create an Employee with an unconstructed or invalid Date. `const Date& getHireDate() const { return hired; }` — returns **const reference** to avoid copying while promising no mutation. Printing through the getter only: `cout << e.getHireDate().getYear();` — the wall holds even for nested objects.

**S21.** `ostream& operator<<(ostream& out, const Employee& e) { out << e.getName() << " (hired " << e.getHireDate().toString() << ")"; return out; }` — chaining works because the function returns the same stream it received; `<<` is left-associative, so `(cout << e1)` yields the stream that then receives `" | "`, and so on. Uses only getters — no friend needed, no wall breached.

**S22.** `for (const Student& s : roster) cout << s.getRollNo() << "  " << s.getName() << "  avg " << s.average() << "\n";` — `const Student&` because (1) by-value `Student` would **copy every string member for every iteration** (the cost rule at collection scale), and (2) `const` is required before calling const methods like `average()`... precisely: a plain `Student&` would compile too, but `const&` documents read-only intent and prevents accidental mutation. (A bare `Student` would also compile but pays the copy.)

**S23.** `bool buy(int qty) { if (qty <= 0 || qty > stock) return false; stock -= qty; return true; }` and `bool restock(int qty) { if (qty <= 0) return false; stock += qty; return true; }`. Boundary table for `buy` (stock = 5): qty = 1 → true, 4 (5−1); qty = 5 → true, 0 (the edge: exactly enough); qty = 6 → false, unchanged (the other side of the edge); qty = 0 → false; qty = −2 → false. Both sides of every boundary are exercised — the Debugging module's family, applied to a method.

**S24.** Composition. The `Cart` owns its own `vector<Product>` — products added are **copies** whose lifetime is exactly the cart's; destroy the cart and its contents go with it, automatically, because the vector's destructor destroys its elements. (If instead products lived in an inventory that the cart merely *referenced* by index or pointer, that would be aggregation — the ownership decision is the whole answer, and it must be written down per the Lesson 3 field guide.)

**S25.** `bool borrow(const string& title) { if ((int)titles.size() >= 3) return false; if (hasBook(title)) return false; titles.push_back(title); return true; }` · `bool giveBack(const string& title) { for (size_t i = 0; i < titles.size(); i++) if (titles[i] == title) { titles.erase(titles.begin() + i); return true; } return false; }` — `hasBook` (a const loop over titles) and `borrowedCount` (`titles.size()`) as readers. Both invariant clauses ("≤ 3", "not already borrowed") are enforced inside `borrow`; `giveBack` refuses returns of non-held titles. Every guard is a sentence from step 3 of the design method, and each lives in the method that owns that rule.

**S26.** The class: `private` status (an `enum class` from the Records module — `Available`, `Borrowed`), `borrow()` guards `status == Available`, `giveBack()` guards `status == Borrowed`; both return `bool`; the status attribute has no setter. What the struct version permitted: *any* code could write `book.status = Borrowed;` (or set it twice, or "return" an Available book) — the transitions were a convention. The class makes the illegal transition a **compile error** rather than a data corruption discovered later — the strongest form of the defensive-programming rule, and the cleanest one-paragraph answer to "why OOP" this exercise can produce.

## Where next

- [Class-design drills](design.md): ten schema-first problems that start *before* the code.
- [Debugging hunts](debugging.md): ten broken classes.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
