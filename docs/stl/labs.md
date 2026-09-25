---
title: "STL Labs — 6 Container-Family Scenarios"
description: "Six labs — contact manager, inventory manager, student grade analyzer, frequency counter, leaderboard, task queue — each with requirements, test data, expected results, solution, and explanation."
---

# STL Labs — six scenarios

> [← Module home](index.md) · Attempt each lab's **container choice (with one-sentence justification) and test table** first. Every lab: scenario → requirements → test data & expected results → solution → explanation → ⭐ extensions.

---

## Lab 1 — Contact manager (`map`)

**Scenario.** A phone-book program: find a contact's number instantly by name, list all contacts sorted by name, add and delete safely.

**Requirements.**

- R1 — `map<string, string>` (name → number); names unique.
- R2 — `add(name, number) -> bool` (refuses duplicates and empty names), `remove(name) -> bool` (refuses absent), `findNumber(name) -> string` (empty string when absent — *without* inserting).
- R3 — `listAll()` prints sorted by name (free).
- R4 — Load-from-records constructor-style bulk insert.

**Test data & expected results.**

| Action | Expected |
| --- | --- |
| add Aisha/0300-111, Omar/0300-222, Sana/0300-333 | all true |
| add Aisha again | **false** (duplicate) |
| findNumber("Omar") | 0300-222 |
| findNumber("Zaid") | "" and `size()` still 3 (no insert!) |
| remove("Sana") | true; remove("Sana") again → false |
| listAll() | Aisha, Omar — sorted |

**Solution.**

```cpp
// stl-lab1-contacts.cpp — Programming Fundamentals Using C++
// STL module · Lab 1 · Contact manager over map
// Compile: g++ -std=c++17 -Wall -Wextra stl-lab1-contacts.cpp -o lab1

#include <iostream>
#include <map>
#include <string>
using namespace std;

class Contacts {
public:
    bool add(const string& name, const string& number) {
        if (name.empty() || book.count(name)) return false;
        book[name] = number;                 // insert-or-assign: the write door
        return true;
    }
    bool remove(const string& name) {
        return book.erase(name) > 0;         // erase returns the count removed
    }
    string findNumber(const string& name) const {
        auto it = book.find(name);           // the ask-door: no insertion
        return it == book.end() ? "" : it->second;
    }
    void listAll() const {
        for (const auto& [name, number] : book)
            cout << name << ": " << number << "\n";
    }
    int size() const { return (int)book.size(); }
private:
    map<string, string> book;
};

int main() {
    Contacts c;
    cout << boolalpha;
    cout << c.add("Aisha", "0300-111") << c.add("Omar", "0300-222")
         << c.add("Sana", "0300-333") << "\n";      // 111
    cout << c.add("Aisha", "0399") << "\n";          // 0 (duplicate)
    cout << c.findNumber("Omar") << "\n";            // 0300-222
    cout << c.findNumber("Zaid") << "|" << c.size() << "\n";  // |3 — no insert
    cout << c.remove("Sana") << c.remove("Sana") << "\n";     // 10
    c.listAll();                                      // Aisha, Omar — sorted
    return 0;
}
```

**Expected output.**

```text
111
0
0300-222
|3
10
Aisha: 0300-111
Omar: 0300-222
```

**Explanation.** The two-doors discipline (write with `[]`, ask with `find`) is the lab's spine — `findNumber` returning `""` *without* inserting is the D1/D13 rule in method form. `erase`'s count-return makes `remove` a one-liner that still reports honesty. Sorted listing is the sorted-pair dividend (Lesson 2): zero code paid for it.

**Extensions.** ⭐ Store structured values (`map<string, vector<string>>` — multiple numbers per name). ⭐ List by *number* prefix (walk the sorted map, filter — the sorted pair's range nature at work).

---

## Lab 2 — Inventory manager (`map` + `vector` report)

**Scenario.** A shop tracks item stock by SKU; low-stock items surface in a report sorted by quantity.

**Requirements.**

- R1 — `map<string, int>` (SKU → quantity); `receive(sku, qty)` (refuses qty ≤ 0; inserts or adds), `sell(sku, qty) -> bool` (refuses insufficient stock; decrements).
- R2 — `lowStock(threshold) -> vector<pair<string,int>>` sorted **ascending by quantity** (ties by SKU).
- R3 — `totalUnits() -> long long` via `accumulate`.
- R4 — The report builds on a *copy* of the map's pairs — state why (the map's order is key-order; the report needs value-order).

**Test data & expected results.**

