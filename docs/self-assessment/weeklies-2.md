---
title: "Weekly Quizzes W05–W08 — Iteration & Functions"
description: "Weeks 5–8: while/do-while and sentinels, for and nested loops, function fundamentals, references and design — 10 questions each with hidden answer keys."
---

# Weekly Quizzes — W05 to W08

> 10 questions each · ~15 min each · attempt ALL ten before opening the key ·
> [← W01–W04](weeklies-1.md) · [Hub](index.md) · [W09–W12 →](weeklies-3.md)

---

## W05 — Loops I: while, do-while, sentinels (Week 5)

**Q1.** [Easy] A `while` loop checks its condition…

- a) after each pass
- b) before each pass
- c) once, ever
- d) only if the body runs

**Q2.** [Easy] How many times does this print `x`?

```cpp
int i = 0;
while (i < 3) {
    cout << "x";
    i++;
}
```

- a) 0
- b) 2
- c) 3
- d) forever

**Q3.** [Easy] A `do-while` loop differs from `while` because…

- a) it can't use counters
- b) its body always runs at least once
- c) it must have a `break`
- d) it runs exactly once

**Q4.** [Medium] What is the value of `sum` after this?

```cpp
int sum = 0, k = 1;
while (k <= 4) {
    sum += k;
    k++;
}
```

- a) 4
- b) 6
- c) 10
- d) 15

**Q5.** [Medium] The loop `while (cin >> x && x != 0) { ... }` is best
described as…

- a) an infinite loop
- b) a sentinel-controlled loop that also stops if the read fails
- c) a do-while in disguise
- d) invalid C++

**Q6.** [Medium] What does this print?

```cpp
int n = 5;
do {
    cout << n << " ";
    n--;
} while (n > 3);
```

- a) `5 4`
- b) `5 4 3`
- c) `5`
- d) nothing

**Q7.** [Medium] The classic missing-update loop — `while (i < 5) { cout << i; }`
with i starting at 0 — is…

- a) correct
- b) infinite: the condition never changes
- c) a compile error
- d) a do-while

**Q8.** [Medium] An off-by-one error in a counting loop most often means…

- a) the loop type is wrong
- b) the loop runs one time too many or too few — usually a `<` vs `<=` mismatch
- c) the counter overflows memory
- d) the body has too many statements

**Q9.** [Hard] What does this print?

```cpp
int n = 40;
while (n != 1) {
    if (n % 2 == 0) n /= 2;
    else            n = 3 * n + 1;
}
cout << "done";
```

- a) done — the sequence reaches 1 (40→20→10→5→16→8→4→2→1)
- b) done — but only after n overflows
- c) infinite loop
- d) compile error

**Q10.** [Hard] This menu loop has a bug:

```cpp
int choice = 0;
do {
    cin >> choice;
    cout << "ran " << choice << "\n";
} while (choice != 0);
```

For input `3 0`, what is wrong with the output?

- a) nothing — it prints `ran 3` then stops
- b) it also prints `ran 0` before stopping — the quit choice is processed
  before the condition is rechecked
- c) it loops forever
- d) it prints `ran 3` twice

<details markdown="1">
<summary><strong>W05 — Answer key</strong></summary>

**Q1 — b.** `while` is pre-test: the condition guards every entry into the
body, so a false condition up front means zero passes.

**Q2 — c.** i = 0, 1, 2 pass; i = 3 fails. Three iterations, standard
counting shape.

**Q3 — b.** Do-while is post-test: the body runs, *then* the condition is
checked — guaranteed first pass. Use it only when once-is-certain.

**Q4 — c.** Trace: sum = 1, 3, 6, 10. The accumulator pattern.

**Q5 — b.** The read doubles as the loop condition (stops at end-of-input or
type error), and `x != 0` is the sentinel. Two stop reasons in one condition.

**Q6 — a.** Passes: prints 5 (n→4), condition 4 > 3 true; prints 4 (n→3),
condition 3 > 3 false. Body ran twice — the post-test never forced extra
passes beyond the condition's truth.

**Q7 — b.** No update → the condition is always true → infinite loop. Every
counting loop needs progress toward the exit.

**Q8 — b.** `i < n` runs n times; `i <= n` runs n+1. The samples that catch it
are the boundaries: first element, last element, n = 0.

**Q9 — a.** The Collatz walk: 40, 20, 10, 5, 16, 8, 4, 2, 1 — condition
false, `done`. An event-terminated loop whose length you cannot predict from
the start value alone.

