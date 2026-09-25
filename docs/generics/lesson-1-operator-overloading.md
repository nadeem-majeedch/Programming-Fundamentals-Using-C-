---
title: "Lesson 1 — Operator Overloading"
description: "Operators are functions; member vs non-member operators and the decision table; arithmetic, comparison, and stream operators; the rules and the mistakes gallery."
---

# Lesson 1 — Operator Overloading

> [← Module home](index.md) · [Lesson 2 — Templates →](lesson-2-templates.md)

## In this lesson you will learn

- that `a + b` is a **function call in costume** — and the strict rules that keep the costume honest
- when to write an operator as a **member** and when as a **non-member** (the decision table)
- **arithmetic** operators (and why they return by value), **comparison** operators (and the symmetric-argument problem), **stream operators** (and why they *cannot* be members)
- the mistakes gallery — the classic overloading sins

**You have used this feature all course.** `cout << x` is an overloaded operator call; `s1 + s2` on strings, `v[i]` on vectors — all overloadings the standard library wrote. This lesson puts you on the writing side.

---

## 1. Operators are functions — the costume revealed

```cpp
#include <iostream>
using namespace std;

class Money {
public:
    Money(long long paisa = 0) : paisa(paisa) {}
    long long getPaisa() const { return paisa; }
private:
    long long paisa;
};

// a + b  means  operator+(a, b)
Money operator+(const Money& a, const Money& b) {
    return Money(a.getPaisa() + b.getPaisa());
}

int main() {
    Money m1(1500), m2(250);
    Money sum = m1 + m2;                    // the costume
    Money same = operator+(m1, m2);         // ...and the naked call: identical
    cout << sum.getPaisa() << "\n";         // 1750
    return 0;
}
```

**Explanation.** `operator+` is an ordinary function whose *name* is the symbol. The expression `m1 + m2` compiles to the same call as the naked form. Everything you know about functions applies: parameters, `const&` conventions, return types, overloading (one name, many signatures). What's special is *notational reach* — your type now reads like the built-ins.

### The rules that keep the notation honest

1. **At least one operand must be a user-defined type.** You cannot redefine `int + int`, or invent `operator**`.
2. **No new operators.** Only the existing set (`+ - * / % == != < > <= >= << >> += -= [] () -> ++ --` and a few more).
3. **Arity is fixed.** `+` takes two operands; you can't make a ternary `+`.
4. **Precedence and associativity are fixed.** Your `operator<<` still binds looser than `+` — that's why `cout << 2 + 3` works but `cout << (2 & 3)` needs parentheses.
5. **Don't surprise.** The *cardinal rule*: an overloaded operator should behave the way the built-in does — `+` produces a new value without touching its operands; `==` is symmetric; `<<` appends to the stream. "Clever" meanings (`operator+` that saves to disk) are the mistakes gallery's first exhibit.

---

## 2. Member vs non-member — the decision table

The same `operator+` can be written two ways, and the choice is **structural, not stylistic**:

```cpp
// MEMBER: the left operand is *this
class Money {
public:
    Money operator+(const Money& rhs) const { return Money(paisa + rhs.paisa); }
    // this->paisa + rhs.paisa — callable as m1 + m2
};

// NON-MEMBER: both operands are named parameters
Money operator+(const Money& lhs, const Money& rhs);
```

| Operator | Form | Why |
| --- | --- | --- |
| `==  !=  <  <=  >  >=` | **non-member** (both `const&`) | **symmetry**: implicit conversions apply to *both* sides (`Money(5) == 5` works only as a non-member); non-members use the public interface, keeping the class's walls intact |
| `+  -  *  /` (binary arithmetic) | **non-member** (both `const&`) | same symmetry argument; returns a **new value by value** |
| `<<  >>` (streams) | **non-member** — *forced* | the left operand is `ostream&`/`istream&` — you cannot add members to `ostream` |
| `+=  -=  *=  /=` | **member** | the left operand *is mutated* — member access to the object's own state, returns `*this` by reference (chaining) |
| `[]` `()` `->` `=` | **member — forced** | the language requires membership for these |
| unary `+ - ! ~ ++ --` | member (usually) | they act on `*this` |

