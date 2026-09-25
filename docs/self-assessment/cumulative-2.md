---
title: "Cumulative Tests CU3–CU4 — Memory through the Full Course"
description: "Two 15-question cumulative tests: CU3 covers everything through pointers/dynamic memory (Weeks 1–13), CU4 spans the entire course including OOP — mixing all question types with hidden answer keys."
---

# Cumulative Tests — CU3 and CU4

> 15 questions each · ~30–35 min each · CU3 assumes Weeks 1–13, CU4 assumes
> the whole course · attempt ALL before any key ·
> [← CU1–CU2](cumulative-1.md) · [Practice finals →](final-exam-1.md)

---

## CU3 — Everything through pointers & dynamic memory (Weeks 1–13)

**Q1.** [Easy] Which correctly swaps two ints through a function?

- a) `void swap(int a, int b) { int t = a; a = b; b = t; }`
- b) `void swap(int& a, int& b) { int t = a; a = b; b = t; }`
- c) `int swap(int a, int b) { return a; }`
- d) `void swap(int a, b) { ... }`

**Q2.** [Easy] `string s = to_string(42) + "!";` gives…

- a) a compile error
- b) `"42!"` — to_string bridges number to string
- c) `"!42"`
- d) 43

**Q3.** [Easy] Reading a file line by line uses…

- a) `while (in >> line)`
- b) `while (getline(in, line))`
- c) `while (line.read(in))`
- d) `for (line : in)`

**Q4.** [Medium] What does this print?

```cpp
void addTax(double& price) { price *= 1.15; }
int main() {
    double p = 200;
    addTax(p);
    cout << p;
}
```

- a) 200
- b) 230 — the reference modified the caller's price
- c) 215
- d) 15

**Q5.** [Medium] What does this print?

```cpp
int a[4] = {1, 2, 3, 4};
int* p = a + 3;
cout << *p;
```

- a) 1
- b) 4 — pointer arithmetic landed on the last element
- c) 3
- d) an address

**Q6.** [Medium] What does this print?

```cpp
ifstream in("data.txt");
if (!in) { cout << "missing"; return 0; }
cout << "open";
```

(data.txt does not exist)

- a) open
- b) missing — the open check caught the failed stream
- c) both
- d) nothing

**Q7.** [Medium] What does this print?

```cpp
int x = 10;
int* p = &x;
int& r = x;
r = 20;
cout << *p;
```

- a) 10
- b) 20 — r and x are one object; p sees the change
- c) the address of x
- d) undefined

**Q8.** [Medium] This code leaks. Where?

```cpp
void process(int n) {
    int* data = new int[n];
    if (n == 0) return;          // early exit!
    for (int i = 0; i < n; i++) data[i] = i;
    cout << data[n - 1];
    delete[] data;
}
```

- a) no leak exists
- b) the `return` at n == 0 skips the delete — every zero-size call leaks
- c) new int[n] leaks by definition
- d) the loop leaks

**Q9.** [Medium] What does this print?

```cpp
string line = "Ali,88";
size_t comma = line.find(',');
cout << line.substr(comma + 1);
```

- a) Ali
- b) 88
- c) ,
- d) Ali,88

**Q10.** [Hard] What does this print?

```cpp
int arr[5] = {5, 10, 15, 20, 25};
int* p = arr;
p += 2;
cout << *p << " " << *(p - 1);
```

- a) `15 10` — p advanced two elements; p−1 steps back one
- b) `15 5`
- c) `20 15`
- d) addresses

**Q11.** [Hard] What does this print?

```cpp
void fill(int* a, int n) {
    for (int i = 0; i < n; i++) a[i] = i * i;
}
int main() {
    int* data = new int[4];
    fill(data, 4);
    cout << data[3];
    delete[] data;
}
```

- a) 3
- b) 9 — 0, 1, 4, 9 written through the decayed pointer
- c) 16
- d) undefined

**Q12.** [Hard] What does this print?

```cpp
int* makePair() {
    int* p = new int[2];
    p[0] = 7; p[1] = 8;
    return p;                    // heap memory survives the return
}
int main() {
    int* q = makePair();
    cout << q[0] << q[1];
    delete[] q;
}
```

- a) undefined — returning pointers is always wrong
- b) `78` — heap allocations outlive the function that made them
- c) 78 then a leak
- d) a compile error

**Q13.** [Hard] A program reads an unknown count of values from a file into
a collection, then reports the median. The best container choice is…

- a) a fixed `int a[10]`
- b) `vector<int>` grown with push_back — the count is a runtime fact
- c) ten separate int variables
- d) a string

**Q14.** [Hard] What does this print?

```cpp
string names[3] = {"Zoe", "Ali", "Mia"};
for (int i = 0; i < 3; i++)
    for (int j = i + 1; j < 3; j++)
        if (names[j] < names[i]) {
            string t = names[i]; names[i] = names[j]; names[j] = t;
        }
cout << names[0];
```

- a) Ali — selection-style sort by string comparison
- b) Zoe
- c) Mia
- d) A