**Q10 — b.** The body processes *before* the condition rechecks — the price of
post-test loops. The fix is testing inside the body (`if (choice == 0)
break;`) or switching to a pre-test loop. W05's own lab fixes this pattern.
</details>

---

## W06 — Loops II: for, nested, break/continue (Week 6)

**Q1.** [Easy] `for (int i = 0; i < 5; i++)` runs its body…

- a) 4 times
- b) 5 times
- c) 6 times
- d) until i overflows

**Q2.** [Easy] `break` inside a loop…

- a) skips to the next iteration
- b) exits the loop entirely
- c) exits the program
- d) restarts the loop

**Q3.** [Easy] `continue` inside a loop…

- a) exits the loop
- b) jumps to the next iteration, skipping the rest of the body
- c) does nothing
- d) reverses the loop

**Q4.** [Medium] How many stars does this print in total?

```cpp
for (int r = 0; r < 3; r++)
    for (int c = 0; c < 4; c++)
        cout << "*";
```

- a) 7
- b) 12
- c) 3
- d) 4

**Q5.** [Medium] What does this print?

```cpp
for (int i = 0; i < 5; i++) {
    if (i == 2) continue;
    if (i == 4) break;
    cout << i << " ";
}
```

- a) `0 1 2 3`
- b) `0 1 3`
- c) `0 1 3 4`
- d) `0 1 2 3 4`

**Q6.** [Medium] Which loop prints the even numbers 10, 8, 6, 4, 2 in order?

- a) `for (int i = 10; i >= 2; i -= 2) cout << i;`
- b) `for (int i = 10; i <= 2; i -= 2) cout << i;`
- c) `for (int i = 2; i <= 10; i += 2) cout << i;`
- d) `for (int i = 10; i > 2; i -= 2) cout << i;`

**Q7.** [Medium] What does this print?

```cpp
for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= i; j++)
        cout << j;
    cout << " ";
}
```

- a) `1 12 123 `
- b) `123 123 123 `
- c) `1 2 3 `
- d) `1 22 333 `

**Q8.** [Medium] The digit-sum loop `while (n > 0) { sum += n % 10; n /= 10; }`
on input 472 gives…

- a) 472
- b) 13
- c) 27
- d) 0

**Q9.** [Hard] What is the value of `total` after this?

```cpp
int total = 0;
for (int i = 1; i <= 3; i++)
    for (int j = 1; j <= 2; j++)
        total += i * j;
```

- a) 6
- b) 18
- c) 12
- d) 9

**Q10.** [Hard] This pattern loop should print a 4×4 hollow square but prints
something else:

```cpp
for (int r = 1; r <= 4; r++) {
    for (int c = 1; c <= 4; c++) {
        bool edge = r == 1 || r == 4 || c == 1 || c == 4;
        cout << (edge ? '*' : ' ');
    }
    cout << "\n";
}
```

What does it actually print?

- a) exactly the hollow square — the code is correct
- b) a solid block: the edge test is wrong
- c) nothing: the loops never run
- d) four rows of `*` followed by spaces but no interior — i.e. it *is* the
  hollow square, and the bug is elsewhere

<details markdown="1">
<summary><strong>W06 — Answer key</strong></summary>

**Q1 — b.** i takes 0, 1, 2, 3, 4 — five values. `for (i = 0; i < n; ...)` is
the n-times idiom.

**Q2 — b.** `break` leaves the *nearest* enclosing loop (or switch). Next
iteration is `continue`'s job.

**Q3 — b.** `continue` abandons the rest of this pass only; the loop update
and condition still run.

**Q4 — b.** Nested loops multiply: 3 × 4 = 12. The inner loop completes fully
for every outer pass.

**Q5 — b.** i = 0, 1 print; i = 2 skips (continue); i = 3 prints; i = 4 breaks
before printing. Neither jump keyword ends the program — they reshape one pass
or the loop.

**Q6 — a.** Descending by 2 with the boundary `i >= 2` includes 2. Option (b)
never runs (10 ≤ 2 false), (c) is ascending, (d) stops at 4.

**Q7 — a.** The inner bound *depends on i*: for i = 1 prints `1`; i = 2 prints
`12`; i = 3 prints `123` — the triangular pattern. Dependent inner bounds are
the essence of shape printing.

**Q8 — b.** Peel: 472 → 2 + 7 + 4 = 13. `% 10` peeks the last digit, `/ 10`
chops it off.

