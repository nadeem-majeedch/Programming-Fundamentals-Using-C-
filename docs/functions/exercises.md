---
title: "Functions Exercises"
description: "26 progressive exercises on functions — machines, parameters, returns, scope, references, overloading, defaults, decomposition. Solutions separated at the end."
---

# Functions Exercises (26)

> [← Module home](index.md) · ★ = first pass · ★★ = needs the idioms · ★★★ = combines ideas

**How to use this page.** Attempt each exercise for at least 15 minutes before opening its [solution](#solutions-s1--s26) — each exercise links to its own. For design exercises, write the *function list* (name, parameters, returns) first; for traces, dry-run on paper first.

---

## Part A — First machines (★, E1–E7)

**E1.** Write `double square(double x)` and a `main` that prints `square(2.5)`, `square(3)`, and `square(square(2))`. State the last one's value *before* running, using the call-flow diagram of [Lesson 1 §4](lesson-1-machine.md#4-the-visual-model--the-call-stack).

**E2.** Write `int max2(int a, int b)` (no `if/else` — two `return`s) and `int max3(int a, int b, int c)`. Rule: `max3` must call `max2` *twice*, never compare directly. Trace `max3(4, 9, 2)` in a table.

**E3.** Write `void printBox(int w, int h)` that prints a hollow rectangle of `*` (from [Iteration C12](../repetition/challenges.md#c12--hollow-rectangle)). Call it three times with different sizes. Why is `void` the right return type here?

**E4.** Write `bool isEven(int n)` and use it in a loop in `main` that prints the even numbers from 1 to 20. (You're wrapping the [Iteration S2](../repetition/exercises.md#s2--evens-two-ways) filter in a machine.)

**E5.** Write `char gradeOf(int marks)` implementing the course ladder (≥80 A, ≥70 B, ≥60 C, ≥40 D, else F). Then write the five-row test table for it *before* running, including boundary owners 80, 79, 40, 39.

**E6.** Trace on paper, then run: what does this print? (Call-flow diagram first.)

```cpp
int twist(int n) {
    n = n * 2;
    return n + 1;
}
int main() {
    int n = 5;
    int result = twist(n);
    std::cout << n << ' ' << result << '\n';
    return 0;
}
```

**E7.** Each snippet has one function-mechanics bug. Name it ([gallery](lesson-4-overloading-refactoring.md#4-the-common-function-errors-gallery)) without compiling:
(a) `void f(int x) { return x * 2; }`
(b) `int g(int x); int main() { return g(3); } int g(int x) { return x; }` — prototype `int g(int x);`, definition `int g(double x) { ... }` variant: prototype says `int g(int);`, definition is `int g(int x, int y)`.
(c) `int h(int x) { if (x > 0) return 1; }` called with `h(0)`.

---

## Part B — Copies, scope, prototypes (★★, E8–E13)

**E8.** Predict the output, tracing the boxes:

```cpp
void bump(int a, int b) { a += 1; b += 10; }
int main() {
    int a = 1, b = 2;
    bump(b, a);            // note the order!
    std::cout << a << ' ' << b << '\n';
    return 0;
}
```

**E9.** Write `void trySwap(int a, int b)` that swaps its parameters, then demonstrate in `main` (with printed before/after) that the callers are unchanged. One sentence: *why*?

**E10.** Scope audit. For each variable, state its scope (which functions see it) and whether the program compiles:

```cpp
int g = 1;
void f() {
    int a = g;          // (i)
}
int main() {
    int b = 2;
    f();
    // a = 3;           // (ii)
    // g = b;           // (iii)
    return 0;
}
```

Then rewrite the program with `g` removed: `f` must *return* the value it used to fetch from `g`, and `main` must pass it in.

**E11.** Convert this define-above program to house style — prototypes → `main` → definitions — without changing behaviour:

```cpp
double half(double x) { return x / 2; }
int main() {
    std::cout << half(9) << '\n';
    return 0;
}
```

**E12.** Decomposition plan (no code): *"A program reads a student's five marks, validates each (0–100, re-prompt), computes the average and grade, and prints a formatted report."* Produce the function table (name / takes / returns / job), mark each row alone-testable or not, and write the narrator `main` in pseudocode.

**E13.** A teammate's function compiles, runs, and passes three tests — but uses the global `int attempts = 0;` to count calls. Explain the two concrete ways this breaks, then fix the signature so the count is honest.

---

## Part C — References and testing (★★, E14–E19)

**E14.** Trace the boxes for:

```cpp
void wire(int& r, int v) { r = v * 2; v = 100; }
int main() {
    int a = 3, b = 4;
    wire(a, b);
    std::cout << a << ' ' << b << '\n';
    return 0;
}
```

**E15.** Write `void divMod(int a, int b, int& q, int& r)` producing quotient and remainder in one call (guard: caller promises b ≠ 0 — document it). Write the four-row test table, then a `check`-style driver for two of the rows.

**E16.** Rewrite [Iteration S25's digit-stats](../repetition/exercises.md#s25--digit-stats) as *one* function `void digitStats(long long n, int& count, int& sum, long long& reversed)` — one pass over the digits, three answers. (Input order: value in, three outputs out — the house convention.)

**E17.** Which of these calls compile, and why (not)?

```cpp
void f(int& x);
int a = 1;
f(a);        // (i)
f(2);        // (ii)
f(a + 1);    // (iii)
```

**E18.** Write the mini-driver for `isPrime` (your [Iteration S28](../repetition/exercises.md#s28--primes-2-to-50) machine) with `check`-style output: rows for 2, 3, 4, 9, 4729, 1, 0. Two of those rows are boundary/edge — say which and why they matter.

**E19.** Design decision: a function must produce the average *and* the pass count of five marks. Compare two designs — (A) `double stats(int m1..m5, int& passed)` vs (B) two functions `double average(...)` and `int countPassed(...)`. Which does the house style prefer, and what tips the balance if a *third* statistic is added tomorrow?

---

## Part D — Overloads, defaults, refactoring (★★–★★★, E20–E26)

**E20.** Write overloaded `double area(double side)` (square) and `double area(double l, double w)` (rectangle) and `double area(double a, double b, double h)`? — *stop*: that third one is a trapezium needing different parameters. Write the first two only, plus `area` for a circle (`double area(double r)` — wait, that's the same signature as the square!). Resolve the collision honestly: rename or re-signature, and justify.

**E21.** Predict, then verify: which overload runs for each call?

```cpp
void p(int x)    { std::cout << "I\n"; }
void p(double x) { std::cout << "D\n"; }
p(3); p(3.0); p('A'); p(true); p(3.0f);
```

**E22.** Write `void printLine(char fill = '-', int width = 20)` and show three calls: default, one explicit, both explicit. Then add `printLine(int width)` — does it compile? Explain the clash using [Lesson 4 §2](lesson-4-overloading-refactoring.md#2-default-arguments).

**E23.** Fix the trailing-default violation: `void log(double value, int digits = 2, bool debug)` — re-order the parameters so it compiles and *keeps* every caller sensible. Show the two resulting call forms.

**E24.** The [iteration module's Lab 5](../repetition/labs.md#lab-5--the-stubborn-menu) copy-pasted its robust reader four times. Sketch the signature of ONE function that replaces all four, list its parameters (prompt, minimum, maximum — anything else?), and state which past behaviour would need a decision (non-numeric message? range message?).

**E25.** Refactor plan (no full code): given the giant-main [electricity bill program](../decisions/labs.md#lab-2--electricity-bill-slab-rates) from the decisions module, produce the ordered extraction list (which block first, second, ...) and the baseline test rows you'd record before touching anything.

**E26.** Each snippet breaks one overload/defaults rule. Name the rule:
(a) `int f(int); double f(int);`
(b) `void g(int a = 1, int b);`
(c) `void h(int x); void h(int x, int y = 0);` then calling `h(1)`.
(d) prototype `double rate(double);` and default `.15` also written on the definition.

---

<a name="solutions-s1--s26"></a>
# Solutions (S1–S26)

> Compare *designs* first — a different but honest decomposition is a win.

<a name="s1--square-and-nesting"></a>
## S1 — Square and nesting

```cpp
double square(double x) { return x * x; }
// main: 6.25, 9, 24.0144...
```
`square(square(2))`: inner call runs first (2 → 4), its *return value* becomes the outer argument (4 → 16). Stack: main → square → back → square → back. Value: `4² = 16`.

<a name="s2--max2-max3"></a>
## S2 — max2, max3

```cpp
int max2(int a, int b) {
    if (a > b) return a;
    return b;
}
int max3(int a, int b, int c) {
    return max2(a, max2(b, c));
}
```
Trace `max3(4, 9, 2)`: inner `max2(9, 2)` → 9; outer `max2(4, 9)` → 9. One direct comparison in `max3` would duplicate `max2`'s logic — composition is the point.

<a name="s3--printbox"></a>
## S3 — printBox

```cpp
void printBox(int w, int h) {
    for (int r = 1; r <= h; r = r + 1) {
        for (int c = 1; c <= w; c = c + 1) {
            if (r == 1 || r == h || c == 1 || c == w) std::cout << "* ";
            else                                      std::cout << "  ";
        }
        std::cout << '\n';
    }
}
```
`void` because nothing is *computed* — the effect is the printout; there's no value for a caller to use.

<a name="s4--iseven"></a>
## S4 — isEven

```cpp
bool isEven(int n) { return n % 2 == 0; }
// main:
for (int i = 1; i <= 20; i = i + 1) {
    if (isEven(i)) std::cout << i << ' ';
}
```
The loop *filters* via a question-machine — computation (parity) separated from printing, exactly the Lesson 1 split.

<a name="s5--gradeof"></a>
## S5 — gradeOf

```cpp
char gradeOf(int marks) {
    if (marks >= 80) return 'A';
    if (marks >= 70) return 'B';
    if (marks >= 60) return 'C';
    if (marks >= 40) return 'D';
    return 'F';
}
```
Table (write first, verify after): 85→A, **80→A, 79→B**, 70→B, 69→C, **60→C, 59→D**, 40→D, **39→F**, 0→F. Most-demanding-first ladder inside a machine.

<a name="s6--twist"></a>
## S6 — twist

Prints **`5 11`**. `twist` doubled its *own copy* (n=5 stays 5 in main; copy becomes 10, returns 11). `main`'s `n` never touched — the [copy rule](lesson-2-scope.md#1-pass-by-value--the-copy-rule) in one line.

<a name="s7--mechanics-bugs"></a>
## S7 — Mechanics bugs

(a) `void` function returns a value — compiler error (or, if it were `int f`, missing return on the else path — F7's cousin). Make it `int f(int x) { return x * 2; }`.
(b) Prototype promises `(int)`, definition delivers `(int, int)` — the *linker* then rejects the call: declared-and-defined machines don't match (F1's signature-mismatch form).
(c) `h(0)` falls off the end with no return — F7; add the final `return 0;` (or `else`).

<a name="s8--bump"></a>
## S8 — bump

Prints **`1 2`**. Inside `bump`, `a` is a copy of `b`'s value (2→3) and `b` a copy of `a`'s (1→11) — both destroyed at return. Swapped argument order changes nothing outside.

<a name="s9--tryswap"></a>
## S9 — trySwap

```cpp
void trySwap(int a, int b) { int t = a; a = b; b = t; }
// main: print x y; trySwap(x, y); print x y — identical lines.
```
Because parameters are *copies* ([Lesson 2 §1](lesson-2-scope.md#1-pass-by-value--the-copy-rule)); the real swap needs `int&` — [Lesson 3 §2](lesson-3-references-testing.md#2-reference-parameters--the-write-back-wire).

<a name="s10--scope-audit"></a>
## S10 — Scope audit

(i) legal — `f` sees the global. (ii) illegal — `a` is local to `f`, dead after return. (iii) legal — `main` sees `g`. Program compiles.
De-globalised:

```cpp
int f(int g) { return g; }          // takes what it used to fetch
int main() {
    int g = 1;
    g = f(g);                       // or just use the return directly
    return 0;
}
```

<a name="s11--house-style"></a>
## S11 — House style

```cpp
double half(double x);              // prototype

int main() {
    std::cout << half(9) << '\n';
    return 0;
}

double half(double x) { return x / 2; }   // definition, any order now
```

<a name="s12--decomposition-plan"></a>
## S12 — Decomposition plan

| Function | Takes | Returns | Job | Alone-testable |
| --- | --- | --- | --- | --- |
| `readMark` | — | `int` | validated single mark | logic yes (console no — keep it thin) |
| `average5` | 5 ints | `double` | arithmetic | **yes** |
| `gradeOf` | int | `char` | ladder | **yes** |
| `printReport` | 5 ints | void | formatting + calls the above | via its parts |

```text
MAIN
    read five marks (readMark x5)
    SET avg TO average5(m1..m5)
    SET gr  TO gradeOf(ROUND(avg))     ← policy decision: grade the average? document it
    CALL printReport(m1..m5, avg, gr)
```
The grade-the-average-vs-grade-each question is exactly the kind of ambiguity decomposition *surfaces* before coding.

<a name="s13--global-attempts"></a>
## S13 — Global attempts

Breaks: (1) tests can't run in isolation — every test starts with `attempts` inherited from the last; (2) any future function can silently reset/change it — action at a distance ([Lesson 2 §3](lesson-2-scope.md#3-global-variables--why-this-course-bans-them)).
Fix: the counter belongs to *the caller's loop* — `main` counts calls; the function stays pure. If it must report its own calls, return the count or take `int& attempts`.

<a name="s14--wire"></a>
## S14 — wire

Prints **`8 4`**. `r` is a wire to `main`'s `a`: `r = 8` writes main's box. `v` is a copy of `b` — `v = 100` dies at return.

<a name="s15--divmod"></a>
## S15 — divMod

```cpp
void divMod(int a, int b, int& q, int& r) {
    // caller contract: b != 0 (division by zero otherwise)
    q = a / b;
    r = a % b;
}
```
Table: (17,5)→3,2 · (20,5)→4,0 · (3,7)→0,3 · (-7,2)→-3,-1 (truncation toward zero — document it!). Driver with `check` on rows 1–2.

<a name="s16--digitstats"></a>
## S16 — digitStats

```cpp
void digitStats(long long n, int& count, int& sum, long long& reversed) {
    count = 0; sum = 0; reversed = 0;
    while (n > 0) {
        int d = n % 10;
        sum += d;
        reversed = reversed * 10 + d;
        count += 1;
        n = n / 10;
    }
}
```
One pass, three answers — replaces two separate loops from S25/S26. (Edge: n = 0 → all zeros; document like S25.)

<a name="s17--reference-calls"></a>
## S17 — Reference calls

(i) compiles — a variable. (ii) **no** — no box to attach the wire to. (iii) **no** — `a + 1` is a value, not a variable ([Lesson 3 §3](lesson-3-references-testing.md#3-reference-gotchas)).

<a name="s18--isprime-driver"></a>
## S18 — isPrime driver

```cpp
void check(bool got, bool want, const char* label) {
    std::cout << (got == want ? "PASS " : "FAIL ") << label << '\n';
}
int main() {
    check(isPrime(2),    true,  "smallest prime");
    check(isPrime(3),    true,  "odd prime");
    check(isPrime(4),    false, "first composite");
    check(isPrime(9),    false, "odd composite");
    check(isPrime(4729), true,  "lab-10 value");
    check(isPrime(1),    false, "boundary: not prime by definition");
    check(isPrime(0),    false, "edge: rejected by n > 1 guard");
    return 0;
}
```
Boundary rows: 1 (the definition's lower edge) and 0 (garbage tolerance). 2 is the *even-prime* boundary — a naive even-skipping optimisation breaks it.

<a name="s19--stats-design"></a>
## S19 — Stats design

House style prefers **(B)** — two single-job machines, each with its own clean test table; composition in `main`:
`passed = countPassed(...); avg = average(...)`. (A) couples two answers and forces a reference. **But** if a third statistic arrives: five parameters × three functions gets noisy — *that's* the moment `minMax`-style multi-output references (or a struct, later) start winning. Design rules have scope: single-job until the parameter list itself becomes the problem.

<a name="s20--area-overloads"></a>
## S20 — Area overloads

```cpp
double area(double side);                  // square
double area(double l, double w);           // rectangle
```
Circle can't be `area(double)` — it *is* the square's signature. Honest fixes: `circleArea(double r)` (distinct concept, distinct name), or `area(double r, bool isCircle)` — which is worse (a bool flag is a hidden second machine). **Different meanings deserve different names** — overload by meaning only.

<a name="s21--overload-picks"></a>
<a name="s21--overload-picks"></a>
## S21 — Overload picks

`p(3)`→I · `p(3.0)`→D · `p('A')`→I (char promotes to int) · `p(true)`→I (bool→int beats bool→double) · `p(3.0f)`→D (float→double is a promotion). Compare with Lesson 4's table — the `true` row is the famous surprise.

<a name="s22--printline"></a>
## S22 — printLine

```cpp
void printLine(char fill = '-', int width = 20) {
    for (int i = 1; i <= width; i = i + 1) std::cout << fill;
    std::cout << '\n';
}
// printLine();        → 20 dashes
// printLine('=');     → 20 equals
// printLine('*', 5);  → 5 stars
```
Adding `void printLine(int width)` does **not** compile alongside it cleanly: `printLine(30)` would be ambiguous-ish (int→char conversion for the first overload vs exact for the second) — and `printLine('x')` already binds to `char fill`. The clash is the [defaults+overloads trap](lesson-4-overloading-refactoring.md#2-default-arguments): don't grow by overload what a default already serves.

<a name="s23--trailing-default"></a>
## S23 — Trailing default

```cpp
void log(bool debug, double value, int digits = 2);
// log(false, 3.14159);         → digits 2
// log(true, 3.14159, 4);       → digits 4
```
The defaulted parameter must be rightmost; `debug` moves to the front (and is now *required*, which is honest — callers should say whether they're debugging).

<a name="s24--readinrange"></a>
## S24 — readInRange

```cpp
int readInRange(const char* prompt, int lo, int hi);
```
(Or `const std::string&` — the [Strings module](../strings/index.md) formalises strings.) Replaces all four copied readers. Decisions to make explicit: one message for non-numeric ("Numbers only, please.") and one for range ("Between lo and hi, please.") — parameterise or standardise? House choice: standardise the wording, parameterise the bounds. This becomes a library entry ([Lesson 3 §6](lesson-3-references-testing.md#6-reusable-code--your-personal-library)).

<a name="s25--extraction-order"></a>
## S25 — Extraction order

Baseline rows first: units `50/100/150/200/201/400` outputs written down ([walkthrough §3](lesson-4-overloading-refactoring.md#3-refactoring--the-walkthrough)).
Order: 1) `computeBill` (slab ladder — pure, testable), 2) `applySurcharge` (pure decision), 3) `printReceipt` (output block), 4) `readUnits` (input loop), 5) `main` as narrator. Compile-and-compare after *each*.

<a name="s26--overload-rules"></a>
## S26 — Overload/defaults rules

(a) return type alone can't overload. (b) defaults must trail. (c) ambiguity — `h(1)` fits both signatures. (d) default declared twice — put it on the prototype only.
