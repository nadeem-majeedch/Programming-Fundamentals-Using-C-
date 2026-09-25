---
title: "Lesson 3 — Arrays and Dynamic Memory"
description: "Pointers with arrays, pointer arithmetic, new/delete, dynamic arrays, memory leaks, dangling pointers, invalid access, and ownership."
---

# Lesson 3 — Arrays and Dynamic Memory

> [← Module home](index.md) · [← Lesson 2 — References and functions](lesson-2-references-functions.md) · [Exercises →](exercises.md)

## In this lesson you will learn

- why an array's name *is* an address — and what `arr[i]` secretly is
- **pointer arithmetic**: moving through memory box by box
- **`new` and `delete`**: asking the OS for boxes at runtime, and giving them back
- **dynamic arrays** sized at runtime — and why `delete[]` is not `delete`
- the three failure families: **memory leaks**, **dangling pointers**, **invalid access** — each with its prevention rule
- **ownership**: the one idea that organizes all of the above

⚠️ This lesson covers the only material in the course where a one-character mistake crashes the program *outside your logic*. Read the safety boxes; do the tracing exercises before the code.

---

<a name="arrays-as-addresses"></a>
## 1. Pointers with arrays — the name is an address

Here is a fact that explains a dozen things you have already used:

```cpp
int arr[5] = {10, 20, 30, 40, 50};
std::cout << arr << '\n';        // prints an ADDRESS — not the values!
```

An **array's name, used in an expression, converts to the address of its first element.** (The formal name is *array-to-pointer conversion*; the working name is **the handle** — you met it in [Unit 09](../arrays/lesson-3-arrays-functions.md#1-what-gets-passed--the-surprise) when arrays crossed into functions without copying.)

```text
        3000   3004   3008   3012   3016
       ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐
       │ 10 │ │ 20 │ │ 30 │ │ 40 │ │ 50 │   arr
       └────┘ └────┘ └────┘ └────┘ └────┘
         ↑
        arr  (in expressions, the name means 3000)
```

With that fact, indexing **unravels**:

```cpp
arr[2]        // the compiler reads this as:
*(arr + 2)    // "start at arr's address, move over 2 ints, dereference"
```

`arr + 2` does **not** add 2 to the address (that would be 3002, mid-box!). Pointer arithmetic scales by the **pointed-to type's size**: with `int*`, `+1` moves 4 bytes, `+2` moves 8 — always landing on the *next whole int*. That is why a pointer's type matters: the type is the **stride** of the arithmetic.

```cpp
int* p = arr;          // points at arr[0]
std::cout << *p;       // 10
std::cout << *(p + 1); // 20   (one int further)
std::cout << p[2];     // 30   — p[i] works on pointers TOO: p[i] IS *(p + i)
p = p + 3;             // move the arrow three boxes forward
std::cout << *p;       // 40
```

