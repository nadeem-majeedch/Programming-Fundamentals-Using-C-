---
title: "Lesson 3 — Enums and the Discipline of Organizing Data"
description: "enum and enum class for named sets and states, the input trap, designing record schemas before coding, and the mistakes gallery."
---

# Lesson 3 — Enums and the Discipline of Organizing Data

> [← Module home](index.md) · [← Lesson 2 — Moving records around](lesson-2-functions-nesting.md) · [Exercises →](exercises.md)

## In this lesson you will learn

- **enum** — how a named set of constants replaces magic numbers
- **enum class** — the scoped, safer form, and when each is the right tool
- the enum **input trap** (and its validation cure)
- the design habit that is the real title of this lesson: **organizing related data before writing logic**
- the module's mistakes gallery

---

## 1. The magic-number problem

You have been writing these all course — and squinting at them later:

```cpp
if (s.status == 2)        // ...2 was... what?
std::cout << "grade F";   // wait, is 0 A or is 4 A?
```

Magic numbers: correct today, mysterious next month, ambiguous to every reader who isn't you-right-now. The fix is a type that **names the members of a closed set**:

```cpp
enum Grade { G_A, G_B, G_C, G_D, G_F };
// G_A is 0, G_B is 1, ... — but nobody ever needs to care

Grade g = G_A;
if (g == G_F) std::cout << "see you next semester\n";
```

An **enum** (enumeration) declares a new type whose values are the listed names. Under the hood each name is an integer — `G_A` is 0, `G_B` is 1, in declaration order — but the whole point is that **your code never says the number again**. `g == G_F` reads like the sentence it is.

The classic use is **state** — a record's phase of life:

```cpp
enum OrderStatus { PENDING, PAID, SHIPPED, DELIVERED, CANCELLED };

struct Order {
    int         id;
    double      total;
    OrderStatus status;      // a member OF enum type — records and enums compose
};
```

<a name="2-comparing-switching-printing"></a>
## 2. Comparing, switching, printing

