---
title: "Generics Labs — 5 Practical Builds"
description: "Five labs — Complex numbers, Generic calculator, Generic maximum/minimum, Generic container, Student/result comparison — each with requirements, interface, test cases, solution, and explanation."
---

# Generics Labs — five builds

> [← Module home](index.md) · Attempt each lab's interface and test table first. Every lab: scenario → requirements → interface → test cases → solution → explanation → ⭐ extensions.

---

## Lab 1 — Complex number class

**Scenario.** A signals course needs complex arithmetic that *reads like mathematics*: `c1 + c2`, `c1 * 2`, comparisons of magnitudes, and printing like `3+4i`.

**Requirements.**

- R1 — `class Complex` (re, im — `double`), constructor defaulting to `0+0i`.
- R2 — Operators: `+`, `-` (binary), unary `-`, `*` (complex multiplication: `(a+bi)(c+di) = (ac−bd) + (ad+bc)i`), `*` by a real scalar (both orders), `==`/`!=`, `<` **by magnitude only** (documented!), `<<`.
- R3 — All binary operators non-members returning by value; `<<` returns the stream; the magnitude-`<` contract comment states exactly what "less than" means here.
- R4 — A test main exercising every operator and both scalar orders.

**Interface.**

| Operator | Form | Returns | Notes |
| --- | --- | --- | --- |
| `+`, `-` | non-member | `Complex` (value) | component-wise |
| `-` (unary) | member | `Complex` | negates both |
| `*` (complex) | non-member | `Complex` | the four-multiplication formula |
| `*` (scalar, both orders) | non-member | `Complex` | `c * 2` and `2 * c` both compile |
| `==`/`!=` | non-member | `bool` | component-wise exact |
| `<` | non-member | `bool` | **magnitude order** — the comment is part of the deliverable |
| `<<` | non-member | `ostream&` | `3+4i`, `-2+0i`, `0-1i` shapes |

**Test cases.**

| Case | Expression | Expected |
| --- | --- | --- |
| add | `(3+4i) + (1-2i)` | `4+2i` |
| multiply | `(3+4i) * (1+2i)` | `-5+10i` (3−8, 6+4) |
| scalar both orders | `(3+4i) * 2` and `2 * (3+4i)` | `6+8i` each |
| equality | `(3+4i) == (3+4i)` | true |
| magnitude order | `(3+4i) < (1+1i)` | **false** (5 vs √2) |
| unary minus | `-(3+4i)` | `-3-4i` |
| print | `Complex(-2, 0)` | `-2+0i` |

**Solution (the load-bearing parts).**

```cpp
class Complex {
public:
    Complex(double r = 0, double i = 0) : re(r), im(i) {}
    double getRe() const { return re; }
    double getIm() const { return im; }
    Complex operator-() const { return Complex(-re, -im); }
private:
    double re, im;
};

Complex operator+(const Complex& a, const Complex& b) {
    return Complex(a.getRe() + b.getRe(), a.getIm() + b.getIm());
}

Complex operator*(const Complex& a, const Complex& b) {
    return Complex(a.getRe() * b.getRe() - a.getIm() * b.getIm(),
                   a.getRe() * b.getIm() + a.getIm() * b.getRe());
}

Complex operator*(const Complex& c, double k) { return Complex(c.getRe() * k, c.getIm() * k); }
Complex operator*(double k, const Complex& c) { return c * k; }   // expressed through the pair

// Contract comment — the deliverable:
// operator< orders Complex by MAGNITUDE (sqrt(re²+im²)), not by any
// component-wise rule. This is a total order on magnitudes; it is NOT
// the ordering any numeric field provides. Do not use with algorithms
// expecting ordinary numeric order without reading this note.
bool operator<(const Complex& a, const Complex& b) {
    return a.getRe() * a.getRe() + a.getIm() * a.getIm()
         < b.getRe() * b.getRe() + b.getIm() * b.getIm();    // squared magnitudes — no sqrt needed
}

ostream& operator<<(ostream& out, const Complex& c) {
    out << c.getRe() << (c.getIm() < 0 ? "" : "+") << c.getIm() << "i";
    return out;
}
```

