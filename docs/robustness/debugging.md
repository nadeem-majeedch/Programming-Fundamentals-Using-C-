---
title: "Robustness Debugging — 10 Seeded Hunts"
description: "Ten broken exception programs: swallowed catches, dead handlers, throwing destructors, leaks through throw paths, and the silent failures they cause — diagnoses in a separated section."
---

# Debugging — 10 seeded hunts

> [← Module home](index.md) · For each program: **predict** what it does, **run** it, **explain** the gap. The hint ladder is ordered — take one hint at a time. Diagnoses are in a separated section; a fix that differs but restores loud failure and safety counts as correct.

**How to read the seeds:** each program *compiles* (or fails in the specific way described). The bug is the deliverable — name it, classify it with the [silent-failure gallery](lesson-2-custom-safety.md#5-the-silent-failure-gallery) species number where it applies, and fix it.

---

- **D1 — The quiet empty.** This menu loader "works" — the file is missing, and the menu runs fine with zero students. *Run it. What does the user see? Which species is this? Fix it so the missing file cannot pass unnoticed.*
  ```cpp
  vector<Student> loadStudents(const string& path) {
      vector<Student> out;
      ifstream in(path);
      string line;
      while (getline(in, line))
          if (!line.empty()) out.push_back(parseStudent(line));
      return out;
  }
  ```

- **D2 — The dead handler.** A teammate reports that their careful `out_of_range` diagnostics never print. *Trace the catch ladder before running. Why is the specific block dead code? Fix the order and prove it with one run.*
  ```cpp
  try {
      marks.at(1000000) = 0;
  }
  catch (const exception& e)      { cerr << "unexpected: " << e.what() << "\n"; }
  catch (const out_of_range& e)   { cerr << "bad index: " << e.what() << "\n"; }
  ```

- **D3 — The flattened report.** The plan: enrich the message in the low-level function and keep the type for the high-level handler. *What actually arrives at `main`? Name the rule from Lesson 2 that the code breaks. Fix it with `throw;` and explain what that bare statement does.*
  ```cpp
  void load() {
      try { data = readConfig(); }
      catch (const exception& e) {
          throw runtime_error(string("load failed: ") + e.what());   // "enriched"
      }
  }
  int main() {
      try { load(); }
      catch (const ConfigError& e)  { cerr << "config problem: " << e.what() << "\n"; }
      catch (const exception& e)    { cerr << "unexpected: "   << e.what() << "\n"; }
  }
  ```

- **D4 — The optimistic parse.** `stoi` meets a hostile file. *Run with the given file contents. What value does `count` carry, and which species is it? Fix using exactly one try/catch — where, and catching what?*
  ```cpp
  // file.txt:  "12\nx9\n30\n"
  int count = 0;
  ifstream in("file.txt");
  string line;
  while (getline(in, line)) {
      int v = stoi(line);            // no try in sight
      total += v; ++count;
  }
  cout << "read " << count << " numbers\n";
  ```

- **D5 — The destructor that fights back.** A "guaranteed cleanup" class. *Run it. The program doesn't reach the catch — why? State the two-active-exceptions rule, then fix the class so cleanup can never terminate the program.*
  ```cpp
  class Closer {
  public:
      ~Closer() {
          if (!ok) throw runtime_error("Closer: cleanup failed");
      }
      bool ok = false;
  };
  int main() {
      try {
          Closer c;
          throw runtime_error("original failure");
      }
      catch (const exception& e) { cerr << "caught: " << e.what() << "\n"; }
  }
  ```

- **D6 — The leak ladder.** A resource is allocated, then a sibling call throws. *Trace the throw path. Which local cleans up after itself, and which resource leaks? Fix twice: once with ordering only, once with the ownership tool — and say which fix survives the next teammate's edit.*
  ```cpp
  void process() {
      Report* rpt = new Report("sales");        // raw owner
      vector<int> data = loadNumbers();          // may throw
      rpt->render(data);
      delete rpt;
  }
  ```

- **D7 — The half-transfer.** Two accounts, one operation. *Which single-line reordering gives the strong guarantee? Which additional check makes the reorder airtight?*
  ```cpp
  void transfer(BankAccount& from, BankAccount& to, double amount) {
      from.withdraw(amount);          // may throw InsufficientFundsError
      log.append("transfer", amount); // may throw WriteError
      to.deposit(amount);             // never throws (verified)
  }
  ```

- **D8 — The net that eats everything.** A `catch (...)` was added "for safety" around the whole main loop. Now *no* error message ever appears, but results are wrong from time to time. *Which species is this? What must every catch do at minimum? Fix the block while keeping the safety net.*
  ```cpp
  while (running) {
      try {
          processOneCommand();
      } catch (...) {
          // keep the loop alive no matter what
      }
  }
  ```

- **D9 — The constructor half-birth.** A resource-owning class opens a file in its constructor body, after some members are built. *When the open throws, what runs and what leaks? Sketch the fix using member objects that own themselves.*
  ```cpp
  class Session {
  public:
      Session(const string& path) : header("session") {
          file.open(path);                    // may throw
          if (!file) throw runtime_error("no session file");
      }
      ~Session() { file.close(); }
  private:
      ofstream file;                          // FILE* file = fopen(...) variant leaks worse
      string header;
  };
  ```

- **D10 — The three-bug audit.** One program, three exception bugs from this list: a dead handler, a swallowed species-2 catch, and a leak through a throw path. *Find all three, classify each, and produce a fixed version whose every catch fixes, rethrows, or reports.*
  ```cpp
  vector<int> load(const string& p) {
      vector<int>* buf = new vector<int>();
      ifstream in(p);
      if (!in) { /* file missing */ }
      string line;
      while (getline(in, line)) buf->push_back(stoi(line));
      return *buf;
  }
  int main() {
      try {
          try { auto v = load("marks.txt"); }
          catch (const exception& e) { cerr << "E: " << e.what() << "\n"; }
          catch (const out_of_range& e) { cerr << "range: " << e.what() << "\n"; }
      } catch (...) {}
  }
  ```

---

## Diagnoses and fixes

**D1.** Species #1+#4 — the missing file produces an empty vector that the menu presents as real (empty) data. Fix:

```cpp
ifstream in(path);
if (!in) throw runtime_error("loadStudents: cannot open " + path);
```

The guard layer *above* (the menu) catches and decides: offer file re-entry or a fresh start. The loader's job is honesty, not recovery.

**D2.** `exception` is `out_of_range`'s base — handlers match top-down, so the first block catches every derived type and the `out_of_range` block is dead code (the teammate's diagnostics *never* compile-matter). Fix: most-derived first. Proof run prints `bad index: vector::_M_range_check ...` from the specific block. Same rule as lesson 1's ladder, broken in miniature.

