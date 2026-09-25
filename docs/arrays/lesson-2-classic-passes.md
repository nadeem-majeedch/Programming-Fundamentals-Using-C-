---
title: "Lesson 2 — The Classic Passes"
description: "Linear search, minimum/maximum champions, sum and average, frequency counting, and copying arrays — the five workhorse passes."
---

# Lesson 2 — The Classic Passes

> [← Module home](index.md) · [← Lesson 1 — The row of boxes](lesson-1-basics.md) · [Lesson 3 — Arrays and functions →](lesson-3-arrays-functions.md)

## In this lesson you will learn

- **linear search** — find a value, handle the miss honestly
- **minimum/maximum** — the champion idiom wearing an index
- **sum/average** — the accumulator over boxes
- **frequency counting** — counting *kinds*, not totals: the tally-array superpower
- **copying** — the element loop and why `=` fails

Five passes, each a few lines, together covering most data-processing programs ever written. Every one is an [iteration idiom](../repetition/lesson-2-for.md#2-the-classic-idioms--learn-once-reuse-forever) you already own — the only new skill is walking an array while you do it.

---

<a name="1-linear-search--the-find-machine"></a>
## 1. Linear search — the find-machine

Question: *does this value appear, and where?* Walk the boxes, compare each, stop at the first match:

```cpp
// returns the INDEX of the first match, or -1 if absent
int linearSearch(const int data[], int n, int target) {
    for (int i = 0; i < n; i = i + 1) {
        if (data[i] == target) {
            return i;              // found — the index IS the answer
        }
    }
    return -1;                     // the agreed "not found" signal
}
```

**The miss must be representable.** −1 is the convention because no valid index is negative — a caller can test honestly:

```cpp
int pos = linearSearch(marks, n, 91);
if (pos == -1) {
    std::cout << "91 is not in the list.\n";
} else {
    std::cout << "91 first appears at index " << pos << '\n';
}
```

⚠️ The [bounds](lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does) trap in person: an unchecked −1 becomes `marks[-1]` — out of bounds, undefined. **Every search result is checked or rejected before use.**

Trace for `data = {72, 85, 91, 67}`, target 91:

| i | data[i] | == 91? | action |
| - | ------- | ------ | ------ |
| 0 | 72 | no | continue |
| 1 | 85 | no | continue |
| 2 | 91 | **yes** | return 2 |

(index 3 never examined — first match wins). For target 50, all four rows fail and the function returns −1.

**Variants** that are the same machine with a twist (all in [challenges](challenges.md)):

- **last match** — scan backward, return the first hit from the end.
- **all matches** — no early return; print/collect every hit ([Lab 5](labs.md#lab-5--survey-response-analysis) uses this).
- **count matches** — the counter idiom instead of an index.

And a passing observation for later: if the data were *sorted*, you could stop half-way through every miss — that's [Unit 10](../syllabus.md#stage-d-algorithms-and-data-units-10-12)'s binary search, and it's why sorting matters.

<a name="2-minimum-and-maximum--the-champion-with-an-address"></a>
## 2. Minimum and maximum — the champion with an address

The [champion idiom](../repetition/lesson-2-for.md#2-the-classic-idioms--learn-once-reuse-forever), upgraded: track *where* the champion lives, not just its value.

```cpp
// returns the INDEX of the largest element (n >= 1 assumed — document it)
int indexMax(const int data[], int n) {
    int best = 0;                       // box 0 is the initial champion
    for (int i = 1; i < n; i = i + 1) { // challengers from box 1
        if (data[i] > data[best]) {
            best = i;
        }
    }
    return best;
}
```

Why index-tracking beats value-only: the *position* answers more questions — *who* scored highest, *which* day was hottest — and the value is one dereference away (`data[best]`). The seed is **box 0, not a made-up number** — the honest-first-value rule from [Iteration S12](../repetition/exercises.md#s12--high-low), now with an address. Contract: `n >= 1` (an empty array has no champion — the caller guards).

Trace `data = {72, 85, 91, 67}`:

| i | data[i] | data[best] | best after |
| - | ------- | ---------- | ---------- |
| seed | — | 72 | 0 |
| 1 | 85 | 72 | 1 |
| 2 | 91 | 85 | 2 |
| 3 | 67 | 91 | 2 (unchanged) |

`data[indexMax(...)]` = 91. Minimum: flip one comparison (`<`). Both-at-once: two champions, one pass ([Lab 7](labs.md#lab-7--simple-statistics-calculator)).

<a name="3-sum-and-average--the-accumulator-over-boxes"></a>
## 3. Sum and average — the accumulator over boxes

```cpp
int sumOf(const int data[], int n) {
    int total = 0;                      // accumulator starts at its identity
    for (int i = 0; i < n; i = i + 1) {
        total += data[i];
    }
    return total;
}
// average: sumOf(data, n) / n  — and the int-division warning from
// [Foundations Lesson 4](../cpp-foundations/lesson-4-conversion.md) applies:
// cast first:  static_cast<double>(sumOf(data, n)) / n
```

One loop, one accumulator — the [Lab 2 canteen till](../repetition/labs.md#lab-2--canteen-till) job, now over boxes instead of a stream. The guards travel with it: `n >= 1` before dividing, garbage-tolerance decisions documented ([Problem Solving §7](../problem-solving/lesson.md#47-inputs-processing-outputs-requirements-assumptions-constraints)).

<a name="4-frequency-counting--the-tally-array"></a>
## 4. Frequency counting — the tally array

The most powerful idea in this lesson. Question: *of 40 survey answers (1–5), how many chose each option?* Five counters — or one **tally array** where **the value is the counter and the index is the thing counted**:

```cpp
constexpr int OPTIONS = 5;
int tally[OPTIONS] = {0};               // tally[0] unused; answers are 1..5

for (int i = 0; i < n; i = i + 1) {
    int answer = answers[i];
    if (answer >= 1 && answer <= OPTIONS) {
        tally[answer] += 1;             // THE move: index by data
    }
}

for (int opt = 1; opt <= OPTIONS; opt = opt + 1) {
    std::cout << "Option " << opt << ": " << tally[opt] << " response(s)\n";
}
```

`answers` is the data array; `tally` is a *second* array whose **indices mean categories**. `tally[answer] += 1` is the whole trick: the data picks which counter to bump. This is hashing's baby picture, and it generalizes far beyond surveys — digit histograms ([Iteration's](../repetition/lesson-4-nested-digits-patterns.md#3-digit-processing--10-and--10) digit-sum in one pass), grade-band counts, character counts ([Strings module](../strings/index.md)).

The guard *inside* the loop is not decoration: an out-of-range answer would index outside `tally` — [bounds](lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does) discipline applied to *data-as-index*.

Trace `answers = {3, 1, 3, 5, 3}`, n = 5:

| i | answer | tally after |
| - | ------ | ----------- |
| — | — | 0 0 0 0 0 |
| 0 | 3 | 0 0 1 0 0 |
| 1 | 1 | 1 0 1 0 0 |
| 2 | 3 | 1 0 2 0 0 |
| 3 | 5 | 1 0 2 0 1 |
| 4 | 3 | 1 0 3 0 1 |

Output: option 1 → 1, option 3 → 3, option 5 → 1. (Mode = 3: `indexMax` over `tally[1..5]`.)

## 5. Copying — the element loop

```cpp
constexpr int MAX_SIZE = 100;
int source[MAX_SIZE], copy1[MAX_SIZE];
int n = 5;   // filled elsewhere

// THE copy: element by element
for (int i = 0; i < n; i = i + 1) {
    copy1[i] = source[i];
}

copy1 = source;        // COMPILE ERROR — arrays are not assignable (gallery A4)
```

`=` fails because an array *name* isn't a value you can assign — it's the whole row of boxes. The loop is the copy; and copying `0..n-1` (logical size) is usually the intent — copying full capacity copies garbage.

A near-relative worth knowing now: **copying in reverse** (backward traversal) produces the *reversal* — [challenge C1](challenges.md#c1--the-reverser) makes you write it; **shifting** (each box takes its neighbour's value) is [C2](challenges.md#c2--the-shifter), and teaches why loop *direction* matters when boxes overwrite each other.

## The five passes at a glance

| Pass | Keeps | One-sentence shape |
| --- | --- | --- |
| Linear search | current index | walk, compare, return first hit or −1 |
| Min/Max | champion index | seed box 0, challenge the rest |
| Sum/Average | accumulator | start at 0, add every box |
| Frequency | tally array | index-by-data, bump counters |
| Copy | destination array | assign each box from its twin |

## Practice

- [Exercises 9–16](exercises.md) — the five passes
- [Predictions 4–7](predictions.md#questions)
- [Debugging 4–6](debugging.md)
- [Lab 7](labs.md#lab-7--simple-statistics-calculator) — the statistics calculator

## Key takeaways

- Linear search returns an index or −1; −1 must be checked before it's used as an index.
- Champions seed at box 0 and track the *index* — positions answer more questions than values.
- Sum/average is the accumulator over boxes; average casts before dividing.
- Frequency counting indexes a tally array *by the data* — categories become counters.
- Copying is an element loop; `=` between arrays is a compile error.

→ Next: [Lesson 3 — Arrays and functions](lesson-3-arrays-functions.md)
