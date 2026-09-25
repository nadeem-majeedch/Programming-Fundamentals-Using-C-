---
title: "Robustness Exercises — 15 Problems"
description: "Fifteen graded exercises on try/catch/throw, custom families, safety levels, and silent-failure eradication — solutions in a separated section."
---

# Exercises — 15 problems

> [← Module home](index.md) · Attempt each problem in writing **before** opening its solution — the [course protocol](../how-to-study.md). Part A: the machinery. Part B: design and safety.

## Part A — the machinery (E1–E8)

- **E1 ★ — First throw.** Write `double celsiusToFahrenheit(double c)` that throws `invalid_argument("celsius below absolute zero")` when `c < -273.15`, otherwise converts. Write a `main` that calls it with −300 inside a `try` and prints the message from the catch, then calls it again with 25 — both calls inside the *same* `try`. Predict the output before running.
- **E2 ★ — Catch order.** Given a function that may throw `out_of_range` and another that may throw `runtime_error`, write a `try` with two `catch` blocks — but place `catch (const exception& e)` **first**. What happens for each throw? Then swap the order and confirm the difference.
- **E3 ★ — The three-dot net.** Write a function `mystery(int mode)` that throws `42` when `mode == 1`, `"boom"` when `mode == 2` (a C-string literal), and `runtime_error("clean")` when `mode == 3`. From `main`, call it three times through one `try` whose only handler is `catch (const exception& e)`. Which calls land in the handler, and which terminate the program?
- **E4 ★★ — Unwinding observation.** Build a class `Tracer` whose constructor prints `"born"` and destructor prints `"died"`. Write `void levelTwo() { Tracer t2; throw runtime_error("boom"); }` and `void levelOne() { Tracer t1; levelTwo(); }`. Call `levelOne()` from a `try` in `main`. Write down the exact output order, then run and compare.
- **E5 ★★ — Rethrow with context.** Write `int parseAge(const string& s)` that calls `stoi(s)` in a `try`, catches `invalid_argument` and `out_of_range`, and rethrows as `runtime_error("parseAge: bad age string: " + s)` in both cases. From `main`, call it with `"abc"`, `"99999999999999"`, and `"19"` and print the three outcomes.
- **E6 ★★ — The boundary reader, exception edition.** Rewrite `readIntInRange` (the validation-suite reader) so that instead of re-prompting forever it gives the caller **three attempts** and then throws `runtime_error("readIntInRange: three bad attempts")`. Write the `main` that catches it and exits with a polite message.
- **E7 ★★ — Data on the exception.** Extend the Lesson 2 `InsufficientFundsError` with a third field: `double shortfall() const`. Write `main` that withdraws too much and prints `"add 45.50 to continue"` — computed from the exception object, not from any outside variable.
- **E8 ★★ — Guard vs throw, decided.** Two situations: (a) the user types a bad menu number; (b) `saveAll()` cannot open its output file mid-session. For each, state the layer (guard or throw) and the reason in one sentence — then implement both in one small program skeleton.

## Part B — design and safety (E9–E15)

- **E9 ★★ — The domain family.** Design the exception family for a hotel-booking domain: booking failed because the room is occupied; because the dates are inverted; because the guest is unknown. Write the three classes (derive from `runtime_error` via a shared `BookingError`), each carrying the data a handler would need. Then write the catch ladder that handles "occupied" differently from the rest.
- **E10 ★★ — Strong by ordering.** The `removeAndLog` pattern (refactor R8) reversed: a function must write the log entry *before* updating the in-memory cart. Rewrite it so a log failure cannot desynchronise the two systems, and state the safety level achieved.
- **E11 ★★ — The swallowed catch.** Fix this code without deleting the catch — the requirement is that a failed load is *reported* but the program may continue with an empty list:
  `try { marks = loadMarks(path); } catch (const exception&) { }`
