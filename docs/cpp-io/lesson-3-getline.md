---
title: "Lesson 3 — Lines: getline and the Mixing Trap"
description: "getline(), why >> stops at spaces, the leftover newline, cin >> ws and cin.ignore, and the common input mistakes gallery."
---

# Lesson 3 — Lines: `getline` and the Mixing Trap

> [← Module home](index.md) · [Lesson 2 — Input](lesson-2-cin.md) · [Practice →](traces.md)

## In this lesson you will learn

- why `>>` can never read a whole line with spaces
- `getline()` — the line reader — and what it does with the newline
- the single most famous beginner bug: **mixing `cin >>` and `getline`**
- the two-line cure: `cin.ignore(...)` after `>>`, or `cin >> ws` before
  `getline`
- a gallery of common input mistakes and their fixes

---

## 3.1 `getline()` — reading a whole line

**Explanation.** `std::getline(cin, s)` is *not* a member of `cin` — it is
a free function that takes the stream and a `string`. Its contract:
**read everything up to the next newline, store it (spaces included), and
consume the newline too.** Nothing is left behind. That last part makes it
the *polite* reader.

**Syntax**

```cpp
std::string line;
std::getline(std::cin, line);
```

**Worked example**

```cpp
#include <iostream>
#include <string>

int main() {
    std::string fullName;

    std::cout << "Full name: " << std::endl;
    std::getline(std::cin, fullName);

    std::cout << "Welcome, " << fullName << "!\n";
    return 0;
}
```

**Explaining the example.** The user types `Ali Raza Khan` and presses
Enter. `getline` stores **all thirteen characters** — spaces included —
in `fullName`, then eats the newline. Output: `Welcome, Ali Raza Khan!`.
Compare with `cin >> fullName` from Lesson 2, which would have stored
`Ali` and left ` Raza Khan\n` poisoning the buffer.

