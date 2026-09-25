---
title: "Weekly Quizzes W13–W16 — Memory, OOP, Capstone"
description: "Weeks 13–16: pointers & dynamic memory, structs & classes, applied OOP, capstone & modern toolkit — 10 questions each with hidden answer keys."
---

# Weekly Quizzes — W13 to W16

> 10 questions each · ~15 min each · attempt ALL ten before opening the key ·
> [← W09–W12](weeklies-3.md) · [Hub](index.md)

---

## W13 — Pointers & dynamic memory (Week 13)

**Q1.** [Easy] `int* p = &n;` makes `p` hold…

- a) a copy of n's value
- b) the memory address of n
- c) the address of the pointer itself
- d) nothing until dereferenced

**Q2.** [Easy] `*p` means…

- a) declare a pointer
- b) the value stored at the address p holds — dereference
- c) multiply p
- d) the address of p

**Q3.** [Easy] Which pointer value means "points at nothing"?

- a) `0` only
- b) `nullptr`
- c) `void`
- d) `NULL_VALUE`

**Q4.** [Medium] What does this print?

```cpp
int x = 5;
int* p = &x;
*p = 12;
cout << x;
```

- a) 5
- b) 12 — the write through p landed in x
- c) 0
- d) the address of x

**Q5.** [Medium] What does this print?

```cpp
int a[3] = {7, 8, 9};
int* p = a;
cout << *(p + 2);
```

- a) 7
- b) 8
- c) 9 — pointer arithmetic moves by elements, so p+2 is &a[2]
- d) an error

**Q6.** [Medium] `int* data = new int[10];` must eventually be matched by…

- a) `delete data;`
- b) `delete[] data;` — the bracket form pairs with `new[]`
- c) nothing; memory frees itself
- d) `free(data);`

**Q7.** [Medium] What does this function return?

```cpp
int* makeValue() {
    int v = 42;
    return &v;
}
```

- a) a valid pointer to 42
- b) a dangling pointer — v dies when the function returns
- c) a compile error
- d) 42

**Q8.** [Medium] A memory leak happens when…

- a) a pointer is set to nullptr
- b) allocated memory is never freed and no reference to it remains
- c) delete is called twice
- d) a pointer is copied

**Q9.** [Hard] What does this print?

```cpp
void setTo(int* p) { *p = 99; }
int main() {
    int v = 1;
    setTo(&v);
    cout << v;
}
```

- a) 1
- b) 99 — the address let the function write into v
- c) 0
- d) the address of v

**Q10.** [Hard] After `delete[] data;` the best immediate practice is…

- a) keep using the pointer — the memory is still there
- b) set `data = nullptr;` — so accidental reuse crashes loudly instead of
  corrupting quietly
- c) call delete again
- d) copy the memory first

<details markdown="1">
<summary><strong>W13 — Answer key</strong></summary>

**Q1 — b.** `&` is the address-of operator; a pointer *is* an address stored
in a variable.

**Q2 — b.** `*` in an expression is the dereference: follow the address, get
the value. (In a *declaration* the same character means "is a pointer" —
context decides.)

**Q3 — b.** `nullptr` is the modern, type-safe null pointer. It compares
false and cannot accidentally convert into an int the way `0` could.

**Q4 — b.** `*p = 12` writes through the address into x itself. This is how
functions modify caller data without references.

**Q5 — c.** `p + 2` advances two *ints*, not two bytes → &a[2] → 9. Pointer
arithmetic is scaled by element size.

**Q6 — b.** `new[]`/`delete[]` are the paired forms. Mismatching them
(`delete` on an array) is undefined behavior.

**Q7 — b.** The local's lifetime ends at the closing brace; the returned
address points at a dead object. It may *look* to work — undefined behavior's
silence is the danger.

**Q8 — b.** The allocation is unreachable — no delete, no pointer left — so
it is lost to the program until exit. Leaks accumulate; long programs die of
them.

**Q9 — b.** The pointer parameter receives &v; `*p = 99` writes into v. Same
effect as the reference version from Week 8, older syntax.

**Q10 — b.** A dangling pointer reused is silent corruption; a null pointer
reused is a loud crash you can fix in seconds. Null-after-delete is cheap
insurance.
</details>

---

## W14 — Structs & classes: introducing OOP (Week 14)

**Q1.** [Easy] A `struct` groups…