**Explanation.** Every form choice from Lesson 1's table, in one class: non-member binaries (symmetry — note `2 * c` *requires* it), a member unary, the comparison with its **contract in writing** (the R3 deliverable — DP3's lesson: a symbol with a non-standard meaning must say so), and squared magnitudes avoiding `sqrt` (the math habit: compare squares). The scalar pair expressed one-through-the-other is the DRY rule.

**Extensions.** ⭐ Add `conjugate()` and `/` (complex division: multiply by the conjugate of the denominator, divide by its squared magnitude — guard the zero case). ⭐⭐ Template it: `template <typename T> class Complex<T>` and stamp for `float` and `long double` — list what `T` must support (the contract grows: `+ - * / <`, copyable).

---

## Lab 2 — Generic calculator

**Scenario.** A template-based four-function calculator: the *same* driver runs on `int`, `double`, and `Money` — because `Money` (Lesson 1) brought its operators.

**Requirements.**

- R1 — `template <typename T> class Calculator`: stores a running value; methods `reset(const T& seed)`, `add(const T&)`, `subtract(const T&)`, `multiply(const T&)`, `current() const`.
- R2 — The **contract comment** at the class head names every requirement `T` must meet (`+ - *`, copyable, `<<`-printable for the demo).
- R3 — `main` runs the identical command sequence on all three stamps and prints each result.
- R4 — Honest scope: no division (integer division's truncation would make the three stamps disagree — say so in a comment).

**Test cases.**

| Case | Commands | int | double | Money |
| --- | --- | --- | --- | --- |
| add chain | reset(10), add(5), add(2) | 17 | 17 | 17.00 |
| multiply | reset(3), multiply(4) | 12 | 12 | 12.00 |
| subtract to negative | reset(2), subtract(9) | −7 | −7 | −7.00 |

**Solution.**

```cpp
// Contract for T: copy-constructible; supports +, -, * with its own type
// (each returning T); printable with operator<<. No division: truncating
// integer division would make the int stamp disagree with Money/double.
template <typename T>
class Calculator {
public:
    explicit Calculator(const T& seed) : value(seed) {}
    void reset(const T& seed) { value = seed; }
    void add(const T& x)      { value = value + x; }
    void subtract(const T& x) { value = value - x; }
    void multiply(const T& x) { value = value * x; }
    const T& current() const { return value; }
private:
    T value;
};
```

**Explanation.** The calculator is *pure contract*: it never touches a field of `T`, never branches on a type — it just demands the arithmetic surface and uses it. Money qualifies *because Lesson 1 built its operator set* — the two lessons of this module meeting. The no-division comment is the frugality principle: every operation added to the class is a requirement added to every `T`, and integer division is a *semantic* trap, not just a missing operator.

**Extensions.** ⭐ Add `apply(const T& x, char op)` dispatching on the op character — and defend whether a switch on `char` inside a generic class is a contract violation. ⭐⭐ Stamp it with `Duration` (Lab E3's class) — which operator did you have to *remove* from the contract comment because Duration lacks `*`?

---

## Lab 3 — Generic maximum/minimum toolkit

**Scenario.** The Algorithms module's max/min hunting, generalized once and for all: values, arrays, and (by pointer) the *index* question.

**Requirements.**

- R1 — `myMax(a, b)`, `myMin(a, b)` — the pair from Lesson 2, contract-commented (`<`, strict weak order).
- R2 — `maxOf(const T arr[], int n) -> T` and `maxIndexOf(const T arr[], int n) -> int` (−1 when empty) — stamp for `int`, `double`, `string`, and `Money`.
- R3 — `minMax(const T arr[], int n, T& lo, T& hi)` — the Functions module's two-output pattern, generic; single pass, both outputs.
- R4 — Verify `maxOf` on `Money` needs **no new operators** (Lesson 1's `<` already serves) — and say so in the write-up.

**Test cases.**

| Case | Input | Expected |
| --- | --- | --- |
| values | myMax(3, 9), myMin("pear", "apple") | 9, "apple" |
| array max | {2, 9, 4} int | 9 |
| index | {2, 9, 4} | 1 |
| strings | {"pear", "apple", "fig"} max | "pear" (lexicographic) |
| money | {1500, 250, 9900} paisa | 9900 |
| empty | maxOf(anything, 0) | throws (guarded) |
| minMax | {3, 1, 4, 1, 5} | lo=1, hi=5 |

**Solution (the two new shapes).**

```cpp
// Contract: T supports < (strict weak ordering); copyable.
template <typename T>
T maxOf(const T arr[], int n) {
    if (n <= 0) throw out_of_range("maxOf: empty");
    T best = arr[0];                       // seed from the first element (D8's lesson)
    for (int i = 1; i < n; i++)
        if (best < arr[i]) best = arr[i];
    return best;
}

template <typename T>
int maxIndexOf(const T arr[], int n) {
    if (n <= 0) return -1;
    int bestIdx = 0;
    for (int i = 1; i < n; i++)
        if (arr[bestIdx] < arr[i]) bestIdx = i;   // track the INDEX (Arrays module rule)
    return bestIdx;
}

template <typename T>
void minMax(const T arr[], int n, T& lo, T& hi) {
    if (n <= 0) throw out_of_range("minMax: empty");
    lo = hi = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] < lo) lo = arr[i];
        if (hi < arr[i]) hi = arr[i];
    }
}
```

**Explanation.** The seed-from-first-element pattern (the Algorithms module, generic dress); index tracking stays in the *index* version rather than coupling the two answers; `minMax` is one pass with two reference outputs — the Functions module's output-parameter pattern, now type-independent. The Money observation is the module's thesis: *generic code is a reward for well-behaved types.*

**Extensions.** ⭐ Add `secondLargest(arr, n, T& out) -> bool` (the arrays module's distinct-second logic, generic). ⭐⭐ Stamp `minMax` with `Complex` (Lab 1) and reconcile the magnitude-`<` contract with the toolkit's comment — what does the *composition* of two honest contracts mean here?

---

## Lab 4 — Generic container-like class

**Scenario.** Lesson 2's `Box<T>` grown to course-grade: the container the OOP module's roster wanted to be, for any type.

**Requirements.**

- R1 — `template <typename T> class Box`: `explicit Box(int capacity)`; `add`, `removeAt`, `at` (throwing), `size`, `contains`, `max` (pointer-or-nullptr — the E20/D8 design), `operator<<`.
- R2 — The **full contract comment** ranking requirements (copyable → assignable → `==` → printable → `<`), per member (the DP6 review's ranking, implemented).
- R3 — Copying deleted (Challenge C5's posture) with the ownership comment.
- R4 — Stamp for `int`, `string`, and `Money`; each stamp's demo exercises every member it *can* — and names which members Money can't serve (none, if Lesson 1 was complete — verify).

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| add + size | 3 adds | size 3 |
| bounds | at(3) on size-3 | throws |
| contains | contains("fig") | true; contains("kiwi") false |
| max | Box<int>{2,9,4} | pointer to 9 |
| max on empty | max() | nullptr |
| remove shift | removeAt(0) on {2,9,4} | {9,4}, size 2 |
| copy refusal | `Box<int> b = a;` | compile error (deleted) |
| money | add Money(250), max | pointer to it |

**Solution (the new members).**

```cpp
// Box<T> — contract by member:
//   add        : T copy-constructible, copy-assignable
//   removeAt   : T copy-assignable (shifts left)
//   at         : nothing beyond copyability
//   contains   : T supports == (value equality)
//   max        : T supports < (strict weak order) — returns nullptr when empty,
//                so T need NOT be default-constructible
//   operator<< : T printable
// Ownership: a Box owns its heap block exclusively; copying is deleted.
// Pass Boxes by reference or const&. (Rule of three: next course.)
template <typename T>
class Box { /* Lesson 2's class, plus: */ };

template <typename T>
const T* Box<T>::max() const {
    if (count == 0) return nullptr;
    const T* best = &data[0];
    for (int i = 1; i < count; i++)
        if (*best < data[i]) best = &data[i];
    return best;
}
```

**Explanation.** The pointer-returning `max` is the lab's design centrepiece: a value-returning `max()` on empty needs a sentinel — which forces `T` to be default-constructible (`T()`) — a requirement *rare and expensive* (DP6's ranking). Returning `const T*` (nullptr = empty) deletes that requirement entirely: the interface shape changed so the contract could shrink. That trade — *signature design in service of genericity* — is the module's most transferable idea.

**Extensions.** ⭐ Add `removeValue(const T& v) -> bool` (first match, shift — reuses `contains`'s `==`). ⭐⭐ Add `Box(const Box&)` done *safely* (deep copy: allocate and copy the block) — the rule of three's first step, and re-run the copy test: which members did you write and why exactly three?

---

## Lab 5 — Student/result comparison

**Scenario.** A results office compares students: by average, by roll number, by name — and a generic "is A ahead of B" question must serve all three *without* three copies of the comparison code.

**Requirements.**

- R1 — Reuse the OOP module's `Student` (name, rollNo, three marks, `average() const`, `grade()`).
- R2 — Design the comparison surface: which operators does `Student` itself get (and with *which* default ordering — decide and document), and how do the other two orderings get served?
- R3 — A generic `sortBy(Student arr[], int n, ...)` — design the third parameter honestly: the Inheritance module's function-pointer answer (`bool (*less)(const Student&, const Student&)`) or comparator classes — and implement **two** orderings (by average descending, by name ascending) through it.
- R4 — Prove the design: sort the same six students both ways; the *same* `sortBy` serves both.

**Test cases.**

| Case | Action | Expected |
| --- | --- | --- |
| default ordering documented | two students, equal averages | tie broken by roll (or by name) — *per your documented rule* |
| sort by average | 6 students | descending averages |
| sort by name | same 6 | ascending names |
| same sortBy | both runs | identical code path |
| stability note | equal averages, different names | document whether original order survives (the Algorithms module's stability lab, met again) |

**Solution (the design's shape).**

```cpp
// Student's OWN operators: the natural, dominant ordering — by roll number
// (identity order; unique keys; the roster invariant's order).
bool operator<(const Student& a, const Student& b) {
    return a.getRollNo() < b.getRollNo();
}
bool operator==(const Student& a, const Student& b) {
    return a.getRollNo() == b.getRollNo();
}

// The alternative orderings are NOT operators — they are named functions:
bool byAverageDesc(const Student& a, const Student& b) {
    return a.average() > b.average();
}
bool byNameAsc(const Student& a, const Student& b) {
    return a.getName() < b.getName();
}

// The generic sort (selection sort — the Algorithms module's, genericized):
// Contract: T copy-assignable; the comparator is a strict weak ordering on T.
template <typename T>
void sortBy(T arr[], int n, bool (*less)(const T&, const T&)) {
    for (int start = 0; start < n - 1; start++) {
        int m = start;
        for (int i = start + 1; i < n; i++)
            if (less(arr[i], arr[m])) m = i;
        if (m != start) { T t = arr[start]; arr[start] = arr[m]; arr[m] = t; }
    }
}
// calls:
//   sortBy(students, 6, byAverageDesc);
//   sortBy(students, 6, byNameAsc);
```

**Explanation.** The lab's design lesson, in three moves: (1) a type gets operators for its **one natural ordering** (roll number — identity, unique, stable meaning) and *not* for every question anyone asks (DP5's line: overload where one honest behaviour exists); (2) alternative orderings are **named functions**, not operators — `byAverageDesc` says what it means; (3) the generic `sortBy` with a comparator parameter is the bridge — the Algorithms module's C15 function-pointer sort, genericized, and the exact shape the standard library's `sort` runs on. The tie-break and stability notes are documentation deliverables, not afterthoughts.

**Extensions.** ⭐ Add a third comparator (by grade letter, then average) and chain two sorts to achieve it — and note what stability property the chained sorts depend on. ⭐⭐ Replace the function pointer with a small `Comparator` interface (the Inheritance module's pure-abstract form) and compare the two designs in a paragraph — the compile-time/runtime polymorphism divide from Lesson 2, in your own code.

---

## Where next

- [The syllabus's Stage F](../syllabus.md#stage-f--capstone): this module's vocabulary (`operator<<` on your types, contracts on template parameters) is what the Modern C++ Toolkit review assumes.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
