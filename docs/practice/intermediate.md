---
title: "Practice Bank — Intermediate Tier (40 problems)"
description: "I-01…I-40: arrays, strings, functions and records, applied loops — each with statement, topics, I/O, constraints, samples, graded hints, reference solution, and explanation."
---

# Intermediate tier — I-01 to I-40

> **Units first:** [Stage C — Structure](../syllabus.md#stage-c-structure-units-7-9) (arrays, strings, functions, records).
> **Attempt protocol:** unchanged — and now the samples must include one *boundary* case you invent yourself.

## Part 1 — Arrays and collections (I-01…I-12)

### I-01 — Fill, then analyze

**Difficulty:** ★★ · **Topics:** arrays, input, traversal

Read n (1–100) then n integers into an array. Print them reversed on one line, then their sum.

**Input:** n, then n integers (−1000…1000).
**Output:** reversed line, then `sum: S`.
**Sample tests:** `4 1 2 3 4` → `4 3 2 1` / `sum: 10`
**Hints:** ① fill in one loop, print in a second, downward loop.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    for (int i = n - 1; i >= 0; i--) cout << a[i] << " \n"[i == 0];
    long long sum = 0;
    for (int i = 0; i < n; i++) sum += a[i];
    cout << "sum: " << sum << "\n";
    return 0;
}
```

**Explanation:** the fill-then-two-passes shape is the array baseline; `" \n"[i == 0]` prints a space between items and a newline after the last — a neat, honest trick worth meeting early (a plain if also works). *Distinct idea:* passes over stored data.

---

### I-02 — Maximum and its position

**Difficulty:** ★★ · **Topics:** arrays, extremes, indices

Read n (1–100) then n distinct integers. Print the maximum and its 0-based index.

**Input:** n, then n integers (−10⁶…10⁶).
**Output:** `max: M at: I`.
**Sample tests:** `5 8 3 9 1 9` — invalid (distinct), use `5 8 3 9 1 4` → `max: 9 at: 2`
**Hints:** ① track index alongside the max — update both together.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    int best = 0;
    for (int i = 1; i < n; i++) if (a[i] > a[best]) best = i;
    cout << "max: " << a[best] << " at: " << best << "\n";
    return 0;
}
```

**Explanation:** storing the *index* of the best rather than the best value is the small reframing that makes position reporting free — and it's the shape that later becomes `max_element` (C-11). *Distinct idea:* index as the artifact.

---

### I-03 — Count above average

**Difficulty:** ★★ · **Topics:** arrays, averages, two-pass

Read n (1–100) then n integers. Print the average (two decimals) and how many elements are strictly above it.

**Input:** n, then n integers.
**Output:** `avg: X above: K`.
**Sample tests:** `5 10 20 30 40 50` → `avg: 30.00 above: 2`
**Hints:** ① pass 1 sums; pass 2 counts — you need the array because the average arrives *after* the data.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    long long sum = 0;
    for (int i = 0; i < n; i++) { cin >> a[i]; sum += a[i]; }
    double avg = (double)sum / n;
    int above = 0;
    for (int i = 0; i < n; i++) if (a[i] > avg) above++;
    cout << fixed << setprecision(2) << "avg: " << avg << " above: " << above << "\n";
    return 0;
}
```

**Explanation:** the two-pass pattern exists *because* storage lets you look again — a streaming version is impossible without keeping the values. *Distinct idea:* why storage enables second looks.

---

### I-04 — In-place reverse (two-pointer)

**Difficulty:** ★★★ · **Topics:** arrays, two pointers, in-place

Read n (1–100) then n integers. Reverse the array **in place** (no second array) and print it.

**Input:** n, then n integers.
**Output:** the reversed line.
**Sample tests:** `5 1 2 3 4 5` → `5 4 3 2 1`
**Hints:** ① two indices walk toward the middle, swapping as they go; ② stop when they meet.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    for (int lo = 0, hi = n - 1; lo < hi; lo++, hi--) {
        int t = a[lo]; a[lo] = a[hi]; a[hi] = t;
    }
    for (int i = 0; i < n; i++) cout << a[i] << " \n"[i == n - 1];
    return 0;
}
```

**Explanation:** the two-pointer swap — half the moves of a full pass, zero extra memory — is the in-place idiom behind reverse, palindrome checks, and partitioning later. *Distinct idea:* converging indices.

---

### I-05 — Rotate right by k

**Difficulty:** ★★★ · **Topics:** arrays, index arithmetic, modular thinking

Read n (1–100), k (0–100), then n integers. Print the array rotated right by k (the last k elements move to the front).

**Input:** n, k, then n integers.
**Output:** the rotated line.
**Sample tests:** `5 2 1 2 3 4 5` → `4 5 1 2 3` · `3 0 7 8 9` → `7 8 9`
**Hints:** ① element at old index i lands at new index (i + k) % n — or read it backwards: new position j comes from old (j − k + n) % n.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, k, a[100], b[100];
    cin >> n >> k;
    k %= n;                                  // k may exceed n
    for (int i = 0; i < n; i++) cin >> a[i];
    for (int i = 0; i < n; i++) b[(i + k) % n] = a[i];
    for (int i = 0; i < n; i++) cout << b[i] << " \n"[i == n - 1];
    return 0;
}
```

**Explanation:** modular index arithmetic turns rotation into one assignment formula — no shifting loops, no special cases for the wrap. The `k %= n` guard is the boundary habit. *Distinct idea:* `% n` as the wraparound operator.

---

### I-06 — Second largest without sorting

**Difficulty:** ★★★ · **Topics:** arrays, extremes, single pass

Read n (2–100) then n integers (may contain duplicates of values but the two largest *positions* differ). Print the second largest **distinct value**; if all values are equal, print `NONE`.

**Input:** n, then n integers (−10⁶…10⁶).
**Output:** one integer or `NONE`.
**Sample tests:** `5 3 9 1 9 4` → `4` · `3 7 7 7` → `NONE` · `2 5 5` → `NONE`
**Hints:** ① track best and secondBest; ② a value equal to best must not demote secondBest.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    long long best = a[0], second = LLONG_MIN;
    bool haveSecond = false;
    for (int i = 1; i < n; i++) {
        if (a[i] > best)        { second = best; haveSecond = true; best = a[i]; }
        else if (a[i] < best && (a[i] > second || !haveSecond)) { second = a[i]; haveSecond = true; }
    }
    if (haveSecond) cout << second << "\n";
    else            cout << "NONE\n";
    return 0;
}
```

