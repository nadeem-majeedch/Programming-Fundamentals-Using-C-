---
title: "Lesson 1 — The Fundamentals: C++ Every Student Should Know"
description: "The left column as one connected picture: const correctness, references, nullptr, enum class, range-based for, lambdas, and the standard library as the default toolkit — consolidated from Units 02–15."
---

# Lesson 1 — the fundamentals every student should know

> [← Module home](index.md) · [Lesson 2 — The modern practices →](lesson-2-modern-practices.md)

## In this lesson you will learn

- **const correctness** as one idea applied in five places — variables, parameters, references, members, interfaces
- references (`&`) as the everyday parameter and loop tool — and when plain values win
- `nullptr`, `enum class`, range-based `for`, and lambdas — reassembled as one toolkit
- the **standard library as the default answer** — the habit that separates a C-with-classes program from a C++ program

Nothing in this lesson is new — each piece was taught in Units 02–15. What is new is seeing them as **one connected discipline**. If any section feels shaky, its "taught in" link is the page to revisit.

## 1. const correctness — five placements, one idea

`const` is a *promise*: this thing will not change through this name. The compiler enforces it, readers rely on it, and bugs surrender to it. Five placements, oldest to newest:

```cpp
// 01_const_everywhere.cpp — five placements, one promise.
// Compile: g++ -std=c++17 -Wall -Wextra 01_const_everywhere.cpp -o consteverywhere

#include <iostream>
#include <string>
#include <vector>
using namespace std;

constexpr int MAX_ENROL = 50;                       // (1) named constant — the
                                                    // arrays-module habit, formalised

double averageOf(const vector<int>& v) {            // (2) + (3): the reference is
    if (v.empty()) return 0.0;                      // non-owning AND read-only
    long sum = 0;
    for (int x : v) sum += x;
    return (double)sum / v.size();
}

class Course {
public:
    Course(string title, int seats) : title(move(title)), seats(seats) {}
    const string& getTitle() const { return title; }  // (4) member function promise:
    int getSeats() const { return seats; }            //     calling changes nothing
private:
    const string title;                               // (5) born-once member — the
    int seats;                                        //     Records-module invariant
};

int main() {
    const double PASS_MARK = 50.0;                    // (1) again: magic numbers die
    vector<int> marks = {78, 45, 92};
    double avg = averageOf(marks);
    cout << "average " << avg << " — pass mark " << PASS_MARK << "\n";
    Course c("Programming Fundamentals", MAX_ENROL);
    cout << c.getTitle() << ": " << c.getSeats() << " seats\n";
}
```

| Placement | Taught in | The promise |
| --- | --- | --- |
| `const` variable | Unit 03; `constexpr` refines it in [Lesson 2](lesson-2-modern-practices.md) | this value never changes |
| `const T&` parameter | Functions module (Unit 07) | I read your object, I don't copy or touch it |
| `const std::string&` return | OOP module | I hand you a view, not a copy |
| `const` member function | OOP module Lesson 3 | calling me doesn't change the object |
| `const` member (data) | OOP module | this field is fixed at construction |

**The habit to adopt:** every parameter, return, and member starts `const` — and you *remove* it only with a reason. Adding `const` later is surgery; removing it is suspicion.

## 2. References — the everyday tool, and when plain values win

The functions module introduced `&` as pass-by-reference; the STL module made it the loop variable's default. Consolidating the three uses:

```cpp
// 02_references.cpp — three reference roles, one selection rule.
// Compile: g++ -std=c++17 -Wall -Wextra 02_references.cpp -o refs

#include <iostream>
#include <string>
#include <vector>
using namespace std;

void shout(const string& s) {                 // (a) read-only parameter: no copy
    cout << s << "!\n";
}

void normalise(double& x) {                   // (b) in/out parameter: caller sees changes
    if (x < 0) x = 0;
}

int main() {
    string name = "Aisha";
    shout(name);                              // no copy of the string is made

    double reading = -4.2;
    normalise(reading);
    cout << reading << "\n";                  // 0 — the caller's variable changed

    vector<string> roster = {"Aisha", "Bilal", "Sara"};
    for (const string& s : roster) cout << s << " ";   // (c) range loop: const& = read, & = write
    cout << "\n";

    for (int small : {1, 2, 3}) cout << small << " ";  // cheap types: plain value is fine
    cout << "\n";
}
```

**The selection rule**, now in one sentence: **expensive types travel by `const&`, mutable visits by `&`, and small values (`int`, `double`, `char`, `bool`) by plain value — copying an `int` is cheaper than aliasing it.** The beginner bug the rule prevents: `for (string& s : roster)` with a *read-only* body (suspicious — why the non-const reference?), and the `double&` parameter that mutates a caller's variable *by accident* — the Debugging module's "who changed this?" hunt, caused by a reference that only needed to read.

One boundary from the records module, restated because it is a `const`-correctness fact in disguise: a reference must be initialised and can never be re-seated. That is why the OOP module used `const` members for born-once data — a reference-shaped promise with value semantics.

## 3. nullptr, enum class — two retirements you have already made

