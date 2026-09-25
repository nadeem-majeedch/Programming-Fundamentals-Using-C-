---
title: "Weekly Quizzes W09–W12 — Collections, Algorithms, Strings, Files"
description: "Weeks 9–12: arrays & vectors, searching & sorting, strings, file I/O — 10 questions each with hidden answer keys."
---

# Weekly Quizzes — W09 to W12

> 10 questions each · ~15 min each · attempt ALL ten before opening the key ·
> [← W05–W08](weeklies-2.md) · [Hub](index.md) · [W13–W16 →](weeklies-4.md)

---

## W09 — Arrays & vectors (Week 9)

**Q1.** [Easy] `int a[5];` creates…

- a) five ints named a0…a4
- b) one array of five ints, indices 0–4
- c) an array of six ints, indices 0–5
- d) a resizable list

**Q2.** [Easy] The first element of `int a[4]` is…

- a) `a[1]`
- b) `a[0]`
- c) `a[4]`
- d) `a`

**Q3.** [Easy] Which is true about `vector<int>` compared to a C array?

- a) it cannot hold ints
- b) it can grow at runtime and remembers its own size
- c) it is always slower and larger
- d) it has no indices

**Q4.** [Medium] What does this print?

```cpp
int a[3] = {10, 20, 30};
cout << a[1] + a[2];
```

- a) 30
- b) 50
- c) 60
- d) an error

**Q5.** [Medium] What happens with `int a[3]; cout << a[3];`?

- a) prints 0
- b) out-of-bounds access — undefined behavior (no runtime check)
- c) compile error
- d) prints the size

**Q6.** [Medium] What does this print?

```cpp
vector<int> v;
v.push_back(4);
v.push_back(9);
cout << v.size() << " " << v[0];
```

- a) `2 4`
- b) `2 9`
- c) `1 4`
- d) `0 4`

**Q7.** [Medium] Which range-based loop prints every element of
`vector<int> v`?

- a) `for (int x : v) cout << x;`
- b) `for (v : int x) cout << x;`
- c) `for (int i : 0..v.size()) cout << v[i];`
- d) `foreach (x in v) cout << x;`

**Q8.** [Medium] What does this print?

```cpp
int a[4] = {5, 2, 8, 1};
int m = a[0];
for (int i = 1; i < 4; i++)
    if (a[i] > m) m = a[i];
cout << m;
```

- a) 1
- b) 5
- c) 8
- d) 16

**Q9.** [Hard] What does this print?

```cpp
vector<int> v = {1, 2, 3};
for (int i = 0; i <= v.size(); i++)
    cout << v[i] << " ";
```

- a) `1 2 3`
- b) `1 2 3` then one garbage/out-of-bounds value — the classic `<=` bug
- c) a compile error
- d) nothing

**Q10.** [Hard] Why do functions receiving C arrays also receive the length —
`void f(int a[], int n)`?

- a) style only
- b) the array parameter decays to a pointer; the function cannot know its size
- c) arrays are copied without their metadata
- d) C++ requires n as a reserved keyword

<details markdown="1">
<summary><strong>W09 — Answer key</strong></summary>

**Q1 — b.** One object, five same-type elements, indexed 0–4. Declaration
size is fixed forever — hence `vector` later.

**Q2 — b.** Array indices start at 0; the last of four is `a[3]`.

**Q3 — b.** `vector` manages its own dynamic storage — `push_back` grows it,
`size()` reports it. That management is exactly what C arrays lack.

**Q4 — b.** `a[1]` is 20, `a[2]` is 30 → 50. Index arithmetic before anything
else.

**Q5 — b.** `a[3]` is past the end. C++ performs no bounds checking on raw
arrays — the access compiles and misbehaves at runtime. This is the module's
central safety lesson.

**Q6 — a.** Two `push_back`s → size 2; `v[0]` is the first pushed value, 4.

**Q7 — a.** `for (int x : v)` binds x to each element in turn. The syntax in
(b) and (c) does not exist; (d) is another language.

**Q8 — c.** Seed-from-first max scan → 8. The same three-line pattern will
become `max_element` in the STL module.

**Q9 — b.** `i <= v.size()` touches `v[3]` — one past the last valid index
(2). Range-for exists precisely so this off-by-one cannot be written.

