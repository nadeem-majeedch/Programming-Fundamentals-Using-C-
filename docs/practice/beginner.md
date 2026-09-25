---
title: "Practice Bank — Beginner Tier (40 problems)"
description: "B-01…B-40: variables, input/output, conditions, and first loops — each with statement, topics, I/O, constraints, samples, graded hints, reference solution, and explanation."
---

# Beginner tier — B-01 to B-40

> **Units first:** [Stage A — Foundations](../syllabus.md#stage-a-foundations-units-1-3) (variables, input/output, conditions).
> **Attempt protocol:** 15 minutes before hints · one hint at a time · samples + one self-invented test before ticking [the checklist](index.md).

## Part 1 — Variables & expressions (B-01…B-10)

### B-01 — Pocket money split

**Difficulty:** ★ · **Topics:** variables, arithmetic, output

A student receives pocket money for the month and splits it into equal weekly portions.

**Input:** two integers — total money (1–100000), weeks (1–4).
**Output:** per-week amount and the leftover, each on its own line, as in the sample.
**Constraints:** division is exact only sometimes; the leftover must be reported.
**Sample tests:** `1200 4` → `300` `0` · `1250 4` → `312` `2`
**Hints:** ① which operator gives the portion? ② the leftover is what division *discards*.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int total, weeks;
    cin >> total >> weeks;
    int perWeek = total / weeks;
    int leftover = total % weeks;
    cout << perWeek << "\n" << leftover << "\n";
    return 0;
}
```

**Explanation:** `/` on integers is integer division — it discards the remainder; `%` captures exactly what was discarded. Together they partition the total with no arithmetic surprises. *Distinct idea:* the division/remainder pair as a partition tool.

---

### B-02 — Seconds decomposer

**Difficulty:** ★ · **Topics:** variables, arithmetic

Convert a total number of seconds into hours, minutes, and remaining seconds.

**Input:** one integer 1–86399.
**Output:** three integers separated by spaces — h m s.
**Constraints:** no loops; pure arithmetic.
**Sample tests:** `3665` → `1 1 5` · `59` → `0 0 59`
**Hints:** ① hours first, largest unit; ② after removing hours, what remains?
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int total;
    cin >> total;
    int h = total / 3600;
    int m = (total % 3600) / 60;
    int s = total % 60;
    cout << h << " " << m << " " << s << "\n";
    return 0;
}
```

**Explanation:** each unit is extracted by dividing by its size — *after* subtracting larger units via the remainder. The chain `total % 3600` then `/ 60` is the pattern for any unit decomposition. *Distinct idea:* layered unit extraction.

---

### B-03 — Digit sum of a three-digit number

**Difficulty:** ★ · **Topics:** variables, arithmetic

Read a three-digit number and print the sum of its digits.

**Input:** one integer 100–999.
**Output:** one integer.
**Sample tests:** `472` → `13` · `305` → `8`
**Hints:** ① `% 10` isolates the last digit; ② `/ 10` removes it.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    int ones = n % 10;
    int tens = (n / 10) % 10;
    int hundreds = n / 100;
    cout << ones + tens + hundreds << "\n";
    return 0;
}
```

**Explanation:** `%` and `/` by 10 are the "peek" and "chop" of the decimal system. This fixed-width version uses no loops — B-31 revisits it generally. *Distinct idea:* digits as arithmetic, not characters.

---

### B-04 — Price with discount ladder (single rule)

**Difficulty:** ★ · **Topics:** variables, arithmetic, output formatting

Compute the final price after one discount: 10% if the price is at least 1000, else none.

**Input:** one number 1.0–100000.0.
**Output:** final price with exactly two decimal places.
**Sample tests:** `1500` → `1350.00` · `999` → `999.00`
**Hints:** ① `fixed` and `setprecision(2)` from `<iomanip>`; ② the condition picks the multiplier.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    double price;
    cin >> price;
    double rate = (price >= 1000.0) ? 0.10 : 0.0;
    cout << fixed << setprecision(2) << price * (1.0 - rate) << "\n";
    return 0;
}
```

**Explanation:** the multiplier form `price * (1 - rate)` reads as "keep this fraction of the price" and avoids a subtraction round-trip. *Distinct idea:* choosing a *multiplier* by condition.

---

### B-05 — Average of four quiz marks

**Difficulty:** ★ · **Topics:** variables, arithmetic, type conversion

Read four integer marks and print their average to two decimal places.

