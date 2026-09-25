---
title: "Lesson 3 — Writing Code That Has Fewer Bugs"
description: "Defensive programming, meaningful names, honest comments, functions and modularity, avoiding duplicated code, and a basic code-review checklist."
---

# Lesson 3 — Writing Better C++ Programs

> [← Module home](index.md) · [← Lesson 2 — The debugger and testing](lesson-2-debugger-testing.md)

## In this lesson you will learn

- **defensive programming** — input validation, guard clauses, invariants, and the principle of distrust
- **meaningful names** and the naming rules that prevent a whole bug family
- **comments that earn their lines** — and the ones that rot
- **functions and modularity** — why small, single-purpose functions are the strongest bug repellent in the course
- the **DRY rule** and how duplication quietly manufactures bugs
- a **basic code review** checklist you can run on your own work

Lessons 1–2 made you a better *finder* of bugs. This lesson makes you a rarer *writer* of them. Every practice item in the [practice pack](practice.md) is a bug this lesson teaches you to not create.

---

## 1. Defensive programming — distrust everything, especially yourself

The defensive programmer assumes every assumption will be violated, and answers in advance:

```cpp
// Non-defensive: trusts the caller
int average(const int a[], int n) {
    int total = 0;
    for (int i = 0; i < n; i++) total += a[i];
    return total / n;                       // n == 0? crash or garbage
}

// Defensive: checks the contract at the door
bool average(const int a[], int n, double& out) {
    if (n <= 0) return false;               // guard clause: refuse the impossible
    int total = 0;
    for (int i = 0; i < n; i++) total += a[i];
    out = static_cast<double>(total) / n;   // explicit, intentional conversion
    return true;
}
```

**Explanation of the moves.** The **guard clause** (`if (bad) return early;`) checks preconditions first and fails fast — the function's real logic stays un-nested at full indent level, and the caller *cannot* ignore the failure (a `bool` return must be checked, or at least can be). The **explicit conversion** replaces an implicit one — Lesson 1 of the Foundations module's implicit-conversion traps, now defensive. And the second version's signature documents the contract: *this function can fail, and says so.*

The defensive toolkit, in frequency order:

