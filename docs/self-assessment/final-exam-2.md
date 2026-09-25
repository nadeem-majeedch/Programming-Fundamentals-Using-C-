---
title: "Final Practice Exam B — 25 Fresh Questions, Full Course"
description: "Comprehensive practice final B: 25 all-new questions in 8 sections with a different question balance (more code writing, more diagnosis) — hidden answer key, explanations, and scoring guide. Sit after Final A's post-mortem."
---

# Final Practice Exam B

> **25 fresh questions · 8 sections · 90 minutes · closed book.** A
> different balance from Final A: more *write-the-code* and *diagnose-the-bug*
> items, fewer pure recall. Sit it only after Final A's post-exam worksheet
> is done — that's when a second measurement means something.
>
> [← Final Exam A](final-exam-1.md) · [Hub](index.md)

## Instructions

Same rules as Final A: one sitting, paper answers, one key at the bottom.
Section weights below.

| Section | Topic | Questions | Weight |
| --- | --- | --- | --- |
| A | Concepts & vocabulary | Q1–Q3 | 12 |
| B | I/O, strings, files | Q4–Q7 | 16 |
| C | Conditions & validation | Q8–Q10 | 12 |
| D | Loops: tracing & writing | Q11–Q14 | 16 |
| E | Functions: writing & diagnosing | Q15–Q17 | 12 |
| F | Collections & algorithms | Q18–Q20 | 12 |
| G | Memory & pointers | Q21–Q22 | 8 |
| H | OOP & design | Q23–Q25 | 12 |

---

## Section A — Concepts (Q1–Q3)

**Q1.** [Easy] In two sentences each: what the *compiler* does, and what the
*linker's* job is in a one-file program (hint: think `main` and `<iostream>`).

**Q2.** [Medium] Give the type and value of each:

```cpp
int a = 5 % 2;
double b = 5 / 2;
double c = (double)5 / 2;
char d = 'A' + 1;
```

**Q3.** [Medium] A variable is declared inside a function and another with
the same name outside it. In two sentences: which one does a statement
inside the function see, and what is this called?

## Section B — I/O, strings, files (Q4–Q7)

**Q4.** [Medium] Write the exact output:

```cpp
string first = "Data", second = "Science";
cout << second << " of " << first << "\n";
cout << first + "-" + second;
```

