---
title: "Iteration Predictions"
description: "15 predict-the-output exercises on loops — counters, accumulators, sentinels, break/continue, nesting, digits. Answers separated at the end."
---

# Iteration Predictions (15)

> [← Module home](index.md) · Predict **before** running: write the exact output on paper, then check. [Questions](#questions) first, [answers](#answers) at the end — no peeking between.

<a name="questions"></a>
# Questions

**P1.** (★)

```cpp
int k = 1;
while (k <= 4) {
    std::cout << k * 10 << ' ';
    k = k + 2;
}
```

**P2.** (★)

```cpp
int t = 5;
while (t > 0) {
    std::cout << t << ' ';
    t = t - 1;
}
std::cout << "GO\n";
```

**P3.** (★)

```cpp
int total = 0;
for (int i = 2; i <= 8; i = i + 2) {
    total += i;
}
std::cout << total << '\n';
```

**P4.** (★)

```cpp
int x = 3;
do {
    std::cout << x << ' ';
    x = x - 1;
} while (x > 3);
```

**P5.** (★)

```cpp
int i;
for (i = 1; i <= 3; i = i + 1);   // mind the semicolon
    std::cout << i << ' ';
```

**P6.** (★★)

```cpp
int total = 0;
int count = 0;
for (int i = 1; i <= 6; i = i + 1) {
    if (i % 2 == 0) continue;
    total += i;
    count += 1;
}
std::cout << count << ' ' << total << '\n';
```

**P7.** (★★)

```cpp
int max = 5;
for (int i = 1; i <= 4; i = i + 1) {
    int v = 6 - i;        // 5, 4, 3, 2
    if (v > max) {
        max = v;
    }
}
std::cout << max << '\n';
```

**P8.** (★★) *Sentinel with break and a filter — inputs arrive in this order: `4, 1, 9, -1`.*

```cpp
int total = 0;
int m;
while (true) {
    std::cin >> m;
    if (m == -1) break;
    if (m % 2 == 0) continue;
    total += m;
}
std::cout << total << '\n';
```

**P9.** (★★)

```cpp
for (int r = 1; r <= 2; r = r + 1) {
    for (int c = 1; c <= 3; c = c + 1) {
        std::cout << r * c << ' ';
    }
    std::cout << "| ";
}
```

**P10.** (★★)

```cpp
int n = 482;
int rev = 0;
while (n > 0) {
    rev = rev * 10 + n % 10;
    n = n / 10;
}
std::cout << rev << '\n';
```

**P11.** (★★)

```cpp
int fact = 1;
for (int k = 1; k <= 4; k = k + 1) {
    fact = fact * k;
}
std::cout << fact << '\n';
```

**P12.** (★★)

```cpp
int divisors = 0;
int n = 9;
for (int d = 1; d <= n; d = d + 1) {
    if (n % d == 0) {
        divisors += 1;
        if (divisors > 2) {
            break;
        }
    }
}
std::cout << divisors << '\n';
```

**P13.** (★★★)

```cpp
for (int r = 1; r <= 3; r = r + 1) {
    for (int c = 1; c <= r; c = c + 1) {
        std::cout << r;
    }
    std::cout << ' ';
}
std::cout << '\n';
```

**P14.** (★★★)

```cpp
int total = 0;
int i = 1;
while (i <= 100) {
    if (i % 10 == 0) {
        i = i + 5;
        continue;
    }
    total += i;
    i = i + 1;
}
std::cout << total << '\n';
```

**P15.** (★★★)

```cpp
int a = 0, b = 0;
int n = 7;
while (n > 0) {
    if (n % 2 == 0) {
        a += n;
    } else {
        b += n;
    }
    n = n / 2;
}
std::cout << a << ' ' << b << '\n';
```

---

<a name="answers"></a>
# Answers

**A1.** Condition checked at k = 1, 3, 5. Body prints at k = 1 → `10`, k = 3 → `30`; at k = 5 the condition fails. **Output: `10 30 `**. Stepping by 2 skips values — the pass set is {1, 3}, not "every number up to 4".

**A2.** t = 5, 4, 3, 2, 1 print; at t = 0 the condition fails, then `GO` prints. **Output: `5 4 3 2 1 GO`**.

**A3.** Pass set {2, 4, 6, 8}: total = 2 → 6 → 12 → **20**.

**A4.** `do-while` runs the body first: prints `3`, x becomes 2, condition `2 > 3` is false → exit. **Output: `3 `**. One pass, exactly — the do-while guarantee in action.

**A5.** The semicolon is the body — an empty statement. The loop runs 3 times doing nothing (i becomes 4); *then* the unbraced `cout` runs **once**. **Output: `4 `**. [Debugging D9](debugging.md#d9--the-do-nothing-loop) makes you fix this by hand.

**A6.** Odds in 1..6: {1, 3, 5}. `continue` skips evens. count = 3, total = 1+3+5 = 9. **Output: `3 9`**.

**A7.** v values 5, 4, 3, 2; none beats the seeded champion 5. **Output: `5`**. The champion idiom starts from a seed and only moves on a *strict* `>` — "first value wins ties" is the semantics.

**A8.** Inputs 4, 1, 9, −1: 4 is even → `continue` (total stays 0); 1 odd → total 1; 9 odd → total 10; −1 → break. **Output: `10`**. Two filters (even-skip, sentinel-break) in one loop — the [Lesson 3 §7 trace](lesson-3-break-continue-sentinels.md#7-tracing-loops-with-breaks-and-skips) shape.

**A9.** Outer r = 1: inner prints `1 2 3 | `? No — inner prints `r*c` for c = 1..3 → `1 2 3 `, then `| ` after the inner loop; r = 2 → `2 4 6 | `. **Output: `1 2 3 | 2 4 6 | `**. The separator sits *outside* the inner loop — same structure lesson as the grid's newline.

**A10.** 482: rev = 0×10+2 = 2 (n 48) → 2×10+8 = 28 (n 4) → 28×10+4 = 284 (n 0). **Output: `284`**.

**A11.** fact: 1×1=1, ×2=2, ×3=6, ×4=24. **Output: `24`** — 4!.

**A12.** Divisors of 9: d=1 (count 1), d=3 (count 2), d=9 (count 3 → break fires *after* incrementing). **Output: `3`**. The break stops the *search*, not the increment — count is 3, not 2. Note the count is still "more than 2", so the prime test `divisors == 2` still works correctly.

**A13.** Row r prints `r` repeated r times, then a space *outside* the inner loop: r=1 → `1 `, r=2 → `22 `, r=3 → `333 `. **Output: `1 22 333 `** — no trailing newline; the printed variable is the *row* (contrast [S30](exercises.md#s30--number-triangle), which printed the column).

**A14.** The `continue` path changes `i` by 5 before skipping — so each multiple of 10 *jumps past itself and the next four numbers*. i goes 10 → 15, so 10, 11, 12, 13, 14 are all never added; then 20 → 25 (20–24 gone), ..., 90 → 95 (90–94 gone); finally i = 100 jumps to 105 and the loop exits (100 never added).

Added: {1–9} ∪ {15–19} ∪ {25–29} ∪ ... ∪ {95–99} = 45 + (85+135+...+485) = 45 + 2565 = **2610**.

Complement check: full 1..100 = 5050; removed blocks 10–14, 20–24, ..., 90–94 sum to 60+110+...+460 = 2340; plus 100 itself → 5050 − 2440 = 2610. ✓ The lesson: a `continue` that *also moves the counter* doesn't skip one pass — it redraws the pass set.

**A15.** n path: 7→3→1→0. n=7 odd → b=7; n=3 odd → b=10; n=1 odd → b=11; n=0 stops. a never grows (no even n visited). **Output: `0 11`**. `n = n/2` walks 7, 3, 1 — the [digit-processing](lesson-4-nested-digits-patterns.md#3-digit-processing--10-and--10) family in base 2.

---

**Scoring yourself**: 12+ correct — excellent; you're tracing precisely. 8–11 — solid; reread the wrong ones' *first divergence row* in a dry-run table. Below 8 — re-run [Lesson 1 §2](lesson-1-while.md#2-the-while-loop--anatomy)'s trace method by hand for P1–P4 before continuing; the rest of the unit builds on it.
