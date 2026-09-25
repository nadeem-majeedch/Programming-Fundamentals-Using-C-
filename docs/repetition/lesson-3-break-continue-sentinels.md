---
title: "Lesson 3 — break, continue, and Sentinel Loops"
description: "The two exits and the shortcut: break, continue, sentinel-controlled loops, menu programs, and a validation-loop gallery."
---

# Lesson 3 — `break`, `continue`, and Sentinel Loops

> [← Module home](index.md) · [← Lesson 2 — for](lesson-2-for.md) · [Lesson 4 — Nested loops →](lesson-4-nested-digits-patterns.md)

## In this lesson you will learn

- `break` — leaving a loop from the middle, and when that is the *right* design
- `continue` — skipping the rest of one pass without leaving the loop
- the `continue`-in-a-`while` trap that creates infinite loops
- sentinel-controlled loops: choosing a sentinel and running the prime-read rhythm properly
- menu-driven programs — `do-while` + `switch` composed
- a validation-loop gallery you will reuse in every later unit
- tracing loops that contain `break`/`continue`

---

## 1. Two exits and a shortcut

So far every loop has had exactly one exit: the condition going false. Two more control moves exist:

- **`break`** — *leave the loop now*, from wherever you are. The program jumps to the first statement after the loop.
- **`continue`** — *abandon this pass*, jump straight to the condition check (in a `for`, to the update first — see §3).

The door metaphor: `break` is the emergency exit; `continue` is stepping over a spill and rejoining the queue.

```text
   while (cond) {                 while (cond) {
       A;                             A;
       break;     ────────► out       continue;  ────────► back to cond
       B;   (skipped)                 B;   (skipped this pass)
   }                              }
   next;  ◄──── lands here        next;
```

**Pseudocode**: `EXIT LOOP` and `NEXT PASS` (course house style: `EXITWHILE` for break, `CONTINUE` for continue).

<a name="2-break--the-emergency-exit"></a>
## 2. `break` — the emergency exit

`break` earns its place in three honest situations:

**1. A first-match search** — stop as soon as the answer is known:

```cpp
// firstBig.cpp — read 10 numbers; report the FIRST one over 100 (or say none)
#include <iostream>

int main() {
    int found = -1;                        // -1 = "no answer yet"
    for (int i = 1; i <= 10; i = i + 1) {
        int x;
        std::cin >> x;
        if (x > 100) {
            found = x;
            break;                         // answer found — later passes are waste
        }
    }
    if (found == -1) {
        std::cout << "None over 100\n";
    } else {
        std::cout << "First over 100: " << found << '\n';
    }
    return 0;
}
```

Dry run, inputs `40 95 210 88 ...`:

| i | x | x > 100? | found | action |
| - | - | -------- | ----- | ------ |
| 1 | 40 | no | -1 | continue looping |
| 2 | 95 | no | -1 | continue looping |
| 3 | 210 | yes | 210 | **break** — passes 4–10 never happen |

**2. Sentinel loops written without a prime read** — a legitimate alternative rhythm, explored in §4.

**3. Escaping a wait** — e.g. a menu's Quit inside the switch (§5).

Without `break`, both searches still work — you would add a flag (`bool done = false;`) and test it in the condition. The flag version is *single-exit*: all ways out of the loop are visible in the loop header. That is easier to reason about in complex loops, and many teams prefer it. `break` shines when the "stop now" moment happens deep inside the body, where a flag would have to be threaded through every branch. Rule of thumb: **use `break` when it makes the exit *more* visible, not less — and never more than one `break` per loop** unless you have a reason to say out loud.

<a name="3-continue--skip-this-pass"></a>
## 3. `continue` — skip this pass

`continue` says: *this pass's remaining statements are not wanted — go to the next pass*. It is a filter in loop form:

```cpp
// odds.cpp — sum of the odd numbers from 1 to n
int total = 0;
for (int k = 1; k <= n; k = k + 1) {
    if (k % 2 == 0) {
        continue;              // even → not wanted → next pass
    }
    total += k;                // only odds reach here
}
```

Same result, no `continue`, arguably clearer:

```cpp
    if (k % 2 != 0) {
        total += k;
    }
```

That comparison is the whole etiquette of `continue`: **it pays off when the "keep going" work is long and the skip condition is short** — guarding the interesting code from a nest of negative conditions. When the body is three lines, an `if` is usually cleaner.

### The trap: `continue` in a `while` with a manual update

