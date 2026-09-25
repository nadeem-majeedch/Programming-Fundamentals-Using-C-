---
title: "Level 1 — Beginner Labs (L1-01 to L1-08)"
description: "Eight beginner lab scenarios on output, input, arithmetic and decisions — every lab with all fifteen parts: scenario, problem, objectives, requirements, input/output, constraints, example, test cases, tasks, hints, extensions, solution, explanation, testing checklist."
---

# Level 1 — Beginner

> [← Labs home](index.md) · **Units first: 01–04** — output, variables and arithmetic, input, decisions. No loops appear in this level; no collection is needed.

---

## L1-01 — The Canteen Receipt

### Scenario
The university canteen prints a small receipt for every order. The cashier types the item prices and quantities; the program prints the customer's receipt with the totals and change.

### Problem statement
Read the price and quantity of one item, plus the cash the customer hands over. Print a formatted receipt showing the line total, and the change due. If the cash is less than the total, print a shortfall message instead of a receipt.

### Learning objectives
- produce multi-line formatted output with `cout`
- perform multiplication and subtraction with money values
- compare two values and branch on the result

### Requirements
1. Read price (double), quantity (int), cash (double).
2. Compute the line total as price × quantity.
3. If cash ≥ total, print the full receipt and the change (cash − total).
4. If cash < total, print `"SHORTFALL: Rs "` followed by the missing amount, and no receipt.

### Input
Three values on separate lines: `price` (double, 0–1000), `quantity` (int, 1–100), `cash` (double, 0–100000).

### Output
A four-line receipt:

```text
CANTEEN RECEIPT
Item total:    Rs 450.00
Cash:          Rs 500.00
Change:        Rs  50.00
```

or `SHORTFALL: Rs 30.00`.

### Constraints
- Money prints with exactly two decimals (`fixed`, `setprecision(2)`).
- Quantity 0 or negative → print `Invalid quantity` and stop.

### Example
Input: `150`, `3`, `500` → Output: total `Rs 450.00`, cash `Rs 500.00`, change `Rs 50.00`.

### Test cases
| Input | Expected |
| --- | --- |
| 150, 3, 500 | receipt, change 50.00 |
| 150, 3, 450 | receipt, change 0.00 |
| 150, 3, 420 | SHORTFALL: Rs 30.00 |
| 150, 0, 500 | Invalid quantity |
| 999.99, 1, 1000 | receipt, change 0.01 |

### Student tasks
1. Print the program's title line.
2. Read the three values.
3. Compute the total; write the shortfall branch and test it.
4. Add the receipt branch with two-decimal formatting.
5. Add the quantity validation.

### Hints
1. `<iomanip>` gives you `fixed` and `setprecision`.
2. Compute the total *once* into a variable — never recompute inside the print.
3. The change when cash exactly equals total is `0.00` — no special case needed.

### Extension challenges
1. Read two different items and print two line totals plus a grand total.
2. Add a 5% service charge to the total before comparing with cash.

### Complete solution

```cpp
// L1-01 — The Canteen Receipt
// Compile: g++ -std=c++17 -Wall -Wextra L1-01.cpp -o L1-01
#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    double price, cash;
    int quantity;

    cout << "Item price: ";
    cin >> price;
    cout << "Quantity: ";
    cin >> quantity;
    cout << "Cash: ";
    cin >> cash;

    if (quantity <= 0) {
        cout << "Invalid quantity\n";
        return 1;
    }

    double total = price * quantity;

    if (cash < total) {
        cout << "SHORTFALL: Rs " << fixed << setprecision(2) << total - cash << "\n";
        return 0;
    }

    cout << "CANTEEN RECEIPT\n";
    cout << "Item total:    Rs " << fixed << setprecision(2) << total << "\n";
    cout << "Cash:          Rs " << cash << "\n";
    cout << "Change:        Rs " << cash - total << "\n";
    return 0;
}
```