| Action | Expected |
| --- | --- |
| receive SKU-1 ×50, SKU-2 ×8, SKU-3 ×120 | all true |
| receive SKU-1 ×10 (top-up) | SKU-1 = 60 |
| sell SKU-2 ×10 | **false** (insufficient) |
| sell SKU-2 ×5 | true; SKU-2 = 3 |
| lowStock(10) | [(SKU-2, 3)] then threshold 100 → [(SKU-2,3), (SKU-1,60), (SKU-3,120)] |
| totalUnits | 183 |

**Solution.**

```cpp
#include <iostream>
#include <map>
#include <vector>
#include <string>
#include <numeric>
#include <algorithm>
using namespace std;

class Inventory {
public:
    bool receive(const string& sku, int qty) {
        if (qty <= 0) return false;
        stock[sku] += qty;                   // insert-or-accumulate: intended write
        return true;
    }
    bool sell(const string& sku, int qty) {
        auto it = stock.find(sku);
        if (it == stock.end() || qty <= 0 || qty > it->second) return false;
        it->second -= qty;
        return true;
    }
    vector<pair<string, int>> lowStock(int threshold) const {
        vector<pair<string, int>> report;
        for (const auto& [sku, qty] : stock)
            if (qty < threshold) report.push_back({sku, qty});
        sort(report.begin(), report.end(),
             [](const pair<string,int>& a, const pair<string,int>& b) {
                 return a.second != b.second ? a.second < b.second : a.first < b.first;
             });
        return report;
    }
    long long totalUnits() const {
        return accumulate(stock.begin(), stock.end(), 0LL,
                          [](long long acc, const pair<const string, int>& p) {
                              return acc + p.second;
                          });
    }
private:
    map<string, int> stock;
};
```

**Explanation.** `sell` uses `find` once and *reuses* the iterator for both the test and the update — one lookup instead of two (the D1 discipline, performance-flavoured). `lowStock` copies pairs and sorts by *value* with a tie-broken comparator — the map's key-order is a feature the report deliberately overrides (D8's principle). `totalUnits` folds with `0LL` seeded (D9) and the binary-accumulate lambda from E25.

**Extensions.** ⭐ Add a transaction log (`vector<string>`) appended by every successful operation — the Files module's audit-log habit. ⭐⭐ Persist `receive`/`sell` history to a text file and replay on load (the format contract, one more time).

---

## Lab 3 — Student grade analyzer (`vector` + algorithms)

**Scenario.** A class's marks (0–100) need the full statistical story: pass rate, extremes, average, distribution.

**Requirements.**

- R1 — Load marks into a `vector<int>` (validated at input: reject out-of-range at the door).
- R2 — Report: count ≥ 50 and < 50 (`count_if` + lambdas), min/max (`min_element`/`max_element` with the empty guard), average (`accumulate`, `0LL` seed, double result), per-grade histogram A/B/C/D/F via `map<char,int>`.
- R3 — Top-3 marks, descending — via `priority_queue` (and note the alternative full-sort cost).
- R4 — Print everything with aligned columns (`<iomanip>`).

**Test data & expected results.**

| Marks | 72, 91, 45, 88, 67, 50, 99, 38, 76, 84 |
| --- | --- |
| pass / fail | 8 / 2 |
| min / max | 38 / 99 |
| average | 71.0 |
| histogram | A:2 B:3 C:2 D:1 F:2 |
| top-3 | 99, 91, 88 |

**Solution.**

```cpp
#include <iostream>
#include <vector>
#include <map>
#include <queue>
#include <algorithm>
#include <numeric>
#include <iomanip>
using namespace std;

char gradeOf(int m) {
    if (m >= 90) return 'A';
    if (m >= 80) return 'B';
    if (m >= 70) return 'C';
    if (m >= 60) return 'D';
    return 'F';
}

int main() {
    vector<int> marks = {72, 91, 45, 88, 67, 50, 99, 38, 76, 84};
    if (marks.empty()) { cout << "no data\n"; return 0; }

    int pass = count_if(marks.begin(), marks.end(), [](int m) { return m >= 50; });
    int fail = (int)marks.size() - pass;
    cout << "pass=" << pass << " fail=" << fail << "\n";

    cout << "min=" << *min_element(marks.begin(), marks.end())
         << " max=" << *max_element(marks.begin(), marks.end()) << "\n";

    double avg = accumulate(marks.begin(), marks.end(), 0LL) / (double)marks.size();
    cout << "avg=" << avg << "\n";

    map<char, int> hist;
    for (int m : marks) hist[gradeOf(m)]++;
    for (const auto& [g, n] : hist)
        cout << g << ": " << string(n, '*') << " (" << n << ")\n";

    priority_queue<int> pq(marks.begin(), marks.end());   // heap from a range!
    cout << "top-3: ";
    for (int i = 0; i < 3 && !pq.empty(); i++) {
        cout << pq.top() << " ";
        pq.pop();
    }
    cout << "\n";
    return 0;
}
```

