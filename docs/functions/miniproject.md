---
title: "Mini-Project — The Menu-Driven Utility Toolkit"
description: "A progressively-built, function-team menu program: reader suite, temperature desk, number analysis, statistics session, and utility billing — the capstone of Units 07-08."
---

# Mini-Project — The Menu-Driven Utility Toolkit

> [← Module home](index.md) · Unit 07–08 capstone · Built in six progressive milestones

In the [iteration module](../repetition/miniproject.md) you built a toolkit as **one giant main** — and its own write-up asked you to name the walls: eighty lines of copy-pasted readers, no way to test one piece, no way to extend one tool without re-reading the whole file. This project rebuilds that idea *properly*: same spirit, new architecture. Every feature is a **function**; `main` narrates; every pure machine carries a test table.

## What you're building

A menu console with five tools and a session summary:

```text
==== Utility Toolkit ====
1. Temperature desk
2. Number analysis
3. Statistics session
4. Utility bill calculator
5. Quick conversions (km/miles)
0. Quit
```

- **1 Temperature desk** — C↔F↔K conversions ([Lab 1](labs.md#lab-1--the-conversion-desk) machines, with the −40 anchor test).
- **2 Number analysis** — digit count, digit sum, reversed, palindrome, prime, divisor count for any n ≤ 99999 (your [iteration Lab 10](../repetition/labs.md#lab-10--the-number-lab) block, now a function team: `digitStats`, `divisorInfo`, `printAnalysis`).
- **3 Statistics session** — running stats of numbers added until you leave the tool (count, total, average, min, max — the [Lab 2](labs.md#lab-2--the-statistics-team) champion machinery).
- **4 Utility bill** — slab-rate bill from units with validated reader and itemised receipt ([Lab 4](labs.md#lab-4--the-warehouse-dispatch) pattern; slabs: first 100 @ 6.00, next 100 @ 7.00, rest @ 8.00).
- **5 Quick conversions** — km↔miles (× 0.621371) and kg↔pounds (× 2.20462), pure machines, aligned table output.
- **0 Quit** — prints the session summary: tools used, how many numbers analyzed/statistic-ed, grand totals. **No crashes, ever**: every input passes through the reader suite.

**Global rules.** Prototypes → `main` → definitions. No mutable globals. Compute/print split. Readers standardised ([S24](exercises.md#s24--readinrange)). Every pure function has its test table *before* its code.

## The progressive milestones

Each milestone ends with a **working program**. Do not start M4 with M2 broken.

**M1 — Skeleton + reader suite.** Menu loop ([C6 skeleton](challenges.md#c6--the-menu-machine)) with stub handlers (`// TODO` bodies that print the handler's name), plus all five readers from [Lab 5](labs.md#lab-5--the-validation-suite) with their test script passing. *Done when:* every menu path runs, bad input never crashes, the [Lab 5 test script](labs.md#lab-5--the-validation-suite) passes row by row.

**M2 — Pure machines.** Write the computation core with **no menu at all**: `toCelsius`, `toFahrenheit`, `toKelvin` pair, `digitStats` (three outputs via references), `divisorInfo`, `kmToMiles`, `kgToPounds`, `slabBill`. Test each with its own table — a temporary `main` that just calls and checks (`check` from [Lesson 3 §5](lesson-3-references-testing.md#5-testing-functions--the-payoff-of-small-machines)). *Done when:* every machine's table is green in the driver.

**M3 — Wire the desk tools.** Handlers 1, 2, 5: each is read → compute → print, calling only tested machines. *Done when:* tool 1 on −40 shows −40 both ways; tool 2 on 4729 matches the [Lab 10](../repetition/labs.md#lab-10--the-number-lab) row; tool 5's table aligns with `setw`.

**M4 — Session tools.** Handler 3 (statistics session: add numbers, show stats, `done` to leave) and handler 4 (bill). Both *keep their own local session state inside the handler* — no globals; state lives in `main`'s call frame only while the handler runs, and the session summary needs it, so handlers return their counts. *Done when:* adding 7, 3, 10 then showing stats prints count 3 / total 20 / average 6.67; bill on 250 units matches the slab table's 1900.00 row (100×6 + 100×7 + 50×8).

**M5 — Session summary.** Quit summary aggregating the counters handlers returned. *Done when:* using tools 2 and 3 then quitting prints both counts; quitting cold prints zeros without crashing.

**M6 — Polish + write-up.** Consistent prompts, aligned output, named constants (`constexpr`) for rates and limits, final test pass over the whole table, then the [write-up](#write-up) below.

## Deliverable test table (minimum rows)

One per tool, plus boundaries: temp −40/0/100; analysis 0, 1, 2, 4729, 1221; stats with 0/1/3 entries (0 must print `No numbers yet.`); bill 100, 101, 200, 201, 250; conversions 1.0 and 0.0; *plus* one non-numeric and one out-of-range attempt per distinct input site (the reader suite makes these all identical — that's the point).

## Write-up (deliverable)

<a name="write-up"></a>

1. **Function inventory** — every function: name, signature, single-job sentence, table-attached (yes/no). Count the pure machines vs readers vs printers.
2. **The walls, revisited** — compare with the iteration mini-project: what the reader suite removed, what the compute/print split made testable, what *still* can't be stored (the statistics session can't re-list its numbers — name that wall precisely; [Stage D](../syllabus.md#stage-d-algorithms-and-data-units-10-12) removes it).
3. **Library grown** — which functions graduate to your [toolbox](lesson-3-references-testing.md#6-reusable-code--your-personal-library), with contract lines.
4. **Design decisions** — three, each justified (e.g. why handlers return counts; why `digitStats` uses references; why the bill slabs are constants).

## Reference solution skeleton

> **Attempt M1–M3 before reading.** This is the *shape*, not the only shape — your decomposition may differ and be correct. Bodies are the milestone work; the signatures and wiring are the architecture lesson.

```cpp
// toolkit.cpp — Menu-Driven Utility Toolkit (Units 07-08 capstone)
// Build:  g++ -std=c++17 -Wall -Wextra toolkit.cpp -o toolkit
// House rules: prototypes -> main -> definitions; no mutable globals;
// compute/print split; every pure machine carries a test table.

#include <iostream>
#include <iomanip>

// ---------- constants ----------
constexpr double KM_TO_MILES = 0.621371;
constexpr double KG_TO_POUNDS = 2.20462;
constexpr int    TABLE_WIDTH  = 10;

// ---------- prototypes: the table of contents ----------
// readers (Lab 5 suite)
int    readInt(const char* prompt);
int    readIntInRange(const char* prompt, int lo, int hi);
double readDoubleInRange(const char* prompt, double lo, double hi);
char   readChoice(const char* prompt, const char* allowed);
bool   askYesNo(const char* prompt);

// temperature machines (Lab 1)
double toCelsius(double f);
double toFahrenheit(double c);
void   tempDesk();

// number analysis machines (iteration Lab 10, re-teamed)
void   digitStats(long long n, int& count, int& sum, long long& reversed);
void   divisorInfo(long long n, int& count, long long& sum);
void   printAnalysis(long long n);
int    analysisDesk();   // returns how many numbers were analyzed

// statistics session (Lab 2 machinery)
double readScore();
void   updateChampions(double v, double& lo, double& hi, bool& first);
void   printReport(int count, double total, double lo, double hi);
int    statsSession(int& numbersAdded);

// billing (Lab 4 pattern)
double slabBill(int units);
int    billDesk();

// quick conversions
double kmToMiles(double km);
double kgToPounds(double kg);
void   conversionDesk();

void   printMenu();
int    readMenuChoice();

// ---------- main: the narrator ----------
int main() {
    int analyses = 0, statAdds = 0, bills = 0;
    int choice;
    do {
        printMenu();
        choice = readMenuChoice();
        switch (choice) {
            case 1: tempDesk();      break;
            case 2: analyses += analysisDesk(); break;
            case 3: statAdds += statsSession(statAdds); break;
            case 4: bills    += billDesk();      break;
            case 5: conversionDesk(); break;
            case 0: break;
            default: std::cout << "1-5 or 0, please.\n";
        }
    } while (choice != 0);

    std::cout << "Session: " << analyses << " analysis(es), "
              << statAdds << " number(s) in stats, "
              << bills << " bill(s). Bye!\n";
    return 0;
}

// ---------- definitions below, in any order ----------
// ... M1 readers, M2 machines, M3-M4 desks per the milestones ...
```

**Three subtleties to notice in the skeleton** (each is a milestone lesson):

- The desks that *count their own usage* (`analysisDesk`, `billDesk`) **return the count** — state flows back through returns, not globals. If a desk needs to hand back two numbers, that's a reference pair ([minMax pattern](lesson-3-references-testing.md#2-reference-parameters--the-write-back-wire)).
- `statsSession` takes `int&` *and* returns `int` in the sketch — resolve that honestly in M4: pick one channel per value and defend it in the write-up (the skeleton deliberately leaves one inconsistency for you to catch).
- `readMenuChoice` is `readIntInRange` with a fixed range — the reader suite composing with itself.

The [arrays module](../arrays/index.md) tears the statistics session's wall down: arrays let the session *remember*, and the desk functions you wrote here take collections as parameters almost unchanged — the [Marks Analyzer](../arrays/miniproject.md) is that rebuild.