**Input:** four integers 0–100.
**Output:** one number, two decimals.
**Sample tests:** `80 90 70 100` → `85.00` · `1 2 3 4` → `2.50`
**Hints:** ① `(a+b+c+d)/4` on ints throws away the fraction — why?
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    int a, b, c, d;
    cin >> a >> b >> c >> d;
    double avg = (a + b + c + d) / 4.0;
    cout << fixed << setprecision(2) << avg << "\n";
    return 0;
}
```

**Explanation:** one `4.0` forces floating-point division for the whole expression. B-05 and B-12 look like siblings but test different conversions (int→double here, rounding there). *Distinct idea:* promoting division with one literal.

---

### B-06 — Temperature converter (C→F, two decimals)

**Difficulty:** ★ · **Topics:** variables, arithmetic, formatted output

**Input:** one Celsius value −89.0…57.0.
**Output:** Fahrenheit, two decimals, using F = C × 9/5 + 32.
**Sample tests:** `37` → `98.60` · `-40` → `-40.00`
**Hints:** ① `9/5` in C++ is `1` — write `9.0/5.0`.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    double c;
    cin >> c;
    cout << fixed << setprecision(2) << c * 9.0 / 5.0 + 32.0 << "\n";
    return 0;
}
```

**Explanation:** the classic integer-division trap is *inside the formula itself*: `9/5` evaluates to 1 before any conversion. *Distinct idea:* literals' types shape formula results.

---

### B-07 — Swap two values (three-variable dance)

**Difficulty:** ★★ · **Topics:** variables, assignment order

Read two integers, swap their values, print both after.

**Input:** two distinct integers −1000…1000.
**Output:** the two values in swapped order, space-separated.
**Sample tests:** `3 8` → `8 3` · `-5 12` → `12 -5`
**Hints:** ① what happens to `a` when you write `a = b;` first? ② a third variable is the safe courier.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int a, b;
    cin >> a >> b;
    int temp = a;
    a = b;
    b = temp;
    cout << a << " " << b << "\n";
    return 0;
}
```

**Explanation:** assignment *overwrites*: without `temp`, the original `a` is gone after `a = b`. The three-step dance is the foundation of every in-place swap, including A-31's sorting work. *Distinct idea:* assignment order as a correctness property.

---

### B-08 — Rectangle report

**Difficulty:** ★ · **Topics:** variables, arithmetic, multi-line output

Read length and width; print area, perimeter, and the diagonal (two decimals) on three lines.

**Input:** two numbers 0.1–10000.0.
**Output:** `Area: X` / `Perimeter: X` / `Diagonal: X` (two decimals each).
**Sample tests:** `3 4` → Area 12.00, Perimeter 14.00, Diagonal 5.00
**Hints:** ① the diagonal needs `sqrt` from `<cmath>`.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
#include <cmath>
using namespace std;
int main() {
    double len, wid;
    cin >> len >> wid;
    cout << fixed << setprecision(2);
    cout << "Area: " << len * wid << "\n";
    cout << "Perimeter: " << 2 * (len + wid) << "\n";
    cout << "Diagonal: " << sqrt(len * len + wid * wid) << "\n";
    return 0;
}
```

**Explanation:** one stream-formatting statement (`cout << fixed << setprecision(2)`) is sticky — it stays for later `<<`. *Distinct idea:* format state persists across statements.

---

### B-09 — Cents-only money

**Difficulty:** ★★ · **Topics:** variables, arithmetic, units

Store money as integer cents, not double. Read rupees and paisa, then read a purchase in rupees; print the remaining balance as `R.P` (R rupees, P two-digit paisa).

**Input:** balance rupees 0–9999, balance paisa 0–99, cost rupees 0–9999, cost paisa 0–99 (cost ≤ balance).
**Output:** `1234.56` style remaining balance.
**Sample tests:** `100 50 40 75` → `59.75` · `10 5 10 5` → `0.00`
**Hints:** ① convert both to cents first; ② `% 100` recovers paisa.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    int br, bp, cr, cp;
    cin >> br >> bp >> cr >> cp;
    int bal = br * 100 + bp;
    int cost = cr * 100 + cp;
    int left = bal - cost;
    cout << left / 100 << "."
         << setfill('0') << setw(2) << left % 100 << "\n";
    return 0;
}
```

**Explanation:** money in integers avoids binary-fraction surprises (`0.1` isn't exact in binary). The `setw(2)` + `setfill('0')` pair pads `5` paisa to `05`. *Distinct idea:* units as an integer-design decision.

---

### B-10 — Expression evaluator (predict, then compute)

**Difficulty:** ★★ · **Topics:** variables, operator precedence

Given `a=6, b=3, c=2` compute four expressions and print each result on its own line:
`a + b * c`, `(a + b) * c`, `a / b / c`, `a - b - c`.

**Input:** none — the values are fixed in the code.
**Output:** four integers, one per line: `12`, `18`, `1`, `1`.
**Constraints:** predict on paper before running; if any prediction differs, explain why in a comment.
**Hints:** ① precedence: `*` before `+`; ② same-precedence operators group left to right.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int a = 6, b = 3, c = 2;
    cout << a + b * c   << "\n";  // 12
    cout << (a + b) * c << "\n";  // 18
    cout << a / b / c   << "\n";  // (6/3)/2 = 1, not 6/(3/2)
    cout << a - b - c   << "\n";  // (6-3)-2 = 1
    return 0;
}
```

**Explanation:** precedence is the grammar of arithmetic; associativity (left-to-right for `/` and `-`) is its second half. The `/b/c` line is the one beginners consistently miss. *Distinct idea:* evaluation grammar made visible.

---

