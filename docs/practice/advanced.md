---
title: "Practice Bank — Advanced Tier (40 problems)"
description: "A-01…A-40: pointers, files, recursion, searching and sorting, and class design — each with statement, topics, I/O, constraints, samples, graded hints, reference solution, and explanation."
---

# Advanced tier — A-01 to A-40

> **Units first:** [Stage D — Algorithms & data](../syllabus.md#stage-d-algorithms-and-data-units-10-12) and [Stage E — Memory & objects](../syllabus.md#stage-e-memory-and-objects-units-13-15) (files, pointers, algorithms, class fundamentals).
> **Attempt protocol:** unchanged — and now every solution should say *what it owns and what it only borrows*.

## Part 1 — Pointers (A-01…A-10)

### A-01 — First pointer: address bookkeeping

**Difficulty:** ★★ · **Topics:** pointers, address-of, dereference

Read an integer n. Print its value, its address (via a pointer), and the value the pointer dereferences to — three lines, labeled.

**Input:** one integer.
**Output:** `value: V` / `addr: 0x...` (address varies) / `via ptr: V`.
**Hints:** ① `int* p = &n;` then `*p` and `p` are three different things.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    int* p = &n;
    cout << "value: "   << n   << "\n";
    cout << "addr: "    << p   << "\n";   // addresses vary run to run
    cout << "via ptr: " << *p  << "\n";
    return 0;
}
```

**Explanation:** the three-way identity — n, &n, *p — in one output. The address line differing across runs is itself the lesson: addresses are runtime facts, not program constants. *Distinct idea:* value, address, and dereference as distinct outputs.

---

### A-02 — Swap through pointers

**Difficulty:** ★★ · **Topics:** pointers, dereference, out-parameters

Write `void swapPtr(int* a, int* b)` that swaps using dereference only. Read two integers, print them, swap via the function, print again.

**Input:** two integers.
**Output:** the pair before and after.
**Sample tests:** `3 8` → `3 8` then `8 3`
**Hints:** ① inside the function, `*a` *is* the caller's variable; ② temp holds `*a`, not `a`.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void swapPtr(int* a, int* b) {
    int t = *a;
    *a = *b;
    *b = t;
}

int main() {
    int x, y;
    cin >> x >> y;
    cout << x << " " << y << "\n";
    swapPtr(&x, &y);
    cout << x << " " << y << "\n";
    return 0;
}
```

**Explanation:** the pointer-parameter shape (`&x` at the call, `*a` inside) versus Ba-35's reference shape — same effect, two syntaxes. Reading legacy C-style code is why both belong in your hands. *Distinct idea:* mutation through dereference.

---

### A-03 — Pointer walk over an array

**Difficulty:** ★★ · **Topics:** pointers, arrays, traversal

Read n (1–20) then n integers. Sum the array **using only a pointer** — `int* p = a;` advanced with `p++` — no `a[i]` subscripting anywhere.

**Input:** n, then n integers.
**Output:** `sum: S`.
**Sample tests:** `4 5 10 15 20` → `sum: 50`
**Hints:** ① the array name decays to `&a[0]`; ② `p++` advances by *one element*, not one byte.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[20];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    long long sum = 0;
    for (int* p = a; p < a + n; p++) sum += *p;
    cout << "sum: " << sum << "\n";
    return 0;
}
```

**Explanation:** the pointer-walk loop `for (int* p = a; p < a + n; p++)` is subscripting's underlying reality — and `a + n` (one past the last element) is legal to *compare* against, illegal to *dereference*. Both facts in one loop. *Distinct idea:* iteration as address arithmetic.

---

### A-04 — min/max via reference out-params (pointer style)

**Difficulty:** ★★ · **Topics:** pointers, references, multiple outputs

Write `void minMax(int* a, int n, int& mn, int& mx)` filling both out-params in one pass. Read n then n values; print `min: m max: M`.

**Input:** n (1–100), then n integers.
**Output:** one line.
**Sample tests:** `5 8 3 9 1 4` → `min: 1 max: 9`
**Hints:** ① mixed signature: pointer for the array (decay), references for outputs; ② seed from a[0].
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void minMax(int* a, int n, int& mn, int& mx) {
    mn = mx = a[0];
    for (int i = 1; i < n; i++) {
        if (a[i] < mn) mn = a[i];
        if (a[i] > mx) mx = a[i];
    }
}

int main() {
    int n, a[100], mn, mx;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    minMax(a, n, mn, mx);
    cout << "min: " << mn << " max: " << mx << "\n";
    return 0;
}
```

**Explanation:** the honest mixed signature — arrays decay so `int*` documents reality; references (not pointers) for outputs because they can never be null and read cleanly. Choosing each tool *for its reason* is the lesson. *Distinct idea:* pointer-in, reference-out idiom.

---

### A-05 — Dynamic array sized at runtime

**Difficulty:** ★★★ · **Topics:** pointers, new/delete, dynamic arrays

Read n (1–100000 — too big for a fixed guess), then n integers. Allocate an exact-size dynamic array with `new`, compute the sum, `delete[]` it, and print the sum.

**Input:** n, then n integers (−10⁹…10⁹).
**Output:** `sum: S`.
**Sample tests:** `3 1000000000 1000000000 1000000000` → `sum: 3000000000`
**Hints:** ① `int* a = new int[n];` … `delete[] a;` — the bracket form pairs with `new[]`.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n;
    cin >> n;
    int* a = new int[n];
    long long sum = 0;
    for (long long i = 0; i < n; i++) { cin >> a[i]; sum += a[i]; }
    delete[] a;
    cout << "sum: " << sum << "\n";
    return 0;
}
```

**Explanation:** runtime sizing is the *point* of dynamic allocation — `int a[100000]` on the stack is often fatal, while `new int[n]` asks the heap for exactly n. The `delete[]` pairing is the ownership contract; the modern-cpp module later replaces this pair with `unique_ptr`/`vector`. *Distinct idea:* allocation matched to actual need.

---

### A-06 — The leak hunt (find and fix)

**Difficulty:** ★★★ · **Topics:** pointers, memory leaks, ownership

This program compiles and "works" — but leaks. Explain where, then fix it:

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    for (int trial = 0; trial < 3; trial++) {
        int* data = new int[n];
        for (int i = 0; i < n; i++) cin >> data[i];
        long long s = 0;
        for (int i = 0; i < n; i++) s += data[i];
        cout << "trial " << trial << " sum: " << s << "\n";
    }
    return 0;
}
```

