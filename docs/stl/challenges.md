---
title: "STL Challenges — 15 Build Problems"
description: "Fifteen challenges across the container families and algorithms, with separated approaches and solutions."
---

# Challenges — 15 problems

> [← Module home](index.md) · ★ to ★★★★. Each has a separated **approach** — choose the container *and justify the choice in one sentence* before building. The justification is half the deliverable.

- **C1 ★ — The deduplicator.** Remove duplicates from a `vector<string>` **keeping first-appearance order**. Two implementations: one with `unordered_set`, one with `sort` + `unique` + `erase` — and state what the second preserves (and doesn't).
- **C2 ★ — The top-k.** Given a `vector<int>`, print the 3 largest values in descending order — twice: with a full `sort`, and with a `priority_queue` (and `pop`). Which version does less work when k ≪ n?
- **C3 ★ — The word-length histogram.** Read words into a `vector<string>`; build `map<size_t, int>` of length → count; print the histogram sorted by length.
- **C4 ★★ — The two-container diff.** Given two `vector<string>`s, print items only in A, only in B, and in both — using `unordered_set` membership. Then state what changes if the output must be alphabetical.
- **C5 ★★ — The anagram grouper.** Group words so anagrams share a group: `map<string, vector<string>>` keyed by the **sorted letters** of each word. Trace the groups for `{listen, silent, enlist, google, gooogle}`.
- **C6 ★★ — The running median.** Numbers arrive one at a time; after each, report the median. Design with two `priority_queue`s (max-heap of the lower half, min-heap of the upper). State the invariant that keeps them balanced.
- **C7 ★★ — The bracket-checker, extended.** D7's bracket stack, generalized: `{}, [], ()` plus a `priority` twist — report the *position* of the first offending character. `stack<char>` + an index walk.
- **C8 ★★★ — The inventory merger.** Two warehouses' `map<string, int>` stock lists merge into one: same keys add, conflicts log. Then the low-stock report: all items under threshold, **sorted by quantity ascending** (sort the map's pairs into a vector — why can't you sort the map?).
- **C9 ★★★ — The exam statistics.** A `vector<int>` of marks: count pass/fail (`count_if` + lambdas), min/max (`min_element`/`max_element`), average (`accumulate`, seeded honestly), and the per-grade histogram (`map<char,int>` via a grade function). One program, five algorithms.
- **C10 ★★★ — The undo stack.** A text buffer (`string`) with an undo history: `type(s)`, `undo()` restores the previous state. Implement with two `stack<string>` (states + redo). State the memory cost and the cap policy you'd add.
- **C11 ★★★ — The task scheduler.** Tasks arrive with priorities and print order matters within equal priority: `map<int, queue<string>>` (priority → FIFO queue). `add(task, priority)`, `next()` serves the highest priority's oldest task. Trace five adds and three serves.
- **C12 ★★★ — The sliding-window maximum.** For `{1, 3, -1, -3, 5, 3, 6, 7}` and window 3, report each window's max. Implement with a `deque` of *indices* holding candidates in decreasing value. State why the deque beats "recompute each window" (O(n) vs O(n·k)).
- **C13 ★★★ — The playlist shuffle.** A `list<string>` playlist: `next()` wraps to the front, `remove(title)` is safe while iterating, `shuffle()` rebuilds the order from a `vector` copy. Which operations justify `list` over `vector` — answer honestly against Lesson 1's choice table.
- **C14 ★★★★ — The frequency leaderboard.** Words arrive in a stream; repeatedly report the top 3 by count (ties: alphabetical). `unordered_map<string,int>` for counts + a rebuild-at-query `vector` of pairs sorted by the tie-broken comparator. Then state the design you'd graduate to when queries get frequent (a `set` of pairs with a custom comparator) — and why.
- **C15 ★★★★ — The template container encore.** Take the Generics module's `Box<T>` and re-express its *entire interface* as a thin wrapper over `vector<T>` (add, at, size, max — the last via `max_element`). Count the lines. Then write the paragraph: what does hand-rolling a container teach, and when is the wrapper the right call?

---

## Approaches and solutions

**A1.** Set-version: `unordered_set<string> seen; vector<string> out; for (...) if (seen.insert(s).second) out.push_back(s);` — O(n), arrival order. Sort-version: `sort(v); v.erase(unique(v.begin(), v.end()), v.end());` — O(n log n), and it *destroys arrival order* (output is sorted) — `unique` only squeezes *adjacent* duplicates, which is why the sort precedes it. The preserved/lost pair is the answer.

**A2.** Full sort: `sort(v.begin(), v.end(), greater<int>());` then print the first 3 — O(n log n). Heap: push all, `pop` thrice — O(n + k log n). When k ≪ n the heap wins by skipping the full ordering; the phrase "top-k under a sort" is the classic interview tell.

**A3.** `map<size_t, int> hist; for (const string& w : words) hist[w.size()]++;` — the `[]` here is *deliberate* insert-or-increment (the one place the mutating lookup is the right tool — D1's rule, stated with its exception); the loop prints lengths ascending, free.

**A4.** `unordered_set<string> inB(b.begin(), b.end());` then A-only = `!inB.count(x)`; build `inA` symmetrically; both = both tests. For alphabetical output: collect the three result vectors and sort them — the *computation* stays hash-speed; the *presentation* pays one sort (D3's fix pattern).

**A5.** Key = the word's letters sorted: `string k = w; sort(k.begin(), k.end()); group[k].push_back(w);` — trace: `eilnst` → {listen, silent, enlist}; `eggloo` → {google, gooogle}. The insight worth stating: *canonicalization by sorting turns an equivalence question into an exact-key lookup* — the same trick as normalizing roll numbers or lowercase names.

**A6.** Invariant: `low` (max-heap) holds the smaller half; `high` (min-heap) holds the larger half; sizes differ by ≤ 1. Arrive → push into the correct half → rebalance by moving one top across. Median = `low.top()` (odd total) or the average of both tops (even). The min-heap side needs the reversed comparator (`greater<int>` or a lambda) — D8's convention, load-bearing this time.

**A7.** Walk with an index; openers push *the expected closer and the index* (a `stack<pair<char,int>>`); on a mismatch/empty-pop/unmatched-tail, the stored index names the first offender. The LIFO rule still *is* the nesting rule — the index only localizes the confession.

**A8.** `for (const auto& [item, qty] : b) merged[item] += qty;` — insert-or-accumulate; conflicts log via a pre-check `if (merged.count(item))`. Low-stock: copy pairs to `vector<pair<string,int>>`, `sort` with a quantity-ascending lambda — the map **cannot be sorted** because its order *is* the key order (its structure); reordering it means a different container, so the report pays a copy (D3/D8's principle: the container's fixed order is a feature until it isn't).

**A9.** `count_if` ×2 with lambdas (`>= 50`), `min_element`/`max_element` with the `end()` guard, `accumulate(..., 0LL)` seeded for the sum, `map<char,int>` histogram via a grade function — five algorithms, one pipeline; the whole report is ~20 lines with zero index arithmetic.

**A10.** `stack<string> states;` — `type` pushes the pre-change state (or the post-change; pick and document), `undo` pops into the current. Redo: a second stack that undo pushes onto and that any new `type` **clears** (the classic redo-validity rule). Cost: O(state size) per operation — the cap policy (bounded depth, drop oldest) is where a `deque`-backed structure would enter; state it as the next step.

**A11.** `map<int, queue<string>> tasks;` — `add`: `tasks[priority].push(task);` (the mutating `[]` *again* the right tool — bucket creation is the intent); `next()`: walk the map from `rbegin()` (highest priority first — the *sorted* pair paying its dividend), serve that queue's front, erase empty buckets. Trace: serves highest-priority-oldest, exactly the scheduler contract.

**A12.** The `deque<int> window` holds *indices*; maintain two invariants while sliding: indices within the window, and their values strictly decreasing (front = current max). Each element: pop-back while smaller, push, pop-front when out of window, then report `nums[front]`. Every index enters and leaves once — **O(n) total** vs the naive O(n·k) window rescans. (The hard one of the set; the two invariants written down first are the difference between a sketch and a solution.)

**A13.** Honest scoring against the choice table: `next()`-with-wrap and `remove-while-iterating` are `list`'s genuine wins (stable iterators, O(1) erase); but if the playlist is read-mostly and small, a `vector` + index arithmetic serves identically. The defensible verdict: **`list` earns its place here only because of erase-while-iterating** — and the paragraph should *say* that rather than chant "linked list for playlists."

**A14.** Query design: `unordered_map<string,int> counts;` per query, copy pairs → `vector<pair<string,int>>` → `sort` with (count desc, key asc) lambda → print top 3. O(n log n) per query — fine until queries dominate. The graduation: `set<pair<int,string>, custom>` maintaining the top candidates as counts change (erase old pair, insert new on each increment) — O(log n) *per update*, O(1)-ish per query; the trade flips when query count exceeds update count. Stating *when the flip happens* is the ★★★★ part.

**A15.** The wrapper: `template <typename T> class Box { vector<T> data; public: void add(const T& x) { data.push_back(x); } const T& at(int i) const { return data.at(i); } int size() const { return (int)data.size(); } const T* max() const { if (data.empty()) return nullptr; return &*max_element(data.begin(), data.end()); } };` — roughly fifteen lines, every operation delegated. The paragraph: hand-rolling (the Generics module's Box) taught *what the operations cost and what contracts they need*; the wrapper is the right call when you want a *narrower or renamed* interface over the library's general one — encapsulation at container scale, and the honest end of the course's Box arc.

---

## Where next

- [Labs](labs.md): six container-family scenarios, end to end.
- [The Media Catalogue mini-project](miniproject.md): the families working together.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
