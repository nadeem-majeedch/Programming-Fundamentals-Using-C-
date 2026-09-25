---
title: "Labs — Five Realistic IO Scenarios"
description: "Student information system, billing counter, temperature assistant, travel expense calculator, and utility bill calculator — full briefs with test cases and solutions."
---

# Labs — Five Realistic IO Scenarios

> [← Module home](index.md) · [Lab rubric](../grading.md#lab-rubric-all-labs)

Five labs, in rising difficulty. **Every lab hides its solution in a
collapsed box — write, compile, and test your own attempt first.** That
is not decoration: the gap between *reading* a solution and *producing*
one is the entire course.
[Try It Yourself](../problem-solving/index.md#try-it-yourself-before-looking-at-the-solution)
is the lab rule.

Standard lab method ([full write-up template](../getting-started/getting-started-lab.md)):

1. **Plan on paper** — inputs, processing, outputs (the IPO shape)
2. **Code** — smallest program that meets the requirements
3. **Compile clean** — `g++ -std=c++17 -Wall -Wextra lab.cpp -o lab`
4. **Run the test table** — every case, compare character by character
5. **Write up** — what worked, what didn't, one thing you'd do differently

Save as `lab-N-yourname.cpp` in your labs folder
([lab organisation](../getting-started/getting-started-lesson.md#20-how-students-should-organize-and-submit-lab-work)).

---

<a name="lab-1--the-student-information-system"></a>
## Lab 1 — The Student Information System ★★

**Scenario.** The department records students on paper cards. You are
digitising one card: the clerk types the details, the program prints a
neat summary block.

**Requirements.**

1. Read, in this order: roll number (whole number), full name (may
   contain spaces), marks in three subjects (whole numbers).
2. Print a summary block: name left-aligned in width 20, roll right in
   width 8, each subject's marks, then total and average (average to
   exactly 1 decimal).
3. Print a result word: `Result: true` when the total is 120 or more,
   `Result: false` otherwise — a `bool` and `std::boolalpha` do this with
   no `if` (compare, print). Upgrading the word to `PASS`/`FAIL` is an
   extension — [Unit 04](../decisions/index.md) gives you the decision to do it.

**Inputs.** roll: `int` · name: one `getline` line · marks: three `int`
(`>>`). Name typed on its own line; the three marks may share a line.

**Outputs.** Exactly this shape (your pads may differ; values must not):

```text
Roll:        41  Name: Ali Raza Khan
Marks: 78 84 91
Total: 253  Average: 84.3  Result: PASS
```

**Constraints.** Name is 3–40 characters and never empty; marks are
0–100; the program may assume well-formed numbers *except* the
name/marks reader-splitting (the trap is mandatory terrain here).

**Sample test cases.**

| # | Input lines | Expected output |
| --- | --- | --- |
| 1 | `41` ⏎ `Ali Raza Khan` ⏎ `78 84 91` | Total 253, Average 84.3, Result true |
| 2 | `7` ⏎ `Bo` ⏎ `40 40 39` | Total 119, Average 40.0, Result false (one mark short!) |
| 3 | `99` ⏎ `Chen Wei` ⏎ `100 100 100` | Total 300, Average 100.0, Result true |

**Student tasks.** (1) IPO plan with the buffer in mind — *which* read
leaves a newline behind? (2) code it; (3) compile with `-Wall -Wextra`;
(4) run all three cases; (5) then deliberately remove the cure, watch
case 1 break, and restore it; (6) write-up: what exactly did the cure
remove?

**Extension challenges.** Validate each mark 0–100 with the
`fail()/clear()/ignore()` loop · print the marks as a formatted row
(`setw`) · read the name *first* and the roll second (does the trap
move? where?) · **now unlocked — [Unit 04](../decisions/index.md)**:
upgrade `Result: true/false` to `PASS`/`FAIL` with a real decision (an
`if-else`, or the ternary `?:` — your call, labelled), then re-verify
every test row including the exact boundary of 120 total.

<details markdown="1">
<summary><strong>Solution — after your own attempt is compiled and tested</strong></summary>

```cpp
// lab-1.cpp — Student Information System
#include <iostream>
#include <iomanip>
#include <string>

int main() {
    int rollNo;
    std::string fullName;
    int m1, m2, m3;

    std::cout << "Roll number: " << std::endl;
    std::cin >> rollNo;

    std::cin.ignore(1000, '\n');            // cure: eat the leftover '\n'

    std::cout << "Full name: " << std::endl;
    std::getline(std::cin, fullName);       // whole line, spaces kept

    std::cout << "Marks (three, space-separated): " << std::endl;
    std::cin >> m1 >> m2 >> m3;             // one Enter or three — same

    int total = m1 + m2 + m3;
    double average = static_cast<double>(total) / 3;
    bool pass = (total >= 120);

    std::cout << "Roll: " << std::right << std::setw(8) << rollNo
              << "  Name: " << std::left << std::setw(20) << fullName << "\n";
    std::cout << "Marks: " << m1 << " " << m2 << " " << m3 << "\n";
    std::cout << "Total: " << total
              << "  Average: " << std::fixed << std::setprecision(1) << average
              << "  Result: " << std::boolalpha << pass << "\n";
    return 0;
}
```

</details>

**Explanation.** The read plan is the exam: `rollNo` via `>>` leaves
`'\n'`, so the mandatory cure runs *before* the name `getline`; the three
marks ride one chained `>>` (whitespace-flexible by design). The average
needs the `static_cast<double>` **before** dividing — `253 / 3` in ints
is 84, and `setprecision(1)` cannot recover lost digits. `pass` is an
ordinary `bool` from a comparison; `boolalpha` prints it as `true`/
`false` — words, just not the *clerk's* words. Printing `PASS`/`FAIL`
needs a decision (Unit 04) or the ternary operator — and noticing that
a requirement outruns your current toolkit, then documenting the gap,
is itself a professional habit. (Deliberate stretch — caught it? Good.)
Unit 04 is out: the upgrade is now a worked pattern in
[its Lesson 3 §6](../decisions/lesson-3-switch.md#6-the-conditional-operator--a-decision-that-yields-a-value)
and an unlocked extension above.

---

<a name="lab-2--the-billing-counter"></a>
## Lab 2 — The Billing Counter ★★

**Scenario.** A canteen counter program: one item per bill. The cashier
types item, quantity, unit price; the printer wants a receipt with money
that *looks* like money.

**Requirements.**

1. Read item name (one word), quantity (whole), unit price (decimal).
2. Print: the item line, a line `qty x unit = subtotal` (both money
   figures two decimals), a GST line at 5%, and a grand total —
   dot-filled to align the amounts at column 24.
3. All rupee amounts use `fixed` + `setprecision(2)`.

**Inputs.** item: `string` via `>>` (no spaces) · qty: `int` · price:
`double` — all on one line is legal (`Chai 3 40`).

**Outputs.**

```text
Item: Chai
3 x 40.00 = 120.00
GST 5% ..............6.00
TOTAL .............126.00
```

**Constraints.** qty 1–99; price 0.01–9999.99; item is a single word;
GST is exactly 5% of subtotal; dot-fill via `setfill('.')` + `setw(24)`
applied to the *combined label+amount* field… or per-column — your
choice, but the amounts must align.

**Sample test cases.**

| # | Input | Expected lines |
| --- | --- | --- |
| 1 | `Chai 3 40` | subtotal 120.00, GST 6.00, TOTAL 126.00 |
| 2 | `Samosa 12 25.5` | subtotal 306.00, GST 15.30, TOTAL 321.30 |
| 3 | `Water 1 9999.99` | subtotal 9999.99, GST 500.00 (499.9995 rounds), TOTAL 10499.99 |

**Student tasks.** (1) IPO plan; (2) code; (3) all three test cases —
case 3 checks your rounding honestly; (4) explain in the write-up why
GST printed `500.00` and not `499.99` or `500` (two mechanisms: rounding
and sticky formatting); (5) swap two test inputs and re-verify.

**Extension challenges.** 10% discount when qty ≥ 10 (bool arithmetic
trick: `discount = subtotal * 0.10 * (qty >= 10);` — no `if` needed;
explain *why* that works) · a second item per receipt · currency
thousands separators (research `std::locale` — read-only).

<details markdown="1">
<summary><strong>Solution — after your own attempt is compiled and tested</strong></summary>

```cpp
// lab-2.cpp — The Billing Counter
#include <iostream>
#include <iomanip>
#include <string>

int main() {
    std::string item;
    int qty;
    double unitPrice;

    std::cout << "Item qty price (e.g. Chai 3 40): " << std::endl;
    std::cin >> item >> qty >> unitPrice;      // one line or three — both fine

    double subtotal = qty * unitPrice;
    double gst = subtotal * 0.05;
    double total = subtotal + gst;

    std::cout << std::fixed << std::setprecision(2);   // sticky money mode

    std::cout << "Item: " << item << "\n";
    std::cout << qty << " x " << unitPrice << " = " << subtotal << "\n";
    std::cout << std::left << std::setfill('.') << std::setw(20) << "GST 5%"
              << std::right << gst << "\n";
    std::cout << std::left << std::setfill('.') << std::setw(20) << "TOTAL"
              << std::right << total << "\n";
    return 0;
}
```

</details>

**Explanation.** All three reads are `>>` on one line — no `getline`, no
trap; the *prompt* promises the one-line form and the reads keep that
promise ([Debugging D9](debugging.md#d9---the-two-enters) was the
broken-promise version). `fixed/setprecision(2)` set once before any
money prints — sticky, so `40` prints `40.00` even inside the `x` line.
The dot-fill trick: `left << setfill('.') << setw(20)` pads the *label*,
then `right` (with the pad reset? no — `setfill` is sticky too; the
amounts need no padding because they never reach width 20 — but if a
total ever grew past 20 chars the dots would creep in; your write-up
should catch that risk). Case 3: 5% of 9999.99 is 499.9995 → rounds to
`500.00`; the total 10499.9895 → `10499.99`. Rounding happens *at print*
in each field separately — that is why added money columns can disagree
by a paisa, and why real systems round at every step.

---

<a name="lab-3--the-temperature-assistant"></a>
## Lab 3 — The Temperature Assistant ★★

**Scenario.** A lab bench tool: the user gives a Celsius reading, the
assistant prints the Fahrenheit twin and both rounded forms.

**Requirements.**

1. Read a Celsius temperature (decimal, negatives allowed).
2. Print the conversion line: `36.6 C = 97.88 F` using
   F = C × 9/5 + 32, two decimals.
3. Print a doctor's-rounding line: `rounded: 98 F` (nearest whole).
4. Freeze test: exactly `0 C` must print `32.00 F` — sanity anchor.

**Inputs.** temperature: `double` via `>>` (may be negative, may have
decimals).

**Outputs.**

```text
36.60 C = 97.88 F
rounded: 98 F
```

**Constraints.** Range −90.0 to 60.0 C; output always two decimals on
the conversion line, zero decimals on the rounded line; no decisions
(borrowed-`if` solutions are rejected — formatting does the rounding).

**Sample test cases.**

| # | Input | Expected |
| --- | --- | --- |
| 1 | `36.6` | `36.60 C = 97.88 F` · `rounded: 98 F` |
| 2 | `0` | `0.00 C = 32.00 F` · `rounded: 32 F` |
| 3 | `-40` | `-40.00 C = -40.00 F` · `rounded: -40 F` |

**Student tasks.** (1) Verify the arithmetic of all three cases *on
paper first* — especially −40 (why is it famous?); (2) code; (3) test;
(4) write-up: how does `setprecision(0)` round `97.88`, and does it
round −40.5 the same way? (Test it — the answer is "toward the even
whole on most compilers" or "up in the old ones": report yours.)

**Extension challenges.** Read the direction letter and convert both
ways (needs a decision — write it anyway, borrow `if` from Unit 04's
preview, label it as borrowed) · a K-line (Kelvin) · a table of −10 to
50 in tens using ten statements (loops preview).

<details markdown="1">
<summary><strong>Solution — after your own attempt is compiled and tested</strong></summary>

```cpp
// lab-3.cpp — The Temperature Assistant
#include <iostream>
#include <iomanip>

int main() {
    double celsius;

    std::cout << "Celsius temperature: " << std::endl;
    std::cin >> celsius;

    double fahrenheit = celsius * 9.0 / 5.0 + 32.0;

    std::cout << std::fixed << std::setprecision(2)
              << celsius << " C = " << fahrenheit << " F\n";
    std::cout << std::setprecision(0)
              << "rounded: " << fahrenheit << " F\n";
    return 0;
}
```

</details>

**Explanation.** Two classic formatting moves: `fixed` + `setprecision(2)`
for the conversion line, then `setprecision(0)` for the rounded line —
same sticky stream, changed mid-program on purpose. The arithmetic is
written `9.0 / 5.0`, not `9 / 5`: integer division would make *every*
conversion `c + 32` (9/5 = 1 in ints) — the
[Foundations conversion lesson](../cpp-foundations/lesson-4-conversion.md#42-implicit-conversion)
in the wild. Case 3: `−40 × 9/5 + 32 = −40` — the scale crossover, and
your sanity anchor for the sign logic.

---

<a name="lab-4--the-travel-expense-calculator"></a>
## Lab 4 — The Travel Expense Calculator ★★★

**Scenario.** The university trip planner: one car, several travellers.
Given distance, fuel average, fuel price, and head-count, print the fuel
budget and each person's share.

**Requirements.**

1. Read: distance (km, decimal), fuel average (km per litre, decimal),
   price per litre (decimal), number of travellers (whole).
2. Print: fuel needed (2 dp), total fuel cost (2 dp), cost per
   traveller (2 dp) — dot-filled labels aligned as in Lab 2.
3. Zero travellers must not be *divided by* — guard by treating 0 as 1
   for the share line, and say so in a comment (a decision disguised as
   arithmetic is not required; a documented assumption is).

**Inputs.** Four values, one line legal (`250 12.5 272.5 4`).

**Outputs.**

```text
Fuel needed .......20.00 L
Total fuel cost ..5450.00
Per traveller ....1362.50
```

**Constraints.** distance 1–5000 km; average 1–60 km/L; price 50–500;
travellers 0–7 (0 = driver alone → share equals total); all money
two decimals; the four reads are all `>>` — no `getline` needed, but
*write why not* in a comment (the trap you avoided by design).

**Sample test cases.**

| # | Input | Expected |
| --- | --- | --- |
| 1 | `250 12.5 272.5 4` | 20.00 L · 5450.00 · 1362.50 |
| 2 | `120 15 265 0` | 8.00 L · 2120.00 · 2120.00 (share = total) |
| 3 | `1000 6 280 5` | 166.67 L · 46666.67 · 9333.33 |

**Student tasks.** (1) Paper-verify case 3 — the division 1000/6 is
166.666…; where does 166.67 come from, and why does the total *not*
recompute from the printed litres? (2) code; (3) test all three;
(4) the travellers-0 case with and without your guard; (5) write-up:
one paragraph on printed-vs-true values (this is the whole money-format
story in miniature).

**Extension challenges.** Add a toll cost and a parking cost as extra
inputs · print a two-car comparison table (`setw` columns) · read all
four values on four prompts and prove the one-line input still works.

<details markdown="1">
<summary><strong>Solution — after your own attempt is compiled and tested</strong></summary>

```cpp
// lab-4.cpp — The Travel Expense Calculator
#include <iostream>
#include <iomanip>

int main() {
    double distance, kmPerLitre, pricePerLitre;
    int travellers;

    std::cout << "Distance km, avg km/L, price/L, travellers: " << std::endl;
    std::cin >> distance >> kmPerLitre >> pricePerLitre >> travellers;

    if (travellers == 0) {          // borrowed decision — documented guard
        travellers = 1;             // (see requirement 3) Unit 04 retires this borrow
    }

    double litres = distance / kmPerLitre;
    double cost = litres * pricePerLitre;
    double share = cost / travellers;

    std::cout << std::fixed << std::setprecision(2);

    std::cout << std::left  << std::setfill('.') << std::setw(17) << "Fuel needed "
              << std::right << litres << " L\n";
    std::cout << std::left  << std::setfill('.') << std::setw(17) << "Total fuel cost "
              << std::right << cost << "\n";
    std::cout << std::left  << std::setfill('.') << std::setw(17) << "Per traveller "
              << std::right << share << "\n";
    return 0;
}
```

</details>

**Explanation.** The guard is the honest minimum without real decisions:
one borrowed `if`, flagged in a comment — by Unit 04 you'll rewrite it
properly, and the comment is the breadcrumb. Case 3's arithmetic:
`1000 / 6 = 166.6666…` prints `166.67` (print-time rounding), then
`cost` uses the *true* value `166.6666… × 280 = 46666.66…`, printing
`46666.67`, and the share `9333.33`. Multiply the printed litres by the
price yourself and you get `46667.60` — the 93-paisa discrepancy between
*printed* and *true* values is the write-up's payoff: money columns are
rounded snapshots, not the computation.

---

<a name="lab-5--the-utility-bill-calculator"></a>
## Lab 5 — The Utility Bill Calculator ★★★

**Scenario.** A small power-distribution desk prints customer bills:
flat-rate energy plus meter rent plus government tax, formatted like the
real thing.

**Requirements.**

1. Read: customer name (a full line — spaces!), units consumed (whole),
   meter rent (decimal).
2. Rates as named constants: `ENERGY_RATE = 17.50` per unit,
   `TAX_PERCENT = 8` on the energy charge (meter rent is not taxed).
3. Print a bill block: customer line, units, energy charge, tax, meter
   rent, TOTAL — money two decimals, dot-filled labels, total on its
   own emphasised line.
4. The name `getline` must survive a junk-tolerant entry flow: units
   may be typed on the same line as… nothing — design the read order so
   the cure is provably needed, then prove it in your write-up with the
   broken transcript.

**Inputs.** name: one `getline` line · units: `int` · meter rent:
`double`. Entry order: name first, then units and rent (same line legal).

**Outputs.**

```text
Customer: Fatima Khan
Units: 320
Energy charge ...5600.00
Tax 8% ..........448.00
Meter rent ......150.00
TOTAL ..........6198.00
```

**Constraints.** units 0–9999; meter rent 0–1000; constants spelled
`constexpr double` (the [Foundations constants lesson](../cpp-foundations/lesson-2-data.md#29-constants) applies);
totals must add up *exactly* to the paisa in all test cases; name is
non-empty.

**Sample test cases.**

| # | Input lines | Expected |
| --- | --- | --- |
| 1 | `Fatima Khan` ⏎ `320 150` | 5600.00 · 448.00 · 150.00 · TOTAL 6198.00 |
| 2 | `St. John's Academy Hostel` ⏎ `0 75` | 0.00 · 0.00 · 75.00 · TOTAL 75.00 |
| 3 | `Owais` ⏎ `9999 0` | energy 174982.50 · tax 13998.60 · TOTAL 188981.10 |

**Student tasks.** (1) IPO plan *with the read order drawn as a buffer
diagram*; (2) code with named constants; (3) all three cases — case 3
stresses every digit; (4) break your own cure and capture the broken
transcript for the write-up; (5) one-paragraph answer: why is the tax
8% of the *energy charge only*, and what would the code look like if
policy changed to tax-after-rent?

**Extension challenges.** Slab tariff (first 100 @ 14, next 200 @ 18,
above @ 22) — needs decisions, borrow and label · late-payment surcharge
line (5% of total) · a second customer in one run (what survives the
buffer the second time around?).

<details markdown="1">
<summary><strong>Solution — after your own attempt is compiled and tested</strong></summary>

```cpp
// lab-5.cpp — The Utility Bill Calculator
#include <iostream>
#include <iomanip>
#include <string>

int main() {
    constexpr double ENERGY_RATE = 17.50;   // rupees per unit
    constexpr double TAX_PERCENT = 8.0;     // percent on energy charge

    std::string customer;
    int units;
    double meterRent;

    std::cout << "Customer name: " << std::endl;
    std::getline(std::cin >> ws, customer);  // first read: '>> ws' armour is harmless here

    std::cout << "Units and meter rent: " << std::endl;
    std::cin >> units >> meterRent;

    double energy = units * ENERGY_RATE;
    double tax = energy * TAX_PERCENT / 100.0;
    double total = energy + tax + meterRent;

    std::cout << std::fixed << std::setprecision(2);

    std::cout << "Customer: " << customer << "\n";
    std::cout << "Units: " << units << "\n";
    std::cout << std::left << std::setfill('.') << std::setw(16) << "Energy charge "
              << std::right << energy << "\n";
    std::cout << std::left << std::setfill('.') << std::setw(16) << "Tax 8% "
              << std::right << tax << "\n";
    std::cout << std::left << std::setfill('.') << std::setw(16) << "Meter rent "
              << std::right << meterRent << "\n";
    std::cout << std::left << std::setfill('.') << std::setw(16) << "TOTAL "
              << std::right << total << "\n";
    return 0;
}
```

</details>

**Explanation.** Name first means the *first* read is the `getline` — no
leftover newline exists yet, so the program would work bare; `>> ws` is
armour against the *menu-driven future* where this program becomes a
loop and a previous `>>` precedes it (write-up task 4 makes you prove
the fragile ordering by inverting it). Case 3 arithmetic:
9999 × 17.50 = 174982.50; tax 8% = 13998.60; total 188981.10 — the paisa
must land exactly, which is why `fixed/setprecision(2)` is set before
the first money print and never changed. The named constants mean the
policy questions in the extension are one-line edits — the whole point
of [Lesson 2 §2.9 of Foundations](../cpp-foundations/lesson-2-data.md#29-constants).

---

*[← Module home](index.md) · [Grading rubric](../grading.md#lab-rubric-all-labs) ·
[Course home](../index.md)]*