**Q10 — b.** Arrays decay to a pointer to their first element when passed;
the size is *not* part of what arrives. Hence the length parameter — the
pointer-plus-count convention used across all C-family APIs.
</details>

---

## W10 — Searching & sorting (Week 10)

**Q1.** [Easy] Linear search on n elements examines, worst case,…

- a) about half the elements
- b) all n elements
- c) log₂ n elements
- d) one element

**Q2.** [Easy] Binary search's essential precondition is…

- a) the array is small
- b) the array is sorted
- c) the array holds ints
- d) the array is in a file

**Q3.** [Easy] Which sort repeatedly swaps adjacent out-of-order pairs?

- a) selection sort
- b) bubble sort
- c) insertion sort
- d) binary search

**Q4.** [Medium] Binary search on a sorted array of 16 elements examines at
most…

- a) 16
- b) 8
- c) 5 (⌈log₂ 16⌉ + 1 = 5 probes)
- d) 1

**Q5.** [Medium] Searching for 7 in `[2, 5, 8, 12, 16]`, binary search first
compares 7 against…

- a) 2
- b) 5
- c) 8 (the middle element)
- d) 16

**Q6.** [Medium] One pass of selection sort on `[4, 1, 3, 2]` (ascending,
select-min) produces…

- a) `[1, 4, 3, 2]` — the minimum swapped into position 0
- b) `[1, 2, 3, 4]` — fully sorted in one pass
- c) `[4, 1, 3, 2]` — one pass changes nothing
- d) `[2, 1, 3, 4]`

**Q7.** [Medium] What does this linear search return for key 9?

```cpp
int a[5] = {3, 9, 1, 9, 4};
int pos = -1;
for (int i = 0; i < 5; i++)
    if (a[i] == key) { pos = i; break; }
```

- a) 3 — the last match
- b) 1 — the first match, thanks to the break
- c) 9
- d) −1

**Q8.** [Medium] Bubble sort's early-exit optimization stops when…

- a) the array is half sorted
- b) a full pass completes with zero swaps
- c) the first element is the smallest
- d) the counter overflows

**Q9.** [Hard] What does this binary search print?

```cpp
int a[5] = {2, 5, 8, 12, 16};
int lo = 0, hi = 4, key = 10;
while (lo <= hi) {
    int mid = (lo + hi) / 2;
    if (a[mid] == key) { cout << "at " << mid; return 0; }
    if (key < a[mid]) hi = mid - 1; else lo = mid + 1;
}
cout << "missing";
```

- a) `at 3`
- b) `missing` — 10 is not present
- c) `at 4`
- d) infinite loop

**Q10.** [Hard] Sorting student records by marks descending, then name
ascending on ties, needs…

- a) two separate sorts, one after the other, on separate arrays
- b) a composite comparison: marks first, name as tie-breaker — on the records
  themselves, so swaps keep fields together
- c) sorting only the marks array
- d) binary search

<details markdown="1">
<summary><strong>W10 — Answer key</strong></summary>

**Q1 — b.** Linear search stops early only when lucky; the worst case (absent
key) examines all n. That linearity is its defining cost.

**Q2 — b.** Halving the search space is only valid if the middle comparison
tells you which half to discard — which requires order. Unsorted input makes
binary search silently wrong.

**Q3 — b.** Bubble sort's pass compares neighbors and swaps inversions,
bubbling the largest to the end each pass.

**Q4 — c.** Each probe halves the space: 16→8→4→2→1 — at most 5 probes. The
logarithm in action; 1,000,000 elements need ≤ 20.

**Q5 — c.** lo=0, hi=4 → mid=2 → a[2]=8. The first comparison is always
against the middle; 7 < 8 discards the right half immediately.

**Q6 — a.** Pass 1 selects the minimum (1) and swaps it with position 0. One
pass fixes one position — that is selection's contract.

**Q7 — b.** The break returns the *first* match. Without the break, pos would
end at 3 — the last. Sentinel-initialized to −1 means "absent."

**Q8 — b.** Zero swaps in a pass means every adjacent pair is ordered — proof
of sortedness. This is bubble's one adaptive virtue.

