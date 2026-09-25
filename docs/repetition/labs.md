---
title: "Iteration Labs"
description: "10 lab scenarios: drill instructor, canteen till, queue processor, honest teller, stubborn menu, guessing game, robust reader, warehouse scan, pattern studio, number lab."
---

# Iteration Labs (10)

> [← Module home](index.md) · Every lab: IPO on paper → pseudocode → dry-run table → code → test every row. LAR style: no functions, no arrays, `iostream`-only (plus `<iomanip>` where shown). **[Lab-0 conventions](../getting-started/getting-started-lab.md)** apply to all ten.

## Lab 1 — The drilling instructor

**Scenario.** A PT instructor drills cadets: each cadet does a fixed number of push-up sets. The instructor wants per-cadet totals and a class summary. This lab drills the [counting loop + accumulator](lesson-1-while.md) until it's automatic.

**Requirements.** Read `cadets` (1–20), then for each cadet read `sets` (1–10) and that many marks. Print each cadet's total; after all cadets print: class total, class average (2 dp), best cadet number + score.

**Sample run** (values in bold are typed input):

```text
Cadets? 2
Cadet 1 — sets? 2
  Set 1: 20
  Set 2: 30
Cadet 1 total: 50
Cadet 2 — sets? 3
  Set 1: 10
  Set 2: 25
  Set 3: 5
Cadet 2 total: 40
Class total: 90   average: 45.00   best: cadet 1 (50)
```

**Test table** (dry-run all rows):

| cadets | per-cadet marks | class total | average | best |
| --- | --- | --- | --- | --- |
| 2 | 20 30 / 10 25 5 | 90 | 45.00 | 1 (50) |
| 1 | 40 | 40 | 40.00 | 1 (40) |
| 3 | 5 5 / 5 5 5 / 5 5 5 | 45 | 15.00 | any (15) |
| 2 | 0 0 / 0 0 | 0 | 0.00 | 1 (0) |

**Dry-run skeleton** (fill before coding):

| cadet | i | sets | j (set) | mark | cadetTotal | classTotal | best |
| --- | - | ---- | ------- | ---- | ---------- | ---------- | ---- |
| 1 | 1 | 2 | 1 | 20 | 20 | 20 | — |
|   |   |   | 2 | 30 | 50 | 50 | 1 (50) |
| 2 | 2 | 3 | 1 | 10 | 10 | 60 | 1 (50) |
|   |   |   | 2 | 25 | 35 | 85 | 1 (50) |
|   |   |   | 3 | 5  | 40 | 90 | 1 (50) |

**Student tasks.** 1. Trace the sample run in the skeleton above. 2. Write the nested loop with both counters named for their jobs. 3. Best-cadet champion — why can't `best = 0` seed it? 4. Guard `cadets` = 0 (should print a message, divide nothing).

**Extensions.** ⭐ Print a `-` bar of length `cadetTotal / 10` under each cadet's total (a loop-printed chart). ⭐⭐ Reject any per-set mark that is negative — re-prompt without losing the cadet's place. ⭐⭐⭐ Print how many cadets tied for the best score (`Best: 50 by 2 cadet(s)`) — a `bestCount` beside the champion (`m > best` resets it to 1, `m == best` increments it) makes the tie *count* exact in one pass; printing *which* cadet numbers tied cannot be done in one pass. Document why.