- **E12 ★★★ — The no-fail destructor.** A `SessionLog` object writes a closing line in its destructor. A teammate wrote it to `throw runtime_error` when the file write fails. Explain (in three sentences) the exact scenario in which this crashes the program, then fix it in the only correct way.
- **E13 ★★★ — The four levels, identified.** For each snippet, name its exception-safety level and one sentence of justification:
  (a) `void f(vector<int>& v) { v.clear(); v.push_back(1); }`
  (b) `void g(vector<int>& v) { vector<int> tmp = build(); v = tmp; }` (`build` may throw)
  (c) `~Guard() { delete ptr; }`
  (d) `void h(BankAccount& a) { a.withdraw(50); log.write("withdrew 50"); }` (`log.write` may throw)
- **E14 ★★★ — The layered menu.** Sketch (pseudocode is fine) the four validation layers for a "student registration" program: the constructor that prevents invalid students; the boundary guard for input; the domain throw for "course full"; the last-resort net. Mark for each layer one concrete check that lives there — and one that does **not** belong there.
- **E15 ★★★★ — Refactor on demand.** Take the Files module's Lab 4 (Marks Report) solution and produce the refactor-workshop write-up for it: original snippet, invited failure (name the species number), robust version, what changed. Your robust version must include one guard-layer check, one throw, and one catch-and-rethrow-with-context.

---

## Solutions

*(Attempt first. The solutions are the *shape* of an answer — yours may differ and still be right.)*

**S1.** The second call's output never appears in the same run: the first throw vacates the whole `try` block, so control jumps to the catch and the program continues *after* it. To exercise both paths through one `try` each, the second call needs its own `try`. Output:

```text
caught: celsius below absolute zero
98.6
```

The lesson the exercise is built for: one `try` guards one attempt — a "resume after failure" flow needs either multiple `try` blocks or a loop around one.

**S2.** With `exception` first, **both** throws land in the `exception` block — the specific `catch` blocks below it are unreachable for those types (base-first swallows derived). After swapping, `out_of_range` goes to the specific desk and `runtime_error` to the family desk. The compiler accepts both orders silently; only the behaviour changes — which is why hunt [D2](debugging.md) exists.

**S3.** `mode == 3` lands in the handler (`runtime_error` is an `exception`). Modes 1 and 2 throw things that are **not** `std::exception` — `int` and a string literal — so no handler matches, unwinding reaches `main`'s top with no reception desk, and `std::terminate` ends the program. `catch (...)` is the only net that would have caught them. The design lesson: throw *exception-derived types only*; the type system is your dispatch table.

**S4.** Exact output:

```text
born
born
died
died
caught: boom
```

`t2` is born inside `levelTwo`, so it dies *first* when the throw unwinds that frame; then `t1` dies as `levelOne` unwinds; then the catch runs. Reverse order of creation — the unwinding rule from Lesson 1's diagram, now observed rather than stated.

