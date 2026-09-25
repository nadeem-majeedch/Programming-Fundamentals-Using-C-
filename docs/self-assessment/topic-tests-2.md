---
title: "Topic Revision Tests T5–T8 — Strings, Files, Memory, OOP"
description: "Four 12-question topic tests spanning multiple units: strings & text, files & persistence, memory & pointers, and OOP & design — each with hidden answer keys, explanations, and difficulty labels."
---

# Topic Revision Tests — T5 to T8

> 12 questions each · ~20 min each · span-units consolidation · attempt ALL
> before any key · [← T1–T4](topic-tests-1.md) · [Hub](index.md) ·
> [Cumulative tests →](cumulative-1.md)

---

## T5 — Strings & text processing (Units 03, 11)

**Q1.** [Easy] Which correctly tests whether string `s` is empty?

- a) `s == ""`
- b) `s.empty()`
- c) `s.size() == 0`
- d) all three work

**Q2.** [Easy] `string s = "Programming";` — `s.substr(0, 7)` returns…

- a) `Program`
- b) `ming`
- c) `Programming`
- d) `Pro`

**Q3.** [Easy] Concatenation of `first = "Ada"` and `last = "Lovelace"` with a
space is…

- a) `first + " " + last`
- b) `first ++ " " ++ last`
- c) `first.append(last)`
- d) `first.space(last)`

**Q4.** [Medium] What does this print?

```cpp
string s = "abc";
for (int i = s.size() - 1; i >= 0; i--) cout << s[i];
```

- a) abc
- b) cba
- c) c
- d) nothing

**Q5.** [Medium] What does this print?

```cpp
string s = "Hello World";
int spaces = 0;
for (size_t i = 0; i < s.size(); i++)
    if (s[i] == ' ') spaces++;
cout << spaces << " " << s.size();
```

- a) `1 11`
- b) `1 10`
- c) `0 11`
- d) `2 11`

**Q6.** [Medium] After `cin >> n;` with input 42, what does
`getline(cin, line)` (immediately after) store in `line`?

- a) the user's next full line
- b) an empty string — the buffered newline satisfied it
- c) "42"
- d) it crashes

**Q7.** [Medium] What does this print?

```cpp
string s = "2026";
int n = 0;
for (size_t i = 0; i < s.size(); i++) n = n * 10 + (s[i] - '0');
cout << n + 1;
```

- a) 2027 — the digit-to-value conversion builds the number
- b) 20261
- c) 0
- d) an error

**Q8.** [Medium] Which snippet capitalizes the first character of `word`?

- a) `word[0] = toupper(word[0]);`
- b) `toupper(word);`
- c) `word.first() = upper;`
- d) `word = upper(word);`

**Q9.** [Hard] What does this print?

```cpp
string a = "apple", b = "Apple";
if (a == b)      cout << "same";
else if (a < b)  cout << "lower-first";
else             cout << "upper-first";
```

- a) same
- b) lower-first — uppercase letters precede lowercase in ASCII, so "Apple" <
  "apple"… check carefully
- c) upper-first
- d) undefined

**Q10.** [Hard] What does this print?

```cpp
string s = "mississippi";
int count = 0;
for (size_t i = 0; i + 2 < s.size(); i++)
    if (s.substr(i, 2) == "ss") count++;
cout << count;
```

- a) 2
- b) 3 — overlapping occurrences counted: positions 2, 5, 8
- c) 1
- d) 4

**Q11.** [Hard] What does this print?

```cpp
string line = "  data  ";
// strip leading and trailing spaces
size_t b = line.find_first_not_of(' ');
size_t e = line.find_last_not_of(' ');
cout << "[" << line.substr(b, e - b + 1) << "]";
```

- a) `[data]`
- b) `[  data  ]`
- c) `[data  ]`
- d) `[]`

**Q12.** [Hard] A word counter must treat runs of spaces as one separator
(`"a  b"` is two words). The loop test that handles it is…

- a) count every space
- b) count a word-start: current char is not a space AND (i == 0 OR previous
  char was a space)
- c) split on every character
- d) count non-space characters

<details markdown="1">
<summary><strong>T5 — Answer key</strong></summary>

**Q1 — d.** All three are correct; `s.empty()` states the intent most
directly. Knowing the equivalents matters more than the favorite.

**Q2 — a.** `substr(pos, len)`: 7 characters from index 0. The second
argument is a length — the recurring confusion.

