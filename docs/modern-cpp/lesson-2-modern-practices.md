---
title: "Lesson 2 — The Modern Practices: RAII, auto, constexpr, Smart Pointers, Move Semantics"
description: "The right column: RAII as the organizing idea, auto with restraint rules, constexpr for compile-time constants, unique_ptr as the default owner, shared_ptr only for true sharing, move semantics conceptually, and the retirement of raw new/delete."
---

# Lesson 2 — the modern practices to begin adopting

> [← Module home](index.md) · [← Lesson 1 — the fundamentals](lesson-1-fundamentals.md) · [Exercises →](exercises.md)

## In this lesson you will learn

- **RAII** — the one idea that organises all of modern C++ resource handling
- `auto` — what it is for, and the restraint rules that keep it readable
- `constexpr` — compile-time constants done properly
- `unique_ptr` as the **default owner**; `shared_ptr` reserved for genuinely shared ownership
- **move semantics, conceptually** — what a move is, why `std::move` exists, and where you will meet it
- the retirement ceremony for raw `new`/`delete`

Everything here is C++17, standard, and portable. And every practice earns its place by making programs *safer or clearer* — if a practice ever makes your program worse, this module has failed it.

## 1. RAII — the idea that runs modern C++

You have already watched RAII work three times without the name:

- a `vector` local frees its memory when the function exits — *even via a `throw`* (the Robustness module's unwinding lesson)
- a `string` member releases its buffer when its object dies
- an `ofstream` closes its file in its destructor

**RAII — Resource Acquisition Is Initialization** — is the name for this pattern: *tie a resource's lifetime to an object's lifetime. The constructor acquires; the destructor releases — automatically, in reverse order of creation, on every exit path including exceptions.*

```text
stack frame born ──► objects constructed (resources acquired)
                      │
        normal code runs
                      │
stack frame ends ──► destructors run (resources released)  ◄── EVERY exit path:
     return ▸ same          │                                   normal return,
     throw  ▸ same          ▼                                   early return, throw
     break  ▸ same   nothing leaks, ever
```

The alternative — acquiring and releasing *by hand* — is the Pointers module's discipline: `new` here, `delete` there, and every `return`/`throw`/`break` in between checked for an escape route. One missed route is a leak; the Robustness module's hunt D6 showed the throw route specifically. RAII's answer: **stop managing resources by hand at all.** The resource lives in an object; the object's destructor is the release; the language guarantees the destructor runs.

| Resource | The RAII owner you already use | The one this lesson adds |
| --- | --- | --- |
| dynamic memory | `vector`, `string`, `map`, ... | `unique_ptr<T>` |
| open files | `ifstream`, `ofstream` (Files module) | — |
| invariants | classes with validating constructors (OOP module) | — |
| "restore on the way out" | — | the rollback guard ([Robustness challenge C8](../robustness/challenges.md)) |

**The habit:** whenever you type `new`, you should be able to name the *object that owns* the memory. If the answer is "a raw pointer," the modern answer is "then it's the wrong pointer — see §4."

## 2. auto — convenience with restraint

`auto` asks the compiler to deduce a variable's type from its initialiser:

```cpp
// 05_auto.cpp — what auto is for.
// Compile: g++ -std=c++17 -Wall -Wextra 05_auto.cpp -o auto_demo

#include <iostream>
#include <map>
#include <string>
#include <vector>
using namespace std;

int main() {
    vector<int> readings = {12, 7, 19};

    for (auto it = readings.begin(); it != readings.end(); ++it)
        cout << *it << " ";                       // vector<int>::iterator — spelled "auto"
    cout << "\n";

    map<string, int> ages = { {"Aisha", 21}, {"Bilal", 22}};
    for (const auto& [name, age] : ages)          // structured bindings (C++17): the
        cout << name << " is " << age << "\n";    // syllabus's other toolkit item
}
```

The case **for** `auto`: iterator types are unspellable (`vector<int>::const_iterator`), structured bindings are unspellable, and `auto x = vector<int>{...}`-style declarations stay correct when the container's type changes.

The case **for restraint** — the rules this course endorses:

1. **`auto` when the type is obvious from the right-hand side** (`auto n = marks.size();`) or **unspellable** (iterators, structured bindings).
2. **Name the type when the type carries meaning** (`double average`, `FeeAccount acct`) — a variable whose *unit* or *role* matters deserves its name on the type.
3. **Never `auto` a numeric literal chain you care about** — `auto n = 0;` deduces `int`; if you meant the long-seeded accumulator (`accumulate(..., 0LL)`), say so. The STL module's seed-type lesson is exactly this rule.
4. **`auto&&` and `decltype` are beyond this course** — meet them in a later course, not here.

`auto` is a *readability* tool that becomes a *readability hazard* the moment a reader must deduce the type mentally to understand the line. When in doubt, spell it.

## 3. constexpr — compile-time constants, formalised

The arrays module used `constexpr int MAX_SIZE = 100;` for capacity. Now the full habit:

```cpp
// 06_constexpr.cpp — the compile-time constant habit.
// Compile: g++ -std=c++17 -Wall -Wextra 06_constexpr.cpp -o constexprdemo

#include <array>
#include <iostream>
using namespace std;

constexpr int MAX_ROWS = 4;                 // known at COMPILE time: the compiler
constexpr int MAX_COLS = 5;                 // can check bounds, size arrays, and
constexpr int CELL_COUNT = MAX_ROWS * MAX_COLS;  // fold the arithmetic itself

int main() {
    array<int, CELL_COUNT> grid {};          // std::array sizes must be constexpr
    static_assert(CELL_COUNT == 20, "grid shape changed");   // the compiler's own check

    for (int r = 0; r < MAX_ROWS; ++r)
        for (int c = 0; c < MAX_COLS; ++c)
            grid[r * MAX_COLS + c] = r * 10 + c;

    cout << grid[2 * MAX_COLS + 3] << "\n";  // 23
}
```

The distinction to internalise — and its one-sentence reason:

- **`const`** = "I promise not to change it" — the value may still be computed at run time (`const int n = readInt();` is perfectly legal).
- **`constexpr`** = "the compiler may compute it now" — for array sizes (`array<T, N>` needs it), for values that must not be magic numbers, for arithmetic the compiler can fold.

**The habit:** named constants that *can* be compile-time should be `constexpr`; `const` remains the tool for run-time-fixed values. And `static_assert` — shown above — is the free bonus: a compile-time test with zero runtime cost (the Debugging module's assertion discipline, promoted to the compiler).

The restraint note: `constexpr` *functions* (computations usable at compile time) are a real feature but beyond this course's needs — constant *values* only, here.

## 4. Smart pointers — unique_ptr as the default owner

The Pointers module ended at the exact edge of this lesson: raw `new`/`delete` are *correct but dangerous* — the manual discipline (one delete per path, ownership named, no leaks through throws) does not scale. The modern answer: **an object that owns a heap resource and destroys it in its own destructor.** A smart pointer is RAII for memory.

```cpp
// 07_unique_ptr.cpp — ownership that cannot leak.
// Compile: g++ -std=c++17 -Wall -Wextra 07_unique_ptr.cpp -o unique

#include <iostream>
#include <memory>
#include <string>
#include <stdexcept>
using namespace std;

class Report {
public:
    explicit Report(const string& title) : title(title) {
        cout << "Report '" << title << "' created\n";
    }
    void render() const { cout << "rendering '" << title << "'\n"; }
    ~Report() { cout << "Report '" << title << "' destroyed\n"; }
private:
    string title;
};

void risky(const string& name) {
    unique_ptr<Report> rpt = make_unique<Report>(name);   // acquired
    if (name.empty()) throw runtime_error("risky: empty name");
    rpt->render();
}   // destructor runs HERE — normal return AND throw path. Nothing leaks.

int main() {
    risky("sales");
    try { risky(""); }
    catch (const runtime_error& e) { cout << "caught: " << e.what() << "\n"; }
}
```

**Output:**

```text
Report 'sales' created
rendering 'sales'
Report 'sales' destroyed
Report '' created
caught: risky: empty name
Report '' destroyed
```

Read the last two lines twice: the throw skipped `render`, unwound the function — and `~Report` still ran. The Robustness module's hunt-D6 leak, cured by replacing `Report* rpt = new Report(...)` with one line.

The practices, as rules:

1. **`make_unique<T>(args...)`** creates the owned object — never `unique_ptr<T> p{new T(...)}`, which separates allocation and ownership needlessly.
2. **`unique_ptr` = exactly one owner.** It cannot be copied (the compiler *enforces* single ownership); it can be *moved* (`std::move` — §6), which is ownership **transferred**, not shared.
3. **Access like a pointer:** `p->render()`, `*p`; **test like a pointer:** `if (p) ...`; **release it explicitly** with `p.reset()` when the resource must go *now*.
4. **Arrays are not its job:** `unique_ptr<T[]>` exists, but `vector<T>` is the answer — the container-first habit from Lesson 1 §5 applies inside the heap too.
5. **`get()` hands out a non-owning view** for interop; the *owner* stays the `unique_ptr`. (The Inheritance module's catalogue — `unordered_map<string, unique_ptr<MediaItem>>` — was already living these rules.)

### shared_ptr — only for genuine sharing

```cpp
shared_ptr<Report> a = make_shared<Report>("shared");
shared_ptr<Report> b = a;          // two owners; a use-count tracks them
```

A `shared_ptr` keeps a **use count**; the object dies when the *last* owner dies. That is the right tool when no single component can own the resource — caches, shared immutable data reached from several structures. The costs are real: an extra control block, atomic count updates, and the classic bug — **two objects holding `shared_ptr`s to each other keep each other alive forever** (a cycle; the fix, `weak_ptr`, is beyond this course).

**The beginner rule, stated plainly: if you cannot name *the one owner*, redesign until you can — `shared_ptr` is the exception (genuinely shared, immutable-ish data), not the default.** A course that hands every node a `shared_ptr` has skipped the design step the pointers module trained.

## 5. Move semantics — the conceptual introduction

You have already seen a move, unnamed: the STL module's `unique_ptr` insertion, `byTitle[key] = move(item)` — ownership *transferred* from the caller's variable into the map, with no copy of the pointee. Here is the idea in full, at beginner depth.

**The problem moves solve.** Copying is expensive when the payload is big: `vector<string> big = makeRoster();` copies every string — then the *source* is destroyed immediately after. All that copying, thrown away. A **move** says: instead of copying the contents, *transfer the guts* — the destination takes the source's buffer; the source is left empty-but-alive.

```text
COPY:  src [◆──► "roster data"]      dst allocates, copies byte-by-byte,
       dst [◆──► copy of data]       src still owns its original — two payloads

MOVE:  src [◇──✗]                    dst STEALS the buffer pointer;
       dst [◆──► "roster data"]      src left empty-but-alive — one payload
```

The cost of a move of a `string`/`vector` is a few pointer assignments — independent of payload size. That is why returns of big locals are cheap in modern C++ (the compiler moves), and why the STL module said `push_back(str)` copies but `push_back(move(str))` doesn't.

**`std::move` itself** — the honest beginner description: it does not move anything. It is a *permission slip* that marks a value as "safe to steal from" — "I am done with this; take its guts." The move *happens* in whatever receives the slip (a move constructor/assignment — implementation beyond this course; usage is not):

```cpp
string name = "Aisha Ibrahim Khan";
string copy = name;                 // copy: name still full
string stolen = move(name);         // move: stolen has the text; name is empty-but-alive
cout << name.size() << "\n";        // 0 — using a moved-from value: only assignment or destroy
```

The two rules to carry:

1. **After `std::move(x)`, treat `x` as gone** — assign it fresh or let it die; never read its contents.
2. **Move only when you are truly done** — `move` on a variable still in use is the modern variant of the dangling-pointer bug family.

Where you will meet moves in the capstone: returning containers from functions (automatic), inserting into containers when done with the source (`push_back(move(x))`, `emplace_back`), and `unique_ptr` ownership transfer. Nothing more is needed — the *implementation* (rvalue references, move constructors) belongs to the next course, and this module says so honestly.

## 6. The retirement of raw new/delete

The module's closing ceremony, stated as policy:

| Situation | Old habit | Modern replacement |
| --- | --- | --- |
| one heap object | `Report* p = new Report(t); ... delete p;` | `auto p = make_unique<Report>(t);` |
| growable collection | `new T[n]` + `delete[]` | `vector<T>` |
| keyed collection | arrays + counters | `map` / `unordered_map` |
| optional "found it" result | returning a `new`-allocated pointer | return `T` by value, or `unique_ptr` if huge |
| ownership passing | raw pointer + comment "caller deletes" | `unique_ptr` parameter (the transfer *is* the signature) |
| truly shared | — | `shared_ptr` (rare; name the reason) |

Raw pointers do **not** retire — as *non-owning views* they are everywhere (the `const MediaItem*` ordered view of the STL mini-project, function parameters, `get()` results). What retires is the raw pointer **as owner**: `new`/`delete` pairs disappear from course code because ownership now lives in objects whose destructors cannot forget. When a future course meets raw `new` again (container internals, polymorphic factories), it will arrive with this discipline already installed.

## Recap

- **RAII** ties resource lifetime to object lifetime; destructors run on every exit path, throws included — the one idea behind all the tools.
- **`auto`** for the unspellable and the obvious; name the type when the type carries meaning.
- **`constexpr`** for compile-time constants (array sizes, no magic numbers); `static_assert` is its free test.
- **`unique_ptr`/`make_unique`** is the default heap owner — single ownership, enforced by the compiler; **`shared_ptr`** only for genuinely shared data, and the beginner rule is to redesign until one owner exists.
- **Move semantics** transfer guts instead of copying payloads; `std::move` is a permission slip; a moved-from value is empty-but-alive and off-limits.
- **Raw `new`/`delete` retire as ownership**; raw pointers thrive as non-owning views.

## Practice

1. Convert `07_unique_ptr.cpp`'s `risky` back to raw `new`/`delete` and demonstrate the leak on the throw path (run under repeated calls, or just trace it). Then write the two-sentence argument a reviewer gives for the `unique_ptr` version.
2. Take `constexpr` through a small program: a fixed 3×4 grid program with `MAX_ROWS`/`MAX_COLS`, a `static_assert` on the cell count, and one comment on what breaks if someone changes the grid shape without updating the assert.
3. Write a program that moves a large `vector<int>` (say 10 million elements) into another, printing `.size()` of both after — then re-run with `copy` and time the difference if your machine allows. One sentence: what did the move save?

→ Continue to the [Exercises](exercises.md) — or jump to [the Modernisation Lab](labs.md).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