**Q9 — b.** (1·1 + 1·2) + (2·1 + 2·2) + (3·1 + 3·2) = 3 + 6 + 9 = 18. Trace
tables turn nested accumulation from guesswork into arithmetic.

**Q10 — a.** The code is correct — every cell on an edge prints `*`, interior
cells print a space. The question trains *reading* loops before trusting a
"looks wrong" reflex; the honest answer is sometimes "no bug."
</details>

---

## W07 — Functions I: parameters, return, scope (Week 7)

**Q1.** [Easy] A function that returns nothing is declared with the keyword…

- a) `null`
- b) `void`
- c) `empty`
- d) `auto`

**Q2.** [Easy] In `int square(int x) { return x * x; }`, the `x` is…

- a) an argument
- b) a parameter — a local variable that receives the argument's value
- c) a global
- d) a constant

**Q3.** [Easy] Where does a function's local variable live after the function
returns?

- a) it persists for the program's life
- b) nowhere — its lifetime ended with the function
- c) in the return value
- d) on the heap

**Q4.** [Medium] What does this print?

```cpp
int twice(int v) { return v * 2; }
int main() {
    int v = 5;
    cout << twice(v) << " " << v;
}
```

- a) `10 10`
- b) `10 5` — the parameter was a copy
- c) `5 5`
- d) `5 10`

**Q5.** [Medium] What does this print?

```cpp
int f(int a) { a++; return a; }
int main() {
    int n = 3;
    f(n);
    cout << n;
}
```

- a) 4
- b) 3 — the increment happened on the copy
- c) 0
- d) undefined

**Q6.** [Medium] What does this program print?

```cpp
int g = 10;
void bump() { g++; }
int main() {
    bump(); bump();
    cout << g;
}
```

- a) 10
- b) 12 — both calls saw the same global
- c) 11
- d) a compile error

**Q7.** [Medium] Which is a valid prototype (declaration only) for a function
taking a double and returning a bool?

- a) `bool isBig(double);`
- b) `bool isBig(double) { }`
- c) `double isBig(bool);`
- d) `isBig(double) bool;`

**Q8.** [Medium] What does this print?

```cpp
int add(int a, int b = 10) { return a + b; }
int main() {
    cout << add(5) << " " << add(5, 1);
}
```

- a) `15 6`
- b) `5 6`
- c) `15 15`
- d) a compile error

**Q9.** [Hard] What does this print?

```cpp
int mystery(int n) {
    if (n <= 0) return 0;
    return n + mystery(n - 1);
}
int main() { cout << mystery(4); }
```

- a) 4
- b) 10 — 4+3+2+1+0 assembled on the unwinds
- c) 0
- d) infinite recursion

**Q10.** [Hard] A function must return *two* results. The cleanest course
idiom at this point in the curriculum is…

- a) two separate `return` statements
- b) reference parameters: `void f(int x, int& out1, int& out2)`
- c) global variables for the outputs
- d) returning one and hoping

<details markdown="1">
<summary><strong>W07 — Answer key</strong></summary>

**Q1 — b.** `void` = "no value comes back." Callers use it for its effect, not
its result.

**Q2 — b.** Parameters are the function's named inputs, declared in the
parentheses; arguments are the actual values supplied at the call site.

**Q3 — b.** Locals are born at declaration and die at the closing brace —
the reason returning references to locals is a dangling-pointer bug (Week 13).

**Q4 — b.** Pass-by-value: `twice` doubled its own copy. The caller's `v` is
untouched — 10 then 5.

**Q5 — b.** Same lesson from the other side: mutating a value parameter never
travels back. (Compare W07's lab: `int&` would have made it 4.)

**Q6 — b.** Globals are shared by all functions; two calls increment the same
object → 12. The course's rule — pass parameters, avoid new globals — exists
because this implicit coupling gets unreadable at scale.

**Q7 — a.** A prototype ends with a semicolon and names types (parameter
names optional). (b) is a definition with an empty body and no return — a
different beast; (c) swaps the types.

**Q8 — a.** Default arguments fill omitted trailing parameters: `add(5)` is
`add(5, 10)` → 15; the explicit call overrides → 6.

**Q9 — b.** The recursion dives to mystery(0) = 0, then unwinds 1+2+3+4 = 10.
Base case first; the multiplications/accumulations happen on the way up.

**Q10 — b.** Reference out-parameters are the course's multi-result idiom
(Week 8 deepens it; returning a struct arrives with records in Week 14).
Two returns are impossible; globals are the trap this course retires.
</details>

---

## W08 — Functions II: references, overloading, design (Week 8)

**Q1.** [Easy] `void fill(int& out)` — the `&` makes `out`…

- a) a copy of the caller's variable
- b) an alias for the caller's variable — writes inside travel back
- c) a constant
- d) a pointer

