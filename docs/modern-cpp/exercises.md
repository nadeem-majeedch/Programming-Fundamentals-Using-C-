---
title: "Modern C++ Exercises — 18 Problems"
description: "Eighteen graded exercises in two parts — the fundamental column (const, references, nullptr, enum class, traversal, library-first) and the modern column (auto, constexpr, RAII, smart pointers, move) — solutions in a separated section."
---

# Exercises — 18 problems

> [← Module home](index.md) · Attempt each in writing **before** opening its solution — the [course protocol](../how-to-study.md). Part F consolidates [Lesson 1](lesson-1-fundamentals.md); Part M practises [Lesson 2](lesson-2-modern-practices.md).

## Part F — the fundamentals (F1–F9)

- **F1 ★ — The const sweep.** Take this signature and make it const-correct: `void printRoster(vector<string> names, string title)`. Write the final signatures, and one sentence per `const` explaining the promise it adds.
- **F2 ★ — Value or reference?** For each parameter, choose plain value, `const T&`, or `T&`, with a one-word reason: (a) `int n` count; (b) `string` student name, read; (c) `double` balance, adjusted; (d) `vector<int>` marks, read; (e) `char` grade, read.
- **F3 ★ — The null test.** Write `const Student* findByName(const vector<Student>& v, const string& name)` returning `nullptr` on miss. Write the caller's two-branch handling — and state why `NULL` would be wrong here even where it compiles.
- **F4 ★ — enum class migration.** Convert this to `enum class` with a `describe` switch, and list the two errors the conversion *prevents*: `enum Level { LOW, MEDIUM, HIGH }; int level = 2;`
- **F5 ★ — The traversal chooser.** Three tasks: print every element; add 10 to every element; print elements at even *indices*. Which uses range-`for` with what loop variable, and which needs a counted loop? Write all three loops over the same `vector<int>`.
- **F6 ★★ — Lambda at the call site.** Using one `vector<string>`, write four one-line algorithm calls with lambdas: count words longer than 5 letters; sort by length then alphabetically; find the first word starting with 'A'; print all with a for_each-style range-for instead. State the STL module rule each call obeys.
- **F7 ★★ — Library-first audit.** Rewrite this hand-rolled snippet with the standard library — identify what it computes first: `int best = 0; for (size_t i = 1; i < v.size(); ++i) if (v[i] > v[best]) best = i;`
- **F8 ★★ — const members by design.** A `Course` object's title must never change after construction, but its enrolled count changes. Write the class: which members are `const`, which member functions are `const`, and why the `const string` member forces the constructor-initialiser list (the OOP module's birth-vs-renovation rule).
- **F9 ★★★ — The const-correct interface.** Design the public interface of a `LibraryBook` (title, author, available-flag, borrower): every getter `const`, mutators named as commands, one `const string&` return — then add the line that would *not compile* if a `const LibraryBook&` parameter tried to call a mutator. Explain what the compile error just bought the design.

## Part M — the modern practices (M1–M9)

