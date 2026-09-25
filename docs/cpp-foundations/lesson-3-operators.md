---
title: "Lesson 3 — Operations"
description: "Arithmetic, relational and logical operators, increment/decrement, compound assignment, and operator precedence."
---

# Lesson 3 — Operations

> ~90–120 min · [← Lesson 2](lesson-2-data.md) · [Lesson 4 — Conversion →](lesson-4-conversion.md)

Six operator families + the rule that governs them all. Same beats as
always: explanation → syntax → example → explained → practice.

---

## 3.1 Arithmetic operators

**Explanation.** The five workhorses: `+ − * / %` (modulo = remainder).
The one that bites everyone: **`/` depends on operand types** — two ints →
integer division (fraction truncated); either operand `double` → decimal
division. `%` is the remainder *of integer division* — the operator of
even/odd tests, digit extraction, and cyclic patterns.

**Syntax / Example.**

```cpp
// arith.cpp
#include <iostream>

int main() {
    std::cout << 7 + 3   << "\n";   // 10
    std::cout << 7 / 2   << "\n";   // 3      integer division
    std::cout << 7.0 / 2 << "\n";   // 3.5    one double promotes the lot
    std::cout << 7 % 2   << "\n";   // 1      remainder
    std::cout << 7 % 2 == 0 << "\n";// ??     see Explained!
    return 0;
}
```

**Explained.** The last line prints `0`, not `false`-ness you might expect —
because `%` binds tighter than `==`, it parses as `(7 % 2) == 0` →
`1 == 0` → `0`. Accidentally correct here, but the *pattern* — mixing
arithmetic and comparison without parentheses — is how precedence bugs are
born (§3.6). Also meet the negative-remainder fact now: `-7 % 2` is `-1`
in C++ (sign follows the dividend) — remember it for Unit 04's even/odd
checks. And `x / 0`? Integer division by zero is undefined behaviour;
`x / 0.0` yields infinity — neither is ever what you meant; validate
divisors ([Set D, Scenario 16](../problem-solving/scenarios-d.md) showed
how).

