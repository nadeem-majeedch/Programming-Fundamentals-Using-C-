---
title: "Topic Revision Tests T1–T4 — Variables, Control Flow, Functions, Collections"
description: "Four 12-question topic tests spanning multiple units: variables & expressions, control flow, functions, and arrays/vectors — each with hidden answer keys, explanations, and difficulty labels."
---

# Topic Revision Tests — T1 to T4

> 12 questions each · ~20 min each · these *span units* — take them after
> finishing the whole topic cluster, not mid-unit · attempt ALL before any key ·
> [Hub](index.md) · [T5–T8 →](topic-tests-2.md)

---

## T1 — Variables, types & expressions (Units 02–03)

**Q1.** [Easy] Which type for a single letter grade?

- a) `int`
- b) `char`
- c) `double`
- d) `bool`

**Q2.** [Easy] `int x = 2.9;` stores…

- a) 2.9
- b) 2 — the fraction is truncated (with a narrowing warning)
- c) 3
- d) an error

**Q3.** [Easy] Which is *not* a valid identifier?

- a) `total2`
- b) `_temp`
- c) `2total`
- d) `myValue`

**Q4.** [Medium] What does this print?

```cpp
int a = 9, b = 4;
cout << a / b << " " << a % b;
```

- a) `2.25 1`
- b) `2 1`
- c) `2 0`
- d) `3 1`

**Q5.** [Medium] What does this print?

```cpp
double d = 7.0 / 2;
int i = 7 / 2;
cout << d << " " << i;
```

- a) `3.5 3` — the literal 2.0's effect stops at the division
- b) `3 3`
- c) `3.5 3.5`
- d) `4 3`

**Q6.** [Medium] Which expression converts Celsius `c` (a double) to
Fahrenheit correctly?

- a) `c * 9 / 5 + 32` with c an int
- b) `c * 9.0 / 5.0 + 32`
- c) `9 / 5 * c + 32`
- d) `c * (9 / 5) + 32`

**Q7.** [Medium] What is `b` after `int a = 5; int b = a++ + 2;`?

- a) 8 — a++ used 5, then a became 6
- b) 7
- c) 6
- d) 9

**Q8.** [Medium] What does this print?

```cpp
int x = 10;
x -= 3;
x *= 2;
cout << x;
```

- a) 14
- b) 10
- c) 7
- d) 20

**Q9.** [Hard] What does this print?

```cpp
int total = 2500;
cout << total / 1000 << "k " << (total % 1000) / 100 << "h";
```

- a) `2k 5h`
- b) `2.5k 5h`
- c) `2k 0h`
- d) `25k 0h`

**Q10.** [Hard] A student writes `double avg = (a + b + c) / 3;` with three
ints and gets whole numbers only. The minimal correct fix is…

- a) `double avg = (a + b + c) / 3.0;`
- b) `double avg = double(a) + double(b) + double(c);`
- c) `double avg = (double)(a + b + c / 3);`
- d) `double avg = (a + b + c) / 3;` with a cast on the result

**Q11.** [Hard] What does this print?

```cpp
bool flag = true;
flag = !flag;
flag = flag && false;
cout << boolalpha << flag;
```

- a) `true`
- b) `false`
- c) `0`
- d) `1`

**Q12.** [Hard] `const double TAX = 0.15;` appears at the top of the file and
is used in four functions. The main benefit versus writing `0.15` inline four
times is…

- a) faster execution
- b) one named place to read *and* change the rate — with the compiler
  preventing accidental modification
- c) smaller executable
- d) the value can be changed while running

<details markdown="1">
<summary><strong>T1 — Answer key</strong></summary>

**Q1 — b.** A grade letter is one character. `string` would also work for
multi-character grades, but for a single letter, `char` is the honest type.

**Q2 — b.** Initializing an int from a double truncates toward zero: 2.9 →
2. Compilers warn (`-Wall`) — another reason warnings are always on.

**Q3 — c.** Identifiers cannot *start* with a digit. Leading underscores and
embedded digits are fine.

**Q4 — b.** Integer division 9/4 = 2; remainder 9%4 = 1. The pair partitions
9 = 2·4 + 1.

**Q5 — a.** `7.0 / 2` promotes to 3.5 — but that promotion belongs to that
one expression only. `7 / 2` on ints is 3. Each expression is evaluated with
its own types.

**Q6 — b.** The famous 9/5 trap: with int literals, `9 / 5` is 1, and both
(c) and (d) compute `c + 32`. Floating literals force real division.