**Q9 — b.** Trace: mid=2 (8<10→lo=3), mid=3 (12>10→hi=2), lo>hi → exit →
`missing`. The loop terminates because the window shrinks every pass.

**Q10 — b.** Composite comparisons — primary key, tie-breaker — on records:
one swap moves all fields together. Sorting parallel arrays separately destroys
the record alignment.
</details>

---

## W11 — Strings & text processing (Week 11)

**Q1.** [Easy] Which reads a full line including spaces?

- a) `cin >> s;`
- b) `getline(cin, s);`
- c) `cin.get(s);`
- d) `s.read();`

**Q2.** [Easy] For `string s = "Hello";`, `s.size()` is…

- a) 4
- b) 5
- c) 6
- d) 0

**Q3.** [Easy] `s[0]` for `s = "Hello"` is…

- a) `'H'`
- b) `"H"`
- c) `'e'`
- d) `0`

**Q4.** [Medium] What does this print?

```cpp
string a = "data", b = "base";
cout << a + b;
```

- a) `data base`
- b) `database`
- c) `datab`
- d) an error

**Q5.** [Medium] What does this print?

```cpp
string s = "banana";
cout << s.substr(1, 3);
```

- a) `ana`
- b) `ban`
- c) `nan`
- d) `ana` — hmm, check: index 1, length 3 → characters at 1, 2, 3

**Q6.** [Medium] Comparing strings with `==` compares…

- a) their addresses
- b) their contents, character by character
- c) their lengths only
- d) their first characters only

**Q7.** [Medium] What does this print?

```cpp
string s = "hello";
s[0] = 'H';
cout << s;
```

- a) `hello`
- b) `Hello` — strings are mutable, index writes allowed
- c) an error
- d) `H`

**Q8.** [Medium] Which counts vowels in `s` (lowercase input)?

- a) loop with `if (s[i] == 'a' || 'e' || ...)` — this is the trap
- b) loop with `if (s[i]=='a'||s[i]=='e'||s[i]=='i'||s[i]=='o'||s[i]=='u')`
- c) `s.count("aeiou")`
- d) `vowel(s)`

**Q9.** [Hard] What does this print?

```cpp
string s = "abc";
for (size_t i = 0; i < s.size(); i++)
    cout << (char)toupper(s[i]);
cout << "|" << s;
```

- a) `ABC|abc` — toupper built output without touching s
- b) `ABC|ABC` — s was modified
- c) `abc|ABC`
- d) `ABC|`

**Q10.** [Hard] After `int n; cin >> n; getline(cin, line);` with input `42`
then `hello world`, `line` is…

- a) `hello world`
- b) `""` — the getline consumed the newline left by `>>`
- c) `42`
- d) undefined

<details markdown="1">
<summary><strong>W11 — Answer key</strong></summary>

**Q1 — b.** `getline` reads to the newline and consumes it. `>>` stops at the
first space.

**Q2 — b.** Five characters. `size()` returns the count; the last valid index
is 4.

**Q3 — a.** Indexing yields a `char` — single quotes in the answer, and the
first index is 0.

**Q4 — b.** `+` concatenates: no space is inserted unless you write one.

**Q5 — a.** `substr(1, 3)` = 3 characters starting at index 1: a, n, a. The
second argument is a *length*, not an end index — the standard confusion.

**Q6 — b.** `std::string`'s `==` is value equality — the content. (C-style
`char*` comparison compares pointers — a Week-11 contrast.)

**Q7 — b.** `std::string` is mutable: writing `s[0]` replaces the character.

**Q8 — b.** Each comparison must name `s[i]`. Option (a) parses as
`(s[i] == 'a') || 'e' || ...` — `'e'` is truthy, so *every* character "counts."
The most reused bug in student text-processing code.

**Q9 — a.** `toupper(s[i])` returns a transformed value; unless it is assigned
back, `s` is untouched. Transform-to-output vs modify-in-place are different
programs.

**Q10 — b.** The mixing trap, third appearance: `>>` leaves the newline,
`getline` is satisfied by it instantly. One `cin.ignore()` between them fixes
it — now by reflex, one hopes.
</details>

---

## W12 — File I/O (Week 12)

**Q1.** [Easy] Which opens a file for *reading*?