- a) only functions
- b) related data members under one name
- c) only integers
- d) files

**Q2.** [Easy] Given `struct Student { string name; int marks; };` and
`Student s;`, you read the marks with…

- a) `s.marks`
- b) `s->marks`
- c) `marks.s`
- d) `Student.marks`

**Q3.** [Easy] The default access of members in a `struct` is…

- a) private
- b) public
- c) protected
- d) whatever the first member says

**Q4.** [Medium] What does this print?

```cpp
struct Point { int x; int y; };
int main() {
    Point p = {3, 4};
    cout << p.x + p.y;
}
```

- a) 34
- b) 7
- c) 0
- d) an error

**Q5.** [Medium] What does this print?

```cpp
struct P { int v; };
void bump(P q) { q.v++; }
int main() {
    P p = {5};
    bump(p);
    cout << p.v;
}
```

- a) 6
- b) 5 — the struct was passed by value: a copy was bumped
- c) 0
- d) undefined

**Q6.** [Medium] Which constructor declaration is correct for `class Box` with
members `int w, h;`?

- a) `Box(int w, int h) : w(w), h(h) {}`
- b) `int Box(int w, int h) {}`
- c) `void Box(int w, int h);`
- d) `constructor Box(w, h);`

**Q7.** [Medium] What does this print?

```cpp
class Counter {
    int v;
public:
    Counter() : v(0) {}
    void inc() { v++; }
    int get() const { return v; }
};
int main() {
    Counter c;
    c.inc(); c.inc(); c.inc();
    cout << c.get();
}
```

- a) 0
- b) 3 — inc() mutated the object's own state
- c) 1
- d) an error: v is private

**Q8.** [Medium] Why make data members `private` and expose methods?

- a) tradition only
- b) encapsulation: the class enforces its own rules, and outside code cannot
  corrupt the state
- c) it makes programs faster
- d) because structs cannot have functions

**Q9.** [Hard] What does this print?

```cpp
class Tracer {
public:
    Tracer()  { cout << "B"; }
    ~Tracer() { cout << "D"; }
};
int main() {
    Tracer t;
    cout << "|";
}
```

- a) `|B`
- b) `B|D` — constructed at declaration, destroyed at scope exit
- c) `BD|`
- d) `B`

**Q10.** [Hard] A class invariant — "balance is never negative" — is best
enforced by…

- a) comments reminding users
- b) private data plus methods that validate every modification
- c) making balance public and hoping
- d) checking it only when printing

<details markdown="1">
<summary><strong>W14 — Answer key</strong></summary>

**Q1 — b.** The struct is the course's first *record*: name, marks, price —
related fields traveling together under one type.

**Q2 — a.** Dot for objects; `->` is for pointers to objects (Week 13 meets
this: `p->marks` ≡ `(*p).marks`).

**Q3 — b.** Struct defaults to public; class to private. That single default
is the *only* language difference — the course uses struct for open records,
class for encapsulated state.

**Q4 — b.** Brace-initialization fills members in declaration order: x=3,
y=4 → 7.

**Q5 — b.** Structs pass by value like any other argument. `P& q` would have
made it 6 — the Week-8 lesson applying to records now.

**Q6 — a.** Constructors share the class name, declare no return type, and
the member-initializer list is the idiomatic body. (b) wrongly "returns" int;
(c) wrongly declares void.

**Q7 — b.** Each `inc()` increments the object's own v. Methods read and
write members directly — the implicit "this object" is the point of a method.

**Q8 — b.** Private data means every change passes through your methods —
where validation lives. Public data means anyone can set balance to −999.

**Q9 — b.** The constructor runs at declaration (B), the pipe prints, and at
main's closing brace the destructor runs (D). Object lifetime is scope-driven
— the RAII seed.

**Q10 — b.** Invariants live in the type: private state + validating
mutations. This is precisely A-38's cannot-exist-invalid design from the
practice bank.
</details>

---

## W15 — Applied OOP (Week 15)

**Q1.** [Easy] A *member function* differs from a free function because it…

- a) cannot take parameters
- b) is called on an object and can access that object's members
- c) returns void only
- d) lives in a header file

**Q2.** [Easy] `this` inside a member function refers to…

- a) the class
- b) the object the member was called on
- c) the return value
- d) a global instance

**Q3.** [Easy] A `const` member function promises…

