---
title: "Scenarios — Set D: Combining Everything (16–20)"
description: "Five full problems: validation, multi-phase processing, nested decisions in loops, and trace-table discipline."
---

# Set D — Combining Everything (Scenarios 16–20)

> ★★–★★★ difficulty · ~15 min honest attempt each · [← Module home](index.md) ·
> [← Set C](scenarios-c.md)

The final set combines **everything**: IPO + decisions + loops +
accumulators + boundaries + test design. Some scenarios also introduce one
new *design* idea each — validation, best-so-far tracking, two-phase
processing — flagged where it appears. Solutions remain collapsed; by now
the [Try It Yourself protocol](index.md#try-it-yourself-before-looking-at-the-solution)
is a habit, not a reminder.

---

## Scenario 16 ★★ — Age gate with input validation

**Problem statement.** A registration kiosk asks for the applicant's age
and prints `"ADULT"` (18+) or `"MINOR"` (under 18). The kiosk **must not
accept nonsense**: ages below 0 or above 120 are re-asked until a legal
value arrives.

**Expected input.** One whole number; if outside 0–120, the program asks
again (no limit on retries).

**Expected output.**

```text
Age: 150
Invalid age — enter 0 to 120.
Age: 16
MINOR
```

**Constraints & assumptions.** Legal range **0–120 inclusive** (0 is legal:
a newborn's record). Retries unlimited. The decision boundary: exactly 18
is ADULT.

**Thinking questions:**
1. This is Scenario 7's decision *plus* a loop. Which comes first — the
   validation loop or the classification? Sketch the order of the phases.
2. The loop's stopping condition: what makes it stop? What is the *read*
   that must happen both before and inside the loop?
3. Boundary set: which inputs must you test? (There are the classification
   edges *and* the validation edges — list both families.)

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. **Validation first, classification second** — two phases. Classifying
   an invalid age is meaningless; the loop's job is to *deliver a legal
   value*, and only then does the decision run. (Same two-phase thinking
   as the lesson's §12 update pattern, and Unit 12 will reuse it for file
   data.)
2. The loop stops when the last-read age is legal: condition `age < 0 ||
   age > 120` keeps re-asking. Read **before** the loop (prime), and
   **inside** the loop (re-read after the error message) — exactly
   Scenario 11's prime/process/advance beats, with "process" replaced by
   "complain".
3. Two families. Validation edges: −1 (re-ask), 0 (accept), 120 (accept),
   121 (re-ask). Classification edges: 17 → MINOR, 18 → ADULT. All six
   belong in the test table — a two-phase program inherits both phases'
   boundaries.

**Suggested approach.** Sentinel-style WHILE on *invalidity*; then the
one-line classification. Note the condition is an **or** — invalid means
"below the floor *or* above the ceiling"; writing `&&` here is the classic
bug (no age is both < 0 *and* > 120, so the loop would never loop).

**Pseudocode.**

```text
REPEAT
    PRINT "Age: "
    READ age
    IF age < 0 OR age > 120 THEN
        PRINT "Invalid age — enter 0 to 120."
    ENDIF
UNTIL age >= 0 AND age <= 120

IF age >= 18 THEN PRINT "ADULT" ELSE PRINT "MINOR" ENDIF
```

**Solution explanation.** The REPEAT–UNTIL shape (test *after* the body)
matches this problem naturally: we must ask at least once, and keep asking
until legal. (A WHILE form works too: read first, then
`WHILE invalid: print, read` — the pseudocode above compiles to exactly
that in C++.) The subtle line is the **or/and mirror**: the loop *continues*
on `age < 0 || age > 120` but *ends* on `age >= 0 && age <= 120` — De
Morgan again (Scenario 9 previewed it). When a validation loop "never
loops" or "never stops", read these two conditions against each other
first. The classification is then trivial — validation did the hard part.

**C++ solution.**

```cpp
// s16_agegate.cpp — Set D · Scenario 16
// Compile: g++ -std=c++17 -Wall -Wextra s16_agegate.cpp -o s16

#include <iostream>

int main() {
    int age = -1;                        // deliberately invalid: forces entry
    while (age < 0 || age > 120) {
        std::cout << "Age: ";
        std::cin  >> age;
        if (age < 0 || age > 120) {
            std::cout << "Invalid age — enter 0 to 120.\n";
        }
    }

    if (age >= 18) {
        std::cout << "ADULT\n";
    } else {
        std::cout << "MINOR\n";
    }
    return 0;
}
```

**Test cases.**

| Input sequence | Expected |
| --- | --- |
| 150, 16 | error line, then MINOR |
| 200, −4, 25 | two error lines, then ADULT |
| 18 | ADULT ← classification boundary |
| 17 | MINOR ← one below |
| 0 | MINOR ← validation floor, legal |
| 120 | ADULT ← validation ceiling, legal |

**Edge cases.** The six in the table; plus −1 and 121 (the first illegal
values on each side). Retry-forever is *by design* unbounded — the edge of
the *assumption*, not the program. Also note the initial `age = -1`: it
must be *outside* the legal range so the loop runs at least once — a
deliberate initialisation choice, documented.

</details>

---

## Scenario 17 ★★★ — The class-topper scan

**Problem statement.** An exam cell scans **exactly 10 students' marks**
(0–100 each). Print the **highest mark** and the **position (1–10) of the
student who scored it** — for ties, the *earliest* position.

**Expected input.** Ten whole numbers (0 … 100).

**Expected output.**

```text
Highest mark: 91
Student position: 3
```

**Constraints & assumptions.** Exactly 10 marks; 0–100; ties resolve to
the earliest position (that's the requirement).

**Thinking questions:**
1. This is Scenario 10's champion, upgraded: the champion must now
   **remember who it beat** — what extra accumulator is needed, and when
   exactly is it updated?
2. Tie discipline: with strict `<` (new > champion), which position wins a
   tie — earliest or latest? Check against the requirement.
3. Trace for marks 55, 70, 91, 91, 12, 88, 91, 40, 67, 3: champion and
   position after each student. What are the two 91s' fates?

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. Two accumulators: `highest` (the champion value) and `pos` (its
   position). The position updates **only when the champion is
   replaced** — they move together, always. Any design where they can
   disagree (e.g. updating `pos` every iteration) is broken by
   construction.
2. With strict `>` (replace only on *strictly greater*), a tie leaves the
   old champion — so the **earliest** position wins. Exactly the
   requirement. (`>=` would hand ties to the latest — a one-character
   design decision with visible consequences; decide it *because* of the
   requirement, not by accident.)
3. Trace:

| student | mark | > highest? | highest (after) | pos (after) |
| --- | --- | --- | --- | --- |
| 1 | 55 | yes (55 > −1 init) | 55 | 1 |
| 2 | 70 | yes | 70 | 2 |
| 3 | 91 | yes | 91 | 3 |
| 4 | 91 | no (tie — keep) | 91 | 3 |
| 5 | 12 | no | 91 | 3 |
| 6 | 88 | no | 91 | 3 |
| 7 | 91 | no (tie again) | 91 | 3 |
| 8 | 40 | no | 91 | 3 |
| 9 | 67 | no | 91 | 3 |
| 10 | 3 | no | 91 | 3 |

Both 91s lose the tie deliberately → position **3**, the earliest. ✓

**Suggested approach.** FOR 1..10 with the paired champion
(value + position); initialisation matters — seed `highest` with the
**first mark** (and pos = 1), or seed with −1 (below the legal floor) and
let student 1 win the first comparison. Both are correct; seeding with the
first read avoids the "sentinel-ish" magic number.

**Pseudocode.**

```text
READ first mark → highest;  pos ← 1
FOR student FROM 2 TO 10 DO
    READ mark
    IF mark > highest THEN          (strict: ties keep the earliest)
        highest ← mark
        pos ← student
    ENDIF
ENDFOR
PRINT "Highest mark: ", highest
PRINT "Student position: ", pos
```

**Solution explanation.** The **best-so-far** pattern: the same
champion-and-challenge shape as Scenario 10, running *inside* a loop over
data that arrives one item at a time — which is why no arrays are needed
at this stage of the course. The two discipline points: (1) paired
accumulators must update *together, under the same condition* — the
invariant "highest is the max of marks 1..student, and pos is where it
came from" is preserved by every row of the trace; (2) the tie policy is
a *requirement*, encoded as `<` vs `<=` — trace rows 4 and 7 are the
proof. This pattern returns at scale in Unit 09 (Marks Analyzer) and
Unit 10 (searching).

**C++ solution.**

```cpp
// s17_topper.cpp — Set D · Scenario 17
// Compile: g++ -std=c++17 -Wall -Wextra s17_topper.cpp -o s17

#include <iostream>

int main() {
    int highest = 0;
    int pos = 0;

    int student = 1;
    while (student <= 10) {
        int mark = 0;
        std::cout << "Mark " << student << ": ";
        std::cin  >> mark;

        if (student == 1 || mark > highest) {   // first seed, then strict ties
            highest = mark;
            pos = student;                       // moves with the champion
        }
        student = student + 1;
    }

    std::cout << "Highest mark: " << highest << "\n";
    std::cout << "Student position: " << pos << "\n";
    return 0;
}
```

**Test cases.**

| Input (10 marks) | Expected |
| --- | --- |
| 55, 70, 91, 91, 12, 88, 91, 40, 67, 3 | 91 at position 3 (tie → earliest) |
| 90, 90, 90, 90, 90, 90, 90, 90, 90, 90 | 90 at position 1 (all tie) |
| 3, 5, 7, 9, 12, 20, 44, 70, 88, 100 | 100 at position 10 (champion at the end) |

**Edge cases.** All-equal (position must stay 1), strictly increasing
(champion updates every round — pos ends 10), strictly decreasing (updates
only the seed), 0s (legal floor — highest 0 at position 1), the tie pair
at *adjacent* vs *distant* positions (91s at rows 3/4 and 3/7 both → 3).

</details>

---

## Scenario 18 ★★★ — The vending machine (multi-condition menus)

**Problem statement.** A canteen kiosk sells four items: **1) Samosa
25**, **2) Chai 15**, **3) Sandwich 60**, **4) Juice 40**. The user types
an item number; the kiosk prints the item name and price. An invalid
number (anything but 1–4) prints `"No such item"`.

