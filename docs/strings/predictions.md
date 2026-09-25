---
title: "Strings Predictions"
description: "10 trace/output problems — covering the two ways, indexing, concatenation, comparison, find/substr, modification, and conversion traps."
---

# Strings Predictions (10)

> [← Module home](index.md) · **Trace first on paper** — draw the boxes, one state per step — then commit to an answer. All 10 answers in the [answers section](#answers) (separated so you can't peek accidentally). ★ = first pass · ★★ = needs the toolkit.

**The four rules** for these: (1) `==` on char arrays compares *addresses*, not text. (2) `>>` reads one word; getline reads to newline. (3) `find` returns npos (printed as a huge number) on failure. (4) `substr(pos, len)` — second arg is *length*, and it clips silently.

---

## P1 — The two creators (★)

```cpp
char ca[6] = "cat";
std::string s = "cat";
std::cout << ca << ' ' << s << '\n';
if (ca == s) std::cout << "same";
else         std::cout << "different";
```
**Trace.** What prints on line 1? Does the comparison even *compile* — and if it compiles, what does it compare?

## P2 — The reader mix (★)

```cpp
std::string a, b;
std::cin >> a;                 // input line 1: Silent Sea
std::getline(std::cin, b);     // input line 2: was long
std::cout << "[" << a << "] [" << b << "]";
```
Input:
```text
Silent Sea
was long
```
**Trace.** What is in `a`? What is in `b` — and which reader consumed the rest of line 1?

## P3 — The skipped line (★)

```cpp
int n;
std::string course;
std::cin >> n;                 // input: 42 / then: C++ Fundamentals
std::getline(std::cin, course);
std::cout << n << "/" << course.length();
```
Input:
```text
42
C++ Fundamentals
```
**Trace.** What prints — and what is `course` actually holding? (One reader's leftover is another reader's whole input.)

## P4 — Lengths and last boxes (★)

```cpp
std::string s = "arrays";
std::cout << s.length() << ' ' << s[0] << ' ' << s[5] << ' ' << s[6];
```
**Trace.** Which of the four outputs is valid, and which is undefined? What is the *last valid* index formula?

## P5 — Build-up states (★)

```cpp
std::string s = "C";
s += '+';
s += '+';
s = s + " rocks";
std::cout << s << ' ' << s.length();
```
**Trace.** Final string and length? (Count carefully — spaces are boxes.)

## P6 — Lexicographic truth (★)

```cpp
std::cout << ("apple" < "Banana") << '\n';
std::cout << ("app" < "apple")  << '\n';
std::cout << ("10" < "9")       << '\n';
```
**Trace.** Three booleans (printed 1/0). Rule: lexicographic = code order, prefix rule, no numeric awareness.

## P7 — The npos print (★★)

```cpp
std::string s = "haystack";
std::size_t p = s.find("needle");
if (p == std::string::npos) std::cout << "absent\n";
else std::cout << p << '\n';
// Program B:
std::size_t q = s.find("hay");
std::cout << q << '\n';
```
**Trace.** What does Program A print? Program B? What *kind* of value does find return, and what happens if you slice without checking it?

## P8 — Substr math (★★)

```cpp
std::string t = "abcdefgh";
std::cout << t.substr(2, 3) << '\n';
std::cout << t.substr(0, 5) << '\n';
std::cout << t.substr(6)    << '\n';
std::cout << t.substr(4, 9) << '\n';
```
**Trace.** Four lines. Remember: (start, length), start-only = to the end, length clips.

## P9 — The modify chain (★★)

```cpp
std::string m = "embedded";
m.erase(0, 3);
m.insert(0, "im");
m.replace(4, 1, "dd");
std::cout << m << '\n';
```
**Trace.** Three states after each edit. Expected final: `"imbedded"`. Is it?

## P10 — The char arithmetic (★★)

```cpp
std::string digits = "4729";
int sum = 0;
for (int i = 0; i < digits.length(); i = i + 1) {
    sum = sum + (digits[i] - '0');
}
std::cout << sum << '\n';

std::string lower;
char c = 'M';
lower += tolower(c);
std::cout << lower << ' ' << ('a' - 'A');
```
**Trace.** What is the sum? What prints for `lower` and for `'a' - 'A'`? (Codes: '0' is 48, digits 49–57; 'A' 65, 'a' 97.)

---

<a name="answers"></a>
# Answers

<details markdown="1"><summary>A1 — P1 (two creators)</summary>

Line 1: `cat cat` (both print their text). The comparison **does compile** (array converts to pointer) and compares the **array's address** vs the string's internal data address — different → prints `different`. The text is identical; the comparison isn't comparing text. ([Lesson 1 §2](lesson-1-two-ways.md#2-the-old-way--character-arrays-c-strings), [gallery S1](lesson-4-conversions-mistakes.md#4-the-common-mistakes-gallery))
</details>

<details markdown="1"><summary>A2 — P2 (reader mix)</summary>

`a = "Silent"` (`>>` stops at the space), `b = " Sea"` (getline read the *rest of line 1*: a space + `Sea`). Line 2 (`was long`) is **never read**. `[Silent] [ Sea]`. The buffer had a leftover after `>>`; getline happily took it. ([Lesson 1 §3](lesson-1-two-ways.md#5-input--and--getline))
</details>

<details markdown="1"><summary>A3 — P3 (skipped line)</summary>

`42/0` — `course` holds the *empty string*: the newline `>>` left behind. Line 2's text is never consumed. The [mixing trap](lesson-1-two-ways.md#5-input--and--getline) in its purest form; the fix is `cin.ignore(1000, '\n')` after `cin >> n`.
</details>

<details markdown="1"><summary>A4 — P4 (lengths and last boxes)</summary>

`6 a s` — valid — then `s[6]` is **undefined behaviour** (length 6 → valid indices 0–5). Last valid index = `length() - 1`. Some compilers print garbage for `s[6]`, some crash, some (in debug) assert. ([Lesson 2 §2](lesson-2-indexing-comparison.md#2-indexing--a-string-is-a-row-of-chars))
</details>

<details markdown="1"><summary>A5 — P5 (build-up states)</summary>

Final string: `C++ rocks` — length **9** (C,+,+,space,r,o,c,k,s). States: `C` → `C+` → `C++` → `C++ rocks`. Both `+=` forms (char, string) and `s = s + "..."` behave.
</details>

<details markdown="1"><summary>A6 — P6 (lexicographic)</summary>

**0, 1, 1.** First: `'a' (97) > 'B' (66)` — lowercase codes are *larger* — so "apple" > "Banana" and the expression prints **0** (the trap: uppercase sorts before lowercase). Second: "app" is a proper prefix → shorter sorts first → `1`. Third: `'1' (49) < '9' (57)` — lexicographic, no numeric awareness → `1`. ([Lesson 2 §4](lesson-2-indexing-comparison.md#4-comparison--the-lexicographic-rules))
</details>

<details markdown="1"><summary>A7 — P7 (npos)</summary>

A: `absent`. B: `0`. find returns `std::size_t` (unsigned). Slicing without the check: `s.substr(p)` with p = npos either throws or (npos+1 wrap) returns the whole string — the [D3 bug](debugging.md#d3--searching-for-what-isnt-there-npos).
</details>

<details markdown="1"><summary>A8 — P8 (substr)</summary>

`cde` (3 chars from 2) · `abcde` (5 from 0) · `gh` (start 6 → end) · `efgh` (start 4, length 9 **clips** to what exists). ([Lesson 3 §2](lesson-3-find-modify.md#2-substr--the-extraction-machine))
</details>

<details markdown="1"><summary>A9 — P9 (modify chain)</summary>

`"embedded"` → erase(0,3) → `edded` → insert(0,"im") → `imedded` → replace(4,1,"dd") → `imeddded`. Final: **`imeddded`** — not `imbedded`! The replace hit index 4 of the *current* string (`d` of ded... verify: i-m-e-d-d-e-d, index 4 = second `d`, replaced by `dd` → i m e d d d e d). Edit chains re-index every step — predict state by state, never jump. ([Lesson 3 §4](lesson-3-find-modify.md#3-modification--insert-erase-replace))
</details>

<details markdown="1"><summary>A10 — P10 (char arithmetic)</summary>

Sum: 4+7+2+9 = **22**. `lower` prints `m` ('M' 77 − 32 → 109 = 'm'). `'a' - 'A'` = 97 − 65 = **32**. The offset dance works in both directions. ([Lesson 4 §3](lesson-4-conversions-mistakes.md#3-char-arithmetic--the-character-code-trick))
</details>
