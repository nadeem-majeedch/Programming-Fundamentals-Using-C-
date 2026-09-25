---
title: "Functions Labs"
description: "8 design labs — every program is a function team. Scenario, function table, test rows, student tasks, extensions, and guidance for each."
---

# Functions Labs (8)

> [← Module home](index.md) · **House rules for all eight labs:** prototypes → `main` → definitions; no mutable globals; compute/print split ([Lesson 1 §6](lesson-1-machine.md#6-void-functions--machines-that-only-act)); every pure function ships with its test table; `main` narrates. Lab-0 [conventions](../getting-started/getting-started-lab.md) otherwise apply.

## Lab 1 — The conversion desk

**Scenario.** A weather station converts between scales all day. Build the conversion *desk*, not one program.

**Requirements.** Functions: `toCelsius(double f)`, `toFahrenheit(double c)`, and `void printRow(double v, char scale)` (prints one aligned conversion line). `main`: read a scale choice, read a value (validated), print the converted value with both units, then `Another? (y/n)`.

**Function table** (fill this *first*, in your write-up):

| Function | Takes | Returns | Alone-testable |
| --- | --- | --- | --- |
| `toCelsius` | double f | double | yes — pure |
| `toFahrenheit` | double c | double | yes |
| `printRow` | value, scale | void | via its parts |

**Test rows** (expected values you must verify by hand):

| call | expected |
| --- | --- |
| `toCelsius(212)` | 100 |
| `toCelsius(32)` | 0 |
| `toCelsius(-40)` | -40 |
| `toFahrenheit(37)` | 98.6 |
| `toFahrenheit(-40)` | -40 |

**Student tasks.** 1. Write the table, then the machines, then `main`. 2. Why is −40 in the table twice? 3. Which function would survive a switch to Kelvin unchanged — and which two new machines would join it ([C2](challenges.md#c2--the-unit-converter))? 4. Prove the y/n wrapper is [gallery C](../repetition/lesson-3-break-continue-sentinels.md#6-validation-loop-gallery--patterns-you-will-reuse-forever), not new design.

**Extensions.** ⭐ Add Kelvin pair. ⭐⭐ `printTable(double lo, double hi, double step, char from)` — a loop *inside* a printer. ⭐⭐⭐ Reject Kelvin inputs below 0 K in the reader — validation that knows domain physics.

**Guidance.** The smallest lab on purpose: every design habit (table first, split, narrator main) fits on one page. The −40 anchor is the course's favourite correctness check.

---

## Lab 2 — The statistics team

**Scenario.** A coach logs athlete scores (0–10, one decimal) until sentinel −1 and wants a session report. This lab is [C1](challenges.md#c1--the-statistics-suite) made concrete.

**Requirements.** `main` owns all state. Functions: `double readScore()` (validated reader), `void updateChampions(double v, double& lo, double& hi, bool& first)` (seeds or challenges both champions), `void printReport(int count, double total, double lo, double hi)` (guards count = 0). Report: count, total, average (2 dp), min, max.

**Test rows** (drive the *machines*, not the console):

| `updateChampions` call | lo/hi before | after |
| --- | --- | --- |
| (7.5, 0, 0, first=true) | — | 7.5 / 7.5 (seed) |
| (3.0, 7.5, 7.5, first=false) | 7.5/7.5 | 3.0 / 7.5 |
| (9.9, 3.0, 7.5, first=false) | 3.0/7.5 | 3.0 / 9.9 |
| (7.5, 3.0, 9.9, first=false) | 3.0/9.9 | 3.0 / 9.9 (tie: no change) |

**Student tasks.** 1. Trace the champion seeding — why the `first` flag beats `lo = 999`? (Connect to [Iteration S12](../repetition/exercises.md#s12--high-low).) 2. `printReport(0, ...)` must print `No scores yet.` — where does that guard live and why not in `main`? 3. The reader is thin: what *doesn't* it do (no messages policy? state yours)? 4. Write `main`'s narration in pseudocode before C++.

**Extensions.** ⭐ Count above-average (the [C1](challenges.md#c1--the-statistics-suite) wall — feel it, descope honestly). ⭐⭐ Standard deviation is off-limits (needs arrays) — write a comment in `printReport` saying exactly what data it would need. ⭐⭐⭐ Split the report into `printSummary` and `printChampions` — when does splitting a printer earn its keep?

**Guidance.** First lab where a *reference* carries state between functions — the `first` flag pattern is the honest way to seed champions without globals. The reader/print split is enforced by the function table.

---

## Lab 3 — The wire tracing desk

**Scenario.** A debugging classroom needs a demo program that *visibly* shows pass-by-value vs pass-by-reference. Build the teaching artefact.

**Requirements.** Functions: `void byValue(int x)` (prints inside, adds 100), `void byRef(int& x)` (same, with `&`), `void swapPair(int& a, int& b)`, `void minMax2(int a, int b, int& lo, int& hi)`. `main` demonstrates each with printed before/after and labels. Every demo must print enough for a student to *see* the box diagram happen.

**Test rows:**

| call | before | after | why |
| --- | --- | --- | --- |
| `byValue(n)`, n=5 | 5 | 5 | copy died |
| `byRef(n)`, n=5 | 5 | 105 | same box |
| `swapPair(a,b)`, 1/2 | 1 2 | 2 1 | wires |
| `minMax2(8,3,...)` | — | lo 3 hi 8 | outputs right |

**Student tasks.** 1. Draw the box diagrams for all four demos (on paper, in the write-up). 2. `minMax2(8, 3)` vs `minMax2(3, 8)` — prove the champion seed isn't order-dependent. 3. Add one demo that *shouldn't compile* (`byRef(5)`) as a comment — explain the error message in a comment. 4. Which demo would break silently if someone removed one `&`? (Trade: compile error vs wrong answer.)

**Extensions.** ⭐ Add `void addTax(double& price)` and use it on three prices — write-back as ordinary tool. ⭐⭐ A demo where by-value *is* the right tool (protecting a caller) — narrate why. ⭐⭐⭐ `void sort3(int& a, int& b, int& c)` using only `swapPair` calls — three comparisons, order them carefully.

**Guidance.** The lab is a *teaching aid* — grading is on diagram quality and explanation accuracy, not cleverness. Task 4 is the unit's safety argument in miniature.

---

## Lab 4 — The warehouse dispatch

**Scenario.** A warehouse prices orders: unit price × qty, category discount (A 10% over 1000, B 5% over 500, C none), 200 delivery flat (free over 2000 net), receipt printed. Two clerks use it alternately — the discount machine is shared logic (see [R3](refactoring.md#r3--the-duplicated-discount)).

**Requirements.** Functions: `double lineCost(double price, int qty)`; `double categoryDiscount(char cat, double amount)`; `double deliveryFee(double net)`; `void printReceipt(int orderNo, double sub, double disc, double deliv, double total)`. `main`: sentinel loop on order number 0; per order read price, qty, category (validated A/B/C), print receipt; running day total at close.

**Test rows** (machines):

| call | expected |
| --- | --- |
| `lineCost(120, 10)` | 1200 |
| `categoryDiscount('A', 1200)` | 120 |
| `categoryDiscount('A', 900)` | 0 |
| `categoryDiscount('B', 600)` | 30 |
| `categoryDiscount('C', 9999)` | 0 |
| `deliveryFee(1500)` | 200 |
| `deliveryFee(2500)` | 0 |

**Student tasks.** 1. Boundary rows: A at exactly 1000 (discount or not — which comparison did you pick, and does the table *prove* it?), B at 500, delivery at exactly 2000. 2. The shared discount machine: what makes it stealable into another program — and what would you *rename* first? 3. Day total: who owns the accumulator, and why isn't it a global? 4. Order number 0 must print nothing — which layer owns that rule?

**Extensions.** ⭐ Category D: 15% over 3000 — one new row in one table; which function changed? ⭐⭐ Two-item orders: read a second line, subtotal first ([decisions Lab 8](../decisions/labs.md#lab-8--restaurant-billing-rules) composition). ⭐⭐⭐ Make the discount ladder itself a function-of-function: `applyLadder(amount)` calling `categoryDiscount` — when does wrapping stop earning its keep?

**Guidance.** Four pure machines + one narrator: the lab *is* the compute/print split at bill scale. Task 1's boundary rows are the deliverable — code that passes all seven rows but lacks the boundary rows isn't done.

---

## Lab 5 — The validation suite

**Scenario.** Every future lab needs bulletproof input. Build the reader suite *as a program*: a test bench that exercises each reader.

**Requirements.** Functions: `int readInt(const char* prompt)` (non-numeric re-prompt only); `int readIntInRange(const char* prompt, int lo, int hi)`; `double readDoubleInRange(const char* prompt, double lo, double hi)`; `char readChoice(const char* prompt, const char* allowed)` (re-prompt until the char is in the allowed set); `bool askYesNo(const char* prompt)`. `main`: exercise each reader with a scripted bad-good sequence, printing what was accepted.

**Test script** (feed exactly this; note every response):

| reader | keystrokes | expected |
| --- | --- | --- |
| `readInt` | `abc`, `12` | re-prompt once, accept 12 |
| `readIntInRange 1..10` | `0`, `11`, `5` | two range messages, accept 5 |
| `readDoubleInRange 0..1` | `x`, `-0.1`, `0.5` | two messages, accept 0.5 |
| `readChoice "ABC"` | `Z`, `B` | reject Z, accept B |
| `askYesNo` | `maybe`, `Y` | reject, accept |

**Student tasks.** 1. Where does `clear()` sit relative to `ignore()` and *why* (order matters — cite [I/O Lesson 2](../cpp-io/lesson-2-cin.md#25-when-input-goes-wrong-fail-clear-ignore))? 2. `readChoice`'s allowed-set check is a loop with a scan — write it with only decisions+loops (no string indexing tricks — that's the [Strings module](../strings/index.md)). 3. Signatures: which parameters are `const char*` and why not `const&` yet? 4. Which reader goes in your [library](lesson-3-references-testing.md#6-reusable-code--your-personal-library) today, and what's its contract line?

**Extensions.** ⭐ Add retry counters returned by reference. ⭐⭐ `readIntInRange` with an *exclusive* upper bound flag — or is a second function more honest? ⭐⭐⭐ Merge the family into one template-shaped design *on paper* — what would a single function need to know to serve all four? (This is [C8](challenges.md#c8--the-overload-family) and, much later, real templates.)

**Guidance.** Infrastructure lab — the outputs are boring on purpose; the *signatures* are the product. These readers appear in every remaining lab; write them once, carefully.

---

## Lab 6 — The refactor rescue

**Scenario.** Your instructor hands you a 70-line single-`main` grading program (below, condensed). Rescue it using the [walkthrough method](lesson-4-overloading-refactoring.md#3-refactoring--the-walkthrough).

**Requirements (the patient, condensed).** Reads 5 marks with re-prompt validation; computes average, highest, lowest, fails count; prints a report with a dashed divider and a pass/fail verdict per mark. Everything inline.

**Required function team** (the rescue target):

| Function | Signature sketch |
| --- | --- |
| `readMark` | `int readMark(int index)` |
| `average5`, `highest5`, `lowest5`, `countFails` | one machine each, 5 int params |
| `printDivider` | `void printDivider(int width)` |
| `printReport` | takes the five stats |
| `main` | narrator |

**Baseline rows** (record BEFORE touching anything — marks sets):

| marks | average | highest | lowest | fails |
| --- | --- | --- | --- | --- |
| 55 38 91 40 62 | 57.2 | 91 | 38 | 1 |
| 40 40 40 40 40 | 40 | 40 | 40 | 0 |
| 10 20 30 39 5 | 20.8 | 39 | 5 | 5 |

**Student tasks.** 1. Extract in checklist order (computers → printers → readers), compiling and re-running the baseline after *each* extraction. 2. The five-machines design takes 20 parameters across four functions — refactor *within* the rescue: which two machines collapse into one with two references, and does the table survive? 3. Prove byte-identical output on all three baseline rows. 4. Write the one-paragraph "what I'd do differently starting fresh" note.

**Extensions.** ⭐ `printVerdict` per mark (the per-mark pass/fail line) — pure or printer? Decide with the split rule. ⭐⭐ The [iteration Lab 1](../repetition/labs.md#lab-1--the-drilling-instructor) was the same program in loop form — map its variables onto your functions' parameters in a table. ⭐⭐⭐ The 5-mark limit is the wall: write the comment naming exactly what data structure removes it ([Stage D](../syllabus.md#stage-d-algorithms-and-data-units-10-12)).

**Guidance.** The flagship rescue. Grading weight: baseline discipline and step-by-step verification *over* the final shape — a slightly ugly design reached safely beats a elegant one reached with a broken step.

---

## Lab 7 — The divide-and-conquer desk

**Scenario.** A maths-tutor tool that answers three question types — quotient/remainder, GCD (two ways), and prime check — reusing your [library](lesson-3-references-testing.md#6-reusable-code--your-personal-library).

**Requirements.** Functions: `void divMod(int a, int b, int& q, int& r)` (guard documented); `int gcdEuclid(int a, int b)`; `int gcdTrial(int a, int b)`; `bool isPrime(long long n)` (library carry-over); `void runTutor()` (the do-while menu). `main` narrates: greet → runTutor → farewell.

**Test rows:**

| call | expected |
| --- | --- |
| `divMod(17, 5)` | q 3, r 2 |
| `divMod(20, 5)` | q 4, r 0 |
| `gcdEuclid(48, 18)` | 6 |
| `gcdTrial(48, 18)` | 6 |
| `isPrime(4729)` | true |
| `isPrime(1)` | false |

**Student tasks.** 1. Both GCD machines on (48, 18): which needed fewer loop passes, and *why* does Euclid win ([Iteration C5](../repetition/challenges.md#c5--gcd-by-subtraction))? 2. `runTutor` calls machines and prints — cite the line in the house rules this lab enforces. 3. `divMod(5, 0)` — the guard is *documented*, not checked: what does the caller owe, and which lab's readers would enforce it instead? 4. Which of the five functions existed before this lab? Count your [library](lesson-3-references-testing.md#6-reusable-code--your-personal-library) growth honestly.

**Extensions.** ⭐ `lcm(a, b)` via `a*b/gcd` — one line, but write its table (including a = 0). ⭐⭐ `gcdTrial` with the early-exit upgrade from [S28](../repetition/exercises.md#s28--primes-2-to-50). ⭐⭐⭐ `isPrime` with the √n bound — measure pass-count difference on 4729 and say when the upgrade matters.

**Guidance.** The lab where the library concept becomes real: three of five machines already existed. The menu is [C6](challenges.md#c6--the-menu-machine)'s skeleton fleshed out.

---

## Lab 8 — The bank-at-the-desk

**Scenario.** A teller console: deposit, withdraw, balance report, transaction count, quit. The [D5](debugging.md#d5--the-global-gang)/[R4](refactoring.md#r4--the-shadowed-total)/[C10](challenges.md#c10--the-stateless-empire) arc, now built *right* from the start.

**Requirements.** `main` owns `balance` and `txCount`. Functions: `double readAmount(const char* prompt)` (positive, 2-dp-ish, validated reader); `double deposit(double balance, double amount)`; `bool withdraw(double& balance, double amount)` — false + unchanged on insufficiency, true + updated on success; `void printBalance(double balance, int txCount)`. Menu loop until quit; report at quit.

**Test rows** (machines, no console):

| call | before | after | returns |
| --- | --- | --- | --- |
| `deposit(100, 50)` | 100 | (return) 150 | — |
| `withdraw(100, 30)` | 100 | 130 | true |
| `withdraw(100, 130)` | 100 | **100** | false |
| `withdraw(30, 30)` | 30 | 0 | true |

**Student tasks.** 1. `withdraw` returns bool *and* writes `balance&` — why two channels? What breaks if success were signalled by returning the new balance (think: is 0 a balance or a failure?). 2. The boundary row `withdraw(30, 30)`: exactly-equal passes — which comparison decided that, and does the table prove it? 3. `printBalance` before any transaction: whose job is the `No transactions yet.` guard? 4. Map every state variable to its owner — prove no function reaches past its parameters.

**Extensions.** ⭐ A per-transaction fee of 5 on withdrawals over 5000 — which machine grows, and which table gains rows? ⭐⭐ Transaction *log* — you can't store it ([Stage D wall](../syllabus.md#stage-d-algorithms-and-data-units-10-12)); write the wall-comment naming what's needed. ⭐⭐⭐ Two accounts: the functions already take `balance` — prove no signature changes, only `main` grows. That's the test of stateless design.

**Guidance.** The capstone lab: every house rule exercised at once, and the extension proves the design's point — stateless machines scale by *caller growth*, not signature churn.

---

## After the labs

Eight labs, one pattern: **table first, machines next, narrator last**. The [mini-project](miniproject.md) now asks you to run that pattern at menu-plus-six-tools scale — and to rebuild your own iteration mini-project as a function team.