**Explanation:** the three cases — bigger, smaller, equal — each get explicit treatment; the equal case is precisely what makes this problem distinct from Ba-02's plain max. `LLONG_MIN` + a boolean is the honest "no second yet" encoding. *Distinct idea:* extremes with a duplicate-aware runner-up.

---

### I-07 — Merge two sorted arrays

**Difficulty:** ★★★ · **Topics:** arrays, merge, two pointers

Read n, then n sorted integers; read m, then m sorted integers. Merge into one sorted line without sorting again.

**Input:** n (1–50), n sorted ints; m (1–50), m sorted ints (−10⁶…10⁶).
**Output:** the merged line.
**Sample tests:** `3 1 4 9` + `3 2 3 10` → `1 2 3 4 9 10`
**Hints:** ① i and j walk the two arrays; ② always emit the smaller head; ③ drain leftovers after either runs out.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, m, a[50], b[50];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cin >> m;
    for (int j = 0; j < m; j++) cin >> b[j];
    int i = 0, j = 0;
    bool firstOut = true;
    while (i < n || j < m) {
        long long take;
        if (i < n && (j >= m || a[i] <= b[j])) take = a[i++];
        else                                    take = b[j++];
        if (!firstOut) cout << " ";
        cout << take;
        firstOut = false;
    }
    cout << "\n";
    return 0;
}
```

**Explanation:** the merge walk is the heart of merge sort (A-30 uses it) and the classic "two pointers, one output" pattern. The `<=` keeps the merge stable — equal elements keep their source order. *Distinct idea:* consuming two sorted streams.

---

### I-08 — Remove duplicates, keep first order

**Difficulty:** ★★★ · **Topics:** arrays, membership, compaction

Read n (1–100) then n integers. Print the values with duplicates removed, keeping first-appearance order.

**Input:** n, then n integers (−10⁶…10⁶).
**Output:** the compacted line.
**Sample tests:** `6 4 2 4 3 2 9` → `4 2 3 9`
**Hints:** ① build a result array; before inserting, scan what's already there; ② track the result length separately.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100], out[100], m = 0;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    for (int i = 0; i < n; i++) {
        bool seen = false;
        for (int j = 0; j < m; j++) if (out[j] == a[i]) { seen = true; break; }
        if (!seen) out[m++] = a[i];
    }
    for (int i = 0; i < m; i++) cout << out[i] << " \n"[i == m - 1];
    return 0;
}
```

**Explanation:** the keep-first compaction with a separate output length — the same structure as the later `set`-based version (C-08), where the container replaces the inner scan. Writing both is the point. *Distinct idea:* grow-a-result-with-membership-checks.

---

### I-09 — Frequency table of an array

**Difficulty:** ★★ · **Topics:** arrays, counting, bounded values

Read n (1–200) then n integers, each in 0–50 inclusive. Print each distinct value (ascending) with its count.

**Input:** n, then n integers (0…50).
**Output:** `value: v count: c` per distinct value.
**Sample tests:** `6 3 1 3 0 3 1` → `value: 0 count: 1` / `value: 1 count: 2` / `value: 3 count: 3`
**Hints:** ① a count array `cnt[51]` indexed by value; ② the bounded range is what makes direct indexing possible.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, cnt[51] = {0};
    cin >> n;
    for (int i = 0; i < n; i++) { int x; cin >> x; cnt[x]++; }
    for (int v = 0; v <= 50; v++)
        if (cnt[v] > 0) cout << "value: " << v << " count: " << cnt[v] << "\n";
    return 0;
}
```

**Explanation:** direct-indexed counting — O(n + 51) — works only because values are bounded; the constraint line *is* the algorithm's license. Unbounded values force the Ba-16-style pairing or the map (C-10). *Distinct idea:* the value as the index.

---

### I-10 — Longest run of equal values

**Difficulty:** ★★★ · **Topics:** arrays, runs, state machines

Read n (1–100) then n integers. Print the value with the longest consecutive run and that run's length.

**Input:** n, then n integers.
**Output:** `value: V run: L`.
**Sample tests:** `7 5 5 3 3 3 5 1` → `value: 3 run: 3` · `1 4 4` → `value: 4 run: 2` — input `3 1 4 4` → `value: 4 run: 2`
**Hints:** ① keep current value + current run + best value + best run; ② equal to current → extend; else → reset.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    int curVal = a[0], curRun = 1, bestVal = a[0], bestRun = 1;
    for (int i = 1; i < n; i++) {
        if (a[i] == curVal) curRun++;
        else { curVal = a[i]; curRun = 1; }
        if (curRun > bestRun) { bestRun = curRun; bestVal = curVal; }
    }
    cout << "value: " << bestVal << " run: " << bestRun << "\n";
    return 0;
}
```

**Explanation:** run-length tracking is a two-state machine (extend/reset) with a promotion rule — the same skeleton as the word-frequency run problems and the temperature station's longest cold spell. *Distinct idea:* current-vs-best state pairs.

---

### I-11 — Matrix row and column sums

**Difficulty:** ★★ · **Topics:** arrays, matrices, nested loops

Read r, c (1–10 each) then r×c integers row by row. Print each row's sum, then each column's sum, labeled.

**Input:** r, c, then the grid.
**Output:** `row i: S` lines then `col j: S` lines.
**Sample tests:** `2 3 1 2 3 4 5 6` → `row 0: 6` `row 1: 15` `col 0: 5` `col 1: 7` `col 2: 9`
**Hints:** ① row sums: inner loop over the row; ② column sums: swap the loop order — outer j, inner i.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int r, c, g[10][10];
    cin >> r >> c;
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            cin >> g[i][j];
    for (int i = 0; i < r; i++) {
        int s = 0;
        for (int j = 0; j < c; j++) s += g[i][j];
        cout << "row " << i << ": " << s << "\n";
    }
    for (int j = 0; j < c; j++) {
        int s = 0;
        for (int i = 0; i < r; i++) s += g[i][j];
        cout << "col " << j << ": " << s << "\n";
    }
    return 0;
}
```

**Explanation:** transposing the *loops* (not the data) produces column sums — g[i][j] visited in both orders is the matrix-traversal lesson in its purest form. *Distinct idea:* loop order as data access order.

---

### I-12 — Diagonal difference (square matrix)

**Difficulty:** ★★★ · **Topics:** arrays, matrices, index relationships

Read n (2–10) then an n×n grid. Print the absolute difference between the main-diagonal sum and the anti-diagonal sum.

**Input:** n, then the grid (−100…100).
**Output:** one integer.
**Sample tests:** `3 1 2 3 4 5 6 7 8 9` → `0` (1+5+9 = 15; 3+5+7 = 15) · n=2 grid `1 2 3 4` → `2` (1+4 − (2+3))
**Hints:** ① main diagonal: i == j; ② anti-diagonal: i + j == n − 1.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n, g[10][10];
    cin >> n;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            cin >> g[i][j];
    long long main_sum = 0, anti = 0;
    for (int i = 0; i < n; i++) {
        main_sum += g[i][i];
        anti     += g[i][n - 1 - i];
    }
    long long diff = main_sum - anti;
    if (diff < 0) diff = -diff;
    cout << diff << "\n";
    return 0;
}
```

