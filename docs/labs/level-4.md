---
title: "Level 4 — Advanced Labs (L4-25 to L4-34)"
description: "Ten advanced lab scenarios on algorithms, string processing, file I/O, pointers, records and classes — every lab with all fifteen parts."
---

# Level 4 — Advanced

> [← Labs home](index.md) · [← Level 3](level-3.md) · **Units first: 10–15** — searching/sorting, strings, files, pointers, records, and classes are assumed.

---

## L4-25 — The Sorting Desk

### Scenario
The examination cell sorts result sheets by different keys: by marks descending (merit list), by name ascending (alphabetical roll), and by ID. The desk applies three elementary sorts by hand — the point is watching them work, not the library's `sort`.

### Problem statement
Read `n` students (2–25): name (one word) and marks (0–100). Store as parallel vectors. Provide three sort modes chosen from a menu: bubble (marks descending), selection (name ascending), insertion (marks descending). Each mode prints the number of comparisons and swaps it used, then the sorted list.

### Learning objectives
- implement the three elementary sorts on parallel collections
- move *two aligned elements* together in every swap
- count and compare the algorithms' work on identical data

### Requirements
1. All three sorts as functions taking the vectors **by value** (so each mode sorts its own copy and counts are comparable).
2. Bubble sort stops early when a pass makes no swap.
3. Selection sort finds the minimum name (ascending) by `compare > 0`.
4. Output per mode: comparisons, swaps, then the sorted list. The merit list must be identical across the two descending sorts.

### Input
`n`, then per student: name, marks. Then the mode menu (1–3, 0 to quit — the menu may loop).

### Output
Per chosen mode: `Bubble: 12 comparisons, 4 swaps` (etc.) then the list lines.

### Constraints
- Name comparison is `<`/`>` on `std::string` (lexicographic — the strings module's rule).
- Every swap swaps *both* the key vector and the aligned payload vector.

### Example
Input: 3 students (`Sara 82`, `Ali 91`, `Zara 67`), mode 1 → `Bubble: 3 comparisons, 2 swaps`, list: Ali 91, Sara 82, Zara 67.

### Test cases
| Input | Expected |
| --- | --- |
| the example, mode 1 | sorted descending, counts printed |
| same data, mode 3 | same order as mode 1 (different counts likely) |
| same data, mode 2 | Ali, Sara, Zara ascending by name |
| already-sorted input, mode 1 | early exit: n−1 comparisons, 0 swaps |
| reverse-sorted input, mode 1 | maximum swaps |

### Student tasks
1. Write the read loop into parallel vectors.
2. Write `bubbleByMarksDesc(vector<int>, vector<string>)` with the early-exit flag and the swap counter.
3. Write `selectionByNameAsc` and `insertionByMarksDesc` with counters.
4. Write the menu loop; call each sort on copies; print counts and lists.

### Hints
1. The aligned swap is three lines every time: temp-marks, temp-name, assign both — one missing line is the classic parallel-vector bug.
2. Bubble's early exit: a `bool swapped = false;` per pass — checked after the inner loop.
3. Insertion's shifting moves *both* arrays' elements — shift marks and names in the same while loop.

### Extension challenges
1. Print each pass's state for a 5-element sort (the trace-table view).
2. Add a count of comparisons that were *equal* (relevant to stability — observe which sorts preserve name order for equal marks).

### Complete solution

```cpp
// L4-25 — The Sorting Desk
// Compile: g++ -std=c++17 -Wall -Wextra L4-25.cpp -o L4-25
#include <iostream>
#include <string>
#include <vector>
using namespace std;

void printRoster(const vector<string>& names, const vector<int>& marks) {
    for (size_t i = 0; i < names.size(); ++i)
        cout << "  " << names[i] << " " << marks[i] << "\n";
}

void bubbleByMarksDesc(vector<int> marks, vector<string> names) {
    long long comparisons = 0, swaps = 0;
    size_t n = marks.size();
    for (size_t pass = 0; pass + 1 < n; ++pass) {
        bool swapped = false;
        for (size_t i = 0; i + 1 < n - pass; ++i) {
            ++comparisons;
            if (marks[i] < marks[i + 1]) {              // descending: small drifts right
                swap(marks[i], marks[i + 1]);
                swap(names[i], names[i + 1]);           // the payload moves too — always
                ++swaps;
                swapped = true;
            }
        }
        if (!swapped) break;                            // early exit: sorted already
    }
    cout << "Bubble: " << comparisons << " comparisons, " << swaps << " swaps\n";
    printRoster(names, marks);
}

void selectionByNameAsc(vector<int> marks, vector<string> names) {
    long long comparisons = 0, swaps = 0;
    size_t n = names.size();
    for (size_t i = 0; i + 1 < n; ++i) {
        size_t minIdx = i;
        for (size_t j = i + 1; j < n; ++j) {
            ++comparisons;
            if (names[j] < names[minIdx]) minIdx = j;   // ascending by name
        }
        if (minIdx != i) {
            swap(marks[i], marks[minIdx]);
            swap(names[i], names[minIdx]);
            ++swaps;
        }
    }
    cout << "Selection: " << comparisons << " comparisons, " << swaps << " swaps\n";
    printRoster(names, marks);
}

void insertionByMarksDesc(vector<int> marks, vector<string> names) {
    long long comparisons = 0, swaps = 0;
    for (size_t i = 1; i < marks.size(); ++i) {
        int keyM = marks[i];
        string keyN = names[i];
        size_t j = i;
        while (j > 0 && (++comparisons, marks[j - 1] < keyM)) {   // descending
            marks[j] = marks[j - 1];                    // shift BOTH arrays
            names[j] = names[j - 1];
            ++swaps;
            --j;
        }
        marks[j] = keyM;
        names[j] = keyN;
    }
    cout << "Insertion: " << comparisons << " comparisons, " << swaps << " swaps\n";
    printRoster(names, marks);
}

int main() {
    int n;
    cout << "Number of students: ";
    cin >> n;
    if (n < 2 || n > 25) { cout << "Invalid count\n"; return 1; }

    vector<string> names;
    vector<int> marks;
    for (int i = 0; i < n; ++i) {
        string name;
        int m;
        cout << "Student " << (i + 1) << " name and marks: ";
        cin >> name >> m;
        while (m < 0 || m > 100) { cout << "Marks are 0-100: "; cin >> m; }
        names.push_back(name);
        marks.push_back(m);
    }

    int mode;
    do {
        cout << "\n1 Bubble (marks desc) · 2 Selection (name asc) · 3 Insertion (marks desc) · 0 Quit: ";
        cin >> mode;
        if (mode == 1)      bubbleByMarksDesc(marks, names);
        else if (mode == 2) selectionByNameAsc(marks, names);
        else if (mode == 3) insertionByMarksDesc(marks, names);
        else if (mode != 0) cout << "Invalid mode\n";
    } while (mode != 0);
    return 0;
}
```

### Solution explanation
Sorting by value parameters is the lab's safety device: each mode sorts its *own copy*, so the counts and the "same order from two algorithms" comparison are honest, and the original data survives the menu loop. The aligned-swap discipline appears in all three sorts — bubble and selection swap two pairs; insertion shifts two arrays in one while loop — the omission of either half is the parallel-collection bug this lab is designed to expose. The early-exit flag makes bubble's best case observable (test 4), and the counters turn the three algorithms into measurable objects rather than abstractions — the Algorithms module's comparison table, populated with the student's own numbers.

### Testing checklist
- [ ] All five test cases pass
- [ ] Modes 1 and 3 produce identical orders on identical data
- [ ] Sorted input exits bubble after one pass
- [ ] The original vectors are unchanged after every mode (re-run mode 2 after mode 1)

---

## L4-26 — The Dictionary Lookups

### Scenario
The linguistics society maintains a sorted word list (a mini-dictionary) and needs a lookup desk: exact search (fast binary), and a "first word ≥ prefix" query for autocomplete.

### Problem statement
Read `n` words (2–100, already sorted, one per line). Then process queries until the sentinel `.`: (a) `? word` — report found at position or `not found`, using binary search; (b) `# prefix` — report the first word that is ≥ prefix (lexicographic) and its position, or `none`. Count comparisons for each query.

### Learning objectives
- implement binary search with the lo/hi/mid discipline
- compare strings lexicographically as the search's ordering
- adapt binary search into a lower-bound query

### Requirements
1. Binary search function: `int binarySearch(const vector<string>&, const string&, long long& comparisons)`.
2. Lower-bound function: `int firstAtLeast(...)` with the same signature shape.
3. Query line format: a `?` or `#` then a space then the word/prefix; `.` alone ends the session.
4. Report comparisons per query: `found at position P (Q comparisons)`.

### Input
`n`, then n sorted words; then query lines until `.`.

### Output
One response line per query.

### Constraints
- The input's sortedness is a *precondition* — the program may verify it and refuse unsorted input (`Input not sorted`), because binary search on unsorted data answers silently wrong (the algorithms module's rule).
- Words are lowercase, no spaces.

