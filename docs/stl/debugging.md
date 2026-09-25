---
title: "STL Debugging — 10 Seeded Hunts"
description: "Ten broken STL programs — the mutating lookup, iterator invalidation, sorted-output assumptions, adapter misuse — with separated diagnoses."
---

# Debugging — 10 seeded hunts

> [← Module home](index.md) · Each snippet compiles (or nearly) but misbehaves. Predict the symptom, form a hypothesis, *then* read the separated diagnosis.

---

## D1 — The lookup that multiplied

```cpp
#include <iostream>
#include <map>
#include <string>
using namespace std;

int main() {
    map<string, int> stock;
    stock["pen"] = 10;
    if (stock["pencil"] > 0)                 // "is pencil in stock?"
        cout << "pencil available\n";
    else
        cout << "no pencils\n";
    cout << "map size: " << stock.size() << "\n";   // expected: 1
    return 0;
}
```

The message is right; the size is wrong. What did the lookup do, and what are the two safe asks?

<details markdown="1">
<summary>Diagnosis</summary>

`stock["pencil"]` **insert-or-assigns**: on a miss it inserts `("pencil", 0)` and hands back a reference — the "lookup" grew the map to size 2 (the Lesson 2 §2 trap, in the wild). Safe asks: `if (stock.count("pencil") > 0)` or `auto it = stock.find("pencil"); if (it != stock.end())`. Rule: `[]` to write, `count`/`find` to ask.
</details>

---

## D2 — The set that wouldn't take four

```cpp
#include <iostream>
#include <set>
using namespace std;

int main() {
    set<int> ids;
    int values[] = {7, 7, 7, 9};
    for (int v : values) ids.insert(v);
    cout << ids.size() << "\n";      // programmer expected 4
    return 0;
}
```

Why is the size 2, and which container holds "every value including repeats"?

<details markdown="1">
<summary>Diagnosis</summary>

