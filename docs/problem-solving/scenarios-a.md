---
title: "Scenarios — Set A: First Steps (1–5)"
description: "Five input→process→output problems. Pure straight-line thinking — no decisions, no loops yet."
---

# Set A — First Steps (Scenarios 1–5)

> ★ difficulty · 5–10 min honest attempt each · [← Module home](index.md)

These five are **pure IPO**: information in, a small chain of computations,
answers out. No decisions, no loops — just the discipline. Every scenario
has the same ten fields; everything from *Thinking questions* onward is
inside the collapsed solution, so do your attempt first (protocol refresher:
[here](index.md#try-it-yourself-before-looking-at-the-solution)).

**Read every scenario as:** *statement → (your turn) → expected I/O →
constraints/assumptions → then open and compare.*

**C++ you'll meet here** (all taught properly in Units 01–03): `int`
variables for whole numbers, `std::cin >>` to read, `std::cout <<` to
print, `*` `+` `-` for arithmetic, `/` and `%` for divide and remainder.

---

## Scenario 1 ★ — The rectangular garden bed

**Problem statement.** A school is building a rectangular vegetable bed.
Given its length and width in metres, the gardener wants to know the
**perimeter** (for the wooden border) and the **area** (for ordering soil).

**Expected input.** Two whole numbers on separate lines: length, width
(metres).

**Expected output.**

```text
Perimeter: 14 m
Area:      12 m^2
```
*(for length 5, width 2 — wait, check this during your attempt!)*

**Constraints & assumptions.** Both values are positive whole numbers
≤ 1000. No validation required — the gardener types carefully.

**Thinking questions** (answer before opening):
1. What are I, P, O here — in one line each?
2. How many output numbers are there? What *unit* does each carry?
3. What arithmetic turns (length, width) into perimeter? Into area?
4. If the gardener measures 5 m by 2 m, what *should* the output be? Write
   both numbers down.

<details markdown="1">
<summary><strong>Open: thinking questions answered, approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. I: length, width. P: two formulas. O: perimeter, area.
2. **Two** outputs. Perimeter is in *metres* (a length); area is in
   *square metres* (an area). Units are part of the output — printing
   "12" for soil-ordering purposes is ambiguous; "12 m²" is an answer.
3. Perimeter = 2 × (length + width). Area = length × width.
4. Perimeter = 2 × (5 + 2) = **14 m**; area = 5 × 2 = **10 m²** — the
   sample output above deliberately said 12 m² to make the point: *verify
   every worked number yourself.* Your paper calculation outranks the page.

**Suggested approach.** Straight-line IPO: read two values, compute two
results, print with units. No pattern beyond sequence.

**Pseudocode.**

```text
READ length
READ width
perimeter ← 2 × (length + width)
area      ← length × width
PRINT "Perimeter: ", perimeter, " m"
PRINT "Area:      ", area, " m^2"
```

**Solution explanation.** Two independent formulas off the same inputs —
the decomposition is three steps wide, each instant. The only design
decisions are the parentheses (perimeter needs them: without, `2 × length
+ width` would be a different, wrong number — precedence) and printing
units with the numbers.

**C++ solution.**

```cpp
// s01_garden.cpp — Set A · Scenario 1
// Compile: g++ -std=c++17 -Wall -Wextra s01_garden.cpp -o s01

#include <iostream>

int main() {
    int length = 0;
    int width  = 0;

    std::cout << "Length (m): ";
    std::cin  >> length;
    std::cout << "Width (m): ";
    std::cin  >> width;

    int perimeter = 2 * (length + width);
    int area      = length * width;

    std::cout << "Perimeter: " << perimeter << " m\n";
    std::cout << "Area:      " << area << " m^2\n";
    return 0;
}
```

**Test cases.**

| Input | Expected output |
| --- | --- |
| 5, 2 | Perimeter 14 m · Area 10 m² |
| 1, 1 | Perimeter 4 m · Area 1 m² |
| 10, 3 | Perimeter 26 m · Area 30 m² |

**Edge cases.** The smallest legal garden: 1 × 1 (perimeter 4, area 1) —
if your formula prints 2 or 0, parentheses or the formula are wrong.
A *square* (7 × 7) is legal and must work like any rectangle. Length 1000,
width 1: perimeter 2002, area 1000 — the largest area at the constraint's
edge. (0 × anything is excluded by the assumptions — see the assumption
discipline in the [lesson §7](lesson.md#47-inputs-processing-outputs-requirements-assumptions-constraints).)

</details>

---

## Scenario 2 ★ — Movie night time

**Problem statement.** A film club stores durations in total minutes. For
the schedule poster they need it human-readable: given a movie's length in
minutes, print **hours** and **leftover minutes** (e.g. 137 minutes is
"2 h 17 min").

**Expected input.** One whole number: total minutes (0 … 600).

**Expected output.**

```text
137 minutes = 2 h 17 min
```

**Constraints & assumptions.** Input is a whole number 0–600. Output uses
"h" and "min" exactly as shown.

**Thinking questions:**
1. Which arithmetic operation "extracts" the hours from 137? Which extracts
   the leftovers?
2. Try it on paper: 137 ÷ 60 = …? and the remainder is …?
3. What should happen for 60 exactly? For 59? For 0?

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. **Division** gives hours (how many whole 60s fit); **remainder** gives
   the leftover minutes. In C++: `/` on whole numbers and `%` (the
   remainder operator).
2. 137 ÷ 60 = 2 remainder 17 → 2 h 17 min. ✓
3. 60 → "1 h 0 min" (remainder 0 is fine). 59 → "0 h 59 min" (0 hours is
   fine — don't "fix" it, the format handles it). 0 → "0 h 0 min" — legal
   at the constraint edge.

**Suggested approach.** The **decompose-a-quantity** pattern: divide by the
unit size for the big piece, remainder for the rest. (This exact pattern
returns as money-change, digit extraction, and h:m:s in Set A #3.)

**Pseudocode.**

```text
READ totalMinutes
hours    ← totalMinutes ÷ 60        (whole-number division)
leftover ← totalMinutes % 60        (remainder)
PRINT totalMinutes, " minutes = ", hours, " h ", leftover, " min"
```

**Solution explanation.** Two computations, both *derived from the same
input* — `/` and `%` are a matched pair: for whole numbers,
`(a ÷ b) × b + a % b` always rebuilds `a`. Check it: 2 × 60 + 17 = 137. ✓
That identity is your built-in correctness check for every divide-and-
remainder problem this course poses.

**C++ solution.**

```cpp
// s02_movie.cpp — Set A · Scenario 2
// Compile: g++ -std=c++17 -Wall -Wextra s02_movie.cpp -o s02

#include <iostream>

int main() {
    int totalMinutes = 0;
    std::cout << "Total minutes: ";
    std::cin  >> totalMinutes;

    int hours    = totalMinutes / 60;   // whole hours
    int leftover = totalMinutes % 60;   // remaining minutes

    std::cout << totalMinutes << " minutes = "
              << hours << " h " << leftover << " min\n";
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 137 | 2 h 17 min |
| 60 | 1 h 0 min |
| 59 | 0 h 59 min |
| 90 | 1 h 30 min |

**Edge cases.** 0 (the minimum — prints 0 h 0 min), 600 (the maximum —
10 h 0 min), 61 and 119 (the "just over" values people get wrong when they
round instead of using remainder: 1 h 1 min, 1 h 59 min).

</details>

---

## Scenario 3 ★ — The long drive

**Problem statement.** A trip tracker records a journey in total seconds.
Print it as **hours, minutes, seconds** — e.g. 7385 seconds is
"2 h 3 m 5 s".

**Expected input.** One whole number: total seconds (0 … 86400).

**Expected output.**

```text
7385 seconds = 2 h 3 m 5 s
```

**Constraints & assumptions.** Whole number 0–86400 (one day is 86400 s).
Hours, minutes, seconds are each printed as plain whole numbers.

**Thinking questions:**
1. Can you reuse Scenario 2's idea? What is the "unit size" now — 60?
   3600? Both?
2. Plan the order: to get hours first, what do you divide by? What is
   left *after* taking out the hours?
3. Dry-run your plan on 7385 *before* opening.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. Yes — this is Scenario 2 applied *twice*, because 1 h = 3600 s and the
   remainder then still contains minutes.
2. hours = total ÷ 3600. The remainder (total % 3600) is the not-yet-full
   hour: minutes = remainder ÷ 60, seconds = remainder % 60.
3. Dry run: 7385 ÷ 3600 = 2 (7200 used), remainder 185; 185 ÷ 60 = 3
   (180 used), remainder 5 → 2 h 3 m 5 s. ✓

**Suggested approach.** **Cascade decomposition**: peel the biggest unit,
then re-process the remainder with the next unit. One variable
(`remaining`) that shrinks is easier to keep honest than three ad-hoc
expressions.

**Pseudocode.**

```text
READ total
hours     ← total ÷ 3600
remaining ← total % 3600
minutes   ← remaining ÷ 60
seconds   ← remaining % 60
PRINT total, " seconds = ", hours, " h ", minutes, " m ", seconds, " s"
```

**Solution explanation.** Four stored values, each one step — no nested
expressions, so the trace table stays trivial and the code reads like the
pseudocode. The identity check again: 2×3600 + 3×60 + 5 = 7385. ✓ Notice
how the *design* (peel biggest unit first) made the code structure
obvious — that's §19-mistake-7 avoidance: the thinking shaped the code,
not vice versa.

**C++ solution.**

```cpp
// s03_drive.cpp — Set A · Scenario 3
// Compile: g++ -std=c++17 -Wall -Wextra s03_drive.cpp -o s03

#include <iostream>

int main() {
    int total = 0;
    std::cout << "Total seconds: ";
    std::cin  >> total;

    int hours     = total / 3600;
    int remaining = total % 3600;
    int minutes   = remaining / 60;
    int seconds   = remaining % 60;

    std::cout << total << " seconds = "
              << hours << " h " << minutes << " m " << seconds << " s\n";
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 7385 | 2 h 3 m 5 s |
| 3600 | 1 h 0 m 0 s |
| 3661 | 1 h 1 m 1 s |
| 60 | 0 h 1 m 0 s |

**Edge cases.** 0 (all zeros), 86400 (exactly one day → 24 h 0 m 0 s),
3599 (one second shy of an hour → 0 h 59 m 59 s — the classic near-
boundary value), 86399 (23 h 59 m 59 s).

</details>

---

## Scenario 4 ★ — The class party budget

**Problem statement.** Your class raises money with a bake sale: **cakes
at 120 rupees**, **cupcakes at 40**, **juice boxes at 25**. Given how many
of each were sold, print each item's earnings and the **grand total**.

**Expected input.** Three whole numbers: cakes, cupcakes, juice boxes.

**Expected output.**

```text
Cakes    x 4 : 480
Cupcakes x 6 : 240
Juice    x 3 :  75
----------------
GRAND TOTAL  : 795
```

**Constraints & assumptions.** Counts are whole numbers ≥ 0. Prices are
fixed constants (they don't change mid-run). Output format should line the
totals column up.

**Thinking questions:**
1. How many named values will your solution keep track of? List them —
   inputs, computed, outputs.
2. Which values are *inputs* and which are *computed*? (Never recompute a
   value you already have.)
3. 4 cakes, 6 cupcakes, 3 juice: what should the output be? Compute it —
   this becomes a test case.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. **Eight**: three inputs (cakes, cupcakes, juice), three computed
   (cakeSales, cupcakeSales, juiceSales), one derived (grandTotal), plus
   the three price constants if you name them (recommended!). Naming
   things on paper first is the cheapest design review there is.
2. Inputs: the three counts. Computed: each item's sales; then the total
   from the *computed* values (not recomputed from scratch — one source of
   truth per value).
3. 4×120 = 480, 6×40 = 240, 3×25 = 75 → total **795**. ✓ (matches the
   sample — this one wasn't lying)

**Suggested approach.** Straight-line with **named constants**: write
`PRICE_CAKES = 120` once, use it in the formula. If the price changes next
month, one line changes. (In C++ this becomes `const int` — Unit 02.)

**Pseudocode.**

```text
PRICE_CAKES    ← 120
PRICE_CUPCAKES ← 40
PRICE_JUICE    ← 25

READ cakes, cupcakes, juice

cakeSales    ← cakes    × PRICE_CAKES
cupcakeSales ← cupcakes × PRICE_CUPCAKES
juiceSales   ← juice    × PRICE_JUICE
grandTotal   ← cakeSales + cupcakeSales + juiceSales

PRINT item lines with sales
PRINT "GRAND TOTAL  : ", grandTotal
```

**Solution explanation.** The lesson's cafeteria example with one more
item and no decision — deliberately, so you notice the *pattern* is the
same: read → per-item computation → sum → print. The design wins here are
naming (each value has one obvious name) and constants (prices live in one
place). Alignment in the output is cosmetic iteration — get the *numbers*
right first, tidy spacing after.

**C++ solution.**

```cpp
// s04_bakesale.cpp — Set A · Scenario 4
// Compile: g++ -std=c++17 -Wall -Wextra s04_bakesale.cpp -o s04

#include <iostream>

int main() {
    const int PRICE_CAKES    = 120;   // named constants: prices in ONE place
    const int PRICE_CUPCAKES = 40;
    const int PRICE_JUICE    = 25;

    int cakes = 0, cupcakes = 0, juice = 0;
    std::cout << "Cakes sold: ";
    std::cin  >> cakes;
    std::cout << "Cupcakes sold: ";
    std::cin  >> cupcakes;
    std::cout << "Juice boxes sold: ";
    std::cin  >> juice;

    int cakeSales    = cakes    * PRICE_CAKES;
    int cupcakeSales = cupcakes * PRICE_CUPCAKES;
    int juiceSales   = juice    * PRICE_JUICE;
    int grandTotal   = cakeSales + cupcakeSales + juiceSales;

    std::cout << "Cakes    x " << cakes    << " : " << cakeSales    << "\n";
    std::cout << "Cupcakes x " << cupcakes << " : " << cupcakeSales << "\n";
    std::cout << "Juice    x " << juice    << " : " << juiceSales   << "\n";
    std::cout << "----------------\n";
    std::cout << "GRAND TOTAL  : " << grandTotal << "\n";
    return 0;
}
```

**Test cases.**

| Input | Expected total |
| --- | --- |
| 4, 6, 3 | 795 |
| 0, 0, 0 | 0 |
| 1, 0, 0 | 120 |

**Edge cases.** All zeros (total 0 — the legal minimum under our
assumptions), single item sold of each kind (120 / 40 / 25 lines), large
counts (999 of each: 119880 + 39960 + 24975 = 184815 — check it by hand,
the point is your program agrees with *your* arithmetic).

</details>

---

## Scenario 5 ★ — Fuel for the trip

**Problem statement.** A van rental includes fuel planning. Given the
**distance** of a trip in km and the **price of petrol per litre**, print:
the **fuel needed** (the van does exactly 15 km per litre — whole litres;
round *up* to the next whole litre) and the **fuel cost**.

**Expected input.** Two whole numbers: distance in km, price per litre in
rupees.

**Expected output.**

```text
Distance      : 320 km
Fuel needed   : 22 litres   (rounded up)
Cost at 275 Rs/l : 6050 Rs
```

**Constraints & assumptions.** Distance 1–2000 km; price 100–500 Rs.
"Rounded up" is a **requirement**: 21.33 litres must be planned as 22 —
you can't buy a third of a litre. Assume the input numbers are valid
(no validation required yet — Set D, Scenario 19 adds it).

**Thinking questions:**
1. Fuel needed = distance ÷ 15 — but *rounded up*. What does plain whole-
   number division give for 320 ÷ 15 (21.33…)? How do you turn "21" into
   the required "22" — without decimals?
2. When does "round up" change nothing? (What must be true of distance for
   the fuel to be exact?)
3. Which values feed which? Does cost depend on fuel — or on distance?

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. Plain `/` gives 21 — the *floor*. A cheap whole-number **ceiling** trick:
   `(distance + 14) / 15` — adding "one less than the divisor" pushes any
   remainder over the line: (320+14)/15 = 334/15 = 22. And when distance
   is an exact multiple, the addition doesn't overflow the division:
   (300+14)/15 = 314/15 = 20 — still 20. ✓
2. Exactly when distance is a multiple of 15 — the trick is idempotent
   there. Verify with 300 and 450 in your tests (see below).
3. Cost = fuelNeeded × pricePerLitre — it depends on the **computed**
   fuel, not directly on distance. Two-stage processing: the output of
   stage 1 is an input to stage 2. Forgetting this dependency is how
   people compute cost from raw distance and get subtly wrong totals.

**Suggested approach.** Straight-line, two stages, with the ceiling trick
written as its own named step (and a comment!) because it *is* the clever
bit — isolating it makes it checkable.

**Pseudocode.**

```text
READ distance, pricePerLitre

fuelNeeded ← (distance + 14) ÷ 15       (whole-number ceiling: round up)
fuelCost   ← fuelNeeded × pricePerLitre

PRINT distance, fuelNeeded, pricePerLitre, fuelCost
```

**Solution explanation.** The one non-obvious line is the ceiling: why
+14? Because 14 = 15 − 1: if there is *any* remainder at all, adding 14
crosses into the next multiple; if there is none, the sum still divides
cleanly one short of doubling. Try the two probe values from the thinking
questions on paper until you believe it — a trick you can't explain is a
bug you haven't met yet. (Alternative honest designs exist: e.g.
`fuelNeeded = distance / 15; if (distance % 15 != 0) fuelNeeded = fuelNeeded + 1;`
— same result, more verbose, zero cleverness. Either is fine; the second
preview's Unit 04's `if`.)

**C++ solution.**

```cpp
// s05_fuel.cpp — Set A · Scenario 5
// Compile: g++ -std=c++17 -Wall -Wextra s05_fuel.cpp -o s05

#include <iostream>

int main() {
    int distance = 0;
    int pricePerLitre = 0;

    std::cout << "Distance (km): ";
    std::cin  >> distance;
    std::cout << "Price per litre (Rs): ";
    std::cin  >> pricePerLitre;

    int fuelNeeded = (distance + 14) / 15;   // round UP to whole litres
    int fuelCost   = fuelNeeded * pricePerLitre;

    std::cout << "Distance      : " << distance << " km\n";
    std::cout << "Fuel needed   : " << fuelNeeded << " litres (rounded up)\n";
    std::cout << "Cost at " << pricePerLitre << " Rs/l : " << fuelCost << " Rs\n";
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 320, 275 | 22 litres · 6050 Rs |
| 300, 275 | 20 litres · 5500 Rs (exact multiple — no extra litre) |
| 15, 100 | 1 litre · 100 Rs |
| 1, 500 | 1 litre · 500 Rs |

**Edge cases.** Distance 1 (minimum → 1 litre — even a tiny trip needs
fuel), distance 15 and 300 (exact multiples: the ceiling must *not* add a
litre), distance 2000 (maximum: 2000 ÷ 15 = 133.33 → ceiling **134**
litres — verify (2000 + 14) ÷ 15 = 134 on paper), distance 16 (the
smallest value that *does* round up: 2 litres).

</details>

---

*[← Module home](index.md) · [Set B — Decisions →](scenarios-b.md)*