**D3.** `throw runtime_error(...)` builds a *new* exception — every `ConfigError` becomes a generic `runtime_error`, and `main`'s config desk never fires (the flattened report arrives at the wrong desk). The rule: **rethrow the same object with `throw;`** — it re-arms the *current* exception, preserving its dynamic type, and it does not copy. Fix:

```cpp
catch (const ConfigError& e) {
    log.append("config failed: "s + e.what());
    throw;                                    // same object, same type, now logged
}
```

(If the message itself must change, carry the context in a *new* exception of the *same* family — or better, make the family carry a context field.)

**D4.** `stoi("x9")` throws `invalid_argument` — it flies out of the loop, out of `main` uncaught, and the program dies before printing anything (with `count` never printed at all). The species hidden underneath: had the throw been caught *outside the loop*, the answer would be a silently short `count`. Fix — one try *inside* the loop, converting bad lines into reported skips:

```cpp
while (getline(in, line)) {
    try {
        total += stoi(line);
        ++count;
    } catch (const invalid_argument&) {
        cerr << "skipping non-numeric line: " << line << "\n";
    }
}
```

Now the report is true: bad lines are *counted as news*, not vanished.

**D5.** Two exceptions active at once: `main`'s `runtime_error` begins unwinding, the unwinding runs `~Closer`, which throws its own `runtime_error` mid-unwind — `std::terminate()` fires, and *neither* message prints. The rule: destructors must be **no-fail**. Fix:

```cpp
~Closer() {
    try {
        if (!ok) cerr << "warning: cleanup incomplete\n";
    } catch (...) {}                          // last-resort wall; never lets anything out
}
```

If the cleanup result genuinely matters, provide an explicit `close()` method that *may* throw — and let the destructor only handle the case the user forgot.

