---
title: "Lesson 3 — Arrays and Functions"
description: "What actually gets passed when an array meets a function, const protection, size-passing conventions, partial fills, and refactorings the array enables."
---

# Lesson 3 — Arrays and Functions

> [← Module home](index.md) · [← Lesson 2 — The classic passes](lesson-2-classic-passes.md) · [Lesson 4 — Two dimensions →](lesson-4-matrices.md)

## In this lesson you will learn

- what is *actually* copied when you pass an array — the honest answer
- why array parameters are **always references in disguise**, and what that costs and buys
- `const` — the promise that makes array parameters safe to share
- how the size travels: parameter conventions and partial fills
- the refactorings the array finally enables

---

<a name="1-what-gets-passed--the-surprise"></a>
## 1. What gets passed — the surprise

You learned in [Functions Lesson 2](../functions/lesson-2-scope.md#1-pass-by-value--the-copy-rule) that arguments are *copied*. Arrays break that rule:

```cpp
void tryToChange(int data[]) {
    data[0] = 999;                  // changes the CALLER's first box!
}

int main() {
    int marks[3] = {1, 2, 3};
    tryToChange(marks);
    std::cout << marks[0] << '\n';  // 999 — not 1
    return 0;
}
```

The honest mechanics: when an array is an argument, what travels is **the address of its first box** — the function gets a *handle on the caller's original boxes*, not a copy of them. (That address is precisely what [Unit 13](../syllabus.md#stage-e-memory-and-objects-units-13-15) calls a pointer; you don't need the machinery yet, only the consequence.)

```text
main:            marks ──► [ 1 ][ 2 ][ 3 ]
                              ▲
tryToChange:  data ───────────┘   (same boxes, second name)
```