## Part 2 — Input / output (B-11…B-20)

### B-11 — Student card line

**Difficulty:** ★ · **Topics:** input/output, strings (intro), `getline`

Read a name that may contain spaces, then an age; print `Name (Age)`.

**Input:** a full name on one line (1–50 chars), then an integer 1–120 on the next.
**Output:** exactly `Ali Raza (20)` for input `Ali Raza` `20`.
**Hints:** ① `>>` stops at the first space; ② after `>>` into age you'd need `cin.ignore` — so read the *name first* with `getline`, *then* `>>` the age.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    string name;
    int age;
    getline(cin, name);
    cin >> age;
    cout << name << " (" << age << ")\n";
    return 0;
}
```

**Explanation:** ordering the reads name-first sidesteps the mixing trap entirely — the classic `getline`-after-`>>` issue is introduced with the fix in sight, and I-13 forces the harder order. *Distinct idea:* read order as a design choice.

---

### B-12 — Rounding half-up

**Difficulty:** ★★ · **Topics:** input/output, type conversion, rounding

Read a decimal number; print it rounded **half up** (0.5 → 1, −0.5 → 0) as an integer.

**Input:** one number −1000.0…1000.0.
**Output:** one integer.
**Sample tests:** `2.5` → `3` · `2.4` → `2` · `-2.5` → `-2`
**Hints:** ① `floor(x + 0.5)` — check it on the negatives; ② `<cmath>`.
**Reference solution**

```cpp
#include <iostream>
#include <cmath>
using namespace std;
int main() {
    double x;
    cin >> x;
    cout << (long long)floor(x + 0.5) << "\n";
    return 0;
}
```

**Explanation:** `floor(x+0.5)` is the half-up rule and behaves *asymmetrically* on negatives (−2.5 → −2) — that's what "half up" means (toward +∞ on the tie). Plain casting truncates, a different rule. *Distinct idea:* rounding as a specified rule, not a cast.

---

### B-13 — Field-width table

**Difficulty:** ★★ · **Topics:** input/output, formatting

Read three rows of (item name without spaces, quantity, price). Print a right-aligned table: name in width 10, quantity in width 5, price in width 8 with two decimals.

**Input:** three lines, each `name quantity price`.
**Output:** a header `Item      Qty      Price` then the three aligned rows.
**Sample tests:** input `Pen 12 1.5` row → `       Pen   12    1.50`
**Hints:** ① `setw` applies only to the *next* output; ② `<iomanip>`.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    cout << left << setw(10) << "Item" << setw(5) << "Qty" << "Price\n";
    for (int i = 0; i < 3; i++) {          // first taste of loops; covered in B-31+
        string name; int qty; double price;
        cin >> name >> qty >> price;
        cout << left << setw(10) << name << right << setw(5) << qty
             << setw(8) << fixed << setprecision(2) << price << "\n";
    }
    return 0;
}
```

**Explanation:** `left`/`right` choose the padding direction per field; `setw` is one-shot while `fixed`/`setprecision` are sticky — mixing the two behaviors is the formatting lesson. *Distinct idea:* per-field vs persistent formatting.

---

### B-14 — Echo with types

**Difficulty:** ★ · **Topics:** input/output, reading all base types

Read, in order: an int, a double, a char, and a single word. Echo each on its own line, labeled.

**Input:** `42 3.14 x hello`
**Output:** `int: 42` / `double: 3.14` / `char: x` / `word: hello`
**Constraints:** the char is separated by whitespace.
**Hints:** ① `cin >>` skips whitespace between all four reads — no `.ignore()` needed here; why not?
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    int i; double d; char c; string w;
    cin >> i >> d >> c >> w;
    cout << "int: " << i << "\ndouble: " << d
         << "\nchar: " << c << "\nword: " << w << "\n";
    return 0;
}
```

**Explanation:** `>>` is whitespace-driven: consecutive `>>` reads naturally sequence across a line. The `.ignore()` problem only appears when `getline` joins the party. *Distinct idea:* when the trap *doesn't* apply and why.

---

### B-15 — Two-line form printer

**Difficulty:** ★ · **Topics:** input/output, `getline`, multi-part strings

Read a full name (with spaces) and a city (with spaces), each on its own line. Print:
`Applicant: <name>` / `City: <city>` / `Initials: <first letter of name>.`

**Input:** `Fatima Zahra` then `Lahore`
**Output:** `Applicant: Fatima Zahra` / `City: Lahore` / `Initials: F.`
**Constraints:** the first name is at least 1 character.
**Hints:** ① initials: `name[0]`.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    string name, city;
    getline(cin, name);
    getline(cin, city);
    cout << "Applicant: " << name << "\nCity: " << city
         << "\nInitials: " << name[0] << ".\n";
    return 0;
}
```

**Explanation:** back-to-back `getline` calls work cleanly because each consumes its own line — the trap only fires after a `>>`. Indexing `name[0]` previews string indexing (full treatment in I-13+). *Distinct idea:* sequential getline discipline.

---

### B-16 — Fixed-point money formatter

