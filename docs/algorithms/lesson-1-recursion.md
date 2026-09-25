---
title: "Lesson 1 — Recursion: Solving Problems by Shrinking Them"
description: "The recursion concept, base and recursive cases, the call stack felt as boxes, tracing, factorial, Fibonacci, digit processing, recursive search, array recursion, and the mistakes gallery."
---

# Lesson 1 — Recursion

> [← Module home](index.md) · [Lesson 2 — Searching →](lesson-2-searching.md)

## In this lesson you will learn

- what recursion is — a function that calls itself on a **smaller** version of the same problem
- the two mandatory parts of every recursive function: **base case** and **recursive case**
- how the **call stack** makes recursion work — and what "stack overflow" means
- how to **trace** recursive calls by hand with a diagram of stacked boxes
- classic recursive algorithms: **factorial**, **Fibonacci**, **digit processing**, **recursive search**, and **recursive array problems**
- the common mistakes that break recursive functions

You already own every piece of machinery this lesson uses. A recursive function is an ordinary function with one new trick: somewhere in its body, it calls **itself**. Nothing about the function machine changed — the same call-and-return you learned in the Functions module just happens with the caller and the callee being the same function.

---

## 1. The idea: solve a big problem with a smaller copy of itself

Some problems are naturally described in terms of themselves:

- *What is 5!?* — "5 × (what is 4!?)"
- *How many digits does n have?* — "1 + (how many digits does n/10 have?)"
- *Is `x` in the array?* — "Is `x` equal to `arr[0]`, or is `x` in the rest of the array?"

Each answer is built from an answer to a **smaller question of the same kind**. That is recursion: instead of writing a loop that chews through the problem, you write a function that hands a *smaller problem to a copy of itself* and combines the returned answer with a little local work.

Two things must be true or the recursion never ends:

| Part | What it is | Example (factorial) |
| --- | --- | --- |
| **Base case** | The smallest problem you can answer **without recursing** | `n == 0` → return `1` |
| **Recursive case** | Shrink the problem, recurse, combine the answer | `n * factorial(n-1)` |

The base case is the exit door. Every chain of recursive calls must eventually reach one — like a line of people each asking a smaller question, and the last person in line *just knows* the answer and hands it back up the line.

> **The one-sentence test:** if you can't say "the problem gets strictly smaller and here is where it stops," what you've written is not a recursive algorithm — it's a crash with extra steps.

---

## 2. Factorial — the first recursion, worked completely

**Mathematical fact** (stated, not invented): `n! = 1 × 2 × 3 × … × n`, and by convention `0! = 1`. Notice the self-similarity: `5! = 5 × 4!`, and `4! = 4 × 3!`, … down to `0! = 1`. That gives us both cases for free:

**Pseudocode**

```text
function factorial(n):
    if n == 0:              // base case: the question that answers itself
        return 1
    return n * factorial(n - 1)   // recursive case: shrink, recurse, combine
```

**C++ implementation**

```cpp
// factorial.cpp — Programming Fundamentals Using C++
// Unit 10 · Lesson 1 · The first recursion
// Compile: g++ -std=c++17 -Wall -Wextra factorial.cpp -o factorial

#include <iostream>
using namespace std;

long long factorial(int n) {
    if (n == 0) {
        return 1;                 // base case
    }
    return n * factorial(n - 1);  // recursive case
}

int main() {
    for (int n = 0; n <= 10; n++) {
        cout << n << "! = " << factorial(n) << "\n";
    }
    return 0;
}
```

**Sample output**

```text
0! = 1
1! = 1
2! = 2
3! = 6
...
10! = 3628800
```

**Explanation of the example.** The magic is not in the function — it's in what the machine does with it. Read the next section slowly; it is the most important diagram in this lesson.

### Test cases for factorial

| Input | Expected | Why |
| --- | --- | --- |
| `0` | `1` | base case fires immediately |
| `1` | `1` | one recursive call, `1 * 1` |
| `5` | `120` | `5·4·3·2·1` |
| `10` | `3628800` | fits in `int`, barely, at 13! it doesn't — see §9 |