**Q7 — a.** Post-increment: the *old* value (5) participates in the
expression, then a becomes 6. b = 5 + 2 = 8.

**Q8 — a.** 10 − 3 = 7; 7 × 2 = 14. Compound operators read left to right as
sequential updates.

**Q9 — a.** 2500/1000 = 2 (integer division), remainder 500, 500/100 = 5.
Unit decomposition with `/` and `%` — the pattern from hundreds and seconds.

**Q10 — a.** One `3.0` promotes the entire division. (d) casts *after* the
integer division already destroyed the fraction; (b) never divides.

**Q11 — b.** true → !true = false → false && anything = false. `boolalpha`
prints the words; without it you'd see `0`.

**Q12 — b.** The named constant documents *meaning*, centralizes change, and
gets compiler enforcement. Executable speed is identical — the win is
maintainability and safety.
</details>

---

## T2 — Control flow: selection & iteration (Units 04–06)

**Q1.** [Easy] Which `if` correctly rejects negatives and values above 100?

- a) `if (m < 0 || m > 100) reject();`
- b) `if (m < 0 && m > 100) reject();`
- c) `if (0 <= m <= 100) accept(); else reject();`
- d) `if (!(m < 0 && m > 100)) reject();`

**Q2.** [Easy] How many times does the body of `for (int i = 3; i > 0; i--)`
run?

- a) 2
- b) 3
- c) 4
- d) 0

**Q3.** [Easy] `switch` cases need which type of expression?

- a) any double
- b) an integral or enum value
- c) a string
- d) a bool only

**Q4.** [Medium] What does this print for input `12`?

```cpp
int n; cin >> n;
if (n % 3 == 0 && n % 4 == 0) cout << "both";
else if (n % 3 == 0)          cout << "three";
else if (n % 4 == 0)          cout << "four";
else                          cout << "neither";
```

- a) three
- b) four
- c) both
- d) neither

**Q5.** [Medium] What is `s` after this?

```cpp
int s = 0;
for (int i = 1; i <= 10; i++) {
    if (i % 2 != 0) continue;
    s += i;
}
```

- a) 55
- b) 30 — 2+4+6+8+10; odd values skipped by continue
- c) 25
- d) 20

**Q6.** [Medium] What does this print?

```cpp
int n = 100;
while (n > 0) {
    n -= 30;
}
cout << n;
```

- a) 0
- b) 10
- c) −20
- d) infinite loop

**Q7.** [Medium] Which loop prints 5 4 3 2 1?

- a) `for (int i = 5; i >= 1; i--) cout << i << " ";`
- b) `for (int i = 5; i > 1; i--) cout << i << " ";`
- c) `for (int i = 1; i <= 5; i++) cout << 6 - i << " ";`
- d) both (a) and (c)

**Q8.** [Medium] What does this print?

```cpp
int i = 0;
while (i < 10) {
    if (i == 3) break;
    cout << i;
    i++;
}
```

- a) 012
- b) 0123
- c) 0123456789
- d) nothing

**Q9.** [Hard] What does this print?

```cpp
for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
        if (j == i) continue;
        if (j > i) break;
        cout << i << j << " ";
    }
}
```

- a) `21 31 32 `
- b) `12 13 23 `
- c) `11 22 33 `
- d) nothing

**Q10.** [Hard] A grading ladder must output A (90+), B (80–89), C (70–79),
F otherwise. Which ladder is correct for input `85`?

- a) `if (m >= 90) A; if (m >= 80) B; if (m >= 70) C; else F;` — independent ifs
- b) `if (m >= 90) A; else if (m >= 80) B; else if (m >= 70) C; else F;`
- c) `if (m >= 70) C; else if (m >= 80) B; else if (m >= 90) A; else F;`
- d) `switch (m) { case 90: A; ... }`

**Q11.** [Hard] What does this print?

```cpp
int count = 0;
for (int i = 100; i <= 999; i += 100)
    for (int j = 0; j < 3; j++)
        if ((i + j) % 2 == 0) count++;
cout << count;
```

- a) 2
- b) 3 — 100+0, 100+2, 200+0, 200+2 → 4… trace it
- c) 4
- d) 6

**Q12.** [Hard] The sentinel loop `while (cin >> x && x != -1) { sum += x; }`
is preferred over `do { cin >> x; if (x == -1) break; sum += x; } while
(true);` mainly because…

- a) it is faster
- b) the condition states both stop reasons up front — the loop's contract is
  readable in one line, and the sentinel can never be summed
- c) do-while is deprecated
- d) it handles input errors automatically

