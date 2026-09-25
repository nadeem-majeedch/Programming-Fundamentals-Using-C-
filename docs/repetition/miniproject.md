---
title: "Mini-Project — The Number Analysis Toolkit"
description: "A loop-based menu program combining every Stage-B idiom: a self-study mini-project with staged milestones, test plans, and a separated reference solution."
---

# Mini-Project — The Number Analysis Toolkit

> [← Module home](index.md) · Unit 05–06 capstone · Everything from this module, one program

You've built ten labs' worth of parts. This project asks you to **design a program out of them** — a menu-driven statistics and number-theory toolkit that runs until the user quits. No new syntax is introduced: if you need something you haven't met ([functions](../syllabus.md#stage-c-structure-units-7-9), arrays, strings-as-collections), you either copy-paste working blocks (as [Lab 5](labs.md#lab-5--the-stubborn-menu) did) or descope honestly.

## What you're building

A console program that maintains, in memory, the statistics of a *session* of numbers entered one at a time, plus a set of single-number analysis tools. Menu:

```text
==== Number Analysis Toolkit ====
1. Add a number to the session
2. Session statistics (count, total, average, min, max)
3. Times table of any n
4. Analyze a number (digits, palindrome, prime)
5. Pattern printing (triangle, pyramid)
6. Collatz journey of a number
0. Quit
```

## Behaviour spec