**Explanation:** two index *relationships* — `i == j` and `i + j == n − 1` — define the diagonals without any special-cased loops. Index algebra over matrices is the skill; the center cell of odd-n matrices lands on both, which is fine here (it's added to both sums). *Distinct idea:* diagonal index identities.

---

## Part 2 — Strings (I-13…I-24)

### I-13 — getline after cin, done right

**Difficulty:** ★★★ · **Topics:** strings, cin/getline mixing, buffer

Read an integer n, then n *full lines* of text. Echo each line numbered.

**Input:** n (1–5), then n lines (each up to 100 chars, may contain spaces).
**Output:** `1: line1` etc.
**Hints:** ① after `cin >> n`, the newline is still in the buffer — one `cin.ignore()` before the getline loop.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    int n;
    cin >> n;
    cin.ignore();                       // eat the newline left by >>
    for (int i = 1; i <= n; i++) {
        string line;
        getline(cin, line);
        cout << i << ": " << line << "\n";
    }
    return 0;
}
```

**Explanation:** the mixing trap in its canonical fix — the ignore's placement (once, before the loop) is the whole exercise; inside the loop it would eat each line's first character. *Distinct idea:* the buffer as state between reads.

---

### I-14 — Case flip

**Difficulty:** ★★ · **Topics:** strings, traversal, cctype

Read one line; print it with every letter's case flipped (others unchanged).

**Input:** one line, up to 200 chars.
**Output:** the flipped line.
**Sample tests:** `Code Buff 2026!` → `cODE bUFF 2026!`
**Hints:** ① `isupper`/`islower` + `tolower`/`toupper` from `<cctype>`; ② build a result or modify in place.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <cctype>
using namespace std;
int main() {
    string s;
    getline(cin, s);
    for (size_t i = 0; i < s.size(); i++) {
        if (isupper(s[i]))      s[i] = tolower(s[i]);
        else if (islower(s[i])) s[i] = toupper(s[i]);
    }
    cout << s << "\n";
    return 0;
}
```

**Explanation:** in-place character transformation with a classification-then-act ladder — the digits and punctuation in the sample prove the else-chain leaves them alone. *Distinct idea:* conditional per-character rewrite.

---

### I-15 — Word reverser (order of words preserved)

**Difficulty:** ★★★ · **Topics:** strings, splitting, traversal

Read one line of space-separated words (single spaces, no leading/trailing spaces). Print the words in reverse word order on one line.

**Input:** one line, up to 200 chars.
**Output:** one line.
**Sample tests:** `the quick brown fox` → `fox brown quick the`
**Hints:** ① store words in a `string words[50]` while scanning; ② a word ends at a space or end-of-line.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    string line, words[50];
    getline(cin, line);
    int count = 0;
    string cur = "";
    for (size_t i = 0; i <= line.size(); i++) {
        if (i == line.size() || line[i] == ' ') {
            if (!cur.empty()) words[count++] = cur;
            cur = "";
        } else {
            cur += line[i];
        }
    }
    for (int i = count - 1; i >= 0; i--) cout << words[i] << " \n"[i == 0];
    return 0;
}
```

**Explanation:** the manual word scanner — accumulate until a boundary, flush, repeat — is hand-rolled tokenization, the same loop a later `istringstream` or `stringstream` version replaces. Writing it once makes the library version mean something. *Distinct idea:* scanning with a flush rule.

---

### I-16 — Palindrome line (letters only, case-blind)

**Difficulty:** ★★★ · **Topics:** strings, two pointers, normalization

Read one line. Consider only letters (ignore digits, spaces, punctuation), case-insensitively. Print `PALINDROME` or `NOT`.

**Input:** one line, up to 200 chars.
**Output:** one word.
**Sample tests:** `Madam, I'm Adam!` → `PALINDROME` · `Hello` → `NOT`
**Hints:** ① normalize: keep tolower'd letters in a new string; ② two-pointer compare, or compare with its reverse.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <cctype>
using namespace std;
int main() {
    string raw, clean;
    getline(cin, raw);
    for (size_t i = 0; i < raw.size(); i++)
        if (isalpha(raw[i])) clean += tolower(raw[i]);
    for (size_t lo = 0, hi = clean.size(); lo < hi; lo++, hi--) {
        if (clean[lo] != clean[hi - 1]) { cout << "NOT\n"; return 0; }
    }
    cout << "PALINDROME\n";
    return 0;
}
```

**Explanation:** normalize-then-check splits the problem into two easy halves — the same decomposition discipline as the functions module. The two-pointer scan (I-04's idiom on characters) halves the comparisons. *Distinct idea:* normalization before property testing.

---

### I-17 — Vowel/consonant report with positions

**Difficulty:** ★★ · **Topics:** strings, classification, reporting

Read one word (letters only). Print its vowel positions (0-based) on one line, then counts: `vowels: v consonants: c`.

**Input:** one word, 1–50 chars, letters only.
**Output:** positions line (space-separated) then the count line.
**Sample tests:** `Education` → `0 4 6 7` / `vowels: 4 consonants: 5`
**Hints:** ① test lowercase via tolower; ② print positions as you find them (separator discipline from I-01).
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <cctype>
using namespace std;
int main() {
    string w;
    cin >> w;
    int v = 0, c = 0;
    bool first = true;
    for (size_t i = 0; i < w.size(); i++) {
        char t = tolower(w[i]);
        if (t=='a'||t=='e'||t=='i'||t=='o'||t=='u') {
            if (!first) cout << " ";
            cout << i;
            first = false;
            v++;
        } else c++;
    }
    cout << "\nvowels: " << v << " consonants: " << c << "\n";
    return 0;
}
```

