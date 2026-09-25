---
title: "Weekly Quizzes W01–W04 — Foundations"
description: "Weeks 1–4: programs & compiling, variables & arithmetic, input & output, selection — 10 questions each with hidden answer keys and explanations."
---

# Weekly Quizzes — W01 to W04

> 10 questions each · ~15 min each · attempt ALL ten before opening the key ·
> [Hub](index.md) · [W05–W08 →](weeklies-2.md)

---

## W01 — Programs, compiling, first output (Week 1)

**Q1.** [Easy] The edit–compile–run cycle is best described as…

- a) edit, then run, then compile if it fails
- b) edit the source, compile it into an executable, run the executable
- c) compile, edit, run in any order you like
- d) run the source file directly; compiling is optional

**Q2.** [Easy] Which file does the compiler *read*?

- a) the executable
- b) the `.cpp` source file
- c) the terminal
- d) the output of the program

**Q3.** [Easy] In `g++ -std=c++17 -Wall -Wextra hello.cpp -o hello`, the `-o hello` part means…

- a) optimize the program
- b) name the output executable `hello`
- c) run the program once
- d) open the file for editing

**Q4.** [Medium] Every C++ program begins executing at…

- a) the first line of the file, whatever it is
- b) the first function defined
- c) the `main` function
- d) `#include <iostream>`

**Q5.** [Medium] What does this print?

```cpp
#include <iostream>
using namespace std;
int main() {
    cout << "3 + 4";
    return 0;
}
```

- a) `7`
- b) `3 + 4`
- c) nothing — the expression must be outside quotes
- d) an error

**Q6.** [Medium] A *syntax error* is…

- a) the program running but producing wrong output
- b) the compiler refusing the text because it breaks the language's grammar
- c) a crash while the program runs
- d) a warning you can ignore forever

**Q7.** [Medium] `cout << "Hi\n"` versus `cout << "Hi"` — the difference is…

- a) none; both move to a new line
- b) the first prints a newline after `Hi`
- c) the second prints a newline before `Hi`
- d) the first is invalid

**Q8.** [Medium] The compiler's warning `-Wall` exists because…

- a) all programs must have warnings to compile
- b) some legal code is suspicious, and warnings point at it before it bites
- c) it makes the program run faster
- d) it deletes errors automatically

**Q9.** [Hard] Which is a *logic* error?

```cpp
int a = 5, b = 2;
cout << a + b * 2;   // wanted: (a + b) * 2 = 14
```

- a) it prints 9 — legal code, wrong result
- b) it prints 14
- c) it fails to compile
- d) it crashes

**Q10.** [Hard] You change your source file, but running `./hello` shows the old
behavior. The most likely cause is…

- a) the terminal is broken
- b) you never recompiled — the executable is from the old source
- c) C++ programs cannot be changed
- d) `cout` is caching the output

<details markdown="1">
<summary><strong>W01 — Answer key (open only after attempting)</strong></summary>

**Q1 — b.** The cycle is edit → compile → run. The executable, not the source,
is what runs.

**Q2 — b.** The compiler reads source text; everything else in the cycle is
produced by it.

**Q3 — b.** `-o` names the output file. Without it, most compilers default to
`a.out` (or `a.exe`).

**Q4 — c.** `main` is the entry point — the only function the operating system
calls by name when the program starts.

**Q5 — b.** `"3 + 4"` is a *string literal*: characters, not an expression.
Remove the quotes and `cout << 3 + 4` evaluates and prints `7`.

**Q6 — b.** Syntax errors are grammar violations caught at compile time. Wrong
output (a) is a logic error; crashes (c) are runtime errors.

**Q7 — b.** `\n` is the escape character for a newline; without it, the next
output continues on the same line.

**Q8 — b.** Warnings flag *legal but suspicious* code — the compiler accepts it
while telling you it smells wrong. Turn warnings on; they are free bug
detection.

**Q9 — a.** It compiles and runs, printing 9 (5 + 2·2). The *intended* 14
requires parentheses. Legal code, wrong answer — the definition of a logic
error.

