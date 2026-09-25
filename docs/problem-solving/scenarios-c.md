---
title: "Scenarios — Set C: Repetition (11–15)"
description: "Five problems that loop: totals, counting, tables — with full trace tables."
---

# Set C — Repetition (Scenarios 11–15)

> ★★ difficulty · 10–15 min honest attempt each · [← Module home](index.md) ·
> [← Set B](scenarios-b.md)

These five use the **repetition** pattern and its constant companion the
**accumulator** ([lesson §14](lesson.md#14-repetition)). The discipline
that matters most here is the **trace table**
([§15–16](lesson.md#1516-dry-runs-and-trace-tables)): loops are where
hand-execution stops being optional — a 5-iteration loop guessed at in
your head *will* hide a bug that a 5-row table catches instantly.

**New C++ in this set** (formally Units 05–06; explained inline): the
`while` loop — `while (condition) { … }` — repeats the block as long as
the condition holds; and `count = count + 1;` (often written `count++`)
to update accumulators.

**The three questions to answer before writing any loop:**
1. What repeats? (the body)
2. What changes each time, so the loop eventually stops? (the update)
3. What value must the running variable/accumulator *start* from? (the
   initialisation — zero for sums, the champion for min/max, 1 for
   counting steps that start at 1)

---

## Scenario 11 ★★ — Counting the collection jar

**Problem statement.** A class counts its fundraising jar: coins are
dropped one at a time, and the treasurer types each coin's value until the
jar is empty — signalled by typing **0**. Print the **total money** and
the **number of coins**.

**Expected input.** Whole numbers, one per line (1, 2, or 5 rupee coins),
ending with the sentinel **0**.

**Expected output.**

```text
Total: 23 Rs
Coins: 6
```

**Constraints & assumptions.** Coin values are 1, 2, or 5; the sentinel 0
ends the input and is *not* a coin. At least one coin exists before the
sentinel (the jar is not counted empty-empty).

**Thinking questions:**
1. Which loop shape fits — a counted FOR ("do 10 times") or a WHILE with a
   stopping condition? What *is* the stopping condition?
2. Two accumulators run at once (total, count). What must each start at?
3. Trace table: for input 5, 2, 1, 5, 2, 5, 0 — fill every row *before*
   opening. What total and count do you predict?

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. WHILE with a **sentinel** ([lesson §14](lesson.md#14-repetition)): we
   don't know the number of coins in advance — we know the *stop sign*.
   Condition: "the value just read is not 0". This is the read →
   process → read-again shape; forgetting the second read is the classic
   infinite loop here.
2. Both start at **0** — sums and counts start empty. Starting `count` at
   1 is the classic first-coin miscount.
3. Trace (coins 5,2,1,5,2,5 then 0):

| step | coin | total | count |
| --- | --- | --- | --- |
| start | – | 0 | 0 |
| 1 | 5 | 5 | 1 |
| 2 | 2 | 7 | 2 |
| 3 | 1 | 8 | 3 |
| 4 | 5 | 13 | 4 |
| 5 | 2 | 15 | 5 |
| 6 | 5 | 20 | 6 |
| (read 0 → stop) | 0 | 20 | 6 |

Predicted: **total 20, coins 6** — count the actual coins in that list:
5,2,1,5,2,5 is six coins summing to 20. (If your trace said 23, you added
the sentinel — proof the table works.)

**Suggested approach.** Sentinel WHILE with two accumulators; read, check,
process, read again. The "process then re-read" order keeps the sentinel
out of the arithmetic.

**Pseudocode.**

```text
total ← 0
count ← 0
READ coin
WHILE coin ≠ 0 DO
    total ← total + coin
    count ← count + 1
    READ coin                      (read again — moves toward the stop)
ENDWHILE
PRINT "Total: ", total, " Rs"
PRINT "Coins: ", count
```

**Solution explanation.** The sentinel pattern's three beats: **prime**
(read once before the loop, so the condition has something true to test),
**process** (accumulate only when the value is real), **advance** (read
again at the loop's end). Every WHILE you write this year should make you
ask the three questions from the set header — here they're: repeats =
accumulate+read; changes = `coin` (eventually 0); starts = both
accumulators 0. The output *after* the loop, once — not inside.

**C++ solution.**

```cpp
// s11_jar.cpp — Set C · Scenario 11
// Compile: g++ -std=c++17 -Wall -Wextra s11_jar.cpp -o s11

#include <iostream>

int main() {
    int total = 0;
    int count = 0;

    int coin = 0;
    std::cout << "Coin value (0 to finish): ";
    std::cin  >> coin;                       // prime the loop

    while (coin != 0) {                      // stop condition: sentinel seen
        total = total + coin;                // accumulator 1
        count = count + 1;                   // accumulator 2
        std::cout << "Coin value (0 to finish): ";
        std::cin  >> coin;                   // advance: read again
    }

    std::cout << "Total: " << total << " Rs\n";
    std::cout << "Coins: " << count << "\n";
    return 0;
}
```

**Test cases.**

| Input sequence | Expected |
| --- | --- |
| 5, 2, 1, 5, 2, 5, 0 | Total 20 · Coins 6 |
| 1, 0 | Total 1 · Coins 1 |
| 5, 5, 5, 0 | Total 15 · Coins 3 |

**Edge cases.** Single coin then sentinel (the minimum legal jar —
total 1, coins 1); many 2s (even/odd totals parity check); *first value is
the sentinel* — excluded by assumptions, but notice: the loop body never
runs, total stays 0, coins 0 — a graceful zero, worth knowing your code
does that rather than crashing.

</details>

---

## Scenario 12 ★★ — The thunderstorm countdown

**Problem statement.** A weather station prints a countdown of the minutes
until a storm arrives, one per line, from the given number down to 1, then
prints "STORM ALERT". Given the starting minutes, produce the full
countdown.

**Expected input.** One whole number: starting minutes (1 … 120).

**Expected output.** *(for input 3)*

```text
3
2
1
STORM ALERT
```

**Constraints & assumptions.** Start value is 1–120. Countdown includes
the starting number and includes 1 (it stops *after* 1 — then the alert).

**Thinking questions:**
1. Counting *down* needs a variable that moves toward the stop. Write the
   loop condition: for start = 3, how many times must the body run?
2. What must the variable start as, and what is the update? (Compare with
   Scenario 11: there the *input* moved; here *your own variable* moves.)
3. Trace for start = 3: rows for each body run, and the values of your
   variable at each check.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. Condition: `minutes > 0` (keep going while minutes remain). For start 3
   the body runs exactly **3** times — once per value 3, 2, 1. Counting
   the runs *before* coding is how you'll know your loop isn't off by one.
2. Starts at the given minutes; the update is `minutes = minutes - 1` — a
   **count-down accumulator**. The loop must reach `minutes = 0`, where
   `> 0` fails and the loop exits — that's the stop *you* built in.
3. Trace:

| check | minutes (at check) | body runs? | prints |
| --- | --- | --- | --- |
| 1 | 3 | yes | 3 |
| 2 | 2 | yes | 2 |
| 3 | 1 | yes | 1 |
| 4 | 0 | no — exit | (then STORM ALERT) |

Body ran 3 times ✓, alert printed once after. ✓

**Suggested approach.** WHILE with a counting-down variable; the alert
prints **after** the loop — a one-time event, so it lives outside.

**Pseudocode.**

```text
READ minutes
WHILE minutes > 0 DO
    PRINT minutes
    minutes ← minutes − 1
ENDWHILE
PRINT "STORM ALERT"
```

**Solution explanation.** Same skeleton as Scenario 11 — condition check,
body, update — but the *moving* value is now one we own, not user input.
The two classic errors are both visible in the trace: printing the 0
(put the alert's print inside wrongly and you'd print `0` too — the
condition stops at 0 *before* the body runs) and forgetting the update
(missing `minutes − 1` = infinite 3 3 3 …: the trace table shows a body
that never changes the checked value — the lesson's §14 red flag). The
alert's placement (inside vs after) is decided by *meaning*: it happens
once, after all minutes — not once per minute.

**C++ solution.**

```cpp
// s12_countdown.cpp — Set C · Scenario 12
// Compile: g++ -std=c++17 -Wall -Wextra s12_countdown.cpp -o s12

#include <iostream>

int main() {
    int minutes = 0;
    std::cout << "Minutes until storm: ";
    std::cin  >> minutes;

    while (minutes > 0) {
        std::cout << minutes << "\n";
        minutes = minutes - 1;      // move toward the stop
    }

    std::cout << "STORM ALERT\n";
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 3 | 3, 2, 1, STORM ALERT |
| 1 | 1, STORM ALERT |
| 10 | 10 … 1, STORM ALERT (ten numbers) |

**Edge cases.** Start 1 (the minimum: exactly one number — a loop that
runs "at least once but not twice" catches off-by-ones on both ends);
start 2 (does it print 2 then 1, or skip 1?); start 120 (maximum — count
the output lines: 120 numbers + 1 alert).

</details>

---

## Scenario 13 ★★ — The exam-pass check for one class

**Problem statement.** A tutor enters the marks of **exactly 8 students**
(one per line, 0–100). Print **how many passed** (50 or more) and **how
many failed**.

**Expected input.** Eight whole numbers (0 … 100).

**Expected output.**

```text
Passed: 5
Failed: 3
```

**Constraints & assumptions.** Exactly eight marks; each is 0–100 (no
validation yet). "Pass" means 50 or more — the boundary is inclusive.

**Thinking questions:**
1. The count is *known* (8). Which loop shape now — FOR or WHILE? What
   runs through the loop: the marks, or the count of marks so far?
2. How many accumulators? What are they, and are they independent? (Can
   you compute one from the other at the end instead of tracking both?)
3. Boundary thinking: is 49 a pass? 50? Write the condition, then the
   trace table for input 60, 45, 50, 0, 90, 49, 100, 30.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. FOR — the repetition count is known in advance: `FOR student FROM 1 TO
   8`. The loop variable counts *students*, not marks; the marks arrive
   one per iteration.
2. Two accumulators: passed, failed — but they're **dependent**: every
   student is one or the other, so `failed = 8 − passed` at the end.
   Tracking one accumulator is simpler and removes a whole class of
   drift bugs. (Tracking both is also acceptable — the design note is:
   notice the dependency, choose deliberately.)
3. 49 fails, 50 passes (`>= 50`). Trace for the given input:

| student | mark | mark ≥ 50? | passed (after) |
| --- | --- | --- | --- |
| 1 | 60 | yes | 1 |
| 2 | 45 | no | 1 |
| 3 | 50 | yes ← boundary | 2 |
| 4 | 0 | no | 2 |
| 5 | 90 | yes | 3 |
| 6 | 49 | no ← just below | 3 |
| 7 | 100 | yes | 4 |
| 8 | 30 | no | 4 |

Predicted: passed 4, failed 4. (The sample output above showed 5/3 for a
*different* mark set — your trace is the truth for *your* input.)

**Suggested approach.** FOR loop over 8 students; one accumulator
(`passed`); boundary test with `>=`; derive failed at the end.

**Pseudocode.**

```text
passed ← 0
FOR student FROM 1 TO 8 DO
    READ mark
    IF mark >= 50 THEN
        passed ← passed + 1
    ENDIF
ENDFOR
PRINT "Passed: ", passed
PRINT "Failed: ", 8 − passed
```

**Solution explanation.** The **counting-accumulator** pattern: one
variable incremented only when the body's data meets a condition. The
decision lives *inside* the loop but is a plain Scenario-7-style
comparison — composition, not new machinery. The `8 − passed` trick is
worth naming: **derive, don't duplicate** — one source of truth per fact.
(Compare: if you tracked `failed` separately and forgot to increment it on
one path, the two would disagree, and "passed + failed = 8" — your free
invariant — would break silently.)

**C++ solution.**

```cpp
// s13_passcount.cpp — Set C · Scenario 13
// Compile: g++ -std=c++17 -Wall -Wextra s13_passcount.cpp -o s13

#include <iostream>

int main() {
    int passed = 0;

    int student = 1;
    while (student <= 8) {              // FOR-student-from-1-to-8, C++-style
        int mark = 0;
        std::cout << "Mark " << student << ": ";
        std::cin  >> mark;

        if (mark >= 50) {               // boundary: 50 passes
            passed = passed + 1;
        }
        student = student + 1;          // advance (never forget!)
    }

    std::cout << "Passed: " << passed << "\n";
    std::cout << "Failed: " << 8 - passed << "\n";
    return 0;
}
```

**Test cases.**

| Input (8 marks) | Expected |
| --- | --- |
| 60, 45, 50, 0, 90, 49, 100, 30 | Passed 4 · Failed 4 |
| 50, 50, 50, 50, 50, 50, 50, 50 | Passed 8 · Failed 0 |
| 0, 0, 0, 0, 0, 0, 0, 0 | Passed 0 · Failed 8 |

**Edge cases.** All-exactly-50 (every mark sits *on* the boundary —
tests `>=` vs `>`), all zeros, alternating pass/fail, and 100s (top
edge). Notice the loop *count* edges matter too: eight prompts must
appear — run it and count; the day you write 9 iterations by mistake is
the day this habit pays.

</details>

---

## Scenario 14 ★★★ — The weekly savings tracker

**Problem statement.** A student saves money for 6 weeks. Each week has a
target of 100 rupees. For each week, the student's saving is entered; the
tracker prints, **per week**, whether the target was met ("OK") or missed
("SHORT" plus how much short), and at the end prints the **total saved**
and the **weeks that met the target**.

**Expected input.** Six whole numbers (0 … 1000), one per week.

**Expected output.**

```text
Week 1: OK        (120)
Week 2: SHORT by 40  (60)
Week 3: OK        (105)
...
Total saved: 530 Rs
Weeks on target: 4
```

**Constraints & assumptions.** Exactly 6 weeks; savings are whole numbers
0–1000. "Met" means reached 100 or more (inclusive boundary again).

**Thinking questions:**
1. Two accumulators (total, weeks-on-target) plus **per-week** output
   inside the loop. What belongs *inside* the loop and what *after*? Make
   the list.
2. The per-week line needs the week number — where does it come from?
3. Trace for savings 120, 60, 105, 100, 0, 145: fill the table (week,
   saving, verdict, total-so-far, on-target-so-far) and predict the final
   two lines.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. Inside: read saving, decide verdict, **print the week's line**, update
   both accumulators. After: the two summary lines. The test is "does this
   action happen once *per week* (inside) or once *for the whole report*
   (after)?" — the same question as Scenario 12's alert placement, now
   with three inside-items.
2. From the **loop variable** — the FOR's counter is the week number
   (1–6). Printing it is why the loop variable exists; never hand-count.
3. Trace:

| week | saving | verdict | total-so-far | on-target-so-far |
| --- | --- | --- | --- | --- |
| 1 | 120 | OK | 120 | 1 |
| 2 | 60 | SHORT by 40 | 180 | 1 |
| 3 | 105 | OK | 285 | 2 |
| 4 | 100 | OK ← boundary | 385 | 3 |
| 5 | 0 | SHORT by 100 | 385 | 3 |
| 6 | 145 | OK | 530 | 4 |

Final: total **530**, on-target **4**.

**Suggested approach.** FOR 1..6; two accumulators; decision inside
(>= 100); SHORT amount derived as `100 - saving` (only meaningful in that
branch — another derive-don't-duplicate); summary after.

**Pseudocode.**

```text
total ← 0
onTarget ← 0
FOR week FROM 1 TO 6 DO
    READ saving
    total ← total + saving
    IF saving >= 100 THEN
        PRINT "Week ", week, ": OK (", saving, ")"
        onTarget ← onTarget + 1
    ELSE
        PRINT "Week ", week, ": SHORT by ", 100 − saving, " (", saving, ")"
    ENDIF
ENDFOR
PRINT "Total saved: ", total, " Rs"
PRINT "Weeks on target: ", onTarget
```

**Solution explanation.** This is Set C's synthesis: **FOR** (known count)
+ **accumulators** (two) + a **decision** per iteration + inside/after
placement discipline. The trace table now has five columns and *still*
catches the classics: forgetting `total` update (column freezes), boundary
100 (row 4 must say OK), and the SHORT arithmetic (40 = 100 − 60, printed
from the derivation, never hand-typed). Note what the loop does NOT
decide: nothing about *earlier* weeks is re-examined — each week is
processed once, fully, and forgotten. That "process one item completely"
mindset is what makes loops scale to 600 weeks or 6 million.

**C++ solution.**

```cpp
// s14_savings.cpp — Set C · Scenario 14
// Compile: g++ -std=c++17 -Wall -Wextra s14_savings.cpp -o s14

#include <iostream>

int main() {
    int total = 0;
    int onTarget = 0;

    int week = 1;
    while (week <= 6) {
        int saving = 0;
        std::cout << "Week " << week << " saving: ";
        std::cin  >> saving;

        total = total + saving;

        if (saving >= 100) {
            std::cout << "Week " << week << ": OK (" << saving << ")\n";
            onTarget = onTarget + 1;
        } else {
            std::cout << "Week " << week << ": SHORT by "
                      << 100 - saving << " (" << saving << ")\n";
        }
        week = week + 1;
    }

    std::cout << "Total saved: " << total << " Rs\n";
    std::cout << "Weeks on target: " << onTarget << "\n";
    return 0;
}
```

**Test cases.**

| Input (6 savings) | Expected |
| --- | --- |
| 120, 60, 105, 100, 0, 145 | Total 530 · On-target 4 (per-week lines per trace) |
| 100, 100, 100, 100, 100, 100 | Total 600 · On-target 6 (all on the boundary) |
| 0, 0, 0, 0, 0, 0 | Total 0 · On-target 0 (every line SHORT by 100) |

**Edge cases.** Saving exactly 100 (boundary row), saving 0 (minimum —
SHORT by 100), all-boundary and all-zero runs (accumulators at their
extremes), 145 (does your "SHORT" arithmetic stay sane when the branch
isn't taken? It must never print for OK weeks).

</details>

---

## Scenario 15 ★★★ — Times table, tidily

**Problem statement.** Print the multiplication table of a given number
`n` from ×1 to ×12, one line each, aligned as:

```text
7 x  1 =  7
7 x  2 = 14
...
7 x 12 = 84
```

**Expected input.** One whole number: n (1 … 12).

**Expected output.** Twelve lines as above — note the **spacing**: the
multiplier column and the result column are right-aligned to two digits in
the example.

**Constraints & assumptions.** n is 1–12. Alignment "like the example" —
a *constraint* (§7): numbers up to 144 need at most 3 characters.

**Thinking questions:**
1. What is the loop's counter, its start, its stop — and *which* of those
   come from the input vs are fixed?
2. The line has four varying parts (n, multiplier, product). Which are
   known before the loop, which change per iteration?
3. Alignment on paper: for n = 7, list products 7, 14, …, 84 — how many
   characters wide is the widest? What would break if you padded to 2
   characters anyway?
4. Trace the loop variable and product for the first three and the last
   iteration.

<details markdown="1">
<summary><strong>Open: approach, pseudocode, solution</strong></summary>

**Thinking questions — answered.**
1. The counter is the multiplier: starts at 1, stops after 12 — both
   *fixed by the requirement*; only `n` comes from input. (A FOR 1..12.)
2. Before the loop: `n` (read once). Per iteration: multiplier (the
   counter itself — not a second variable!), product (`n × multiplier`,
   computed fresh each time).
3. Widest product: 144 (3 chars for n = 12). Padding to 2 breaks at 100+
   for the *product* column — but for n ≤ 12 products reach 144, so the
   example's 2-space alignment is only correct for products < 100…
   catch: for n = 12, `12 x 12 = 144` *cannot* fit the 2-char result
   column; the requirement says "like the example", and the honest design
   is right-align to the widest for the chosen n, or accept the example's
   minor raggedness at 12. Deciding this **is** the constraint analysis —
   document your choice in the write-up.
4. Trace (n = 7):

| check | multiplier | product (printed) |
| --- | --- | --- |
| 1 | 1 | 7 |
| 2 | 2 | 14 |
| 3 | 3 | 21 |
| … | … | … |
| 12 | 12 | 84 |
| 13 | — | exit (13 > 12) |

**Suggested approach.** FOR 1..12 over the multiplier; compute the product
inside; print with the counter *and* the product; decide alignment by the
constraint analysis in Q3 — simplest honest choice: print natural numbers
with a single space, or right-align to 3 for guaranteed tidiness.

**Pseudocode.**

```text
READ n
FOR multiplier FROM 1 TO 12 DO
    product ← n × multiplier
    PRINT n, " x ", multiplier, " = ", product
ENDFOR
```

**Solution explanation.** The **table-generation** pattern: the loop
variable *is* one of the printed columns — no separate counter, no
second loop. Note what the trace fixed before it became a bug: writing
`multiplier = multiplier + 1` *and* a FOR would double-advance (the FOR
owns the counter); and the product is recomputed per iteration from the
counter — never stored across iterations (it has no memory between rows).
Compared with Set A's straight-line scenarios, the only new skill is
letting the loop variable do double duty as data — a small step in code,
the normal way of thinking in every table/histogram/report task later
(Unit 06, the Pattern & Table Studio, is exactly this scenario with
shapes).

**C++ solution.**

```cpp
// s15_table.cpp — Set C · Scenario 15
// Compile: g++ -std=c++17 -Wall -Wextra s15_table.cpp -o s15

#include <iostream>

int main() {
    int n = 0;
    std::cout << "Table of: ";
    std::cin  >> n;

    int multiplier = 1;
    while (multiplier <= 12) {
        int product = n * multiplier;     // fresh each row
        std::cout << n << " x " << multiplier << " = " << product << "\n";
        multiplier = multiplier + 1;
    }
    return 0;
}
```

**Test cases.**

| Input | Expected |
| --- | --- |
| 7 | rows `7 x 1 = 7` … `7 x 12 = 84` |
| 1 | `1 x 1 = 1` … `1 x 12 = 12` |
| 12 | `12 x 1 = 12` … `12 x 12 = 144` |

**Edge cases.** n = 1 (every product equals the multiplier — a natural
correctness check), n = 12 (the largest products, alignment stress),
count the rows: exactly 12 — never 11 or 13.

</details>

---

*[← Set B](scenarios-b.md) · [Module home](index.md) ·
[Set D — Combining everything →](scenarios-d.md)*