**Explanation:** classification plus *position reporting* in one pass — the positional scan that text-toolkit problems (search tools, highlighters) are built from. *Distinct idea:* positions as first-class output.

---

### I-18 — Substring counter

**Difficulty:** ★★★ · **Topics:** strings, searching, nested loops

Read a text line and a pattern (both on separate lines, pattern ≤ 20 chars). Print how many times the pattern occurs — **counting overlaps**.

**Input:** text (≤ 200 chars), pattern (1–20 chars).
**Output:** one integer.
**Sample tests:** text `aaaa`, pattern `aa` → `3` · text `abababab`, pattern `abab` → `3`
**Hints:** ① try every start position 0…text.size() − pat.size(); ② compare character by character.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    string text, pat;
    getline(cin, text);
    getline(cin, pat);
    int count = 0;
    if (pat.size() <= text.size()) {
        for (size_t s = 0; s + pat.size() <= text.size(); s++) {
            bool match = true;
            for (size_t k = 0; k < pat.size(); k++)
                if (text[s + k] != pat[k]) { match = false; break; }
            if (match) count++;
        }
    }
    cout << count << "\n";
    return 0;
}
```

**Explanation:** the naive search loop — every start, every offset — is the honest baseline that makes `find`-in-a-loop (the course's string module version) and KMP-level ideas legible later. The `s + pat.size() <= text.size()` bound is the off-by-one battleground. *Distinct idea:* overlapping occurrence counting.

---

### I-19 — Caesar shift (letters only)

**Difficulty:** ★★★ · **Topics:** strings, modular arithmetic, cctype

Read a line and a shift k (0–25). Encrypt: letters shift forward k (wrapping Z→A), case preserved, others unchanged.

**Input:** one line (≤ 200 chars), then k.
**Output:** the encrypted line.
**Sample tests:** `Attack at Z-5!` with k=3 → `Dwwdfn dw C-5!`
**Hints:** ① for lowercase: `(c - 'a' + k) % 26 + 'a'`; ② uppercase analog; ③ non-letters pass through.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    string s;
    int k;
    getline(cin, s);
    cin >> k;
    for (size_t i = 0; i < s.size(); i++) {
        char c = s[i];
        if (c >= 'a' && c <= 'z')      s[i] = (c - 'a' + k) % 26 + 'a';
        else if (c >= 'A' && c <= 'Z') s[i] = (c - 'A' + k) % 26 + 'A';
    }
    cout << s << "\n";
    return 0;
}
```

**Explanation:** the normalize-to-alphabet-index trick — subtract the base, shift modulo 26, add the base back — is *the* idiom for letter arithmetic. `%` here is a range-clamper, not a remainder report: same operator, third job. *Distinct idea:* base-offset modular mapping.

---

### I-20 — Initials and name length stats

**Difficulty:** ★★ · **Topics:** strings, getline, word starts

Read a full name (may contain multiple spaces between words? No — single spaces, no leading/trailing). Print initials in capitals separated by dots, then `letters: N` (letters only) and `words: W`.

**Input:** one line, e.g. `muhammad ali jinnah`.
**Output:** `M.A.J.` / `letters: 17` / `words: 3`
**Hints:** ① I-13-style word starts; ② isalpha filters letters from the length count.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <cctype>
using namespace std;
int main() {
    string name;
    getline(cin, name);
    int letters = 0, words = 0;
    for (size_t i = 0; i < name.size(); i++) {
        if (isalpha(name[i])) letters++;
        bool isStart = name[i] != ' ' && (i == 0 || name[i-1] == ' ');
        if (isStart) {
            words++;
            cout << (char)toupper(name[i]);
            if (i != name.size() - 1) cout << ".";  // dot after every word's initial
        }
    }
    cout << "\nletters: " << letters << " words: " << words << "\n";
    return 0;
}
```

**Explanation:** one scan, three products (initials, letter count, word count) — multi-output single-pass processing, with the punctuation rule (dot after each initial, including the last) specified by the sample. *Distinct idea:* one scan, several reports.

---

### I-21 — Digit words to digits

**Difficulty:** ★★ · **Topics:** strings, mapping, token processing

Read one line of English number words separated by spaces — `zero`…`nine` only. Print the digits they name as one integer string.

**Input:** one line, 1–12 words.
**Output:** one line of digits.
**Sample tests:** `five zero seven` → `507`
**Hints:** ① compare each token against ten literals; ② accumulate into a result string with `+=`.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    string line;
    getline(cin, line);
    string result = "";
    string cur = "";
    for (size_t i = 0; i <= line.size(); i++) {
        if (i == line.size() || line[i] == ' ') {
            if (cur == "zero")      result += '0';
            else if (cur == "one")  result += '1';
            else if (cur == "two")  result += '2';
            else if (cur == "three")result += '3';
            else if (cur == "four") result += '4';
            else if (cur == "five") result += '5';
            else if (cur == "six")  result += '6';
            else if (cur == "seven")result += '7';
            else if (cur == "eight")result += '8';
            else if (cur == "nine") result += '9';
            cur = "";
        } else {
            cur += line[i];
        }
    }
    cout << result << "\n";
    return 0;
}
```

**Explanation:** token-accumulate-classify — the word scanner from I-15 feeding a ten-way mapping. Building a result *string* (not arithmetic) is the difference from Ba-03's numeric rebuild. *Distinct idea:* strings as output accumulators.

---

### I-22 — Anagram check (case-blind, letters only)

**Difficulty:** ★★★ · **Topics:** strings, counting, normalization

Read two lines. Print `ANAGRAMS` if they contain exactly the same letters (ignoring case and non-letters, spaces included in neither), else `NOT`.

