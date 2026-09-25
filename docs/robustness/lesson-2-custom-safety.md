---
title: "Lesson 2 — Custom Exceptions, Exception Safety, and the End of Silent Failures"
description: "Exception types as classes, stdexcept hierarchy for a domain, the four exception-safety levels, validation layering, the silent-failure gallery, and what not to do with exceptions."
---

# Lesson 2 — custom exceptions, exception safety, and the end of silent failures

> [← Module home](index.md) · [← Lesson 1 — try/catch/throw](lesson-1-try-catch-throw.md) · [Refactor workshop →](refactor.md)

## In this lesson you will learn

- why a real application defines its **own exception types** — and how the OOP module's inheritance finally earns this keep
- the standard `stdexcept` derivation pattern for a domain
- the **four levels of exception safety** and which one to aim for
- how to layer validation so failures are caught at the cheapest layer
- the **silent-failure gallery** — and how to exterminate each species

## 1. Why custom exceptions

A generic `runtime_error("error")` reaches a `catch` and the handler knows only that *something* went wrong. But your application knows more: a bank withdrawal failed *because of insufficient funds* — a condition the **caller** may want to treat differently from, say, a network failure. Different *kinds* of failure deserve different *types*, so handlers can select by type — the same dispatch idea as `catch (const out_of_range&)` before `catch (const exception&)`.

Custom exception types are just classes — usually inheriting from a standard one so the family net still catches them:

```cpp
#include <stdexcept>
#include <string>
using namespace std;

// The domain's exception family — one per failure KIND, not per failure SITE.
class BankError : public runtime_error {          // everything bank-shaped
public:
    explicit BankError(const string& msg) : runtime_error(msg) {}
};

class InsufficientFundsError : public BankError { // withdrawal > balance
public:
    InsufficientFundsError(double requested, double available)
        : BankError("insufficient funds: requested " + to_string(requested)
                    + ", available " + to_string(available)),
          requested(requested), available(available) {}
    double getRequested() const { return requested; }
    double getAvailable() const { return available; }
private:
    double requested, available;                  // data rides along!
};

class InvalidAmountError : public BankError {     // negative / NaN-shaped input
public:
    explicit InvalidAmountError(double amount)
        : BankError("invalid amount: " + to_string(amount)) {}
};
```

Three design notes worth memorising:

1. **Derive from `runtime_error`**, not bare `exception` — then `e.what()` works for free and the family net still catches your types.
2. **One type per failure kind the caller might want to *distinguish*** — not one per `if`. Three to five types is a healthy domain family; thirty is a design smell.
3. **Carry data.** `InsufficientFundsError` knows the requested and available amounts — the handler can *format a real message* instead of parsing one. This is what makes exceptions richer than an `int` error code.

## 2. The throw site and the catch site, end to end

```cpp
// 02_custom.cpp — the full journey of a domain exception.
// Compile: g++ -std=c++17 -Wall -Wextra 02_custom.cpp -o custom

#include <iostream>
using namespace std;
// ... BankError family from above ...

class BankAccount {
public:
    BankAccount(double opening) : balance(opening) {
        if (opening < 0) throw InvalidAmountError(opening);
    }
    void withdraw(double amount) {
        if (amount <= 0)  throw InvalidAmountError(amount);
        if (amount > balance) throw InsufficientFundsError(amount, balance);
        balance -= amount;                        // reached only when valid
    }
    double getBalance() const { return balance; }
private:
    double balance;
};

int main() {
    try {
        BankAccount acct(100.0);
        acct.withdraw(150.0);                     // the failure
        cout << "never printed\n";
    }
    catch (const InsufficientFundsError& e) {     // the SPECIFIC desk
        cout << "declined: " << e.what() << "\n";
        cout << "shortfall: " << e.getRequested() - e.getAvailable() << "\n";
    }
    catch (const BankError& e) {                  // the FAMILY desk
        cout << "bank error: " << e.what() << "\n";
    }
    catch (const exception& e) {                  // the WORLD desk
        cout << "unexpected: " << e.what() << "\n";
    }
}
```

**Output:**

```text
declined: insufficient funds: requested 150.000000, available 100.000000
shortfall: 50.000000
```

The catch ladder reads like an escalation procedure: specific first, family second, world last — and because `BankError` derives from `runtime_error`, a `bad_alloc` from deep inside would still land in the world desk. Also notice the invariant held: the failed withdrawal left the balance at 100, untouched — which is exactly the exception-safety promise, next.

## 3. Exception safety — the four levels

When an exception flies through code, what state does the code leave behind? Professionals name four answers:

| Level | Promise | Example |
| --- | --- | --- |
| **No-fail** | never throws (destructors, swaps) | destructors; the course's "no-fail" cleanup layer |
| **Strong** | either succeeds completely, or the program state is as-if-never-called | `push_back` with a copyable element; the transaction pattern below |
| **Basic** | no leaks, invariants hold, state is *valid* (but maybe changed) | most everyday functions — the realistic default target |
| **No guarantee** | anything may be broken | the bug class — hunt [D6](debugging.md) |

The rule of thumb this course endorses: **aim for basic everywhere, strong where it matters (money, files, anything a user retries), no-fail only destructors and swaps.** And the tool that delivers basic safety almost for free is the one the course has been building since the pointers module: **ownership by stack objects**. If every resource lives in a destructor-bearing object (`string`, `vector`, `unique_ptr`, your file wrapper), unwinding cleans up automatically and basic safety is your default, not your achievement.

The **strong guarantee** has one classic shape — do all the fallible work *before* any irreversible change:

```cpp
// Strong: commit only after everything fallible has succeeded.
void importMarks(vector<int>& target, const string& path) {
    vector<int> fresh = loadMarks(path);   // may throw — target untouched
    // ... validate fresh, may throw ...
    target = fresh;                        // the commit — noexcept in spirit
}
```