`arr[i]` and `p[i]` are the same machine operation — indexing was pointer arithmetic wearing a friendlier face all along. And bounds? Nothing checked it in Unit 09, and nothing checks it here: `*(arr + 9)` on a 5-box array compiles and misbehaves — the [bounds rule](../arrays/lesson-1-basics.md#6-bounds--what-out-of-bounds-really-does) applies to arithmetic too.

**Walking with a pointer** — the classic traversal:

```cpp
const int* p   = arr;          // start at the first box
const int* end = arr + 5;      // one PAST the last box — the standard "end" convention
while (p != end) {
    std::cout << *p << ' ';
    p = p + 1;                 // advance one int
}
```

Note the `end`: pointers mark ranges as **[begin, end)** — end is *one past the last element*. You have used this convention since your first `for` loop (`i < n` stops at n−1); here it is in pointer form. Re-aiming (`p = p + 1`) is [Lesson 2's Job 1](lesson-2-references-functions.md#two-jobs) running in a loop; `std::cout << *p` is Job 2 for reading.

⚠️ **One honest distinction.** The array name converts to a pointer in expressions, but it is **not a modifiable pointer variable**: `arr = arr + 1;` doesn't compile — the array is nailed to its boxes. Copy the address into a real pointer (`int* p = arr;`) and then walk *that*. This is also why `sizeof arr / sizeof arr[0]` works in the *declaring* function but not after the array is passed: the parameter is only the handle.

---

<a name="stack-heap"></a>
## 2. The stack and the heap — two places boxes live

Until today, every box you made was automatic:

```cpp
void f() {
    int x = 42;          // born when the line runs
}                        // ...dies HERE, automatically, when f returns
```

Automatic variables live in a region called the **stack** — named for how it works: function calls stack up, and when a function returns, its whole frame (all its local boxes) pops off at once. That is why returning a local by address is poison — the box is gone the moment the function exits:

```cpp
int* bad() {
    int local = 42;
    return &local;       // ⚠️ COMPILER WARNING: address of local returned
}                        // local's box just evaporated — caller's arrow now dangles
```

The **heap** (also called the *free store*) is the other region: a big pool you manage yourself. Two differences that matter:

| | Stack (automatic) | Heap (dynamic) |
| --- | --- | --- |
| Lifetime | tied to the function — dies at `return` | **you** decide — from `new` until `delete` |
| Size | fixed at compile time | **decided at runtime** |
| Who cleans up | the compiler | **you** — this is the unit's whole safety story |
| Failure mode if misused | compiler usually catches it | leaks, dangling, invalid access |

---

## 3. `new` — asking for a box at runtime

```cpp
int* p = new int;       // one int on the heap; p holds its address
int* q = new int(42);   // ...and initialize it to 42 in the same breath
```

`new int` does two things at once: asks the OS for enough bytes for an int **on the heap**, and yields the address of that box. The only way to reach the box is through the pointer — heap boxes have **no name**.

```text
   stack                         heap
  ┌──────┐                    ┌──────┐
  │  b?  │ p                  │  42  │  (anonymous — reachable only via p)
  └──────┘                    └──────┘
      ↑___________________________|
```

Why bother, when `int x = 42;` is simpler? Because of the two heap differences above: the box **outlives the function that made it**, and its **size can be decided at runtime**. Both powers arrive in §4.

<a name="delete"></a>
## 4. `delete` — giving the box back

```cpp
delete p;      // the heap box is returned to the system
p = nullptr;   // the idiom: same line, always
```

`delete` returns the box the pointer aims at. It does **not** destroy the pointer — `p` still holds the (now meaningless) address. Using it afterwards is the classic bug; setting it to `nullptr` turns the "meaningless" into the "checkable nothing" from Lesson 1. Two lines, one habit:

```cpp
delete p;
p = nullptr;   // now any accidental *p fails LOUDLY (null deref) instead of quietly
```

### The dynamic array — the reason `new` exists

The killer feature: **size decided while the program runs.**

```cpp
int n;
std::cin >> n;                       // only known at RUNTIME
int* data = new int[n];              // n boxes, contiguous, on the heap
for (int i = 0; i < n; i = i + 1) data[i] = 0;   // index it exactly like an array
```

That line does what no stack array can — `int arr[n];` with a runtime `n` is not standard C++. Everything from [Unit 09](../arrays/lesson-1-basics.md) transfers untouched: traversal, the five classic passes, arrays-as-parameters (the handle travels; a size must travel beside it).

Releasing an **array** uses `delete[]` — with the brackets:

```cpp
delete[] data;      // return the whole n-box block
data = nullptr;     // same-line idiom, always
```

⚠️ **The pairs rule (Module rule 4):** `new` ↔ `delete`, `new[]` ↔ `delete[]` — never crossed, never doubled, never missing. Mixing the forms (`delete` on a `new[]` block) is undefined behaviour; two deletes on one box corrupts the heap; zero deletes leaks it. Count them in pairs like parentheses.

### The template of a correct dynamic-array function

```cpp
// reads n values into a runtime-sized array; returns the handle + size via out-param
int* readValues(int& countOut) {
    std::cin >> countOut;
    if (countOut <= 0) { countOut = 0; return nullptr; }   // guard the degenerate case
    int* data = new int[countOut];
    for (int i = 0; i < countOut; i = i + 1) std::cin >> data[i];
    return data;                        // hand the handle up — the CALLER owns it now
}

int main() {
    int n = 0;
    int* data = readValues(n);          // main becomes the owner
    // ... use data ...
    delete[] data;                      // the OWNER releases — exactly once
    data = nullptr;
}
```

Read the comments twice: the function that `new`s hands ownership to its caller, and the owner deletes. That handoff is §6.

---

<a name="failure-families"></a>
## 5. The three failure families

Everything that can go wrong with dynamic memory lands in one of three families. Learn the *signature symptom* of each and you can diagnose half the crashes you will ever see.

### Family 1 — Memory leaks

**Definition:** heap memory that was `new`ed, never `delete`d, and is no longer reachable by any pointer — allocated, orphaned, unreturnable.

```cpp
void leaky() {
    int* p = new int(42);
    // ... function ends — p (stack box) pops, but the HEAP box remains.
    // Nothing points at it. It can never be freed. That is a leak.
}
```

```text
   stack            heap
  ┌──────┐        ┌──────┐
  │ gone │        │  42  │   ← orphaned: no arrow points here, ever again
  └──────┘        └──────┘
```

The sneaky variant — **re-pointing without releasing**:

```cpp
int* p = new int(1);
p = new int(2);      // ⚠️ the arrow MOVED — box 1 is now orphaned. Leak.
```

The diagram *is* the diagnosis: whenever an arrow moves away from a heap box and no other arrow holds it, you leaked. And the leak is silent — the program runs perfectly, using a little more memory each pass. In a loop, that grows until the machine groans. Small leaks in homework are survivable; the habit is not.

**Prevention:** every `new` has a planned `delete`; never re-point away from a heap box without either deleting first or handing the address to a new owner (§6).

### Family 2 — Dangling pointers

**Definition:** a pointer whose target has already been returned. Two ways to make one:

```cpp
// way 1: delete, then use
int* p = new int(42);
delete p;
// p is now DANGLING — it still holds the old address, but the box is gone
std::cout << *p;     // ⚠️ undefined behaviour — reads memory the system may have reused

// way 2: return the address of a dead local (from §2)
int* bad() { int local = 42; return &local; }   // ⚠️ caller's arrow dangles instantly
```

The cruel part: a dangling read often **appears to work** — the freed box still briefly holds its old bytes — and then corrupts or crashes later, somewhere unrelated. The most confusing bug family in C++, precisely because the failure is delayed and far from the cause.

**Prevention:** the same-line idiom — `delete p; p = nullptr;` — converts every dangling pointer into a null pointer, which at least fails loudly. And the rule from §2: never return the address of a local.

### Family 3 — Invalid memory access

**Definition:** reading or writing memory your program has no right to touch. The umbrella over: dereferencing `nullptr`, dereferencing garbage (uninitialized), out-of-bounds indexing/arithmetic (`*(arr + 9)` on 5 boxes), and use-after-delete.

**Symptom:** the **segmentation fault** ("segfault") — the OS killing your program the instant it touches forbidden memory. Read it as good news: a loud, immediate stop *at the guilty line*, versus the dangling family's quiet rot. The [compiler error catalogue](../toolchain/compiler-errors.md) covers the compile-time cousins; the runtime family lives here.

**Prevention:** Module rules 1–3 — initialize at birth, guard nulls, stay in bounds. All three are *drawing* failures at heart: every one is visible in a diagram as an arrow to a box that isn't yours.

### The three families, one table

| Family | What it is | Signature symptom | Prevention |
| --- | --- | --- | --- |
| **Leak** | heap box, no owner, unreturnable | silent memory growth | plan every `delete`; never orphan a box |
| **Dangling** | pointer to already-freed memory | delayed, distant corruption | `delete` then `= nullptr` on the same line; never return a local's address |
| **Invalid access** | touching memory not yours | segfault, immediately | initialize, guard nulls, stay in bounds |

---

<a name="ownership"></a>
## 6. Ownership — who deletes?

One organizing idea, and the three families become rules instead of fear:

> **Ownership: exactly one region of code is responsible for deleting each heap box.**

Every failure family is an ownership failure in disguise:

- **Leak** = the owner deleted zero times, or lost the address.
- **Double-delete** = *two* owners each felt responsible. Corrupts the heap.
- **Dangling** = somebody deleted while somebody else still held an arrow.

So the working discipline, at introductory level:

1. **`new` in exactly one place per box** — usually the function that becomes the first owner.
2. **Hand off explicitly.** A function returning a `new`ed handle passes ownership to its caller (the §4 template). A parameter used as an out-parameter passes it *downward* — `readValues(&p, &n)` style. Ownership always travels with the handle, visibly.
3. **The owner deletes — exactly once.** Non-owners may *use* the boxes (through their own arrows) but never `delete`.
4. **When unsure who owns a pointer in a diagram, stop coding** — that uncertainty *is* the future bug.

And the honest modern footnote, promised in the module's safety rules: real C++ wraps this discipline inside container and smart-pointer types (`std::vector`, `std::string`, and in later study `std::unique_ptr`) so the compiler itself enforces "one owner." That is precisely why the course built everything on `std::string` and `std::vector`-adjacent patterns first: those tools are this lesson's rules, automated. Here you do it by hand once, to understand what they automate — **Unit 15's classes are where you will build your first wrapper** (a class that news in its constructor and deletes in its destructor).

---

## 7. A complete, safe program

```cpp
// 05_dynamic_safe.cpp — Unit 13 · Session 13.2 — the full discipline in 30 lines
// Compile: g++ -std=c++17 -Wall -Wextra 05_dynamic_safe.cpp -o dynamic_safe
#include <iostream>

// owner handoff: caller receives the handle AND the responsibility
int* readValues(int& countOut) {
    std::cin >> countOut;
    if (countOut <= 0) { countOut = 0; return nullptr; }
    int* data = new int[countOut];
    for (int i = 0; i < countOut; i = i + 1) std::cin >> data[i];
    return data;
}

int sum(const int* data, int n) {          // non-owner: const, uses only
    int total = 0;
    for (int i = 0; i < n; i = i + 1) total += data[i];
    return total;
}

int main() {
    int n = 0;
    int* data = readValues(n);             // main is the owner from here
    if (data != nullptr) {                 // owner guards before use
        std::cout << "sum: " << sum(data, n) << '\n';
    } else {
        std::cout << "no data\n";
    }
    delete[] data;                         // owner releases — exactly once
    data = nullptr;                        // same-line idiom
    return 0;
}
```

Count the pairs with your finger: one `new[]`, one `delete[]` — balanced. Trace the ownership: created in `readValues`, handed to `main`, released by `main`. `sum` never touches `delete` — it isn't the owner, and the `const` says so.

---

## Practice

- [Exercises 14–20](exercises.md) — arrays, new/delete, the families, ownership
- [Tracing 8–10](tracing.md) — heap diagrams, including one deliberate leak to catch
- [Lab 3 — the resize desk](labs.md#lab-3--the-resize-desk) and [Lab 4 — the leak detective](labs.md#lab-4--the-leak-detective) — the families, practiced safely
- [Debugging D4–D10](debugging.md) — every family, seeded and findable

## Key takeaways

- An array's name converts to its first element's address; **`arr[i]` is `*(arr + i)`**; pointer arithmetic moves in whole objects, and the type is the stride
- Stack boxes die automatically at function exit — heap boxes live from **`new`** until **`delete`**, and their size can be runtime-chosen (`new int[n]` / `delete[]`)
- **Leaks** orphan boxes; **dangling** pointers outlive their target; **invalid access** touches what isn't yours — each has a one-line prevention rule, and all three are visible in a diagram
- `delete p; p = nullptr;` on one line, always — it converts silent rot into loud failure
- **Ownership: exactly one owner per box** — hands off visibly, delete exactly once; `std::vector` and Unit 15's classes automate this discipline
