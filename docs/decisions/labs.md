---
title: "Labs — Decision Making"
description: "8 realistic decision scenarios: grading, electricity billing, cinema pricing, bank validation, sports-day categories, admission eligibility, shipping costs, restaurant billing."
---

# Labs — Decision Making

> [← Module home](index.md) · [Lesson 4 — the pipeline these labs demand](lesson-4-requirements-to-decisions.md)

**Try first — always.** Every lab below hides its solution in a collapsed block, and every task list starts with steps you do *before* coding. A lab where you read the solution first is a lab you did not do. Write your decision table, write your code, dry-run the test table — *then* compare.

**Conventions for every lab**

- One `.cpp` per lab: `lab-decisions-1.cpp` … `lab-decisions-8.cpp`, in your `labs/` folder ([project layout](../getting-started/getting-started-lesson.md#18-recommended-project-directory-structure)).
- Compile: `g++ -std=c++17 -Wall -Wextra lab-decisions-N.cpp -o labN`
- Submit with: decision table **or** ladder sketch, and a dry run of the *full* test table ([Lesson 4 §9](lesson-4-requirements-to-decisions.md#9-the-pre-submission-boundary-audit)).
- Every output table below has **edge rows on purpose** — values like 39/40 and 100/101 are the real exam of your conditions.

---

## Lab 1 — Grading system

**Scenario.** The examination cell processes marks sheets one student at a time. Marks arrive as a whole number; invalid sheets must be rejected *before* grading, and every valid sheet gets exactly one grade.

**Requirements.**

1. Read marks as an `int`.
2. Marks outside 0–100 → print `Invalid marks: ` and the value, exit with status 1. No grade, ever.
3. Grades: **A** ≥ 80 · **B** 70–79 · **C** 60–69 · **D** 40–59 · **F** below 40.
4. Print exactly one grade letter.

**Inputs / outputs.** Input: one `int`. Output: one line — `Invalid marks: N` *or* the grade letter.

**Test cases (dry-run all of them).**

| marks | expected output |
| --- | --- |
| −1 | `Invalid marks: -1` |
| 0 | `F` |
| 39 | `F` |
| **40** | `D` (edge owns: D) |
| 59 | `D` |
| 60 | `C` |
| 69 | `C` |
| 70 | `B` |
| 79 | `B` |
| 80 | `A` |
| 100 | `A` |
| 101 | `Invalid marks: 101` |

**Student tasks.** ① Write the condition for "invalid" from requirement 2 (one compound condition — which shape?). ② Sketch the ladder — most-demanding first. ③ Code it. ④ Dry-run the table. ⑤ Prove each edge (40, 60, 70, 80) lands in exactly one band.

**Extensions.** ⭐ Print `A+` for marks ≥ 95 without breaking any other band (which band owns 95 now?). ⭐⭐ Read a second student's marks and print which of the two graded higher (a compound comparison — `>` on the marks). ⭐⭐⭐ Add a "best of three" rule: read three subjects' marks and grade on the *average* — validation must apply to all three before the ladder runs.

<details markdown="1">
<summary><strong>Solution (after your attempt!)</strong></summary>

```cpp
#include <iostream>
int main() {
    int marks;
    std::cout << "Enter marks (0-100): ";
    std::cin >> marks;

    if (marks < 0 || marks > 100)              // requirement 2: OR of two violations
    {
        std::cout << "Invalid marks: " << marks << '\n';
        return 1;
    }

    if (marks >= 80)      std::cout << "A\n";  // most demanding first
    else if (marks >= 70) std::cout << "B\n";
    else if (marks >= 60) std::cout << "C\n";
    else if (marks >= 40) std::cout << "D\n";
    else                  std::cout << "F\n";
    return 0;
}
```

</details>

**Explanation.** The guard runs first so the ladder never sees invalid data — after `return 1`, "the rest of the program" *is* the valid case, so no `else` wrap is needed. The ladder is most-demanding-first, so each `else if` inherits "and below the previous band" for free; the final `else` owns everything under 40. Edge ownership is provable: 40 fails `>= 80/70/60` and passes `>= 40` — one band only.

---

## Lab 2 — Electricity bill (slab rates)

**Scenario.** The power company charges *marginal* slab rates — each slab's rate applies only to the units inside that slab — plus a fixed meter rent. Your program computes one customer's bill.

**Requirements.**

1. Read units consumed as an `int`. Negative → `Invalid units` and exit status 1.
2. Rates (marginal): first 100 units @ 5.00; next 100 units (101–200) @ 7.00; above 200 @ 10.00.
3. Fixed meter rent: 150.00, always added (even at 0 units).
4. Print the bill with two decimals: `Bill: 1850.00`.

**Inputs / outputs.** Input: one `int`. Output: one `Bill: X.XX` line (or the invalid message).

**Test cases.**

| units | working | expected |
| --- | --- | --- |
| −5 | — | `Invalid units` |
| 0 | 0 + rent | `Bill: 150.00` |
| 100 | 100×5 + rent | `Bill: 650.00` |
| 150 | 500 + 50×7 + rent | `Bill: 1000.00` |
| **200** | 500 + 100×7 + rent (edge) | `Bill: 1350.00` |
| 250 | 500 + 700 + 50×10 + rent | `Bill: 1850.00` |
| 300 | 500 + 700 + 1000 + rent | `Bill: 2350.00` |

**Student tasks.** ① Decide the *shape*: this is not a classification ladder — each branch *computes* an amount. Sketch which slabs contribute at 150 and at 250 units. ② Write the branch conditions (`<= 100`? `<= 200`? `else`?). ③ Code it — declare `double bill = 150.0;` first and *add* slab charges in the ladder. ④ Dry-run the table; check 200 especially: does the 7.00 slab own all of 101–200, exactly?

**Extensions.** ⭐ Print each slab's contribution on its own line (turn the ladder into an itemised bill). ⭐⭐ Add a 5% fuel-price adjustment on the *units cost* (not the rent) when units exceed 300. ⭐⭐⭐ Read three months of units and bill each; flag any month over 400 units as `High usage` — you'll need three decisions *plus* the ladder per month (write it long-hand; loops come in [Unit 05](../syllabus.md#stage-b-control-flow-units-4-6)).

<details markdown="1">
<summary><strong>Solution (after your attempt!)</strong></summary>

```cpp
#include <iostream>
#include <iomanip>
int main() {
    int units;
    std::cout << "Units consumed: ";
    std::cin >> units;

    if (units < 0)
    {
        std::cout << "Invalid units\n";
        return 1;
    }

    double bill = 150.0;                       // meter rent, requirement 3

    if (units <= 100)                          // slab 1 only
    {
        bill += units * 5.0;
    }
    else if (units <= 200)                     // slab 1 full + part of slab 2
    {
        bill += 100 * 5.0 + (units - 100) * 7.0;
    }
    else                                       // slabs 1+2 full + part of slab 3
    {
        bill += 100 * 5.0 + 100 * 7.0 + (units - 200) * 10.0;
    }

    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Bill: " << bill << '\n';
    return 0;
}
```

</details>

**Explanation.** Marginal slabs are the classic *decision that computes*: the ladder picks the slab the customer's usage *tops out in*, and each branch charges all cheaper slabs in full plus the remainder at the current rate. `units - 100` and `units - 200` are the "how far into this slab" amounts — the same pattern powers [C9](challenges.md#c9--tax-slab-calculator). Note 200 is charged entirely at 7.00 (`units - 200` = 0 in the last branch) — the test row proves the edge belongs to the second slab, not straddling two.

---

## Lab 3 — Cinema ticket pricing

**Scenario.** A multiplex prices by customer category, with a weekday discount. Several rules interact, and the *order* of the rules decides what a 10-year-old student pays.

**Requirements.**

1. Read `age` (int), `isStudent` (1/0), `day` (1–7, Mon = 1).
2. Base price: 700.00. Child (under 12): 350.00. Senior (60 or more): 400.00.
3. Students of **any other age** pay 500.00 — but the child and senior rules take precedence over the student rule.
4. Wednesday (day = 3): 20% off the *final* price, whatever it is.
5. Validate: age 0–120, day 1–7 → else `Invalid input`, exit 1.

**Inputs / outputs.** Inputs: three values in order `age isStudent day`. Output: one line `Ticket: 560.00` (two decimals) or the invalid message.

**Test cases.**

| age | student | day | price work | expected |
| --- | --- | --- | --- | --- |
| 10 | 0 | 1 | child 350 | `Ticket: 350.00` |
| 10 | 1 | 1 | child wins over student | `Ticket: 350.00` |
| 30 | 1 | 1 | student 500 | `Ticket: 500.00` |
| 30 | 0 | 1 | base 700 | `Ticket: 700.00` |
| **12** | 0 | 1 | not under 12 → base | `Ticket: 700.00` |
| **60** | 0 | 1 | senior edge | `Ticket: 400.00` |
| 59 | 0 | 1 | not yet senior | `Ticket: 700.00` |
| 30 | 0 | 3 | 700 × 0.8 | `Ticket: 560.00` |
| 65 | 0 | 3 | 400 × 0.8 | `Ticket: 320.00` |
| 10 | 0 | 3 | 350 × 0.8 | `Ticket: 280.00` |
| 130 | 0 | 1 | — | `Invalid input` |

**Student tasks.** ① Extract the conditions and note the **precedence** sentence in requirement 3 — write it in your own words before coding. ② Decide the price with one if-else chain (child → senior → student → base — why can't student come first?). ③ Apply the Wednesday factor *after* the price is known — one more decision. ④ Dry-run the table; the age-12 and age-60 rows are the whole lab. ⑤ Which rule "wins" for a 65-year-old student? Trace it — requirement 3 says.

**Extensions.** ⭐ Print the category name alongside (`Child 350.00`). ⭐⭐ Add a family deal: 4 or more tickets (read `ticketCount`) take a further 10% off the pre-Wednesday price — decide and document whether it stacks before or after Wednesday. ⭐⭐⭐ A 3D surcharge (+150) applies *before* the Wednesday percentage — reorder your decisions so percentages always come last, and explain why money-percentage rules must be ordered that way.

<details markdown="1">
<summary><strong>Solution (after your attempt!)</strong></summary>

```cpp
#include <iostream>
#include <iomanip>
int main() {
    int age, isStudent, day;
    std::cout << "Enter age, isStudent (1/0), day (1-7): ";
    std::cin >> age >> isStudent >> day;

    if (age < 0 || age > 120 || day < 1 || day > 7)
    {
        std::cout << "Invalid input\n";
        return 1;
    }

    double price;
    if (age < 12)                    // child first — precedence rule 3
    {
        price = 350.0;
    }
    else if (age >= 60)              // senior second
    {
        price = 400.0;
    }
    else if (isStudent == 1)         // student only if neither of the above
    {
        price = 500.0;
    }
    else
    {
        price = 700.0;
    }

    if (day == 3)                    // Wednesday: percentage last
    {
        price = price * 0.80;
    }

    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Ticket: " << price << '\n';
    return 0;
}
```

</details>

**Explanation.** Requirement 3's precedence sentence translates directly into ladder *order*: `if age < 12` is checked first, so a 10-year-old student exits at the child branch and never reaches the student test. Moving the student branch first would silently rewrite the pricing policy — the bug wouldn't crash, it would just charge children 500. The Wednesday decision is *separate and later*: percentage discounts must apply to an already-decided price, so the ladder decides *which* price, then the discount decides *its* final value.

---

## Lab 4 — ATM withdrawal validation

**Scenario.** An ATM validates every withdrawal request through a chain of business rules. Each rejection must say **why** — and when a request breaks several rules, the ATM reports the *most specific* reason first, in the order below.

**Requirements.**

1. Read `balance` (double) and `amount` (int).
2. Rejection chain, checked in this order — first failure wins:
   a. amount must be positive → `Error: amount must be positive`
   b. amount must be a multiple of 500 (the machine stocks only 500-notes) → `Error: amount must be a multiple of 500`
   c. amount must not exceed the per-transaction limit of 25000 → `Error: exceeds per-transaction limit`
   d. amount must not exceed the balance → `Error: insufficient funds`
3. On success: print `Dispensed: N` and `New balance: X.XX`.
4. Balance validation: negative balance → `Error: invalid balance`, exit 1, before anything else.

**Inputs / outputs.** Inputs: `balance amount`. Output: one or two lines as above.

**Test cases.**

| balance | amount | rule hit | expected output |
| --- | --- | --- | --- |
| −100 | 500 | pre-check | `Error: invalid balance` |
| 30000 | 0 | (a) | `Error: amount must be positive` |
| 30000 | −500 | (a) | `Error: amount must be positive` |
| 30000 | 300 | (b) | `Error: amount must be a multiple of 500` |
| 30000 | 35000 | (c) | `Error: exceeds per-transaction limit` |
| 20000 | 35000 | (c) **before** (d) | `Error: exceeds per-transaction limit` |
| 20000 | 25000 | (d) | `Error: insufficient funds` |
| 20000 | 20000 | (d) edge — equal is allowed | `Dispensed: 20000` · `New balance: 0.00` |
| 30000 | 25000 | success edge | `Dispensed: 25000` · `New balance: 5000.00` |
| 30000 | 5000 | success | `Dispensed: 5000` · `New balance: 25000.00` |

**Student tasks.** ① Write each rule as a condition *before* coding; mark which boundary is inclusive (equal-to-balance — check rule d's wording). ② Build the chain: four ifs in order, each `return 1` — why is a ladder *wrong* here (think: what would the `else`s mean)? ③ The row `20000, 35000` breaks rules (c) and (d) — dry-run your chain and confirm (c) is reported. ④ Add the two success lines — the dispensed amount is an `int`, the balance a `double`; print each correctly.

**Extensions.** ⭐ Count and print how many 500-notes the machine dispenses (`amount / 500` — why is this exact?). ⭐⭐ Add a daily limit of 50000: read `alreadyWithdrawnToday` and fold it into rule (c)'s check *after* the per-transaction limit — the remaining allowance is `50000 - alreadyWithdrawnToday`. ⭐⭐⭐ Two accounts: read `fromSavings` (1/0) — a joint current account allows a 40000 limit; savings stays at 25000. Keep the chain flat if you can.

<details markdown="1">
<summary><strong>Solution (after your attempt!)</strong></summary>

```cpp
#include <iostream>
#include <iomanip>
int main() {
    double balance;
    int amount;
    std::cout << "Enter balance and amount: ";
    std::cin >> balance >> amount;

    if (balance < 0)
    {
        std::cout << "Error: invalid balance\n";
        return 1;
    }
    if (amount <= 0)                        // (a) positive — 0 fails too
    {
        std::cout << "Error: amount must be positive\n";
        return 1;
    }
    if (amount % 500 != 0)                  // (b) machine notes
    {
        std::cout << "Error: amount must be a multiple of 500\n";
        return 1;
    }
    if (amount > 25000)                     // (c) per-transaction limit
    {
        std::cout << "Error: exceeds per-transaction limit\n";
        return 1;
    }
    if (amount > balance)                   // (d) funds — equal passes
    {
        std::cout << "Error: insufficient funds\n";
        return 1;
    }

    std::cout << "Dispensed: " << amount << '\n';
    std::cout << std::fixed << std::setprecision(2);
    std::cout << "New balance: " << balance - amount << '\n';
    return 0;
}
```

</details>

**Explanation.** This is a **guard chain**, not a ladder: each `if` *ends the program* on failure, so there is no `else` — reaching the next line *means* the previous rule passed. That's why rule order *is* precedence: the 20000/35000 request fails (c) before (d) is ever consulted. Equal-to-balance passes because rule (d) uses `>` — "must not *exceed*" includes equality; the `20000, 20000` row proves it. Rule (b) uses `%` with the guarantee from (a) that amount is positive, so the modulo is well-defined — guard order protects later checks.

---

## Lab 5 — Sports-day categories

**Scenario.** A school sorts students into sports-day events by age, and older juniors with signed consent forms may additionally enter the relay.

**Requirements.**

1. Read `age` (int) and `hasConsent` (1/0).
2. Valid ages: 5–80. Outside → `No event`, exit status 1.
3. Categories: 5–7 `Red: fun races` · 8–10 `Blue: junior track` · 11–13 `Green: intermediate track` · 14–17 `Gold: senior track` · 18–80 `Staff/exhibition only`.
4. Relay: students aged 11–13 **with** consent also get the line `Relay eligible`.

**Inputs / outputs.** Inputs: `age hasConsent`. Output: one category line, plus possibly the relay line.

**Test cases.**

| age | consent | output |
| --- | --- | --- |
| 4 | 0 | `No event` |
| **5** | 0 | `Red: fun races` (edge) |
| 7 | 0 | `Red: fun races` |
| **8** | 1 | `Blue: junior track` |
| 10 | 1 | `Blue: junior track` |
| 11 | 0 | `Green: intermediate track` |
| 11 | 1 | `Green: intermediate track` + `Relay eligible` |
| 13 | 1 | `Green: intermediate track` + `Relay eligible` |
| **14** | 1 | `Gold: senior track` (relay age over) |
| 17 | 0 | `Gold: senior track` |
| 18 | 1 | `Staff/exhibition only` |
| 81 | 1 | `No event` |

**Student tasks.** ① Two decisions, two different shapes: the category is a **ladder**; the relay is an **AND-gate**. Write both conditions on paper first. ② The relay check is *independent* of the category ladder — it must run for Green students only. Do you nest it, or guard it with `age >= 11 && age <= 13`? Compare both shapes and pick one with a reason. ③ Dry-run all 12 rows. ④ Confirm 14/1 prints Gold *without* the relay line — the compound condition must exclude it.

**Extensions.** ⭐ Print a third line for Blue and Gold students: `Bring water bottle`. ⭐⭐ Read a third input `hasSibling` — Red-house students with a sibling in any other house get `Sibling race: yes`. Which of your conditions grow compound, and does any *nesting* become necessary? ⭐⭐⭐ Re-express your entire category ladder as a single `switch` on an `ageGroup` variable you compute first (you'll need a small ladder to compute the group — notice the two-stage shape; this previews functions in [Stage B](../syllabus.md#stage-b-control-flow-units-4-6)).

<details markdown="1">
<summary><strong>Solution (after your attempt!)</strong></summary>

```cpp
#include <iostream>
int main() {
    int age, hasConsent;
    std::cout << "Enter age and hasConsent (1/0): ";
    std::cin >> age >> hasConsent;

    if (age < 5 || age > 80)
    {
        std::cout << "No event\n";
        return 1;
    }

    if (age <= 7)             std::cout << "Red: fun races\n";      // 5-7
    else if (age <= 10)       std::cout << "Blue: junior track\n";  // 8-10
    else if (age <= 13)       std::cout << "Green: intermediate track\n"; // 11-13
    else if (age <= 17)       std::cout << "Gold: senior track\n";  // 14-17
    else                      std::cout << "Staff/exhibition only\n"; // 18-80

    if (age >= 11 && age <= 13 && hasConsent == 1)
    {
        std::cout << "Relay eligible\n";
    }
    return 0;
}
```

</details>

**Explanation.** The validation guard runs first; after it, the ladder's bounds are guaranteed. Inside the ladder, each `else if (age <= N)` inherits "above the previous band" — so `<= 10` means 8–10, no explicit `age >= 8` needed. The relay is deliberately *not* nested inside the Green branch: it's an independent fact about the input, and a flat `if` with a three-part condition reads as one sentence. The 14/1 row proves the AND-gate's upper bound; the 11/0 row proves the consent side.

---

## Lab 6 — Admission eligibility

**Scenario.** A university admits BS students on a weighted aggregate: matriculation marks count 30%, intermediate marks count 70%. Eligible candidates are routed to a department by aggregate band; age is a hard gate.

**Requirements.**

1. Read `matric`, `inter` (both ints, out of 1100) and `age` (int).
2. Validate: each marks value in 0–1100, age in 16–25 → else `Invalid input`, exit 1.
3. Aggregate: `aggregate = matric / 1100.0 * 30 + inter / 1100.0 * 70` (all `double` math — why does `matric / 1100 * 30` with int division fail?).
4. Hard gate: age over 22 → `Not eligible: age`, even with a perfect aggregate.
5. Bands (only if the age gate passed): ≥ 85 `Data Science` · ≥ 75 `Computer Science` · ≥ 60 `Information Technology` · below 60 `Not eligible: aggregate`.

**Inputs / outputs.** Inputs: `matric inter age`. Output: one line — a department, or a not-eligible reason.

**Test cases.**

| matric | inter | age | aggregate | output |
| --- | --- | --- | --- | --- |
| 1200 | 800 | 20 | — | `Invalid input` |
| 990 | 990 | 20 | 90.0 | `Data Science` |
| 990 | 935 | 20 | 86.5 | `Data Science` |
| 880 | 880 | 20 | 80.0 | `Computer Science` |
| 990 | 660 | 20 | 69.0 | `Information Technology` |
| 550 | 550 | 20 | 50.0 | `Not eligible: aggregate` |
| 990 | 990 | **23** | 90.0 | `Not eligible: age` |
| 880 | 880 | **22** | 80.0 | `Computer Science` (age edge — eligible) |

**Student tasks.** ① Requirement 3 hides the [integer-division trap](../cpp-foundations/lesson-4-conversion.md) — write the aggregate line so every division happens in `double`. ② Order the checks: validation → age gate → bands. Why must the age gate precede the bands (what would a 23-year-old with 90.0 otherwise see)? ③ Dry-run the table; hand-compute the 86.5 row yourself. ④ The age edge row (22 vs 23) — which comparison did the requirement's "over 22" become?

**Extensions.** ⭐ Print the aggregate with two decimals alongside the department (`Computer Science (80.00)`). ⭐⭐ Add a Hafiz-e-Quran bonus: read `isHafiz` (1/0) and add 2 marks to the aggregate *before* banding — a 58.0 + 2 candidate must become IT; check where the bonus line sits. ⭐⭐⭐ Department seats are capped: read `dsSeatsLeft` — a Data Science qualifier with 0 seats left gets `Computer Science` instead. Which branch grows, and what happens to the CS band's own check?

<details markdown="1">
<summary><strong>Solution (after your attempt!)</strong></summary>

```cpp
#include <iostream>
#include <iomanip>
int main() {
    int matric, inter, age;
    std::cout << "Enter matric, inter (out of 1100) and age: ";
    std::cin >> matric >> inter >> age;

    if (matric < 0 || matric > 1100 || inter < 0 || inter > 1100 ||
        age < 16 || age > 25)
    {
        std::cout << "Invalid input\n";
        return 1;
    }

    double aggregate = matric / 1100.0 * 30 + inter / 1100.0 * 70;

    if (age > 22)                       // hard gate first
    {
        std::cout << "Not eligible: age\n";
        return 0;
    }

    std::cout << std::fixed << std::setprecision(2);

    if (aggregate >= 85)      std::cout << "Data Science\n";
    else if (aggregate >= 75) std::cout << "Computer Science\n";
    else if (aggregate >= 60) std::cout << "Information Technology\n";
    else                      std::cout << "Not eligible: aggregate\n";

    return 0;
}
```

</details>

**Explanation.** Three decision layers, in dependency order: validation (garbage in, nothing meaningful out), the hard gate (age disqualifies *before* any band is consulted — a 23-year-old with 90.0 must see the age message, never a department), then the classification ladder. The aggregate line divides by `1100.0` so each division is floating-point; `matric / 1100` with two ints would be 0 for every value under 1100 — the single most common bug in this lab. The banding ladder is exactly Lab 1's shape, one abstraction higher: same discipline, computed inputs.

---

## Lab 7 — Shipping cost calculator

**Scenario.** A courier prices parcels from a weight charge plus a distance surcharge; express service doubles the weight charge but not the distance part.

**Requirements.**

1. Read `weightKg` (int), `distanceKm` (int), `express` (1/0).
2. Validate: weight 1–50, distance 1–5000 → else `Invalid input`, exit 1.
3. Weight charge: base 250.00 covers up to 5 kg inclusive; each additional full kg adds 60.00.
4. Distance surcharge (added once, never doubled): up to 100 km +0.00 · 101–500 +150.00 · above 500 +400.00.
5. Express: the **weight charge only** is doubled.
6. Print `Shipping: X.XX`.

**Inputs / outputs.** Inputs: `weightKg distanceKm express`. Output: one line `Shipping: 1260.00` or the invalid message.

**Test cases.**

| kg | km | express | working | expected |
| --- | --- | --- | --- | --- |
| 0 | 80 | 0 | — | `Invalid input` |
| 3 | 80 | 0 | 250 + 0 | `Shipping: 250.00` |
| **5** | 80 | 0 | base edge — 0 extra kg | `Shipping: 250.00` |
| 8 | 80 | 0 | 250 + 3×60 | `Shipping: 430.00` |
| 8 | 300 | 0 | 430 + 150 | `Shipping: 580.00` |
| 8 | 700 | 0 | 430 + 400 | `Shipping: 830.00` |
| 8 | 700 | 1 | (430×2) + 400 | `Shipping: 1260.00` |
| 12 | 50 | 1 | (250 + 7×60)×2 | `Shipping: 1340.00` |
| **6** | 80 | 0 | one extra kg — the first paid kg | `Shipping: 310.00` |
| 60 | 80 | 0 | — | `Invalid input` |

**Student tasks.** ① Two independent classifications (weight charge, distance band) *plus* one multiplier decision. Compute them as separately named values before printing. ② The base covers "up to 5 kg inclusive" — write that condition. How many additional kg at 6 kg? At 5 kg? ③ Express doubles *only* the weight charge — dry-run the 8/700/1 row by hand to catch any doubling of the surcharge. ④ Confirm 6/80/0 costs 310 — the first *paid* kg is the boundary your condition must own.

**Extensions.** ⭐ Print the two components (`Weight: 430.00 Distance: 400.00`). ⭐⭐ Fractional weights: read `weightKg` as a `double`; "each additional kg **or part thereof**" means 7.2 kg pays for 3 additional kg — the ceiling. With only decisions (no loops, no `cmath` yet): `extra = (int)(w) - 5;` then add one more kg when the fractional part is non-zero and `w > 5`. Test 7.0 vs 7.2 vs 7.99. ⭐⭐⭐ Add zone-based per-kg distance fee: above 500 km, each kg over 5 adds 1.50 as well — which value does this modify, and *before or after* the express doubling?

<details markdown="1">
<summary><strong>Solution (after your attempt!)</strong></summary>

```cpp
#include <iostream>
#include <iomanip>
int main() {
    int weightKg, distanceKm, express;
    std::cout << "Enter weightKg, distanceKm, express (1/0): ";
    std::cin >> weightKg >> distanceKm >> express;

    if (weightKg < 1 || weightKg > 50 || distanceKm < 1 || distanceKm > 5000)
    {
        std::cout << "Invalid input\n";
        return 1;
    }

    double weightCharge;
    if (weightKg <= 5)                  // base covers up to 5 inclusive
    {
        weightCharge = 250.0;
    }
    else
    {
        weightCharge = 250.0 + (weightKg - 5) * 60.0;
    }

    double distanceFee;
    if (distanceKm <= 100)      distanceFee = 0.0;
    else if (distanceKm <= 500) distanceFee = 150.0;
    else                        distanceFee = 400.0;

    if (express == 1)                   // doubles the weight charge only
    {
        weightCharge = weightCharge * 2.0;
    }

    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Shipping: " << weightCharge + distanceFee << '\n';
    return 0;
}
```

</details>

**Explanation.** The lab's lesson is **decompose then combine**: two classifications and one multiplier, each a small decision, each producing a *named value*; only the final line adds them. Express modifies `weightCharge` *after* the weight ladder and *before* the sum — placement is the whole requirement 5, and the 8/700/1 row (1260, not 1660) proves the surcharge escaped the doubling. The `weightKg - 5` inside the else branch is safe because the branch condition already guarantees `weightKg >= 6` — ladder membership again doing the range work.

---

## Lab 8 — Restaurant billing rules

**Scenario.** A restaurant's till computes bills from a short menu with stacked money rules: a bulk discount, a dine-in service charge, and GST on top of everything else.

**Requirements.**

1. Read `item` (1 = Biryani 450, 2 = Burger 350, 3 = BBQ Platter 700) and `quantity` (int).
2. Invalid item (not 1–3) → `Unknown item`, exit 1. Quantity below 1 → `Invalid quantity`, exit 1.
3. subtotal = item price × quantity.
4. Discount: 10% off the subtotal when subtotal ≥ 2000.
5. Service charge: 5% of the **discounted** subtotal, but only for dine-in (read `dineIn` 1/0; 0 takeaway).
6. GST: 16% of (discounted subtotal + service charge).
7. Total = discounted subtotal + service charge + GST. Print `Total: X.XX`.

**Inputs / outputs.** Inputs: `item quantity dineIn`. Output: one line `Total: 1096.20`.

**Test cases.**

| item | qty | dineIn | subtotal | discount | service | GST | expected |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 2 | 1 | 900 | 0 | 45.00 | 151.20 | `Total: 1096.20` |
| 3 | 3 | 1 | 2100 | 210.00 | 94.50 | 317.52 | `Total: 2302.02` |
| 3 | 3 | 0 | 2100 | 210.00 | 0.00 | 302.40 | `Total: 2192.40` |
| **2** | 4 | 1 | 1400 | 0 | 70.00 | 235.20 | `Total: 1705.20` |
| **3** | 2 | 1 | 1400 | 0 | 70.00 | 235.20 | `Total: 1705.20` |
| 3 | 2 | 1 | **2000 edge** | 200.00 | 90.00 | 334.40 | `Total: 1924.40` |
| 4 | 1 | 1 | — | — | — | — | `Unknown item` |
| 1 | 0 | 1 | — | — | — | — | `Invalid quantity` |

**Student tasks.** ① Map the menu with a `switch` (exactly the tool from [Lesson 3](lesson-3-switch.md)) — three cases, one `default`. ② Compute the pipeline in order: subtotal → discount → service → GST → total, one named `double` per stage. ③ Which rules are decisions (discount threshold, dine-in) and which are unconditional arithmetic (GST)? Write them differently on purpose. ④ Dry-run all 8 rows by hand — including the 2000 edge, where the discount must *just* switch on. ⑤ Verify row 5 equals row 4 (different item, same money): your switch must produce identical arithmetic from both routes.

**Extensions.** ⭐ Print all four components before the total, aligned with `setw` ([I/O Lesson 1 §6](../cpp-io/lesson-1-cout.md#4-formatting-columns-setw-left-right-setfill)). ⭐⭐ Loyalty: read `points` (int); 100 points may be redeemed for 50.00 off **after** the discount but **before** service and GST — decide and document the exact insertion point, then re-verify the first four rows unchanged when points = 0. ⭐⭐⭐ A combo deal: item 1 **and** item 2 ordered together (read a second `item2 quantity2` pair) take 15% off the *combined* subtotal before any other rule — restructure your pipeline so the combo decision sits at the very top, and re-derive every test row.

<details markdown="1">
<summary><strong>Solution (after your attempt!)</strong></summary>

```cpp
#include <iostream>
#include <iomanip>
int main() {
    int item, quantity, dineIn;
    std::cout << "Enter item (1-3), quantity, dineIn (1/0): ";
    std::cin >> item >> quantity >> dineIn;

    double price;
    switch (item)
    {
        case 1: price = 450.0; break;
        case 2: price = 350.0; break;
        case 3: price = 700.0; break;
        default:
            std::cout << "Unknown item\n";
            return 1;
    }

    if (quantity < 1)
    {
        std::cout << "Invalid quantity\n";
        return 1;
    }

    double subtotal      = price * quantity;
    if (subtotal >= 2000)               // bulk discount threshold
    {
        subtotal = subtotal * 0.90;
    }

    double service      = 0.0;
    if (dineIn == 1)                    // dine-in only
    {
        service = subtotal * 0.05;
    }

    double gst   = (subtotal + service) * 0.16;   // unconditional arithmetic
    double total = subtotal + service + gst;

    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Total: " << total << '\n';
    return 0;
}
```

</details>

**Explanation.** Four rule types in one program: a **routing** decision (`switch` — exact menu codes), two **threshold** decisions (discount at 2000, dine-in gate), and **unconditional arithmetic** (GST, total) — deliberately not wrapped in any `if`. The ordering is the money logic: discount before service (the service charge is 5% of the *discounted* subtotal), and GST last on the running sum. The 2000 edge row is the lab's exam: at exactly 2000 the discount applies (`>=`), which cascades through service, GST, and total — a wrong comparison operator there shifts *every* downstream number, which is exactly why the dry-run table exists.

---

## After the labs

- [ ] All attempted labs have a decision table *and* a dry-run sheet in your `labs/` folder
- [ ] Every boundary value in every requirement was tested with below/edge/above
- [ ] You can name, per lab, which decision was a ladder, which a guard chain, which a switch, and which an AND-gate
- [ ] At least one extension attempted per lab

Ready for more? The [challenge problems](challenges.md) C1, C2, C7 and C9 are natural continuations — and [Unit 05](../syllabus.md#stage-b-control-flow-units-4-6) will let you re-run Labs 1–8 with loops, menus that repeat, and input that re-prompts instead of quitting.
