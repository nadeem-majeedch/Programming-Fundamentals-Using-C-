---
title: "Iteration Debugging Exercises"
description: "15 seeded loop bugs — infinite loops, off-by-one, sentinel collisions, continue traps, nesting errors. Find, fix, reflect."
---

# Iteration Debugging Exercises (15)

> [← Module home](index.md) · Find → Fix → Reflect. **Don't compile first — trace.** Every bug here is visible in a dry-run table ([Lesson 1 §2](lesson-1-while.md#2-the-while-loop--anatomy)); that is the skill being trained. Hints are progressive — open one only when stuck.

---

## D1 — The tally that never ends

```cpp
// intent: read 5 marks, print their total
int total = 0;
int i = 1;
while (i <= 5) {
    int m;
    std::cin >> m;
    total += m;
}
std::cout << total << '\n';
```

What happens when you run it? Which rule-of-three part is broken?

<details markdown="1"><summary>Hints (open one at a time)</summary>

1. Trace two passes: what does `i` do in each?
2. The condition reads `i` — who is supposed to change `i`?
3. The body updates `total` but never `i` — this is E1 of the [error gallery](lesson-4-nested-digits-patterns.md#6-the-common-loop-errors-gallery).

</details>

<a name="d1--the-tally-that-never-ends"></a>
**Fix:** `i = i + 1;` as the body's last statement. **Reflect:** the condition tested a variable nothing updated — cause 1 of [infinite loops](lesson-1-while.md#4-infinite-loops--the-runaway-train).

---

## D2 — The zero-pass sum

```cpp
int total = 0;
int i = 5;
while (i <= 5) {
    total += i;
    i = i - 1;
}
std::cout << total << '\n';   // expected: 15 (5+4+3+2+1)
```

It compiles, runs, and prints `5`. Why?

<details markdown="1"><summary>Hints</summary>

1. Trace pass 1: what are `i` and the condition's verdict?
2. What is `i` on the second check?
3. The update walks *away* from the exit — wrong-direction update ([gallery E2](lesson-4-nested-digits-patterns.md#6-the-common-loop-errors-gallery)).

</details>

<a name="d2--the-zero-pass-sum"></a>
**Fix:** `i = i - 1;` → `i = i + 1;` won't fix it — the *bound* must flip too: `while (i >= 1)`. **Reflect:** direction is a *pair*: update direction and condition direction must agree.

---

## D3 — The overflowing loop

```cpp
// intent: print 1..5, one per line
for (int i = 1; i <= 5; i = i + 1)
    std::cout << i << '\n';
    std::cout << "Done\n";
```

The program prints 1–5 — then prints `Done` five times... no. What does it actually print, and why?

<details markdown="1"><summary>Hints</summary>

1. No braces — which statement belongs to the loop?
2. What did [Lesson 4 §6](lesson-4-nested-digits-patterns.md#6-the-common-loop-errors-gallery) call the semicolon's cousin, the unbraced body?
3. Only the *first* statement is the body; `Done` runs once — unless you misread the indent.

</details>

<a name="d3--the-overflowing-loop"></a>
**Fix:** brace both statements. **Reflect:** indentation lies; braces don't. This is the [Decisions Lesson 1](../decisions/lesson-1-branches.md) braces rule applied to loops.

---

## D4 — The off-by-one table

```cpp
// intent: average of the 5 marks 10 20 30 40 50 (expect 30)
int total = 0;
for (int i = 1; i < 5; i = i + 1) {
    int m;
    std::cin >> m;
    total += m;
}
std::cout << total / 5 << '\n';
```

With inputs `10 20 30 40 50`, it prints... not 30. What and why?

<details markdown="1"><summary>Hints</summary>

1. Which values does the body see for `i < 5`? ([E15's pass sets](exercises.md#s15--pass-sets))
2. The 5th mark is never read — where does it go?
3. `i <= 5` — but check the *division* too.

</details>

<a name="d4--the-off-by-one-table"></a>
**Fix:** `i <= 5`. (And `total / 5` is int division of a clean multiple here — 150/5 = 30, fine; with a non-divisible total it would truncate: use `static_cast<double>(total) / 5`.) **Reflect:** `i < n` vs `i <= n` — prove the boundary with the [exit-sentence rule](lesson-2-for.md#5-off-by-one--the-boundary-problem).

---

## D5 — The poisoned accumulator

```cpp
int total;
int i = 1;
while (i <= 3) {
    int m;
    std::cin >> m;
    total += m;
    i = i + 1;
}
std::cout << total << '\n';
```

Inputs `10 20 30` — output is 60 on one machine, 17409 on another. Same code, different answer. Why?

<details markdown="1"><summary>Hints</summary>

1. What is `total`'s value on pass 1?
2. Was it ever assigned?
3. Uninitialized variable — [gallery E4](lesson-4-nested-digits-patterns.md#6-the-common-loop-errors-gallery).

</details>

<a name="d5--the-poisoned-accumulator"></a>
**Fix:** `int total = 0;` — accumulators start at their identity value. **Reflect:** "works on my machine" is the uninitialized-variable signature: the junk is whatever the memory held.

---

## D6 — The vanishing total

```cpp
// intent: running total of 4 sales
double total = 0;
for (int i = 1; i <= 4; i = i + 1) {
    double sale;
    std::cin >> sale;
    double total = 0;      // ← fresh start each pass?
    total += sale;
}
std::cout << total << '\n';
```

Inputs `100 200 50 75` — prints `0`. Find the two bugs.

<details markdown="1"><summary>Hints</summary>

1. How many variables named `total` exist?
2. Which one does `cout` see?
3. Inner declaration shadows the outer — and resets every pass ([gallery E5](lesson-4-nested-digits-patterns.md#6-the-common-loop-errors-gallery)).

</details>

<a name="d6--the-vanishing-total"></a>
**Fix:** delete the inner line entirely. **Reflect:** declare accumulators *once, before* the loop; a declaration inside a loop is a reset, and shadowing hides the real one.

---

## D7 — The hungry sentinel

```cpp
// intent: total donations until -1
int total = 0;
int d;
std::cin >> d;
while (d != -1) {
    total += d;
    std::cin >> d;
}
std::cout << "Total: " << total << '\n';
```

The clerk enters donations `50, -1` and the total is 50 — correct. But a different clerk's donations `30, -1, 20, -1` total 50 and the 20 vanished. Wait — re-read the intent: the clerk *queues* two customers' donations separated by -1. What does this program actually compute, and what design question does that raise?

<details markdown="1"><summary>Hints</summary>

1. What does the loop do at the *first* -1?
2. Can it ever see the second customer's 20?
3. A sentinel ends *the whole loop* — it cannot mean "pause" ([sentinel rules](lesson-3-break-continue-sentinels.md#4-sentinel-controlled-loops-properly)).

</details>

<a name="d7--the-hungry-sentinel"></a>
**Fix (design, not syntax):** one loop per customer — wrap the sentinel loop in an outer "next customer?" loop, or define a different data format. **Reflect:** a sentinel means "end of ALL data". Nested data needs nested loops ([Lesson 4 §1](lesson-4-nested-digits-patterns.md#1-nested-loops--a-loop-inside-a-loop)) — or a redesigned input format.

---

## D8 — The self-colliding sentinel

```cpp
// intent: average of quiz answers, each 1..4; stop on 0
int total = 0, count = 0;
int a;
std::cin >> a;
while (a != 0) {
    total += a;
    count += 1;
    std::cin >> a;
}
if (count > 0)
    std::cout << static_cast<double>(total) / count << '\n';
```

Answers `3 2 0` work. But the teacher's sheet uses `0` to mean "question skipped" — a legitimate answer count. What went wrong *before any code ran*?

<details markdown="1"><summary>Hints</summary>

1. What is a sentinel allowed to mean? ([Lesson 3 §4](lesson-3-break-continue-sentinels.md#4-sentinel-controlled-loops-properly))
2. Can 0 ever be real data here?
3. Sentinel choice is a *requirements* decision — [gallery E6](lesson-4-nested-digits-patterns.md#6-the-common-loop-errors-gallery).

</details>

<a name="d8--the-self-colliding-sentinel"></a>
**Fix:** pick an impossible value: `-1` (or read the count first and use a `for`). **Reflect:** the sentinel must be a value that can never be real data — that's a property of the *requirements*, not the code.

---

## D9 — The do-nothing loop

```cpp
// intent: print Hello three times
for (int i = 1; i <= 3; i = i + 1);
{
    std::cout << "Hello\n";
}
```

Prints `Hello` exactly once. Why?

<details markdown="1"><summary>Hints</summary>

1. What is the loop's body here? ([gallery E7](lesson-4-nested-digits-patterns.md#6-the-common-loop-errors-gallery))
2. What is the `{...}` block to the loop?
3. The semicolon is an empty statement — the loop runs three times doing nothing.

</details>

<a name="d9--the-do-nothing-loop"></a>
**Fix:** delete the semicolon. **Reflect:** a semicolon after a loop header is a complete (empty) body; the block after it is just a statement that follows the loop.

---

## D10 — The continue that ate the update

```cpp
// intent: print 1..5, skipping 3
int k = 1;
while (k <= 5) {
    if (k == 3) {
        continue;
    }
    std::cout << k << '\n';
    k = k + 1;
}
```

Prints `1 2` and then hangs forever. Trace it and fix.

<details markdown="1"><summary>Hints</summary>

1. Pass 3: where does `continue` jump *to*? ([the trap](lesson-3-break-continue-sentinels.md#3-continue--skip-this-pass))
2. Does `k` get updated on that pass?
3. In a `while`, `continue` skips the *rest of the body* — including the update.

</details>

<a name="d10--the-continue-that-ate-the-update"></a>
**Fix:** move the update *before* the `if`, or convert to a `for` (whose update runs even after `continue`). **Reflect:** `for` honours the header contract; `while`'s update is just a body line.

---

## D11 — The flat grid

```cpp
// intent: 3 x 3 grid of stars
for (int r = 1; r <= 3; r = r + 1) {
    for (int c = 1; c <= 3; c = c + 1) {
        std::cout << "* ";
        std::cout << '\n';
    }
}
```

Output is 9 lines of one star each. Fix the structure.

<details markdown="1"><summary>Hints</summary>

1. Which loop should own the newline? ([grid model](lesson-4-nested-digits-patterns.md#2-the-grid-mental-model))
2. Rows outside, columns inside.
3. `'\n'` after the *inner* loop, inside the *outer*.

</details>

<a name="d11--the-flat-grid"></a>
**Fix:**

```cpp
for (int r = 1; r <= 3; r = r + 1) {
    for (int c = 1; c <= 3; c = c + 1) {
        std::cout << "* ";
    }
    std::cout << '\n';          // end of ROW
}
```

**Reflect:** the newline's *position* encodes the row structure — Bug A of the grid pair.

---

## D12 — The dependency that wasn't

```cpp
// intent: triangle — row r has r stars
for (int r = 1; r <= 4; r = r + 1) {
    for (int c = 1; c <= 4; c = c + 1) {
        std::cout << "* ";
    }
    std::cout << '\n';
}
```

Prints a 4×4 square, not a triangle. One character fixes it — which?

<details markdown="1"><summary>Hints</summary>

1. What is the *rule* for row r? ([rule → statement](lesson-4-nested-digits-patterns.md#5-pattern-printing--rule--statement))
2. The inner bound must depend on the outer variable.
3. `c <= 4` → `c <= r`.

</details>

<a name="d12--the-dependency-that-wasnt"></a>
**Fix:** `c <= r`. **Reflect:** a fixed inner bound is a rectangle; a rule that varies per row must appear as `r` in the inner condition.

---

## D13 — The digit loop that won't die

```cpp
// intent: digit sum of n
int digitSum = 0;
while (n > 0) {
    digitSum += n % 10;
}
std::cout << digitSum << '\n';
```

Hangs (or compiles into an infinite loop once `n` is declared and read). Trace a pass.

<details markdown="1"><summary>Hints</summary>

1. What changes `n`?
2. `% 10` *reads* a digit — which operation *removes* it? ([digit processing](lesson-4-nested-digits-patterns.md#3-digit-processing--10-and--10))
3. Missing `n = n / 10;` — cause 1 again, now in digit clothing.

</details>

<a name="d13--the-digit-loop-that-wont-die"></a>
**Fix:** add `n = n / 10;` as the body's last statement. **Reflect:** digit loops need *both* operations every pass — peel (`% 10`) and consume (`/ 10`).

---

## D14 — The backward staircase

```cpp
// intent: sum 1..n
int total = 0;
int i = 0;
while (i <= n) {
    total += i;
    i = i + 1;
}
```

`n = 4` gives 10 — correct. But `n = 0` gives 0 — also correct... and `n = -3` gives 0 with *no passes*. So what's wrong?

<details markdown="1"><summary>Hints</summary>

1. Nothing — for `n >= 0`. Now read the intent again: "sum of 1..n" for a user who enters -3.
2. Is a negative `n` meaningful input, or garbage?
3. Not every bug is inside the loop — this one is the *missing validation guard* ([Decisions](../decisions/lesson-2-conditions.md) meets loops).

</details>

<a name="d14--the-backward-staircase"></a>
**Fix:** validate first: `if (n < 0) { report and stop; }` before the loop. **Reflect:** loops inherit input contracts — garbage in, confidently wrong out, unless a guard precedes the loop.

---

## D15 — The double-count champion

```cpp
// intent: highest of 5 marks
int max = 0;
for (int i = 1; i <= 5; i = i + 1) {
    int m;
    std::cin >> m;
    if (m > max) {
        max = m;
    }
    if (m >= max) {
        max = m;
    }
}
std::cout << max << '\n';
```

It prints the right answer for `40 55 91 60 70`... and also for `0 0 0 0 0`. So is it correct? What is wrong with it, honestly?

<details markdown="1"><summary>Hints</summary>

1. Trace `40`: pass 1 — which `if` fires? Both? Does the outcome differ?
2. The two conditions overlap — the second is (almost) always true when the first is, and also when it isn't (`m == max`).
3. Redundant branches don't create wrong answers here — they create *fragile code* and a hidden assumption (`max = 0` seeding).

</details>

<a name="d15--the-double-count-champion"></a>
**Fix:** one condition `if (m > max)`, and seed with the first value (`if (i == 1) max = m; else if (m > max) ...`) so negatives are handled ([Lesson 2 §2](lesson-2-for.md#2-the-classic-idioms--learn-once-reuse-forever)). **Reflect:** the output looked right; the *code* was wrong twice — redundancy hides assumptions. Tests pass ≠ code is right.

---

## Fix-list recap

| D | Bug family | Gallery link |
| --- | --- | --- |
| D1 | missing update → infinite | E1 |
| D2 | wrong-direction update | E2 |
| D3 | unbraced body | E7 (cousin) |
| D4 | off-by-one bound | E3 |
| D5 | uninitialized accumulator | E4 |
| D6 | accumulator reset/shadowed in loop | E5 |
| D7 | sentinel misuse in nested data | E6 (design) |
| D8 | sentinel collides with data | E6 |
| D9 | semicolon body | E7 |
| D10 | continue eats while-update | E8 |
| D11 | newline in wrong loop | grid pair A |
| D12 | missing inner dependency | pattern rule |
| D13 | digit loop missing `/ 10` | E1 (digit form) |
| D14 | missing input guard | validation |
| D15 | redundant overlapping branches | champion idiom |
