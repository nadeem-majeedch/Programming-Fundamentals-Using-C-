---
title: "Lesson 2 — Conditions and Boundaries"
description: "Building the question: comparison operators, logical operators, compound conditions, boolean variables, validation patterns, and the > vs >= boundary trap."
---

# Lesson 2 — Conditions and Boundaries

> [← Module home](index.md) · [← Lesson 1 — Branches](lesson-1-branches.md) · [Lesson 3 — Switch →](lesson-3-switch.md)

## In this lesson you will learn

- the six comparison operators and what each really answers
- `&&`, `||`, `!` — and the precedence rule that saves you from parentheses chaos
- compound conditions: AND-ranges, OR-menus, and mixing them safely
- `bool` variables as *named conditions*
- validation patterns you will reuse in every lab
- **boundary conditions** — why `>` vs `>=` decides pass and fail, and how to test it

Lesson 1 taught the *shape* of decisions; this lesson builds the *questions* inside them.

---

<a name="1-comparison-operators--six-ways-to-ask"></a>
## 1. Comparison operators — six ways to ask

A **condition** is an expression whose value is `true` or `false`. The six comparison operators produce exactly that:

| Operator | Reads as | Example | Value |
| --- | --- | --- | --- |
| `==` | equal to | `marks == 40` | true only when equal |
| `!=` | not equal to | `attempts != 0` | true when different |
| `<` | less than | `age < 18` | true when strictly smaller |
| `>` | greater than | `marks > 40` | true when strictly larger |
| `<=` | less than **or equal to** | `age <= 12` | true at the boundary too |
| `>=` | greater than **or equal to** | `marks >= 40` | true at the boundary too |

Key properties:

- The result is a `bool`. You can store it: `bool passed = marks >= 40;`
- The operands may be variables, literals, or whole expressions: `total > budget + 100` compares *values*, then forgets them.
- **`==` compares values, not meaning.** `'A' == 65` is `true` (characters are numbers — [Foundations Lesson 2](../cpp-foundations/lesson-2-data.md)); two different variables holding 40 compare equal even though they are different boxes.

> **Read `<=` and `>=` as single words.** Writing `=<` or `=>` is a compile error, not a near miss.

<a name="2--both-must-hold-logical-and"></a>
## 2. `&&` — both must hold (logical AND)

```cpp
if (age >= 13 && age <= 19)
```

`&&` is `true` only when **both** sides are `true`. Truth table, filled in the same direction your program evaluates:

| `age >= 13` | `age <= 19` | `&&` result |
| --- | --- | --- |
| true | true | true |
| true | false | false |
| false | true | false |
| false | false | false |

