---
title: "Modern C++ Challenges — 6 Problems"
description: "Six challenges: a RAII file wrapper, an ownership redesign, a constexpr table, a move-aware pipeline, the smart-pointer policy document, and the modernisation kata — solutions in a separated section."
---

# Challenges — 6 problems

> [← Module home](index.md) · ★ to ★★★★. Each solution ends with its design defence — write yours before comparing.

- **C1 ★ — The RAII log wrapper.** Build `class TxLog` — a transaction-log RAII owner: opens `tx.log` in append mode in the constructor (throwing `FileError` on failure — the Robustness module's family), appends via `append(line)` with the flush-and-verify discipline, closes in the destructor **no-fail**. Demonstrate that a `throw` between two appends still leaves a valid, closed log.
- **C2 ★★ — The ownership redesign.** Take the Strings module's mini-project *Text Analysis Toolkit* (or any earlier program with `new`-shaped or copy-shaped data flow) and redesign its data ownership: every structure either owns (container / `unique_ptr`) or views (`const&` / raw const pointer). Deliverable: the ownership diagram (boxes and arrows, owner arrows solid, view arrows dashed) plus the rewritten signatures.
- **C3 ★★ — The constexpr table.** Build a static times-table program: `constexpr` rows/columns, a `constexpr`-computable cell formula, `static_assert` on the total cell count and on the first row's values, all storage in `std::array`. Then change the shape to 12×12 and list what the compiler caught for you.
- **C4 ★★ — The move-aware pipeline.** Three stages — `readLines()` → `clean(lines)` → `count(lines)` — where each stage consumes the previous output. Write the pipeline so every hand-off is a move (automatic or explicit), no payload is copied, and after each hand-off a comment states the source's state. Prove the no-copy claim with a `Traced` string-like class that prints on copy vs move.
- **C5 ★★★ — The smart-pointer policy document.** Write the one-page policy for your capstone team: when `unique_ptr` (default owner), when raw (views only), when `shared_ptr` (genuine sharing, named), when containers instead of any pointer; the three rules for `make_unique`; the moved-from rule; the two code-review questions the policy answers. Every rule with a one-sentence *why* from this module.
- **C6 ★★★★ — The modernisation kata.** Take any program you wrote before Unit 13 (arrays/strings era) and perform the full [Modernisation Lab](labs.md) on it — all four stages — plus one addition the lab does not require: a before/after **complexity-of-ownership paragraph** (how many `delete` paths existed, how many exist now, and which tool deleted them).

---

## Solutions

**S1.**

```cpp
class TxLog {
public:
    explicit TxLog(const string& path) : out(path, ios::app) {
        if (!out) throw FileError("open", path);
    }
    void append(const string& line) {
        out << line << "\n";
        out.flush();
        if (!out) throw AppError("TxLog: append failed");   // loud, never silent
    }
    ~TxLog() = default;    // ofstream closes itself — the no-fail close is the member's job
private:
    ofstream out;
};
// demonstration:
void demo() {
    TxLog log("tx.log");                 // acquired
    log.append("begin");
    doWork();                            // suppose this throws
    log.append("end");                   // skipped on the throw path
}                                        // ~TxLog → ~ofstream: file closed, no matter what
```

The demonstration's point: the throw skips `append("end")`, unwinds, and the destructor chain still closes the file — the log is valid (flushed writes intact) and never left open. Defence sentence: *"The destructor does nothing because the owner member does everything — the RAII pattern is inherited, not re-implemented."*

**S2.** The redesign deliverable, in the toolkit's shape:

```text
OWNER ARROWS (solid):  TextTool ──owns──► vector<string> lines   (the corpus)
                       TextTool ──owns──► map<string,int> tally   (the counts)
VIEW ARROWS (dashed):  printReport(const TextTool&) ┄┄views┄┄► lines, tally
                       findWord(const string&) ┄┄views┄┄► tally entries
```

```cpp
class TextTool {
public:
    explicit TextTool(vector<string> lines) : lines(move(lines)) {}   // takes ownership by value+move
    const vector<string>& linesView() const { return lines; }          // viewers get views
    const map<string, int>& tallyView() const { return tally; }
    void rebuildTally();                    // the only tally mutator
private:
    vector<string> lines;                   // owns the text
    map<string, int> tally;                 // owns the counts
};
void printReport(const TextTool& t);        // a view: cannot outlive its argument's call
```

Defence: every arrow is now either a *lifetime-anchored member* (owner) or a *call-scoped const&* (view) — no third category, nothing to `delete`, and the construction signature (`TextTool(vector<string>)` by value + move) states the ownership transfer in the type.

**S3.**

```cpp
constexpr int ROWS = 10, COLS = 10;
constexpr int CELLS = ROWS * COLS;
constexpr int cell(int r, int c) { return (r + 1) * (c + 1); }   // constexpr function is fine here
static_assert(CELLS == 100, "table shape");
static_assert(cell(0, 0) == 1 && cell(0, 9) == 10, "first row formula");

array<array<int, COLS>, ROWS> table {};
// fill with cell(r, c); print.
```

Changing to 12×12: `CELLS` recomputes, and the *stale* `static_assert(CELLS == 100)` fails compilation instantly — the assert was written against the shape, and the shape changed. That is the deliverable's lesson: `static_assert` turns silent assumption into loud contract. (The `constexpr` function is included deliberately — constant *values* were the lesson; this shows the boundary honestly: simple computations are fine, machinery is not.)

**S4.**

```cpp
class Traced {                       // the proof instrument
public:
    Traced() = default;
    Traced(const Traced&) { cout << "[copy] "; }
    Traced(Traced&&) noexcept { cout << "[move] "; }
    // ... string payload and assignment operators printing likewise ...
};

vector<string> readLines() { /* ... */ return lines; }          // A: return — automatic move/elision
vector<string> clean(vector<string> lines) {                    // B: BY VALUE — moved into
    // erase-remove whitespace-only lines; operates on its own (moved-in) copy
    return lines;                                               // automatic move out
}
int count(const vector<string>& lines) { return lines.size(); } // C: a view — no hand-off at all

// the pipeline:
auto lines = readLines();            // source: local, alive
auto cleaned = clean(move(lines));   // EXPLICIT move — we are done with lines; after: lines empty
int n = count(cleaned);              // view — no transfer, cleaned still owned here
```

Each comment names the source's state at hand-off. The `Traced` run prints `[move]` at A and B and *nothing* at C — no copies anywhere. Defence: the pipeline's data flows by transfer; views cost nothing; and the one explicit `move` sits exactly where a named variable ends its life.

**S5.** The policy's shape (yours will differ; every rule needs its why):

- **Owners:** `vector`/`map`/`string` first — *why:* heap management already solved, RAII included (Lesson 2 §1). `unique_ptr` for single heap objects that containers cannot express — *why:* single ownership enforced by the compiler (§4). `shared_ptr` only when two *independent* lifetimes genuinely share one object — *why:* counts cost, cycles kill (D3, M8).
- **Views:** `const&` parameters and returns; raw `const T*` only where null is a *meaningful* answer (the ask-door) — *why:* views cannot dangle what they do not own (§6).
- **`make_unique` rules:** always `make_unique<T>(...)`, never `new` in an owning expression; always initialise at creation; `reset()` only for explicit eager release.
- **Moved-from rule:** after `move(x)`, x is assign-or-destroy — *why:* D2.
- **Review questions:** (1) *Who owns this, and is the owner named in the type?* (2) *Is any `new`/`delete` pair reachable — and if so, which exit path skips it?* — every accepted answer routes to §4 and §1 of the policy.

**S6.** The kata is self-assessed against the [Modernisation Lab's](labs.md) four stages, with the addition: the complexity-of-ownership paragraph. A strong before/after reads: *"The arrays-era program had four `new` sites and three `delete` paths each (normal return, two early exits), with one path provably leaky under a throw; the modernised program has zero `new` sites — the growth pattern became a `vector`, the temporary report a `unique_ptr`, and the only pointers remaining are the two ask-door views into `find`-style lookups. The tool that deleted the ownership complexity was RAII; the tool that proved it was the destructor-order trace."* If your paragraph cannot name a *specific path that used to leak*, pick a bigger kata program — the before must have something for the after to cure.

---

*Every solution's closing sentence is its design defence — compare, then run the kata on your own pre-Unit-13 code.*
