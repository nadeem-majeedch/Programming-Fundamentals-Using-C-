---
title: "OOP Challenges — 10 Design-and-Build Problems"
description: "Ten challenges from sealed-class interfaces to state machines and ring-buffer logs, with separated approaches and solutions."
---

# Challenges — 10 problems

> [← Module home](index.md) · ★ to ★★★★. Each has a separated **approach** — design on paper first, commit to an interface, *then* read. Build and compile the ★★ and above; a design you never typed is a design you never tested.

- **C1 ★ — The sealed vault.** Write a `Safe` class whose only public members are `bool unlock(int code)`, `void lock()`, `bool isOpen() const`, and `void setCode(int oldCode, int newCode)`. Everything else is private. Then write `main` attempts (as comments) at every illegal access and note which the compiler rejects.
- **C2 ★ — The temperature twin.** Write a `Temperature` class storing **one** attribute (celsius) exposing `getCelsius() const`, `getFahrenheit() const`, and `setCelsius(double)` with the absolute-zero guard. The design question: is Fahrenheit stored or derived? Defend in one sentence.
- **C3 ★★ — The stopwatch done right.** Build `Stopwatch` (E8) with a *lap* feature: `start`, `lap() -> double` (seconds since start, without stopping), `stop() -> double`, `reset()`. Guard every out-of-order call. Tabulate the test matrix (actions × orderings).
- **C4 ★★ — The queue at the counter.** Implement `class TokenQueue` for a bank: `takeToken() -> int` (sequential, starting 1), `serveNext() -> int` (returns the served token, or −1 when empty), `waiting() const`, `reset()` (refuses when people wait). Decide the storage; defend the `reset` guard.
- **C5 ★★ — The revision-proof Quiz class.** The Records module's quiz marks (array of 3, −1 sentinel) become a class with `setMark(int quiz, int m)`, `mark(int quiz) const -> int`, `average() const`, `grade() const` (A ≥ 90…), and *no* way to read or write the raw array. Refactor from E6 and state what the class now guarantees that the struct couldn't.
- **C6 ★★★ — The bank with statement.** Extend BankAccount (Lesson 1) into `BankAccountPlus` with a **ring-buffer statement** (D8's design): last 10 transactions, `getStatement() const` printing them, and a `transfer(BankAccountPlus& to, long long amount) -> bool` that is all-or-nothing (both accounts change or neither does — including the statement entries).
- **C7 ★★★ — The vending machine with change.** D1's machine, extended: it holds coin inventory (count of 1s, 2s, 5s, 10s) and must *make change* or refuse the sale. Design the change algorithm's guards (`canMakeChange(amount) const`) before coding.
- **C8 ★★★ — The immutable coordinate.** Write `class Coord` with **no setters at all**: born by constructor, plus `movedBy(dx, dy) const -> Coord` returning a *new* object, and comparison `bool sameAs(const Coord&) const`. Explain what the lifetime cost of `movedBy` is, and why immutability buys safety anyway.
- **C9 ★★★★ — The library, end to end.** Combine the drills: `Book` (C5-style guarded status transitions), `LibraryMember` (S25's 3-book invariant), and `Library` (owns both collections; `borrow(memberId, isbn) -> bool` enforces *every* rule through the member classes, never by reaching into them). The design question: where does each rule live? Write the rule-to-method map.
- **C10 ★★★★ — The report card, printed.** Take the mini-project's roster of `Student` objects and add `ostream& operator<<(ostream&, const Student&)` and a `printClassReport(const vector<Student>&)` free function producing an aligned table (roll no, name, marks, average, grade) with a class-summary footer. Constraint: `printClassReport` may only use public const methods — no friends, no back doors.

---

## Approaches and solutions

**A1.** Attributes `code`, `open` — both private. `unlock` guards `!open && code matches`; `lock` guards `open` (or is idempotent — decide, document); `setCode` requires the vault open *or* the old code correct (real-world: closed vaults need the old code — state your rule). The exercise's payoff is the *comment audit*: `s.code = 0;` and `if (s.open)` must both be compile errors — if either compiles, a member is misplaced (D1's label lesson). Bonus: make the code `private` and *also* delete any temptation for a `getCode()` — a vault that reports its code is E9's Password lesson.

**A2.** Fahrenheit is **derived**: one storage attribute means one place where validity is enforced; a stored fahrenheit is a second fact that can drift (D8's lesson). `getFahrenheit() const { return celsius * 9.0 / 5.0 + 32; }` — the formula needs the `9.0` (integer `9/5` is 1 — the Foundations module's division trap, still biting). The one-sentence defence: *storing a conversion invites two temperatures disagreeing; deriving makes disagreement impossible.*

**A3.** State: `running (bool)`, `startedAt`, `lapStart` (clock_t). Guards: `lap`/`stop` refuse when `!running`; `start` refuses when already running; `reset` refuses while running. `lap()` returns seconds since `lapStart` and *re-anchors* `lapStart = now`; `stop()` returns since start and sets `running = false`. Test matrix rows: start→lap→lap→stop (two laps then total); start→stop→start (restart resets anchors — decide!); lap before start (refused); stop twice (second refused); reset while running (refused). The matrix is the deliverable — a stopwatch with unguarded orderings is the D6 bug family at method scale.

**A4.** Storage: `int nextToken = 1; vector<int> queue;` — `takeToken` pushes `nextToken++` (no upper bound needed at this scale; document the assumption); `serveNext` pops the front (`queue.erase(queue.begin())`) or returns −1; `waiting()` is `queue.size()` — derived, never stored. `reset()` guards `queue.empty()` — you may not forget people who are waiting; that's the point of the guard (a real-world system would schedule them elsewhere; here it refuses). Boundaries: serve on empty (−1, and the vector never underflows); take-serve interleavings; reset with waiters.

**A5.** The class hides `int marks[3]` behind `setMark` (guards: index 0–2, mark 0–100) and `mark(int quiz) const` (returns the sentinel or the mark — or −1 documented as "not entered"). `average()` skips sentinels and guards the empty case; `grade()` derives from `average()` — the Records module's derived rule, twice over. The guarantee the struct couldn't make: *no code outside the class can write `marks[2] = 150` or read raw slots to average sentinels themselves* — the invariant is structural. Bonus: `operator<<` (Lesson 3) for pretty printing.

**A6.** The ring buffer: `Txn history[10]; int count = 0; int head = 0;` — `record(type, amount, resulting)` writes at `head`, `head = (head + 1) % 10`, count clamps at 10. `transfer` is the design's teeth: validate once (`amount > 0`, sufficient balance), then mutate **both** accounts through their guarded methods and record on **both** statements — if any step refuses, neither statement records (all-or-nothing; note honestly that a full exception-safe version is next-course material, and the guard-first structure is the beginner-grade equivalent). `getStatement() const` walks from oldest (head − count + 10) % 10. Tests: transfer larger than balance (nothing moves); transfer exactly the balance; full-ring wrap (11 transfers → statement shows the last 10, oldest dropped).

**A7.** Change design: `canMakeChange(change) const` — greedily check from the largest coin: take `min(available[10], change/10)` tens, remainder to 5s, 2s, 1s; return true iff remainder hits 0 *with real counts*. (Greedy is exact for coin systems where each coin divides the next-sum — true for {1,2,5,10}; state the assumption, don't invent it.) The sale: guard credit ≥ price **and** `canMakeChange(credit − price)` **and** stock > 0 *before* mutating anything; then decrement stock, move coins (credit → inventory, change → out), reset credit. Tests: exact change, change available, change unavailable (refuse, credit intact — the crucial row), coin inventory exhausted edge.

**A8.** `Coord(int x, int y) : x(x), y(y) {}` — parameters shadow members, so either rename (course rule) or `this->` (S16); the initializer list avoids the whole question: `Coord(int px, int py) : x(px), y(py) {}`. `movedBy` returns `Coord(x + dx, y + dy)` — a **new** object; the cost is a copy per move (the lifetime/copy answer the challenge asks for). Why immutability anyway: a `Coord` that cannot change can never be corrupted mid-use — every holder's value is the value they were given (the Debugging module's "make illegal states unrepresentable" at its purest). Use case honesty: good for points, dates, money; wrong for objects whose identity is their mutability (a BankAccount that couldn't change balance would be useless).

**A9.** The rule-to-method map (the deliverable):

| Rule | Lives in | Method |
| --- | --- | --- |
| book is borrowable only if Available | `Book` | `borrow()` guard |
| book must be actually borrowed to return | `Book` | `giveBack()` guard |
| member holds ≤ 3 | `LibraryMember` | `borrow()` guard |
| member can't hold the same title twice | `LibraryMember` | `borrow()` guard |
| member exists / id valid | `Library` | `findMember()` |
| book exists / isbn valid | `Library` | `findBook()` |

`Library::borrow` is orchestration only: find both parties (−1/`nullptr` refusal), call `member.borrow(title)` then `book.borrow()` — and note the ordering subtlety: if the book says no after the member said yes, *undo* the member's state (or check both *before* mutating either — cleaner; state it). The design principle the map teaches: **each rule lives in the class that owns the data it constrains** — the Library coordinates, it doesn't reach into fields. If your first draft had `Library::borrow` writing `book.status = ...` directly, that's D10's hole rebuilt; fix the architecture, not just the line.

**A10.** `operator<<` uses the getters (Lesson 3's signature, `const&` parameter): roll no width 4, name left-padded, marks `setw(4)` each, average `fixed << setprecision(1)`, grade as a char method. `printClassReport` iterates `const Student&`, accumulates class average and per-grade counts (the algorithms module's tally array — reused, again), and prints the footer. The constraint is the point: **a free function that only touches public const methods cannot corrupt anything** — the report layer is safe by construction. If you were tempted to `friend` it, ask what getter was missing; add the getter, keep the wall.

---

## Where next

- [Labs](labs.md): the seven scenario classes, specified and solved.
- [The Object-Oriented Mini Project](miniproject.md): everything assembled.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
