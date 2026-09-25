---
title: "Lesson 2 — Associative Containers: set, map, and the Unordered Pair"
description: "The four associative containers — sorted trees versus hash tables, the comparison tables, key requirements, and the when-to-use rules."
---

# Lesson 2 — Associative Containers

> [← Module home](index.md) · [← Lesson 1 — Sequence containers](lesson-1-sequence.md) · [Lesson 3 — Iterators and algorithms →](lesson-3-iterators-algorithms.md)

## In this lesson you will learn

- `set` and `map` — sorted, tree-backed containers that **find by key** in O(log n)
- `unordered_set` and `unordered_map` — hash-table versions that find in **O(1) average**
- the key requirements (`<` vs hash+equality) and what each table promises
- the when-to-use rules, including the ordering bonus only the sorted containers give

**The connection that opens the lesson:** the Arrays module's frequency counter used a "tally array indexed by data" — brilliant for small dense keys, impossible for names. The Files module's roster searched by roll number with a linear scan, then earned a binary search *by paying for sortedness*. Associative containers are both ideas, industrialized: **find by key, at the speed the data structure can afford.**

---

## 1. `set` — unique keys, kept sorted

```cpp
// sets.cpp — Programming Fundamentals Using C++
// STL module · Lesson 2 · set and map
// Compile: g++ -std=c++17 -Wall -Wextra sets.cpp -o sets

#include <iostream>
#include <set>
using namespace std;

int main() {
    set<int> s;
    s.insert(3);
    s.insert(1);
    s.insert(4);
    s.insert(1);                    // duplicate — silently ignored
    cout << "size = " << s.size() << "\n";      // 3 — the second 1 never entered

    cout << boolalpha;
    cout << s.count(4) << "\n";     // 1 — present (O(log n))
    cout << s.count(9) << "\n";     // 0 — absent

    for (int x : s)                 // walks in SORTED order — always
        cout << x << " ";
    cout << "\n";                   // 1 3 4
    return 0;
}
```

**What `set` promises:** no duplicates; membership in **O(log n)**; iteration in **sorted order, always** — the sortedness is not a service you maintain, it's the structure itself (the binary-search precondition, satisfied by construction). Backed by a balanced tree; every element is its own key.

---

## 2. `map` — key → value pairs, kept sorted

```cpp
#include <iostream>
#include <map>
#include <string>
using namespace std;

int main() {
    map<string, long long> population;              // key: city — value: people
    population["Lahore"] = 13000000;                // insert-or-assign
    population["Karachi"] = 16000000;
    population["Lahore"] = 13100000;                // same key: OVERWRITES (no duplicate keys)

    cout << population["Lahore"] << "\n";           // 13100000 — O(log n) lookup

    cout << population.count("Multan") << "\n";     // 0 — the safe membership test
    cout << population["Multan"] << "\n";           // 0 — ⚠ and it INSERTED a zero entry!
    cout << population.size() << "\n";              // 3 — the lookup grew the map

    for (const auto& [city, people] : population)   // structured bindings (C++17) — sorted by key
        cout << city << ": " << people << "\n";
    return 0;
}
```

**The one trap of the lesson, in the code above:** `population["Multan"]` on a missing key **inserts a default value and returns a reference to it** — a lookup that mutates. The safe read is `count(key)` or (Lesson 3) `find`. Rule: **use `[]` to insert/assign; use `count`/`find` to ask.** (Debugging hunt D4 seeds exactly this.)

**`map`'s promises:** unique keys; find/insert/erase in **O(log n)**; iteration **sorted by key** — the roster's "list in roll order" requirement, free. The `pair<const Key, Value>` elements unpack beautifully with structured bindings — the syllabus's structured-bindings topic, arriving where it's useful.

---

## 3. `unordered_set` and `unordered_map` — the hash-table pair

```cpp
#include <unordered_set>
#include <unordered_map>
// ...
unordered_set<string> seen;
seen.insert("aisha");
cout << seen.count("aisha") << "\n";        // 1 — O(1) average

unordered_map<string, int> marks;
marks["physics"] = 88;                       // insert-or-assign, O(1) average
cout << marks["physics"] << "\n";
// iteration order: UNSPECIFIED — do not rely on it, ever
```

**The trade, stated:** hash tables pay **O(1) average** lookups for three costs — **no ordering** (iteration order is unspecified and may change), a **hash + equality requirement** on the key (the standard types have both; your classes need `operator==` and a hash — next-course territory, named here), and **O(n) worst case** when the table degenerates. For membership questions ("have I seen this word?"), the unordered pair is usually the right tool; for *ordered* questions ("top 3 scores in order"), the sorted pair is.

---

## 4. The comparison tables — sorted vs unordered, and the whole family

**Sorted vs hashed, the decision table:**

| | `set` / `map` | `unordered_set` / `unordered_map` |
| --- | --- | --- |
| Find | O(log n) | **O(1) average**, O(n) worst |
| Iteration order | **sorted by key** | unspecified — never rely |
| Key requirement | `operator<` (strict weak order) | hash + `==` |
| Range queries (all keys in [a,b]) | ✅ natural | ❌ must scan everything |
| Predictable worst case | ✅ | ❌ (hash attacks/degenerate tables) |
| Use when | you need order, ranges, or stable worst case | you need raw speed on membership |

**The whole family, one screen:**

| Container | Keeps | Find | Ordered? | One-line use |
| --- | --- | --- | --- | --- |
| `set<K>` | unique keys | O(log n) | ✅ | seen-lists, sorted unique values |
| `map<K,V>` | unique key→value | O(log n) | ✅ | rosters, dictionaries, indexes |
| `unordered_set<K>` | unique keys | O(1) avg | ❌ | membership, dedup at speed |
| `unordered_map<K,V>` | unique key→value | O(1) avg | ❌ | counters, caches, lookups |

**The decision procedure, compressed:** *is the question "have I seen / how many of X" with no order needed? → unordered. Does the answer need to come out sorted, or range? → the sorted pair. Is the key a `string`/`int` (hashable) with no order requirement? → unordered wins on speed.*

---

## 5. The multiset/multimap footnote (honest scope)

`multiset` and `multimap` allow duplicate keys — real tools, used in leaderboards-with-ties and indexes-with-multiples. This course names them and moves on: every pattern here transfers directly, and duplicate keys are a design decision you should make *consciously* (the Records module's duplicate-refusal invariants argued for uniqueness; the leaderboard lab will meet ties honestly).

---

## Check yourself

- Why did `population["Multan"]` grow the map — and what are the two safe reads? (`[]` insert-or-assigns on a miss; `count(key)` and `find(key)` ask without inserting)
- A word-frequency counter needs "which word appeared most" — which container family, and why not the sorted one? (`unordered_map<string,int>` — pure membership/counting at O(1); the sorted pair would pay O(log n) per update for an ordering the question never uses)
- Your `Student` class as a `map` key: which requirement must it meet, and which container takes a hash instead? (`operator<` for `map`/`set`; hash + `==` for the unordered pair)

## Where next

- [Lesson 3 — Iterators, algorithms, and lambdas →](lesson-3-iterators-algorithms.md): the glue that makes every container interchangeable.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