**Input:** n, then 3×n integers.
**Output:** three trial sums.
**Sample tests:** n=2, values `1 2 3 4 5 6` → `trial 0 sum: 3` / `trial 1 sum: 7` / `trial 2 sum: 11`
**Hints:** ① count the `new`s versus the `delete[]`s; ② each loop pass abandons one allocation.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n;
    cin >> n;
    for (int trial = 0; trial < 3; trial++) {
        int* data = new int[n];
        long long s = 0;
        for (long long i = 0; i < n; i++) { cin >> data[i]; s += data[i]; }
        cout << "trial " << trial << " sum: " << s << "\n";
        delete[] data;                  // the fix: every new[] gets its delete[]
    }
    return 0;
}
```

**Explanation:** three allocations, zero releases — each pass overwrites the pointer, orphaning the previous block forever. The fix is one line, but the *habit* is the deliverable: every `new[]` is paired with a `delete[]` on every path, including early returns. *Distinct idea:* leaks as orphaned ownership.

---

### A-07 — Dangling pointer demonstration

**Difficulty:** ★★★ · **Topics:** pointers, dangling, scope

Predict, then run, then explain in comments:

```cpp
#include <iostream>
using namespace std;

int* makeValue() {
    int v = 42;
    return &v;          // BUG
}

int main() {
    int* p = makeValue();
    cout << *p << "\n";   // line A — what prints, and why is this not "safe"?
}
```

**Input:** none.
**Output:** line A may print 42 — *by luck*.
**Hints:** ① v's lifetime ends at makeValue's closing brace; ② "it printed 42" ≠ "it is correct".
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int* makeValue() {
    int v = 42;
    return &v;   // dangling: v dies here; the returned address points at a corpse.
                 // It often *prints* 42 because the stack slot hasn't been reused
                 // yet — luck, not correctness. Changing the function slightly
                 // (a cout, another call) can change or corrupt the value.
}

int main() {
    int* p = makeValue();
    cout << *p << "\n";
    return 0;
}
// Fixes: return the value (int, not int*), or make v static (last resort),
// or allocate with new (ownership transferred — caller must delete).
```

**Explanation:** the dangling-return trap demonstrated honestly — including why the demo *seems* to work. Undefined behavior's silence is what makes it dangerous; the comments carry the engineering conclusion. *Distinct idea:* lifetime outliving the pointer.

---

### A-08 — Pointer to const vs const pointer

**Difficulty:** ★★★ · **Topics:** pointers, const, read-only access

Given this code, predict which lines compile and which fail (then verify):

```cpp
int x = 10, y = 20;
const int* p1 = &x;    // pointer to const
int* const p2 = &x;    // const pointer
const int* const p3 = &x;
```

Candidates: `*p1 = 5;` · `p1 = &y;` · `*p2 = 5;` · `p2 = &y;` · `*p3 = 5;` · `p3 = &y;`

**Input:** none — a compile-experiment.
**Output:** a written verdict per line, then the corrected understanding in comments.
**Hints:** ① read right-to-left: `const int* p1` — p1 points at a const int; `int* const p2` — p2 is a const pointer.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int x = 10, y = 20;
    const int* p1 = &x;         // *p1 read-only; p1 movable
    int* const p2 = &x;         // *p2 writable; p2 frozen at &x
    const int* const p3 = &x;   // both frozen

    // *p1 = 5;   // NO — the pointed-to int is const through p1
    p1 = &y;      // OK — the pointer itself moves
    *p2 = 5;      // OK — x becomes 5
    // p2 = &y;   // NO — p2 cannot be reseated
    // *p3 = 5;   // NO
    // p3 = &y;   // NO

    cout << x << " " << *p1 << " " << *p2 << " " << *p3 << "\n";
    return 0;
}
```

**Explanation:** const binds to its *left* (or to the type if nothing is left of it) — that one reading rule resolves all six lines. The passing pattern in APIs: read-only views as `const T*`, writable views as `T*`, and `T* const` is rare outside "this pointer never moves" declarations. *Distinct idea:* const as a position-dependent promise.

---

### A-09 — Array of values vs array of pointers

**Difficulty:** ★★★ · **Topics:** pointers, arrays, indirection

Read 5 integers. Store them in `int vals[5]`. Then build `int* ptrs[5]` where `ptrs[i] = &vals[order[i]]` — read 5 indices (0–4, a permutation) and print the values in the order the *pointers* dictate, then prove the originals are unchanged by printing vals again.

**Input:** 5 integers, then a permutation of 0–4.
**Output:** permuted line, then the original line.
**Sample tests:** vals `10 20 30 40 50`, perm `3 0 4 1 2` → `40 10 50 20 30` then `10 20 30 40 50`
**Hints:** ① the permutation reorders *views*, not data; ② `*ptrs[i]` reads through the view.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int vals[5], order[5];
    int* ptrs[5];
    for (int i = 0; i < 5; i++) cin >> vals[i];
    for (int i = 0; i < 5; i++) cin >> order[i];
    for (int i = 0; i < 5; i++) ptrs[i] = &vals[order[i]];
    for (int i = 0; i < 5; i++) cout << *ptrs[i] << " \n"[i == 4];
    for (int i = 0; i < 5; i++) cout << vals[i]  << " \n"[i == 4];
    return 0;
}
```

**Explanation:** data and views are separate layers — the pointer array is a re-orderable *index into* the data without touching it. This is the indirection that sorting-without-moving (sort an array of pointers to heavy records) exploits, and the course's contact-book "views vs storage" lab scales it up. *Distinct idea:* indirection as a reordering layer.

---

### A-10 — Two-dimensional dynamic grid

**Difficulty:** ★★★ · **Topics:** pointers, new/delete, dynamic matrices

Read r and c (1–50 each), then r×c integers. Allocate a dynamic r×c grid (array of row pointers), fill it, print each row's sum, then free **all** memory in the correct order.

**Input:** r, c, then the grid.
**Output:** `row i: S` lines.
**Hints:** ① `int** g = new int*[r];` then per-row `g[i] = new int[c];`; ② free rows first, then the row-pointer array.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int r, c;
    cin >> r >> c;
    int** g = new int*[r];
    for (int i = 0; i < r; i++) g[i] = new int[c];
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            cin >> g[i][j];
    for (int i = 0; i < r; i++) {
        long long s = 0;
        for (int j = 0; j < c; j++) s += g[i][j];
        cout << "row " << i << ": " << s << "\n";
    }
    for (int i = 0; i < r; i++) delete[] g[i];   // rows first
    delete[] g;                                   // then the row table
    return 0;
}
```

**Explanation:** the pointer-to-pointer grid — allocation and release in reverse order of creation — is the manual shape that `vector<vector<int>>` automates. Freeing the table before the rows would strand them: the order *is* the ownership graph. *Distinct idea:* layered allocation, layered release.

---

## Part 2 — Files (A-11…A-18)

### A-11 — Write, then read back

**Difficulty:** ★★ · **Topics:** files, ofstream, ifstream

Write the integers 1–10 (one per line) to `nums.txt` with an `ofstream`, close it, then read the file back with an `ifstream` and print their sum.

**Input:** none.
**Output:** `sum: 55`.
**Hints:** ① close before reopening for read — or use two streams; ② check the open succeeded.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
using namespace std;
int main() {
    ofstream out("nums.txt");
    if (!out) { cout << "write failed\n"; return 1; }
    for (int i = 1; i <= 10; i++) out << i << "\n";
    out.close();

    ifstream in("nums.txt");
    if (!in) { cout << "read failed\n"; return 1; }
    long long sum = 0, x;
    while (in >> x) sum += x;
    cout << "sum: " << sum << "\n";
    return 0;
}
```