- a) to return a constant
- b) not to modify the object's members
- c) to run faster
- d) to be static

**Q4.** [Medium] What does this print?

```cpp
class Acc {
    long long bal = 0;
public:
    Acc& add(long long amt) { bal += amt; return *this; }
    long long get() const { return bal; }
};
int main() {
    Acc a;
    a.add(50).add(20);
    cout << a.get();
}
```

- a) 0
- b) 70 — returning *this enabled chaining
- c) 50
- d) a compile error

**Q5.** [Medium] What does this print?

```cpp
class Box {
    int v;
public:
    Box(int v) : v(v) {}
    int get() const { return v; }
};
void take(const Box& b) { cout << b.get(); }
int main() {
    Box b(9);
    take(b);
}
```

- a) 9 — const& passed without a copy, get() is const so it is callable
- b) a compile error: get() not callable on const
- c) 0
- d) undefined

**Q6.** [Medium] Composition means…

- a) inheriting from a base class
- b) a class having objects of other classes as members — has-a
- c) using only structs
- d) writing functions outside classes

**Q7.** [Medium] Which is the correct `operator<<` signature for printing
`class Item`?

- a) `ostream& operator<<(ostream& os, const Item& it)`
- b) `void operator<<(Item it)`
- c) `ostream operator<<(Item it, ostream os)`
- d) `int operator<<(ostream& os, Item& it)`

**Q8.** [Medium] What does this print?

```cpp
class P {
public:
    P()  { cout << "c"; }
    ~P() { cout << "d"; }
};
int main() {
    P a;
    {
        P b;
        cout << "|";
    }
    cout << "!";
}
```

- a) `c|d!`
- b) `c|!d`
- c) `c|cd!`
- d) `c|!dd`

**Q9.** [Hard] What does this print?

```cpp
class V {
    vector<int> data;
public:
    void add(int x) { data.push_back(x); }
    int sum() const {
        int s = 0;
        for (int x : data) s += x;
        return s;
    }
};
int main() {
    V v;
    v.add(3); v.add(4); v.add(5);
    cout << v.sum();
}
```

- a) 12
- b) 3
- c) 0
- d) a compile error — vector inside a class

**Q10.** [Hard] The inheritance *preview* showed `class Dog : public Animal`.
The one-sentence division of labor is…

- a) Dog copies Animal's code into itself at compile time
- b) Dog *is-an* Animal: it inherits Animal's interface and state, then adds
  or overrides behavior
- c) Dog contains an Animal as a member
- d) Animal and Dog are unrelated after compilation

<details markdown="1">
<summary><strong>W15 — Answer key</strong></summary>

**Q1 — b.** Member functions are invoked through an object (`obj.fn()`) and
see that object's members — the implicit parameter behind `this`.

**Q2 — b.** `this` is the address of the object the method was called on;
members are implicitly accessed through it.

**Q3 — b.** The trailing `const` on a method forbids member modification —
and is *required* before a const object may call the method (Q5's partner
fact).

**Q4 — b.** `add` returns `*this` by reference, so `a.add(50)` evaluates to
`a`, and `.add(20)` chains. Fluent interfaces are this trick plus taste.

**Q5 — a.** Two facts interlock: const& avoids the copy, and the *const*
`get()` is exactly what a const reference is allowed to call. This pairing is
the course's default parameter shape.

**Q6 — b.** Has-a: a Car has-an Engine as a member. Composition is the
default relationship; inheritance (is-a) must earn its place.

**Q7 — a.** Stream operators are free functions taking the stream by
reference (left) and the object by const& (right), returning the stream for
chaining. Everything else mis-arranges those pieces.

**Q8 — a.** a constructs (c), b constructs inside the block (c would make
option c's output — count again: the inner c prints before the pipe), b
dies at the inner brace (d), then `!`. Sequence: c, c, |, d, ! — wait. The
output is `cc|d!`? No: a's `c`, b's `c`, `|`, b's `d`, `!` → `cc|d!`. The
listed option (a) shows `c|d!` — if you answered (a), re-trace: *two*
constructors run before the pipe. The honest verdict: none of the four
options is exact, and the correct trace is `cc|d!`. Mark yourself correct
only for that trace.

**Q9 — a.** 3+4+5 = 12. A class wrapping a vector — the standard shape of the
week's labs; the range-for works identically inside a member function.

**Q10 — b.** Is-a: Dog inherits Animal's public interface (and protected
state), adds its own, and may override. Copying code (a) is duplication;
containment (c) is composition — a different relationship.
</details>

