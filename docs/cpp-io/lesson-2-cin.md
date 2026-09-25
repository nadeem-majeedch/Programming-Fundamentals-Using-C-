---
title: "Lesson 2 — Input: cin and the Buffer"
description: "cin, >>, whitespace rules, multiple inputs, the input buffer, and input-validation basics with fail, clear, and ignore."
---

# Lesson 2 — Input: `cin` and the Buffer

> [← Module home](index.md) · [Lesson 1 — Output](lesson-1-cout.md) · [Lesson 3 — Lines →](lesson-3-getline.md)

## In this lesson you will learn

- what `std::cin` is and what `>>` extracts
- the whitespace rules that make `>>` skip spaces — and stop at them
- reading multiple inputs in one statement (or one line)
- the input buffer: where typed characters *wait*
- validation basics: detecting bad input with `fail()`, recovering with
  `clear()` and `ignore()` — the "borrowed patterns" for now

---

## 2.1 What `cin` is

**Explanation.** `std::cin` is the *character input* stream — the pipe from
the keyboard to your program. `>>` is the **extraction operator**: it
pulls characters out of the stream, converts them to the type of the
variable on its right, and stores them there. `cin` is `cout`'s mirror:
what `cout` prints, `cin` swallows.

**Syntax**

```cpp
std::cin >> variable;
```

**Worked example**

```cpp
#include <iostream>

int main() {
    int age;
    std::cout << "Enter your age: " << std::endl;  // flush the prompt
    std::cin >> age;
    std::cout << "In five years you will be " << age + 5 << "\n";
    return 0;
}
```

