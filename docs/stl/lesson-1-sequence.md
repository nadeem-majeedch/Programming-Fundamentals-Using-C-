---
title: "Lesson 1 — Sequence Containers: vector, array, deque, list, and the Adapters"
description: "The five sequence containers and three adapters — each connected to its hand-made ancestor, with the complexity-promise table and the when-to-use rules."
---

# Lesson 1 — Sequence Containers

> [← Module home](index.md) · [Lesson 2 — Associative containers →](lesson-2-associative.md)

## In this lesson you will learn

- the four **sequence containers** — `vector`, `array`, `deque`, `list` — and what each promises
- the three **container adapters** — `stack`, `queue`, `priority_queue` — and why they *hide* their container
- the **choice table**: where each container's fast operations live
- how each connects to machinery you hand-built earlier in this course

---

## 1. `vector` — the default container (and your Box, grown up)

```cpp
// vectors.cpp — Programming Fundamentals Using C++
// STL module · Lesson 1 · vector, the default
// Compile: g++ -std=c++17 -Wall -Wextra vectors.cpp -o vectors

#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> v;                     // empty — it will grow
    for (int x : {3, 1, 4, 1, 5})
        v.push_back(x);                // append at the end

    cout << "size = " << v.size() << "\n";
    cout << "second = " << v[1] << "\n";        // fast random access
    cout << "second = " << v.at(1) << "\n";     // same, but bounds-checked (throws)

    v[0] = 42;                          // update in place
    for (int x : v) cout << x << " ";   // range-based loop
    cout << "\n";

    v.pop_back();                       // remove the last element
    cout << "now size = " << v.size() << "\n";
    return 0;
}
```

**Output:**

```text
size = 5
second = 1
second = 1
42 1 4 1 5 
now size = 4
```

**The connection you already own.** The Pointers module's Quiz Runner grew a raw array by hand — allocate bigger, copy, delete, re-point (the `grow` function you debugged in the Debugging module's P19). `vector` **is** that machinery, done once, professionally: contiguous memory, amortized growth, `size()` carried for you, the double-free family made impossible. The Generics module's `Box<T>` added the guarded doors; `vector` has its own (`at` throws, `[]` trusts — the same two conventions you implemented).

