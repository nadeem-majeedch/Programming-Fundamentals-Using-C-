---
title: "Output Predictions (10)"
description: "Read each program, write the exact output on paper, then compile and compare."
---

# C++ Foundations — Output Predictions

> 10 programs · write the output **on paper first** — the prediction is the
> exercise · [answers](#answers) at the bottom · [← Module home](index.md)

The rules: predict *every line including blank ones*, then compile, run,
compare. A wrong prediction is a discovery — write it in your bug diary
with the reason. All programs compile with the course command.

---

<a name="p1"></a>
**P1.** *Structure.* (Concepts: main, statements, comments)

```cpp
#include <iostream>

int main() {
    std::cout << "A" << "B";
    std::cout << "C\n";
    std::cout << "D\n";
    // std::cout << "E\n";
    return 0;
}
```

**P2.** *Statements & braces.* What happens — and *does it compile*?

```cpp
#include <iostream>

int main() {
    std::cout << "one\n"
    std::cout << "two\n";
    return 0;
}
```

<a name="p3"></a>
**P3.** *Variables.* (declaration, assignment)

```cpp
#include <iostream>

int main() {
    int x = 5;
    int y = x;
    x = 10;
    std::cout << x << " " << y << "\n";
    return 0;
}
```

<a name="p4"></a>
**P4.** *Doubles vs ints.* (floating-point, integer division)

```cpp
#include <iostream>

int main() {
    std::cout << 9 / 2 << "\n";
    std::cout << 9 / 2.0 << "\n";
    double d = 9 / 2;
    std::cout << d << "\n";
    return 0;
}
```

<a name="p5"></a>
**P5.** *Integers.* (overflow)

```cpp
#include <iostream>

int main() {
    int a = 2000000000;
    std::cout << a + a << "\n";
    return 0;
}
```
*(If your machine prints something other than what you predicted, write
the actual number down — undefined means exactly that: not guaranteed,
varies by platform. The *concept* — not 4 billion — is the answer.)*

**P6.** *Mixed arithmetic.* (implicit conversion)

```cpp
#include <iostream>

int main() {
    double r1 = 7 / 2;
    double r2 = 7 / 2.0;
    double r3 = (7 + 1) / 2;
    std::cout << r1 << " " << r2 << " " << r3 << "\n";
    return 0;
}
```

<a name="p7"></a>
**P7.** *Characters.*

```cpp
#include <iostream>

int main() {
    char c = 'a';           // code 97 on nearly every platform
    std::cout << c << "\n";
    std::cout << c + 2 << "\n";
    std::cout << static_cast<char>(c + 2) << "\n";
    return 0;
}
```

<a name="p8"></a>
**P8.** *Booleans.*

```cpp
#include <iostream>

int main() {
    bool t = true;
    bool f = false;
    std::cout << t << "\n";
    std::cout << f << "\n";
    std::cout << (t && f) << "\n";
    std::cout << (t || f) << "\n";
    std::cout << (!t) << "\n";
    return 0;
}
```

<a name="p9"></a>
**P9.** *Strings.*

```cpp
#include <iostream>
#include <string>

int main() {
    std::string a = "data";
    std::string b = "base";
    std::string c = a + b;
    std::cout << c << "\n";
    std::cout << c.length() << "\n";
    return 0;
}
```

<a name="p10"></a>
**P10.** *Literals.* (the trap gallery)

```cpp
#include <iostream>

int main() {
    std::cout << '9' + 1 << "\n";
    std::cout << "9" << 1 << "\n";
    std::cout << "9" "1" << "\n";
    std::cout << 9 + 1 << "\n";
    return 0;
}
```

---

<a name="p11"></a>
**P11.** *Integer division and remainder.* (arithmetic operators)

```cpp
#include <iostream>

int main() {
    int totalMinutes = 135;
    int hours = totalMinutes / 60;
    int minutes = totalMinutes % 60;
    std::cout << hours << " h " << minutes << " min\n";
    std::cout << 7 / 2 << " and " << 7 % 2 << "\n";
    std::cout << -7 / 2 << " and " << -7 % 2 << "\n";
    return 0;
}
```

---

<a name="p12"></a>
**P12.** *Mixed arithmetic.* (implicit conversion on both sides)

```cpp
#include <iostream>

int main() {
    int boxes = 3;
    double weight = 2.5;
    std::cout << boxes * weight << "\n";
    std::cout << weight / boxes << "\n";
    std::cout << boxes / boxes * weight << "\n";
    return 0;
}
```

---

<a name="p13"></a>
**P13.** *Logical operators with numbers.* (a classic trap)

```cpp
#include <iostream>

int main() {
    int age = 20;
    std::cout << (age == 20) << "\n";
    std::cout << (age > 12 && age < 65) << "\n";
    std::cout << (12 < age < 65) << "\n";
    return 0;
}
```

---

<a name="p14"></a>
**P14.** *Increment in a larger expression.* (pre vs post)

```cpp
#include <iostream>

int main() {
    int a = 5;
    int b = a++ + 10;
    int c = ++a * 2;
    std::cout << a << " " << b << " " << c << "\n";
    return 0;
}
```

---

<a name="p15"></a>
**P15.** *The precedence gauntlet.* Rewrite each expression with explicit
parentheses on paper **first**, then check by running. Each line is 0 or 1.

```cpp
#include <iostream>

int main() {
    int x = 3;
    std::cout << (x + 2 * 4 == 11) << "\n";
    std::cout << (x % 2 == 1 && x > 0) << "\n";
    std::cout << (!(x > 5) == true) << "\n";
    std::cout << (x * 3 % 7 >= 2) << "\n";
    return 0;
}
```

---

<a id="answers"></a>

## Answers

<details markdown="1">
<summary><strong>Reveal after every prediction is written down</strong></summary>

**P1.**

```text
ABC
D
```

No E — the line is commented out. First statement has no `\n`, so `C`
continues the line.

**P2.** It does **not** compile: `error: expected ';' before 'std::cout'`
(the first statement lacks its semicolon; the error is *reported* on the
*next* line — Lesson 1's read-upward rule).

**P3.**

```text
10 5
```

`y` copied x's *value* (5) at initialization; later changes to `x` don't
flow backwards into `y` — assignment copies, it never links.

**P4.**

```text
4
4.5
4
```

Line 3 is the trap: `9 / 2` divides in *ints* (→ 4), and only then converts
to double for storage (→ 4.0, printed as 4). Cast before, not after.

**P5.** Not 4 billion — the sum overflows `int` (undefined behaviour; on
typical two's-complement platforms it wraps to `-294967296`). The lesson:
products/sums of big ints need `long long`.

**P6.**

```text
3 3.5 4
```

`7/2` → int 3 (stored as 3.0); `7/2.0` → 3.5; `(7+1)/2` → all-int → 4.
Only r2 ever saw a double *during* its arithmetic.

**P7.**

```text
a
99
c
```

`'a'` is 97; `+2` promotes to int (99); `static_cast<char>` puts the
costume back (→ 'c').

**P8.**

```text
1
0
0
1
0
```

AND false, OR true, NOT flips. Booleans print as 1/0.

**P9.**

```text
database
8
```

Concatenation then length 8.

**P10.**

```text
58
91
91
10
```

`'9'` is char (57) + 1 → 58 · `"9" << 1` prints string `9` then the
*number* 1 → `91` · adjacent string literals `"9" "1"` concatenate → `91`
· `9 + 1` is int arithmetic → 10. Four lines, four completely different
mechanisms, two identical outputs.

**P11.**

```text
2 h 15 min
3 and 1
-3 and -1
```

`135 / 60` is 2 in ints, `135 % 60` is 15 — divide-and-remainder splits a
quantity into units. With negatives, `/` truncates toward zero (`-7 / 2 → -3`)
and `%` takes the sign of the left operand (`-7 % 2 → -1`).

**P12.**

```text
7.5
0.833333
2.5
```

`boxes * weight` converts `boxes` to double first → 7.5. `weight / boxes` →
0.833333. Line 3 is left-to-right: `boxes / boxes` is `1 / 1 = 1` **in ints**,
then `1 * weight` → 2.5. Same numbers as line 1's factors, different order,
different arithmetic kind.

**P13.**

```text
1
1
1
```

Line 3 prints 1 — but for the wrong reason. `12 < age < 65` groups as
`(12 < age) < 65`, i.e. `1 < 65` → 1 (true). It *looks* like the maths
notation "between 12 and 65" but checks nothing about 65. The correct form is
line 2's `(age > 12 && age < 65)`. Lesson: chained relations are a trap even
when they accidentally print the right answer.

**P14.**

```text
7 15 14
```

`b = a++ + 10` uses a = 5 first → b = 15, then a becomes 6. `c = ++a * 2`
bumps a to 7 first → 7 * 2 = 14. Final: a=7, b=15, c=14.

**P15.**

```text
1
1
1
1
```

With parentheses made explicit: `((x + (2*4)) == 11)` → 11 == 11 → 1 ·
`(((x % 2) == 1) && (x > 0))` → 1 · `((!(x > 5)) == true)` → `!0` → 1 == 1 →
1 · `(((x*3) % 7) >= 2)` → 9 % 7 = 2 → 1. Four different precedence rules,
one right answer each time — which is why writing the parentheses first is
the habit worth building.

</details>

---

*[← Module home](index.md) · [Debugging](debugging.md) ·
[Challenges](challenges.md)*