```cpp
// BUG — infinite loop
int k = 1;
while (k <= 5) {
    if (k % 2 == 0) {
        continue;          // k never updated on even values → stuck at 2 forever
    }
    std::cout << k << '\n';
    k = k + 1;             // skipped by continue!
}
```

`continue` jumps to the *condition* — and the update sits *below* it, so even values never reach the update. In a **`for`** loop the same code is safe, because `continue` in a `for` still runs the update slot before re-checking the condition:

```cpp
for (int k = 1; k <= 5; k = k + 1) {
    if (k % 2 == 0) continue;   // safe: for's update runs anyway
    std::cout << k << '\n';
}
```

**Memory hook**: in a `for`, the update is part of the loop header's contract — `continue` honours contracts. In a `while`, the update is just a body statement — `continue` skips body statements, wherever they sit. [Debugging 10](debugging.md#d10--the-continue-that-ate-the-update) makes you fix this by hand.

<a name="4-sentinel-controlled-loops-properly"></a>
## 4. Sentinel-controlled loops, properly

Lesson 1 introduced input-controlled loops and the read → test → process → read-again rhythm. Now the full picture of **sentinels**.

A **sentinel** is a data value with a second job: "there is no more data". Choosing one is a design decision with one rule:

> **The sentinel must be a value that can never be real data.**

| Data | Bad sentinel | Why bad | Good sentinel |
| --- | --- | --- | --- |
| ages | 0 | 0 could mean "newborn" or a typo worth reporting | -1 |
| marks (0–100) | 50 | a real mark | -1 |
| temperatures | 0 | a real temperature | -999 |
| quiz answers (1–4) | 4 | a real answer | 0 or -1 |
| names (`getline`) | `"end"` | someone could be named End | empty line (or EOF) |

The classic sentinel loop, with the prime read doing its job:

```cpp
// marksSum.cpp — accumulate marks until -1
#include <iostream>

int main() {
    int total = 0;
    int count = 0;

    int m;
    std::cout << "Mark (-1 to finish): ";
    std::cin >> m;                        // prime read

    while (m != -1) {
        total += m;
        count += 1;
        std::cout << "Mark (-1 to finish): ";
        std::cin >> m;                    // read-again, LAST statement
    }

    std::cout << "Entered: " << count << ", total: " << total << '\n';
    if (count > 0) {
        std::cout << "Average: " << static_cast<double>(total) / count << '\n';
    }
    return 0;
}
```

Two details worth naming:

- **`count > 0` guard before dividing** — a sentinel loop can legitimately process *zero* values (user quits immediately). Dividing by zero would turn correct loop logic into a runtime crash. This guard is the standard companion of every sentinel average.
- The count of condition checks is one more than the count of processed values, exactly as in every loop — the final check is the sentinel's.

**The two sentinel rhythms.** The prime-read rhythm above versus the break rhythm:

```cpp
while (true) {                 // condition deliberately always true
    std::cin >> m;
    if (m == -1) break;        // sentinel check right after the read
    total += m;
    count += 1;
}
```

Same behaviour, one read instead of two — no chance of the two reads drifting apart (a real maintenance hazard in long programs: someone edits one prompt and not the other). Cost: a `while (true)` whose *real* exit lives in the body — acceptable here precisely because it is immediately visible, and this idiom is extremely common in real code. Choose one rhythm per course program and stay consistent; the labs use both and name them.

**Tracing a sentinel loop** — one extra convention: the sentinel row appears in the table with the body marked `—`:

| pass | m | m != -1? | total | count |
| ---- | -- | -------- | ----- | ----- |
| — (prime) | 60 | — | 0 | 0 |
| 1 | 60 | yes | 60 | 1 |
| 2 | 75 | yes | 135 | 2 |
| 3 | -1 | no → exit | 135 | 2 |

<a name="5-menu-driven-programs--the-stage-b-showcase"></a>
## 5. Menu-driven programs — the Stage B showcase

A menu composes three Stage-B tools: **do-while** (show at least once), **switch** (route the choice), **sentinel** (the Quit choice ends it):

```cpp
// menu.cpp
#include <iostream>

int main() {
    int choice;
    do {
        std::cout << "\n=== Circle menu ===\n"
                  << "1. Area\n2. Circumference\n0. Quit\nChoice: ";
        std::cin >> choice;

        switch (choice) {
            case 1:
                std::cout << "area = pi * r * r\n";
                break;                      // breaks the SWITCH, not the loop
            case 2:
                std::cout << "circumference = 2 * pi * r\n";
                break;
            case 0:
                std::cout << "Bye!\n";
                break;
            default:
                std::cout << "1, 2 or 0, please.\n";
        }
    } while (choice != 0);                  // sentinel: 0 means quit
    return 0;
}
```