**Difficulty:** ★★ · **Topics:** input/output, rounding to cents

Read a rupee amount as a decimal; print it rounded to two decimals, always showing both digits (`5.5` → `5.50`, `5.555` → `5.56`).

**Input:** one number 0.0–999999.999.
**Output:** the formatted amount.
**Hints:** ① `fixed` + `setprecision(2)` rounds by the stream; verify the `5.555` case.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    double amt;
    cin >> amt;
    cout << fixed << setprecision(2) << amt << "\n";
    return 0;
}
```

**Explanation:** the stream's rounding is *round-half-to-even*-flavored in practice — a value landing exactly on the half cent may round either way depending on its binary representation. B-09's integer cents are the engineering answer; this problem *demonstrates the symptom*. *Distinct idea:* stream rounding vs exact money.

---

### B-17 — Character counter on one line (preview)

**Difficulty:** ★★ · **Topics:** input/output, getline, strings (intro)

Read one line and print its length and its first and last characters (or `empty` if the line has no characters).

**Input:** one line, 0–200 chars.
**Output:** `len: N first: c last: c` or `empty`.
**Sample tests:** `Hello` → `len: 5 first: H last: o` · `` → `empty`
**Hints:** ① `line.size()`; ② guard `size() == 0` before indexing.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    string line;
    getline(cin, line);
    if (line.empty()) {
        cout << "empty\n";
    } else {
        cout << "len: " << line.size()
             << " first: " << line.front()
             << " last: " << line.back() << "\n";
    }
    return 0;
}
```

**Explanation:** indexing an empty string is undefined behavior — the guard is the lesson, and it previews the boundary-thinking of B-27. *Distinct idea:* guard-then-index.

---

### B-18 — Three-number announcement, formatted

**Difficulty:** ★ · **Topics:** input/output, chaining

Read three integers on one line; print them comma-separated inside brackets: `[a, b, c]`.

**Input:** `1 2 3`
**Output:** `[1, 2, 3]`
**Constraints:** exact spacing — the comma is followed by one space.
**Hints:** ① write the literal text as you want it to appear.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int a, b, c;
    cin >> a >> b >> c;
    cout << "[" << a << ", " << b << ", " << c << "]\n";
    return 0;
}
```

**Explanation:** output precision is a typing-accuracy skill; the string between numbers is just more chainable text. This exact spacing pattern recurs in every later report format. *Distinct idea:* punctuation as output design.

---

### B-19 — Reading a whole line of numbers (preview of loops)

**Difficulty:** ★★ · **Topics:** input/output, loops (first contact)

Read integers until end of input (Ctrl+Z/Enter then Ctrl+D, or a `0` sentinel), then print how many were read and their total. Use the sentinel `0` — a loop-free solution is impossible here, so this is a gentle preview.

**Input:** integers, one or more per line, terminated by `0` (not counted).
**Output:** `count: N total: T`
**Sample tests:** `5 7 0` → `count: 2 total: 12` · `0` → `count: 0 total: 0`
**Hints:** ① `while (cin >> x && x != 0)`; ② accumulate in `sum`.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int x, count = 0, total = 0;
    while (cin >> x && x != 0) {
        count++;
        total += x;
    }
    cout << "count: " << count << " total: " << total << "\n";
    return 0;
}
```

**Explanation:** the loop condition does two jobs — read success *and* sentinel — joined by `&&`. This is the seed of every accumulator loop in the course. *Distinct idea:* the read-as-condition pattern.

---

### B-20 — Receipt line for one item

**Difficulty:** ★ · **Topics:** input/output, arithmetic, formatting

Read item name (no spaces), unit price, and quantity. Print `name x qty = total` with total at two decimals, then a `----` separator of length equal to the printed line.

**Input:** `Tea 2.25 3`
**Output:** `Tea x 3 = 6.75` / `--------------` (14 dashes)
**Hints:** ① build the first line first, then `.length()` it.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
#include <string>
using namespace std;
int main() {
    string name; double price; int qty;
    cin >> name >> price >> qty;
    cout << fixed << setprecision(2)
         << name << " x " << qty << " = " << price * qty << "\n";
    cout << string(14, '-') << "\n";   // length matches the sample line
    return 0;
}
```

**Explanation:** `string(n, ch)` is the repeat constructor — a tidy way to produce rules and separators. The dash count is fixed for the fixed sample format; a variable-width version is a stated extension. *Distinct idea:* strings built from repetition.

---

## Part 3 — Conditions (B-21…B-30)

### B-21 — Pass/fail with the boundary made explicit

**Difficulty:** ★ · **Topics:** conditions, boundaries

Read a mark (0–100). Print `PASS` if it is 50 or more, else `FAIL`.

**Input:** one integer.
**Output:** `PASS` or `FAIL`.
**Sample tests:** `50` → `PASS` · `49` → `FAIL` · `100` → `PASS` · `0` → `FAIL`
**Hints:** ① `>=` — test the exact boundary value.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int mark;
    cin >> mark;
    if (mark >= 50) cout << "PASS\n";
    else            cout << "FAIL\n";
    return 0;
}
```