**The symmetry example, made concrete:** with a non-member `operator+(const Money&, long long)`, the expression `500 + m1` works (the conversion `Money(500)` applies to the *left* side, which members can never do — a member's left side is fixed as `*this`). Members can only ever serve `m1 + 500`. Write both directions, or make both operands `const Money&` and let conversions serve — the non-member form is the one that behaves like the built-ins.

---

## 3. Arithmetic operators — the `+`/`+=` pattern

The professional idiom: **implement the mutating operator as a member, then express the plain operator through it.**

```cpp
#include <iostream>
using namespace std;

class Money {
public:
    explicit Money(long long paisa = 0) : paisa(paisa) {}

    Money& operator+=(const Money& rhs) {       // member: mutates *this
        paisa += rhs.paisa;
        return *this;                            // chaining: (a += b) += c
    }

    long long getPaisa() const { return paisa; }
private:
    long long paisa;
};

// non-member, expressed through +=: no duplicated logic (the DRY rule, operator edition)
Money operator+(const Money& a, const Money& b) {
    Money result(a);
    result += b;
    return result;
}

// stream output — non-member because the LEFT operand is the stream
ostream& operator<<(ostream& out, const Money& m) {
    out << m.getPaisa() / 100 << "." << (m.getPaisa() % 100 < 10 ? "0" : "")
        << m.getPaisa() % 100 << " PKR";
    return out;                                   // MUST return the stream
}

int main() {
    Money a(1500), b(250);
    a += b;                       // a is now 17.50
    Money c = a + Money(100);     // new value; a unchanged
    cout << a << " | " << c << "\n";   // 17.50 PKR | 18.50 PKR
    return 0;
}
```

**Explanation of the three signatures:** `+=` returns `Money&` — a reference to `*this`, so chains mutate one object (the Inheritance module's reference-return lesson, S17). `+` returns `Money` **by value** — a new object; returning a reference here would dangle. `<<` returns `ostream&` — the OOP module's chaining requirement, now stated as *why*: `(cout << a) << b` needs the inner result to be the stream.

> **The `explicit` note:** `explicit Money(long long)` blocks *silent* `int → Money` conversions — which makes accidental comparisons like `money == 5` compile-fail instead of compute. The course's standing rule: **one-argument constructors get `explicit` unless you truly want conversion** — and the comparison section below shows why.

---

## 4. Comparison operators — the contract and the symmetry problem

**The contract `==` must satisfy** (the Inheritance module's substitutability thinking, operator edition): *symmetric* (`a == b` ⇔ `b == a`), *self-consistent* (`a == a`), *transitive* — and every other operator must agree with it (`a != b` is exactly `!(a == b)`; if `a < b` then not `a > b`).

```cpp
class Money {
public:
    // ...as above...
};

bool operator==(const Money& a, const Money& b) {
    return a.getPaisa() == b.getPaisa();
}
bool operator!=(const Money& a, const Money& b) {
    return !(a == b);                       // define ONE, derive the other
}
bool operator<(const Money& a, const Money& b) {
    return a.getPaisa() < b.getPaisa();
}
bool operator>(const Money& a, const Money& b)  { return b < a; }
bool operator<=(const Money& a, const Money& b) { return !(b < a); }
bool operator>=(const Money& a, const Money& b) { return !(a < b); }
```

**Explanation.** Write `==` and `<` as the *ground truth* (the only two that read raw data), derive the other four from them — the DRY rule applied to logic: one authoritative answer per question, five derived ones that *cannot drift*. This matters doubly because sorted collections (the Algorithms module's binary search) assume `<` is a **strict weak ordering** — consistent, irreflexive, transitive. A sloppy `<` silently corrupts sorts.

### The symmetric-argument problem — where members lose

```cpp
bool operator==(const Money& a, long long paisa) {
    return a.getPaisa() == paisa;
}
// now ALL of these work:
//   m == 1500        (Money, long long)
//   1500 == m        (long long, Money — the swapped form)
//   m == Money(1500) (via the converting constructor — unless it's explicit)
```

Had `==` been a **member**, `1500 == m` would not compile (the left operand would have to *be* a Money). The non-member form lets conversions apply to both sides — the structural argument from §2, now with a test case. Note the honest interaction with `explicit`: with the constructor explicit, `m == 1500` needs this explicit overload pair; without it, the conversion serves. **Decide deliberately and test both orders** — the [Student-comparison lab](labs.md) makes you.

---

## 5. Stream operators — the full anatomy

You met `operator<<` in the OOP and Inheritance modules; this is the complete statement of its anatomy and rules:

```cpp
ostream& operator<<(ostream& out, const Money& m);   // read: left stream, right your type, both const-safe
istream& operator>>(istream& in, Money& m) {         // read: the target is MUTATED — no const
    long long p;
    if (in >> p) m = Money(p);                        // only commit on a successful read
    return in;
}
```

The four rules: (1) **non-member** — the left operand is a stream you can't modify; (2) output takes `const&` (no copy, no mutation); **input takes plain `&`** (it must mutate the target); (3) **return the stream** by reference — chaining; (4) input operators commit only after the read succeeds (the Files module's test-the-read discipline, at parameter scale).

---

## 6. The mistakes gallery

1. **Surprise semantics.** `operator+` that mutates, `operator==` that ignores a field, `operator<` that isn't transitive. The cardinal rule again: built-in behaviour is the spec.
2. **Returning references to locals.** `Money& operator+(...) { Money r; ...; return r; }` — a dangling reference. `+` returns **by value**; only `+=`-family and `<<`/`>>` return references (to `*this` / the stream).
3. **Asymmetric comparison members.** `bool operator==(long long)` as a member breaks `1500 == m`. Comparisons are non-members.
4. **Forgetting the return in `<<`.** `out << ...;` without `return out;` breaks every chain — and the *compiler* only complains at the second `<<`.
5. **Overloading without need.** A `Money` class that overloads `operator[]` "just in case" — the Inheritance module's D8 lesson applies verbatim: operators are design decisions, not decoration.
6. **Inconsistent pairs.** `==` written, `!=` forgotten (then `!=` uses a *different* rule somewhere); `<` and `>` disagreeing. Derive the family from two, always.
7. **`explicit` forgotten.** A converting one-arg constructor turns `if (money == 5)` into a silent truth. One-arg constructors: `explicit` by default.

---

## Check yourself

- Why can't `operator<<(ostream&, const Money&)` be a member of `Money`? (the left operand is the stream; members fix their left operand as `*this` — you can't add members to `ostream`)
- What does `Money operator+(const Money&, const Money&)` return *by value*, and why can't it return a reference? (a new object; the local would die at return, dangling the reference)
- Which two comparison operators carry ground truth in the course's idiom, and what do the other four derive from? (`==` and `<`; the rest are negations and argument-swaps)

## Where next

- [Lesson 2 — Templates →](lesson-2-templates.md): the same shape of code, written once for every type.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