Enums compare with `==` (they're one value each) and drive `switch` beautifully:

```cpp
const char* statusText(OrderStatus st) {      // return const char* — literal strings
    switch (st) {
        case PENDING:   return "pending";
        case PAID:      return "paid";
        case SHIPPED:   return "shipped";
        case DELIVERED: return "delivered";
        case CANCELLED: return "cancelled";
    }
    return "?";                                // unreachable-but-polite fallback
}
```

That function is the standard **enum → text** bridge — you will write one per enum in every lab this unit. (Its twin, **text → enum**, is §4.)

## 3. enum class — the safer sibling

Plain enums have a wart: their names leak into the surrounding scope, and they convert to `int` silently:

```cpp
enum Color  { RED, GREEN };
enum Fruit  { APPLE, GREEN };     // ⚠️ COMPILE ERROR: GREEN already exists!

int x = RED;                      // also legal — RED quietly becomes 0
```

The second `GREEN` collides because plain-enum names live in the *global* namespace. **enum class** (the scoped enum) fixes both:

```cpp
enum class Color { RED, GREEN, BLUE };
enum class Fruit { APPLE, PEAR, GREEN };   // fine — Fruit::GREEN, its own scope

Color c = Color::RED;      // note the qualified name — Type::VALUE
int x = c;                 // ⚠️ COMPILE ERROR: no silent int conversion
int y = static_cast<int>(c);   // the one honest door: explicit, deliberate
```

Rules of thumb, course-level:

| | plain `enum` | `enum class` |
| --- | --- | --- |
| Names | global — collide easily | scoped — `Type::VALUE` |
| → `int` | silent (safe-ish, surprising) | forbidden without `static_cast` |
| Comparison to ints | allowed | not allowed |
| Course default | tiny legacy-style sets | **new code** — safer by construction |

The course writes new enums as `enum class`; you'll meet plain ones in older code you read, and now you can decode them.

<a name="4-the-enum-input-trap--and-the-cure"></a>
## 4. The enum input trap — and the cure

The trap every beginner falls into:

```cpp
int choice;
std::cin >> choice;              // user types 3
OrderStatus st = choice;         // ⚠️ plain enum: compiles! st is now... 3? What is 3?
OrderStatus sc = static_cast<OrderStatus>(choice);   // ⚠️ enum class: compiles too!
// If 3 isn't a real member, st is a value NO member has — every switch misses it
```

Casting an arbitrary int to an enum doesn't validate it — it *launders* the number into a fake member. The cure is exactly the [allDigits gate](../strings/index.md) pattern from Unit 11: **validate the integer first, cast only survivors:**

```cpp
// text/int -> enum, the honest door
bool parseStatus(int code, OrderStatus& out) {
    if (code < 0 || code > 4) return false;      // the closed set, enforced
    out = static_cast<OrderStatus>(code);
    return true;
}
```

And the friendliest shape for users is the **menu mapper** — the user never sees numbers at all:

```cpp
// map a MENU choice to an enum — validation by construction
bool pickStatus(int menuChoice, OrderStatus& out) {
    switch (menuChoice) {
        case 1: out = PENDING;   return true;
        case 2: out = PAID;      return true;
        case 3: out = SHIPPED;   return true;
        case 4: out = DELIVERED; return true;
        case 5: out = CANCELLED; return true;
        default: return false;
    }
}
```

This is the pattern the mini-project's menus use throughout: `int` at the boundary (input is int-shaped), `enum` in the logic (state is name-shaped), one mapping function between.

<a name="5-organizing-related-data--the-design-habit"></a>
## 5. Organizing related data — the design habit

The real skill of this unit happens *before* any loop: designing the schema. The course procedure, on paper, in order:

**Step 1 — List the nouns.** A patient has a name, an ID, an admission date, a ward, a condition flag. *Patient, Date, Ward* — nouns first, types second.

**Step 2 — Give each noun its fields, one sentence each.** "`id` — int, the hospital number, positive." "`admitted` — a Date, the admission day." "`critical` — bool, watched hourly." The sentence *is* the documentation; if a field can't get one, it isn't a field yet.

**Step 3 — Spot the closed sets — those become enums.** A ward is one of {General, ICU, Maternity, Paediatrics}: closed → `enum class Ward`. A name is open-ended: `std::string`. Ask of every field: *is this one of a fixed list of kinds?* If yes, enum; if the set can grow, string.

**Step 4 — Spot the records-inside-records.** A field with fields of its own is a type waiting to be named — dates, addresses, names-with-parts. Nest them (Lesson 2 §3).

**Step 5 — Choose the container.** Fixed capacity known? Array of records + count. Grows? The [doubling pattern](../pointers/challenges.md#c4). (Vectors arrive next unit.)

**Step 6 — Write the record's `print` and `read` functions first.** Every lab below has you do this: if you can't print a record, you can't debug anything about it.

Do this on paper and the code writes itself; skip it and every later function argues with a schema you never committed to.

<a name="6-the-common-mistakes-gallery"></a>
## 6. The common mistakes gallery

**G1 — The missing semicolon.** `struct Student { ... }` with no `};` — the error appears *later*, usually at the next declaration, far from the crime. Count your closing braces-and-semicolon as one unit.

**G2 — Redefining the type.** Writing `struct Student s;` (C-style) in C++ — legal in C, noise in C++. Just `Student s;`.

**G3 — Uninitialized records.** `Student s;` leaves numeric members holding garbage. Brace-initialize (`Student s = {};` zeros everything) or run every record through `readX()`.

**G4 — Comparing a whole record to a field.** `if (s == 90)` — a record isn't a number. Compare *members*: `if (s.score == 90)`. (And note: `s1 == s2` on records doesn't even compile until you write the comparison yourself — C++ doesn't auto-generate it. Compare field by field.)

**G5 — The arrow/dot mix-up.** `s->score` on a plain `Student`, or `s.score` on a `Student*` — both compile errors, both instant to spot once you ask *"which do I hold: the record, or the address of one?"*

**G6 — The partially-filled brace list.** `Student s = {"Ali"};` — legal, score zero-initialized, *silently* zero. Prefer complete lists or member assignment.

**G7 — The enum-input laundering.** Casting unchecked ints into enums (§4). Validate, then cast — or map through a menu function.

**G8 — The anonymous enum-as-int.** Using plain `enum` values as ints across module boundaries (`int x = RED;`) — surprising conversions; enum class makes them impossible.

**G9 — Nesting by string.** Storing `"2024-03-15"` as a string date — no validation, no ordering, no components. A `Date` record earns its keep the moment any rule touches it.

**G10 — The schema that grew.** Two functions adding "just one more field" differently — the record now has fields no function reads, or two spellings of the same fact. Fix: the design habit of §5 — the schema lives in one place.

## Practice

- [Exercises 16–22](exercises.md) — enums, enum class, the input trap, schema design
- [Predictions 8–10](predictions.md) — enum prints and switch falls
- [Lab 3 — Product Inventory](labs.md#lab-3--product-inventory) — enums as state in a real schema

## Key takeaways

- **enum** names a closed set — the end of magic numbers; **enum class** scopes the names and forbids silent int conversions (the course default)
- Records and enums **compose**: a status member of enum type is the classic state field
- The **input trap** is real: validate the int, then cast — or map through a menu function
- **Design before code**: nouns → fields-with-sentences → closed sets to enums → nested records → container → print/read first
- The gallery's top three: the missing `};`, the silently-zeroed partial brace list, and the laundered enum input
