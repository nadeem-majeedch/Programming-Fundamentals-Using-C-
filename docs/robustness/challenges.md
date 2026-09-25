---
title: "Robustness Challenges — 10 Problems"
description: "Ten build-and-design challenges: a typed file layer, a transaction engine, retry policies, exception-safe containers, and the audit harness — solutions in a separated section."
---

# Challenges — 10 problems

> [← Module home](index.md) · ★ to ★★★★. Each challenge ends with a one-sentence *design defence* — write it before comparing with the solution.

- **C1 ★ — The typed file layer.** Wrap `ifstream` usage in a function `openOrThrow(path)` that throws a custom `FileError` (carrying path and the operation) for missing files. Refactor any Files-module lab to use it everywhere, and delete every raw `if (!in)` — count how many remained unguarded in the original.
- **C2 ★ — The retry reader.** Upgrade E6's three-attempt reader into `readIntUntil(istream, lo, hi, maxAttempts)` that throws `TooManyAttemptsError` (carrying the attempts) — then a *second* variant that accepts a fallback value instead of throwing. Write the two-sentence rule for when each variant is the right call.
- **C3 ★★ — The transaction engine.** Build `template <typename F> bool transact(F work)`-style logic *without templates*: a function that runs a list of account operations and applies all-or-nothing — if any operation throws, no operation's effect survives. (Hint: the strong-guarantee ordering trick, scaled up: validate everything fallible first, then commit.)
- **C4 ★★ — The context stack.** Every module function that catches-and-rethrows adds its name to the message: `runtime_error("report: load: parse: bad line 42")`. Implement a small helper that composes prefixes without duplicating string code, and state the alternative design (a `context` field on a custom exception) with one sentence on which you'd ship.
- **C5 ★★ — The assert-or-throw audit.** Take five `assert(...)` uses from the Debugging module and decide for each: stays an assert (programmer contract) or becomes a typed throw (runtime condition the caller can act on)? Write the one-line criterion you applied, then verify every throw you introduced has a receiver.
- **C6 ★★ — The safe config loader.** Parse a `key=value` file: unknown keys throw `ConfigError` carrying the key; malformed lines are *reported* (counted) but don't stop the load; a missing file throws. Return the config only if **zero** malformed lines — otherwise throw with the count and the offending line numbers.
- **C7 ★★★ — The exception-safe stack.** Hand-rolled `IntStack` (array + size) from the arrays module: give `push` the strong guarantee — grow into a *new* array, then swap pointers, so a failed growth leaves the stack untouched. Prove it with a "fault-injecting" allocator that throws on the Nth allocation.
- **C8 ★★★ — The rollback object.** Build `Rollback onLeave(currentState)` — an object whose destructor *restores* the captured state unless `commit()` was called (a scope-guard in beginner form). Use it to give a two-step update strong safety, and explain why the destructor must be `no-fail` even though restoring can "fail".
- **C9 ★★★ — The error budget.** A batch importer processes 10,000 records. Design the policy: bad records are collected (line numbers + reasons) until they exceed a configurable budget (say 1%), then the load throws with a summary; under budget, the load succeeds *and reports* the skips. Write the invariant sentence the caller can rely on.
- **C10 ★★★★ — The audit harness.** Write a test program that *proves* exception safety: for a given operation, snapshot the state, run the operation with an injected failure (a throwing mock dependency), catch, and compare state to the snapshot — pass iff identical. Demonstrate it on the C7 stack and on one of your own classes, and print a per-case PASS/FAIL table.

---

## Solutions

**S1.**

```cpp
class FileError : public runtime_error {
public:
    FileError(const string& op, const string& path)
        : runtime_error(op + ": cannot open " + path), op(op), path(path) {}
    const string& getOp() const { return op; }
    const string& getPath() const { return path; }
private:
    string op, path;
};

ifstream openOrThrow(const string& path) {
    ifstream in(path);
    if (!in) throw FileError("open", path);
    return in;
}
```

