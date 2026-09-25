---
title: "Design Problems — 10 Inheritance Judgements"
description: "Ten design problems where the is-a test, the composition alternative, and the interface shape matter more than the code — with separated design reviews."
---

# Design Problems — 10 judgements

> [← Module home](index.md) · These problems are decided **before code**. For each: write (1) the is-a sentence and its substitutability check, (2) the class diagram (or composition diagram), (3) the interface table for the abstract base if there is one, (4) the composition alternative and why you kept or rejected it. The [reviews](#design-reviews) grade the reasoning.

---

- **DP1 ★ — The zoo enclosure.** A zoo tracks animals in enclosures: every animal has a name and a feed cost; mammals nurse their young; birds fly in shows. Design the hierarchy — and decide where `fly()` lives.

- **DP2 ★ — The car that wanted to be an engine.** A junior proposes `class Car : public Engine` "so `car.start()` works for free." Run the is-a test out loud, then design the honest version, including which methods Car exposes.

- **DP3 ★★ — The stack that shouldn't.** `class Stack : public Vector` is proposed: "the storage is written, why rewrite it?" Diagnose the is-a failure concretely (which inherited methods break Stack's rules?), then design the composition version — including which Vector operations the Stack *exposes*.

- **DP4 ★★ — The square's revenge.** `Square : Rectangle` — argue it fully: the mathematical case, the behavioural break (which promise fails?), the two rescues (immutable rectangles; or no relationship), and the final verdict with its sentence.

- **DP5 ★★ — Notification channels.** A system notifies users by Email, SMS, and Push. A `notify(msg)` loop must accept all three — and a fourth channel (Slack) arrives next quarter with zero loop changes. Design the interface, the implementers, and the loop. Which mistake-gallery entry does this design *prevent*?

- **DP6 ★★ — Shapes of saving.** Every document type (Invoice, Report, Memo) must `save()` and `print()`, but only some can `compress()`. Design the interfaces so `compress` is *impossible to call* on a Memo — and a new type that can compress slots in with no loop changes.

- **DP7 ★★★ — The personnel menu.** A university has Teachers, Students, and Staff — all are People (name, id), but their operations barely overlap. Someone proposes a god-base `Person` with every operation virtual. Diagnose the design smell, then design with the smallest honest base plus per-role interfaces.

- **DP8 ★★★ — Discount strategies.** A checkout applies exactly one price rule per order: NoDiscount, PercentageOff, FlatOff, BuyOneGetOne. New rules are promised quarterly, and the active rule may be **swapped after the order is created**. Decide: inheritance or composition — and defend against the losing option in one paragraph.

- **DP9 ★★★ — The media player's plugin contract.** Third parties will write plugins: each must `play(stream)`, report `supportedFormats()`, and guarantee it releases resources. Design the plugin interface *as its documentation* — every pure virtual justified, the destructor's virtuality explained, and one sentence on what a plugin author is *not allowed* to assume.

- **DP10 ★★★★ — The audit of a bad diagram.** Here is a proposed hierarchy, given verbatim: `Database : FileManager` ("to reuse file I/O"); `User : Database` ("users live in the database"); `AdminController : User` ("the admin *is* the most important user"). Find every is-a failure, name the mistake-gallery entry each one commits, and redraw the honest architecture (composition directions included).

---

<a name="design-reviews"></a>
## Design reviews — after your own sketch

**R1 — The zoo enclosure.** Honest base: `Animal` (name, `feedCost() const` — pure virtual or defaulted-with-data depending on whether cost is per-species data or per-kind rule). `Mammal : Animal` adds nursing (`nurse()`); `Bird : Animal` adds flight — and **`fly()` lives on Bird, not Animal** (E15's design question): the zoo's *show schedule* takes `vector<Bird*>`, the *feeding report* takes `vector<Animal*>` — two contracts, two collections, no stubbed methods. The review's extra question: is `Mammal` needed at all if nursing never appears in code? (No — a level with no behaviour is ceremony; DP7's lesson in miniature.)

**R2 — The car that wanted to be an engine.** The is-a sentence fails out loud: "a car **is an** engine" — false; the substitutability check kills it (an Engine cannot park, a Car cannot rev standalone). Honest version: `class Car { ... private: Engine engine; public: void start() { engine.ignite(); } ... }` — Car *has an* Engine, exposes the verbs drivers need, hides the rest (Car must not expose `engine.setSparkTiming()` — exposure is a choice, inheritance would have made it a law). Gallery entries prevented: #1 (reuse-only inheritance) and #5 (god hierarchies) in miniature.

**R3 — The stack that shouldn't.** The concrete break: `Stack` inheriting `Vector` inherits `insert(i, v)` and `remove(i)` — a stack's contract (*last-in, first-out, ends only*) is violated by its own inherited interface; a `Vector` used where a `Stack` is expected can insert into the middle, and Liskov fails *in the concrete*. Composition version: `class Stack { private: Vector data; public: void push(int v) { data.pushBack(v); } int pop() { ... } bool isEmpty() const; }` — the Stack *exposes* push/pop/isEmpty only; the Vector's full interface stays interior. The reuse is identical; the honesty is total.