`set` keeps **unique keys** — the three 7s collapsed to one (size 2: {7, 9}). The insertions "failed" silently by design, which is exactly the contract, not a bug in the code — the bug is the *expectation*. For repeats: `multiset<int>` (sorted, duplicates allowed) or a `vector` + `count`. The lesson: choose containers by the duplicate question *before* the data arrives (the Records module's uniqueness invariant, library-enforced).
</details>

---

## D3 — The sorted output that wasn't

```cpp
#include <iostream>
#include <unordered_map>
#include <string>
using namespace std;

int main() {
    unordered_map<string, int> m = { {"pear", 2}, {"apple", 5}, {"fig", 7} };
    for (const auto& [k, v] : m)
        cout << k << " ";
    cout << "\n";        // programmer expected: apple fig pear
    return 0;
}
```

The counts are right; the order is a stranger's. Diagnose the expectation error and give the two honest fixes.

<details markdown="1">
<summary>Diagnosis</summary>

`unordered_map` iteration order is **unspecified** — hash-table order, not key order; expecting alphabetical output was the bug (Lesson 2 §3's "never rely"). Fixes: switch to `map<string,int>` (sorted-by-key iteration, O(log n) updates), or keep the unordered speed and sort the *keys* into a `vector<string>` when presentation order is needed (pay once at output, not per update).
</details>

---

## D4 — The loop that erased half

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {1, 2, 3, 4, 5, 6};
    for (size_t i = 0; i < v.size(); i++) {
        if (v[i] % 2 == 0) v.erase(v.begin() + i);
    }
    for (int x : v) cout << x << " ";
    cout << "\n";        // expected: 1 3 5
    return 0;
}
```

Trace the loop by hand — what actually happens at each erase, and what are the two correct erase-while-walking patterns?

<details markdown="1">
<summary>Diagnosis</summary>

Each `erase` **shifts the tail left**, so the index that was about to be examined now names the *next* element — which gets skipped. Trace: erase 2 (index 1) → {1,3,4,5,6}; i=2 sees 4 → erase → {1,3,5,6}; i=3 sees 6 → erase → {1,3,5}. It "works" here by luck of the data — change the input and elements survive that shouldn't (and the classic variant runs off the end entirely). Correct patterns: (1) the **erase-remove idiom** — `v.erase(remove_if(v.begin(), v.end(), [](int x){ return x % 2 == 0; }), v.end());` (the library's version of exactly this dance); (2) the manual iterator dance — `for (auto it = v.begin(); it != v.end(); ) { if (*it % 2 == 0) it = v.erase(it); else ++it; }` — the assignment re-validates the iterator, and `++` only on keep. Both encode the rule the hand loop violated: *erase changes the structure; the walk must re-anchor.*
</details>

---

## D5 — The `at` that threw, the `[]` that lied

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {10, 20, 30};
    cout << v[5] << "\n";          // line A
    cout << v.at(5) << "\n";       // line B
    return 0;
}
```

One of these throws a catchable exception; the other is undefined behaviour. Which is which, why does the library offer both, and which belongs where in this course's defensive rules?

<details markdown="1">
<summary>Diagnosis</summary>

**Line B** (`at`) throws `std::out_of_range` — catchable, named, located. **Line A** (`[]`) is unchecked — reading garbage or crashing, silently (the Pointers module's raw-array honesty, kept for performance parity with C). The library offers both because the checked form has a price and hot loops may pay it deliberately. The course's allocation of the pair: `[]` **inside** code that has already bounds-validated (loops bounded by `size()`); `at` at **boundaries and with external data** — the defensive-programming rule (validate at the door, trust inside) applied to the library's own API.
</details>

---

## D6 — The iterator that outlived its container

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {1, 2, 3};
    auto it = v.begin();
    int first = *it;               // fine: 1
    for (int i = 0; i < 100; i++) v.push_back(i);
    cout << *it << "\n";           // ← what happens here?
    return 0;
}
```

What may happen at the last line, which operation invalidated `it`, and what is the safe ordering of "remember a position" vs "grow the container"?

<details markdown="1">
<summary>Diagnosis</summary>

`push_back` may have **reallocated** (capacity grew past its old block) — `it` points into freed memory; dereferencing is undefined behaviour (garbage, crash, or — worst — *seemingly fine*). The invalidating operation: any growth that reallocated (insert/erase likewise). Safe ordering: **take iterators after the last structural change**; if you must hold across mutations, re-take `begin()` after, or hold an *index* into a vector (indices survive; addresses don't) — or choose `list`/`set`, whose iterators survive non-erasing changes (Lesson 3 §1's stability table).
</details>

---

## D7 — The stack that peeked wrong

```cpp
#include <iostream>
#include <stack>
using namespace std;

int main() {
    stack<int> s;
    s.push(5);
    s.push(9);
    cout << s.pop() << "\n";       // "remove and return the top" — intended 9
    return 0;
}
```

This doesn't compile — and the *design* behind the compile error is the lesson. Explain why `pop` returns nothing, and write the correct two-step.

<details markdown="1">
<summary>Diagnosis</summary>

`pop()` returns **`void`** — deliberately. If it returned the top, the return would require a copy *after* removal, which cannot throw safely (the library's exception-safety history — summarized honestly: separating peek from pop lets each operation guarantee what it does). The two-step: `int top = s.top(); s.pop();` — test-then-use, the course's standing rule in adapter clothing. (Forgetting `empty()` before `top`/`pop` is the companion bug — the guard clause lives here too.)
</details>

---

## D8 — The priority that came out backwards

```cpp
#include <iostream>
#include <queue>
#include <vector>
using namespace std;

struct Task { string name; int urgency; };   // 1 = most urgent

int main() {
    priority_queue<Task> pq;
    pq.push({"email", 3});
    pq.push({"fire", 1});
    pq.push({"report", 2});
    cout << pq.top().name << "\n";   // intended: fire (urgency 1) — got: report
    return 0;
}
```

Wait — this doesn't compile either (Task has no `<`). After adding a member `operator<` returning `urgency < other.urgency`, why does `report` come out on top, and what are the two honest cures?

<details markdown="1">
<summary>Diagnosis</summary>

`priority_queue` puts the **largest** element on top *by the comparator* — and `urgency < other.urgency` declares *higher number = larger*, so urgency 2 outranks 1: "report" on top is the contract working against the intention. Cure 1: **reverse the comparator** — `return urgency > other.urgency;` (the "smallest on top" convention from E9). Cure 2: define urgency so bigger-is-more-urgent (score 1→3 scale) — fix the *model*, not the comparator, when the domain allows. Both cures encode the rule: *the comparator defines "greatest"; priority_queue hands you the greatest — write the comparator for the top you want.*
</details>

---

## D9 — The accumulate that overflowed

```cpp
#include <iostream>
#include <vector>
#include <numeric>
using namespace std;

int main() {
    vector<int> sales = {1500000000, 1400000000};
    int total = accumulate(sales.begin(), sales.end(), 0);
    cout << total << "\n";     // expected 2900000000
    return 0;
}
```

What does this print (and why is it *not* an error), and what single token fixes it? State the general rule for seeds.

<details markdown="1">
<summary>Diagnosis</summary>

Prints a **wrapped negative** (or similar garbage) — the seed `0` made the accumulator an `int`, and 2.9 billion overflows int: signed overflow is undefined behaviour, silently accepted here. Fix: seed `0LL` (`long long` total) — the seed's *type* is the accumulator's type. General rule: **choose the seed for the arithmetic the whole sum needs**, not the type of one element (the same rule that chose `0.0` for averages — the Foundations module's conversion traps, resident in one parameter).
</details>

---

## D10 — The audit: three bugs, one program

```cpp
#include <iostream>
#include <map>
#include <vector>
#include <string>
using namespace std;

int main() {
    map<string, int> marks;
    marks["Aisha"] = 91;
    marks["Omar"] = 84;
    marks["Sana"] = 77;

    vector<string> names = {"Aisha", "Omar", "Zaid", "Sana"};
    for (const string& n : names) {
        if (marks[n] > 80)                       // line A
            cout << n << " passed\n";
    }

    for (auto& [name, score] : marks)
        score += 2;                              // line B (curve)

    map<string, int>::iterator it = marks.begin();
    cout << "first: " << it->first << "\n";
    marks["Zaid"] = 66;                          // line C
    cout << "first still: " << it->first << "\n"; // line D

    return 0;
}
```

Find all three defects before reading the list — classify each: mutating lookup, reference invalidation, or iterator invalidation.

<details markdown="1">
<summary>Diagnosis</summary>

**Line A — mutating lookup:** `marks[n]` on "Zaid" (absent) *inserts* ("Zaid", 0) — the membership test grows the map and, worse, **prints "Zaid passed\n" never** but "Zaid" now occupies memory with a 0 that later code may read as data; use `find`/`count`. (D1's hunt, third appearance this module — it earns the repetition.) **Line B — clean, deliberately:** the structured-binding `auto&` mutation is legal and updates the map in place — the audit includes one clean line so the fix-list doesn't become a reflex; the curve works. **Lines C/D — the audit's real lesson:** `marks["Zaid"] = 66` inserts a node; for `map`, insertion **does not** invalidate other iterators (node-based structure), and "Zaid" sorts last — so "first" survives *here*. But the same two lines against a `vector` (D6) or an `unordered_map` (no guarantee at all) would break — this is a **latent** bug: legal for `map` today, broken the day the container changes. Classify: A is a bug, B is clean, C/D is a contract dependency. Verdict order: mutating lookup → reference check → invalidation contract.
</details>

---

## Fix-list recap

| Hunt | Bug class | Prevention rule |
| --- | --- | --- |
| D1 | mutating lookup | `[]` writes; `count`/`find` ask |
| D2 | uniqueness expectation | choose the container for the duplicate answer |
| D3 | unordered-order assumption | sorted pair for ordered output |
| D4 | erase-while-walking | erase-remove idiom; re-anchor the walk |
| D5 | `[]` vs `at` | `at` at boundaries; `[]` only post-validation |
| D6 | stale iterator | iterators after the last mutation; indices into vectors |
| D7 | pop-with-return expectation | `top` then `pop`; guard `empty()` |
| D8 | comparator defines "greatest" | write the comparator for the top you want |
| D9 | seed type | the seed is the accumulator's type |
| D10 | three-for-one audit | lookup → reference → invalidation contract |

## Where next

- [Challenges](challenges.md): fifteen builds.
- [Labs](labs.md): six container-family scenarios.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
