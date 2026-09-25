---
title: "Traces — Hand-Run Input/Output Programs"
description: "Five trace exercises: run IO programs on paper, recording variables and the input buffer as you go."
---

# Traces — Hand-Run IO Programs

> [← Module home](index.md) · [Answers at the bottom — attempt first!](#answers)

The rule, as always:
[Try It Yourself before looking](../problem-solving/index.md#try-it-yourself-before-looking-at-the-solution).
For each program: **write your trace table before reading anything below
the code.** For input programs, add a **Buffer** column — what is left
waiting after each extraction step. That column is where the module's
bugs live.

---

<a name="t1"></a>
## T1 — Three readers, one line ★

```cpp
#include <iostream>
#include <string>

int main() {
    int id;
    std::string name;
    char grade;

    std::cin >> id >> name >> grade;
    std::cout << grade << name << id << "\n";
    return 0;
}
```

Input (single line):

```text
7 Ayesha A
```

**Your task.** Trace each extraction: what does `>>` consume, what does
it leave, what lands in the variable? Then write the output line.
Extra credit: state what the Buffer column contains after the last `>>`.

---

<a name="t2"></a>
## T2 — The formatted receipt ★★

```cpp
#include <iostream>
#include <iomanip>

int main() {
    std::cout << std::left << std::setw(10) << "Item"
              << std::right << std::setw(8) << "Qty" << "\n";
    std::cout << std::left << std::setw(10) << "Chai"
              << std::right << std::setw(8) << 3 << "\n";
    std::cout << std::left << std::setw(10) << "Samosa"
              << std::right << std::setw(8) << 12 << "\n";
    return 0;
}
```

**Your task.** No input here — trace each output statement and draw the
exact characters, using `·` for every padding space `setw` inserts
(`Chai·····`, etc.). Count: how many pad characters per row?

---

<a name="t3"></a>
## T3 — One Enter, two reads ★★

```cpp
#include <iostream>

int main() {
    int a, b;
    std::cin >> a;
    std::cin >> b;
    std::cout << a * b << "\n";
    return 0;
}
```

Input (typed exactly like this, **one** Enter):

```text
6 7
```

**Your task.** Trace the buffer after each `>>`. How many Enters did the
user press, and how many did the program *need*? What would change if
the user typed `6` and `7` on separate lines?

---

<a name="t4"></a>
## T4 — The mixing trap, line by line ★★★

```cpp
#include <iostream>
#include <string>

int main() {
    int age;
    std::string name;

    std::cin >> age;
    std::getline(std::cin, name);
    std::cout << "[" << age << "][" << name << "]\n";
    return 0;
}
```

Input (user types `19`, Enter, then `Ali Raza`, Enter):

```text
19
Ali Raza
```

**Your task.** Build the full table: step, action, buffer before, buffer
after, variable state. Explain in one sentence why the output is
`[19][]` and where `Ali Raza` is at the moment the program prints.

---

<a name="t5"></a>
## T5 — The validation loop ★★★

```cpp
#include <iostream>

int main() {
    int age = -1;

    while (age < 0) {
        std::cin.clear();
        std::cin.ignore(1000, '\n');
        std::cin >> age;
        if (std::cin.fail()) {
            age = -1;
        }
    }
    std::cout << "Accepted: " << age << "\n";
    return 0;
}
```

Input the user actually types, in order (each on its own line):

```text
abc
-5
21
```

**Your task.** For each of the three attempts: what does `>>` do, what
state is the stream in, what does `fail()` report, what is `age` after
the `if`? Which attempt finally breaks the `while` loop, and why did
`-5` — a perfectly good integer — not break it?

---

<a name="answers"></a>
## Answers

<details markdown="1">
<summary><strong>Reveal after your own tables are written</strong></summary>

### T1

| step | action | buffer before | buffer after | variable |
| --- | --- | --- | --- | --- |
| 1 | `cin >> id` | `7 Ayesha A\n` | ` Ayesha A\n` | `id = 7` |
| 2 | `cin >> name` (skips space) | ` Ayesha A\n` | ` A\n` | `name = "Ayesha"` |
| 3 | `cin >> grade` (skips space) | ` A\n` | `\n` | `grade = 'A'` |

Output: `AAyesha7` (grade, then name, then id — the `cout` order, not the
input order). Buffer still holds `\n`.

### T2

```text
Item      ·····Qty
Chai····· ·······3
Samosa··· ······12
```

`"Chai"` is 4 chars in width 10 → 6 pad dots; `"Samosa"` is 6 → 4 pads;
header same. Right column: `3` is 1 char in width 8 → 7 pads; `12` → 6
pads. Total pads per data row: 10.

### T3

After `cin >> a`: buffer holds ` 7\n` — the `6` is consumed, the space
and `7` wait. After `cin >> b`: buffer holds `\n` — `7` came off the
**same line**; the user pressed one Enter, the program needed zero
additional Enters. Separate lines change nothing in the result — `>>`
treats `\n` as ordinary whitespace.

### T4

| step | action | buffer before | buffer after | variable |
| --- | --- | --- | --- | --- |
| 1 | `cin >> age` | `19\nAli Raza\n` | `\nAli Raza\n` | `age = 19` |
| 2 | `getline(cin, name)` | `\nAli Raza\n` | `Ali Raza\n` | `name = ""` |
| 3 | print | — | — | `[19][]` |

`getline` reads "up to the first newline" — and step 1 left one at the
front of the buffer, so it read the empty line and consumed it. `Ali
Raza` is still sitting un-consumed in the buffer when the program prints;
it would be read by a *second* `getline`. Cure: `cin.ignore(1000, '\n')`
between steps 1 and 2, or `getline(std::cin >> ws, name)`.

### T5

| attempt | `cin >> age` | stream state | `fail()` | `age` after `if` |
| --- | --- | --- | --- | --- |
| `abc` | extraction fails, `age = 0` | failed | true | forced back to `-1` |
| `-5` | succeeds, `age = -5` | good | false | stays `-5` |
| `21` | succeeds, `age = 21` | good | false | `21` |

Loop: `while (age < 0)` is true after attempts 1 *and* 2 — a valid
integer is not the same as a *sensible* one; `-5` passes extraction but
fails the range condition. Attempt 3 gives `age = 21`, the condition is
false, the loop exits, output `Accepted: 21`.

</details>

---

*[← Module home](index.md) · [Output predictions →](predictions.md)*
