---
title: "Design Problems — 6 Operator/Template Judgements"
description: "Six design problems on operator sets, explicit conversions, and generic contracts — with separated design reviews."
---

# Design Problems — 6 judgements

> [← Module home](index.md) · Design on paper first: (1) the complete operator set you'd provide, (2) member vs non-member per operator with the *reason*, (3) the conversion policy (`explicit` or not), (4) for templates: the contract comment verbatim. The [reviews](#design-reviews) grade the reasoning.

---

- **DP1 ★ — The Money operator set.** A `Money` class (paisa, `long long`) must support: adding two amounts, adding a whole rupee count, comparing any two amounts, printing to a stream, and reading from a stream. Design the complete operator set — which operators, which forms, which conversions allowed.

- **DP2 ★ — The one-way string.** `class Name` wraps a `std::string` and must compare equal to plain string literals (`name == "Aisha"`) and print. Design the operator set and conversion policy — then answer whether `Name` should convert *from* string at all.

- **DP3 ★★ — The range type.** Design `class Range` (lo, hi) needing: containment tests (`r.contains(x)`, and the mathematical notation `x < r` for "x is inside r"), iteration-by-index is *not* needed, equality, and printing. The design question: is overloading `<` for containment honest — or a gallery-#1 violation?

- **DP4 ★★ — The generic absolute-value.** Design `template <typename T> T myAbs(const T& v)` for *any* numeric-like type. Enumerate the contract completely, then answer: can one template honestly serve both `int` and a fixed-point `Decimal` class whose `-` is expensive — or is that two functions?

- **DP5 ★★ — The generic pair.** Design `template <typename A, typename B> class Pair` holding two possibly-different types: construction, `first()`/`second()` (const-correct), equality. The design questions: which operators should `Pair` overload *itself* (hint: what does `==` on a `Pair<Money, string>` demand of `Money`?), and why is a printing `operator<<` for Pair reasonable while an arithmetic `+` is not?

- **DP6 ★★★ — The generic container's public face.** Lesson 2's `Box<T>` must grow into a course-grade container: add, remove, at, size, contains, max, and stream output. Design the full interface — for each member: signature, contract contribution to `T`, and const-correctness — then rank the requirements from "almost every type satisfies" to "rare and expensive," and state which members you'd *cut* to keep `Box` usable for the widest set of types.

---

<a name="design-reviews"></a>
## Design reviews — after your own sketch

**R1 — The Money operator set.** `explicit Money(long long paisa)` (conversions deliberate — the accidental `money == 5` must not compile); `Money operator+(const Money&, const Money&)` non-member (symmetry, value return); `Money& operator+=(const Money&)` member (mutates `*this`, chains); **no** `operator+(const Money&, long long)` — with `explicit`, mixed arithmetic *can't* happen silently, and `money + Money(500)` is honest; comparison family from `==` and `<` (non-members, symmetric, derived four); `<<`/`>>` non-members with the commit-on-success rule. The review's extra point: the *absent* operators are part of the design — with `explicit`, fewer overloads and no silent conversions is the stronger posture.

**R2 — The one-way string.** `explicit`-free question answered: **convert from literal: yes, implicitly is defensible** (`Name n = "Aisha";` reads naturally and the type adds no invariants worth guarding) — but then `==` must be non-members on `(const Name&, const Name&)` so both sides convert and `name == "Aisha"` and `"Aisha" == name` both hold with *one* overload. Convert *to* string: only via an explicit `str() const` getter — an implicit `operator const string&` would make `Name` leak into every overload-resolution corner (and two implicit conversions can silently meet). Printing: `operator<<` via `str()`. The review's sentence: *one-way implicit conversions are a design smell; choose a direction and make the other explicit.*

**R3 — The range type.** `contains` as a **member function** is honest; `operator<` for containment is **gallery #1**: `<` carries a global contract (strict weak ordering — sorts and binary searches borrow it blindly), and "is inside" violates it (`x < r` with x inside and y outside can give `y < x` false in ways that break transitivity across ranges). The honest set: `contains`, `==`, `!=`, `<<` — and if mathematical notation is truly wanted, a differently-named free function (`isInside(x, r)`) or a deliberately-named wrapper type (`InRange`) whose `<` exists in a context where ordering is not used. The review's rule, restated: *operators inherit the built-in contracts; don't borrow a symbol whose contract you break.*

**R4 — The generic absolute-value.** Contract for `int`/`double`-like `T`: `<` (against `T(0)`), unary `-`, copy construction/assignment, construction from `0`, return by value. For an expensive-negation `Decimal`: the honest answer is **two functions** — the generic `myAbs` (correct everywhere, suboptimal for Decimal) plus a *specialized* overload `Decimal myAbs(const Decimal&)` using whatever fast path Decimal offers; overloading (not specialization — the distinction named honestly) picks the best at the call site with zero caller changes. The review's sentence: *genericity serves breadth; overloading serves the exception; both can coexist and the caller stays unchanged.*

**R5 — The generic pair.** Interface: `Pair(const A&, const B&)`, `const A& first() const`, `const B& second() const` (const-correct references — no copies), `bool operator==(const Pair&, const Pair&)` **non-member**. The demand chain: Pair's `==` demands `A`'s `==` *and* `B`'s `==` — the contract comment reads *"`A, B` each require `==`"*, and stamping a `Pair<Money, string>` works only because Lesson 1 built Money's comparison set. Arithmetic `+` on Pair: **no** — "add two pairs" has no single honest meaning (component-wise? concatenate? — every choice is a surprise, gallery #1), while `<<` printing `(first, second)` has exactly one defensible form. The review's dividing line, stated: *overload where one honest behaviour exists; provide named functions where choices exist.*

**R6 — The generic container's public face.** Full interface: `explicit Box(int capacity)`; `bool add(const T&)` (contract: copyable); `bool removeAt(int)` (contract: copy-assignable — it shifts); `const T& at(int) const` (bounds-checked, throws); `int size() const`; `bool contains(const T&) const` (contract: `==`); `const T* max() const` returning a pointer-or-nullptr (contract: `<`; the pointer form avoids requiring default-constructible `T` for a sentinel return — the E20/D8 seed-from-first lesson, promoted to interface design); `operator<<` (contract: `T` printable). Ranking: copyable ≈ indexable-cheapest → `==` → `<<` → `<` → default-constructible (avoided by the pointer-return design). The cut list: `removeAt` (assignable) and `contains`/`max` (equality/ordering) are the rarest demands — a minimal `Box` keeps add/at/size/`<<` and serves the widest type set; the review rewards *saying why the cuts*, not the cut list itself. (Lesson 2 §3's frugality, at interface scale.)

---

## Where next

- [Challenges](challenges.md): eight build-and-defend problems.
- [The five labs](labs.md): Complex numbers to the Student comparison.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
