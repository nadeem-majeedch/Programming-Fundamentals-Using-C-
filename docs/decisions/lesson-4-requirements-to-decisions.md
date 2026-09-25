---
title: "Lesson 4 — From Requirements to Decisions"
description: "The five-stage pipeline: extract conditions, build decision tables, draw flowcharts, write pseudocode, translate to C++, and verify with dry runs — worked end to end on one realistic rule set."
---

# Lesson 4 — From Requirements to Decisions

> [← Module home](index.md) · [← Lesson 3 — Switch](lesson-3-switch.md) · [Practice: exercises →](exercises.md)

## In this lesson you will learn

- how to read a requirement and extract its **conditions** and **actions** without losing any
- how to build a **decision table** — and use it to prove your logic covers every case
- how to sketch the same logic as a **flowchart** and write it as **pseudocode**
- how to translate the plan into **C++** and verify it with a **dry run** on boundary cases
- a pre-submission checklist you will run on every lab in [labs.md](labs.md)

Syntax is behind you (Lessons 1–3). What separates a correct program from an almost-correct one now is *process*. This lesson is that process, worked on one realistic rule set from start to finish.

---

## 1. The pipeline

Every rule-based program in this course goes through the same five stages:

```text
requirements ──► conditions & actions ──► decision table ──► flowchart ──► pseudocode ──► C++ ──► dry run
   (someone's       (what to ask,            (every case     (the shape    (the plan,   (the real    (the proof)
    words)           what to do)              covered)        as a map)     in English)  thing)       it works)
```

