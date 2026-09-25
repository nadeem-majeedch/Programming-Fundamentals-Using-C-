---
title: "STL Exercises — 26 Drills in Three Parts"
description: "Part A sequence containers, Part B associative containers, Part C iterators/algorithms/lambdas — each with a separated solution."
---

# Exercises — 26 drills, three parts

> [← Module home](index.md) · Attempt before opening solutions — separated below each part. Compile with `-std=c++17 -Wall -Wextra`; the drills are designed for the compiler conversation.

## Part A — Sequence containers (E1–E9)

- **E1 ★** Build a `vector<int>` from `{3,1,4,1,5}` with `push_back`, print `size()`, the second element via `[]` and via `at()`, then `pop_back()` and reprint the size.
- **E2 ★** Read n numbers from `cin` into an (initially empty) `vector<int>`, then print them reversed — using `[]` with a backwards loop.
- **E3 ★** Repeat E2's reversal with `reverse()` from `<algorithm>` — then explain in one sentence why the library version is preferable to the hand loop.
- **E4 ★** Declare `array<int, 7> days` of weekday numbers and print `days.size()` *without* passing the size anywhere. What did the C array version of this require?
- **E5 ★★** A `deque<int>` models a print queue where urgent jobs go to the front: implement "normal job arrives" and "urgent job arrives" as one-liners, then drain the queue printing the order.
- **E6 ★★** Use a `list<int>` for a playlist: `push_back` four tracks, insert a new track *at position 2* using `next(begin(), 1)`, then try `l[2]` — quote the compiler error and explain it.
- **E7 ★★** Build the bracket-matching checker with `stack<char>`: `({[]})` balanced, `([)]` not. State the LIFO rule that makes the algorithm work.
- **E8 ★★** A `queue<string>` models a service counter: enqueue three names, serve two, print who's at the front. Then answer: which container *did* the Iteration module's TokenQueue hand-build, and what did the adapter delete from that code?
- **E9 ★★★** A `priority_queue<int>` receives task priorities `{3, 9, 1, 9, 5}` and serves four tasks. Print each served priority in order. Then a `priority_queue` of a custom `Task` struct (name, priority) must put *smallest* priority first — write the comparator lambda and state which two operations `top`/`push` now use.

### Solutions A

**S1.** As in Lesson 1's program: size 5, `v[1]` and `v.at(1)` both `1`, after `pop_back` size 4. The `at`/`[]` pair is the trust/check distinction the Arrays module taught, library form.

**S2.** `vector<int> v; int n, x; cin >> n; while (n--) { cin >> x; v.push_back(x); } for (int i = (int)v.size() - 1; i >= 0; i--) cout << v[i] << " ";` — the empty vector grows by appends; no capacity ever mentioned.

**S3.** `reverse(v.begin(), v.end()); for (int x : v) cout << x << " ";` — the sentence: *the library version names the intent (`reverse`), works on any reversible container, and carries no index-arithmetic bugs* — the loop's shape matched a named algorithm, so the loop was replaced.