---

## 3. The call stack — recursion felt as stacked boxes

When any function is called, the machine places a **frame** on the call stack: a box holding that call's parameters, local variables, and the spot to return to. When the function returns, its box is removed. Ordinary programs stack and unstack boxes all the time — recursion just stacks **many copies of the same box** before any of them finishes.

Here is `factorial(4)` drawn the way the machine builds it. **Each box is a separate call** with its own `n`. Notice that nothing multiplies yet — every box is *waiting* for the box below it to come back with an answer:

```text
main calls factorial(4)

  ┌─────────────────┐
  │ factorial(4)    │  n=4 → needs 4 * factorial(3)   … waits
  └─────────────────┘
          │ calls
          ▼
  ┌─────────────────┐
  │ factorial(3)    │  n=3 → needs 3 * factorial(2)   … waits
  └─────────────────┘
          │ calls
          ▼
  ┌─────────────────┐
  │ factorial(2)    │  n=2 → needs 2 * factorial(1)   … waits
  └─────────────────┘
          │ calls
          ▼
  ┌─────────────────┐
  │ factorial(1)    │  n=1 → needs 1 * factorial(0)   … waits
  └─────────────────┘
          │ calls
          ▼
  ┌─────────────────┐
  │ factorial(0)    │  n=0 → BASE CASE → returns 1    ✓ nothing to wait for
  └─────────────────┘
```

Now the returns, unwinding upward — each box finishes its multiplication with the answer it received:

```text
  factorial(0) returns 1
  factorial(1) computes 1 * 1  → returns 1
  factorial(2) computes 2 * 1  → returns 2
  factorial(3) computes 3 * 2  → returns 6
  factorial(4) computes 4 * 6  → returns 24      ← main receives 24
```

Two consequences, both important:

- **Depth.** The stack grew 5 boxes deep for `factorial(4)`. Recursion depth = number of stacked boxes. A function that recurses on `n` from 1,000,000 needs a million stacked boxes — and the stack is finite. When it runs out, the program dies with a **stack overflow**. Recursion is not free.
- **Order.** All the "going down" happens first (each box pauses at its recursive call), all the "combining" happens on the way back up. Beginners read `n * factorial(n-1)` as if it computes immediately. It doesn't. It **waits**.

### Trace table — the same thing in table form

| Call | n | action | returns to caller |
| --- | --- | --- | --- |
| 1 | 4 | not base → call factorial(3), wait | — |
| 2 | 3 | not base → call factorial(2), wait | — |
| 3 | 2 | not base → call factorial(1), wait | — |
| 4 | 1 | not base → call factorial(0), wait | — |
| 5 | 0 | base case | 1 |
| 4 | 1 | 1 × 1 | 1 |
| 3 | 2 | 2 × 1 | 2 |
| 2 | 3 | 3 × 2 | 6 |
| 1 | 4 | 4 × 6 | 24 → **main gets 24** |

Read the top half downward (descent), the bottom half upward (ascent). Every recursion trace you do in this course has this two-phase shape.

---

## 4. Fibonacci — recursion's famous warning label

**Definition** (standard, stated): the Fibonacci sequence starts 1, 1, and each later term is the sum of the two before it: 1, 1, 2, 3, 5, 8, 13, 21, … So `fib(n) = fib(n-1) + fib(n-2)` with `fib(1) = fib(2) = 1`.

The recursive translation is famous because it's beautiful — and a trap:

```cpp
// fib.cpp — the naive recursion (kept, but with a warning)
#include <iostream>
using namespace std;

long long fib(int n) {
    if (n <= 2) return 1;            // base case: two of them
    return fib(n - 1) + fib(n - 2);  // recursive case: TWO self-calls
}

int main() {
    for (int n = 1; n <= 10; n++) cout << "fib(" << n << ") = " << fib(n) << "\n";
    return 0;
}
```

**Why the warning.** Follow the calls for `fib(5)`:

