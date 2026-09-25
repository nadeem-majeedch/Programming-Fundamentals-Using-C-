---
title: "Lesson 3 — Iterators, Algorithms, and Lambdas"
description: "Iterators as the glue between containers and algorithms, the half-open range convention, the everyday algorithms (sort, find, count, reverse, min/max, accumulate), and introductory lambdas."
---

# Lesson 3 — Iterators, Algorithms, and Lambdas

> [← Module home](index.md) · [← Lesson 2 — Associative containers](lesson-2-associative.md)

## In this lesson you will learn

- **iterators** — generalized positions, the `[begin, end)` convention, and why they make algorithms container-independent
- the **range-based loop** and what it compiles to
- the everyday algorithms: **`sort`, `find`, `count`, `reverse`, `min_element`/`max_element`, `accumulate`**
- **lambdas** at an introductory level — unnamed functions where they're used

---

## 1. Iterators — positions, not indices

An **iterator** is an object that *points into a container* and can move to the next element — a generalization of the index that works on structures with no indices (`list`, `set`). Every container provides:

- `begin()` — an iterator to the **first** element
- `end()` — an iterator to **one past the last** element (a position, not an element)

The `[begin, end)` **half-open convention** — the exact convention the search algorithms and Files module taught (`lo <= hi`, the read-until-fail loop) — is the STL's universal contract. It survives the empty case gracefully: `begin() == end()` *means empty*, no special code.

```cpp
#include <iostream>
#include <vector>
#include <list>
using namespace std;

int main() {
    vector<int> v = {10, 20, 30};
    list<int> l = {10, 20, 30};

    // the same loop shape serves both:
    for (auto it = v.begin(); it != v.end(); ++it) cout << *it << " ";
    cout << "\n";
    for (auto it = l.begin(); it != l.end(); ++it) cout << *it << " ";
    cout << "\n";

    // iterator arithmetic: vector iterators can jump; list iterators cannot
    auto mid = v.begin() + 2;      // O(1) on vector
    cout << *mid << "\n";          // 30
    // auto m2 = l.begin() + 2;    // ← compile error: list iterators only step ++/--
    return 0;
}
```

**The one rule with teeth:** *an iterator into a container dies when the container changes size* — after `push_back` may invalidate, after insert/erase definitely does (the hunting ground of [debugging D6](debugging.md)). Store iterators for the duration of a computation, not across mutations.

**`auto`'s honest debut here:** iterator types are unspellable (`std::vector<int>::iterator`) — this is the syllabus's `auto` use case: *let the compiler state the type you'd only misstate*. The Generics module's deduction lesson applies: `auto` deduces, exactly as `T` did.

---

## 2. Range-based loops — the everyday form

```cpp
vector<int> v = {1, 2, 3};

for (int x : v)        cout << x;   // a copy per element — fine for int
for (int& x : v)       x *= 2;      // mutate through a reference
for (const string& s : words) cout << s;   // big types: const& — no copies (the standing rule)
for (const auto& [k, v2] : myMap) ...     // structured bindings unpack map pairs (C++17)
```

The three-body rule from the OOP module's collections lesson, now the house style: **copy for small types, `&` to mutate, `const&` to read** — and `auto` whenever the spelled type adds noise.

---

## 3. The everyday algorithms

Algorithms live in `<algorithm>` (`<numeric>` for `accumulate`) and take **iterator ranges** — which is why one `sort` serves `vector`, `deque`, `array`, and even `string`, and why the sorted containers can't be sorted again (they're always sorted; the tree is the order).

### `sort` — and the comparator parameter

```cpp
#include <algorithm>
#include <vector>
#include <string>
using namespace std;

vector<int> v = {5, 1, 9, 3};
sort(v.begin(), v.end());                 // ascending — needs < on T (the contract, again)

vector<string> names = {"Omar", "Aisha", "Zaid"};
sort(names.begin(), names.end());         // lexicographic

// a custom order — the comparator, the Generics module's Student lab shape:
sort(v.begin(), v.end(), [](int a, int b) { return a > b; });   // descending
```

O(n log n) — the Algorithms module's merge-sort ceiling, in one call. The comparator (a *function, lambda, or functor* — any callable) is the `bool (*)(const T&, const T&)` parameter you wrote in the Student-comparison lab, generalized.

