---
title: "Challenges — Decision Making"
description: "10 open challenge problems (C1–C10): no starter code, no answers — design briefs with tests so you can check yourself."
---

# Challenges — Decision Making

> [← Module home](index.md) · [Exercises →](exercises.md)

**How to work.** Challenges are design briefs, not recipes: no starter code, no solution to peek at. For each one — extract the conditions ([Lesson 4 §2](lesson-4-requirements-to-decisions.md#2-stage-1--extract-conditions-and-actions)), sketch the table or ladder, write the code, then **build the test table yourself** and dry-run the boundaries. Difficulty: ★★ stretch · ★★★ serious. Where a challenge extends a course example, the link tells you what to build on.

---

## C1 — The two-flag discount
A shop gives 10% off when the bill exceeds 2000 **or** the customer holds a loyalty card; 20% when *both* are true. Read `bill` and `hasCard` (1/0); print the final bill with two decimals. **Self-check:** 2500/no-card → 2250.00; 2500/card → 2000.00; 1500/card → 1350.00; 1500/no-card → 1500.00.

## C2 — Traffic-light state
Read a colour as a character (`r`, `y`, `g`) and print the driver instruction (`Stop`, `Ready`, `Go`); anything else prints `Fault` and the program exits with status 1. Then extend: `y` behaves as `Stop` **unless** the road is clear — read a second input `roadClear` (1/0) that only matters for `y`. Structure matters: which shape (switch? nested? ladder?) keeps the extension honest?

## C3 — Password strength gate
Read a password as a single word (`std::string`). Print `Strong` when it has at least 8 characters (`password.size() >= 8` — one string method, used like a number) **and** contains a digit somewhere. Checking "contains a digit" needs a scan — you haven't met loops yet, so *approximate*: read the password **and** a second input `hasDigit` (1/0) that a friend's checker supplied, and decide on both. Mark with a comment exactly which check the loop-free version can't do yet — [Unit 05](../syllabus.md#stage-b-control-flow-units-4-6) will remove the crutch.

## C4 — The grade ladder's missing rule
Rebuild [E6](exercises.md#part-b--else-if-ladders--) and add the university's rule that was silently missing: a mark of 39 gets a "conceded pass" if attendance was at least 75%. Read `marks` and `attendance`; print `A`/`B`/`C`/`D`/`Conceded`/`F`. Where does the concession check live — before, inside, or after the ladder? Defend the placement with a dry run of (39, 80), (39, 60), (38, 90).

## C5 — Elevator controller
Read `currentFloor` (1–10) and `targetFloor`. Print `Up`, `Down`, or `Already there`; reject any floor outside 1–10 with `Out of range` and status 1. Then add: floors 4 and 13 are skipped by the building (superstition) — pressing them is `Out of range` too. Does your range check get *more* complex, or does a second check join it? Which reads better, and why?

## C6 — Menu-driven mini calculator
Read two `double` operands and an operator character (`+ - * /`). Use a `switch` on the operator; `default` must reject unknown operators. Division must guard the divisor *before* dividing ([E4](exercises.md#part-a--one-condition-decisions--) pattern). Print the result with `fixed`/`setprecision(2)`. **Self-check:** 9 / 4 → 2.25; 9 / 0 → your message, no crash; 3 ? 4 → rejected.

## C7 — Cinema pricing, complete
Rebuild the classic with every rule at once: base price 700; under-12 pays 350; 60+ pays 400; students (read `isStudent` 1/0) of *any* age pay 500; **Wednesday** (read `day` 1–7) takes 20% off whatever price was decided. Order your decisions so the student rule and the age rules interact correctly (a 10-year-old student pays 350 — which rule wins, and does the requirement say?). Document the precedence you chose.

<a name="c8--the-boundary-stress-test-harness"></a>
## C8 — The boundary stress-test harness
Write a program that asks the user for a band edge `e` and then prints the verdict of *your* ladder from [E6](exercises.md#part-b--else-if-ladders--) for `e-1`, `e`, `e+1` in one run — three grades per edge. Run it for every edge in the ladder. You'll write the ladder once and re-verify edges mechanically. (Yes, this is a loop-shaped idea written without a loop — three explicit calls. [Unit 05](../syllabus.md#stage-b-control-flow-units-4-6) will make it one line.)

## C9 — Tax slab calculator
Income slabs: first 600,000 → 0%; next 600,000 (to 1.2M) → 5%; next 800,000 (to 2M) → 10%; above 2M → 15% *on the portion above 2M only* — marginal, like real tax systems. Read income as a `double`; print tax with two decimals. This is a ladder that *computes*, not just classifies: each branch adds its slab's share. **Self-check:** 1,000,000 → 20,000; 1,500,000 → 50,000; 2,500,000 → 115,000.

## C10 — Design the un-testable
A friend writes: `if (x * 0 == 0) { ... }` and `if (x / 2 * 2 == x) { ... }`. For each: (1) determine for which values it is true, (2) decide whether it's a legitimate check or an obfuscated one, and (3) rewrite it in honest terms (or explain why no honest rewrite exists — one of them hides a division-by-zero the condition never guards). Then write a two-sentence rule about when arithmetic-in-conditions is acceptable.

---

## How to know you're done

Every challenge is finished when:
- [ ] the decision table or ladder sketch exists *on paper* before the code
- [ ] the code compiles clean under `-Wall -Wextra`
- [ ] your test table covers every boundary value in the brief — one below, the edge, one above
- [ ] at least one test exercises the catch-all (`else`/`default`)
- [ ] a classmate could rebuild your logic from your comments alone

That same checklist is the marking rubric for the [labs](labs.md) — practice it here where the stakes are zero.
