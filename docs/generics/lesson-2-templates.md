---
title: "Lesson 2 — Templates and Generic Programming"
description: "Function templates, class templates, type independence, what generic code demands of its types, and the honest limitations and common mistakes."
---

# Lesson 2 — Templates and Generic Programming

> [← Module home](index.md) · [← Lesson 1 — Operator overloading](lesson-1-operator-overloading.md)

## In this lesson you will learn

- **function templates** — one algorithm, every type, stamped by the compiler
- **class templates** — containers that hold *any* type honestly
- what **generic programming** means and what it demands of the types it serves
- the **limitations and common mistakes** — named honestly, including the error-message wall

**The problem you have already felt:** the Algorithms module had you write `maxOf(const int a[], int n)`, then the same shape for `double`, then `string`. Three copies of one idea (gallery-worthy duplication — the DRY rule hated it). Templates delete the copies: write the *shape* once, name the varying *type*, and let the compiler stamp out the versions.

---

## 1. Function templates — the shape, parameterized

```cpp
// mymax.cpp — Programming Fundamentals Using C++
// Generics module · Lesson 2 · The first function template
// Compile: g++ -std=c++17 -Wall -Wextra mymax.cpp -o mymax

#include <iostream>
#include <string>
using namespace std;

template <typename T>
const T& myMax(const T& a, const T& b) {
    return (a < b) ? b : a;          // the ONE requirement: a and b are comparable with <
}

int main() {
    cout << myMax(3, 9) << "\n";              // T = int      — stamped version 1
    cout << myMax(2.5, 1.5) << "\n";          // T = double   — stamped version 2
    cout << myMax(string("apple"), string("pear")) << "\n";  // T = string — version 3
    return 0;
}
```

**Output:** `9`, `2.5`, `pear`.

**What actually happens — the stamping model.** `template <typename T>` declares `T` a *type parameter*. The template itself is **not code** — it's a pattern. At each call, the compiler **deduces** `T` from the arguments (`3, 9` → both `int` → stamp `int` version) and *generates* an ordinary function from the pattern. Nothing generic runs; the genericity happened at compile time. (This is the key difference from the Inheritance module's virtual dispatch — which is *runtime* polymorphism. Templates are **compile-time polymorphism**: the "many forms" are stamped out before the program ever runs.)

### The contract — what a template demands of its types

Read `myMax`'s body as a *requirement listing*: it uses `<` on two `T`s. Therefore every `T` you stamp with must support `<` in a way that orders correctly. That is the template's **implicit contract** — and it is the honest bridge to the Inheritance module's *interfaces*: an interface is a contract you *write down*; a template's requirements are a contract you *infer from the body*. The Inheritance module's Challenges C4/C5 graded contracts you could name; here the compiler enforces them — brutally (see §4).

```cpp
// stamping with your own types: satisfy the contract
class Money {
public:
    explicit Money(long long p = 0) : paisa(p) {}
    bool operator<(const Money& o) const { return paisa < o.paisa; }   // the contract, kept
    long long getPaisa() const { return paisa; }
private:
    long long paisa;
};
// myMax(Money(5), Money(9)) — works: Money meets the < requirement
```

This is why Lesson 1 exists: **operator overloading is how your types enter generic code.** `Money` compares because you taught it to.

### Deduction rules worth knowing

- **Both parameters deduce `T`** — `myMax(3, 9.5)` fails: `int` vs `double`, no single `T`. Cures: call with matching types (`myMax(3.0, 9.5)`), supply `T` explicitly (`myMax<double>(3, 9.5)`), or take the two-parameter-template form (the [challenges](challenges.md) build it).
- `const T&` parameters: no copies for `string`-scale types; deduction works through references.
- Return `const T&` (reference to *one of the arguments* — safe, they outlive the call) rather than `T` (a copy) when the value already exists.

---

## 2. Class templates — containers that hold any type

The Arrays module's fixed `int squares[10]` and the OOP module's `vector<Student>` bracket the idea; a class template is you writing `vector` yourself:

```cpp
// box.cpp — Programming Fundamentals Using C++
// Generics module · Lesson 2 · A class template
// Compile: g++ -std=c++17 -Wall -Wextra box.cpp -o box

#include <iostream>
#include <stdexcept>
using namespace std;

template <typename T>
class Box {
public:
    explicit Box(int capacity) : cap(capacity > 0 ? capacity : 1) {
        data = new T[cap];
    }
    ~Box() { delete[] data; }

    bool add(const T& item) {                  // the OOP module's guarded doors
        if (count >= cap) return false;
        data[count++] = item;
        return true;
    }
    const T& at(int i) const {
        if (i < 0 || i >= count) throw out_of_range("Box::at");
        return data[i];
    }
    int size() const { return count; }
private:
    T* data;
    int cap;
    int count = 0;
};

int main() {
    Box<int> nums(3);                  // stamp 1: T = int
    nums.add(5); nums.add(9);
    cout << nums.at(1) << "\n";        // 9

    Box<string> words(3);              // stamp 2: T = string
    words.add("template");
    cout << words.at(0).size() << "\n";// 8

    Box<Box<int>> nested(2);           // stamps compose — T is itself a stamped type
    nested.add(nums);
    cout << nested.at(0).size() << "\n";  // 2
    return 0;
}
```