### Example
Dictionary: `apple banana cherry date`. Query `? cherry` → `found at position 3 (2 comparisons)`. Query `# cas` → `first at least "cas": cherry (position 3)`.

### Test cases
| Input | Expected |
| --- | --- |
| the example queries | the responses above |
| `? date` (last) | found, ~2 comparisons |
| `? aardvark` | not found |
| `# zzz` | none |
| `# banana` | banana itself (position 2) |
| unsorted input refused | Input not sorted |

### Student tasks
1. Write `binarySearch` with lo/hi/mid and the comparison counter.
2. Write the sortedness check (adjacent-pair scan).
3. Write `firstAtLeast`: when `mid < target`, move lo up; else hi down *including mid* (the boundary variant).
4. Write the query loop with parsing and reporting.

### Hints
1. `mid = lo + (hi - lo) / 2` — the overflow-safe midpoint.
2. The lower-bound differs from exact search in one line: the `==` case joins the "go left" side (`hi = mid`), and the answer is `lo` when the loop ends.
3. String comparison `<` is lexicographic — that is the entire ordering the search needs.

### Extension challenges
1. Add a `*` query: count occurrences of a word (the dictionary has duplicates) — adapt the found-mid to walk both directions or recurse.
2. Report the position where a missing word *would* be inserted (compare with `firstAtLeast`'s result).

### Complete solution

```cpp
// L4-26 — The Dictionary Lookups
// Compile: g++ -std=c++17 -Wall -Wextra L4-26.cpp -o L4-26
#include <iostream>
#include <string>
#include <vector>
using namespace std;

int binarySearch(const vector<string>& words, const string& target, long long& comparisons) {
    int lo = 0, hi = static_cast<int>(words.size()) - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        ++comparisons;
        if (words[mid] == target) return mid;
        if (words[mid] < target) lo = mid + 1;
        else                     hi = mid - 1;
    }
    return -1;
}

int firstAtLeast(const vector<string>& words, const string& target, long long& comparisons) {
    int lo = 0, hi = static_cast<int>(words.size());
    while (lo < hi) {
        int mid = lo + (hi - lo) / 2;
        ++comparisons;
        if (words[mid] < target) lo = mid + 1;
        else                     hi = mid;        // mid stays in play: the boundary
    }
    return lo;                                    // first index with words[lo] >= target
}

bool isSorted(const vector<string>& words) {
    for (size_t i = 1; i < words.size(); ++i)
        if (words[i - 1] > words[i]) return false;
    return true;
}

int main() {
    int n;
    cout << "How many words: ";
    cin >> n;
    if (n < 2 || n > 100) { cout << "Invalid count\n"; return 1; }

    vector<string> words(static_cast<size_t>(n));
    for (int i = 0; i < n; ++i) cin >> words[static_cast<size_t>(i)];

    if (!isSorted(words)) { cout << "Input not sorted\n"; return 1; }

    cout << "Queries (? word, # prefix, . to end):\n";
    string line;
    while (cin >> line && line != ".") {
        string target;
        cin >> target;
        long long comparisons = 0;

        if (line == "?") {
            int pos = binarySearch(words, target, comparisons);
            if (pos == -1)
                cout << target << ": not found (" << comparisons << " comparisons)\n";
            else
                cout << target << ": found at position " << (pos + 1)
                     << " (" << comparisons << " comparisons)\n";
        } else if (line == "#") {
            int pos = firstAtLeast(words, target, comparisons);
            if (pos >= static_cast<int>(words.size()))
                cout << "first at least \"" << target << "\": none\n";
            else
                cout << "first at least \"" << target << "\": " << words[static_cast<size_t>(pos)]
                     << " (position " << (pos + 1) << ")\n";
        } else {
            cout << "Unknown query\n";
        }
    }
    return 0;
}
```

### Solution explanation
The two searches are one idea and one delta: exact search leaves `hi = mid − 1` and answers at `==`; the lower-bound variant *keeps mid in play* (`hi = mid`) and answers at loop end (`lo`), which converts "not found" from a failure into a position. The comparison counter makes the algorithms module's O(log n) claim visible — a 100-word dictionary answers in ≤ 7 comparisons, and the student sees it. The sortedness precondition is enforced, not assumed: the algorithms module's "silent wrong answers on unsorted data" warning becomes a runtime refusal here.

### Testing checklist
- [ ] All six test cases pass
- [ ] Comparisons never exceed ⌈log₂ n⌉ + 1
- [ ] The lower-bound query answers "none" beyond the last word
- [ ] Unsorted input is refused before any query is accepted

---

## L4-27 — The Recursion Workshop

### Scenario
The mathematics society wants a demonstration desk for recursion: the visitor types a number and sees a recursive computation with its call structure explained — the classic tower from the algorithms module, made interactive.

### Problem statement
Provide a recursive desk with three commands until `quit`: `fact n` — prints n! (0–20) with the call chain; `fib n` — prints fib(n) (0–30); `digits n` — prints the digit sum of n (≥ 0) *recursively*. Each command also prints its call count.

### Learning objectives
- write recursive functions with explicit base and recursive cases
- count recursive calls to feel exponential vs linear growth
- reason about the call stack from the call-count evidence

### Requirements
1. `fact`: base `n <= 1` returns 1; recursive `n * fact(n-1)`; `long long` (20! fits).
2. `fib`: base `n <= 1` returns n; the call counter exposes the overlap (fib(25) makes ~243k calls).
3. `digits`: base `n < 10` returns n; recursive `n % 10 + digits(n / 10)`.
4. Call counts print per command; the command loop continues until `quit`.

### Input
Command lines: `fact 5`, `fib 10`, `digits 9876`, `quit`.

### Output
Per command: the value and the call count (`fact(5) = 120 (5 calls)`).

### Constraints
- fact argument outside 0–20 → `Out of range`; fib 0–30; digits n ≥ 0.
- No loops inside the three functions — recursion only.

### Example
`fact 5` → `fact(5) = 120 (5 calls)`; `digits 9876` → `digitSum(9876) = 30 (4 calls)`.

### Test cases
| Input | Expected |
| --- | --- |
| fact 5, quit | 120, 5 calls |
| fact 0 | 1, 1 call (base case only) |
| fib 10 | 55, 177 calls |
| digits 9876 | 30, 4 calls |
| fact 21 | Out of range |

### Student tasks
1. Write the three recursive functions, each with a counter parameter (by reference).
2. Verify the call-count formulas by hand for n = 4 (fact: n; fib: 2·fib(n+1)−1).
3. Write the command loop with argument validation.
4. Predict fib(25)'s call count before printing it.

### Hints
1. The counter travels as `long long& calls` — increment at function entry.
2. fib's explosion is the *overlap*: the call tree repeats subtrees — the counter is the proof.
3. digits' recursion depth is the digit count — 9876 makes exactly 4 calls.

### Extension challenges
1. Add `pow b e` (recursive exponentiation, e ≥ 0) with call count = e + 1.
2. Add a memoized fib (an array of known answers) and compare call counts for fib(25).

### Complete solution

```cpp
// L4-27 — The Recursion Workshop
// Compile: g++ -std=c++17 -Wall -Wextra L4-27.cpp -o L4-27
#include <iostream>
#include <string>
using namespace std;

long long fact(int n, long long& calls) {
    ++calls;
    if (n <= 1) return 1;
    return n * fact(n - 1, calls);
}

long long fib(int n, long long& calls) {
    ++calls;
    if (n <= 1) return n;
    return fib(n - 1, calls) + fib(n - 2, calls);
}

int digitSum(long long n, long long& calls) {
    ++calls;
    if (n < 10) return static_cast<int>(n);
    return static_cast<int>(n % 10) + digitSum(n / 10, calls);
}

int main() {
    string command;
    cout << "Command (fact/fib/digits/quit): ";
    while (cin >> command && command != "quit") {
        long long calls = 0;

        if (command == "fact") {
            int n;
            cin >> n;
            if (n < 0 || n > 20) cout << "Out of range\n";
            else cout << "fact(" << n << ") = " << fact(n, calls)
                      << " (" << calls << " calls)\n";
        } else if (command == "fib") {
            int n;
            cin >> n;
            if (n < 0 || n > 30) cout << "Out of range\n";
            else cout << "fib(" << n << ") = " << fib(n, calls)
                      << " (" << calls << " calls)\n";
        } else if (command == "digits") {
            long long n;
            cin >> n;
            if (n < 0) cout << "Out of range\n";
            else cout << "digitSum(" << n << ") = " << digitSum(n, calls)
                      << " (" << calls << " calls)\n";
        } else {
            cout << "Unknown command\n";
        }
        cout << "Command (fact/fib/digits/quit): ";
    }
    return 0;
}
```

### Solution explanation
The three functions are the algorithms module's canonical recursions, now *instrumented*: the by-reference call counter converts the call-stack story into numbers the student can check by hand (fact: exactly n calls; digits: the digit count; fib: the exponential overlap). The lab's design point is the contrast — three recursions of identical shape (base case, shrink, combine) with wildly different costs, which is the honest introduction to "recursion is a control structure, not a performance strategy." Argument ranges guard both overflow (21! exceeds `long long`... 20! = 2.43×10¹⁸ fits) and patience (fib 30 ≈ 1.7M calls, still instant; fib 90 would be geological).

### Testing checklist
- [ ] All five test cases pass
- [ ] fact(0) makes exactly 1 call (the base case is a real call)
- [ ] digitSum's call count equals the digit count
- [ ] fib's counts grow conspicuously faster than linear

---

## L4-28 — The Text Toolkit Pro

### Scenario
The writing centre upgrades the Word Wizard into a toolkit for one-file analysis: word splitting, case folding, palindrome detection, and vowel-consonant profiling — as callable functions over `std::string`.

### Problem statement
Implement and demonstrate five functions over a read line of text: (a) `countWords` (the word-edge algorithm), (b) `toLowercase` (returns a folded copy), (c) `isPalindrome` (letters only, case-insensitive), (d) `countVowelsAndConsonants` (by-reference pair), (e) `reverseWords` (word order reversed, words intact). `main` reads the line, then prints all five results.

### Learning objectives
- design string functions with const-correct signatures
- filter non-letters during analysis (the cctype guard)
- reverse word order without reversing characters

### Requirements
1. `bool isPalindrome(const string&)` — ignores case and every non-letter; a letterless string is a palindrome (vacuously).
2. `void countVowelsAndConsonants(const string&, int& vowels, int& consonants)` — letters only.
3. `string reverseWords(const string&)` — splits on whitespace, rejoins reversed; multiple spaces collapse to one in the output.
4. The demonstration prints each result on a labelled line.

### Input
One line (may be empty).

### Output
Five labelled lines (words, lowercase, palindrome yes/no, vowels/consonants, reversed words).

### Constraints
- All classification goes through `<cctype>` with the `unsigned char` cast.
- Empty line: 0 words, palindrome yes (vacuous), 0/0, empty reversed.

### Example
Input: `Madam, I'm Adam` → words 3, lowercase `madam, i'm adam`, palindrome yes (madamimadam), vowels 4, consonants 7, reversed `Adam I'm Madam,`.

### Test cases
| Input | Expected |
| --- | --- |
| Madam, I'm Adam | the example output |
| (empty line) | 0, empty, yes, 0/0, empty |
| racecar | 1 word, palindrome yes |
| hello world | palindrome no, 2 words, reversed `world hello` |
| 12321 | palindrome yes (digits ignored — letters only rule), 1 word |

### Student tasks
1. Write `countWords` and `toLowercase` (warm-ups from earlier modules).
2. Write `isPalindrome` with the two-cursor walk (front/back, skipping non-letters).
3. Write `countVowelsAndConsonants` with by-reference outputs.
4. Write `reverseWords` using the split-then-rejoin pattern.

### Hints
1. Two cursors: `i` from the front, `j` from the back; advance each past non-letters; compare folded characters; meet in the middle → palindrome.
2. `reverseWords`: collect words into a `vector<string>` (L3-20's `indexOf` world), then join from the end.
3. The vacuous-palindrome rule falls out of the cursor walk naturally — verify with the digit-only test case.

### Extension challenges
1. Add `capitaliseWords` (first letter of each word uppercase, rest lower).
2. Add a word-frequency line using the L3-20 technique (the toolkit grows toward the mini-project).

### Complete solution

```cpp
// L4-28 — The Text Toolkit Pro
// Compile: g++ -std=c++17 -Wall -Wextra L4-28.cpp -o L4-28
#include <iostream>
#include <string>
#include <vector>
#include <cctype>
using namespace std;

int countWords(const string& text) {
    int words = 0;
    bool inWord = false;
    for (char ch : text) {
        if (isspace(static_cast<unsigned char>(ch))) inWord = false;
        else if (!inWord) { ++words; inWord = true; }
    }
    return words;
}

string toLowercase(const string& text) {
    string out = text;
    for (char& ch : out)
        ch = static_cast<char>(tolower(static_cast<unsigned char>(ch)));
    return out;
}

bool isPalindrome(const string& text) {
    int i = 0, j = static_cast<int>(text.size()) - 1;
    while (i < j) {
        while (i < j && !isalpha(static_cast<unsigned char>(text[static_cast<size_t>(i)]))) ++i;
        while (i < j && !isalpha(static_cast<unsigned char>(text[static_cast<size_t>(j)]))) --j;
        if (i < j) {
            char a = static_cast<char>(tolower(static_cast<unsigned char>(text[static_cast<size_t>(i)])));
            char b = static_cast<char>(tolower(static_cast<unsigned char>(text[static_cast<size_t>(j)])));
            if (a != b) return false;
            ++i; --j;
        }
    }
    return true;
}

void countVowelsAndConsonants(const string& text, int& vowels, int& consonants) {
    vowels = 0; consonants = 0;
    for (char ch : text) {
        unsigned char u = static_cast<unsigned char>(ch);
        if (isalpha(u)) {
            char lower = static_cast<char>(tolower(u));
            if (lower=='a'||lower=='e'||lower=='i'||lower=='o'||lower=='u') ++vowels;
            else ++consonants;
        }
    }
}

string reverseWords(const string& text) {
    vector<string> words;
    string current;
    for (char ch : text) {
        if (isspace(static_cast<unsigned char>(ch))) {
            if (!current.empty()) { words.push_back(current); current.clear(); }
        } else {
            current += ch;
        }
    }
    if (!current.empty()) words.push_back(current);

    string out;
    for (size_t i = words.size(); i > 0; --i) {
        out += words[i - 1];
        if (i > 1) out += " ";
    }
    return out;
}

int main() {
    cout << "Enter a line: ";
    string line;
    getline(cin, line);

    int vowels = 0, consonants = 0;
    countVowelsAndConsonants(line, vowels, consonants);

    cout << "Words: " << countWords(line) << "\n";
    cout << "Lowercase: " << toLowercase(line) << "\n";
    cout << "Palindrome: " << (isPalindrome(line) ? "yes" : "no") << "\n";
    cout << "Vowels: " << vowels << ", consonants: " << consonants << "\n";
    cout << "Reversed: " << reverseWords(line) << "\n";
    return 0;
}
```

### Solution explanation
The five functions are a survey of string-processing shapes: the word-edge counter, the copy-then-mutate fold, the two-cursor filter-walk (the lab's centrepiece — skipping non-letters *while* comparing, so punctuation never breaks the symmetry), the by-reference pair return, and the split-rejoin rebuild. The palindrome walk's vacuous-true outcome needs no special case — the cursors meet immediately on letterless input — which is the test table's digit-only probe. Signatures are const-correct throughout: every function that reads takes `const string&`; the two that produce take nothing and return values; the one that reports through parameters says so in its signature.

### Testing checklist
- [ ] All five test cases pass
- [ ] Punctuation never affects the palindrome verdict
- [ ] Multiple spaces collapse in `reverseWords` output
- [ ] The empty line produces sensible zeros, not crashes

---

## L4-29 — The Persistent Gradebook

### Scenario
A tutor's gradebook must survive the program: marks are saved to `gradebook.csv` and reloaded next session. The desk loads, reports, appends, and saves.

### Problem statement
Implement a CSV gradebook `name,marks` (one record per line). The program: loads the file if present (reporting how many records); prints a report (count, average, top student); asks for new students until an empty name; saves the *whole* book back. Handle: missing file (start empty), malformed lines (skip with a count), and the empty-book save (creating a valid empty file).

### Learning objectives
- read structured CSV records with the Files module's discipline
- distinguish missing file from empty file
- round-trip data through save/load with a stated format contract

### Requirements
1. Format contract (in a comment at both read and write): `name,marks` — name contains no commas; marks 0–100.
2. Load: missing file → start empty with a note; malformed line → skip, count, report at the end.
3. Append loop: empty name ends input; marks validated 0–100.
4. Save writes every record (old + new) in the same format; print the saved count.

### Input
File `gradebook.csv` (optional), then interactive appends.

### Output
Load summary, the report block, the save confirmation.

### Constraints
- The read loop uses `getline` for the whole line, then splits (the files module's CSV strategy).
- `stoi`/`stod` failures are caught and counted as malformed lines.

### Example
`gradebook.csv` containing `Aisha,82\nBilal,45\n` →
`Loaded 2 records`, report (avg 63.50, top Aisha), append `Sara 67`, `Saved 3 records`.

### Test cases
| Scenario | Expected |
| --- | --- |
| file with 2 valid records | loaded 2, correct report |
| no file | `No existing gradebook — starting empty` |
| file with one malformed line (`Bob,abc`) | loaded skips it, `Skipped 1 malformed line` |
| append 2 then empty name | both appended; save count includes them |
| empty book save | `Saved 0 records`, file exists and is empty |

### Student tasks
1. Write `loadBook(path, vector<string>&, vector<int>&, int& skipped)` with the open-check ritual.
2. Write the report block (count, average, top — reuse the L3-17 patterns).
3. Write the append loop with validation.
4. Write `saveBook` with the same format contract; assemble `main`.

### Hints
1. Line split: find the last comma? No — the *first* comma (names have no commas by contract; the last-comma trick is for fields that do).
2. `stoi` inside a `try` — `invalid_argument` and `out_of_range` both mean "malformed line" here.
3. Save reopens with `ofstream` (truncating — correct: the file is rewritten whole) and writes all records.

### Extension challenges
1. Add a third field (assignment average) and migrate the contract — update read, write, and the report together.
2. Add a `delete name` command before save (rewrite-without-the-record is the same save).

### Complete solution

```cpp
// L4-29 — The Persistent Gradebook
// Compile: g++ -std=c++17 -Wall -Wextra L4-29.cpp -o L4-29
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <stdexcept>
#include <iomanip>
using namespace std;

// Format contract: "name,marks" per line; name has no commas; marks 0-100.
// This comment governs BOTH loadBook and saveBook — change them together.

void loadBook(const string& path, vector<string>& names, vector<int>& marks, int& skipped) {
    ifstream in(path);
    if (!in) return;                       // missing file: caller starts empty

    string line;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t comma = line.find(',');
        if (comma == string::npos) { ++skipped; continue; }
        try {
            string name = line.substr(0, comma);
            int m = stoi(line.substr(comma + 1));
            if (m < 0 || m > 100) { ++skipped; continue; }
            names.push_back(name);
            marks.push_back(m);
        } catch (const exception&) {
            ++skipped;                      // stoi refused: malformed line
        }
    }
}

void saveBook(const string& path, const vector<string>& names, const vector<int>& marks) {
    ofstream out(path);                     // truncating: the book is rewritten whole
    if (!out) { cerr << "saveBook: cannot open " << path << "\n"; return; }
    for (size_t i = 0; i < names.size(); ++i)
        out << names[i] << "," << marks[i] << "\n";
}

int main() {
    const string PATH = "gradebook.csv";
    vector<string> names;
    vector<int> marks;
    int skipped = 0;

    loadBook(PATH, names, marks, skipped);
    if (skipped > 0) cout << "Skipped " << skipped << " malformed line(s)\n";
    if (names.empty()) cout << "No existing gradebook — starting empty\n";

    cout << fixed << setprecision(2);
    if (!names.empty()) {
        long long total = 0;
        size_t top = 0;
        for (size_t i = 0; i < names.size(); ++i) {
            total += marks[i];
            if (marks[i] > marks[top]) top = i;
        }
        cout << "Records: " << names.size() << ", average: " << static_cast<double>(total) / names.size()
             << ", top: " << names[top] << " (" << marks[top] << ")\n";
    }

    cout << "\nNew students (empty name to finish):\n";
    string name;
    cout << "Name: ";
    getline(cin, name);                      // clear the newline left by any prior >>... none here; getline is first
    while (!name.empty()) {
        int m;
        cout << "Marks: ";
        cin >> m;
        while (m < 0 || m > 100) { cout << "Marks are 0-100: "; cin >> m; }
        names.push_back(name);
        marks.push_back(m);
        cout << "Name: ";
        cin.ignore(1000, '\n');              // drop the newline the >> left
        getline(cin, name);
    }

    saveBook(PATH, names, marks);
    cout << "Saved " << names.size() << " records\n";
    return 0;
}
```

### Solution explanation
The format contract lives in a comment above *both* functions that honour it — the files module's rule that the contract is documentation adjacent to code, changed only in the same edit. Loading separates three failure modes cleanly: missing file (the open-check returns, the caller starts empty), malformed lines (the `stoi` catch counts them without stopping), and out-of-range marks (a policy refusal counted the same). The save is a *whole-file rewrite* — the simplest correct persistence — and the getline/`>>` mixing dance appears in the append loop exactly as the IO module taught: the `cin.ignore` after `>>` before the next `getline`.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] A malformed line never aborts the load
- [ ] The saved file reloads byte-identically (run twice, compare)
- [ ] The empty book still creates the file

---

## L4-30 — The Library Ledger

### Scenario
The departmental library records loans in `loans.csv`: `title,member,daysOnLoan`. The librarian needs overdue detection (over 14 days), per-member load, and the ledger's statistics — from a file, not a console batch.

### Problem statement
Load `loans.csv` (the program creates it with sample data if missing). Report: total loans, the longest loan (title and days), all loans over 14 days, loans per member (first-appearance order), and the average loan length. Then append one new loan from input and save.

### Learning objectives
- run multi-report analysis over file-loaded records
- aggregate by a string key without `map` (parallel vectors, L3-20's pattern)
- persist appended records with the same contract

### Requirements
1. Contract: `title,member,days` — titles/members contain no commas; days ≥ 0.
2. Missing file → write four sample loans, then load them (the program seeds its own data).
3. Overdue list: `title (member) — N days` per line; none → `No overdue loans`.
4. Per-member lines in first-appearance order; the append asks title, member, days and saves the whole ledger.

### Input
`loans.csv` (optional), then one interactive append.

### Output
The five report blocks, then the save confirmation.

### Constraints
- Malformed lines are skipped and counted (the L4-29 ritual, reused).
- The per-member aggregation is the manual parallel-vector tally — no `map`.

### Example
Seed data yields 4 loans; a member with 2 loans prints one line `Aisha: 2`; average over the seed is (3+21+7+14)/4 = 11.25 days.

### Test cases
| Scenario | Expected |
| --- | --- |
| seeded file, no overdue beyond seed | overdue block lists exactly the >14 loans |
| append `C++ Primer,Bilal,30` then save | saved 5; Bilal's member line appears |
| file with a malformed line | skipped with count; reports still correct |
| all loans ≤ 14 | `No overdue loans` |
| empty title field line (`,Aisha,3`) | malformed — skipped (empty title) |

### Student tasks
1. Write the seed-and-load path (create file if missing, then load).
2. Write the five reports over the loaded vectors (longest, overdue filter, per-member tally, average).
3. Write the append and save.
4. Assemble `main` with the open-check discipline.

### Hints
1. The per-member tally is L3-20's `indexOf`-then-increment pattern over names — reuse the function shape.
2. Days parse with `stoi` inside the same try/catch as the CSV split.
3. "Longest" uses the position-tracking max (L2-15's pattern) over the days vector.

### Extension challenges
1. Add a `return title` command: rewrite the file without that loan (search + save).
2. Sort the overdue list by days descending before printing.

### Complete solution

```cpp
// L4-30 — The Library Ledger
// Compile: g++ -std=c++17 -Wall -Wextra L4-30.cpp -o L4-30
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdexcept>
#include <iomanip>
using namespace std;

// Format contract: "title,member,days" per line; no commas inside fields; days >= 0.

void seedIfMissing(const string& path) {
    ifstream probe(path);
    if (probe) return;
    ofstream out(path);
    out << "Clean Code,Aisha,3\n";
    out << "Algorithms,Bilal,21\n";
    out << "C++ Primer,Aisha,7\n";
    out << "Discrete Maths,Sara,14\n";
}

bool loadLedger(const string& path, vector<string>& titles, vector<string>& members,
                vector<int>& days, int& skipped) {
    ifstream in(path);
    if (!in) return false;
    string line;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        if (c1 == string::npos) { ++skipped; continue; }
        size_t c2 = line.find(',', c1 + 1);
        if (c2 == string::npos) { ++skipped; continue; }
        try {
            string title  = line.substr(0, c1);
            string member = line.substr(c1 + 1, c2 - c1 - 1);
            int d = stoi(line.substr(c2 + 1));
            if (title.empty() || member.empty() || d < 0) { ++skipped; continue; }
            titles.push_back(title);
            members.push_back(member);
            days.push_back(d);
        } catch (const exception&) {
            ++skipped;
        }
    }
    return true;
}

void saveLedger(const string& path, const vector<string>& titles,
                const vector<string>& members, const vector<int>& days) {
    ofstream out(path);
    for (size_t i = 0; i < titles.size(); ++i)
        out << titles[i] << "," << members[i] << "," << days[i] << "\n";
}

int indexOf(const vector<string>& v, const string& target) {
    for (size_t i = 0; i < v.size(); ++i)
        if (v[i] == target) return static_cast<int>(i);
    return -1;
}

int main() {
    const string PATH = "loans.csv";
    const int OVERDUE_LIMIT = 14;

    seedIfMissing(PATH);

    vector<string> titles, members;
    vector<int> days;
    int skipped = 0;
    loadLedger(PATH, titles, members, days, skipped);
    if (skipped > 0) cout << "Skipped " << skipped << " malformed line(s)\n";

    cout << "Loans on file: " << titles.size() << "\n";

    size_t longest = 0;
    for (size_t i = 1; i < days.size(); ++i)
        if (days[i] > days[longest]) longest = i;
    if (!titles.empty())
        cout << "Longest loan: " << titles[longest] << " (" << days[longest] << " days)\n";

    cout << "\nOverdue (over " << OVERDUE_LIMIT << " days):\n";
    bool anyOverdue = false;
    for (size_t i = 0; i < titles.size(); ++i)
        if (days[i] > OVERDUE_LIMIT) {
            cout << "  " << titles[i] << " (" << members[i] << ") — " << days[i] << " days\n";
            anyOverdue = true;
        }
    if (!anyOverdue) cout << "  No overdue loans\n";

    cout << "\nLoans per member:\n";
    vector<string> memberNames;
    vector<int> memberCounts;
    for (const string& m : members) {
        int idx = indexOf(memberNames, m);
        if (idx == -1) { memberNames.push_back(m); memberCounts.push_back(1); }
        else ++memberCounts[static_cast<size_t>(idx)];
    }
    for (size_t i = 0; i < memberNames.size(); ++i)
        cout << "  " << memberNames[i] << ": " << memberCounts[i] << "\n";

    long long total = 0;
    for (int d : days) total += d;
    cout << "\nAverage loan: " << fixed << setprecision(2)
         << (days.empty() ? 0.0 : static_cast<double>(total) / days.size()) << " days\n";

    cout << "\nAppend a loan (empty title to skip):\nTitle: ";
    string title;
    getline(cin, title);
    if (!title.empty()) {
        string member;
        int d;
        cout << "Member: ";
        getline(cin, member);
        cout << "Days on loan: ";
        cin >> d;
        while (d < 0) { cout << "Cannot be negative: "; cin >> d; }
        titles.push_back(title);
        members.push_back(member);
        days.push_back(d);
        saveLedger(PATH, titles, members, days);
        cout << "Saved " << titles.size() << " loans\n";
    }
    return 0;
}
```

### Solution explanation
The lab composes the course's file patterns into one system: seed-if-missing (create-then-load — a real application's first-run behaviour), the two-comma CSV split (three fields this time), the malformed-line skip, five reports over stored vectors, and the L3-20 manual tally for per-member aggregation. The position-tracking max and the strict-overdue filter are single-purpose scans over the same loaded vectors — the "load once, view many" shape from Level 3, now fed by a file. The append saves the *whole* ledger — the same rewrite-whole contract as L4-29 — keeping the persistence story to one mechanism while the analysis grows.

### Testing checklist
- [ ] All five scenarios behave as specified
- [ ] First run seeds the file; second run loads it (verify by record count)
- [ ] The member tally's first-appearance order holds
- [ ] The appended loan survives a restart

---

## L4-31 — The Safe Ledger

### Scenario
A journal tool keeps entries in *dynamically allocated* storage to teach manual memory management under controlled conditions — the Pointers module's discipline, applied to a real (small) tool.

### Problem statement
Store `n` journal entries (dynamically allocated array of `Entry` structs: text and a timestamp). Provide: append (growing the array — allocate double, copy, delete old), print all, find by text, and a clean shutdown that frees everything. Every allocation failure and every free path must be handled.

### Learning objectives
- own a dynamic array across operations (allocate, grow, free)
- grow by doubling without leaking the old block
- guarantee the single free path at shutdown

### Requirements
1. `struct Entry { string text; long timestamp; };` and the store is `Entry* data` with `size`/`capacity`.
2. `append` grows by doubling when full (start capacity 2), copying, deleting the old block.
3. `findByText` returns a pointer or `nullptr` (the ask-door).
4. Shutdown deletes the array exactly once; run the program under repeated appends to prove stability.

### Input
Commands until `quit`: `add text...`, `list`, `find text`, `quit`.

### Output
`list` prints all entries; `find` prints the entry or `not found`; shutdown prints `Released N entries`.

### Constraints
- Text is a single `std::string` member — the *array* is dynamic; the strings manage themselves (the honest modern hybrid).
- No `new` without a named owner; no `delete` outside the two legitimate paths (grow and shutdown).

### Example
`add first`, `add second`, `add third` (forces one doubling), `list` → three entries; `find second` → found; `quit` → `Released 3 entries`.

### Test cases
| Scenario | Expected |
| --- | --- |
| the example | growth happens silently; all three listed |
| add 20 entries | three doublings (2→4→8→16→32); all listed |
| find missing | not found |
| find after growth | still found (the copy preserved contents) |
| quit with zero entries | Released 0 entries, clean exit |

### Student tasks
1. Write `initStore`, `appendEntry` (with the doubling grow), `freeStore`.
2. Write `findByText` and `printAll`.
3. Write the command loop.
4. Verify with the 20-entry stress test and check the growth path in a debugger or with size/capacity prints.

### Hints
1. Grow: `Entry* bigger = new Entry[capacity * 2];` — copy by assignment, `delete[] data;`, reassign, double `capacity`.
2. The copy in the grow uses the *old* size, not the new capacity.
3. `freeStore` does `delete[] data` once — guard it with a null check or a flag.

### Extension challenges
1. Add `remove text` — compact the array and note which entries shift.
2. Replace the manual grow with `vector<Entry>` and diff the two programs — write the paragraph on what the vector automated (the Modern C++ module's thesis, in one page).

### Complete solution

```cpp
// L4-31 — The Safe Ledger
// Compile: g++ -std=c++17 -Wall -Wextra L4-31.cpp -o L4-31
#include <iostream>
#include <string>
using namespace std;

struct Entry {
    string text;
    long timestamp;
};

struct Store {
    Entry* data;
    size_t size;
    size_t capacity;
};

void initStore(Store& s) {
    s.data = new Entry[2];          // the store owns this block
    s.size = 0;
    s.capacity = 2;
}

void appendEntry(Store& s, const string& text, long timestamp) {
    if (s.size == s.capacity) {
        size_t newCap = s.capacity * 2;                 // grow by doubling
        Entry* bigger = new Entry[newCap];              // 1: allocate the new block
        for (size_t i = 0; i < s.size; ++i)             // 2: copy the OLD size
            bigger[i] = s.data[i];
        delete[] s.data;                                // 3: release the old block
        s.data = bigger;                                // 4: adopt the new block
        s.capacity = newCap;
    }
    s.data[s.size].text = text;
    s.data[s.size].timestamp = timestamp;
    ++s.size;
}

Entry* findByText(Store& s, const string& text) {
    for (size_t i = 0; i < s.size; ++i)
        if (s.data[i].text == text) return &s.data[i];
    return nullptr;                                     // the ask-door's empty hand
}

void printAll(const Store& s) {
    for (size_t i = 0; i < s.size; ++i)
        cout << i + 1 << ". " << s.data[i].text << " (t=" << s.data[i].timestamp << ")\n";
}

void freeStore(Store& s) {
    delete[] s.data;                                    // the single free path
    s.data = nullptr;
    s.size = s.capacity = 0;
}

int main() {
    Store store;
    initStore(store);
    long clock = 1000;

    cout << "Command (add/list/find/quit): ";
    string command;
    while (cin >> command && command != "quit") {
        if (command == "add") {
            string text;
            cin >> text;
            appendEntry(store, text, ++clock);
        } else if (command == "list") {
            printAll(store);
        } else if (command == "find") {
            string text;
            cin >> text;
            Entry* hit = findByText(store, text);
            if (hit)
                cout << "found: " << hit->text << " (t=" << hit->timestamp << ")\n";
            else
                cout << "not found\n";
        } else {
            cout << "Unknown command\n";
        }
        cout << "Command (add/list/find/quit): ";
    }

    cout << "Released " << store.size << " entries\n";
    freeStore(store);
    return 0;
}
```

### Solution explanation
The grow operation is the lab's heart and its most dangerous four lines — allocate, copy, free, adopt, in that exact order: allocate *first* (if it throws, the old block is untouched), copy the *old* size, free only after the copy succeeded, adopt last. The owner is named in the struct (`Store` owns `data`), the free paths are exactly two (grow, shutdown), and everything else holds views (`findByText` returns a non-owning pointer — the ask-door over dynamic storage). The lab is deliberately the *last* manual-memory exercise: the extension's vector comparison is the honest conclusion the Modern C++ module draws — the same operations, minus every way to get them wrong.

### Testing checklist
- [ ] All five test cases pass
- [ ] Contents survive every doubling (find after growth)
- [ ] Exactly one `delete[]` per allocation over the whole run
- [ ] The 20-entry stress run completes cleanly

---

## L4-32 — The Student Registry

### Scenario
The department's front desk maintains a registry of students — name, roll number, programme, GPA — as *records* (the structs module): a directory that can be listed, searched, and summarized without classes yet.

### Problem statement
Define `struct Student { string name; string roll; string programme; double gpa; };`. Read `n` students (1–50) into a vector. Provide: the full listing, search by roll (report all fields or `not found`), the highest-GPA student, the count per programme (first-appearance order), and the registry average GPA.

### Learning objectives
- define and populate a record type from input
- pass records and vectors of records through functions
- aggregate over one record field while reporting others

### Requirements
1. All functions take `const vector<Student>&` except the reader.
2. GPA validated 0.0–4.0 (re-prompt); roll numbers unique — a duplicate roll re-prompts.
3. Search by exact roll; print all four fields on a hit.
4. The per-programme tally is the L3-20/L4-30 manual pattern.

### Input
`n`, then per student: name (one word), roll, programme (one word), GPA.

### Output
Listing block, search section (one query), top student, programme tally, average.

### Constraints
- The record is the unit of storage — no parallel vectors (that was Level 3's idiom; this lab retires it).
- Functions: `readStudents`, `printAll`, `findByRoll`, `topStudent`, `printProgrammeTally`, `averageGpa`.

### Example
Three students with GPAs 3.8, 3.2, 3.8 → top: first 3.8 (tie: first occurrence), average 3.60, tally shows each programme's count.

### Test cases
| Input | Expected |
| --- | --- |
| 3 students as the example | listing, top, tally, average 3.60 |
| duplicate roll typed | re-prompted for the roll only |
| GPA 4.5 then 4.0 | re-prompt, then accepted 4.0 |
| search missing roll | not found |
| 1 student | top = that student; average = their GPA |

### Student tasks
1. Define the struct; write `readStudents` with both validations.
2. Write `findByRoll` returning `const Student*` (nullptr on miss).
3. Write `topStudent` (position-tracking max over the vector).
4. Write the tally and average; assemble `main`.

### Hints
1. The duplicate-roll check needs the rolls *read so far* — search the vector's current contents before pushing.
2. `topStudent` returns `const Student*` too — one design for both "search" and "max" answers.
3. The tally tracks names only; counts live in the aligned second vector.

### Extension challenges
1. Sort the listing by GPA descending before printing (a copied-then-sorted vector of records).
2. Add a second query type: search by programme prefix.

### Complete solution

```cpp
// L4-32 — The Student Registry
// Compile: g++ -std=c++17 -Wall -Wextra L4-32.cpp -o L4-32
#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
using namespace std;

struct Student {
    string name;
    string roll;
    string programme;
    double gpa;
};

void readStudents(vector<Student>& out, int n) {
    for (int i = 0; i < n; ++i) {
        Student s;
        cout << "Student " << (i + 1) << " name: ";
        cin >> s.name;
        cout << "roll: ";
        cin >> s.roll;
        while (findByRollHelper(out, s.roll) != nullptr) {
            cout << "Roll already registered. Again: ";
            cin >> s.roll;
        }
        cout << "programme: ";
        cin >> s.programme;
        cout << "gpa: ";
        cin >> s.gpa;
        while (s.gpa < 0.0 || s.gpa > 4.0) { cout << "GPA is 0.0-4.0: "; cin >> s.gpa; }
        out.push_back(s);
    }
}

const Student* findByRollHelper(const vector<Student>& students, const string& roll) {
    for (const Student& s : students)
        if (s.roll == roll) return &s;
    return nullptr;
}

void printAll(const vector<Student>& students) {
    cout << fixed << setprecision(2);
    for (const Student& s : students)
        cout << "  " << s.name << " (" << s.roll << ") " << s.programme
             << " GPA " << s.gpa << "\n";
}

const Student* topStudent(const vector<Student>& students) {
    const Student* best = &students[0];
    for (const Student& s : students)
        if (s.gpa > best->gpa) best = &s;      // strict: first-occurrence tie
    return best;
}

void printProgrammeTally(const vector<Student>& students) {
    vector<string> names;
    vector<int> counts;
    for (const Student& s : students) {
        size_t i = 0;
        while (i < names.size() && names[i] != s.programme) ++i;   // manual indexOf
        if (i == names.size()) { names.push_back(s.programme); counts.push_back(1); }
        else ++counts[i];
    }
    for (size_t i = 0; i < names.size(); ++i)
        cout << "  " << names[i] << ": " << counts[i] << "\n";
}

double averageGpa(const vector<Student>& students) {
    double total = 0.0;
    for (const Student& s : students) total += s.gpa;
    return total / students.size();
}

int main() {
    int n;
    cout << "Number of students: ";
    cin >> n;
    if (n < 1 || n > 50) { cout << "Invalid count\n"; return 1; }

    vector<Student> students;
    readStudents(students, n);

    cout << "\n=== REGISTRY ===\n";
    printAll(students);

    cout << "\nRoll to find: ";
    string roll;
    cin >> roll;
    const Student* hit = findByRollHelper(students, roll);
    if (hit)
        cout << "  " << hit->name << " (" << hit->roll << ") " << hit->programme
             << " GPA " << hit->gpa << "\n";
    else
        cout << "  not found\n";

    const Student* top = topStudent(students);
    cout << "Top student: " << top->name << " (GPA " << top->gpa << ")\n";

    cout << "Programmes:\n";
    printProgrammeTally(students);

    cout << "Average GPA: " << fixed << setprecision(2) << averageGpa(students) << "\n";
    return 0;
}
```

*(Forward-reference note for self-study readers: `readStudents` calls `findByRollHelper` — place the helper's definition above it, or add a prototype at the top. The full solution orders the functions accordingly; the listing here shows the call for clarity.)*

### Solution explanation
The struct retires Level 3's parallel vectors: one `Student` travels as a unit, functions take `const vector<Student>&`, and the copy-safety of by-value record assignment replaces the three-vector alignment dance — the records module's argument, demonstrated by use. Both "search" and "max" return `const Student*` (the ask-door and the first-occurrence tie rule from Level 2, now over records). The duplicate-roll check searches the *partially built* vector — validation against the collection's own growing contents is the first cross-record rule in the course, and it foreshadows the classes module's constructor gates.

### Testing checklist
- [ ] All five test cases pass
- [ ] Duplicate rolls re-prompt without losing the other fields
- [ ] GPA boundaries (0.0 and 4.0) are accepted
- [ ] Ties for top student resolve to the first occurrence

---

## L4-33 — The Fee Account Family

### Scenario
The finance office models student fee accounts as *classes* (the OOP module): each account defends its own balance — deposits, charges, and a transaction log — with validation inside the object, not in `main`.

### Problem statement
Implement `class FeeAccount` (owner name, balance): a validating constructor (opening ≥ 0), `deposit` (amount > 0), `charge` (amount > 0 and ≤ balance — else refuse), `balance()` query, and a transaction history (a vector of strings, appended by every successful operation). Demonstrate with a small `main` that creates two accounts, performs valid and invalid operations, and prints both histories.

### Learning objectives
- encapsulate state behind a validating interface
- refuse invalid operations inside the class (the object defends itself)
- maintain an object-owned history

### Requirements
1. Balance is private; all mutation through methods; every method validates its own inputs.
2. Refusals return `bool` (the ask-door) and change nothing.
3. History entries: `DEPOSIT 500.00`, `CHARGE 120.50`, `REFUSED CHARGE 9999.00` — the refusals are logged too.
4. `main` shows: a successful deposit/charge, a refused overdraft, a refused negative deposit.

### Input
All values hard-coded in `main` (this lab is about the class, not I/O).

### Output
The two accounts' final balances and full histories.

### Constraints
- `balance()` is `const`; the history append happens only for *successful* operations — plus the REFUSED entries (decide and document: the contract says refusals log too).
- No getters beyond what `main`'s output needs — the OOP module's "don't build a crew of getters" discipline.

### Example
Account A: deposit 500, charge 120.50 → balance 379.50, history of 2; Account B: charge 100 refused → history shows REFUSED.

### Test cases
| Scenario | Expected |
| --- | --- |
| deposit 500, charge 120.50 | balance 379.50, two history lines |
| charge beyond balance | refused, balance unchanged, REFUSED line |
| deposit −50 | refused, no DEPOSIT line |
| constructor with −100 opening | throws (the constructor gate) |
| charge exactly the balance | accepted, balance 0.00 |

### Student tasks
1. Write the class skeleton: privates, constructor with the gate.
2. Write `deposit`/`charge` with validation, logging, and the ask-door returns.
3. Write `balance()` and `printHistory()`.
4. Write the demonstration `main` covering every test-case row.

### Hints
1. The constructor gate throws `invalid_argument` for a negative opening — the object can never exist invalid.
2. `charge` checks `amount <= balance` — the equality case (test 5) must pass.
3. History strings: `to_string`-assemble, or a small `ostringstream` — either; the format is the contract.

### Extension challenges
1. Add `transferTo(FeeAccount&, amount)` — all-or-nothing (a failed charge leaves both accounts untouched; the Robustness module's transaction ordering).
2. Return the refusal *reason* as an enum class instead of bool.

### Complete solution

```cpp
// L4-33 — The Fee Account Family
// Compile: g++ -std=c++17 -Wall -Wextra L4-33.cpp -o L4-33
#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <stdexcept>
using namespace std;

class FeeAccount {
public:
    explicit FeeAccount(const string& owner, double opening)
        : owner_(owner), balance_(opening) {
        if (opening < 0)
            throw invalid_argument("FeeAccount: negative opening balance for " + owner);
        history_.push_back("OPENED with " + to_string(opening));
    }

    bool deposit(double amount) {
        if (amount <= 0) {
            history_.push_back("REFUSED DEPOSIT " + to_string(amount));
            return false;
        }
        balance_ += amount;
        history_.push_back("DEPOSIT " + to_string(amount));
        return true;
    }

    bool charge(double amount) {
        if (amount <= 0 || amount > balance_) {
            history_.push_back("REFUSED CHARGE " + to_string(amount));
            return false;
        }
        balance_ -= amount;
        history_.push_back("CHARGE " + to_string(amount));
        return true;
    }

    double balance() const { return balance_; }
    const string& owner() const { return owner_; }

    void printHistory() const {
        for (const string& entry : history_)
            cout << "  " << entry << "\n";
    }

private:
    string owner_;
    double balance_;
    vector<string> history_;
};

int main() {
    cout << fixed << setprecision(2);

    FeeAccount aisha("Aisha", 500.0);
    aisha.deposit(250.0);
    aisha.charge(120.50);
    aisha.charge(9999.0);            // refused: overdraft
    aisha.deposit(-50.0);            // refused: non-positive

    FeeAccount bilal("Bilal", 100.0);
    bilal.charge(100.0);             // exactly the balance: accepted

    cout << aisha.owner() << ": balance " << aisha.balance() << "\n";
    aisha.printHistory();
    cout << bilal.owner() << ": balance " << bilal.balance() << "\n";
    bilal.printHistory();
    return 0;
}
```

### Solution explanation
The class is the OOP module's BankAccount, wired to this lab's logging requirement: every public method validates *before* mutating, refusals are recorded (the log is the object's memory of its own life — including its refusals, which is what makes the histories useful as evidence), and the constructor gate means no invalid account can be constructed at all. The ask-door returns (`bool`) keep the caller in charge of *responding* to refusal while the object stays in charge of *enforcing* it — the division of labour the module taught. `balance()` and `owner()` are the only queries; `printHistory` exists because printing *is* the object's own presentation, not a getter crew.

### Testing checklist
- [ ] All five test cases behave as specified
- [ ] A refused operation leaves the balance untouched (verify with the exact-balance charge)
- [ ] REFUSED lines appear for every refusal
- [ ] The negative-opening constructor throws before any history exists

---

## L4-34 — The Course Catalogue

### Scenario
The registrar's office keeps a course catalogue: each `Course` has a title, a capacity, its enrolled count, and a roster of student names (as strings — the roster is *names*, not objects, to keep the lab on vectors-of-objects mechanics). The desk offers add-course, enrol, drop, and the catalogue report.

### Problem statement
Implement `class Course` (title, capacity, `vector<string> roster`): validating constructor (capacity 1–100), `enrol(name)` (ask-door: refuses when full or already enrolled), `drop(name)` (refuses when not enrolled), `isFull()`, `seatCount()`, and a `print()` report. Manage the catalogue as a `vector<Course>`; `main` offers a menu until quit.

### Learning objectives
- own a container *inside* a class (composition)
- enforce enrolment invariants inside the class
- manage a vector of objects through a menu

### Requirements
1. `enrol` refuses: course full, name already on the roster (both cases logged as refusals).
2. `drop` refuses when the name is absent; removal preserves order of the others.
3. The catalogue menu: 1 add course, 2 enrol, 3 drop, 4 report, 0 quit.
4. The report lists every course: `Title (enrolled/capacity)` plus the roster names.

### Input
Menu-driven: course title (one word), capacity, then names (one word each).

### Output
Per operation: an acknowledgement or a refusal; the report block on demand.

### Constraints
- The roster vector lives inside the class — `main` never touches it directly.
- Capacity is fixed at construction (no setter).

### Example
Add `PF 2`; enrol Aisha, Bilal; enrol Sara (refused: full); drop Bilal; enrol Sara (accepted) → report: `PF (2/2): Aisha Sara`.

### Test cases
| Sequence | Expected |
| --- | --- |
| the example | refusal at full, then success after the drop |
| enrol the same name twice | second refused |
| drop a non-enrolled name | refused |
| capacity 0 at construction | refused by the constructor gate |
| report with zero courses | `No courses in the catalogue` |

### Student tasks
1. Write the class: privates, constructor gate, `enrol`/`drop`/`isFull`/`seatCount`/`print`.
2. Write the menu loop over `vector<Course>`.
3. Wire each menu option to one class operation.
4. Run the example sequence; verify every refusal.

### Hints
1. `enrol`'s two refusal conditions are independent — full and duplicate — test both.
2. `drop`: find the name's index, then `roster.erase(roster.begin() + index)` — the vector-erase idiom (or rebuild without the name; both acceptable, one is one line).
3. The menu's index arithmetic: courses print 1-based, vectors index 0-based — subtract once, at the selection.

### Extension challenges
1. Add a waitlist per course (a second vector; enrol-when-full offers the waitlist).
2. Add `Course::merge(const Course&)` — union of rosters, capacity permitting (all-or-nothing).

### Complete solution

```cpp
// L4-34 — The Course Catalogue
// Compile: g++ -std=c++17 -Wall -Wextra L4-34.cpp -o L4-34
#include <iostream>
#include <string>
#include <vector>
#include <stdexcept>
using namespace std;

class Course {
public:
    Course(const string& title, int capacity) : title_(title), capacity_(capacity) {
        if (capacity < 1 || capacity > 100)
            throw invalid_argument("Course: capacity must be 1-100 for " + title);
    }

    bool enrol(const string& name) {
        if (isFull()) return false;
        if (indexOf(name) != -1) return false;         // already enrolled
        roster_.push_back(name);
        return true;
    }

    bool drop(const string& name) {
        int idx = indexOf(name);
        if (idx == -1) return false;
        roster_.erase(roster_.begin() + idx);
        return true;
    }

    bool isFull() const { return static_cast<int>(roster_.size()) >= capacity_; }
    int seatCount() const { return capacity_ - static_cast<int>(roster_.size()); }
    const string& title() const { return title_; }

    void print() const {
        cout << "  " << title_ << " (" << roster_.size() << "/" << capacity_ << "): ";
        for (const string& name : roster_) cout << name << " ";
        cout << "\n";
    }

private:
    int indexOf(const string& name) const {
        for (size_t i = 0; i < roster_.size(); ++i)
            if (roster_[i] == name) return static_cast<int>(i);
        return -1;
    }

    string title_;
    int capacity_;
    vector<string> roster_;
};

int main() {
    vector<Course> catalogue;

    int choice;
    do {
        cout << "\n1 Add course · 2 Enrol · 3 Drop · 4 Report · 0 Quit: ";
        cin >> choice;

        if (choice == 1) {
            string title;
            int capacity;
            cout << "Title: ";
            cin >> title;
            cout << "Capacity: ";
            cin >> capacity;
            try {
                catalogue.push_back(Course(title, capacity));
                cout << "Added " << title << "\n";
            } catch (const invalid_argument& e) {
                cout << "Refused: " << e.what() << "\n";
            }
        } else if (choice == 2 || choice == 3) {
            string title, name;
            cout << "Course title: ";
            cin >> title;
            cout << "Student name: ";
            cin >> name;

            Course* target = nullptr;                   // find the course (view, not owner)
            for (Course& c : catalogue)
                if (c.title() == title) { target = &c; break; }

            if (!target) {
                cout << "No such course\n";
            } else if (choice == 2) {
                cout << (target->enrol(name) ? "Enrolled " : "Refused: full or already enrolled ")
                     << name << "\n";
            } else {
                cout << (target->drop(name) ? "Dropped " : "Refused: not enrolled ")
                     << name << "\n";
            }
        } else if (choice == 4) {
            if (catalogue.empty()) {
                cout << "No courses in the catalogue\n";
            } else {
                for (const Course& c : catalogue) c.print();
            }
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);
    return 0;
}
```

### Solution explanation
The class owns its roster — composition in its smallest form: the vector is born with the course, dies with it, and *no code outside the class can touch it* (the requirement makes the encapsulation testable: search `main` for `roster_` — it isn't there). The ask-door pattern covers every operation (enrol, drop, the catalogue search returning a view), and the constructor gate keeps impossible courses out of the vector. The menu-over-objects shape is the OOP module's "vectors of objects" lesson running interactively — and the drop-then-reenrol sequence in the example is the invariant test: capacity is respected across mutations, not just at insert.

### Testing checklist
- [ ] All five test sequences behave as specified
- [ ] `main` never accesses the roster directly
- [ ] Refusals leave the roster unchanged (verify with the report)
- [ ] Capacity gate rejects 0 and 101 at construction

---

[← Level 3](level-3.md) · [Labs home](index.md) · Continue to [Level 5 — Integrated](level-5.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