**Practice.** [Exercise E19](exercises.md#e-lines-19-24) · [Prediction P9](predictions.md#p9).

---

## 3.2 The mixing trap — the bug you must meet once, safely

**Explanation.** Now put the two readers side by side. `cin >> n` stops
at the newline **and leaves it in the buffer**. The very next `getline`
reads "everything up to the newline" — and finds one waiting immediately.
It stores an **empty string** and consumes it. Your name question appears,
the user types a beautiful full name… and it vanishes into the void
because `getline` already read the *empty line after the number*.

Sequence to burn into memory:

```text
input buffer after "cin >> n" with user typing "19\n":   [ \n ]
getline called next:  reads "" (empty!), consumes \n,    name = ""
user's actual typing waits for the NEXT getline.
```

**Worked example** — the bug, live:

```cpp
#include <iostream>
#include <string>

int main() {
    int age;
    std::string name;

    std::cout << "Age: " << std::endl;
    std::cin >> age;                 // leaves '\n' behind
    std::cout << "Name: " << std::endl;
    std::getline(std::cin, name);    // eats the leftover '\n' -> name is ""

    std::cout << age << " / [" << name << "]\n";
    return 0;
}
```

**Explaining the example.** Run it: type `19`, press Enter, then type
`Ali` at the Name prompt. Output: `19 / []` — the name is empty, and
`Ali` is still un-consumed in the buffer. The program didn't "skip" your
question; `getline` answered it with the leftover empty line. Trace this
line by line in [Trace T4](traces.md#t4).

**Practice.** [Trace T4](traces.md#t4) · [Debugging D4](debugging.md#d4---the-vanishing-name).

---

<a name="33-the-cure--cinignore-after"></a>
## 3.3 The cure — `cin.ignore` after `>>`

**Explanation.** After the last `>>` and before the first `getline`,
throw the leftover newline away:

```cpp
std::cin >> age;
std::cin.ignore(1000, '\n');   // discard up to 1000 chars, stop AFTER '\n'
std::getline(std::cin, name);  // now it reads the user's real line
```

`ignore(n, stopChar)` reads and discards characters until either `n`
characters are gone or it has consumed a `'\n'` — which means the whole
rest of that line (whatever junk it held) is gone. 1000 is a safe "long
enough" number; you will meet the exact typed-constant idiom in Unit 02's
arithmetic work.

**Worked example** — the fixed program:

```cpp
#include <iostream>
#include <string>

int main() {
    int age;
    std::string name;

    std::cout << "Age: " << std::endl;
    std::cin >> age;
    std::cin.ignore(1000, '\n');     // the cure
    std::cout << "Name: " << std::endl;
    std::getline(std::cin, name);

    std::cout << age << " / [" << name << "]\n";
    return 0;
}
```

**Explaining the example.** Same input as before, but now the buffer is
clean when `getline` runs: output is `19 / [Ali]`. If the user had typed
`19 almost-twenty` on the age line, `ignore` would discard
` almost-twenty\n` too — often exactly what you want.

**Practice.** [Exercise E20](exercises.md#e-lines-19-24) · [Lab 1](labs.md#lab-1--the-student-information-system).

---

## 3.4 The other cure — `cin >> ws` before `getline`

**Explanation.** When *several `getline`s run in a row* (or your design
reads lines after a menu `char`), the alternative cure skips whitespace
**at the moment of the read**:

```cpp
std::getline(std::cin >> ws, name);
```

`std::ws` is a manipulator for input streams: "discard leading whitespace,
then let `getline` read the rest of the line." The difference that matters:

- `ignore(1000, '\n')` — throws away the **whole remainder of the line**;
- `cin >> ws` — throws away only **spaces/tabs/newlines at the front**,
  keeps everything after.

If the user may have typed something valuable before the newline, `>> ws`
preserves it; if the remainder is junk, `ignore` is the broom. Both work;
pick deliberately and say *why* in a comment.

**Worked example** — back-to-back lines:

```cpp
#include <iostream>
#include <string>

int main() {
    std::string street, city;

    std::cout << "Street: " << std::endl;
    std::getline(std::cin >> ws, street);
    std::cout << "City: " << std::endl;
    std::getline(std::cin >> ws, city);

    std::cout << "[" << street << "] of [" << city << "]\n";
    return 0;
}
```

**Explaining the example.** Because `getline` consumes its own newline,
plain `getline` twice would already work — `>> ws` adds armour for the
case where a previous `>>` (say, a house-number `int`) left stray
whitespace. Type `12 Gulberg III` / `Lahore` →
`[12 Gulberg III] of [Lahore]`… with the house number read first as an
`int`, this is exactly the Lab 1 scenario.

**Practice.** [Exercise E21](exercises.md#e-lines-19-24) · [Prediction P10](predictions.md#p10).

---

<a name="35-whitespace-end-to-end"></a>
## 3.5 Whitespace, end to end

**Explanation.** Collect the rules in one place — this table *is* the
module's exam:

| Reader | Skips leading whitespace? | Stops at | Consumes the stopper? |
| --- | --- | --- | --- |
| `cin >>` (int/double) | yes | first non-number char | **no** — leaves it |
| `cin >>` (char) | yes | after 1 non-ws char | **no** — leaves what follows |
| `cin >>` (string) | yes | first whitespace | **no** — leaves it |
| `getline` | **no** | first `'\n'` | **yes** — eats it |
| `getline(cin >> ws, s)` | yes | first `'\n'` | **yes** — eats it |
| `cin.ignore(n, '\n')` | n/a | after `n` chars or `'\n'` | **yes** — eats it |

**Worked example** — one input, three readers:

```cpp
#include <iostream>
#include <string>

int main() {
    int n;
    std::string word, line;

    std::cin >> n >> word;                  // "23 donut\n" -> n=23, word="donut"
    std::getline(std::cin >> ws, line);     // ws skips '\n', line gets next line
    std::cout << n << " " << word << " [" << line << "]\n";
    return 0;
}
```

**Explaining the example.** Input `23 donut` / `order extra sugar`:
`>>` fills `n` and `word`, leaving `\n`; `>> ws` discards it; `getline`
stores `order extra sugar`. Remove `ws` and `line` would be empty — the
trap, disguised.

**Practice.** [Trace T1](traces.md#t1) again, now predicting the *buffer* column too.

---

<a name="36-the-common-input-mistakes-gallery"></a>
## 3.6 The common-input-mistakes gallery

Each: symptom → cause → fix.

| # | Mistake | Symptom | Cause | Fix |
| --- | --- | --- | --- | --- |
| 1 | `cin >> fullName` for "Ali Khan" | only `Ali` stored; later reads poisoned | `>>` stops at whitespace | `getline` for anything with spaces |
| 2 | `>>` then bare `getline` | name question "skipped", empty string | leftover `'\n'` fed to `getline` | `cin.ignore(1000,'\n')` or `cin >> ws` |
| 3 | wrong `>>` order for the typed order | second read fails or garbage | extraction is positional, types don't renegotiate | match the prompt order exactly |
| 4 | `char` read for a word | only first letter stored | `char` = exactly one character | `string` unless truly one letter |
| 5 | no prompt flush (rare consoles) | prompt invisible until later | output not delivered | prompt with `endl` |
| 6 | `cin >>` in a loop after bad input | infinite "Enter age:" spam | failed state ignores all `>>` | `clear()` **then** `ignore()`, then retry |
| 7 | `clear()` after `ignore()` | `ignore` does nothing, junk survives | ignored stream ignores commands | always `clear()` **first** |
| 8 | reading numbers with `getline` | you get the text `"17"`, not 17 | `getline` produces a `string` | `>>` for numbers, `getline` for lines (conversion comes in Unit 11) |
| 9 | assuming one Enter = one input | second value "self-reads" | buffer holds the rest of the line | this is normal; design for it |
| 10 | trailing `getline` after menu `char` | last input empty | same leftover-newline family | `>> ws` or `ignore` before the final read |

**Practice.** [Debugging D1–D10](debugging.md) covers ten of these as live
bug hunts · [Challenges](challenges.md) C6 and C8 make you *explain* two
of them back.

---

## Check yourself (Lesson 3)

Answer in one written sentence each.

1. Why does `getline` never leave a newline in the buffer while `>>`
   almost always does?
2. Your program asks for an age, then a full name; the name always comes
   out empty. Which characters are being read by the `getline`, and what
   are the two possible cures?
3. When would you prefer `cin >> ws` over `cin.ignore(1000, '\n')` —
   what does each preserve or destroy?
4. From the gallery, which mistake produces an *infinite prompt loop*,
   and which two calls in which order fix it?

---

*[← Lesson 2 — Input](lesson-2-cin.md) · [Module home](index.md) · [Practice: traces →](traces.md)*
