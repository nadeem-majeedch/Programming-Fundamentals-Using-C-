---
title: "Records Debugging Exercises"
description: "10 seeded bugs — the missing semicolon, arrow/dot confusion, positional brace traps, uninitialized members, laundered enums, and the parallel-array ghost."
---

# Records Debugging Exercises (10)

> [← Module home](index.md) · Work each in the [debugging protocol](../arrays/debugging.md): reproduce → form hypotheses → instrument → fix → **reflect**. Records add a first step: **re-read the struct definition** — most record bugs are a lie between the schema and the code that uses it.

**Format.** Each snippet compiles (unless stated) but misbehaves. Hint ladders are collapsible — one rung at a time. [Fix-list summary](#fix-list-summary) at the end.

---

## D1 — The error that isn't here (missing semicolon)

```cpp
struct Student {
    std::string name;
    int score;
}                                   // ← nothing wrong on THIS line, says the compiler

int main() {
    Student a = {"Ali", 78};
    std::cout << a.name << '\n';
}
// Compiler: error: expected ';' after struct definition (or something stranger, later)
```

<details markdown="1"><summary>Hint 1 — which line does the compiler report, and which line is guilty?</summary>

The struct definition needs a closing **semicolon**: `};`. The compiler only notices at the *next* construct — the error location is a clue, not a confession.
</details>

<details markdown="1"><summary>Hint 2 — the habit</summary>

Read `};` as one token when writing types — brace, brace-semicolon — and when an error points *after* a struct, look **up** at the definition first.
</details>

**Reflection.** Struct-definition errors report downstream. The schema is the first suspect whenever the scene of the reported crime makes no sense.

## D2 — The arrow that wasn't (dot/arrow confusion)

```cpp
void bumpScore(Student* s) {
    s.score += 5;        // error: member reference type 'Student *' is not a structure
}
```

<details markdown="1"><summary>Hint 1 — what does <code>s</code> hold: the record, or the address of one?</summary>

The address. `s.score` asks an *address* for a member — type error. Through a pointer you follow first: `s->score += 5;` (or the noisy `(*s).score += 5;`).
</details>

**Reflection.** One question resolves every access: *do I hold the record or the address of one?* Record → dot; address → arrow. ([Lesson 2 §1](lesson-2-functions-nesting.md#door-2--by-pointer-the-handle-crosses))

## D3 — The swapped birthday (positional braces)

```cpp
struct Date { int y; int m; int d; };
struct Employee {
    std::string name;
    Date        hired;
    double      salary;
};

int main() {
    Employee e = {"Sana Mir", {2024, 3, 15}, 85000.0};   // intended: hired 15 March 2024
    std::cout << e.hired.y << '-' << e.hired.m << '-' << e.hired.d << '\n';
}
// Prints: 2024-3-15  — but the intent was d=15, m=3... is it right? Now change intent:
Employee f = {"Sana Mir", {15, 3, 2024}, 85000.0};       // "15/3/2024" — what did this BUILD?
```
The second record compiles silently and is garbage.

<details markdown="1"><summary>Hint 1 — what does the nested brace list bind to?</summary>

**Position, in declaration order**: `Date { y, m, d }` — so `{15, 3, 2024}` built year **15**, month **3**, day **2024**. No error, no warning — just a record that lies ([Lesson 1 §4](lesson-1-structs.md#initialization--three-ways-and-one-rule)).
</details>

<details markdown="1"><summary>Hint 2 — the two defences</summary>

Validate (`isValid` from E11 rejects year 15 immediately) and prefer member assignment for wide records: `f.hired.y = 2024; f.hired.m = 3; f.hired.d = 15;` — every value beside its name.
</details>

**Reflection.** Brace lists bind by position, never by name — the schema's order *is* the list's meaning. Wide records get member assignment; every record gets validation.

## D4 — The zero that passed (uninitialized + partial fill)

```cpp
struct Attempt {
    std::string name;
    int score;
    int items;      // number of questions — set at creation!
};

Attempt readAttempt() {
    Attempt a = {"Ali"};          // quick partial fill...
    std::cout << "score: ";
    std::cin >> a.score;
    return a;                      // a.items is... ?
}
// later: double pct = 100.0 * a.score / a.items;   // division by... what?
```

<details markdown="1"><summary>Hint 1 — what does a partial brace list do to missing members?</summary>

Zeroes them — silently. `items` is 0, looks legitimate, and detonates at the division ([gallery G6](lesson-3-enums-design.md#6-the-common-mistakes-gallery)).
</details>

<details markdown="1"><summary>Hint 2 — the fix, and the design question</summary>

Complete the fill (`a.items` read and validated like score), or use full member assignment so no member is forgotten. Design question: if `items` is *always* 5 for this quiz, does it belong as a per-record field at all — or is it a constant?
</details>

**Reflection.** Zero-initialized means "quietly wrong", not "safely empty". Every field either gets a real value or a *documented* sentinel.

<a name="d5"></a>
## D5 — The laundered state (enum input trap)

```cpp
enum class Status { ACTIVE, FROZEN, GRADUATED };

int main() {
    int code;
    std::cin >> code;                                  // user types 9
    Status st = static_cast<Status>(code);             // compiles!
    switch (st) {
        case Status::ACTIVE:     std::cout << "active\n"; break;
        case Status::FROZEN:     std::cout << "frozen\n"; break;
        case Status::GRADUATED:  std::cout << "graduated\n"; break;
    }
    std::cout << "done\n";
}
// Input 9 → prints only "done". No case matched. No error. The record now carries state 9.
```

<details markdown="1"><summary>Hint 1 — is <code>static_cast</code> a validator?</summary>

No — it's a launderer. It converts *any* int to the enum type, including values no member has. The switch then matches nothing, silently.
</details>

<details markdown="1"><summary>Hint 2 — the cure (two forms)</summary>

Validate-then-cast (`if (code < 0 || code > 2) reject;`) or map through a menu function (`pickStatus`) so only real members are ever produced ([Lesson 3 §4](lesson-3-enums-design.md#4-the-enum-input-trap--and-the-cure)).
</details>

**Reflection.** A cast changes the *type*, never the *truth*. Enum inputs cross a validation gate or they don't cross.

## D6 — The ghost of parallel arrays (partial swap)

```cpp
struct Item { std::string name; int qty; };

void restock(Item shelf[], int n) {
    // move the last item to the front, "efficiently":
    Item last = shelf[n - 1];
    for (int i = n - 1; i > 0; i = i - 1)
        shelf[i] = shelf[i - 1];
    shelf[0] = last;           // ← but the author ALSO keeps a legacy parallel array:
    // prices[0] = prices[n-1]; ... forgot to rotate it!
}
```
Symptom: after restocking, item names/quantities rotate but the *prices* array still lines up with the old order — records lie by half.

<details markdown="1"><summary>Hint 1 — which two facts must always move together, and what structure guarantees that?</summary>

A record's fields. The parallel `prices[]` array is the drift surface the struct was invented to kill — keep price **inside** `Item` and the rotation moves it for free.
</details>

<details markdown="1"><summary>Hint 2 — the deeper fix</summary>

Delete the parallel array; migrate the field into the record ([Lesson 1 §5](lesson-1-structs.md#5-arrays-of-structures--the-payoff)). Any "second array that must move in lockstep" is the ghost of the old design.
</details>

**Reflection.** If two datasets must change together, they are **one** dataset. The struct is the type-system way of saying so.

## D7 — The copy that fooled the test (by-value mutation)

```cpp
void enrollLate(Student s) {      // intended: add 5 late-penalty to the record
    s.score -= 5;
}

int main() {
    Student a = {"Ali", 78};
    enrollLate(a);
    std::cout << a.score << '\n';   // prints 78 — the penalty vanished
}
```

<details markdown="1"><summary>Hint 1 — what crossed the call?</summary>

A **copy** ([Lesson 2 §1](lesson-2-functions-nesting.md#door-1--by-value-a-copy-crosses)). `s.score -= 5` penalized the copy; the original never knew.
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`void enrollLate(Student& s)` — the alias modifies the caller's record. (The compiler can't catch this one — a value parameter is *legal*; only the intent is wrong. This is why the door choice is a design decision, not syntax trivia.)
</details>

**Reflection.** "It compiled and ran" is not a pass. Only the test table (expected 73, actual 78) catches a door taken by mistake.

## D8 — The nested nobody (unvalidated nested record)

```cpp
struct Patient { int id; std::string name; Date admitted; bool critical; };

Patient readPatient() {
    Patient p;
    std::cout << "id: ";   std::cin >> p.id;
    std::cin.ignore(1000, '\n');
    std::cout << "name: "; std::getline(std::cin, p.name);
    std::cout << "critical: "; std::cin >> p.critical;
    // admitted: never read!
    return p;
}
```
Later: the ward report prints `admitted 0-0-0` — a record whose nested member is all zeros, looking almost legitimate.

<details markdown="1"><summary>Hint 1 — which member never got a real value, and what does it hold?</summary>

`admitted` — a `Date` of zeros. Nested members don't initialize themselves ([gallery G3](lesson-3-enums-design.md#6-the-common-mistakes-gallery)).
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`p.admitted = readDate();` — route the nested record through its validating factory ([Lesson 2 §2](lesson-2-functions-nesting.md#date--the-record-with-rules)). Construction goes through checkpoints — *all* of them, nested included.
</details>

**Reflection.** Every member, at every depth, gets a real value through a validating door. Zeros in a date are a design smell, not a default.

## D9 — The leaky catalogue (returned-handle confusion)

```cpp
// The author wants a function that "finds the cheapest book":
Book* cheapest(Book shelf[], int n) {
    int best = 0;
    for (int i = 1; i < i; i = i + 1)          // (typo'd loop — also find this!)
        if (shelf[i].price < shelf[best].price) best = i;
    return &shelf[best];
}

int main() {
    Book shelf[3] = { /* ... */ };
    Book* c = cheapest(shelf, 3);
    delete c;              // ← the real crime
}
```
Two bugs are planted. Find both before reading the hints.

<details markdown="1"><summary>Hint 1 — who owns <code>shelf</code>'s memory?</summary>

`main` does — `shelf` is a stack array. `delete c;` releases a slice of a **non-heap** block: undefined behaviour. A pointer *into* someone else's array is a borrowed view, never a deletion ticket ([ownership](../pointers/lesson-3-arrays-dynamic.md#ownership)).
</details>

<details markdown="1"><summary>Hint 2 — and the loop?</summary>

`i < i` — always false, so the loop never runs and `best` stays 0: the "cheapest" is always the first book. Two lessons: `i < n` (the classic), and — bigger — for a *value* question ("which book is cheapest?"), **return the record, not a pointer** ([E13's rule](exercises.md#s13)): `Book cheapest(...)`.
</details>

**Reflection.** Pointers returned from searches point *into existing data* — they are views, not owners. And value questions deserve value returns.

## D10 — The enum that printed a number

```cpp
enum class Level { BEGINNER, INTERMEDIATE, ADVANCED };

int main() {
    Level l = Level::INTERMEDIATE;
    std::cout << "level: " << l << '\n';    // prints "level: 1"
}
```
Expected (by the author): "intermediate". Observed: `1`.

<details markdown="1"><summary>Hint 1 — what does the compiler know an enum to be?</summary>

An integer in a costume. `cout` prints the underlying value — the *name* exists only in your source code, not at runtime.
</details>

<details markdown="1"><summary>Hint 2 — the fix, and why it's a feature</summary>

Write the bridge: `std::cout << "level: " << levelText(l) << '\n';` ([Lesson 3 §2](lesson-3-enums-design.md#2-comparing-switching-printing)). The bridge function is your single point of naming truth — add a member, update one function.
</details>

**Reflection.** Enum names live in source, not in memory. Every enum that faces a human gets a `xText()` bridge; every bridge gets one home.

---

<a name="fix-list-summary"></a>
# Fix-list summary

| D | Bug (one line) | Fix (one line) |
| - | -------------- | -------------- |
| D1 | `};` missing on the struct | read `};` as one token; look up at the schema when errors point low |
| D2 | `.score` through a pointer | `s->score` |
| D3 | positional brace list built a lying Date | member assignment + `isValid` gate |
| D4 | partial brace list zeroed `items` | complete fill or documented sentinel — every field, real value |
| D5 | cast laundered 9 into Status | validate-then-cast / menu mapper |
| D6 | parallel price array left behind by the rotation | move the field into the record — one dataset |
| D7 | by-value parameter mutated a copy | `Student&` when the callee must modify |
| D8 | nested `admitted` never read | route every nested member through its factory |
| D9 | `delete` on a borrowed view (+ `i < i`) | views aren't owners; value questions return values |
| D10 | enum printed as its integer | the `xText()` bridge function |