The audit number is the real deliverable: most first-draft labs have 1–3 unguarded opens (species #1 in every one). After the refactor the pattern is mechanical — `ifstream in = openOrThrow(path);` — and the *decision* about failure lives at the caller, once per program, not once per file.

**S2.** The throwing variant is for callers that *must* have a value to proceed (menu setup, required config); the fallback variant is for callers with a sensible default (optional settings, "press Enter for default"). The rule in one sentence: **throw when proceeding without the value would be a lie; default when proceeding without it is a legitimate choice.**

```cpp
int readIntUntil(istream& in, int lo, int hi, int maxAttempts) {
    for (int a = 1; a <= maxAttempts; ++a) {
        int x;
        if (in >> x && x >= lo && x <= hi) return x;
        in.clear(); in.ignore(1000, '\n');
        cout << "(" << a << "/" << maxAttempts << ") enter " << lo << "-" << hi << ": ";
    }
    throw TooManyAttemptsError(maxAttempts);
}
```

**S3.** Two phases, mirroring the strong guarantee:

```cpp
bool transactAll(vector<BankAccount*>& accounts, const vector<double>& amounts,
                 LogFile& log) {
    // Phase 1: everything fallible, touching nothing.
    log.append("begin", amounts.size());                    // may throw
    for (double a : amounts)
        if (a < 0) throw InvalidAmountError(a);             // may throw
    // Phase 2: commits only — withdraw/deposit composed to never throw here.
    for (size_t i = 0; i < accounts.size(); ++i)
        accounts[i]->applyValidated(amounts[i]);            // pre-validated commit
    return true;
}
```

The honest limitation goes in the defence sentence: full all-or-nothing *across* objects requires either pre-validated commit operations or an undo log (C8's rollback object) — the phase structure is the beginner-honest version, and saying so *is* the design maturity.

**S4.**

```cpp
string prefix(const string& existing, const string& layer) {
    return existing.empty() ? layer : layer + ": " + existing;
}
// usage:  catch (...) { throw runtime_error(prefix("parse", "report: load")); }
```

The alternative — a `context` field accumulated by a custom `ChainedError` — keeps the original type and message machine-readable (no string parsing to recover structure) at the cost of one more class. Ship the class: the string stack reads well to humans but forces every consumer to parse to *dispatch* by kind, which is exactly what D3 taught not to lose.

**S5.** The criterion: **would a *user* of the finished program ever trigger this through legitimate input? Yes → typed throw. No (it means a programmer broke an internal contract) → assert.** Typical outcomes: `index >= 0 && index < size` inside a public API used with file-driven data → throw (`out_of_range`); `pointer != nullptr` before an internal helper → assert. The verification step is the teeth: every converted throw must trace to a handler — a throw with no receiver is a crash waiting for a user.

**S6.**

```cpp
Config loadConfig(const string& path, const set<string>& knownKeys) {
    ifstream in = openOrThrow(path);                        // missing file: throw
    Config c;
    vector<int> badLines;
    string line; int n = 0;
    while (getline(in, line)) {
        ++n;
        size_t eq = line.find('=');
        if (eq == string::npos) { badLines.push_back(n); continue; }   // report, continue
        string key = line.substr(0, eq);
        if (!knownKeys.count(key)) throw ConfigError("unknown key", key);  // throw
        c[key] = line.substr(eq + 1);
    }
    if (!badLines.empty())
        throw ConfigError("malformed lines", to_string(badLines.size())
                          + " at " + join(badLines));
    return c;
}
```

The policy split is deliberate: *unknown key* = a logic mismatch the maintainer must fix (loud, immediate); *malformed line* = data damage worth summarising (loud, but collected). One loader, two responses, each matching the failure's nature.

**S7.**

```cpp
void IntStack::push(int v) {
    if (size == cap) {
        int newCap = cap == 0 ? 4 : cap * 2;
        int* bigger = new int[newCap];       // may throw (bad_alloc / injected) — stack untouched
        for (int i = 0; i < size; ++i) bigger[i] = data[i];
        delete[] data;                       // only after the fallible work succeeded
        data = bigger;
        cap = newCap;
    }
    data[size] = v;                          // cannot throw for int
    ++size;
}
```

Proof: the fault-injecting allocator throws on the growth allocation; after the caught exception, `size` and `cap` are unchanged and all previous elements render correctly — the stack never saw the failure. The two-sentence defence: all fallible work precedes the pointer swap; the commit (`data = bigger`) is no-throw for this type.

**S8.**

```cpp
class Rollback {
public:
    Rollback(Inventory& inv) : inv(inv), snapshot(inv.snapshot()) {}   // capture on entry
    void commit() { done = true; }            // the caller accepts the new state
    ~Rollback() {                             // no-fail, ALWAYS
        if (!done) {
            try { inv.restore(snapshot); }
            catch (...) { cerr << "CRITICAL: restore failed\n"; }          // never lets anything out
        }
    }
private:
    Inventory& inv;
    Snapshot snapshot;
    bool done = false;
};
// usage:
void applyDiscount(Inventory& inv, double pct) {
    Rollback rb(inv);                 // scope guard armed
    inv.repriceAll(pct);              // may throw
    validateInventory(inv);           // may throw
    rb.commit();                      // only reached when everything succeeded
}
```

Why no-fail even though restore can fail: this destructor runs *during* any unwind of the two throwing operations — if restore's failure escaped, it would terminate the program and hide the original error. The escape hatch is honest: report "CRITICAL", leave a flag for the recovery layer, and let the original exception continue its flight.

**S9.** The invariant the caller relies on: **`importBatch` either throws (state untouched, summary in the exception) or returns normally having imported every parseable record and reported every skipped one with line numbers — never both, never neither.**

```cpp
struct ImportResult { int imported; vector<string> skipped; };   // skipped = "line 17: abc"

ImportResult importBatch(const string& path, double budgetPct) {
    // parse all rows, collect skips...
    double badPct = (double)result.skipped.size() / (result.imported + result.skipped.size());
    if (badPct > budgetPct)
        throw LoadError("importBatch: " + to_string(result.skipped.size())
                        + " bad records (" + to_string(badPct * 100) + "% > budget)");
    return result;   // skips already reported by the caller-facing print of the struct
}
```

The budget turns "how bad is acceptable" from a code constant into a *policy argument* — the same pattern as the config loader's malformed-line policy, generalised.

**S10.**

```cpp
struct Case { string name; function<void()> op; bool expectPass; };

bool auditOne(Inventory& inv, const Snapshot& before, function<void()> op) {
    try { op(); }
    catch (const exception&) { return inv.snapshot() == before; }  // threw: must be untouched
    return true;                                                    // succeeded: fine
}

int main() {
    Inventory inv = makeTestInventory();
    Snapshot before = inv.snapshot();
    vector<Case> cases = {
        {"push growth fault", [&] { faultNextAlloc(); inv.add(Item("x", 1)); }, true},
        {"negative price",    [&] { inv.setPrice(0, -5); },                    true},
    };
    for (const Case& c : cases) {
        bool ok = auditOne(inv, before, c.op);
        cout << (ok ? "PASS" : "FAIL") << "  " << c.name << "\n";
        inv.restore(before);              // reset between cases
    }
}
```

The harness's power is its *genericity*: any operation, any failure point, one criterion — **after a caught exception, state equals the pre-call state.** Running it on your own classes is the course's regression discipline (Debugging module) applied to the strongest promise this module made. The FAIL case it exists to catch: a `push` that mutates `size` before allocating — state changed, exception thrown, lie delivered.

---

*Every solution's last sentence is the design defence in compressed form — compare yours, then take the pattern to [the lab](labs.md).*
