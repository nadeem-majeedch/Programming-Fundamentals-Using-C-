---
title: "Lesson 1 — The while Loop and the Accumulator"
description: "Loop anatomy, counters vs accumulators, infinite loops and how to escape them, do-while, and input-controlled loops."
---

# Lesson 1 — The `while` Loop and the Accumulator

> [← Module home](index.md) · Lesson 1 of 4 · [Lesson 2 — `for` →](lesson-2-for.md)

## In this lesson you will learn

- why computers repeat, and what a loop actually is
- the three parts every `while` loop needs — and what goes wrong when one is missing
- **counters** and **accumulators**: the two variables that power almost every loop you will ever write
- what an infinite loop is, why it happens, and how to stop one
- `do-while`: the loop that always runs at least once
- input-controlled loops — repeating until the data says stop

Everything here builds on the guard and validation patterns from [Decisions Lesson 1](../decisions/lesson-1-branches.md) and the IPO thinking from [Problem Solving](../problem-solving/lesson.md#13-what-is-a-computational-problem-decomposition-and-the-ipoh-shape).

---

## 1. Why repeat?

Printing one invoice is easy. Printing 500 is not 500 statements — it is *one* set of statements, *repeated*. Repetition is the difference between a program that scales with data and one that must be rewritten for every new row.

A loop is a way to say: **"as long as this is true, do that again."**

<a name="2-the-while-loop--anatomy"></a>
## 2. The `while` loop — anatomy

```cpp
int count = 1;                 // 1. initialization — start the clock
while (count <= 3) {           // 2. condition — keep going while true
    std::cout << count << '\n';// 3. body — the work
    count = count + 1;         // 4. update — move toward the exit
}
```

**Visual** — the loop as a circuit. The condition is a gate on a one-way road:

```text
        ┌────────────────────────────┐
        │  count <= 3 ?              │◄─────────────┐
        └──────┬─────────────┬───────┘              │
          true │             │ false                │
               ▼             ▼                      │
        ┌────────────┐   (exit — the program      │
        │  body:     │    continues here)          │
        │  print     │                             │
        │  count+1 ──┼─────────────────────────────┘
        └────────────┘
```

**Pseudocode** (course house style):

```text
SET count TO 1
WHILE count <= 3
    PRINT count
    SET count TO count + 1
ENDWHILE
```

**Dry-run table** — executing it by hand, one row per *condition check*:

| pass | count (at check) | count <= 3? | body prints | count after update |
| ---- | ---------------- | ----------- | ----------- | ------------------ |
| 1    | 1                | true        | 1           | 2                  |
| 2    | 2                | true        | 2           | 3                  |
| 3    | 3                | true        | 3           | 4                  |
| 4    | 4                | **false**   | —           | loop exits         |

The body ran 3 times; the condition was checked 4 times. **The condition is always checked one more time than the body runs** — the final check is the one that ends it. That last row is not wasted effort: it is the loop's exit certificate.

### The rule of three

Every counting loop needs all three of these, or it breaks in a characteristic way:

1. **Initialization** — before the loop: `int count = 1;`
2. **Condition** — in the parentheses: `count <= 3`
3. **Update** — inside the body: `count = count + 1;`

| Missing part | Symptom |
| --- | --- |
| No initialization | compile error: *undeclared identifier* — or a garbage value deciding your loop |
| No update (or update never fires) | **infinite loop** — the condition can never become false |
| Update moves the wrong way | either 0 passes or an infinite loop (`count = count - 1` with `count <= 3` runs forever) |

Worked mini-example with all three annotated:

```cpp
// countdown.cpp — print 3, 2, 1, then Liftoff
#include <iostream>

int main() {
    int t = 3;                       // init: start where the countdown starts
    while (t >= 1) {                 // condition: keep going DOWN to 1
        std::cout << t << '\n';
        t = t - 1;                   // update: move toward the exit
    }
    std::cout << "Liftoff\n";
    return 0;
}
```

Note the condition direction flipped: `t >= 1` counts *down* because the update moves *toward* the exit from above. **A loop's condition is an open interval the update must walk across** — more in [Lesson 2 §5](lesson-2-for.md#5-off-by-one--the-boundary-problem).

## 3. Counters and accumulators — the power pair

Two variables show up in nearly every loop you will ever write. They look similar and are easy to confuse, so learn them as a pair:

- A **counter** *counts events*. It adds a fixed amount (usually 1) each pass. `count = count + 1;`
- An **accumulator** *collects a total*. It adds a *changing* amount each pass. `total = total + x;`

Both follow the same ritual: **initialize before the loop** (counter → a start value like 0 or 1; accumulator → 0), **update inside the loop**, **use after the loop**.

```cpp
// posneg.cpp — count positives and accumulate their sum
// reads 5 integers; counts how many are positive and totals them
#include <iostream>

int main() {
    int i = 1;
    int countPos = 0;      // counter: how many events
    int totalPos = 0;      // accumulator: running sum

    while (i <= 5) {
        int x;
        std::cout << "Enter number " << i << ": ";
        std::cin >> x;

        if (x > 0) {                 // decision inside a loop
            countPos = countPos + 1; // event happened
            totalPos = totalPos + x; // collect its value
        }
        i = i + 1;
    }

    std::cout << "Positives: " << countPos << '\n';
    std::cout << "Sum of positives: " << totalPos << '\n';
    return 0;
}
```

Worked example (inputs `4, -7, 10, 0, -2`):

| pass | i | x | x > 0? | countPos | totalPos |
| ---- | - | -- | ------ | -------- | -------- |
| 1    | 1 | 4 | yes    | 1        | 4        |
| 2    | 2 | -7| no     | 1        | 4        |
| 3    | 3 | 10| yes    | 2        | 14       |
| 4    | 4 | 0 | no     | 2        | 14       |
| 5    | 5 | -2| no     | 2        | 14       |

Output: `Positives: 2`, `Sum of positives: 14`.

Notice the division of labour: `i` drives the *loop* (how many times), `countPos`/`totalPos` answer the *question* (what we wanted to know). Beginners often try to make one variable do both jobs — it tangles the exit condition with the answer. Keep them separate.

**Shorthand**: `count = count + 1` has a compact spelling you will see everywhere — `count++` (and `total += x` for "add into"). Both were introduced in [Foundations Lesson 3 §3.4](../cpp-foundations/lesson-3-operators.md#34-increment--decrement); from now on the lessons use both forms freely.

<a name="4-infinite-loops--the-runaway-train"></a>
## 4. Infinite loops — the runaway train

An infinite loop is one whose condition can never become false. The three classic causes, all from the rule of three:

```cpp
// CAUSE 1 — forgot the update
while (n <= 10) {
    std::cout << n << '\n';
}                        // n never changes → forever

// CAUSE 2 — update defeated by data
while (n != 0) {
    std::cin >> x;       // reading x, but the condition tests n!
}

// CAUSE 3 — off-by-direction
while (n <= 10) {
    n = n - 1;           // walking AWAY from the exit
}
```

### How to stop one (platform-specific, but essential)

- **Windows**: `Ctrl+C` in the console.
- **Linux/macOS**: `Ctrl+C` in the terminal.

If the loop is waiting for input *and* printing, you may need `Ctrl+C` twice. This is a normal rite of passage — expect to hit it at least once this unit, stop the program, read the loop, and find which of the three causes it was.

### Defence habits

1. Say the exit sentence out loud: *"each pass moves count closer to making the condition false."* If you can't finish the sentence, the loop is broken.
2. One variable, one job: the variable you test should be the variable you update.
3. Dry-run the first two passes and the last pass on paper *before* compiling — infinite loops are almost always visible in row 2 of a trace table.

## 5. `do-while` — the loop that must run once

`while` checks *first*, then runs. Sometimes you need the reverse: the body must happen at least once, and only *then* do we ask whether to repeat. The classic case: a menu — you can't check "did the user choose Quit?" before showing the menu.

```cpp
int choice;
do {
    std::cout << "1. Say hello  2. Show time... 0. Quit\nChoice: ";
    std::cin >> choice;
    // ... act on choice ...
} while (choice != 0);
```

```text
       ┌──────────────┐
       │    body      │
       └──────┬───────┘
              ▼
        ┌──────────┐   false
        │ condition├────────► exit
        └────┬─────┘
        true │
              └────── back to body
```

**Pseudocode**: `REPEAT ... UNTIL choice = 0` — you met this shape in [Problem Solving §14](../problem-solving/lesson.md#14-repetition).

Two facts to burn in:

1. `do-while` **always runs the body at least once** — the check is after. A `while` loop whose condition starts false runs **zero** times. Neither is "better"; they answer different questions (§7).
2. The semicolon after `while (...)` in a do-while is **required** and easy to forget: `} while (choice != 0);` — note the `;`.

**Dry-run comparison.** Same task, "read a number until one in 1–10 arrives", two designs, input `99`:

- `while` version (`while (bad)` with `bad` initialized true): check first → body runs → eventually re-checks. Works, but the *setup* (initialize `bad = true`) is a workaround for "check before the data exists".
- `do-while` version: body runs once unconditionally — no flag needed; the check tests data the body just produced.

| pass | n | valid (1–10)? | verdict |
| ---- | - | ------------- | ------- |
| 1    | 99 | no | body repeats |
| 2    | 5  | yes | loop exits |

## 6. Input-controlled loops — repeat until the data says stop

The countdown knew its trip count in advance (3). Many loops don't: "keep reading orders until the cashier enters 0" — the *user's data* decides how many passes run. This is an **input-controlled** (or event-controlled) loop, and its standard shape is **read → test → process → read again**:

```cpp
// orderTotal.cpp — total order values until a 0 arrives
#include <iostream>

int main() {
    double amount;
    double total = 0;

    std::cout << "Enter order amount (0 to finish): ";
    std::cin >> amount;                 // 1. PRIME READ — before the loop

    while (amount != 0) {               // 2. test the just-read value
        total += amount;                // 3. process
        std::cout << "Running total: " << total << '\n';
        std::cout << "Next amount (0 to finish): ";
        std::cin >> amount;             // 4. READ AGAIN at the very end
    }

    std::cout << "Final total: " << total << '\n';
    return 0;
}
```

The structure's names matter:

- **prime read** — the read *before* the loop, so the condition has data to test. Forgetting it is the classic compile-error-free disaster: the loop tests an uninitialized variable.
- **read-again** — the last statement in the body. Forgetting it creates an infinite loop of the Cause-2 type: the condition keeps testing a value nothing ever changes. (You traced this exact trap in [I/O predictions P8](../cpp-io/predictions.md#answers).)

Trace with inputs `120.5, 80, 0`:

| pass | amount (tested) | amount != 0? | total after |
| ---- | --------------- | ------------ | ----------- |
| —    | 120.5 (prime)   | true → enter | 0           |
| 1    | 120.5           | true         | 120.5       |
| 2    | 80              | true         | 200.5       |
| 3    | 0               | false → exit | 200.5       |

Final output: `Final total: 200.5`.

The `0` here is a **sentinel** — a pre-agreed data value meaning "stop". Sentinels deserve their own treatment (choosing one that can't be confused with real data, and the read-prime-read rhythm that goes with them) — that is [Lesson 3 §4](lesson-3-break-continue-sentinels.md#4-sentinel-controlled-loops-properly).

## 7. while vs do-while — the one-question test

Ask: **must the body run at least once for the question to even make sense?**

- *Show a menu.* Yes — you can't ask "quit?" before showing options → **do-while**.
- *Print the 7 times table.* No — the work doesn't need to happen for the question to be meaningful; and if the size input were 0, zero rows is the correct answer → **while** (or `for`, [Lesson 2](lesson-2-for.md)).
- *Validate input.* Usually yes — you must read at once before you can judge it → **do-while** fits naturally (though the flag-based `while` from [Decisions](../decisions/lesson-2-conditions.md) is fine too).

## Practice

- [Exercises 1–8](exercises.md) (★: loop mechanics, counters, accumulators)
- [Predictions 1–3](predictions.md#questions)
- [Debugging 1–3](debugging.md) — all three are rule-of-three failures
- [Lab 1](labs.md#lab-1--the-drilling-instructor) after Lesson 2

## Key takeaways

- A loop = initialization + condition + update; the condition is checked one more time than the body runs.
- Counter counts events (adds 1); accumulator collects values (adds x). Initialize both before the loop.
- Infinite loops come from a missing/misdirected update or a condition on an unchanged variable; `Ctrl+C` is the brake.
- `do-while` = check after; use it when the body must run at least once (menus, input reading). Semicolon after its `while`.
- Input-controlled loops use read → test → process → read-again, with the prime read before the loop.

→ Next: [Lesson 2 — `for`, idioms, and choosing](lesson-2-for.md)
