---
title: "Exercises — Decision Making"
description: "25 graded decision-making exercises (E1–E25): one-liners, ladders, compound conditions, boundaries, switch, and ternary — with selected answers below."
---

# Exercises — Decision Making

> [← Module home](index.md) · [Debugging hunts →](debugging.md)

**How to work:** write your answer and dry-run it *before* opening any answer. Stars: ★ recall · ★★ apply · ★★★ design. Selected answers (E1–E10, and starred hints for later items) are in a collapsed block at the [bottom of this page](#selected-answers) — the Try-It-Yourself rule from the [module home](index.md#the-one-rule-of-this-module) applies to every one.

**Setup for code exercises:** every program compiles with `g++ -std=c++17 -Wall -Wextra eNN.cpp -o eNN` (see the [toolchain notes](../getting-started/getting-started-lesson.md#8-command-line-compilation)).

---

<a name="part-a--one-condition-decisions--"></a>
## Part A — One-condition decisions (★)

**E1 — Pass/fail.** Read marks (0–100). Print `PASS` when marks are 40 or more, otherwise `FAIL`. Then print `Checked.` on its own line either way.

**E2 — Adult gate.** Read an age. Print `Adult` if 18 or more, `Minor` otherwise. Then add: if the age is exactly 17, additionally print `One year to go.`

**E3 — Negative guard.** Read a number. If it is negative, print `Negative input` and stop the program with `return 1;`. Otherwise print `OK: ` and the number.

**E4 — Zero division guard.** Read integers `total` and `count`. If `count` is 0, print `Cannot divide by zero.`; otherwise print the integer quotient and remainder (`total / count`, `total % count` — recall [Foundations Lesson 3](../cpp-foundations/lesson-3-operators.md)).

**E5 — Coin doubles.** Read a number. If it is positive, print the number doubled; otherwise print the number unchanged. One decision, two outputs.

<a name="part-b--else-if-ladders--"></a>
## Part B — else-if ladders (★–★★)

**E6 — Grade ladder.** Read marks (0–100) and print the grade with a single ladder: A ≥ 80, B ≥ 70, C ≥ 60, D ≥ 40, else F. Print the letter only, no newline gymnastics needed.

**E7 — BMI bands.** Read weight (kg) and height (m). Compute `bmi = weight / (height * height)` as a `double` and classify: `< 18.5` Underweight, `< 25` Normal, `< 30` Overweight, else Obese. Print the band and the BMI with two decimal places (`fixed`/`setprecision` — [I/O Lesson 1 §6](../cpp-io/lesson-1-cout.md#4-formatting-columns-setw-left-right-setfill)).

**E8 — Day type.** Read a day number 1–7 (Mon=1). Print `Working day` for 1–5, `Weekend` for 6–7, and `Invalid day` for anything else. One ladder, three outcomes.

**E9 — Ticket bands.** Read age. Prices: under 12 → `Child 300`, 12–17 → `Teen 450`, 18–59 → `Adult 700`, 60+ → `Senior 350`. Print e.g. `Adult 700`. Then state (in a comment) which boundary values your ladder places in which band, and why 12 and 17 land where they do.

**E10 — Temperature advisory.** Read a Celsius temperature as a `double` (integer divisions off!). Print: ≥ 40 `Heat warning`, ≥ 30 `Hot`, ≥ 20 `Pleasant`, ≥ 10 `Cool`, < 10 `Cold`.

## Part C — Compound conditions (★★)

**E11 — Range check.** Read a number and print `In range` when it is between 10 and 20 **inclusive**, else `Out of range`. Then answer in a comment: does your condition admit 10? 20? Why?

**E12 — Login rule.** Read a `username` (`std::string`) and a 4-digit `pin` (`int`). Print `Welcome` when username is `"admin"` **and** pin is `1234`; otherwise `Access denied`. Note the [I/O](../cpp-io/lesson-2-cin.md) whitespace rules: `>>` reads one word for the string.

**E13 — Discount rule.** Read `isMember` (1/0) and `total`. Print `Discount applied` when the customer is a member **and** total is more than 500; else `Full price`. Keep the message decision in one `if-else`.

<a name="e14--seasons-two-ways"></a>
**E14 — Seasons two ways.** Read a month number 1–12. Print the season (12/1/2 Winter, 3–5 Spring, 6–8 Summer, 9–11 Autumn, else `Invalid month`) **twice**: once with an `else-if` ladder using `||`, once with a `switch` using stacked cases. Both must produce identical output for every month 0–13.

**E15 — Triangle validity.** Read three sides. Print `Valid triangle` when all three are positive **and** the sum of any two is greater than the third (three checks joined by `&&`), else `Invalid`.

**E16 — Leap year, first attempt.** Read a year and print `Leap` when it is divisible by 4, else `Not leap`. (Save your answer — [C12](challenges.md) extends this to the full rule.)

**E17 — Overlap check.** Read two time slots as start/end hour pairs (`s1 e1 s2 e2`, each 0–23). Print `Overlap` when one slot starts before the other ends *and* vice versa: `(s1 < e2 && s2 < e1)`, else `Free`. Test with slots that merely *touch* (one ends where the next begins) — is touching an overlap per your formula?

<a name="e18--xor-the-exclusive-or"></a>
**E18 — XOR, the exclusive or.** Read two answers `a` and `b` as 1/0 booleans. Print `Exactly one` when **exactly one** of them is true, else `Both or neither`. One comparison, no nested ifs: recall [Lesson 2 §6](lesson-2-conditions.md#6-compound-conditions-in-the-wild) (`a != b` when both are bool).

**E19 — Military time check.** Read `hours` and `minutes` as two integers. Print `Valid time` when hours are 0–23 **and** minutes 0–59, else `Invalid time`. Then re-do it with a single compound condition and confirm both versions agree on (24, 0), (23, 60), (0, 0), (-1, 30).

## Part D — Validation and boundaries (★★–★★★)

**E20 — Three-guard program.** Read age, weight, and haemoglobin (the Lesson 4 example — but write it *yourself* before rereading [the worked solution](lesson-4-requirements-to-decisions.md#6-stage-5--the-c-translation)). Reject out-of-range inputs individually (`return 1` after each message), then classify exactly as the worked example does. Your output text may differ; the branch structure may not.

**E21 — Boundary line-up.** A rule says *"students with more than 60 marks get a scholarship."* For each of 59, 60, 61: state whether your `if` (you choose the comparison) admits the student. Then rewrite the condition the opposite way (`<` vs `>=` family) without changing which values qualify, and state the flip rule from [Lesson 2 §5](lesson-2-conditions.md#5-boundary-conditions-the--vs--trap) you used.

**E22 — Band-edge owner.** Marks ladder with bands A ≥ 80, B ≥ 70: which band owns exactly 70 in your ladder? Prove it by dry-running 69, 70, 71 through *your* code and recording the branch each takes. Then move the boundary deliberately (change `>= 70` to `> 70`) and list which test values change verdicts.

**E23 — Validation loop, one pass.** Read marks; if they are outside 0–100 print `Invalid` and `return 1`. Combine this with E6's ladder so invalid input never reaches the grading ladder. Test: −5, 0, 39, 40, 100, 101 — record each output.

**E24 — Weekday menu.** Read a day number 1–7 and use a `switch` to print the day's schedule: 1–5 `Classes`, 6 `Lab cleanup`, 7 `Off`, default `Invalid day`. Then convert it to an `else-if` ladder. In a comment: which version would you extend first if the schedule became per-day different, and why?

**E25 — Fee rule stack.** A course fee is 15000. Rules: (a) full fee with no discount; (b) 10% discount when the student is a merit scholar **or** the fee is paid within the first week; (c) an *additional* 5% (on the already-discounted fee) when both are true. Read `isMerit` (1/0) and `paidEarly` (1/0), compute and print the fee with two decimals. Design the decisions so both-true (rule c) really stacks — test with both-false, each-alone, and both-true; the both-true answer is 12825.00.

---

## Selected answers

<details markdown="1">
<summary><strong>Answers to E1–E10 (attempt first!)</strong></summary>

**E1.** `if (marks >= 40) { std::cout << "PASS\n"; } else { std::cout << "FAIL\n"; } std::cout << "Checked.\n";` — the final line is *outside* the if-else. Boundary: 40 → PASS.

**E2.** Two separate decisions, not a ladder — the "exactly 17" message is *additional*, so it can't be an `else` of the Adult/Minor fork:
```cpp
if (age >= 18) std::cout << "Adult\n"; else std::cout << "Minor\n";
if (age == 17) std::cout << "One year to go.\n";
```
(braces preferred per [Lesson 1 §7](lesson-1-branches.md#7-braces-the-silent-killer); shown tight for space.)

**E3.** `if (number < 0) { std::cout << "Negative input\n"; return 1; } std::cout << "OK: " << number << '\n';` — no `else` needed: after the early return, what follows *is* the other case.

**E4.** `if (count == 0) { std::cout << "Cannot divide by zero.\n"; return 1; } std::cout << total / count << " " << total % count << '\n';` — integer division on purpose; `count` must be `int`.

**E5.** `if (n > 0) { std::cout << n * 2 << '\n'; } else { std::cout << n << '\n'; }` — zero and negatives print unchanged ("positive" is strict `>`; 0 is not positive).

**E6.** Ladder exactly as [Lesson 1 §5](lesson-1-branches.md#5-else-if--a-ladder-of-questions); final `else` catches 0–39. Edges: 80→A, 79→B, 70→B, 69→C, 60→C, 59→D, 40→D, 39→F.

**E7.** `bmi = weight / (height * height);` with `weight`/`height` as `double`. Ladder: `bmi < 18.5` → Underweight; `else if (bmi < 25)` Normal; `else if (bmi < 30)` Overweight; else Obese. Print with `std::fixed << std::setprecision(2)` after `#include <iomanip>`.

**E8.** `if (day >= 1 && day <= 5) ... else if (day == 6 || day == 7) ... else ...` — the range needs `&&`, the menu needs `||`; mixing them wrong is [C3](lesson-2-conditions.md#7-compound-condition-mistakes).

**E9.** `age < 12` Child; `else if (age <= 17)` Teen — *or* `else if (age < 18)`; both own 12–17. 12 lands in Teen only because the first question used `< 12` (strict); with `<= 12` Child would own 12. 17 is Teen because Adult starts at 18. Every boundary is owned by exactly one band — on purpose.

**E10.** `double` throughout; ladder of `<` rejections, else Cold. Edge owner: 40→Heat warning (first question is `temp >= 40`), 30→Hot, 20→Pleasant, 10→Cool.

</details>

<details markdown="1">
<summary><strong>Hints for E11–E25 (no full answers — design these yourself)</strong></summary>

- **E11** — inclusive is `>=` **and** `<=`; 10 and 20 both admitted. Then say why.
- **E12** — `pin == 1234` and `username == "admin"`; both in one `&&`. What does `pin == 123` or `"Admin"` do? (Case matters.)
- **E13** — `(isMember == 1 && total > 500)`; keep it one if-else. Is a member with total exactly 500 discounted? Check your operator against "more than".
- **E14** — ladder: `month == 12 || month == 1 || month == 2`; switch: stacked `case 12: case 1: case 2:`. Identical-output proof: test 0, 1, 2, 3, 12, 13.
- **E15** — three positivity checks *and* three triangle inequalities: `a + b > c && a + c > b && b + c > a` (positivity folded in). Test 1,2,3 (degenerate — invalid) and 1,1,1 (valid).
- **E16** — `year % 4 == 0` — deliberately incomplete; keep the program for C12.
- **E17** — `(s1 < e2 && s2 < e1)`; touching slots give `Free` with strict `<` — decide which the requirement wants and state it.
- **E18** — `a != b` with both stored as `int` 1/0 or `bool`; if `int`, compare to 1 after validating.
- **E19** — `hours >= 0 && hours <= 23 && minutes >= 0 && minutes <= 59`; the four test pairs each fail exactly one conjunct.
- **E20** — ladder order age → weight → hgb; three separate guards before it. Compare against the worked version *after* your own attempt.
- **E21** — `marks > 60` admits 61, not 60/59. Flip family: `!(marks > 60)` ≡ `marks <= 60` — state it.
- **E22** — with `>= 70`, band B owns 70. Changing to `> 70` moves 70 to band C: verdicts change for exactly that one value.
- **E23** — guard first, ladder after; 101 and −5 die in the guard; 0 → F, 39 → F, 40 → D, 100 → A.
- **E24** — switch version stacks `case 1: ... case 5:`; ladder uses ranges `day >= 1 && day <= 5`. Per-day schedules favour the switch (add a case per day); ranges favour the ladder.
- **E25** — compute `fee = 15000; if (merit || early) fee = fee * 0.90; if (merit && early) fee = fee * 0.95;` — two decisions, the second applying on top. 15000 → 13500 (one) → 12825.00 (both). Print with `fixed`/`setprecision(2)`.

</details>