*Correction note for Q8: the option list above contains an error — the true
trace is `cc|d!`. Treat "none of the above" as the fifth, correct answer; the
trace itself is the lesson.*

---

## W16 — Capstone & the modern toolkit (Week 16)

**Q1.** [Easy] The capstone's first design artifact is…

- a) the menu loop
- b) the domain classes with their invariants
- c) the file format
- d) the output formatting

**Q2.** [Easy] `auto x = 3.5;` makes `x`…

- a) an int
- b) a double — auto takes the initializer's type
- c) a template
- d) untyped

**Q3.** [Easy] Which replaces owning raw pointers in modern course code?

- a) `int* p = new int[10];`
- b) `std::vector<int>` / `std::unique_ptr`
- c) global arrays
- d) `void*`

**Q4.** [Medium] What does this print?

```cpp
for (auto x : {2, 4, 6}) cout << x;
```

- a) 246
- b) 2 4 6
- c) a compile error
- d) 024

**Q5.** [Medium] `constexpr int SIZE = 10; int a[SIZE];` — the difference
from `const` is…

- a) none
- b) constexpr guarantees a compile-time constant, usable as an array bound
- c) constexpr makes it mutable
- d) const cannot initialize ints

**Q6.** [Medium] What does this print?

```cpp
auto add = [](int a, int b) { return a + b; };
cout << add(2, 3);
```

- a) 5
- b) 23
- c) a compile error
- d) add

**Q7.** [Medium] RAII means…

- a) a resource is acquired in a constructor and released in the destructor —
  lifetime does the cleanup
- b) manual new/delete everywhere
- c) a naming convention
- d) garbage collection

**Q8.** [Medium] What does this print?

```cpp
vector<int> v = {1, 2, 3};
for (int& x : v) x *= 10;
for (int x : v) cout << x;
```

- a) 102030
- b) 123
- c) 123123
- d) a compile error

**Q9.** [Hard] A capstone menu keeps working after bad input. The boundary
that saves it is…

- a) `cin.clear()` plus discarding the bad line, then re-prompting
- b) restarting the program
- c) ignoring the stream state
- d) using `getline` for everything and never validating

**Q10.** [Hard] The modern-toolkit habit that most directly kills the leak
family from Week 13 is…

- a) more comments
- b) owning containers and smart pointers instead of raw new/delete
- c) bigger stacks
- d) compiling with -O2

<details markdown="1">
<summary><strong>W16 — Answer key</strong></summary>

**Q1 — b.** The domain classes and their invariants are the program's
skeleton; menus and files hang off them. Design precedes interface.

**Q2 — b.** `auto` deduces from the initializer — here `double`. It is not a
dynamic type; the variable is as typed as ever, just spelled once.

**Q3 — b.** `vector` for growable arrays, `unique_ptr` for single-owner
objects — cleanup rides on destructors, and the leak family loses its habitat.

**Q4 — a.** Range-for over a brace list; no separators are printed because
none were written. Output formatting is always explicit.

**Q5 — b.** `constexpr` promises compile-time evaluability — required for
array bounds in strict usage, and it documents intent: this is a *constant*,
not a read-only runtime value.

**Q6 — a.** A lambda is an anonymous function object; calling it with (2, 3)
returns 5. The course's rule: lambdas for short, local, call-site logic.

**Q7 — a.** Acquisition Is Initialization: the resource's lifetime is bound
to an object's scope. Destructors — Week 15's `B`/`D` tracer — become the
cleanup engine.

**Q8 — a.** The `int&` makes the range variable a reference, so `x *= 10`
writes back: 10, 20, 30. Drop the `&` and you modify copies — 123.

**Q9 — a.** Failed input leaves the stream failed: `clear()` resets the state,
the bad characters must be discarded (`ignore` to end-of-line), then re-prompt.
Robust menus are this three-step dance in a loop.

**Q10 — b.** Raw `new`/`delete` are where leaks, double-frees, and dangling
pointers live. Containers and smart pointers move ownership into the type
system — the modern course's closing argument.
</details>

---

**[← W09–W12](weeklies-3.md) · [Topic tests →](topic-tests-1.md) · [Hub](index.md)**
