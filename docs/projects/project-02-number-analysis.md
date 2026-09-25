---
title: "Project 2 — The Number Analysis Toolkit"
description: "A batch analyzer for digits, primes, palindromes and statistics — the first loop-heavy project: sentinel and counted loops, digit processing, running extremes."
---

# Project 2 — The Number Analysis Toolkit

> [← Projects home](index.md) · [← Project 1](project-01-calculator.md) · Tier: Beginner · **Units first: 05–06** — `while`/`do-while`, sentinels, counters, `for`, nested loops

## Overview

A batch desk that takes a list of whole numbers (ending with the sentinel `0`) and reports each number's properties — digit count, digit sum, reversal, palindrome, prime — plus session statistics: how many were analyzed, the largest, the smallest, and how many were palindromes.

## Learning objectives

- drive a sentinel loop with per-item analysis
- implement digit extraction, reversal, and trial-division primality
- maintain running extremes and counters across a batch
- keep a session summary honest when the batch is empty

## Prerequisites

| Unit | What you need |
| --- | --- |
| 05 (Loops I) | sentinel-controlled `while`, trace tables |
| 06 (Loops II) | `for`, `break`, nested loops |
| Project 1 | the loop-and-branch rhythm, test-plan discipline |

## Requirements

1. Read whole numbers until `0` (the sentinel is never analyzed).
2. Per number (0–999999999): print digits, digit sum, reversal, palindrome yes/no, prime yes/no.
3. Negative numbers are refused with a message and *not* analyzed (the loop continues).
4. Session summary on sentinel: count analyzed, largest, smallest, palindrome count — or `No numbers analyzed`.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | `12321` → 5 digits, sum 9, reversal 12321, palindrome yes, prime no | T1 |
| F2 | `97` → prime yes; `1` → prime no; `0`… wait, 0 is the sentinel | T1, T3 |
| F3 | `−5` → refusal message; the session continues | T2 |
| F4 | `0` as the first input → `No numbers analyzed` | T3 |
| F5 | summary counts and extremes are correct across a batch | T4 |

## Suggested data structures

Variables only: `count`, `largest`, `smallest`, `palindromeCount`, `bool first` for first-seeding. Storage is *forbidden* by design — the batch is processed as it arrives, which is the discipline Level 3's collections will replace.

## Milestones

- **M1 — the digit engine.** One number, digit count + sum + reversal printed. *Exit: T1's first three values correct.*
- **M2 — the verdicts.** Palindrome (compare with the reversal) and prime (trial division, `i * i <= n`). *Exit: T1 fully passes.*
- **M3 — the batch.** The sentinel loop, the negative refusal, the running statistics. *Exit: T2 and T4 pass.*
- **M4 — the honest summary.** The empty-batch guard and the final block. *Exit: T3 passes; all tests green.*

## Tasks

1. M1: read one number; write the `while (work > 0)` digit loop on a sacrificial copy.
2. M2: add the palindrome comparison and the prime loop.
3. M3: wrap in `while (cin >> n && n != 0)`; add first-seeded extremes; add the negative refusal.
4. M4: the summary block with its empty guard.
5. Run the test plan; fill the actual column; log any bug you met and its fix.

## Test plan

| # | Input | Expected |
| --- | --- | --- |
| T1 | `12321, 97, 1, 0` | the per-number lines above; summary: 3 analyzed, largest 12321, smallest 1, palindromes 1 |
| T2 | `-5, 7, 0` | one refusal line; 7 analyzed; summary counts 1 |
| T3 | `0` | `No numbers analyzed` |
| T4 | `9, 9, 0` | both analyzed; largest = smallest = 9; palindromes 2 |
| T5 | `1000000, 0` | 7 digits, sum 1, reversal 1 (leading zeros vanish), palindrome no |

## Edge cases

- Single-digit numbers: palindrome by definition; prime only for 2, 3, 5, 7.
- The reversal of numbers ending in zero (T5) — leading zeros vanish; is that "wrong"? Document the behaviour as the contract.
- `999999999` — reversal fits `long long`; check your types.