### Solution explanation
The program computes `total` once and branches on the *comparison result*, not on recomputed values — the single-source-of-truth habit. The formatting stream flags (`fixed` + `setprecision(2)`) persist on `cout` after the first use, so later money prints stay two-decimal automatically. The quantity check happens *before* any money maths: refuse invalid data at the cheapest layer (the Robustness module's boundary rule, in beginner form).

### Testing checklist
- [ ] All five test cases produce the expected output
- [ ] Money always shows two decimals
- [ ] Quantity 0 prints the message and no receipt
- [ ] Exact cash prints change `0.00` (no negative)

---

## L1-02 — The Student ID Card

### Scenario
The registrar's office prints student ID cards. A clerk types a student's details; the program lays them out in a fixed-width card.

### Problem statement
Read a student's name, roll number, programme, and semester. Print an ID card with labelled, right-aligned fields inside a border.

### Learning objectives
- read a whole line of text with `getline`
- mix line input and formatted output
- lay out text in fixed-width fields with `setw`

### Requirements
1. Read name (full line, may contain spaces), roll number (string), programme (string), semester (int).
2. Print the card exactly as in the Example: `+` corners, `|` edges, fields left-aligned in width 20 after the label column.
3. The semester prints as `Semester N`.

### Input
Name on one line; then roll, programme, semester — each on its own line.

### Output

```text
+----------------------+
| Name:      Aisha Khan|
| Roll:      2024-017  |
| Programme: BS DataSci |
| Semester:  3          |
+----------------------+
```

### Constraints
- Use `getline` for name and programme; `>>` for the number.
- Field width for values: 14 characters, left-aligned.

### Example
Input: `Aisha Khan`, `2024-017`, `BS DataSci`, `3` → the card above.

### Test cases
| Input | Expected |
| --- | --- |
| Aisha Khan / 2024-017 / BS DataSci / 3 | card as above |
| A very long name here / 2024-999 / BSc / 1 | fields overflow the width (accepted: columns shift) |
| Ali / x / y / 8 | card prints with the given values |

### Student tasks
1. Print the top border.
2. Read all four fields in the right order (mind the `>>`/`getline` mixing).
3. Print the four labelled rows with `left` and `setw`.
4. Print the bottom border.

### Hints
1. `cin >> semester` leaves the newline — that's why name is read *first*, or `cin.ignore` is needed after it.
2. `left << setw(14)` aligns the value column; apply it per field.
3. Border and rows must use the same total width or the card looks crooked — count the characters once, in a comment.

### Extension challenges
1. Add a fifth row: the card's issue date, typed by the clerk.
2. Print two cards side by side (read two students).

### Complete solution

```cpp
// L1-02 — The Student ID Card
// Compile: g++ -std=c++17 -Wall -Wextra L1-02.cpp -o L1-02
#include <iostream>
#include <iomanip>
#include <string>
using namespace std;

int main() {
    string name, roll, programme;
    int semester;

    cout << "Name: ";
    getline(cin, name);
    cout << "Roll number: ";
    getline(cin, roll);
    cout << "Programme: ";
    getline(cin, programme);
    cout << "Semester: ";
    cin >> semester;

    const int W = 14;                       // value-column width

    cout << "+----------------------+\n";
    cout << "| " << left << setw(9) << "Name:"     << setw(W) << name      << "|\n";
    cout << "| " << left << setw(9) << "Roll:"     << setw(W) << roll      << "|\n";
    cout << "| " << left << setw(9) << "Programme:" << setw(W) << programme << "|\n";
    cout << "| " << left << setw(9) << "Semester:" << setw(W) << ("Semester " + to_string(semester)) << "|\n";
    cout << "+----------------------+\n";
    return 0;
}
```

### Solution explanation
The card is *two columns*: a 9-wide label column and a 14-wide value column, then the closing edge — the widths in the code are chosen once and reused, so the border and the rows can't drift apart. The requirement to read the name with `getline` (names contain spaces) puts the `>>`/`getline` mixing problem on the table early: because the number is read *last*, no `cin.ignore` dance is needed — reading order is itself a design decision. `to_string(semester)` lets the semester row use the same string machinery as the rest.

### Testing checklist
- [ ] The example input produces the exact card
- [ ] A name with spaces prints whole (no truncation at the first space)
- [ ] The four value columns align in one vertical line
- [ ] No leftover-prompt weirdness between the four reads

---

## L1-03 — The Temperature Desk

### Scenario
The campus weather board converts between Celsius and Fahrenheit for display. The desk operator enters a value and the direction of conversion.

### Problem statement
Read a temperature and a direction (`C` = the value is Celsius, convert to Fahrenheit; `F` = the value is Fahrenheit, convert to Celsius). Print the converted value with one decimal. Any other direction letter is refused.

### Learning objectives
- read a single character choice with `cin >> char`
- apply a formula per branch
- validate a choice and refuse politely

### Requirements
1. Read the value (double) and the direction (char).
2. `C` → print Fahrenheit: F = C × 9/5 + 32.
3. `F` → print Celsius: C = (F − 32) × 5/9.
4. Any other direction → print `Unknown direction` and stop.
5. Values below absolute zero (−273.15 °C / −459.67 °F) are refused with `Below absolute zero`.

### Input
`value` (double) then `direction` (single char `C` or `F`).

### Output
`100 C = 212.0 F` — or the refusal messages.

### Constraints
- One decimal place (`fixed`, `setprecision(1)`).
- Both formulas must use the same formatting.

### Example
Input: `100`, `C` → `100.0 C = 212.0 F`.

### Test cases
| Input | Expected |
| --- | --- |
| 100 C | 100.0 C = 212.0 F |
| 212 F | 212.0 F = 100.0 C |
| 0 C | 0.0 C = 32.0 F |
| -40 C | -40.0 C = -40.0 F |
| 50 X | Unknown direction |
| -300 C | Below absolute zero |

### Student tasks
1. Read value and direction.
2. Write the two conversion branches.
3. Add the unknown-direction refusal.
4. Add the absolute-zero checks (note: the limit differs per direction).

### Hints
1. Write `9.0 / 5.0` — `9 / 5` is integer division and equals 1 (the foundations module's truncation trap).
2. The −273.15 test applies to the *Celsius reading*; convert the Fahrenheit limit before comparing.
3. One `if / else if / else` ladder is enough — no nesting.

### Extension challenges
1. Add `K` (Kelvin) with K = C + 273.15.
2. Loop the desk until the operator types `Q` (peeks at Level 2).

### Complete solution

```cpp
// L1-03 — The Temperature Desk
// Compile: g++ -std=c++17 -Wall -Wextra L1-03.cpp -o L1-03
#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    double value;
    char direction;

    cout << "Temperature value: ";
    cin >> value;
    cout << "Direction (C/F): ";
    cin >> direction;

    cout << fixed << setprecision(1);

    if (direction == 'C') {
        if (value < -273.15) { cout << "Below absolute zero\n"; return 1; }
        cout << value << " C = " << value * 9.0 / 5.0 + 32.0 << " F\n";
    } else if (direction == 'F') {
        if (value < -459.67) { cout << "Below absolute zero\n"; return 1; }
        cout << value << " F = " << (value - 32.0) * 5.0 / 9.0 << " C\n";
    } else {
        cout << "Unknown direction\n";
    }
    return 0;
}
```

### Solution explanation
The ladder checks direction, then each branch checks *its own* physical limit — the two limits live in their branches because they belong to different scales. The formula uses floating constants throughout (`9.0 / 5.0`), avoiding the integer-division trap the foundations module demonstrated. The output line is composed in one statement per branch so the value and its unit always travel together — a tiny inversion of the "format once" habit that keeps unit and number from drifting.

### Testing checklist
- [ ] All six test cases pass
- [ ] −40 converts to −40 in both directions (the classic crossover)
- [ ] One decimal everywhere
- [ ] Lowercase `c` prints `Unknown direction` (case-sensitivity is documented behaviour)

---

## L1-04 — Market Money

### Scenario
A fruit seller at the campus gate sells three fruits at fixed rates: apples Rs 120/kg, bananas Rs 60/dozen, oranges Rs 90/kg. At day's end the seller wants a takings summary for one customer's basket.

### Problem statement
Read the kilograms of apples, dozens of bananas, and kilograms of oranges a customer buys. Print each line's cost and the bill total. A 2% market-fee discount applies to bills of Rs 1000 or more.

### Learning objectives
- compute with named constants instead of magic numbers
- sum several line computations
- apply a conditional rate

### Requirements
1. Three `const double` rates at the top: `APPLES_PER_KG = 120`, `BANANAS_PER_DOZEN = 60`, `ORANGES_PER_KG = 90`.
2. Read three quantities (doubles ≥ 0).
3. Print each line as `Apples (2.5 kg): Rs 300.00`.
4. Print the total; if total ≥ 1000, print a `Market fee discount (2%): Rs X` line and the discounted total.

### Input
Three doubles on separate lines: kg apples, dozens bananas, kg oranges.

### Output
Three item lines, a `TOTAL:` line, and — conditionally — the discount and final lines.

### Constraints
- Negative quantity → `Invalid quantity` and stop.
- Two-decimal money formatting throughout.

### Example
Input: `2.5`, `2`, `3` → apples 300.00, bananas 120.00, oranges 270.00, TOTAL 690.00 (no discount).

### Test cases
| Input | Expected |
| --- | --- |
| 2.5, 2, 3 | total 690.00, no discount |
| 5, 5, 5 | total 1290.00, discount 25.80, final 1264.20 |
| 0, 0, 0 | three Rs 0.00 lines, total 0.00 |
| −1, 2, 3 | Invalid quantity |
| 8.333, 0, 0 | apples 999.96, no discount (boundary probe) |

### Student tasks
1. Write the three named constants.
2. Read the three quantities with validation.
3. Compute and print the three lines.
4. Sum, print the total, add the discount branch.

### Hints
1. The discount comparison uses the *undiscounted* total.
2. One `double total = a + b + c;` — then the branch reads the variable.
3. `fixed << setprecision(2)` once, before the first print.

### Extension challenges
1. Add a fourth fruit with its own rate.
2. Print the percentage each fruit contributes to the total.

### Complete solution

```cpp
// L1-04 — Market Money
// Compile: g++ -std=c++17 -Wall -Wextra L1-04.cpp -o L1-04
#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    const double APPLES_PER_KG    = 120.0;
    const double BANANAS_PER_DOZEN = 60.0;
    const double ORANGES_PER_KG   = 90.0;
    const double DISCOUNT_RATE    = 0.02;
    const double DISCOUNT_MINIMUM = 1000.0;

    double kgApples, dozenBananas, kgOranges;
    cout << "Apples (kg): ";
    cin >> kgApples;
    cout << "Bananas (dozen): ";
    cin >> dozenBananas;
    cout << "Oranges (kg): ";
    cin >> kgOranges;

    if (kgApples < 0 || dozenBananas < 0 || kgOranges < 0) {
        cout << "Invalid quantity\n";
        return 1;
    }

    double apples  = kgApples * APPLES_PER_KG;
    double bananas = dozenBananas * BANANAS_PER_DOZEN;
    double oranges = kgOranges * ORANGES_PER_KG;
    double total   = apples + bananas + oranges;

    cout << fixed << setprecision(2);
    cout << "Apples ("  << kgApples    << " kg):    Rs " << apples  << "\n";
    cout << "Bananas (" << dozenBananas << " dozen): Rs " << bananas << "\n";
    cout << "Oranges (" << kgOranges   << " kg):    Rs " << oranges << "\n";
    cout << "TOTAL:               Rs " << total   << "\n";

    if (total >= DISCOUNT_MINIMUM) {
        double discount = total * DISCOUNT_RATE;
        cout << "Market fee discount (2%): Rs " << discount << "\n";
        cout << "FINAL:               Rs " << total - discount << "\n";
    }
    return 0;
}
```

### Solution explanation
Every rate is a named constant — the day the seller changes the apple rate, one line changes, and the constant's name documents the unit. The discount branch reads the already-computed total and compares against the *named* minimum, so the business rule (`2%` over `1000`) is legible in code. Validation precedes arithmetic: no line items are printed on invalid input.

### Testing checklist
- [ ] All five test cases pass
- [ ] The 999.96 probe stays undiscounted (the boundary belongs to ≥ 1000)
- [ ] Zero quantities produce zero lines, not an error
- [ ] Changing `APPLES_PER_KG` to 130 changes only apple lines

---

## L1-05 — The Cinema Pass

### Scenario
The campus cinema sells student passes with age-based pricing: under 12 pays Rs 300, 12–17 pays Rs 450, 18–25 pays Rs 600, 26–59 pays Rs 800, 60 and above pays Rs 400 (senior concession). A valid student ID takes Rs 50 off any price.

### Problem statement
Read an age and a student-ID flag (`y`/`n`), compute the ticket price from the age ladder, apply the student discount, and print the price. Refuse ages outside 3–120.

### Learning objectives
- build an `if / else if` ladder from a boundary table
- combine a ladder result with a further conditional
- map a rule table to code without gaps or overlaps

### Requirements
1. Age ladder exactly as in the Scenario (note 60+ *resets* cheaper — ladder order matters).
2. Student flag `y` subtracts 50 from the ladder price; `n` changes nothing; other letters refuse with `Invalid flag`.
3. Age below 3 or above 120 → `Invalid age`.
4. Print `Ticket price: Rs X` (whole rupees).

### Input
Age (int), then flag (char).

### Output
The price line, or the refusal.

### Constraints
- The ladder must cover 3–120 with no gaps (test 4, 12, 17, 18, 25, 26, 59, 60).

### Example
Input: `22`, `y` → ladder 600, student −50 → `Ticket price: Rs 550`.

### Test cases
| Input | Expected |
| --- | --- |
| 22, y | Rs 550 |
| 22, n | Rs 600 |
| 10, n | Rs 300 |
| 12, n | Rs 450 (12 is in the second band) |
| 17, n | Rs 450 |
| 18, n | Rs 600 |
| 60, n | Rs 400 |
| 59, n | Rs 800 |
| 2, n | Invalid age |
| 22, z | Invalid flag |

### Student tasks
1. Write the boundary table as a comment.
2. Validate the age first.
3. Build the ladder; store the price in one variable.
4. Apply the flag discount to the variable; print once.

### Hints
1. Ladder from the youngest band upward — each `else if` only needs the *lower* bound (`age <= 11`, then `age <= 17`, ...).
2. Exactly one branch of the ladder runs; the print happens *after* the ladder, not inside each branch.
3. The flag check is independent of the ladder — two separate decisions.

### Extension challenges
1. Add a Tuesday half-price rule that runs before the ladder (then the ladder prices are halved).
2. Print which band the customer fell into, alongside the price.

### Complete solution

```cpp
// L1-05 — The Cinema Pass
// Compile: g++ -std=c++17 -Wall -Wextra L1-05.cpp -o L1-05
#include <iostream>
using namespace std;

int main() {
    // Boundary table: 3-11 Rs300 | 12-17 Rs450 | 18-25 Rs600 | 26-59 Rs800 | 60-120 Rs400
    int age;
    char studentFlag;

    cout << "Age: ";
    cin >> age;
    cout << "Student ID (y/n): ";
    cin >> studentFlag;

    if (age < 3 || age > 120) {
        cout << "Invalid age\n";
        return 1;
    }

    int price;
    if (age <= 11)      price = 300;
    else if (age <= 17) price = 450;
    else if (age <= 25) price = 600;
    else if (age <= 59) price = 800;
    else                price = 400;      // 60+: the senior concession band

    if (studentFlag == 'y' || studentFlag == 'Y') {
        price -= 50;
    } else if (studentFlag != 'n' && studentFlag != 'N') {
        cout << "Invalid flag\n";
        return 1;
    }

    cout << "Ticket price: Rs " << price << "\n";
    return 0;
}
```

### Solution explanation
The ladder encodes the boundary table top-down, each branch guarding only its *upper* edge because the previous branch eliminated the lower ones — the boundary rows of the test table (12 vs 11, 60 vs 59) are exactly the edges the ladder encodes. The price is computed into one variable and printed once, after both decisions, so the output code exists once. Accepting both cases of `y`/`n` while refusing anything else shows the "validate the input vocabulary, not just the range" habit.

### Testing checklist
- [ ] All ten test cases pass, especially the eight boundary probes
- [ ] Student discount applies to every band
- [ ] Invalid flag produces no price line
- [ ] One price line per successful run

---

## L1-06 — The Load Shedding Checker

### Scenario
The hostel displays a daily load-shedding board: each day of the week has a fixed outage slot (start hour and duration). A student types a day number and an hour to ask "will there be power at hour H on day D?"

### Problem statement
Read a day number (1–7, Monday=1) and an hour (0–23). Look up the day's outage start and duration from a `switch`, and report whether power is on at that hour. The outage spans `[start, start + duration)`. Refuse invalid days and hours.

### Learning objectives
- use `switch` on an integer with grouped cases
- express a range membership test (`start <= h && h < start + duration`)
- validate two inputs with distinct messages

### Requirements
1. Outage table (hours, duration): Mon 6–2, Tue 8–2, Wed 10–2, Thu 6–2, Fri 8–3, Sat 14–3, Sun 0–0 (no outage).
2. Day outside 1–7 → `Invalid day`; hour outside 0–23 → `Invalid hour`.
3. Output `Power OFF at hour H (day D)` or `Power ON at hour H (day D)`.
4. Sunday (duration 0) is always `Power ON`.

### Input
Day (int), hour (int).

### Output
One status line or one refusal.

### Constraints
- The outage interval is half-open: start hour is OFF, `start + duration` is ON again.
- Use `switch` for the table (that is the point of the lab).

### Example
Day 1, hour 7 → Monday starts 6 for 2 hours → `Power OFF at hour 7 (day 1)`.

### Test cases
| Input | Expected |
| --- | --- |
| 1, 7 | Power OFF at hour 7 (day 1) |
| 1, 8 | Power ON (6+2 = 8 is outside) |
| 1, 6 | Power OFF (start is inside) |
| 5, 10 | Power OFF (Fri 8–11) |
| 5, 11 | Power ON |
| 7, 3 | Power ON (Sunday) |
| 8, 3 | Invalid day |
| 3, 24 | Invalid hour |

### Student tasks
1. Write the table as a comment above the switch.
2. Validate day, then hour.
3. Build the switch: group Mon/Thu, Tue, Wed, Fri, Sat, Sun — each branch computing start and duration into two variables.
4. After the switch, run the half-open interval test once.

### Hints
1. `case 1: case 4:` groups Monday with Thursday — one body, two labels.
2. `default:` is the Invalid-day branch — no separate if needed.
3. The interval test `h >= start && h < start + duration` — the second comparison is strict.

### Extension challenges
1. Add a second evening slot for Wednesday (20–1) and test the hour 20 boundary.
2. Print the day's name alongside the status (a second switch or a lookup).

### Complete solution

```cpp
// L1-06 — The Load Shedding Checker
// Compile: g++ -std=c++17 -Wall -Wextra L1-06.cpp -o L1-06
#include <iostream>
using namespace std;

int main() {
    // Outage table: day -> (start, duration): 1:(6,2) 2:(8,2) 3:(10,2)
    //                                  4:(6,2) 5:(8,3) 6:(14,3) 7:(0,0)
    int day, hour;
    cout << "Day (1-7): ";
    cin >> day;
    cout << "Hour (0-23): ";
    cin >> hour;

    if (day < 1 || day > 7) { cout << "Invalid day\n";  return 1; }
    if (hour < 0 || hour > 23) { cout << "Invalid hour\n"; return 1; }

    int start = 0, duration = 0;              // Sunday's values; every case overwrites
    switch (day) {
        case 1: case 4: start = 6;  duration = 2; break;
        case 2:         start = 8;  duration = 2; break;
        case 3:         start = 10; duration = 2; break;
        case 5:         start = 8;  duration = 3; break;
        case 6:         start = 14; duration = 3; break;
        case 7:         start = 0;  duration = 0; break;
    }

    bool powerOn = !(hour >= start && hour < start + duration);
    cout << (powerOn ? "Power ON" : "Power OFF")
         << " at hour " << hour << " (day " << day << ")\n";
    return 0;
}
```

### Solution explanation
The table lives in the `switch`, the *logic* lives after it: the switch's only job is to translate a day number into two numbers, and the interval test runs once for all days — separating data lookup from logic is the modular habit in one file. Sunday falls out naturally: its `start=0, duration=0` makes the interval empty, so `powerOn` is true with no special case. Every branch `break`s — the fallthrough hazard is deliberately absent, and the grouped `case 1: case 4:` shows grouping as a feature, not an accident.

### Testing checklist
- [ ] All eight test cases pass, including both edges of each interval
- [ ] Hour 0 and 23 are accepted
- [ ] Sunday answers ON at every hour
- [ ] Invalid day and invalid hour produce distinct messages

---

## L1-07 — The Admission Desk

### Scenario
The Data Science department admits applicants by three criteria: intermediate marks at least 60%, entry test at least 50, and age at most 23 (25 for a Hafiz-e-Quran). Each criterion is a gate; the desk prints which gates passed and the final verdict.

### Problem statement
Read marks percentage, entry-test score, age, and a Hafiz flag (`y`/`n`). Print each criterion as PASS/FAIL, then `ADMITTED` only if all pass, else `NOT ADMITTED` with the count of failed gates.

### Learning objectives
- evaluate compound conditions with `&&`
- report each component condition separately *and* the combined result
- derive a limit from a flag (the age ceiling)

### Requirements
1. Marks ≥ 60 → PASS else FAIL; test ≥ 50 → PASS else FAIL; age ≤ limit → PASS else FAIL where limit = 23, or 25 when Hafiz is `y`.
2. Print three criterion lines, then the verdict.
3. The Hafiz flag affects *only* the age gate.
4. Any percentage outside 0–100 → `Invalid percentage`; test score outside 0–100 → `Invalid score`.

### Input
Percentage (double), test score (int), age (int), hafiz (char).

### Output
```text
Marks:     PASS
Test:      PASS
Age:       PASS
ADMITTED
```
or the same with FAIL lines and `NOT ADMITTED (2 gates failed)`.

### Constraints
- Validation before evaluation.
- The verdict line counts failures only for the three gates.

### Example
Input: `58`, `72`, `21`, `n` → Marks FAIL, Test PASS, Age PASS → `NOT ADMITTED (1 gate failed)`.

### Test cases
| Input | Expected |
| --- | --- |
| 85, 72, 21, n | three PASS, ADMITTED |
| 58, 72, 21, n | Marks FAIL, NOT ADMITTED (1 gate failed) |
| 60, 50, 23, n | three PASS (all boundaries), ADMITTED |
| 90, 80, 24, y | three PASS (Hafiz ceiling), ADMITTED |
| 90, 80, 24, n | Age FAIL, NOT ADMITTED (1 gate failed) |
| 40, 30, 30, n | three FAIL, NOT ADMITTED (3 gates failed) |
| 120, 50, 20, n | Invalid percentage |

### Student tasks
1. Read and validate the percentage and score.
2. Compute the age limit from the flag.
3. Evaluate the three booleans into named variables.
4. Print the three lines, then count and print the verdict.

### Hints
1. `bool marksOk = marks >= 60.0;` — name the conditions; the printing and the counting both use the names.
2. The count is `(marksOk ? 0 : 1) + (testOk ? 0 : 1) + (ageOk ? 0 : 1)` — or three ifs incrementing a counter (that's fine here too).
3. The Hafiz ceiling change happens where the limit is computed — not inside the age comparison.

### Extension challenges
1. Add a fourth gate: a passing grade in intermediate mathematics (typed `y`/`n`).
2. Print "provisional" instead of refused when exactly one gate failed and it was the test.

### Complete solution

```cpp
// L1-07 — The Admission Desk
// Compile: g++ -std=c++17 -Wall -Wextra L1-07.cpp -o L1-07
#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    double marks;
    int testScore, age;
    char hafiz;

    cout << "Percentage: ";
    cin >> marks;
    if (marks < 0 || marks > 100) { cout << "Invalid percentage\n"; return 1; }
    cout << "Test score: ";
    cin >> testScore;
    if (testScore < 0 || testScore > 100) { cout << "Invalid score\n"; return 1; }
    cout << "Age: ";
    cin >> age;
    cout << "Hafiz-e-Quran (y/n): ";
    cin >> hafiz;

    int ageLimit = (hafiz == 'y' || hafiz == 'Y') ? 25 : 23;

    bool marksOk = marks >= 60.0;
    bool testOk  = testScore >= 50;
    bool ageOk   = age <= ageLimit;

    cout << fixed << setprecision(0);
    cout << "Marks:     " << (marksOk ? "PASS" : "FAIL") << "\n";
    cout << "Test:      " << (testOk  ? "PASS" : "FAIL") << "\n";
    cout << "Age:       " << (ageOk   ? "PASS" : "FAIL") << "\n";

    int failed = (marksOk ? 0 : 1) + (testOk ? 0 : 1) + (ageOk ? 0 : 1);
    if (failed == 0)
        cout << "ADMITTED\n";
    else
        cout << "NOT ADMITTED (" << failed << (failed == 1 ? " gate failed" : " gates failed") << ")\n";
    return 0;
}
```

### Solution explanation
Each gate is evaluated once into a named boolean — the printing, counting, and verdict all consume the *names*, so the criteria are stated exactly once. The age limit is *derived* from the flag before any comparison, keeping the Hafiz rule in one place. The singular/plural suffix expression shows conditional text built from data rather than duplicated verdict lines. Compound conditions (`||`) appear in validation and flag handling; the three gates themselves stay simple comparisons — the lab's lesson is naming and structuring conditions, not nesting them.

### Testing checklist
- [ ] All seven test cases pass, including the all-boundaries case
- [ ] The Hafiz ceiling applies only to the age gate
- [ ] Singular vs plural count text is correct
- [ ] Invalid inputs print one message and stop

---

## L1-08 — The Word Wizard

### Scenario
The writing centre analyses one line of student prose at a time: length, word count, vowel count, and uppercase-letter count, as quick style feedback.

### Problem statement
Read one full line of text. Print its character count, word count, vowel count, and uppercase count. An empty line reports all zeros.

### Learning objectives
- read a whole line with `getline` (including the empty line)
- visit each character of a string with a range-based `for`
- classify characters with `<cctype>` and comparisons

### Requirements
1. Count characters (including spaces), words (runs of non-space), vowels (`a e i o u`, both cases), uppercase letters (`A`–`Z`).
2. Print four lines: `Characters: N`, `Words: N`, `Vowels: N`, `Uppercase: N`.
3. Words are separated by single or multiple spaces; leading/trailing spaces don't create words.
4. No loops *beyond* the character loop are needed — one pass, four counters.

### Input
One line (may be empty, may contain spaces and punctuation).

### Output
The four labelled counts.

### Constraints
- Punctuation is not a word separator (only whitespace is).
- `getline` must capture the empty line correctly.

### Example
Input: `Hello World from PUCIT` → Characters: 22, Words: 4, Vowels: 6, Uppercase: 2.

### Test cases
| Input | Expected |
| --- | --- |
| Hello World from PUCIT | 22, 4, 6, 2 |
| (empty line) | 0, 0, 0, 0 |
|    spaced   out   | Characters 17, Words 2, Vowels 3, Uppercase 0 |
| AEIOU aeiou | 12, 2, 10, 5 |
| C++ is #1! | 11, 3, 1, 1 |

### Student tasks
1. Read the line with `getline`.
2. Print the character count (`line.size()`).
3. Add the vowel and uppercase counters in one pass.
4. Add the word counter with the edge-of-word technique.

### Hints
1. `tolower(static_cast<unsigned char>(ch))` — cast first (the strings module's rule), then compare against `'a'`…`'u'` or test membership in `"aeiou"`.
2. Word counting: a word *starts* when a non-space follows a space (or the line's beginning) — count those edges, not characters.
3. `bool inWord = false;` before the loop; flip it and count on entry.

### Extension challenges
1. Also count digits and punctuation marks (two more counters, same pass).
2. Print the longest word found (a second scan or a running candidate).

### Complete solution

```cpp
// L1-08 — The Word Wizard
// Compile: g++ -std=c++17 -Wall -Wextra L1-08.cpp -o L1-08
#include <iostream>
#include <string>
#include <cctype>
using namespace std;

int main() {
    cout << "Enter a line: ";
    string line;
    getline(cin, line);

    int vowels = 0, uppercase = 0, words = 0;
    bool inWord = false;

    for (char ch : line) {
        unsigned char u = static_cast<unsigned char>(ch);
        char lower = static_cast<char>(tolower(u));

        if (lower == 'a' || lower == 'e' || lower == 'i' || lower == 'o' || lower == 'u')
            ++vowels;
        if (isupper(u))
            ++uppercase;

        if (isspace(u)) {
            inWord = false;
        } else if (!inWord) {
            ++words;                    // the edge where a word begins
            inWord = true;
        }
    }

    cout << "Characters: " << line.size() << "\n";
    cout << "Words: "      << words      << "\n";
    cout << "Vowels: "     << vowels     << "\n";
    cout << "Uppercase: "  << uppercase  << "\n";
    return 0;
}
```

### Solution explanation
One pass, four independent counters — the structure teaches that a single traversal can serve several analyses, and that each classification (`tolower` + vowel test, `isupper`, the word-edge flip) is independent logic on the same character. The `unsigned char` cast before `<cctype>` functions applies the strings module's documented rule. The word-edge technique (`!inWord` on entry to a non-space run) counts *words*, not spaces — the multiple-space and padding test cases are exactly the cases a "count the spaces + 1" solution fails.

### Testing checklist
- [ ] All five test cases pass, including the empty line and the padded line
- [ ] Punctuation does not split words
- [ ] Vowel count is case-insensitive; uppercase count is not
- [ ] One pass only (no second scan of the string)

---

[← Labs home](index.md) · Continue to [Level 2 — Basic](level-2.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
