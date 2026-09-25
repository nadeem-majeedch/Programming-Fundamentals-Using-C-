---
title: "Pointers Labs"
description: "4 safe-practice labs — the address printer, the swap clinic, the resize desk, the leak detective — each engineered so mistakes surface as compiler warnings and testable output, not crashes."
---

# Pointers Labs (4 scenarios)

> [← Module home](index.md) · ⚠️ This module's labs are **engineered for safety**: every task either avoids dereferencing risky pointers by design, guards explicitly, or studies crash *causes* on paper before touching a keyboard. Attempt each lab's **student tasks** before opening its solution. Format: scenario → requirements → student tasks → solution → explanation → safety notes.

**The lab contract.** You may run everything here freely — but a lab is only *passed* when your written answers to the reflection questions are on paper. Drawing is not optional; it is the deliverable.

---

## Lab 1 — The Address Printer

**Scenario.** Before arrows make sense, addresses must feel ordinary. You are building the tool that *demystifies* the number: a small program that prints where variables live, so the abstraction becomes concrete on **your** machine.

**Requirements.**
R1. Declare: an `int`, a `double`, a `char`, and a `std::string`. Print each one's **value** and **address** (`&v`).
R2. Print the addresses of two consecutive `int`s and compute the gap (cast to `long long` before subtracting — addresses aren't ints). What gap do you observe, and why *that* number?
R3. Declare a pointer to each of the four variables; print the pointer's **own** address (`&p`), its **stored value** (`p`), and what it points to (`*p`) — a 3-row table per variable.
R4. Set one pointer to `nullptr` and print `p` itself (never `*p`). Note what a null pointer *prints* as on your system.

**Student tasks.**
1. Predict each output *before* running (addresses: "a hex number I can't predict" is the correct prediction for most).
2. Fill the 3-column table from R3 for all four variables.
3. Reflection: why is `p`'s own address (`&p`) different from `p`'s value? Draw the two boxes.

**Solution.**

```cpp
#include <iostream>
#include <string>

int main() {
    int         i = 42;
    double      d = 3.5;
    char        c = 'Z';
    std::string s = "hello";

    std::cout << "int    value " << i  << "  at " << &i << '\n';
    std::cout << "double value " << d  << "  at " << &d << '\n';
    std::cout << "char   value " << c  << "  at " << (void*)&c << '\n';  // cast: char* prints as TEXT
    std::cout << "string value " << s  << "  at " << &s << '\n';

    int i2 = 7;
    std::cout << "next int  at " << &i2 << '\n';
    long long gap = (long long)&i2 - (long long)&i;
    std::cout << "gap: " << gap << " bytes\n";

    int* pi = &i;
    std::cout << "pi: own " << &pi << "  holds " << pi << "  target " << *pi << '\n';
    double* pd = &d;
    std::cout << "pd: own " << &pd << "  holds " << pd << "  target " << *pd << '\n';

    int* nul = nullptr;
    std::cout << "null pointer prints as: " << nul << '\n';   // never *nul
}
```

**Explanation.** R2's gap: the compiler may place variables with padding or in any order — the gap is typically **4 or more** (an int's size) but is *not guaranteed*; the lesson is that `&i2 - &i` isn't ordinary subtraction (hence the cast) and that *layout belongs to the compiler*. The `(void*)&c` cast is a practical gotcha: `cout <<` a `char*` prints the **text it points to**, not the address — the cast forces address printing. R4: most systems print null as `00000000` or `0` — a visible "nothing".

