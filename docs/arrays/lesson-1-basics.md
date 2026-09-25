---
title: "Lesson 1 — The Row of Boxes"
description: "The array concept, declaration, initialization, indexing, traversal, bounds, updating elements, and the common errors gallery."
---

# Lesson 1 — The Row of Boxes

> [← Module home](index.md) · Lesson 1 of 4 · [Lesson 2 — The classic passes →](lesson-2-classic-passes.md)

## In this lesson you will learn

- what an array *is* — and the one big trade it makes
- declaration and initialization, including the shortcuts
- **indexing**: position numbers from 0, and the last-index rule
- **traversal** — the visit-every-box loop, the workhorse of the unit
- updating elements; reading unknown `n` into a fixed array
- **bounds** — the honest story of what out-of-bounds access does
- the common errors gallery

---

## 1. The concept — one name, many boxes

Five marks as five variables:

```cpp
int m1, m2, m3, m4, m5;     // five names, five statements for every task
```

Five marks as an **array**:

```cpp
int marks[5];               // one name, five boxes
```

```text
 marks
┌────┬────┬────┬────┬────┐
│ 72 │ 85 │ 91 │ 67 │ 78 │   values
└────┴────┴────┴────┴────┘
  [0]  [1]  [2]  [3]  [4]      indices (positions)
```