**S5.** `"abc"` → caught, rethrown, prints `parseAge: bad age string: abc`. `"99999999999999"` → `out_of_range` (the number doesn't fit `int`), rethrown with the same enriched message — the catch *both* handlers feed. `"19"` → prints `age: 19`. The enrichment line is identical for both, which is the point: the caller reports the *string*, not the internal converter's vocabulary.

**S6.**

```cpp
int readIntInRange(istream& in, int lo, int hi) {
    for (int attempt = 1; attempt <= 3; ++attempt) {
        int x;
        if (in >> x && x >= lo && x <= hi) return x;
        in.clear();
        in.ignore(1000, '\n');
        cout << "(attempt " << attempt << " of 3) Enter a number "
             << lo << "-" << hi << ": ";
    }
    throw runtime_error("readIntInRange: three bad attempts");
}
```

The guard layer keeps the *expected* case (one typo, fixed) cheap and quiet; the *persistent* failure escalates. Boundary validation stays local; escalation is the event.

**S7.**

```cpp
double shortfall() const { return requested - available; }
```

and the handler prints `fixed`-precision to two decimals. The design point: the handler needed **no access to the account, no globals, no parsing** — the exception carried its own report. Data-carrying exceptions turn handlers into reporters.

**S8.** (a) Guard layer: a bad menu number is *expected every session*, the fix is local (re-prompt), and throwing would make the main loop unreadable. (b) Throw: a mid-session save failure is *unexpected*, the function cannot fix it (the menu cannot open files), and the application layer must choose between retry, discard, or abort. One sentence each — but the *decision* was the exercise.

**S9.**

```cpp
class BookingError : public runtime_error {
public: explicit BookingError(const string& m) : runtime_error(m) {}
};
class RoomOccupiedError : public BookingError {
public: RoomOccupiedError(const string& room) : BookingError("occupied: " + room), room(room) {}
        const string& getRoom() const { return room; }
private: string room;
};
class InvertedDatesError : public BookingError { /* check-in, check-out carried */ };
class UnknownGuestError  : public BookingError { /* guest id carried */ };
```

The ladder: `catch (const RoomOccupiedError&)` first (offer alternatives), then `catch (const BookingError&)` (report and refuse), then the world net. One type per failure *kind* — three, not thirty, because the handler's behaviour really does differ for occupied vs everything else.

**S10.** The fallible step must come first and the in-memory commit last:

```cpp
void addToCartAndLog(Cart& cart, LogFile& log, const Item& it) {
    log.append("adding " + it.name());   // may throw — cart untouched
    cart.add(it);                        // commit last (basic-safe)
}
```

Strong guarantee, by ordering: if the log throws, the cart is as-if-never-called and a retry is safe. (If `cart.add` could throw *after* the log write, the order would be wrong the other way — the analysis is always: which step leaves the system lying if it succeeds alone?)

**S11.** Swallowed species #2 becomes a *reported* continuation:

```cpp
try {
    marks = loadMarks(path);
} catch (const exception& e) {
    cerr << "warning: marks unavailable (" << e.what() << ") — continuing empty\n";
    // marks stays empty; every later use is guarded or informed
}
```

The catch now does one of the three legal things (fix / rethrow / report-and-stop-the-operation). A continued program with an *announced* empty state is honest; a continued program with a *silent* empty state is the bug.

**S12.** The scenario: an exception is already unwinding (say, `loadMarks` threw) — during unwinding, every live destructor runs; if `~SessionLog` throws *now*, there are two active exceptions and `std::terminate` fires instantly, hiding the original error. The only correct fix: the destructor catches its own failure and reports it non-throwingly (`cerr`, a flag, a "flush failed" note) — destructors are the no-fail level. A "critical flush" belongs in an explicit `close()` the *user* calls, where throwing is legal.

**S13.** (a) **No guarantee** — a throw from `push_back` leaves `v` cleared-but-empty: valid memory, but the operation half-happened on the caller's data with no promise. (b) **Strong** — all fallible work happens in `tmp`; the commit `v = tmp` doesn't throw for `vector<int>`; failure leaves `v` as-if-never-called. (c) **No-fail** — a destructor doing cleanup only (and `delete` on a valid owned pointer doesn't throw). (d) **Basic** — if `log.write` throws, the account state is valid (money moved, invariant intact) but the pair is half-updated — no lie, no leak, no strong promise.

**S14.** Layer sketch: *prevent* — `Student`'s constructor throws on age < 5; the `Course` object cannot exceed capacity (ask-door returns false). *guard* — the menu's reader re-prompts on non-numeric input. *throw* — `enroll` throws `CourseFullError` (carrying course code and seats) when a race between check and add still fails, and `RegistrationError` rethrown with student+course context. *net* — `main`'s `catch (const exception&)` then `catch (...)`, logging and stopping politely. What does **not** belong: re-prompt loops below the menu (a library function should not interrogate the user), and `CourseFullError` thrown from the constructor (a constructor builds *valid* objects; fullness is a *use-time* condition of the course, not the student).

**S15.** A complete answer has all four parts. The grade points: the *invited failure* must name a species (e.g. "species #1 — `ifstream in(path)` unchecked, missing file prints an empty report"); the robust version's guard must be at the boundary (empty-vector refusal), the throw typed with context (`"loadMarks: cannot open " + path`), and the rethrow enriched at a *different* layer than the catch that finally handles it. If all three tools appear in one function, the layering is wrong — that observation is half the exercise.
