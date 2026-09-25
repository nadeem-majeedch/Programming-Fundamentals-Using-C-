---
title: "Level 3 — Intermediate Labs (L3-17 to L3-24)"
description: "Eight intermediate lab scenarios on functions, decomposition, vectors and arrays, collection statistics, matrices and simulation — every lab with all fifteen parts."
---

# Level 3 — Intermediate

> [← Labs home](index.md) · [← Level 2](level-2.md) · **Units first: 07–09** — functions, decomposition, arrays and `vector` are assumed. Level 2's loops are assumed everywhere.

---

## L3-17 — The Marks Analyzer

### Scenario
A class tutor needs a marks report: read the class's marks, then answer the tutor's standard questions — average, highest, lowest, pass count, and the grade histogram.

### Problem statement
Read `n` (1–100) then `n` marks (0–100). Using functions for every statistic, print: average (2 decimals), highest and lowest, pass count (≥ 50), the number in each letter band (A ≥ 80, B ≥ 70, C ≥ 60, D ≥ 50, F below), and the list of failing positions.

### Learning objectives
- decompose a report into single-job functions over a `vector`
- pass collections by `const&` and mutate them through `&`
- compute several independent statistics over one stored dataset

### Requirements
1. Every statistic is a function taking `const vector<int>&` (or the vector plus what it needs); `main` is a sequence of calls.
2. Marks outside 0–100 are re-prompted for that position.
3. Failing positions print 1-based: `Failing: 3, 7` — or `Failing: none`.
4. The grade histogram prints five labelled counts.

### Input
`n`, then n ints.

### Output
Eight labelled lines (average, highest, lowest, passes, A–F counts, failing positions).

### Constraints
- The vector is read once; every statistic re-reads it by parameter.
- No global variables — everything travels by parameter.

### Example
Input: n=6, marks `82 45 91 67 50 38` → average 62.17, highest 91, lowest 38, passes 4, A:2 B:0 C:1 D:1 F:2, Failing: 2, 6.

### Test cases
| Input | Expected |
| --- | --- |
| 6: 82 45 91 67 50 38 | the example output |
| 1: 50 | average 50.00, passes 1, D:1, Failing: none |
| 3: 100 0 100 | highest 100, lowest 0, A:2 F:1, Failing: 2 |
| 0 | Invalid count |
| 2: −3 then 55, 55 | re-prompt keeps position 1; passes 2, D:2 |

### Student tasks
1. Write `readMarks(vector<int>& marks, int n)` with the re-prompt loop.
2. Write `averageOf`, `highestOf`, `lowestOf` over `const vector<int>&`.
3. Write `countPasses` and `printHistogram`.
4. Write `printFailingPositions`; assemble `main` as a call sequence.

### Hints
1. `averageOf` returns `double` and divides by `marks.size()` — mind the empty case (the read guarantees n ≥ 1).
2. The histogram is five counters — or a `map<char,int>` if you've met the STL module early; the course answer here is counters.
3. Failing positions need the *index*, not just the value — the range-for hides it; use an index loop or carry both.

### Extension challenges
1. Add the median (sort a copy, take the middle — or average the two middles).
2. Add the standard deviation using the two-pass formula.

### Complete solution

```cpp
// L3-17 — The Marks Analyzer
// Compile: g++ -std=c++17 -Wall -Wextra L3-17.cpp -o L3-17
#include <iostream>
#include <iomanip>
#include <vector>
using namespace std;

void readMarks(vector<int>& marks, int n) {
    for (int i = 0; i < n; ++i) {
        int m;
        cout << "Mark " << (i + 1) << ": ";
        cin >> m;
        while (m < 0 || m > 100) {
            cout << "Marks are 0-100. Again: ";
            cin >> m;
        }
        marks.push_back(m);
    }
}

double averageOf(const vector<int>& marks) {
    long long total = 0;
    for (int m : marks) total += m;
    return static_cast<double>(total) / marks.size();
}

int highestOf(const vector<int>& marks) {
    int best = marks[0];
    for (int m : marks) if (m > best) best = m;
    return best;
}

int lowestOf(const vector<int>& marks) {
    int worst = marks[0];
    for (int m : marks) if (m < worst) worst = m;
    return worst;
}

int countPasses(const vector<int>& marks) {
    int passes = 0;
    for (int m : marks) if (m >= 50) ++passes;
    return passes;
}

void printHistogram(const vector<int>& marks) {
    int a = 0, b = 0, c = 0, d = 0, f = 0;
    for (int m : marks) {
        if (m >= 80)      ++a;
        else if (m >= 70) ++b;
        else if (m >= 60) ++c;
        else if (m >= 50) ++d;
        else              ++f;
    }
    cout << "A: " << a << "  B: " << b << "  C: " << c << "  D: " << d << "  F: " << f << "\n";
}

void printFailingPositions(const vector<int>& marks) {
    bool any = false;
    for (size_t i = 0; i < marks.size(); ++i) {
        if (marks[i] < 50) {
            if (!any) { cout << "Failing: "; any = true; }
            else cout << ", ";
            cout << (i + 1);
        }
    }
    if (!any) cout << "Failing: none";
    cout << "\n";
}

int main() {
    int n;
    cout << "Number of students: ";
    cin >> n;
    if (n < 1 || n > 100) { cout << "Invalid count\n"; return 1; }

    vector<int> marks;
    readMarks(marks, n);

    cout << fixed << setprecision(2);
    cout << "Average: " << averageOf(marks) << "\n";
    cout << "Highest: " << highestOf(marks) << "\n";
    cout << "Lowest: "  << lowestOf(marks)  << "\n";
    cout << "Passes: "  << countPasses(marks) << "\n";
    printHistogram(marks);
    printFailingPositions(marks);
    return 0;
}
```

