---
title: "Class-Design Exercises — 10 Schema-First Drills"
description: "Ten design problems solved on paper first — invariants, interface tables, relationships, and test families — with separated design reviews."
---

# Class-Design Exercises — 10 drills

> [← Module home](index.md) · These problems start **before the code**. For each: run the [six-step method](lesson-3-design-composition.md#2-the-design-method--six-steps-from-requirements-to-class) (nouns → verbs → invariants → interface → birth → tests) **on paper**, then compare with the separated design review. "It compiles" is not the success criterion here — a defensible interface is.

**The deliverable per drill, before peeking:**

1. Attributes (name, type, initial value) — and *why each earns its place*
2. Invariants, written as sentences
3. Interface table: method / parameters / returns / mutates? / guards
4. Constructor parameters (the "birth")
5. Relationships, if more than one class
6. Test table: normal, boundary, invalid

---

- **D1 ★ — VendingMachine.** Stocks drinks with prices; a customer inserts coins (tracked as a running credit), selects a slot; the machine dispenses if credit covers price and stock exists, returns change credit; an owner restocks and collects money. Design the class (or classes).

- **D2 ★ — DigitalClock.** Holds hours/minutes/seconds; `tick()` advances one second with correct rollover (23:59:59 → 00:00:00); `toString() const` returns `HH:MM:SS`. The interesting question: which attributes have setters, and does *any* of them deserve one?

- **D3 ★★ — Elevator.** Serves floors 1–10; remembers current floor and direction; `call(floor)` queues a request (only 1–10 accepted); `step()` moves one floor toward the nearest pending request or idles. Design the state and the two methods' guards.

- **D4 ★★ — Playlist.** Holds song titles in order; `add`, `remove(title)`, `moveUp(title)`, `next() -> string` (wraps around), `current() const`. The invariant "current always names a real song" is the whole exercise.

- **D5 ★★ — Thermostat.** Target temperature, tolerance band (±0.5 °C), heater state (on/off). `update(currentTemp)` decides the heater; the invariant "the heater never flips state twice within one update" must hold *by construction*.

- **D6 ★★★ — ParkingGarage.** N slots; `admit(plate) -> bool` (full garage refuses), `release(plate) -> bool`, `occupancy() const`, `isPresent(plate) const`. Decide: vector of plates, or a fixed array with a count — and defend the capacity strategy from the Arrays module.

- **D7 ★★★ — Exam + Question (two classes).** An exam has questions, each with a prompt, four options, an answer index, and marks; the exam can `addQuestion`, `totalMarks() const`, and `grade(const int answers[], int n) const -> int`. Which class owns what, and why is `grade` on `Exam` rather than `Question`?

- **D8 ★★★ — BankAccount + TransactionLog (composition with a purpose).** The account from Lesson 1 gains a log of the last k operations (type, amount, resulting balance). The log is born and dies with the account. Design the inner class (or struct), the ownership, and `getStatement() const`.

- **D9 ★★★ — HotelRoom + Booking.** A room charges by tier (standard/deluxe — an `enum class`), tracks whether occupied, and by whom; `checkIn(guest) -> bool`, `checkOut() -> bool` (returns the charge: nights × tier rate — nights counted by the caller-supplied dates or a simple counter; state your choice). The one-way doors matter: no double check-in, no check-out of an empty room.

- **D10 ★★★★ — the mini schema audit.** Here is a *bad* design, given verbatim: `class University { public: string studentNames[5000]; double studentGpas[5000]; int courseCodes[200]; string courseTitles[200]; string registrarPassword; void setGpa(int i, double g) { studentGpas[i] = g; } };` Find every design failure you can (there are at least six), then produce the corrected design — as a diagram of classes with relationships, not one god-class.

---

<a name="design-reviews"></a>
## Design reviews — after your own sketch

**R1 — VendingMachine.** Attributes: `prices[5]`, `stock[5]`, `credit`, `collected`. Verbs distribute across roles: customer verbs (`insertCoin`, `select(slot) -> bool`, `refund()`) vs owner verbs (`restock(slot, qty)`, `collect() -> long long`) — one class is defensible; two (Machine + CoinBox) is better if you noticed the credit rules are a self-contained invariant ("credit ≥ 0 always"). Key guards: selection requires `stock[slot] > 0 && credit >= price[slot]`; on success both decrement properly and change credit = credit − price. Test families: exact change, over-insertion then selection, insufficient credit, empty slot, refund with/without credit. The review question this drill is built around: *who may call the owner verbs?* (In a real system, roles; in this course, document the assumption in a comment — the interface table is where that honesty lives.)

**R2 — DigitalClock.** Attributes: `h, m, s` (or one `secondsSinceMidnight` — even better: single attribute, rollover is one modulo, and `toString` derives h/m/s; praise whichever you chose *if you wrote the trade-off*). `tick()` mutates; guards are rollover arithmetic, not refusal — this class's boundaries are the wrap points. **Setters: none.** A clock that accepts `setHours(25)` is broken by design; time enters only through `tick()`. If you added setters "for completeness," the review pushes back: E9's Password lesson again — every door is a way in, and doors with no purpose are attack surface.

**R3 — Elevator.** State: `floor (1–10)`, `direction (idle/up/down)`, and a request set — a `bool requests[11]` (index 0 unused) is the honest beginner structure (the Arrays module's index-by-data tally, reused). `call(f)` guards `f ∈ [1,10]` and sets the flag; `step()` is the design's heart: if a request exists at the current floor, clear it and (decide!) keep direction; else move toward the nearest flagged floor in the current direction, flipping direction at the ends — or idle when no flags. Write the invariants as sentences first: "floor never leaves [1,10]"; "direction is idle iff no requests and nothing pending". Test families: single call up/down, two calls opposite directions, call to current floor, call during movement. Boundary: floors 1 and 10 direction flips. If your `step()` grew past ~15 lines, the review suggests extracting `nearestRequest() const` — methods are functions; the one-job rule still holds.

**R4 — Playlist.** `vector<string> songs; int current = 0;` The invariant "current names a real song" breaks at: `remove(current)` — the two defensible policies are (a) remove shifts current to the next song, (b) remove when only one song exists resets to empty-and-currentless (a `count == 0` state, requiring `current() const` to define a no-song answer — `""` and a `bool hasCurrent() const`). Whichever you chose, the tests must visit both edges: remove the current song; remove the last remaining song; `next()` on a one-song playlist (wraps to itself); `moveUp` on the first song (refuse or wrap — document). This drill exists because *states you didn't design are states users will visit.*

**R5 — Thermostat.** Attributes: `target`, `tolerance = 0.5`, `heating (bool)`. `update(double t)`: if `t < target - tolerance` → heating = true; if `t > target + tolerance` → heating = false; **inside the band: no change** — the "no double flip" invariant is enforced by doing nothing in the middle, which is why the band exists at all (a thermostat without hysteresis clicks on/off around the setpoint forever; the tolerance *is* the design). The review's extra credit: `isHeating() const`, and the observation that `update` is the *only* writer of `heating` — one door, one rule.

**R6 — ParkingGarage.** Capacity from the Arrays module: a `vector<string>` grows honestly and `full()` is `plates.size() == capacity`; a fixed array needs the count *and* the clamp discipline (P13's lesson). Either is defensible; the review wants the *reason* written. `admit` guards: not full, not already present (`isPresent` — a linear search, Algorithms module), plate non-empty. `release` guards: present. `occupancy() const` is derived — computed, never stored (the Records rule; storing a count parallel to the vector invites the drift the parallel-arrays section warned about). Tests: admit to capacity exactly, one over; release absent plate; double admit of the same plate; admit-release-admit same plate.

**R7 — Exam + Question.** `Question` owns its own data invariantly: options must be 4, answer index in `[0,3]`, marks > 0 — enforced in its constructor/setters; it offers `checkAnswer(int) const -> bool` and `getMarks() const`. `Exam` owns the collection (`vector<Question>`), the `addQuestion` door (maybe a limit), `totalMarks() const` (derived: sum — computed, never stored), and `grade`: because grading is *iteration over questions*, it belongs to the class that can see all of them — `Question` can't grade an exam, and putting `grade` on `Exam` keeps the answer-checking on `Question` while the *orchestration* sits with the owner. The relationship is composition (the exam owns its questions). The review's favourite question: should `grade` take `const int answers[]` with n, or `const vector<int>&`? Either — but say why (arrays-as-parameters bring the size-travels-separately rule; vectors carry their own size — Unit 09's choosing table, applied).

**R8 — BankAccount + TransactionLog.** Inner `struct Txn { string type; long long amount; long long resultingBalance; };` owned as `Txn history[10]; int txnCount = 0;` — a **ring buffer** (drop the oldest when full) or a clamp-then-stop; state the policy. Composition: the log is born (constructor) and dies (destructor) with the account — no separate lifetime, no ownership anxiety. `deposit`/`withdraw` append a record *after* a successful state change (the log records facts, not intentions — a refused withdrawal isn't a transaction; if you logged refusals too, that's defensible for an *audit* log: say so). `getStatement() const` prints or returns the entries — const, because reading the past changes nothing. The review question: why does the *account* validate and then log, rather than the log validating? (The invariant is the account's; the log is a record-keeper, not a policy-maker.)

**R9 — HotelRoom + Booking.** Attributes: `tier (enum class Tier { Standard, Deluxe })`, `ratePerNight`, `occupied (bool)`, `guest`, `nights` (or dates — the drill allows a simple counter if you *state* the simplification). One-way doors: `checkIn` refuses when `occupied` (no double booking); `checkOut` refuses when `!occupied`, computes `charge = nights * ratePerNight` by tier, resets state, **returns the charge** (a `bool` return can't carry it — the return-type row of your interface table should show `long long`). `Booking` as a separate class earns its keep only if bookings outlive or precede occupancy (aggregation — future reservations); if booking == occupancy, a second class is ceremony, and the review says so. Tests: check-in → check-out → check-in again; double check-in refused; check-out of empty room refused; charge arithmetic per tier.

**R10 — the schema audit.** The six-plus failures, itemized: (1) **two parallel arrays of students** — the Records module's founding horror: name[i] and gpa[i] held together only by index discipline (swap one without the other and the data corrupts silently); (2) **fixed magic capacities** (5000/200) with no clamp anywhere — `setGpa(6000, 3.9)` writes out of bounds; (3) **a public-ish `registrarPassword` in the same class** — unrelated responsibility stuffed into one type (the god-class smell; also a Password class exists for exactly this, E9); (4) **`setGpa` validates nothing** — a 9.4 GPA walks in (the guard was the one job the method had); (5) **index-keyed access** — no way to *find* a student except knowing the slot; no `find`, no invariants across the collection (duplicate entries trivially possible); (6) **no constructors** — the arrays are born unvalidated, and any subset of slots is "data". The corrected design: `class Student` (name, gpa with 0.0–4.0 guard, constructor) + `class Course` (code, title, roster) + `class University` **has-a** `vector<Student>` and `vector<Course>` with finding/admission methods — three nouns, three classes, relationships stated, each class defending its own invariants. If your redesign kept one big class, redo it — the audit's whole point is that *responsibilities want separate walls*.

---

## Where next

- [Labs](labs.md): the seven designed classes, implemented and tested.
- [The Object-Oriented Mini Project](miniproject.md): the records→classes refactor, in full.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
