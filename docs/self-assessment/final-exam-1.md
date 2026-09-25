---
title: "Final Practice Exam A — 25 Questions, Full Course"
description: "Comprehensive practice final A: 25 questions in 8 sections (concepts, I/O, conditions, loops, functions, collections & strings, files & memory, OOP & integration) under exam conditions — hidden answer key, explanations, and scoring guide."
---

# Final Practice Exam A

> **25 questions · 8 sections · 90 minutes · closed book — no compiler, no
> notes.** Write every answer on paper before opening the single key at the
> bottom. Section weights mirror the course's emphasis: the trace and
> predict questions are the heart of the exam.
>
> [Hub](index.md) · [Final Exam B →](final-exam-2.md)

## Instructions

1. **Time yourself** — 90 minutes, one sitting. The pacing below is per section.
2. Answer every question; there is no penalty for a wrong attempt.
3. **Scoring:** each question = 1 raw mark (some questions award partial marks
   as marked). Total = 25, weighted to 100.
4. After scoring, complete the post-exam worksheet at the bottom.

| Section | Topic | Questions | Time | Weight |
| --- | --- | --- | --- | --- |
| A | Core concepts | Q1–Q4 | 10 min | 16 |
| B | Input/output & strings | Q5–Q8 | 12 min | 16 |
| C | Conditions | Q9–Q11 | 10 min | 12 |
| D | Loops & tracing | Q12–Q15 | 16 min | 16 |
| E | Functions | Q16–Q18 | 12 min | 12 |
| F | Collections & algorithms | Q19–Q21 | 12 min | 12 |
| G | Files & memory | Q22–Q23 | 10 min | 8 |
| H | OOP & integration | Q24–Q25 | 8 min | 8 |

---

## Section A — Core concepts (Q1–Q4)

**Q1.** [Easy] Order the edit–compile–run cycle and state what each stage
consumes and produces.

**Q2.** [Easy] Give one difference between a *syntax error* and a *logic
error*, with one example of each.

**Q3.** [Medium] What are the values and types of `a` and `b`?

```cpp
int a = 7 / 2;
double b = 7 / 2.0;
```

**Q4.** [Medium] Why does the course use `const` for values like tax rates?
Give two distinct reasons.

## Section B — Input/output & strings (Q5–Q8)

**Q5.** [Easy] Write the one missing line so this prints the name correctly:

```cpp
int age;
cin >> age;
// missing line here
string name;
getline(cin, name);
```

**Q6.** [Medium] What exactly does this print?

```cpp
cout << setw(6) << 42 << "|" << fixed << setprecision(1) << 2.45;
```

**Q7.** [Medium] What does this print?

```cpp
string s = "integration";
cout << s.size() << " " << s[4] << " " << s.substr(2, 4);
```

**Q8.** [Hard] A user types `Ali Hassan` for a name prompt read with
`cin >> name;`. State exactly what `name` holds, what happens to `Hassan`,
and which statement should have been used.

## Section C — Conditions (Q9–Q11)

**Q9.** [Medium] Rewrite correctly: "in stock if quantity is at least 1 and
at most 500".

```cpp
bool inStock = (qty >= 1) || (qty <= 500);   // fix this line
```

**Q10.** [Medium] What does this print for `t = 72`?

```cpp
if (t >= 90)      cout << "A";
else if (t >= 80) cout << "B";
else if (t >= 70) cout << "C";
else              cout << "F";
```

**Q11.** [Hard] What does this print for `x = 5`? Explain the truth of each
condition in one clause.

```cpp
if (x > 3 && x < 10)   cout << "P";
if (x > 3 || x < 10)   cout << "Q";
if (x < 3 && x < 10)   cout << "R";
```

## Section D — Loops & tracing (Q12–Q15)

**Q12.** [Medium] What does this print?

```cpp
int sum = 0;
for (int i = 2; i <= 8; i += 2)
    sum += i;
cout << sum;
```

**Q13.** [Medium] What does this print?

```cpp
int n = 406;
while (n > 0) {
    cout << n % 10;
    n /= 10;
}
```

**Q14.** [Hard] Complete the trace table (0.5 marks per correct row) for:

```cpp
int a = 1, b = 1;
while (b < 20) {
    int next = a + b;
    a = b;
    b = next;
}
cout << a;
```

| Pass | a (start) | b (start) | next | a (end) | b (end) | loop continues? |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | | | | | | |
| 2 | | | | | | |
| 3 | | | | | | |
| 4 | | | | | | |
| 5 | | | | | | |

Then state the printed value.

