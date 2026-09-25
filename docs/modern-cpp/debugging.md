---
title: "Modern C++ Debugging — 8 Seeded Hunts"
description: "Eight hunts where the modern practices are the diagnosis: auto that lied, move after which the data was read, a shared_ptr cycle, the raw owner's last leak, and the const that caught the bug."
---

# Debugging — 8 seeded hunts

> [← Module home](index.md) · For each program: **predict**, **run**, **explain the gap**, then **name the practice that prevents the whole class**. Diagnoses in a separated section.

- **D1 — The auto that lied.** A statistics program compiles clean and prints wrong averages for large inputs.
  ```cpp
  auto total = 0;
  for (int m : marks) total += m;
  cout << (double)total / marks.size() << "\n";   // marks holds 3,000,000 marks ≤ 1000
  ```
  *What type did `auto` deduce, what overflowed, and which restraint rule was violated?*

- **D2 — The ghost value.** After "optimising" a report builder, the destination file is empty half the time.
  ```cpp
  string buildReport() {
      string body = collectData();
      string out = move(body);
      log.append(body);              // "audit trail"
      return out;
  }
  ```
  *What does `log.append` receive? Which rule of `std::move` did the audit line break? Fix while keeping the audit trail.*

- **D3 — The immortal cache.** A cache of reports is emptied (`cache.clear()`) but memory usage never drops; reports are observed alive in a memory tool long after clear.
  ```cpp
  struct Node { shared_ptr<Node> next; shared_ptr<Node> prev; Report data; };
  // a ring of nodes, each holding shared_ptr to both neighbours...
  ```
  *Why does `clear()` not free them? Name the trap, then redesign the ownership in one sentence.*

- **D4 — The raw owner's last leak.** One early exit was added to an old loader last week.
  ```cpp
  vector<Record>* load(const string& path) {
      vector<Record>* out = new vector<Record>();
      ifstream in(path);
      if (!in) return nullptr;                 // the new early exit
      string line;
      while (getline(in, line)) out->push_back(parse(line));
      return out;
  }
  ```
  *Two bugs: which lines leak on which path, and what does the *caller* have to remember even on the happy path? Rewrite with the modern idiom so neither bug can exist.*

- **D5 — The const that caught it.** A "pure" statistics function was found mutating its input — only because a reviewer changed one signature.
  ```cpp
  double stdDev(vector<int> marks) {           // reviewer changed to const vector<int>& — build broke
      double mean = averageOf(marks);
      for (size_t i = 0; i < marks.size(); ++i)
          marks[i] -= mean;                    // "just normalising locally"
      return spread(marks);
  }
  ```
  *Explain both readings: why the original hid a surprise from callers, and what the compile error revealed. Which is the correct design, and what should the function be named in that case?*

- **D6 — The nullptr archaeology.** An old header declares `void onTimeout(Callback* cb);` and callers pass `0` and `NULL` interchangeably; one call site passes the *integer* 0 to a new overload `onTimeout(int code)` and gets silent wrong behaviour instead of the "no callback" intent.
  *Explain the overload resolution, and state the two-word rule that makes this bug unwriteable.*

- **D7 — The moved-from return.** A "fast path" was added to a getter.
  ```cpp
  const string& getName() const { return title; }        // existing, fine
  string getNameFancy() const {
      string decorated = "[" + title + "]";
      return move(decorated);                // "avoid the copy"
  }
  ```
  *Is the `move` harmful, useless, or load-bearing here — and what would the compiler have done without it? State the general rule for returns and `move`.*

- **D8 — The constexpr that wasn't.** A capacity constant silently stopped being compile-time after an "improvement".
  ```cpp
  constexpr int MAX_ROWS = readConfigInt("rows");    // config file value
  array<int, MAX_ROWS> grid {};
  ```
  *Why does this fail to compile at all, what is the `const`-vs-`constexpr` distinction it proves, and where does a config-file value actually belong (compile time or run time)?*

---

## Diagnoses

**D1.** `auto total = 0;` deduces `int`. Three million marks averaging ~500 → a sum near 1.5 billion — inside `int`'s range until the unlucky semester: overflow is *undefined behaviour*, and on typical machines the total wraps negative, producing nonsense averages for large-but-legal inputs. The violated rule: **name the type when the type carries meaning** — this variable's whole job is "sum that must not overflow": `long long total = 0;` (or the seed-type lesson: `accumulate(marks.begin(), marks.end(), 0LL)`). `auto` on a numeric literal is exactly where the rule bites.