- **M1 ★ — auto or spelled?** For each declaration, write `auto` if it obeys the restraint rules, else the spelled type, with the deciding sentence: (a) `vector<Student>::const_iterator it = v.begin();` (b) `double avg = total / n;` (c) `long long sum = accumulate(...);` (d) `auto [name, marks] = pair;`
- **M2 ★ — constexpr upgrade.** Rewrite `const int MAX_STUDENTS = 50; int rooms[MAX_STUDENTS];` (raw array) into the modern idiom: `constexpr`, `std::array`, and a `static_assert` that the count is positive.
- **M3 ★ — The ownership audit.** For each raw pointer use, name the modern replacement: (a) `Report* p = new Report(t); ...; delete p;`; (b) `int* data = new int[n]; ...; delete[] data;`; (c) `Student* found = findByName(...);` used read-only; (d) a function returning `new`-built `vector` as `vector<int>*`.
- **M4 ★★ — make_unique conversion.** Rewrite the Pointers module's typical `Triangle* t = new Triangle(b, h); cout << t->area(); delete t;` with `make_unique` — then add the throwing call between creation and use that *proves* the leak in the old version and its absence in the new. Show both outputs.
- **M5 ★★ — One owner, one view.** A cache owns `Report` objects; a printer receives one to print. Write both signatures — the cache's storage (`unordered_map<string, unique_ptr<Report>>`) and the printer's parameter — and state in one sentence which is the owner and why the printer must *not* take `unique_ptr`.
- **M6 ★★ — The move moment.** You build a `vector<string>` locally in `buildRoster()`, return it, then insert it into a member `vector<vector<string>> archive`. Write the function and the insertion, marking where moves happen automatically, where `move` is your call, and the state of the local after each.
- **M7 ★★ — RAII inventory.** List every resource a small "session" program acquires (file read, dynamic buffer, log file, restore-on-exit state) and name the RAII owner for each from this module and the course — then write the one-sentence rule the table demonstrates.
- **M8 ★★★ — The shared_ptr temptation.** A teammate proposes `shared_ptr<Node>` for every node of a doubly linked list ("no ownership arguments!"). Write the two-paragraph verdict: what actually happens between adjacent nodes, what the correct ownership design is (one owner structure, raw/`const&` links), and the beginner rule this case proves.
- **M9 ★★★ — The modernisation review.** Review this snippet and produce the modernisation list — every line that violates the module's habits, with the replacement:

```cpp
Record* load(int n) {
    Record* recs = new Record[n];
    for (int i = 0; i < n; ++i) recs[i] = readOne();
    if (n > LIMIT) return NULL;             // early out
    return recs;
}
```

---

## Solutions

*(Attempt first — the solutions state the *reasoning*, not just the code.)*

**F1.** `void printRoster(const vector<string>& names, const string& title)` — the vector: non-owning, read-only, no copy of a possibly large container; the string: same promise for the title. Each `const` is a *promise to the caller* ("your data comes back untouched") and a *guarantee to the reader* (no mutation to hunt for). If the function needed to modify, the `const` would be *removed with a reason* — the const-first discipline in one exercise.

**F2.** (a) plain value — copying an `int` is cheaper than aliasing; (b) `const string&` — expensive type, read-only; (c) `double&` — must mutate the caller's variable; (d) `const vector<int>&` — expensive type, read-only; (e) plain value — a `char` is cheap. The pattern: size decides value-vs-reference, intent decides const.

**F3.**

```cpp
const Student* findByName(const vector<Student>& v, const string& name) {
    for (const Student& s : v)
        if (s.getName() == name) return &s;
    return nullptr;
}
// caller:
const Student* s = findByName(roster, query);
if (s) cout << s->getGpa() << "\n";
else    cout << "no such student\n";
```

`NULL` is a macro that expands to `0` (or similar) — an *integer* literal that happens to convert; it can pick the wrong overload and reads as a number. `nullptr` has pointer type: the ask-door's empty hand, typed correctly.

**F4.**

```cpp
enum class Level { Low, Medium, High };
const char* describe(Level l) {
    switch (l) {
        case Level::Low:    return "low";
        case Level::Medium: return "medium";
        case Level::High:   return "high";
    }
    return "unknown";
}
```

Prevented: (1) `int level = 2;` — an unqualified int can no longer *be* a level (magic numbers die; only valid `Level` values exist); (2) implicit conversions and scope leaks — `LOW` no longer pollutes the enclosing scope and no `int` sneaks into a `Level` parameter. The compiler's switch-warning is the bonus.

**F5.** Print-every: `for (const int& x : v)` (or `int x` — cheap type; both fine, state the rule). Add-10: `for (int& x : v) x += 10;` — a *write* needs the non-const reference. Even indices: a counted loop `for (size_t i = 0; i < v.size(); i += 2)` — range-`for` has no index, and *position* is the task. Choosing the loop is the exercise; all three appear in [the lab](labs.md)'s modernisation table.