**Q3 — a.** `+` chains strings and literals. `append` (c) also works but
takes only one argument — as written it would produce `AdaLovelace`, no
space.

**Q4 — b.** Backward index loop — the manual reverse. `s.size() - 1` as the
start requires a signed loop counter (here `int`), or the unsigned trap
bites.

**Q5 — a.** One space; eleven characters including it. Counting characters
vs counting separators are different questions — this program answers both.

**Q6 — b.** The mixing trap, final appearance. `cin.ignore()` before the
getline — if this still surprised you, W03 and W11 deserve one more pass.

**Q7 — a.** The digit-build: '2'−'0' = 2, then 2026 accumulates left to
right. `n + 1` = 2027. This is `stoi`'s engine, hand-cranked.

**Q8 — a.** Strings are mutable per-index; `toupper` works on a char and the
assignment writes it back. The other options call functions that don't exist
or operate on nothing.

**Q9 — c.** ASCII: 'A' (65) < 'a' (97), so "Apple" < "apple" — and a < b is
false, a == b is false → upper-first. Case-blind comparison requires
tolower-ing both sides first; the default `<` is byte order, not dictionary
order.

**Q10 — b.** Sliding window of length 2, stepping by 1, counting *overlaps*:
"ss" at indices 2, 5, 8 → 3. `i + 2 < s.size()` guards the window — note it
is `<` size, because the window occupies i and i+1 with i+2 as the exclusive
edge… precisely: with `i + 2 < size`, the last start index checked is
size−3; index 9 ("pp") starts a window ending at 10 = size — excluded. For
"mississippi" (11 chars, last index 10), ss-pairs start at 2, 5, 8 — all
satisfy `i + 2 < 11` (4, 7, 10 < 11; 10 is not < 11 — so index 8 has window
{8,9}, fine). Count = 3.

**Q11 — a.** `find_first_not_of(' ')` locates the first non-space (2);
`find_last_not_of` the last (7); `substr(2, 7−2+1)` = 6 characters —
`data`. Trim via two finds + arithmetic.

**Q12 — b.** The word-start predicate collapses any run of separators to one
boundary event. Counting spaces (a) fails on double spaces; counting
non-spaces (d) fails on everything.
</details>

---

## T6 — Files & persistence (Unit 12)

**Q1.** [Easy] Which stream type reads a file?

- a) `ofstream`
- b) `ifstream`
- c) `fstream` writing
- d) `stringstream`

**Q2.** [Easy] `ofstream out("data.txt");` on an *existing* file…

- a) appends to it
- b) truncates it — old contents are gone
- c) fails if the file exists
- d) opens it read-only

**Q3.** [Easy] Which line correctly checks an open?

- a) `if (in.open()) ...`
- b) `if (!in) { /* handle failure */ }`
- c) `if (in == true) ...`
- d) `check(in);`

**Q4.** [Medium] `nums.txt` holds `10 20 30`. What does this print?

```cpp
ifstream in("nums.txt");
int x, sum = 0, count = 0;
while (in >> x) { sum += x; count++; }
cout << count << " " << sum;
```

- a) `3 60`
- b) `1 60`
- c) `0 0`
- d) `3 102030`

**Q5.** [Medium] What does this loop read?

```cpp
string line;
while (getline(in, line)) { ... }
```

- a) one word per pass
- b) one full line per pass — including interior spaces, newline consumed
- c) only lines with numbers
- d) nothing; getline cannot loop

**Q6.** [Medium] A log must *add* lines across many program runs. The open
is…

- a) `ofstream log("log.txt");`
- b) `ofstream log("log.txt", ios::app);`
- c) `ifstream log("log.txt");`
- d) `fstream log("log.txt", ios::in);`

**Q7.** [Medium] What does this print, given the file exists with 4 lines?

```cpp
ifstream in("words.txt");
string w;
int count = 0;
while (in >> w) count++;
cout << count;
```

- a) 4 — the file has 4 lines, one word each
- b) 0
- c) 1
- d) unknown without the word count per line

**Q8.** [Medium] Writing `out << name << "," << marks << "\n";` produces…

- a) a binary record
- b) one CSV-style line per student
- c) a compile error
- d) output only after program exit

**Q9.** [Hard] `stock.txt` holds `Pen 3\nPad 990\n`. What does this print?

```cpp
ifstream in("stock.txt");
string name; int qty;
while (in >> name >> qty)
    if (qty < 10) cout << name << " ";
```

- a) `Pen ` — the low-stock filter over streamed records
- b) `Pad `
- c) `Pen Pad `
- d) nothing

