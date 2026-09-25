---
title: "OOP Labs — 7 Class-Building Scenarios"
description: "Seven labs — BankAccount, Student, Book, Product, Employee, Course, Library — each with scenario, requirements, interface table, test cases, solution, and explanation."
---

# OOP Labs — seven scenarios

> [← Module home](index.md) · Attempt each lab's **design first** (the [six-step method](lesson-3-design-composition.md#2-the-design-method--six-steps-from-requirements-to-class), on paper) before opening its solution. Every lab: scenario → requirements → interface table → test cases → solution → explanation → ⭐ extensions.

---

## Lab 1 — BankAccount

**Scenario.** A bank needs a software account object that *cannot* hold an invalid state: negative balances are impossible, deposits of nothing change nothing, and every withdrawal is answered.

**Requirements.**

- R1 — Attributes: owner's name, balance (long long — paisa-safe integer arithmetic). Both private.
- R2 — Every account is born knowing its owner; balance starts at 0 unless a positive opening deposit is given.
- R3 — `deposit` refuses non-positive amounts; `withdraw` refuses non-positive amounts *and* overdrafts, and reports whether it succeeded.
- R4 — The statement of Lesson 1's class, plus `isOverdrawn() const` is *not* needed (balance can't go negative) — notice which requirements dissolve when invariants are enforced at birth.

**Interface table (attempt yours before reading).**

| Method | Parameters | Returns | Mutates? | Guards |
| --- | --- | --- | --- | --- |
| `BankAccount(name)` / `BankAccount(name, opening)` | — | object | — | opening > 0 enforced |
| `deposit` | `long long amount` | `void` | yes | `amount > 0` |
| `withdraw` | `long long amount` | `bool` | yes | `amount > 0 && amount <= balance` |
| `getBalance` | — | `long long` | **const** | — |
| `getOwner` | — | `string` | **const** | — |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| normal deposit | deposit 500 → balance | 500 |
| zero deposit | deposit 0 → balance | unchanged |
| valid withdrawal | balance 500, withdraw 120 | true, 380 |
| overdraft | balance 100, withdraw 500 | **false**, 100 |
| opening deposit rules | `BankAccount("S", -50)` → balance | 0 |
| no setter exists | `acc.setBalance(...)` | compile error — the wall holds |

**Solution.**

```cpp
// lab1-bankaccount.cpp — Programming Fundamentals Using C++
// Unit 15 · Lab 1 · BankAccount
// Compile: g++ -std=c++17 -Wall -Wextra lab1-bankaccount.cpp -o lab1

#include <iostream>
#include <string>
using namespace std;

class BankAccount {
public:
    BankAccount(const string& ownerName) : owner(ownerName), balance(0) {}
    BankAccount(const string& ownerName, long long opening)
        : BankAccount(ownerName) {              // delegate, then apply the rule
        if (opening > 0) balance = opening;
    }
    void deposit(long long amount) {
        if (amount > 0) balance += amount;
    }
    bool withdraw(long long amount) {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;
        return true;
    }
    long long getBalance() const { return balance; }
    const string& getOwner() const { return owner; }
private:
    string owner;
    long long balance;
};

int main() {
    BankAccount acc("Sana", 500);
    cout << boolalpha;
    cout << acc.getOwner() << " opens with " << acc.getBalance() << "\n";
    acc.deposit(0);
    cout << "after deposit(0):   " << acc.getBalance() << "\n";
    cout << "withdraw(120): " << acc.withdraw(120) << " -> " << acc.getBalance() << "\n";
    cout << "withdraw(9999): " << acc.withdraw(9999) << " -> " << acc.getBalance() << "\n";
    return 0;
}
```

**Expected output.**

```text
Sana opens with 500
after deposit(0):   500
withdraw(120): true -> 380
withdraw(9999): false -> 380
```

**Explanation.** The delegating constructor gives the two birth paths one validated setup (Lesson 2). Every mutation is guarded; the only door *without* a guard is a read (`getBalance`). No `setBalance` exists — an arbitrary setter would reopen the overdraft the class exists to close. This class is the module's reference implementation; six of the later exercises and the mini-project reuse it.

**Extensions.** ⭐ Add a monthly `applyFee(long long fee)` that refuses to push the balance negative (partial fee? refuse whole — document). ⭐ Add C6's ring-buffer statement. ⭐⭐ Add `transfer` (C6) with all-or-nothing semantics.

---

## Lab 2 — Student