**Q2.** [Easy] Two functions may share the name `area` when…

- a) never — names must be unique
- b) their parameter lists differ (overloading)
- c) their return types differ
- d) they are in different files

**Q3.** [Easy] Which call is ambiguous for `void f(int); void f(double);`?

- a) `f(3)`
- b) `f(3.0)`
- c) `f(3.5f)` — a float
- d) none are ambiguous

**Q4.** [Medium] What does this print?

```cpp
void swapVals(int& a, int& b) { int t = a; a = b; b = t; }
int main() {
    int x = 1, y = 9;
    swapVals(x, y);
    cout << x << y;
}
```

- a) 19
- b) 91 — the references swapped the caller's variables
- c) 11
- d) 99

**Q5.** [Medium] What does this print?

```cpp
void grow(int n)   { n++; }
void growRef(int& n) { n++; }
int main() {
    int v = 5;
    grow(v);
    growRef(v);
    cout << v;
}
```

- a) 5
- b) 6 — only the reference version changed it
- c) 7
- d) 0

**Q6.** [Medium] Top-down design's first step for a large program is…

- a) write `main` with the smallest possible statements
- b) split the problem into named sub-tasks, then define each as a function
- c) write everything in one function, then split later
- d) choose variable names

**Q7.** [Medium] A *stub* is…

- a) a finished, tested function
- b) a temporary placeholder that returns a fixed value so the rest can run
- c) a global variable
- d) a function that never returns

**Q8.** [Medium] What does this print?

```cpp
double apply(double x)            { return x; }
double apply(double x, double f)  { return x * f; }
int main() { cout << apply(3.0) << " " << apply(3.0, 2.0); }
```

- a) `3 6` — overloading picks by argument count
- b) `3 3`
- c) `6 6`
- d) a compile error: redefinition

**Q9.** [Hard] What does this print?

```cpp
void analyze(int a, int b, int& mn, int& mx) {
    mn = (a < b) ? a : b;
    mx = (a > b) ? a : b;
}
int main() {
    int lo = 0, hi = 0;
    analyze(7, 2, lo, hi);
    cout << lo << hi;
}
```

- a) 72
- b) 27 — the out-params came back filled
- c) 00
- d) 77

**Q10.** [Hard] A function needs to *read* a large string but must never change
it. The best parameter form is…

- a) `void f(string s)` — copies, therefore safe
- b) `void f(const string& s)` — no copy, and the compiler enforces read-only
- c) `void f(string& s)` — efficient but invites accidental writes
- d) `void f(string* s)` — pointers before references are taught

<details markdown="1">
<summary><strong>W08 — Answer key</strong></summary>

**Q1 — b.** A reference parameter is another name for the caller's object.
Assignment to it is assignment to the original — the out-parameter idiom.

**Q2 — b.** Overloading is by *parameter list* (count/types). Return type
alone cannot distinguish overloads — the compiler ignores it when resolving.

**Q3 — c.** A `float` argument needs a promotion to match either `int`
(float→int, losing data — not allowed implicitly here) or `double`
(float→double, fine). Promotion rules make (a) and (b) exact or safe matches,
but the float is the classic ambiguity that once required a cast in older
standards — reading the compiler's ambiguity error is the skill.

**Q4 — b.** References make the temp-swap operate on x and y themselves: 91.

**Q5 — b.** One call by value (no effect), one by reference (5→6). Side by
side, the `&` is the whole difference.

**Q6 — b.** Design precedes code: name the sub-problems, make each a
function, keep `main` a coordinator. The week's refactor lab is exactly this
move on an existing program.

**Q7 — b.** Stubs let the program's skeleton run and be tested before every
part exists — the driver/stub pair is how you test functions in isolation.

**Q8 — a.** Distinct signatures: one argument picks the single-parameter
version (3), two arguments the multiplying one (6). Not a redefinition — the
parameter lists differ.

**Q9 — b.** Two inputs by value, two outputs by reference: lo=2, hi=7, printed
as `27`. The multi-result idiom in four lines.

**Q10 — b.** The `const string&` pattern — no copy cost, and any accidental
write is a compile error. It is the single most reused signature in the
course's later modules.
</details>

---

**Next:** [W09–W12 — Collections, algorithms, strings, files →](weeklies-3.md) · [Hub](index.md)