**Q15.** [Hard] The dangling-pointer return from Week 13 (`return &v;` for a
local v) *sometimes prints the right value*. The engineering lesson is…

- a) it works if you are careful
- b) undefined behavior may appear to work; correctness requires the value
  outlive the pointer (return by value, static, or heap)
- c) the compiler always catches it
- d) printing twice fixes it

<details markdown="1">
<summary><strong>CU3 — Answer key</strong></summary>

**Q1 — b.** References let the swap touch the caller's variables. (a)
swaps copies — the null op that feels like work.

**Q2 — b.** `to_string` is the number→string bridge; `+` concatenates.

**Q3 — b.** getline loops on stream truth — line grain, newline consumed.

**Q4 — b.** `double&` aliases p: 200 × 1.15 = 230. In/out through a
reference.

**Q5 — b.** a+3 is &a[3] → 4. Arithmetic scaled by element size, from the
decayed array start.

**Q6 — b.** The failed open sets the fail state; `!in` is true → `missing`.
The guard converts a silent disaster into a handled event.

**Q7 — b.** Three names, one object: r is x is *p. Writing through any
alias, reading through any other.

**Q8 — b.** The early return abandons data with no delete — the leak hides
on the exceptional path, which is exactly where leaks live. (Fixes: delete
before return, or restructure so cleanup is automatic — the RAII lesson.)

**Q9 — b.** find locates the comma; substr(comma+1) is everything after —
`88`. The CSV slice.

**Q10 — a.** += 2 moves two ints forward (index 2 → 15); −1 back one
(index 1 → 10). Bidirectional pointer arithmetic.

**Q11 — b.** The array decays; fill writes squares through it; data[3] is
9. Pointer + length crossing the boundary — Week 9's convention with Week
13's memory.

**Q12 — b.** Heap memory outlives its creating function — that is *why*
heap exists. The returned pointer is valid until delete; ownership
transferred to the caller. (Compare: returning &local — stack — was the
bug.)

**Q13 — b.** Unknown count at compile time → dynamic container. vector
manages its own growth; the alternative manual new/realloc dance is the
Week-13 discipline exercise, not the default answer.

**Q14 — a.** Selection sort with string `<` — lexicographic: Ali, Mia, Zoe.
names[0] = Ali. Strings order themselves; the swap moves whole strings.

**Q15 — b.** "Appears to work" is undefined behavior's most dangerous
feature. The fix list — return the value, extend the lifetime, or move to
the heap with ownership — is the vocabulary the whole memory module exists
to teach.
</details>

---

## CU4 — The full course (Weeks 1–16)

**Q1.** [Easy] Which prints `3.14` from `double pi = 3.14159;`?

- a) `cout << pi;`
- b) `cout << fixed << setprecision(2) << pi;`
- c) `cout << %.2f << pi;`
- d) `print(pi, 2);`

**Q2.** [Easy] `struct Student { string name; int marks; };` — which copies
one student's marks into another *existing* object?

- a) `b = a.marks;`
- b) `b.marks = a.marks;`
- c) `b = marks(a);`
- d) `marks.b = marks.a;`

**Q3.** [Easy] Which is the *const-correct* read-only parameter?

- a) `string s`
- b) `const string& s`
- c) `string& s`
- d) `string* s`

**Q4.** [Medium] What does this print?

```cpp
class Acc {
    int bal = 0;
public:
    void deposit(int a) { if (a > 0) bal += a; }
    int get() const { return bal; }
};
int main() {
    Acc a;
    a.deposit(100); a.deposit(-5);
    cout << a.get();
}
```

- a) 100 — the negative deposit was refused by the class itself
- b) 95
- c) 105
- d) 0

**Q5.** [Medium] What does this print?

```cpp
vector<int> v = {8, 3, 8, 1};
int count = 0;
for (int x : v) if (x == 8) count++;
cout << count;
```

- a) 1
- b) 2
- c) 3
- d) 0

**Q6.** [Medium] What does this print?

```cpp
int a[5] = {9, 2, 7, 1, 5};
// selection sort pass 1: move the minimum to index 0
int mi = 0;
for (int i = 1; i < 5; i++) if (a[i] < a[mi]) mi = i;
int t = a[0]; a[0] = a[mi]; a[mi] = t;
cout << a[0] << a[4];
```

- a) `15` — min (1) swapped into front; slot 4 now holds 9
- b) `95`
- c) `12`
- d) `19`

**Q7.** [Medium] What does this print?

```cpp
string s = "abc";
s += "def";
cout << s.size();
```

- a) 3
- b) 6
- c) 7
- d) 5

**Q8.** [Medium] What does this print?

```cpp
class Box {
public:
    int v;
    Box(int v) : v(v) {}
};
void take(Box b) { b.v = 99; }
int main() {
    Box b(1);
    take(b);
    cout << b.v;
}
```

- a) 99
- b) 1 — objects pass by value too; the copy was mutated
- c) 0
- d) undefined

**Q9.** [Medium] A file holds `5\n10\n15\n`. What does this print?

