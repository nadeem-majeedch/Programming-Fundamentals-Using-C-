---
title: "Lab — The Modernisation Lab"
description: "A working 2010-style pipeline program retrofitted in four stages — const-first, library-first, RAII and smart pointers, the modern toolkit — with the modernization table as the graded deliverable."
---

# Lab — the Modernisation Lab

> [← Module home](index.md) · Four stages over one program · Attempt each stage before opening its solution pass

## The scenario

A marks-processing pipeline — **load → analyse → report → archive** — works, but it was written in the course's "pre-modern" style: raw `new`/`delete`, by-value vectors, magic numbers, hand-rolled searches, `NULL`. Your job is not to rewrite it from scratch. It is to **modernise it in four stages**, running and testing after each — because retrofitting working code *without breaking it* is the professional skill this lab teaches.

**The program** (study it before touching anything):

```cpp
// pipeline-vintage.cpp — Programming Fundamentals Using C++
// Modernisation Lab · the starting point (deliberately pre-modern)
// Compile: g++ -std=c++17 -Wall -Wextra pipeline-vintage.cpp -o vintage

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <stdexcept>
using namespace std;

#define LIMIT 1000                          // (1) the macro constant

struct Student {
    string name;
    int marks;
};

// load: reads "name marks" lines; the caller must delete the result
Student* loadStudents(const string& path, int& count) {     // (2) raw owning pointer
    Student* out = new Student[LIMIT];
    count = 0;
    ifstream in(path);
    if (!in) return NULL;                                   // (3) NULL, leaked out
    string line;
    while (getline(in, line) && count < LIMIT) {
        stringstream ss(line);
        Student s;
        if (ss >> s.name >> s.marks) out[count++] = s;      // (4) silently skips bad lines
    }
    return out;
}

double average(Student* students, int count) {              // (5) pointer + count pair
    int total = 0;
    for (int i = 0; i < count; ++i) total += students[i].marks;
    return (double)total / count;                           // (6) divide-by-zero on empty
}

int findTop(Student* students, int count) {                 // (7) hand-rolled max search
    int best = 0;
    for (int i = 1; i < count; ++i)
        if (students[i].marks > students[best].marks) best = i;
    return best;
}

void printReport(Student* students, int count) {            // (8) by-value would copy; this
    cout << "=== REPORT ===\n";                             //     instead shares the raw pointer
    for (int i = 0; i < count; ++i)
        cout << students[i].name << " " << students[i].marks << "\n";
    cout << "average: " << average(students, count) << "\n";
    cout << "top: " << students[findTop(students, count)].name << "\n";
}

void archive(Student* students, int count) {                // (9) truncating reopen, unverified
    ofstream out("archive.txt");
    for (int i = 0; i < count; ++i)
        out << students[i].name << "," << students[i].marks << "\n";
}

int main() {
    int count = 0;
    Student* students = loadStudents("students.txt", count);
    if (students == NULL) {                                 // (10) only the open is checked;
        cout << "no file\n";                                 //     count>0 vs 0 not distinguished
        return 1;
    }
    printReport(students, count);
    archive(students, count);
    delete[] students;                                      // (11) the one delete — one path
    return 0;                                               //     away from an early exit
}
```

The numbered comments are the modernisation targets — eleven of them, mapped across four stages. **Baseline first:** compile and run with `students.txt` (make one: `Aisha 82`, `Bilal 65`, `Sara 91`, plus one bad line `Zed`), confirm the report, and *record the behaviour on a missing file and on an empty file* — you will need it to prove the later stages fix real bugs.

---

## Stage 1 — const-first (the readability ring)

**Tasks.**

1. Replace `#define LIMIT 1000` with `constexpr int MAX_STUDENTS = 1000;` — and find every magic number the macro was hiding.
2. Make `average`, `findTop`, `printReport` take what they actually need: parameters become `const` — where a whole-array view is passed, switch to the container shape *that Stage 2 will formalise* (for now: `const Student*` + count, honestly marked) — and name the promise each new `const` adds.
3. Fix divide-by-zero on empty input (the guard from the Robustness module — decide: throw or report?).
4. Re-run the baseline scenarios — nothing should change except the empty-file case.