So array parameters behave like the [reference parameters](../functions/lesson-3-references-testing.md#2-reference-parameters--the-write-back-wire) from Unit 08 — *automatically*, with no `&`. Two consequences:

- **A function can change your data.** Useful for fills and in-place edits; dangerous for anything else.
- **No copying cost.** A 10 000-element array passes as cheaply as a 3-element one — the thing `const&` imitated for single values.

<a name="2-const--the-safety-belt"></a>
## 2. `const` — the safety belt

Since the function holds a handle on your originals, C++ lets *you* decide whether it may write through it:

```cpp
int sumOf(const int data[], int n);        // PROMISE: read-only
void fillOnes(int data[], int n);          // no const: may write
```

Inside `sumOf`, any attempt to assign `data[i]` is a **compile error** — the compiler enforces the promise. House rule from this lesson forward:

> **Every function that only reads an array takes it `const`.** Write-access parameters stay plain — but their names should say so (`result[]`, `tally[]`).

This is the [compute/print split](../functions/lesson-1-machine.md#6-void-functions--machines-that-only-act) extended to data: *readers* of data are `const`, *writers* announce themselves by type.

<a name="3-the-size-travels-separately--and-how"></a>
## 3. The size travels separately — and how

Here's the trap the address-mechanics creates: the function receives a handle on box 0 — **and nothing else**. Inside `sumOf`, there is no way to ask "how long is this array?" The `int n` parameter is not decoration; it is the *only* size information that exists:

```cpp
int sumOf(const int data[], int n);    // size MUST be a parameter
```

Course conventions (all three appear in real code; the labs name which they use):

1. **Explicit size parameter** — `f(const int data[], int n)`. The default; explicit and honest.
2. **Capacity + logical size** — `f(int data[], int capacity, int& n)` for functions that *fill*: capacity bounds the writes, `n` comes back as the reference output ([Lab 4](labs.md#lab-4--inventory-analysis) uses this shape).
3. **Sentinel-terminated** — the array carries its own end marker (a −1, an empty line). Convenient for literals; hides the size from the type. The labs avoid it except where input format dictates it.

**What you cannot do**: `sizeof(data)` inside the function will *not* give the array's length — inside, `data` is just the handle, and `sizeof` returns the handle's size, not the row's. That's the deep reason the size parameter exists at all.

### Partial fills — the MAX_SIZE/n pair crosses the boundary

The [Lesson 1](lesson-1-basics.md#2-declaration-and-initialization) capacity/logical-size pair becomes a calling convention:

```cpp
// reads up to capacity values; returns how many landed in data
int readData(int data[], int capacity) {
    int n = 0;
    int value;
    while (n < capacity && std::cin >> value && value != -1) {
        data[n] = value;
        n += 1;
    }
    return n;
}

int main() {
    constexpr int MAX_SIZE = 50;
    int data[MAX_SIZE];
    int n = readData(data, MAX_SIZE);      // fill
    std::cout << "Read " << n << " values, sum " << sumOf(data, n) << '\n';
    return 0;
}
```

`readData` writes (plain array param), `sumOf` reads (`const`), and `n` — the logical size — flows from one to the other. This reader/writer split is the standard shape of every [lab](labs.md) in this unit.

<a name="4-a-function-team-on-real-data"></a>
## 4. A function team on real data

Putting it together — the marks program as a team (this is the [mini-project's](miniproject.md) skeleton in miniature):

```cpp
#include <iostream>
#include <iomanip>

constexpr int MAX_STUDENTS = 50;

int    readMarks(int marks[], int capacity);                 // fill; returns n
void   printMarks(const int marks[], int n);                 // printer
int    sumOf(const int marks[], int n);                      // accumulator
int    indexMax(const int marks[], int n);                   // champion
int    indexMin(const int marks[], int n);
double averageOf(const int marks[], int n);                  // uses sumOf
int    countAtLeast(const int marks[], int n, int cut);      // filter counter
int    linearSearch(const int marks[], int n, int target);   // finder

int main() {
    int marks[MAX_STUDENTS];
    int n = readMarks(marks, MAX_STUDENTS);

    printMarks(marks, n);
    std::cout << "Average: " << averageOf(marks, n) << '\n'
              << "Highest: mark of student " << indexMax(marks, n) + 1 << '\n'
              << "Lowest:  mark of student " << indexMin(marks, n) + 1 << '\n'
              << "Passed (>=40): " << countAtLeast(marks, n, 40) << '\n';

    int probe = linearSearch(marks, n, 91);
    if (probe != -1) std::cout << "A 91 was found at position " << probe + 1 << '\n';
    return 0;
}

// ... definitions per house style: prototypes -> main -> definitions ...
```

Compare with the five-`m1..m5` signatures of [Functions E19](../functions/exercises.md#s19--stats-design): the parameter list collapsed, and every function is table-testable with the [driver pattern](../functions/lesson-3-references-testing.md#5-testing-functions--the-payoff-of-small-machines) — a tiny `main` filling an array by hand and calling one machine. The mini-project assembles exactly this team with validation and a menu.

## 5. Refactorings the array finally enables

Three walls fall in this lesson; each is a [refactoring](../functions/refactoring.md) you can do in old programs:

1. **The `m1..m5` collapse.** Every five-parameter statistics signature becomes `(const int marks[], int n)` — [Functions R6's](../functions/refactoring.md#r6--the-giant-main-the-rescue) five machines shrink to one-parameter forms, and a sixth statistic no longer changes any signature.
2. **The re-read hack.** [Functions C1](../functions/challenges.md#c1--the-statistics-suite) answered "above average" by reading the data twice. Now: read once into the array, run `sumOf`, then `countAtLeast(marks, n, static_cast<int>(avg) + 1)` on the *stored* data.
3. **The tally graduates.** The frequency pass needs its `tally[]` *inside* a function too — `void tallyAnswers(const int answers[], int n, int tally[], int options)` shows both faces at once: `const` input, plain output array (the writer announces itself).

## Practice

- [Exercises 17–24](exercises.md) — parameters, const, fills, the team
- [Debugging 7–8](debugging.md)
- [Lab 3](labs.md#lab-3--temperature-analysis) or [Lab 4](labs.md#lab-4--inventory-analysis)

## Key takeaways

- Arrays pass by *handle*, not by copy — functions can (and sometimes should) change the caller's boxes; no copy cost.
- Read-only array parameters take `const`; the compiler enforces the promise.
- The size does not travel with the array — pass `n` explicitly (or capacity + `int& n` for fills).
- The MAX_SIZE/n pair, a `const` reading team, and a plain writing reader is the standard program shape from now on.

→ Next: [Lesson 4 — Two dimensions](lesson-4-matrices.md)