**Expected output.**

```text
pass=8 fail=2
min=38 max=99
avg=71
A: ** (2)
B: *** (3)
C: ** (2)
D: * (1)
F: ** (2)
top-3: 99 91 88
```

**Explanation.** One container, five algorithms, zero index arithmetic. Two quiet techniques worth naming: the range constructor `priority_queue<int> pq(marks.begin(), marks.end())` heapifies in O(n) (the iterator glue paying off at construction); the histogram's `string(n, '*')` renders bars without a print loop (the Strings module's fill constructor, one last favour). The `avg` division coerces to double *before* dividing — the truncation trap guarded by hand.

**Extensions.** ⭐ Median via sort + middle (even-case averaging). ⭐⭐ The standard deviation via `accumulate` with a lambda that folds `(m − avg)²` — and the two-pass honesty note (avg must exist first).

---

## Lab 4 — Frequency counter (`unordered_map`)

**Scenario.** Word frequencies in a text: raw counts at hash speed, plus a "most common" query with a tie-broken order.

**Requirements.**

- R1 — `unordered_map<string, int>` counts from a word list.
- R2 — `mostCommon() -> pair<string,int>` — highest count; ties broken **alphabetically** (the tie rule makes the answer deterministic).
- R3 — `uniqueWords() -> int` (the map's size — derived, never stored).
- R4 — Normalize case at input (lowercase everything — canonicalization).

**Test data & expected results.**

| Words | the, cat, The, hat, the, cat, dog |
| --- | --- |
| counts (normalized) | the→3, cat→2, hat→1, dog→1 |
| mostCommon | (the, 3) |
| uniqueWords | 4 |

**Solution.**

```cpp
#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>
#include <cctype>
using namespace std;

string normalize(const string& w) {
    string lower = w;
    for (char& c : lower) c = (char)tolower((unsigned char)c);
    return lower;
}

class FrequencyCounter {
public:
    void add(const string& word) { counts[normalize(word)]++; }
    pair<string, int> mostCommon() const {
        pair<string, int> best{"", -1};
        for (const auto& [word, n] : counts)
            if (n > best.second || (n == best.second && word < best.first))
                best = {word, n};
        return best;
    }
    int uniqueWords() const { return (int)counts.size(); }
private:
    unordered_map<string, int> counts;
};
```

**Explanation.** The unordered pair is right here: the questions are pure membership/counting — no ordering ever requested (Lesson 2's decision procedure, applied). The tie-break walks the *unsorted* map comparing `(n, word)` lexicographically by hand — deterministic output from an unordered structure, which is the honest pattern when the data is huge and the query is rare (C14's graduation path states when it stops being honest). Normalization is canonicalization — the anagram challenge's trick, reused.

**Extensions.** ⭐ Add `topK(k)` (C2's heap pattern over the map). ⭐⭐ Load words from a file — the Files module's word-reading loop (`cin >> w`) feeding `add`.

---

## Lab 5 — Leaderboard (`priority_queue` + comparator discipline)

**Scenario.** A game leaderboard: players score points over time; the board always shows the current ranking, top wins.

**Requirements.**

- R1 — `record(name, points)` adds/accumulates a player's score (`unordered_map<string,long long>` — the update door).
- R2 — `topN(n) -> vector<pair<string,long long>>` sorted by score **descending**, ties by name **ascending**.
- R3 — `rankOf(name) -> int` (1-based position; 0 when absent).
- R4 — Serve `topN` from a `priority_queue` with the tie-broken comparator — the comparator defines "greatest", so *write it for the top you want* (D8's rule as the design centrepiece).

**Test data & expected results.**

| Action | Expected |
| --- | --- |
| record Aisha 90, record Omar 75, record Sana 90, record Aisha 5 | Aisha 95 |
| topN(3) | Aisha 95, Sana 90, Omar 75 (ties: Aisha before Sana — name asc) |
| rankOf("Sana") | 2 |
| rankOf("Zaid") | 0 |

**Solution.**

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <queue>
using namespace std;

class Leaderboard {
public:
    void record(const string& name, long long points) {
        scores[name] += points;              // insert-or-accumulate
    }
    vector<pair<string, long long>> topN(int n) const {
        auto cmp = [](const pair<string, long long>& a, const pair<string, long long>& b) {
            // "greatest" = higher score; tie -> the ALPHABETICALLY SMALLER name is "greater"
            if (a.second != b.second) return a.second < b.second;
            return a.first > b.first;
        };
        priority_queue<pair<string, long long>,
                       vector<pair<string, long long>>,
                       decltype(cmp)> pq(cmp);
        for (const auto& [name, score] : scores) pq.push({name, score});

        vector<pair<string, long long>> out;
        while (!pq.empty() && (int)out.size() < n) {
            out.push_back(pq.top());
            pq.pop();
        }
        return out;
    }
    int rankOf(const string& name) const {
        vector<pair<string, long long>> board = topN((int)scores.size());
        for (int i = 0; i < (int)board.size(); i++)
            if (board[i].first == name) return i + 1;
        return 0;
    }
private:
    unordered_map<string, long long> scores;
};
```

**Explanation.** The comparator comment is the lab: *it defines what "greatest" means* — higher score, and among equals the alphabetically-first name — so the heap pops the board in exactly the display order. `decltype(cmp)` names the comparator type (the Generics module's deduction, used for a purpose); the constructor passes the lambda through (a C++11-and-onwards idiom, stated once). `rankOf` reusing `topN` costs an O(n log n) sort per call — and the write-up names when that stops being acceptable (C14's set-of-pairs graduation).

**Extensions.** ⭐ Return the full ranked board and print with alignment. ⭐⭐ Maintain a live `set` of pairs on every `record` (erase the old, insert the new) — O(log n) updates, O(1) queries; write the flip-point paragraph against this lab's version.

---

## Lab 6 — Task queue (`queue` + `priority_queue` composition)

**Scenario.** A help desk: normal tickets wait FIFO; urgent tickets jump to a priority lane. Serve urgent-first, then oldest-normal.

**Requirements.**

- R1 — `add(task, isUrgent)`: urgent tasks enter `priority_queue<string>` (served alphabetically among urgents), normal enter `queue<string>`.
- R2 — `next() -> string` serves urgent first (when any exist), then normal; returns `"none"` when both empty.
- R3 — `pending() -> int` — both lanes summed (derived).
- R4 — State the container choice per lane in one sentence each (adapter discipline: the interface *is* the policy).

**Test data & expected results.**

| Action | Expected |
| --- | --- |
| add "billing", normal; add "install", normal; add "crash", urgent; add "bug", urgent | — |
| next() | **bug** (urgent lane, alphabetically first among urgents) |
| next() | crash |
| next() | billing (normal lane, FIFO) |
| next() | install |
| next() | none |

**Solution.**

```cpp
#include <iostream>
#include <queue>
#include <string>
using namespace std;

class HelpDesk {
public:
    void add(const string& task, bool urgent) {
        if (urgent) urgentLane.push(task);
        else normalLane.push(task);
    }
    string next() {
        if (!urgentLane.empty()) {
            string t = urgentLane.top();        // peek first...
            urgentLane.pop();                   // ...then pop (D7's two-step)
            return t;
        }
        if (!normalLane.empty()) {
            string t = normalLane.front();
            normalLane.pop();
            return t;
        }
        return "none";
    }
    int pending() const {
        return (int)urgentLane.size() + (int)normalLane.size();
    }
private:
    // "Most urgent" = alphabetically FIRST among urgents — so the comparator
    // must make the alphabetically SMALLER string the heap's "greatest"
    // (D8's rule: write the comparator for the top you want):
    priority_queue<string, vector<string>, greater<string>> urgentLane;
    queue<string> normalLane;   // adapter: "oldest first" as a policy
};

int main() {
    HelpDesk hd;
    hd.add("billing", false);
    hd.add("install", false);
    hd.add("crash", true);
    hd.add("bug", true);
    cout << hd.next() << "\n" << hd.next() << "\n" << hd.next() << "\n"
         << hd.next() << "\n" << hd.next() << "\n";
    return 0;
}
```

**Expected output.**

```text
bug
crash
billing
install
none
```

**Explanation.** Two adapters, two policies, zero manual ordering — and one deliberate design trap, named here so it never bites you silently: the default `priority_queue<string>` puts the **greatest** string on top, which is alphabetically *last* ("crash" over "bug") — the exact backwards-top surprise of debugging hunt D8. "Most urgent = alphabetically first" therefore needs the reversed comparator: `priority_queue<string, vector<string>, greater<string>>` makes the *smaller* string the heap's "greatest". The container-choice sentences: *the urgent lane's policy is "best first" → priority_queue, with a comparator written for the top we want; the normal lane's policy is "oldest first" → queue — and neither lane should ever expose its contents in bulk.*

**Extensions.** ⭐ Add timestamps and serve urgents FIFO-within-priority (`pair<int, int>` (priority-negative, arrival-seq) in the heap — C6's trick at mini scale). ⭐⭐ Log every serve to a file — the audit-log habit closing the course's loop.

---

## Where next

- [The Media Catalogue mini-project](miniproject.md): the families, working together.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
