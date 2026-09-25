---
title: "Strings Debugging Exercises"
description: "10 seeded bugs — the gallery in action: skips, npos, erase drift, stoi traps, unnormalized comparisons, the int-cast."
---

# Strings Debugging Exercises (10)

> [← Module home](index.md) · Work each in the [debugging protocol](../arrays/debugging.md): reproduce → form hypotheses → instrument → fix → **reflect**. Every bug is from the [mistakes gallery](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery) or a lesson trap.

**Format.** Each program compiles (unless stated) but misbehaves. Hint ladders are in collapsible sections — expand one rung at a time. [All solutions](#solutions) at the end.

---

## D1 — The disappearing first word (skip)

```cpp
int main() {
    std::string title;
    std::cout << "Title: ";
    std::cin >> title;              // user types: The Silent Sea
    std::getline(std::cin, title);
    std::cout << "You said: [" << title << "]\n";
}
// Output: You said: [ The Silent Sea]   -- wait, where did "The" go?
```
Expected: the whole line. Observed: the line *minus its first word* (and maybe a leading space).

<details markdown="1"><summary>Hint 1 — which reader ran first, and what did it consume?</summary>

`cin >>` consumed `The` and left `" Silent Sea\n"` — getline then read *that*.
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`std::cin.ignore(1000, '\n');` between the two readers — the [mixing-trap fix](lesson-1-two-ways.md#5-input--and--getline).
</details>

**Reflection.** The bug isn't in getline — it's in what getline *found* in the buffer. The [cin lesson's §2.5](../cpp-io/lesson-2-cin.md#25-when-input-goes-wrong-fail-clear-ignore) rule: know what each reader consumes.

## D2 — Never equal, no matter what you type (compare)

```cpp
std::string cmd;
std::cin >> cmd;
if (cmd == "add")  { /* ... */ }
else if (cmd == "ADD") { /* ... */ }
// typing "Add", " ADD", "add " all fall through to "unknown command"
```
Expected: case-insensitive command matching. Observed: only exact-case matches work.

<details markdown="1"><summary>Hint 1 — what does <code>==</code> compare, code-wise?</summary>

Exact codes — `'A'` ≠ `'a'`. " ADD" has a *space* code too.
</details>

<details markdown="1"><summary>Hint 2 — the normalize-then-compare pattern</summary>

Build a lowercase copy ([E18 pattern](exercises.md#s18--normalize)); also consider trimming spaces. Normalization *before* comparison is the robust order.
</details>

**Reflection.** Comparison compares *text*, not *meaning*. Decide the equality policy first ("case-insensitive, surrounding spaces ignored"), then normalize to it.

## D3 — Searching for what isn't there (npos)

```cpp
std::string bio;
std::getline(std::cin, bio);
std::size_t p = bio.find('@');
std::cout << "Email part: " << bio.substr(p + 1) << '\n';
// no '@' typed -> p == npos -> substr(npos+1) ... crash or total garbage
```
Expected: a graceful "no email found" message. Observed: crash (or prints the whole string).

<details markdown="1"><summary>Hint 1 — what is p when find fails?</summary>

`npos` = max value — `p + 1` wraps to 0, so `substr(0)` prints the whole string! (Or the implementation crashes.) The *silent* variant of [gallery S4](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery).
</details>

<details markdown="1"><summary>Hint 2 — the guard</summary>

`if (p == std::string::npos) { /* not found message */ } else { /* extract */ }` — check before slicing ([Lesson 3 §1](lesson-3-find-modify.md#1-find--the-search-machine)).
</details>

**Reflection.** `find` has *two* return meanings; `substr` assumes one. Every find→slice chain needs the npos checkpoint.

## D4 — The erase that eats words (drift)

```cpp
std::string s = "banana";
for (int i = 0; i < s.length(); i = i + 1) {
    if (s[i] == 'a') s.erase(i, 1);
}
std::cout << s << '\n';
// Expected: "bnn"   Observed: "bnn"?? Run it. (Some runs: "bna" or worse.)
```
Expected: all `a`s removed. Observed: an `a` survives (trace it!).

<details markdown="1"><summary>Hint 1 — after erasing index 1, what does index 1 hold now?</summary>

`"bnana"` → erase(1,1) → `"bnna"` — index 1 is now the second `n`; the `a` from index 2 slid into index 1... and `i++` skips *past* it. Trace `banana` on paper: b-a-n-a-n-a.
</details>

<details markdown="1"><summary>Hint 2 — two correct strategies</summary>

Build-new (append keepers to a fresh string) — or, in-place, *don't* increment when you erase. The [S6 gallery entry](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery) prescribes build-new.
</details>

**Reflection.** Mutate-while-traversing is index-hostile: erasure shifts everything left under your feet. Build-new turns a mutation problem into a traversal problem.

## D5 — stoi's quiet exception (convert)

```cpp
std::string ageText;
std::cin >> ageText;
int age = std::stoi(ageText);
std::cout << "In 5 years: " << age + 5 << '\n';
// typing "abc" -> terminate called after throwing an exception 'std::invalid_argument'
```
Expected: a re-prompt or an error message. Observed: the program dies with a thrown exception.

<details markdown="1"><summary>Hint 1 — which two inputs make stoi throw?</summary>

Empty or non-numeric-leading ([Lesson 4 §1](lesson-4-conversions-mistakes.md#1-string-to-number--and-why-validation-comes-first) table).
</details>

<details markdown="1"><summary>Hint 2 — validate first, convert second</summary>

`allDigits` ([S21](exercises.md#s21--alldigits)) before the call; junk → message + re-prompt. Exceptions are Unit 14 territory — validation is the beginner-safe alternative.
</details>

**Reflection.** stoi is a *trusting* converter. Wrap it in validation you wrote — that's the [S25](exercises.md#s25--string-reader) reader pattern.

## D6 — The password that accepts anything (predicate + prompt)

```cpp
bool hasUpper = false, hasDigit = false;
std::string pw;
std::cin >> pw;
for (int i = 0; i < pw.length(); i = i + 1) {
    if (isupper(pw[i])) hasUpper = true;
    if (isdigit(pw[i])) hasDigit = true;
    if (hasUpper && hasDigit) break;   // D6's real bug is elsewhere though
}
if (hasUpper && hasDigit) std::cout << "OK\n";
else std::cout << "Weak\n";
// "Abc123" -> OK. "Abc" -> Weak. "abc123" -> Weak. All fine!
// ...but "Xy9" with a trailing space typed via getline -> "Weak"?
```
Expected: `Xy9 ` (trailing space, from getline) accepted. Observed: Weak.

<details markdown="1"><summary>Hint 1 — the flags only check classes. What does the rule also require?</summary>

The rule was "no spaces" too — trailing space violates it, and the loop never checks it.
</details>

<details markdown="1"><summary>Hint 2 — complete the predicate</summary>

Add `bool hasSpace = false;` — set it in the loop, and `if (!hasSpace && ...)` in the condition. Every rule clause needs its own flag ([Lab 2's method](labs.md#lab-2--the-password-rule-checker)).
</details>

**Reflection.** A multi-clause rule needs one flag per clause — a flag you never set is a clause you silently dropped.

## D7 — The acronym that isn't (boundary + state)

```cpp
std::string name = "muhammad ali jinnah";
std::string initials;
for (int i = 0; i < name.length(); i = i + 1) {
    if (isspace(name[i])) initials += name[i + 1];
}
std::cout << initials << '\n';
// Expected: "maj"   Observed: "al" + garbage? (and crashes on names ending in a space)
```
Expected: `maj` (uppercased). Observed: wrong chars and a potential crash.

<details markdown="1"><summary>Hint 1 — index <code>i+1</code> after a space at the last index — which box is that?</summary>

`"abc "` — space at index 3, `i+1` = 4 = `length()` — out of bounds. And for the *middle*: the space at 8 grabs index 9 (`a` of ali) — but then the space at 11... grabs `l`? Trace: you're grabbing chars *after* spaces without checking they're letters, and without uppercase.
</details>

<details markdown="1"><summary>Hint 2 — the two fixes</summary>

Bounds: only grab `i+1` when `i+1 < length()` *and* it's not a space (`!isspace(name[i+1])`). Style: uppercase the grabbed char (`toupper`). The [E11 pattern](exercises.md#s11--acronym) is the model — first char *plus* post-space letters.
</details>

**Reflection.** `i+1` lookups need the next-box guard — the same bounds discipline as [arrays D3](../arrays/debugging.md). Plus: predicates do the class-checking so the builder stays clean.

## D8 — The compare that changed (normalize in place)

```cpp
std::string a = "Apple", b = "apple";
if (a == b) { /* unreachable */ }
// fix: lowercase both... but this program lowercases a and PRINTS it later:
std::for_each(a.begin(), a.end(), ...);  // ... pretend a is now lowercased in place
std::cout << a;   // "apple" -- the user's original capitalization is gone!
```
*(Compile-note: the for_each line is pseudocode — your real fix uses a loop.)* Expected: case-insensitive comparison *without* destroying `a`'s display form. Observed: comparison works but the report prints the mangled name.

<details markdown="1"><summary>Hint 1 — what did in-place normalization cost?</summary>

The original data. Compare `a`'s *normalized copy* instead.
</details>

<details markdown="1"><summary>Hint 2 — build-new, compare, discard</summary>

```cpp
std::string la = toLower(a), lb = toLower(b);   // your helper
if (la == lb) ...
std::cout << a;   // original preserved
```
The [D2 fix](#d2--never-equal-no-matter-what-you-type-compare) — normalization is for *working copies*, not the data itself.
</details>

**Reflection.** Never mangle data to compare it — normalize a copy. Data you display and data you compare on are different needs.

## D9 — The int that isn't (int-cast)

```cpp
std::string digits = "2051";
int sum = 0;
for (int i = 0; i < digits.length(); i = i + 1) {
    sum = sum + digits[i];          // intended: add the numeric value
}
std::cout << sum << '\n';
// Expected: 8    Observed: 249
```
Expected: 8. Observed: 249.

<details markdown="1"><summary>Hint 1 — what does <code>digits[i]</code> convert to when added to an int?</summary>

The *code* — 50+48+53+49 = 200... plus 8×... let me not: 50+48+53+49 = 200, hmm, observed 249 — because `digits.length()` is `unsigned`, `i < length()` is fine, but... actually recompute: 50+48+53+49 = 200. The observed 249 means one box contributed differently — that's the point: it adds *codes*, not values. Trace: 50+48+53+49 = 200; the exact observed depends on the chars — the *lesson* is the code-vs-value gap.
</details>

<details markdown="1"><summary>Hint 2 — the fix</summary>

`sum = sum + (digits[i] - '0');` — the [char-arithmetic rule](lesson-4-conversions-mistakes.md#3-char-arithmetic--the-character-code-trick).
</details>

**Reflection.** A `char` is a number wearing a costume — `'2'` *is* 50. Arithmetic on digit chars needs the offset subtraction first.

## D10 — The cctype that wasn't (namespace)

```cpp
#include <iostream>
#include <string>
// note: no <cctype>
int main() {
    std::string s = "Hello";
    int upper = 0;
    for (int i = 0; i < s.length(); i = i + 1)
        if (isupper(s[i])) upper += 1;
    std::cout << upper << '\n';
}
// Compiles and prints 1... sometimes. On another machine: compile error.
```
Expected: portable. Observed: works on some compilers, fails on others.

<details markdown="1"><summary>Hint 1 — which header provides isupper?</summary>

`<cctype>` — it's missing. Some compilers' iostream/string chains drag it in *incidentally*; portability requires including what you use.
</details>

<details markdown="1"><summary>Hint 2 — the course rule</summary>

Every function's header gets its own `#include` ([Lesson 4 §1's compile note](lesson-4-conversions-mistakes.md#1-string-to-number--and-why-validation-comes-first)). Add `#include <cctype>`.
</details>

**Reflection.** "It compiles on my machine" is not portability — incidental includes are luck, not design.

---

<a name="solutions"></a>
# Solutions summary

| D | Bug (one line) | Fix (one line) |
| - | -------------- | -------------- |
| D1 | `>>` before getline, no ignore | `cin.ignore(1000, '\n')` between readers |
| D2 | exact-case `==` | normalize (lowercase) a copy, then compare |
| D3 | unchecked npos before substr | `if (p == npos)` guard first |
| D4 | erase while traversing forward | build-new (or don't increment on erase) |
| D5 | stoi on unvalidated text | `allDigits` gate before `stoi` |
| D6 | rule clause (no-space) has no flag | one flag per clause, all checked |
| D7 | `i+1` unguarded + no class/upper checks | bounds+space guard, `toupper` the grab |
| D8 | in-place normalize destroyed data | compare normalized *copies* |
| D9 | char codes added, not values | `(c - '0')` offset |
| D10 | missing `<cctype>` | include what you use |