**Explanation of the new notations:** every use names the stamp — `Box<int>`, `Box<string>` (function templates deduce; class templates, at this course's level, are told explicitly). Inside the template, `T` is used like any type. The members keep every habit the course drilled: guarded `add` (OOP), bounds-checked `at` (Arrays), the `new[]`/`delete[]` pair (Pointers), the throwing `.at` honesty (the standard library's own convention). **Note what the template can't do for you:** the `Box<T>` of any type inherits `T`'s requirements — `add` needs `T` copyable; a `T` that leaks on copy poisons the Box (Lesson 2 of the Inheritance module's D4 lesson, generalized: *resource-owning template arguments need resource-safe copies* — the reason `unique_ptr` exists next course).

### Two honest scope notes

- **Templates live in headers.** The compiler must see the pattern to stamp it in every file that uses it — so template *definitions* sit in `.hpp` files, not `.cpp`. At single-file course scale this is invisible; name it now so the rule isn't a surprise later.
- **This course's templates stop before the deep end.** Template *specialization*, variadic templates, SFINAE/concepts, and template metaprogramming are real and out of scope — the honest boundary is: you can now *read* standard-library signatures and *write* small generic utilities; the rest belongs to the next course.

---

## 3. Generic programming — the idea, stated

**Generic programming** is writing algorithms and containers against *requirements on types* rather than against *specific types* — so one `sort` serves `int`, `string`, and `Money`, and one `Box` serves any element type that meets its needs. The standard library is the proof: `vector`, `string`, and every algorithm you'll meet in a data-structures course are templates.

The three-part discipline this module teaches:

1. **Name the requirements** (in a comment, at the template head — the contract made visible): *"`T` must support `<` forming a strict weak ordering"* (the Algorithms module's precondition discipline, at type scale).
2. **Keep the body minimal** — a template using ten operations demands ten of every `T`; each operation added narrows the set of types that can stamp it. Genericity is *frugality*.
3. **Test with at least two wildly different types** (`int` and `string` minimum — the [labs](labs.md) use your own classes too): a generic utility proven on one type is a specialization wearing a costume.

---

## 4. Limitations and common mistakes — named honestly

**Limitations (the honest wall):**

1. **The error-message wall.** A contract violation inside a three-layer template produces a multi-page instantiation trace. The skill this module builds: read *your own line* in the error (the first mention of *your* code), identify the failed requirement, ignore the stamping noise. It gets easier; it never becomes pleasant.
2. **Code bloat.** Every distinct stamp is a real copy — `Box<int>` and `Box<long>` are two classes in the binary. At course scale, irrelevant; the term belongs in your vocabulary.
3. **Errors surface at use, not at definition.** A template that would never compile for any type sits quietly until *stamped* — the inversion of the normal compile story (the Debugging module's taxonomy, template-flavoured).
4. **No runtime flexibility.** Templates resolve at compile time: one binary, fixed types. "A Box that decides at runtime whether it holds ints or strings" is *not* a template problem — it's the Inheritance module's polymorphic-interface problem. (This division of labour — templates for same-shape-different-type, virtual dispatch for same-call-different-behaviour-at-runtime — is the exam answer to "templates vs inheritance".)

**Mistakes (the gallery):**

1. **Assuming operations the type doesn't have.** Using `+=` in a template that promised only `<` — fails only for the `T`s that lack it. Keep the body inside the documented contract.
2. **The deduction mismatch.** `myMax(3, 9.5)` — two parameters, one `T`, no agreement. Know the cures (§1).
3. **Forgetting `typename`-era basics: the stamp.** Declaring `Box box;` — which `T`? Class templates *must* name their arguments.
4. **Templates in `.cpp` files.** The linker error of the next course ("undefined reference to..."), pre-named in §2's scope note.
5. **Testing on one type only.** The int-only `Box` is a lie about genericity (§3's discipline 3).
6. **`operator<` drift.** A template's ordering is only as honest as the `<` it borrows — Lesson 1's comparison contract is load-bearing here.
7. **Storing references or raw owners carelessly.** `Box<T&>` (illegal at this level) and `Box<int*>` (ownership ambiguity — who deletes the pointee?) both bite; the course rule: generic containers hold *values*, and resource-owning values need resource-safe copies.

---

## Check yourself

- Where does `myMax(3, 9)`'s `int` version come from — the compiler or the runtime? (the compiler stamps it from the pattern at the call — compile-time polymorphism)
- What single operation does `myMax` demand of `T`, and who taught `Money` to satisfy it? (`<`, correctly ordered; you did, via overloaded `operator<` — Lesson 1)
- Why does `Box box;` fail to compile while `myMax(3, 9)` succeeds? (function templates deduce `T` from arguments; class templates must be told: `Box<int>`)

## Where next

- [Exercises](exercises.md): twenty drills across both lessons.
- [The five labs](labs.md): Complex numbers to the Student-comparison lab.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