**Input:** two lines, each ≤ 100 chars.
**Output:** one word.
**Sample tests:** `Dormitory` / `Dirty Room!` → `ANAGRAMS` · `apple` / `pale` → `NOT`
**Hints:** ① tally 26 counts for each line (tolower'd letters); ② compare the two tallies.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <cctype>
using namespace std;
int main() {
    string a, b;
    getline(cin, a);
    getline(cin, b);
    int ca[26] = {0}, cb[26] = {0};
    for (size_t i = 0; i < a.size(); i++)
        if (isalpha(a[i])) ca[tolower(a[i]) - 'a']++;
    for (size_t i = 0; i < b.size(); i++)
        if (isalpha(b[i])) cb[tolower(b[i]) - 'a']++;
    bool same = true;
    for (int i = 0; i < 26; i++) if (ca[i] != cb[i]) { same = false; break; }
    cout << (same ? "ANAGRAMS" : "NOT") << "\n";
    return 0;
}
```

**Explanation:** the letter-tally comparison — signature-words, not sorting — and the `'a'`-offset indexing from I-19. The canonical anagram trap sample (`pale` vs `apple`) is what a length pre-check would shortcut: state that as an extension. *Distinct idea:* multiset equality via tallies.

---

### I-23 — Sentence capitalizer

**Difficulty:** ★★★ · **Topics:** strings, state across characters

Read one line of sentences separated by `. ` (period space). Capitalize the first letter of each sentence; the rest lowercase. Print the result.

**Input:** one line, ≤ 200 chars, at least one sentence.
**Output:** the normalized line.
**Sample tests:** `hello THERE. how ARE you.` → `Hello there. How are you.`
**Hints:** ① a boolean `newSentence` starts true; ② after a `.`, set it true; letters otherwise lowercase it false after use.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <cctype>
using namespace std;
int main() {
    string s;
    getline(cin, s);
    bool capNext = true;
    for (size_t i = 0; i < s.size(); i++) {
        if (s[i] == '.') { capNext = true; }
        else if (isalpha(s[i])) {
            if (capNext) { s[i] = toupper(s[i]); capNext = false; }
            else          s[i] = tolower(s[i]);
        }
    }
    cout << s << "\n";
    return 0;
}
```

**Explanation:** one boolean of *carried state* turns a per-character problem into a context-sensitive one — the state-machine idea that separates intermediate text processing from B-tier character audits. *Distinct idea:* carried state across a scan.

---

### I-24 — String formatting: CSV line to columns

**Difficulty:** ★★★ · **Topics:** strings, splitting, fixed fields

Read one CSV-style line: `name,marks,grade` (name may contain spaces; exactly two commas). Print it as three aligned columns: name left in width 15, marks right in width 5, grade right in width 6.

**Input:** one line, e.g. `Ali Raza,87,A`
**Output:** `Ali Raza          87     A`
**Hints:** ① find both commas with `find`, slice with `substr`; ② `stoi` the middle piece.
**Reference solution**

```cpp
#include <iostream>
#include <string>
#include <iomanip>
using namespace std;
int main() {
    string line;
    getline(cin, line);
    size_t c1 = line.find(',');
    size_t c2 = line.find(',', c1 + 1);
    string name  = line.substr(0, c1);
    string marks = line.substr(c1 + 1, c2 - c1 - 1);
    string grade = line.substr(c2 + 1);
    cout << left  << setw(15) << name
         << right << setw(5)  << stoi(marks)
         << setw(6)           << grade << "\n";
    return 0;
}
```

**Explanation:** `find` + `substr` slicing is the standard-library counterpart to I-15's manual scanner — and `stoi` is the string→number bridge the file-handling labs run constantly. Knowing both by hand makes the tools trustworthy. *Distinct idea:* positional slicing with find/substr.

---

## Part 3 — Functions and records (I-25…I-36)

### I-25 — Function over an array: stats

**Difficulty:** ★★ · **Topics:** arrays, functions, parameters

Write `double average(int a[], int n)` and `int maxOf(int a[], int n)`. Read n then n values; print `avg: X max: M` (avg two decimals).

**Input:** n (1–100), then n integers (−10⁶…10⁶).
**Output:** one line.
**Sample tests:** `4 3 9 1 7` → `avg: 5.00 max: 9`
**Hints:** ① array parameters decay to a pointer — pass n alongside; ② the function doesn't know the length otherwise.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
using namespace std;

double average(int a[], int n) {
    long long s = 0;
    for (int i = 0; i < n; i++) s += a[i];
    return (double)s / n;
}

int maxOf(int a[], int n) {
    int m = a[0];
    for (int i = 1; i < n; i++) if (a[i] > m) m = a[i];
    return m;
}

int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cout << fixed << setprecision(2)
         << "avg: " << average(a, n) << " max: " << maxOf(a, n) << "\n";
    return 0;
}
```

**Explanation:** the array+length parameter convention — the "pointer and count" pair — is why every C-family API carries a size. The functions are pure, which is exactly what makes them reusable across the next twelve problems. *Distinct idea:* arrays cross function boundaries by pointer+length.

---

### I-26 — Pass-by-reference fill: readInto

**Difficulty:** ★★ · **Topics:** arrays, references, I/O functions

Write `int readInto(int a[], int cap)` that reads values until a `0` sentinel or cap is reached, stores them in `a`, and **returns the count**. Main calls it once, then prints the count and the values.

**Input:** integers ending with 0 (at most 50 before the sentinel).
**Output:** `count: N` then the values on one line.
**Sample tests:** `4 8 15 0` → `count: 3` / `4 8 15`
**Hints:** ① the count *returns*; the array fills *by reference* (arrays always do); ② stop on 0 *before* storing it.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int readInto(int a[], int cap) {
    int n = 0, x;
    while (n < cap && (cin >> x) && x != 0) a[n++] = x;
    return n;
}

int main() {
    int a[50];
    int n = readInto(a, 50);
    cout << "count: " << n << "\n";
    for (int i = 0; i < n; i++) cout << a[i] << " \n"[i == n - 1];
    return 0;
}
```

**Explanation:** one function, two channels of output — the filled array (by nature of array parameters) and the count (by return). This dual-channel shape is the idiom behind every "load the data" function in the later labs. *Distinct idea:* in-channel and out-channel collaboration.

---

### I-27 — Boolean function over an array: anyAbove

**Difficulty:** ★ · **Topics:** arrays, predicates, early return

Write `bool anyAbove(int a[], int n, int threshold)`. Read n, n values, then a threshold; print `YES` or `NO`.

**Input:** n (1–100), n integers, threshold (−10⁶…10⁶).
**Output:** one word.
**Sample tests:** `4 10 20 5 8 15` → `YES` · `4 10 20 5 8 30` → `NO`
**Hints:** ① return true the moment one qualifies — no need to finish the loop.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

bool anyAbove(int a[], int n, int threshold) {
    for (int i = 0; i < n; i++)
        if (a[i] > threshold) return true;
    return false;
}