**Explanation:** the full write-close-read cycle with open checks on both streams — the while `(in >> x)` read-until-fail loop is the file counterpart of Ba-01's sentinel reading. *Distinct idea:* files as program-to-program memory.

---

### A-12 — Line-based copy with numbering

**Difficulty:** ★★ · **Topics:** files, getline, line processing

Read `in.txt` (create it with a few lines first, or assume it exists) and write to `out.txt` each line prefixed with its 1-based number: `N: line`.

**Input:** an existing `in.txt`.
**Output:** the numbered `out.txt`; also echo the line count to the screen.
**Hints:** ① `while (getline(in, line))`; ② the counter lives outside the loop.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;
int main() {
    ifstream in("in.txt");
    if (!in) { cout << "no in.txt\n"; return 1; }
    ofstream out("out.txt");
    if (!out) { cout << "cannot write\n"; return 1; }
    string line;
    int n = 0;
    while (getline(in, line)) {
        n++;
        out << n << ": " << line << "\n";
    }
    cout << "lines: " << n << "\n";
    return 0;
}
```

**Explanation:** getline-driven line processing preserves content `>>` would split — the same whitespace trade-off as the I/O module, now crossing a file boundary. *Distinct idea:* line-grain vs token-grain file reading.

---

### A-13 — CSV marks file to report

**Difficulty:** ★★★ · **Topics:** files, CSV, records

`marks.txt` holds lines `name,marks` (name has no commas). Read it, print each line as `name -> marks`, and the class average (two decimals) at the end.

**Input:** a `marks.txt` with 1–50 valid lines.
**Output:** per-line reports then `avg: X`.
**Sample tests:** file `Ayesha,88` `Bilal,72` → `Ayesha -> 88` / `Bilal -> 72` / `avg: 80.00`
**Hints:** ① read whole lines, split on the comma (I-24's tool); ② count lines for the average.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>
using namespace std;
int main() {
    ifstream in("marks.txt");
    if (!in) { cout << "no marks.txt\n"; return 1; }
    string line;
    long long total = 0;
    int count = 0;
    while (getline(in, line)) {
        size_t comma = line.find(',');
        if (comma == string::npos) continue;      // tolerate blank/garbage lines
        string name  = line.substr(0, comma);
        int marks = stoi(line.substr(comma + 1));
        cout << name << " -> " << marks << "\n";
        total += marks;
        count++;
    }
    if (count > 0)
        cout << fixed << setprecision(2) << "avg: " << (double)total / count << "\n";
    return 0;
}
```

**Explanation:** CSV as the simplest file format — split, convert, aggregate — with a defensive `continue` for malformed lines. The file-handling labs' record files are this pattern with more columns. *Distinct idea:* file lines as records.

---

### A-14 — Append mode log

**Difficulty:** ★★ · **Topics:** files, append, ios::app

Each program run should add one line `run <n>` to `log.txt`, where n is 1 more than the number of existing lines. Print the new line count.

**Input:** none.
**Output:** `logged as run N`.
**Hints:** ① count existing lines first (read pass), then reopen with `ios::app`; ② appends never disturb earlier lines.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;
int main() {
    ifstream in("log.txt");
    int existing = 0;
    if (in) {
        string line;
        while (getline(in, line)) existing++;
        in.close();
    }  // missing file is fine: existing stays 0
    ofstream out("log.txt", ios::app);
    out << "run " << existing + 1 << "\n";
    cout << "logged as run " << existing + 1 << "\n";
    return 0;
}
```

**Explanation:** the read-then-append cycle builds state *across runs* — a file as persistent memory. The `if (in)` tolerance of a first-run missing file is the boundary case every log keeps. *Distinct idea:* persistence across executions.

---

### A-15 — File word/line/char census

**Difficulty:** ★★ · **Topics:** files, getline, counting

Read `text.txt`; print `lines: L words: W chars: C` — chars including spaces and newlines, words as whitespace-separated tokens.

**Input:** an existing `text.txt`.
**Output:** the census line.
**Sample tests:** a file containing `hello world\nbye\n` → `lines: 2 words: 3 chars: 17` (h-e-l-l-o-space-w-o-r-l-d = 11 + newline = 12; b-y-e = 3 + newline = 4; total 17? No: 11+1+3+1 = 16 — recount: `hello world` is 11 chars + `\n` = 12, `bye` is 3 + `\n` = 4 → 16. The sample asserts 16.)
**Hints:** ① getline for lines; ② a word-start scan (Ba-39's rule) per line; ③ chars = line.size() + 1 per line (the newline).
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;
int main() {
    ifstream in("text.txt");
    if (!in) { cout << "no text.txt\n"; return 1; }
    long long lines = 0, words = 0, chars = 0;
    string line;
    while (getline(in, line)) {
        lines++;
        chars += line.size() + 1;             // +1 for the newline
        for (size_t i = 0; i < line.size(); i++)
            if (line[i] != ' ' && (i == 0 || line[i-1] == ' ')) words++;
    }
    cout << "lines: " << lines << " words: " << words << " chars: " << chars << "\n";
    return 0;
}
```

**Explanation:** one pass, three counters, with the newline accounting made explicit (`+1` per line) — the sort of off-by-one that file censuses live by. Note `getline` drops the newline; the program's definition of "chars" must reintroduce it. *Distinct idea:* definitions drive counters.

---

### A-16 — Filter: copy passing lines only

**Difficulty:** ★★★ · **Topics:** files, filtering, two streams

Read `in.txt`; write to `passes.txt` only the lines that contain the word `PASS` (exact token, not as a substring like `PASSING` — treat words as space-separated). Print how many passed.