- a) `ofstream in("f.txt");`
- b) `ifstream in("f.txt");`
- c) `fstream out("f.txt");`
- d) `open(f.txt);`

**Q2.** [Easy] `ofstream out("log.txt", ios::app);` means…

- a) create empty, discard old contents
- b) append: new writes land after the existing content
- c) read the log
- d) binary mode

**Q3.** [Easy] After opening a file, the first thing to check is…

- a) its size
- b) whether the open succeeded — `if (!in) ...`
- c) the last line
- d) nothing; opens always succeed

**Q4.** [Medium] The read loop `while (in >> x) { ... }` stops when…

- a) x is 0
- b) the stream fails — end of data or bad content
- c) x is negative
- d) 100 iterations pass

**Q5.** [Medium] What does `getline(in, line)` return as a loop condition?

- a) the line read
- b) the stream — true until failure (e.g. end of file)
- c) the line's length
- d) always true

**Q6.** [Medium] Writing with `out << 42 << "\n";` produces…

- a) the characters `42` followed by a newline — text formatting just like cout
- b) the binary number 42
- c) nothing until close
- d) an error without flush

**Q7.** [Medium] `marks.txt` holds `Ayesha 88\nBilal 72\n`. What does this print?

```cpp
ifstream in("marks.txt");
string name; int m;
while (in >> name >> m)
    cout << name << "-" << m << " ";
```

- a) `Ayesha-88 Bilal-72 `
- b) `Ayesha Bilal `
- c) `88 72 `
- d) nothing — `>>` cannot read lines

**Q8.** [Medium] A program should read `scores.txt`, compute the average, then
*overwrite* the file with the average. The safe sequence is…

- a) open for read and write simultaneously and interleave
- b) read fully (compute), close, reopen with `ofstream` (truncating) and write
- c) append the average to avoid loss
- d) it is impossible

**Q9.** [Hard] `ifstream in("ghost.txt"); if (!in) { ... }` — the check exists
because…

- a) opening a missing file throws an exception by default
- b) a failed open leaves the stream in a fail state; reads do nothing and the
  program would silently "succeed" with empty data
- c) the compiler detects missing files
- d) Windows requires it

**Q10.** [Hard] A CSV line `Ali Raza,88` is read with `getline(in, line)`.
Extracting the marks requires…

- a) `in >> marks` — it will skip to the number
- b) splitting on the comma: `find(',')` + `substr` + `stoi` — because the
  name contains a space, `>>`-based splitting is unsafe
- c) `atoi(line)`
- d) binary mode

<details markdown="1">
<summary><strong>W12 — Answer key</strong></summary>

**Q1 — b.** `ifstream` = input file stream (reading); `ofstream` = output
(writing). The names are the mnemonic.

**Q2 — b.** `ios::app` positions every write at the end, preserving prior
content. Plain `ofstream out("f")` truncates — the data-loss footgun.

**Q3 — b.** Stream state after construction tells you whether the open
worked. The missing-file program that "runs" is the silent failure this check
prevents.

**Q4 — b.** The extraction operator converts into a boolean: success. Failure
— EOF or garbage — ends the loop. Read-until-fail is the file twin of the
sentinel loop.

**Q5 — b.** `getline` returns the stream reference; in a condition it converts
to success/failure. The line itself arrives in the second argument.

**Q6 — a.** Output streams format values to text exactly as `cout` does —
the same operators, different destination.

**Q7 — a.** `>>` skips whitespace including newlines, so name/marks pairs
read across line boundaries until the data ends.

**Q8 — b.** Read-then-close-then-rewrite: one mode at a time, with the data
safely in memory before the destructive truncating open. Interleaved
read/write on the same stream is an advanced, error-prone pattern.

**Q9 — b.** C++ streams fail quietly. The `if (!in)` guard converts "no file"
from silent-empty into an explicit, handled event.

**Q10 — b.** Fields with spaces force line-grain reading and explicit
splitting. `stoi` converts the marks substring; finding *one* comma when names
contain commas is the stated extension (hint: `rfind`).
</details>

---

**Next:** [W13–W16 — Memory, OOP, capstone →](weeklies-4.md) · [Hub](index.md)
