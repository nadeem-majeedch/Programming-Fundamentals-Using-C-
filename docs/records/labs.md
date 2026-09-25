---
title: "Records Labs"
description: "6 record-keeping labs — student records, employee records, product inventory, library books, patient records, course registration — each with schema, test data, solution, and explanation."
---

# Records Labs (6 scenarios)

> [← Module home](index.md) · Attempt each lab's **student tasks** before opening its solution. Every lab: scenario → requirements → test data → student tasks → solution → explanation → ⭐ extensions. The **first deliverable in every lab is the schema** — struct + enum definitions with one-sentence field comments ([Lesson 3 §5](lesson-3-enums-design.md#5-organizing-related-data--the-design-habit)).

**Ground rules.** Procedural C++ — records, enums, arrays, functions ([Lesson 2's door rules](lesson-2-functions-nesting.md#1-passing-structures--three-doors)); no classes, no vectors. Every lab reuses the same skeleton discipline: `readX` factory → `printX` const& → per-field passes.

---

## Lab 1 — Student Records

**Scenario.** A tutor runs a 30-student class on paper. Digitize it: one menu program over a roster of records.

**Requirements.**
R1. Schema: `Student { std::string name; int score; }` with a `Grade` enum (A/B/C/D/F) *derived* — `Grade letterOf(int score)` with the course-standard bands (80/70/60/50).
R2. Menu: 1-add (validated, capacity-guarded) · 2-list (`Sr. | Name | Score | Grade` with the bridge) · 3-statistics (highest, lowest, average, pass count ≥ 50) · 4-sort by score descending · 5-quit.
R3. Construction through `readStudent()` only — no record is ever built elsewhere.
R4. The grade bridge is the *only* place that knows the bands — change 80→85 and exactly one function edits.

**Test data.**

| Input | Expected |
| --- | --- |
| scores 92, 78, 85, 49, 63 | grades A, C, B, F, D |
| statistics on that set | high 92, low 49, avg 73.4, pass 4 |
| sort then list | 92, 85, 78, 63, 49 |
| add when full (30) | `roster full` message, no crash |
| score 101 / −3 | rejected by the factory, re-prompted |

**Student tasks.**
1. Write the schema + `letterOf` + `gradeText` first; test the bridge standalone.
2. Then the roster passes — one function per menu option, all taking `const Student[]` except add/sort.
3. Reflection: the 85→A row in your trace — *which* function decided that? Follow it: list → letterOf. One source of truth.

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <iomanip>

struct Student { std::string name; int score; };
enum class Grade { A, B, C, D, F };

Grade letterOf(int score) {                 // the bands live HERE only
    if (score >= 80) return Grade::A;
    if (score >= 70) return Grade::B;
    if (score >= 60) return Grade::C;
    if (score >= 50) return Grade::D;
    return Grade::F;
}
const char* gradeText(Grade g) {
    switch (g) {
        case Grade::A: return "A"; case Grade::B: return "B";
        case Grade::C: return "C"; case Grade::D: return "D";
    }
    return "F";
}

Student readStudent() {                     // the only construction door
    Student s;
    std::cout << "name: ";
    std::getline(std::cin, s.name);
    do { std::cout << "score: "; std::cin >> s.score;
         if (s.score < 0 || s.score > 100) std::cout << "0-100 please\n"; }
    while (s.score < 0 || s.score > 100);
    std::cin.ignore(1000, '\n');
    return s;
}

void printRow(int sr, const Student& s) {
    std::cout << std::setw(3) << sr << " | " << std::setw(20) << std::left << s.name
              << " | " << std::setw(3) << std::right << s.score << " | "
              << gradeText(letterOf(s.score)) << '\n';
}

void statistics(const Student r[], int n) {
    if (n == 0) { std::cout << "empty\n"; return; }
    int hi = r[0].score, lo = r[0].score, total = 0, pass = 0;
    for (int i = 0; i < n; i = i + 1) {
        if (r[i].score > hi) hi = r[i].score;
        if (r[i].score < lo) lo = r[i].score;
        total += r[i].score;
        if (r[i].score >= 50) pass += 1;
    }
    std::cout << std::fixed << std::setprecision(1)
              << "high " << hi << " low " << lo << " avg " << (1.0 * total / n)
              << " pass " << pass << "/" << n << '\n';
}

void sortByScore(Student r[], int n) {
    for (int i = 0; i < n - 1; i = i + 1) {
        int best = i;
        for (int j = i + 1; j < n; j = j + 1)
            if (r[j].score > r[best].score) best = j;
        Student t = r[i]; r[i] = r[best]; r[best] = t;      // ONE move
    }
}

int main() {
    const int CAP = 30;
    Student roster[CAP];
    int count = 0;
    int choice;
    do {
        std::cout << "\n1-add 2-list 3-stats 4-sort 5-quit: ";
        std::cin >> choice; std::cin.ignore(1000, '\n');
        if (choice == 1) {
            if (count < CAP) { roster[count] = readStudent(); count += 1; }
            else std::cout << "roster full\n";
        } else if (choice == 2) {
            for (int i = 0; i < count; i = i + 1) printRow(i + 1, roster[i]);
        } else if (choice == 3) statistics(roster, count);
        else if (choice == 4) sortByScore(roster, count);
    } while (choice != 5);
}
```

**Explanation.** The design win to *feel*: `letterOf` and `gradeText` split the "what band?" question from the "how to show it?" question — the enum member travels through records and switches while the bands and the spelling each live in exactly one function. Every menu option is one pass over records; the sort's one-move swap is the parallel-arrays dividend, cashed.

**⭐ Extensions.** ⭐ Add "3b: class grade histogram" (count per Grade — the enum drives the tally array). ⭐⭐ Add name search (case-insensitive contains — [Unit 11](../strings/index.md) toolkit). ⭐⭐⭐ Add edit-with-revalidation (the `editX` pattern from C10).

---

## Lab 2 — Employee Records

**Scenario.** A small company's HR sheet: employees, grades, overtime. Your schema gets to be *nested* this time.

**Requirements.**
R1. Schema: `struct Name { std::string first; std::string last; }`, `struct Employee { Name who; Date joined; double base; int overtimeHours; Grade grade; }` — reuse the Date and Grade from Lab 1/E11 and [C7's rates].
R2. Menu: 1-hire (validated factory) · 2-directory (sorted by last name) · 3-payroll table (gross per [C7's rule]) · 4-find-by-surname (all matches) · 5-quit.
R3. `gross` is a **function** of the record — no stored gross field (derive, never store derived data).
R4. Directory sort compares `who.last` then `who.first` — the two-key comparison.

**Test data.**

| Employee | base | OT hrs | grade | gross (300/500/700 rates) |
| --- | --- | --- | --- | --- |
| Ali Raza, JUNIOR | 40000 | 5 | JUNIOR | 41500 |
| Sana Mir, SENIOR | 90000 | 2 | SENIOR | 91400 |
| Umar Farooq, MID | 60000 | 0 | MID | 60000 |
| Ayesha Khan, MID | 62000 | 3 | MID | 63500 |

Directory order (last name): Farooq, Khan, Mir, Raza. Payroll order (gross desc): Mir 91400, Khan 63500, Raza 41500, Farooq 60000 → *sort check*: 91400, 63500, 60000, 41500.

**Student tasks.**
1. Schema first — including the decision memo: why `Date joined` is a nested record and not three ints (one sentence).
2. The two-key comparator: write `bool comesBefore(const Employee& a, const Employee& b)` and use it in the sort — sorting logic never inlines the comparison.
3. Reflection: the payroll table sorts by a **derived** value. Where do you compute it (per comparison? into a helper array?) and why is *not storing* it still the right call?

**Solution (core functions).**

```cpp
double gross(const Employee& e) {                    // derived on demand — C7's rule
    double rate = 0.0;
    if (e.grade == Grade::JUNIOR)      rate = 300.0;
    else if (e.grade == Grade::MID)    rate = 500.0;
    else                               rate = 700.0;
    return e.base + e.overtimeHours * rate;
}

bool comesBefore(const Employee& a, const Employee& b) {   // two-key: last, then first
    if (a.who.last != b.who.last) return a.who.last < b.who.last;
    return a.who.first < b.who.first;
}

void sortByLastName(Employee staff[], int n) {       // selection sort, comparator-driven
    for (int i = 0; i < n - 1; i = i + 1) {
        int best = i;
        for (int j = i + 1; j < n; j = j + 1)
            if (comesBefore(staff[j], staff[best])) best = j;
        Employee t = staff[i]; staff[i] = staff[best]; staff[best] = t;
    }
}
```

**Explanation.** Two ideas to carry off: the **comparator function** (sort mechanics stay generic; *meaning* of order lives in one named function — swap "by last name" for "by gross" by writing one new comparator), and **derive-don't-store** (gross is always computed from the current base/OT — store it and a base edit makes the stored value a lie). Traces: Ali 40000 + 5×300 = 41500 ✓; Ayesha 62000 + 3×500 = 63500 ✓.

**⭐ Extensions.** ⭐ Anniversaries: employees whose `joined` anniversary falls in the current month (compare months only — Date components earn their keep). ⭐⭐ ⭐⭐⭐ Grade-raise: promote+raise with re-validation, printing a before/after table.

---

## Lab 3 — Product Inventory

**Scenario.** A campus store's stock: products with quantities and reorder levels. The enum makes its appearance as *state*.

**Requirements.**
R1. Schema: `enum class StockState { OK, LOW, OUT }`, `struct Product { std::string name; int qty; double price; int reorderAt; StockState state; }` — state is **derived** from qty via `stateOf(qty, reorderAt)` (qty ≤ 0 → OUT, < reorderAt → LOW, else OK), updated by one `refreshState(Product&)`.
R2. Menu: 1-receive shipment (`qty += n`) · 2-sell (`qty -= n`, refuse oversell) · 3-report (table: name, qty, price, state-text) · 4-value (Σ qty×price) · 5-reorder list (LOW and OUT items, by urgency: OUT first) · 6-quit.
R3. Selling never sets state directly — it changes qty and calls `refreshState`. One door to state.
R4. Refuse oversell *without* changing qty (validate, then mutate — the [C4 gate](challenges.md#c4)).

**Test data.**

| Action | Product (start qty) | Result qty → state |
| --- | --- | --- |
| sell 3 | Notebook (10, reorder 4) | 7 → OK |
| sell 4 | Notebook (7, reorder 4) | 3 → LOW |
| sell 3 | Notebook (3, reorder 4) | 0 → OUT |
| sell 1 | Notebook (0) | refused — `out of stock` |
| receive 20 | Notebook (0) | 20 → OK |
| value | Pens(50×Rs.30) + Notebooks(20×Rs.120) | Rs. 3900.0 |

**Student tasks.**
1. Schema + `stateOf` + `stockText` first; drive the state machine on the test table *by hand*.
2. Sell: write the guard, then the mutation, then `refreshState` — in that order, and note *why* the order matters.
3. Reflection: why is `state` stored at all, when it's derivable? (Hint: think about the *reorder report's* query pattern vs recomputing on every print — and what rule keeps the stored value honest: exactly one updater function.)

**Solution (core).**

```cpp
StockState stateOf(int qty, int reorderAt) {
    if (qty <= 0) return StockState::OUT;
    if (qty <  reorderAt) return StockState::LOW;
    return StockState::OK;
}
void refreshState(Product& p) { p.state = stateOf(p.qty, p.reorderAt); }

bool sell(Product& p, int n) {
    if (n <= 0 || p.qty < n) return false;      // validate BEFORE mutate
    p.qty -= n;
    refreshState(p);                            // one door to state
    return true;
}
bool receive(Product& p, int n) {
    if (n <= 0) return false;
    p.qty += n;
    refreshState(p);
    return true;
}
```

**Explanation.** The lab's teaching point is **single-source state**: `state` is derivable, but caching it in the record is a legitimate performance/reading choice *only* when every mutation path funnels through `refreshState` — the same discipline Unit 15's setters will enforce structurally. The reorder list is a two-priority pass (OUT before LOW): a comparator-driven sort or a two-sweep print, your documented choice. Value check: 50×30 + 20×120 = 1500 + 2400 = 3900 ✓.

**⭐ Extensions.** ⭐ Category enum (Stationery/Books/Other) with a per-category value report. ⭐⭐ Transaction history as a second record array (`Sale { productIndex; int qty; Date when; }`) — the parallel array that's *honest* because it's a different entity, not a parallel view of the same one.

---

## Lab 4 — Library Books

**Scenario.** The departmental library: circulation with rules. The full [C4 state machine](challenges.md#c4) becomes a working catalog.

**Requirements.**
R1. Schema: [E20's `LibraryBook`] plus `isbn` uniqueness enforced at add time (scan for duplicates — refuse).
R2. Menu: 1-add · 2-catalogue (all books with state-text) · 3-borrow (by ISBN, name + today's date) · 4-return (by ISBN) · 5-overdue list (BORROWED and due < today, via C1's `isBefore`) · 6-quit.
R3. Borrow/return return `bool` — the caller prints the refusal reason (already borrowed / not borrowed / unknown ISBN).
R4. Borrower name is the `""` sentinel when not borrowed — and *every* printer honours it (never prints an empty "with " line).

**Test data.**

| Step | Book | Expected |
| --- | --- | --- |
| add 2 books | C++ Primer, Little Prince | catalogue shows both AVAILABLE |
| add C++ Primer again | duplicate ISBN | refused |
| borrow C++ Primer (today 2026-09-23) | | BORROWED, due 2026-10-07, borrower recorded |
| borrow C++ Primer again | | refused: already borrowed |
| borrow Little Prince | | BORROWED |
| return Little Prince | | AVAILABLE, borrower cleared |
| overdue list (today 2026-10-10) | | C++ Primer listed (due 10-07 < today) |

**Student tasks.**
1. Schema + `stateText` + `findByIsbn` (returns an **index** — −1 convention — say why an index beats a pointer here).
2. The borrow/return gates from C4, now wired to menu + ISBN lookup.
3. Reflection: `findByIsbn` returning −1 vs `nullptr` — both conventions exist in the course. State the rule for choosing (searching an *array* → index; searching *dynamic/linked* structures → pointer; the array needs no nulls, the linked world lives on them).

**Solution (core).**

```cpp
int findByIsbn(const LibraryBook shelf[], int n, const std::string& isbn) {
    for (int i = 0; i < n; i = i + 1)
        if (shelf[i].isbn == isbn) return i;
    return -1;
}

bool borrow(LibraryBook& b, const std::string& who, const Date& today) {
    if (b.status != BookStatus::AVAILABLE) return false;
    b.status = BookStatus::BORROWED;
    b.borrower = who;
    b.due = addDays(today, 14);          // the documented 14-day loan; addDays from C1/C4
    return true;
}
bool giveBack(LibraryBook& b) {
    if (b.status != BookStatus::BORROWED) return false;
    b.status = BookStatus::AVAILABLE;
    b.borrower = "";
    return true;
}
```

**Explanation.** The catalogue is now a **state machine with an index**: enum states, guarded transitions, and a search convention that returns a position rather than a copy (so borrow/return mutate the *shelf's* record — `shelf[i]` passed by reference through the index). The overdue list composes three unit-skills: enum state filter + `isBefore` (record comparison) + the printing discipline. Due-date check: 2026-09-23 + 14 = 2026-10-07 ✓.

**⭐ Extensions.** ⭐⭐ Borrow limit: a borrower's name may appear on at most 2 BORROWED books (a count pass before the gate). ⭐⭐⭐ Fine report: for overdue books, days-late × Rs.10 per book, as a record array (the [C3 rule](challenges.md#c3): return values, print reports).

---

## Lab 5 — Patient Records

**Scenario.** A ward round tool — the **generic programming scenario**: any clinic's daily triage and round report. (Deliberately generic: no medical knowledge required, only records doing record work.)

**Requirements.**
R1. Schema: `enum class Ward { GENERAL, ICU, MATERNITY, PAEDIATRIC }`, `struct Patient { int id; Name who; int age; Ward ward; bool critical; Date admitted; }` — Name and Date nested ([E22's seed](exercises.md#s22), grown up).
R2. Menu: 1-admit (validating factory: unique id, age 0–120, admission date via `readDate`) · 2-ward round (per-ward patient list) · 3-critical list (cross-ward, top priority first: critical → then lowest id) · 4-discharge (by id; removes from the array — the shift-left) · 5-census (counts per ward + total) · 6-quit.
R3. The ward round groups by **enum** — the outer loop iterates Ward values ([E17's grouping trick](exercises.md#s17)).
R4. Discharge must keep records contiguous (shift) — the count stays the truth.

**Test data.**

| Patient | ward | critical | Round order | Census |
| --- | --- | --- | --- | --- |
| #1 Ali Raza, 34 | GENERAL | no | GENERAL: #1, #4 | GENERAL 2 |
| #2 Baby Sana, 0 | PAEDIATRIC | yes | ICU: #3 | ICU 1 |
| #3 Umar Farooq, 51 | ICU | yes | PAEDIATRIC: #2 | PAEDIATRIC 1 |
| #4 Ayesha Khan, 28 | GENERAL | no | MATERNITY: (none) | MATERNITY 0 |
| discharge #1 | | | GENERAL: #4 only — contiguous ✓ | GENERAL 1 |

**Student tasks.**
1. Schema + `wardText` + `findPatient` (id → index, −1 convention).
2. Admit: *unique-id scan before insert* — the duplicate gate from Lab 4's ISBN, reused.
3. Critical list: the three-key champion from [C6] simplified to two keys (critical desc, id asc).
4. Reflection: the census loop iterates **Ward values**, not patients. What property of enums makes that possible — and what would break the loop if a ward were a string?

**Solution (core).**

```cpp
void roundForWard(const Patient ward[], int n, Ward w) {
    std::cout << "-- " << wardText(w) << " --\n";
    bool any = false;
    for (int i = 0; i < n; i = i + 1)
        if (ward[i].ward == w) { printPatient(ward[i]); any = true; }
    if (!any) std::cout << "(empty)\n";
}
// census: for each Ward value, count matches — the enum IS the iteration plan
void discharge(Patient ward[], int& n, int id) {
    int i = findPatient(ward, n, id);
    if (i == -1) { std::cout << "no such id\n"; return; }
    for (int k = i; k < n - 1; k = k + 1) ward[k] = ward[k + 1];   // shift left
    n -= 1;                                                        // count stays the truth
}
```

**Explanation.** Three composable patterns, all procedural: **enum-driven grouping** (closed sets enumerate, strings don't — that's the R4 reflection's answer: a string's value set is open, so no outer loop over "all wards" can exist), **contiguity discipline** (discharge shifts left so `n` remains the record count — the array invariant from Unit 09), and **id-keyed access** (find-by-id → index → mutate through the index). The ward round prints per-ward headers whether or not patients exist — a report that silently omits empty wards looks like data loss.

**⭐ Extensions.** ⭐ Stay-days report: today − admitted per patient (C1's day arithmetic). ⭐⭐⭐ Transfer: change a patient's ward with a guard-chain (must exist; source ≠ target; target ward capacity 10).

---

## Lab 6 — Course Registration Data

**Scenario.** The registrar's end-of-day job: courses, registrations, and the enrolment report. Two record arrays cooperating — the [C5 join](challenges.md#c5), operationalized.

**Requirements.**
R1. Schemas: [E17's `Course`] + `Registration { int studentId; std::string courseCode; Date when; }`. Course codes are canonical uppercase (enforce at add: "cs101" → "CS101").
R2. Menu: 1-add course · 2-register (valid course code + unique (studentId, courseCode) pair — no double registration) · 3-drop (remove one registration) · 4-report (per course: code, title, level-text, count, capacity-filler %) · 5-course list for one student (by id) · 6-quit.
R3. Capacity: registration refused when the course is full (Course has `int capacity;`) — the guard prints both numbers.
R4. The report orders by count descending (the C5 index sort) and totals: courses, seats, taken, fill % (1 dp, cast rule).

**Test data.**

| Courses (cap 2 each) | Registrations | Expected |
| --- | --- | --- |
| CS101 (Beginner), CS201 (Advanced) | 1→CS101, 2→CS101, 1→CS201 | counts 2 and 1 |
| register 2→CS201, then 3→CS201 | | second refused: full (2/2) |
| register 1→CS101 again | | refused: duplicate pair |
| register "cs201" | | canonicalized → CS201, then full-refused |
| student 1's list | | CS101, CS201 |
| drop 1→CS101, re-report | | CS101 count 1 |

**Student tasks.**
1. Both schemas + `levelText` + `findCourse` (code → index).
2. The **double gate** on register: course exists → capacity → duplicate pair. Write the guard chain as three refusals with three distinct messages ([the guard-chain discipline](../decisions/index.md)).
3. Canonicalize-on-entry: one `toUpperCode()` helper ([Unit 11](../strings/lesson-3-find-modify.md)) applied at *add* and *register* — the data stays clean, not the queries.
4. Reflection: why is `(studentId, courseCode)` uniqueness a *pair* rule, and which loop shape checks it? (Nested scan: for each registration, does an earlier one match both fields?)

**Solution (core).**

```cpp
bool registerStudent(Registration regs[], int& regCount, const Course courses[], int courseCount,
                     int studentId, const std::string& rawCode) {
    std::string code = toUpperCode(rawCode);
    int ci = findCourse(courses, courseCount, code);
    if (ci == -1) { std::cout << "no such course\n"; return false; }
    if (countFor(regs, regCount, code) >= courses[ci].capacity) {
        std::cout << "full (" << countFor(regs, regCount, code)
                  << "/" << courses[ci].capacity << ")\n";
        return false;
    }
    for (int r = 0; r < regCount; r = r + 1)
        if (regs[r].studentId == studentId && regs[r].courseCode == code) {
            std::cout << "already registered\n"; return false;
        }
    regs[regCount] = {studentId, code, readDate()};
    regCount += 1;
    return true;
}
```

**Explanation.** The lab's design lesson: **two record types are joined by a key, not by indices** — `courseCode` is the string foreign key, and every operation (count, fill, list-for-student) is a traversal that matches on it. The three-refusal guard chain *is* the requirements section made executable; the canonicalization at entry is the data-cleaning principle that keeps every later comparison honest (the test table's lowercase case). Fill % = taken/capacity with the cast: 2/2 → 100.0%.

**⭐ Extensions.** ⭐ Waitlist record (`Waiting { studentId; courseCode; Date when; }`) promoted FIFO when a drop opens a seat — the queue pattern from the [iteration module](../repetition/index.md) with records. ⭐⭐⭐ Timetable clash check: a student can't register for two courses meeting at the same `Time` slot (add `int slot;` to Course — a third join dimension).

---

# Lab index

| Lab | Schema focus | The pattern it drills |
| --- | --- | --- |
| 1 | Student Records | derived enum + single-source bands; the one-move sort |
| 2 | Employee Records | nesting + comparator functions; derive-don't-store |
| 3 | Product Inventory | cached state with one updater door; validate-then-mutate |
| 4 | Library Books | guarded state machine + key lookup (−1 index convention) |
| 5 | Patient Records | enum-driven grouping + contiguity discipline |
| 6 | Course Registration | two record types joined by a key; triple guard chain |

**After the labs:** [The Student Record Management System](miniproject.md) — the capstone that assembles schemas, state machines, and joins into one program.