**Input:** an existing `in.txt`.
**Output:** `passes.txt` plus a screen count.
**Sample tests:** `Ali PASS 88` copies; `Bilal PASSING 40` does not.
**Hints:** ① token-scan each line and compare tokens to `PASS`; ② substring matching is the bug the sample is built to catch.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;
int main() {
    ifstream in("in.txt");
    ofstream out("passes.txt");
    if (!in || !out) { cout << "file problem\n"; return 1; }
    string line, token;
    int count = 0;
    while (getline(in, line)) {
        bool hit = false;
        string cur = "";
        for (size_t i = 0; i <= line.size(); i++) {
            if (i == line.size() || line[i] == ' ') {
                if (cur == "PASS") hit = true;
                cur = "";
            } else cur += line[i];
            if (hit) break;
        }
        if (hit) { out << line << "\n"; count++; }
    }
    cout << "copied: " << count << "\n";
    return 0;
}
```

**Explanation:** token-exact matching versus `find("PASS")` substring matching — the difference between `PASSING` matching and not. The scanner is I-15's, reused; the decision is a spec-reading lesson. *Distinct idea:* matching at the right grain.

---

### A-17 — Merge two sorted files

**Difficulty:** ★★★ · `Topics:` files, merge, sorted data

`a.txt` and `b.txt` each hold sorted integers (one per line, any counts). Write `merged.txt` with all values in order — read both fully into arrays first, then apply I-07's merge.

**Input:** two existing sorted files.
**Output:** the merged file plus a screen count of total values.
**Hints:** ① load each file with the read-until-fail loop; ② the merge is I-07 verbatim — reuse it.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
using namespace std;
int main() {
    int a[1000], b[1000];
    int na = 0, nb = 0, x;
    ifstream fa("a.txt"), fb("b.txt");
    if (!fa || !fb) { cout << "file problem\n"; return 1; }
    while (fa >> x) a[na++] = x;
    while (fb >> x) b[nb++] = x;
    ofstream out("merged.txt");
    int i = 0, j = 0;
    while (i < na || j < nb) {
        if (i < na && (j >= nb || a[i] <= b[j])) out << a[i++] << "\n";
        else                                     out << b[j++] << "\n";
    }
    cout << "merged: " << na + nb << "\n";
    return 0;
}
```

**Explanation:** load-then-merge separates *reading* from *processing* — the two-phase shape that lets the same merge serve files, arrays, or streams. Sorted-input awareness is the whole economy: no sorting pass is ever run. *Distinct idea:* sorted-input fusion.

---

### A-18 — Data repair: skip and report bad lines

**Difficulty:** ★★★ · **Topics:** files, validation, robustness

`raw.txt` holds lines that should each be `integer integer`. Some lines are broken (letters, one value, empty). Read the file; write valid pairs to `clean.txt` as their sums, and print `kept: K skipped: S`.

**Input:** an existing `raw.txt` with 1–30 lines of any content.
**Output:** the screen summary; clean sums in the file.
**Sample tests:** lines `10 20` / `abc` / `7` / `3 4` → kept sums `30` and `7`; report `kept: 2 skipped: 2`.
**Hints:** ① read a line, then attempt `istringstream`-free validation: find the space, try stoi on both halves; ② any failure means skip.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

bool toInt(const string& s, int& out) {
    if (s.empty()) return false;
    for (size_t i = 0; i < s.size(); i++)
        if (s[i] < '0' || s[i] > '9') return false;
    out = stoi(s);
    return true;
}

int main() {
    ifstream in("raw.txt");
    ofstream out("clean.txt");
    if (!in || !out) { cout << "file problem\n"; return 1; }
    string line;
    int kept = 0, skipped = 0;
    while (getline(in, line)) {
        size_t sp = line.find(' ');
        int a, b;
        if (sp == string::npos ||
            !toInt(line.substr(0, sp), a) ||
            !toInt(line.substr(sp + 1), b)) { skipped++; continue; }
        out << a + b << "\n";
        kept++;
    }
    cout << "kept: " << kept << " skipped: " << skipped << "\n";
    return 0;
}
```

**Explanation:** a hand-rolled `toInt` validator (digits only, non-empty) gates every conversion — the boundary-validation layer from the robustness module, applied at file grain. Files from the real world are dirty; the program's job is to triage, not crash. *Distinct idea:* validate-then-convert at the file boundary.

---

## Part 3 — Recursion (A-19…A-26)

### A-19 — Trace factorial by hand, then verify

**Difficulty:** ★★ · **Topics:** recursion, tracing, base case

Draw the call stack for `factRec(4)` on paper (each call, its return), then write `long long factRec(int n)` and a main that prints factRec(4). Mark the base case in a comment.

**Input:** none (fixed call 4).
**Output:** `24`.
**Hints:** ① base: n ≤ 1 returns 1; ② each pending multiplication resumes after the deeper call returns.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

long long factRec(int n) {
    if (n <= 1) return 1;        // base case: the recursion's floor
    return n * factRec(n - 1);   // recursive case: shrink, trust, multiply on the way up
}

int main() {
    cout << factRec(4) << "\n";  // 4 * (3 * (2 * (1))) = 24
    return 0;
}
```

**Explanation:** shrink-and-trust — each call assumes the smaller answer exists — with the multiplication happening on the *unwind*. The hand-drawn stack before the code is the exercise; the code merely verifies the drawing. *Distinct idea:* the unwind does half the work.

---

### A-20 — Recursive sum of digits

**Difficulty:** ★★ · **Topics:** recursion, digit processing

Write `int digitSumRec(long long n)` recursively (no loops). Read n; print the sum.

**Input:** one integer 0…10¹⁸.
**Output:** one integer.
**Sample tests:** `4729` → `22` · `0` → `0`
**Hints:** ① base: n == 0 → 0; ② step: n % 10 + digitSumRec(n / 10).
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int digitSumRec(long long n) {
    if (n == 0) return 0;
    return n % 10 + digitSumRec(n / 10);
}

int main() {
    long long n;
    cin >> n;
    cout << digitSumRec(n) << "\n";
    return 0;
}
```

**Explanation:** the peel loop (B-31) as a recursion — the accumulator became the *return value assembling on the unwind*. n=0 is a legal input whose base case fires immediately: recursion handles empty cases for free. *Distinct idea:* loops become unwinds.

---

### A-21 — Recursive power (divide-and-conquer)

**Difficulty:** ★★★ · **Topics:** recursion, divide and conquer

Write `long long powerRec(long long b, int e)` computing b^e in O(log e) multiplications: even e → powerRec(b, e/2)²; odd e → b · powerRec(b, e−1). Read b (1–10) and e (0–30); print the result.

**Input:** two integers.
**Output:** one integer.
**Sample tests:** `2 10` → `1024` · `3 5` → `243`
**Hints:** ① two cases, one on parity; ② squaring halves the exponent — that's the log.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

long long powerRec(long long b, int e) {
    if (e == 0) return 1;
    if (e % 2 == 0) {
        long long half = powerRec(b, e / 2);
        return half * half;
    }
    return b * powerRec(b, e - 1);
}

int main() {
    long long b;
    int e;
    cin >> b >> e;
    cout << powerRec(b, e) << "\n";
    return 0;
}
```

**Explanation:** Ba-05 multiplied e times; this squares its way down — storing `half` once (not computing it twice) is the difference between O(log e) and a disguised O(e). Divide-and-conquer in its smallest honest form. *Distinct idea:* halving the problem.

---

### A-22 — Recursive array sum and max

**Difficulty:** ★★ · **Topics:** recursion, arrays, index parameter

Write `long long sumRec(int* a, int n)` (sum of first n elements, recursively) and `int maxRec(int* a, int n)`. Read n then n values; print both.

**Input:** n (1–100), then n integers.
**Output:** `sum: S max: M`.
**Sample tests:** `5 4 9 1 7 3` → `sum: 24 max: 9`
**Hints:** ① base: n == 1 → a[0] (for both); ② step: last element + rest / max(last, rest).
**Reference solution**