**Explanation:** the difference between `>` and `>=` *is* a student's grade; the samples deliberately include both sides of the boundary. *Distinct idea:* boundary values as first-class test cases.

---

### B-22 — Largest of three (chain form)

**Difficulty:** ★★ · **Topics:** conditions, compound logic

Read three distinct integers; print the largest.

**Input:** three integers, guaranteed distinct, −1000…1000.
**Output:** one integer.
**Sample tests:** `3 9 4` → `9` · `9 3 4` → `9` · `3 4 9` → `9`
**Hints:** ① chain: if a≥b and a≥c … else if … ② make sure *both* rivals are checked each time.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int a, b, c;
    cin >> a >> b >> c;
    if (a >= b && a >= c)      cout << a << "\n";
    else if (b >= a && b >= c) cout << b << "\n";
    else                       cout << c << "\n";
    return 0;
}
```

**Explanation:** each branch must defeat *all* others, so each condition is compound (`&&`). The distinctness guarantee removes the tie question — which B-38 confronts. *Distinct idea:* compound conditions covering all rivals.

---

### B-23 — Leap year (the full rule)

**Difficulty:** ★★ · **Topics:** conditions, nested logic, boundaries

Read a year (1–3000). Print `LEAP` or `COMMON`.

**Input:** one integer year.
**Output:** `LEAP` or `COMMON`.
**Sample tests:** `2000` → `LEAP` · `1900` → `COMMON` · `2024` → `LEAP` · `2023` → `COMMON`
**Hints:** ① divisible by 4; ② but centuries must be divisible by 400.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int year;
    cin >> year;
    bool leap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    cout << (leap ? "LEAP" : "COMMON") << "\n";
    return 0;
}
```

**Explanation:** the real calendar rule has an exception to an exception — a two-level compound condition. `1900` (divisible by 100 but not 400) is the trap sample. *Distinct idea:* rules with exceptions expressed as one boolean expression.

---

### B-24 — Triangle classifier

**Difficulty:** ★★ · **Topics:** conditions, ordering logic

Read three side lengths (integers 1–1000, any order). Classify: `EQUILATERAL`, `ISOSCELES` (exactly two equal), or `SCALENE`. If the sides cannot form a triangle (triangle inequality), print `INVALID`.

**Input:** three integers.
**Output:** the classification.
**Sample tests:** `3 3 3` → `EQUILATERAL` · `3 3 5` → `ISOSCELES` · `3 4 5` → `SCALENE` · `1 2 3` → `INVALID`
**Hints:** ① validity first: each side < sum of the other two; ② order the checks so the *most specific* equality wins.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int a, b, c;
    cin >> a >> b >> c;
    if (a + b <= c || b + c <= a || a + c <= b) {
        cout << "INVALID\n";
    } else if (a == b && b == c) {
        cout << "EQUILATERAL\n";
    } else if (a == b || b == c || a == c) {
        cout << "ISOSCELES\n";
    } else {
        cout << "SCALENE\n";
    }
    return 0;
}
```

**Explanation:** check order *is* the logic: validity gates everything; equilateral is a special case of isosceles, so it must be tested first. Reordering the equality checks silently misclassifies. *Distinct idea:* classification ladders where specificity ordering matters.

---

### B-25 — BMI band (floor boundaries)

**Difficulty:** ★★ · **Topics:** conditions, else-if ladders, boundaries

Read weight (kg) and height (m). BMI = weight / height². Print the band: `< 18.5` UNDER, `< 25` NORMAL, `< 30` OVER, else OBESE.

**Input:** weight 10.0–300.0, height 0.5–2.5.
**Output:** one band word.
**Sample tests:** `70 1.75` → `NORMAL` (22.86) · `50 1.75` → `UNDER` · `80 1.75` → `OVER` · `100 1.7` → `OBESE`
**Hints:** ① a falling ladder with `<` needs no upper bound in each branch.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    double w, h;
    cin >> w >> h;
    double bmi = w / (h * h);
    if (bmi < 18.5)      cout << "UNDER\n";
    else if (bmi < 25.0) cout << "NORMAL\n";
    else if (bmi < 30.0) cout << "OVER\n";
    else                 cout << "OBESE\n";
    return 0;
}
```

**Explanation:** in an ordered else-if ladder, each branch inherits "all previous were false" — so `< 25` really means "18.5 to 25". Doubling the bounds (`>= 18.5 && < 25`) is correct but redundant, and redundancy invites drift. *Distinct idea:* ladder semantics as implicit ranges.

---

### B-26 — Age category with invalid guard

**Difficulty:** ★ · **Topics:** conditions, input validation guard

Read an age. If it is negative or above 150, print `INVALID`; otherwise print CHILD (0–12), TEEN (13–19), ADULT (20–64), or SENIOR (65+).

