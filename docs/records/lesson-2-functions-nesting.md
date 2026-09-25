---
title: "Lesson 2 — Moving Records Around"
description: "Passing structures to functions (value, pointer, const&), returning structures, nested structures, and a complete record-processing program."
---

# Lesson 2 — Moving Records Around

> [← Module home](index.md) · [← Lesson 1 — The struct](lesson-1-structs.md) · [Lesson 3 — Enums and design →](lesson-3-enums-design.md)

## In this lesson you will learn

- the three ways to **pass** a struct — by value, by pointer, and by `const&` — and the decision rule
- how to **return** a record (and when a record-returning function beats an out-parameter)
- **nested structures** — records whose fields are records, and how the dots descend
- a complete worked program that prints a formatted report over an array of records

---

<a name="1-passing-structures--three-doors"></a>
## 1. Passing structures — three doors

A struct is a first-class type: it crosses function boundaries by any of the routes you know. The *mechanisms* are pure [Unit 13](../pointers/index.md) — only the payload got bigger.

### Door 1 — by value (a copy crosses)

```cpp
void printStudent(Student s) {          // s is a FULL COPY of the argument
    std::cout << s.name << ": " << s.score << '\n';
    s.score = -1;                       // changes the copy only — harmless, pointless
}
// call:  printStudent(roster[0]);       — no & needed; the record walks in whole
```