```cpp
#include <iostream>
using namespace std;

long long sumRec(int* a, int n) {
    if (n == 1) return a[0];
    return a[n - 1] + sumRec(a, n - 1);
}

int maxRec(int* a, int n) {
    if (n == 1) return a[0];
    int rest = maxRec(a, n - 1);
    return (a[n - 1] > rest) ? a[n - 1] : rest;
}

int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cout << "sum: " << sumRec(a, n) << " max: " << maxRec(a, n) << "\n";
    return 0;
}
```

**Explanation:** the array shrinks through the *n* parameter while the pointer stays put — recursion over "first n elements" is the standard array-recursion frame. n=1 (not 0) as base avoids the empty-array question entirely; stating why is part of the exercise. *Distinct idea:* size parameters as shrinking subproblems.

---

### A-23 — Recursive reverse print

**Difficulty:** ★★ · **Topics:** recursion, arrays, output order

Write `void printRev(int* a, int n)` printing the first n elements in reverse, recursively. Read n then n values; call it.

**Input:** n (1–100), then n integers.
**Output:** the reversed line.
**Sample tests:** `4 1 2 3 4` → `4 3 2 1`
**Hints:** ① print a[n−1] *then* recurse on n−1 — order is everything; ② handle the spacing with a leading-space rule.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void printRev(int* a, int n) {
    if (n == 0) return;
    cout << a[n - 1];
    if (n > 1) cout << " ";
    printRev(a, n - 1);
}

int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    printRev(a, n);
    cout << "\n";
    return 0;
}
```

**Explanation:** swapping the print and the recurse turns forward traversal into reverse — a one-line change with a deep lesson: *in recursion, order of operations is the direction of traversal*. *Distinct idea:* statement order as traversal direction.

---

### A-24 — Recursive linear search

**Difficulty:** ★★ · **Topics:** recursion, searching, index parameters

Write `int linSearchRec(int* a, int n, int key)` — search the first n elements, return the index or −1. Read n, n distinct values, key; print the result index or `absent`.

**Input:** n (1–100), n distinct integers, key.
**Output:** 0-based index or `absent`.
**Sample tests:** `5 8 3 9 1 4 9` → `2` · key 7 → `absent`
**Hints:** ① base: n == 0 → −1; ② check a[n−1] first, then recurse smaller — or check a[0] and recurse on a+1; pick one and justify.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int linSearchRec(int* a, int n, int key) {
    if (n == 0) return -1;
    if (a[n - 1] == key) return n - 1;   // found at the back
    return linSearchRec(a, n - 1, key);  // search the front part
}

int main() {
    int n, a[100], key;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cin >> key;
    int pos = linSearchRec(a, n, key);
    if (pos == -1) cout << "absent\n";
    else           cout << pos << "\n";
    return 0;
}
```

**Explanation:** the "check the last, recurse on the rest" order returns the *highest* matching index; checking the first instead returns the lowest. With distinct values the two agree — but the reasoning about which base ordering produces which semantics is the real content. *Distinct idea:* search direction encoded in recursion order.

---

### A-25 — Binary search, recursive, on a sorted array

**Difficulty:** ★★★ · **Topics:** recursion, binary search, boundaries

Write `bool binSearchRec(int* a, int lo, int hi, int key)` on a sorted array. Read n (1–100), n **sorted** integers, then k queries; answer each `FOUND`/`MISSING`.

**Input:** n, sorted ints, k (1–20), then k keys.
**Output:** k lines.
**Sample tests:** n=5 `2 5 8 12 16`, k=3, keys `8 1 16` → `FOUND` `MISSING` `FOUND`
**Hints:** ① base: lo > hi → MISSING; ② mid = lo + (hi − lo)/2 — *not* (lo+hi)/2, and say why in a comment.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

bool binSearchRec(int* a, int lo, int hi, int key) {
    if (lo > hi) return false;
    int mid = lo + (hi - lo) / 2;   // overflow-safe midpoint
    if (a[mid] == key) return true;
    if (key < a[mid]) return binSearchRec(a, lo, mid - 1, key);
    return binSearchRec(a, mid + 1, hi, key);
}

int main() {
    int n, a[100], k;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cin >> k;
    for (int q = 0; q < k; q++) {
        int key;
        cin >> key;
        cout << (binSearchRec(a, 0, n - 1, key) ? "FOUND" : "MISSING") << "\n";
    }
    return 0;
}
```

**Explanation:** the inclusive-bounds binary search — `lo > hi` as the empty-range base, three-way narrowing, and the `lo + (hi−lo)/2` midpoint whose overflow story matters only at huge indices but whose *habit* costs nothing now. Sortedness is the precondition, stated by the input spec. *Distinct idea:* halving with proof-of-absence.

---

### A-26 — Tower of Hanoi (moves counter)

**Difficulty:** ★★★ · **Topics:** recursion, classic algorithm, move counting

Write `void hanoi(int n, char from, char to, char via, long long& moves)` printing each move as `disk N: from->to` and counting moves. Read n (1–10); print all moves then `total: 2^n − 1`.

**Input:** one integer n.
**Output:** move lines then the total.
**Sample tests:** n=2 → `disk 1: A->B` / `disk 2: A->C` / `disk 1: B->C` / `total: 3`
**Hints:** ① move n−1 disks aside, move the biggest, move n−1 onto it; ② the count is a reference out-param — the tower of n=10 makes 1023 moves.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

void hanoi(int n, char from, char to, char via, long long& moves) {
    if (n == 0) return;
    hanoi(n - 1, from, via, to, moves);
    cout << "disk " << n << ": " << from << "->" << to << "\n";
    moves++;
    hanoi(n - 1, via, to, from, moves);
}

int main() {
    int n;
    long long moves = 0;
    cin >> n;
    hanoi(n, 'A', 'C', 'B', moves);
    cout << "total: " << moves << "\n";
    return 0;
}
```

**Explanation:** the canonical double recursion — two self-calls bracketing one print — whose growth (2ⁿ−1) students can *feel* by watching n climb from 3 to 10. The reference counter survives the unwind, a practical out-param use. *Distinct idea:* exponential structure made visible.

---

## Part 4 — Searching and sorting (A-27…A-32)

### A-27 — Binary search, iterative, with insertion point

**Difficulty:** ★★★ · **Topics:** searching, binary search, boundaries

Read n (1–100), n **sorted** integers, then one key. If present, print `at: I`; if absent, print `would-be: I` — the index where it should be inserted to keep the array sorted.