**What vector promises:** index access in **O(1)**; append at the end amortized **O(1)**; insert/erase *in the middle* **O(n)** (everything after the point shifts — your arrays module's "unchecked middle-insert" cost, formalized). **The course rule, stated plainly: `vector` is the default container.** Reach for another only with a reason from the choice table (§5).

**Capacity vs size, one last time:** the Arrays module's distinction returns as `size()` (elements in use) and `capacity()` (slots allocated). `vector` never shrinks its allocation on `pop_back` — harmless, and worth knowing when reading memory profiles someday.

---

## 2. `array` — the fixed-size stack array, honest about its size

```cpp
#include <array>
// ...
array<int, 5> a = {1, 2, 3, 4, 5};
a[2] = 30;
cout << a.size() << "\n";            // 5 — the C array never told you this
```

**The connection:** the course's `int marks[3]` was a C array — fast, fixed, and silent about its own length (the P13 hunt: the caller had to be trusted with the bound). `std::array<T, N>` wraps exactly that memory plus `size()`, bounds-checked `at`, and STL algorithm compatibility. Same performance, no new knowledge required of the caller. **Use it when the size is a compile-time fact** — the three quizzes, the four suits, the seven days.

---

## 3. `deque` — the double-ended queue

```cpp
#include <deque>
// ...
deque<int> d = {2, 3};
d.push_front(1);        // O(1) at the FRONT — vector can't do this
d.push_back(4);         // O(1) at the back
// d is now 1 2 3 4, fast at both ends, indexable in O(1)
```

**The connection:** the Iteration module's queue-at-the-counter used a `vector` with expensive front removals (every element shifted). `deque` is segmented memory: fast at **both** ends, still indexable. **Use it when you push/pop at both ends** — sliding windows, undo history with a cap, work items that arrive at the front.

---

## 4. `list` — the linked list, and the honesty about when you need it

```cpp
#include <list>
// ...
list<int> l = {3, 1, 2};
l.push_front(0);                    // O(1) front AND back
auto it = next(l.begin());          // iterators (Lesson 3) name positions
l.insert(it, 99);                   // O(1) insert at a *known position*
l.remove(2);                        // O(n) search + remove by value
// no l[3] — no random access. Traversal walks nodes.
```

**The connection:** the Pointers module taught you nodes and arrows by hand — `list` is a doubly-linked list of exactly that shape, with the memory management done. Its honest selling points: O(1) insert/erase *at an iterator you're already holding*, and stable addresses (elements never move). Its honest costs: **no `[]`** (walking is pointer-chasing, cache-unfriendly), more memory per element. The professional wisdom this course endorses: **`list` is chosen far more often than it's needed** — most "I need a list" cases are vector cases (or `deque`). Choose it for the iterator-stable insert/erase story, not by default.

---

## 5. The adapters — `stack`, `queue`, `priority_queue`

**Adapters wrap a container and deliberately expose less** — the OOP module's encapsulation at library scale: the interface *is* the data structure.

```cpp
#include <stack>
#include <queue>
// ...
stack<int> s;
s.push(1); s.push(2); s.push(3);
cout << s.top() << "\n";   // 3  — last in...
s.pop();                   //      ...first out

queue<int> q;
q.push(1); q.push(2); q.push(3);
cout << q.front() << "\n"; // 1  — first in...
q.pop();                   //      ...first out

priority_queue<int> pq;
pq.push(3); pq.push(9); pq.push(1);
cout << pq.top() << "\n";  // 9  — the LARGEST, always on top
```

**The connections:** the Inheritance module's TokenQueue (challenge C4) was a hand-built `queue`; the recursion module's call stack was the story of a `stack`; the leaderboard and top-k problems you've met are `priority_queue`'s home turf (the Heaps ancestor from the Algorithms module's "seed of" notes).

| Adapter | Discipline | Backbone (default) | The one use-sentence |
| --- | --- | --- | --- |
| `stack` | LIFO — `top`, `push`, `pop` | `deque` | undo, matching brackets, depth-first anything |
| `queue` | FIFO — `front`, `push`, `pop` | `deque` | counters, breadth-first, task pipelines |
| `priority_queue` | best-out — `top`, `push`, `pop` | `vector` (heap-ordered) | top-k, schedulers, Dijkstra later |

**Two honesty notes:** `pop()` returns nothing (check `top()` *first* — the P19-style test-before-use rule, library form); and `priority_queue` puts the **largest** on top by default — the Reversed-comparison surprise is debugging hunt D8's seed.

---

## 6. The choice table — the whole lesson on one screen

| Container | Index `[]`? | Fast at front? | Fast middle insert? | Sorted? | Use when |
| --- | --- | --- | --- | --- | --- |
| **`vector`** | ✅ O(1) | ❌ O(n) | ❌ O(n) | no | **the default** — append, walk, index |
| **`array`** | ✅ O(1) | — (fixed) | — | no | compile-time-known size |
| **`deque`** | ✅ O(1) | ✅ O(1) | ❌ O(n) | no | both ends active |
| **`list`** | ❌ | ✅ O(1) | ✅ O(1)* | no | *at an iterator you hold; stable addresses |
| **`stack`** | ❌ | — | — | — | LIFO discipline |
| **`queue`** | ❌ | — | — | — | FIFO discipline |
| **`priority_queue`** | ❌ | — | — | by priority | always need the current best |

**The decision procedure, compressed:** *start with `vector`; upgrade only when a measured or structural need appears — both-ends activity (deque), iterator stability (list), or a discipline the adapter should enforce (the adapters).*

---

## Check yourself

- Why is `v.insert(v.begin() + 2, x)` O(n) while `v.push_back(x)` is O(1)? (everything after the insertion point shifts — the contiguous-memory promise has a middle-insert price)
- What does the adapter design *hide*, and why is hiding the point? (the backbone container and all its other operations — the interface is the discipline; a `stack` you can index isn't a stack)
- A leaderboard needs the current best at all times under pushes. Which adapter, and what sits on top by default? (`priority_queue`; the largest)

## Where next

- [Lesson 2 — Associative containers →](lesson-2-associative.md): the containers that *find* in O(log n) — and O(1).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