**Expected input.** One whole number (any).

**Expected output.**

```text
Item: 3
Sandwich — 60 Rs
```
*(for item 9: "No such item")*

**Constraints & assumptions.** Item codes are exactly 1–4; everything else
is invalid *and there are no retries* (one shot — this kiosk is a single
transaction).

**Thinking questions:**
1. Four known cases + one catch-all: which construct fits — a chain of
   ifs, or `switch`-style multi-branch? Sketch the shape. (C++'s `switch`
   arrives in Unit 04; here design it as an else-if chain and note where
   the `default` would sit.)
2. The invalid case: is it the *last else*, or does it need its own
   condition? Why is "last else" the honest choice here?
3. Test set: which codes, and how many invalid probes? Include the two
   edges of the valid range (1, 4) and both sides just outside (0, 5).

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. A **multi-way selection on one value** — the textbook `switch` shape.
   As an else-if ladder: one equality test per branch; the invalid case is
   the final `else` (C++: `default:`). Equality tests (not ranges!) —
   note the contrast with Scenario 8, where ranges forced inequalities;
   choosing equality vs range conditions *is* reading the requirement.
2. Last-else, because "invalid" is *defined negatively* — "anything but
   1–4". Enumerating every invalid value explicitly (0, 5, 9, −3, …) is
   endless and incomplete; the catch-all else is *exactly* the
   complement. Always prefer the complement when the spec defines the
   default case negatively.