This is the natural shape of a **range**: `min <= value && value <= max`. It reads like maths but is two separate questions joined by AND — C++ has no `13 <= age <= 19` shortcut that does what you mean. That chained form *compiles* and computes a wrong answer: `(13 <= age)` is a `bool` (`0` or `1`), and `1 <= 19` is always `true`. So every age passes the "teenager" test. [P7](predictions.md#p7--the-chained-comparison) traces this exact disaster.

## 3. `||` — at least one must hold (logical OR)

```cpp
if (day == "sat" || day == "sun")     // pseudocode-ish; real string compare in §6
```

`||` is `true` when **at least one** side is `true` — the shape of a *menu* (any qualifying value wins):

| A | B | A `||` B |
| --- | --- | --- |
| true | true | true |
| true | false | true |
| false | true | true |
| false | false | false |

> **Vocabulary trap.** In everyday speech "or" can mean *either but not both* (exclusive or). C++'s `||` is **inclusive**: if both sides are true, the result is still true. Requirements usually want inclusive — "members or seniors get a discount" includes a senior member. If a requirement truly wants exactly-one, that's `!=` on the booleans (see exercise [E18](exercises.md#e18--xor-the-exclusive-or)).

<a name="4--flip-it-logical-not"></a>
## 4. `!` — flip it (logical NOT)

`!` inverts a condition: `!(age >= 18)` means "not an adult". Two honest uses:

- **Naming a denial:** `if (!found)` reads better than `if (found == false)`.
- **Guarding early:** `if (!(marks >= 0 && marks <= 100)) { reject; }`

The **De Morgan flip** (worth memorising for the [mistake gallery](#7-compound-condition-mistakes)): `!(A && B)` equals `!A || !B`, and `!(A || B)` equals `!A && !B`. "Not both in range" = "one of them is out of range". You will meet this again when a validation condition refuses to behave.

**Precedence:** `!` binds tighter than comparisons, which bind tighter than `&&`, which binds tighter than `||`. So `marks == 40 || marks == 45` needs no parentheses, but **parenthesise whenever two different operators mix** — `age < 18 || age > 65 && hasPass` is *not* what it looks like (see [P8](predictions.md#p8--and-before-or)). House rule: when in doubt, parenthesise; it never hurts and it always documents intent.

<a name="5-boundary-conditions-the--vs--trap"></a>
## 5. Boundary conditions — the `>` vs `>=` trap

A **boundary** is the edge value where a rule flips. "Pass at 40" means 40 itself passes — `>=` — and 39 fails. Get this wrong and *exactly one mark* is graded wrong, which is the hardest kind of bug to notice and the easiest kind to test for.

```cpp
marks >= 40    // 40 passes   (boundary INCLUDED)
marks >  40    // 40 fails    (boundary EXCLUDED)
```

Three habits that make boundaries safe:

1. **Test both sides plus the edge.** For a pass rule at 40: check 39, 40, 41. Three values, ten seconds, bug found or rule confirmed. Every lab in this module has a test table with edge rows for exactly this reason.
2. **Copy the requirement's word choice literally.** "40 or more" → `>= 40`. "More than 40" → `> 40`. "Above 40" is ambiguous — *ask or state your assumption*, a habit from [Problem Solving §7](../problem-solving/lesson.md#47-inputs-processing-outputs-requirements-assumptions-constraints).
3. **Watch the direction when you flip.** The *opposite* of `>= 40` is **`< 40`**, not `<= 39` and not `> 40`. Flipping a comparison while keeping the same boundary value is the classic rewrite bug ([D6](debugging.md#d6--the-flipped-boundary) hunts it).

**Adjacent bands share a boundary — decide once.** If 60 ends band C and starts band B, then 60 must belong to *exactly one* of them: either `marks >= 60` starts B (and C is `marks < 60`), or C is `marks <= 59`. In an `else-if` ladder the shared value silently goes to the earlier question — know which band owns each edge and put an edge value in the test table to prove it.

<a name="6-compound-conditions-in-the-wild"></a>
## 6. Compound conditions in the wild

Real rules stack these patterns. Recognise the shape, don't reinvent it:

| Requirement wording | Shape | C++ |
| --- | --- | --- |
| "between 18 and 65 inclusive" | AND-range | `age >= 18 && age <= 65` |
| "outside 0–100" | inverted range | `marks < 0 \|\| marks > 100` |
| "Wednesday or Thursday" | OR-menu | `day == 3 \|\| day == 4` |
| "member AND purchased over 500" | AND-gate | `isMember && total > 500` |
| "student OR (senior AND weekday)" | mixed | `isStudent \|\| (isSenior && isWeekday)` |
| "exactly one of A, B" | XOR | `a != b` (when both are `bool`) |

Two constructions that pay rent immediately:

**Validation guard** — reject bad input *before* using it:

```cpp
if (marks < 0 || marks > 100)
{
    std::cout << "Invalid marks: " << marks << '\n';
    return 1;                    // stop; nothing sensible can follow
}
// from here on, marks is guaranteed 0..100 — the ladder below needs no re-checks
```

This pairs with the fail-clear-ignore input check from [I/O Lesson 2 §6](../cpp-io/lesson-2-cin.md#25-when-input-goes-wrong-fail-clear-ignore): that one guards *readable* input; this one guards *sensible* input. Real programs need both.

**Classification ladder** — with ranges ordered so earlier questions do the range work:

```cpp
if (temp >= 40)      band = "extreme heat";
else if (temp >= 30) band = "hot";
else if (temp >= 20) band = "warm";
else if (temp >= 10) band = "mild";
else                 band = "cold";
```

<a name="7-compound-condition-mistakes"></a>
## 7. Compound-condition mistakes

| # | Mistake | What happens | Fix |
| --- | --- | --- | --- |
| C1 | `13 <= age <= 19` chained comparison | always true (bool is 0/1) | split: `age >= 13 && age <= 19` |
| C2 | `if (day == "sat" \|\| "sun")` | `"sun"` is a non-zero pointer → always true | repeat the comparison each side |
| C3 | AND where OR is meant (`marks >= 40 && marks <= 100` used as "invalid") | rejects nothing / rejects everything | test with an in-range and an out-of-range value |
| C4 | boundary direction flipped after "simplifying" | exactly the edge cases break | re-run the 39/40/41 test |
| C5 | `!` applied to the wrong term | `!age >= 18` flips `age` first | parenthesise: `!(age >= 18)` |
| C6 | unparenthesised `&&`/`\|\|` mix | AND wins; logic silently re-grouped | parenthesise every mixed pair |

Each has a hunting exercise in [debugging.md](debugging.md) — but predictions [P7](predictions.md#p7--the-chained-comparison) and [P8](predictions.md#p8--and-before-or) spoil C1/C6, so do those hunts first if you want the surprise.

## 8. `bool` variables — name the question

A condition can be stored, named, and reused — which makes complex rules *readable*:

```cpp
bool isWeekend  = (day == 6 || day == 7);
bool hasTicket  = (ticketCount > 0);
bool canEnter   = hasTicket && !isBanned;

if (canEnter) { ... }
```

Named conditions turn a compound rule into vocabulary: the `if` states *what*, the definitions state *why*. They also make dry runs trivial — add a column per bool to your [trace table](../problem-solving/lesson.md#1516-dry-runs-and-trace-tables) and fill them in order. Keep the names assertive (`hasTicket`, not `ticketCheck`) so `!hasTicket` reads as "has no ticket", not a double negative.

---

## Recap — you can now

- [ ] choose among `==`, `!=`, `<`, `>`, `<=`, `>=` and say which side of a boundary each puts the edge value on
- [ ] build AND-ranges, OR-menus, and mixed conditions with honest parentheses
- [ ] explain why `13 <= age <= 19` and `day == "sat" || "sun"` are wrong while looking right
- [ ] write a validation guard and a classification ladder
- [ ] run the 39/40/41 boundary test on any rule

**Next:** [Lesson 3 — Switch and the conditional operator](lesson-3-switch.md): when the question is "which one of these values?", and the one-line decision that isn't an `if`.