```text
                        fib(5)
                       /      \
                  fib(4)        fib(3)
                 /     \        /    \
             fib(3)   fib(2) fib(2) fib(1)
             /    \
         fib(2)  fib(1)
```

`fib(3)` is computed **twice**, `fib(2)` **three times** — and the duplicated subtree duplicates *itself* at every level. The number of calls roughly **doubles with each increase of n**: `fib(30)` makes over a million calls, `fib(50)` would take longer than your patience. The tree above is the whole story: recursion that re-solves the same subproblem over and over.

**Test cases:** `fib(1)=1`, `fib(2)=1`, `fib(7)=13`, `fib(10)=55`. **Mistake to avoid:** the base case is *two* values — write only `n == 1` and `fib(2)` recurses to `fib(0)`, `fib(-1)`, … forever (well, until the stack dies).

The lesson is not "recursion is bad" — it is: *recursion is expensive when subproblems overlap*. Factorial's subproblems never overlap; Fibonacci's overlap massively. In the [challenges](challenges.md) you'll meet the fix (memoization-lite); in the [traces](traces.md) you'll count the calls yourself.

---

## 5. Digit processing — recursion on n / 10

Dividing by 10 chops the last digit off a number; `n % 10` is the last digit. That is a smaller problem *of the same kind*, so number questions become recursive questions:

**Question 1: how many digits does n have?**

```text
digits(n):  if n < 10 → 1            (one digit left: base case)
            else → 1 + digits(n / 10)
```

**Question 2: what is the digit sum?**

```text
digitSum(n):  if n < 10 → n
              else → n % 10 + digitSum(n / 10)
```

```cpp
// digits.cpp — two digit recursions
#include <iostream>
using namespace std;

int digits(int n)   { return n < 10 ? 1 : 1 + digits(n / 10); }
int digitSum(int n) { return n < 10 ? n : n % 10 + digitSum(n / 10); }

int main() {
    int n = 4729;
    cout << n << " has " << digits(n) << " digits\n";   // 4
    cout << "digit sum = " << digitSum(n) << "\n";      // 4+7+2+9 = 22
    return 0;
}
```

**Trace of `digitSum(4729)`**, box style, compressed:

```text
digitSum(4729) = 9 + digitSum(472)
                    digitSum(472) = 2 + digitSum(47)
                                       digitSum(47) = 7 + digitSum(4)
                                                         digitSum(4) = 4   ← base
                    ← 2 + 11 = 13          ← 7 + 4 = 11
← 9 + 13 = 22
```

**Edge cases to test:** single digit (base immediately), `0` (digits: 1 — is that your contract? say so), negative numbers (decide: take absolute value first, or document that negatives are rejected — either is fine, silence is not).

---

## 6. Recursive search — the same linear search, upside down

You wrote linear search with a loop in the arrays module. The recursive version asks a different question: *"is the first element it — or is it in the rest?"*

**Pseudocode**

```text
function recSearch(arr, n, x, i):      // i = index to start from
    if i == n:        return -1        // ran off the end: not here (base)
    if arr[i] == x:   return i         // found it (base)
    return recSearch(arr, n, x, i + 1) // look in the rest (recurse)
```

```cpp
// recsearch.cpp — linear search, recursively
#include <iostream>
using namespace std;

int recSearch(const int arr[], int n, int x, int i) {
    if (i == n)      return -1;              // base: no elements left
    if (arr[i] == x) return i;               // base: found
    return recSearch(arr, n, x, i + 1);      // recurse on the rest
}

int main() {
    int a[] = {4, 8, 15, 16, 23, 42};
    cout << recSearch(a, 6, 23, 0) << "\n";  // 4
    cout << recSearch(a, 6, 7, 0)  << "\n";  // -1
    return 0;
}
```

**Explanation.** Two base cases: *found* and *exhausted*. Each call examines exactly one element and delegates the remainder, so the recursion depth is at most n+1. Test: target first (1 call), target last (n calls), target absent (n+1 calls), empty array (`n=0` → −1 immediately).

> **Honest note:** the loop version is better here — same work, no stack growth. We do the recursive version because it is the cleanest possible model of "divide the problem: this element vs. the rest," which binary search (Lesson 2) and the array recursion below build on directly.