3. Valid: 1, 2, 3, 4 (every item once — no band inherits anything here;
   each is its own case). Invalid: 0 and 5 (the immediate outsides), plus
   one wildcard (9) and one negative (−3) for confidence.

**Suggested approach.** Else-if equality chain, 1→4, else → invalid.
Print name and price in the same branch (they're a matched pair —
Scenario 6's derive-together rule).

**Pseudocode.**

```text
READ item
IF item = 1 THEN PRINT "Samosa — 25 Rs"
ELSE IF item = 2 THEN PRINT "Chai — 15 Rs"
ELSE IF item = 3 THEN PRINT "Sandwich — 60 Rs"
ELSE IF item = 4 THEN PRINT "Juice — 40 Rs"
ELSE PRINT "No such item"
ENDIF
```

**Solution explanation.** The **menu dispatch** pattern: multi-way branch
on a single discrete value — the decision-tree cousin of Scenarios 7/8,
with three differences worth naming: conditions are *equalities*, not
ranges; order doesn't matter (no inheritance between branches — every
test is independent); and the fall-through else is the spec's "anything
else". In Unit 04 this becomes a `switch (item)` with `case 1: … case 4:
… default: …` — the same design, syntactically tidier, and you'll already
own the thinking. (Why care about a construct you haven't met? Because
Unit 05's menus — `do-while` + `switch` — are this pattern wearing a
loop.)

**C++ solution.**

```cpp
// s18_kiosk.cpp — Set D · Scenario 18
// Compile: g++ -std=c++17 -Wall -Wextra s18_kiosk.cpp -o s18

