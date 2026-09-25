---
title: "Scenarios — Set B: Decisions (6–10)"
description: "Five problems that branch: thresholds, categories, multiple conditions, boundaries."
---

# Set B — Decisions (Scenarios 6–10)

> ★–★★ difficulty · ~10 min honest attempt each · [← Module home](index.md) ·
> [← Set A](scenarios-a.md)

These five add the **selection** pattern ([lesson §13](lesson.md#13-decision-making)):
conditions, then/else branches — and, above all, **boundaries**. For every
scenario, one of your thinking questions is always the same: *what value
sits exactly on the boundary, and which side is it on?* Decide that on
paper, dry-run it ([§15–16](lesson.md#1516-dry-runs-and-trace-tables)), and
write the boundary test before reading on.

**New C++ in this set** (formally Unit 04; explained inline): `if (condition) { … } else { … }`,
comparison operators `>` `>=` `<` `<=` `==` (equals) `!=` (not equals), and
the logical **and/or/not** — `&&` `||` `!` — for combining conditions.

---

## Scenario 6 ★ — Free delivery?

**Problem statement.** An online bookstore delivers free for orders of
**2500 rupees or more**; otherwise delivery costs **150 rupees**. Given the
order value, print the delivery charge and the grand total.

**Expected input.** One whole number: order value in rupees (1 … 100000).

**Expected output.**

```text
Order: 3000 Rs
Delivery: FREE
Grand total: 3000 Rs
```
*(for an order of 3000 — for 2000 the delivery line reads "Delivery: 150 Rs"
and the total changes accordingly)*

**Constraints & assumptions.** Order value is a positive whole number.
"2500 or more" is the requirement — note the *or more*.

**Thinking questions:**
1. State the condition as a yes/no question. Which comparison operator
   matches "2500 or more" — `>` or `>=`?
2. What happens **exactly at 2500**? Compute both totals (with and without
   the charge) to see how different they are.
3. List your four test cases *before* coding — including the boundary.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. "Is the order at least 2500?" → `orderValue >= 2500`. The requirement's
   words *or more* are the spec: `>` alone would wrongly charge a 2500
   order. This is lesson §19's boundary mistake in miniature — the fix
   costs nothing now.
2. At 2500: delivery free, total 2500. Just below (2499): delivery 150,
   total 2649 — a 2499-rupee order *costs more* than a 2500 order! That
   perversity is the shop's choice, not your bug — but it shows why the
   boundary deserves its own test: the two sides of it are very different
   worlds.
3. See the test table below — boundary, one below, ordinary cases.

**Suggested approach.** Straight-line IPO plus **one** decision. Compute
the total *after* deciding delivery, so only one addition formula exists.

**Pseudocode.**

```text
READ orderValue
IF orderValue >= 2500 THEN
    delivery ← 0
    deliveryText ← "FREE"
ELSE
    delivery ← 150
    deliveryText ← delivery + " Rs"
ENDIF
total ← orderValue + delivery
PRINT orderValue, deliveryText, total
```

**Solution explanation.** The decision sets *both* the numeric delivery
and the display text, keeping the two consistent — a tiny design point
with a big lesson: derive related outputs together, so they can never
disagree. The total is computed once, after the branch, because it's the
*same formula* either way (`orderValue + delivery` — delivery just
carries 0 or 150). One formula, no duplication, no possibility of the two
branches drifting apart.

**C++ solution.**

```cpp
// s06_delivery.cpp — Set B · Scenario 6
// Compile: g++ -std=c++17 -Wall -Wextra s06_delivery.cpp -o s06

#include <iostream>

int main() {
    int orderValue = 0;
    std::cout << "Order value (Rs): ";
    std::cin  >> orderValue;

    int delivery = 0;
    if (orderValue >= 2500) {
        delivery = 0;
    } else {
        delivery = 150;
    }

    int total = orderValue + delivery;

    std::cout << "Order: " << orderValue << " Rs\n";
    std::cout << "Delivery: ";
    if (delivery == 0) {
        std::cout << "FREE\n";
    } else {
        std::cout << delivery << " Rs\n";
    }
    std::cout << "Grand total: " << total << " Rs\n";
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 3000 | Delivery FREE · total 3000 |
| 2500 | Delivery FREE · total 2500 ← **boundary** |
| 2499 | Delivery 150 · total 2649 ← **one below** |
| 1 | Delivery 150 · total 151 |

**Edge cases.** 2500 and 2499 (the boundary pair — both must be tested,
*by name*, every time), 1 (minimum legal), 100000 (maximum — free
delivery, no overflow drama at this size). A future refinement (Set D)
asks: what if delivery were 150 *or* 5% of the order, whichever is
smaller? Park it — but notice how "think about the boundary" scales up.

</details>

---

## Scenario 7 ★ — Pass or fail, with distinction

**Problem statement.** An exam is graded from a percentage: **below 50**
fails, **50–69** passes, **70 or above** passes with distinction. Given the
marks percentage, print exactly one verdict line.

**Expected input.** One whole number: percentage (0 … 100).

**Expected output.**

```text
Result: PASS WITH DISTINCTION
```
*(for 70; the other verdicts: "FAIL", "PASS")*

**Constraints & assumptions.** Percentage is a whole number 0–100.
Boundaries belong to the **higher** band (50 is a pass, 70 is a
distinction) — this is the requirement.

**Thinking questions:**
1. There are three bands but C++ `if/else` is two-way. Two classic shapes:
   (a) chain `if … else if … else`, (b) nested ifs. Draft shape (a) on
   paper — which condition goes **first**?
2. Check every boundary: 49/50 and 69/70. Which side does each land on,
   per the requirement?
3. What does your chain say for 100? For 0? Are both inside the
   requirement's range?

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. Check from the **top down**: `>= 70` first (distinction), `else if
   >= 50` (pass), `else` (fail). Top-down ordering works because each
   branch only receives what the previous rejected — by the time you ask
   "≥ 50?", you already know it's < 70. Bottom-up with `<=` works too, but
   mixing directions is how bands get skipped or doubled — pick one
   direction per chain.
2. 49 → fail; 50 → pass; 69 → pass; 70 → distinction. With `>=` at each
   band edge, all four land exactly as the requirement says. (If your
   draft used `> 70` for distinction, 70 itself falls through to "pass" —
   the classic off-by-one at the boundary.)
3. 100 → distinction ✓; 0 → fail ✓. Both inside the requirement; no
   special handling needed — the chain's final `else` is the safety net.

**Suggested approach.** An **else-if ladder** checked top-down — the
standard shape for multi-band classification (grades, tariffs, tax
brackets all use it later in the course).

**Pseudocode.**

```text
READ percent
IF percent >= 70 THEN
    verdict ← "PASS WITH DISTINCTION"
ELSE IF percent >= 50 THEN
    verdict ← "PASS"
ELSE
    verdict ← "FAIL"
ENDIF
PRINT "Result: ", verdict
```

**Solution explanation.** Compute the verdict *first*, print once at the
end — rather than printing inside each branch. One print statement means
the format can never diverge between branches; the branches only choose
the *content*. This "decide, then act once" shape scales beautifully: with
ten bands you'd still have exactly one print.

**C++ solution.**

```cpp
// s07_exam.cpp — Set B · Scenario 7
// Compile: g++ -std=c++17 -Wall -Wextra s07_exam.cpp -o s07

#include <iostream>

int main() {
    int percent = 0;
    std::cout << "Percentage: ";
    std::cin  >> percent;

    if (percent >= 70) {
        std::cout << "Result: PASS WITH DISTINCTION\n";
    } else if (percent >= 50) {
        std::cout << "Result: PASS\n";
    } else {
        std::cout << "Result: FAIL\n";
    }
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 82 | PASS WITH DISTINCTION |
| 70 | PASS WITH DISTINCTION ← boundary |
| 69 | PASS ← one below |
| 50 | PASS ← boundary |
| 49 | FAIL ← one below |
| 0 | FAIL |

**Edge cases.** The two boundary pairs (49/50, 69/70) — if you test
nothing else, test these; 0 and 100 (the legal extremes). **Out of
range** (−5, 105): by our assumptions, undefined — but *notice* that this
program happily prints FAIL for −5 and DISTINCTION for 105. Defining what
should happen there is exactly what Set D, Scenario 19 adds as validation.

</details>

---

## Scenario 8 ★★ — Which cinema ticket?

**Problem statement.** A cinema prices tickets by age: **children
(under 12)** pay 300, **teens (12–17)** pay 450, **adults (18–59)** pay
600, **seniors (60+)** pay 400. Given the customer's age, print the
category name and the price.

**Expected input.** One whole number: age in years (1 … 120).

**Expected output.**

```text
Category: TEEN
Price: 450 Rs
```

**Constraints & assumptions.** Age is a whole number 1–120. Band edges
belong to the band that *names* the age: a 12-year-old is a TEEN (the
"under 12" band excludes 12); a 60-year-old is a SENIOR; an 18-year-old is
an ADULT.

**Thinking questions:**
1. This is Scenario 7's ladder with **four** bands and non-uniform widths.
   Write the band table: for each category, its exact inclusive range.
2. Which boundaries must be tested? List *all* the pairs (just below / at
   each edge).
3. The bands are given as ranges (under 12; 12–17; 18–59; 60+) — how do
   you make sure your code's conditions can't accidentally overlap or
   leave a gap?

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. CHILD 1–11 · TEEN 12–17 · ADULT 18–59 · SENIOR 60–120. Writing the
   *ranges* (not the sentences) is the step that prevents overlap/gap bugs
   — sentences hide edges, ranges expose them.
2. The pairs: 11/12 (CHILD→TEEN), 17/18 (TEEN→ADULT), 59/60
   (ADULT→SENIOR). Three edges, six tests. Plus 1 and 120 for the legal
   extremes.
3. Top-down ladder (like Scenario 7): `age < 12` → CHILD; else `age < 18`
   → TEEN; else `age < 60` → ADULT; else SENIOR. Each branch inherits a
   *lower bound* from the previous rejection, so only the **upper** bound
   is needed per branch — no gaps or overlaps are possible by
   construction. (The explicit-range shape `age >= 12 && age <= 17` also
   works and is more "self-documenting" at the cost of more conditions —
   Set B's Scenario 9 uses exactly that style when branches can't be
   ordered so neatly.)

**Suggested approach.** Else-if ladder, top-down, one condition per branch
exploiting inheritance; compute category+price, print once.

**Pseudocode.**

```text
READ age
IF age < 12 THEN
    category ← "CHILD";   price ← 300
ELSE IF age < 18 THEN
    category ← "TEEN";    price ← 450
ELSE IF age < 60 THEN
    category ← "ADULT";   price ← 600
ELSE
    category ← "SENIOR";  price ← 400
ENDIF
PRINT "Category: ", category
PRINT "Price: ", price, " Rs"
```

**Solution explanation.** Same skeleton as Scenario 7 — proof the
*classification* pattern transfers unchanged from 3 bands to 4, uniform or
not. The one new thinking move is *deriving* the ladder conditions from a
range table (step 1), so the code inherits the table's guarantee: every
age lands in exactly one band. Trace-check the three boundary pairs by
hand (11→300, 12→450, 17→450, 18→600, 59→600, 60→400) before trusting it.

**C++ solution.**

```cpp
// s08_cinema.cpp — Set B · Scenario 8
// Compile: g++ -std=c++17 -Wall -Wextra s08_cinema.cpp -o s08

#include <iostream>

int main() {
    int age = 0;
    std::cout << "Age: ";
    std::cin  >> age;

    if (age < 12) {
        std::cout << "Category: CHILD\n";
        std::cout << "Price: 300 Rs\n";
    } else if (age < 18) {
        std::cout << "Category: TEEN\n";
        std::cout << "Price: 450 Rs\n";
    } else if (age < 60) {
        std::cout << "Category: ADULT\n";
        std::cout << "Price: 600 Rs\n";
    } else {
        std::cout << "Category: SENIOR\n";
        std::cout << "Price: 400 Rs\n";
    }
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 5 | CHILD · 300 |
| 11 / 12 | CHILD / TEEN ← pair |
| 17 / 18 | TEEN / ADULT ← pair |
| 59 / 60 | ADULT / SENIOR ← pair |
| 90 | SENIOR · 400 |

**Edge cases.** The three boundary pairs above; 1 and 120 (legal
extremes); and the *assumption* edge: age 0 is excluded by the constraints
(a 0-year-old isn't a ticket-buyer) — document, don't defend.

</details>

---

## Scenario 9 ★★ — Can we play the match?

**Problem statement.** The college ground can host a match only if **the
temperature is between 15 and 35 degrees** (inclusive) **and it is not
raining**. The groundskeeper answers two yes/no questions: temperature OK?
 raining? Given the two answers (typed as `y` or `n`), print "MATCH ON" or
"MATCH OFF" — and, when off, *why* (too hot, too cold, or raining).

**Expected input.** Two characters, each `y` or `n`: first "is temperature
in range?", then "is it raining?".

**Expected output.**

```text
Temp OK (y/n): y
Raining (y/n): n
MATCH ON
```

*(when the match is off, the output must say **why** — but see Thinking
question 3 before deciding what "why" can honestly say)*

**Constraints & assumptions.** Inputs are exactly `y` or `n` (lowercase).
The *combined* rule: match on ⇔ temp-OK **and** not raining.

**Thinking questions:**
1. Write the ON condition as one combined expression using **and**. Write
   OFF as the negation — how many distinct OFF reasons are there really?
2. The four possible input combinations: which output does each produce?
   Make the 2×2 table first.
3. A first draft of this problem says: when off because of temperature,
   print whether it was "too hot" or "too cold". **Read the problem
   statement again** — can this program actually know that? What does
   this teach about checking outputs against inputs? (This is lesson
   §19, mistake 2 — solving the wrong problem — caught at design time.)

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. ON: `tempOk && !raining`. OFF is its negation: `!tempOk || raining` —
   **or**! Negations flip and↔or (De Morgan's laws; Unit 04 names them).
   Distinct OFF reasons: three user-visible (temp-not-ok, raining, both)
   but only *two* explanation categories we can honestly report —
   temperature and rain.
2. The 2×2: (y, n) → ON · (y, y) → OFF/RAIN · (n, n) → OFF/TEMP ·
   (n, y) → OFF/TEMP+RAIN — the honest message can mention both
   conditions. All four rows must be tests.
3. The naive design promised "TOO HOT/TOO COLD" — impossible from the
   given inputs. Catching that **on paper** is free; catching it after
   coding means rework. This scenario is the module's small lesson in
   reading requirements *before* designing outputs.

**Suggested approach.** One combined **and** condition for ON; if OFF,
report temperature and/or rain honestly, using two independent checks.

**Pseudocode.**

```text
READ tempAnswer, rainAnswer
tempOk  ← (tempAnswer = "y")
raining ← (rainAnswer = "y")

IF tempOk AND NOT raining THEN
    PRINT "MATCH ON"
ELSE
    IF NOT tempOk THEN PRINT "TEMPERATURE — outside 15–35"
    IF raining THEN PRINT "RAIN"
ENDIF
```

**Solution explanation.** Two design points worth stealing. First, the
condition is written from the *requirement's* sentence ("between 15 and 35
and not raining") almost word for word — code that mirrors the requirement
is checkable against it. Second, the OFF branch uses two *separate* ifs,
not one else-if chain, because the reasons are **independent**: both can
be true at once. else-if would silently hide one. Choosing between "chain"
and "independent ifs" *is* the design decision here — decided from the
meaning of the inputs, not from typing convenience.

**C++ solution.**

```cpp
// s09_match.cpp — Set B · Scenario 9
// Compile: g++ -std=c++17 -Wall -Wextra s09_match.cpp -o s09

#include <iostream>

int main() {
    char tempAnswer = ' ';
    char rainAnswer = ' ';

    std::cout << "Temp OK (y/n): ";
    std::cin  >> tempAnswer;
    std::cout << "Raining (y/n): ";
    std::cin  >> rainAnswer;

    bool tempOk  = (tempAnswer == 'y');
    bool raining = (rainAnswer == 'y');

    if (tempOk && !raining) {
        std::cout << "MATCH ON\n";
    } else {
        if (!tempOk) {
            std::cout << "TEMPERATURE — outside 15-35\n";
        }
        if (raining) {
            std::cout << "RAIN\n";
        }
    }
    return 0;
}
```

**Test cases.** (the 2×2 — all four, plus nothing else exists)

| tempOk | raining | Expected |
| --- | --- | --- |
| y | n | MATCH ON |
| y | y | RAIN |
| n | n | TEMPERATURE — outside 15-35 |
| n | y | TEMPERATURE + RAIN (both lines) |

**Edge cases.** The 2×2 *is* the edge set for this input design — four
combinations, all tested. (If the input had been the *temperature number*
and a rain flag, the edges would instead be 14/15 and 35/36 — the
boundary discipline from Scenarios 6–8 transfers unchanged.)

</details>

---

## Scenario 10 ★★ — The smallest of three

**Problem statement.** A warehouse scanner reads three shelf counts and
must flag the **smallest** for restocking (ties: any one of the smallest
is fine). Given three whole numbers, print the smallest.

**Expected input.** Three whole numbers, one per line (each 0 … 10000).

**Expected output.**

```text
Smallest: 7
```

**Constraints & assumptions.** Counts are whole numbers ≥ 0. Ties are
legal and must produce *a* smallest value (printing it once, obviously).

**Thinking questions:**
1. How would you find the smallest of three *without a computer* — in as
   few comparisons as possible? Say the strategy in words first.
2. Draft the condition for "a is smallest": what must be true about `a`
   relative to *both* others? (This needs **and**.)
3. How many orderings does your test set need to be confident? Consider
   a<b<c, and each of the other five arrangements of {3, 7, 9} — plus
   ties.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. "Keep a champion: look at a, then b — whichever is smaller becomes the
   champion — then c." The **running minimum** pattern (an accumulator of
   comparisons). Two comparisons, not three-choose-two chaos.
2. `a <= b && a <= c`. Note `<=` not `<`: with a tie (a = b), the
   requirement says any smallest is fine, but `<` with equal values would
   fall through every branch and print nothing — a *gap*. `<=` closes it.
3. The six arrangements of three distinct values, plus at least two tie
   shapes (two equal, all three equal). You'll find the ladder below
   handles all of them — but *you* verify that, on paper, before opening.

**Suggested approach.** Either (a) the ladder: `if (a <= b && a <= c) …
else if (b <= a && b <= c) … else …`, or (b) the champion: start with
`smallest = a`, then two `if` updates. Both are taught; (b) is the shape
that scales to ten values (Set C uses accumulators heavily), (a) is the
direct translation of the definition. Dry-run both on {9, 3, 7}.

**Pseudocode (champion form).**

```text
READ a, b, c
smallest ← a
IF b < smallest THEN smallest ← b
IF c < smallest THEN smallest ← c
PRINT "Smallest: ", smallest
```

**Solution explanation.** The champion form is two *independent* ifs —
not a chain — because each new value challenges the current champion once;
else-if would wrongly skip the second challenge whenever the first fired.
Dry-run {9, 3, 7}: champion 9 → 3 challenges (3 < 9: champion 3) →
7 challenges (7 < 3? no) → prints 3. ✓ And {3, 9, 3}: champion 3 →
9? no → 3 < 3? no (strict `<`) → prints 3. ✓ Ties work because the
champion already holds a smallest value and equals are no-ops.

**C++ solution.**

```cpp
// s10_smallest.cpp — Set B · Scenario 10
// Compile: g++ -std=c++17 -Wall -Wextra s10_smallest.cpp -o s10

#include <iostream>

int main() {
    int a = 0, b = 0, c = 0;
    std::cout << "Three counts: ";
    std::cin  >> a >> b >> c;

    int smallest = a;          // the champion
    if (b < smallest) {
        smallest = b;          // b challenges and wins
    }
    if (c < smallest) {
        smallest = c;          // c challenges the current champion
    }

    std::cout << "Smallest: " << smallest << "\n";
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 9, 3, 7 | 3 |
| 3, 7, 9 | 3 |
| 7, 9, 3 | 3 |
| 9, 7, 3 | 3 |
| 3, 9, 7 | 3 |
| 7, 3, 9 | 3 |
| 5, 5, 2 | 2 |
| 4, 4, 4 | 4 (all tie) |
| 0, 9, 7 | 0 |

**Edge cases.** All-equal (4,4,4 — every branch a no-op), two-equal-with-
smallest (5,5,2 — and its permutations), smallest first (champion never
updates), smallest last (both updates fire), 0 as the legal minimum.

</details>

---

*[← Set A](scenarios-a.md) · [Module home](index.md) ·
[Set C — Repetition →](scenarios-c.md)*