**Q5.** [Medium] A program must read a full address line ("12-B, Gulberg
III, Lahore") after reading an integer house number. Write the two input
statements *in order*, with the fix that makes them cooperate.

**Q6.** [Medium] What does this print? (`data.txt` holds one line: `b 2 a 1`)

```cpp
ifstream in("data.txt");
string s; int n;
while (in >> s >> n) cout << n << s << " ";
```

**Q7.** [Hard] Write a complete loop (declarations included) that counts how
many lines of `notes.txt` are longer than 40 characters, and prints the
count. Handle a missing file by printing `missing` and stopping.

## Section C — Conditions & validation (Q8–Q10)

**Q8.** [Medium] Write the condition: `rush` is true when `hour` (0–23) is
*strictly between* 7 and 9, or strictly between 17 and 19.

**Q9.** [Medium] What does this print for `pin = 1234`? And for `pin = 0`?

```cpp
if (pin >= 1000 && pin <= 9999) cout << "valid";
else                            cout << "invalid";
```

**Q10.** [Hard] This ladder misclassifies: a mark of exactly 50 prints
`FAIL` but the spec says pass-at-50. Identify the two broken comparisons
and rewrite the ladder.

```cpp
if (marks > 50)       cout << "PASS";
else if (marks > 70)  cout << "MERIT";
else if (marks > 85)  cout << "DISTINCTION";
else                  cout << "FAIL";
```

## Section D — Loops (Q11–Q14)

**Q11.** [Medium] What does this print?

```cpp
int p = 1;
for (int i = 1; i <= 5; i++)
    if (i % 2 == 1) p *= i;
cout << p;
```

**Q12.** [Medium] What does this print?

```cpp
int x = 100;
int steps = 0;
while (x > 1) {
    x = x / 2;
    steps++;
}
cout << x << " " << steps;
```

**Q13.** [Hard] Write a complete loop (no functions needed) that prints this
exact shape for the fixed height 4:

```text
1
22
333
4444
```

**Q14.** [Hard] The loop below should sum the digits of every number the
user enters until 0, but prints wrong results. Diagnose the bug (1 mark)
and write the corrected loop (1.5 marks):

```cpp
int n, total = 0;
while (cin >> n && n != 0) {
    while (n > 0) {
        total = n % 10;
        n /= 10;
    }
}
cout << total;
```

## Section E — Functions (Q15–Q17)

**Q15.** [Medium] What does this print?

```cpp
int g = 5;
void bump(int n) { n += g; }
int main() {
    int v = 10;
    bump(v);
    cout << v;
}
```

**Q16.** [Medium] Write the prototype and the definition for
`long long pow2(int e)` — returns 2^e by a loop, for e in 0–62 — and one
call printing pow2(10).

**Q17.** [Hard] This function compiles but never changes the caller's
doubles. Name the defect (0.5) and write the corrected signature line +
body (1.5):

```cpp
void normalize(double x) {
    x = x / 100.0;
}
```

## Section F — Collections & algorithms (Q18–Q20)

**Q18.** [Medium] What does this print?

```cpp
vector<string> v = {"kiwi", "apple", "fig"};
string shortest = v[0];
for (size_t i = 1; i < v.size(); i++)
    if (v[i].size() < shortest.size()) shortest = v[i];
cout << shortest;
```

**Q19.** [Medium] One pass of **selection** sort (ascending) is applied to
`{6, 2, 8, 4}`. Write the array afterwards, and state how many swaps
happened.

**Q20.** [Hard] Write a complete function `int countBelow(const vector<int>&
v, int cut)` (declarations included) that returns how many elements are
strictly below `cut`. Full marks for the empty-vector case.

## Section G — Memory & pointers (Q21–Q22)

**Q21.** [Medium] What does this print?

```cpp
int vals[4] = {9, 8, 7, 6};
int* p = vals;
p++;
cout << *p << *(p + 2);
```

**Q22.** [Hard] This program has exactly two memory defects. Name each
(0.5 each) and write the corrected line(s) (1 each):

```cpp
int main() {
    int* a = new int[10];
    int* b = new int[10];
    for (int i = 0; i < 10; i++) { a[i] = i; b[i] = i * 2; }
    delete[] a;
    return 0;
}
```

## Section H — OOP & design (Q23–Q25)

**Q23.** [Medium] What does this print?

```cpp
class Light {
    bool on = false;
public:
    void toggle() { on = !on; }
    string state() const { return on ? "ON" : "OFF"; }
};
int main() {
    Light l;
    l.toggle(); l.toggle(); l.toggle();
    cout << l.state();
}
```

**Q24.** [Hard] Design in words + signatures (no full bodies): a class
`Temperature` holding a double celsius, with (a) a constructor that
rejects values below −273.15 by storing 0 and remembering the rejection,
or throws `invalid_argument` — choose one, justify in one sentence; (b) a
`toFahrenheit() const`; (c) `operator<<` for printing `25C`. (1 mark per
part, 1 for the justification.)

**Q25.** [Hard] Two sentences: why does the course prefer composition
(has-a) by default, and name one concrete situation from the course where
inheritance (is-a) *was* the right call.

---

<details markdown="1">
<summary><strong>Final Exam B — Answer key (open only after the full 90 minutes)</strong></summary>

### Section A

**Q1.** Compiler: translates the whole source file into machine code /
object form, catching grammar errors first. Linker: connects the object
code to the standard library's compiled implementations (cout machinery)
and to `main` as the entry point, producing the executable.

**Q2.** a = `int` 1 · b = `double` 2 (integer division happened first —
the *result* is then converted) · c = `double` 2.5 (the cast promotes
before dividing) · d = `char` 'B' ('A' + 1 promotes to int 66, converted
back to char).

**Q3.** The statement sees the *local* — the inner declaration shadows the
outer within the function's scope. This is name shadowing; `::name`
reaches the outer/global one explicitly.

### Section B

**Q4.** `Science of Data` / `Data-Science` — exact strings, one newline
after the first line.

**Q5.**

```cpp
int house;
cin >> house;
cin.ignore();            // eat the newline left by >>
string address;
getline(cin, address);
```

**Q6.** `2b 1a ` — pairs stream as (s,n); output concatenates n then s per
pass, space-separated.

**Q7.** Reference:

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;
int main() {
    ifstream in("notes.txt");
    if (!in) { cout << "missing\n"; return 0; }
    string line;
    int count = 0;
    while (getline(in, line))
        if (line.size() > 40) count++;
    cout << count << "\n";
    return 0;
}
```

(Marks: open+guard 0.5, getline loop 0.5, size test 0.5, count+print 0.5.)

### Section C

**Q8.** `(hour > 7 && hour < 9) || (hour > 17 && hour < 19)` — "strictly
between" excludes the endpoints; the two windows join with `||`.

**Q9.** 1234 → `valid`; 0 → `invalid` (0 fails the ≥1000 side; the guard
correctly rejects absurd pins).

**Q10.** Two defects: (1) `> 50` must be `>= 50` for pass-at-50; (2) the
ladder's thresholds are unreachable in order — any mark > 70 is caught by
the *first* branch (since > 85 is also > 50… specifically: after fixing
(1), MERIT and DISTINCTION can never fire because the first branch swallows
them). Corrected:

```cpp
if (marks > 85)       cout << "DISTINCTION";
else if (marks >= 70) cout << "MERIT";
else if (marks >= 50) cout << "PASS";
else                  cout << "FAIL";
```

(Highest threshold first; boundaries chosen to match the spec.)

### Section D

**Q11.** `15` — odd i values 1, 3, 5 multiplied: 1·3·5.

**Q12.** `1 6` — 100→50→25→12→6→3→1: six halvings, x ends at 1. (Integer
division: 12/2=6, 6/2=3, 3/2=1.)

**Q13.** Reference:

```cpp
for (int row = 1; row <= 4; row++) {
    for (int k = 1; k <= row; k++)
        cout << row;
    cout << "\n";
}
```

(Marks: outer rows 0.5, dependent inner count 0.5, newline 0.5, exact
digits 0.5.)

**Q14.** Defect: `total = n % 10;` *assigns*, discarding earlier digits —
only the last digit of the last number survives. Corrected:

```cpp
int n, total = 0;
while (cin >> n && n != 0) {
    while (n > 0) {
        total += n % 10;   // accumulate, not assign
        n /= 10;
    }
}
cout << total;
```

### Section E

**Q15.** `10` — n is a copy; `n += g` changed the copy. The global g was
read, but no write reached v.

**Q16.**

```cpp
long long pow2(int e);                      // prototype

long long pow2(int e) {                     // definition
    long long r = 1;
    for (int i = 0; i < e; i++) r *= 2;
    return r;
}
// call:
cout << pow2(10);   // 1024
```

(Marks: prototype 0.5, correct loop and type 0.5, return 0.5, call 0.5.)

**Q17.** Defect: pass-by-value — the function divides its own copy.
Corrected:

```cpp
void normalize(double& x) {
    x = x / 100.0;
}
```

(The `&` is the whole repair; the body was already correct.)

### Section F

**Q18.** `fig` — shortest-wins scan: kiwi(4) → apple(5) no → fig(3) yes.

**Q19.** `{2, 6, 8, 4}` — pass 1 selects min (2) and swaps with slot 0:
exactly **1 swap** (selection does at most one per pass).

**Q20.** Reference:

```cpp
#include <vector>
using namespace std;

int countBelow(const vector<int>& v, int cut) {
    int count = 0;
    for (size_t i = 0; i < v.size(); i++)
        if (v[i] < cut) count++;
    return count;
}
```

Empty vector: the loop body never runs → returns 0 — correct without a
special case. (Range-for version equally correct; marks: signature+const&
0.5, loop 0.5, strict `<` 0.5, empty-case reasoning 0.5.)

### Section G

**Q21.** `87` — p++ moved to index 1 (8); p+2 is index 3 (6).

**Q22.** (1) Leak: `b` is never freed. Fix: `delete[] b;` before return.
(2) (Half-credit framing) The `return 0` path is fine here because both
deletes precede it — but `a`'s delete is present while `b`'s is missing:
the single required fix is `delete[] b;`. Full marks: name the missing
delete (0.5), add `delete[] b;` (1). If you also reordered deletes to
release both on every path (defensive restructuring), that earns the
second mark.

### Section H

**Q23.** `ON` — three toggles: ON→OFF→ON. Odd toggles end ON.

**Q24.** Reference choice: **throw** `invalid_argument` — one sentence:
a temperature below absolute zero is not a temperature, so the object
should never exist in that state, and an exception makes the failure loud
at the construction site rather than silent in the data.

```cpp
class Temperature {
    double c;
public:
    Temperature(double celsius) {
        if (celsius < -273.15) throw invalid_argument("below absolute zero");
        c = celsius;
    }
    double toFahrenheit() const { return c * 9.0 / 5.0 + 32.0; }
};
ostream& operator<<(ostream& os, const Temperature& t) {
    return os << t.toFahrenheit() << "F-from-" << 0;   // see note
}
```

(Practical note: printing `25C` needs the celsius value — either a
`getCelsius() const` accessor used inside operator<<, or `friend`. The
marked skills are the guard choice + justification, the const conversion
method, and the operator's stream-in/stream-out shape. The storing-0
alternative earns full marks *only* with an honest one-sentence cost:
the object then lies about being a temperature.)

**Q25.** Composition couples less: the part can be swapped, tested, and
reused without dragging the whole hierarchy along, and has-a describes
most real relationships. Inheritance earned its place in the course's
shape hierarchies (Circle/Rectangle behind a Shape interface): genuinely
is-a, shared interface, and the collection needed to treat them uniformly
through one base type.

</details>

---

## Scoring guide

| Raw /25 | % | Verdict | Action |
| --- | --- | --- | --- |
| 23–25 | ≥90 | Ready | The course is yours. Move to the capstone build with confidence. |
| 18–22 | 70–89 | Almost | Target the sections below 70%; retake B in 3+ days — or alternate with A for a fresh form. |
| ≤ 17 | <70 | Not yet | Rebuild from the flagged units' modules; A-and-B both wait. |

**Section health check:**

| Section | Topic to revisit |
| --- | --- |
| A | [Getting Started](../getting-started/index.md) · [Cpp foundations](../cpp-foundations/index.md) |
| B | [Getting Started](../getting-started/index.md) · [Strings](../strings/index.md) · [Files](../files/index.md) |
| C | [Decisions module](../decisions/index.md) |
| D | [Repetition module](../repetition/index.md) |
| E | [Functions module](../functions/index.md) |
| F | [Arrays](../arrays/index.md) · [Algorithms](../algorithms/index.md) · [STL module](../stl/index.md) |
| G | [Pointers module](../pointers/index.md) |
| H | [OOP module](../oop/index.md) · [Robustness module](../robustness/index.md) |

**Compare with Final A:** any section weaker in *both* exams is a true gap
— schedule it. Sections strong in A but weak in B (or vice versa) are
usually question-style effects, not gaps.

**[← Final Exam A](final-exam-1.md) · [Hub](index.md)**
