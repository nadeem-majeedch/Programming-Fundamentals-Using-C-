---
title: "Cumulative Tests CU1–CU2 — Foundations through Collections"
description: "Two 15-question cumulative tests: CU1 covers everything through loops (Weeks 1–6), CU2 through arrays/vectors (Weeks 1–9) — mixing all question types with hidden answer keys."
---

# Cumulative Tests — CU1 and CU2

> 15 questions each · ~30 min each · **everything so far is fair game** —
> cumulative means the early material returns, mixed and combined ·
> attempt ALL before any key · [Hub](index.md) · [CU3–CU4 →](cumulative-2.md)

---

## CU1 — Everything through loops (Weeks 1–6)

**Q1.** [Easy] The command that compiles `lab.cpp` with the course's standard
flags is…

- a) `cpp lab.cpp`
- b) `g++ -std=c++17 -Wall -Wextra lab.cpp -o lab`
- c) `g++ lab -o lab.cpp`
- d) `run lab.cpp`

**Q2.** [Easy] What does `cout << 17 % 5;` print?

- a) 3
- b) 2
- c) 3.4
- d) 85

**Q3.** [Easy] Which reads a whole line with spaces?

- a) `cin >> line;`
- b) `getline(cin, line);`
- c) `cin.getline(line);`
- d) `read line;`

**Q4.** [Easy] `if (x = 5)` — what is wrong?

- a) nothing
- b) assignment used where comparison was intended; x becomes 5 and the
  condition is truthy
- c) x cannot be assigned in a condition
- d) the else branch is required

**Q5.** [Medium] What does this print?

```cpp
int x = 10;
if (x > 5) cout << "big";
if (x > 8) cout << "bigger";
if (x > 12) cout << "biggest";
```

- a) `big`
- b) `bigbigger` — two independent ifs both fire
- c) `bigbiggerbiggest`
- d) nothing

**Q6.** [Medium] What does this print?

```cpp
int total = 0;
for (int i = 1; i <= 4; i++)
    total += i;
cout << total;
```

- a) 4
- b) 10
- c) 6
- d) 24

**Q7.** [Medium] What does this print?

```cpp
int n = 6;
while (n > 0) {
    cout << n % 2;
    n /= 2;
}
```

- a) `011` — binary of 6 printed least-significant first
- b) `110`
- c) `6`
- d) infinite loop

**Q8.** [Medium] What does this print?

```cpp
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 2; j++)
        cout << i << j << " ";
}
```

- a) `00 01 10 11 20 21 `
- b) `00 10 20 01 11 21 `
- c) `00 01 02 `
- d) `01 11 21 `

**Q9.** [Medium] This loop should read numbers until 0, but has a bug:

```cpp
int x, sum = 0;
while (x != 0) {
    cin >> x;
    sum += x;
}
cout << sum;
```

The bug is…

- a) sum is not initialized (it is)
- b) x is tested *before ever being set* — uninitialized first test, and the
  sentinel 0 gets summed
- c) the loop must be a for
- d) sum should be a double

**Q10.** [Medium] What does this print?

```cpp
int balance = 1000;
int withdraw = 300;
if (withdraw > 0 && withdraw <= balance)
    cout << "ok";
else
    cout << "denied";
```

- a) ok
- b) denied
- c) okdenied
- d) nothing

**Q11.** [Hard] What does this print?

```cpp
int n = 4729;
int rev = 0;
while (n > 0) {
    rev = rev * 10 + n % 10;
    n /= 10;
}
cout << rev;
```

- a) 4729
- b) 9274
- c) 22
- d) 472

**Q12.** [Hard] What does this print?

```cpp
for (int row = 1; row <= 3; row++) {
    for (int s = 0; s < 3 - row; s++) cout << " ";
    for (int star = 0; star < 2 * row - 1; star++) cout << "*";
    cout << "\n";
}
```

- a) a centered pyramid — `  *` / ` ***` / `*****`
- b) a left-aligned triangle
- c) a solid block
- d) nothing

**Q13.** [Hard] A program must keep asking for a mark until it lands in
0–100. The correct loop is…

- a) `do { cin >> m; } while (m < 0 || m > 100);` — read, then repeat while
  invalid
- b) `while (m >= 0 && m <= 100) cin >> m;`
- c) `for (int i = 0; i < 100; i++) cin >> m;`
- d) `if (m < 0 || m > 100) cin >> m;`

**Q14.** [Hard] What does this print?

```cpp
int count = 0;
for (int i = 10; i <= 99; i++) {
    if (i % 7 == 0) count++;
}
cout << count;
```

- a) 12
- b) 13 — 14, 21, …, 98: thirteen multiples of 7
- c) 14
- d) 90