```cpp
ifstream in("n.txt");
int x, sum = 0;
while (in >> x) sum += x;
cout << sum;
```

- a) 30
- b) 15
- c) 51015
- d) 0

**Q10.** [Hard] What does this print?

```cpp
int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}
int main() {
    cout << fib(5);
}
```

- a) 5 — 0,1,1,2,3,5: the fifth index
- b) 8
- c) 15
- d) infinite recursion

**Q11.** [Hard] What does this print?

```cpp
map<string, int> stock;   // #include <map>
stock["pen"] = 4;
stock["pen"] += 2;
cout << stock["pen"];
```

- a) 4
- b) 6 — operator[] created, then updated
- c) 2
- d) an error

**Q12.** [Hard] What does this print?

```cpp
try {
    int marks = -1;
    if (marks < 0) throw invalid_argument("negative");
    cout << "ok";
} catch (const invalid_argument& e) {
    cout << "caught";
}
```

- a) ok
- b) caught — the throw jumped straight to the matching handler
- c) okcaught
- d) the program crashes

**Q13.** [Hard] What does this print?

```cpp
class Base {
public:
    virtual string who() const { return "base"; }
};
class Derived : public Base {
public:
    string who() const { return "derived"; }
};
void report(const Base& b) { cout << b.who(); }
int main() {
    Derived d;
    report(d);
}
```

- a) base
- b) derived — the virtual dispatch follows the object, not the reference
  type
- c) both
- d) an error

**Q14.** [Hard] What does this print?

```cpp
int* data = new int[3]{1, 2, 3};
int* alias = data;
delete[] data;
data = nullptr;
cout << (alias == nullptr);
```

- a) 1 — data was nulled, so alias follows
- b) 0 — alias still holds the dangling address; nulling data changed only
  data
- c) 1 then a crash
- d) undefined print

**Q15.** [Hard] The capstone stores `Student` objects in a `vector`, saves
them to a text file, reloads at startup, and rejects any marks outside
0–100 at *both* entry points (user input and file load). The architectural
principle this enacts is…

- a) single ingestion path: all data enters through one validating doorway,
  so the invariant has exactly one place to live
- b) duplicate validation in every function that touches marks
- c) trusting the file since it was written by the same program
- d) validating only when printing

<details markdown="1">
<summary><strong>CU4 — Answer key</strong></summary>

**Q1 — b.** fixed + setprecision(2) — the formatting pair, from `<iomanip>`.

**Q2 — b.** Member-to-member assignment between existing objects. (a)
overwrites b entirely with an int — a type error.

**Q3 — b.** const&: no copy, read-only enforced. The signature the course
adopts for every read-only string parameter from Week 8 onward.

**Q4 — a.** The class refuses its own corruption: deposit(−5) fails the
guard. The invariant lives in the type — Q4 of T8, matured into the
capstone.

**Q5 — b.** 8 appears at indices 0 and 2 → count 2. Linear counting over a
vector — the `==`-test pattern.

**Q6 — a.** Pass 1 finds min index 3 (value 1), swaps with slot 0:
{1,2,7,9,5}. a[0]=1, a[4]=5 → `15`. One selection pass, traced.

**Q7 — b.** += appends; 3+3 = 6 characters. size() counts what the string
*is*, not what it was.

**Q8 — b.** take receives a copy of the Box; the copy's v became 99 and died
at the closing brace. Objects follow value semantics unless passed by
reference — the Week-8 lesson wearing a class.

**Q9 — a.** Three extractions across three lines: 5+10+15 = 30. `>>` treats
newlines as ordinary whitespace.

**Q10 — a.** fib(5) = fib(4)+fib(3) = 3+2 = 5. Double recursion — the tree
the algorithms module traces. The base cases n ≤ 1 return n itself (0 and
1), anchoring the sequence.

**Q11 — b.** First use creates the key with 4; `+=` updates it to 6. The
map's insert-or-access bracket — a side effect to *use* deliberately.

**Q12 — b.** throw abandons the normal path instantly; the catch handler
prints `caught`. "ok" never runs — control left that line the moment the
throw fired.

**Q13 — b.** A Base& holding a Derived object calls the Derived override —
runtime polymorphism through the virtual function. The reference's *static*
type is Base; the object's *dynamic* type is Derived, and `virtual` makes
the call follow the object.

**Q14 — b.** Nulling `data` did not touch `alias` — two independent
pointers held one address; the delete killed the memory, not the copies.
Alias is dangling regardless of data's new value. Null-after-delete protects
*that* pointer only — one more reason owning containers beat manual
pointers.

**Q15 — a.** One doorway: every mark — typed or loaded — passes the same
0–100 gate before entering the system. Duplicate validation (b) drifts out
of sync; trusting the file (c) is how corrupt data enters via your own
hand. The single-path principle is the capstone's quiet spine.
</details>

---

**[← CU1–CU2](cumulative-1.md) · [Final Exam A →](final-exam-1.md) · [Hub](index.md)**