**D6.** The throw from `loadNumbers` unwinds `process`; `data` (a `vector`) destroys itself automatically, but `rpt` is a raw pointer — **the pointed-to `Report` leaks** (the pointer itself is just a variable; nobody owns it through the unwind). Ordering-only fix: call `loadNumbers()` *first*, then `new` — nothing fallible sits between allocation and delete. Ownership fix:

```cpp
unique_ptr<Report> rpt = make_unique<Report>("sales");   // or makeReport(...)
```

`rpt`'s destructor deletes the object during unwinding — the fix that survives, because the next teammate can insert any throwing call anywhere and the report still cleans up.

**D7.** Reorder so the never-throwing step goes last is impossible as written — `deposit` is the commit and *must* be last, so instead: **make the fallible log step first, and the two account mutations contiguous.** Wait — a log failure after `withdraw` still leaves money moved without news. Airtight version:

```cpp
void transfer(BankAccount& from, BankAccount& to, double amount) {
    log.append("transfer", amount);   // 1. fallible first: throws leave both accounts intact
    from.withdraw(amount);            // 2. may throw — but nothing irreversible happened yet
    to.deposit(amount);               // 3. the commit (never throws)
}
```

The remaining seam is a throw *between* 2 and 3 — nothing sits there, and the empty gap is the point: state it in a comment. That comment is the strong guarantee made visible.

**D8.** Species #2, institutionalised — every exception (including the ones announcing *why results are wrong*) is discarded so the loop can keep spinning. Minimum duty of any catch: log at least `e.what()`. Fix:

```cpp
} catch (const exception& e) {
    cerr << "command failed: " << e.what() << "\n";    // report before continuing
} catch (...) {
    cerr << "command failed: unknown error\n";
}
```

The loop may still continue — continuing is a *policy*, but the report is the *law*. A log-only-and-continue net is also where you add a failure *counter* that escalates after N consecutive failures.

**D9.** If `file.open` throws (or the `!file` check throws), unwinding destroys the fully-constructed members — but `Session`'s destructor **never runs**, because the object was never fully constructed. Members clean up themselves (`string` frees its buffer; `ofstream` closes its file if open) — so with `ofstream file` the code is actually *safe*; the leaked variant is the `FILE*`/raw-handle comment: a raw pointer member is not destroyed meaningfully and the open handle leaks. Fix: own the resource with a member that cleans itself up (`ofstream`, or a file wrapper whose destructor closes) — then the destructor body can be empty, and even a throwing constructor leaves no debris. The deep rule: **destructor bodies run only for fully-constructed objects; member destructors run for fully-constructed *members* — so build ownership into members, not bodies.**

**D10.** The three bugs: (1) *dead handler* — in `main`'s inner try, `exception` precedes `out_of_range`, so the range desk never fires; swap. (2) *swallowed catch* — the outer `catch (...) {}` eats everything (including what the inner rethrows) with no report; it must log at minimum. (3) *leak* — `load`'s missing-file case is a comment (the `if (!in)` never throws or returns — species #1), the function returns a *copy* of `*buf` while the heap original is never deleted on *any* path — throw or not. Fixed shape:

```cpp
vector<int> load(const string& p) {
    ifstream in(p);
    if (!in) throw runtime_error("load: cannot open " + p);
    vector<int> out;                       // stack owner — cleans up through any throw
    string line;
    while (getline(in, line)) {
        try { out.push_back(stoi(line)); }
        catch (const invalid_argument&) { cerr << "skipping: " << line << "\n"; }
    }
    return out;
}
```

And the ladder reordered, outer net reporting. The audit's summary sentence: **every catch reports, every resource owns itself, every refusal is typed and loud.**

---

## Fix-list recap

| Hunt | Bug class | Rule it teaches |
| --- | --- | --- |
| D1 | missing-file silence (#1/#4) | throw at the open |
| D2 | dead handler | most-derived first |
| D3 | flattened rethrow | `throw;` preserves type |
| D4 | optimistic parse | catch inside the loop; report skips |
| D5 | throwing destructor | destructors are no-fail |
| D6 | leak through throw path | ownership by stack objects |
| D7 | half-transfer | fallible first, commit last |
| D8 | the eating net | every catch reports |
| D9 | constructor half-birth | ownership in members, not bodies |
| D10 | the audit | all of the above |
