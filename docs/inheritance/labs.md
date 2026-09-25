---
title: "Inheritance Labs — 5 Hierarchy Scenarios"
description: "Five labs — Shape, Employee, Payment methods, Vehicle, University roles — each with requirements, interface tables, test cases, solutions, and the composition comparison."
---

# Inheritance Labs — five hierarchies

> [← Module home](index.md) · Attempt each lab's **is-a sentences and interface table first**. Every lab: scenario → requirements → interface table → test cases → solution → explanation → **composition check** (where the alternative deserves a hearing) → ⭐ extensions.

---

## Lab 1 — Shape hierarchy

**Scenario.** A geometry toolkit renders shapes: every shape answers `area()` and `perimeter()`, prints itself, and new shapes arrive every term without touching existing code.

**Requirements.**

- R1 — `Shape` is **abstract**: pure `area()`, pure `perimeter()`, virtual destructor, shared non-virtual `describe()` calling both hooks.
- R2 — Implementers: `Circle` (radius), `Rect` (width, height), `Triangle` (three sides, Heron's formula).
- R3 — Mixed collection loop with per-object dispatch; totals computed through the interface only.
- R4 — No type fields, no `dynamic_cast`, no switches on kind (gallery #10 — the loop *is* the table).

**Interface table.**

| Method | Class | Kind | Returns | Notes |
| --- | --- | --- | --- | --- |
| `area()` | Shape | **pure virtual** | `double` | every shape refines |
| `perimeter()` | Shape | **pure virtual** | `double` | every shape refines |
| `describe()` | Shape | non-virtual | `void` | calls the hooks |
| `~Shape` | Shape | virtual | — | rule with no exceptions |
| `area()` / `perimeter()` | each subclass | `override` | `double` | the refinement |

**Test cases.**

| Case | Input | Expected |
| --- | --- | --- |
| circle area | r = 2 | 12.5664 |
| rect perimeter | 3 × 4 | 14 |
| triangle validity | sides 1, 2, 10 | constructor refuses (violates triangle inequality) |
| abstract refusal | `Shape s;` | compile error |
| mixed loop | {circle 2, rect 3×4, tri 3-4-5} | areas 12.5664, 12, 6 |
| totals | same collection | total area 30.5664; max perimeter 14 |

**Solution.**

```cpp
// lab1-shapes.cpp — Programming Fundamentals Using C++
// Inheritance module · Lab 1 · Shape hierarchy
// Compile: g++ -std=c++17 -Wall -Wextra lab1-shapes.cpp -o lab1

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

const double PI = 3.14159265358979;   // M_PI is POSIX, not standard C++

class Shape {
public:
    virtual double area() const = 0;
    virtual double perimeter() const = 0;
    void describe() const {
        cout << "area = " << area() << ", perimeter = " << perimeter() << "\n";
    }
    virtual ~Shape() = default;
};

class Circle : public Shape {
public:
    Circle(double r) : radius(r > 0 ? r : 1) {}
    double area() const override { return PI * radius * radius; }
    double perimeter() const override { return 2 * PI * radius; }
private:
    double radius;
};

class Rect : public Shape {
public:
    Rect(double w, double h) : w(w > 0 ? w : 1), h(h > 0 ? h : 1) {}
    double area() const override { return w * h; }
    double perimeter() const override { return 2 * (w + h); }
private:
    double w, h;
};

class Triangle : public Shape {
public:
    Triangle(double a, double b, double c) : a(a), b(b), c(c) {
        if (a + b <= c || a + c <= b || b + c <= a) {   // triangle inequality at birth
            side1 = side2 = side3 = 1;
        } else {
            side1 = a; side2 = b; side3 = c;
        }
    }
    double area() const override {
        double s = (side1 + side2 + side3) / 2.0;       // Heron
        return sqrt(s * (s - side1) * (s - side2) * (s - side3));
    }
    double perimeter() const override { return side1 + side2 + side3; }
private:
    double side1, side2, side3, a = 1, b = 1, c = 1;
};

int main() {
    vector<Shape*> gallery = { new Circle(2.0), new Rect(3, 4), new Triangle(3, 4, 5) };
    double totalArea = 0, maxPerimeter = 0;
    for (const Shape* s : gallery) {
        s->describe();
        totalArea += s->area();
        if (s->perimeter() > maxPerimeter) maxPerimeter = s->perimeter();
    }
    cout << "total area = " << totalArea << ", max perimeter = " << maxPerimeter << "\n";
    for (Shape* s : gallery) delete s;
    return 0;
}
```

**Expected output.**

```text
area = 12.5664, perimeter = 12.5664
area = 12, perimeter = 14
area = 6, perimeter = 12
total area = 30.5664, max perimeter = 14
```

**Explanation.** The abstract base carries the *contract* (two pure virtuals) and the *shared formatting* (`describe`) — the template-method split. Triangle's validation runs at birth (the OOP module's D6 lesson: every door validates, including construction), so no invalid triangle can join a gallery. The loop and totals never mention a kind.

**Composition check.** Could shapes be composition? The honest answer: *kinds of the same question* is exactly inheritance's jurisdiction (Lesson 3's decision step 3) — Circle/Rect/Triangle are different *rules*, not swappable *parts*. The composition alternative (a `Shape` holding an enum and switching) is gallery #10. Verdict: inheritance, defended.

