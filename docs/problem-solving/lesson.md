---
title: "The Problem-Solving Lesson"
description: "All 20 fundamentals — from computational problems to translating into C++ — threaded through one worked example."
---

# The Problem-Solving Lesson

> ~60–90 min · one worked example throughout · [← Module home](index.md)

This lesson teaches all twenty fundamentals by *using* them, once, on a
single problem — so you see how the ideas connect instead of memorising
twenty disconnected definitions. After the lesson, the
[20 scenarios](index.md#whats-in-the-module) let you run the method
yourself (remember the
[Try It Yourself protocol](index.md#try-it-yourself-before-looking-at-the-solution)).

**Our running problem.** A university cafeteria prints a daily bill:
samosas cost **25** rupees each, chai **15** a cup. For every order, the
cashier enters how many samosas and how many cups, and the till prints a
tidy bill. A 5% service charge is added if the total reaches 500 or more.
How do we get from that paragraph to a working C++ program?

Follow the sections in order — each one is a tool, and the tools build.

---

## Table of contents

[1–3. Problems, decomposition, IPO](#13-what-is-a-computational-problem-decomposition-and-the-ipoh-shape) ·
[4–7. Inputs, processing, outputs, requirements, assumptions, constraints](#47-inputs-processing-outputs-requirements-assumptions-constraints) ·
[8–10. Algorithms](#810-algorithms) · [11. Pseudocode](#11-pseudocode) ·
[12. Flowcharts](#12-flowcharts) · [13. Decision making](#13-decision-making) ·
[14. Repetition](#14-repetition) · [15–16. Dry runs and trace tables](#1516-dry-runs-and-trace-tables) ·
[17–18. Test cases and edge cases](#1718-test-cases-and-edge-cases) ·
[19. Common mistakes](#19-common-problem-solving-mistakes) ·
[20. Translating into C++](#20-translating-a-problem-into-a-c-solution) ·
[Glossary of the module](#glossary-of-this-module)

---

<a name="13-what-is-a-computational-problem-decomposition-and-the-ipoh-shape"></a>
## 1–3. What is a computational problem, decomposition, and the IPO shape

### 1. What is a computational problem?

A **computational problem** is any task that can be solved by *computing* —
taking some information, transforming it by precise rules, and producing an
answer. Not every problem is computational: "cheer up your friend" isn't.
"Work out what 12 samosas and 5 chais cost" is — information goes in,
arithmetic happens, an answer comes out.

The first skill is spotting the difference. Clues that a problem is
computational:

- it talks about **quantities** (how many, how much, how often)
- it has **rules** that always work the same way ("5% charge at 500 or more")
- a **definite answer** exists (a number, a yes/no, a category)

The cafeteria problem is computational *because* the rules are fixed. If the
manager gave discretionary discounts ("be generous if the customer looks
hungry"), no computer could follow it — computers need rules, not vibes.

### 2. Problem decomposition

Real problems arrive as a blob: *"print a bill."* Too big to solve in one
glance. **Decomposition** is cutting the blob into pieces small enough to
solve immediately — the single most-used skill in programming, used at every
scale from a homework exercise to an operating system.

Decompose the cafeteria problem by asking *"what must happen, in order?"*

```text
"Print a bill"
  ├─ 1. Find out how many samosas and how many cups of chai.
  ├─ 2. Work out the food cost:        samosas × 25
  ├─ 3. Work out the chai cost:        cups × 15
  ├─ 4. Add them:                      subtotal
  ├─ 5. Decide the service charge:     5% of subtotal, but only if subtotal ≥ 500
  ├─ 6. Total:                         subtotal + service
  └─ 7. Print it all neatly.
```

Seven steps — each one *small enough to do instantly*. That feeling of
"oh, each of those is easy" is the whole reward of decomposition. (If any
step still feels big, decompose *it* — steps may have sub-steps.)

### 3. The IPO shape

Nearly every program you write this year has three beats —
**Input → Processing → Output** (IPO). It is worth drawing as a picture,
because every scenario in this module is first analysed as this box:

```text
            ┌─────────────────────────────┐
  INPUT ──▶ │  PROCESSING                 │ ──▶ OUTPUT
            │  (the rules, step by step)  │
            └─────────────────────────────┘
```

| Beat | Cafeteria question | Answer |
| --- | --- | --- |
| **Input** | what information changes from order to order? | number of samosas, number of chais |
| **Processing** | what rules turn input into output? | multiply, add, the 5% decision |
| **Output** | what must the customer see? | item lines, subtotal, service, total |

Here is the key habit: **nailing I and O before writing any P.** Inputs and
outputs are *observable* — you can test them. Processing is the engine
between. Students who start typing "the processing" usually discover
halfway that they were solving a slightly different problem; students who
write I and O first always know when they're done.

---

<a name="47-inputs-processing-outputs-requirements-assumptions-constraints"></a>
## 4–7. Inputs, processing, outputs, requirements, assumptions, constraints

These six words are the vocabulary of *understanding the problem precisely*
— before any algorithm exists.

### 4. Inputs

The data your solution consumes, decided in advance:

| Input | Kind of value | Sensible range |
| --- | --- | --- |
| number of samosas | whole number | 0 … 50 (a realistic order) |
| number of chais | whole number | 0 … 50 |

Two early lessons hide here. First, **kind matters**: quantities of items
are whole numbers — you cannot sell 2.5 samosas. Second, **inputs have
ranges**: the till should not be asked for −3 samosas. Noticing that now is
cheaper than crashing later.

### 5. Processing

The rules that transform inputs into outputs, stated so precisely that two
different people following them get the same bill:

```text
food   = samosas × 25
chai   = cups × 15
subtotal = food + chai
service  = 0.05 × subtotal   — but only when subtotal ≥ 500, else 0
total    = subtotal + service
```

If any rule feels ambiguous ("what if it's exactly 500?" — included, the
statement says *reaches*), this is the moment to notice, not after coding.

### 6. Outputs

The bill itself, drawn *before* coding — a target to aim at:

```text
==== CAFETERIA BILL ====
Samosas x 3   :  75
Chai    x 2   :  30
------------------------
Subtotal      : 105
Service (5%)  :   0
------------------------
TOTAL         : 105
========================
```

### 7. Requirements, assumptions, constraints

Three different kinds of statement about the problem — keeping them apart
prevents real bugs:

| Kind | Meaning | Cafeteria examples |
| --- | --- | --- |
| **Requirement** | what the solution *must* do | print each item line, subtotal, service, total; charge 5% when subtotal reaches 500 |
| **Assumption** | what we *take for granted* (and would confirm if the client were here) | counts are whole numbers ≥ 0; prices don't change mid-day; one order per run |
| **Constraint** | a *limit* we must live inside | use only whole-rupee arithmetic on the displayed bill; single order per program run; run on the till's modest hardware |

Why the fuss? Because mistakes hide in the seams. A program is "wrong" only
relative to requirements; it is *fragile* when assumptions go unspoken ("I
assumed nobody types negative numbers"); it is *rejected* when a constraint
is violated ("we said the bill shows whole rupees"). Writing down your
assumptions is the cheapest debugging there is — you do it before the bug
exists.

---

<a name="810-algorithms"></a>
## 8–10. Algorithms

### 8. What an algorithm is

An **algorithm** is a finite sequence of precise steps that solves the
problem — the decomposition, tightened until it is *executable*. A recipe
is an algorithm; so is long division; so is this:

```text
1. Read samosaCount.
2. Read chaiCount.
3. food     ← samosaCount × 25
4. chaiCost ← chaiCount × 15
5. subtotal ← food + chaiCost
6. If subtotal ≥ 500:  service ← 0.05 × subtotal
   Else:               service ← 0
7. total ← subtotal + service
8. Print the bill lines.
9. Stop.
```

What makes this an algorithm and not just "a plan": **finiteness** (it
ends), **definiteness** (each step is unambiguous), **inputs** and
**outputs** (defined above), and **effectiveness** (each step is doable by
the machine). The arrow `←` means "store into" — step 3 *computes*
`3 × 25` and *stores* it in `food`.

### 9. Where algorithms come from

Not from thin air — from **patterns you already know**. This course leans
on a small set that covers nearly everything:

| Pattern | Smell | Cafeteria use |
| --- | --- | --- |
| straight-line | "do this, then this" | steps 1–5, 7 |
| selection | "in *this* case, differently" | step 6 |
| repetition | "for *each* … do …" | (Unit 06 problems: one bill per customer until the till closes) |
| accumulator | "keep a running total" | (Set C scenarios) |

Recognising *which* pattern a problem needs is most of the intellectual
work — and it happens on paper, before C++ exists.

### 10. Step-by-step thinking

The final ingredient of algorithm design is a *discipline*: state steps so
dumb that a machine could follow them — then improve them. Test your draft
algorithm the way a machine would: take example inputs and execute the
steps *literally*. Step 6 on a subtotal of 500: the `If` says *reaches 500
or more*, so service is charged. On 499? Not charged. The algorithm already
answers the ambiguity — because the steps are precise. That habit —
**executing your own plan before coding it** — is the difference between
students who debug for hours and students who debug for minutes.

---

<a name="11-pseudocode"></a>
## 11. Pseudocode

**Pseudocode** is the algorithm written in structured English — half human,
half program. It uses *sequence, selection, repetition* keywords but no
language-specific punctuation; there are no official rules, only house
style. This course's conventions:

| Construct | This course writes |
| --- | --- |
| store a value | `total ← subtotal + service` |
| read input | `READ samosaCount` |
| print | `PRINT total` |
| choice | `IF condition THEN … ELSE … ENDIF` |
| repeat | `WHILE condition … ENDWHILE` · `FOR i FROM 1 TO n … ENDFOR` |

The cafeteria algorithm in §8 *is* the pseudocode. Why bother, when C++ is
next? Because pseudocode is **cheap to change** and **language-free**: you
fix the logic while it costs nothing, and you can hand it to a C++,
Python, or Java programmer — all would write the same program. Rule of
thumb for beginners: *no pseudocode, no code.* (In the scenarios, every
solution shows pseudocode first — but per the
[Try It Yourself protocol](index.md#try-it-yourself-before-looking-at-the-solution),
you write yours *first*.)

---

<a name="12-flowcharts"></a>
## 12. Flowcharts

A **flowchart** draws the algorithm — boxes for actions, diamonds for
decisions, arrows for the order. Two symbols carry this whole course:

| Symbol | Meaning | Cafeteria |
| --- | --- | --- |
| `▭` rectangle | an action / step | `subtotal ← food + chai` |
| `◇` diamond | a **decision** with exits | `subtotal ≥ 500 ?` — yes → charge, no → don't |
| `▭` with rounded corners | start / end | `START` / `STOP` |

```text
   ┌─────────┐
   │  START  │
   └────┬────┘
        ▼
 ┌──────────────┐      ┌───────────────┐
 │ READ samosas │      │  (then chais, │
 │      & chais │      │  costs, total)│
 └──────┬───────┘      └───────┬───────┘
        ▼                      ▼
      ╱╲ subtotal ≥ 500? ╲
     ╱  ╲                 ╲
  YES▼    ▼NO
   ┌──────────────┐   ┌──────────────┐
   │service ← 5%  │   │service ← 0   │
   └──────┬───────┘   └──────┬───────┘
          └───────┬──────────┘
                  ▼
          ┌──────────────┐
          │ PRINT bill   │
          └──────┬───────┘
                 ▼
             ┌───────┐
             │ STOP  │
             └───────┘
```

Use flowcharts the way professionals do: **to see structure at a glance** —
especially where decisions branch and rejoin. Long sequences are clearer as
pseudocode; two-way choices are often clearer as a diamond. You'll never be
asked to be an artist — boxes and arrows on paper are the standard tool.

---

<a name="13-decision-making"></a>
## 13. Decision making

Decisions give algorithms their intelligence — the same steps behave
differently depending on the data. A **decision** has three parts:

1. a **condition** — a yes/no question (`subtotal ≥ 500`)
2. a **then-branch** — what to do when yes
3. an **else-branch** — what to do when no (sometimes empty)

Cafeteria pseudocode:

```text
IF subtotal ≥ 500 THEN
    service ← 0.05 × subtotal
ELSE
    service ← 0
ENDIF
```

Two beginner traps, named now so Unit 04 can defeat them:

- **Boundary logic.** Is 500 charged? The requirement says *reaches 500* —
  so yes, `≥`, not `>`. Off-by-one-at-the-boundary is *the* classic logic
  bug; decide boundaries consciously, on paper.
- **Order of checks.** If a later problem needs *many* conditions (marks →
  grade), check the most specific first and think about what "the rest"
  falls into. Sets B and D of the scenarios drill exactly this.

Ask of every decision: **what data makes this go the *other* way?** If you
can't answer, the condition isn't understood yet.

---

<a name="14-repetition"></a>
## 14. Repetition

Some tasks need the same steps many times: print 30 bills, total 25 marks,
count down from 10. **Repetition** (a *loop*) lets the algorithm say "do
this again" instead of copying the steps — but it introduces the danger of
**never stopping**. Every loop needs an honest answer to: *what makes it
stop?*

Two shapes, learned on paper here, coded in Units 05–06:

```text
WHILE there is another customer:      FOR each day FROM 1 TO 7:
    read the order                        read that day's sales
    print the bill                        add to the weekly total
    ask: another customer?            ENDFOR
ENDWHILE
```

- **WHILE** — repeat *as long as* a condition holds; the condition is
  checked first; something inside must eventually make it false
  (the customer eventually says "no").
- **FOR** — repeat a *known number* of times.

The classic failure, so you recognise it on paper: a WHILE whose condition
never changes — *infinite loop*; the algorithm never reaches STOP. The fix
is always the same: make sure **something inside the loop moves the world
toward the stopping condition**. Set C's scenarios (11–15) are built on
this idea; Unit 05 turns it into `while` statements.

---

<a name="1516-dry-runs-and-trace-tables"></a>
## 15–16. Dry runs and trace tables

### 15. Dry runs

A **dry run** is executing the algorithm *by hand* — with pencil and
values — before any code exists. You are the computer; the algorithm is the
program; you keep honest track of every value. It takes two minutes and
finds the bugs that otherwise cost an evening: wrong formulas, boundary
slips, values never updated.

### 16. Trace tables

The **trace table** is the dry run written down — one column per variable,
one row per step, updating values as the algorithm touches them. Dry-run
the cafeteria algorithm with **3 samosas, 2 chais** (no service, since
105 < 500):

| Step | samosas | chais | food | chaiCost | subtotal | service | total |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1–2 (read) | 3 | 2 | – | – | – | – | – |
| 3 | 3 | 2 | 75 | – | – | – | – |
| 4 | 3 | 2 | 75 | 30 | – | – | – |
| 5 | 3 | 2 | 75 | 30 | 105 | – | – |
| 6 (else) | 3 | 2 | 75 | 30 | 105 | 0 | – |
| 7 | 3 | 2 | 75 | 30 | 105 | 0 | **105** |

The final column is the output — **105**, matching the target bill above.
Two minutes of pencil replaced an hour of debugging; this is also exactly
the table you'll fill in Set C/D scenarios, and the "predict before you
run" habit the whole course runs on.

**The professional upgrade — run the boundary too.** The decision hides at
`subtotal = 500`: try **20 samosas, 0 chais** (subtotal exactly 500) →
service = 25 → total 525. And one below: **19 samosas, 1 chai** = 475+15 =
490 → service 0. If your paper run disagrees with the requirement at the
boundary, you just found a design bug *for free*.

---

<a name="1718-test-cases-and-edge-cases"></a>
## 17–18. Test cases and edge cases

### 17. Test cases

A **test case** is a planned check: *given this input, the output must be
this.* Now that trace tables predict behaviour, write the predictions down
**before** coding — the plan, at minimum:

| # | Input (samosas, chais) | Expected total | Why chosen |
| --- | --- | --- | --- |
| T1 | 3, 2 | 105 | ordinary case (matches the trace table) |
| T2 | 0, 0 | 0 | smallest possible order |
| T3 | 20, 0 | 525 | exactly at the service boundary |
| T4 | 19, 1 | 490 | just below the boundary |

After coding: run all four, compare, and only then declare the program
working. "It ran once" is not testing; *testing is comparing against
predictions you wrote down first.*

### 18. Edge cases

**Edge cases** are the inputs at the edges of the ranges — smallest,
largest, exactly-at-boundaries, and the "nobody would do that" values that
users do daily:

| Edge | Input | Expected | What it guards |
| --- | --- | --- | --- |
| zero order | 0, 0 | total 0 | no crash, no negative nonsense |
| exact boundary | 20, 0 | service charged (525) | `≥` vs `>` decision implemented as designed |
| just below | 19, 1 | no service (490) | the other side of the same decision |
| first chargeable step | 20, 1 | 500+25+0.75 → 526 (rounded) | mixed boundaries + rounding policy |
| big order | 50, 50 | 1250 + 62 = 1312 | large values behave |
| *invalid* (assumption: user obeys) | −3 samosas | *out of scope* — assumption §7 | documents where behaviour is undefined |

That last row is the quiet lesson: an **assumption** (§7) marks territory
your program does *not* defend; a **validation** requirement would move it
inside (Set D's Scenario 19 adds exactly that). Knowing *which inputs are
the program's problem* is part of the design — and saying so on paper is
what makes it true.

---

<a name="19-common-problem-solving-mistakes"></a>
## 19. Common problem-solving mistakes

The failure modes this module exists to prevent — every one is cheaper to
avoid on paper than in code:

| # | Mistake | What it looks like | Defence |
| --- | --- | --- | --- |
| 1 | **Coding before understanding** | typing while still fuzzy on I/O | IPO first — I and O written *before* P |
| 2 | **Solving the wrong problem** | a beautiful solution to a misread statement | restate the problem in your own words; check the restatement |
| 3 | **Hidden assumptions** | "works for positive numbers" — never said, never tested | assumption list (§7) as a ritual |
| 4 | **Ignoring boundaries** | `>` where the spec says *reaches* (`≥`) | run the trace table *at* the boundary (§16) |
| 5 | **Unstoppable loops** | WHILE that never ends | "what makes it stop?" answered *before* writing the loop (§14) |
| 6 | **Testing only the happy path** | one run, one smile | planned test table incl. edges (§17–18) |
| 7 | **Premature C++** | fighting syntax while the logic is broken | pseudocode + dry run first; the logic is language-free |
| 8 | **Copy-paste tweaking without a model** | changing code at random until it "looks right" | predict → run → compare; explain every change |
| 9 | **One giant step** | "then it calculates the bill" | decompose until each step is instant (§2) |
| 10 | **Not reading the error** | panic at the first red line | the Week-0 [reading rules](../getting-started/getting-started-lesson.md#16-how-to-read-compiler-error-messages) — and they apply to logic too: *read the whole thing* |

Keep this table for the scenarios: when a scenario resists you, find your
row here, apply the defence, and try again *before* reading its solution.

---

<a name="20-translating-a-problem-into-a-c-solution"></a>
## 20. Translating a problem into a C++ solution

Only now — IPO understood, algorithm written, dry run clean, tests planned
— do we translate. Each construct has a direct C++ form:

| Algorithm (pseudocode) | C++ (as written in this course) |
| --- | --- |
| `READ x` | `std::cin >> x;` — input arrives via `std::cin`, the console *input* stream |
| `x ← expression` | `int x = expression;` — a **variable**, a named box holding a value |
| `PRINT x` | `std::cout << x << "\n";` |
| `IF c THEN … ELSE … ENDIF` | `if (c) { … } else { … }` |
| `WHILE c … ENDWHILE` | `while (c) { … }` |
| whole numbers / decimals | `int` / `double` — Unit 02 teaches choosing; we need whole counts here |

And the cafeteria program:

```cpp
// cafeteria.cpp — Programming and Problem-Solving Fundamentals, worked example
// Compile: g++ -std=c++17 -Wall -Wextra cafeteria.cpp -o cafeteria
// Run:     ./cafeteria            (Windows: .\cafeteria.exe)

#include <iostream>

int main() {
    int samosas = 0;
    int chais   = 0;

    std::cout << "Samosas: ";
    std::cin  >> samosas;                    // READ samosaCount
    std::cout << "Chai cups: ";
    std::cin  >> chais;                      // READ chaiCount

    int food     = samosas * 25;             // food     ← samosas × 25
    int chaiCost = chais * 15;               // chaiCost ← chais × 15
    int subtotal = food + chaiCost;          // subtotal ← food + chaiCost

    int service = 0;                         // the ELSE branch value
    if (subtotal >= 500) {                   // IF subtotal ≥ 500 THEN
        service = subtotal * 5 / 100;        //     service ← 5% (whole rupees)
    }

    int total = subtotal + service;          // total ← subtotal + service

    std::cout << "\n==== CAFETERIA BILL ====\n";
    std::cout << "Samosas x " << samosas << " : " << food << "\n";
    std::cout << "Chai    x " << chais   << " : " << chaiCost << "\n";
    std::cout << "------------------------\n";
    std::cout << "Subtotal      : " << subtotal << "\n";
    std::cout << "Service (5%)  : " << service << "\n";
    std::cout << "------------------------\n";
    std::cout << "TOTAL         : " << total << "\n";
    return 0;
}
```

**The translation walk-through — notice *where every line came from*:**

- `samosas`, `chais` — the **inputs** (§4); `int` because counts are whole.
- `food`, `chaiCost`, `subtotal`, `service`, `total` — one variable per
  **algorithm step** (§8), same names as the pseudocode. Same names = the
  code *is* the design, readable.
- `if (subtotal >= 500)` — the **decision** (§13); `>=` because the
  requirement says *reaches 500* — the boundary we dry-ran on purpose.
- `subtotal * 5 / 100` — 5% in whole rupees (integer arithmetic keeps the
  bill in whole rupees — our constraint §7; Unit 02 formalises this).
- the printed bill — the **output spec** (§6), line by line.
- every test from §17–18 must now pass, run by you:

```text
T1: 3 2   → total 105   ✓   T3: 20 0 → total 525  ✓
T2: 0 0   → total 0     ✓   T4: 19 1 → total 490  ✓
```

That is the whole pipeline: **understand → decompose → IPO → algorithm →
pseudocode → dry run → tests → code → test.** The 20 scenarios repeat it
until it's reflex — *you* doing it, per the
[Try It Yourself protocol](index.md#try-it-yourself-before-looking-at-the-solution).

---

## Glossary of this module

| Term | One-line definition | § |
| --- | --- | --- |
| computational problem | a task solvable by precise rules on information | 1 |
| decomposition | splitting a problem into instantly-solvable pieces | 2 |
| IPO | Input → Processing → Output, the shape of nearly every program | 3 |
| requirement | what the solution must do | 7 |
| assumption | what we take for granted (and say so) | 7 |
| constraint | a limit the solution must respect | 7 |
| algorithm | a finite, unambiguous, effective sequence of steps | 8 |
| pattern | a known solution shape: straight-line, selection, repetition, accumulator | 9 |
| pseudocode | structured-English algorithm: cheap to change, language-free | 11 |
| flowchart | the algorithm drawn: rectangles, diamonds, arrows | 12 |
| decision | condition + then-branch + else-branch | 13 |
| loop | repetition; must have an honest stopping condition | 14 |
| dry run | executing the algorithm by hand with real values | 15 |
| trace table | the dry run written down: variables × steps | 16 |
| test case | planned check: given input → expected output | 17 |
| edge case | an input at the edge of the ranges | 18 |

---

*[← Module home](index.md) · [Scenarios — Set A](scenarios-a.md) ·
[Lab](lab.md)*
