---
title: "Arrays Debugging Exercises"
description: "10 seeded array bugs — bounds, off-by-one, garbage fills, handle surprises, matrix index swaps. Find, fix, reflect."
---

# Arrays Debugging Exercises (10)

> [← Module home](index.md) · Find → Fix → Reflect. **Draw the boxes and trace before compiling** — array bugs live in the index arithmetic. Hints are progressive.

---

## D1 — The sixth guest

```cpp
// intent: print 5 marks
int marks[5] = {72, 85, 91, 67, 78};
for (int i = 0; i <= 5; i = i + 1) {
    std::cout << marks[i] << ' ';
}
```

Five marks in — six values out, the last one nonsense (or a crash). Diagnose precisely.

<details markdown="1"><summary>Hints</summary>

1. List the indices the loop visits.
2. Which one is not a box? ([bounds](lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does))
3. [Gallery A1](lesson-1-basics.md#7-the-common-errors-gallery).

</details>

<a name="d1--the-sixth-guest"></a>
**Fix:** `i < 5`. **Reflect:** size 5 → valid indices 0–4; `<=` is the fence-post error. The house `i < n` style exists because its exit sentence is "while the index is valid".

---

## D2 — The memory exhibit

```cpp
// intent: initialize all 10 boxes to 1
int a[10];
for (int i = 1; i <= 10; i = i + 1) {
    a[i] = 1;
}
std::cout << a[0] << '\n';     // surprise!
```

Two bugs share this loop. Find both, and explain what `a[0]` might print.

<details markdown="1"><summary>Hints</summary>

1. Which boxes did the loop actually write?
2. Which box did it write that *isn't* a box?
3. Box 0 was never initialized — [gallery A6](lesson-1-basics.md#7-the-common-errors-gallery).

</details>

<a name="d2--the-memory-exhibit"></a>
**Fix:** `for (int i = 0; i < 10; i = i + 1) a[i] = 1;` (or `int a[10] = {1};`? — **no**: that fills box 0 with 1 and the rest with 0 — the `{v}` shortcut only fills *everything* when v is 0. Say the initialization honestly: an explicit loop.) **Reflect:** this loop both started one too late (skipping box 0) and ended one too far (touching index 10) — the two ends of the same off-by-one coin.

---

## D3 — The partial print

```cpp
int data[100] = {0};
int n = 4;
// ... four values read into data[0..3] ...
for (int i = 0; i < 100; i = i + 1) {
    std::cout << data[i] << ' ';
}
```

The output is `72 85 91 67` followed by ninety-six zeros. Why is using the *capacity* here wrong, and when would the same loop be right?

<details markdown="1"><summary>Hints</summary>

1. Capacity vs [logical size](lesson-1-basics.md#2-declaration-and-initialization).
2. What does the array *mean* after 4 values?

</details>

<a name="d3--the-partial-print"></a>
**Fix:** `for (int i = 0; i < n; i = i + 1)`. **Reflect:** the same capacity loop is *correct* in the initialization pass (touch all boxes once) and wrong in every *data* pass (touch only the live boxes). Purpose decides the bound.

---

## D4 — The search that found −1

```cpp
int pos = linearSearch(marks, n, target);   // returns -1 when absent
std::cout << "Your mark: " << marks[pos] << '\n';
```

Search for 999 (absent) → the program prints a "mark" that was never entered — or crashes. Trace the two failure modes.

<details markdown="1"><summary>Hints</summary>

1. What is `pos` when the target is absent?
2. What does `marks[-1]` mean? ([Lesson 2 §1](lesson-2-classic-passes.md#1-linear-search--the-find-machine)'s warning)

</details>

<a name="d4--the-search-that-found-1"></a>
**Fix:**

```cpp
if (pos != -1) std::cout << "Your mark: " << marks[pos] << '\n';
else           std::cout << "Not found.\n";
```
**Reflect:** a search result is data-as-index — every index from data must be validated before use ([gallery A3](lesson-1-basics.md#7-the-common-errors-gallery)).

---

## D5 — The copy that wasn't

```cpp
int a[3] = {1, 2, 3};
int b[3];
b = a;                        // "copy"
std::cout << b[0] << '\n';
```

It doesn't even compile. What does the compiler say, what *would* the honest copy be — and (advanced thought) why can't arrays be assigned the way ints can?

<details markdown="1"><summary>Hints</summary>

1. [Gallery A4](lesson-1-basics.md#7-the-common-errors-gallery).
2. An array name is a handle on the boxes, not a value.

</details>

<a name="d5--the-copy-that-wasnt"></a>
**Fix:**

```cpp
for (int i = 0; i < 3; i = i + 1) b[i] = a[i];
```
**Reflect:** ints are *values*; array names are *handles* — assignment semantics differ precisely because of what the name *is* ([Lesson 3 §1](lesson-3-arrays-functions.md#1-what-gets-passed--the-surprise) foreshadows this).

---

## D6 — The function that saw garbage

```cpp
void printAll(const int data[]) {          // note: no size parameter
    for (int i = 0; i < 5; i = i + 1)      // "we always have 5"
        std::cout << data[i] << ' ';
}
int main() {
    int data[5] = {0};
    int n = readData(data, 5);             // user entered only 2 values
    printAll(data);
    return 0;
}
```

With 2 values entered, the output is `72 85 0 0 0` — two real values and three zeros that mean nothing. The hard-coded 5 is one bug; the missing size parameter is the deeper one. Fix both properly.

<details markdown="1"><summary>Hints</summary>

1. Who knows `n`? Who needs it?
2. [The size travels separately](lesson-3-arrays-functions.md#3-the-size-travels-separately--and-how).

</details>

<a name="d6--the-function-that-saw-garbage"></a>
**Fix:** `void printAll(const int data[], int n)` with `i < n`; call `printAll(data, n)`. **Reflect:** a function cannot ask an array its length — hard-coded sizes are a lie the first time input varies; the logical size is a *parameter*, always.

---

## D7 — The const violation

```cpp
int total(const int a[], int n) {
    int t = 0;
    for (int i = 0; i < n; i = i + 1) {
        t += a[i];
        a[i] = 0;              // "clean up as we go"
    }
    return t;
}
```

The compiler rejects it. Quote the promise that was broken, then decide: is the "cleanup" ever a good idea — and where would it go if it were?

<details markdown="1"><summary>Hints</summary>

1. `const int a[]` promised what? ([Lesson 3 §2](lesson-3-arrays-functions.md#2-const--the-safety-belt))
2. Does summing *need* to mutate?

</details>

<a name="d7--the-const-violation"></a>
**Fix:** delete `a[i] = 0;` — summing is a pure read. If a genuine "consume as you read" task existed, the parameter would be a plain writer `int a[]` and the *name would say so* (`consume(...)`) — but hiding a write inside a function named `total` breaks the read/write contract that makes teams reviewable. **Reflect:** `const` isn't bureaucracy; it's the compiler enforcing your signature's promise.

---

## D8 — The tally that exploded

```cpp
int tally[5] = {0};
for (int i = 0; i < n; i = i + 1) {
    tally[answers[i]] += 1;         // answers are "1..5", we think
}
```

With the real answer sheet containing one `7` and one `0`, this sometimes works, sometimes crashes. Diagnose the index range, then fix with the guard from [Lesson 2 §4](lesson-2-classic-passes.md#4-frequency-counting--the-tally-array) — and decide what to *do* with out-of-range answers (count separately? reject?).

<details markdown="1"><summary>Hints</summary>

1. Which indices can `answers[i]` produce?
2. Which are valid tally boxes?
3. Data-as-index needs the range check *inside the loop*.

</details>

<a name="d8--the-tally-that-exploded"></a>
**Fix:**

```cpp
if (answers[i] >= 1 && answers[i] <= 5) tally[answers[i]] += 1;
else                                    invalid += 1;    // honest third category
```
**Reflect:** the tally is only as safe as the data's range — the guard converts "sometimes works" into "defined behaviour with a documented outcome".

---

## D9 — The backwards copy

```cpp
// intent: shift each box right by one: a[i] takes a[i-1]'s value (box 0 lost)
for (int i = 1; i < n; i = i + 1) {
    a[i] = a[i - 1];
}
```

Intent: `{4, 8, 15, 16}` → `{4, 4, 8, 15}`. Actual: `{4, 4, 4, 4}`. Why does direction matter here, and which loop order fixes it?

<details markdown="1"><summary>Hints</summary>

1. Trace box by box: when you write `a[2]`, what's in `a[1]` — the original or an overwritten copy?
2. The boxes you still *need* are the ones you're overwriting first.

</details>

<a name="d9--the-backwards-copy"></a>
**Fix:** run the loop **backward** — `for (int i = n - 1; i >= 1; i = i - 1) a[i] = a[i - 1];` — so each box is overwritten only after it has been copied. **Reflect:** in-place transformations have a direction; when the source of one write is the destination of another, walk away from the reads. ([C2](challenges.md#c2--the-shifter) is the general workout.)

---

## D10 — The mirrored matrix

```cpp
// intent: print the transpose of a 3x3 matrix
int a[3][3] = { {1, 2, 3}, {4, 5, 6}, {7, 8, 9} };
for (int r = 0; r < 3; r = r + 1) {
    for (int c = 0; c < 3; c = c + 1) {
        std::cout << a[r][c] << ' ';
    }
    std::cout << '\n';
}
std::cout << "transpose:\n";
for (int r = 0; r < 3; r = r + 1) {
    for (int c = 0; c < 3; c = c + 1) {
        std::cout << a[r][c] << ' ';        // "just swap the loops"
    }
    std::cout << '\n';
}
```

The "transpose" prints the original. One character fixes it — which, and why does the same bug hide on *symmetric* test data?

<details markdown="1"><summary>Hints</summary>

1. What does a transpose access — `a[?][?]`?
2. Swapping the *loops* vs swapping the *indices* — which changes the access?

</details>

<a name="d10--the-mirrored-matrix"></a>
**Fix:** print `a[c][r]` — the transpose is an index swap, not a loop swap ([gallery M1](lesson-4-matrices.md#6-the-2d-errors-gallery); swapping the loops only changes visit *order*, which for a full-grid print changes nothing). **Reflect:** this is exactly why [E30/S30](exercises.md#s30--add-and-transpose) demands asymmetric test data — on `{1,2,3},{4,5,6}`-style data the bug is visible instantly; on symmetric matrices it's invisible.

---

## Fix-list recap

| D | Bug family | Gallery |
| --- | --- | --- |
| D1 | off-by-one bound | A1 |
| D2 | skip-first + touch-past-end | A1/A6 |
| D3 | capacity where logical size belongs | A2 |
| D4 | unchecked search index | A3 |
| D5 | array assignment with `=` | A4 |
| D6 | missing size parameter / hard-coded size | A2 + [Lesson 3 §3](lesson-3-arrays-functions.md#3-the-size-travels-separately--and-how) |
| D7 | write through a const promise | [Lesson 3 §2](lesson-3-arrays-functions.md#2-const--the-safety-belt) |
| D8 | data-as-index without range guard | A3 |
| D9 | in-place shift in the wrong direction | direction discipline |
| D10 | swapped indices vs swapped loops | M1 |
