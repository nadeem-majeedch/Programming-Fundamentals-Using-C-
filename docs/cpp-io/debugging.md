---
title: "Debugging Hunts — Seeded IO Bugs"
description: "Ten IO programs that compile but misbehave (or mis-type): find the bug, fix it, and only then read the fix list."
---

# Debugging Hunts

> [← Module home](index.md) · [Fix list at the bottom — your fix first!](#fix-list)

Ten programs. Each compiles (unless it doesn't — that's a clue) but
misbehaves. For every one: **write the symptom, name the bug, fix it** —
*before* opening the fix list. Hints escalate: ① what to notice ② where
to look ③ the fix. The rule:
[Try It Yourself](../problem-solving/index.md#try-it-yourself-before-looking-at-the-solution).

---

<a name="d1---the-wrong-slash"></a>
**D1 — The wrong slash.** *Compiles. Output looks wrong.*

```cpp
#include <iostream>

int main() {
    std::cout << "Attendance report" << "/n";
    std::cout << "Week 1: perfect" << "/n";
    return 0;
}
```

Student report: *"My newlines print as letters."*

---

<a name="d2---the-glued-prompt"></a>
**D2 — The glued prompt.** *Compiles. Screen looks cramped.*

```cpp
#include <iostream>
#include <string>

int main() {
    std::string name;
    int age;

    std::cout << "Name: ";
    std::cin >> name;
    std::cout << "Age: ";
    std::cin >> age;
    std::cout << name << " is " << age << "\n";
    return 0;
}
```

Student report: *"Age: appears at the end of the line where I typed the
name, not on its own line."*

---

<a name="d3---the-word-eater"></a>
**D3 — The word eater.** *Compiles. Loses data.*

```cpp
#include <iostream>
#include <string>

int main() {
    std::string fullName;
    int rollNo;

    std::cout << "Roll no: " << std::endl;
    std::cin >> rollNo;
    std::cout << "Full name: " << std::endl;
    std::cin >> fullName;
    std::cout << rollNo << ": " << fullName << "\n";
    return 0;
}
```

Student report: *"I typed 41 and Ali Raza Khan — the program printed
`41: Ali` and forgot the rest."*

---

<a name="d4---the-vanishing-name"></a>
**D4 — The vanishing name.** *Compiles. Asks the second question and
ignores the answer.*

```cpp
#include <iostream>
#include <string>

int main() {
    int age;
    std::string name;

    std::cout << "Age: " << std::endl;
    std::cin >> age;
    std::cout << "Name: " << std::endl;
    std::getline(std::cin, name);

    std::cout << "[" << age << "][" << name << "]\n";
    return 0;
}
```

Student report: *"It never lets me type the name — output is
`[19][]`."*

---

<a name="d5---the-wrong-order"></a>
**D5 — The wrong order.** *Compiles. Second read explodes.*

```cpp
#include <iostream>
#include <string>

int main() {
    int marks;
    std::string subject;

    std::cout << "Enter subject and marks: " << std::endl;
    std::cin >> marks >> subject;
    std::cout << subject << " = " << marks << "\n";
    return 0;
}
```

Student report: *"I typed `Maths 88` and it printed nothing sensible —
something like ` = 0` and the stream seemed dead."*

---

<a name="d6---the-clear-that-did-nothing"></a>
**D6 — The clear that did nothing.** *Compiles. Infinite prompt loop on
bad input.*

```cpp
#include <iostream>

int main() {
    int age = -1;

    while (age < 0) {
        std::cout << "Age: " << std::endl;
        std::cin.ignore(1000, '\n');
        std::cin.clear();
        std::cin >> age;
        if (std::cin.fail()) {
            age = -1;
        }
    }
    std::cout << "Accepted " << age << "\n";
    return 0;
}
```

Student report: *"When I type letters it spams `Age:` forever. Numbers
work."*

---

<a name="d7---the-price-that-lost-its-decimals"></a>
**D7 — The price that lost its decimals.** *Compiles. Money wrong.*

```cpp
#include <iostream>

int main() {
    int qty;
    double unitPrice, total;

    std::cout << "Qty and unit price: " << std::endl;
    std::cin >> qty >> unitPrice;
    total = qty * unitPrice;
    std::cout << "Total: " << total << "\n";
    return 0;
}
```

Student report: *"For 3 and 7.5 it prints `Total: 22.5` — where did my
`.00` go? The receipt looks fake."*

---

<a name="d8---the-column-that-refuses-to-line-up"></a>
**D8 — The column that refuses to line up.** *Compiles. Table wobbles.*

```cpp
#include <iostream>
#include <iomanip>

int main() {
    std::cout << std::setw(10) << "Item" << std::setw(6) << "Qty\n";
    std::cout << std::setw(10) << "Chai" << 3 << "\n";
    std::cout << std::setw(10) << "Samosa" << 12 << "\n";
    return 0;
}
```

Student report: *"The header lines up but the numbers sit right after
the names — `Chai3`, `Samosa12` — the qty column vanished."*

---

<a name="d9---the-two-enters"></a>
**D9 — The two Enters.** *Compiles. Second getline reads empty when the
user types both fields on one line.*

```cpp
#include <iostream>
#include <string>

int main() {
    std::string item;
    int qty;

    std::cout << "Item and qty on one line (e.g. 'Chai 2'): " << std::endl;
    std::getline(std::cin, item);
    std::cin >> qty;

    std::cout << qty << " x " << item << "\n";
    return 0;
}
```

Student report: *"Typing `Chai 2` on one line prints nothing useful;
typing them on two lines works. I thought getline was broken."*

---

<a name="d10---the-menu-that-ate-a-letter"></a>
**D10 — The menu that ate a letter.** *Compiles. First menu choice works,
second is skipped.*

```cpp
#include <iostream>
#include <string>

int main() {
    char choice;
    std::string note;

    std::cout << "Choice (a/b): " << std::endl;
    std::cin >> choice;                     // user types: a⏎
    std::cout << "Leave a note: " << std::endl;
    std::getline(std::cin >> ws, note);
    std::cout << "Choice2 (y/n): " << std::endl;
    std::cin >> choice;                     // user types: y⏎
    std::cout << "[" << choice << "][" << note << "]\n";
    return 0;
}
```

Student report: *"The note line gets skipped entirely when I answer the
menus quickly — `[y][]`."*  (The seeded bug is the *first* cure applied
in the wrong place — trace which newline is left where.)

---

<a name="fix-list"></a>
## Fix list (after your own fixes)

<details markdown="1">
<summary><strong>Reveal after each bug is found and fixed on paper</strong></summary>

**D1.** `"/n"` is a two-character *string*; the newline character is
`'\n'` (backslash). Fix both lines. Detection habit: when output "prints
as letters", read the literal character by character.

**D2.** Prompts `cout << "Name: ";` never end their line, so the next
prompt continues on the same line as the typed text. Fix: end each
prompt with `'\n'` (or print the prompt, then read on the same line —
deliberately — and say so). Either is fine; *deciding* is the lesson.

**D3.** `cin >> fullName` reads one *word*: `Ali`. ` Raza Khan\n` waits
in the buffer. Fix: read the name with `getline` (after the mandatory
cure — `ignore` or `>> ws`) whenever spaces are legal. Symptom pattern:
"only the first word survived" → `>>` on a multi-word field.

**D4.** The mixing trap verbatim: `cin >> age` leaves `'\n'`; bare
`getline` reads it as an empty line. Fix: `std::cin.ignore(1000, '\n');`
after `cin >> age`, or `getline(std::cin >> ws, name)`.

**D5.** Extraction is positional: `marks` (int) is asked to read `Maths`
→ fails → stream dead → everything after is skipped; `marks` holds `0`.
Fix: match the read order to the prompt order (`subject` then `marks`),
and — better — validate with `fail()/clear()/ignore()` so nonsense input
recovers instead of dying.

**D6.** `clear()` and `ignore()` are reversed. In a failed state, `>>`
does nothing — but so does `ignore()` (an ignored stream ignores
commands). Fix: `clear()` **first**, `ignore(1000, '\n')` second, then
retry. Order is not cosmetic; it is the whole fix.

**D7.** Nothing is wrong with the math — `22.5` is the true product —
the *format* is default. Fix:
`std::cout << std::fixed << std::setprecision(2);` before printing money
(once, sticky). Lesson: money without `fixed/setprecision(2)` is a
formatting bug even when the arithmetic is perfect.

**D8.** `setw` applies to the **next item only**. Header: two `setw`s,
both applied. Rows: `setw(10)` padded the name, but the qty had no
`setw` of its own. Fix: `<< std::setw(6) << qty` on both rows. The
"vanished column" is always a forgotten one-shot `setw`.

**D9.** The user followed the prompt; the program lied. `getline`
consumed `Chai 2\n` wholesale into `item`, then `cin >> qty` found an
**empty buffer** and blocked for a second line. Fix: change the prompt
to promise two lines (item line, then qty line) *or* parse the one-line
form (read a word with `>>`, then the qty — Lab 5 uses this). Prompt and
read-style must make the same promise.

**D10.** After the first `cin >> choice`, the buffer holds `\n`. The
`getline(cin >> ws, note)` *would* have handled it — but the user
answered both menus before the note in this transcript; the seeded bug:
the second `cin >> choice` runs **before** the note `getline`, and the
`y` Enter's newline waits behind… nothing, so the *next* read (the
printed note in a later iteration) would be the one poisoned. Fix for
this program: reorder to ask the note before the second menu choice, and
keep `>> ws` on the `getline` — plus the general law: every `>>`
followed by a `getline` needs its cure, *wherever* they touch.

</details>

---

*[← Exercises](exercises.md) · [Module home](index.md) · [Challenges →](challenges.md)*