**`nullptr`** (Pointers module, Unit 13) replaced `NULL` and literal `0` for one reason: it has a *pointer type*, so overloads and errors that used to confuse "the number zero" with "the empty pointer" now behave:

```cpp
void show(int x);        // called with show(0)  → the int overload
void show(Student* p);   // called with show(nullptr) → unambiguously the pointer
```

The adoption is complete: **there is no situation in this course where `NULL` or `0`-as-pointer is the right spelling.** Every "found nothing" answer from the searching lessons is `nullptr` — the ask-door's empty hand.

**`enum class`** (Records module, Unit 14's enum lesson) is the same story for named categories — scoped, strongly typed, immune to the plain-enum's implicit-int conversions:

```cpp
// 03_enum_class.cpp — the records module's pattern, restated as the default.
// Compile: g++ -std=c++17 -Wall -Wextra 03_enum_class.cpp -o enumclass

#include <iostream>
using namespace std;

enum class Grade { Pass, Fail, Pending };    // scoped: Grade::Pass, no int leaking in

const char* describe(Grade g) {
    switch (g) {                              // the compiler warns if a case is missed
        case Grade::Pass:    return "passed";
        case Grade::Fail:    return "failed";
        case Grade::Pending: return "awaiting result";
    }
    return "unknown";                         // unreachable if every case is handled
}

int main() {
    Grade g = Grade::Pending;
    // int n = g;                             // compile error — the whole point
    cout << describe(g) << "\n";
}
```

**The habit:** a fixed set of categories in a design is a `enum class` question — never an `int` with magic values, never a plain `enum` leaking into the enclosing scope. (The Records module's lesson-3 covered the migration table; this module just repeats the verdict.)

## 4. Range-based for, lambdas — the traversal voice

The STL module taught both; here is the consolidated rule set:

```cpp
// 04_traversal.cpp — the two voices of modern traversal.
// Compile: g++ -std=c++17 -Wall -Wextra 04_traversal.cpp -o traversal

#include <algorithm>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

int main() {
    vector<int> readings = {12, 7, 19, 3};

    for (int r : readings)                    // (a) whole-container visits: range-for
        cout << r << " ";
    cout << "\n";

    sort(readings.begin(), readings.end(),
         [](int a, int b) { return a > b; }); // (b) short call-site predicates: lambdas

    auto big = count_if(readings.begin(), readings.end(),
                        [](int r) { return r > 10; });   // the STL module's capture rules:
    cout << big << " readings above 10\n";               // explicit captures, two-line max
}
```

**Range-based `for`** is for *every element of this container*, in order, with no index bookkeeping — it replaces the counted loop for whole-container visits (the counted loop remains the tool for *positions*, stride patterns, and index-math). **Lambdas** are for predicates and comparators *at the call site* — the STL module's three rules stand: short, explicit captures, name anything longer.

## 5. The standard library — the default answer

The deepest habit this lesson consolidates: **when a need appears, the standard library is the first place you look.** The course built hand-rolled versions of library tools on purpose — the tally before `map`, the linear search before `find`, the hand-grown array before `vector`, the Box before the templates lesson — because building a tool once teaches what the tool *does*. The professional posture, now that the building is done:

| Need | First answer | The hand-rolled version you built |
| --- | --- | --- |
| growable list | `vector<T>` | arrays module's growth pattern |
| lookup by key | `map` / `unordered_map` | the tally array, the frequency counter |
| unique membership | `set` / `unordered_set` | the dedup passes |
| find / count / min / max | `find`, `count_if`, `min_element`, `max_element` | searching & sorting lessons |
| ordering | `sort` with a comparator | bubble/selection/insertion |
| text | `std::string` | the char-array lesson (kept for understanding) |
| dynamic memory | containers, then `unique_ptr` ([Lesson 2](lesson-2-modern-practices.md)) | the Pointers module's `new`/`delete` |

The writing rule that follows: **code you write is for the *problem domain* (students, accounts, inventory) — the *mechanics* (growing, sorting, looking up) are the library's job.** When your draft contains a hand-rolled mechanic, the draft is asking to be modernised — which is [the lab](labs.md).

## Recap

- `const` correctness is one promise in five placements; adopt **const-first** on parameters, returns, and members.
- References: `const&` to read, `&` to mutate through, plain values for cheap types.
- `nullptr` and `enum class` are complete retirements — no `NULL`, no magic ints.
- Range-`for` owns whole-container visits; lambdas own short call-site predicates.
- The standard library is the default answer for mechanics; your code is for the domain.

## Practice

1. Take any exercise program you wrote for the arrays module and count the `const` opportunities you missed: parameters that should be `const T&`, loop variables that should be `const T&`, local literals that should be named constants. List them; you will fix them in [the lab](labs.md).
2. Write `bool contains(const vector<string>& v, const string& key)` using `find` — then write the loop version you *would* have written in the arrays module. Which version's correctness is obvious at a glance, and why?
3. Convert one plain `enum` or magic-number category in your earlier code to `enum class`, and note every place the compiler forced you to qualify — that friction is the feature.

→ Continue to [Lesson 2 — the modern practices](lesson-2-modern-practices.md).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
