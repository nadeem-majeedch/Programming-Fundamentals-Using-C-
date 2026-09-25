---
title: "Inheritance Exercises — 22 Drills in Three Parts"
description: "Part A base/derived/order, Part B virtual/polymorphism/slicing, Part C abstract/interfaces/design — each with a separated solution."
---

# Exercises — 22 drills, three parts

> [← Module home](index.md) · Attempt before opening solutions — separated below each part. ★★ items: compile with `-Wall -Wextra`; the `override` keyword turns several of these drills into compiler conversations.

## Part A — Base, derived, order (E1–E7)

- **E1 ★** Write `class Vehicle` (brand, `describe() const` printing brand) and `class Car : public Vehicle` adding `doors` and a `honk()`. In `main`, call all three methods on one Car through the Car itself. Which methods came from where?
- **E2 ★** Give `Vehicle` a two-argument constructor and make `Car`'s constructor pass through the initializer list. Then remove the pass-through and read the compiler error — write down what it says about base construction.
- **E3 ★** Write the three-level `Animal → Dog → Puppy` hierarchy with a `Tracer`-style print in each constructor and destructor. **Predict the six output lines in writing**, then run and compare.
- **E4 ★★** Put a `Tracer` member in each of the three classes (E3) and re-predict: nine build lines, nine raze lines, interleaved with bodies. What is the rule for where *members* land relative to *bodies*?
- **E5 ★★** Add a `protected long long balance = 0;` to `Account` and write `SavingsAccount::addMonthlyInterest()`. Then attempt (as a commented-out line) `acc.balance = 0;` from `main` and note the compiler error. Now write the course's preferred alternative: `private balance` + a `protected` `adjustBalance(long long delta)` hook — and state in one comment what invariant the hook must guard.
- **E6 ★★** In `class Base { public: void f() const; void f(int) const; };` and `class D : public Base { public: void f() const; };`, which base overloads are callable on a `D` object, why, and what one line fixes it?
- **E7 ★★★** A `Sensor` base has `private double reading;` and a public `read()` that validates `0 ≤ r ≤ 100` before storing. A subclass wants a "calibration offset" applied before validation. Design the honest mechanism: which members move to `protected`, in what form (attribute? method?), and what sentence defends it?

### Solutions A

**S1.** `describe()` and the brand data are `Vehicle`'s (inherited); `doors`, `honk()` are `Car`'s additions. The point of the drill is naming the source per call — inherited vs added — which is the is-a substance made visible.

**S2.** `Car(const string& b, int d) : Vehicle(b), doors(d) {}` — without the pass-through, the compiler seeks `Vehicle`'s default constructor, doesn't find one (a user constructor exists), and refuses: *"no matching constructor for initialization of 'Vehicle'"* (or equivalent). The error's lesson: the base subobject **must** be constructed, and the initializer list is the only place to choose how.

**S3.** Predicted: `Puppy body`... carefully — construction climbs: **A(Animal) body → Dog body → Puppy body**; destruction descends: **~Puppy → ~Dog → ~Animal**. Six lines total (one per ctor/dtor). If you predicted Puppy-first construction, re-read Lesson 1 §5: *bases before bodies on the way up*.