**Practice.** [Exercise 20](exercises.md#part-c---code-it-18-24) ·
[predictions P11, P12](predictions.md#p11).

---

<a name="32-relational-operators"></a>
## 3.2 Relational operators

**Explanation.** Six comparisons producing a `bool`: `==` equal, `!=` not
equal, `<` less, `<=` less-or-equal, `>` greater, `>=` greater-or-equal.
The universal beginner bug: `=` (assignment) vs `==` (comparison) — one
character, opposite universes.

**Syntax / Example.**

```cpp
// relations.cpp
#include <iostream>

int main() {
    int marks = 50;
    std::cout << (marks >= 50) << "\n";   // 1  boundary is inclusive
    std::cout << (marks >  50) << "\n";   // 0  strict — different question!
    std::cout << (marks == 50) << "\n";   // 1  comparison
    std::cout << (marks =  0)  << "\n";   // 0  ASSIGNMENT! marks is now 0
    std::cout << marks        << "\n";    // 0  …destroyed by the line above
    return 0;
}
```

**Explained.** Two lessons hide here. (1) **Boundaries**: `>=` and `>` are
different questions — "50 or more" must be `>=` (the Problem-Solving
module's boundary discipline, now in syntax). (2) The **`=` vs `==` trap**:
`marks = 0` *stores* 0 and the expression's value is the stored value
(`0` — falsy). In an `if` this silently corrupts the variable and flips the
logic; `-Wall` warns (`suggest parentheses around assignment used as truth
value`) — another reason warnings are must-fix. Parentheses around every
comparison inside output/conditions, per the example, also keep `<<` from
biting you (it outranks comparisons — see §3.6's table).

**Practice.** [Exercise 21](exercises.md#part-c---code-it-18-24) ·
[debugging D5](debugging.md#d5---the-one-character-bug) (the one-character
bug).

---

## 3.3 Logical operators

**Explanation.** Three operators combine booleans: `&&` (AND — true only if
**both** true), `||` (OR — true if **either**), `!` (NOT — flips). Both
`&&` and `||` **short-circuit**: if the left side decides the answer, the
right side is never evaluated at all.

**Syntax / Example.**

```cpp
// logic.cpp
#include <iostream>

int main() {
    int age = 20;
    bool hasID = false;
    std::cout << ((age >= 18) && hasID)  << "\n";   // 0  both required
    std::cout << ((age >= 18) || hasID)  << "\n";   // 1  either suffices
    std::cout << (!hasID)                << "\n";   // 1  flip

    // short-circuit in action:
    int divisor = 0;
    bool safe = (divisor != 0) && (100 / divisor > 2);
    std::cout << safe << "\n";                      // 0 — and NO crash:
    return 0;
}
```

**Explained.** The last block is the professional pattern `safe = (divisor
!= 0) && (…division…)`: because `&&` checks left first and short-circuits,
the dangerous division *never runs* when the divisor is 0. Put the cheap
guard on the left, the expensive/risky check on the right — the ordering is
the design. (Negations flip AND↔OR: "not (a and b)" = "not-a or not-b" —
the Problem-Solving module's Scenario 9/16/20 conditions, now with their
C++ names — De Morgan's laws, formally in Unit 04.)

**Practice.** [Exercise 22](exercises.md#part-c---code-it-18-24) ·
[prediction P13](predictions.md#p13).

---

<a name="34-increment--decrement"></a>
## 3.4 Increment / decrement

**Explanation.** `++` adds one, `--` subtracts one — the loop-counter
shorthand. Each has **two positions**: prefix (`++x` — *then* use) and
postfix (`x++` — *then* increment: use first, bump after). In a standalone
statement the two are identical; inside a larger expression they differ —
and that difference is a readability hazard the course rules accordingly:
**standalone statements only.**

**Syntax / Example.**

```cpp
// incdec.cpp
#include <iostream>

int main() {
    int count = 5;
    count++;                        // standalone: now 6 (position irrelevant)
    std::cout << count << "\n";     // 6

    int a = 5;
    int b = a++;                    // postfix: b gets 5, THEN a becomes 6
    std::cout << a << " " << b << "\n";   // 6 5

    int c = 5;
    int d = ++c;                    // prefix: c becomes 6, THEN d gets 6
    std::cout << c << " " << d << "\n";   // 6 6
    return 0;
}
```

**Explained.** Read `a++` aloud as "a, then plus": the *old* value is what
the expression yields. `++a` is "plus a": bump first. The `b`/`d` pair is
the whole lesson — memorise the two outputs (5 then 6) and you'll never be
surprised by a seeded bug again. The course style: `count++;` alone on its
line, always.

**Practice.** [Exercise 23](exercises.md#part-c---code-it-18-24) ·
[prediction P14](predictions.md#p14).

---

## 3.5 Compound assignment

**Explanation.** `op=` operators abbreviate "update in place": `x += 5`
means `x = x + 5`; also `-=` `*=` `/=` `%=`. Same value, fewer repeated
names — and it scales to code you haven't written yet (Unit 06: `total +=
mark` inside a loop is the accumulator idiom).

**Syntax / Example.**

```cpp
// compound.cpp
#include <iostream>

int main() {
    int total = 0;
    total += 20;        // total = total + 20  → 20
    total += 35;        // → 55
    total *= 2;         // → 110
    total -= 10;        // → 100
    total /= 3;         // integer division → 33 (fraction discarded!)
    std::cout << total << "\n";
    return 0;
}
```

**Explained.** Every line is "read, operate, store back" in one token —
and the last line repeats Lesson 2's warning in compound clothes: `/=`
between ints is *integer* division (110/3 → 33). Compound operators bind
at *assignment* precedence (bottom of §3.6's table): `x *= y + 1` means
`x = x * (y + 1)` — the whole right side first.

**Practice.** [Exercise 24](exercises.md#part-c---code-it-18-24) ·
[challenge C7](challenges.md).

---

## 3.6 Operator precedence

**Explanation.** When operators mix, **precedence** decides who goes first;
**associativity** decides left-to-right vs right-to-left among equals. The
memory-saving core for this course (highest first):

| Level | Operators | Notes |
| --- | --- | --- |
| 1 | `++` `--` (postfix) | highest |
| 2 | `++` `--` (prefix), `!`, unary `-` | |
| 3 | `*` `/` `%` | before + and − |
| 4 | `+` `-` | |
| 5 | `<` `<=` `>` `>=` | |
| 6 | `==` `!=` | |
| 7 | `&&` | before \|\| |
| 8 | `\|\|` | |
| 9 | `=`, `+=`, `-=`, … | assignment: **right-to-left**, lowest |

**Example.**

```cpp
// precedence.cpp
#include <iostream>

int main() {
    std::cout << 2 + 3 * 4        << "\n";  // 14   * before +
    std::cout << (2 + 3) * 4      << "\n";  // 20   parentheses win
    std::cout << 10 - 4 - 3       << "\n";  // 3    left-to-right
    std::cout << 2 + 3 < 5 + 1    << "\n";  // ??   (2+3)<(5+1) → 0
    std::cout << (2 + 3 < 5) + 1  << "\n";  // 1    bool promotes to int
    return 0;
}
```

**Explained.** Row 4 parses as `(2+3) < (5+1)` — arithmetic *before*
comparison — giving `5 < 6` → `1`… wait, `5 < 6` is true → `1`; run it and
check your trace. Row 5 shows comparison *results* participating in
arithmetic (`true` → 1). The course's standing rule beats memorising all
12 levels: **parentheses for anything beyond `* / %` over `+ -`** — free
correctness, free readability, zero cost. When in doubt, parenthesise;
when not in doubt, parenthesise anyway.

**Practice.** [predictions P11–P15](predictions.md#p11) are precedence
drills by design · [debugging D6](debugging.md#d6---the-average-that-wasnt)
(the classic average expression).

---

## Check yourself (Lesson 3)

- [ ] I can predict `7 / 2`, `7.0 / 2`, `7 % 2` — and explain each
- [ ] `=` vs `==` is a reflex, and `-Wall` warnings get fixed, not ignored
- [ ] I can write the safe-guard short-circuit idiom and say why it's safe
- [ ] I know prefix vs postfix *and* use `++` standalone only
- [ ] I parenthesise mixed arithmetic/comparison/logic without being asked

**Next:** [Lesson 4 — Type Conversion & Common Mistakes](lesson-4-conversion.md):
how values change types, and how they bite.

*[← Lesson 2](lesson-2-data.md) · [Module home](index.md)*
