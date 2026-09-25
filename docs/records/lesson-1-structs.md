---
title: "Lesson 1 — The struct: One Record at Last"
description: "From parallel arrays to records: defining a struct, members, dot access, initialization, and arrays of structures."
---

# Lesson 1 — The struct: One Record at Last

> [← Module home](index.md) · [Lesson 2 — Moving records around →](lesson-2-functions-nesting.md)

## In this lesson you will learn

- what a **struct** is — a blueprint for bundling related fields into one named value
- how to declare structure **members** and access them with the **dot operator**
- the three ways to **initialize** a record — and the ordering rule
- how **arrays of structures** replace parallel arrays — and why the swap goes with the record

---

## 1. The problem: parallel arrays drift

You have built this pattern at least four times in the course — the [statistics team](../functions/labs.md), the [Marks Analyzer](../arrays/labs.md), the [Quiz Runner](../pointers/miniproject.md):

```cpp
std::string names[100];
int    scores[100];
int    count = 0;
```

Three arrays, one conceptual thing: *students*. The tax this design charges:

- every function signature carries **all the arrays plus count**: `void report(std::string names[], int scores[], int n)`
- **swapping** two students means swapping both arrays in lockstep — miss one and record 7 is a lie
- **sorting** means permuting every array identically
- nothing in the type system says these arrays belong together — the compiler cannot help you

The bug in all its glory: a report that prints Ayesha's name with Ali's score, because one swap forgot its partner. **Parallel arrays are three wrong answers held together by an index.**

## 2. The struct — a blueprint, not a box

A **struct** defines a new type that bundles named fields:

```cpp
struct Student {
    std::string name;    // full name
    int    score;        // 0–100, the exam result
};
```

Read it exactly right: `struct Student { ... };` is a **blueprint** — it describes what every Student will contain. It creates **no variables and no memory**. Only declarations do:

```cpp
Student a;                      // one record — name empty, score UNINITIALIZED
Student b = {"Ayesha Khan", 92};  // one record, filled
```

```text
   Student b                      (one box of boxes)
  ┌─────────────────────────┐
  │ name: "Ayesha Khan"     │
  │ score:              92  │
  └─────────────────────────┘
```

Now `b` is **one value**. Assign it, pass it, return it, swap it — the fields travel together, forever. That is the entire idea; everything else in this unit is detail.

**Style rule (course-wide):** the definition ends with a **semicolon** — `};`. Forgetting it is the classic first-day error: the compiler reads the *next* thing in the file as part of the declaration and reports an error one line (or ten) away from the real mistake.

---

## 3. Members and the dot operator

Each named field is a **member** (also called a field). Access uses the **dot operator**:

```cpp
b.name = "Ayesha Khan";    // the name member of b
b.score = 92;              // the score member of b
std::cout << b.name;       // read too — the dot works for both
```

Read `b.score` out loud as *"b's score"* — the grammar is possessive, and the dot descends into whatever type the member has:

```cpp
b.name.length()            // b's name (a string), and ITS length() member function
```

Members can be any type you own: `int`, `double`, `std::string`, `bool`, arrays, **and other structs** (Lesson 2). A member that is an array:

```cpp
struct Quiz {
    int answers[5];        // five raw scores
    int count;             // how many are filled
};
Quiz q;
q.answers[0] = 8;          // dot, THEN brackets — the member is the array
```

---

<a name="initialization--three-ways-and-one-rule"></a>
## 4. Initialization — three ways and one rule

**Way 1 — brace list, complete:**

```cpp
Student a = {"Ayesha Khan", 92};   // fields in declaration order
```

**Way 2 — brace list, partial:**

```cpp
Student b = {"Ali Raza"};          // score gets 0 (the zero-init rule for missing fields)
```

Missing fields are **zero-initialized** — numbers to 0, strings to `""`, bools to `false`. Convenient, but silent: a record with a forgotten score looks legitimate. Prefer complete lists.

**Way 3 — member assignment:**

```cpp
Student c;
c.name = "Sana Mir";               // when values arrive at runtime (e.g. from input)
c.score = readScore();             // this is the INPUT shape
```

**Way 4, the free one — assignment from another record:**

```cpp
Student d = a;                     // deep member-wise copy: name AND score copied
```