**Q15.** [Hard] The single most important habit when a loop misbehaves is…

- a) rewriting it as a different loop type immediately
- b) a trace table: variables as columns, passes as rows, update every cell
  honestly
- c) adding more output inside the loop
- d) deleting the loop

<details markdown="1">
<summary><strong>CU1 — Answer key</strong></summary>

**Q1 — b.** The standard invocation: standard, warnings, source, `-o` name.

**Q2 — b.** 17 = 3·5 + 2 → remainder 2.

**Q3 — b.** getline reads the whole line; `>>` stops at whitespace.

**Q4 — b.** The classic `=` vs `==` slip: assignment succeeds (x becomes 5),
its value 5 is truthy, the branch fires. Compilers warn; the habit is
reading warnings as errors.

**Q5 — b.** Two *independent* ifs: 10 > 5 and 10 > 8 both true, 10 > 12
false. An else-if ladder would print only `big`.

**Q6 — b.** 1+2+3+4 = 10. The accumulator against a bounded for.

**Q7 — a.** Parity print + halve: 6%2=0 (n→3), 3%2=1 (n→1), 1%2=1 (n→0).
Output `011` — 6 in binary is 110, printed in reverse. Binary decomposition
is the digit-peel loop with base 2.

**Q8 — a.** Outer i runs 0–2, inner j runs 0–1 per pass, completing fully
each time — row-major order.

**Q9 — b.** Two defects: the first test reads an uninitialized x (undefined),
and even with luck, the 0 gets added to sum. The clean form tests the read
itself: `while (cin >> x && x != 0)`.

**Q10 — a.** 300 > 0 and 300 ≤ 1000 → both sides true → ok. The && guard is
the withdrawal rule the bank labs enforce.

**Q11 — b.** The peel-and-rebuild: 9, then 7, then 2, then 4 → 9274. Reverse
by arithmetic.

**Q12 — a.** Padding `3−row` spaces then `2·row−1` stars per row — the
centered pyramid. Dependent bounds *both* matter: one shapes position, the
other width.

**Q13 — a.** Do-while fits: the first read must happen, then repetition
continues exactly while the value is invalid. (b) tests m before it exists;
(c) reads 100 times; (d) reads once.

**Q14 — b.** From 14 to 98 step 7: (98−14)/7 + 1 = 13. Counting multiples in
a range by the endpoints — the closed form behind the loop.

**Q15 — b.** The trace table is the course's universal loop debugger —
slower than hope, correct more often. Output (c) is a fine *supplement*, but
the table is what finds logic errors.
</details>

---

## CU2 — Everything through collections (Weeks 1–9)

**Q1.** [Easy] Which is a valid array declaration with initialization?

- a) `int a[3] = {1, 2, 3};`
- b) `int a[3] = 1 2 3;`
- c) `array a = [1, 2, 3];`
- d) `int[3] a = {1, 2, 3};`

**Q2.** [Easy] `vector<int> v;` — which reports how many elements it holds?

- a) `v.length()`
- b) `v.size()`
- c) `sizeof(v)`
- d) `v.count()`

**Q3.** [Easy] A function receiving `int a[]` also receives `int n` because…

- a) arrays cannot be looped otherwise
- b) the array parameter decays to a pointer; size is not conveyed
- c) n doubles as a return value
- d) the compiler demands it

**Q4.** [Medium] What does this print?

```cpp
int a[5] = {9, 4, 7, 1, 8};
int m = a[0];
for (int i = 1; i < 5; i++)
    if (a[i] < m) m = a[i];
cout << m;
```

- a) 9
- b) 1 — the min scan, seeded from the first element
- c) 4
- d) 29

**Q5.** [Medium] What does this print?

```cpp
vector<int> v = {3, 6, 9};
for (int x : v) cout << x * 2;
```

- a) `369`
- b) `61218` — the copy x doubled for output; v unchanged
- c) `6 12 18`
- d) `3 6 9`

**Q6.** [Medium] What does this print?

```cpp
int a[4] = {5, 10, 15, 20};
cout << a[1] + a[3];
```

- a) 25
- b) 30
- c) 15
- d) 35

**Q7.** [Medium] What does this print?

```cpp
vector<int> v;
for (int i = 0; i < 4; i++) v.push_back(i + 10);
cout << v.size() << ":" << v[2];
```

- a) `4:12`
- b) `4:13`
- c) `3:12`
- d) `4:10`

**Q8.** [Medium] What does this print?

```cpp
int a[6] = {1, 2, 3, 4, 5, 6};
int count = 0;
for (int i = 0; i < 6; i++)
    if (a[i] % 3 == 0) count++;
cout << count;
```