**S4.** Each level prints *member first, then body* (members build before the constructor body runs — the OOP module's initializer rule, now per level). Build order: A-member, A-body, D-member, D-body, P-member, P-body; destruction mirrors: P-member, ~P-body, D-member, ~D-body, A-member, ~A-body. The rule: **members of a level build with that level, before that level's body — and every level's member+body waits for its complete base.**

**S5.** `addMonthlyInterest() { balance += balance / 100; }` compiles under `protected`. The `main` attempt fails: *"'balance' is protected within this context"* — protected reaches derived classes, never the world. Preferred alternative: keep `balance` private and add `protected: bool adjustBalance(long long delta) { if (balance + delta < 0) return false; balance += delta; return true; }` — the hook *carries the invariant* ("never negative") instead of handing out raw access; `addMonthlyInterest` calls the hook. The defending sentence: *the base's rule survives every future subclass because the wall is thinner, not gone.*

**S6.** Only `D::f()` is callable — `D`'s redeclaration **hides both** base overloads (Lesson 1 §3), so `d.f(3);` is a compile error ("too many arguments" / no matching function). Fix: `using Base::f;` in `D`'s public section un-hides the family.

**S7.** The offset is *degree*, not access: make it a `private` member of the subclass with its own setter (a `Sensor` shouldn't know calibration exists), and route the store through a new **`protected` method** in `Sensor`: `protected: bool storeValidated(double r) { if (r < 0 || r > 100) return false; reading = r; return true; }`. The subclass's `read()` adds its offset to the incoming raw value, then calls `storeValidated`. Defending sentence: *the validation invariant stays in the base where it belongs; the subclass contributes its transformation without ever touching `reading`.*

## Part B — virtual, polymorphism, slicing (E8–E15)

- **E8 ★** Take Lesson 2's `Shape`/`Circle`/`Rect`. Remove the word `virtual` from `area()` and run the gallery loop again. What prints, and why? Restore `virtual` and add `override` in both subclasses — what changed?
- **E9 ★** Write `class Animal { public: virtual void speak() const { cout << "...\n"; } virtual ~Animal() = default; };` plus `Dog` ("Woof") and `Cat` ("Meow") overrides. Loop over `Animal* arr[] = {&d, &c};` printing each — then flip the base's `speak` to non-virtual and state the difference.
- **E10 ★★** A `Drawable` interface (pure `draw() const`, virtual destructor) with `Square` and `Circle` implementers; a `render(const vector<Drawable*>&)` free function. Add a `Triangle` with **zero changes** to `render` — and write the sentence that explains why zero changes were possible.
- **E11 ★★** Demonstrate slicing: `Circle c(2.0); Shape s = c; cout << s.area();` — predict, run, then fix in two ways (reference alias, pointer) and state which fix belongs in a *collection* and why.
- **E12 ★★** Give `Shape` a non-virtual `describe()` that calls virtual `area()` (Lesson 2's centrepiece) and verify `s->describe()` dispatches per object. Then answer: what breaks if `describe()` were virtual *and* each subclass overrode it? (Nothing compiles-wrong — but what maintenance debt appears?)
- **E13 ★★** Write `Base` with a virtual destructor printing "~Base" and `Derived` (holding a `Tracer` member) whose destructor prints "~Derived". `Base* p = new Derived; delete p;` — predict the exact output. Then delete the word `virtual` from the base destructor, predict, and run (observe honestly — note that anything may happen, and what typically does).
- **E14 ★★★** Build `class Report` holding `vector<Shape*>` with `add(Shape*)`, `totalArea() const`, and a destructor that deletes every stored shape. Then state the ownership rule in one comment at the class head — and answer: why does the destructor have to loop-delete, and what happens to that code when smart pointers arrive next course?
- **E15 ★★★** A `Bird : Animal` adds `fly()`. Code does `Animal* a = new Bird; a->fly();` — why is this a compile error, what is the design question it raises (is `fly` part of the *Animal* contract?), and what are the two honest designs?

### Solutions B

**S8.** Non-virtual: every line prints `area = 0` — the pointer's type (Shape) picks the function at compile time; the overrides are hiding, invisible through base pointers. Restoring `virtual` (+ `override` in the subclasses) restores per-object dispatch: 12.5664, 12, 0.785398. What changed with `override`: the compiler now *verifies* each signature really overrides — the two words convert silent hiding into checked overriding.

**S9.** Virtual: "Woof" then "Meow" — the objects answer. Non-virtual: "..." twice — the Animal window answers for both. One keyword, one behaviour; the drill is seeing the difference *twice in one program*.

**S10.** `render` iterates `const Drawable*` and calls `draw()` — a pure contract; `Triangle : public Drawable` with an override slots in untouched. The sentence: *`render` was written against the contract, not the implementers, so new implementers are invisible to it* — the open-closed idea in beginner form.

**S11.** Prediction: `0` (the Circle part — radius and vptr — never survives the by-value copy; `s` is a plain Shape). Fixes: `Shape& alias = c;` (alias keeps the object; dispatch works) or `Shape* p = &c;` (same, by address). Collections need the **pointer** (or smart pointer) form: a `vector<Shape&>` isn't a legal container; `vector<Shape>` slices; `vector<Shape*>` stores addresses so each object keeps its own table.

**S12.** `describe()` prints each object's own area — the shared-wrapper-calls-virtual-hook pattern. The maintenance answer: overriding `describe` in every subclass duplicates the printing skeleton everywhere (the DRY rule across the hierarchy); future formatting changes become N edits. Non-virtual shared code + virtual hooks keeps one skeleton.

**S13.** With virtual: `~Derived` then its member's raze line, then `~Base` — the Lesson 1 order, dispatched correctly. Without `virtual`: only `~Base` prints — the Derived part and its `Tracer` member are never destroyed (undefined behaviour; typically the member's resources leak, and your output is one line shorter than the truth).

**S14.** Ownership comment: *"Report owns every Shape added; it deletes them all at death; callers must not delete a shape they handed over (and must not add one owned elsewhere)."* The destructor loops `delete` because raw pointers know nothing of ownership — someone must. Next course: `vector<unique_ptr<Shape>>` deletes itself element-by-element; the loop and the comment both evaporate — the rule stays, the machinery automates.

**S15.** Compile error: `fly()` isn't part of `Animal`'s interface, and the compiler checks the *static* type. The design question: would *every* Animal plausibly answer `fly`? No — so putting it on the base fattens the contract (mistake #2). Honest designs: (1) a second interface — `class Flyer { public: virtual void fly() const = 0; virtual ~Flyer() = default; };` and `class Bird : public Animal, public Flyer` (interface multiple inheritance, safe by no-state); (2) keep birds in a `vector<Flyer*>` for flying code and a `vector<Animal*>` for animal code — collections follow the contract they need.

## Part C — Abstract, interfaces, design (E16–E22)

- **E16 ★** Make Lesson 2's `Shape` abstract (`area()` pure virtual). Verify: `Shape s;` now fails to compile — quote the error. Can `Shape` still have attributes and a constructor? Try, and explain the answer.
- **E17 ★** Write the `Printable` interface (pure `print`, virtual destructor) and implement it on `Invoice` (number) and `Receipt` (amount). A `printAll(const vector<Printable*>&)` prints both.
- **E18 ★★** One class, **two** interfaces: `class Document : public Printable, public Saveable` — implement both. Why is this safe when multiple inheritance of *implementation* classes is the classic tangle? (Answer in one sentence about what pure interfaces carry.)
- **E19 ★★** Convert Lesson 2's `operator<<` to work on *any* `Printable` via the hook idiom (Lesson 3 §2). Verify `cout << invoice << "\n";` compiles and prints.
- **E20 ★★** `class Square : public Rectangle` — write it, attempt `sq.setWidth(3); sq.getHeight()`, and expose the behavioural break (does width stay equal to height?). Then rewrite the design without inheritance (either immutable values or composition) and say which sentence won.
- **E21 ★★★** A `MediaFile` base has `play()`, `duration()`, and ten methods subclasses ignore. Diagnose the design smell, split it into two small interfaces your three formats (Audio, Video, Podcast) genuinely satisfy, and show a function for each interface that accepts mixed collections.
- **E22 ★★★** Refactor a switch: given `enum Kind { CIRCLE, RECT };` and a `drawShape(Kind, ...)` with an if/else chain, design the polymorphic replacement (abstract `Shape` + `draw()` override + a container), and list what *never needs editing again* when a `Triangle` arrives.

### Solutions C

**S16.** Error: *"cannot declare variable 's' to be of abstract type 'Shape'"* (plus a note naming the unimplemented pure virtual). Yes — attributes and constructors remain legal: abstract classes have **state and birth logic**; what they lack is *instantiation*. The base constructor still runs as step 1 of every derived construction (Lesson 1's order). Abstract ≠ empty.

**S17.** `class Printable { public: virtual void print(ostream& out) const = 0; virtual ~Printable() = default; };` — implementers put their own fields private and print through them. `printAll` is written against the contract and never changes again (E10's sentence, at interface scale).

**S18.** `class Document : public Printable, public Saveable` — safe because pure interfaces carry **no data and no implementation**: there is nothing to duplicate or conflict (no diamond of state), only two promise-sets to fulfil. The tangle that class-scaled multiple inheritance invites is shared *state* with ambiguous paths — interfaces have none.

**S19.** `ostream& operator<<(ostream& out, const Printable& p) { p.print(out); return out; }` — takes the interface by `const&`, calls the pure hook, returns the stream. Every implementer, present and future, prints with `<<`. The OOP module's operator pattern, generalized once.

**S20.** With inheritance: `setWidth(3)` on the Rectangle part leaves `height` untouched — a "square" 3×4 exists, and the class's name now lies. The rewrite: make `Rectangle` immutable (set in constructor only) — then a Square *can* be a Rectangle because no promise can be broken — **or** drop the relationship and give Square its own class (a square is data, not behaviour). The winning sentence, stated either way: *is-a is about keeping every promise, not about the geometry.*

**S21.** Smell: fat base (mistake #2) — ten methods, three subclasses, most stubbed. Split by genuine capability: `Playable` (play, duration) — Audio, Video, Podcast all qualify; `Streamable` (bufferSize, supportsLive) — Video and Podcast qualify, Audio doesn't. `playAll(const vector<Playable*>&)` and `streamAll(const vector<Streamable*>&)` each accept their mixed collections; Audio sits in the first, never the second — the interface is the admission ticket, honestly priced.

**S22.** The design: `class Shape { public: virtual void draw() const = 0; virtual ~Shape() = default; };` with `Circle::draw`, `Rect::draw`; the container `vector<Shape*>` (or smart pointers); the loop `for (const Shape* s : shapes) s->draw();`. What never needs editing when Triangle arrives: `drawShape` (it's gone), the loop, the container type, every caller. Only *one new file* (Triangle). The enum-and-switch version edits the enum, the switch, and every function with a kind parameter — the maintenance delta *is* the argument for polymorphism.

## Where next

- [Debugging hunts](debugging.md): ten broken hierarchies.
- [Design problems](design.md): ten is-a judgements.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
