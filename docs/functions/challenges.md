---
title: "Functions Challenges"
description: "10 challenge problems on function design — machines that compose, reference designs, overload sets, and refactor-at-scale. Solutions separated at the end."
---

# Functions Challenges (10)

> [← Module home](index.md) · Design-first problems ★–★★★. Attempt on paper (function list + test table) before code — the [Try It Yourself protocol](../problem-solving/index.md) applies. [Solutions](#solutions-c1--c10) describe *approaches*; your decomposition may differ and be right.

## The problems

<a name="c1--the-statistics-suite"></a>
**C1 ★ — The statistics suite.** Design the function set for: read n values (sentinel −1), print count, total, average, min, max, and how many were above average. Constraint: no global variables; `main` narrates. How many functions, and which one is the surprise?

<a name="c2--the-unit-converter"></a>
**C2 ★ — The unit converter.** Design `convert(double value, char from, char to)` for temperatures (C/F/K). Decide: one function with a switch, or a family of small ones (`cToF`, `fToC`, `cToK`...)? Justify with testability and the [overload-by-meaning](lesson-4-overloading-refactoring.md#1-function-overloading--one-name-several-machines) rule. Then write its test table (include −40 and absolute zero as anchors).

<a name="c3--the-two-output-analyzer"></a>
**C3 ★★ — The two-output analyzer.** Design `analyze(long long n, ...)` that reports, in ONE pass over the digits: digit count, digit sum, digit product, max digit, min digit. Sign it (how many references?), write the test rows for n = 0, 7, 9045, 99999, and state the pass-count vs single-pass trade-off versus five separate functions.

<a name="c4--the-perfect-refactor"></a>
**C4 ★★ — The perfect refactor.** Take your [Iteration C1](../repetition/challenges.md#c1--perfect-numbers) perfect-number search and restructure it as a function team: `sumOfProperDivisors(n)`, `isPerfect(n)` built on it, and a `printPerfectUpTo(limit)` that reports. Which function gets the test table with boundary owners, and what are they?

<a name="c5--the-library-card"></a>
**C5 ★★ — The library card.** Formalise your personal [toolbox](lesson-3-references-testing.md#6-reusable-code--your-personal-library): pick any five functions from previous units, write each one's prototype + one-line contract + three-row test table on a single "library card" page. Which of the five *couldn't* be tested without a driver, and why?

<a name="c6--the-menu-machine"></a>
**C6 ★★ — The menu machine.** Design `runMenu()` for a 4-option utility (from your [iteration mini-project](../repetition/miniproject.md)): how does the quit decision leave the loop cleanly with prototypes → main → definitions layout, and where do the four option-handlers' prototypes go? Write the skeleton (signatures only, `// TODO` bodies).

<a name="c7--the-safe-division-suite"></a>
**C7 ★★ — The safe division suite.** Design the division trio: `bool canDivide(double a, double b)`, `double divide(double a, double b)` (caller's contract: only call when canDivide), and `void safeDivide(double a, double b, bool& ok, double& result)` (never crashes, reports instead). Same maths, three contracts — write the client code for each and say who each contract serves.

<a name="c8--the-overload-family"></a>
**C8 ★★★ — The overload family.** Design a `readNumber` overload family: `int readNumber(const char* prompt)`, `int readNumber(const char* prompt, int lo, int hi)`, `double readNumber(const char* prompt, double lo, double hi)`. Where are the ambiguities (think `readNumber("p", 1, 2)` — which overload?), how do you resolve them honestly, and where do defaults fit without creating traps?

<a name="c9--the-pipeline"></a>
**C9 ★★★ — The pipeline.** A payroll pipeline: gross → tax (slab) → bonus (performance %) → net → report. Design the function team so that *tax* and *bonus* are individually testable AND swappable (the company changes bonus policy yearly). Write the narrator `main`, and mark which function's test table survives a policy change untouched.

<a name="c10--the-stateless-empire"></a>
**C10 ★★★ — The stateless empire.** A 150-line program tracks a bank account through deposits, withdrawals, a balance report, and a transaction counter — written by "past you" with two globals (`balance`, `txCount`). Produce the de-globalisation plan: every function signature before/after, the new narrator `main`, and the argument for why the *new* version is testable row-by-row. (This is the [D5](debugging.md#d5--the-global-gang)/[R4](refactoring.md#r4--the-shadowed-total) lesson at full scale — the exact refactor you'll redo with structs in [Stage E](../syllabus.md#stage-e-memory-and-objects-units-13-15).)

<a name="solutions-c1--c10"></a>
## Solutions (C1–C10)

> One sound approach each; compare decompositions first.

### C1 — The statistics suite

Five machines: `readValue()` (thin sentinel reader), `printStats(count, total, min, max)` (printer), and the surprise — **above-average needs a second pass over the data**… which the course can't store yet (no arrays!). Honest resolutions: (a) collect the above-average count in a second *reading* pass (read the data twice — clumsy but honest), or (b) descope: report above-average only when the data is re-entered. The lesson: **decomposition exposes data-dependency walls before code hides them** — this is exactly why arrays exist, and C1 has now made you feel it. (Count/total/min/max fold into one reading pass with the four idioms; `main` holds the state and narrates.)

### C2 — The unit converter

Family of small ones wins: `cToF`, `fToC`, `cToK`, `kToC` are each one formula with one test row each — alone-testable, composable (`fToK = cToK(fToC(x))`). The `convert(value, from, to)` switch is *one* function with a 6-way switch — testable, but every new unit multiplies cases, and a wrong pairing fails silently. Char-code routing also breaks the [overload-by-meaning](lesson-4-overloading-refactoring.md#1-function-overloading--one-name-several-machines) instinct: the name should *say* the conversion. Anchors: −40 (C == F), 0/32 (freezing), 100/212 (boiling), 0 K = −273.15 °C (the floor — a value below it is garbage: reject with `kToC` guard or document).

### C3 — The two-output analyzer

```cpp
void analyze(long long n,
             int& count, int& sum, long long& product,
             int& maxD, int& minD);
```
Five references + the input — wide but honest, inputs left / outputs right. One pass: peel d; `sum += d; product *= d; count++;` champion updates for max/min. Test rows: 0 → (0,0,1,0,0) — **product's identity is 1, so zero passes leaves 1; is that the answer for n=0? Document!**; 7 → (1,7,7,7,7); 9045 → (4,18,0,9,0) — product 0 because of the 0 digit, the accumulator [identity rule](../repetition/lesson-2-for.md#2-the-classic-idioms--learn-once-reuse-forever) colliding with real data; 99999 → (5,45,59049,9,9). Trade-off: five separate functions = five passes, five test tables, five chances for inconsistent edge handling; one pass = one table, but a wide signature. Five statistics is where the multi-output reference design starts paying rent.

### C4 — The perfect refactor

`sumOfProperDivisors(int n)` gets the boundary table: 1 → 0 (no proper divisors), 6 → 6 (perfect), 28 → 28, a prime p → 1, 12 → 16 (abundant). `isPerfect(n)` is one comparison — `n > 1 && sumOfProperDivisors(n) == n` — *its* table is two rows because its job is one sentence. `printPerfectUpTo(limit)` owns the search loop and the printing. The boundary owners live with the *machine that computes the boundary concept* — test tables attach to computation, not to orchestration.

### C5 — The library card

Example card rows: `max2(int,int) → int` — "larger of two" — (3,9)→9, (9,3)→9, (-5,-2)→-2. The one that *couldn't* be tested without a driver: any reader (e.g. `readInRange`) — its contract involves the console, so the driver *is* the test harness (feed keystrokes, observe prompts). The rule that falls out: **library = pure machines + thin readers; only pure machines get automatic tables.**

### C6 — The menu machine

```cpp
void handleAdd();      // prototypes block
void handleStats();
void handleAnalyze();
void handleHelp();
int  readChoice();     // validated reader (gallery D)

int main() { runMenu(); return 0; }   // or main IS the menu loop — house style: main narrates

void runMenu() {
    int choice;
    do {
        printMenu();                    // printer, separate
        choice = readChoice();
        switch (choice) { case 1: handleAdd(); break; ... case 0: break; default: ... }
    } while (choice != 0);
}
```
The quit decision lives in the loop condition (sentinel), *not* a `break` inside the switch — one exit, visible in the header ([iteration Lesson 3 §5](../repetition/lesson-3-break-continue-sentinels.md#5-menu-driven-programs--the-stage-b-showcase)). Handlers' prototypes sit in the same block; their *definitions* after `main`. Skeleton-first means each `// TODO` becomes a one-function task a teammate could take.

### C7 — The safe division suite

`canDivide`/`divide` = **design-by-contract**: caller checks, callee trusts — two test tables, zero duplicated checks, fastest at the call site, and the *caller's* bug (dividing without checking) is invisible until it crashes. `safeDivide` = **self-defending**: one call, no precondition — the bool& out is the cost of safety at every call. Client code: tight numeric loops use the contract pair; interactive calculators and student tools use `safeDivide` (or the re-prompting reader from the gallery, which prevents the bad call entirely). Three contracts, three audiences — the design question "who is the caller?" *is* the answer.

### C8 — The overload family

The trap: `readNumber("p", 1, 2)` — `1` and `2` are `int` literals; they bind exactly to the `(const char*, int, int)` overload… so far so good; the real ambiguity is `readNumber("p", 1.0, 2.0)` *only* matching the double overload (fine) versus mixed `readNumber("p", 1, 2.0)` — one conversion per argument to *either* range overload → ambiguous, compiler refuses. Honest fixes: (a) accept it — mixed int/double bounds is a caller bug; write the error message to say so; (b) name them apart (`readInt`, `readDouble`) and keep overloads only where the *meaning* is identical ([E20's](exercises.md#s20--area-overloads) rule). Defaults fit cleanly on the *reader* only where a range has a natural universal ("readNumber(prompt)" = unbounded) — but that signature collides with the bounded int version for any 2-arg call, so the honest family is: `readInt(prompt)`, `readInt(prompt, lo, hi)`, `readDouble(prompt, lo, hi)` — three machines, zero ambiguity, meaning-aligned names.

### C9 — The pipeline

```cpp
double computeTax(double gross);            // slab ladder — pure
double computeBonus(double gross, double rate);
double computeNet(double gross, double taxRate, double bonusRate);
void   printPayslip(...);
```
`main`: read gross → tax → bonus → net → report. Swappability: bonus policy changes = edit `computeBonus` (or its *rate table*), nothing else — the pipeline's shape is policy-independent because each stage takes values and returns values. **The test table that survives untouched: `computeTax`'s** — its slab boundaries belong to tax law, not bonus policy. `computeNet`'s table changes if stages' *order* changes — which is exactly why the order lives in one place (`main`), visible, not smeared across functions.

### C10 — The stateless empire

Signatures before → after: `deposit(amount)` → `double deposit(double balance, double amount)`; `withdraw(balance, amount)` → `double withdraw(double balance, double amount)` (with the insufficiency guard returning a bool via `bool& ok` or a documented sentinel); `report()` → `void report(double balance, int txCount)`; counter increments move to `main` (the *orchestrator* owns state). New `main`: reads commands in a sentinel loop, owns `balance` and `txCount`, calls pure machines. Testability argument: every machine now has a table that runs with no setup ritual — `check(withdraw(100, 30), 70, ...)` — whereas the global version needed `balance` arranged just-so before *every* row and leaked state between rows. Full-scale note: five pieces of account state would make these signatures groan — that groan is [Stage E's structs](../syllabus.md#stage-e-memory-and-objects-units-13-15) calling.