**Scenario.** A course coordinator needs a `Student` object that manages its own marks: three quiz slots, each writable once per quiz with a valid mark, and an average that can never be computed wrong.

**Requirements.**

- R1 — Attributes: name, roll number, `int marks[3]` with −1 = "not entered" (all private).
- R2 — `setMark(quiz, m)` accepts only `quiz ∈ {0,1,2}` and `m ∈ [0,100]`; marks may be *corrected* (rewritten), but only through the guard.
- R3 — `average()` computes over *entered* marks only; zero entered → 0.0 (guarded division).
- R4 — `grade()` derives A–F from the average (A ≥ 90, B ≥ 80, C ≥ 70, D ≥ 60). Never stored.
- R5 — Roll number is fixed at birth: no setter.

**Interface table.**

| Method | Parameters | Returns | Mutates? | Guards |
| --- | --- | --- | --- | --- |
| `Student(name, roll)` | — | object | — | name non-empty, roll > 0 |
| `setMark` | `int quiz, int m` | `void` | yes | index + range |
| `mark(quiz)` | `int quiz` | `int` (−1 if unset) | **const** | index |
| `average` | — | `double` | **const** | empty case → 0.0 |
| `grade` | — | `char` | **const** | — |
| `getName` / `getRollNo` | — | — | **const** | — |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| set + read | setMark(0, 85); mark(0) | 85 |
| index guard | setMark(3, 50); mark(3) | unchanged; −1 |
| range guard | setMark(1, 101) | unchanged |
| correction | setMark(0, 85); setMark(0, 92) | 92 |
| average, partial | marks 85, 92, unset | 88.5 (not /3) |
| average, empty | none set | 0.0 |
| grade boundary | marks 90,90,90 | 'A' (the ≥ edge) |
| grade boundary | marks 89,90,89 → avg 89.33 | 'B' |

**Solution.**

```cpp
class Student {
public:
    Student(const string& n, int roll) : name(n), rollNo(roll > 0 ? roll : 0) {}
    void setMark(int quiz, int m) {
        if (quiz >= 0 && quiz < 3 && m >= 0 && m <= 100) marks[quiz] = m;
    }
    int mark(int quiz) const {
        return (quiz >= 0 && quiz < 3) ? marks[quiz] : -1;
    }
    double average() const {
        int total = 0, count = 0;
        for (int m : marks)
            if (m >= 0) { total += m; count++; }
        return count == 0 ? 0.0 : static_cast<double>(total) / count;
    }
    char grade() const {
        double a = average();
        if (a >= 90) return 'A';
        if (a >= 80) return 'B';
        if (a >= 70) return 'C';
        if (a >= 60) return 'D';
        return 'F';
    }
    const string& getName() const { return name; }
    int getRollNo() const { return rollNo; }
private:
    string name;
    int rollNo;
    int marks[3] = {-1, -1, -1};
};
```