**Q10 — b.** The executable is a snapshot of the source at compile time.
Edit-compile-**run** means recompiling after every edit.
</details>

---

## W02 — Variables, types, arithmetic (Week 2)

**Q1.** [Easy] Which declares a whole-number variable?

- a) `double total;`
- b) `int count;`
- c) `char count;`
- d) `bool total;`

**Q2.** [Easy] What is stored in `x` after `int x = 7 / 2;`?

- a) 3.5
- b) 3
- c) 4
- d) an error

**Q3.** [Easy] `10 % 3` evaluates to…

- a) 3
- b) 3.33
- c) 1
- d) 0

**Q4.** [Medium] Which literal is a `char`?

- a) `"A"`
- b) `'A'`
- c) `A`
- d) `65.0`

**Q5.** [Medium] `const int SPEED = 80; SPEED = 90;` — what happens?

- a) SPEED becomes 90
- b) compile error: assignment to a constant
- c) SPEED becomes 170
- d) undefined behavior

**Q6.** [Medium] Which expression computes the average of `int a, b` correctly?

- a) `(a + b) / 2`
- b) `(a + b) / 2.0`
- c) `a / 2 + b / 2`
- d) `double(a + b / 2)`

**Q7.** [Medium] After `int x = 5; x += 3; x *= 2;` what is `x`?

- a) 13
- b) 16
- c) 10
- d) 11

**Q8.** [Medium] What does this print?

```cpp
int a = 4, b = 10;
cout << a + b * 2;
```

- a) 28
- b) 24
- c) 18
- d) 12

**Q9.** [Hard] What does this print?

```cpp
int p = 17;
cout << p / 5 << " " << p % 5;
```

- a) `3.4 2`
- b) `3 2`
- c) `3 3`
- d) `2 3`

**Q10.** [Hard] A program stores money as `double balance = 0.1 + 0.2;` and then
tests `balance == 0.3`. The test…

- a) passes — addition is exact
- b) fails — 0.1 and 0.2 are not exactly representable in binary floating point
- c) fails only on some compilers, so it is fine to ignore
- d) crashes

<details markdown="1">
<summary><strong>W02 — Answer key</strong></summary>

**Q1 — b.** `int` is the whole-number type. `double` holds decimals, `char`
holds one character, `bool` holds true/false.

**Q2 — b.** Integer division truncates: 7/2 is 3, remainder discarded. Use
`7 / 2.0` when you want 3.5.

**Q3 — c.** `%` is the remainder: 10 = 3·3 + 1. Both operands must be integers.

**Q4 — b.** Single quotes make a character literal; double quotes make a
string (`"A"` is two characters plus a terminator).

**Q5 — b.** `const` means initialize-once. Assigning later is a compile error —
the compiler is the guard you asked for.

**Q6 — b.** Dividing by `2.0` promotes the whole expression to floating point.
(a) truncates; (c) truncates twice; (d) converts *after* the integer division
inside already lost the fraction.

**Q7 — b.** 5 + 3 = 8; 8 × 2 = 16. Compound assignments read as "update x
using the operation."

**Q8 — b.** Precedence: `*` before `+` → 10 + 4 = 24. Parentheses change it to
28 — the trap the question is built on.

**Q9 — b.** `/` gives the quotient 3, `%` the remainder 2. Together they
partition 17 = 3·5 + 2 exactly.

**Q10 — b.** Binary floating point cannot represent 0.1 or 0.2 exactly, so the
sum is a hair off 0.3. Compare with a tolerance (`fabs(balance - 0.3) < 1e-9`)
or store money as integer cents.
</details>

---

## W03 — Input, output, and the buffer (Week 3)

**Q1.** [Easy] Which statement reads one whole number from the keyboard into
`age`?

- a) `cout >> age;`
- b) `cin >> age;`
- c) `cin << age;`
- d) `read(age);`

**Q2.** [Easy] `cin >> word;` where the user types `Ali Raza` puts what in
`word`?

