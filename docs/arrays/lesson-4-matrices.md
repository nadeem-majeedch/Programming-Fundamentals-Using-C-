---
title: "Lesson 4 — Two Dimensions: Matrices"
description: "Multidimensional arrays, the grid mental model, nested loops, row and column operations, the 2D parameter rule, and the 2D errors gallery."
---

# Lesson 4 — Two Dimensions: Matrices

> [← Module home](index.md) · [← Lesson 3 — Arrays and functions](lesson-3-arrays-functions.md) · [Exercises →](exercises.md)

## In this lesson you will learn

- 2D arrays — a grid of boxes with *two* indices
- how the nested loops you own are the matrix's native language
- row sums, column sums, and the whole-grid pass
- the **2D parameter rule** — the one C++ quirk you must know
- the 2D errors gallery

---

## 1. The grid — one name, two indices

A chessboard, a spreadsheet, a marks table of 4 students × 3 subjects — data that has a *row* and a *column* wants a 2D array:

```cpp
int grid[3][4];                 // 3 rows, 4 columns = 12 boxes
```

```text
              columns
           c=0   c=1   c=2   c=3
  row r=0 [ 72 ] [ 85 ] [ 91 ] [ 67 ]
  row r=1 [ 60 ] [ 55 ] [ 40 ] [ 98 ]
  row r=2 [ 88 ] [ 91 ] [ 79 ] [ 84 ]
```

Access needs both coordinates, row first: `grid[1][2]` is row 1, column 2 → `40`. Read it as "grid row 1, then box 2 *of that row*" — a 2D array is honestly an *array of rows*, each row itself an array. That mental model makes every rule below fall out naturally.

Declaration + initialization nests the braces per row:

```cpp
int grid[2][3] = { {1, 2, 3},      // row 0
                   {4, 5, 6} };    // row 1
int sparse[2][3] = { {1}, {4, 5} };   // 1 0 0 / 4 5 0 — missing → 0
```

## 2. Nested loops — the matrix's native language