**Q10.** [Hard] A program reads a file, averages the numbers, and must also
*append* the average as a final line. The safe structure is…

- a) read to EOF in the same stream, then immediately `out << avg;` on that
  stream after reopening for append — two opens, two purposes
- b) read and append interleaved on one ofstream
- c) append first, read later
- d) keep the ifstream and cast it to ofstream

**Q11.** [Hard] `marks.txt` holds `Ayesha,88\nBilal,72\n`. What does this
print?

```cpp
ifstream in("marks.txt");
string line;
int total = 0, count = 0;
while (getline(in, line)) {
    size_t comma = line.find(',');
    if (comma == string::npos) continue;
    total += stoi(line.substr(comma + 1));
    count++;
}
cout << total << "/" << count;
```

- a) `160/2`
- b) `88/1`
- c) `160/1`
- d) nothing — stoi cannot read from files

**Q12.** [Hard] The deepest reason `if (!in)` after opening matters: a failed
open…

- a) throws immediately, so the check is redundant
- b) leaves the stream in a fail state — every subsequent read is a no-op,
  and averages computed over zero records would print `nan` or lie
- c) terminates the program automatically
- d) only matters on Windows

<details markdown="1">
<summary><strong>T6 — Answer key</strong></summary>

**Q1 — b.** Input file stream = reading. `ofstream` writes; `fstream` does
both with a mode argument.

**Q2 — b.** Plain ofstream truncates. Data loss by default — `ios::app` is
the opt-in for preserving.

**Q3 — b.** The stream converts to false when its state failed — the
idiomatic open check.

**Q4 — a.** Three successful extractions; the fourth fails at EOF, ending
the loop. count and sum accumulate over exactly the records read.

**Q5 — b.** getline = line grain, spaces preserved, newline consumed. This
is why CSV-with-spaces must be read this way (Q11).

**Q6 — b.** `ios::app` — every write lands at the current end. The log file
grows across runs; nothing is ever truncated.

**Q7 — a.** `>>` skips newlines; four words → four passes. Lines and words
are different currencies — this loop counts words even across line breaks.

**Q8 — b.** Stream operators format text exactly like cout. The comma and
newline are the CSV structure you are writing by hand.

**Q9 — a.** Two records stream in; only `Pen 3` passes the `< 10` filter.
Records + business rule + streaming — the file labs' whole shape in four
lines.

**Q10 — a.** One open per purpose: ifstream to EOF, close, ofstream with
ios::app for the final line. Interleaving on one stream (b) invites
read/write position chaos.

**Q11 — a.** Two lines split cleanly; stoi converts "88" and "72" → 160 over
2 records. The defensive `continue` skips malformed lines rather than
crashing.

**Q12 — b.** The silent-failure chain is the whole danger: no error, empty
data, a program that "works" and reports nonsense. The open check converts
silence into a handled event.
</details>

---

## T7 — Memory & pointers (Unit 13)

**Q1.** [Easy] Which stores the *address* of `x`?

- a) `int p = x;`
- b) `int* p = &x;`
- c) `int& p = x;`
- d) `int p = *x;`

**Q2.** [Easy] `cout << *p;` where `p` points at `n` prints…

- a) the address of n
- b) the value of n
- c) the address of p
- d) nothing

**Q3.** [Easy] `nullptr` is…

- a) a dereference error
- b) the pointer value meaning "points at nothing"
- c) a type of int
- d) the address of main

**Q4.** [Medium] What does this print?

```cpp
int a = 3, b = 8;
int* p = &a;
p = &b;
cout << *p;
```

- a) 3
- b) 8 — the pointer was reseated to b
- c) 11
- d) the address of b

**Q5.** [Medium] What does this print?

```cpp
int arr[3] = {10, 20, 30};
int* p = arr;
cout << *p << *(p + 1);
```

- a) `1020`
- b) `10 20` without space — exactly `1020`
- c) `102030`
- d) addresses

**Q6.** [Medium] What does this print?

```cpp
void viaPointer(int* p) { *p = *p + 1; }
int main() {
    int v = 41;
    viaPointer(&v);
    cout << v;
}
```

- a) 41
- b) 42 — the function wrote through the address
- c) 0
- d) the address of v

**Q7.** [Medium] What does this print?

```cpp
int* data = new int[3];
data[0] = 5; data[1] = 6; data[2] = 7;
cout << data[1];
delete[] data;
```

- a) 5
- b) 6
- c) 7
- d) an error — delete before printing