**Guidance.** The nesting is two-level and independent: the inner loop's trip count comes from *this cadet's* `sets`, not from the outer variable — note that this differs from patterns, where the inner bound *is* the outer variable ([Lesson 4 §5](lesson-4-nested-digits-patterns.md#5-pattern-printing--rule--statement)). Reset `cadetTotal` **per cadet** (D6's shadow bug is waiting for exactly this). The champion compares *cadet totals*, so it updates only after each cadet's inner loop ends — never mid-cadet. Ties: a `bestCount` beside the champion gives the exact tie count in one pass; the tie *list* of cadet numbers needs the [arrays module](../arrays/index.md).

---

## Lab 2 — Canteen till

**Scenario.** The canteen's till takes continuous orders: dish code and quantity per item, 0 0 to close the till. Totals per category, count of items, and the day's take.

**Requirements.** Repeat until code `0`: read `code` (1 = drink 60, 2 = snack 120, 3 = meal 250, 0 = close). Read `qty` (1–50). Accumulate per-category takings and the item count; print a final receipt: per-category totals, item count, grand total.

**Sample run:**

```text
Item (code qty, 0 0 to close): 1 2
Item (code qty, 0 0 to close): 3 1
Item (code qty, 0 0 to close): 2 4
Item (code qty, 0 0 to close): 0 0
Drinks:   120.00
Snacks:   480.00
Meals:    250.00
Items:    3
TOTAL:    850.00
```

**Test table:**

| order stream | drinks | snacks | meals | items | total |
| --- | --- | --- | --- | --- | --- |
| 1 2 / 3 1 / 2 4 / 0 0 | 120 | 480 | 250 | 3 | 850 |
| 0 0 (immediate close) | 0 | 0 | 0 | 0 | 0 |
| 2 1 / 0 0 | 0 | 120 | 0 | 1 | 120 |
| 1 1 / 2 1 / 3 1 / 1 1 / 0 0 | 120 | 120 | 250 | 4 | 490 |

**Dry-run skeleton:**

| code | qty | drinkTotal | snackTotal | mealTotal | items | action |
| --- | --- | ---------- | ---------- | --------- | ----- | ------ |
| 1 | 2 | 120 | 0 | 0 | 1 | drink line |
| 3 | 1 | 120 | 0 | 250 | 2 | meal line |
| 2 | 4 | 120 | 480 | 250 | 3 | snack line |
| 0 | 0 | — | — | — | — | exit → receipt |

**Student tasks.** 1. Sentinel `0` for the *pair* — decide the exact condition (`code == 0` suffices; why?). 2. Route with `switch` inside the loop. 3. Guard qty out of range (skip the line with a message — how does the accumulator stay clean?). 4. Immediate close (0 items): what must the receipt show, and is division involved anywhere?

**Extensions.** ⭐ Count items per category too. ⭐⭐ Add code 4 (special 175) with a daily special name read once at open. ⭐⭐⭐ Print the best-selling category by *revenue* — three-way champion.

**Guidance.** This is the [sentinel + switch composition](lesson-3-break-continue-sentinels.md#5-menu-driven-programs--the-stage-b-showcase) at real scale. The qty guard decision ("skip vs re-prompt") changes the loop's contract — do it as ⭐⭐ only after the base works; document your choice.

---

## Lab 3 — The queue processor

**Scenario.** A help desk serves customers; each states their issue type and the service takes a fixed time. Simulate the queue and report.

**Requirements.** Read `customers` (0–15). For each: read `type` (A=5 min, B=8, C=12, X=quit-simulation early). Track a running clock (accumulates minutes), print each service's start and end time (minutes). X ends input immediately (stop reading, don't process it). Report: customers served, total service time, average (guard!), longest single service.

**Sample run:**

```text
Customers? 4
Type for customer 1: A
  Start 0, end 5
Type for customer 2: B
  Start 5, end 13
Type for customer 3: X
Simulation stopped early.
Served: 2   total time: 13 min   average: 6.50   longest: 8
```

**Test table:**

| customers | types | served | total | average | longest |
| --- | --- | --- | --- | --- | --- |
| 4 | A B X ... | 2 | 13 | 6.50 | 8 |
| 3 | A B C | 3 | 25 | 8.33 | 12 |
| 0 | — | 0 | 0 | (no avg line) | 0 |
| 2 | X A | 0 | 0 | (no avg line) | 0 |

**Dry-run skeleton:**

| i | type | start | end | served | clock | longest |
| - | ---- | ----- | --- | ------ | ----- | ------- |
| 1 | A | 0 | 5 | 1 | 5 | 5 |
| 2 | B | 5 | 13 | 2 | 13 | 8 |
| 3 | X | — | — | — | — | (break) |

**Student tasks.** 1. Map X to `break` vs a flag — implement one, justify in a comment. 2. Clock = accumulator; start = clock before, end = after. 3. Guard average when served = 0. 4. Why is the champion here *per-service minutes*, and where exactly is it updated?

**Extensions.** ⭐ Print a mini Gantt line per service: `[0----5)`. ⭐⭐ If the queue would end after 60 minutes, stop scheduling and print `Closing — X minutes of queue left unserved` (track remaining customers). ⭐⭐⭐ Two desks: alternate customers between desk 1 and 2, each with its own clock (state per desk — [C10](challenges.md#c10--the-run-detector)'s two-lifetime idea).

**Guidance.** The clock is a *derived* accumulator: you print *both* the before and after values — the first lab where the accumulator's mid-flight value is itself output. Average guard from [S17](exercises.md#s17--sentinel-prime-read) recurs.

---

## Lab 4 — The honest teller

**Scenario.** A bank teller validates withdrawal slips one by one. Each slip: account number and amount. Rules: amount must be a positive multiple of 500, at most 25000. Print per-slip verdicts, then a summary.

**Requirements.** Read `slips` (1–30). Per slip read account (6-digit, trust it) and amount. Rules, checked in this order: amount must be (a) positive, (b) a multiple of 500, (c) at most 25000. Print `OK` or the *first* failed rule with its value. After all slips: count OK, count each rejection reason, total valid amount.

**Sample run:**

```text
Slips? 3
Account: 100234 Amount: 8500
  OK
Account: 100235 Amount: 8300
  REJECT: not a multiple of 500 (8300)
Account: 100236 Amount: 27000
  REJECT: exceeds limit (27000)
OK: 1  not-multiple: 1  over-limit: 1  total valid: 8500
```

**Test table:**

| slips | amounts | OK | non-pos | not-mult | over | total valid |
| --- | --- | --- | --- | --- | --- | --- |
| 3 | 8500 8300 27000 | 1 | 0 | 1 | 1 | 8500 |
| 2 | 500 25000 | 2 | 0 | 0 | 0 | 25500 |
| 1 | 0 | 0 | 1 | 0 | 0 | 0 |
| 2 | 499 30000 | 0 | 0 | 1 | 1 | 0 |

**Dry-run skeleton:**

| i | amount | passes multiple? | passes limit? | verdict | counters |
| - | ------ | ---------------- | ------------- | ------- | -------- |
| 1 | 8500 | yes (17×500) | yes | OK | ok 1 |
| 2 | 8300 | no | (skipped) | not-multiple | nm 1 |
| 3 | 27000 | yes (54×500) | no | over-limit | ol 1 |

**Student tasks.** 1. Order the three rules deliberately — why must *positive* run before *multiple* (`0 % 500 == 0` is true!)? 2. Four counters + one accumulator in one loop. 3. Guard: the total-valid accumulator only grows on OK — trace that 8300 and 30000 contribute nothing. 4. The test table's third row: which counter does the 0-amount slip hit, and what would happen if the multiple check ran first?

**Extensions.** ⭐ Print `OK (17 notes of 500)` — the quotient as information. ⭐⭐ A daily cap: after 50000 total, further slips print `CASH LIMIT REACHED` without processing. ⭐⭐⭐ Read a `priority` flag; process all slips *and* print a second report listing only rejected slips (impossible without arrays — print them immediately in a side list format; feel the limitation).

**Guidance.** Guard chains from [decisions](../decisions/lesson-1-branches.md) inside a loop — validation logic per iteration. The 0-amount trap (`0 % 500 == 0` is true!) forces an explicit `amount <= 0` rule; document it in requirements *before* coding.

---

## Lab 5 — The stubborn menu

**Scenario.** A gym kiosk's menu must survive any user: wrong keys re-prompt, and nothing crashes. Compose the [menu pattern](lesson-3-break-continue-sentinels.md#5-menu-driven-programs--the-stage-b-showcase) with [validation gallery D](lesson-3-break-continue-sentinels.md#6-validation-loop-gallery--patterns-you-will-reuse-forever).

**Requirements.** Menu: 1 = BMI (read weight kg, height m; print BMI 2dp + band: <18.5 Under, <25 Normal, <30 Over, else Obese), 2 = 1RM estimate (read weight and reps 1–10; print weight × (1 + reps/30.0), 1dp), 3 = show greeting, 0 = quit. Non-numeric input anywhere must re-prompt (fail/clear/ignore). Menu itself re-shows on any other key with `Unknown option`.

**Test table:**

| action | input sequence | expected |
| --- | --- | --- |
| BMI | 1, 70, 1.75 | `BMI: 22.86 Normal` |
| BMI band edges | 1, 50, 1.6 / 1, 60, 1.6 / 1, 70, 1.6 / 1, 80, 1.6 | Under / Normal / Over / Obese |
| 1RM | 2, 100, 1 | `1RM: 103.3` |
| 1RM guard | 2, 100, 0 → re-prompt reps → 3 | `1RM: 110.0` |
| bad keys | 9, abc, 3 | `Unknown option` twice, greeting once |
| quit | 0 | `Bye!` |

**Dry-run skeleton** (BMI, 70 kg 1.75 m):

| step | value | computed | verdict |
| --- | --- | --- | --- |
| menu choice | 1 | — | route BMI |
| weight | 70 | — | valid |
| height | 1.75 | 70/3.0625 = 22.857... | prints 22.86 |
| band | 22.86 | < 25 | Normal |

**Student tasks.** 1. Draw the do-while/switch skeleton first, with `// TODO` bodies. 2. BMI decimal — why does `70 / (1.75*1.75)` already compute in `double`? 3. Make `readInt(prompt)` / `readDouble(prompt)` helpers *as commented blocks* you copy-paste (no functions yet!) — mark clearly that Stage C turns these into real functions. 4. Test every menu path incl. unknown keys twice.

**Extensions.** ⭐ Count sessions per option; print usage at quit. ⭐⭐ BMI bands with the boundary *owners* tested (22.49/22.5/24.99/25/29.99/30 — which band owns 25.0?). ⭐⭐⭐ Add option 4: quit confirmation `Sure? (y/n)` — n returns to the menu (state: you're inside a do-while inside a do-while).

**Guidance.** This is the Stage-B capstone of composition: menu + switch + two validation loops + formatting. The copy-paste helper blocks are honest scaffolding — label them, and revisit after [functions](../syllabus.md#stage-c-structure-units-7-9) to see how much code evaporates.

---

## Lab 6 — The guessing game

**Scenario.** The computer picks a number; the user guesses; the program coaches. First loop game — deterministic (no randomness): a fixed secret keeps testing honest.

**Requirements.** Secret is 42 (a named constant). Read guesses until correct: print `Too low` / `Too high` / `Correct!` and the attempt count. Reject out-of-range (1–100) guesses with a message that does NOT count as an attempt. Ask `Play again? (y/n)` after a win.

**Sample run:**

```text
Guess (1-100): 25
Too low
Guess (1-100): 75
Too high
Guess (1-100): 50
Too high
Guess (1-100): 42
Correct! Took 4 tries.
Play again? (y/n): n
```

**Test table:**

| secret | guess sequence | outcome |
| --- | --- | --- |
| 42 | 42 | Correct in 1 |
| 42 | 25 75 50 42 | Correct in 4 |
| 42 | 0 → re-prompt, 101 → re-prompt, 42 | Correct in 1 (invalids not counted) |
| 42 | 25, then 42 | Correct in 2 |

**Dry-run skeleton** (secret 42, guesses 25 75 50 42):

| attempt | guess | vs secret | feedback | attempts |
| --- | --- | --- | --- | --- |
| 1 | 25 | low | Too low | 1 |
| 2 | 75 | high | Too high | 2 |
| 3 | 50 | high | Too high | 3 |
| 4 | 42 | equal | Correct! | 4 |

**Student tasks.** 1. Which loop and why (must the body run first? — argue it with the §6 procedure). 2. Range guard *outside* the attempt counter — placement decision. 3. `constexpr int SECRET = 42;` at the top; no magic numbers. 4. Binary-search probing by hand: 50, 25, 37, 43 ... in ≤ 7 guesses for any secret — count yours.

**Extensions.** ⭐ After a win, report whether the player used binary search discipline (all guesses halved the remaining range — track remaining range yourself). ⭐⭐ Narrowing range display: show the current `(lo..hi)` window; then the player who probes 25 when lo..hi is 26..74 gets called out. ⭐⭐⭐ Two-player mode: player 1 enters the secret (print 30 blank lines to hide it); then player 2 guesses.

**Guidance.** The range guard is *two* nested validation loops (range re-prompt around the game loop) — or one loop with two jobs; do it as one loop with an explicit `attempts` rule. The play-again wrapper is [gallery C](lesson-3-break-continue-sentinels.md#6-validation-loop-gallery--patterns-you-will-reuse-forever) around the whole game — the do-while-in-do-while shape.

---

## Lab 7 — The robust reader

**Scenario.** A data-entry terminal must survive a whole shift of mistyped input: letters in numeric fields, out-of-range values, empty tries. The [validation gallery](lesson-3-break-continue-sentinels.md#6-validation-loop-gallery--patterns-you-will-reuse-forever) is the entire lab.

**Requirements.** Build one program that: reads a count n (robustly, 1–100), then n readings (robustly, 10–500). Then prints count, total, average, min, max — all idioms at once. Every field must re-prompt on: non-numeric input (`Numbers only, please.`), out-of-range (`Between 10 and 500, please.`). Non-numeric retries must not count as attempts.

**Test table:**

| step | user types | program does |
| --- | --- | --- |
| n | `abc` | `Numbers only, please.` |
| n | `150` | `Between 1 and 100, please.` |
| n | `3` | accepted |
| reading 1 | `-5` | range message |
| reading 1 | `hello` | numbers message |
| reading 1 | `200` | accepted |
| ... | 200, 300 | ... |

Final with 200/300/120: total 620, average 206.67, min 120, max 300.

**Dry-run skeleton** (for the n-loop only):

| attempt | input | fail()? | clear+ignore | in range? | outcome |
| --- | --- | --- | --- | --- | --- |
| 1 | abc | yes | happens | — | re-prompt |
| 2 | 150 | no | — | no | re-prompt |
| 3 | 3 | no | — | yes | accept |

**Student tasks.** 1. Compose gallery D (fail/clear/ignore) *and* A (range) into one reader — order matters (check fail first: why?). 2. Trace the reader on the test table. 3. Then the main idioms loop — note it now contains *no* validation; it trusts its inputs. 4. Prove the boundary: `n = 100` is accepted, `n = 101` is refused.

**Extensions.** ⭐ Track retry counts per field; print a "shift report" of retries. ⭐⭐ Reading sentinel with 0: readings of `0` mean "meter not read" — skip in stats but count them; the sentinel-vs-data question returns ([D8](debugging.md#d8--the-self-colliding-sentinel)). ⭐⭐⭐ Make the range itself a per-field parameter in your copy-paste helper block (min/max written once) — what would this look like as a function?

**Guidance.** Validation code is *infrastructure*: it doubles the program's size while adding zero features — which is exactly why professionals factor it (Stage C). Experience the duplication honestly here; the ⭐⭐⭐ points at the cure.

---

## Lab 8 — The warehouse scan

**Scenario.** Barcode scans arrive as integers until scan 0. Some scans are re-reads (the same code twice in a row is a double-beep misread) and must be ignored. Report stock movements.

**Requirements.** Read scans until 0. A scan equal to the *previous* scan is a misread: ignore it (count misreads). Valid scans: accumulate count, and count categories (1–99 = small, 100–499 = medium, ≥ 500 = large). Report: valid items, misreads, per-category counts, largest valid code (champion).

**Sample run:**

```text
Scan: 23
Scan: 23      (misread — ignored)
Scan: 410
Scan: 410     (misread — ignored)
Scan: 705
Scan: 0
Items: 3   misreads: 2
Small: 1   Medium: 1   Large: 1
Largest: 705
```

**Test table:**

| scan stream | items | misreads | S/M/L | largest |
| --- | --- | --- | --- | --- |
| 23 23 410 410 705 0 | 3 | 2 | 1/1/1 | 705 |
| 0 | 0 | 0 | 0/0/0 | (no largest line) |
| 5 5 5 0 | 1 | 2 | 1/0/0 | 5 |
| 10 20 20 20 30 0 | 3 | 2 | 2/1/0 | 30 |

**Dry-run skeleton:**

| scan | prev | == prev? | category | counters | prev after |
| ---- | ---- | -------- | -------- | -------- | ---------- |
| 23 | 0 | no | small | items 1 | 23 |
| 23 | 23 | yes → ignore | — | misreads 1 | 23 |
| 410 | 23 | no | medium | items 2 | 410 |
| 410 | 410 | yes | — | misreads 2 | 410 |
| 705 | 410 | no | large | items 3 | 705 |
| 0 | — | sentinel | — | — | exit |

**Student tasks.** 1. `prev` must survive between passes — where is it declared, when updated? 2. This is [C10's](challenges.md#c10--the-run-detector) run-tracking with one simplification (any repeat counts). 3. Champion + category counters + misread counter in one loop — the full idiom set. 4. Empty stream (0 first): what prints instead of `Largest:`? Guard it.

**Extensions.** ⭐ Track the *longest* misread streak (consecutive misreads). ⭐⭐ A scan of a *cancelled* item (−1) undoes the previous item if the previous was valid (a simple undo: category count −1, items −1 — think through whether prev should also revert). ⭐⭐⭐ Two consecutive identical scans = misread, but three in a row = a real triple-quantity read (count as 3 items of that code) — a genuine state machine.

**Guidance.** `prev` is a new kind of variable: *state that crosses loop passes* — neither counter nor accumulator. C10 generalizes this; the ⭐⭐⭐ shows why run-length logic is the seed of data compression.

---

## Lab 9 — The pattern studio

**Scenario.** A print shop needs row-rule patterns for banners. Each pattern is a [rule → statement](lesson-4-nested-digits-patterns.md#5-pattern-printing--rule--statement) translation.

**Requirements.** Read h (2–9). Print, each pattern clearly labelled: (a) left triangle, row r has r stars; (b) left triangle shrinking: row r has `h−r+1` stars; (c) number triangle printing column numbers; (d) same but printing row numbers; (e) rectangle h×(2h) hollow ([C12](challenges.md#c12--hollow-rectangle) rule).

**Sample** (h = 4): (a) `*` / `* *` / `* * *` / `* * * *`; (b) `* * * *` / `* * *` / `* *` / `*`; (c) `1` / `1 2` / `1 2 3` / `1 2 3 4`; (d) `1` / `2 2` / `3 3 3` / `4 4 4 4`; (e) 4×8 border.

**Test table:**

| h | (a) rows | (b) row 1 | (c) last row | (d) last row | (e) checks |
| - | --- | --- | --- | --- | --- |
| 4 | 4 | 4 stars | 1 2 3 4 | 4 4 4 4 | border only, 8 wide |
| 2 | 2 | 2 | 1 2 | 2 2 | 2×4 |
| 9 | 9 | 9 | 1..9 | 9×9 | 9×18 |

**Dry-run skeleton** (pattern (a), h = 4):

| r | inner cond | prints | newline after |
| - | ---------- | ------ | ------------- |
| 1 | c <= 1 | `*` | yes |
| 2 | c <= 2 | `* *` | yes |
| 3 | c <= 3 | `* * *` | yes |
| 4 | c <= 4 | `* * * *` | yes |

**Student tasks.** 1. For each pattern write the row rule in words *first*; translate only then. 2. (c) vs (d): one printed variable differs — state which and why the output differs. 3. Trace (b)'s inner bound for h = 4, rows 1–2. 4. (e): write the border condition as one four-way OR.

**Extensions.** ⭐ Add (f): binary triangle `1 / 1 0 / 1 0 1 ...` (parity of column). ⭐⭐ Add (g): hollow triangle (border of the triangle — condition r == 1 or r == h or c == r). ⭐⭐⭐ Add (h): the pyramid of [C13](challenges.md#c13--pyramid) with both formulas derived on paper in your write-up.

**Guidance.** Patterns (a)–(d) are the full [S29/S30](exercises.md#s30--number-triangle) family; (e)–(g) add the 2D condition. The studio's lesson: derive the rule on paper first — patterns are never debugged into existence.

---

## Lab 10 — The number lab

**Scenario.** A maths-tutor tool: for any n in range, print a mini report of number properties — every [Lesson 4](lesson-4-nested-digits-patterns.md) technique in one program.

**Requirements.** Read n (1–99999, validated). Print: digit count, digit sum, reversed n, palindrome verdict, factorial of the digit count, prime verdict (divisor count), divisor count itself, and the sum of all divisors of n including n. Then a `Another n? (y/n)` loop (gallery C).

**Sample run:**

```text
n (1-99999): 4729
Digits: 4   digit sum: 22   reversed: 9274   palindrome: no
Prime: yes  divisors: 2    divisor sum: 4730
Factorial of digit count (4!): 24
Another n? (y/n): y
n (1-99999): 1221
Digits: 4   digit sum: 6   reversed: 1221   palindrome: yes
Prime: no   divisors: 8    divisor sum: 1824
Factorial of digit count (4!): 24
Another n? (y/n): n
Done.
```

*Worked check for 1221 = 3 × 11 × 37: divisors 1, 3, 11, 33, 37, 111, 407, 1221 → 8 divisors, sum 1824. (4729 is prime: no divisor found up to 68 = ⌊√4729⌋.)*

**Test table:**

| n | digits | sum | reversed | palindrome | prime | divisors | divisor sum | fact line |
| - | ------ | --- | -------- | ---------- | ----- | -------- | ----------- | --------- |
| 4729 | 4 | 22 | 9274 | no | **yes** | 2 | 4730 | 24 |
| 1221 | 4 | 6 | 1221 | yes | no | 8 | 1824 | 24 |
| 12 | 2 | 3 | 21 | no | no | 6 | 28 | 2 |
| 1 | 1 | 1 | 1 | yes | no (n>1 guard) | 1 | 1 | 1 |
| 0 (rejected) | — | — | — | — | — | — | — | — |

**Dry-run skeleton** (digit loop for 4729):

| pass | n | last | sum | count | n/10 |
| ---- | - | ---- | --- | ----- | ---- |
| 1 | 4729 | 9 | 9 | 1 | 472 |
| 2 | 472 | 2 | 11 | 2 | 47 |
| 3 | 47 | 7 | 18 | 3 | 4 |
| 4 | 4 | 4 | 22 | 4 | 0 |

**Student tasks.** 1. Which techniques consume n — and which need the original? Plan the copies. 2. The divisor loop runs to n (accept the slowness; note the √n upgrade path from [Lesson 4 §4](lesson-4-nested-digits-patterns.md#4-primes--the-divisor-count-method)). 3. The factorial block: which loop never runs for n = 1 (digit count 1 → 1! = 1), and why is the accumulator already correct? 4. y/n wrapper: which gallery pattern, and what happens on `Y`?

**Extensions.** ⭐ Add "largest digit" and "smallest digit" champions inside the digit loop. ⭐⭐ Perfect-number check ([C1](challenges.md#c1--perfect-numbers)'s property test). ⭐⭐⭐ Print all divisors *and* whether n is "abundant" (divisor sum excluding n exceeds n) — needs the divisor loop to also accumulate.

**Guidance.** The composition discipline: each property is a small self-contained block with its own loop and its own variable names — *never* share loop variables across blocks. The divisor-sum block is the accumulator idiom on a nested property; the factorial block is the multiplying accumulator with a guard. This lab is the [mini-project](miniproject.md) in miniature.

---

## After the labs

Completed all ten? You've used every idea in Stage B's toolkit at integration scale. The [mini-project](miniproject.md) now asks you to *design* with them — and the [functions module](../functions/index.md) makes the reader helpers, validators, and idiom blocks disappear into functions.
