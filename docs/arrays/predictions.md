---
title: "Arrays Predictions"
description: "10 trace/output problems on arrays — traversal, passes, handles, tallies, matrices. Answers separated at the end."
---

# Arrays Predictions (10)

> [← Module home](index.md) · Predict on paper — **draw the boxes and fill an index-column trace** — then check the [answers](#answers).

<a name="questions"></a>
# Questions

**P1.** (★)

```cpp
int a[4] = {2};
for (int i = 0; i < 4; i = i + 1) std::cout << a[i] << ' ';
```

**P2.** (★)

```cpp
int a[5] = {10, 20, 30, 40, 50};
for (int i = 4; i >= 0; i = i - 1) std::cout << a[i] << ' ';
```

**P3.** (★)

```cpp
int a[6] = {4, 8, 15, 16, 23, 42};
std::cout << a[1] + a[4] << ' ' << a[a[0]] << '\n';
```

**P4.** (★)

```cpp
int a[3] = {1, 2, 3};
for (int i = 0; i <= 3; i = i + 1) std::cout << a[i] << ' ';
std::cout << "\n(done)";
```

**P5.** (★★)

```cpp
int a[5] = {3, 7, 2, 7, 9};
int best = 0;
for (int i = 1; i < 5; i = i + 1) {
    if (a[i] > a[best]) best = i;
}
std::cout << best << ' ' << a[best] << '\n';
```

**P6.** (★★)

```cpp
int a[5] = {1, 2, 3, 4, 5};
int total = 0;
for (int i = 0; i < 5; i = i + 1) {
    if (a[i] % 2 == 0) continue;
    total += a[i];
}
std::cout << total << '\n';
```

**P7.** (★★)

```cpp
int a[4] = {5, 6, 7, 8};
void twice(int data[]) {
    for (int i = 0; i < 4; i = i + 1) data[i] *= 2;
}
// ... in main: twice(a); then print a[0..3]
```

**P8.** (★★)

```cpp
int tally[4] = {0};
int answers[6] = {1, 3, 2, 3, 1, 3};
for (int i = 0; i < 6; i = i + 1) tally[answers[i]] += 1;
for (int k = 0; k < 4; k = k + 1) std::cout << tally[k] << ' ';
```

**P9.** (★★)

```cpp
int a[4] = {4, 8, 15, 16};
for (int i = 1; i < 4; i = i + 1) {
    a[i] = a[i] + a[i - 1];
}
for (int i = 0; i < 4; i = i + 1) std::cout << a[i] << ' ';
```

**P10.** (★★★)

```cpp
int g[2][3] = { {1, 2, 3}, {4, 5, 6} };
int t = 0;
for (int c = 0; c < 3; c = c + 1) {
    for (int r = 0; r < 2; r = r + 1) {
        t += g[r][c];
    }
    std::cout << t << ' ';
}
```

---

<a name="answers"></a>
# Answers

**A1.** `int a[4] = {2}` fills box 0 with 2 and **the rest with 0** — the one shortcut that does more than the first element. **Output: `2 0 0 0 `**.

**A2.** Backward traversal from index 4 down to 0. **Output: `50 40 30 20 10 `**.

**A3.** `a[1] + a[4]` = 8 + 23 = **31**. `a[a[0]]` = `a[4]` = **23** (data-as-index: box 0's value picks the box). **Output: `31 23`**.

**A4.** The loop visits 0, 1, 2, 3 — and **4**, one past the end. It prints `1 2 3 ` then whatever garbage sits at `a[4]` (or crashes — undefined). Then `(done)`. The [D1](debugging.md#d1--the-sixth-guest) bug in prediction form.

**A5.** Champion-by-index: a[0]=3 seeds; 7 > 3 → best 1; 2 < 7; 7 not **>** 7 → stays 1 (strict comparison, first winner kept); 9 > 7 → best 4. **Output: `4 9`** — the *index* 4, then the value 9.

**A6.** The `continue` skips evens; odds 1+3+5 = **6**. [Iteration P6](../repetition/predictions.md#answers)'s filter, walking boxes.

**A7.** `twice` received a *handle* — the caller's boxes double in place. **Output: `10 12 14 16 `**. The [handle rule](lesson-3-arrays-functions.md#1-what-gets-passed--the-surprise) in one call.

**A8.** tally[1] counts the 1s (2), tally[2] the 2 (1), tally[3] the 3s (3), tally[0] nothing (0). **Output: `0 2 1 3 `**.

**A9.** Running-total in place: a[1] = 8+4 = 12; a[2] = 15+12 = 27 (the *updated* a[1]!); a[3] = 16+27 = 43. **Output: `4 12 27 43 `**. The forward in-place dependency — [D9](debugging.md#d9--the-backwards-copy)'s mirror image.

**A10.** Column-major visit order (columns frozen in the outer loop): column 0 adds 1+4 = 5 → prints 5; column 1 adds 2+5 → t = 12 → prints 12; column 2 adds 3+6 → t = 21 → prints 21. **Output: `5 12 21 `**. Two lessons: the *frozen* variable selects the line, and `t` was never reset — each print includes all previous columns ([gallery M2](lesson-4-matrices.md#6-the-2d-errors-gallery) disguised as a column-sum question; a true per-column sum resets `t` inside the outer loop).

---

**Scoring yourself**: 9–10 — you trace arrays like tables, which is the point. 6–8 — reread the wrong ones' index column, box by box. Below 6 — redo [Lesson 1 §4](lesson-1-basics.md#4-traversal--the-visit-every-box-loop)'s dry run by hand for P1–P4 before moving on.