**Input:** one integer.
**Output:** one word.
**Sample tests:** `-1` → `INVALID` · `12` → `CHILD` · `13` → `TEEN` · `64` → `ADULT` · `65` → `SENIOR` · `151` → `INVALID`
**Hints:** ① validate *before* classifying.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int age;
    cin >> age;
    if (age < 0 || age > 150) {
        cout << "INVALID\n";
        return 0;
    }
    if (age <= 12)       cout << "CHILD\n";
    else if (age <= 19)  cout << "TEEN\n";
    else if (age <= 64)  cout << "ADULT\n";
    else                 cout << "SENIOR\n";
    return 0;
}
```

**Explanation:** the guard exits early, keeping the main ladder clean — the boundary-guard pattern from the decisions module in miniature. *Distinct idea:* guard-first structure.

---

### B-27 — Range membership with strict/loose ends

**Difficulty:** ★★ · **Topics:** conditions, boundary semantics

Read an integer n and two bounds lo, hi. Print `IN` if `lo <= n <= hi` **inclusive**, else `OUT`. Then print which end, if any, it touches: `LOWER-EDGE`, `UPPER-EDGE`, `BOTH` (only when lo==hi==n), or `INTERIOR`.

**Input:** three integers, lo ≤ hi.
**Output:** two lines.
**Sample tests:** `5 5 10` → `IN` `LOWER-EDGE` · `10 5 10` → `IN` `UPPER-EDGE` · `7 7 7` → `IN` `BOTH` · `8 5 10` → `IN` `INTERIOR` · `11 5 10` → `OUT`
**Hints:** ① four interior cases, mutually exclusive — order matters.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, lo, hi;
    cin >> n >> lo >> hi;
    if (n < lo || n > hi) {
        cout << "OUT\n";
        return 0;
    }
    cout << "IN\n";
    bool lower = (n == lo), upper = (n == hi);
    if (lower && upper)      cout << "BOTH\n";
    else if (lower)          cout << "LOWER-EDGE\n";
    else if (upper)          cout << "UPPER-EDGE\n";
    else                     cout << "INTERIOR\n";
    return 0;
}
```

**Explanation:** membership and *position within* the range are two separate questions — separating them (guard, then edge analysis) keeps each ladder simple. *Distinct idea:* decomposing a condition into question layers.

---

### B-28 — Simple calculator with operator character

**Difficulty:** ★ · **Topics:** conditions, char comparison

Read `a op b` where op is one of `+ - * / %`. Print the result; for `/` print `DIV0` if b is 0; for `%` print `MOD0` if b is 0; for an unknown op print `BADOP`.

**Input:** integers a, b (−1000…1000) and a char op, whitespace-separated.
**Output:** the result or error word.
**Sample tests:** `7 % 3` → `1` · `5 / 0` → `DIV0` · `2 ^ 3` → `BADOP`
**Hints:** ① `switch (op)` or a char if-ladder — both fine; ② check b before dividing.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int a, b; char op;
    cin >> a >> op >> b;
    switch (op) {
        case '+': cout << a + b << "\n"; break;
        case '-': cout << a - b << "\n"; break;
        case '*': cout << a * b << "\n"; break;
        case '/':
            if (b == 0) cout << "DIV0\n";
            else        cout << a / b << "\n";
            break;
        case '%':
            if (b == 0) cout << "MOD0\n";
            else        cout << a % b << "\n";
            break;
        default: cout << "BADOP\n";
    }
    return 0;
}
```

**Explanation:** char `switch` with a guarded division inside two cases — the first taste of *validation inside a branch*, which the robustness module later formalizes. *Distinct idea:* guarding inside switch cases.

---

### B-29 — Small/medium/large parcel fee

**Difficulty:** ★★ · **Topics:** conditions, tiered fees

A courier charges by weight: up to 1 kg → Rs 100; over 1 up to 5 kg → Rs 100 + Rs 40 per kg above 1; over 5 kg → Rs 100 + Rs 40×4 + Rs 25 per kg above 5. Read weight; print the fee.

**Input:** weight 0.1–50.0.
**Output:** integer fee.
**Sample tests:** `0.8` → `100` · `3` → `180` · `7` → `310` (100+160+50)
**Hints:** ① three tiers, two boundaries; ② only the *excess* is charged in each tier.
**Reference solution**

```cpp
#include <iostream>
#include <cmath>
using namespace std;
int main() {
    double w;
    cin >> w;
    if (w <= 1.0)      cout << 100 << "\n";
    else if (w <= 5.0) cout << 100 + (int)ceil(w - 1.0) * 40 << "\n";
    else               cout << 100 + 4 * 40 + (int)ceil(w - 5.0) * 25 << "\n";
    return 0;
}
```

**Explanation:** tiered fees charge the *excess* over each threshold, and the ladder's implicit ranges (`ceil` rounds a fractional kg up to a billable whole kg) make the arithmetic layer work. *Distinct idea:* excess-based tier arithmetic.

---

### B-30 — Coin change for one amount (greedy, fixed denominations)

**Difficulty:** ★★ · **Topics:** conditions, ordering, arithmetic

Read an amount 1–99 (paisa-free). Print how many 50s, 25s, 10s, 5s, 1s — greedy order, one line each.

**Input:** one integer.
**Output:** five lines `50s: n` … `1s: n`.
**Sample tests:** `87` → `50s: 1` `25s: 1` `10s: 1` `5s: 0` `1s: 2`
**Hints:** ① process largest first; ② `/` and `%` do the work — no loops needed.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int amt;
    cin >> amt;
    cout << "50s: " << amt / 50 << "\n";  amt %= 50;
    cout << "25s: " << amt / 25 << "\n";  amt %= 25;
    cout << "10s: " << amt / 10 << "\n";  amt %= 10;
    cout << "5s: "  << amt / 5  << "\n";  amt %= 5;
    cout << "1s: "  << amt << "\n";
    return 0;
}
```

