---
title: "Output Predictions — Read the Code, Write the Screen"
description: "Twelve IO prediction exercises covering chaining, endl, formatting, whitespace, getline, and the mixing trap — answers separated."
---

# Output Predictions

> [← Module home](index.md) · [Answers at the bottom — attempt first!](#answers)

Write the exact screen output **on paper** for each program before
opening anything. Where input is shown, it is what the user typed
(`⏎` marks an Enter press). The rule:
[Try It Yourself](../problem-solving/index.md#try-it-yourself-before-looking-at-the-solution).

---

<a name="p1"></a>
**P1.** *Chaining.* (cout, no spaces for free)

```cpp
#include <iostream>

int main() {
    std::cout << "Mark:" << 88 << "\n";
    std::cout << "Mark: " << 88;
    std::cout << " Nice" << "\n";
    return 0;
}
```

---

<a name="p2"></a>
**P2.** *Expression before printing.* (computed values in chains)

```cpp
#include <iostream>

int main() {
    int pens = 4, price = 12;
    std::cout << "Cost: " << pens * price << "\n";
    std::cout << "Cost: " << pens << " * " << price << "\n";
    return 0;
}
```

---

<a name="p3"></a>
**P3.** *Newline soup.* (endl, '\n', and one imposter)

```cpp
#include <iostream>

int main() {
    std::cout << "A" << std::endl;
    std::cout << "B\nC" << '\n';
    std::cout << "D" << "/n";
    std::cout << "\nE\n";
    return 0;
}
```

---

<a name="p4"></a>
**P4.** *Sticky precision.* (fixed, setprecision, then a surprise)

```cpp
#include <iostream>
#include <iomanip>

int main() {
    double price = 9.5;
    std::cout << std::fixed << std::setprecision(2) << price << "\n";
    std::cout << price * 10 << "\n";
    std::cout << std::setprecision(0) << price << "\n";
    return 0;
}
```

---

<a name="p5"></a>
**P5.** *Bools and chars.* (boolalpha, char printing)

```cpp
#include <iostream>
#include <iomanip>

int main() {
    char g = 'B';
    bool pass = (g <= 'D');
    std::cout << g << " " << pass << "\n";
    std::cout << std::boolalpha << pass << "\n";
    return 0;
}
```

---

<a name="p6"></a>
**P6.** *Two-way conversation.* (cin echo with computation)

Input: `17⏎`

```cpp
#include <iostream>

int main() {
    int n;
    std::cout << "n? " << std::endl;
    std::cin >> n;
    std::cout << "twice: " << n + n << "\n";
    return 0;
}
```

---

<a name="p7"></a>
**P7.** *Whitespace-proof extraction.* (spaces everywhere)

Input: `   12   x   3.5   ⏎` (extra spaces deliberate)

```cpp
#include <iostream>

int main() {
    int a;
    char c;
    double d;
    std::cin >> a >> c >> d;
    std::cout << a << "|" << c << "|" << d << "\n";
    return 0;
}
```

---

<a name="p8"></a>
**P8.** *The buffer is a queue.* (one Enter, three reads)

Input: `4 5⏎` — **one** Enter only.

```cpp
#include <iostream>

int main() {
    int a, b, c;
    std::cin >> a;
    std::cin >> b;
    std::cin >> c;
    std::cout << a << "," << b << "," << c << "\n";
    return 0;
}
```

---

<a name="p9"></a>
**P9.** *getline keeps spaces.* (and consumes its newline)

Input: `Gulberg III, Lahore⏎`

```cpp
#include <iostream>
#include <string>

int main() {
    std::string line;
    std::getline(std::cin, line);
    std::cout << "[" << line << "]" << " len=" << line.size() << "\n";
    return 0;
}
```

---

<a name="p10"></a>
**P10.** *Two lines, two readers.* (>> ws as armour)

Input: `42⏎Deep Learning Basics⏎`

```cpp
#include <iostream>
#include <string>

int main() {
    int pages;
    std::string title;

    std::cin >> pages;
    std::getline(std::cin >> ws, title);
    std::cout << pages << " pages of [" << title << "]\n";
    return 0;
}
```

---

<a name="p11"></a>
**P11.** *The trap, undisguised.* (bare getline after >>)

Input: `7⏎Monday⏎`

```cpp
#include <iostream>
#include <string>

int main() {
    int n;
    std::string day;

    std::cin >> n;
    std::getline(std::cin, day);
    std::cout << n << "|" << day << "|\n";
    return 0;
}
```

---

<a name="p12"></a>
**P12.** *Everything at once.* (columns + precision + the trap cured)

Input: `Ayesha⏎88.5⏎`

```cpp
#include <iostream>
#include <iomanip>
#include <string>

int main() {
    std::string name;
    double mark;

    std::getline(std::cin >> ws, name);
    std::cin >> mark;

    std::cout << std::left  << std::setw(10) << name
              << std::right << std::setw(7) << std::fixed
              << std::setprecision(1) << mark << "\n";
    return 0;
}
```

---

<a name="answers"></a>
## Answers

<details markdown="1">
<summary><strong>Reveal after every prediction is written down</strong></summary>

**P1.**

```text
Mark:88
Mark: 88 Nice
```

Line 1: no space after the colon (label had none). Lines 2–3: the second
statement ends *without* a newline, so ` Nice` glues onto the same line —
the space inside `" Nice"` is the only separator.

**P2.**

```text
Cost: 48
Cost: 4 * 12
```

First prints the *product*; second prints the *pieces* — `<<` never
multiplies, it just serialises what you hand it.

**P3.**

```text
A
B
C
D/n
E
```

`std::endl` and `'\n'` both end lines; `"/n"` is a two-character *string*
(slash + n) — the imposter prints literally. Then `"\nE\n"` ends line 4
and prints `E` on line 5.

**P4.**

```text
9.50
95.00
10
```

`fixed << setprecision(2)` is **sticky**: `price * 10` also prints with
two decimals. With `setprecision(0)`, `9.5` rounds (banker-hat optional)
to `10` — zero digits after the point.

**P5.**

```text
B 1
B true
```

A `bool` prints as `1`/`0` until `boolalpha` switches the stream to
words — the switch is sticky too. `'B' <= 'D'` is true: chars compare by
their code points.

**P6.**

```text
n?
twice: 34
```

The prompt line, then the result. `n + n` is computed first, then
printed — the user's `17` itself never appears.

**P7.**

```text
12|x|3.5
```

`>>` skips *all* leading whitespace for each item — the decorative
spaces change nothing. `d` prints as `3.5` (default formatting drops the
trailing zero).

**P8.**

```text
4,5,_
```

…where `_` never arrives — **the program is still waiting.** `a` and `b`
read `4` and `5`; the buffer is then empty, and the third `cin >> c`
*blocks*, holding the program until the user types another number (type
`9` and it finishes with `4,5,9`). The lesson: extraction from an empty
buffer does not fail and does not produce garbage — it **waits**. A
prediction of `4,5,` plus a hang was the honest answer.

**P9.**

```text
[Gulberg III, Lahore] len=19
```

`getline` keeps spaces and the comma; `Gulberg III, Lahore` is 19
characters (count them: 7 + 1 + 3 + 2 + 6 = 19 — `size()` counts every
character including spaces).

**P10.**

```text
42 pages of [Deep Learning Basics]
```

`cin >> pages` leaves `\n`; `>> ws` throws it away before `getline`
reads the real line. The cure working as designed.

**P11.**

```text
7||
```

The undisguised trap: bare `getline` after `>>` reads the leftover
newline as an empty line. `Monday` is still in the buffer, unread. Cure:
`cin.ignore(1000, '\n')` or `getline(std::cin >> ws, day)`.

**P12.**

```text
Ayesha     ···88.5
```

(…shown with `·` for the pads.) `getline >> ws` safely takes the name;
`cin >> mark` then reads `88.5` fine (a number after a line is no
problem — the problem is only `getline` *after* `>>`). `setw(10)` pads
`Ayesha` to 10 with 4 spaces on the right; `setw(7)` right-aligns
`88.5` (4 chars) with 3 pads; `fixed/setprecision(1)` keep one decimal.

</details>

---

*[← Traces](traces.md) · [Module home](index.md) · [Exercises →](exercises.md)*
