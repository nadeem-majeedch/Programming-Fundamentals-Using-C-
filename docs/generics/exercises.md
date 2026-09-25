---
title: "Generics Exercises — 20 Drills in Two Parts"
description: "Part A operator overloading, Part B templates — each with a separated solution."
---

# Exercises — 20 drills, two parts

> [← Module home](index.md) · Attempt before opening solutions — separated below each part. Compile with `-Wall -Wextra`; several drills become compiler conversations.

## Part A — Operator overloading (E1–E10)

- **E1 ★** Write `class Duration` (seconds, `long long`) with `operator+` as a **non-member** returning by value, and demonstrate the naked call `operator+(a, b)` produces the same result.
- **E2 ★** Add `operator+=` as a member returning `Money`-style `Duration&`, and re-express E1's `+` through it. Verify chaining: `(d1 += d2) += d3;`.
- **E3 ★** Write `operator<<` for `Duration` printing `mm:ss` (e.g. `75 → 01:15`). Watch the two-digit padding — and the return-the-stream rule.
- **E4 ★★** Write the full comparison family for `Duration` — `==`, `!=`, `<`, `>`, `<=`, `>=` — with exactly two touching raw data. Test both argument orders against an `explicit`-free converting constructor, then add `explicit` and state what breaks and why.
- **E5 ★★** Write `operator>>` for `Duration` that commits only on a successful read, and prove the no-commit rule: feed it `abc`, check the object unchanged.
- **E6 ★★** A classmate writes `Money& operator+(const Money& a, const Money& b) { Money r = ...; return r; }`. Diagnose precisely what dangles, when the symptom appears, and give the two correct signature families (which returns a value; which returns a reference — and to *what*).
- **E7 ★★** Write `class Fraction` (num, den; den validated non-zero) with `+` (cross-multiply), `==` (cross-multiply — note `1/2 == 2/4` must hold), and `<`. Test `Fraction(1,2) == Fraction(2,4)` and `Fraction(1,3) < Fraction(1,2)`.
- **E8 ★★** Explain — with the two failing expressions written out — why `operator<<` and `operator[]` have *opposite* member/non-member requirements.
- **E9 ★★★** Write `class Vector2` (x, y) with `+`, `-`, unary `-`, `*` for **both** scalar orders (`v * 2` and `2 * v`), and `==`. Which overloads *must* be non-members, and which have a free choice?
- **E10 ★★★** A `Temperature` class has `explicit Temperature(double c)` and a member `bool operator==(double c) const`. Its author complains `temp == 36.6` works but `36.6 == temp` doesn't. Diagnose the asymmetry, then redesign: the non-member pair, the `explicit` interaction, and the one-sentence rule.

### Solutions A