The entire record is copied field by field — the free deep copy from [Lesson 1 §4](lesson-1-structs.md#initialization--three-ways-and-one-rule) at work. Small records: perfect. Large ones: wasteful, and the function *cannot* modify the caller's record.

### Door 2 — by pointer (the handle crosses)

```cpp
void bumpScore(Student* s, int by) {    // s holds the CALLER's record's address
    if (s == nullptr) return;           // pointers guard — the normal case
    s->score += by;                     // arrow operator: (*s).score, written humanely
}
// call:  bumpScore(&roster[0], 5);
```

New syntax, and it earns its place: `s->score` is shorthand for `(*s).score` — "follow the pointer, then use the dot." The parens-plus-star version is legal but noisy; the **arrow operator** is the humane spelling and the one real code uses.

When do structs travel as pointers? Exactly when [pointers earn their keep](../pointers/lesson-2-references-functions.md#two-jobs): arrays of records (the handle + count convention from Unit 09 — `Student* roster, int n`), optional records ("might not exist"), and ownership-heavy designs. One honest note for later: you may also meet `Student*` used as an *output* route in older code — in this course, references (below) are the default for that job.

### Door 3 — by reference (the alias crosses) — the course default

```cpp
void readInto(Student& s) {             // s IS the caller's record — a soldered alias
    std::cout << "name: ";
    std::getline(std::cin, s.name);     // no arrow, no star, no ceremony
    std::cout << "score: ";
    std::cin >> s.score;
}
// call:  readInto(roster[1]);          — no & at the call site
```

The [reference-parameter rule](../pointers/lesson-2-references-functions.md#two-jobs) applied to records: when the callee must modify the caller's record and it always exists, take a reference — the alias mechanics make it *the same box* with a new name.

### And the star of the show: `const&` — read-only, no copy

```cpp
void printBest(const Student& a, const Student& b) {   // no copy, no modification
    if (a.score >= b.score) std::cout << a.name << '\n';
    else                    std::cout << b.name << '\n';
}
```

`const Student&` is the **default door for big read-only records**: reference efficiency (no copy) with value safety (the compiler forbids modification). You have been living on this rung since Unit 09's `const std::string arr[]` — same promise, record-shaped.

### The decision table

| Situation | Door | Why |
| --- | --- | --- |
| Small record, read-only, want a snapshot | **value** | copy is cheap; callee can't touch the caller's |
| Callee must modify the caller's record | **`Student&`** | alias — the same box |
| Read-only, potentially large record | **`const Student&`** | no copy + compiler-enforced safety — *the default* |
| Array of records / optional / ownership | **`Student*`** | handle + count; nullable; re-aimable |
| Anything using `Student*` | guard `nullptr` | the pointer contract from Unit 13 |

---

<a name="2-returning-structures"></a>
## 2. Returning structures

Functions can hand back whole records:

```cpp
Student readStudent() {                 // build locally, return by value
    Student s;
    std::cout << "name: ";
    std::getline(std::cin, s.name);
    std::cout << "score: ";
    std::cin >> s.score;
    return s;
}
// call:  Student a = readStudent();    — the record comes back whole
```

`return s;` copies the record out — the same deep field-wise copy, in reverse. For course-sized records the copy is trivial, and the shape is beautiful: *a function that manufactures a value*.

Return-vs-outparameter — the course rule:

| Need | Choose |
| --- | --- |
| Produce a **new value** from inputs (compute, read-and-build) | **return the record** — `readStudent()`, `makeDefault(name)` |
| Fill in a record the caller already has | **reference parameter** — `readInto(s)` |
| Report "nothing found" | return a **pointer** (`nullptr`) or a `bool` + out-param |

### `Date` — the record with rules

A record type whose validity rules live in one function:

```cpp
struct Date {
    int year;
    int month;      // 1–12
    int day;        // 1–31
};

bool isValid(const Date& d) {
    if (d.year < 1900 || d.year > 2100) return false;
    if (d.month < 1 || d.month > 12)    return false;
    if (d.day < 1 || d.day > 31)        return false;
    return true;
}
```

And the factory function that *guarantees* validity, in the [guard-chain](../decisions/index.md) style:

```cpp
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

This is the pattern classes will industrialize in Unit 15: **construction goes through a checkpoint, so no invalid record ever exists.** For now, the discipline is a habit — the type system isn't enforcing it yet, *you* are.

---

<a name="3-nested-structures--records-inside-records"></a>
## 3. Nested structures — records inside records

Real data nests. A book has an author; an author has a name and a birth year:

```cpp
struct Author {
    std::string name;
    int    birthYear;
};

struct Book {
    std::string title;
    Author  writer;        // a record member — a record inside the record
    double  price;
};
```

Building and reading one — the dots **descend**:

```cpp
Book b;
b.title = "The Little Prince";
b.writer.name      = "Antoine de Saint-Exupéry";   // two dots: b's writer, the writer's name
b.writer.birthYear = 1900;
b.price = 9.99;

std::cout << b.writer.name;    // "Antoine de Saint-Exupéry"
```

Brace initialization nests the same way:

```cpp
Book c = {
    "The Little Prince",
    {"Antoine de Saint-Exupéry", 1900},   // the nested brace list — position-bound, like always
    9.99
};
```

```text
   Book c
  ┌───────────────────────────────┐
  │ title: "The Little Prince"    │
  │ writer:                       │
  │   ┌────────────────────────┐  │
  │   │ name: "Antoine de..."  │  │
  │   │ birthYear: 1900        │  │
  │   └────────────────────────┘  │
  │ price: 9.99                   │
  └───────────────────────────────┘
```

And **assignment stays deep all the way down**:

```cpp
Book d = c;    // title, the WHOLE writer record, and price — copied recursively
```

Nesting is how the course builds records honestly: a `Date` inside `Patient`, an `Address` inside `Employee` — [Lab 5](labs.md#lab-5--patient-records) and [Lab 2](labs.md#lab-2--employee-records) do exactly this. Design rule of thumb: **a field that has fields of its own is a type waiting to be named.**

---

## 4. A complete worked program

A report over an array of records — every door in one program:

```cpp
// 04_roster_report.cpp — Unit 14 · Session 14.2
// Compile: g++ -std=c++17 -Wall -Wextra 04_roster_report.cpp -o roster_report
#include <iostream>
#include <string>
#include <iomanip>

struct Student {
    std::string name;
    int    score;
};

void readInto(Student& s) {                       // Door 3 — modify the caller's
    std::cout << "name: ";
    std::getline(std::cin, s.name);
    std::cout << "score: ";
    std::cin >> s.score;
    std::cin.ignore(1000, '\n');                  // the mixing trap, pre-empted
}

void printRow(int sr, const Student& s) {         // Door: const& — read-only, no copy
    std::cout << std::setw(3) << sr << " | "
              << std::setw(20) << std::left << s.name << " | "
              << std::setw(3) << std::right << s.score << '\n';
}

Student bestOf(const Student roster[], int n) {   // RETURNS a record — a value question
    int best = 0;
    for (int i = 1; i < n; i = i + 1)
        if (roster[i].score > roster[best].score) best = i;
    return roster[best];                          // deep copy out
}

int main() {
    Student roster[50];
    int count = 0;
    char more;
    do {
        readInto(roster[count]);
        count += 1;
        std::cout << "another? (y/n): ";
        std::cin >> more;
        std::cin.ignore(1000, '\n');
    } while (more == 'y' && count < 50);

    std::cout << "--- ROSTER ---\n";
    for (int i = 0; i < count; i = i + 1)
        printRow(i + 1, roster[i]);

    Student top = bestOf(roster, count);
    std::cout << "best: " << top.name << " (" << top.score << ")\n";
    return 0;
}
```

Trace the doors: `readInto` by reference (modifies), `printRow` by `const&` (read-only), `bestOf` returning a value (a *new* answer), `roster` itself an array (handle + count under the hood). One program, every lesson-2 idea pulling its weight.

---

## Practice

- [Exercises 9–15](exercises.md) — the three doors, returns, nesting
- [Predictions 4–7](predictions.md) — arrow vs dot, nested-dot chains
- [Lab 2 — Employee Records](labs.md#lab-2--employee-records) — nesting in a real schema

## Key takeaways

- **Value** copies (safe, costly for big records); **reference** modifies (no copy, never null); **`const&`** is the default for read-only records (no copy, compiler-enforced); **pointer** for arrays/optional/ownership — with the **arrow operator** as the humane `(*s).field`
- **Return** records when the function manufactures a value; use reference out-parameters to fill existing ones
- **Nested records** build with nested braces and read with descending dots — and assignment copies all the way down
- Route construction through a validating `readX()` factory so invalid records never exist — the habit Unit 15's constructors will enforce for you