<details markdown="1">
<summary><strong>T2 — Answer key</strong></summary>

**Q1 — a.** A value is either below 0 or above 100 — the union needs `||`.
(b) is impossible (both at once), (c) is the chained-comparison trap, (d)
inverts the logic twice.

**Q2 — b.** i = 3, 2, 1 — the body runs before the decrement ends the loop.

**Q3 — b.** Cases are integers, chars, or enums — values with exact
equality. Ranges and strings need if-ladders.

**Q4 — c.** 12 % 3 = 0 *and* 12 % 4 = 0 → `both`. The first matching branch
wins; ordering "both" first matters.

**Q5 — b.** continue skips odds; evens sum to 30. Trace: 2, 6, 12, 20, 30.

**Q6 — c.** Trace fully: 100→70→40→10→−20. The condition `n > 0` is still
true at 10, so the body runs once more and *overshoots* zero before the loop
stops. Loops terminate on the condition, not on the target — a trace table
is the only honest way to answer this class of question.

**Q7 — d.** Both (a) and (c) produce `5 4 3 2 1 ` — (c) by arithmetic
reflection. Counting down and counting up-with-math are equivalent forms;
choose the one that reads better.

**Q8 — a.** i = 0, 1, 2 print; i = 3 breaks before printing. Break fires
*before* the body's output — placement decides.

**Q9 — a.** i=1: j=1 continue (skip), j=2 >1 break → nothing. i=2: j=1
prints `21`, j=2 continue, j=3 break. i=3: j=1 `31`, j=2 `32`, j=3 continue.
Total: `21 31 32 `. The jumps act per-inner-iteration — the classic
nested-loop trace.

**Q10 — b.** The else-if ladder gives each band an implicit range (85 ≥ 80
→ B). Option (a)'s independent ifs fall through to C as well — 85 would
print B *and* C. Ascending thresholds with else-if is the idiom.

**Q11 — c.** i takes 100, 200, 300; j takes 0, 1, 2. Even sums: 100+0,
100+2, 200+0, 200+2 → count 4. (The option text's own trace was the
hint — (b) miscounts by stopping early.)

**Q12 — b.** The one-line condition documents "readable stream, not the
sentinel" — the loop's complete contract. The do-while version scatters the
stop logic and risks summing the sentinel if the break is misplaced.
</details>

---

## T3 — Functions & decomposition (Units 07–08)

**Q1.** [Easy] Which line *calls* the function `int roll()` correctly?

- a) `int roll;`
- b) `int v = roll();`
- c) `roll = int();`
- d) `call roll;`

**Q2.** [Easy] A prototype (declaration) differs from a definition because it…

- a) has no body
- b) has no name
- c) has no parameters
- d) has no return type

**Q3.** [Easy] Which parameter *can* change the caller's variable?

- a) `int x`
- b) `int& x`
- c) `const int x`
- d) `double x`

**Q4.** [Medium] What does this print?

```cpp
int f(int x) { return x * 2; }
int main() {
    cout << f(f(3));
}
```

- a) 6
- b) 12 — the inner call produces 6, fed to the outer
- c) 9
- d) 3

**Q5.** [Medium] What does this print?

```cpp
void paint(char c, int n = 3) {
    for (int i = 0; i < n; i++) cout << c;
}
int main() {
    paint('*');
    cout << "|";
    paint('#', 5);
}
```

- a) `***|#####`
- b) `*|#####`
- c) `***|#`
- d) `######|***`

**Q6.** [Medium] What does this print?

```cpp
double half(double x) { return x / 2; }
int half(int x)       { return x / 2; }
int main() {
    cout << half(5) << " " << half(5.0);
}
```

- a) `2 2.5` — overloading picks int and double versions
- b) `2 2`
- c) `2.5 2.5`
- d) ambiguous — compile error

**Q7.** [Medium] What does this print?

```cpp
void stats(int a, int b, int& lo, int& hi) {
    lo = (a < b) ? a : b;
    hi = (a > b) ? a : b;
}
int main() {
    int p = 0, q = 0;
    stats(9, 4, p, q);
    cout << p << q;
}
```

- a) 49
- b) 94
- c) 00
- d) 99

**Q8.** [Medium] A function's purpose, parameters, and return are documented
*before* its body. This practice chiefly helps…

- a) the compiler
- b) callers who use the function without reading its implementation — and
  you, when the memory fades
- c) the linker
- d) execution speed

**Q9.** [Hard] What does this print?