**Input:** n, sorted ints, key.
**Output:** one line.
**Sample tests:** `5 2 5 8 12 16` key `8` → `at: 2` · key `10` → `would-be: 3` · key `0` → `would-be: 0` · key `99` → `would-be: 5`
**Hints:** ① when the loop ends, lo is the insertion point; ② track lo/hi inclusive.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100], key;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cin >> key;
    int lo = 0, hi = n - 1, pos = -1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (a[mid] == key) { pos = mid; break; }
        if (key < a[mid]) hi = mid - 1;
        else              lo = mid + 1;
    }
    if (pos != -1) cout << "at: " << pos << "\n";
    else           cout << "would-be: " << lo << "\n";
    return 0;
}
```

**Explanation:** the loop-invariant view — everything before lo is smaller, everything after hi is larger — so when the window closes, lo *is* the insertion point. Same machinery as A-25, one extra conclusion drawn from the invariant. *Distinct idea:* the invariant as the answer.

---

### A-28 — Bubble sort with pass counters

**Difficulty:** ★★ · **Topics:** sorting, bubble, optimization

Read n (1–100) then n integers. Sort ascending with bubble sort, counting total comparisons and total swaps; print the sorted line, then `comparisons: C swaps: S`.

**Input:** n, then n integers.
**Output:** sorted line + counters.
**Sample tests:** `4 3 1 4 2` → `1 2 3 4` / `comparisons: 9 swaps: 3` (verify with early-exit: pass 2 makes 3+2 comparisons)
**Hints:** ① outer passes, inner adjacent pairs; ② stop early when a pass makes zero swaps — count that pass's comparisons too.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    long long comps = 0, swaps = 0;
    for (int pass = 0; pass < n - 1; pass++) {
        bool anySwap = false;
        for (int j = 0; j + 1 < n - pass; j++) {
            comps++;
            if (a[j] > a[j + 1]) {
                int t = a[j]; a[j] = a[j + 1]; a[j + 1] = t;
                swaps++;
                anySwap = true;
            }
        }
        if (!anySwap) break;   // already sorted — stop counting, stop working
    }
    for (int i = 0; i < n; i++) cout << a[i] << " \n"[i == n - 1];
    cout << "comparisons: " << comps << " swaps: " << swaps << "\n";
    return 0;
}
```

**Explanation:** the instrumented sort — counters turn O(n²) from a slogan into a number, and the early-exit shows bubble's one virtue (sorted or nearly-sorted inputs finish fast). The shrinking inner bound (`n - pass`) is the sorted-tail observation made code. *Distinct idea:* measurement as motivation.

---

### A-29 — Selection sort with swap counting

**Difficulty:** ★★ · **Topics:** sorting, selection, minimization

Read n then n integers. Sort ascending with selection sort; print the sorted line and `swaps: S`. Note in a comment: what is the maximum possible S, and why is selection "swap-frugal"?

**Input:** n (1–100), then n integers (−10⁶…10⁶).
**Output:** sorted line + swap count.
**Sample tests:** `5 5 4 3 2 1` → `1 2 3 4 5` / `swaps: 2`
**Hints:** ① select the min of the unsorted part, swap it into place; ② at most one swap per pass.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    int swaps = 0;
    for (int i = 0; i < n - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < n; j++)
            if (a[j] < a[minIdx]) minIdx = j;
        if (minIdx != i) {
            int t = a[i]; a[i] = a[minIdx]; a[minIdx] = t;
            swaps++;
        }
    }
    for (int i = 0; i < n; i++) cout << a[i] << " \n"[i == n - 1];
    cout << "swaps: " << swaps << "\n";
    // At most n-1 swaps: one per pass, and the last pass needs none.
    // Selection scans everything but moves data frugally — the right choice
    // when writes are expensive relative to reads.
    return 0;
}
```

**Explanation:** the min-index scan plus the `minIdx != i` guard (a swap that does nothing is still a bug class) — and the swap budget is selection's identity: n−1 writes maximum. Comparing the three elementary sorts' *counters* on the same input is the sorting module's lab exercise; this supplies one instrument. *Distinct idea:* cost measured in writes.

---

### A-30 — Insertion sort on nearly-sorted data

**Difficulty:** ★★★ · **Topics:** sorting, insertion, adaptive behavior

Read n then n integers that are *nearly sorted* (at most 3 positions from home). Sort with insertion sort and print `shifts: S` (element moves) along with the sorted line. Verify: the shift count stays small.

**Input:** n (1–100), then n nearly-sorted integers.
**Output:** sorted line + shift count.
**Sample tests:** `5 1 2 4 3 5` → `1 2 3 4 5` / `shifts: 1` · `6 1 3 2 4 6 5` → `shifts: 2`
**Hints:** ① hold the key, shift larger elements right, drop the key; ② count each shift.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    long long shifts = 0;
    for (int i = 1; i < n; i++) {
        int key = a[i];
        int j = i - 1;
        while (j >= 0 && a[j] > key) {
            a[j + 1] = a[j];
            shifts++;
            j--;
        }
        a[j + 1] = key;
    }
    for (int i = 0; i < n; i++) cout << a[i] << " \n"[i == n - 1];
    cout << "shifts: " << shifts << "\n";
    return 0;
}
```

**Explanation:** insertion's adaptive superpower made measurable — each element moves only as far as it must, so near-sorted inputs cost near-linear work. The same code on reversed input would show quadratic shifts; run both and compare is the stated extension. *Distinct idea:* adaptivity as a measured property.

---

### A-31 — Sort by two keys (marks desc, name asc)

**Difficulty:** ★★★ · **Topics:** sorting, records, stable decisions

Read n (1–50) student lines `name marks`. Sort by marks **descending**; equal marks keep **alphabetical** name order. Print the ranked list.

**Input:** n, then n lines (marks 0–100).
**Output:** n lines `name marks`.
**Sample tests:** n=4 `Bilal 88` `Ayesha 92` `Sara 88` `Danish 75` → `Ayesha 92` / `Bilal 88` / `Sara 88` / `Danish 75`
**Hints:** ① compare: marks first (descending), then names (ascending) on ties; ② sort the struct array — parallel arrays would need synchronized swaps.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

struct Student { string name; int marks; };

int main() {
    int n;
    cin >> n;
    Student s[50];
    for (int i = 0; i < n; i++) cin >> s[i].name >> s[i].marks;
    for (int i = 0; i < n - 1; i++) {
        int best = i;
        for (int j = i + 1; j < n; j++) {
            bool jBetter = s[j].marks > s[best].marks ||
                          (s[j].marks == s[best].marks && s[j].name < s[best].name);
            if (jBetter) best = j;
        }
        if (best != i) { Student t = s[i]; s[i] = s[best]; s[best] = t; }
    }
    for (int i = 0; i < n; i++) cout << s[i].name << " " << s[i].marks << "\n";
    return 0;
}
```

**Explanation:** two-key comparison as one boolean — the tie-breaker fires only when the primary keys are equal, exactly the decision-table logic of the sorting module. Sorting *records* (not parallel arrays) means one swap moves name and marks together: I-32's argument, now demonstrated. *Distinct idea:* composite ordering.

---

### A-32 — Is it sorted? (and where it breaks)

**Difficulty:** ★★ · **Topics:** searching, validation, order checking

Read n then n integers. If non-decreasing, print `SORTED`. Otherwise print `BROKEN at: I` — the 0-based index of the *first* place a[i] < a[i−1].

**Input:** n (1–100), then n integers.
**Output:** one line.
**Sample tests:** `5 1 2 2 7 9` → `SORTED` · `5 1 3 2 7 9` → `BROKEN at: 2`
**Hints:** ① one pass comparing neighbors; ② report the *first* violation and stop.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    for (int i = 1; i < n; i++) {
        if (a[i] < a[i - 1]) { cout << "BROKEN at: " << i << "\n"; return 0; }
    }
    cout << "SORTED\n";
    return 0;
}
```