- a) 1
- b) 2 — 3 and 6
- c) 3
- d) 6

**Q9.** [Medium] A marks array must report how many students scored above the
average. The minimal structure is…

- a) one pass: sum and count-above simultaneously
- b) two passes: first sum → average, then count comparisons against it
- c) sort, then count from the top
- d) store marks in a string

**Q10.** [Medium] What does this print?

```cpp
double avg(int a[], int n) {
    long long s = 0;
    for (int i = 0; i < n; i++) s += a[i];
    return (double)s / n;
}
int main() {
    int a[3] = {7, 8, 9};
    cout << avg(a, 3);
}
```

- a) 8
- b) 8.0? No `setprecision` — cout prints `8`
- c) 24
- d) 7.5

**Q11.** [Hard] What does this print?

```cpp
vector<int> v = {4, 1, 7, 2};
int best = 0;
for (size_t i = 1; i < v.size(); i++)
    if (v[i] > v[best]) best = i;
cout << best << "@" << v[best];
```

- a) `2@7` — index tracking, then dereference at the end
- b) `7@2`
- c) `0@4`
- d) `3@2`

**Q12.** [Hard] What does this print?

```cpp
int a[5] = {3, 1, 4, 1, 5};
for (int i = 0; i < 4; i++)
    if (a[i] > a[i + 1]) {
        int t = a[i]; a[i] = a[i + 1]; a[i + 1] = t;
    }
for (int i = 0; i < 5; i++) cout << a[i];
```

- a) `13415` — one bubble pass: adjacent fixes only
- b) `11345` — fully sorted
- c) `31415`
- d) `51413`

**Q13.** [Hard] What does this print?

```cpp
int a[3][3] = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
int s = 0;
for (int i = 0; i < 3; i++) s += a[i][i];
cout << s;
```

- a) 15 — the main diagonal 1+5+9
- b) 45
- c) 12
- d) 5

**Q14.** [Hard] What does this print?

```cpp
vector<int> v = {5, 3, 8};
v[1] = v[0] + v[2];
for (size_t i = 0; i < v.size(); i++) cout << v[i];
```

- a) `5138` — index write: slot 1 became 5+8
- b) `538`
- c) `583`
- d) `1313`

**Q15.** [Hard] A student's marks analyzer prints the max but crashes for
empty input. The missing guard is…

- a) `if (n == 0) { print "no data"; return; }` — before any a[0] access
- b) a bigger array
- c) starting the loop at i = 0
- d) using double instead of int

<details markdown="1">
<summary><strong>CU2 — Answer key</strong></summary>

**Q1 — a.** Braced initialization fills elements in order.

**Q2 — b.** `size()` is the vector's element count. `sizeof` returns bytes of
the vector object, not its contents.

**Q3 — b.** Decay is the reason. The length parameter is the API convention
built on that fact.

**Q4 — b.** Min scan — the max pattern with `<`. Seeding from a[0] keeps it
correct for all-negative data.

**Q5 — b.** Range-for binds copies by default: x doubles for output, the
vector's elements untouched. `int& x` would have doubled the vector.

**Q6 — b.** a[1] = 10, a[3] = 20 → 30. Index arithmetic before sentiment.

**Q7 — a.** Pushed 10, 11, 12, 13 → size 4; index 2 is 12.

**Q8 — b.** 3 and 6 pass the `% 3` test → 2.

**Q9 — b.** The average is unknown until the sum is — pass 1 computes it,
pass 2 compares. Two passes exist because the data is *stored*; a streaming
version cannot know the average mid-stream.

**Q10 — b.** The function returns 8.0; default `cout` formatting prints `8`.
Formatting is presentation — the value is what the function owns.

**Q11 — a.** best walks to index 2 (value 7); output pairs position@value.
The index-as-artifact pattern.

**Q12 — a.** One bubble pass compares (3,1)→swap, (3,4)→ok, (4,1)→swap,
(4,5)→ok → `1 3 1 4 5`. One pass does not sort — it *bubbles*. The
full sort needs n−1 passes; seeing one pass proves you understand the
mechanism, not the slogan.

**Q13 — a.** The `i == j` identity selects the main diagonal: 1, 5, 9 → 15.

**Q14 — a.** v[1] = 5 + 8 = 13 → {5,13,8} printed without separators:
`5138`. Reads that look ambiguous (`5138`) are why the labs print
separators.

**Q15 — a.** Empty input has no a[0] to seed from — the guard must precede
every element access. Empty-collection handling is a first-class case in
every analyzer from here to the capstone.
</details>

---

**[← CU1…](cumulative-1.md) · [CU3–CU4 →](cumulative-2.md) · [Hub](index.md)**