1. **Validate at the boundary.** Every value arriving from a user, a file, or a parameter you don't control is checked *once*, at the door — then trusted inside. (The Files module's open-check pattern is this rule in disguise; so was every guard chain in the Decisions module.)
2. **Prefer explicit over implicit.** Explicit casts with intent, explicit `else`, explicit initialization (`int count = 0;` — the uninitialized variable is C++'s classic ghost, and `-Wall` flags it for a reason).
3. **Make illegal states unrepresentable.** If marks below 0 are meaningless, the reading code refuses them — the *state* never enters the program, so no downstream code needs to handle it.
4. **Check pairs.** Every `new` has a `delete` in sight (Pointers module); every `open` has a close or an explicit lifetime; every acquire pairs with a release. The Pointers module called this *ownership* — it's the same discipline here.

> **The balance, stated honestly:** defense has a cost (more code, more branches to test). The course's rule: *validate inputs and boundaries ruthlessly; assert internal invariants; and do not clutter arithmetic that cannot fail.* Defense is a budget; spend it where the distrust is earned.

---

## 2. Meaningful names — the cheapest debugging there is

```cpp
// Who wrote this, and what does it do?
int p(const int x[], int n, int t) {
    int r = -1;
    for (int i = 0; i < n; i++) if (x[i] == t) r = i;
    return r;
}

// Same code. One of these versions debugs itself.
int findFirstIndex(const int values[], int count, int target) {
    int resultIndex = -1;
    for (int i = 0; i < count; i++)
        if (values[i] == target) resultIndex = i;
    return resultIndex;
}
```

The rules this course follows:

- **Names answer "what", not "how".** `total` not `t2`, `isSorted` not `flag1`.
- **Booleans read as sentences.** `isValid`, `hasDuplicates`, `found` — an `if (isValid)` reads like the thought you're checking.
- **One letter only for the genuinely anonymous:** loop indices (`i`, `j`), or where convention is overwhelming. `int e;` holding an *employee count* is a bug factory.
- **Units in the name when the type can't say them:** `delaySeconds`, `priceRupees`. Two integers named `time` and `Time` differing only in units is how Mars-class bugs happen.
- **Consistency beats cleverness.** If the codebase says `count`, don't introduce `numItems` on the next line. The reader's pattern-matching is an asset; don't break it.

**The test:** read your function's body aloud, skipping every name you'd have to explain. Those are the ones to rename — *before* the debugger has to guess with you.

---

## 3. Comments — what to write, what to leave out

Comments exist to carry what the code *cannot* say:

- **The why.** `// use long long: 13! overflows int` — a decision and its reason. The code says *what*; the comment says *why this way*.
- **The contract.** What a function expects, returns, and refuses — where the signature can't carry it.
- **Section signposts** in long files, and **references to the rule being implemented** ("spec §2: descending order").

And the ones to leave out:

- **Restatements.** `i++;  // increment i` — noise that the eye learns to skip, taking real comments with it.
- **Apologies.** `// TODO: this is broken` is an unpaid debt with interest; fix it or file it (a real note in your journal).
- **Soured code.** Large commented-out blocks rot silently — version control (or, at this scale, your project folder's backups) remembers old versions so the file doesn't have to.

**The maintenance rule that outranks all of the above:** a wrong comment is worse than no comment. When you change code, the adjacent comment is part of the change. The pair (`n - pass` and its comment "skip the sorted tail") must move together or both are lies.

---

## 4. Functions and modularity — the strongest bug repellent in the course

Every function is a wall: inside, you may reason freely; across, only the signature matters. The debugging dividend is direct — a bug in `computeAverage` *cannot* come from the menu loop, and the menu loop's bug cannot hide in the arithmetic. Small functions shrink the search space; that is their debugging value, stated in Lesson 1's terms: **modular programs make the shrink step of the workflow automatic.**

The course's working standards (all learned in the Functions module, all restated here as bug-prevention):

- **One job per function, name = the job.** If you need "and" to describe it, it's two functions.
- **Short enough to see whole.** Roughly one screen; longer is a smell, not a sin — but ask for a decomposition.
- **Pass what it needs; return what it makes.** Reference parameters *only* for genuine outputs (and `const&` for big read-only inputs). The global-variable ban (Functions module) is a debugging rule in disguise: globals mean any bug *might* be anywhere.
- **Test functions in isolation.** The tiny driver habit — call the function with known inputs, check the answers — is unit testing at student scale, and it localizes bugs to one wall before the program is even assembled.

---

## 5. Avoiding duplicated code — the DRY rule

**DRY — Don't Repeat Yourself:** every piece of knowledge in a program should have one authoritative home.

```cpp
// The debt: the grade rule lives in three places.
char gradeExam(int m)  { if (m >= 90) return 'A'; if (m >= 80) return 'B'; ... }
char gradeQuiz(int m)  { if (m >= 90) return 'A'; if (m >= 80) return 'B'; ... }
char gradeProject(int m){ if (m >= 90) return 'A'; /* oops: >= 70 */ ... }
```

The third copy drifted. Now the program grades identical marks differently depending on *which copy runs* — a bug that exists *because* of duplication, and one the testing discipline must now hunt in three places forever. The fix is mechanical: **one authoritative function** (`char grade(int mark)`), three callers. When the rule changes (it always changes), it changes in exactly one place.

The student-scale practice: when you find yourself *copying* a block to paste elsewhere — stop, and extract a function instead. Copy-paste-modify is how one bug becomes five; the extracted function is one place, tested once, fixed once. (The Functions module's refactor exercises were DRY drills; the Records module's `StudentRecord` was knowledge given one home — the record definition — instead of five parallel arrays.)

**The honest caveat:** DRY has a failure mode — merging things that *look* alike but change for *different reasons* (exam grading and project grading may legitimately diverge). The rule for that case: duplicate twice, then decide. Three copies with two identical is DRY's signal; three copies that all drift apart were three different rules wearing one costume.

---

<a name="6-basic-code-review--reading-code-like-a-reviewer"></a>
## 6. Basic code review — reading code like a reviewer

Professional teams review each other's code before it ships, because a second pair of eyes is the cheapest bug filter ever invented. You can review your own — after a gap (overnight is ideal; lunch works) the code is stranger, and strangeness reveals bugs. The checklist to run, top to bottom:

1. **Names** — do they say what they mean? Any `temp`, `x2`, `flag`?
2. **Bounds** — every loop, every index: where's the off-by-one? Test the boundaries from Lesson 2 in your head.
3. **Initialization** — every variable assigned before read? (`-Wall` flags these — run it and read the output.)
4. **Guard clauses** — every input checked at the door? Every division's denominator? Every array's index against its capacity?
5. **Duplication** — two blocks that differ by one line? Extract.
6. **Function hygiene** — one job each? Under a screen? No globals?
7. **Comments and code agree** — every comment still true after this change?
8. **Tests** — do the three families exist for anything new? Is the regression table current?

Run it on the [practice pack's](practice.md) buggy programs *before* finding their bugs — the checklist catches most of them mechanically, which is exactly the point: **the checklist is the bug family, written down.**

---

## Check yourself

- The DRY "three copies" rule — why wait for three? (One duplicate might be a coincidence of similarity; the third copy reveals drift and justifies the extraction. Premature merging can weld together things that diverge for real reasons.)
- Why is a wrong comment worse than none? (It actively asserts a falsehood about the code — the reader must discover the truth *twice*.)
- Which defensive tool matches user input, and which matches internal invariants? (Validation/guard clauses at the boundary; `assert` inside the machine.)

## Where next

- [Practice pack](practice.md): twenty broken programs, description → hints → fix → explanation.
- [The Debugging Challenge Lab](lab.md): triage under time.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
