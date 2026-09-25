---
title: "Records Challenges"
description: "10 design challenges — richer schemas, record algorithms, enum state machines, and the bridge to next unit's classes — with separated solutions."
---

# Records Challenges (10)

> [← Module home](index.md) · Attempt **30 minutes** before reading any solution — and **design the schema on paper first**: this page's challenges are won in the struct definitions. Solutions separated at the end. ★ = Lesson 1 · ★★ = adds Lesson 2 · ★★★ = combines everything.

---

## C1 — The full Date (★★)

Upgrade E11's coarse `isValid` to a **real** date validator: month lengths (30/31), the February leap rule (divisible by 4, except centuries unless divisible by 400 — so 2000 yes, 1900 no, 2024 yes). Then `bool isBefore(const Date& a, const Date& b)` — chronological ordering. Test: 1900-02-29 rejected, 2000-02-29 accepted, ordering across a month boundary.

## C2 — The sortable roster (★★)

Write `void sortByScore(Student roster[], int n)` — selection sort over **records** (the [arrays-module sort](../arrays/lesson-1-basics.md) ported): the swap is the one-move record swap, and ties keep their original order (strict `>`). Then a `void printRoster(const Student[], int)` and a driver that sorts descending and prints. One sentence: why did sorting get *easier* than in Unit 09?

## C3 — The inventory report (★★)

`struct Product { std::string name; int qty; double price; };` — over an array, produce: total stock value (Σ qty×price), the most-stocked product, and a **low-stock list** (qty < 5) printed as a table. All three functions take `const Product[]` — and none may sort or modify. Return-type drill: which of the three results should be **returned** as a record, and why can't all three be?

## C4 — The library state machine (★★★)

Using E20's `LibraryBook` schema: `bool borrow(LibraryBook& b, const std::string& who, const Date& today)` — refuses unless `AVAILABLE`, sets status/borrower/due (due = today + 14 days: reuse C1's date arithmetic or a simple day-count approximation, documented); `bool giveBack(LibraryBook& b)` — refuses unless `BORROWED`, clears borrower (the `""` sentinel), resets status. Write the 6-row test table (borrow, borrow again, return, return again, borrow a reserved book, return a fresh book).

## C5 — The registration counter (★★★)