int main() {
    int n, a[100], t;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cin >> t;
    cout << (anyAbove(a, n, t) ? "YES" : "NO") << "\n";
    return 0;
}
```

**Explanation:** early-exit predicates — the search problem in boolean clothing — where the return inside the loop *is* the optimization. Contrast with I-03's counting: full pass vs first hit. *Distinct idea:* existential questions exit early.

---

### I-28 — Function returning the position: indexOf

**Difficulty:** ★★ · **Topics:** arrays, search, sentinel returns

Write `int indexOf(int a[], int n, int key)` returning the first matching index or −1. Read n, n values (guaranteed distinct), key; print the index or `absent`.

**Input:** n (1–100), n distinct integers, key.
**Output:** index (0-based) or `absent`.
**Sample tests:** `5 8 3 9 1 4 9` → `2` · same with key `7` → `absent`
**Hints:** ① −1 as the "not found" sentinel is a C-family convention — why −1 and not 0? (Because 0 is a valid index.)
**Reference solution**

```cpp
#include <iostream>
using namespace std;

int indexOf(int a[], int n, int key) {
    for (int i = 0; i < n; i++)
        if (a[i] == key) return i;
    return -1;
}

int main() {
    int n, a[100], key;
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    cin >> key;
    int pos = indexOf(a, n, key);
    if (pos == -1) cout << "absent\n";
    else           cout << pos << "\n";
    return 0;
}
```

**Explanation:** the −1 sentinel return — linear search as a reusable function — and the *caller* decides how "not found" is presented. Separation of finding from reporting is the design lesson. *Distinct idea:* sentinel returns and caller-side reporting.

---

### I-29 — Returning a struct: minMaxSum

**Difficulty:** ★★★ · **Topics:** structures, functions, multi-results

Define `struct Stats { int mn, mx; long long sum; };`. Write `Stats analyze(int a[], int n)`. Read n then n values; print the three fields from the returned struct.

**Input:** n (1–100), then n integers (−10⁶…10⁶).
**Output:** `min: m max: M sum: s`.
**Sample tests:** `4 3 9 1 7` → `min: 1 max: 9 sum: 20`
**Hints:** ① build a local Stats, return it by value; ② Ba-36 did this with three references — compare the two shapes.
**Reference solution**

```cpp
#include <iostream>
using namespace std;

struct Stats { int mn, mx; long long sum; };

Stats analyze(int a[], int n) {
    Stats s;
    s.mn = s.mx = a[0];
    s.sum = 0;
    for (int i = 0; i < n; i++) {
        if (a[i] < s.mn) s.mn = a[i];
        if (a[i] > s.mx) s.mx = a[i];
        s.sum += a[i];
    }
    return s;
}

int main() {
    int n, a[100];
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    Stats r = analyze(a, n);
    cout << "min: " << r.mn << " max: " << r.mx << " sum: " << r.sum << "\n";
    return 0;
}
```

**Explanation:** one *named result type* instead of three reference out-params — the struct-return shape. When a function's outputs travel together conceptually, a struct documents that fact; Ba-36's references suit in-place filling. Both idioms, one comparison. *Distinct idea:* results as a record.

---

### I-30 — Struct array: top student

**Difficulty:** ★★★ · **Topics:** structures, arrays of structs, extremes

Define `struct Student { string name; int marks; };`. Read n (1–50) students (name without spaces, marks 0–100). Print the topper's line `Topper: name (marks)`; if several tie, print each on its own line in input order.

**Input:** n, then n lines `name marks`.
**Output:** topper line(s).
**Sample tests:** n=3 `Ayesha 88` `Bilal 92` `Sara 92` → `Topper: Bilal (92)` / `Topper: Sara (92)`
**Hints:** ① find the max marks first (pass 1); ② print all matches (pass 2).
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
    int best = s[0].marks;
    for (int i = 1; i < n; i++) if (s[i].marks > best) best = s[i].marks;
    for (int i = 0; i < n; i++)
        if (s[i].marks == best) cout << "Topper: " << s[i].name << " (" << best << ")\n";
    return 0;
}
```