You will not always draw every artifact — but knowing *which to skip* is itself a skill the labs will train. The table at [§8](#8-where-each-artifact-earns-its-keep) tells you what each stage buys you. The worked example below uses all of them, because that is how you learn to feel the gaps between stages.

**The running example — Blood Donor Eligibility:**

> A donor may give blood if they are **between 17 and 65 inclusive**, weigh **at least 50 kg**, and have a haemoglobin reading of **12.5 or higher**. Donors outside the age or weight limits are **referred** (permanently ineligible). Donors who qualify on age and weight but read **below 12.5** are **deferred for two weeks** to recheck. Everyone who meets all three limits is **accepted**.

Four sentences, three conditions, three actions. Notice this is *not* one of the lab scenarios in [labs.md](labs.md) — the labs are yours to solve; this one is here to be dissected.

<a name="2-stage-1--extract-conditions-and-actions"></a>
## 2. Stage 1 — extract conditions and actions

Read the requirement with a pencil. Two colours, mentally:

- **Conditions** — questions with true/false answers. Hunt for: numbers with limits, category words, yes/no states.
- **Actions** — the possible outcomes. Hunt for: result words (accept/refer/defer), printed messages, computed values.

| From the requirement | Type | C++-ready form |
| --- | --- | --- |
| "between 17 and 65 inclusive" | condition C1 | `age >= 17 && age <= 65` |
| "at least 50 kg" | condition C2 | `weight >= 50.0` |
| "12.5 or higher" | condition C3 | `haemoglobin >= 12.5` |
| "referred" (age or weight) | action | print referral message |
| "deferred for two weeks" | action | print deferral message |
| "accepted" | action | print acceptance message |

Two habits worth their weight in gold:

1. **Translate wording to operators immediately, in writing.** "At least" → `>=`. "Between … inclusive" → `>=` *and* `<=` ([Lesson 2 §2](lesson-2-conditions.md#2--both-must-hold-logical-and)). "Below 12.5" → `< 12.5`. This is where boundary mistakes are cheapest to catch — on paper, before any code ([Lesson 2 §5](lesson-2-conditions.md#5-boundary-conditions-the--vs--trap)).
2. **Note the data types the words imply.** Haemoglobin has a fractional reading (12.5), so it's a `double`; age and weight could go either way, but a weight of 49.5 kg is meaningful, so `double` for both — deciding this *now* avoids the integer-division trap from [Foundations Lesson 3](../cpp-foundations/lesson-3-operators.md) sneaking into your eligibility math later.

## 3. Stage 2 — the decision table

A **decision table** lists every meaningful combination of condition outcomes and the action each triggers. With three yes/no conditions there are 2³ = 8 raw combinations:

| Rule | C1: age 17–65 | C2: weight ≥ 50 | C3: hgb ≥ 12.5 | Action |
| --- | --- | --- | --- | --- |
| 1 | T | T | T | Accept |
| 2 | T | T | F | **Defer two weeks** |
| 3 | T | F | T | Refer (weight) |
| 4 | T | F | F | Refer (weight) |
| 5 | F | T | T | Refer (age) |
| 6 | F | T | F | Refer (age) |
| 7 | F | F | T | Refer (age) |
| 8 | F | F | F | Refer (age) |

Raw tables are honest but bloated. **Collapse** them with dashes meaning *"don't care"*: when the action is the same regardless of a condition's value, merge the rows. Rules 5–8 collapse into one (age fails → refer, no matter what else); rules 3–4 collapse (weight fails → refer, hemoglobin irrelevant):

| Rule | C1 | C2 | C3 | Action |
| --- | --- | --- | --- | --- |
| 1 | T | T | T | Accept |
| 2 | T | T | F | Defer two weeks |
| 3 | T | F | – | Refer (weight) |
| 4 | F | – | – | Refer (age) |

Four rows — and now the table does two jobs no code listing can:

- **Completeness check:** can every possible input find a row? Every T/F pattern matches exactly one — nothing falls through the cracks.
- **Non-redundancy check:** does any input match *two* rows? No — the dashes never overlap. (Two matching rows with different actions is the classic ambiguity bug; the collapsed table exposes it instantly.)

Compare that against a pile of unbraced ifs — this is why the table comes *before* the code.

> **Collapsing tips.** Collapse only when actions truly match. Work from the condition most likely to dominate (here: age). If your collapsed table has a row you can't justify in one sentence, un-collapse it and think again.

## 4. Stage 3 — the flowchart

A flowchart shows **control flow** — the path through the logic — which the table deliberately hides. Course symbols:

| Symbol | Meaning | Used for |
| --- | --- | --- |
| rounded rectangle | start / end | terminator |
| parallelogram | input / output | `cin`, `cout` |
| **diamond** | decision | one yes/no question |
| rectangle | process | compute, assign |
| arrow | flow | the order questions are asked |

```text
        (Start)
           │
   ╱ read age, weight, hgb ╲
           │
      ◆ age in 17..65? ◆ ── No ──► [ print "Refer: age" ] ──┐
           │ Yes                                            │
      ◆ weight >= 50? ◆ ── No ──► [ print "Refer: weight" ]─┤
           │ Yes                                            │
      ◆ hgb >= 12.5? ◆ ── No ──► [ print "Defer 2 weeks" ] ─┤
           │ Yes                                            │
   ╱ print "Accept" ╲ ──────────────────────────────────────┤
           │                                                │
         (End) ◄────────────────────────────────────────────┘
```

Flowchart conventions that keep them readable:

- **One question per diamond.** `age ok AND weight ok` in a single diamond hides the referral-reason distinction the requirement asks for.
- **Every diamond has two exits**, labelled. An unlabelled arrow is a guess.
- **All paths reach End.** Trace each of the four collapsed rules through the chart with a finger — a path that dead-ends is a missing `else`.

The chart makes the **question order** visible: age → weight → haemoglobin. That order is a design decision (cheapest/most decisive check first, and the order determines *which reason* gets reported). The decision table doesn't encode order; the flowchart does.

## 5. Stage 4 — pseudocode

Pseudocode is the plan in structured English — no syntax to trip on, every decision explicit. Course house style (matching [Problem Solving §10](../problem-solving/lesson.md#11-pseudocode)):

```text
READ age, weight, haemoglobin

IF age < 17 OR age > 65 THEN
    PRINT "Refer: outside age limits"
ELSE IF weight < 50 THEN
    PRINT "Refer: under weight limit"
ELSE IF haemoglobin < 12.5 THEN
    PRINT "Defer: recheck haemoglobin in two weeks"
ELSE
    PRINT "Accepted: you may donate today"
END IF
```

Notice three things:

- The ladder is **most-decisive first** (age), mirroring the flowchart exactly — pseudocode is the flowchart in text.
- Conditions are written as the **rejection** side (`age < 17 OR age > 65`), so each `ELSE` carries the meaning "all previous conditions held". This is the ladder property from [Lesson 1 §5](lesson-1-branches.md#5-else-if--a-ladder-of-questions) doing real work.
- The negative range uses De Morgan's flip correctly: "not (17..65)" = "below 17 OR above 65" ([Lesson 2 §4](lesson-2-conditions.md#4--flip-it-logical-not)).

<a name="6-stage-5--the-c-translation"></a>
## 6. Stage 5 — the C++ translation

Now — and only now — syntax. Each pseudocode line becomes one C++ line; if a line doesn't map, the pseudocode (not the C++) needs fixing:

```cpp
#include <iostream>
int main() {
    int age;
    double weight, haemoglobin;

    std::cout << "Enter age: ";
    std::cin >> age;
    std::cout << "Enter weight in kg: ";
    std::cin >> weight;
    std::cout << "Enter haemoglobin: ";
    std::cin >> haemoglobin;

    if (age < 17 || age > 65)                    // Rule 4
    {
        std::cout << "Refer: outside age limits\n";
    }
    else if (weight < 50.0)                      // Rule 3
    {
        std::cout << "Refer: under weight limit\n";
    }
    else if (haemoglobin < 12.5)                 // Rule 2
    {
        std::cout << "Defer: recheck haemoglobin in two weeks\n";
    }
    else                                         // Rule 1
    {
        std::cout << "Accepted: you may donate today\n";
    }
    return 0;
}
```

Check the mapping: four table rules → four ladder branches, in order. Each comment names the rule it implements — when a marker (or future-you) reads the code against the table, the mapping is checkable line by line.

**Why not a `switch`?** Revisit [Lesson 3 §5](lesson-3-switch.md#5-switch-vs-ladder-vs--choosing-honestly): the conditions are ranges on three different variables — case labels can't hold them. The tool choice was settled back at Stage 1, not by taste.

## 7. Stage 6 — dry run: the proof

A dry run (trace table, [Problem Solving §15](../problem-solving/lesson.md#1516-dry-runs-and-trace-tables)) executes the ladder by hand for chosen inputs. Choose inputs that **walk every collapsed rule and stand on every boundary**:

| # | age | weight | hgb | C1 pass? | C2 pass? | C3 pass? | Branch taken | Output |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 30 | 62.0 | 13.0 | T | T | T | else | Accepted |
| 2 | 30 | 62.0 | 12.4 | T | T | F | hgb < 12.5 | Defer |
| 3 | 30 | 49.5 | 13.0 | T | F | – | weight < 50 | Refer: weight |
| 4 | 16 | 62.0 | 13.0 | F | – | – | age check | Refer: age |
| 5 | 66 | 62.0 | 13.0 | F | – | – | age check | Refer: age |
| 6 | 17 | 50.0 | 12.5 | T | T | T | else | Accepted |

Rows 1–4 each prove one collapsed rule works. Rows 5–6 are the **boundary audit**: 16/17 and 66/65 straddle the age edges; 49.5/50.0 straddles weight; 12.4/12.5 straddles haemoglobin. Row 6 puts a value *exactly on* every edge simultaneously — the all-boundaries row, and the single most valuable test you can write.

If any row's "branch taken" surprises you, the ladder — not the compiler — gets fixed. That is the entire point of dry-running: bugs found on paper cost minutes; bugs found after submission cost marks.

<a name="8-where-each-artifact-earns-its-keep"></a>
## 8. Where each artifact earns its keep

You won't draw all five artifacts for every exercise — here's what each one *buys*, so you can choose:

| Artifact | Finds these bugs | Skip when |
| --- | --- | --- |
| Conditions/actions list | misread requirement, wrong operator for a word | requirement is a single condition |
| Decision table | uncovered cases, overlapping rules, wrong actions | ≥ 4 interacting conditions (table explodes) |
| Flowchart | wrong question order, dead-end paths | presenting to people who don't code |
| Pseudocode | structural tangles before syntax noise | logic is 2–3 lines |
| Dry run | boundary errors, ladder-order bugs | *never* — always dry-run boundaries |

The labs in [labs.md](labs.md) require: a decision table or ladder sketch **and** a dry run for every submission — the two artifacts with the best bug-per-minute rate.

<a name="9-the-pre-submission-boundary-audit"></a>
## 9. The pre-submission boundary audit

Before declaring any decision program finished, run this checklist — it takes two minutes:

1. [ ] List every boundary value in the requirement (each "or more", "at least", "under", "between").
2. [ ] Test each boundary with the three values: one below, the edge itself, one above.
3. [ ] Put each edge value in exactly one branch — on purpose, not by luck.
4. [ ] Confirm the catch-all (`else` or `default`) is reachable and says something useful.
5. [ ] Dry-run at least one *all-boundaries* row.

The labs each ship with a test table already containing these rows — your job is to make your *code* pass them, and to add the rows the table forgot.

---

## Recap — you can now

- [ ] extract conditions and actions from a written requirement, with operators chosen on paper
- [ ] build and collapse a decision table, and use it to prove coverage and non-overlap
- [ ] draw the flowchart and write the pseudocode a table implies — in the same question order
- [ ] translate pseudocode to C++ line by line, choosing ladder vs switch with reasons
- [ ] dry-run every rule plus every boundary, including an all-edges row

**Next:** put the pipeline to work — start with [exercises E1–E25](exercises.md), or go straight to the [labs](labs.md) if you want the realistic scenarios first. Either way: **table before code, dry run before done.**
