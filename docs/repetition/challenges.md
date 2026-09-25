---
title: "Iteration Challenges"
description: "15 challenge problems on loops — search variants, prime work, digit puzzles, pattern engineering, and algorithm building blocks. Solutions separated at the end."
---

# Iteration Challenges (15)

> [← Module home](index.md) · Open-ended problems ★–★★★. Attempt on paper (IPO + pseudocode + a dry run) before any code — the [Try It Yourself protocol](../problem-solving/index.md) applies. [Solutions](#solutions-c1--c15) are separated at the end and describe *approaches*: your solution may differ and still be right.

## The problems

<a name="c1--perfect-numbers"></a>
**C1 ★ — Perfect numbers.** A perfect number equals the sum of its proper divisors (`6 = 1+2+3`). Find all perfect numbers up to 10 000 using only the unit's toolkit.

<a name="c2--amazing-numbers"></a>
**C2 ★ — Armstrong numbers.** Print all 3-digit Armstrong numbers (each digit's cube sums to the number: `153 = 1+125+27`). Combine digit processing with an accumulator.

<a name="c3--first-match-variants"></a>
**C3 ★ — First-match variants.** Read n values until sentinel −1. Print (a) the first over 100, (b) the count of values over 100, (c) whether *any* was over 100. One loop, three idioms — which of the three can stop early, and why can't the other two?

<a name="c4--the-collatz-journey"></a>
**C4 ★★ — The Collatz journey.** Read n ≥ 1. Repeat: if even, halve it; if odd, 3n+1 — until you reach 1. Print the journey and its length. (Known mathematics: this always terminates for small n; for your dry runs, start at 6.)

<a name="c5--gcd-by-subtraction"></a>
**C5 ★★ — GCD two ways.** Read a, b ≥ 1; compute gcd(a,b) by (a) Euclid's modulo method, (b) trial division from min(a,b) downward. Trace both for 48, 18. Which terminates sooner, and why?

<a name="c6--prime-gaps"></a>
**C6 ★★ — Prime gaps.** Print every prime pair (p, q) with q the next prime after p and q − p = 2 (twin primes) below 100. You'll need your prime test from [Lesson 4 §4](lesson-4-nested-digits-patterns.md#4-primes--the-divisor-count-method) *and* a way to remember the previous prime.

<a name="c7--the-four-digit-sorter"></a>
**C7 ★★ — The four-digit sorter.** Read a 4-digit number; print its digits in ascending order (`4729 → 2 4 7 9`). No arrays (that's the [arrays module](../arrays/index.md)) — digit peeling plus a decision ladder, or ten nested pass-limiters. *Honest note: without arrays this is brute-force; the point is feeling why arrays exist.*

<a name="c8--digit-power-tower"></a>
**C8 ★★ — Digit power tower.** Read n; print the sum of each digit raised to the power of its position (rightmost = position 1): `4729 → 9¹ + 2² + 7³ + 4⁴ = 9+4+343+256 = 612`. Position tracking inside the digit loop is the new wrinkle.

<a name="c9--the-binary-builder"></a>
**C9 ★★ — The binary builder.** Read n ≥ 0 and print its binary representation *without* arrays or strings: peel bits `n % 2`, then rebuild the *reversed* binary digits the same way [S26](exercises.md#s26--reverse-palindrome) rebuilds decimal. (Trace 13 → 1101.) Then handle n = 0 explicitly and say why.

<a name="c10--the-run-detector"></a>
**C10 ★★ — The run detector.** Read integers until sentinel −1 and report the longest run of equal consecutive values (`5 5 5 2 2 9 -1 → 3`). You need a *current-run* counter AND a *best-run* champion — two counters with different lifetimes.

<a name="c11--the-menu-calculator"></a>
**C11 ★★ — The menu calculator.** Do-while menu: 1 add, 2 subtract, 3 multiply, 4 divide (guard 0), 0 quit. After each op, ask continue/quit. Compose [Lesson 3 §5](lesson-3-break-continue-sentinels.md#5-menu-driven-programs--the-stage-b-showcase) + validation gallery. Extension: count operations performed and print it at quit.

<a name="c12--hollow-rectangle"></a>
**C12 ★★ — Hollow rectangle.** Print an h×w rectangle of `*` with only the border: `*` when r is 1 or h, or c is 1 or w; spaces elsewhere. The 2D condition is the whole puzzle.

<a name="c13--pyramid"></a>
**C13 ★★★ — The pyramid.** Print a centred pyramid of height h: row r has `h−r` leading spaces, then `2r−1` stars. Derive both formulas from rows 1–3 on paper, then translate.

<a name="c14--pascals-row"></a>
**C14 ★★★ — Pascal's row.** Print row n of Pascal's triangle using only `long long` and loops: entries `C(n,k) = C(n,k-1) × (n-k+1) / k` — a *running update*, no arrays, no factorials. Trace n = 5: 1 5 10 10 5 1. (Why must the multiply come *before* the divide?)

<a name="c15--the-state-machine"></a>
**C15 ★★★ — The state machine.** Read chars until `.`: count words, sentences (`.` `!` `?`), and track whether currently inside a word. A boolean *state* (`inWord`) that flips on transitions — the run-detector [C10](#c10--the-run-detector) grown a third counter.

<a name="solutions-c1--c15"></a>
## Solutions (C1–C15)

> These describe one sound approach each, with the reasoning. Compare ideas first.

<a name="s-c1--perfect-numbers"></a>
### C1 — Perfect numbers

Two nested loops: outer n = 2..10000; inner d = 1..n−1 summing proper divisors; compare sum to n. Plain trial division — slow but honest; 6, 28, 496, 8128 found. The real lesson: **a property-check loop becomes a search loop by wrapping it**.

### C2 — Armstrong numbers

For n in 100..999: peel digits (sum of `d*d*d` via while-loop digit peeling); compare to n. `153, 370, 371, 403`. Same shape as C1: property test wrapped in a search range. Watch: the digit loop *consumes* n — copy it first.

### C3 — First-match variants

(a) `break` on first hit (only one that can stop early — its answer is fully determined by one element). (b) must see every value — a count is global. (c) can stop early on the first `true` (set a flag, break) — "any" is a first-match question in disguise; "count" is not. **The idiom's stopping power follows from the question's scope.**

### C4 — Collatz

```cpp
int steps = 0;
while (n != 1) {
    if (n % 2 == 0) n = n / 2;
    else            n = 3 * n + 1;
    steps += 1;
    std::cout << n << ' ';
}
```
6 → 3 → 10 → 5 → 16 → 8 → 4 → 2 → 1 (9 steps... count printed values: 8 transitions; state your counting convention). Input-controlled loop: the *value* decides. Also a rare loop whose correctness ("always terminates") is a famous open problem — for your test values, dry-run first.

### C5 — GCD two ways

(a) Euclid: `while (b != 0) { int r = a % b; a = b; b = r; }` → gcd in a. (b) `for (d = min(a,b); d >= 1; d--) if (a % d == 0 && b % d == 0) break;` — hits 6 for (48,18) after 12 checks; Euclid: 2. Euclid wins because each step *shrinks the problem*, trial division only *scans* it. First algorithmic-efficiency lesson.

### C6 — Prime gaps

Track `prevPrime = 0`. Loop candidates; when prime found: `if (prevPrime != 0 && p - prevPrime == 2) print pair;` then `prevPrime = p;`. Two-state scan: current + memory. Pairs below 100: (3,5), (5,7), (11,13), (17,19), (29,31), (41,43), (59,61), (71,73).

### C7 — Digit sorter

Peel the 4 digits into four variables via `% 10`/`/ 10`, then a champion-style min-selection ladder four times: find min of the four, print, "remove" it by a flag/second-variable dance. Brute-force, and it *feels* wrong — that's the intended outcome; the [arrays module](../arrays/index.md)'s sorting turn this into five lines. (A hint you're fighting the language: your ladder duplicates per digit.)

### C8 — Digit power tower

```cpp
long long total = 0;
int pos = 0;
while (n > 0) {
    int d = n % 10;
    pos += 1;
    long long p = 1;
    for (int k = 1; k <= pos; k = k + 1) p *= d;
    total += p;
    n = n / 10;
}
```
A digit loop containing a power loop — nesting by composition. `long long` because 4⁴-scale products... are fine in int here, but 9⁹ in extensions isn't: name the overflow risk.

### C9 — Binary builder

Two sound no-array approaches; try (a) first, then see why (b) is the one that survives all inputs.

**(a) Peel-and-rebuild (the reverse idiom in base 2):** peel `n % 2` into `rev = rev * 10 + bit`, consuming `n = n / 2`. For 13: bits 1, 0, 1, 1 build rev = 1011 — which is 1101 *reversed*. Running the same peel/build on rev turns it back: 1011 → 1101. **But trace n = 4**: bits 0, 0, 1 build rev = 0 → 0 → 1, and the second pass prints `1`, not `100` — the leading zeros died in the rebuild. The double-reverse fails exactly when the binary form ends in 0.

**(b) Power-of-two descent (correct for every n):**

```cpp
int p = 1;
while (p * 2 <= n) p = p * 2;      // highest power of 2 that fits in n
while (p > 0) {
    std::cout << n / p;            // that bit: 1 or 0
    n = n % p;                     // remove its contribution
    p = p / 2;                     // next smaller place value
}
```

Trace 13: p = 8 → prints 1 (n 5) → p 4 → 1 (n 1) → p 2 → 0 → p 1 → 1 → `1101`. Trace 4: p = 4 → `100`. ✓ The descent prints place values from the top, so no zero can be lost. n = 0 handled explicitly (print `0` — both loops would otherwise print nothing). **The honest outcome:** approach (b) works, but compare its effort with storing peeled digits in a list — that's the [arrays module](../arrays/index.md)'s job, and C9 has now made you feel why it exists.

### C10 — Run detector

```cpp
int prev, cur;
int run = 1, best = 1;

std::cin >> prev;                    // prime read: the first value starts run 1
if (prev == -1) {
    run = 0; best = 0;               // empty stream: no runs at all
}
while (run > 0) {                    // sentinel pattern from Lesson 3
    std::cin >> cur;
    if (cur == -1) break;
    if (cur == prev) run += 1;
    else             run = 1;
    if (run > best) best = run;
    prev = cur;
}
std::cout << "Longest run: " << best << '\n';
```
`run` = current streak (resets on change); `best` = champion over streaks (never resets). **Two counters, two lifetimes** — the unit's central idea at full power. (Edge case traced in the code: an empty stream must report 0, not 1 — the first value *is* a run of one only if it exists.)

### C11 — Menu calculator

do-while menu ([Lesson 3 §5](lesson-3-break-continue-sentinels.md#5-menu-driven-programs--the-stage-b-showcase)); division branch guards `b == 0` with re-prompt (validation gallery B). Operations counter incremented in each case (or once after the switch when choice is 1–4). Extension prints the counter at quit.

### C12 — Hollow rectangle

```cpp
for (int r = 1; r <= h; r = r + 1) {
    for (int c = 1; c <= w; c = c + 1) {
        if (r == 1 || r == h || c == 1 || c == w) std::cout << "* ";
        else                                      std::cout << "  ";
        }
    std::cout << '\n';
}
```
The 2D condition: *border = any coordinate at an extreme*. Border/or-space is one four-way OR — [Decisions](../decisions/lesson-2-conditions.md) inside a grid.

### C13 — Pyramid

Rows 1–3 (h=4): row1 = 3 spaces + 1 star; row2 = 2 + 3; row3 = 1 + 5. Formulas: spaces = `h − r`, stars = `2r − 1`. Two inner loops per row (spaces then stars), newline after. Derive-then-translate is the method — formulas from data, never guessed.

### C14 — Pascal's row

```cpp
long long c = 1;
for (int k = 0; k <= n; k = k + 1) {
    std::cout << c << ' ';
    c = c * (n - k) / (k + 1);
}
```
Multiply first: `c × (n−k)` is always divisible by (k+1) at that point (it's C(n,k+1)×(k+1)); dividing first would truncate. Trace n=5: 1, 5, 10, 10, 5, 1. Integer-exact running update — a division that always divides evenly *by design*.

### C15 — State machine

The one I/O detail this challenge borrows: `cin.get(ch)` reads *every* character, spaces included (`cin >> ch` would skip the very whitespace that defines words).

```cpp
int words = 0, sentences = 0;
bool inWord = false;
char ch;
while (std::cin.get(ch) && ch != '.') {
    if (ch == ' ' || ch == '\n' || ch == '\t') {
        if (inWord) { words += 1; inWord = false; }   // transition: word ended
    } else {
        inWord = true;                                 // letter seen: inside a word
    }
}
if (inWord) words += 1;    // the '.' closed the final word
sentences = 1;             // (extension: also count '!' and '?' as sentence ends)
std::cout << "Words: " << words << ", sentences: " << sentences << '\n';
```

Trace `hi there.`: h,i → inWord true; space → word closed (words 1); t..e → inWord true; `.` → loop exits, final word closed (words 2). The state flips only at transitions, and counters update **on transitions**, not per character. Sentinel + state + counters — the unit's ideas in one program; also [mini-project](miniproject.md) scale.