**D2.** After `move(body)`, `body` is empty-but-alive — the audit line logs an empty string: the "audit trail" is a lie, which is this module's silent-failure species in modern clothing. The rule broken: **after `std::move(x), treat x as gone** — no reads. Fix: log *before* the move, or log the destination:

```cpp
string body = collectData();
log.append(body);          // audit BEFORE stealing
string out = move(body);   // now transfer
return out;                // (the return itself would move anyway)
```

**D3.** A use-counted cycle: every node is kept alive by its two neighbours' `shared_ptr`s; the ring's counts never reach zero, so `clear()` (which drops the map's references) leaves the circle counting itself — immortal. The trap: **shared ownership between mutually-referring nodes is a keep-alive circle.** The redesign in one sentence: *the ring structure itself owns the nodes (`vector<Node>` or `unique_ptr` chain), and neighbour links become raw non-owning views* — one owner, views for the rest (exercise M8's verdict, in the wild).

**D4.** Leak one: the `!in` path returns `nullptr` while `out`'s heap vector is abandoned — leaked. Leak two, structural: even the happy path forces every caller to `delete` the returned pointer *and* to remember that `nullptr` means "no file" — an ask-door bolted onto an ownership obligation. The modern rewrite deletes the whole bug class:

```cpp
vector<Record> load(const string& path) {          // by value: the move is automatic
    ifstream in = openOrThrow(path);               // Robustness module: loud open
    vector<Record> out;
    string line;
    while (getline(in, line)) out.push_back(parse(line));
    return out;
}
```

No owner to forget, no null to test, and the missing-file policy moved to the layer that can act.

**D5.** Original: takes `vector<int>` *by value* (so the caller's data was safe by copying) but *mutates* its own copy mid-computation — a surprise to every reader who trusted "stdDev computes; it does not transform," and a hidden dependency if `spread` is later given the caller's view. The reviewer's `const vector<int>&` turned the hidden surprise into a **compile error** — the const correctness payoff: intent, checked. Correct design: the function is *not* a pure stdDev — it is "centre then spread": either split it (`centred()` returns a new vector; `stdDev` stays pure) or rename honestly (`centredStdDev`) and document the transform. The practice: const-first on parameters makes the compiler the reviewer.

**D6.** `0` and `NULL` are integer-ish literals; overload resolution for `onTimeout(0)` happily picks `onTimeout(int)` — the "no callback" intent silently becomes "timeout code zero" (this module's most modern bug: type confusion the language used to permit). The two-word rule: **`nullptr` only** — it has no integer conversion and always names the pointer overload. The archaeology lesson: the codebase's mixed `0`/`NULL`/`nullptr` spellings are a bug reservoir; the modern idiom is a retirement, not a style choice.

**D7.** **Useless — and the honest answer is that the compiler already does it.** `return decorated;` from a local is automatically moved (or elided) — the explicit `move` adds nothing and, worse, *suppresses* the NRVO-shaped elision opportunities in some compilers, plus it signals "I needed to know about moves" to every reader. The general rule: **never `std::move` a return of a local — return it plainly;** reserve `move` for transferring *named* variables you are done with into containers, members, or parameters. (`getName`'s `const&` return stays the right design for the member itself.)

**D8.** `readConfigInt` reads a file at *run time* — a `constexpr` variable must be computable at compile time, so the definition is a compile error (the compiler refusing the lie). The distinction proved: **`const` = unchanged after init (any run-time value allowed); `constexpr` = usable at compile time (compile-time value required).** A config-file value belongs to run time: `const int rows = readConfigInt("rows");` with a run-time-shaped container (`vector<int> grid(rows)` — or the validated range check). The deeper habit: compile-time constants are for *shapes and invariants the code owns*; user configuration is data, and data is checked at run time — with the Robustness module's guards.

---

## Fix-list recap

| Hunt | Bug class | The practice that prevents the class |
| --- | --- | --- |
| D1 | `auto` overflow | name the type when meaning rides on it |
| D2 | read after move | moved-from is gone — audit first |
| D3 | shared_ptr cycle | one owner; neighbours are views |
| D4 | raw-owner leak on early exit | containers/`unique_ptr` own; value returns |
| D5 | hidden mutation | const-first parameters |
| D6 | `0`/`NULL` overload confusion | `nullptr` only |
| D7 | pointless return-move | return locals plainly |
| D8 | constexpr on run-time data | const vs constexpr; config is run-time |