**S4.** `array<int, 7> days = {1,2,3,4,5,6,7}; cout << days.size();` — the C-array version required passing `7` alongside everywhere (the size-travels-separately rule, P13's hunt) or a macro; the wrapper carries the size in the type.

**S5.** Normal: `q.push_back(job);` urgent: `q.push_front(job);` drain: `while (!q.empty()) { cout << q.front() << " "; q.pop_front(); }` — both ends O(1), which is exactly the deque promise (a vector's `push_front` would be O(n) shifting).

**S6.** `auto it = next(l.begin(), 1); l.insert(it, track);` — the `l[2]` attempt fails: *"no operator '[]' matches"* — `list` has no random access; positions are iterator-walked (Lesson 1 §4's pointer-chasing cost).

**S7.** Openers push; on a closer, the stack top must be the matching opener — else unbalanced; balanced at end iff the stack is empty. `({[]})`: each closer meets its own opener because the *most recently opened* is always on top — the LIFO rule *is* the nesting rule (the recursion module's call-stack discipline in data).

**S8.** `queue<string> q; q.push("Aisha"); ... cout << q.front(); q.pop();` — the TokenQueue hand-built a `vector` plus front-index; the adapter deleted the index management, the front-removal shifting, and the empty-check from the user's code.

**S9.** Served: `9 9 5 3` (largest first, duplicates preserved in the heap). Smallest-first comparator: `auto cmp = [](const Task& a, const Task& b) { return a.priority > b.priority; }; priority_queue<Task, vector<Task>, decltype(cmp)> pq(cmp);` — the two operations (`top`, `push`) now order by the comparator; the *reversed* comparison is the convention for "smallest on top" (D8's seed, met here by design).

## Part B — Associative containers (E10–E18)

- **E10 ★** Insert `{5, 3, 9, 3, 1}` into a `set<int>`; print `size()` and the range-based loop — explain both outputs.
- **E11 ★** Build a `map<string, int>` of three course enrollments; overwrite one; print all pairs with structured bindings — and state the iteration order's guarantee.
- **E12 ★** A word counter: `unordered_map<string, int>` over `{"the","cat","the","hat","the"}`; print each word's count. What's the requirement on `string` that makes this work?
- **E13 ★★** Demonstrate the `map::[]` trap: on an empty `map<string,int>`, call `m["x"]` as a *read*, print `m.size()`, then fix the read with `count`. State the rule.
- **E14 ★★** Membership at speed: 100 000 lookups against a `vector` of 10 000 ints (linear) vs an `unordered_set`. Predict the ratio, then state which extra requirements the unordered container made of its key.
- **E15 ★★** A `set<string>` of completed roll numbers sorted alphabetically vs an `unordered_set` — write the one question each answers best, then answer: where do range queries ("all roll numbers between A and M") live?
- **E16 ★★** Deduplicate a `vector<string>` keeping first-appearance order (unordered_set + vector walk). Why can't the set alone preserve that order?
- **E17 ★★★** A `map<char, int>` of character frequencies in `"mississippi"` — print in sorted key order. Then the same with `unordered_map` — what changed in the *output*, and what didn't?
- **E18 ★★★** Two-word anagram check via containers: same letters, same counts. Implement with `unordered_map<char,int>` (increment for word 1, decrement for word 2, all zero ⇒ anagram), and state the contract the method demands of `char`.

### Solutions B

**S10.** Size 4 — the duplicate 3 was *ignored* (unique keys); the loop prints `1 3 5 9` — sorted, always (the tree *is* the order).

**S11.** `population`-pattern: `m["OOP"] = 45; m["DS"] = 60; m["OOP"] = 48;` — the overwrite hits the same key. Structured-binding loop prints keys **sorted** (`DS, OOP, ...`) — the sorted pair's free ordering guarantee.

**S12.** Counts: the→3, cat→1, hat→1. The requirement: `string` is **hashable** (hash + `==`) — the standard library supplies both for `string`, which is why the unordered pair "just works" on the types you've used all course.

**S13.** `m["x"];` on a missing key **inserts** `("x", 0)` and returns it — size becomes 1 after a "read". Safe: `if (m.count("x")) ...` or `auto it = m.find("x"); if (it != m.end()) ...`. The rule: *`[]` inserts/assigns; `count`/`find` ask.* (Lesson 2 §2's trap — now demonstrated.)

**S14.** Prediction: ~O(n) per lookup against the vector (10 000 steps × 100 000 lookups = 10⁹) vs ~O(1) (10⁵) — a ratio in the thousands. The unordered key's extra requirements: hash + `==` (vs the vector's need for nothing but `==` in a manual scan).

**S15.** `unordered_set` answers "is this roll number done?" fastest; the *sorted* `set` answers "show me the completed ones, in order" and range queries — range queries live **only** in the sorted containers (the hash scatters keys; no structure to query between).

**S16.** `unordered_set<string> seen; vector<string> out; for (const string& s : v) if (seen.insert(s).second) out.push_back(s);` — first-appearance order lives in the *output vector*; the set only answers "new?". The set alone can't preserve it: unordered scatters (specifies no order), and even `set`'s sorted order is *key* order, not arrival order.

**S17.** `map<char,int>`: `i→4, m→1, p→2, s→4` — sorted keys. `unordered_map`: same *counts*, unspecified *order* — the data identical, the presentation contract different. That's the entire sorted/unordered trade, visible in one output.

**S18.** The increment/decrement map per word; anagram iff every bucket is zero. The contract on `char`: hashable + equality (supplied for built-ins) — and the *algorithm's* invariant ("sum of counts must return to zero") is the hand-checked proof (the Debugging module's sums-add-up discipline, one more appearance).

## Part C — Iterators, algorithms, lambdas (E19–E26)

- **E19 ★** Print `vector<int> v` twice: once with a range-based loop, once with an explicit `begin()/end()` iterator loop. State what `end()` points *at*.
- **E20 ★** Given `vector<int> v = {5,1,9,3}`, print `min_element`/`max_element` values — and the empty-vector guard you must write first.
- **E21 ★** Replace a hand loop that counted values above 50 with `count_if` + lambda. Show both versions.
- **E22 ★★** Sum a `vector<int>` of `{1000000000, 2000000000}` with `accumulate` seeded `0` vs `0LL` — predict both outputs, then state the seed rule.
- **E23 ★★** Sort `vector<string>` words ascending; then descending with a lambda comparator; then by *length* (ties by natural order). Three sorts, one container.
- **E24 ★★** `find` on `{4, 8, 15, 16}`: locate 15 and print its index via iterator subtraction; locate 99 and show the `end()` test. Then `find` the same values in a `set<int>` — what changes about the *result*, and what about the *tool* you'd use instead?
- **E25 ★★★** A `vector<pair<string,int>>` of names/marks: sort by marks descending (lambda), print with structured bindings, then `accumulate` the total marks (seeded correctly) and print the class average as a double.
- **E26 ★★★** Explain the invalidation: build `vector<int> v = {1,2,3}`, take `auto it = v.begin()`, `push_back` five more, then `*it` — what's wrong, what *may* happen, and what's the safe pattern? Then the same story for `list` — and why the answers differ.

### Solutions C

**S19.** Range loop and `for (auto it = v.begin(); it != v.end(); ++it) cout << *it;` — `end()` points *one past the last element* (a position, not an element); equality with it means "exhausted."

**S20.** `if (v.empty()) return;` first — then `*min_element(...)`/`*max_element(...)` → 1 and 9. The guard is mandatory: dereferencing `end()` is undefined (the iterator-safety family, hunt D6's kin).

**S21.** Hand: `int n = 0; for (int x : v) if (x > 50) n++;` Library: `int n = count_if(v.begin(), v.end(), [](int x) { return x > 50; });` — the predicate names the criterion; the counting shape disappears (named-algorithm rule).

**S22.** Seeded `0` (int): the true sum 3 000 000 000 **overflows int** — UB, typically a wrapped negative. Seeded `0LL`: 3000000000. The seed rule: *the seed's type is the accumulator's type* — choose it for the arithmetic you need (the Foundations module's type-choice lesson, in the seed).

**S23.** `sort(w.begin(), w.end());` · `sort(w.begin(), w.end(), [](const string& a, const string& b) { return a > b; });` · `sort(w.begin(), w.end(), [](const string& a, const string& b) { return a.size() < b.size(); });` — three orderings, one container, comparators as data (the Generics module's comparator lesson, lambda edition).

**S24.** `auto it = find(v.begin(), v.end(), 15); if (it != v.end()) cout << it - v.begin();` → 2; for 99 the test fails → absent. In the `set`: `find` still works (member `find`, O(log n)) — but the subtraction is *illegal* (no random access); and for set membership the idiomatic tool is `count`/`set::find`, not the generic `std::find`. Same question, container-changed tool.

**S25.** `sort(students.begin(), students.end(), [](const pair<string,int>& a, const pair<string,int>& b) { return a.second > b.second; });` then the structured-binding loop, then `long long total = accumulate(students.begin(), students.end(), 0LL, [](long long acc, const pair<string,int>& p) { return acc + p.second; });` and `double avg = (double)total / students.size();` — the four-item pipeline (sort → unpack → fold → divide) is the whole course in four lines. (The binary `accumulate` overload takes the lambda as the *combining rule* — one step beyond the seed-only form, introduced here deliberately.)

**S26.** After `push_back` × 5, capacity may have grown and reallocated — `it` may point into freed memory: dereferencing is **undefined behaviour** (garbage, crash, anything). Safe pattern: *take iterators after the last mutation*, or re-take `v.begin()` post-mutation, or index by position. For `list`: **the iterator survives** — nodes have stable addresses (Lesson 1 §4's selling point, stated as an invalidation guarantee). The answers differ because the containers' memory layouts differ — the guarantees are part of each container's contract.

## Where next

- [Debugging hunts](debugging.md): ten seeded STL bugs.
- [Challenges](challenges.md): fifteen builds.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