---

## 7. Recursive array problems — shrink from either end

Arrays recurse by shrinking from the front (`index 0` vs. `the rest`) or the back (`last element` vs. `the first n-1`). Three classics:

**Sum of the first n elements** — "last element + sum of the rest":

```cpp
// arrsum.cpp — recursion over an array, shrinking from the back
#include <iostream>
using namespace std;

int sumOf(const int a[], int n) {
    if (n == 0) return 0;            // base: nothing left sums to 0
    return a[n - 1] + sumOf(a, n - 1);
}

int main() {
    int a[] = {3, 1, 4, 1, 5};
    cout << sumOf(a, 5) << "\n";     // 14
    return 0;
}
```

**Is the array sorted (non-decreasing)?** — "is `a[0] <= a[1]`, *and* is the rest sorted?"

```cpp
// sorted.cpp — a yes/no question answered recursively
#include <iostream>
using namespace std;

bool isSorted(const int a[], int n) {
    if (n <= 1)  return true;                  // base: 0 or 1 element — sorted by definition
    if (a[n-2] > a[n-1]) return false;         // found one bad pair: done
    return isSorted(a, n - 1);                 // the rest is sorted iff the whole is
}

int main() {
    int b[] = {1, 2, 2, 7, 9};
    int c[] = {1, 2, 0, 7};
    cout << isSorted(b, 5) << isSorted(c, 4) << "\n";  // 1 0
    return 0;
}
```

**Count occurrences of x** — combine the two patterns above:

```text
count(a, n, x):  if n == 0 → 0                          // no elements, no matches
                 else → (a[n-1] == x ? 1 : 0) + count(a, n-1, x)
```

**Explanation of the pattern.** All three follow the same skeleton the factorial taught: base case on *size* (nothing left), shrink by one (drop the last element), combine (add, and-compare, count). Once you see the skeleton, new array recursions are fill-in-the-blank exercises. The [exercises](exercises.md) Part A gives you the blanks.

---

## 8. Common recursion mistakes — the gallery

1. **No base case** → infinite recursion → stack overflow. Symptom: crash with a huge call depth.
2. **Unreachable base case** — the shrinkage goes the wrong way: `factorial(n-2)` with base `n == 1` skips right past it for even n. Test with small inputs *and* odd *and* even.
3. **Not actually smaller** — `fib(n)` calling `fib(n)` unchanged, or "shrinking" `n/2` when the math needs `n-1`. The one-sentence test from §1 catches this.
4. **Work in the wrong place** — printing *after* the recursive call when you meant before (digit printing runs backwards). Trace it: order of return is order of combining.
5. **Forgetting the return value** — calling `factorial(n-1);` as a statement and returning `n *` nothing. The compiler's warning flags catch this one — which is why we compile with `-Wall -Wextra`.
6. **Assuming the recursive call "knows" more than it does** — using a local variable from one frame in another frame. Each box has its own copies. Locals do not survive between frames; parameters passed down do.
7. **Testing only with friendly input** — factorial at 13 overflows `int` (that's why the lesson's version returns `long long`). Failing silently is worse than crashing loudly.

**The prevention ritual:** before running any recursion, write (a) the base case, (b) the exact shrinkage, (c) one hand trace for a small input. If any of the three feels fuzzy, the function is not ready.

---

## Check yourself

- In `factorial(3)`, which line executes first — the `if` or the `return n * factorial(n-1)`? And in which box?
- Why does `fib` need base cases for both `n == 1` and `n == 2`?
- What is the depth of `digitSum(12345)`'s call stack?

(Answers, in order: the `if` — in the `factorial(3)` box, the newest box; because the recursive case needs *two* previous values, so one base value leaves `fib(2)` unanchored; 5.)

## Where next

- [Lesson 2 — Searching →](lesson-2-searching.md): the loop-vs-recursion question gets a real answer — binary search.
- [Trace pack](traces.md): fifteen dry runs, T1–T6 on recursion.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