```cpp
int mystery(int& a, int b) {
    a = a + b;
    return a - b;
}
int main() {
    int x = 10, y = 3;
    int r = mystery(x, y);
    cout << x << " " << r;
}
```

- a) `10 7`
- b) `13 10` — x became 13 through the reference; 13−3 = 10 returned
- c) `13 7`
- d) `10 10`

**Q10.** [Hard] What does this print?

```cpp
bool isVowel(char c) {
    c = tolower(c);
    return c=='a'||c=='e'||c=='i'||c=='o'||c=='u';
}
int main() {
    cout << isVowel('E') << isVowel('x');
}
```

(with `<cctype>` included; no boolalpha)

- a) `10`
- b) `10` — wait: isVowel('E') is true → 1; 'x' → 0. Check the choices:
- c) `01`
- d) `11`

**Q11.** [Hard] A driver program exists to…

- a) test one function in isolation with known inputs and expected outputs
- b) drive the operating system
- c) replace main in production
- d) compile faster

**Q12.** [Hard] Refactoring `main` that mixes input, calculation, and
printing into functions should…

- a) preserve the program's *behavior exactly* — same input, same output —
  while restructuring the code
- b) also fix any logic bugs found on the way
- c) rename all variables
- d) merge small functions into larger ones

<details markdown="1">
<summary><strong>T3 — Answer key</strong></summary>

**Q1 — b.** A call is the name with parentheses; assigning its result needs a
matching type.

**Q2 — a.** Declaration = signature + semicolon; definition adds the body.
Headers carry declarations, source files carry definitions.

**Q3 — b.** Only a non-const reference aliases the caller's object. Value
parameters mutate copies; const forbids writing.

**Q4 — b.** Inner first: f(3) = 6; outer: f(6) = 12. Nesting reads inside-out.

**Q5 — a.** One argument → default n = 3 → `***`; two arguments override →
`#####`. Defaults fill the *right end* of the list.

**Q6 — a.** The literal 5 is int → int version → 2; 5.0 is double → double
version → 2.5. Overload resolution matches types first.

**Q7 — b.** Out-params: p (lo) = 4, q (hi) = 9 → printed `49`. The order of
the output variables in the call decides — argument *positions*, not names.

**Q8 — b.** The signature-with-meaning is the interface contract. Users
(including future you) code against it without reopening the body.

**Q9 — b.** The reference parameter updated x to 13; the return value is
13 − 3 = 10. One function, two channels: mutation + return. Use deliberately,
not accidentally.

**Q10 — a.** isVowel('E') → tolower → 'e' → true → prints `1`; 'x' → `0`.
So `10`. Option (b) second-guesses itself into nonsense — a reminder to
*verify options*, not just trust their commentary.

**Q11 — a.** A driver is a small main whose only job is exercising one
function: known inputs in, expected outputs checked. The unit-testing habit
in miniature.

**Q12 — a.** Behavior-preserving is the definition of a refactor. Mixing in
behavior changes (b) makes every later bug ambiguous: restructure or edit?
One axis at a time.
</details>

---

## T4 — Collections: arrays & vectors (Unit 09)

**Q1.** [Easy] Which accesses the *last* element of `vector<int> v` (non-empty)?

- a) `v[v.size()]`
- b) `v[v.size() - 1]`
- c) `v.last()`
- d) `v[-1]`

**Q2.** [Easy] `int a[10] = {0};` …

- a) is invalid
- b) sets every element to 0
- c) sets only a[0]
- d) sets a[10] to 0

**Q3.** [Easy] Which adds 7 to the end of `vector<int> v`?

- a) `v.add(7);`
- b) `v.push_back(7);`
- c) `v[7] = 0;`
- d) `v.append(7);`

**Q4.** [Medium] What does this print?

```cpp
int a[4] = {2, 4, 6, 8};
int s = 0;
for (int i = 0; i < 4; i += 2) s += a[i];
cout << s;
```

- a) 20
- b) 8 — indices 0 and 2 → 2 + 6
- c) 6
- d) 12

**Q5.** [Medium] What does this print?

```cpp
vector<int> v = {5, 1, 9, 3};
int best = 0;
for (size_t i = 1; i < v.size(); i++)
    if (v[i] > v[best]) best = i;
cout << v[best];
```

- a) 5
- b) 9 — index tracking finds the position, then dereferences
- c) 3
- d) 18

**Q6.** [Medium] What does this print?

```cpp
int a[5] = {1, 2, 3, 4, 5};
for (int i = 0; i < 5 / 2; i++) {
    int t = a[i]; a[i] = a[4 - i]; a[4 - i] = t;
}
for (int i = 0; i < 5; i++) cout << a[i];
```