**F6.**

```cpp
auto n = count_if(w.begin(), w.end(), [](const string& s) { return s.size() > 5; });
sort(w.begin(), w.end(), [](const string& a, const string& b) {
    return a.size() != b.size() ? a.size() < b.size() : a < b; });
auto it = find_if(w.begin(), w.end(), [](const string& s) { return !s.empty() && s[0] == 'A'; });
for (const string& s : w) cout << s << "\n";
```

Rules obeyed: predicates are short and at the call site; captures empty (nothing captured, no `[&]` greed); the ordering comparator reads as one sentence — length first, then lexicographic.

**F7.** It computes the **index of the maximum element** — the hand-rolled version of `max_element` plus index math. The library form: `auto best = max_element(v.begin(), v.end());` (iterator) or `auto idx = distance(v.begin(), max_element(v.begin(), v.end()));` when the index itself is needed. The audit lesson: name the *computation* first; the library probably owns it — and owns its edge cases (`max_element` on empty returns `end()`, which the hand loop's `best = 0` silently gets wrong for empty input).

**F8.**

```cpp
class Course {
public:
    Course(const string& title, int capacity)
        : title(title), capacity(capacity), enrolled(0) {}   // const member: init list ONLY
    const string& getTitle() const { return title; }         // read-only interface
    int getEnrolled() const { return enrolled; }
    bool enrol() {                       // a command — not const; the ask-door returns false
        if (enrolled >= capacity) return false;
        ++enrolled;
        return true;
    }
private:
    const string title;                  // born once, never renamed
    const int capacity;
    int enrolled;                        // the mutable part
};
```

`const` members can only be initialised in the constructor-initialiser list — assignment would mutate after birth, which `const` forbids. The design point: const-ness *splits the state* into fixed identity (title, capacity) and living state (enrolled) — the class reads as its own documentation.

**F9.**

```cpp
class LibraryBook {
public:
    LibraryBook(const string& title, const string& author);
    const string& getTitle() const;      // view, not copy
    const string& getAuthor() const;
    bool isAvailable() const;            // query
    bool checkOut(const string& borrower);   // command (ask-door)
    bool returnBook();                   // command
private:
    const string title, author;
    bool available = true;
    string borrower;
};
// the line that must NOT compile:
void sneak(LibraryBook& b) { b.checkOut("me"); }          // fine — non-const
void sneak2(const LibraryBook& b) { b.checkOut("me"); }   // COMPILE ERROR
```

The error is the feature: a `const LibraryBook&` parameter is a *promise-bearing view*, and the compiler just proved the promise is enforceable — every future reader knows `sneak2` cannot alter the book, without reading its body. Const correctness converts a comment ("this doesn't modify b, honest") into a checked fact.

**M1.** (a) `auto` — the iterator type is unspellable and obvious from `begin()`; (b) spelled `double` — the type carries meaning (a ratio, not an int); (c) spelled `long long` — the seed-type lesson: `auto sum = accumulate(..., 0LL)` would deduce from the *seed*, but writing the type states the intent; the trap this course teaches against is `auto n = 0;` when a big sum was meant; (d) `auto` with structured bindings — unspellable by definition; the names carry the meaning.

**M2.**

```cpp
constexpr int MAX_STUDENTS = 50;             // compile-time: checkable, foldable
static_assert(MAX_STUDENTS > 0, "capacity must be positive");
array<int, MAX_STUDENTS> rooms {};
```

`const` merely promises not to change; `constexpr` lets the compiler *use* the value — sizing `array`, folding arithmetic, feeding `static_assert`. And `std::array` replaces the raw array: same stack storage, plus `.size()`, range-`for`, and no pointer decay surprises.

**M3.** (a) `auto p = make_unique<Report>(t);` — one owner, auto-destroyed; (b) `vector<int> data(n);` — container-first: the heap under management, sizing included; (c) keep the raw `const Student*` — a *non-owning view* is the modern role of raw pointers; (d) return by value: `vector<int> load(int n)` — the move makes it free (M6). The audit's theme: ownership moves into objects; raw pointers remain, but only as views.

**M4.**

```cpp
auto t = make_unique<Triangle>(b, h);
if (b <= 0) throw invalid_argument("bad base");   // the injected failure
cout << t->area();
```

Old version on the throw path: `new Triangle` succeeded, the throw skipped `delete` — the triangle leaks *and* the destructor never runs (its print, if any, never appears). New version: `~Triangle` runs during unwinding (the Robustness module's D6 cure), the output shows destruction after the catch. The reviewer's two sentences: "Ownership is declared in the type and enforced by the compiler — no exit path needs auditing." "The old version's correctness depended on every future edit remembering the delete; this one cannot forget."

**M5.**

```cpp
unordered_map<string, unique_ptr<Report>> cache;     // THE owner
void print(const Report& r);                          // or void print(const Report* r);
```

The cache owns: it creates and destroys reports. The printer *views*: taking `unique_ptr` by value would *transfer* ownership into a function that only reads — the report would die at the end of printing (and the cache would hold a dangling entry). Owner takes ownership; viewers take views — the signature *is* the ownership story.

**M6.**

```cpp
vector<string> buildRoster() {
    vector<string> roster = readNames();    // built locally
    return roster;                          // move happens automatically (or elided) — free
}
// in the owner class:
archive.push_back(buildRoster());           // the temporary is moved — automatic
// or, with a named local you are DONE with:
vector<string> extra = buildRoster();
archive.push_back(move(extra));             // your explicit call: extra is now empty-but-alive
```

The return move is the compiler's business (rule: moving out of a dying local is automatic). The explicit `move` is yours *only* when a named variable is finished — and after it, `extra` must be treated as gone (assign fresh or destroy; never read). The exercise's sentence: `move` marks *permission*, the receiver performs the transfer.

**M7.** File read → `ifstream` (destructor closes); dynamic buffer → `vector` / `string` (destructor frees); log file → `ofstream` with the append-verify discipline; restore-on-exit state → the rollback guard object (Robustness C8), whose destructor restores unless `commit()` ran. The rule: **every resource is owned by an object, so every release is a destructor call — and destructors run on every exit path, throws included.** No resource is released by hand; therefore no path can forget.

**M8.** Verdict, two paragraphs. *What happens:* each node holds a `shared_ptr` to the next **and** to the previous; walking the list, every node's use-count never reaches zero — each node keeps its neighbour alive, the neighbours keep it back: the whole list leaks as a closed circle of mutual keep-alives (the shared_ptr cycle), and the "no ownership arguments" design owns nothing. *The correct design:* the list structure (`LinkedList`) owns the nodes — `unique_ptr` forward, the back pointer a raw *non-owning* view (or the list is doubly-linked only through the owner's bookkeeping); functions that visit take `const Node&` or `const Node*`. The rule the case proves: **shared ownership is a last resort for genuinely shared data — redesign until you can name the one owner; the pointer discipline is a design tool, not a substitute for design.**

**M9.** The modernisation list, line by line: (1) `Record* recs = new Record[n]` → `vector<Record> recs(n);` — the container-first rule; (2) `return NULL;` → two fixes: `nullptr` (never `NULL`), and better, the *ask-door* reshaped — return `optional`-like idioms are beyond the course, so return `bool`/out-param or throw (the Robustness module's typed refusal) per the caller's need; the early-out also **leaks** `recs` — the raw owner abandoned on a secondary path (species #1 of the Robustness module); (3) the raw `Record*` return → `vector<Record> load(int n)` by value (move semantics make it free) — the caller's `delete[]` obligation disappears entirely; (4) the loop stays but reads `recs[i] = readOne();` over a vector unchanged — mechanics identical, ownership solved. One-sentence summary for the review: **the original's leak was structural (a raw owner with an unguarded exit); the modern version has no owner to forget.**