**Explanation:** the sortedness verifier — binary search's *precondition check* turned into a standalone tool, with first-violation reporting (early exit) rather than a count. Equal neighbors pass: non-decreasing, not strictly increasing, per the spec. *Distinct idea:* preconditions as runnable checks.

---

## Part 5 — OOP: class fundamentals (A-33…A-38)

### A-33 — BankAccount with an enforced invariant

**Difficulty:** ★★★ · **Topics:** classes, encapsulation, validation

Design `class BankAccount { private: string owner; long long balance; public: ... }` with deposit (must be > 0) and withdraw (must be > 0 and ≤ balance) returning bool, plus a getter. Read commands `D amount` / `W amount` until `Q`; print `ok`/`denied` per command and the final balance.

**Input:** command lines ending with `Q`.
**Output:** per-command verdicts then `balance: B`.
**Sample tests:** `D 500` `W 200` `W 400` `Q` → `ok` / `ok` / `denied` / `balance: 300`
**Hints:** ① data private, behavior public; ② the class *refuses* bad operations — main never touches balance directly.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

class BankAccount {
    string owner;
    long long balance;
public:
    BankAccount(string o) : owner(o), balance(0) {}
    bool deposit(long long amt) {
        if (amt <= 0) return false;
        balance += amt;
        return true;
    }
    bool withdraw(long long amt) {
        if (amt <= 0 || amt > balance) return false;
        balance -= amt;
        return true;
    }
    long long getBalance() const { return balance; }
};

int main() {
    BankAccount acc("student");
    string cmd;
    while (cin >> cmd && cmd != "Q") {
        long long amt;
        cin >> amt;
        bool ok = (cmd == "D") ? acc.deposit(amt) : acc.withdraw(amt);
        cout << (ok ? "ok" : "denied") << "\n";
    }
    cout << "balance: " << acc.getBalance() << "\n";
    return 0;
}
```

**Explanation:** encapsulation with *teeth* — the bool returns let the caller know a refusal happened, and the private balance makes the "deny over-withdrawal" rule unbreakable from outside. This is the fee-account family lab's core object. *Distinct idea:* invariants enforced by privacy.

---

### A-34 — Constructor, destructor, and lifetime

**Difficulty:** ★★ · **Topics:** classes, constructors, destructors, lifetime

Write `class Tracer` printing `born` in its constructor and `gone` in its destructor. In main, create two Tracers in an inner block `{ ... }`; print `between` after the block. Predict the output order on paper first.

**Input:** none.
**Output:** `born` / `born` / `between` / `gone` / `gone`
**Hints:** ① locals die at block exit — in reverse creation order.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

class Tracer {
public:
    Tracer()  { cout << "born\n"; }
    ~Tracer() { cout << "gone\n"; }
};

int main() {
    {
        Tracer a;
        Tracer b;
    }                 // both die here, b first (reverse order)
    cout << "between\n";
    return 0;
}
```

**Explanation:** object lifetime made visible — construction at declaration, destruction at scope exit in reverse order. The destructor's *automatic* call is the seed of RAII; the modern-cpp module names the idea this output demonstrates. *Distinct idea:* scope as a lifetime contract.

---

### A-35 — const member functions and the const object

**Difficulty:** ★★★ · **Topics:** classes, const, interfaces

Design `class Rectangle` with private width/height, `double area() const`, `void scale(double f)` (non-const), and getters `const`. In main: a normal Rectangle scales and prints; a `const Rectangle` prints its area but must not scale — attempt the scale call in a comment and note the compiler's verdict.

**Input:** width, height for both rectangles.
**Output:** areas after scaling (first) and as-is (const second).
**Sample tests:** `3 4` then `5 6` → `area after scale x2: 48` / `const area: 30`
**Hints:** ① `const` after the parameter list promises no mutation; ② const objects may call *only* const members.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;

class Rectangle {
    double w, h;
public:
    Rectangle(double w_, double h_) : w(w_), h(h_) {}
    double area() const { return w * h; }
    double getWidth() const { return w; }
    double getHeight() const { return h; }
    void scale(double f) { w *= f; h *= f; }   // mutates — not const
};

int main() {
    double w1, h1, w2, h2;
    cin >> w1 >> h1 >> w2 >> h2;
    Rectangle r(w1, h1);
    r.scale(2.0);
    cout << fixed << setprecision(0) << "area after scale x2: " << r.area() << "\n";

    const Rectangle fixedR(w2, h2);
    cout << "const area: " << fixedR.area() << "\n";
    // fixedR.scale(2.0);   // compile error: const object, non-const method
    return 0;
}
```

**Explanation:** const-correctness as an *interface* — the const methods form the read-only surface every object (including const ones) honors, while `scale` self-identifies as mutating by its absence of const. The commented-out call is the experiment; the compiler is the grader. *Distinct idea:* const as a published promise.

---

### A-36 — Composition: Engine inside Car

**Difficulty:** ★★★ · **Topics:** classes, composition, has-a

Design `class Engine { int hp; public: Engine(int); int getHp() const; }` and `class Car { Engine engine; string model; public: Car(string, int); void report() const; }` — Car *has-an* Engine. Read model and hp; print `model: M engine: HPhp`.

**Input:** one line `model hp` (model is one word).
**Output:** the report line.
**Sample tests:** `Civic 158` → `model: Civic engine: 158hp`
**Hints:** ① the member initializer list constructs Engine before Car's body runs; ② `engine.getHp()` is the member chain.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

class Engine {
    int hp;
public:
    Engine(int h) : hp(h) {}
    int getHp() const { return hp; }
};

class Car {
    Engine engine;      // composition: Car has-an Engine
    string model;
public:
    Car(string m, int h) : engine(h), model(m) {}
    void report() const {
        cout << "model: " << model
             << " engine: " << engine.getHp() << "hp\n";
    }
};

int main() {
    string m; int h;
    cin >> m >> h;
    Car c(m, h);
    c.report();
    return 0;
}
```

**Explanation:** composition — the has-a relationship built from fully-owned members — versus the inheritance taught later: an Engine is *part of* a Car, not a *kind of* Car. The member-initializer list shows construction happening inside-out. *Distinct idea:* has-a as object assembly.

---

### A-37 — this pointer and method chaining

**Difficulty:** ★★★ · **Topics:** classes, this, chaining