**Explanation.** The sentinel array is the Records module's design, now unreachable from outside. `average()` is the arrays module' guarded mean over entered marks; `grade()` is a pure derivation from it — two const readers chained, no stored copy anywhere (D8's drift bug is structurally impossible). The roll-number immutability (R5) is identity, not data: people's names change, roll numbers don't.

**Extensions.** ⭐ Add `operator<<` (Lesson 3) printing roll, name, average, grade. ⭐ Add `highestQuiz() const -> int` (index of best entered mark, −1 if none). ⭐⭐ Refuse *lowering* a mark (corrections only upward) — justify or reject the rule in a comment.

---

## Lab 3 — Book

**Scenario.** A library's book object must enforce its own lending lifecycle: borrowed books can't be borrowed again, available books can't be returned.

**Requirements.**

- R1 — Attributes: title, author, isbn (string), status (an `enum class Status { Available, Borrowed }`), borrower id (int, meaningful only while borrowed).
- R2 — Transitions happen **only** through `borrow(memberId)` and `giveBack()`, each returning `bool` and each checking the current status first (S26's one-way doors).
- R3 — Title/author/isbn are fixed at construction. Status has **no setter**.
- R4 — `isAvailable() const` and `currentBorrower() const -> int` (−1 when available) are the only peepholes.

**Interface table.**

| Method | Parameters | Returns | Mutates? | Guards |
| --- | --- | --- | --- | --- |
| `Book(title, author, isbn)` | — | object | — | — |
| `borrow` | `int memberId` | `bool` | yes | `status == Available && memberId > 0` |
| `giveBack` | — | `bool` | yes | `status == Borrowed` |
| `isAvailable` | — | `bool` | **const** | — |
| `currentBorrower` | — | `int` | **const** | — |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| fresh book | isAvailable() | true |
| borrow | borrow(7) | true; isAvailable() false |
| double borrow | borrow(9) on borrowed book | **false**; borrower still 7 |
| return | giveBack() | true; isAvailable() true |
| double return | giveBack() again | **false** |
| borrower cleared | borrow(7), giveBack(), currentBorrower() | −1 |

**Solution.**

```cpp
class Book {
public:
    Book(const string& t, const string& a, const string& i)
        : title(t), author(a), isbn(i), status(Status::Available), borrowerId(-1) {}
    bool borrow(int memberId) {
        if (status != Status::Available || memberId <= 0) return false;
        status = Status::Borrowed;
        borrowerId = memberId;
        return true;
    }
    bool giveBack() {
        if (status != Status::Borrowed) return false;
        status = Status::Available;
        borrowerId = -1;
        return true;
    }
    bool isAvailable() const { return status == Status::Available; }
    int currentBorrower() const { return borrowerId; }
    const string& getIsbn() const { return isbn; }
    const string& getTitle() const { return title; }
private:
    enum class Status { Available, Borrowed };
    string title, author, isbn;
    Status status;
    int borrowerId;
};
```

**Explanation.** The `enum class` (Records module) gives status a type with no silent integer conversions; it sits private with no setter, so the *only* state changes are the two guarded transitions — the state machine from the Strings/Records work, now compiler-enforced. Every illegal sequence from the test table returns `false` rather than corrupting state. Compare with D10's broken `LibraryBook`: the difference is guards on *both* doors and no public attributes.

**Extensions.** ⭐ Add `dueDay` set at borrow time and a `isOverdue(int today) const`. ⭐⭐ Add a `Borrowed` → `Lost` transition and decide which transitions `Lost` permits (defend the one-way doors in comments).

---

## Lab 4 — Product

**Scenario.** A shop's inventory line must never oversell and never accept nonsense restocking.

**Requirements.**

- R1 — Attributes: name, unit price (long long, whole paisa), stock (int). Private.
- R2 — `buy(qty) -> bool`: refuses qty ≤ 0 or qty > stock; on success decrements stock.
- R3 — `restock(qty) -> bool`: refuses qty ≤ 0 (ceilings are a policy choice — document if you add one).
- R4 — `value() const` returns stock × unit price (derived).
- R5 — Price changes are allowed but guarded (positive), and *never* change already-sold transactions — out of scope, but state that in a comment (the honesty habit).

**Interface table.**

| Method | Parameters | Returns | Mutates? | Guards |
| --- | --- | --- | --- | --- |
| `Product(name, price, stock)` | — | object | — | price > 0, stock ≥ 0 |
| `buy` | `int qty` | `bool` | yes | `qty > 0 && qty <= stock` |
| `restock` | `int qty` | `bool` | yes | `qty > 0` |
| `value` | — | `long long` | **const** | — |
| `getStock` | — | `int` | **const** | — |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| exact stock | stock 5, buy(5) | true; stock 0 (the edge) |
| oversell | stock 5, buy(6) | **false**; stock 5 |
| zero buy | buy(0) | **false** |
| restock flow | buy(5); restock(10); buy(3) | true; stock 7 |
| negative restock | restock(-4) | **false** |
| value | price 2500, stock 7 | 17500 |

**Solution.**

```cpp
class Product {
public:
    Product(const string& n, long long unitPrice, int initialStock)
        : name(n), price(unitPrice > 0 ? unitPrice : 0), stock(initialStock >= 0 ? initialStock : 0) {}
    bool buy(int qty) {
        if (qty <= 0 || qty > stock) return false;
        stock -= qty;
        return true;
    }
    bool restock(int qty) {
        if (qty <= 0) return false;
        stock += qty;
        return true;
    }
    bool setPrice(long long p) {
        if (p <= 0) return false;
        price = p;
        return true;
    }
    long long value() const { return static_cast<long long>(stock) * price; }
    int getStock() const { return stock; }
    long long getUnitPrice() const { return price; }
private:
    string name;
    long long price;
    int stock;
};
```

**Explanation.** The constructor guards birth (no negative price/stock can ever exist — the D6 lesson applied); `buy`'s guard is the exact-both-sides boundary pair from the test table; `value()` casts *before* multiplying (the arrays module' overflow habit — int × long long already promotes, but the explicit cast documents intent). Stock decreases through exactly one method; the oversell bug the class exists to prevent is now a `false`, not a negative inventory.

**Extensions.** ⭐ Add a `sellPrice(qty) const` computing bulk discounts (≥ 10 units: 5% off — guard the rounding). ⭐⭐ Add a per-product sales counter and `unitsSold() const` — decide whether refunds decrement it (defend the answer).

---

## Lab 5 — Employee

**Scenario.** HR needs an employee object with a validated hiring date (composition, Lesson 3) and a salary that can only change through a raise method with a rule.

**Requirements.**

- R1 — Attributes: name, `Date hireDate` (Lab: reuse a Date class with month 1–12, day 1–31 guards — the Records module's Date factory, class-ified), salary (long long), employee id. Private.
- R2 — Name, id, and hire date are fixed at birth (composition: `hireDate` is constructed in the initializer list).
- R3 — `applyRaise(percent) -> bool`: accepts 1–50 inclusive; refuses otherwise; salary grows by the rounded amount.
- R4 — `monthlySalary() const` derives salary / 12 (guard nothing — salary is always positive by construction).
- R5 — `tenureYears(int currentYear) const` derives years served (const, no mutation).

**Interface table.**

| Method | Parameters | Returns | Mutates? | Guards |
| --- | --- | --- | --- | --- |
| `Employee(name, id, y, m, d, salary)` | — | object | — | salary > 0; date validated by `Date` |
| `applyRaise` | `int percent` | `bool` | yes | `percent ∈ [1, 50]` |
| `getHireDate` | — | `const Date&` | **const** | — |
| `monthlySalary` / `tenureYears` | — | `long long` / `int` | **const** | — |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| composition at birth | `Employee("Omar", 7, 2020, 9, 1, 60000)`; getHireDate().getMonth() | 9 |
| invalid month refused | `Employee(..., 13, ...)` | Date clamped to 12 — every Employee's date valid |
| raise | applyRaise(10) on 60000 | true; salary 66000 |
| raise boundary | applyRaise(50) | true (the edge) |
| raise refused | applyRaise(51) / applyRaise(0) | **false**; salary unchanged |
| tenure | hired 2020, currentYear 2026 | 6 |

**Solution.**

```cpp
#include <cmath>
class Date {
public:
    Date(int y, int m, int d)
        : year(y), month(m < 1 ? 1 : (m > 12 ? 12 : m)), day(d < 1 ? 1 : (d > 31 ? 31 : d)) {}
    int getYear() const { return year; }
    int getMonth() const { return month; }
    int getDay() const { return day; }
private:
    int year, month, day;
};

class Employee {
public:
    Employee(const string& n, int id, int y, int m, int d, long long yearly)
        : name(n), empId(id), hired(y, m, d), salary(yearly > 0 ? yearly : 0) {}
    bool applyRaise(int percent) {
        if (percent < 1 || percent > 50) return false;
        salary += salary * percent / 100;     // long long: no overflow at these scales
        return true;
    }
    long long getSalary() const { return salary; }
    long long monthlySalary() const { return salary / 12; }
    int tenureYears(int currentYear) const { return currentYear - hired.getYear(); }
    const Date& getHireDate() const { return hired; }
    const string& getName() const { return name; }
private:
    string name;
    int empId;
    Date hired;        // composition: born with the employee, dies with the employee
    long long salary;
};
```

**Explanation.** `hired(y, m, d)` in the initializer list constructs the composed `Date` — the Employee cannot exist with an unconstructed or invalid date (D7's lesson applied positively). `Date`'s clamps guarantee month 1–12 for *every* date ever built; composition propagates the invariant (Lesson 3's "walls made of walls"). `getHireDate` returns `const Date&` — no copy, no mutation path. All the money math is `long long` (the course's currency habit), and raise is the only salary door.

**Extensions.** ⭐ Add `operator<<` printing `name (id) — hired YYYY-MM-DD`. ⭐ Add a `promote(const string& newTitle)` storing a title — decide whether old titles are history (a second attribute? a log? or out of scope — document). ⭐⭐ Refuse raises that would make salary exceed a `MAX_SALARY` class constant — and justify where the constant lives (`static const` in the class).

---

## Lab 6 — Course

**Scenario.** A registrar's course object manages its own enrollment: capacity is a hard ceiling, a student enrolls once, and dropping frees the seat.

**Requirements.**

- R1 — Attributes: course code (string), title, `int capacity`, `vector<int> rollNumbers` of enrolled students. Private.
- R2 — `enroll(rollNo) -> bool`: refuses when full, when already enrolled, or rollNo ≤ 0.
- R3 — `drop(rollNo) -> bool`: refuses when not enrolled.
- R4 — `isEnrolled(rollNo) const`, `seatsLeft() const` (derived), `getRollNumbers() const` returning a **copy** of the roster (why: the caller may not mutate the course's interior through a reference).
- R5 — Capacity fixed at birth, 1–500.

**Interface table.**

| Method | Parameters | Returns | Mutates? | Guards |
| --- | --- | --- | --- | --- |
| `Course(code, title, cap)` | — | object | — | `cap ∈ [1, 500]` |
| `enroll` | `int rollNo` | `bool` | yes | not full, not enrolled, rollNo > 0 |
| `drop` | `int rollNo` | `bool` | yes | currently enrolled |
| `seatsLeft` | — | `int` | **const** | — |
| `isEnrolled` | — | `bool` | **const** | — |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| enroll to capacity | cap 3, enroll 3 students | all true; seatsLeft 0 |
| one over | 4th enroll | **false** (the boundary) |
| duplicate | enroll(101) twice | second **false** |
| drop flow | drop(101); enroll(104) | true; seatsLeft 0 again |
| drop absent | drop(999) | **false** |
| capacity clamp | `Course("CS", "Intro", 900)` | capacity 500 |

**Solution.**

```cpp
#include <vector>
class Course {
public:
    Course(const string& code, const string& title, int cap)
        : courseCode(code), courseTitle(title),
          capacity(cap < 1 ? 1 : (cap > 500 ? 500 : cap)) {}
    bool enroll(int rollNo) {
        if (rollNo <= 0 || (int)rollNumbers.size() >= capacity) return false;
        if (isEnrolled(rollNo)) return false;
        rollNumbers.push_back(rollNo);
        return true;
    }
    bool drop(int rollNo) {
        for (size_t i = 0; i < rollNumbers.size(); i++) {
            if (rollNumbers[i] == rollNo) {
                rollNumbers.erase(rollNumbers.begin() + i);
                return true;
            }
        }
        return false;
    }
    bool isEnrolled(int rollNo) const {
        for (int r : rollNumbers) if (r == rollNo) return true;
        return false;
    }
    int seatsLeft() const { return capacity - (int)rollNumbers.size(); }
    int getCapacity() const { return capacity; }
    vector<int> getRollNumbers() const { return rollNumbers; }   // a copy — deliberate
    const string& getCode() const { return courseCode; }
private:
    string courseCode, courseTitle;
    int capacity;
    vector<int> rollNumbers;
};
```

**Explanation.** The capacity clamp at birth is the D6 audit's Lesson: *every* door validates. `enroll`'s three guards are the requirement sentences translated directly; the **linear search** (`isEnrolled`) is the Algorithms module's linear search living inside a class — same algorithm, new address, and the course's small-n honesty (a binary search would demand sorted roll numbers: a real design decision to note, not a bug). `getRollNumbers` returns by value on purpose: a returned `const&` to the interior vector lets a caller hold a reference while the course mutates (a dangling alias); the copy is the safe, beginner-correct contract — and the comment saying so is part of the design.

**Extensions.** ⭐ Add `roster() const` printing the roll numbers via `operator<<` on the course. ⭐⭐ Add `Course::merge(const Course& other)` importing not-yet-enrolled students up to capacity, reporting how many were added — and decide whether `other` must be `const` (yes: `const Course&`).

---

## Lab 7 — Library

**Scenario.** The synthesis lab: a `Library` coordinates `Book` objects (Lab 3) and `LibraryMember` objects (E25's 3-book design), enforcing every rule *through* the owning classes — the C9 rule-to-method map, built and tested.

**Requirements.**

- R1 — `Library` **has-a** `vector<Book>` and `vector<LibraryMember>` (composition — the library owns its catalogue and membership).
- R2 — `addBook(...)`, `addMember(name) -> int` (returns the assigned member id, starting at 1).
- R3 — `lend(isbn, memberId) -> bool`: book and member must exist; the book must be available (its own rule); the member must be under limit and not already holding that title (their own rules). The library orchestrates; it never touches a Book's status or a Member's list directly.
- R4 — `receive(isbn) -> bool`: the book's `giveBack` rule fires; the *member's* list is updated by finding who held it (the Book knows its borrower id).
- R5 — `findBook(isbn) const -> const Book*` returning `nullptr` when absent — the Pointers module's null-pointer convention, reborn as an honest "not found" answer.

**Interface table (condensed — design the rest yourself).**

| Method | Parameters | Returns | Mutates? | Notes |
| --- | --- | --- | --- | --- |
| `addMember` | `const string& name` | `int` (id) | yes | ids sequential from 1 |
| `lend` | `const string& isbn, int memberId` | `bool` | yes | all guards via member methods |
| `receive` | `const string& isbn` | `bool` | yes | locates borrower via book |
| `findBook` | `const string& isbn` | `const Book*` | **const** | `nullptr` = absent |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| full flow | add book + member; lend | true; book unavailable; member holds 1 |
| limit | member borrows 4th distinct book | **false** (member's rule) |
| duplicate hold | member lends same isbn twice | **false** (member's rule) |
| double lend | two members, same isbn | second **false** (book's rule) |
| receive | receive(isbn) | true; book available; member holds 0 |
| absent isbn | lend("NOPE", 1) | **false** |
| unknown member | lend(isbn, 99) | **false** |

**Solution.**

```cpp
class LibraryMember {
public:
    LibraryMember(const string& n, int id) : name(n), memberId(id) {}
    bool borrow(const string& title) {
        if ((int)held.size() >= 3 || hasTitle(title)) return false;
        held.push_back(title);
        return true;
    }
    bool giveBack(const string& title) {
        for (size_t i = 0; i < held.size(); i++)
            if (held[i] == title) { held.erase(held.begin() + i); return true; }
        return false;
    }
    bool hasTitle(const string& t) const {
        for (const string& h : held) if (h == t) return true;
        return false;
    }
    int getId() const { return memberId; }
private:
    string name;
    int memberId;
    vector<string> held;      // titles — max 3, enforced in borrow
};

class Library {
public:
    int addMember(const string& name) {
        members.push_back(LibraryMember(name, nextMemberId));
        return nextMemberId++;
    }
    void addBook(const Book& b) { books.push_back(b); }
    bool lend(const string& isbn, int memberId) {
        Book* book = findBookMutable(isbn);
        LibraryMember* member = findMember(memberId);
        if (book == nullptr || member == nullptr) return false;
        if (!book->isAvailable()) return false;         // book's own rule
        if (!member->borrow(book->getTitle())) return false;  // member's rules
        book->borrow(memberId);                          // already validated above
        return true;
    }
    bool receive(const string& isbn) {
        Book* book = findBookMutable(isbn);
        if (book == nullptr || book->isAvailable()) return false;
        int borrowerId = book->currentBorrower();
        LibraryMember* member = findMember(borrowerId);
        book->giveBack();
        if (member != nullptr) member->giveBack(book->getTitle());
        return true;
    }
    const Book* findBook(const string& isbn) const {
        for (const Book& b : books) if (b.getIsbn() == isbn) return &b;
        return nullptr;
    }
private:
    Book* findBookMutable(const string& isbn) {
        for (Book& b : books) if (b.getIsbn() == isbn) return &b;
        return nullptr;
    }
    LibraryMember* findMember(int id) {
        for (LibraryMember& m : members) if (m.getId() == id) return &m;
        return nullptr;
    }
    vector<Book> books;
    vector<LibraryMember> members;
    int nextMemberId = 1;
};
```

**Explanation.** This is the module's architectural exam. `lend` refuses *before* mutating anything (the C6/C9 all-or-nothing discipline): the book's availability and the member's rules are consulted first, then both sides update. Note what the library **cannot** do by design: set a status, push a title, reach into any interior — it only calls methods, so every rule fires exactly where its data lives (the rule-to-method map made executable). The mutable/const `findBook` pair shows the const ladder (Functions → Lesson 3) operating at class scale: readers get `const Book*`, orchestrators get the mutable pointer, and neither copies a Book (the D4 lesson: resource-owning types travel by reference — here, by address inside an owned vector). The `nullptr` returns are the Pointers module's contract reborn: absence is a value, checked at the call site.

**Extensions.** ⭐ Add `overdueList(int today) const` using Lab 3's ⭐ due-date extension. ⭐ Add `operator<<` for the library printing counts (books, members, items on loan — all derived). ⭐⭐⭐ Persist the catalogue to a text file and reload it — the Files module's format contract, now round-tripping objects; document the format before writing it.

---

## Where next

- [The Object-Oriented Mini Project](miniproject.md): the Records-module system, rebuilt as classes.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