**Explanation:** arrays of structs with two coordinated passes — find-then-audit (B-38's separation) applied to records. Ties preserved in input order costs nothing because pass 2 walks forward. *Distinct idea:* record collections with two-pass queries.

---

### I-31 — Struct function: older()

**Difficulty:** ★★ · **Topics:** structures, functions returning structs

Define `struct Person { string name; int age; };` and `Person older(Person p, Person q)`. Read two persons (name, age); print `Elder: name (age)`.

**Input:** two lines `name age` (ages 1–120).
**Output:** one line.
**Sample tests:** `Ayesha 19` / `Bilal 22` → `Elder: Bilal (22)`
**Hints:** ① structs pass by value comfortably at this size; ② tie → return the first.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

struct Person { string name; int age; };

Person older(Person p, Person q) {
    return (p.age >= q.age) ? p : q;
}

int main() {
    Person a, b;
    cin >> a.name >> a.age >> b.name >> b.age;
    Person e = older(a, b);
    cout << "Elder: " << e.name << " (" << e.age << ")\n";
    return 0;
}
```

**Explanation:** a struct as both input and output — the record-aware signature that scales to the records module's registry problems. The tie rule (first wins) is stated by the sample. *Distinct idea:* records as natural function currency.

---

### I-32 — Parallel arrays vs struct array (same task, your call)

**Difficulty:** ★★★ · **Topics:** structures, arrays, design comparison

Task: read n (1–30) products (`name price qty`), print the most expensive in-stock product's line `name @ price (qty)` — or `NONE` if all qty are 0. **Implement it with a struct array.** In a comment at the bottom, state one concrete bug the parallel-arrays version (three separate arrays) risks that the struct version cannot.

**Input:** n, then n lines (price 1.0–99999.0, qty 0–1000).
**Output:** one line or `NONE`.
**Sample tests:** n=3 `Pen 20 100` / `Pad 990 0` / `Ink 95 12` → `Ink @ 95.00 (12)` — hmm, price with decimals: print two decimals. Adjust: `Ink @ 95.00 (12)`
**Hints:** ① filter qty > 0 first; ② the comment is the graded part — name a *mechanism*, not a feeling.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
#include <string>
using namespace std;

struct Product { string name; double price; int qty; };

int main() {
    int n;
    cin >> n;
    Product p[30];
    for (int i = 0; i < n; i++) cin >> p[i].name >> p[i].price >> p[i].qty;
    int best = -1;
    for (int i = 0; i < n; i++)
        if (p[i].qty > 0 && (best == -1 || p[i].price > p[best].price)) best = i;
    if (best == -1) cout << "NONE\n";
    else cout << p[best].name << " @ " << fixed << setprecision(2)
              << p[best].price << " (" << p[best].qty << ")\n";
    // Parallel-arrays risk: sorting or swapping one array (say price) without
    // performing the identical swap in name[] and qty[] silently re-pairs
    // unrelated fields. A struct's fields cannot be separated by any swap.
    return 0;
}
```

**Explanation:** the struct-vs-parallel-arrays decision — the course's records module argued it in prose; here the student *implements the struct side and articulates the failure mode* of the alternative. The single index (`best`) walking all three fields together is the payoff visible in the code. *Distinct idea:* cohesion enforced by the type system.

---

### I-33 — Nested struct: Address in Student

**Difficulty:** ★★★ · **Topics:** structures, nesting, member access chains

Define `struct Address { string city; string phone; };` and `struct Student { string name; Address addr; };`. Read n (1–10) students as `name city phone` (no spaces within fields). Print a directory: each line `name — city — phone`.

**Input:** n, then n lines.
**Output:** n directory lines with ` — ` separators.
**Sample tests:** n=2 `Ayesha Lahore 0300-1234567` / `Bilal Karachi 0321-7654321` → `Ayesha — Lahore — 0300-1234567` / `Bilal — Karachi — 0321-7654321`
**Hints:** ① `s.addr.city` — member chains read left to right; ② reading nested members is the same as reading flat ones.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

struct Address { string city; string phone; };
struct Student { string name; Address addr; };

int main() {
    int n;
    cin >> n;
    Student s[10];
    for (int i = 0; i < n; i++)
        cin >> s[i].name >> s[i].addr.city >> s[i].addr.phone;
    for (int i = 0; i < n; i++)
        cout << s[i].name << " — " << s[i].addr.city
             << " — " << s[i].addr.phone << "\n";
    return 0;
}
```

**Explanation:** nesting models *belongs-to* — the address has no life outside its student. The member chain `s[i].addr.city` is the data's path made visible; the same structure returns as composition inside classes (OOP module). *Distinct idea:* containment chains.

---

### I-34 — enum-driven classifier function

**Difficulty:** ★★★ · **Topics:** structures, enums, functions, dispatch

Define `enum class Level { Fail, Pass, Good, Excellent };` and `Level classify(int marks)` (Fail <50, Pass <70, Good <85, else Excellent) plus `string asText(Level)`. Read three marks; print each classification.

**Input:** three integers 0–100.
**Output:** three words, one per line: `FAIL` `PASS` `GOOD` `EXCELLENT`.
**Sample tests:** `40 72 91` → `FAIL` / `GOOD` / `EXCELLENT`
**Hints:** ① enum class needs `Level::` qualification; ② asText is a switch over the enum.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;

enum class Level { Fail, Pass, Good, Excellent };

Level classify(int m) {
    if (m < 50) return Level::Fail;
    if (m < 70) return Level::Pass;
    if (m < 85) return Level::Good;
    return Level::Excellent;
}

string asText(Level l) {
    switch (l) {
        case Level::Fail:      return "FAIL";
        case Level::Pass:      return "PASS";
        case Level::Good:      return "GOOD";
        default:               return "EXCELLENT";
    }
}

int main() {
    for (int i = 0; i < 3; i++) {
        int m;
        cin >> m;
        cout << asText(classify(m)) << "\n";
    }
    return 0;
}
```

**Explanation:** enum as a *typed* classification (not magic ints), a function producing it, and a function rendering it — the pipeline `int → Level → string` is the records module's typed-pipeline idea in miniature. *Distinct idea:* typed classifications through functions.

---

### I-35 — Applied loop: hailstone printer with cap

**Difficulty:** ★★ · **Topics:** loops, safety bounds, applied sequences

Print the Collatz sequence for n (1…10⁶) but **stop early** if it exceeds 10¹⁵ or takes more than 1000 steps. Print the sequence space-separated, then `...` if truncated, else the step count.

**Input:** one integer n.
**Output:** the sequence line and either `...` or `steps: S`.
**Sample tests:** `6` → `6 3 10 5 16 8 4 2 1` / `steps: 8` · `27` → sequence begins `27 82 41 124 ...` and if it would pass 1000 steps, `...` (27 needs 111 — no truncation; invent a forced truncation by testing the guard logic)
**Hints:** ① two stopping conditions in one while; ② print the *start* value before the loop begins appending.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long n;
    cin >> n;
    cout << n;
    long long steps = 0;
    bool truncated = false;
    while (n != 1 && steps < 1000 && n <= 1000000000000000LL) {
        if (n % 2 == 0) n /= 2;
        else            n = 3 * n + 1;
        cout << " " << n;
        steps++;
    }
    if (n != 1) { cout << " ..."; truncated = true; }
    cout << "\n";
    if (!truncated) cout << "steps: " << steps << "\n";
    return 0;
}
```

**Explanation:** the same walk as Ba-06 wearing *safety gear* — step and magnitude caps — because unbounded exploration is a real-world hazard (the conjecture is unproven!). Guarded iteration is the honest engineering wrapper for mathematical loops. *Distinct idea:* bounded exploration.

---

### I-36 — Applied loop: range ledger with running balance

**Difficulty:** ★★ · **Topics:** loops, accumulators, formatted ledgers

Read n transactions (integer amounts, may be negative) then print a ledger: each line `i: amount balance` (i from 1), starting balance 0. End with `final: B`.

**Input:** n (1–100), then n integers (−10000…10000).
**Output:** n ledger lines + final line.
**Sample tests:** `4 100 -30 50 -200` → `1: 100 100` / `2: -30 70` / `3: 50 120` / `4: -200 -80` / `final: -80`
**Hints:** ① print running balance *after* adding; ② negative balances are legal here — no validation requested.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    int n;
    cin >> n;
    long long bal = 0;
    for (int i = 1; i <= n; i++) {
        int amt;
        cin >> amt;
        bal += amt;
        cout << i << ": " << amt << " " << bal << "\n";
    }
    cout << "final: " << bal << "\n";
    return 0;
}
```

**Explanation:** the ledger loop — state (balance) updated and *reported in the same iteration* — is the accounting shape behind the expense tracker and bank simulation projects. The i-from-1 indexing matches human ledger numbering, a deliberate choice to discuss. *Distinct idea:* state visible per step.