**Safety notes.** Nothing here dereferences anything risky: every pointer is aimed at a live local before use, and the null pointer is only *printed*, never followed. This lab is safe to experiment in — try printing `&i + 1` (an address, harmless) vs `*(&i + 1)` (⚠️ do NOT — that's out-of-bounds access; predict what *category* of bug it is instead: [Family 3](lesson-3-arrays-dynamic.md#failure-families)).

**⭐ Extension.** Print the addresses of an array's five elements in a loop — observe the *predictable* stride (contiguous!) versus the unpredictable layout of separate locals.

---

## Lab 2 — The Swap Clinic

**Scenario.** `swap` is the rite of passage — you met [the reference version](../functions/lesson-3-references-testing.md) in Unit 08. This clinic rebuilds it three ways so the *mechanism* — not the syntax — becomes familiar.

**Requirements.**
R1. Implement `swapV(int a, int b)`, `swapR(int& a, int& b)`, `swapP(int* a, int* b)` — each with a one-line contract comment.
R2. From `main`, call all three on test pairs; print x, y after each call.
R3. For `swapP`, add the null-guard no-op (documented) and demonstrate it.
R4. Written deliverable: the three-mechanism table — *what physically crosses the call* (a copy of values / an alias / a copied address) and *what changes in main*.

**Student tasks.**
1. Predict each call's effect before running.
2. Draw the call moment for each version ([Tracing T6](tracing.md) is the model).
3. Reflection: `swapV` compiles and runs politely — why is it still *wrong*? What would catch it (test!), and what would have caught it at compile time?

**Solution.**

```cpp
#include <iostream>

// Contract: swaps its OWN copies — main sees nothing. (Intentionally wrong.)
void swapV(int a, int b) { int t = a; a = b; b = t; }

// Contract: a and b are aliases for the caller's boxes — swaps THE boxes.
void swapR(int& a, int& b) { int t = a; a = b; b = t; }

// Contract: follows the two addresses and swaps the targets; null = documented no-op.
void swapP(int* a, int* b) {
    if (a == nullptr || b == nullptr) return;
    int t = *a; *a = *b; *b = t;
}

int main() {
    int x = 1, y = 2;
    swapV(x, y);  std::cout << x << ' ' << y << '\n';   // 1 2 — nothing happened
    swapR(x, y);  std::cout << x << ' ' << y << '\n';   // 2 1
    swapP(&x, &y); std::cout << x << ' ' << y << '\n';  // 1 2 — swapped back
    swapP(nullptr, &y);                                  // safe no-op
    std::cout << x << ' ' << y << '\n';                  // still 1 2
}
```

**Explanation.** The three mechanisms ([Lesson 2 §4](lesson-2-references-functions.md#out-parameters), [Tracing T6](tracing.md)): `swapV` rotates its private copies; `swapR` renames main's boxes for the duration of the call; `swapP` receives copied *addresses* whose arrows still land on main's boxes. Note the pointer version needs `&` at the call and `*` in the body — the reference version's plainness is exactly why the [course rule](lesson-2-references-functions.md#the-decision) prefers references when nullability isn't needed.

**Safety notes.** Zero risky operations: no heap, no arithmetic, all pointers guarded. The *dangerous* thing this lab teaches you to avoid is believing polite output — `swapV` runs without warnings on many compilers, which is why the test table (R2) is the safety net, and why "it compiled" is never a verdict.

**⭐ Extension.** Write `minMaxPtr(int a, int b, int* minOut, int* maxOut)` — the Unit 08 [minMax](../functions/lesson-3-references-testing.md) with pointer outputs — then refactor it to references and count the characters of ceremony each style costs.

---

## Lab 3 — The Resize Desk

**Scenario.** The [arrays module](../arrays/lesson-1-basics.md) fixed capacities at compile time. You now run the front desk where capacities grow at runtime — safely, with the pairs rule visible at every step.

**Requirements.**
R1. Start with a heap array of capacity 3, filled from input.
R2. When full and another value arrives: allocate capacity 6, copy, `delete[]` the old block, re-point — printing a line at each phase (`allocating 6... copied 3... released old block`).
R3. Support at least two growths (3 → 6 → 12).
R4. At the end: print all values, then release — and print the pairs-audit line: `news: 3, deletes: 3, balanced: yes`.

**Student tasks.**
1. Draw the three-phase diagram for the first growth (old block, new block, the arrow moving).
2. After each phase, state who owns the live block.
3. Reflection: what would the diagram look like if the copy loop was accidentally `for (i = 0; i < cap_new; ...)`? (Category of bug? Why might it not crash *today*?)

**Solution.**

```cpp
#include <iostream>

int main() {
    int cap = 3;
    int count = 0;
    int* data = new int[cap];
    int news = 1, dels = 0;

    int v;
    while (std::cin >> v && v != -1) {
        if (count == cap) {
            int newCap = cap * 2;
            std::cout << "allocating " << newCap << "...\n";
            int* bigger = new int[newCap];
            news += 1;
            for (int i = 0; i < count; i = i + 1) bigger[i] = data[i];
            std::cout << "copied " << count << "...\n";
            delete[] data;
            dels += 1;
            data = bigger;                    // re-point AFTER the release
            cap = newCap;
            std::cout << "released old block\n";
        }
        data[count] = v;
        count += 1;
    }

    for (int i = 0; i < count; i = i + 1) std::cout << data[i] << ' ';
    std::cout << '\n';

    delete[] data;
    dels += 1;
    data = nullptr;
    std::cout << "news: " << news << ", deletes: " << dels
              << ", balanced: " << (news == dels ? "yes" : "NO") << '\n';
}
```

**Explanation.** This is [Challenge C4's](challenges.md#c4) doubling growth, unrolled into a visible audit. The one ordering rule that matters: **allocate → copy → delete → re-point** — re-pointing *before* the delete orphans the old block (leak); deleting *before* the copy would be a dangling read. The audit counter is your first heap bookkeeping tool — in the mini-project it becomes a standing report.

**Safety notes.** The pattern is the safe one by construction: exactly one live owner at every instant, all arrows tamed on the release line. The classic student version of this lab crashes because they `delete data` (no brackets) — you know why that's Family "form mismatch" and what it damages ([D7](debugging.md#d7)).

**⭐ Extension.** Add shrink-on-demand: when count drops below cap/4, halve the capacity (same four-phase discipline, plus one new decision: never shrink below 4).

---

## Lab 4 — The Leak Detective

**Scenario.** You are the *inspector*: given five case files (snippets), produce written verdicts — without running anything. Reading memory bugs cold is the actual job skill; the compiler won't file the report for you.

**Requirements.**
R1. For each case: draw the stack/heap diagram at the last line; state the family (leak / dangling / invalid / double-delete / clean); write the one-line verdict and the one-line repair.
R2. Cases (all from the lesson galleries — no new material):

| Case | Snippet |
| --- | --- |
| 1 | `int* p = new int(5); int* q = p; delete p; q = nullptr; std::cout << (p == nullptr);` |
| 2 | `int* p = new int[3]; p[0] = 1; delete p; p = nullptr;` |
| 3 | `int* get() { int* t = new int(9); return t; } int main() { delete get(); }` |
| 4 | `int* p = new int(1); p = new int(2); delete p; p = nullptr;` |
| 5 | `void f(int* p) { if (p) { *p = 10; } } int main() { int v = 0; f(&v); f(nullptr); std::cout << v; }` |

R3. **Then** — and only then — type cases 3 and 5 into the compiler and confirm your prediction *by observation*. Cases 1, 2, 4 stay on paper: they contain undefined behaviour you should be able to *name* without witnessing.

**Student tasks.**
1. Five diagrams, five verdicts, five repairs — on paper.
2. For case 3: predict the exact output *and* the pairs-audit (news vs deletes).
3. Reflection: which case looked cleanest in code but hides the worst form-mismatch? Why doesn't the compiler reject it?

**Solution (verdicts — diagrams are yours to draw).**

| Case | Verdict | Repair |
| --- | --- | --- |
| 1 | **Clean** — q was tamed before... but note: `p` itself still dangles after `delete p`! The *print* only checks `p == nullptr` (true — it was set), so output is `1`; the latent bug is p's untamed arrow if anything used it later. | `p = nullptr;` too — tame *every* arrow. |
| 2 | **Form mismatch** — `delete` on a `new[]` block (heap bookkeeping damaged silently). | `delete[] p;` |
| 3 | **Clean but leaky-free?** — news 1, deletes 1, balanced... and correct: the temporary handle is deleted in the same expression. Verdict: **clean** (a rare case where a discarded handle is *consumed* safely). | none — but style-wise, a named handle + same-line release reads better. |
| 4 | **Leak** — box₁ orphaned by the re-point; box₂ deleted properly. | `delete p;` before re-pointing, or hand box₁'s arrow to a second pointer first. |
| 5 | **Clean** — the callee guarded null; `v` becomes 10 through the caller's address. Output: `10`. | none — this is the pattern working as designed. |

**Explanation.** The detective skill this lab drills: **diagram → family → repair**, in that order, *before* execution. Case 1 is the subtle one — the printed check passes while a real bug (the dangling `p`) sits unobserved next to it: tests check what you *asked*, diagrams show what *is*. Case 3 teaches that "discarded return" is not automatically a leak — ownership depends on whether the value was *consumed*. Case 5 is the whole Lesson 2 contract in five lines.

**Safety notes.** Only cases 3 and 5 are safe to run (no undefined behaviour). Cases 1, 2, 4 contain genuine UB — analyzing them on paper is the point; running them teaches you nothing reliable *because* UB is unpredictable. That's the meta-lesson: **undefined behaviour is a reason to read, not a spectacle to watch.**

**⭐ Extension.** Write two case files of your own — one clean, one with a planted family bug — and swap with a classmate; each produces the verdict sheet for the other's.

---

# Lab index

| Lab | Focus | The safety skill it drills |
| --- | --- | --- |
| 1 | Address printer | addresses as ordinary data; null as a printable "nothing" |
| 2 | Swap clinic | the three call mechanisms; tests as the net under polite-looking wrongness |
| 3 | Resize desk | allocate → copy → delete → re-point, with a live pairs audit |
| 4 | Leak detective | verdicts by diagram, not by execution — reading UB instead of watching it |

**After the labs:** [The Quiz Runner](miniproject.md) — the mini-project that assembles references, out-parameters, and a growing dynamic roster under one ownership contract.
