---
title: "Mini-Project — The Quiz Runner"
description: "The capstone: a dynamically-sized records app built on references, out-parameters, and one visible ownership contract — the Unit 13 deliverable."
---

# Mini-Project — The Quiz Runner

> [← Module home](index.md) · Unit 13 capstone · Built in six progressive milestones

Every toolkit so far held **numbers** (the [Utility Toolkit](../functions/miniproject.md)) and **text** (the [Text Analysis Toolkit](../strings/miniproject.md)). This one holds **records** — quiz attempts with a name, a score, and a timestamp-ish counter — and it holds them in a **dynamic array that grows by doubling**, with every pointer decision made on purpose.

The point is not the quiz app. The point is that by M6 you can point at any line of your own program and answer: **who owns this box, where is the arrow, and when is it released?**

## The product

A menu program with these options:

| # | Command | What it does |
| - | ------- | ------------ |
| 1 | Add attempt | Reads a name (`getline`) + score (0–100, validated); grows the roster by doubling when full |
| 2 | List attempts | Numbered table: `Sr. | Name | Score` ([setw](../cpp-io/lesson-1-cout.md) alignment) |
| 3 | Best attempt | Prints the highest score + holder — via a function returning the **address** of the record's score (or nullptr) |
| 4 | Curve scores | Adds +5 to every score ≤ 95 — **in place**, through the block, using a pointer walk |
| 5 | Stats | Average (1 dp) + count above 50 — computed by a function taking `const` pointers |
| 6 | Erase all | Releases the block: `delete[]`, same-line nullptr, and prints the pairs audit |
| 7 | Quit | Auto-erases if still live (the safety net), prints the session summary, exits |

**Session summary on quit**: attempts added, growths performed, allocations vs releases (the pairs audit — must read `balanced: yes`).

## Data model — decide it before M1

The roster is a heap block of records. At this stage (pre-struct; the [Records module](../records/index.md) brings the real fix) keep them in **three parallel arrays** — one block per field — or, simpler and pointer-purer, store just **scores** and treat names as the extension. The required core:

```cpp
int*   scores   = nullptr;   // heap block — the roster's scores
int    count    = 0;         // logical size
int    capacity = 0;         // allocated slots (0 = nothing allocated yet)
int    news     = 0, dels = 0;   // the pairs audit
```