### Solution explanation
The lab's thesis is decomposition: `main` reads as the report's table of contents — every statistic is one named call, each function has one job and a `const&` parameter, and the shared dataset is read once into a vector that everything else views. The long-long accumulator in `averageOf` is the overflow-proof seed habit. `printFailingPositions` shows the separator pattern (comma before every element except the first) and the empty-result contract (`Failing: none`) — presentation logic that would clutter `main` if left inline.

### Testing checklist
- [ ] All five test cases pass
- [ ] `main` contains no statistics arithmetic — only calls
- [ ] The re-prompted mark keeps its position
- [ ] Changing the pass mark to 60 touches exactly one function

---

## L3-18 — The Payroll Desk

### Scenario
A small business pays hourly staff: each employee has an hourly rate and hours worked this week. Overtime (hours above 40) is paid at 1.5×. The desk prints each employee's pay and the business's total wage bill.

### Problem statement
Read `n` employees (1–50). For each: name (one word), hourly rate (double), hours (double). Compute pay = rate × hours, with hours above 40 paid at 1.5× for the excess. Print each employee's pay and the total wage bill, plus the count of employees who earned overtime.

### Learning objectives
- manage parallel collections (names, rates, hours) through functions
- compute a business rule (overtime) in exactly one function
- combine per-item output with aggregate reporting

### Requirements
1. Store names, rates, and hours in three parallel vectors (the pre-struct idiom — Level 4 replaces it).
2. `double payFor(double rate, double hours)` — the overtime rule lives only here.
3. Rate must be positive; hours in 0–80 (re-prompt each).
4. Print `Name: Rs pay` per employee; then `Wage bill: Rs X` and `Overtime earners: N`.

### Input
`n`, then per employee: name, rate, hours.

### Output
Per-employee pay lines, then the two summary lines.

### Constraints
- The 40-hour boundary: 40 hours exactly earns no overtime; 41 earns one half-rate hour.
- Money prints two decimals.

### Example
Input: n=2, `Ali 500 45`, `Sara 600 38` → Ali: Rs 23750.00 (40×500 + 5×750), Sara: Rs 22800.00, Wage bill: Rs 46550.00, Overtime earners: 1.

### Test cases
| Input | Expected |
| --- | --- |
| 2: Ali 500 45, Sara 600 38 | the example output |
| 1: Bilal 500 40 | Rs 20000.00, overtime earners 0 |
| 1: Bilal 500 41 | Rs 20750.00 (one half-rate hour) |
| 1: Zed 0 40 | rate re-prompt |
| 1: Zed 500 81 | hours re-prompt |

### Student tasks
1. Write the three read loops into parallel vectors (or one read loop filling all three).
2. Write `payFor` and verify its 40/41 boundary by hand.
3. Write the report loop and the aggregates.
4. Assemble `main`.

### Hints
1. Overtime slice: `hours <= 40 ? rate * hours : rate * 40 + (hours - 40) * rate * 1.5`.
2. "Overtime earners" needs `hours > 40` — count it in the report loop, don't re-derive it from pay.
3. Parallel vectors must stay index-aligned — one read loop filling all three is the safest way.