- a) `Ali Raza`
- b) `Ali` — `>>` stops at the first space
- c) `Raza`
- d) nothing

**Q3.** [Easy] `getline(cin, line);` reads…

- a) one word
- b) one character
- c) one entire line, spaces included, up to Enter
- d) nothing until a number arrives

**Q4.** [Medium] After `int n; cin >> n;` the buffer still contains the Enter
key. What does an immediate `getline(cin, s)` usually get?

- a) the user's next line
- b) an empty string — it consumes the leftover newline
- c) a compile error
- d) the number n again

**Q5.** [Medium] Which prints `Total: 12.50`?

- a) `cout << "Total: " << 12.5;`
- b) `cout << fixed << setprecision(2) << "Total: " << 12.5;`
- c) `cout << "Total: %.2f" << 12.5;`
- d) `print("Total: 12.50")`

**Q6.** [Medium] What does this print for input `7 8`?

```cpp
int a, b;
cin >> a >> b;
cout << a + b;
```

- a) 78
- b) 15
- c) 7 8
- d) an error

**Q7.** [Medium] The standard fix after `cin >> n;` and before `getline` is…

- a) `cin.clear();`
- b) `cin.ignore();`
- c) `cin.getline();`
- d) nothing — it works automatically

**Q8.** [Medium] What does this print?

```cpp
cout << setw(6) << 42 << "|";
```

(with `<iomanip>` included)

- a) `42|`
- b) `    42|` — right-aligned in width 6
- c) `42    |`
- d) `######42|`

**Q9.** [Hard] What does this print for input `5`?

```cpp
int x;
cin >> x;
cout << "got " << x << endl << "done";
```

- a) `got 5done`
- b) `got 5` then `done` on the next line
- c) `got  5 done`
- d) nothing

**Q10.** [Hard] A program reads a mark with `cin >> mark;` and the user types
`abc`. What is true of `mark` afterwards?

- a) it is 0 and the stream is still fine
- b) the read fails: `mark` is unchanged (or 0 since C++11) and the stream is
  in a fail state until cleared
- c) the program crashes
- d) it holds the string "abc"

<details markdown="1">
<summary><strong>W03 — Answer key</strong></summary>

**Q1 — b.** `cin` with `>>` extracts; the arrows point from the stream into
the variable.

**Q2 — b.** `>>` is whitespace-delimited: it stops at the first space and
leaves `Raza` for the next read. Whole lines need `getline`.

**Q3 — c.** `getline` reads to the end of the line and consumes the newline;
spaces are kept.

**Q4 — b.** The leftover newline satisfies `getline` immediately — the classic
mixing trap. Fix with one `cin.ignore()` between the `>>` and the `getline`.

**Q5 — b.** `fixed` + `setprecision(2)` formats decimals; the header is
`<iomanip>`. (a) prints `12.5`; (c) is C's printf syntax, not C++ streams.

**Q6 — b.** Two `>>` reads across the same line work naturally: 7 then 8, sum 15.

**Q7 — b.** `cin.ignore()` discards the buffered newline. `cin.clear()` resets
a *failed* stream — a different problem.

**Q8 — b.** `setw(6)` pads to 6 columns, right-aligned by default: four spaces
then `42`. `setw` applies to the next output only.

**Q9 — b.** `endl` outputs a newline (and flushes); the second `<<` chain
continues on the new line.

**Q10 — b.** `>>` into an `int` expects digits; `abc` fails the read, the
stream enters a fail state (further reads do nothing until `clear()`), and the
variable is zeroed (C++11) — never trusted input. This is why validation
exists.
</details>

---

## W04 — Selection: if, else-if, switch (Week 4)

**Q1.** [Easy] Which condition is true when `mark` is exactly 50 and passing
means 50 or above?

- a) `mark > 50`
- b) `mark >= 50`
- c) `mark = 50`
- d) `mark => 50`

**Q2.** [Easy] What does this print for `x = 5`?

```cpp
if (x > 3) cout << "A";
else       cout << "B";
```