#include <iostream>

int main() {
    int item = 0;
    std::cout << "Item (1-4): ";
    std::cin  >> item;

    if (item == 1) {
        std::cout << "Samosa — 25 Rs\n";
    } else if (item == 2) {
        std::cout << "Chai — 15 Rs\n";
    } else if (item == 3) {
        std::cout << "Sandwich — 60 Rs\n";
    } else if (item == 4) {
        std::cout << "Juice — 40 Rs\n";
    } else {
        std::cout << "No such item\n";
    }
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 1 / 2 / 3 / 4 | each item's name and price |
| 0 | No such item ← just below the range |
| 5 | No such item ← just above |
| 9, −3 | No such item |

**Edge cases.** 0 and 5 (the range's immediate neighbours — a gap between
4 and 5, or a branch shifted by one, shows instantly), −3 (negatives are
invalid *by the complement*, not by an extra condition), and the missing
retry is an assumption edge: one-shot design, documented (Scenario 16's
kiosk would wrap this in the validation loop — same dispatch, new shell).

</details>

---

## Scenario 19 ★★★ — The persistent order-taker

**Problem statement.** A canteen window takes orders until the customer
finishes: item numbers 1–4 (prices as in Scenario 18) are added to the
bill; **0** finishes; any other number prints "No such item" and *does not
end the order*. At the end, print the **number of items** and the **bill
total**.

**Expected input.** A sequence of whole numbers ending with 0 (0 may be
the first number — an empty order).

**Expected output.**

```text
Item (1-4, 0 to finish): 3
Item (1-4, 0 to finish): 1
Item (1-4, 0 to finish): 7
No such item
Item (1-4, 0 to finish): 2
Item (1-4, 0 to finish): 0
Items: 3
Total: 100 Rs
```

**Constraints & assumptions.** Valid items add to the bill; 0 ends;
invalid ≠ end (the customer fumbles but continues). Empty orders are
legal (items 0, total 0).

**Thinking questions:**
1. Three input meanings now — add / finish / reject. How many states does
   the loop body distinguish, and what does each do to the accumulators?
2. Sentinel (Scenario 11) + dispatch (Scenario 18) composition: sketch the
   body's inner decision. Which cases touch `total`/`count`, and which
   touch neither?
3. Trace for input 3, 1, 7, 2, 0 — every row: item, effect, total,
   count. Predict the final lines *before* opening.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. Three cases: valid 1–4 → add price to `total`, +1 to `count`; 0 →
   (loop exits — no body action); anything else → print "No such item",
   accumulators untouched. Distinguishing these three *is* the design;
   everything else is Scenario 11 and 18 reassembled.
2. The body: `if (item >= 1 && item <= 4)` → add both accumulators; else
   `if (item != 0)` → complain; (0 needs no body branch — the loop
   condition handles it). Note the **range** test with `&&` for validity —
   contrast Scenario 18's equality chain: here we only need *valid vs
   not*, and prices come from a lookup-in-head (item→price needs another
   mini-dispatch inside — see the solution).
3. Trace:

| input | meaning | total | count | prints |
| --- | --- | --- | --- | --- |
| 3 | valid (60) | 60 | 1 | — |
| 1 | valid (25) | 85 | 2 | — |
| 7 | invalid | 85 | 2 | No such item |
| 2 | valid (15) | 100 | 3 | — |
| 0 | sentinel | 100 | 3 | (exit) |

Final: **Items 3, Total 100** — and the invalid 7 left no trace. ✓

**Suggested approach.** Sentinel WHILE (0 ends) + inside: one range
decision for "valid" with nested per-item prices (a small dispatch), one
else for "invalid-but-not-0". Accumulators updated *only* in the valid
branch.

**Pseudocode.**

```text
total ← 0
count ← 0
READ item
WHILE item ≠ 0 DO
    IF item >= 1 AND item <= 4 THEN
        IF item = 1 THEN price ← 25
        ELSE IF item = 2 THEN price ← 15
        ELSE IF item = 3 THEN price ← 60
        ELSE price ← 40
        ENDIF
        total ← total + price
        count ← count + 1
    ELSE
        PRINT "No such item"           (item ≠ 0 guaranteed here)
    ENDIF
    READ item
ENDWHILE
PRINT "Items: ", count
PRINT "Total: ", total, " Rs"
```

**Solution explanation.** The course's first genuinely **composed**
design: a sentinel loop (11) whose body contains a validation gate (16's
idea) and a dispatch (18) — and the composition raises the question that
makes this scenario worth ★★★: *where do the accumulators go?* They must
update in exactly one branch (valid); the invalid branch must be a
no-op on state but still print; and the sentinel must bypass the body
entirely (it's the WHILE condition, not an `if`). Trace rows are now the
*only* reliable reviewer — head-guessing a five-branch loop is how the
"7 became a silent charge" bug class is born. (The nested dispatch inside
the loop is also your first taste of Unit 05's menu programs — same
skeleton, switch + do-while, arriving in four weeks.)

**C++ solution.**

```cpp
// s19_orders.cpp — Set D · Scenario 19
// Compile: g++ -std=c++17 -Wall -Wextra s19_orders.cpp -o s19

#include <iostream>

int main() {
    int total = 0;
    int count = 0;

    int item = 1;                        // anything ≠ 0 to enter the loop
    while (item != 0) {
        std::cout << "Item (1-4, 0 to finish): ";
        std::cin  >> item;

        if (item >= 1 && item <= 4) {    // valid → price, add, count
            int price = 0;
            if (item == 1) {
                price = 25;
            } else if (item == 2) {
                price = 15;
            } else if (item == 3) {
                price = 60;
            } else {
                price = 40;
            }
            total = total + price;
            count = count + 1;
        } else if (item != 0) {          // invalid, but not the sentinel
            std::cout << "No such item\n";
        }
    }

    std::cout << "Items: " << count << "\n";
    std::cout << "Total: " << total << " Rs\n";
    return 0;
}
```

**Test cases.**

| Input sequence | Expected |
| --- | --- |
| 3, 1, 7, 2, 0 | Items 3 · Total 100 (invalid ignored) |
| 0 | Items 0 · Total 0 (empty order — no prompts' output beyond the first) |
| 9, 9, 0 | Items 0 · Total 0 (only complaints, then finish) |
| 1, 2, 3, 4, 0 | Items 4 · Total 140 |

**Edge cases.** First-input sentinel (empty order — the loop body must
never run), all-invalid then 0 (state untouched by complaints), each of
the four items once (dispatch coverage), consecutive invalids (no state
corruption), and the trace discipline: for any *new* sequence you try by
hand, extend the table — one row per input, no skips.

</details>

---

## Scenario 20 ★★★ — The stable temperature log (capstone of the module)

**Problem statement.** A cold-storage room logs its temperature once per
hour for **24 hours** (readings −30 … +10 °C). After the day, the log must
report: the **highest** and **lowest** reading, the **average** (one
decimal place is fine on paper), and an **alarm verdict**:
`SAFE` if the temperature *never* left the range −18 … −15 °C inclusive,
otherwise `ALARM` plus **how many hours** were out of range.

**Expected input.** Twenty-four whole numbers, one per hour.

**Expected output.**

```text
Highest: -15
Lowest : -19
Average: -16.6
Verdict: ALARM (1 hour(s) out of range)
```

**Constraints & assumptions.** Exactly 24 readings; each −30 … +10. The
safe band is **inclusive** (−18 and −15 are safe). The alarm threshold is
a *requirement* — encode it exactly.

**Thinking questions:**
1. Inventory the accumulators this needs — there are **five**. Name them,
   their types (count vs champion vs sum), and their starting values.
2. The verdict is a *derived* fact — which accumulator already holds it?
   (Derive, don't duplicate — Scenario 13's rule at three-way scale.)
3. Structure: one loop or two? (Could you compute the verdict in a second
   pass? What would that cost vs remembering an out-of-range counter?)
4. Trace plan: build the table for the 6-reading *mini-run* −16, −19, −15,
   −17, −14, −16 (pretend 24 → 6 for the dry run), then predict the final
   report. Which boundary rows matter?

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. Five: `highest` (champion, seed = first reading or −31 — below the
   floor), `lowest` (champion, seed = first or +11 — above the ceiling),
   `sum` (accumulator, 0), `outOfRange` (counter, 0), plus the loop
   variable `hour` (1–24). Champions and counters have different seeding
   rules — the set's recurring lesson, now with both in one program.
2. `outOfRange` already *is* the verdict: ALARM ⇔ `outOfRange > 0`. No
   separate "alarmHappened" flag needed — deriving beats duplicating.
3. **One loop.** A second pass would need the 24 readings *stored* — but
   we have no arrays yet (Unit 09), and the single-pass inventory above
   answers everything the report asks. Single-pass is also the
   professional habit for streams too big to store — a design constraint
   turned into a feature.
4. Mini-run trace (safe band −18…−15 inclusive):

| hour | reading | > highest? | < lowest? | in band? | sum | out |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | −16 | seed | seed | yes | −16 | 0 |
| 2 | −19 | no | yes → −19 | no (below −18) | −35 | 1 |
| 3 | −15 | no (tie) | no | yes ← boundary | −50 | 1 |
| 4 | −17 | no | no | yes | −67 | 1 |
| 5 | −14 | yes → −14 | no | no (above −15) | −81 | 2 |
| 6 | −16 | no | no | yes | −97 | 2 |

Report: highest −14, lowest −19, average −97/6 = **−16.2** (one decimal),
verdict **ALARM (2 hour(s))**. Boundary rows: −15 and −18 are *safe*
(inclusive) — the trace must show them as in-band; −19/−14 are the first
out-of-band steps on each side. (The page's sample output shows a
different 24-reading day — your trace outranks it, as Scenario 1 already
taught.)

**Suggested approach.** One FOR over 24 hours; five named accumulators;
inside: update both champions (strict `>` and `<`, seeding on hour 1),
add to sum, count out-of-band with a compound condition
(`r < -18 || r > -15` — an **or**, because "outside a range" has two
sides — Scenario 16's mirror-image); after: verdict by derivation,
average as a division.

**Pseudocode.**

```text
highest ← −31          (below every legal reading)
lowest  ← 11           (above every legal reading)
sum ← 0
outOfRange ← 0

FOR hour FROM 1 TO 24 DO
    READ r
    IF r > highest THEN highest ← r ENDIF
    IF r < lowest  THEN lowest  ← r ENDIF
    sum ← sum + r
    IF r < −18 OR r > −15 THEN
        outOfRange ← outOfRange + 1
    ENDIF
ENDFOR

average ← sum ÷ 24
IF outOfRange > 0 THEN
    PRINT "Verdict: ALARM (", outOfRange, " hour(s) out of range)"
ELSE
    PRINT "Verdict: SAFE"
ENDIF
PRINT highest, lowest, average
```

**Solution explanation.** The module's capstone because it composes
*everything*: seeded champions (17), a running sum (11), a conditional
counter (13), a compound boundary condition (9/16's or), and
derive-the-verdict (13's rule). The two-sided "outside the band" test
deserves its pause: *inside* is `r >= -18 && r <= -15` (and-of-near), so
*outside* is its negation — `r < -18 || r > -15` (or-of-far). Getting
this line right is the difference between an alarm that never fires and
one that fires correctly once a day; the trace's −15/−18/−14/−19 rows are
exactly the four probes that prove it. (In C++ we keep the average to a
whole/decimal note: `sum / 24.0` forces decimal division — a Unit 02
preview; on paper, one decimal place is fine.)

**C++ solution.**

```cpp
// s20_stable.cpp — Set D · Scenario 20
// Compile: g++ -std=c++17 -Wall -Wextra s20_stable.cpp -o s20

#include <iostream>

int main() {
    int highest = -31;        // below every legal reading
    int lowest  = 11;         // above every legal reading
    int sum = 0;
    int outOfRange = 0;

    int hour = 1;
    while (hour <= 24) {
        int r = 0;
        std::cout << "Hour " << hour << " reading: ";
        std::cin  >> r;

        if (r > highest) { highest = r; }
        if (r < lowest)  { lowest  = r; }
        sum = sum + r;

        if (r < -18 || r > -15) {        // outside the safe band (two sides!)
            outOfRange = outOfRange + 1;
        }
        hour = hour + 1;
    }

    double average = sum / 24.0;         // 24.0 forces decimal division

    std::cout << "Highest: " << highest << "\n";
    std::cout << "Lowest : " << lowest << "\n";
    std::cout << "Average: " << average << "\n";
    std::cout << "Verdict: ";
    if (outOfRange > 0) {
        std::cout << "ALARM (" << outOfRange << " hour(s) out of range)\n";
    } else {
        std::cout << "SAFE\n";
    }
    return 0;
}
```

**Test cases.**

| Input (24 readings) | Expected |
| --- | --- |
| the mini-run's values ×4 (−16,−19,−15,−17,−14,−16 repeated) | highest −14 · lowest −19 · ALARM (8 hours: 2 per repetition × 4) |
| −16 ×24 | all safe: highest/lowest −16, average −16.0, SAFE |
| −18 ×24 | boundary day: SAFE (inclusive band) |
| −15 ×12 then −18 ×12 | SAFE, average −16.5 (pure-boundary day) |
| −30 … mixed with +10 extremes | champions hit the legal extremes |

**Edge cases.** All-boundary days (−18 only, −15 only: SAFE — the band is
inclusive), one single out-of-range reading (ALARM with count 1 — the
smallest alarm), the first reading being the champion seed (hour 1 wins
both champions), readings at the legal extremes −30 and +10 (mass ALARM
— every hour counts), and the average's shape (a sum divisible by 24 vs
not — decimals appear; that's expected, not a bug).

</details>

---

**Module complete.** Continue to the
[Problem-Solving Lab](lab.md) — four practical tasks that put the whole
method in your hands — or revisit any set via the
[module home](index.md).

*[← Set C](scenarios-c.md) · [Module home](index.md) · [Lab →](lab.md)*