**Q15.** [Hard] What does this print? Draw the nested-loop trace if unsure.

```cpp
for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= i; j++)
        cout << i * j << " ";
    cout << "| ";
}
```

## Section E — Functions (Q16–Q18)

**Q16.** [Medium] What does this print?

```cpp
int twist(int n) { return n * 3 - 1; }
int main() {
    cout << twist(twist(2));
}
```

**Q17.** [Medium] What does this print?

```cpp
void scale(int& v, int f) { v *= f; }
int main() {
    int x = 6;
    scale(x, 10);
    cout << x;
}
```

**Q18.** [Hard] Write a complete function `bool isPerfect(int n)` — true
when n equals the sum of its proper divisors (e.g. 28 = 1+2+4+7+14). Full
marks for correct handling of n < 2. (3 marks: guard 0.5, loop 1.5,
comparison 0.5, n<2 verdict 0.5.)

## Section F — Collections & algorithms (Q19–Q21)

**Q19.** [Medium] What does this print?

```cpp
vector<int> v = {5, 12, 9, 20, 3};
int best = v[0];
for (size_t i = 1; i < v.size(); i++)
    if (v[i] > best) best = v[i];
cout << best;
```

**Q20.** [Medium] After **one** pass of bubble sort (ascending, left to
right) on `{4, 7, 2, 9, 1}`, what is the array?

**Q21.** [Hard] The array `{3, 8, 12, 17, 25, 31}` is searched for `17` by
binary search. List the elements compared, in order. (1 mark per correct
comparison, −1 for a wrong one, floor 0; 0.5 for naming the found index.)

## Section G — Files & memory (Q22–Q23)

**Q22.** [Medium] `marks.txt` holds `Ali 70\nSara 95\n`. What does this
print?

```cpp
ifstream in("marks.txt");
string name; int m, total = 0, count = 0;
while (in >> name >> m) { total += m; count++; }
cout << count << " " << total;
```

**Q23.** [Hard] Circle each bug (1 mark each) and write the corrected line
(0.5 each):

```cpp
int main() {
    int* data = new int[5];
    if (data[0] == 0) return 0;      // (a)
    for (int i = 0; i <= 5; i++)     // (b)
        data[i] = i;
    delete data;                     // (c)
}
```

## Section H — OOP & integration (Q24–Q25)

**Q24.** [Medium] What does this print?

```cpp
class Wallet {
    int cents = 0;
public:
    void add(int c) { if (c > 0) cents += c; }
    int get() const { return cents; }
};
int main() {
    Wallet w;
    w.add(250); w.add(-30); w.add(50);
    cout << w.get();
}
```

**Q25.** [Hard] In one sentence each: (a) what `virtual` changes about a
method call through a base-class reference; (b) why the destructor is
called automatically and what that enables.

---

<details markdown="1">
<summary><strong>Final Exam A — Answer key (open only after the full 90 minutes)</strong></summary>

### Section A

**Q1.** Edit (produce/modify the `.cpp` source) → compile (`g++` reads
source, produces the executable; errors surface here) → run (the operating
system executes the executable; runtime errors and output surface here).

**Q2.** Syntax error = grammar violation caught by the compiler (e.g.
missing `;`). Logic error = legal program, wrong result (e.g. `a + b * c`
when `(a + b) * c` was meant).

**Q3.** `a` is `int` 3 (integer division truncates). `b` is `double` 3.5
(the 2.0 promotes the whole expression).

**Q4.** (1) One named place to read and change the rate — maintainability.
(2) Compiler-enforced immutability — accidental modification becomes a
compile error.

### Section B

**Q5.** `cin.ignore();` — discards the newline left by `>>` so getline
reads the real next line.

**Q6.** `    42|2.5` — width 6 right-aligns 42 (four leading spaces); 2.45
prints as 2.5 (one decimal, rounded).

**Q7.** `11 e ntgr` — size 11; s[4] is 'e'; substr(2,4) is 4 chars from
index 2: `ntgr`.

**Q8.** `name` holds `Ali`; `Hassan` waits in the buffer for the next `>>`
(read). Whole-name input needed `getline(cin, name)`.

### Section C

**Q9.** `bool inStock = (qty >= 1) && (qty <= 500);` — a range is a
conjunction; `||` admits every number.

**Q10.** `C` — 72 fails ≥90 and ≥80, satisfies ≥70.

**Q11.** `PQ` — P: 5>3 true && 5<10 true → prints. Q: true || anything →
prints. R: 5<3 false, so the && is false → no R. Three independent ifs (not
a ladder) evaluate all three.

### Section D

