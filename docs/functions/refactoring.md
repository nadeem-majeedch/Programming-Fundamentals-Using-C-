---
title: "Functions Refactoring Exercises"
description: "10 refactoring exercises — turn giant mains and tangled code into function teams, using the baseline-and-extract checklist."
---

# Functions Refactoring Exercises (10)

> [← Module home](index.md) · Every exercise: **baseline first, one extraction per step, compare after each step** — the [walkthrough checklist](lesson-4-overloading-refactoring.md#3-refactoring--the-walkthrough). Solutions give the *target shape* and the extraction order, not a lecture.

---

## R1 ★ — The welcome-wagon main

```cpp
int main() {
    std::cout << "==============================\n";
    std::cout << "  STUDENT GRADE CALCULATOR\n";
    std::cout << "==============================\n";
    std::cout << "Enter marks for 5 subjects:\n";
    // ... reads 5 marks, prints each with '-' padding ...
    std::cout << "==============================\n";
}
```

Three print-blocks repeat the banner. Extract; `main` should read as three sentences.

**Target:**

```cpp
void printBanner(const char* title);    // one banner machine, title parameter
void readMarks(int& m1, int& m2, int& m3, int& m4, int& m5);
void printReport(...);
// main: printBanner("STUDENT GRADE CALCULATOR"); readMarks(...); printReport(...);
```
Order: banner first (pure output, zero logic), then readers, then the report.

---

## R2 ★ — The inline climber

```cpp
int main() {
    int n;
    std::cin >> n;
    int total = 0;
    for (int i = 1; i <= n; i = i + 1) total += i;
    std::cout << "Sum: " << total << '\n';
}
```

Extract the sum. Name the machine the way a mathematician would.

**Target:** `int sumTo(int n)` — the [S4](../repetition/exercises.md#s4--sum-1-to-n) loop behind a name. `main` becomes read → compute → print. The test table writes itself: n=1, n=0 (empty-loop answer), n=100 (5050).

---

<a name="r3--the-duplicated-discount"></a>
## R3 ★★ — The duplicated discount

Two programs in one file (a shop and a canteen) each contain:

```cpp
    if (amount >= 1000) amount = amount * 0.90;
```

…but with *different* thresholds (canteen: 500, rate 0.95). Extract one machine both can call.

**Target:**

```cpp
double applyDiscount(double amount, double threshold, double rate) {
    return (amount >= threshold) ? amount * rate : amount;
}
```
Baseline both callers before touching anything; after extraction both behaviours must be byte-identical. The [house-shopping lab](labs.md#lab-4--the-warehouse-dispatch) uses exactly this shape.

---

<a name="r4--the-shadowed-total"></a>
## R4 ★★ — The shadowed total

```cpp
double total = 0;                       // global "for convenience"
void addItem(double price) { total += price; }
void printTotal()          { std::cout << "Total: " << total << '\n'; }
int main() {
    addItem(50); addItem(30);
    printTotal();
    return 0;
}
```

De-globalise. (`main` owns the state; functions own the *maths*.)

**Target:**

```cpp
double addItem(double total, double price) { return total + price; }
void printTotal(double total);
// main: double total = 0; total = addItem(total, 50); total = addItem(total, 30); printTotal(total);
```
This is [D5](debugging.md#d5--the-global-gang) at lab scale — baseline before, identical after.

---

## R5 ★★ — The three-lab reader

You've copied the fail/clear/ignore reader into three different labs' programs. Consolidate into the [S24](exercises.md#s24--readinrange) machine and state the two wording decisions.

**Target:**

```cpp
int readInRange(const char* prompt, int lo, int hi);
```
Decisions (document them): standard messages for non-numeric and out-of-range (parameterise *bounds*, standardise *words*); retry counts not tracked (add later if a lab needs them). This function graduates to your [library](lesson-3-references-testing.md#6-reusable-code--your-personal-library) the moment two programs agree on it.

---

<a name="r6--the-giant-main-the-rescue"></a>
## R6 ★★ — The giant main (the rescue)

A 60-line `main`: reads 3 products (name-less: code, qty, unit price), computes per-product cost, applies a combined discount ladder, prints a table, prints totals. No functions. Produce: the extraction order, the function list, and what the narrator `main` looks like.

**Target shape:**

| order | extraction | why this order |
| --- | --- | --- |
| 1 | `double productCost(double price, int qty)` | purest, smallest |
| 2 | `double applyLadder(double subtotal)` | pure decision |
| 3 | `void printRow(...)` / `void printTotals(...)` | output once values stable |
| 4 | `void readProduct(int& code, int& qty, double& price)` | reader (references!) |
| 5 | `main` narrates: for 3 products { read → cost → print } | conductor |

`main` becomes ~8 lines. The [Lab 6 rescue](labs.md#lab-6--the-refactor-rescue) is the full-sized version with a real baseline table.

---

## R7 ★★ — The flag-polluted policy

```cpp
double finalPrice(double amount, bool student, bool member, bool wednesday) {
    double p = amount;
    if (student)  p = p * 0.80;
    if (member)   p = p * 0.90;
    if (wednesday) p = p * 0.95;
    return p;
}
```

Works — but every caller passes three bools, and [decisions Lab 3](../decisions/labs.md#lab-3--cinema-ticket-pricing) taught you policies compose *in order*. Restructure so the ordering is visible and the flags shrink.

**Target:**

```cpp
double applyPercentage(double price, double rate) { return price * rate; }
// caller pipeline, order visible in main:
// price = applyPercentage(price, 0.80);   // student
// price = applyPercentage(price, 0.90);   // member
```
One machine, called in *documented order* by the policy owner (`main`). Refactor honestly: byte-identical outputs on a baseline that covers all flag combinations (8 rows — you have the tooling now).

---

## R8 ★★★ — The tangled validator

```cpp
int main() {
    // reads age; if invalid prints msg and EXITS
    // reads marks; if any invalid prints msg and EXITS
    // ... 40 lines mixing input, policy, output ...
}
```

The program exits-on-error deep inside its flow — three `return 1`s scattered through the reading code. Refactor so validation *returns data* instead of exiting: readers re-prompt (gallery patterns), `main` never inspects validity.

**Target:** readers per field (`int readAge()`, `int readMark()`) using the [re-prompt gallery](../repetition/lesson-3-break-continue-sentinels.md#6-validation-loop-gallery--patterns-you-will-reuse-forever); policy functions pure; `main` = read → compute → print with **zero** decisions in it. The deep insight: *exiting is a policy decision — it belongs to `main`, not to a reader.* (Contrast with the guard-chain style from [decisions Lab 4](../decisions/labs.md#lab-4--atm-withdrawal-validation), which is honest at top level but doesn't scale past two or three fields.)

---

## R9 ★★★ — The copy-pasted slab ladder

The electricity-bill slab ladder now exists in **three** files: the [decisions lab](../decisions/labs.md#lab-2--electricity-bill-slab-rates), the [functions lesson walkthrough](lesson-4-overloading-refactoring.md#3-refactoring--the-walkthrough), and one of your own. Rates differ per file. Consolidate into one *parameterised* machine.

**Target:**

```cpp
// slabs: first s1 units @ r1, next s2 @ r2, remainder @ r3
double slabBill(int units, int s1, double r1, int s2, double r2, double r3);
```
Six parameters — honest but noisy; document each. Test table: transfer each file's old baseline rows into the one table (three boundary sets now owned by one function). Note the trade-off: parameterisation *removes* duplication but *adds* call-site noise — at three slab shapes you'd consider a struct (later units). Recognising that line is the ★★★ part.

---

## R10 ★★★ — The untestable monolith

A program computes, prints, and *reads inside the computation*: `applyLateFee` asks the clerk "waived? y/n" mid-calculation. Design the split so `applyLateFee` becomes pure and the question moves to the caller, without changing any user-visible behaviour.

**Target:**

```cpp
double applyLateFee(double fee, bool waived) { return waived ? 0 : fee * 1.10; }
// main:
//   double fee = computeBase(...);
//   bool waived = askYesNo("Waive late fee? (y/n): ");   // a machine from gallery C
//   fee = applyLateFee(fee, waived);
```
Baseline: run both versions on the same keystrokes — output identical, but the *new* one is testable in four `check` rows with no console interaction. The rule this exercise cements: **input questions never live inside pure machines** — the [D9](debugging.md#d9--the-function-that-prints-its-answer) lesson grown to include reading.

---

## The one-page checklist (pin this)

1. Baseline outputs on fixed inputs — written down.
2. Extract **one** block per step; compile; run; compare; only then continue.
3. Pure computations first, printers second, readers last.
4. Name by single job; parameters in, results out (return or `&`).
5. Duplicated code with different constants → *parameterise*, don't fork.
6. Globals → parameters/returns.
7. Never mix "refactor" and "add feature" in one pass.