If `loadMarks` or validation throws, `target` still holds its old contents: as-if-never-called. If you had appended into `target` directly, a mid-import throw would leave it half-loaded — basic-at-best, and a confused user's next action operates on a mystery state.

## 4. Validation layering — catching failures at the cheapest layer

The course's robustness picture is now complete enough to draw as layers:

```text
┌─ Layer 1: PREVENT  — interfaces that make mistakes impossible
│    (constructors that validate; enums instead of magic ints; ask-doors)
├─ Layer 2: GUARD    — boundary checks with re-prompt (expected user error)
│    (readIntInRange; menu loops; empty-file checks before use)
├─ Layer 3: THROW    — domain failures that must travel upward
│    (custom family; stdexcept types; rethrow-with-context)
└─ Layer 4: NET      — last-resort handlers around main / worker threads
     (catch (const exception&), then catch (...); log, apologise, stop)
```

Two placement rules:

- **Fail at the cheapest layer that fully understands the failure.** A negative amount is cheapest to reject in the `withdraw` guard — not after it has corrupted a log three layers up. An unreadable file is cheapest at the open — not after 10,000 lines were parsed into a vector that must now be discarded.
- **Every layer below the boundary is allowed to assume the boundary validated.** Functions-layer trust is the OOP module's encapsulation promise again: `withdraw` still guards (defence in depth), but the *menu* is where bad input is expected to arrive.

## 5. The silent-failure gallery

<a name="5-the-silent-failure-gallery"></a>

Silent failure: code that proceeds as if nothing went wrong when something did. Six species, all met earlier in this course, all fatal to trust:

| # | Species | Symptom seen earlier in the course | Extermination |
| --- | --- | --- | --- |
| 1 | The ignored return | `in.open(path);` with no `if (!in)` — Files module Lab 1's first bug | open-check-close ritual; now: `throw` on failure |
| 2 | The swallowed catch | `catch (...) {}` — the exception vanishes with its news | never catch without at least logging; rethrow what you can't handle |
| 3 | The defaulted value | `int n = atoi(s);` — garbage in becomes a plausible 0 | checking converters; `stoi` + catch, or the cctype validators |
| 4 | The partial write | program "finishes" after 3 of 500 records failed to parse — and reports success | count failures; throw (or report the count loudly) at the end |
| 5 | The lying success return | `bool remove(...)` returns `true` even when nothing matched | return what happened; let the caller decide if that's an error |
| 6 | The half-updated object | `withdraw` deducts, then the log write throws — money gone from one view | strong guarantee: do fallible work before the irreversible step |

The Debugging module's law returns as this module's first law: **refuse silently, or refuse loudly — never refuse quietly.** Every `catch` must do one of three things: fix the situation, rethrow, or terminate the operation *with a report*. Anything else is species #2.

## 6. What NOT to do with exceptions

- **Don't use `throw` for ordinary control flow.** A missing record in a search is a `nullptr`/`end()` return (the ask-door), not an exception — exceptions are for the *unexpected*, and their cost reflects it.
- **Don't throw from destructors.** During unwinding, destructors are already running; a second exception mid-unwind terminates the program instantly. Destructors are the no-fail level — cleanup only. (Hunt [D5](debugging.md) is exactly this.)
- **Don't `catch` what you can't meaningfully handle.** A function that catches-and-continues with broken state converts one crash into ten wrong answers. Let it fly to a layer that can act.
- **Don't lose the type.** `catch (const exception& e) { throw runtime_error(e.what()); }` flattens every custom type into one — handlers downstream can no longer distinguish decline from corruption. Rethrow the *same* object (`throw;`) after enriching, or not at all. (Hunt [D3](debugging.md).)

## 7. The robust reader, final form

Everything in the module so far, in the twelve lines students will recognise from the functions labs — upgraded:

```cpp
// readIntInRange, final form: guard layer + report layer.
int readIntInRange(istream& in, int lo, int hi) {
    int x;
    while (!(in >> x) || x < lo || x > hi) {
        if (!in) { in.clear(); in.ignore(1000, '\n'); }
        cout << "Enter a number " << lo << "-" << hi << ": ";
    }
    return x;   // the boundary GUARANTEES lo <= x <= hi — layers below may assume it
}
```

and its file-shaped sibling from Lesson 1, `loadMarks` — guards at the open, throws in the depths, context in the rethrow. Between the two, the application's data can arrive only clean or not at all.

## Recap

- Custom exceptions are classes derived (in this course) from `runtime_error`: one type per failure **kind**, carrying the data the handler needs.
- Catch ladders escalate: specific → family → world; every object below the specific desk is sliced-proof because you caught by `const&`.
- Exception safety levels: no-fail (destructors), strong (fallible work before the irreversible commit), basic (valid state, no leaks — the everyday target), none (the bug).
- Validate in layers: prevent, guard, throw, net — cheapest layer that fully understands the failure.
- The six silent-failure species all die by the same rule: every refusal is loud.

## Practice

1. Add `DepositError`-shaped validation: extend `BankAccount` with `deposit(double)` that throws `InvalidAmountError` for non-positive amounts. Write the test ladder: −50, 0, 25 — predict which throw, which commit.
2. Give `importMarks` a *failure-count* variant: instead of throwing on the first bad line, collect bad line numbers and throw a `LoadError` carrying all of them at the end. What level of guarantee does the new version have?
3. Find one species-1 silent failure in your own earlier lab code (any file open without a check). Fix it two ways — guard-layer return, and throw-layer `runtime_error` — and write two sentences on which fits that program's shape and why.

→ Continue to the [Refactor workshop](refactor.md) — eight earlier programs, rebuilt.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