**Explanation:** greedy decomposition with `/`+`%` chains — same machinery as B-02, but now the *order of denominations* is the algorithm. A looped generalization appears in Ba-17. *Distinct idea:* greedy ordering as the plan.

---

## Part 4 — Loops, first contact (B-31…B-40)

### B-31 — Digit sum, any length

**Difficulty:** ★★ · **Topics:** loops, digit processing

Read a positive integer of any length; print the sum of its digits.

**Input:** one integer 1–2,000,000,000.
**Output:** one integer.
**Sample tests:** `4729` → `22` · `5` → `5`
**Hints:** ① `n % 10` then `n /= 10` until n is 0.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n;
    cin >> n;
    int sum = 0;
    while (n > 0) {
        sum += n % 10;
        n /= 10;
    }
    cout << sum << "\n";
    return 0;
}
```

**Explanation:** the peel-a-digit loop generalizes B-03 from fixed width to any length — `long long` matters because the constraint admits 10-digit inputs. *Distinct idea:* the digit-peel loop.

---

### B-32 — Countdown with do-while

**Difficulty:** ★ · **Topics:** loops, do-while

Read a start number 1–20; print a countdown `n … 1` space-separated, then `LIFT-OFF`.

**Input:** one integer.
**Output:** one line countdown, then LIFT-OFF.
**Sample tests:** `3` → `3 2 1 LIFT-OFF`
**Hints:** ① do-while prints at least once even for n = 1 — check it does what you want.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    do {
        cout << n << " ";
        n--;
    } while (n >= 1);
    cout << "LIFT-OFF\n";
    return 0;
}
```

**Explanation:** do-while guarantees one body pass — chosen here because the countdown must print even for `n = 1`. Choosing *that* loop *for that reason* is the lesson. *Distinct idea:* do-when-once-is-certain.

---

### B-33 — Table of squares in a range

**Difficulty:** ★ · **Topics:** loops, for, ranges

Read lo and hi (1 ≤ lo ≤ hi ≤ 1000); print `n n²` for each n in the range, one per line.

**Input:** two integers.
**Output:** hi−lo+1 lines.
**Sample tests:** `3 5` → `3 9` / `4 16` / `5 25`
**Hints:** ① `for (int n = lo; n <= hi; n++)`.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int lo, hi;
    cin >> lo >> hi;
    for (int n = lo; n <= hi; n++) {
        cout << n << " " << n * n << "\n";
    }
    return 0;
}
```

**Explanation:** the counting `for` over an *arbitrary* range — lo is the initializer, not 1. Watch the `n*n` overflow instinct: with hi ≤ 1000, int suffices; the constraint line is the proof. *Distinct idea:* ranged counting loops.

---

### B-34 — Sum of evens in a range

**Difficulty:** ★ · **Topics:** loops, accumulators, conditions

Read lo, hi (0 ≤ lo ≤ hi ≤ 100000); print the sum of even numbers in [lo, hi].

**Input:** two integers.
**Output:** one integer (can exceed int range — use long long).
**Sample tests:** `1 10` → `30` · `4 4` → `4` · `5 5` → `0`
**Hints:** ① `if (n % 2 == 0)` inside the loop; ② accumulate in a `long long`.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int lo, hi;
    cin >> lo >> hi;
    long long sum = 0;
    for (int n = lo; n <= hi; n++) {
        if (n % 2 == 0) sum += n;
    }
    cout << sum << "\n";
    return 0;
}
```

**Explanation:** accumulator + filter — the two-pattern staple. The single-point ranges (`4 4`, `5 5`) test the *inclusive* boundary habit. *Distinct idea:* filtered accumulation.

---

### B-35 — Count vowels in a word

**Difficulty:** ★★ · **Topics:** loops, strings (intro), counting

Read one word (lowercase letters only). Count and print its vowels.