**Q8.** [Medium] Which is a memory leak?

- a) `int* p = new int; delete p;`
- b) `int* p = new int;` with no delete before p goes out of scope
- c) `int x = 5;`
- d) `delete nullptr;` (safe, does nothing)

**Q9.** [Hard] What does this print?

```cpp
int a[4] = {2, 4, 6, 8};
int* end = a + 4;
int s = 0;
for (int* p = a; p < end; p++) s += *p;
cout << s;
```

- a) 20 — the pointer-walk sum
- b) 8
- c) 14
- d) an error — a + 4 is invalid

**Q10.** [Hard] What does this print?

```cpp
int x = 1;
int* p = &x;
int** pp = &p;
**pp = 99;
cout << x;
```

- a) 1
- b) 99 — two dereferences reach x
- c) the address of x
- d) undefined

**Q11.** [Hard] After `delete[] data;`, the variable `data`…

- a) becomes nullptr automatically
- b) still holds the old address — now dangling; reuse is undefined behavior
- c) points at a zeroed array
- d) is a compile error

**Q12.** [Hard] `int& r = x;` versus `int* p = &x;` — the deepest difference…

- a) none; both are addresses
- b) a reference is a permanent alias bound once (cannot be reseated, never
  null, used without `*`); a pointer is a re-pointable object holding an
  address
- c) references are slower
- d) pointers cannot point to ints

<details markdown="1">
<summary><strong>T7 — Answer key</strong></summary>

**Q1 — b.** `&` takes the address; `int*` stores it. (c) makes r a second
name for x — alias, not address-holder.

**Q2 — b.** Dereference follows the address to the value.

**Q3 — b.** The modern null pointer: testable (`if (p == nullptr)`), type-
safe, and dereferencing it is a loud runtime crash rather than silent
corruption.

**Q4 — b.** Pointers are re-pointable: after `p = &b`, *p reads b. One
variable, two targets over its life.

**Q5 — b.** `arr` decays to &arr[0]; p+1 advances one *element*. Output is
`1020` — no separator exists in the code.

**Q6 — b.** The address parameter let the function mutate v — the
pointer-flavored out-parameter. 41+1 = 42.

**Q7 — b.** Allocation, use, then release — the correct order. delete[] runs
*after* the print; the array is alive exactly as long as needed.

**Q8 — b.** The allocation is abandoned with no delete and no copy of the
pointer — unreachable memory, leak. (d) is famously safe: deleting nullptr
does nothing.

**Q9 — a.** The pointer-walk: p visits 4 elements, end is the one-past
position (legal to compare, illegal to dereference). Sum 20.

**Q10 — b.** pp → p → x: `**pp` is x. Two levels of indirection, one write.
Rare in practice, decisive for understanding what pointers *are*.

**Q11 — b.** delete does not null the pointer. The dangling address persists
— hence the course's null-after-delete habit: reuse then crashes loudly at
nullptr instead of corrupting quietly.

**Q12 — b.** The reference is an alias — bound at birth, cannot be null,
cannot be reseated. The pointer is itself an object — re-pointable, nullable,
requires `*`. Choosing between them is a design decision the course makes per
parameter.
</details>

---

## T8 — OOP & design (Units 14–15)

**Q1.** [Easy] `class` differs from `struct` only in…

- a) available features
- b) default member access: private for class, public for struct
- c) memory layout
- d) compilation speed

**Q2.** [Easy] A constructor…

- a) is named `init`
- b) shares the class name and runs at object creation
- c) must return void
- d) is optional for every class — always optional, never required… unless
  initialization is needed

**Q3.** [Easy] Encapsulation chiefly means…

- a) putting everything in one file
- b) private state plus a public interface that enforces the class's rules
- c) fast execution
- d) using structs only

**Q4.** [Medium] What does this print?

```cpp
class Meter {
    int v;
public:
    Meter() : v(0) {}
    void up()   { v++; }
    void down() { if (v > 0) v--; }   // the invariant: never negative
    int  get() const { return v; }
};
int main() {
    Meter m;
    m.down(); m.up(); m.up();
    cout << m.get();
}
```

- a) 1 — down() was refused at 0 by the guard
- b) 2
- c) −1
- d) 0

**Q5.** [Medium] What does this print?

```cpp
class P {
public:
    P()  { cout << "C"; }
    ~P() { cout << "D"; }
};
void make() { P p; }
int main() {
    make();
    cout << "!";
}
```