### `find` — the linear scan, genericized

```cpp
auto it = find(v.begin(), v.end(), 9);
if (it != v.end())                        // THE test — find reports by position
    cout << "found at index " << (it - v.begin()) << "\n";
else
    cout << "absent\n";
```

`find` returns an **iterator** — either at the match or at `end()`. The `!= end()` test is the library's "−1 convention" (Algorithms module), iterator edition. The subtraction `it - v.begin()` recovers the index — legal on vector iterators, which is another way of saying "random access."

### `count` — the frequency question

```cpp
int n9s = count(v.begin(), v.end(), 9);           // exact value
int big  = count_if(v.begin(), v.end(),
                    [](int x) { return x > 4; }); // with a predicate
```

`count` asks "how many equal"; `count_if` asks "how many satisfy" — the predicate version of the tally (the Algorithms module's countOccurrences, library form).

### `reverse` — in-place reversal

```cpp
reverse(v.begin(), v.end());      // the two-pointer swap you wrote, done
```

### `min_element` / `max_element` — the champion passes

```cpp
auto lo = min_element(v.begin(), v.end());   // iterator to the smallest
auto hi = max_element(v.begin(), v.end());   // iterator to the largest
if (lo != v.end()) cout << *lo << " .. " << *hi << "\n";
```

Both return **iterators** — test against `end()` before dereferencing (the empty case, always). The index-tracking champion from the Arrays module, expressed without the index.

### `accumulate` — the sum, generalized

```cpp
#include <numeric>
// ...
long long total = accumulate(v.begin(), v.end(), 0LL);   // seed type matters!
double avg = accumulate(v.begin(), v.end(), 0.0) / v.size();
```

The accumulator pattern from the Iteration module, as one call. **The seed is the accumulator's type** — `0` would sum ints (and overflow like one); `0LL` (long long) or `0.0` (double) set the working type. The foundations module's division/conversion traps all live in that seed.

### The map, one screen

| Algorithm | Header | Answers | Returns | Contract on T |
| --- | --- | --- | --- | --- |
| `sort` | `<algorithm>` | orders the range | void | `<` (or comparator) |
| `find` | `<algorithm>` | is x present, where | iterator (or `end`) | `==` |
| `count` / `count_if` | `<algorithm>` | how many | integer | `==` / predicate |
| `reverse` | `<algorithm>` | mirror the range | void | — |
| `min_element` / `max_element` | `<algorithm>` | where is the extreme | iterator (or `end`) | `<` |
| `accumulate` | `<numeric>` | fold the range to one value | seed's type | `+`, copyable |

---

## 4. Lambdas — unnamed functions at the point of use

```cpp
auto isEven = [](int x) { return x % 2 == 0; };      // a function in a variable
cout << count_if(v.begin(), v.end(), isEven) << "\n";

int threshold = 5;                                    // capturing the surroundings:
int nBig = count_if(v.begin(), v.end(),
                    [threshold](int x) { return x > threshold; });
```

Anatomy: `[capture](parameters) { body }` — brackets hold what's *captured* from the enclosing scope (`threshold` by value here; `&` captures by reference — the two names to know), the parameters are ordinary, the body is ordinary. **The introductory rules this course endorses:** (1) lambdas are for *short predicates and comparators at the call site* — `[](int a, int b){ return a > b; }` beats a named five-line function used once; (2) capture explicitly (`[threshold]`, `[&total]`) — the empty `[]` and the greedy `[=]`/`[&]` are the next course's subtlety traps; (3) anything longer than two lines earns a **name** (a free function) — the Debugging module's one-job rule applies to unnamed code too.

**The connection:** every lambda here could be the function pointer from the Student-comparison lab — same role, tighter spelling, and the capture list is the one thing a plain pointer couldn't carry.

---

## Check yourself

- Why does `begin() == end()` gracefully mean "empty"? (half-open ranges: zero elements is exactly the positions coinciding — no special case)
- `find` on a missing value returns what, and what's the test? (the `end()` iterator; `!= end()` before dereferencing)
- What did the seed `0` vs `0LL` change in `accumulate`? (the accumulator's type — int overflow vs long long safety)

## Where next

- [Exercises](exercises.md): 26 drills across the three lessons.
- [Labs](labs.md): six container-family builds.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