**R4 — The square's revenge.** Mathematical case: every square is a rectangle (area, perimeter formulas hold). Behavioural break: `Rectangle` promises *independent* `setWidth`/`setHeight` (each changing one side only — observable via subsequent `area()`); a Square cannot keep that promise (`setWidth(3)` must also change height, surprising every Rectangle-thinking caller). Rescue 1 — **immutability**: `Rectangle(w, h)` fixed at birth; `Square(s)` fixed at birth; now a Square *can* inherit because no promise can ever be tested-and-broken (E20's verdict, formalized). Rescue 2 — **no relationship**: two classes, shared math via free functions or a shared value type. Final verdict sentence, either way: *substitutability is about promises, and mutable setWidth is the promise Square can't sign.* Gallery entries: #1's mirror (refusing to abstract when the contract is fixable) avoided by stating which rescue and why.

**R5 — Notification channels.** Interface: `class Notifier { public: virtual bool notify(const string& msg) const = 0; virtual ~Notifier() = default; };` — implementers Email/SMS/Push/Slack each validate their own channel rules (addresses, phone format). The loop: `for (const Notifier* n : channels) n->notify(msg);` — written once; Slack's arrival touches **one new file**. Gallery entry prevented: #10 (the switch-chain that edits every function per new kind) — the loop *is* the polymorphic table.

**R6 — Shapes of saving.** Two small interfaces, not one fat one: `Saveable { virtual void save() const = 0; }` (all three types) and `Compressible { virtual void compress() const = 0; }` (Invoice, Report — not Memo). A function `compressAll(const vector<Compressible*>&)` *cannot compile* with a Memo in the collection — the type system is the guarantee, not a runtime check. Gallery entries prevented: #2 (fat base) and its runtime cousin, the `if (canCompress)` flag.

**R7 — The personnel menu.** Smell diagnosed: god-base (#5) — `Person` with `gradeExam()`, `paySalary()`, `enrollCourse()` all virtual means Teachers stub student operations and Students stub staff ones; every stub is a lie the compiler keeps. Honest design: smallest honest base — `Person` (name, id, maybe `describe()`) — plus per-role interfaces where code genuinely mixes roles (e.g. `Payable` for Staff and Teachers-if-paid; `Identifiable` if systems need a common lookup). The review's key sentence: *a base earns its size from the operations that are common, not from the classes that share a building.*

**R8 — Discount strategies.** **Composition** — and the defender must name the two killers: (1) the runtime swap ("active rule may change after creation") — inheritance fixes the base at birth (Lesson 3's decision procedure, step 5), composition holds an interface reference that can be re-pointed; (2) quarterly new rules — new rule = one new `PricingRule` implementer, zero checkout edits. The class: `class Order { private: const PricingRule* rule; public: long long total() const { return rule->apply(items); } void setRule(const PricingRule* r); }`. The paragraph against inheritance: a `PercentageOffOrder : Order` family multiplies order-classes by rules (and locks the rule at construction), while composition prices any order with any rule — the N×M explosion versus the plug-in.

**R9 — The plugin contract.** The interface *as documentation*:

```cpp
// Plugin contract — third parties implement this.
// 1. play(stream) MUST return false (not throw/abort) on unsupported streams.
// 2. supportedFormats() MUST NOT change during the plugin's lifetime.
// 3. Release every resource in your destructor — it WILL be called through this pointer.
class PlayerPlugin {
public:
    virtual bool play(const Stream& s) = 0;
    virtual vector<string> supportedFormats() const = 0;
    virtual ~PlayerPlugin() = default;   // virtual: the host deletes through PlayerPlugin*
};
```

The destructor's virtuality *is* clause 3's enforcement mechanism (D4's hunt, promoted to contract). The not-allowed sentence: *a plugin may not assume which other plugins exist, may not retain ownership of anything the host hands it, and may not store the host's pointers past the call* — contracts bound what implementers assume, which is the whole point of writing them down.

**R10 — The audit.** Failure by failure: `Database : FileManager` — "a database **is a** file manager" is false (a database *uses* storage); gallery #1. `User : Database` — "a user is a database" is absurd; it was proposed *because* the first inheritance gave User file I/O — the mistake compounding (#5: one convenience relationship birthing a family of lies). `AdminController : User` — "the admin is the most important user" confuses *role/permission* (a value: `enum class Role`) with *identity* (a class); also #1. Redrawn: `class Database { private: FileManager storage; ... }` (composition — owns its storage); `class User` standalone (id, name, `Role role`); `class AdminController { ... }` *uses* `Database&` and checks `user.role` — three honest relationships, each passing the test spoken aloud. The review's closing line: *the bad diagram inherited three times to move three pieces of data; the honest architecture composes twice and enums once.*

---

## Where next

- [Labs](labs.md): five hierarchies built with the test applied.
- [The Media Library mini-project](miniproject.md): the design-defence in full.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