### Extension challenges
1. Add a tax band: pay above Rs 25000 is taxed 5% at print time (compute, don't store).
2. Print the highest-paid employee's name and pay.

### Complete solution

```cpp
// L3-18 — The Payroll Desk
// Compile: g++ -std=c++17 -Wall -Wextra L3-18.cpp -o L3-18
#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
using namespace std;

double payFor(double rate, double hours) {
    const double REGULAR_CAP = 40.0, OVERTIME_MULTIPLIER = 1.5;
    if (hours <= REGULAR_CAP)
        return rate * hours;
    return rate * REGULAR_CAP + (hours - REGULAR_CAP) * rate * OVERTIME_MULTIPLIER;
}

int main() {
    int n;
    cout << "Number of employees: ";
    cin >> n;
    if (n < 1 || n > 50) { cout << "Invalid count\n"; return 1; }

    vector<string> names;
    vector<double> rates, hours;

    for (int i = 0; i < n; ++i) {
        string name;
        double rate, hrs;
        cout << "Employee " << (i + 1) << " name: ";
        cin >> name;
        cout << "hourly rate: ";
        cin >> rate;
        while (rate <= 0) { cout << "Rate must be positive: "; cin >> rate; }
        cout << "hours worked: ";
        cin >> hrs;
        while (hrs < 0 || hrs > 80) { cout << "Hours are 0-80: "; cin >> hrs; }

        names.push_back(name);
        rates.push_back(rate);
        hours.push_back(hrs);
    }

    cout << fixed << setprecision(2);
    double wageBill = 0.0;
    int overtimeEarners = 0;

    for (int i = 0; i < n; ++i) {
        double pay = payFor(rates[i], hours[i]);
        wageBill += pay;
        if (hours[i] > 40) ++overtimeEarners;
        cout << names[i] << ": Rs " << pay << "\n";
    }

    cout << "Wage bill: Rs " << wageBill << "\n";
    cout << "Overtime earners: " << overtimeEarners << "\n";
    return 0;
}
```

### Solution explanation
The business rule (overtime) is deliberately confined to `payFor` — the boundary test (40 vs 41 hours) verifies one function, and a rate change touches one line. The parallel-vector idiom is the course's bridge: it works, and its clumsiness (three vectors that must never desynchronise — hence one read loop filling all three) is exactly what Level 4's structs and classes fix. The aggregates accumulate in the *report* loop, so the data is traversed once for output and accounting together.

### Testing checklist
- [ ] All five test cases pass
- [ ] 40 hours earns no overtime; 41 earns exactly one half-rate hour
- [ ] Rate/hours re-prompts keep the employee aligned across all three vectors
- [ ] Changing the overtime multiplier touches one line

---

## L3-19 — The Temperature Station

### Scenario
A weather station logs one temperature per hour for a day (24 readings). The duty officer wants the day's statistics: average, the hottest and coldest hours, how many hours exceeded 35 °C, and the longest run of consecutive hours above 30 °C.

### Problem statement
Read 24 temperatures (−50 to 60). Print: average, maximum with its hour, minimum with its hour, the count above 35, and the longest consecutive run above 30 (with its starting hour).

### Learning objectives
- scan a collection for extremes *with positions*
- track a **run** — a consecutive streak — with length and start
- combine position-based and value-based statistics

### Requirements
1. Temperatures outside −50–60 are re-prompted for that hour.
2. Average two decimals; hours print 0-based (`Hour 14`).
3. The run: strictly above 30 counts; ties for the longest run take the *earliest*.
4. If no hour exceeds 30, print `No hot run`.

### Input
24 doubles.

### Output
Six labelled lines (average, max+hour, min+hour, above-35 count, run length, run start).

### Constraints
- One pass for the run detection (the run logic must not re-scan).
- `max`/`min` use first-occurrence ties (Level 2's rule, still in force).

### Example
Readings around the day peaking at 41.2 in hour 14, with hours 12–16 above 30 →
`Average: 29.83`, `Max: 41.2 at hour 14`, `Min: 18.4 at hour 5`, `Above 35: 3`, `Longest run above 30: 5 hours starting hour 12`.

### Test cases
| Input | Expected |
| --- | --- |
| a 24-reading set with a 5-hour run peaking at hour 14 | the example output |
| all readings 25 | average 25.00, `No hot run`, above-35: 0 |
| first two readings 45 45, rest 20 | Max 45 at hour 0 (first tie), run 2 hours from hour 0 |
| one reading −60 then repaired, rest 25 | re-prompt keeps hour 0; stats from the repaired value |
| 24 readings of exactly 30 | `No hot run` (30 is not *above* 30) |

### Student tasks
1. Write the read loop into a `vector<double>` (24 slots, re-prompt per hour).
2. Scan once for max/min with hours and the above-35 count.
3. Scan (the same pass is allowed) for the longest run: track current run length/start, and the best-so-far.
4. Print the six lines with the `No hot run` fallback.

### Hints
1. Run logic: if `t > 30` and *previous* was also in the run, extend; else start a new run at this hour. Compare each finished/current run against the best.
2. The run can end at the array's edge — the best-run update must happen after the loop too.
3. Strictly above: `t > 30` — the exactly-30 test case exists to catch `>=`.

### Extension challenges
1. Report the *coldest* run (longest consecutive stretch below 10).
2. Read a second day and report which day was hotter on average.

### Complete solution

```cpp
// L3-19 — The Temperature Station
// Compile: g++ -std=c++17 -Wall -Wextra L3-19.cpp -o L3-19
#include <iostream>
#include <iomanip>
#include <vector>
using namespace std;

int main() {
    const int HOURS = 24;
    vector<double> temps(static_cast<size_t>(HOURS));

    for (int h = 0; h < HOURS; ++h) {
        double t;
        cout << "Temperature at hour " << h << ": ";
        cin >> t;
        while (t < -50.0 || t > 60.0) {
            cout << "Range is -50 to 60. Again: ";
            cin >> t;
        }
        temps[static_cast<size_t>(h)] = t;
    }

    double total = 0.0;
    double maxT = temps[0], minT = temps[0];
    int maxH = 0, minH = 0, above35 = 0;

    int bestLen = 0, bestStart = -1;
    int curLen = 0, curStart = -1;

    for (int h = 0; h < HOURS; ++h) {
        double t = temps[static_cast<size_t>(h)];
        total += t;
        if (t > maxT) { maxT = t; maxH = h; }
        if (t < minT) { minT = t; minH = h; }
        if (t > 35.0) ++above35;

        if (t > 30.0) {
            if (curLen == 0) curStart = h;      // a run begins
            ++curLen;
            if (curLen > bestLen) {             // strictly greater: earliest tie wins
                bestLen = curLen;
                bestStart = curStart;
            }
        } else {
            curLen = 0;                          // the run ends
        }
    }

    cout << fixed << setprecision(2);
    cout << "Average: " << total / HOURS << "\n";
    cout << "Max: " << maxT << " at hour " << maxH << "\n";
    cout << "Min: " << minT << " at hour " << minH << "\n";
    cout << "Above 35: " << above35 << "\n";
    if (bestLen == 0)
        cout << "No hot run\n";
    else
        cout << "Longest run above 30: " << bestLen << " hours starting hour " << bestStart << "\n";
    return 0;
}
```

### Solution explanation
Everything runs in **one scan**: extremes, threshold counts, and the run — the run logic is the new pattern (track the *current* run's length and start; every in-run step updates the best if strictly longer; leaving the run resets length but not the best). The strictly-greater comparison encodes the earliest-tie rule without extra code. The best-run bookkeeping never needs an after-loop fix *in this formulation* because the best is updated continuously as the run grows — a deliberate design choice over "update at run end," which must special-case the array edge. All statistics live on one `const`-visited vector — read once, viewed many.

### Testing checklist
- [ ] All five test cases pass
- [ ] Exactly-30 readings neither start nor extend a run
- [ ] The all-25 day prints `No hot run`
- [ ] Ties report earliest occurrences for max, min, and runs

---

## L3-20 — The Word Frequency Counter

### Scenario
The linguistics society analyses short texts: given a paragraph of one-word tokens, count how often each word appears and report the most frequent word.

### Problem statement
Read `n` words (1–200, each ≤ 30 letters, no spaces). Count frequencies using two parallel vectors (words and counts) *without* the STL's `map` — the point is the manual frequency table. Print the table in first-appearance order and name the most frequent word (first-occurrence tie-break).

### Learning objectives
- implement a frequency table over parallel vectors
- search a vector for membership before insert-or-increment
- find the maximum of one vector while retrieving the aligned value of another

### Requirements
1. For each word: if present in the words vector, increment its count; else append the word with count 1.
2. Print `word: count` lines in first-appearance order.
3. Print `Most frequent: word (count)` — ties resolve to the earliest.
4. Case-sensitive: `Apple` and `apple` are different words.

### Input
`n`, then n whitespace-separated words.

### Output
The frequency table, then the most-frequent line.

### Constraints
- No `map`/`unordered_map` — parallel vectors and explicit search only.
- The membership search is a function: `int indexOf(const vector<string>&, const string&)` returning −1 on miss.

### Example
Input: n=8, words `the cat sat the mat the cat sat` →
`the: 3`, `cat: 2`, `sat: 2`, `mat: 1`, `Most frequent: the (3)`.

### Test cases
| Input | Expected |
| --- | --- |
| the example | the table above |
| 1: hello | hello: 1, Most frequent: hello (1) |
| 3: a a a | a: 3, most frequent a (3) |
| 4: Apple apple Apple apple | two table lines, Most frequent: Apple (2) — first tie |
| 2: x y | two lines, tie at 1 — earliest (x) wins |

### Student tasks
1. Write `indexOf` (linear search returning −1).
2. Write the ingest loop: search, then increment or append.
3. Write the table printer.
4. Find the most frequent: scan the counts vector, track the best index, print the aligned word.

### Hints
1. The two vectors are index-aligned — `words[i]` and `counts[i]` describe one entry; never append to one without the other.
2. The most-frequent scan is `counts[i] > counts[best]` (strict) over indices — first-occurrence ties for free.
3. `indexOf` is the algorithms module's linear search — signature first, then the loop.

### Extension challenges
1. Print the table sorted by descending count (a manual selection pass over the pairs).
2. Report words that appear exactly once (the "unique" list).

### Complete solution

```cpp
// L3-20 — The Word Frequency Counter
// Compile: g++ -std=c++17 -Wall -Wextra L3-20.cpp -o L3-20
#include <iostream>
#include <string>
#include <vector>
using namespace std;

int indexOf(const vector<string>& words, const string& target) {
    for (size_t i = 0; i < words.size(); ++i)
        if (words[i] == target) return static_cast<int>(i);
    return -1;
}

int main() {
    int n;
    cout << "How many words: ";
    cin >> n;
    if (n < 1 || n > 200) { cout << "Invalid count\n"; return 1; }

    vector<string> words;
    vector<int> counts;

    for (int k = 0; k < n; ++k) {
        string w;
        cin >> w;
        int idx = indexOf(words, w);
        if (idx == -1) {
            words.push_back(w);
            counts.push_back(1);              // both vectors move together
        } else {
            ++counts[static_cast<size_t>(idx)];
        }
    }

    for (size_t i = 0; i < words.size(); ++i)
        cout << words[i] << ": " << counts[i] << "\n";

    size_t best = 0;
    for (size_t i = 1; i < counts.size(); ++i)
        if (counts[i] > counts[best]) best = i;

    cout << "Most frequent: " << words[best] << " (" << counts[best] << ")\n";
    return 0;
}
```

### Solution explanation
The manual frequency table is the pre-`map` form of the tally the STL module later replaces with one line — the lab's value is *feeling* what `map` automates: membership search, insert-or-increment, and aligned storage. The index-alignment discipline (both vectors appended together, both indexed together) is the invariant the whole design rests on. The most-frequent scan runs over *indices* with a strict comparison, retrieving the aligned word only at the end — the parallel-collection max pattern from L2-15, now over two aligned vectors.

### Testing checklist
- [ ] All five test cases pass
- [ ] Case sensitivity holds (Apple ≠ apple)
- [ ] The table preserves first-appearance order
- [ ] No `map` anywhere in the source

---

## L3-21 — The Queue Simulator

### Scenario
The registrar's service counter serves students FIFO. The office manager wants to simulate one counter: students arrive with service times; the counter serves them in arrival order; the manager wants who-was-served-when and waiting times.

### Problem statement
Read `n` students (1–20): a one-word name and an integer service time (1–60) each. Simulate a single FIFO counter starting at time 0: each student's service begins when the previous one ends. Print the schedule (start and end times per student) and each student's waiting time (start − arrival), where arrival times are the read order (arrival of student i is the *end of the previous service*; the first arrives at 0).

### Learning objectives
- simulate a queue with a vector and a running clock
- compute derived per-item values (waiting time) from simulation state
- print a schedule as a table

### Requirements
1. Service is strictly FIFO in read order.
2. `start[0] = 0`; `start[i] = end[i-1]`; `end[i] = start[i] + service[i]`.
3. Waiting time = start (arrival is implicitly the previous end).
4. Print a table: `name served from T1 to T2 (waited W minutes)`; then the average waiting time.

### Input
`n`, then per student: name, service time.

### Output
The schedule table, then `Average wait: X.X minutes`.

### Constraints
- Service times 1–60 (re-prompt outside).
- First student's wait is 0.

### Example
Input: n=3, `Ali 10`, `Sara 5`, `Bilal 20` →
Ali served 0–10 (waited 0), Sara 10–15 (waited 10), Bilal 15–35 (waited 15), Average wait: 8.3 minutes.

### Test cases
| Input | Expected |
| --- | --- |
| the example | the table and 8.3 average |
| 1: Zed 30 | one row, waited 0, average 0.0 |
| 3: all time 1 | starts 0, 1, 2; average wait 1.0 |
| 2: A 60, B 60 | second waits 60 — the maximum in-range wait |
| 2: A 0, B 5 | time re-prompt for A; schedule unaffected |

### Student tasks
1. Read names and service times into parallel vectors with validation.
2. Simulate: one clock variable, one pass — start, end, wait per student (store starts or print on the fly — your choice, justified).
3. Print the table rows as they are computed (or from stored starts).
4. Accumulate waits and print the average.

### Hints
1. One `long long clock = 0;` — `start = clock; clock += service;` is the entire simulation.
2. Waiting time needs the *start*, which you have before updating the clock — no second pass needed if you print/accumulate inline.
3. The average needs `double` division by n — the int-sum habit again.

### Extension challenges
1. Add a second counter: assign each arriving student to the counter that frees first (sort-of simulation; still no full STL required).
2. Report the maximum waiting time and who waited.

### Complete solution

```cpp
// L3-21 — The Queue Simulator
// Compile: g++ -std=c++17 -Wall -Wextra L3-21.cpp -o L3-21
#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
using namespace std;

int main() {
    int n;
    cout << "Number of students: ";
    cin >> n;
    if (n < 1 || n > 20) { cout << "Invalid count\n"; return 1; }

    vector<string> names;
    vector<int> service;

    for (int i = 0; i < n; ++i) {
        string name;
        int t;
        cout << "Student " << (i + 1) << " name: ";
        cin >> name;
        cout << "service time (1-60): ";
        cin >> t;
        while (t < 1 || t > 60) { cout << "1-60 please: "; cin >> t; }
        names.push_back(name);
        service.push_back(t);
    }

    long long clockTime = 0;                 // the counter's only state
    double waitTotal = 0.0;

    cout << "\n=== SERVICE SCHEDULE ===\n";
    for (int i = 0; i < n; ++i) {
        long long start = clockTime;
        long long end = start + service[static_cast<size_t>(i)];
        double waited = static_cast<double>(start);   // arrival = previous end

        cout << names[static_cast<size_t>(i)]
             << " served from " << start << " to " << end
             << " (waited " << static_cast<long long>(waited) << " minutes)\n";

        waitTotal += waited;
        clockTime = end;
    }

    cout << "Average wait: " << fixed << setprecision(1) << waitTotal / n << " minutes\n";
    return 0;
}
```

### Solution explanation
The entire simulation is one state variable: the counter's clock. Each iteration reads the clock (start), computes the end, prints, and advances — the FIFO discipline needs no queue *structure* because arrival order *is* the vector order. Waiting time falls out as the start time itself (arrival = previous end), so the "derived value" costs nothing extra. The lab teaches simulation's core shape — state + transition + report — with the smallest possible state, preparing the scheduling and banking labs of Levels 4–5 where state multiplies.

### Testing checklist
- [ ] All five test cases pass
- [ ] First student always waits 0
- [ ] The schedule's end times chain exactly into the next starts
- [ ] Average prints one decimal

---

## L3-22 — The Voting Booth

### Scenario
The student society elects a representative from three candidates. The booth accepts one vote per line, validates against the candidate list, and publishes the tally.

### Problem statement
Read votes as candidate numbers 1–3 until the sentinel `-1`. Reject invalid votes (0, 4, non-numeric) with a message, without counting them. At close, print each candidate's count, the total valid votes, the winner (first-occurrence tie-break), or `Tie` when the top two are equal.

### Learning objectives
- validate a choice against a fixed vocabulary inside a loop
- tally into a fixed-size counter array
- compute a winner with an explicit tie rule

### Requirements
1. Candidates: `1 Ali, 2 Sara, 3 Bilal` — the tally is `int votes[3]`.
2. Sentinel `-1` closes the booth; `-1` is never a vote.
3. Invalid votes (outside 1–3, non-numeric) print `Invalid vote` and are not counted.
4. Output: three count lines, `Total valid: N`, then `Winner: name` or `Tie at the top`.

### Input
One int per line, terminated by `-1`.

### Output
The tally block and the winner line.

### Constraints
- Non-numeric input must not crash the booth (stream repair, message, continue).
- Tie rule: if the top count occurs for two or more candidates → `Tie at the top`.

### Example
Input: `1`, `3`, `1`, `2`, `1`, `-1` → Ali 3, Sara 1, Bilal 1, Total valid: 5, `Winner: Ali`.

### Test cases
| Input | Expected |
| --- | --- |
| the example | the tally above |
| −1 first | all zeros, Total 0, `No votes cast` |
| 1, 2, −1 | tie at the top |
| 5, 0, 2, −1 | two Invalid votes, Sara 1 |
| abc, 3, −1 | stream repaired, Invalid vote, Bilal 1 |

### Student tasks
1. Write the vote loop with the sentinel and the vocabulary check.
2. Add the stream-repair branch.
3. Tally into `votes[choice - 1]`.
4. Find the max count; decide winner vs tie; print the block.

### Hints
1. The tally array's indices are 0–2 but the booth's vocabulary is 1–3 — subtract once, at the tally line.
2. Winner vs tie: count how many candidates hold the max count — 1 means a winner, more means a tie.
3. Zero valid votes is its own outcome — decide its message before the winner logic.

### Extension challenges
1. Add a fourth candidate — count every line that changes (then imagine the tally as a vector).
2. Print the vote percentages alongside counts (guard the divide-by-zero).

### Complete solution

```cpp
// L3-22 — The Voting Booth
// Compile: g++ -std=c++17 -Wall -Wextra L3-22.cpp -o L3-22
#include <iostream>
#include <string>
using namespace std;

int main() {
    const string NAMES[3] = {"Ali", "Sara", "Bilal"};
    int votes[3] = {0, 0, 0};
    int totalValid = 0;

    cout << "Vote (1-3, -1 to close): ";
    int v;
    while (cin >> v && v != -1) {
        if (!cin) {                              // non-numeric
            cin.clear();
            cin.ignore(1000, '\n');
            cout << "Invalid vote\n";
        } else if (v < 1 || v > 3) {
            cout << "Invalid vote\n";
        } else {
            ++votes[v - 1];
            ++totalValid;
        }
        cout << "Vote (1-3, -1 to close): ";
    }

    cout << "\n=== TALLY ===\n";
    for (int i = 0; i < 3; ++i)
        cout << NAMES[i] << ": " << votes[i] << "\n";
    cout << "Total valid: " << totalValid << "\n";

    if (totalValid == 0) {
        cout << "No votes cast\n";
        return 0;
    }

    int maxVotes = votes[0];
    for (int i = 1; i < 3; ++i)
        if (votes[i] > maxVotes) maxVotes = votes[i];

    int leaders = 0;
    for (int i = 0; i < 3; ++i)
        if (votes[i] == maxVotes) ++leaders;

    if (leaders == 1) {
        for (int i = 0; i < 3; ++i)
            if (votes[i] == maxVotes) { cout << "Winner: " << NAMES[i] << "\n"; break; }
    } else {
        cout << "Tie at the top\n";
    }
    return 0;
}
```

### Solution explanation
The tally is a *fixed-vocabulary counter array* — the simplest and most important frequency structure; the 1–3 → 0–2 index shift happens at exactly one line. The winner logic separates "find the max" from "count who holds it," which turns the tie rule into an arithmetic question (1 leader vs 2+). The stream-repair branch and the vocabulary check coexist in one loop, each rejecting *its own* failure mode with the same message — the booth stays alive through any input abuse. The zero-votes outcome is handled before the winner logic, an ordering decision the test table exercises.

### Testing checklist
- [ ] All five test cases pass
- [ ] Invalid votes (numeric and non-) never enter the tally
- [ ] The tie rule fires for two-way and three-way ties
- [ ] The booth survives non-numeric input without crashing

---

## L3-23 — The Matrix Marks Grid

### Scenario
The examination cell stores marks in a grid: rows are students, columns are subjects. The cell needs per-student totals, per-subject averages, and the grid's grand average.

### Problem statement
Read `rows` (1–20) and `cols` (1–10). Read the grid of marks (0–100, re-prompt per cell). Print: each student's total and average (a row report), each subject's average (a column report), and the grand average of all cells.

### Learning objectives
- index a 2D array with nested loops in both directions
- compute row-wise and column-wise aggregates over the same grid
- distinguish row-major traversal (row reports) from column-major (column reports)

### Requirements
1. Store the grid as `int marks[20][10]` (or a `vector<vector<int>>` — state your choice).
2. Row report: `Student i: total T, average A` (average 1 decimal).
3. Column report: `Subject j: average A`.
4. Grand average over all rows×cols cells, 2 decimals.

### Input
rows, cols, then rows×cols marks in row-major order.

### Output
The row block, the column block, the grand average.

### Constraints
- Marks outside 0–100 re-prompt for the same cell (the cell's position must not advance).
- Both report directions must read the *stored* grid — no recomputation from input.

### Example
rows=2, cols=3: `80 70 90` / `60 50 40` → Student 1: total 240, avg 80.0; Student 2: total 150, avg 50.0; Subject 1: 70.0, Subject 2: 60.0, Subject 3: 65.0; Grand: 65.00.

### Test cases
| Input | Expected |
| --- | --- |
| the example grid | all reports as stated |
| 1×1: 100 | Student 1: 100/100.0; Subject 1: 100.0; Grand 100.00 |
| 0 rows | Invalid size |
| 2×2 with one re-prompted cell | re-prompt keeps the cell; totals correct |
| 3×2 all 50 | every average 50, grand 50.00 |

### Student tasks
1. Read rows/cols with validation; read the grid with the cell re-prompt loop.
2. Row report: outer rows, inner cols accumulating.
3. Column report: outer cols, inner rows — the loops *swap*.
4. Grand average: either sum both passes or one dedicated pass.

### Hints
1. `marks[row][col]` — the first index is the student; the column report simply reverses which index the *outer* loop drives.
2. Column averages divide by `rows`, row averages by `cols` — swap them and the test grid betrays you.
3. A `long long` running total for the grand sum; the divide happens once at the end.

### Extension challenges
1. Print each student's best subject (a mini-max per row).
2. Mark failing cells (< 50) with `*` in a reprinted grid.

### Complete solution

```cpp
// L3-23 — The Matrix Marks Grid
// Compile: g++ -std=c++17 -Wall -Wextra L3-23.cpp -o L3-23
#include <iostream>
#include <iomanip>
using namespace std;

int main() {
    const int MAX_ROWS = 20, MAX_COLS = 10;

    int rows, cols;
    cout << "Students: ";
    cin >> rows;
    cout << "Subjects: ";
    cin >> cols;
    if (rows < 1 || rows > MAX_ROWS || cols < 1 || cols > MAX_COLS) {
        cout << "Invalid size\n";
        return 1;
    }

    static int marks[MAX_ROWS][MAX_COLS];

    for (int r = 0; r < rows; ++r) {
        for (int c = 0; c < cols; ++c) {
            int m;
            cout << "Student " << (r + 1) << ", subject " << (c + 1) << ": ";
            cin >> m;
            while (m < 0 || m > 100) {
                cout << "Marks are 0-100. Again: ";
                cin >> m;
            }
            marks[r][c] = m;
        }
    }

    cout << fixed << setprecision(1);

    cout << "\n=== STUDENT REPORT ===\n";
    for (int r = 0; r < rows; ++r) {
        int total = 0;
        for (int c = 0; c < cols; ++c) total += marks[r][c];
        cout << "Student " << (r + 1) << ": total " << total
             << ", average " << static_cast<double>(total) / cols << "\n";
    }

    cout << "\n=== SUBJECT REPORT ===\n";
    for (int c = 0; c < cols; ++c) {
        int total = 0;
        for (int r = 0; r < rows; ++r) total += marks[r][c];
        cout << "Subject " << (c + 1) << ": average "
             << static_cast<double>(total) / rows << "\n";
    }

    long long grand = 0;
    for (int r = 0; r < rows; ++r)
        for (int c = 0; c < cols; ++c) grand += marks[r][c];

    cout << "\nGrand average: " << setprecision(2)
         << static_cast<double>(grand) / (rows * cols) << "\n";
    return 0;
}
```

### Solution explanation
The grid is stored once and reported twice in different directions — the row report's loops run `(rows, cols)`, the column report's run `(cols, rows)`, and *nothing else changes*: that symmetry is the entire lesson of two-dimensional traversal. Each report divides by its *own* dimension (row averages by cols, column averages by rows) — the test grid's unequal row/column totals catch any swap. The static grid bounds are the arrays module's fixed-capacity pattern; a `vector<vector<int>>` is the acceptable alternative the requirements name, with the same nested logic.

### Testing checklist
- [ ] All five test cases pass
- [ ] Row and column averages divide by their own dimension
- [ ] The re-prompted cell keeps its position in both indices
- [ ] Grand average is 2-decimal; per-item averages 1-decimal

---

## L3-24 — The Inventory Reorder

### Scenario
The campus store's manager reviews stock weekly: for each product, decide *reorder now* (below the reorder point), *fine*, or *overstocked* (above 5× the reorder point), and compute the reorder quantity (target stock minus current).

### Problem statement
Read `n` products (1–30): name (one word), current quantity (≥ 0), reorder point (1–500), target stock (≥ reorder point). For each, print the status line and — when reordering — the quantity to order (target − current). Print the number of products to reorder and the total units to order.

### Learning objectives
- encode a three-way business rule as a decision ladder
- enforce a cross-field constraint (target ≥ reorder point) at input time
- aggregate a decision's arithmetic across a batch

### Requirements
1. Status: `qty < point` → `REORDER NOW (order X)`; `qty > 5 * point` → `OVERSTOCKED`; else `Fine`.
2. Target below reorder point → re-prompt for the *target only*.
3. Quantities can't go negative; reorders use the computed difference (never negative).
4. Summary: `To reorder: N products, M units`.

### Input
`n`, then per product: name, qty, point, target.

### Output
Per product one status line; then the summary line.

### Constraints
- The overstock multiplier (5) is a named constant.
- All validations re-prompt, not refuse.

### Example
Input: n=2, `Notebook 8 10 30`, `Pen 60 10 30` →
`Notebook: REORDER NOW (order 22)`, `Pen: OVERSTOCKED`, `To reorder: 1 products, 22 units`.

### Test cases
| Input | Expected |
| --- | --- |
| the example | both statuses, summary 1/22 |
| 1: Pencil 10 10 10 | Fine (equal to point is *not* below), order nothing |
| 1: Pad 9 10 5 then 25 | target re-prompt; REORDER (order 16) |
| 1: Ruler 0 10 20 | REORDER (order 20) |
| 2: A 10 10 10, B 51 10 10 | Fine, OVERSTOCKED (5×10=50 < 51), summary 0/0 |

### Student tasks
1. Write the read loop with the four validations (including the cross-field target check).
2. Write the status ladder with the named multiplier.
3. Accumulate reorder counts and units.
4. Print the summary.

### Hints
1. The ladder's edges: `qty < point` strictly, and `qty > 5 * point` strictly — the between-band equality (test case 2) must land on `Fine`.
2. The cross-field check is a *conditional re-prompt*: `while (target < point)`.
3. The order quantity is `max(0, target - qty)` — the max makes the never-negative rule structural.

### Extension challenges
1. Sort the reorder list by quantity descending before printing (a second pass over stored data).
2. Add a budget: cap total reorder units at a limit, skipping products that would exceed it.

### Complete solution

```cpp
// L3-24 — The Inventory Reorder
// Compile: g++ -std=c++17 -Wall -Wextra L3-24.cpp -o L3-24
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    const int OVERSTOCK_FACTOR = 5;

    int n;
    cout << "Number of products: ";
    cin >> n;
    if (n < 1 || n > 30) { cout << "Invalid count\n"; return 1; }

    int reorderProducts = 0;
    long long reorderUnits = 0;

    for (int i = 0; i < n; ++i) {
        string name;
        int qty, point, target;

        cout << "Product " << (i + 1) << " name: ";
        cin >> name;
        cout << "current quantity: ";
        cin >> qty;
        while (qty < 0) { cout << "Cannot be negative: "; cin >> qty; }
        cout << "reorder point: ";
        cin >> point;
        while (point < 1 || point > 500) { cout << "1-500: "; cin >> point; }
        cout << "target stock: ";
        cin >> target;
        while (target < point) { cout << "Target must be >= reorder point: "; cin >> target; }

        if (qty < point) {
            int order = max(0, target - qty);
            cout << name << ": REORDER NOW (order " << order << ")\n";
            ++reorderProducts;
            reorderUnits += order;
        } else if (qty > OVERSTOCK_FACTOR * point) {
            cout << name << ": OVERSTOCKED\n";
        } else {
            cout << name << ": Fine\n";
        }
    }

    cout << "To reorder: " << reorderProducts << " products, " << reorderUnits << " units\n";
    return 0;
}
```

### Solution explanation
The three-way status ladder is a *business rule made executable* — its two strict comparisons and the named multiplier make the between-band case (test 2) land on `Fine` by construction. The cross-field validation (`target ≥ point`) is conditional on earlier input — the first re-prompt loop that *depends on another variable*, a step up from fixed-range checks. The `max(0, ...)` order quantity makes the never-negative rule structural rather than remembered, and the aggregates accumulate exactly where the REORDER branch fires — the decision and its accounting live in one branch, so they can never disagree.

### Testing checklist
- [ ] All five test cases pass, especially the equal-to-point and 5× boundary
- [ ] The target re-prompt repeats until the cross-field rule holds
- [ ] Order quantities are never negative even with odd targets
- [ ] The summary counts only REORDER products

---

[← Level 2](level-2.md) · [Labs home](index.md) · Continue to [Level 4 — Advanced](level-4.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