**Q12.** `20` — 2+4+6+8.

**Q13.** `604` — digits peeled least-significant first: 6, 0, 4.

**Q14.** Trace rows:

| Pass | a | b | next | a→ | b→ | continues? |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 2 | 1 | 2 | yes |
| 2 | 1 | 2 | 3 | 2 | 3 | yes |
| 3 | 2 | 3 | 5 | 3 | 5 | yes |
| 4 | 3 | 5 | 8 | 5 | 8 | yes |
| 5 | 5 | 8 | 13 | 8 | 13 | yes — wait, b=13 < 20, continue; pass 6: next=21, a=13, b=21, stop |

Printed: `13` (a after the loop; the pass-6 row ends a=13, b=21, condition
false). Full marks for the printed 13; rows 1–5 as shown (the loop needs a
sixth pass — candidates who traced to 13 with 5 or 6 rows both earn the
printed-value mark; 0.5/row for any row consistent with *their* row count).

**Q15.** `1 | 2 4 | 3 6 9 | ` — inner products i·j for j ≤ i, one pipe per
row.

### Section E

**Q16.** `14` — twist(2) = 5; twist(5) = 14.

**Q17.** `60` — the reference multiplied the caller's x.

**Q18.** Reference solution:

```cpp
bool isPerfect(int n) {
    if (n < 2) return false;            // guard: 0, 1, negatives
    long long sum = 1;                  // 1 divides every n > 1
    for (int d = 2; d * d <= n; d++) {
        if (n % d == 0) {
            sum += d;
            if (d != n / d) sum += n / d;
        }
    }
    return sum == n;
}
```

(Simple divisor loop to n−1 also earns full marks; the √-bound version is
the course's efficiency idiom.)

### Section F

**Q19.** `20` — running max over the vector.

**Q20.** `{4, 2, 7, 1, 9}` — compare/swap pairs: (4,7) ok, (7,2) swap,
(7,9) ok, (9,1) swap → 9 bubbles to the end.

**Q21.** lo=0, hi=5, mid=2 → 12 (< 17, go right); mid=(3+5)/2=4 → 25
(> 17, go left); mid=3 → 17 found. Compared: **12, 25, 17**; index 3.

### Section G

**Q22.** `2 165` — two records streamed; totals accumulate.

**Q23.**
(a) `return 0` skips the delete → leak. Fix: delete before the return
(`delete[] data; return 0;`) — or restructure.
(b) `i <= 5` writes data[5] — out of bounds. Fix: `i < 5`.
(c) `delete` mismatches `new[]`. Fix: `delete[] data;`.

### Section H

**Q24.** `300` — 250 accepted, −30 refused by the class's guard, +50 → 300.

**Q25.**
(a) `virtual` makes the call follow the *object's actual type* at runtime
(the override runs), not the reference's declared type.
(b) The destructor runs automatically when the object's lifetime ends —
which is what lets an object's scope guarantee its cleanup (RAII): no
manual call, no forgotten one.

</details>

---

## Scoring guide

| Raw /25 | % | Verdict | Action |
| --- | --- | --- | --- |
| 23–25 | ≥90 | Ready | Sit the course material with confidence; take Final B after a week. |
| 18–22 | 70–89 | Almost | Re-study every section below 70%; retake A in 3+ days. |
| ≤ 17 | <70 | Not yet | Return to the flagged units' exercises and revision sheets before any retake. |

**Section health check** — a section below 50% points at a whole topic, not
a bad day:

| Section | Topic to revisit |
| --- | --- |
| A | [Getting Started](../getting-started/index.md) · [Unit 01–02 pages](../syllabus.md) |
| B | [Getting Started I/O pages](../getting-started/index.md) · [Strings module](../strings/index.md) |
| C | [Decisions module](../decisions/index.md) |
| D | [Repetition module](../repetition/index.md) |
| E | [Functions module](../functions/index.md) |
| F | [Arrays module](../arrays/index.md) · [Algorithms module](../algorithms/index.md) |
| G | [Files module](../files/index.md) · [Pointers module](../pointers/index.md) |
| H | [OOP module](../oop/index.md) · [Records module](../records/index.md) |

## Post-exam worksheet (write it out — it is the real exam)

1. List every missed question and the *one sentence* why (what you confused
   it with).
2. Mark each miss: **careless** (you knew it), **gap** (you didn't),
   **misread** (the answer was right for a different question).
3. For each *gap*, write the unit/module you will re-study and the date.
4. Retake when the worksheet's dates have passed — not before.

**Next:** [Final Exam B →](final-exam-2.md) · [Hub](index.md)