No loops, no strdup — structs copy **field by field**. Remember what `=` did *not* do for plain arrays ([Unit 09](../arrays/lesson-1-basics.md)): arrays don't assign, but structs of arrays do. This is the quiet superpower of the type.

### The ordering rule

Brace-list values bind **by position, in declaration order** — the compiler does not read field names:

```cpp
struct Point { int x; int y; };
Point p = {3, 4};        // x=3, y=4 — fine
Point q = {4, 3};        // ALSO fine to the compiler. Swapped. Silent.
```

Defence: declare members in the order you naturally say them, keep brace lists adjacent to the definition when possible, and for anything beyond ~4 fields prefer member assignment (Way 3), where every value sits next to its name. C++20 would allow *designated initializers* (`.x = 3`) — noted for awareness, not used in this course.

---

<a name="5-arrays-of-structures--the-payoff"></a>
## 5. Arrays of structures — the payoff

The headline use. One array of **records** replaces the parallel trio:

```cpp
Student roster[100];
int count = 0;

roster[count].name  = "Ali Raza";    // one statement per FIELD,
roster[count].score = 78;            // one record per INDEX
count += 1;
```

Read `roster[count].name` left to right: *the roster array, its element at position `count`, that element's name member*. Brackets before dot — you dive into the array first, then into the record.

Everything from [Unit 09](../arrays/lesson-1-basics.md) transfers untouched, because this **is** an array — of a new element type:

```cpp
for (int i = 0; i < count; i = i + 1)
    std::cout << roster[i].name << " -> " << roster[i].score << '\n';
```

### The swap — where the win becomes visible

Parallel-array swap (two moves, one to forget):

```cpp
std::string tN = names[i]; names[i] = names[j]; names[j] = tN;
int    tS = scores[i]; scores[i] = scores[j]; scores[j] = tS;
```

Record swap (one move, nothing to forget):

```cpp
Student t = roster[i]; roster[i] = roster[j]; roster[j] = t;
```

The fields **cannot** drift apart — they are one value. Sorting, filtering, reporting: every Unit 09 pass becomes a single-array pass over records.

### And the functions finally breathe

```cpp
// before: every function hauls every array
double average(std::string names[], int scores[], int n);

// after: one parameter, one type you designed
double average(const Student roster[], int n);
```

The type *documents itself* — a reader knows exactly what a `Student` is by looking at one definition, not by tracing three array names through the call chain. (Why `const Student[]`? Lesson 2, §1 — but you have seen the pattern since Unit 09: array parameters are handles, and `const` is the look-don't-touch promise.)

---

## 6. A complete first program

```cpp
// 01_first_struct.cpp — Unit 14 · Session 14.1
// Compile: g++ -std=c++17 -Wall -Wextra 01_first_struct.cpp -o first_struct
#include <iostream>
#include <string>

struct Student {              // blueprint only — no memory yet
    std::string name;
    int    score;
};

int main() {
    Student a = {"Ayesha Khan", 92};        // way 1
    Student b;                              // way 3 (runtime shape)
    std::cout << "name: ";
    std::getline(std::cin, b.name);
    std::cout << "score: ";
    std::cin >> b.score;

    Student roster[2] = {a, b};             // array of records
    for (int i = 0; i < 2; i = i + 1)
        std::cout << roster[i].name << " scored " << roster[i].score << '\n';

    Student t = roster[0];                  // the one-move swap
    roster[0] = roster[1];
    roster[1] = t;
    std::cout << roster[0].name << " is now first\n";
    return 0;
}
```

---

## Practice

- [Exercises 1–8](exercises.md) — define, initialize, access, arrays of records
- [Predictions 1–3](predictions.md) — brace lists and dot chains on paper
- [Lab 1 — Student Records](labs.md#lab-1--student-records) — the full parallel→record migration

## Key takeaways

- A **struct** is a blueprint; declaring a variable builds the box — one value whose fields travel together
- **Dot access** is possessive grammar: `roster[i].score` = the array, the element, the field
- Initialize by brace list (order matters, missing fields zero), member assignment (the input shape), or assignment from another record (**deep field-wise copy**)
- **Arrays of records** kill the parallel-array drift: the swap is one move, and functions take one `const Student[]` instead of three arrays
- The definition's closing **semicolon is part of the syntax** — and its most common omission