**Input:** one word, 1–100 chars, lowercase.
**Output:** one integer.
**Sample tests:** `education` → `5` · `rhythm` → `0` — *wait, rhythm has no aeiou, but y isn't a vowel here: count stays 0.*
**Hints:** ① index each char with `word[i]`; ② compare against five literals.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    string word;
    cin >> word;
    int count = 0;
    for (size_t i = 0; i < word.size(); i++) {
        char c = word[i];
        if (c=='a'||c=='e'||c=='i'||c=='o'||c=='u') count++;
    }
    cout << count << "\n";
    return 0;
}
```

**Explanation:** the string-traversal loop with per-character classification — the seed of every text-processing problem in the course. *Distinct idea:* index-based character audit.

---

### B-36 — Multiplication table (one row)

**Difficulty:** ★ · **Topics:** loops, formatted output

Read n (1–20); print the `n × k = p` line for k = 1…10, one per line.

**Input:** one integer.
**Output:** ten lines.
**Sample tests:** n = 7 → `7 x 1 = 7` … `7 x 10 = 70`
**Hints:** ① exact format: spaces around `x` and `=`.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    for (int k = 1; k <= 10; k++) {
        cout << n << " x " << k << " = " << n * k << "\n";
    }
    return 0;
}
```

**Explanation:** the canonical first table loop; Ba-15 builds the full grid from two of these. *Distinct idea:* one table row per loop pass.

---

### B-37 — Running maximum from a stream

**Difficulty:** ★★ · **Topics:** loops, sentinels, extremes

Read integers until `0`. Print the maximum of the non-zero values, or `NONE` if only `0` arrived.

**Input:** integers ending in `0`.
**Output:** `max: X` or `NONE`.
**Sample tests:** `3 9 4 0` → `max: 9` · `0` → `NONE` · `-7 -2 -9 0` → `max: -2`
**Hints:** ① don't initialize max to 0 — the all-negative test will punish you; ② use the first value.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int x, maxVal;
    bool haveAny = false;
    while (cin >> x && x != 0) {
        if (!haveAny || x > maxVal) {
            maxVal = x;
            haveAny = true;
        }
    }
    if (haveAny) cout << "max: " << maxVal << "\n";
    else         cout << "NONE\n";
    return 0;
}
```

**Explanation:** the first-value initialization — the honest pattern for extremes over signed streams. Initializing `maxVal = 0` is the classic silent bug that the `-7 -2 -9` sample exposes. *Distinct idea:* seed-from-first-value.

---

### B-38 — Largest of three, tie edition

**Difficulty:** ★★ · **Topics:** loops, conditions, tie-breaking

Read three integers (ties allowed). Print the largest; if the largest value appears more than once, print it followed by ` (TIE)`.

**Input:** three integers −100…100.
**Output:** as specified.
**Sample tests:** `5 5 2` → `5 (TIE)` · `5 2 5` → `5 (TIE)` · `1 2 3` → `3`
**Hints:** ① find the max first (three-way compare or a 3-pass trick); ② then count how many equal it.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int a, b, c;
    cin >> a >> b >> c;
    int m = a;
    if (b > m) m = b;
    if (c > m) m = c;
    int equalCount = (a == m) + (b == m) + (c == m);
    cout << m;
    if (equalCount > 1) cout << " (TIE)";
    cout << "\n";
    return 0;
}
```

**Explanation:** two phases — extract the maximum, then audit it — beat one tangled ladder. Counting via boolean-to-int addition (`(a==m)+(b==m)`) is idiomatic and worth naming. *Distinct idea:* find-then-audit separation.

---

### B-39 — Star triangle (right-angled)

**Difficulty:** ★ · **Topics:** loops, nested loops, patterns

Read n (1–15). Print a right-angled triangle: row 1 has one `*`, row n has n.

**Input:** one integer.
**Output:** n lines.
**Sample tests:** n = 4 → `*` / `**` / `***` / `****`
**Hints:** ① outer loop rows, inner loop columns; ② inner count equals the row number.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    for (int row = 1; row <= n; row++) {
        for (int col = 1; col <= row; col++) {
            cout << "*";
        }
        cout << "\n";
    }
    return 0;
}
```

**Explanation:** the inner loop bound *depends on the outer variable* — the one-line essence of all triangular patterns. Ba-11 scales this idea up. *Distinct idea:* dependent inner bounds.

---

### B-40 — Guessing-game logic (fixed secret)

**Difficulty:** ★★ · **Topics:** loops, conditions, interaction

The secret is 42. Read guesses until the user enters 42; for each wrong guess print `HIGHER` (if secret > guess) or `LOWER`; when correct print `FOUND` and stop.

**Input:** integers until 42 appears.
**Output:** one word per guess.
**Sample tests:** `10 100 42` → `HIGHER` `LOWER` `FOUND`
**Hints:** ① loop-forever `while (true)` with a `break` on success; ② compare against the fixed secret.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    const int SECRET = 42;
    int guess;
    while (true) {
        cin >> guess;
        if (guess == SECRET) { cout << "FOUND\n"; break; }
        if (guess < SECRET) cout << "HIGHER\n";
        else                cout << "LOWER\n";
    }
    return 0;
}
```

**Explanation:** `while (true)` + `break` is the honest shape for "repeat until an event" — and it's the interactive seed of Level-2's full guessing game (Ba-14) and the quiz machine (Lab). *Distinct idea:* event-driven loops.

---

**Tier check:** 40 problems · B-01–B-40 · when all your boxes tick, move to [basic.md](basic.md).