`struct Registration { int studentId; std::string courseCode; Date when; };` over an array of registrations and a separate array of `Course` records (E17's, with `Level`): produce a per-course enrolment report — course title, level text, count — **ordered by count descending**. Two arrays of different records cooperating; the join is the course code. (No vectors — parallel traversal with the count convention.)

## C6 — The patient queue (★★★)

Ward triage: `struct Patient { ...; bool critical; int severity; }` — write `Patient nextForDoctor(Patient ward[], int n, bool& ok)` that **removes and returns** the highest-priority patient (critical first, then highest severity, then earliest id as tiebreak), shifting the rest left, setting `ok=false` on an empty ward. Return-the-record + out-param `bool` — the "found + value" convention ([Lesson 2 §2](lesson-2-functions-nesting.md#2-returning-structures)).

## C7 — The employee payroll (★★★)

`struct Employee { std::string name; double base; int overtimeHours; enum class Grade; }` — define `Grade { JUNIOR, MID, SENIOR }` with an overtime *rate* per grade (documented constants), compute `double gross(const Employee&)`, and produce a full payroll table sorted by gross descending, with a `const char* gradeText()` bridge. Which fields does `gross` need, and why is the function — not a stored field — the right home for the calculation?

## C8 — The merge of two rosters (★★★)

Two exam halls, each a `Student` array sorted by score descending: merge into one sorted array without re-sorting — the two-pointer walk ([arrays C6](../arrays/challenges.md)) over records. Capacity discipline: the output array's capacity is a parameter; document the overflow policy (stop + report how many fit, or refuse — pick one, write the contract).

## C9 — The schema critic (★★★)

Below is a colleague's schema. Write a **critique memo** (5–8 numbered points): what's wrong with types, what's a closed set posing as a string, what's a nested record begging to exist, what's a unit-less number, what's a sentinel without a documentation — then write the corrected schema.

```cpp
struct Person {
    std::string name;        // "Ali Raza" — but also "Ali" and "Ali Raza Khan"?
    std::string birth;       // "1999-05-14"
    std::string role;        // "student", "teacher", "staff"...
    int age;                 // recomputed? stored? both?
    std::string city;        // "Lahore", "lahore", "LHR"...
    double gpa;              // for staff too? negative values seen in the data
};
```

## C10 — The record toolkit (★★★ — the Unit 15 on-ramp)

Take the mini-project's `StudentRecord` and write the **five-function toolkit** every record deserves: `readX` (validating factory), `printX` (const&), `xEqualTo` (field-wise comparison — remember C++ gives records no `==`), `xText` (for its enum), and `editX` (reference param, re-validates). Then the reflection: list which of the five never mention the fields *inside* their callers — and why that encapsulation instinct is exactly what `private` will formalize next unit.

---

<a name="solutions"></a>
# Solutions (approaches + key code)

<a name="c1"></a>
<details markdown="1"><summary>C1 — Full Date</summary>

```cpp
bool isLeap(int y) {
    return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
}
bool isValid(const Date& d) {
    if (d.y < 1900 || d.y > 2100) return false;
    if (d.m < 1 || d.m > 12)      return false;
    int len[] = {31,28,31,30,31,30,31,31,30,31,30,31};
    int max = len[d.m - 1];
    if (d.m == 2 && isLeap(d.y)) max = 29;
    return d.d >= 1 && d.d <= max;
}
bool isBefore(const Date& a, const Date& d) {
    if (a.y != d.y) return a.y < d.y;
    if (a.m != d.m) return a.m < d.m;
    return a.d < d.d;
}
```
The leap rule's two clauses: every-4-except-centuries, unless divisible by 400. `isBefore` is **field-wise lexicographic** — compare years, then months, then days: the same descending-dots logic as string comparison, one level up. Tests: 1900-02-29 rejected (century, not ÷400); 2000-02-29 accepted; 2026-01-31 < 2026-02-01 ✓.
</details>

<a name="c2"></a>
<details markdown="1"><summary>C2 — Sortable roster</summary>

```cpp
void sortByScore(Student roster[], int n) {
    for (int i = 0; i < n - 1; i = i + 1) {
        int best = i;
        for (int j = i + 1; j < n; j = j + 1)
            if (roster[j].score > roster[best].score) best = j;   // strict >: ties keep order
        Student t = roster[i]; roster[i] = roster[best]; roster[best] = t;  // ONE move
    }
}
```
Easier than Unit 09 because the swap is one move — the record *is* the unit being sorted. In the parallel era, selection sort needed a two-array swap inside the inner loop (the drift surface lived inside the sort). Everything else — the two loops, the champion scan — transferred unchanged.
</details>

<a name="c3"></a>
<details markdown="1"><summary>C3 — Inventory report</summary>

```cpp
double stockValue(const Product items[], int n);          // returns a number
Product mostStocked(const Product items[], int n);        // RETURNS a record — a value question
void printLowStock(const Product items[], int n);         // produces formatted OUTPUT, not a value
```
One result is a record (mostStocked) — return it. One is a number (stockValue) — return it. The low-stock list is *many* records plus formatting: a function that prints is the honest shape; returning "the list" would need an array out-parameter — possible, but only worth it when the caller processes the list further. Rule: **return values, print reports.**
</details>

<a name="c4"></a>
<details markdown="1"><summary>C4 — Library state machine</summary>

```cpp
bool borrow(LibraryBook& b, const std::string& who, const Date& today) {
    if (b.status != BookStatus::AVAILABLE) return false;   // the state gate
    b.status   = BookStatus::BORROWED;
    b.borrower = who;
    b.due      = addDays(today, 14);      // C1's isBefore + a day-count walk, documented
    return true;
}
bool giveBack(LibraryBook& b) {
    if (b.status != BookStatus::BORROWED) return false;
    b.status   = BookStatus::AVAILABLE;
    b.borrower = "";                      // the documented sentinel = "nobody"
    return true;
}
```
Each function is a **guarded state transition**: refuse unless in the required state, mutate, confirm. Test table: borrow fresh ✓; borrow again ✗ (already BORROWED); return borrowed ✓; return again ✗; borrow a RESERVED book ✗ (not AVAILABLE); return a fresh book ✗. The enum + guard pattern *is* a state machine — and the `&` parameters are the whole mechanism: transitions must modify the caller's record.
</details>

<a name="c5"></a>
<details markdown="1"><summary>C5 — Registration counter</summary>

```cpp
// counts[ci] = number of registrations whose courseCode == courses[ci].code
int counts[MAXC] = {0};
for (int r = 0; r < regCount; r = r + 1)
    for (int c = 0; c < courseCount; c = c + 1)
        if (regs[r].courseCode == courses[c].code) counts[c] += 1;

// then an index sort by counts[] descending (sort INDICES, not records — records stay put)
int idx[MAXC];
for (int i = 0; i < courseCount; i = i + 1) idx[i] = i;
for (int i = 0; i < courseCount - 1; i = i + 1)
    for (int j = i + 1; j < courseCount; j = j + 1)
        if (counts[idx[j]] > counts[idx[i]]) { int t = idx[i]; idx[i] = idx[j]; idx[j] = t; }

for (int i = 0; i < courseCount; i = i + 1) {
    int c = idx[i];
    std::cout << courses[c].title << " [" << levelText(courses[c].level) << "] "
              << counts[c] << " enrolled\n";
}
```
Two techniques in one: the **join** (nested scan matching courseCode) and the **index sort** — permuting an index array so the course records never move (the trick you'll reuse whenever records are expensive to swap). Report prints through the indices.
</details>

<a name="c6"></a>
<details markdown="1"><summary>C6 — Patient queue</summary>

```cpp
Patient nextForDoctor(Patient ward[], int n, bool& ok) {
    if (n <= 0) { ok = false; Patient none = {}; return none; }
    int best = 0;
    for (int i = 1; i < n; i = i + 1)
        if (better(ward[i], ward[best])) best = i;      // critical first, then severity, then id
    Patient picked = ward[best];
    for (int i = best; i < n - 1; i = i + 1) ward[i] = ward[i + 1];   // shift left
    ok = true;
    return picked;
}
// better(): if (a.critical != b.critical) return a.critical;
//           if (a.severity != b.severity) return a.severity > b.severity;
//           return a.id < b.id;
```
The "found + value" convention: record returned, `bool&` reports success — and the empty-ward `Patient none = {};` is the documented zero record the caller only reads when `ok` is true. Removal-by-shift is the Unit 09 array pattern; the priority comparison is a **three-key champion** — each key checked only when the previous ties.
</details>

<details markdown="1"><summary>C7 — Employee payroll</summary>

```cpp
enum class Grade { JUNIOR, MID, SENIOR };
struct Employee { std::string name; double base; int overtimeHours; Grade grade; };

double gross(const Employee& e) {
    double rate = 0.0;                       // per-grade overtime rate, documented
    if (e.grade == Grade::JUNIOR) rate = 300.0;
    else if (e.grade == Grade::MID) rate = 500.0;
    else rate = 700.0;
    return e.base + e.overtimeHours * rate;
}
```
`gross` is a function, not a stored field, because it's **derived data**: storing it would create two copies of a fact (base+rate vs gross) that can drift — exactly the parallel-array disease in miniature. Derive on demand; store only the inputs. The payroll table sorts by the *derived* key — compute `gross` into a helper array (or compare on the fly with the index-sort trick from C5).
</details>

<details markdown="1"><summary>C8 — Merge of two rosters</summary>

```cpp
// Contract: out has capacity outCap; returns how many were written.
int mergeByScore(const Student a[], int na, const Student b[], int nb,
                 Student out[], int outCap) {
    int i = 0, j = 0, k = 0;
    while (i < na && j < nb && k < outCap) {
        if (a[i].score >= b[j].score) out[k++] = a[i++];   // one-move record copies
        else                          out[k++] = b[j++];
    }
    while (i < na && k < outCap) out[k++] = a[i++];
    while (j < nb && k < outCap) out[k++] = b[j++];
    return k;    // caller checks k < needed for overflow
}
```
The walk-two-pointers merge, record edition — each step copies **one record** (the deep-copy `=` doing the multi-field work the parallel version did in two statements). Capacity respected in every loop; the return value is the overflow report (the "stop and report" contract). Ties: `>=` pulls from `a` first — a documented stability choice.
</details>

<details markdown="1"><summary>C9 — Schema critique</summary>

Memo points (the corrected schema follows):

1. **`birth` as `"1999-05-14"` string** — unvalidatable, unorderable, un-componentizable → nest the `Date` record (gallery G9).
2. **`role` as free string** — a closed set {STUDENT, TEACHER, STAFF} posing as text → `enum class Role` (typos like "studen" become impossible).
3. **`age` stored next to `birth`** — derived data stored twice → delete `age`; compute from `birth` when asked (C7's rule).
4. **`city` free string** — inconsistent spellings already in the data ("Lahore"/"lahore"/"LHR") → either a `City` enum (if the set is closed for this system) or a documented canonicalization function; never raw input straight in.
5. **`gpa` unguarded `double`** — negatives observed; and meaningless for staff → validate at read (0.0–4.0), and consider making the GPA field optional/documented-empty for non-students (the sentinel rule).
6. **`name` doing three jobs** — if the system ever sorts by surname or prints "Khan, Ali", it needs structure → decide now: one full-name string (display-only) or nested Name{first, last} (queryable). The memo's job is forcing the decision, not picking it.

```cpp
enum class Role { STUDENT, TEACHER, STAFF };
struct Person {
    std::string name;      // full name, display + free-text search
    Date        birth;     // validated by C1's isValid
    Role        role;      // the closed set
    std::string city;      // canonicalized at read time
    double      gpa;       // 0.0–4.0; -1.0 documented = "not applicable (staff)"
};
```
(The gpa sentinel is deliberately −1.0, not 0.0 — 0.0 is a *real* GPA. Documented sentinels must be unreachable as real data — the [sentinel rule](../repetition/lesson-3-break-continue-sentinels.md).)
</details>

<details markdown="1"><summary>C10 — The record toolkit</summary>

```cpp
StudentRecord readX();                            // validating factory — no invalid record escapes
void          printX(const StudentRecord& s);     // const& — read-only, no copy
bool          xEqualTo(const StudentRecord& a, const StudentRecord& b);   // field-wise
const char*   xText(Status st);                   // the enum bridge
void          editX(StudentRecord& s);            // reference param; re-validates every edit
```
`xEqualTo` compares field by field — C++ generates no `==` for records, so the schema's author decides what "equal" means (all fields? id only? — document it; for a *record system*, id-only equality is usually the truth).

The reflection's answer: `readX`'s **callers** never touch fields — they say `StudentRecord s = readX();` and the record arrives valid. Same for `printX`'s callers. That field-hiding *at the call sites* is the instinct `private` formalizes: next unit the hiding becomes **enforced** (the compiler forbids field access from outside), the five functions become member functions, and the toolkit stops depending on discipline.
</details>