---

### I-37 — Applied loop: digit histogram line

**Difficulty:** ★★ · **Topics:** loops, counting, bounded ranges

Read n (1–100) integers, each 0–9. Print a histogram line for each digit 0–9 that appears: `digit: d ###...` where `#` repeats count times.

**Input:** n, then n integers (0–9).
**Output:** up to 9 lines.
**Sample tests:** `8 1 3 3 9 3 9 1 7` → `digit: 1 ##` / `digit: 3 ###` / `digit: 7 #` / `digit: 9 ##`
**Hints:** ① count into `cnt[10]` (I-09's tool); ② `string(cnt[d], '#')` renders each bar.
**Reference solution**

```cpp
#include <iostream>
#include <string>
using namespace std;
int main() {
    int n, cnt[10] = {0};
    cin >> n;
    for (int i = 0; i < n; i++) { int x; cin >> x; cnt[x]++; }
    for (int d = 0; d <= 9; d++)
        if (cnt[d] > 0) cout << "digit: " << d << " " << string(cnt[d], '#') << "\n";
    return 0;
}
```

**Explanation:** tally then render — the two-phase count-and-present split that every report generator follows. The bar is data turned into *visual* output; the same phase split drives the analytics labs. *Distinct idea:* count phase, render phase.

---

### I-38 — Applied loop: interleaved merge of digits

**Difficulty:** ★★★ · **Topics:** loops, digits, index arithmetic

Read two positive integers a and b. Interleave their digits — a's first digit, b's first digit, a's second, b's second — printing the resulting number. If one runs out, append the rest of the other.

**Input:** two integers 1…10⁹.
**Output:** one integer.
**Sample tests:** `123 4567` → `1425367` · `90 12` → `9102`
**Hints:** ① peel both from the *right* and the result builds reversed — easier to un-reverse at the end (Ba-03's tool); ② or extract digit counts first and walk from the left.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long a, b;
    cin >> a >> b;
    // Peel from the right into reversed results, then reverse each.
    long long ra = 0, rb = 0;
    int la = 0, lb = 0;
    while (a > 0) { ra = ra*10 + a % 10; a /= 10; la++; }
    while (b > 0) { rb = rb*10 + b % 10; b /= 10; lb++; }
    long long result = 0;
    int ia = la, ib = lb;              // digits remaining in each (reversed) number
    while (ia > 0 || ib > 0) {
        if (ia > 0) { result = result*10 + ra % 10; ra /= 10; ia--; }
        if (ib > 0) { result = result*10 + rb % 10; rb /= 10; ib--; }
    }
    cout << result << "\n";
    return 0;
}
```

**Explanation:** left-to-right interleaving via right-peel + un-reverse is the classic digit-gymnastics composition — Ba-03's builder, Ba-09's two-stream walk, and Ba-03's reverse combined. The `if` per stream handles unequal lengths without special cases. *Distinct idea:* stream interleave with exhaust-when-empty.

---

### I-39 — Applied loop: fare meter

**Difficulty:** ★★ · **Topics:** loops, tiered arithmetic, state

A taxi charges Rs 70 for the first 2 km (or part), then Rs 32 per additional km or part. Read a list of trip distances (km, decimals allowed) ending with `0`. Print each trip's fare, then `total: T`.

**Input:** distances (0.1–100.0), one per line, ending with 0.
**Output:** fare per trip (integer) then total.
**Sample tests:** `1.5 3 0` → `70` / `134` / `total: 204` (3 km → 70 + 1 extra "whole or part" km × 32 = 102)
**Hints:** ① fare = 70 + max(0, ceil(d − 2)) × 32; ② ceil from `<cmath>`; ③ the sentinel ends the loop but is not a trip.
**Reference solution**

```cpp
#include <iostream>
#include <iomanip>
#include <cmath>
using namespace std;
int main() {
    double d;
    long long total = 0;
    cout << fixed << setprecision(0);
    while (cin >> d && d != 0) {
        long long fare = 70;
        if (d > 2.0) fare += (long long)ceil(d - 2.0) * 32;
        cout << fare << "\n";
        total += fare;
    }
    cout << "total: " << total << "\n";
    return 0;
}
```

**Explanation:** tiered fare with "or part" semantics — ceil on the excess (B-29's tool) inside a sentinel loop (B-19's shape), plus a running total (the ledger pattern). Three proven pieces composed into one business rule. *Distinct idea:* business rules from composed pieces.

---

### I-40 — Applied loop: staircase summary with milestones

**Difficulty:** ★★★ · **Topics:** loops, thresholds, event reporting

Read n savings deposits (integers) and a goal g. Print a running total after each deposit; each time the cumulative total *reaches or passes* g for the first time, also print `GOAL at deposit k`. At the end print `saved: T` and `goal: reached` or `goal: unmet`.

**Input:** g (1–10⁶), n (1–100), then n integers (1–10000).
**Output:** as specified.
**Sample tests:** g=500, n=4, deposits `200 250 100 50` → `after 1: 200` / `after 2: 450` / `after 3: 550` / `GOAL at deposit 3` / `after 4: 600` / `saved: 600` / `goal: reached`
**Hints:** ① a boolean `goalSeen` makes the milestone fire exactly once; ② print order: running line, then milestone if it just crossed.
**Reference solution**

```cpp
#include <iostream>
using namespace std;
int main() {
    long long g, bal = 0;
    int n;
    bool goalSeen = false;
    cin >> g >> n;
    for (int i = 1; i <= n; i++) {
        int d;
        cin >> d;
        bal += d;
        cout << "after " << i << ": " << bal << "\n";
        if (!goalSeen && bal >= g) {
            cout << "GOAL at deposit " << i << "\n";
            goalSeen = true;
        }
    }
    cout << "saved: " << bal << "\n"
         << "goal: " << (goalSeen ? "reached" : "unmet") << "\n";
    return 0;
}
```

**Explanation:** a one-shot milestone inside a running-total loop — the `goalSeen` latch converts a "crossing" event into exactly one report. Event-latching inside accumulation loops is the savings/goal pattern the expense tracker uses; note the *order* of print versus latch matters and the sample pins it. *Distinct idea:* latched events in accumulation.

---

**Tier check:** 40 problems · I-01–I-40 · update [the checklist](index.md), then take on [advanced.md](advanced.md).