An array is a **row of same-typed boxes under one name**, where each box has a *position number* — the **index**. The trade it makes: all boxes same type, and the count **fixed at compile time**. (The growable cousin, `std::vector`, belongs to [Stage E](../syllabus.md#stage-e-memory-and-objects-units-13-15); fixed arrays first — they teach what vectors automate.)

The first big fact: **numbering starts at 0**. The five boxes above are `marks[0]` … `marks[4]`. The index is the *offset from the start*: the first box is zero boxes away from `marks`, the last is four boxes away.

<a name="2-declaration-and-initialization"></a>
## 2. Declaration and initialization

```cpp
int marks[5];                        // declaration: 5 boxes, garbage contents
int ages[3] = {15, 16, 17};          // declaration + full initialization
double rates[] = {6.0, 7.0, 8.0};    // size deduced from the list (3)
int zeros[100] = {0};                // first box 0, REST ALSO 0 (the one exception)
int partial[5] = {1, 2};             // 1, 2, then 0, 0, 0
```

Rules that matter:

- **Uninitialized local arrays hold garbage** — same law as [iteration D5](../repetition/debugging.md#d5--the-poisoned-accumulator).
- `{0}` fills *everything* with 0 — the one initialization shortcut that does more than the first element. Any other count: missing values become 0, extra values are a compile error.
- The **size must be a compile-time constant**: `int a[n];` with a *runtime* `n` is illegal in standard C++. The course pattern for "n values, n unknown until run time":

```cpp
constexpr int MAX_SIZE = 100;        // the array's physical capacity
int data[MAX_SIZE];
int n = 0;                           // the logical size: how many boxes are in use
// ... read values while (n < MAX_SIZE), storing into data[n] and counting ...
```

**Capacity vs logical size** — two different numbers, forever. `MAX_SIZE` is how many boxes exist; `n` is how many you're using. Every pass in this module runs over `0..n-1`, never `0..MAX_SIZE-1`, unless the task says full.

<a name="3-indexing--reading-and-updating"></a>
## 3. Indexing — reading and updating

`marks[2]` is a single `int` box — usable anywhere an `int` is:

```cpp
std::cout << marks[2];           // read one box
marks[2] = 95;                   // UPDATE one box — assignment, not append
total += marks[2];               // in an expression
marks[2] = marks[2] + 5;         // read and write the same box
```

The index itself can be any integer expression — *that's* the superpower variables-as-indices unlock:

```cpp
std::cout << marks[i];           // whichever box i names right now
```

**The last-index rule** (burn it in): an array of size `n` has valid indices `0 .. n-1`. For `marks[5]`:

| Index | Verdict |
| --- | --- |
| `marks[0]` … `marks[4]` | ✅ valid |
| `marks[5]` | ❌ **one past the end** — the classic fence-post box that isn't there |

<a name="4-traversal--the-visit-every-box-loop"></a>
## 4. Traversal — the visit-every-box loop

The workhorse. Visit every box, in order, doing the body's work on each:

```cpp
for (int i = 0; i < n; i = i + 1) {
    std::cout << marks[i] << ' ';
}
```

Two styles, both correct, one convention:

```cpp
for (int i = 0; i <= n - 1; i = i + 1)   // A: "0 to n-1"  — matches the last-index rule literally
for (int i = 0; i < n; i = i + 1)        // B: "0 while below n" — the course convention
```

B is the house style because its exit sentence ("while the index is a valid one") is unambiguous, and the `<= n - 1` form is where [off-by-one bugs](../repetition/lesson-2-for.md#5-off-by-one--the-boundary-problem) breed when `n` becomes `n+1` during an edit. Pick B, prove boundaries with the dry-run habit.

**Traversal patterns** you'll use in every pass this unit:

| Pattern | Shape |
| --- | --- |
| Visit all | `for (i = 0; i < n; i++) { use data[i]; }` |
| Visit backward | `for (i = n - 1; i >= 0; i--) { use data[i]; }` |
| Counting in two places | counter *outside* the array loop, array index *inside* |

A backward traversal is a first-class pattern, not a trick — reversal, "last match" searches, and printing tables bottom-up all want it.

**Dry-run table** for the traversal printing `data = {72, 85, 91}`, n = 3:

| i | i < 3? | data[i] | output so far |
| - | ------ | ------- | ------------- |
| 0 | yes | 72 | `72 ` |
| 1 | yes | 85 | `72 85 ` |
| 2 | yes | 91 | `72 85 91 ` |
| 3 | no → exit | — | — |

The loop checked `i = 3` once — the [exit-certificate row](../repetition/lesson-1-while.md#2-the-while-loop--anatomy) wearing an index column now.

## 5. Reading n values into an array

The standard input loop, using the capacity/logical-size pair:

```cpp
// read.cpp — read marks until blank
#include <iostream>

int main() {
    constexpr int MAX_SIZE = 50;
    int marks[MAX_SIZE];

    int n = 0;
    std::cout << "How many marks (1-" << MAX_SIZE << ")? ";
    std::cin >> n;
    if (n < 1 || n > MAX_SIZE) {
        std::cout << "Out of range.\n";
        return 1;
    }

    for (int i = 0; i < n; i = i + 1) {
        std::cout << "Mark " << i + 1 << ": ";
        std::cin >> marks[i];               // box i gets value i
    }

    std::cout << "You entered: ";
    for (int i = 0; i < n; i = i + 1) {
        std::cout << marks[i] << ' ';
    }
    std::cout << '\n';
    return 0;
}
```

Two details worth naming: the *prompt* counts humans (`i + 1`) while the *index* counts boxes (`i`); and reading directly into `marks[i]` is just assignment with extra steps — `cin` into the box named by `i`.

<a name="6-bounds--what-out-of-bounds-really-does"></a>
## 6. Bounds — what out-of-bounds really does

C++ does **not** check indices at run time. `marks[7]` on a five-box array compiles and runs — and touches memory that belongs to *something else*: a neighbouring variable, garbage, or nothing the program owns. Consequences range from silently reading junk, to corrupting an unrelated variable (the classic mysterious-variable-changes bug), to crashing.

```text
┌────┬────┬────┬────┬────┬┄┄┄┄┄┄┄┄
│ 72 │ 85 │ 91 │ 67 │ 78 │ ? ? ?   ← marks[5], [6], [7] live out here
└────┴────┴────┴────┴────┴┄┄┄┄┄┄┄┄
  [0]  [1]  [2]  [3]  [4]   (undefined behaviour — anything may happen)
```

The defence is entirely yours, and it's procedural:

1. **The loop bound comes from the logical size**: `i < n`, with `n` validated on input.
2. **Never index with an unvalidated value**: an index that came from the user or from a search miss (−1!) must be checked *before* use — [Lab 2](labs.md#lab-2--sales-analysis) drills exactly this.
3. **Draw the boxes** before coding; count them; the last index is *count − 1*.

(The deeper mechanics — *why* the corruption lands where it lands — is [Unit 13](../syllabus.md#stage-e-memory-and-objects-units-13-15)'s pointers territory. For now: undefined behaviour is a promise that *anything* may happen, so "it worked on my machine" proves nothing.)

<a name="7-the-common-errors-gallery"></a>
## 7. The common errors gallery

| # | Bug | Signature symptom |
| --- | --- | --- |
| A1 | Off-by-one bound (`i <= n` on size-n) | one garbage value read/printed at the end |
| A2 | Using capacity where logical size belongs | garbage for the unfilled boxes |
| A3 | Index from an unvalidated source | mysterious values / crashes on certain inputs |
| A4 | Assigning arrays with `=` | compile error (arrays aren't assignable) |
| A5 | Copying with `=` *inside* a struct-like context or expecting deep copy | only fixed by an element loop (§ Lesson 2) |
| A6 | Forgetting `{0}` initialization | garbage in the never-written boxes |
| A7 | Sentinel read past capacity (`n < MAX` missing) | overflow past the last box |
| A8 | `n` changed mid-traversal | loop visits wrong region — trace it |

A4 deserves its example — the most surprising compile error of the unit:

```cpp
int a[3] = {1, 2, 3}, b[3];
b = a;                        // ERROR: invalid array assignment
for (int i = 0; i < 3; i = i + 1) b[i] = a[i];   // the honest copy
```

## Practice

- [Exercises 1–8](exercises.md) — boxes, indexing, traversal, bounds
- [Predictions 1–3](predictions.md#questions)
- [Debugging 1–3](debugging.md) — the bounds family
- [Lab 7](labs.md#lab-7--simple-statistics-calculator) after Lesson 2

## Key takeaways

- An array: one name, fixed count of same-typed boxes, indices `0..n-1` — the index is the offset from the start.
- Capacity (`MAX_SIZE`) vs logical size (`n`) are different numbers; every pass runs `0..n-1`.
- Traversal is `for (i = 0; i < n; i++)`; the dry-run table gains an index column.
- Out-of-bounds is unchecked and undefined — defence is procedural: validate n, validate indices, draw the boxes.

→ Next: [Lesson 2 — The classic passes](lesson-2-classic-passes.md)