**Stage exit test:** all functions declare their non-mutation; empty input is refused loudly; the macro is gone.

## Stage 2 — library-first (the standard-library ring)

**Tasks.**

1. Replace the raw array + count pair with `vector<Student>` — every signature changes shape; the `count` parameter dies.
2. Replace `findTop` with `max_element` (and note what the library gives you that the hand loop didn't: the empty-input `end()` question, answered explicitly).
3. Replace the bad-line silent skip with the Robustness module's policy: collect skipped line numbers, report them after the load (or throw past a budget — your choice, stated in a comment).
4. Use range-based `for` with the correct loop-variable spelling everywhere a whole-container visit appears.
5. Re-run the baseline — the report output must be **byte-identical** to Stage 1's.

**Stage exit test:** no raw arrays, no manual index-search, every visit spelled with the right `const`/&/value choice, and the bad-line report is true.

## Stage 3 — RAII and smart pointers (the ownership ring)

**Tasks.**

1. Retire the raw owning pointer: `loadStudents` returns `vector<Student>` **by value** — mark in a comment where the move happens.
2. Delete the `delete[]` — and write the sentence: which exit paths could leak in the vintage version, and which can leak now?
3. Fix the missing-file case with the Robustness module's `openOrThrow`/`FileError` shape; wire `main`'s catch ladder (specific → family → net).
4. The archive write gets the append-verify discipline (flush and check — the expense-tracker lesson).
5. Add the fault-injection test: make `archive`'s open fail (rename the directory or pass a bad path in a test build); prove no leak *and* a clean, loud failure.
6. Re-run the baseline — output identical again.

**Stage exit test:** zero `new`/`delete` anywhere; the one-delete-one-path problem is structurally gone; failures are typed and loud.

## Stage 4 — the modern toolkit (the polish ring)

**Tasks.**

1. Where a type is obvious or unspellable, apply `auto` under the restraint rules — and add one comment where you *declined* `auto` because the type carries meaning.
2. Named constants to `constexpr`; add one `static_assert` that encodes a real invariant (e.g. `MAX_STUDENTS > 0`).
3. Convert any category-shaped magic values (say, a "status" int) to `enum class`.
4. One hand-off in the pipeline is a genuine move opportunity — implement it with `std::move` and the moved-from comment (or prove the return path already moves).
5. Replace any remaining `NULL`/`0`-as-pointer with `nullptr` — or confirm the modernised program has none left, and say why.

**Stage exit test:** `g++ -std=c++17 -Wall -Wextra -o final pipeline-final.cpp` compiles **warning-free**; the report is still byte-identical to Stage 1's.

---

## The graded deliverable — the modernization table

| # | Vintage pattern | Stage | Modern replacement | Bug class it kills |
| --- | --- | --- | --- | --- |
| 1 | `#define LIMIT 1000` | 1/4 | `constexpr` + `static_assert` | magic numbers, unchecked assumptions |
| 2 | `new Student[LIMIT]` + count pair | 2/3 | `vector<Student>` by value | raw ownership, the one-delete-one-path trap |
| 3 | `return NULL` mid-load | 3 | typed `FileError` throw | silent failure species #1, leak on early exit |
| 4 | silently skipping bad lines | 2 | collected-and-reported skips | species #4, the lying success |
| 5 | pointer + count parameters | 2 | container parameters | index/size desynchronisation |
| 6 | divide by `count` unchecked | 1 | guard before divide (typed) | computed garbage (species #4) |
| 7 | hand-rolled max search | 2 | `max_element` + explicit empty check | the hand-loop's silent empty bug |
| 8 | raw-pointer sharing into printers | 2/3 | `const vector<Student>&` views | accidental ownership, dangling risk |
| 9 | truncating reopen, unverified write | 3 | append mode + flush-verify | species #4, the vanished record |
| 10 | `NULL` comparison in `main` | 3/4 | exception ladder; `nullptr` if a view remains | type confusion, untested failure paths |
| 11 | `delete[]` on one path only | 3 | RAII — no delete exists | every leak class |

*Fill the third column from your own work — the table is the deliverable because it demonstrates the module's thesis: each practice is the *cure* for a bug class you have already met, not a fashion.*

## The solution pass (compressed, Stage 3 shape)

```cpp
// pipeline-modern.cpp — the load-bearing shapes after Stage 3
#include <algorithm>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <stdexcept>
using namespace std;

constexpr int MAX_STUDENTS = 1000;
static_assert(MAX_STUDENTS > 0, "capacity must be positive");

struct Student { string name; int marks; };

vector<Student> loadStudents(const string& path) {
    ifstream in(path);
    if (!in) throw FileError("open", path);            // from the Robustness family
    vector<Student> out;                                // owns itself
    string line;
    vector<int> badLines;
    int lineNo = 0;
    while (getline(in, line)) {
        ++lineNo;
        stringstream ss(line);
        Student s;
        if (ss >> s.name >> s.marks) out.push_back(move(s));
        else badLines.push_back(lineNo);                // collected, not vanished
    }
    if (!badLines.empty())                              // the report is true
        cerr << "note: skipped " << badLines.size() << " bad line(s)\n";
    return out;                                         // the move out is automatic
}

double averageOf(const vector<Student>& students) {     // const& view, non-owning
    if (students.empty()) throw AppError("averageOf: no students loaded");
    long long total = 0;                                // the D1 cure, built in
    for (const Student& s : students) total += s.marks;
    return (double)total / students.size();
}

void printReport(const vector<Student>& students) {
    cout << "=== REPORT ===\n";
    for (const Student& s : students) cout << s.name << " " << s.marks << "\n";
    cout << "average: " << averageOf(students) << "\n";
    auto top = max_element(students.begin(), students.end(),
        [](const Student& a, const Student& b) { return a.marks < b.marks; });
    if (top != students.end()) cout << "top: " << top->name << "\n";
}

void archive(const vector<Student>& students) {         // append + verify (Stage 3)
    ofstream out("archive.txt", ios::app);
    if (!out) throw FileError("open", "archive.txt");
    for (const Student& s : students)
        out << s.name << "," << s.marks << "\n";
    out.flush();
    if (!out) throw AppError("archive: write failed");
}

int main() {
    try {
        vector<Student> students = loadStudents("students.txt");
        printReport(students);
        archive(students);
    }
    catch (const AppError& e) { cerr << "error: " << e.what() << "\n"; return 1; }
    catch (const exception& e) { cerr << "unexpected: " << e.what() << "\n"; return 2; }
    return 0;
}
```

*(Stages 1–2 and 4 are your work from the same pieces: the `enum class` status, the declined-`auto` comment, and the byte-identical-output proofs.)*

## Explanation

- **The stages are ordered by risk:** readability first (nothing can break), structure second (signatures change but output must not), ownership third (the structural bug-killer), polish last. Retrofit in the other order and the polish lands on code that then changes shape.
- **The byte-identical requirement is the safety harness**: every stage must prove the *behaviour* survived the modernisation — the regression discipline from the Debugging module, applied to refactoring.
- **The table's last column is the module in one column of cells:** every modern practice entered this course as the cure for a named bug class. The lab makes you write the mapping for your own eleven — that mapping, not the code, is what you will carry to the [capstone](../syllabus.md#stage-f-capstone-unit-16).

## ⭐ Extensions

1. **The capstone retrofit:** run all four stages on any portion of your Project 3 code that predates this module — the table is the deliverable, again.
2. **The shared-owner corner:** invent the one feature that *justifies* `shared_ptr` in the pipeline (a report object read concurrently by two views that outlive the function) — build it, then write the paragraph on why the pipeline was *better* without it.
3. **The warning sweep:** compile the vintage file with `-Wall -Wextra` and the final file the same way; count the warnings each produces. The count difference is the modernisation, measured.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