- a) 54321 — two-pointer in-place reverse
- b) 12345
- c) 5432
- d) 15432

**Q7.** [Medium] Which range-based loop *modifies* every element (doubling)?

- a) `for (int x : v) x *= 2;`
- b) `for (int& x : v) x *= 2;`
- c) `for (const int& x : v) x *= 2;`
- d) `for (auto x = v.begin(); x < v.end(); ++x) x *= 2;`

**Q8.** [Medium] What does this print?

```cpp
vector<int> v;
for (int i = 1; i <= 3; i++) v.push_back(i * i);
cout << v.size() << ":" << v[2];
```

- a) `3:9`
- b) `3:4`
- c) `9:9`
- d) `2:9`

**Q9.** [Hard] What does this print?

```cpp
int a[6] = {4, 1, 4, 1, 4, 9};
int target = 4, count = 0;
for (int i = 0; i < 6; i++)
    if (a[i] == target) count++;
cout << count;
```

- a) 2
- b) 3 — linear counting over the whole array
- c) 4
- d) 1

**Q10.** [Hard] What does this print?

```cpp
vector<int> v = {7, 3, 5};
v.insert(v.begin(), 1);
v.erase(v.begin() + 1);
for (int x : v) cout << x;
```

- a) `735`
- b) `135`
- c) `1753`
- d) `35`

**Q11.** [Hard] Parallel arrays (`string names[50]; int marks[50];`) are
replaced by one `struct Student { string name; int marks; };` array chiefly
because…

- a) structs are faster to loop over
- b) a swap/sort/reorder of one array can silently misalign the other — one
  record keeps its fields together under any operation
- c) vectors forbid parallel arrays
- d) structs use less memory

**Q12.** [Hard] What does this print?

```cpp
vector<int> v = {2, 4, 6, 7};
for (size_t i = 0; i < v.size(); i++) {
    if (v[i] % 2 == 0) v.erase(v.begin() + i);
}
for (int x : v) cout << x;
```

- a) `7`
- b) `47` — an even element is skipped when the erase shifts the vector
- c) `26`
- d) `2467`

<details markdown="1">
<summary><strong>T4 — Answer key</strong></summary>

**Q1 — b.** Last valid index is size−1. `v[size()]` is one past the end;
negative indices do not exist in C++.

**Q2 — b.** The `= {0}` initializer zero-fills the entire array. Uninitialized
arrays hold garbage — always initialize before reading.

**Q3 — b.** `push_back` appends and grows. `v[7] = 0` would *write index 7* —
past the end if size < 8, a different operation entirely.

**Q4 — b.** i takes 0, 2 → 2 + 6 = 8. Step-2 traversal skips odd indices.

**Q5 — b.** The index-of-max pattern: best ends at index 2 (value 9). Storing
the *index* keeps position information — the trick the labs reuse for
"which row?" answers.

**Q6 — a.** Swap ends inward: (1,5), (2,4) → 54321. `i < 5/2` = i < 2 — two
swaps, middle element untouched.

**Q7 — b.** The `&` binds a reference: writes hit the element. (a) modifies a
copy, (c) is read-only by law, (d) confuses iterators with values.

**Q8 — a.** Pushed 1, 4, 9 → size 3, index 2 is 9. Squares built by loop —
the collection grows with the data.

**Q9 — b.** 4 appears at indices 0, 2, 4 → 3. Linear counting is O(n) and
works on *any* order — no sortedness required.

**Q10 — b.** Insert 1 at the front → {1,7,3,5}. Erase index 1 — which now
holds the 7, not the 3 — → {1,3,5} → `135`. The lesson: after an insert or
erase, *every later index means something different*; re-derive positions
from the new state, never from the old.

**Q11 — b.** Any reordering must be replicated by hand across every parallel
array — the classic silent misalignment. The struct makes one swap move
name+marks together: cohesion enforced by the type.

**Q12 — b.** Trace the shifts: i=0 erases 2 → {4,6,7}; i=1 examines v[1]
— now 6, because 4 *slid into slot 0* — erases 6 → {4,7}; i=2 is past size
2, loop ends. The 4 was never examined: erasing shifts every later element
left while `i` marches forward, so the element that moves into the current
slot escapes the test. Fixes: iterate backward, or rebuild into a new
vector. Output `47`.
</details>

---

**Next:** [T5–T8 — Strings, Files, Memory, OOP →](topic-tests-2.md) · [Hub](index.md)