[Iteration Lesson 4](../repetition/lesson-4-nested-digits-patterns.md#1-nested-loops--a-loop-inside-a-loop) taught you nesting; the grid is what nesting was *for*. The standard double traversal:

```cpp
for (int r = 0; r < ROWS; r = r + 1) {          // outer = rows
    for (int c = 0; c < COLS; c = c + 1) {      // inner = columns
        std::cout << grid[r][c] << ' ';
    }
    std::cout << '\n';                          // row's end
}
```

The [grid mental model](../repetition/lesson-4-nested-digits-patterns.md#2-the-grid-mental-model) transfers unchanged: *outer = rows, inner = columns, newline between*. Trace for the 2×3 grid above:

| r | c | grid[r][c] | output so far |
| - | - | ---------- | ------------- |
| 0 | 0 | 1 | `1 ` |
| 0 | 1 | 2 | `1 2 ` |
| 0 | 2 | 3 | `1 2 3 ` → newline |
| 1 | 0 | 4 | `4 ` |
| 1 | 1 | 5 | `4 5 ` |
| 1 | 2 | 6 | `4 5 6 ` → newline |

**How many boxes does the body touch?** ROWS × COLS — the [iteration work-counting rule](../repetition/lesson-4-nested-digits-patterns.md#1-nested-loops--a-loop-inside-a-loop) with two loop variables. Swap the loops' order and the *visits* are the same set; what changes is the *order* — which matters the moment you print, or accumulate per-row.

<a name="3-row-and-column-operations"></a>
## 3. Row and column operations

The two half-passes that make matrices useful:

**One row** — freeze `r`, walk the columns:

```cpp
int r = 1;                       // student 1's three subject marks
int total = 0;
for (int c = 0; c < COLS; c = c + 1) {
    total += grid[r][c];         // only c moves
}
```

**One column** — freeze `c`, walk the rows (all students' subject 0):

```cpp
int c = 0;
int total = 0;
for (int r = 0; r < ROWS; r = r + 1) {
    total += grid[r][c];         // only r moves
}
```

The symmetry is the lesson: **the frozen loop variable selects the line; the moving one walks it.** Compose them and you get the per-row report (freeze-and-walk inside the outer loop):

```cpp
// per-row sums — the marks-per-student report
for (int r = 0; r < ROWS; r = r + 1) {
    int rowTotal = 0;                        // RESET per row (D6's shadow trap!)
    for (int c = 0; c < COLS; c = c + 1) {
        rowTotal += grid[r][c];
    }
    std::cout << "Student " << r + 1 << ": " << rowTotal << '\n';
}
```

Per-column reports are the mirror — and the [Lab 6 matrix calculator](labs.md#lab-6--matrix-calculator) builds all four operations into function form.

<a name="4-matrices--the-vocabulary"></a>
## 4. Matrices — the vocabulary

With the mechanics in hand, the standard matrix operations are direct translations:

```cpp
// sum of two 3x3 matrices — box-by-box
for (int r = 0; r < 3; r = r + 1)
    for (int c = 0; c < 3; c = c + 1)
        sumM[r][c] = a[r][c] + b[r][c];

// scalar multiply
for (int r = 0; r < 3; r = r + 1)
    for (int c = 0; c < 3; c = c + 1)
        scaled[r][c] = a[r][c] * k;

// transpose (rows become columns) — note the swap of indices
for (int r = 0; r < 3; r = r + 1)
    for (int c = 0; c < 3; c = c + 1)
        t[c][r] = a[r][c];

// matrix multiplication (the only non-obvious one): dot product of
// A's row r with B's column c, accumulated over the shared dimension
for (int r = 0; r < 3; r = r + 1)
    for (int c = 0; c < 3; c = c + 1) {
        prod[r][c] = 0;
        for (int k = 0; k < 3; k = k + 1)
            prod[r][c] += a[r][k] * b[k][c];
    }
```

Multiplication is the [three-nested-loops](../repetition/lesson-4-nested-digits-patterns.md#1-nested-loops--a-loop-inside-a-loop) summit of the course so far — r and c select the output box, k walks both inputs' shared dimension. [Challenge C10](challenges.md#c10--the-multiplication-prover) has you verify it by hand; [Lab 6](labs.md#lab-6--matrix-calculator) implements the family with tests.

**Diagonals** of a square matrix are index-patterns, not loops: main diagonal boxes satisfy `r == c`; the anti-diagonal satisfies `r + c == SIZE - 1`. Test boxes *inside* one traversal with those conditions ([C11](challenges.md#c11--the-diagonal-inspector)).

## 5. The 2D parameter rule

Passing a 2D array to a function has exactly one C++ quirk, and it's non-negotiable:

```cpp
int rowSum(const int grid[][COLS], int r);        // ✅ first [] empty, second REQUIRED
int rowSum(const int grid[3][4], int r);          // ✅ same thing, sizes written
// int rowSum(const int grid[][], int r);         // ❌ compile error
```

**The column count must be a compile-time constant in the parameter** — the row dimension may be left empty (pass it as a parameter: `int rows`). Why: the handle arithmetic needs to know how wide a row is to find row 2's start; the row *count* is irrelevant to that job. Consequence for course code: `constexpr int COLS = 4;` at file scope, functions written against it — the [Lab 6](labs.md#lab-6--matrix-calculator) team does exactly this.

<a name="6-the-2d-errors-gallery"></a>
## 6. The 2D errors gallery

| # | Bug | Signature symptom |
| --- | --- | --- |
| M1 | Swapped indices (`grid[c][r]`) | works for square matrices' diagonal; mirrors everything else |
| M2 | Row total not reset per row | each row's "sum" includes all previous rows |
| M3 | `grid[ROWS][COLS]` accessed as `grid[ROWS-1][COLS]` | one-past-the-column — bounds in 2D |
| M4 | Parameter missing the column size | compile error (the §5 rule) |
| M5 | Printing without per-row newline | one long line — the grid pair A bug, 2D edition |

M1 deserves a caution: on a *square* matrix full of symmetric test data, swapped indices are invisible. Test with asymmetric data (`{1,2,3},{4,5,6}`) — the transpose exercise in [E29](exercises.md#s29--row-and-column-reports) exists to catch exactly this.

## Practice

- [Exercises 25–32](exercises.md) — grids, row/column reports, matrices
- [Predictions 8–10](predictions.md#questions)
- [Debugging 9–10](debugging.md)
- [Lab 6](labs.md#lab-6--matrix-calculator) — the matrix calculator

## Key takeaways

- A 2D array is a grid of boxes addressed `grid[r][c]` — honestly an array of rows.
- Nested loops are its native language; outer = rows, inner = columns, newline between; work = ROWS × COLS.
- Freeze one variable to operate on a line; reset per-line accumulators inside the outer loop.
- The 2D parameter rule: the column count is a required compile-time constant.
- Test 2D code with asymmetric data — symmetry hides swapped indices.

→ Next: [Exercises](exercises.md) — then the [mini-project](miniproject.md).