Every function below takes pointers/references per the [Lesson 2 §3 decision rule](lesson-2-references-functions.md#the-decision) — **no globals**, and *nothing* is passed by value if the callee must change it.

## Milestones

**M1 — Skeleton + the ownership contract.** Menu loop with stubs. At the top of the file, write the contract in comments: *"`scores` is owned by `main`. Functions receive it as a parameter; only the grow/erase functions may re-aim or release it, and they do so through a reference-to-pointer."* If you can't write the contract, you're not ready to write the code.

**M2 — Add (fixed capacity 4).** Allocate the first block lazily (capacity 0 → allocate 4 on first add). Fill via an out-parameter function `readAttempt(int& scoreOut)` (validated 0–100). Full capacity → print `roster full (M4 will grow)` and reject.

**M3 — List + best.** List: indexed loop, `setw` table. Best: `const int* bestScore(const int* s, int n)` returning the address of the champion (nullptr on empty — [Ex S12's pattern](exercises.md#s12)); main prints `*result` after the guard. *(Notice: the "best *holder*" name needs the records version — the extension.)*

**M4 — The grow.** Doubling growth behind a function with signature `void grow(int*& data, int& capacity, int& news, int& dels)` — the `int*&` is the [reference-to-pointer from Challenge C4](challenges.md#c4): the function re-aims *main's* arrow. Phases inside, in the [Lab 3 order](labs.md#lab-3--the-resize-desk): allocate → copy → delete → re-point, incrementing the audit.

**M5 — Curve + stats.** Curve: `void curve(int* s, int n)` walking with a pointer, `+5` where `*p <= 95`. Stats: `double average(const int* s, int n)` (cast rule) and `int aboveFifty(const int* s, int n)` — both const-pointer users, both guarded for empty.

**M6 — Erase + safety net + audit.** Erase: release, same-line nullptr, print the audit. Quit: if `scores != nullptr`, erase first (the *safety net* — an owner that cleans up even if the user forgets). Then the summary. The program must be able to add → grow → curve → quit, and the audit must still say balanced.

## Deliverables

1. **The program** — no globals, contract in comments, pairs audit printed on quit.
2. **A test table** — per command: input, expected output (hand-traced), actual, PASS/FAIL. Minimum 12 rows, including: add to empty, add 5 (one growth), best on empty, curve at the 95/96 boundary, erase then re-add (the re-allocate path!), quit with live data.
3. **An ownership map** — one diagram per milestone showing: stack boxes, heap blocks, arrows, owner labels. Six small diagrams beat one giant one.
4. **A design note** (half a page): where references were chosen vs pointers and why ([the §3 rule](lesson-2-references-functions.md#the-decision)), what the `int*&` grow signature does that a plain `int*` couldn't, and which [module safety rule](index.md) each function's guards enforce.

## Reference skeleton (start here, then grow)

```cpp
#include <iostream>
#include <iomanip>
#include <string>

// ---- the ownership contract -------------------------------------------
// scores: owned by main. grow() re-aims it (via int*&), erase() releases it.
// All other functions are USERS: const pointers, no re-aiming, no deleting.

bool readAttempt(int& scoreOut) {              // reference out-param (always exists)
    std::cout << "score (0-100): ";
    std::string line;
    std::getline(std::cin, line);
    bool ok = true;
    for (int i = 0; i < line.length() && ok; i = i + 1)
        if (line[i] < '0' || line[i] > '9') ok = false;    // digits only (Unit 11 allDigits)
    if (!ok || line.empty()) { std::cout << "rejected\n"; return false; }
    scoreOut = std::stoi(line);
    if (scoreOut > 100) { std::cout << "rejected\n"; return false; }
    return true;
}

const int* bestScore(const int* s, int n) {    // const user; nullptr on empty
    if (s == nullptr || n <= 0) return nullptr;
    const int* best = s;
    for (int i = 1; i < n; i = i + 1)
        if (s[i] > *best) best = &s[i];
    return best;
}

void eraseRoster(int*& data, int& cap, int& dels) {   // the ONLY releaser
    if (data != nullptr) {
        delete[] data;
        data = nullptr;
        cap = 0;
        dels += 1;
    }
}

int main() {
    int* scores = nullptr;
    int count = 0, capacity = 0;
    int news = 0, dels = 0;
    int added = 0, growths = 0;
    int choice;
    do {
        std::cout << "\n1-add 2-list 3-best 4-curve 5-stats 6-erase 7-quit: ";
        std::cin >> choice;
        std::cin.ignore(1000, '\n');
        switch (choice) {
            case 1:
                if (count == capacity)
                    std::cout << "roster full (grow arrives in M4)\n";
                else {
                    int s;
                    if (readAttempt(s)) { /* scores[count] = s; count++; added++; */ }
                }
                break;
            case 3: {
                const int* b = bestScore(scores, count);
                if (b != nullptr) std::cout << "best: " << *b << '\n';
                else              std::cout << "no attempts yet\n";
                break;
            }
            case 6: eraseRoster(scores, capacity, dels); break;
            case 7:
                if (scores != nullptr) {          // the safety net
                    std::cout << "(auto-erase on quit)\n";
                    eraseRoster(scores, capacity, dels);
                }
                break;
            default: std::cout << "1-7 please.\n";
        }
    } while (choice != 7);
    std::cout << "added=" << added << " growths=" << growths
              << " | news=" << news << " deletes=" << dels
              << (news == dels ? " balanced: yes" : " balanced: NO") << '\n';
}
```

**Three subtleties to notice** (they're in the skeleton on purpose):

1. **`bestScore` returns an address, not a copy** — so `main` can print through it, and M4's curve could later modify through it *if* the const were dropped. Same box, borrowed views.
2. **`eraseRoster` takes `int*&`** — it must null *main's* pointer, not a copy of it. A plain `int*` parameter would leave main's arrow dangling while the audit lied. This is the whole unit in one signature.
3. **The safety net duplicates `eraseRoster`'s guard, not its call** — quitting with live data must still balance the pairs. Owners clean up *even when the user doesn't*; that habit is precisely what Unit 15's destructors ([OOP module](../oop/index.md)) will automate.

## Self-check before you call it done

- [ ] The pairs audit prints `balanced: yes` on **every** path — including quit-with-live-data and erase-then-re-add
- [ ] No function except `grow`/`eraseRoster` re-aims or releases; the contract comment matches the code
- [ ] `bestScore` and both stats functions survive empty rosters (nullptr / 0 / guard)
- [ ] Every pointer parameter that *could* be null is guarded; every reference parameter genuinely always exists
- [ ] The ownership map shows exactly one owner per block at every milestone
- [ ] Compare with the [Text Analysis Toolkit's](../strings/miniproject.md) self-check — one sentence on why this one *needed* pointers where that one didn't