- **1 Add** — robustly read a number (−1000..1000; validation gallery A+D) and fold it into the running statistics. Multiple adds; statistics stay current.
- **2 Stats** — print count, total, average (2 dp), min, max — *without re-asking for the numbers*. Nothing added yet → print `No numbers yet.` and return to the menu.
- **3 Table** — read n (1–12), print the n-times table 1..10, `setw`-aligned like [E31](exercises.md#s31--multiplication-grid).
- **4 Analyze** — read a positive n ≤ 99999; print digit count, digit sum, reversed value, palindrome verdict, prime verdict, divisor count (the [Lab 10](labs.md#lab-10--the-number-lab) block, reused).
- **5 Patterns** — read h (2–9), print the left triangle and the pyramid of [C13](challenges.md#c13--pyramid).
- **6 Collatz** — read n ≥ 1; print the [C4](challenges.md#c4--the-collatz-journey) journey and step count.
- **0 Quit** — print the session summary (numbers added, their average, menu picks made) and exit.

**Global rules.** Non-numeric input anywhere re-prompts; out-of-range re-prompts with a message. The program never crashes and never gives up.

## Why this project is the right capstone

| Menu option | Stage-B skills composed |
| --- | --- |
| Menu itself | do-while + switch + sentinel quit ([Lesson 3 §5](lesson-3-break-continue-sentinels.md)) |
| Add | validation loops ([gallery](lesson-3-break-continue-sentinels.md#6-validation-loop-gallery--patterns-you-will-reuse-forever)) + streaming accumulator (no re-reads!) |
| Stats | accumulator, counter, both champions ([Lesson 2 §2](lesson-2-for.md#2-the-classic-idioms--learn-once-reuse-forever)) |
| Table / Patterns | nested loops ([Lesson 4](lesson-4-nested-digits-patterns.md)) |
| Analyze | digit peeling, prime test, divisor count |
| Collatz | input-controlled loop with derived counter |

**The honest limitation to articulate in your write-up:** "Add many numbers, then list them" is *impossible* here — the toolkit keeps only running statistics, never the numbers themselves. You will feel this wall; naming it precisely is the [arrays module](../arrays/index.md)'s motivation. Similarly, every "robust reader" block you copy-paste is Stage C's [functions](../functions/index.md) begging to exist — and the [Utility Toolkit mini-project](../functions/miniproject.md) is your chance to rebuild this program the structured way.

## Milestones

Build in this order; each milestone is a working program.

- **M1 — Skeleton.** Do-while menu that prints the chosen option's name and loops until 0. Unknown option → message. Test: every option key, unknown keys, quit.
- **M2 — Session.** Options 1 and 2 with all four idioms. Test: add 3, check stats; add again, check stats update; stats-before-any-add; quit prints summary.
- **M3 — Robust reading.** Validation blocks everywhere inputs appear (copy from Lab 5/Lab 7). Test: feed every menu input `abc`, `99999`, `-5` in sequence — nothing crashes, nothing accepts.
- **M4 — Analysis and patterns.** Options 3–6. Test each against the module's worked values: table of 7; analyze 4729 (prime, 22, 9274); triangle h=4; Collatz 6 → 9 steps; Collatz 1 (zero steps — does your loop handle it?).
- **M5 — Polish.** Session summary at quit; consistent prompts; `<iomanip>` alignment; named constants for limits.

## Your test plan (deliverable)

Write the test table *before* M4. Minimum rows: one per option, one boundary per range (n=1, n=12, n=13 for table; h=2, h=9, h=10 for patterns), one non-numeric per input site, stats with 0/1/3 numbers, Collatz 1 and 6, analyze 1 (prime guard), 2 (prime), 1221 (palindrome, 8 divisors), quit summary with 0 adds and with 3 adds. A project isn't done when it *works* — it's done when the table is green.

## Write-up (deliverable)

Alongside the code, half a page each:

1. **Design decisions** — loop choice per construct, justified with the §6 procedure.
2. **The walls** — what you couldn't do without functions/arrays (list the copy-pasted blocks; count the duplication).
3. **Idiom inventory** — which of the unit's patterns appear, and where.
4. **What you'd add next** — two features and which missing tool each needs.

<a name="reference-solution"></a>
# Reference solution

> **Attempt M1–M3 before reading.** This is one sound shape — your structure may differ and be equally correct. It follows the milestones exactly.

```cpp
// natoolkit.cpp — Number Analysis Toolkit (mini-project, Units 05-06)
// Build:  g++ -std=c++17 -Wall -Wextra natoolkit.cpp -o natoolkit
// LAR scope: iostream/iomanip only, no functions, no arrays — the
// copy-pasted reader blocks and the inability to list added numbers
// are DELIBERATE (see the write-up questions).

#include <iostream>
#include <iomanip>

constexpr int ADD_MIN = -1000, ADD_MAX = 1000;
constexpr int TABLE_MAX = 12;
constexpr int ANALYZE_MAX = 99999;
constexpr int HEIGHT_MIN = 2, HEIGHT_MAX = 9;

int main() {
    // session state (M2)
    int   count = 0;
    double total = 0;
    bool  haveFirst = false;      // champion seeding across the whole session
    double minV = 0, maxV = 0;
    int   picks = 0;

    int choice;
    do {
        std::cout << "\n==== Number Analysis Toolkit ====\n"
                  << "1. Add a number to the session\n"
                  << "2. Session statistics\n"
                  << "3. Times table of any n\n"
                  << "4. Analyze a number\n"
                  << "5. Pattern printing\n"
                  << "6. Collatz journey\n"
                  << "0. Quit\nChoice: ";
        std::cin >> choice;
        if (std::cin.fail()) {                 // menu is numeric too (M3)
            std::cin.clear();
            std::cin.ignore(1000, '\n');
            std::cout << "Enter the number of an option.\n";
            continue;                          // back to the menu
        }

        switch (choice) {
        case 1: {
            double x;
            bool ok = false;
            do {                               // gallery D + A composed
                std::cout << "Number (-1000..1000): ";
                std::cin >> x;
                if (std::cin.fail()) {
                    std::cin.clear();
                    std::cin.ignore(1000, '\n');
                    std::cout << "Numbers only, please.\n";
                } else if (x < ADD_MIN || x > ADD_MAX) {
                    std::cout << "Between -1000 and 1000, please.\n";
                } else {
                    ok = true;
                }
            } while (!ok);
            count += 1;
            total += x;
            if (!haveFirst || x < minV) minV = x;   // first value seeds champions
            if (!haveFirst || x > maxV) maxV = x;
            haveFirst = true;
            std::cout << "Added. " << count << " number(s) in session.\n";
            break;
        }
        case 2:
            if (count == 0) {
                std::cout << "No numbers yet.\n";
            } else {
                std::cout << std::fixed << std::setprecision(2)
                          << "Count: " << count
                          << "  total: " << total
                          << "  average: " << total / count << '\n'
                          << "Min: " << minV << "  Max: " << maxV << '\n';
            }
            break;
        case 3: {
            int n = 0;                          // inline reader: range 1..TABLE_MAX
            bool ok = false;
            do {
                std::cout << "n (1-" << TABLE_MAX << "): ";
                std::cin >> n;
                if (std::cin.fail()) {
                    std::cin.clear(); std::cin.ignore(1000, '\n');
                    std::cout << "Numbers only, please.\n";
                } else if (n < 1 || n > TABLE_MAX) {
                    std::cout << "Between 1 and " << TABLE_MAX << ", please.\n";
                } else {
                    ok = true;
                }
            } while (!ok);
            std::cout << "---- " << n << " times table ----\n";
            for (int i = 1; i <= 10; i = i + 1) {
                std::cout << std::setw(3) << i << " x " << std::setw(3) << n
                          << " = " << std::setw(5) << i * n << '\n';
            }
            break;
        }
        case 4: {
            long long n = 0;                   // long long: headroom for rev/dsum
            bool ok = false;
            do {                               // inline reader: 1..ANALYZE_MAX
                std::cout << "n (1-" << ANALYZE_MAX << "): ";
                std::cin >> n;
                if (std::cin.fail()) {
                    std::cin.clear(); std::cin.ignore(1000, '\n');
                    std::cout << "Numbers only, please.\n";
                } else if (n < 1 || n > ANALYZE_MAX) {
                    std::cout << "Between 1 and " << ANALYZE_MAX << ", please.\n";
                } else {
                    ok = true;
                }
            } while (!ok);
            long long orig = n;                // peeling consumes n
            int digits = 0;
            long long dsum = 0, rev = 0;
            while (n > 0) {
                dsum += n % 10;
                rev = rev * 10 + n % 10;
                digits += 1;
                n /= 10;
            }
            long long divisors = 0, dsumAll = 0;
            for (long long d = 1; d <= orig; d = d + 1) {
                if (orig % d == 0) { divisors += 1; dsumAll += d; }
            }
            std::cout << "Digits: " << digits << "  digit sum: " << dsum
                      << "  reversed: " << rev
                      << "  palindrome: " << (rev == orig ? "yes" : "no") << '\n'
                      << "Prime: " << (orig > 1 && divisors == 2 ? "yes" : "no")
                      << "  divisors: " << divisors
                      << "  divisor sum: " << dsumAll << '\n';
            break;
        }
        case 5: {
            int h = 0;                         // inline reader: HEIGHT_MIN..MAX
            bool ok = false;
            do {
                std::cout << "Height (" << HEIGHT_MIN << "-" << HEIGHT_MAX << "): ";
                std::cin >> h;
                if (std::cin.fail()) {
                    std::cin.clear(); std::cin.ignore(1000, '\n');
                    std::cout << "Numbers only, please.\n";
                } else if (h < HEIGHT_MIN || h > HEIGHT_MAX) {
                    std::cout << "Between " << HEIGHT_MIN << " and " << HEIGHT_MAX << ", please.\n";
                } else {
                    ok = true;
                }
            } while (!ok);
            for (int r = 1; r <= h; r = r + 1) {          // left triangle
                for (int c = 1; c <= r; c = c + 1) std::cout << "* ";
                std::cout << '\n';
            }
            std::cout << '\n';
            for (int r = 1; r <= h; r = r + 1) {          // pyramid
                for (int s = 1; s <= h - r; s = s + 1) std::cout << ' ';
                for (int c = 1; c <= 2 * r - 1; c = c + 1) std::cout << "*";
                std::cout << '\n';
            }
            break;
        }
        case 6: {
            int n = 0;                         // inline reader: n >= 1
            bool ok = false;
            do {
                std::cout << "n (>= 1): ";
                std::cin >> n;
                if (std::cin.fail()) {
                    std::cin.clear(); std::cin.ignore(1000, '\n');
                    std::cout << "Numbers only, please.\n";
                } else if (n < 1) {
                    std::cout << "1 or more, please.\n";
                } else {
                    ok = true;
                }
            } while (!ok);
            int steps = 0;
            std::cout << "Journey: " << n;
            while (n != 1) {
                if (n % 2 == 0) n = n / 2; else n = 3 * n + 1;
                steps += 1;
                std::cout << " -> " << n;
            }
            std::cout << "\nSteps: " << steps << '\n';
            break;
        }
        case 0:
            break;
        default:
            std::cout << "Unknown option.\n";
        }
        if (choice >= 1 && choice <= 6) picks += 1;
    } while (choice != 0);

    std::cout << "\nSession summary: " << count << " number(s)";
    if (count > 0)
        std::cout << ", average " << std::fixed << std::setprecision(2) << total / count;
    std::cout << ", " << picks << " menu pick(s). Bye!\n";
    return 0;
}
```

**The reader blocks (M3/M4).** The reference deliberately shows the honest cost of working without functions: each `case` carries its own validated reader, and four of them are near-identical — prompt, read, fail-check, range-check, repeat. That duplication *is* the lesson: when [functions](../syllabus.md#stage-c-structure-units-7-9) arrive, all four collapse into one `readInRange(prompt, min, max)` and about eighty lines evaporate. Count the duplication in your write-up.

Two subtleties worth noticing in the reference:

- `case 6` with n = 1: the `while (n != 1)` loop runs **zero** times and prints `Steps: 0` — the empty-loop-is-the-answer case, exactly like `0!`.
- The quit summary guards `count > 0` before dividing — [S17](exercises.md#s17--sentinel-prime-read)'s guard, one unit later, still saving programs.