**Explaining the example.** The program pauses at `cin >> age` and waits
for the user to type a number and press Enter. `>>` reads the digits,
converts them to an `int`, stores them in `age` — and *skips any leading
whitespace* (spaces, tabs, even earlier newlines) first. The prompt is
printed with `endl` (Lesson 1's flushing guarantee) so it is on screen
before the program blocks.

A sample run (`57` typed by the user):

```text
Enter your age:
57
In five years you will be 62
```

**Practice.** [Prediction P6](predictions.md#p6) · [Exercise E13](exercises.md#e-input-basics-13-18).

---

## 2.2 The whitespace rules of `>>`

**Explanation.** This one rule explains most beginner confusion:

> `>>` **skips leading whitespace**, reads characters that belong to the
> type, and **stops at the first character that cannot belong** — leaving
> that character in the stream.

What that means per type:

| Reading into | Reads | Stops at (leaves it behind) |
| --- | --- | --- |
| `int` / `double` | digits (and sign, decimal point) | first space, letter, or `.`-after-number |
| `char` | exactly **one** character — after skipping leading whitespace | the character after it |
| `string` | a whole **word** — non-whitespace run | the space or newline after the word |

Two consequences you will meet constantly:

1. **You cannot read "Ali Khan" into one `string` with `>>`** — you get
   `Ali`, and `Khan` waits in the buffer (see [Lesson 3](lesson-3-getline.md)).
2. **A `char` read never sees a space on purpose** — `>>` skips spaces
   first, so the classic "read Y/N" pattern works even when the user
   types spaces around the letter.

**Worked example**

```cpp
#include <iostream>
#include <string>

int main() {
    std::string first;
    char initial;
    int number;

    std::cin >> first >> initial >> number;
    std::cout << first << "*" << initial << "*" << number << "\n";
    return 0;
}
```

**Explaining the example.** Given the input line `Usman  K  42` (notice
the double spaces), the output is `Usman*K*42`. Each `>>` skipped all
whitespace before its item, and the separators (spaces) were consumed as
boundaries — the `*` proves no space survived inside any variable.

**Practice.** [Trace T1](traces.md#t1) · [Prediction P7](predictions.md#p7).

---

## 2.3 Multiple inputs in one statement

**Explanation.** Chaining works for extraction too: `cin >> a >> b >> c`
fills three variables. Users may separate the values with spaces, tabs,
or Enter keys — `>>` does not care, whitespace is whitespace. Read the
values in the **order they will be typed**.

**Syntax**

```cpp
std::cin >> width >> height;
```

**Worked example**

```cpp
#include <iostream>

int main() {
    int width, height;

    std::cout << "Enter width and height: " << std::endl;
    std::cin >> width >> height;

    std::cout << "Area: " << width * height << "\n";
    return 0;
}
```

**Explaining the example.** Both of these input styles work identically:

```text
12 9
```

```text
12
9
```

`>>` extracts `12` into `width`, skips the whitespace between (whether it
is one space or a newline), then extracts `9` into `height`. The program
cannot tell the difference — which is a blessing for interaction and a
trap for line-based input ([Lesson 3](lesson-3-getline.md)).

**Practice.** [Exercise E15](exercises.md#e-input-basics-13-18) · [Lab 2](labs.md#lab-2--the-billing-counter).

---

## 2.4 The input buffer — what happens to what you typed

**Explanation.** When you type `42\n` and press Enter, those three
characters do not go straight into `age`. They land in the **input
buffer** — a waiting area owned by the stream. `cin >> age` reads `4`
and `2`, sees the newline, stops, and **leaves the `'\n'` in the buffer**.
The next `>>` will skip it — but a `getline` will not (that is the
[Lesson 3](lesson-3-getline.md) trap).

Mental model worth drawing once:

```text
keyboard → [ input buffer: 4 2 \n ] → cin >> age   (takes 42, leaves \n)
```

**Worked example** — proving the leftover exists:

```cpp
#include <iostream>

int main() {
    int a, b;
    std::cin >> a;            // user types "10 20" on ONE line
    std::cin >> b;            // reads 20 from the SAME line — no new Enter needed
    std::cout << a + b << "\n";
    return 0;
}
```

**Explaining the example.** The user pressed Enter once. After the first
`>>` the buffer still holds `" 20\n"`; the second `>>` skips the space and
finds `20` waiting. Input only *seems* to happen line by line; extraction
happens item by item from a queue of characters.

**Practice.** [Trace T3](traces.md#t3) · [Prediction P8](predictions.md#p8).

---

<a name="25-when-input-goes-wrong-fail-clear-ignore"></a>
## 2.5 When input goes wrong: `fail()`, `clear()`, `ignore()`

**Explanation.** Ask an `int` and the user types `abc`: extraction cannot
produce a number, `cin` enters a **failed state**, and `age` gets the
value `0` (since C++11) — *and every later `>>` does nothing at all* while
the failure persists. Three tools (declared here, fully earned when Unit 04
gives us `if`):

- `std::cin.fail()` — `true` if the last extraction failed
- `std::cin.clear()` — erase the failure flag so the stream works again
- `std::cin.ignore(...)` — throw away characters still sitting in the
  buffer (the garbage the user typed)

**Syntax** (the two borrowed patterns)

```cpp
std::cin.ignore(1000, '\n');   // skip up to 1000 chars, stop after a newline
std::cin.clear();              // then re-enable the stream
```

**Worked example** — a validation loop you can read without `if`... almost:

```cpp
#include <iostream>

int main() {
    int age = -1;

    while (age < 0) {                       // Unit 05's while, borrowed early
        std::cout << "Enter age (whole number): " << std::endl;
        std::cin.clear();                   // 1. re-enable the stream
        std::cin.ignore(1000, '\n');        // 2. throw away the bad line
        std::cin >> age;                    // 3. try again
        if (std::cin.fail()) {
            age = -1;                       // still not a number: force retry
        }
    }
    std::cout << "Accepted: " << age << "\n";
    return 0;
}
```

**Explaining the example.** Type `abc` → `cin` fails, `age` becomes 0 —
no wait, `fail()` was true so we force `age = -1` and loop. Type `-5` →
extraction succeeds but the `while` condition rejects it. Type `19` →
accepted. Trace it by hand:
[Trace T5](traces.md#t5) does exactly this.

**Watch out.** The order matters: `clear()` *then* `ignore()` — an
ignored stream ignores your `ignore()` too. [Debugging D6](debugging.md#d6---the-clear-that-did-nothing)
seeds exactly that reversal.

**Practice.** [Trace T5](traces.md#t5) · [Exercise E18](exercises.md#e-input-basics-13-18).

---

## 2.6 Common input mistakes (preview of the gallery)

Full gallery with fixes in [Lesson 3 §3.6](lesson-3-getline.md#36-the-common-input-mistakes-gallery) —
the top three that involve `>>` alone:

1. **Wrong variable order** — reading `>> age >> name` when the user
   types `Ali 19`. Types don't renegotiate: `age` tries to read `Ali`,
   fails, and everything after is garbage.
2. **Trusting the prompt** — prompts do not enforce anything. The user
   can always type less, more, or nonsense.
3. **Assuming one line = one input** — `cin >> a >> b` happily crosses
   line boundaries, which is what you want for numbers and *not* what
   you want for names.

---

## Check yourself (Lesson 2)

Answer in one written sentence each.

1. Input is `25 6.5 x`. After `cin >> i >> d >> c` (with `int i; double d; char c;`),
   what is in each variable — and which single rule decided all three?
2. Why can `cin >> name` never store `"Ali Khan"` into `name`, no matter
   how the user types it?
3. The user typed `abc` where an int was expected. What state is `cin`
   in, what is in the variable, and which two calls revive the stream?
4. In what order do `clear()` and `ignore()` run in the validation
   pattern, and what does each one do?

---

*[← Lesson 1 — Output](lesson-1-cout.md) · [Module home](index.md) · [Lesson 3 — Lines →](lesson-3-getline.md)*