- a) `CD!`
- b) `CD!D` — no: only one object exists
- c) `CD!`
- d) `C!D`

**Q6.** [Medium] What does this print?

```cpp
class Box {
    int side;
public:
    Box(int s) : side(s) {}
    int area() const { return side * side; }
};
void show(const Box& b) { cout << b.area(); }
int main() {
    Box b(4);
    show(b);
}
```

- a) 16 — const& accepted; area() is const, callable on it
- b) compile error: area not const
- c) 4
- d) 0

**Q7.** [Medium] What does this print?

```cpp
class Chain {
    int v = 1;
public:
    Chain& twice() { v *= 2; return *this; }
    Chain& inc()   { v += 1; return *this; }
    int get() const { return v; }
};
int main() {
    Chain c;
    cout << c.twice().twice().inc().get();
}
```

- a) 5 — 1→2→4→5 via the returned *this
- b) 4
- c) 8
- d) 3

**Q8.** [Medium] Composition — a `Car` containing an `Engine` member — is
preferred over inheritance when the relationship is…

- a) is-a
- b) has-a
- c) both
- d) neither

**Q9.** [Hard] What does this print?

```cpp
class Stack {
    vector<int> data;
public:
    void push(int x) { data.push_back(x); }
    int pop() {
        int top = data.back();
        data.pop_back();
        return top;
    }
};
int main() {
    Stack s;
    s.push(1); s.push(2); s.push(3);
    cout << s.pop() << s.pop();
}
```

- a) `32` — LIFO: the last push comes off first
- b) `12`
- c) `33`
- d) `23`

**Q10.** [Hard] What does this print?

```cpp
class Item {
public:
    string name;
    int qty;
    Item(string n, int q) : name(n), qty(q) {}
};
ostream& operator<<(ostream& os, const Item& it) {
    return os << it.name << ":" << it.qty;
}
int main() {
    Item it("bolt", 40);
    cout << it;
}
```

- a) `bolt:40`
- b) `Item`
- c) an address
- d) a compile error

**Q11.** [Hard] A setter must reject a marks value outside 0–100. The
design that keeps the invariant safest is…

- a) public data member; callers are trusted
- b) private data + a setter that refuses invalid values (bool return or
  throw) + a constructor using the same path
- c) validation only in the printing function
- d) a global validity flag

**Q12.** [Hard] The destructor's defining property is…

- a) it must be called manually
- b) it runs automatically when the object's lifetime ends — the hook RAII
  uses for cleanup
- c) it returns the object's memory cost
- d) it can be overloaded per argument

<details markdown="1">
<summary><strong>T8 — Answer key</strong></summary>

**Q1 — b.** One default. Everything else — methods, constructors, access
specifiers — is identical. Convention: struct for open data bundles, class
for encapsulated state.

**Q2 — b.** Name = class name, no return type, runs at construction.
Options (b) and (d) are both true statements; (b) is the *definition*.

**Q3 — b.** The interface is the only door. Every modification passes
through code you control — where invariants live.

**Q4 — a.** down() at v=0 hits the guard and does nothing; up() twice → 1.
The invariant "never negative" is enforced *inside* the class — callers
cannot break it.

**Q5 — a.** One object, constructed in make() (C), destroyed when make()
returns (D), then `!`. Local lifetime = scope, again.

**Q6 — a.** The const& parameter binds without a copy; `area()` is a const
member, so calling it is legal. The const-correct pairing in action.

**Q7 — a.** Each method returns *this*, so calls chain on the same object:
1×2=2, ×2=4, +1=5.

**Q8 — b.** Has-a → composition (Engine is part of Car). Is-a earns
inheritance. When unsure, compose — it couples less.

**Q9 — a.** Pops: 3 then 2 → `32`. The class wraps a vector and enforces
LIFO — the stack adapter's logic, hand-built, which is the OOP module's
point.

**Q10 — a.** The free operator<< prints the fields; `cout << it` now works
like any built-in type. Operator overloading = giving your type cout
citizenship.

**Q11 — b.** One path, enforced at the type: the constructor routes through
the setter's validation, so no Item can exist with marks 150. Validation at
the boundary *and* at birth — T8's deepest question.

**Q12 — b.** Automatic, deterministic, at scope exit. That automation is
why destructors — not manual cleanup calls — power RAII and the whole
modern-toolkit argument.
</details>

---

**[← T1–T4](topic-tests-1.md) · [Cumulative tests →](cumulative-1.md) · [Hub](index.md)**