Note the break-discipline comment: inside a `switch` *inside a loop*, `break` exits the **switch** — the innermost breakable construct. To leave the loop from inside the switch you would need... a `break` in the loop itself, which is exactly why menu Quit is usually handled by the *condition* (`choice != 0`) rather than a `break` — one exit, visible in the header.

Menus that re-prompt on a bad choice rather than printing an error and quitting are [Lab 5](labs.md#lab-5--the-stubborn-menu)'s territory.

<a name="6-validation-loop-gallery--patterns-you-will-reuse-forever"></a>
## 6. Validation-loop gallery — patterns you will reuse forever

[Decisions](../decisions/lesson-2-conditions.md) gave you one-shot validation (reject bad input once). Loops upgrade rejection into **re-prompting** — the program doesn't give up, it asks again. These four patterns cover most of what the rest of the course needs:

**A. Range re-prompt (do-while):**

```cpp
int age;
do {
    std::cout << "Age (1-120): ";
    std::cin >> age;
    if (age < 1 || age > 120) {
        std::cout << "Out of range — try again.\n";
    }
} while (age < 1 || age > 120);
```

**B. Nonzero divisor re-prompt (while + flag):**

```cpp
int d;
std::cout << "Divisor: ";
std::cin >> d;
while (d == 0) {                     // data decides → while
    std::cout << "Divisor can't be 0 — try again: ";
    std::cin >> d;
}
```

**C. Yes/no gate:**

```cpp
char again;
do {
    // ... one round of the program ...
    std::cout << "Another round? (y/n): ";
    std::cin >> again;
} while (again == 'y' || again == 'Y');
```

**D. Non-numeric input (fail/clear/ignore in a loop)** — combining [I/O Lesson 2](../cpp-io/lesson-2-cin.md#25-when-input-goes-wrong-fail-clear-ignore) with repetition:

```cpp
int n;
std::cout << "Enter a whole number: ";
std::cin >> n;
while (std::cin.fail()) {
    std::cin.clear();                             // forget the failure
    std::cin.ignore(1000, '\n');                  // empty the line
    std::cout << "That wasn't a number — try again: ";
    std::cin >> n;
}
```

Pattern D is the course's most powerful validation tool so far: it survives *anything* the user types (letters, symbols, nothing). All four patterns appear in the [labs](labs.md); D is the star of [Lab 7](labs.md#lab-7--the-robust-reader).

<a name="7-tracing-loops-with-breaks-and-skips"></a>
## 7. Tracing loops with breaks and skips

When a loop contains `break`/`continue`, the dry-run table gains an **action** column — what the pass *did* at the decision point. Full worked trace: sum numbers from input, skip negatives, stop at 0 (inputs `5, -3, 8, 0`):

| pass | x | x == 0? | x < 0? | action | total |
| ---- | - | ------- | ------ | ------ | ----- |
| 1 | 5 | no | no | add | 5 |
| 2 | -3 | no | yes | **continue** | 5 |
| 3 | 8 | no | no | add | 13 |
| 4 | 0 | **yes → break** | — | — | 13 |

Reading such a table is a skill worth 10 minutes of practice: each row must show *why* the pass did what it did. If you can fill this table for a program, you understand the program; [predictions](predictions.md#questions) 8–12 are exactly this drill.

## Practice

- [Exercises 17–24](exercises.md) (★★–★★★: sentinels, breaks, validation)
- [Predictions 8–12](predictions.md#questions)
- [Debugging 7–10](debugging.md) — sentinel and continue bugs
- [Lab 3](labs.md#lab-3--the-queue-processor) — queue processor · [Lab 4](labs.md#lab-4--the-honest-teller) — honest teller

## Key takeaways

- `break` exits the loop now (first-match searches, sentinel-after-read); `continue` skips to the next pass (filters). One `break` per loop, and only when it clarifies.
- `continue` inside a `while` with the update *below* it = infinite loop. Inside a `for`, the update still runs.
- A sentinel must be impossible as real data; prime-read and break are the two standard rhythms — pick one per program.
- Menus = do-while + switch + quit-sentinel; a `break` there breaks the switch, not the loop.
- Re-prompting validation loops (range, nonzero, yes/no, fail-clear-ignore) are reusable patterns — the course's standard input armour.

→ Next: [Lesson 4 — Nested loops, digits, and patterns](lesson-4-nested-digits-patterns.md)