Design `class Counter` with `Counter& inc()` and `Counter& dec()` returning `*this`, plus `value() const`. Read a command string like `+++-+` and apply it to a fresh Counter; print the final value.

**Input:** one line of `+` and `-` characters (1–50).
**Output:** one integer.
**Sample tests:** `+++-+` → `3`
**Hints:** ① return `*this` by reference to enable `c.inc().inc()`; ② loop the characters.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

class Counter {
    int v = 0;
public:
    Counter& inc() { v++; return *this; }
    Counter& dec() { v--; return *this; }
    int value() const { return v; }
};

int main() {
    string ops;
    getline(cin, ops);
    Counter c;
    for (size_t i = 0; i < ops.size(); i++) {
        if (ops[i] == '+') c.inc();
        else if (ops[i] == '-') c.dec();
    }
    cout << c.value() << "\n";
    return 0;
}
```

**Explanation:** returning `*this` by reference is what makes `c.inc().inc().dec()` possible — the fluent-interface trick behind `cout << a << b` itself. The this pointer is usually invisible; this problem makes it the API. *Distinct idea:* the object as its own return value.

---

### A-38 — Class with validation-throwing constructor

**Difficulty:** ★★★ · **Topics:** classes, validation, exceptions preview

Design `class Mark` holding a 0–100 value. Its constructor *rejects* out-of-range input by printing `REJECTED` and leaving the object unusable is impossible — so instead: the constructor takes the value, and a static factory `static bool tryMake(int v, Mark& out)` returns false for invalid input without constructing. Read three values; print each `ok:V` or `REJECTED`, then the sum of accepted marks.

**Input:** three integers (any).
**Output:** per-value verdicts then `sum: S` of accepted values (0 if none accepted).
**Sample tests:** `85 120 40` → `ok:85` / `REJECTED` / `ok:40` / `sum: 125`
**Hints:** ① validate before assigning; ② the factory pattern separates "attempt" from "object exists".
**Reference solution**

```cpp
#include <iostream>
using namespace std;

class Mark {
    int v;
    Mark(int value) : v(value) {}          // private: only tryMake may call
public:
    static bool tryMake(int candidate, Mark& out) {
        if (candidate < 0 || candidate > 100) return false;
        out = Mark(candidate);
        return true;
    }
    int value() const { return v; }
};

int main() {
    long long sum = 0;
    for (int i = 0; i < 3; i++) {
        int x;
        cin >> x;
        Mark m(0);   // placeholder; overwritten on success
        if (Mark::tryMake(x, m)) { cout << "ok:" << x << "\n"; sum += x; }
        else                     cout << "REJECTED\n";
    }
    cout << "sum: " << sum << "\n";
    return 0;
}
```

**Explanation:** the *cannot-exist-invalid* design — a private constructor plus a validating factory means no Mark object ever holds an illegal value, so no user of Mark ever needs to check. This is the boundary-validation idea promoted into the type itself; the exceptions module later offers the throwing alternative. *Distinct idea:* invalid states made unrepresentable.

---

## Part 6 — Functions and structures, advanced (A-39…A-40)

### A-39 — Struct with member functions (the bridge to classes)

**Difficulty:** ★★ · **Topics:** structures, member functions, encapsulation bridge

Define `struct Circle { double r; double area() const { return 3.14159265358979 * r * r; } double circumference() const; };` — a struct *with* member functions. Read r; print area and circumference (two decimals).

**Input:** one number 0.1–1000.0.
**Output:** two lines.
**Sample tests:** `2` → `area: 12.57` / `circumference: 12.57` — for r=2 both are 4π ≈ 12.57; use `3` → `area: 28.27` / `circumference: 18.85` to differentiate.
**Hints:** ① structs and classes differ only in default access; ② member functions read members directly.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;

struct Circle {
    double r;
    double area() const { return 3.14159265358979 * r * r; }
    double circumference() const { return 2 * 3.14159265358979 * r; }
};

int main() {
    Circle c;
    cin >> c.r;
    cout << fixed << setprecision(2)
         << "area: " << c.area() << "\n"
         << "circumference: " << c.circumference() << "\n";
    return 0;
}
```

**Explanation:** data plus the operations that own it, in one place — the struct-with-methods form is the honest bridge from the records module to classes: same feature, different default access. The formulas live *with* the radius they interpret. *Distinct idea:* behavior colocated with data.

---

### A-40 — The registry: struct array + file + query functions

**Difficulty:** ★★★ · **Topics:** structures, files, functions, integration

`students.txt` holds `name marks` lines. Load them into a struct array (max 100), then support three queries read from stdin: `top` (highest marks, ties in input order), `avg` (two decimals), `find name` (marks or `absent`). Commands end with `done`.

**Input:** the file, then commands ending with `done`.
**Output:** per-query results.
**Sample tests:** file `Ayesha 88` `Bilal 72` `Sara 88`; commands `top` `avg` `find Bilal` `done` → `Ayesha 88` / `Sara 88` / `avg: 82.67` / `72`
**Hints:** ① a `loadStudents` function returns the count; ② one query function per command; ③ main is a dispatcher.
**Reference solution**

```cpp
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>
using namespace std;

struct Student { string name; int marks; };

int loadStudents(Student s[], int cap) {
    ifstream in("students.txt");
    if (!in) return 0;
    int n = 0;
    while (n < cap && (in >> s[n].name >> s[n].marks)) n++;
    return n;
}

void queryTop(Student s[], int n) {
    if (n == 0) { cout << "none\n"; return; }
    int best = s[0].marks;
    for (int i = 1; i < n; i++) if (s[i].marks > best) best = s[i].marks;
    for (int i = 0; i < n; i++)
        if (s[i].marks == best) cout << s[i].name << " " << s[i].marks << "\n";
}

void queryAvg(Student s[], int n) {
    if (n == 0) { cout << "none\n"; return; }
    long long t = 0;
    for (int i = 0; i < n; i++) t += s[i].marks;
    cout << fixed << setprecision(2) << "avg: " << (double)t / n << "\n";
}

void queryFind(Student s[], int n, const string& who) {
    for (int i = 0; i < n; i++)
        if (s[i].name == who) { cout << s[i].marks << "\n"; return; }
    cout << "absent\n";
}

int main() {
    Student s[100];
    int n = loadStudents(s, 100);
    string cmd;
    while (cin >> cmd && cmd != "done") {
        if (cmd == "top") queryTop(s, n);
        else if (cmd == "avg") queryAvg(s, n);
        else if (cmd == "find") { string who; cin >> who; queryFind(s, n, who); }
    }
    return 0;
}
```

**Explanation:** the full data-program anatomy — load, then a dispatch loop over single-purpose query functions — is the file-based student management system in miniature and the direct rehearsal for Project 9 and the capstone. Each function is testable alone; main merely routes. *Distinct idea:* load, dispatch, delegate.

---

**Tier check:** 40 problems · A-01–A-40 · update [the checklist](index.md), then face [challenge.md](challenge.md).
