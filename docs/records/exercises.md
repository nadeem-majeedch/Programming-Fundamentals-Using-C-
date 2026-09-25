---
title: "Records Exercises"
description: "22 progressive exercises — struct basics, functions and nesting, enums and design. Solutions separated at the end."
---

# Records Exercises (22)

> [← Module home](index.md) · ★ = first pass · ★★ = needs the toolkit · ★★★ = combines ideas

**How to use this page.** Attempt 15 minutes before opening any [solution](#solutions-s1--s22). The records habit: write the **struct definition first**, one sentence per field, before any function. ★ items need Lesson 1; ★★★ items combine all three lessons.

---

## Part A — Struct basics (★, E1–E8)

**E1.** Define `struct Point { int x; int y; };`. Declare two Points — one with a brace list, one empty then filled by member assignment. Print both in the form `(3, 4)`.

**E2.** The deep-copy proof: make `Point a = {3, 4}; Point b = a; b.x = 99;`. Print both. One sentence: what did `=` do, and what would the *parallel-array* equivalent have required?

**E3.** Define `struct Rectangle { double width; double height; };` and write `double area(Rectangle r)` (by value — say why that's fine here) and `void scale(Rectangle& r, double k)` (by reference — say why it must not be value). Test both.

**E4.** The ordering-rule demo: `struct Pair { int a; int b; };` — `Pair p = {5, 7};`. Without running it, state what `p.a` and `p.b` are. Then swap the *values in the brace list* and state the new contents. What defence does the lesson prescribe for 5+ field records?

**E5.** Define `Student` (name, score) and a `roster[3]` initialized with a brace-list array-of-records. Print a table: `Sr. | Name | Score` with `setw`. Compute and print the average (cast rule!).

**E6.** The swap drill: write the **one-move record swap** of roster[0] and roster[2] from E5's array, then write the parallel-array version as a comment block underneath — and count the lines.

**E7.** Read `n` (validated 1–50), then read `n` Student records into an array (name via getline + the [mixing-trap](../cpp-io/lesson-3-getline.md) ignore, score validated 0–100), then print the roster with the best scorer flagged with a `*`.

**E8.** Define `struct Counter { int value; };` and explain — with a tiny main — why a struct wrapping one int still *beats* a bare int for readability when the int means something specific (e.g. a student count vs a timeout in seconds). This is the strongest form of the "organizing" idea: two structs with the *same* members are still different types.

---

## Part B — Functions and nesting (★★, E9–E15)

**E9.** The three doors, one function each, all over `struct Temp { double celsius; };`: `printByValue(Temp t)`, `bumpByPointer(Temp* t, double by)`, `normalizeByRef(Temp& t)` (clamps into [−50, 50]). Write correct call lines for all three.

**E10.** Write `Student readStudent()` that builds and returns a record (validated), and `void readInto(Student& s)` that fills the caller's record (same validation). Then one sentence: when would you prefer which?

**E11.** Define `struct Date { int y; int m; int d; };` with `bool isValid(const Date&)` (year 1900–2100, month 1–12, day 1–31 — full month-length checking is the challenge's job, not this one) and `Date readDate()` using the guard-chain loop. Test with 2024-13-01 (rejected) and 2024-02-29 (accepted — fine at this precision).

**E12.** Define `Author` (name, birthYear) and `Book` (title, writer, price — nested!). Build one book with a nested brace list, then by member assignment. Print a catalogue line: `title (author, year) Rs. price`.

**E13.** Write `Book cheapest(const Book shelf[], int n)` returning the lowest-price book (guard n ≤ 0 by returning a documented "empty" book — `{"", {"", 0}, 0.0}` — and say in a comment why a returned record can't be null).

**E14.** Write `void applyDiscount(Book& b, double pct)` and explain why the parameter is **not** `const&` — then write `void printBook(const Book& b)` and explain why it **is**. Same type, opposite doors, one rule.

**E15.** The arrow drill: given `Book* p = &shelf[1];` write *both* spellings of printing the title (`(*p).title` and `p->title`), then write the loop that walks the whole shelf with only a pointer (no `[i]`) printing titles — the [Unit 13 traversal](../pointers/lesson-3-arrays-dynamic.md#arrays-as-addresses) over records.

---

## Part C — Enums and design (★★–★★★, E16–E22)

**E16.** Define `enum class Level { BEGINNER, INTERMEDIATE, ADVANCED };` and a `const char* levelText(Level)` bridge function. Print all three levels in a loop over an array of the three values.

**E17.** Define `struct Course { std::string title; int credits; Level level; };`, build three courses, and print a catalogue grouped by level — each group headed by its `levelText`.

**E18.** The input trap, demonstrated: given `enum class Level` from E16, show the compile error for `Level l = 1;`, the *legal-but-wrong* `static_cast<Level>(7)` — and what happens when a switch meets it — then write the honest `bool parseLevel(int code, Level& out)` with validation.

**E19.** Write the **menu mapper**: `bool pickLevel(int menuChoice, Level& out)` mapping 1–3 to the levels, and a loop that prints the menu, reads a choice, re-prompts on garbage, and prints the chosen level's text. (The boundary stays `int`; the logic stays enum.)

**E20.** Design drill (on paper, then code): a **LibraryBook** needs title, author, ISBN, status (Available/Borrowed/Reserved), borrower name (when borrowed), and due date. List the nouns, mark the closed set, name the nested record, then write the full schema with one-sentence field comments.

**E21.** Given this existing (bad) interface — `void report(std::string titles[], double prices[], int counts[], int n)` — rewrite it around a `Product` record. List exactly what improved (function signature, swap safety, self-documentation). Then state what *didn't* change: the array-is-a-handle fact and the count's travels.

**E22.** Capstone drill: combine everything — `struct Patient { int id; std::string name; Date admitted; bool critical; };` with: `readPatient` (validating factory), `printPatient` (const&), `countCritical(const Patient[], int)`, and a main that manages 3 patients and prints a ward report. (This is Lab 5's seed — do it small here.)

---

<a name="solutions-s1--s22"></a>
# Solutions (S1–S22)

<a name="s1"></a>
## S1 — Two Points

```cpp
struct Point { int x; int y; };
Point a = {3, 4};
Point b;
b.x = 10; b.y = 20;
std::cout << '(' << a.x << ", " << a.y << ")\n";   // (3, 4)
```
Brace list for known-at-birth values; member assignment for filled-later ones.

<a name="s2"></a>
## S2 — Deep-copy proof

`a` prints (3, 4), `b` prints (99, 4). `=` copied **both members** — a deep field-wise copy. The parallel-array equivalent needed two moves (`xa = xb; ya = yb;`) — the drift surface E2 exists to expose.

<a name="s3"></a>
## S3 — area and scale

```cpp
double area(Rectangle r) { return r.width * r.height; }   // small type, read-only: value is fine
void scale(Rectangle& r, double k) { r.width *= k; r.height *= k; }   // must modify the CALLER's
```
`area` by value: a 16-byte copy is cheaper than any ceremony, and the callee can't corrupt the caller's. `scale` by value would scale a *copy* — the caller's rectangle would never change, silently.

<a name="s4"></a>
## S4 — The ordering rule

`{5, 7}` binds positionally: a=5, b=7. Swapped list: a=7, b=5 — legal, silent, wrong. Defence for 5+ fields: member assignment (Way 3), where each value sits beside its name; brace lists stay for short, adjacent-to-definition cases.

<a name="s5"></a>
## S5 — Roster table

```cpp
Student roster[3] = { {"Ayesha Khan", 92}, {"Ali Raza", 78}, {"Sana Mir", 85}};
int total = 0;
for (int i = 0; i < 3; i = i + 1) {
    std::cout << std::setw(3) << i + 1 << " | "
              << std::setw(15) << std::left << roster[i].name << " | "
              << std::setw(3) << std::right << roster[i].score << '\n';
    total += roster[i].score;
}
std::cout << "average: " << (1.0 * total / 3) << '\n';
```

<a name="s6"></a>
## S6 — The swap drill

```cpp
Student t = roster[0]; roster[0] = roster[2]; roster[2] = t;   // one move
/* parallel version:
std::string tN = names[0]; names[0] = names[2]; names[2] = tN;
int    tS = scores[0]; scores[0] = scores[2]; scores[2] = tS;   // two moves — twice the drift surface */
```

<a name="s7"></a>
## S7 — Validated roster input

```cpp
int n;
std::cin >> n;
std::cin.ignore(1000, '\n');                 // before the getline loop
if (n < 1 || n > 50) return 0;
Student roster[50];
for (int i = 0; i < n; i = i + 1) {
    std::cout << "name: ";
    std::getline(std::cin, roster[i].name);
    do { std::cout << "score: "; std::cin >> roster[i].score;
         if (roster[i].score < 0 || roster[i].score > 100) std::cout << "0-100 please\n"; }
    while (roster[i].score < 0 || roster[i].score > 100);
    std::cin.ignore(1000, '\n');             // after every >> that precedes a getline
}
int best = 0;
for (int i = 1; i < n; i = i + 1) if (roster[i].score > roster[best].score) best = i;
for (int i = 0; i < n; i = i + 1)
    std::cout << roster[i].name << (i == best ? " *" : "") << '\n';
```

<a name="s8"></a>
## S8 — The one-member struct

```cpp
struct StudentCount { int value; };
struct TimeoutSecs  { int value; };
void enroll(StudentCount n);        // enroll(timeout_in_seconds) does not compile!
```
Two types with identical members are still **different types** — the struct makes the *unit of meaning* part of the type system. A bare `int` accepts anything; a named record documents and enforces. (This is the seed of *strong typing* — and of Unit 15.)

<a name="s9"></a>
## S9 — Three doors, one type

```cpp
void printByValue(Temp t)            { std::cout << t.celsius << '\n'; }
void bumpByPointer(Temp* t, double by) { if (t) t->celsius += by; }
void normalizeByRef(Temp& t) {
    if (t.celsius < -50) t.celsius = -50;
    if (t.celsius >  50) t.celsius =  50;
}
// calls:
printByValue(lab);          // a copy prints
bumpByPointer(&lab, 2.5);   // the address goes in; the target changes
normalizeByRef(lab);        // the alias modifies directly
```

<a name="s10"></a>
## S10 — readStudent vs readInto

```cpp
Student readStudent() { Student s; /* read into s, validate */ return s; }
void    readInto(Student& s) { /* read into s, validate */ }
```
Return the record when the caller *wants a new value* (`Student a = readStudent();`); use the reference when filling **an existing** record (`readInto(roster[count]);`) — no extra copy, and the intent ("fill this one") is visible at the call.

<a name="s11"></a>
## S11 — Date with rules

```cpp
bool isValid(const Date& d) {
    return d.year >= 1900 && d.year <= 2100
        && d.month >= 1 && d.month <= 12
        && d.day   >= 1 && d.day   <= 31;
}
Date readDate() {
    Date d;
    do {
        std::cout << "yyyy mm dd: ";
        std::cin >> d.year >> d.month >> d.day;
        if (!isValid(d)) std::cout << "invalid - try again\n";
    } while (!isValid(d));
    return d;
}
```
2024-13-01 → rejected (month); 2024-02-29 → accepted (day ≤ 31 — the coarse check; month-length precision is the challenge tier).

<a name="s12"></a>
## S12 — Nested Book

```cpp
Book b = {"The Little Prince", {"Antoine de Saint-Exupéry", 1900}, 9.99};
std::cout << b.title << " (" << b.writer.name << ", " << b.writer.birthYear
          << ") Rs. " << b.price << '\n';
```
The nested brace binds positionally: title, then the inner pair, then price. Reading descends: `b.writer.name` = b's writer, the writer's name.

<a name="s13"></a>
## S13 — cheapest

```cpp
// No null possible for a returned record: a record IS a value — the "empty" book
// is the documented nothing (check its empty title at the call site if needed).
Book cheapest(const Book shelf[], int n) {
    int best = 0;
    for (int i = 1; i < n; i = i + 1)
        if (shelf[i].price < shelf[best].price) best = i;
    return shelf[best];
}
```

<a name="s14"></a>
## S14 — The door rule, twice

`applyDiscount(Book& b, ...)` — it **must modify** the caller's record, so a reference; `const&` would forbid the write. `printBook(const Book& b)` — read-only and potentially large, so **no copy + compiler-enforced protection**. One rule, two doors: modify → `&`; read-only → `const&`.

<a name="s15"></a>
## S15 — The arrow drill

```cpp
std::cout << (*p).title << '\n';   // explicit: follow, then dot
std::cout << p->title << '\n';     // the humane spelling

for (const Book* q = shelf; q != shelf + n; q = q + 1)
    std::cout << q->title << '\n';
```
The pointer walk composes both lessons: arithmetic strides by `sizeof(Book)`, and `->` reads each record's field.

<a name="s16"></a>
## S16 — Level bridge

```cpp
enum class Level { BEGINNER, INTERMEDIATE, ADVANCED };
const char* levelText(Level l) {
    switch (l) {
        case Level::BEGINNER:     return "beginner";
        case Level::INTERMEDIATE: return "intermediate";
        case Level::ADVANCED:     return "advanced";
    }
    return "?";
}
Level all[] = {Level::BEGINNER, Level::INTERMEDIATE, Level::ADVANCED};
for (int i = 0; i < 3; i = i + 1) std::cout << levelText(all[i]) << '\n';
```

<a name="s17"></a>
## S17 — Grouped catalogue

```cpp
Course courses[3] = {
    {"Intro to Programming", 3, Level::BEGINNER},
    {"Data Structures",      4, Level::ADVANCED},
    {"OOP Fundamentals",     3, Level::INTERMEDIATE},
};
// group by level: iterate the enum values as the OUTER loop
Level order[] = {Level::BEGINNER, Level::INTERMEDIATE, Level::ADVANCED};
for (int g = 0; g < 3; g = g + 1) {
    std::cout << "-- " << levelText(order[g]) << " --\n";
    for (int i = 0; i < 3; i = i + 1)
        if (courses[i].level == order[g])
            std::cout << "  " << courses[i].title << " (" << courses[i].credits << " cr)\n";
}
```
The grouping trick: the *enum* drives the outer loop — closed sets enumerate naturally.

<a name="s18"></a>
## S18 — The input trap, fully

`Level l = 1;` — compile error (no int→enum-class conversion). `static_cast<Level>(7)` — compiles, produces a value **no member has**; a switch over it matches no case and (without a `default`) falls straight through, silently doing nothing. Honest parse:

```cpp
bool parseLevel(int code, Level& out) {
    if (code < 0 || code > 2) return false;      // the closed set, enforced
    out = static_cast<Level>(code);
    return true;
}
```

<a name="s19"></a>
## S19 — Menu mapper

```cpp
bool pickLevel(int menuChoice, Level& out) {
    switch (menuChoice) {
        case 1: out = Level::BEGINNER;     return true;
        case 2: out = Level::INTERMEDIATE; return true;
        case 3: out = Level::ADVANCED;     return true;
        default: return false;
    }
}
// loop: print menu; read int; if (!pickLevel(ch, lvl)) re-prompt; else print levelText(lvl)
```
The boundary stays `int` (input is int-shaped), the logic stays enum (state is name-shaped), and one mapping function owns the translation.

<a name="s20"></a>
## S20 — LibraryBook schema

```cpp
enum class BookStatus { AVAILABLE, BORROWED, RESERVED };

struct LibraryBook {
    std::string title;        // the book's title
    std::string author;       // author's full name
    std::string isbn;         // ISBN-13, kept as text (leading zeros!)
    BookStatus  status;       // the closed set — the circulation state
    std::string borrower;     // "" when not borrowed (the sentinel)
    Date        due;          // when BORROWED; ignored otherwise
};
```
Nouns → fields; the one closed set (status) became the enum; the due date is the nested record; the borrower's emptiness is the documented "not borrowed" signal. ISBN as **text** is a real-world lesson: it can start with 0 and contains dashes.

<a name="s21"></a>
## S21 — The interface rewrite

```cpp
struct Product { std::string title; double price; int count; };
void report(const Product items[], int n);
```
Improved: one parameter instead of three-arrays-plus-count; swaps/moves of a product are one assignment; the type documents itself. Unchanged: the array still crosses as a **handle** (no copy), and **the count still travels separately** — the [size convention](../arrays/lesson-3-arrays-functions.md) survives every abstraction level.

<a name="s22"></a>
## S22 — Patient capstone drill

```cpp
struct Patient { int id; std::string name; Date admitted; bool critical; };

Patient readPatient() {
    Patient p;
    std::cout << "id: ";            std::cin >> p.id;
    std::cin.ignore(1000, '\n');
    std::cout << "name: ";          std::getline(std::cin, p.name);
    std::cout << "admitted:\n";     p.admitted = readDate();
    std::cout << "critical (1/0): "; std::cin >> p.critical;
    std::cin.ignore(1000, '\n');
    return p;
}

void printPatient(const Patient& p) {
    std::cout << "#" << p.id << ' ' << p.name
              << " (admitted " << p.admitted.y << '-'
              << p.admitted.m << '-' << p.admitted.d << ')'
              << (p.critical ? " [CRITICAL]" : "") << '\n';
}

int countCritical(const Patient ward[], int n) {
    int c = 0;
    for (int i = 0; i < n; i = i + 1) if (ward[i].critical) c += 1;
    return c;
}
```
The seed of Lab 5: a validating factory, a `const&` printer, a counting pass — the whole procedural toolkit around one designed record.