**Extensions.** ⭐ Add `Square` and decide its base honestly (the DP4 argument in a comment). ⭐ Add `scale(factor)` — virtual, mutating; which members change per class? ⭐⭐ Replace raw pointers with an ownership-managing `Report` class (E14's design).

---

## Lab 2 — Employee hierarchy

**Scenario.** A payroll system pays people who work differently: salaried staff get a fixed monthly amount; hourly staff are paid by hours × rate with overtime; commission staff get base + percent of sales.

**Requirements.**

- R1 — Abstract `Employee` (name, id): pure `monthlyPay() const`, shared `describe()` printing name + computed pay.
- R2 — `SalariedEmployee` (monthly salary), `HourlyEmployee` (rate, hours; hours > 160 paid at 1.5×), `CommissionEmployee` (base, sales, percent).
- R3 — A payroll loop over `const Employee* const staff[]` prints each and totals — one loop, three pay formulas.
- R4 — All amounts `long long` (the course's currency habit).

**Interface table.**

| Method | Kind | Returns | Refined by |
| --- | --- | --- | --- |
| `monthlyPay()` | **pure virtual** | `long long` | all three subclasses |
| `describe()` | non-virtual | `void` | nobody (shared) |
| `getName()` / `getId()` | non-virtual const | — | nobody |

**Test cases.**

| Case | Input | Expected |
| --- | --- | --- |
| salaried | salary 60 000 | 60 000 |
| hourly, under cap | rate 500, hours 140 | 70 000 |
| hourly, overtime | rate 500, hours 170 | 85 000 (160×500 + 10×750) |
| commission | base 20 000, sales 100 000, 10% | 30 000 |
| payroll total | all four above | 245 000 |
| abstract refusal | `Employee e;` | compile error |

**Solution (the hierarchy).**

```cpp
class Employee {
public:
    Employee(const string& n, int id) : name(n), empId(id) {}
    virtual long long monthlyPay() const = 0;
    void describe() const {
        cout << name << " (#" << empId << "): " << monthlyPay() << "\n";
    }
    virtual ~Employee() = default;
protected:
    string name;                 // protected data here ONLY with the §4 defence:
    int empId;                   // subclasses keep it valid (never reassigned wholesale)
private:
    // (name/empId could be private + accessors; the lab asks you to try BOTH and argue)
};

class SalariedEmployee : public Employee {
public:
    SalariedEmployee(const string& n, int id, long long monthly)
        : Employee(n, id), salary(monthly > 0 ? monthly : 0) {}
    long long monthlyPay() const override { return salary; }
private:
    long long salary;
};

class HourlyEmployee : public Employee {
public:
    HourlyEmployee(const string& n, int id, long long rate, int hours)
        : Employee(n, id), rate(rate > 0 ? rate : 0), hours(hours > 0 ? hours : 0) {}
    long long monthlyPay() const override {
        int regular = hours > 160 ? 160 : hours;
        int overtime = hours > 160 ? hours - 160 : 0;
        return regular * rate + overtime * rate * 3 / 2;   // 1.5× overtime
    }
private:
    long long rate;
    int hours;
};

class CommissionEmployee : public Employee {
public:
    CommissionEmployee(const string& n, int id, long long base, long long sales, int pct)
        : Employee(n, id), base(base), sales(sales), pct(pct) {}
    long long monthlyPay() const override { return base + sales * pct / 100; }
private:
    long long base, sales;
    int pct;
};
```

**Explanation.** Three *kinds of the same question* ("what does this person earn this month?") — the is-a family's home ground. The overtime boundary (160) gets both-sides tests (140 vs 170 — the Debugging module's boundary family at the payroll edge). The `protected` data appears **with its defence written inline**, exactly as Lesson 1 §4 demands; the lab asks you to write the `private`-plus-accessors variant too and argue which you'd ship.

**Composition check.** Could pay be composed? Yes — a `PayScheme` interface (the Payment lab does exactly that for payment methods). The trade: hierarchy reads naturally for *kinds of employees*; composition reads naturally for *swappable pay rules*. The lab's honest conclusion: either is defensible; **what's not defensible is a switch on an enum inside `monthlyPay`** — gallery #10.

**Extensions.** ⭐ Add `Manager : SalariedEmployee` with a bonus — and decide whether `monthlyPay` overrides or extends (the `SalariedEmployee::monthlyPay()` qualified call — D9's lesson used correctly). ⭐⭐ Make pay rules swappable per employee (compose with a `PayScheme*` — the bridge to Lab 3).

---

## Lab 3 — Payment methods (the composition lab)

**Scenario.** A checkout charges a total through exactly one payment method — but the method is **chosen after the order exists**, and new methods (card, cash-on-delivery, wallet, instalments) arrive quarterly. The brief explicitly asks: *inheritance or composition?*

**Requirements.**

- R1 — An interface `PaymentMethod`: pure `pay(long long amount) -> bool`, pure `name() const -> string`, virtual destructor.
- R2 — Implementers validate their own rules: Card (needs a 16-digit token), COD (refuses totals over 50 000), Wallet (needs sufficient stored balance — it *deducts*), Instalments (needs amount ≥ 10 000).
- R3 — `Checkout` **composes**: holds a `const PaymentMethod*` that can be re-pointed after construction; `charge() -> bool` delegates.
- R4 — Swap the method at runtime and charge again — the requirement that decides the design.

**Interface table.**

| Method | Kind | Returns | Notes |
| --- | --- | --- | --- |
| `pay(amount)` | **pure virtual** | `bool` | each method's own rules |
| `name()` | **pure virtual** | `string` | for receipts |
| `~PaymentMethod` | virtual | — | deleted through the interface |
| `Checkout::setMethod` | non-virtual | `void` | **re-points at runtime** — the design's teeth |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| card success | card(token), charge 2 500 | true |
| COD ceiling | COD, charge 60 000 | **false** (over ceiling) |
| wallet flow | load 1 000; charge 400 | true; wallet balance 600 |
| wallet empty | charge 999 | **false**; balance still 600 |
| runtime swap | card fails → setMethod(wallet) → charge | false then true |
| instalment floor | charge 9 999 via instalments | **false** (under floor) |

**Solution.**

```cpp
class PaymentMethod {
public:
    virtual bool pay(long long amount) = 0;
    virtual string name() const = 0;
    virtual ~PaymentMethod() = default;
};

class Card : public PaymentMethod {
public:
    Card(const string& token16) {
        if (token16.length() == 16) token = token16;    // validated at birth
    }
    bool pay(long long amount) override { return !token.empty() && amount > 0; }
    string name() const override { return "Card"; }
private:
    string token;
};

class Wallet : public PaymentMethod {
public:
    bool load(long long amt) { if (amt <= 0) return false; balance += amt; return true; }
    bool pay(long long amount) override {
        if (amount <= 0 || amount > balance) return false;
        balance -= amount;
        return true;
    }
    string name() const override { return "Wallet"; }
    long long getBalance() const { return balance; }
private:
    long long balance = 0;
};

class CashOnDelivery : public PaymentMethod {
public:
    bool pay(long long amount) override { return amount > 0 && amount <= 50000; }
    string name() const override { return "COD"; }
};

class Checkout {
public:
    explicit Checkout(const PaymentMethod* method) : method(method) {}
    void setMethod(const PaymentMethod* m) { method = m; }   // THE runtime swap
    bool charge(long long amount) const {
        if (method == nullptr) return false;
        cout << "charging " << amount << " via " << method->name() << ": ";
        return method->pay(amount);
    }
private:
    const PaymentMethod* method;    // composition: held, swappable, not owned
};
```

**Explanation.** This lab is Lesson 3's decision procedure executed: step 1 (is-a: "checkout **is a** payment method" — absurd), step 5 (swap at runtime — *only composition can*). The methods are classes because each *owns rules and state* (Wallet's balance); the checkout holds a pointer it does **not** own (methods live in `main`, outliving any checkout — aggregation by the OOP module's field guide). Note the four implementers pass their own gates; `Checkout::charge` never validates amounts — *each rule lives with its data* (C9's rule-to-method map, one more time).

**Composition check.** This lab *is* the composition check — and the inherited counter-design (`CardCheckout : Checkout`) fails on the swap alone: a base class is fixed at birth. Say it in the defence sentence.

**Extensions.** ⭐ Add `CombinedPayment` (part wallet, part card — wallet first, remainder card): composition *of two methods inside one method*, which inheritance cannot express. ⭐⭐ Add a receipt interface and make every method `Printable` (Lesson 3's idiom 1).

---

## Lab 4 — Vehicle hierarchy

**Scenario.** A fleet manager reports every vehicle's range: electric vehicles compute from battery capacity and efficiency; petrol vehicles from tank size and consumption; hybrids do **both** — and the manager's loop must not care.

**Requirements.**

- R1 — Abstract `Vehicle` (registration number): pure `range() const -> double`, shared `describe()`.
- R2 — `ElectricVehicle` (battery kWh, km per kWh), `PetrolVehicle` (tank litres, km per litre).
- R3 — `HybridVehicle` must answer `range()` **correctly** — design decision: inherit from one base and *compose* the second drive system inside.
- R4 — The fleet loop totals range over a mixed `vector<Vehicle*>`.

**Interface table.**

| Method | Kind | Returns | Notes |
| --- | --- | --- | --- |
| `range()` | **pure virtual** | `double` | the one fleet question |
| `describe()` | non-virtual | `void` | shared |
| `~Vehicle` | virtual | — | deleted through base in the loop |

**Test cases.**

| Case | Input | Expected |
| --- | --- | --- |
| electric | 60 kWh × 6 km/kWh | 360 |
| petrol | 40 L × 15 km/L | 600 |
| hybrid | battery half-range + tank half-range | 180 + 300 = 480 |
| fleet total | all three above | 1 440 |
| zero guards | EV with 0 kWh | constructor clamps to 1 (documented) |

**Solution (the hybrid's honest shape).**

```cpp
class ElectricDrive {
public:
    ElectricDrive(double kwh, double kmPerKwh) : kwh(kwh > 0 ? kwh : 1), eff(kmPerKwh > 0 ? kmPerKwh : 1) {}
    double range() const { return kwh * eff; }
private:
    double kwh, eff;
};

class PetrolDrive {
public:
    PetrolDrive(double litres, double kmPerLitre) : litres(litres > 0 ? litres : 1), eff(kmPerLitre > 0 ? kmPerLitre : 1) {}
    double range() const { return litres * eff; }
private:
    double litres, eff;
};

class Vehicle {
public:
    Vehicle(const string& reg) : regNo(reg) {}
    virtual double range() const = 0;
    void describe() const { cout << regNo << ": range " << range() << " km\n"; }
    virtual ~Vehicle() = default;
private:
    string regNo;
};

class ElectricVehicle : public Vehicle {
public:
    ElectricVehicle(const string& reg, double kwh, double eff)
        : Vehicle(reg), drive(kwh, eff) {}            // composed drive
    double range() const override { return drive.range(); }
private:
    ElectricDrive drive;                              // HAS-A drive system
};

class PetrolVehicle : public Vehicle {
public:
    PetrolVehicle(const string& reg, double litres, double eff)
        : Vehicle(reg), engine(litres, eff) {}
    double range() const override { return engine.range(); }
private:
    PetrolDrive engine;
};

class HybridVehicle : public Vehicle {
public:
    HybridVehicle(const string& reg, double kwh, double effE, double litres, double effP)
        : Vehicle(reg), battery(kwh, effE), tank(litres, effP) {}
    double range() const override { return battery.range() + tank.range(); }
private:
    ElectricDrive battery;    // composition, twice
    PetrolDrive tank;
};
```

**Explanation.** The lab's quiet lesson: the *drive systems* are composed (a vehicle **has** a drive), while the *fleet membership* is inherited (an EV **is a** Vehicle — substitutable in the loop). The hybrid inherits **once** and composes **twice** — refusing the diamond-shaped double inheritance (`class Hybrid : public ElectricVehicle, public PetrolVehicle`) that two `range()`s and two `regNo`s would create. Where multiple inheritance *is* safe (pure interfaces) and where it tangles (state) gets its one-sentence rehearsal here.

**Composition check.** Already inside the answer — and that *is* the lab's thesis: **inheritance for the family, composition for the machinery.**

**Extensions.** ⭐ Add `fuelLeft() const` per drive type through a shared `Reportable`-style interface. ⭐⭐ Add a `Maintenance` interface (`serviceDue() const`) implemented only by vehicles that need scheduling — and a loop that takes `vector<Maintainable*>`.

---

## Lab 5 — University role hierarchy

**Scenario.** A university portal shows people: every person has a name and id and introduces themselves; students enroll in courses; teachers teach courses; staff process requests. The portal's directory lists **everyone** with one loop.

**Requirements.**

- R1 — Abstract `Person` (name, id): pure `role() const -> string`, shared `introduce() const` printing name, id, role.
- R2 — `Student` (add `enroll(courseCode)` into a personal list, max 6 — the OOP module's invariant, reused), `Teacher` (courses taught, max 4), `Staff` (department, request processing count).
- R3 — The directory loop takes `const Person* const people[]` and calls `introduce()` on each — role text comes from the object.
- R4 — Role-specific operations are **reachable only through the derived type** — no stubs on the base (gallery #2).

**Interface table.**

| Method | Kind | Returns | Notes |
| --- | --- | --- | --- |
| `role()` | **pure virtual** | `string` | "Student" / "Teacher" / "Staff" |
| `introduce()` | non-virtual | `void` | calls `role()` — the hook again |
| `enroll` / `teach` / `process` | non-virtual | `bool` | **only** on their own class |
| `~Person` | virtual | — | directory may delete through base |

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| directory | 1 of each | three introductions with correct roles |
| enrollment cap | 7th enroll | **false** |
| teaching cap | 5th teach | **false** |
| role isolation | `Person* p = &student; p->enroll(...)` | compile error (contract isolation) |
| abstract refusal | `Person p;` | compile error |

**Solution (condensed — full pattern now familiar).**

```cpp
class Person {
public:
    Person(const string& n, int id) : name(n), personId(id) {}
    virtual string role() const = 0;
    void introduce() const {
        cout << name << " (#" << personId << ") — " << role() << "\n";
    }
    virtual ~Person() = default;
private:
    string name;
    int personId;                  // private + shared via nothing: derived adds their own
};

class Student : public Person {
public:
    Student(const string& n, int id) : Person(n, id) {}
    string role() const override { return "Student"; }
    bool enroll(const string& code) {
        if ((int)courses.size() >= 6 || hasCourse(code)) return false;
        courses.push_back(code);
        return true;
    }
private:
    vector<string> courses;
};
// Teacher (max 4, teach()), Staff (department, process()) follow the same shape.
```

**Explanation.** The smallest honest base (name, id, one role hook — DP7's verdict built), role-specific operations *sealed into their classes* (the R4 compile-error test is the design's teeth), and the shared `introduce()` calling the hook — the same three-line template method as every lab here, which is the point: **one pattern, endlessly reusable**. The portal never learns what a Student can do; it only asks people to introduce themselves.

**Composition check.** Could Person be composed? A `Role` interface held by a `Person` shell would make roles swappable at runtime — a real design for a system where people *change* roles (student → teacher); this portal's roles are fixed at birth, so inheritance's fixity costs nothing. Write both verdict sentences — the exercise is the *choice*, not the code.

**Extensions.** ⭐ Add `GraduateStudent : Student` (teaches labs *and* enrolls) — one inheritance edge, and decide which additional interface it needs. ⭐⭐ Convert roles to runtime-swappable composition and re-run the directory — then write the paragraph on which version this university should ship, given real academic careers.

---

## Where next

- [The Media Library mini-project](miniproject.md): every pattern from these five labs, one system.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
