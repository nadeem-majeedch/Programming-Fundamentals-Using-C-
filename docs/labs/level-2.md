---
title: "Level 2 — Basic Labs (L2-09 to L2-16)"
description: "Eight basic lab scenarios on menus, validation, sentinel and counted loops, digit processing and patterns — every lab with all fifteen parts."
---

# Level 2 — Basic

> [← Labs home](index.md) · [← Level 1](level-1.md) · **Units first: 04–06** — decisions are assumed; this level adds `while`/`do-while`/`for`, sentinels, counters, and nested loops.

---

## L2-09 — The Menu Canteen

### Scenario
The canteen from [L1-01](level-1.md#l1-01--the-canteen-receipt) upgrades to an ordering terminal: the customer keeps adding items from a menu until they choose to check out.

### Problem statement
Display a three-item menu with prices (Samosa Rs 40, Sandwich Rs 120, Chai Rs 60) in a `do-while` loop. Each order line asks which item (1–3) and how many; accumulate the total. Choice 0 checks out and prints the bill; anything else re-prompts.

### Learning objectives
- drive a program with a `do-while` menu loop
- accumulate a total across iterations
- validate a menu choice and re-prompt without crashing

### Requirements
1. Menu prints at the top of every iteration; choice 0 ends the loop.
2. Quantity must be ≥ 1; a bad quantity re-prompts the quantity only.
3. The final bill lists each item's accumulated quantity and cost, then the grand total.
4. Zero items ordered prints `No items ordered` instead of a bill.

### Input
Menu choice (int) per round; quantity (int) when choice is 1–3.

### Output
The running menu; at checkout, the itemised bill.

### Constraints
- The loop must run at least once (`do-while` — the customer sees the menu before any choice).
- No arrays yet — track the three totals with three variables.

### Example
Choices: 1×2, 3×1, 0 → bill: Samosa 2 = Rs 80, Chai 1 = Rs 60, TOTAL Rs 140.

### Test cases
| Input sequence | Expected |
| --- | --- |
| 1,2 · 3,1 · 0 | Samosa 80, Chai 60, TOTAL 140 |
| 0 | No items ordered |
| 9 then 0 | choice 9 re-prompts, then clean checkout |
| 2,1 · 2,1 · 0 | Sandwich 2 = 240, TOTAL 240 |
| 1,0 then 1,2 then 0 | quantity 0 re-prompts, then Samosa 2 |

### Student tasks
1. Write the menu-printing helper block inside the loop.
2. Accumulate `samosas`, `sandwiches`, `chais` with a `switch` on choice.
3. Add the checkout: print the three item lines conditionally (only nonzero) and the total.
4. Add choice and quantity validation.

### Hints
1. `do { ... } while (choice != 0);` — read `choice` at the *end* of the body.
2. Three accumulator variables, one `switch` — arrays would be nicer but come in Level 3.
3. Print an item's bill line only if its accumulator is nonzero.

### Extension challenges
1. Add a fourth item; count how many lines of the program change (then imagine 20 items).
2. Apply the canteen's 5% service charge on bills over Rs 500.

### Complete solution

```cpp
// L2-09 — The Menu Canteen
// Compile: g++ -std=c++17 -Wall -Wextra L2-09.cpp -o L2-09
#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    const double SAMOSA = 40.0, SANDWICH = 120.0, CHAI = 60.0;

    int samosas = 0, sandwiches = 0, chais = 0;
    int choice, qty;

    do {
        cout << "\n=== CANTEEN MENU ===\n"
             << "1. Samosa    Rs " << SAMOSA << "\n"
             << "2. Sandwich  Rs " << SANDWICH << "\n"
             << "3. Chai      Rs " << CHAI << "\n"
             << "0. Check out\n"
             << "Choice: ";
        cin >> choice;

        if (choice >= 1 && choice <= 3) {
            cout << "Quantity: ";
            cin >> qty;
            while (qty < 1) {
                cout << "Quantity must be at least 1: ";
                cin >> qty;
            }
            if (choice == 1)      samosas    += qty;
            else if (choice == 2) sandwiches += qty;
            else                  chais      += qty;
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    cout << fixed << setprecision(2);
    double total = samosas * SAMOSA + sandwiches * SANDWICH + chais * CHAI;

    if (samosas + sandwiches + chais == 0) {
        cout << "No items ordered\n";
        return 0;
    }

    cout << "\n=== BILL ===\n";
    if (samosas > 0)    cout << "Samosa x"   << samosas    << " = Rs " << samosas * SAMOSA    << "\n";
    if (sandwiches > 0) cout << "Sandwich x" << sandwiches << " = Rs " << sandwiches * SANDWICH << "\n";
    if (chais > 0)      cout << "Chai x"     << chais      << " = Rs " << chais * CHAI        << "\n";
    cout << "TOTAL: Rs " << total << "\n";
    return 0;
}
```

### Solution explanation
The `do-while` guarantees the menu appears before the first choice — the while-form would need a pre-loop print or a dummy choice. Validation is *local*: a bad choice loops back to the menu, a bad quantity loops only the quantity read — each invalid input re-asks the narrowest possible question, which is the validation shape every later menu adopts. The accumulators and the bill's conditional lines keep the output honest (no `Samosa x0` rows), and the three-variable approach is deliberately pre-array: its clumsiness with four items is the motivation Level 3's collections answer.

### Testing checklist
- [ ] All five sequences produce the expected bills
- [ ] The menu re-prints after every round including invalid choices
- [ ] Quantity 0 or negative re-prompts without losing the choice
- [ ] Checkout with zero items prints the message, not `TOTAL: Rs 0.00`

---

## L2-10 — The Fee Counter

### Scenario
The accounts office collects semester-fee instalments at a window. Payments arrive one after another; the clerk types each amount and ends the batch with a sentinel value of `0`.

### Problem statement
Read payment amounts until `0` is entered. Print the number of payments, the total collected, the average, the largest payment, and the smallest payment. A `0` as the *first* entry means the batch is empty.

### Learning objectives
- build a sentinel-controlled `while` loop (the read goes in the condition)
- track running totals, count, maximum, and minimum in one pass
- guard every statistic against the empty batch

### Requirements
1. Sentinel is `0`; it is *not* a payment and not counted.
2. Payments must be positive; a negative or zero value that is *not* the intended sentinel re-prompts (hint: read, then test).
3. Empty batch prints `No payments entered` and stops.
4. Average prints two decimals; money values print two decimals.

### Input
One double per line, terminated by `0`.

### Output
`Payments: N`, `Total: Rs X`, `Average: Rs X`, `Largest: Rs X`, `Smallest: Rs X`.

### Constraints
- `while (cin >> amount && amount != 0)` — or an explicit read-test-update loop; `eof()` must not appear.
- One pass only: no second loop over stored values (no arrays yet).

### Example
Input: `25000`, `18000.5`, `40000`, `0` → Payments: 3, Total: 83000.50, Average: 27666.83, Largest: 40000.00, Smallest: 18000.50.

### Test cases
| Input | Expected |
| --- | --- |
| 25000, 18000.5, 40000, 0 | the example output |
| 0 | No payments entered |
| 1, 0 | Payments 1, all values 1.00 |
| −5 then 100 then 0 | −5 re-prompts, then Payment 1, Total 100 |
| 100, 100, 0 | Largest = Smallest = 100.00 |

### Student tasks
1. Write the read-test-update loop with the sentinel.
2. Maintain `count` and `total`.
3. Initialise `largest`/`smallest` from the *first* real payment, then update on each later one.
4. Add the empty-batch guard and the formatting.

### Hints
1. First-payment initialisation: a `bool first = true;` flag set false after the first accepted payment.
2. `largest = max(largest, amount)` needs `<algorithm>` — or a plain `if`. Both fine.
3. The average divides by `count`, never by a remembered input.

### Extension challenges
1. Also report how many payments exceeded the average (requires storing or a second pass — think about which, and why storing wins here).
2. Print the running total after each payment.

### Complete solution

```cpp
// L2-10 — The Fee Counter
// Compile: g++ -std=c++17 -Wall -Wextra L2-10.cpp -o L2-10
#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    double amount;
    int count = 0;
    double total = 0.0, largest = 0.0, smallest = 0.0;
    bool first = true;

    cout << "Payment (0 to finish): ";
    while (cin >> amount && amount != 0) {
        while (amount < 0) {
            cout << "Payments are positive. Again: ";
            if (!(cin >> amount) || amount == 0) break;   // sentinel honoured mid-repair
        }
        if (amount == 0) break;

        if (first) {
            largest = smallest = amount;   // the first real payment seeds both extremes
            first = false;
        } else {
            if (amount > largest)  largest = amount;
            if (amount < smallest) smallest = amount;
        }
        total += amount;
        ++count;

        cout << "Payment (0 to finish): ";
    }

    cout << fixed << setprecision(2);
    if (count == 0) {
        cout << "No payments entered\n";
        return 0;
    }
    cout << "Payments: " << count << "\n";
    cout << "Total:    Rs " << total << "\n";
    cout << "Average:  Rs " << total / count << "\n";
    cout << "Largest:  Rs " << largest << "\n";
    cout << "Smallest: Rs " << smallest << "\n";
    return 0;
}
```

### Solution explanation
This is the sentinel loop in its canonical form — the read sits in the `while` condition, so EOF and the sentinel both end the loop naturally and `eof()` never appears. The extremes use *first-payment seeding* rather than a magic initial value: seeding `largest = 0` would break for an all-refund... no — the point is subtler and shown by the flag: any pre-chosen constant risks being wrong for the data, while "the first real value is both extremes" is always right. The negative-payment repair loop honours the sentinel even mid-repair, keeping the loop's exit contract intact.

### Testing checklist
- [ ] All five test cases pass
- [ ] The sentinel never appears in any statistic
- [ ] Negative values re-prompt but never corrupt the count
- [ ] Single-payment batch prints Largest = Smallest

---

## L2-11 — The Utility Bill Desk

### Scenario
The electricity company's desk computes residential bills with a *tiered* tariff: the first 100 units cost Rs 12 each, units 101–300 cost Rs 18 each, units above 300 cost Rs 25 each — plus a fixed meter rent of Rs 150. The clerk processes several customers, ending with a negative unit count.

### Problem statement
For each customer: read the units consumed (int) and compute the bill by the tiered tariff (each unit is charged at its tier's rate — tiers do not reprice the whole consumption). A negative units value ends the session. Print each bill and, at the end, how many bills were processed and the overall total.

### Learning objectives
- implement tiered pricing with sequential subtraction
- combine a sentinel loop with per-iteration branching
- accumulate session totals

### Requirements
1. Bill = meter rent + tier charges; tiers charge *only their slice* (first 100, next 200, rest).
2. Negative or zero units after the first customer ends the session (the first customer may also end it).
3. Each bill prints: `Customer N: X units — Rs Y`.
4. Session summary: bills processed and the grand total (meter rents included).

### Input
One int per line (units), terminated by a negative value.

### Output
One bill line per customer, then the two summary lines.

### Constraints
- Units > 10000 → bill still computed (no cap), but print a `High usage` note after the bill.
- The negative terminator is not a customer.

### Example
Input: `350`, `80`, `-1` →
`Customer 1: 350 units — Rs 7050.00` (150 + 1200 + 3600 + 2100), `Customer 2: 80 units — Rs 1110.00`, then `Bills: 2, Total: Rs 8160.00`.

### Test cases
| Input | Expected |
| --- | --- |
| 350, 80, −1 | the example output |
| −1 | Bills: 0, Total: Rs 0.00 |
| 100, −1 | boundary: exactly 1200 + 150 = Rs 1350.00 |
| 101, −1 | 1200 + 18 + 150 = Rs 1368.00 |
| 300, −1 | 1200 + 3600 + 150 = Rs 4950.00 |
| 301, −1 | 4950 + 25 = Rs 4975.00 |

### Student tasks
1. Write the tier computation as a sequence: full first tier, full second tier, remainder.
2. Wrap it in the sentinel loop with the session totals.
3. Add the high-usage note.
4. Verify every boundary test by hand *before* running (the tier edges are the lab's real content).

### Hints
1. Subtract tier slices as you charge them: `units -= 100;` after charging the first 100 — what remains belongs to the next tier.
2. `max(0, units)` guards a tier whose slice doesn't exist (a 50-unit bill charges no second tier).
3. Compute the bill into one variable, then print — the summary reuses the same value.

### Extension challenges
1. Add a 1.5% late-payment surcharge flag per customer (`y`/`n`).
2. Track the single highest bill and print it in the summary.

### Complete solution

```cpp
// L2-11 — The Utility Bill Desk
// Compile: g++ -std=c++17 -Wall -Wextra L2-11.cpp -o L2-11
#include <iostream>
#include <iomanip>
#include <algorithm>
using namespace std;

int main() {
    const double TIER1_RATE = 12.0, TIER2_RATE = 18.0, TIER3_RATE = 25.0;
    const double METER_RENT = 150.0;
    const int    TIER1_CAP = 100, TIER2_CAP = 300;

    int units;
    int bills = 0;
    double grandTotal = 0.0;

    cout << "Units (negative to end): ";
    while (cin >> units && units >= 0) {
        double charge = 0.0;
        int remaining = units;

        int tier1 = min(remaining, TIER1_CAP);            // the first slice
        charge += tier1 * TIER1_RATE;
        remaining -= tier1;

        int tier2 = min(remaining, TIER2_CAP - TIER1_CAP); // the next slice
        charge += tier2 * TIER2_RATE;
        remaining -= tier2;

        charge += remaining * TIER3_RATE;                  // everything left

        double bill = METER_RENT + charge;
        ++bills;
        grandTotal += bill;

        cout << "Customer " << bills << ": " << units << " units — Rs "
             << fixed << setprecision(2) << bill << "\n";
        if (units > 10000) cout << "High usage\n";

        cout << "Units (negative to end): ";
    }

    cout << "Bills: " << bills << ", Total: Rs " << fixed << setprecision(2) << grandTotal << "\n";
    return 0;
}
```

### Solution explanation
Tiered pricing is *sequential slicing*: charge `min(remaining, tierCap)` at the tier's rate, subtract the slice, continue — the pattern handles every edge (a 50-unit bill charges only tier 1; a 9000-unit bill charges all three) without a single nested if. The `min`-based form is preferred over stacked `if (units > 100) { ... }` chains because each tier's arithmetic looks identical, which makes the test table's boundary probes (100, 101, 300, 301) the *only* thing that needs care. The session loop is the sentinel pattern again — the same skeleton as L2-10, now carrying per-iteration business logic.

### Testing checklist
- [ ] All six test cases pass — especially 100/101 and 300/301
- [ ] The terminator never produces a bill
- [ ] Zero bills produce the empty summary
- [ ] High-usage note appears only above the threshold

---

## L2-12 — The Quiz Machine

### Scenario
The learning centre's quiz machine drills students on arithmetic: it poses one question at a time, checks the answer, and keeps score over a fixed number of questions.

### Problem statement
Ask 5 questions. Each question is "a + b = ?" with `a` and `b` read from the operator (the course's deterministic stand-in for random numbers). Read the student's answer; count correct answers and wrong answers. At the end, print the score, the percentage, and a grade message (≥ 80 "Excellent", ≥ 60 "Good", ≥ 40 "Keep practising", else "See the tutor").

### Learning objectives
- drive a counted loop (`for`) over a fixed number of items
- combine input, decision, and two counters per iteration
- map a percentage onto a message ladder

### Requirements
1. Exactly 5 questions; the loop is a `for` with the question number printed.
2. Each round reads `a`, `b`, then the student's answer; compare against `a + b`.
3. Track correct and wrong counts (they always sum to 5).
4. Final output: `Score: X/5 (Y%)` then the grade message.

### Input
Per round: two ints (the operands) then one int (the answer). Non-numeric answers count as wrong (repair the stream, count, continue).

### Output
Per round: `Question N: a + b = ?` and after the answer `Correct!` or `Wrong (a + b = S)`. Then the summary block.

### Constraints
- The student's answer must not crash the program when non-numeric — repair the stream and count it wrong.
- Percentages round to a whole number (`(correct * 100) / 5` integer arithmetic is exact here).

### Example
Rounds (a,b,answer): (3,4,7), (10,12,23), (5,5,9), (2,2,4), (9,8,17) → Score: 4/5 (80%), Excellent.

### Test cases
| Rounds | Expected |
| --- | --- |
| the example | 4/5 (80%), Excellent |
| all five correct | 5/5 (100%), Excellent |
| all five wrong | 0/5 (0%), See the tutor |
| (2,3,abc), (1,1,2), rest correct | non-numeric counted wrong, stream recovers, 4/5 |
| 3 correct, 2 wrong | 3/5 (60%), Good |

### Student tasks
1. Write the `for` loop with the question number.
2. Read the operands and the answer; compare.
3. Add the stream-repair branch for non-numeric answers.
4. Compute the percentage and add the message ladder.

### Hints
1. Stream repair: `if (!(cin >> answer)) { cin.clear(); cin.ignore(1000, '\n'); ++wrong; continue; }` — the Unit 03 repair ritual.
2. The percentage arithmetic `(correct * 100) / 5` — multiply *before* dividing.
3. The message ladder is the L1-05 shape with percentage boundaries.

### Extension challenges
1. Alternate between addition and multiplication rounds (even/odd question number).
2. Repeat the whole quiz until the student's percentage is at least 80 (a loop of loops).

### Complete solution

```cpp
// L2-12 — The Quiz Machine
// Compile: g++ -std=c++17 -Wall -Wextra L2-12.cpp -o L2-12
#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    const int QUESTIONS = 5;
    int correct = 0, wrong = 0;

    for (int q = 1; q <= QUESTIONS; ++q) {
        int a, b, answer;
        cout << "Question " << q << ": operand a: ";
        cin >> a;
        cout << "operand b: ";
        cin >> b;
        cout << a << " + " << b << " = ? ";
        cin >> answer;

        if (!cin) {                                   // non-numeric: count wrong, repair
            cin.clear();
            cin.ignore(1000, '\n');
            ++wrong;
            cout << "Not a number — counted as wrong\n";
            continue;
        }

        if (answer == a + b) {
            ++correct;
            cout << "Correct!\n";
        } else {
            ++wrong;
            cout << "Wrong (" << a << " + " << b << " = " << a + b << ")\n";
        }
    }

    int percent = correct * 100 / QUESTIONS;
    cout << "\nScore: " << correct << "/" << QUESTIONS << " (" << percent << "%)\n";
    if      (percent >= 80) cout << "Excellent\n";
    else if (percent >= 60) cout << "Good\n";
    else if (percent >= 40) cout << "Keep practising\n";
    else                    cout << "See the tutor\n";
    return 0;
}
```

### Solution explanation
The counted loop is the natural shape for "exactly five" — no sentinel to invent, no off-by-one to manage beyond `1..5`. The stream-repair branch is the Unit 03 input-validation material meeting a loop for the first time: repair, count as wrong, `continue` — the round ends but the machine lives. The message ladder reuses Level 1's boundary discipline on a percentage. Note the counters' invariant (`correct + wrong == 5`) — every code path must touch exactly one; the test cases verify it.

### Testing checklist
- [ ] All five round-sequences produce the stated scores
- [ ] A non-numeric answer counts as wrong and the next question still works
- [ ] The percentage ladder hits all four messages across the test set
- [ ] The loop runs exactly five times no matter what

---

## L2-13 — The Number Properties Desk

### Scenario
The mathematics learning centre offers a "number properties" desk: type a number, learn its properties — digits, digit sum, reversal, palindrome status, and prime status.

### Problem statement
For each number typed (terminated by 0), print: the digit count, the digit sum, the reversal, whether it is a palindrome, and whether it is prime. The program is a menu-free desk: numbers in, property lines out, sentinel ends it.

### Learning objectives
- extract digits with `% 10` and `/ 10`
- build a reversal and a digit sum in one loop
- implement primality by trial division with the √n bound

### Requirements
1. Digit count, digit sum, and reversal computed by digit extraction (no strings).
2. Palindrome: number equals its reversal.
3. Prime: divisibility test from 2 to √n; 0 and 1 are not prime; negatives refused (`Enter a non-negative number`).
4. Sentinel `0` ends the desk (0 itself gets no property lines).

### Input
One non-negative int per line, terminated by `0`.

### Output
Per number: `N: 5 digits, digit sum S, reversal R, palindrome: yes/no, prime: yes/no`.

### Constraints
- √n bound: loop `i * i <= n` — no `<cmath>` needed.
- Single-digit numbers are palindromes; 2 is prime.

### Example
Input: `12321`, `97`, `0` →
`12321: 5 digits, digit sum 9, reversal 12321, palindrome: yes, prime: no`;
`97: 2 digits, digit sum 16, reversal 79, palindrome: no, prime: yes`.

### Test cases
| Input | Expected |
| --- | --- |
| 12321, 0 | 5 digits, sum 9, reversal 12321, palindrome yes, prime no |
| 97, 0 | 2 digits, sum 16, reversal 79, palindrome no, prime yes |
| 0 | nothing printed, clean exit |
| 7, 0 | 1 digit, sum 7, palindrome yes, prime yes |
| 1, 0 | 1 digit, sum 1, palindrome yes, prime no |
| 100, 0 | 3 digits, sum 1, reversal 001 → 1, palindrome no, prime no |
| −5, 0 | Enter a non-negative number, then the sentinel ends it |

### Student tasks
1. Write the digit loop: while n > 0, take `% 10`, accumulate, divide.
2. Add the reversal accumulation (`rev = rev * 10 + digit`).
3. Write the primality loop with the `i * i <= n` bound.
4. Wrap in the sentinel loop; add the negative refusal.

### Hints
1. Work on a *copy* of the number — the digit loop destroys its input; the palindrome test compares the *original* with the reversal.
2. `i * i <= n` avoids both `<cmath>` and overflow-at-large-n worries for this course's ranges.
3. The prime loop can `break` on the first divisor found — then the primality verdict is whether the loop completed.

### Extension challenges
1. Print the number's digits in words (123 → "one two three").
2. Report whether the number is an Armstrong number (digits cubed sum to the number).

### Complete solution

```cpp
// L2-13 — The Number Properties Desk
// Compile: g++ -std=c++17 -Wall -Wextra L2-13.cpp -o L2-13
#include <iostream>
using namespace std;

int main() {
    long long n;
    cout << "Number (0 to end): ";
    while (cin >> n && n != 0) {
        if (n < 0) {
            cout << "Enter a non-negative number\n";
        } else {
            long long work = n;                  // the digit loop's sacrificial copy
            int digits = 0;
            long long sum = 0, rev = 0;
            while (work > 0) {
                long long d = work % 10;
                sum += d;
                rev = rev * 10 + d;
                ++digits;
                work /= 10;
            }

            bool prime = n > 1;                  // 0 and 1 are not prime
            for (long long i = 2; i * i <= n && prime; ++i)
                if (n % i == 0) prime = false;

            cout << n << ": " << digits << " digits, digit sum " << sum
                 << ", reversal " << rev
                 << ", palindrome: " << (n == rev ? "yes" : "no")
                 << ", prime: " << (prime ? "yes" : "no") << "\n";
        }
        cout << "Number (0 to end): ";
    }
    return 0;
}
```

### Solution explanation
Digit extraction (`% 10` for the last digit, `/ 10` to drop it) is the foundational digit loop — here it feeds three accumulators at once, exactly as the iteration module's digit-processing lesson taught. The sacrificial copy `work` preserves the original for the palindrome comparison; forgetting the copy is the lab's classic first bug. Primality uses the `i * i <= n` bound (any factor above √n pairs with one below it) and starts from the truth for 0 and 1 rather than special-casing them after the loop. `long long` throughout keeps the reversal of large inputs inside the type.

### Testing checklist
- [ ] All seven test cases pass
- [ ] 100's reversal prints as 1 (leading zeros vanish — expected)
- [ ] Negative input prints the message and the desk continues
- [ ] The sentinel 0 produces no output line

---

## L2-14 — The Pattern Press

### Scenario
The art society's newsletter needs decorative number and star patterns; the Pattern Press prints any requested pattern size.

### Problem statement
Read a height `n` (1–15) and print the following four patterns, each of height `n`: (a) a left triangle of `*`, (b) a right-aligned triangle of `*`, (c) a number triangle where row i prints `1..i`, (d) a pyramid of `*` centred in width `2n−1`.

### Learning objectives
- nest loops: outer rows, inner columns
- relate inner-loop bounds to the outer loop's counter
- pad with spaces to position shapes

### Requirements
1. Read `n`; outside 1–15 → `Invalid size`.
2. Pattern (a): row i (1-based) prints i stars.
3. Pattern (b): row i prints `n − i` spaces then i stars.
4. Pattern (c): row i prints the numbers 1..i separated by single spaces.
5. Pattern (d): row i prints `n − i` spaces, `2i − 1` stars, `n − i` spaces (trailing spaces optional but the leading ones are graded).

### Input
One int: `n`.

### Output
The four patterns, each preceded by its label line.

### Constraints
- Every pattern is built from loops — no literal multi-star strings.

### Example
For `n = 4`, pattern (d) is:
```text
   *
  ***
 *****
*******
```

### Test cases
| Input | Expected |
| --- | --- |
| 4 | all four patterns of height 4 |
| 1 | every pattern is a single row/star |
| 0 | Invalid size |
| 16 | Invalid size |
| 2 | minimal two-row versions of all four |

### Student tasks
1. Write pattern (a): the canonical nested loop.
2. Derive (b) by adding the space loop — note the bound is `n − i`.
3. Derive (c) by printing the loop counter inside the inner loop.
4. Derive (d) by combining (b)'s padding with the `2i − 1` star count.

### Hints
1. One outer `for (int i = 1; i <= n; ++i)` per pattern; everything else is inner loops.
2. Print spaces with an inner loop, not string arithmetic — the discipline transfers to every padding problem.
3. After each row's inner loops: `cout << "\n";`.

### Extension challenges
1. Add a hollow pyramid (stars only on the row's edges and base).
2. Print all four patterns side by side (harder: four inner loops per row).

### Complete solution

```cpp
// L2-14 — The Pattern Press
// Compile: g++ -std=c++17 -Wall -Wextra L2-14.cpp -o L2-14
#include <iostream>
using namespace std;

int main() {
    int n;
    cout << "Pattern height (1-15): ";
    cin >> n;
    if (n < 1 || n > 15) { cout << "Invalid size\n"; return 1; }

    cout << "\n(a) Left triangle\n";
    for (int i = 1; i <= n; ++i) {
        for (int j = 1; j <= i; ++j) cout << "*";
        cout << "\n";
    }

    cout << "\n(b) Right-aligned triangle\n";
    for (int i = 1; i <= n; ++i) {
        for (int s = 1; s <= n - i; ++s) cout << " ";
        for (int j = 1; j <= i; ++j) cout << "*";
        cout << "\n";
    }

    cout << "\n(c) Number triangle\n";
    for (int i = 1; i <= n; ++i) {
        for (int j = 1; j <= i; ++j) {
            cout << j;
            if (j < i) cout << " ";
        }
        cout << "\n";
    }

    cout << "\n(d) Pyramid\n";
    for (int i = 1; i <= n; ++i) {
        for (int s = 1; s <= n - i; ++s) cout << " ";
        for (int j = 1; j <= 2 * i - 1; ++j) cout << "*";
        cout << "\n";
    }
    return 0;
}
```

### Solution explanation
Each pattern is one outer loop (rows) over one or two inner loops (columns) — the entire lab is the iteration module's nested-loop lesson made visible. The derivations are the graded content: (b) from (a) by inserting a space loop whose bound `n − i` *shrinks as i grows*; (d) from (b) by changing the star count to the odd sequence `2i − 1`. The number triangle prints the counter itself with a separator conditioned on `j < i` — a small lesson in avoiding a trailing delimiter. Pattern (d)'s leading spaces are graded because centring is the skill; trailing spaces are cosmetic.

### Testing checklist
- [ ] n = 4 reproduces the example pyramid exactly
- [ ] n = 1 prints four one-row patterns
- [ ] Every star comes from a loop (change n and the shapes follow)
- [ ] Invalid sizes print the message once

---

## L2-15 — Stock Take

### Scenario
The campus store runs a stock take: the clerk types each product's quantity one by one (a counted batch — the manifest says how many products), and the program reports the store's summary.

### Problem statement
Read `n` (the number of products, 1–1000), then `n` quantities. Report: total units, the highest quantity and its position (1-based), the lowest quantity and its position, how many products are below the reorder level of 10, and whether any product is out of stock (quantity 0).

### Learning objectives
- run a counted input loop with position tracking
- maintain running extremes *with their positions*
- test a condition "any" over a batch without storing it

### Requirements
1. `n` outside 1–1000 → `Invalid count`.
2. Quantities are non-negative; a negative quantity re-prompts for that same product (the position must not advance).
3. Report the six summary values; ties for highest/lowest report the *first* occurrence.
4. No arrays — the batch is processed as it arrives.

### Input
`n`, then n ints.

### Output
Six labelled lines: `Total units: N`, `Highest: Q at position P`, `Lowest: Q at position P`, `Below reorder level: N`, `Out of stock: yes/no`.

### Constraints
- Position tracking must survive the re-prompt loop (a re-prompted product keeps its position).
- One pass; no storage.

### Example
Input: n=5, quantities `12, 8, 0, 30, 8` → Total 58, Highest 30 at position 4, Lowest 0 at position 3, Below reorder 2, Out of stock yes.

### Test cases
| Input | Expected |
| --- | --- |
| 5: 12, 8, 0, 30, 8 | the example output |
| 0 | Invalid count |
| 1: 7 | Total 7, Highest = Lowest = 7 at position 1, below reorder 1, out no |
| 3: 5, −2 then 6, 9 | re-prompt keeps position 2; Lowest 5 at 1, Highest 9 at 3 |
| 4: 10, 10, 10, 10 | Total 40, first-occurrence positions (1), below 0, out no |

### Student tasks
1. Read and validate `n`.
2. Write the counted loop with the re-prompt guard.
3. Maintain total, extremes with positions, below-count, and the out-of-stock flag.
4. Print the six-line summary.

### Hints
1. Extremes with positions: when `qty > maxQty`, update *both* the value and `maxPos = position`.
2. The re-prompt loop must not advance the product counter — structure it as an inner while.
3. "Any out of stock" is a `bool` that a single `qty == 0` can set true; nothing can unset it.

### Extension challenges
1. Also report the average quantity (mind the integer division).
2. Report the position of the *last* lowest quantity (ties resolve differently).

### Complete solution

```cpp
// L2-15 — Stock Take
// Compile: g++ -std=c++17 -Wall -Wextra L2-15.cpp -o L2-15
#include <iostream>
using namespace std;

int main() {
    const int REORDER_LEVEL = 10;

    int n;
    cout << "Number of products: ";
    cin >> n;
    if (n < 1 || n > 1000) { cout << "Invalid count\n"; return 1; }

    long long total = 0;
    int maxQty = -1, maxPos = 0, minQty = -1, minPos = 0;
    int belowReorder = 0;
    bool anyOut = false;

    for (int position = 1; position <= n; ++position) {
        int qty;
        cout << "Quantity for product " << position << ": ";
        cin >> qty;
        while (qty < 0) {
            cout << "Quantity cannot be negative. Again: ";
            cin >> qty;                       // the position does NOT advance
        }

        total += qty;
        if (qty > maxQty)  { maxQty = qty;  maxPos = position; }
        if (minQty == -1 || qty < minQty) { minQty = qty; minPos = position; }
        if (qty < REORDER_LEVEL) ++belowReorder;
        if (qty == 0) anyOut = true;
    }

    cout << "Total units: " << total << "\n";
    cout << "Highest: " << maxQty << " at position " << maxPos << "\n";
    cout << "Lowest: "  << minQty << " at position " << minPos << "\n";
    cout << "Below reorder level: " << belowReorder << "\n";
    cout << "Out of stock: " << (anyOut ? "yes" : "no") << "\n";
    return 0;
}
```

### Solution explanation
The lab's engine is the "extremes with positions" pattern: update value and position together, inside the same `if`, so they can never disagree. The first-occurrence tie rule falls out of strict comparisons (`>` never fires on equal), and the `minQty == -1` seeding handles the first product explicitly — the same first-seeding idea as L2-10, now with a position attached. The re-prompt loop *inside* the counted loop shows the two loop roles coexisting: the outer loop counts products, the inner one repairs one input — the position belongs to the outer loop and is untouched. The out-of-stock flag is the one-way ratchet: evidence accumulates, nothing clears it.

### Testing checklist
- [ ] All five test cases pass
- [ ] The re-prompted product keeps its position (test 4's Lowest is at 1)
- [ ] Ties report first occurrences (test 5)
- [ ] `n` outside 1–1000 is refused before any quantity is read

---

## L2-16 — The Guess Desk

### Scenario
The programming club builds a deterministic guessing game for its intro workshop: a secret number is set by the operator, the player guesses, and the program answers "too low"/"too high"/"correct" — counting attempts.

### Problem statement
Read a secret (1–100) set by the operator, then read guesses until the secret is found. Each wrong guess prints its direction; the correct guess prints the attempt count. Refuse a secret outside 1–100; refuse guesses outside 1–100 without counting them.

### Learning objectives
- loop until a *condition* (not a count or sentinel) is met
- separate validation loops from the main game loop
- count meaningful events only

### Requirements
1. Secret outside 1–100 → `Invalid secret` and stop.
2. Guess outside 1–100 → `Out of range` — re-prompt, *not counted*.
3. Low guess → `Too low`; high guess → `Too high`; equal → `Correct in N attempts!`.
4. No loop limit — the game ends only on a correct guess.

### Input
Secret (int), then guesses (ints) until correct.

### Output
Direction lines per wrong guess, the final correct line.

### Constraints
- The attempts counter counts *in-range* guesses only.
- One guess per line; no feedback batching.

### Example
Secret 42; guesses 25, 60, 42 → `Too low`, `Too high`, `Correct in 3 attempts!`.

### Test cases
| Input | Expected |
| --- | --- |
| secret 42: 25, 60, 42 | the example output |
| secret 200 | Invalid secret |
| secret 50: 150, 200, 50 | two Out of range lines, then Correct in 1 attempts |
| secret 1: 1 | Correct in 1 attempts! |
| secret 100: 1, 100 | Too low, Correct in 2 attempts! |

### Student tasks
1. Read and validate the secret.
2. Write the condition-controlled loop: read guess, validate range, compare, branch.
3. Manage the attempts counter (increment only on in-range guesses).
4. Print the final line with the correct grammar for 1 attempt (the "1 attempts" wrinkle is deliberate — fix it or document it).

### Hints
1. `while (guess != secret)` with the read at the top of the body — the loop is *condition-driven*, unlike L2-15's counted shape.
2. Validation first, comparison second — an out-of-range guess must not produce a direction line.
3. `do-while` fits too (read-then-test); choose and justify.

### Extension challenges
1. Limit the player to 7 attempts and print a losing message (7 is optimal for 1–100 — why?).
2. Track and print the *closest* wrong guess so far.

### Complete solution

```cpp
// L2-16 — The Guess Desk
// Compile: g++ -std=c++17 -Wall -Wextra L2-16.cpp -o L2-16
#include <iostream>
using namespace std;

int main() {
    int secret;
    cout << "Operator — set the secret (1-100): ";
    cin >> secret;
    if (secret < 1 || secret > 100) { cout << "Invalid secret\n"; return 1; }

    int attempts = 0;
    int guess;
    do {
        cout << "Your guess: ";
        cin >> guess;
        if (guess < 1 || guess > 100) {
            cout << "Out of range\n";           // not counted
            continue;
        }
        ++attempts;
        if (guess < secret)      cout << "Too low\n";
        else if (guess > secret) cout << "Too high\n";
    } while (guess != secret);

    cout << "Correct in " << attempts
         << (attempts == 1 ? " attempt!" : " attempts!") << "\n";
    return 0;
}
```

### Solution explanation
The condition-controlled `do-while` is the game's natural shape: read, react, repeat *until* the condition — no counter drives it, so validation must not disturb the exit test (the `continue` skips counting and comparison while the loop condition still re-checks the out-of-range guess, harmlessly: it can't equal the secret). The counter's placement — after range validation, before the comparison — encodes the requirement "count meaningful guesses" as a fact of code layout rather than a rule to remember. The singular/plural suffix is the same conditional-text habit as L1-07, and the test table deliberately includes the 1-attempt case.

### Testing checklist
- [ ] All five test cases pass
- [ ] Out-of-range guesses print the message and appear nowhere in the count
- [ ] The loop never ends on an out-of-range guess
- [ ] Single-attempt games print `attempt!`

---

[← Level 1](level-1.md) · [Labs home](index.md) · Continue to [Level 3 — Intermediate](level-3.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