## Extension ideas

1. Add an Armstrong-number check (digits³ sum to the number).
2. Print the number's digits in words.
3. Add a second session over *pairs* (gcd by Euclid — peek at the algorithms module).

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] The sentinel never appears in any statistic (+1)
- [ ] The digit loop works on a copy — the original survives for the palindrome test (+1)
- [ ] Empty batch produces the message, not zero-valued lies (+1)

## Hints

1. `long long work = n;` — the digit loop destroys its input; the palindrome needs the original.
2. Prime loop: `for (long long i = 2; i * i <= n; ++i) if (n % i == 0) { prime = false; break; }` — and seed `prime = (n > 1)`.
3. First-seeding: the first *accepted* number sets both extremes; every later one competes.

## Complete reference solution

```cpp
// analysis.cpp — Programming Fundamentals Using C++
// Project 2 · The Number Analysis Toolkit
// Build: g++ -std=c++17 -Wall -Wextra analysis.cpp -o analysis

#include <iostream>
using namespace std;

int main() {
    long long n;
    int analyzed = 0, palindromes = 0;
    long long largest = 0, smallest = 0;
    bool first = true;

    cout << "Number (0 to finish): ";
    while (cin >> n && n != 0) {
        if (n < 0) {
            cout << "Negative numbers are not analyzed\n";
        } else {
            // --- digit engine (on a copy: the palindrome needs the original) ---
            long long work = n;
            int digits = 0;
            long long sum = 0, rev = 0;
            while (work > 0) {
                long long d = work % 10;
                sum += d;
                rev = rev * 10 + d;
                ++digits;
                work /= 10;
            }

            // --- verdicts ---
            bool palindrome = (n == rev);

            bool prime = (n > 1);                    // 0 and 1 are not prime
            for (long long i = 2; i * i <= n && prime; ++i)
                if (n % i == 0) prime = false;

            cout << n << ": " << digits << " digits, digit sum " << sum
                 << ", reversal " << rev
                 << ", palindrome: " << (palindrome ? "yes" : "no")
                 << ", prime: " << (prime ? "yes" : "no") << "\n";

            // --- session statistics ---
            if (first) {
                largest = smallest = n;
                first = false;
            } else {
                if (n > largest)  largest = n;
                if (n < smallest) smallest = n;
            }
            if (palindrome) ++palindromes;
            ++analyzed;
        }
        cout << "Number (0 to finish): ";
    }

    if (analyzed == 0) {
        cout << "No numbers analyzed\n";
    } else {
        cout << "\n=== SESSION SUMMARY ===\n"
             << "Analyzed: " << analyzed << "\n"
             << "Largest: " << largest << "\n"
             << "Smallest: " << smallest << "\n"
             << "Palindromes: " << palindromes << "\n";
    }
    return 0;
}
```

## Explanation of important design decisions

- **Analysis on a copy.** The digit loop's `work /= 10` destroys its subject; the palindrome verdict compares `n` (untouched) with the accumulated `rev`. Doing the analysis on the original is the lab's classic bug — the copy makes the two uses independent by construction.
- **Prime seeded from truth, not special cases.** `prime = (n > 1)` states the mathematical fact for 0 and 1 *before* the loop; the loop then only needs to find one divisor. Compare with "check 0 and 1 inside the loop" — same result, three extra branches, more to test.
- **First-seeding over magic constants.** `first` handles "the first accepted number is both extremes" without choosing an initial value that some dataset could beat. The same pattern returns in every batch-statistic program in the course.
- **The refusal is not an analysis.** Negative input gets a message and no statistics touch — the session's numbers describe *analyzed* numbers, which is what the summary's label promises.

[← Project 1](project-01-calculator.md) · [Projects home](index.md) · Next: [Project 3 — Student Grade Analyzer](project-03-grade-analyzer.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