- a) A
- b) B
- c) AB
- d) nothing

**Q3.** [Easy] In a `switch`, what does `break` do?

- a) ends the program
- b) exits the switch — without it, execution falls into the next case
- c) skips the default case
- d) restarts the switch

**Q4.** [Medium] What does this print for `age = 15`?

```cpp
if (age < 13)      cout << "CHILD";
else if (age < 20) cout << "TEEN";
else               cout << "ADULT";
```

- a) CHILD
- b) TEEN
- c) ADULT
- d) CHILDTEEN

**Q5.** [Medium] `bool ok = (a > 0) && (b > 0);` with `a = 4, b = -1` gives…

- a) true
- b) false
- c) a compile error
- d) 4

**Q6.** [Medium] What does this print for `n = 3`?

```cpp
switch (n) {
    case 1: cout << "one "; break;
    case 3: cout << "three ";
    case 5: cout << "five "; break;
    default: cout << "other";
}
```

- a) `three`
- b) `three five` — case 3 has no break, so it falls through
- c) `three five other`
- d) nothing

**Q7.** [Medium] Which tests "n is between 1 and 100 inclusive"?

- a) `1 <= n <= 100`
- b) `n >= 1 && n <= 100`
- c) `n >= 1 || n <= 100`
- d) `n > 0 && n < 100`

**Q8.** [Medium] What does this print for `temp = 40`?

```cpp
if (temp > 35)
    cout << "HOT";
    cout << " day";
```

- a) `HOT day`
- b) `day`
- c) `HOT`
- d) nothing

**Q9.** [Hard] What does this print for `x = 7`?

```cpp
int y = (x % 2 == 0) ? x / 2 : x * 3 + 1;
cout << y;
```

- a) 3
- b) 22
- c) 14
- d) 7

**Q10.** [Hard] The ladder `if (m < 50) FAIL; else if (m < 70) PASS; else if
(m < 70) RETRY;` — why is the third branch unreachable?

- a) because FAIL catches everything
- b) because any mark that failed `< 50` in the first test cannot re-enter; and
  any mark reaching the third test already satisfied `< 70` in the second —
  the condition is always false there
- c) because else-if chains need different variables
- d) it is reachable for m = 70

<details markdown="1">
<summary><strong>W04 — Answer key</strong></summary>

**Q1 — b.** "50 or above" is `>=`. Option (c) is assignment, not comparison —
and (d) is not an operator at all.

**Q2 — a.** 5 > 3 is true, so only the if-branch runs. The else is skipped,
never both.

**Q3 — b.** `break` leaves the switch. Fallthrough — running into the next
case — is legal but almost always unintended; comment it if you ever mean it.

**Q4 — b.** 15 fails `< 13`, satisfies `< 20` → TEEN. The ladder's implicit
ranges come from earlier tests failing.

**Q5 — b.** `&&` needs both sides true. The first is true, the second false →
false. Short-circuit evaluation means `b > 0` may not even run.

**Q6 — b.** Case 3 matches, prints `three `, has no break, falls through to
case 5 printing `five `, whose break exits. Fallthrough demonstrated
deliberately.

**Q7 — b.** Each comparison stands alone and `&&` joins them. Option (a) is
the classic wrong translation — it parses as `(1 <= n) <= 100`, always true.
Option (c)'s `||` is nearly everything.

**Q8 — b.** Without braces, only the first statement belongs to the `if`;
`cout << " day";` is unconditional. Indentation lied — braces are the truth.

**Q9 — b.** 7 % 2 == 0 is false → the else-branch of the conditional operator:
7·3+1 = 22. This line is also the Collatz step — the loop around it comes in
Week 5.

**Q10 — b.** In an else-if chain each test inherits all earlier failures.
Reaching the third branch guarantees m ≥ 70, so `m < 70` is false forever —
a duplicate-condition bug that silently deletes a grade band.
</details>

---

**Next:** [W05–W08 — Control flow and functions →](weeklies-2.md) · [Hub](index.md)