**S1.** `Money`-pattern non-member: `Duration operator+(const Duration& a, const Duration& b) { return Duration(a.getSeconds() + b.getSeconds()); }` — the naked call compiles and matches, proving the costume (Lesson 1 §1's whole point in one line).

**S2.** `Duration& operator+=(const Duration& rhs) { seconds += rhs.seconds; return *this; }` and `+` becomes `Duration r(a); r += b; return r;` — the one-authoritative-logic idiom. Chaining verified: the reference return keeps `(d1 += d2) += d3` on one object.

**S3.** `ostream& operator<<(ostream& out, const Duration& d) { long long m = d.getSeconds() / 60, s = d.getSeconds() % 60; out << (m < 10 ? "0" : "") << m << ":" << (s < 10 ? "0" : "") << s; return out; }` — padding by hand (the Foundations module's string-vs-number lesson), stream returned.

**S4.** Ground truth: `==` and `<` on seconds; derived: `!=` = `!(a==b)`, `>` = `b<a`, `<=` = `!(b<a)`, `>=` = `!(a<b)` — six operators, two lines of raw logic. With a converting constructor, both `d == 75` and `75 == d` compile (non-members convert either side); with `explicit`, both fail — the explicit overload pairs (`==(const Duration&, long long)` and its swap) are then the honest door, and the *rule*: decide the conversion policy first, write the comparison set to match, test both orders.

**S5.** `istream& operator>>(istream& in, Duration& d) { long long s; if (in >> s) d = Duration(s); return in; }` — the commit-on-success rule; after feeding `abc`, `d` is unchanged because `in >> s` failed before any assignment. (The Files module's read-in-condition, parameter scale.)

**S6.** The reference binds to the local `r`, which **dies at return** — a dangling reference; the symptom appears at the *caller* (reading the destroyed object: garbage, intermittently correct, anything — UB). Correct families: value-returning binary arithmetic — `Money operator+(const Money&, const Money&)`; and reference-returning only where the object outlives the call — `Money& operator+=(...) { ...; return *this; }` and stream operators returning their stream parameter.

**S7.** `bool operator==(const Fraction& a, const Fraction& b) { return a.num * b.den == b.num * a.den; }` and `<` similarly cross-multiplied (positive denominators assumed — validated at birth: den > 0, else reject/negate both, documented). Tests: `(1,2)==(2,4)` true; `(1,3) < (1,2)` — 1·2 < 1·3 → true. Note the honest limitation: cross-multiplication can overflow big numerators — the comment naming the boundary is part of the answer.

**S8.** `operator<<` is **forced non-member**: its left operand is `ostream&` — a type you cannot reopen to add members. `operator[]` is **forced member**: the language requires it, because subscripting must access the object's own interior (and its left operand *is* the object). Opposite requirements, same cause: *who owns the left operand?*

**S9.** `operator-` (binary) and `==` as non-members; `2 * v` **must** be a non-member (the left operand is a scalar — members can't serve it); `v * 2` may be a member or non-member (write the non-member pair for symmetry, or keep the member and add one non-member — state the choice); unary `-` is naturally a member (`Vector2 operator-() const { return Vector2(-x, -y); }`). `+` mirrors `-`. The full set with `explicit`-free... note: `Vector2` takes two arguments, so no one-arg conversion issue — a small designed-in mercy worth noticing.

**S10.** The member's left operand is fixed as `Temperature` — `36.6 == temp` needs a `Temperature` on the *left*, and `explicit` blocks the silent `double → Temperature` conversion that would have made the non-member pair work without overloads. Redesign: keep `explicit`, add the non-member pair `bool operator==(const Temperature&, double)` and `bool operator==(double, const Temperature&)` — both express the *same* ground truth through one helper (`bool equalsC(double c) const`). The sentence: *explicit conversions plus symmetric comparison = write both orders deliberately; implicit conversions plus non-members = one overload serves both.*

## Part B — Templates (E11–E20)

- **E11 ★** Write `template <typename T> const T& myMin(const T& a, const T& b)` and stamp it for `int`, `double`, and `string`. State the one-operation contract in a comment at the template head.
- **E12 ★** Demonstrate the stamping model: instantiate `myMin<int>` two ways — implicit deduction and explicit `myMin<int>(...)` — and explain what "the template is not code until stamped" means in one sentence.
- **E13 ★★** Write `template <typename T> T absMax(const T& a, const T& b)` (the larger of |a|, |b|) and stamp it for `int` and `double`. List the *contract* — it grew: name every operation the body demands (`<`, unary `-`, copying, constructing from int 0).
- **E14 ★★** Show the deduction failure `myMin(3, 4.5)` and its three cures (matching literals; explicit `T`; the two-parameter template `myMin2<A, B>` returning the smaller — write it, and state what its return type must be and why `A` is the honest answer).
- **E15 ★★** Write `template <typename T> int countGreater(const T arr[], int n, const T& threshold)` — stamp it for `int` and for the `Money` class from Lesson 1 (which needed one operator added — name it).
- **E16 ★★** Extend Lesson 2's `Box<T>` with `max() const -> T` (throws on empty — the contract `<` again) and `contains(const T& item) const -> bool` (a linear search using `==` — the contract grows by one; document both requirements at the head).
- **E17 ★★** `Box<const char*>` vs `Box<string>`: explain what `contains("hi")` does in each (pointer comparison vs value comparison — the Strings module's `==` lesson returning at template scale) and state the course rule about generic containers holding values.
- **E18 ★★★** Write `template <typename T> void swapValues(T& a, T& b)` and instantiate it for `Money`, then explain what requirements `swapValues` makes (copy assignment, copy construction — and why a resource-owning `T` with a broken copy poisons the swap; the Inheritance module's D4 lesson generalized).
- **E19 ★★★** Write `template <typename T, int N> class FixedArray` (compile-time size: `T data[N]`, no `new`, bounds-checked `at`, `size()` constant). Stamp it for `FixedArray<double, 5>` and `FixedArray<Box<int>, 3>`. What does the second stamp demand of `Box<int>`?
- **E20 ★★★** A classmate's template `template <typename T> T middle(const T arr[], int n) { return arr[n / 2]; }` compiles for `int` but the reviewer demands a contract comment and a negative-n guard. Write the contract (copyable, indexable, returns by value), the guard, and — the design question — whether returning `const T&` is legal here. (Careful: for which call shapes does the reference dangle?)

### Solutions B

**S11.** `// Contract: T supports operator< (strict weak ordering)` — the body `(a < b) ? a : b` demands exactly that; stamps verified for three types. The comment *is* the discipline (Lesson 2 §3's step 1).

**S12.** Implicit: `myMin(3, 9)` deduces `T=int`. Explicit: `myMin<int>(3, 9)` names it (needed when deduction can't agree, e.g. mixed literals). The sentence: *a template is a pattern; each distinct `T` used generates a fresh ordinary function from it — the genericity is spent at compile time, before the program runs.*

**S13.** `T absMax(const T& a, const T& b) { T za = a < T(0) ? -a : a; T zb = b < T(0) ? -b : b; return za < zb ? zb : za; }` — demands: `<` (twice), unary `-`, construction from `T(0)` (a zero value), copy construction/assignment (the locals). The point: the contract grew from one operation to four — frugality is genericity (Lesson 2 §3's step 2), and the *comment* must list all four.

**S14.** `myMin(3, 4.5)`: deduction finds `T=int` from arg 1 and `T=double` from arg 2 — no single `T`, compile error. Cures: `myMin(3.0, 4.5)`; `myMin<double>(3, 4.5)`; or `template <typename A, typename B> A myMin2(const A& a, const B& b) { return a < b ? a : b; }` — return type `A` (the first parameter's type) is the honest choice because the *smaller value* is returned as one of the two argument types and the caller names the conversion they want; a "common type" computation exists next course.

**S15.** The template demands `<` and `==`... precisely: the body compares `arr[i] > threshold` — so the contract is `>` (or `<` flipped), plus copying for the reference parameter. `Money` needed `operator>` (which Lesson 1's derivation from `<` supplies): `int count = 0; for (int i = 0; i < n; i++) if (threshold < arr[i]) count++;` — written with `<` only, so `Money`'s existing `<` suffices. The design note: *choosing `<`-only spelling kept the contract at one operation* — the frugality principle in action.

**S16.** `T max() const { if (count == 0) throw out_of_range("Box::max"); const T* best = &data[0]; for (int i = 1; i < count; i++) if (best[0] < data[i]) best = &data[i]; return *best; }` and `contains`: linear with `==`. Head comment: *"`T` requires: `<` (strict weak order) for `max`; `==` for `contains`; copyable for `add`."* — three named requirements, testable independently.

**S17.** `Box<const char*>` compares **pointers** — `contains("hi")` checks whether the *same address* is stored (usually false even when equal text exists); `Box<string>` compares **values** (`==` on `string` compares characters). The rule: generic containers hold *values* (`string`), not raw pointers to literals — and when pointers are unavoidable, the comparator must dereference (next course's comparator vocabulary).

**S18.** `template <typename T> void swapValues(T& a, T& b) { T tmp(a); a = b; b = tmp; }` — demands copy construction (`T tmp(a)`) and copy assignment (twice). A resource-owning `T` whose copies share resources (the SessionLog of the Inheritance module's D4) poisons the swap: copies alias one block, double-delete at death. The generalization: *a template's requirements include the type's copy semantics — generic code is only as safe as the least safe `T` it serves.*

**S19.** `template <typename T, int N> class FixedArray { public: FixedArray() {} const T& at(int i) const { if (i < 0 || i >= N) throw out_of_range("FixedArray"); return data[i]; } static constexpr int size() { return N; } private: T data[N]; };` — no heap, size in the type. `FixedArray<Box<int>, 3>` demands of `Box<int>`: **default-constructible** (the array's elements are born) and copy-assignable (`at` returns refs; assignment inside the array if ever moved) — the Lesson 2 scope note's "stamps compose," now with the requirement spelled.

**S20.** Contract: *"`T` must be copy-constructible (return by value) and support array indexing; `n >= 1` required; for `n == 0` the function throws."* Guard: `if (n <= 0) throw out_of_range("middle: empty"); return arr[n / 2];`. The design question: `const T&` is legal **only when the array outlives the use of the reference** — for `middle(arr, n)` reading immediately, it's fine and cheaper; stored or returned further, it dangles if the caller passed a temporary array. The honest answer states both shapes — the reference-return question from the Inheritance module (S17), one last appearance.

## Where next

- [Debugging hunts](debugging.md): eight broken operators and templates.
- [The five labs](labs.md): Complex numbers to the Student comparison.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
