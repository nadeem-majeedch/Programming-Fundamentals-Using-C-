---
title: "Mini-Project — The Text Analysis Toolkit"
description: "The capstone: a progressively-built menu program composing Labs 3, 4, 5, and 7 — validation, functions, and the report-builder discipline of Units 10–11."
---

# Mini-Project — The Text Analysis Toolkit

> [← Module home](index.md) · Unit 10–11 capstone · Built in six progressive milestones

In the [Functions module](../functions/miniproject.md) you built the **Menu-Driven Utility Toolkit** — numbers in, numbers out. This project replaces the numeric desks with a **text desk**: one program, a menu, and a growing set of analyses over a block of text the user enters once per session.

You have built every part already — Labs 3, 4, 5, and 7 are the components. The project *is* the composition.

## The product

A menu program with these options:

| # | Command | What it does |
| - | ------- | ------------ |
| 1 | Enter text | Reads lines until a blank line (replaces the working block) |
| 2 | Character profile | Counts: chars, letters, digits, spaces, punctuation, upper, lower (Lab 3) |
| 3 | Word report | Lines, words, chars, longest word + its line, avg word length (Lab 4) |
| 4 | Search | Reads a target word, lists numbered lines containing it (Lab 5's rules) |
| 5 | Sentence stats | Sentences, avg sentence length, vowels-per-word (Lab 7) |
| 6 | Replace word | Asks for old + new word (both words, `>>`), replaces whole-word matches only |
| 7 | Quit | Prints the session summary, exits |

**Session summary on quit**: how many text blocks were entered, how many searches ran, how many replacements were made.

## Data model (decide it *before* milestone 1)

The block is lines, and lines are few — store them:

```cpp
const int MAXLINES = 100;
std::string lines[MAXLINES];
int lineCount = 0;                    // the capacity + count convention (Unit 09)
```

Every command is a function taking `const std::string lines[], int lineCount` (option 6 needs a non-const array — it edits). No globals. The menu loop is `do-while` + `switch` ([repetition Lesson 3](../repetition/lesson-3-break-continue-sentinels.md) + [functions Lesson 1](../functions/lesson-1-machine.md)).

## Milestones

**M1 — Skeleton + Enter text.** Menu loop with stubs (each prints `TODO` and returns). Option 1 reads lines into the array until blank or capacity — with the capacity guard message. *Test*: enter 2 lines, run option 1 again with 1 line — the block must be **replaced** (lineCount reset), not appended.

**M2 — Character profile.** Port Lab 3's classifier into `void charProfile(const std::string lines[], int n)` — loop over lines, accumulate. Empty block → `NO DATA` message, no crash. *Test*: `Hello, World! 42` → letters 10, digits 2, spaces 3, punct 2 (the sums-add-up invariant holds per line).

**M3 — Word report.** Port Lab 4 (per-line word machines + global accumulators + longest-word champion with line number). *Test*: the two-line lab input → lines 2, words 7, chars 29, longest `quick` line 1, avg 3.6.

**M4 — Search.** Port Lab 5's reader choreography (`>>` target + ignore) and case-heuristic. Report matches with line numbers + summary. *Test*: target `at` over `The cat sat` / `dogs run` → line 1 matches, 1 total.

**M5 — Sentence stats.** Port Lab 7's composition (word machine + sentence transition counter + derived ratios). *Test*: the lab's two-line input → 8 words, 3 sentences, avg word length 4.4, vowels/word 0.88.

**M6 — Replace + session summary.** Whole-word replace: for each line, find candidate words ([C7's splitter](../strings/challenges.md#solutions-approaches--key-code) or the word machine), rebuild the line when a word matches exactly (case-sensitive — document it). Count replacements for the summary. Rebuild rule: *build-new* ([gallery S6](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery)) — never erase-while-traversing. *Test*: block `the cat sat on the mat`, replace `the` → `a` → `a cat sat on a mat`, 2 replacements (not 3 — `the` inside... there is no substring trap here since words only — that's the point of whole-word).

## Deliverables

1. **The program** — every command a function, no globals, capacity-guarded storage.
2. **A test table** — per command: input, expected output (hand-traced), actual, PASS/FAIL. Minimum 10 rows covering every command including the empty-block and capacity cases.
3. **A design note** (half a page): which lab each function came from, what had to change when a line became one-of-many (the accumulate-over-lines refactor), and one thing you'd store differently for a 10,000-line file (honest seam: [vectors and files](../syllabus.md) are Units 14+).

## Reference skeleton (start here, then grow)

```cpp
#include <iostream>
#include <string>
#include <cctype>
#include <iomanip>

const int MAXLINES = 100;

// ---- M1 -------------------------------------------------------------
void enterText(std::string lines[], int& lineCount) {
    std::cout << "Enter lines (blank line to finish):\n";
    lineCount = 0;                                   // replace, not append
    std::string line;
    while (lineCount < MAXLINES && std::getline(std::cin, line) && !line.empty())
        lines[lineCount++] = line;
    if (lineCount == MAXLINES)
        std::cout << "(capacity reached - extra lines ignored)\n";
}

// ---- M6 (stub becomes real last) ------------------------------------
void replaceWord(std::string lines[], int lineCount, int& replacements) {
    replacements = 0;
    // TODO M6
}

int main() {
    std::string lines[MAXLINES];
    int lineCount = 0;
    int sessions = 0, searches = 0, replacements = 0;
    int choice;
    do {
        std::cout << "\n1-enter 2-profile 3-words 4-search 5-sentences 6-replace 7-quit: ";
        std::cin >> choice;
        std::cin.ignore(1000, '\n');                 // every >> is followed by getline-ready state
        switch (choice) {
            case 1: enterText(lines, lineCount); sessions += 1; break;
            case 2: /* TODO M2 */ break;
            case 3: /* TODO M3 */ break;
            case 4: /* TODO M4 */ searches += 1; break;
            case 5: /* TODO M5 */ break;
            case 6: replaceWord(lines, lineCount, replacements); break;
            case 7: break;
            default: std::cout << "1-7 please.\n";
        }
    } while (choice != 7);
    std::cout << "blocks=" << sessions << " searches=" << searches
              << " replacements=" << replacements << '\n';
}
```

**Three subtleties to notice** (they're in the skeleton on purpose):

1. `std::cin.ignore(1000, '\n')` after **every** `>>` — options 4 and 6 use getline, so the menu's own `>>` is the mixing trap in waiting ([gallery S2](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery)).
2. `enterText` takes `int&` — the *count* must flow back out; pass-by-value would silently drop it ([functions Lesson 3](../functions/lesson-3-references-testing.md)).
3. `replacements` is accumulated across calls and printed once — state that lives *between* commands lives in `main` and is passed down, never globalized ([functions Lesson 2's global ban](../functions/lesson-2-scope.md#2-scope--where-variables-live)).

## Self-check before you call it done

- [ ] Every command works on an **empty block** without crashing
- [ ] Replacing text twice replaces (not appends)
- [ ] The invariant `letters + digits + punct + spaces = chars` holds in option 2's output
- [ ] Option 6 counts whole words only (`the` ≠ `they`)
- [ ] No globals; every function has its test rows in the deliverable table
- [ ] The [functions-module toolkit](../functions/miniproject.md)'s summary block and this one would pass the same review — compare and note one thing each did better
