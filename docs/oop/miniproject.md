---
title: "Object-Oriented Mini Project — The Student Record Management System, Refactored"
description: "The Records module's procedural system rebuilt as Student + Roster classes: same commands, same file format, invariants enforced by the compiler."
---

# Object-Oriented Mini Project — the records, refactored

> [← Module home](index.md) · The capstone rehearsal for Unit 16 · Built on [Lab 2's Student](labs.md), [Lab 6's Course thinking](labs.md), and the [Files module](../files/index.md)'s format contract

## The project in one paragraph

The [Records module](../records/index.md) ended with a **Student Record Management System** — a menu program over an array of structs, with free functions for every operation and discipline enforcing every rule. This mini-project rebuilds it as **classes**: a `Student` class that owns and defends its own marks, and a `Roster` class that owns and defends the collection. The commands are the same, the **file format is the same** — and by the end you will be able to say, concretely, what the refactor bought.

**Non-negotiable ground rules (inherited from the original brief):**

1. **No inheritance, no polymorphism** — classes, composition, and the `const` ladder only.
2. **The file format contract survives**: `rollNo;name;marks1;marks2;marks3` per line, `;`-separated, exactly as the Files module specified. A working refactor round-trips the old data file byte-for-byte.
3. **Derived data is computed, never stored** — average and grade are `const` methods.
4. **No globals.** The `Roster` is an object; `main` talks to it through its interface.
5. Every mutation goes through a guarded method — the compiler, not discipline, is the bouncer.

---

## Milestone M1 — the `Student` class

Start from [Lab 2](labs.md) and extend it with the file contract's needs:

- attributes: name, rollNo, `int marks[3]` with −1 sentinels — all private
- guarded `setMark`, const readers (`mark`, `average`, `grade`, `getName`, `getRollNo`)
- **new:** `toCSV() const` producing `"101;Aisha;85;91;-1"` — derived, in roll-no-first field order
- **new:** a static-style factory or constructor-from-fields so a `Student` can be built from parsed CSV fields *after validation* (`Student::fromFields(roll, name, m1, m2, m3) -> bool` into an out-parameter, or your documented equivalent)
- `operator<<` for one-line display

**Exit test for M1:** construct a student, set marks, `toCSV()`, and *hand-compare* against the expected string from the format contract.

## Milestone M2 — the `Roster` class (storage invariants)

- **has-a** `vector<Student>` (composition — the roster owns its students)
- `add(const Student&) -> bool` — refuses **duplicate roll numbers** (the invariant the old system enforced by convention)
- `findByRoll(int roll) const -> const Student*` and a mutable twin — `nullptr` means absent
- `size() const`, `at(index) const -> const Student&` (bounds-checked, the Arrays module's `.at()` honesty)
- **sorted-by-roll invariant:** the roster keeps itself ordered by roll number at all times (insert in position — the Algorithms module's insertion idea, reused). This is what makes M4's binary search legal.

**Exit test for M2:** add four students out of order; list them — roll order. Add a duplicate roll — refused.

## Milestone M3 — persistence (the contract, unchanged)

- `load(const string& filename) -> bool` — open-check (Files module), read line by line, split each CSV line (Strings module: `find`/`substr`), validate fields, `Roster::add`; refuse *the whole load* on a malformed line rather than silently skipping (your original brief's honesty rule — document your choice either way, in a comment)
- `save(const string& filename) const` — rewrite the file in roll order; the format is unchanged, so the old system's data file loads here, and this system's file loads there
- The open-check pattern and the "say what your open means" rule apply verbatim.

**Exit test for M3:** the Records module's sample data file loads; save; the file is byte-identical (or differs only where you legitimately changed marks — prove which).

## Milestone M4 — search and report (algorithms under a class roof)

- `findByRoll` becomes **binary search** over the sorted vector (Algorithms module) — the sorted invariant from M2 is what *earns* it
- `report() const -> void` — class average, highest, lowest, per-grade counts (the tally array, one more reuse); const method over const students
- `printAll() const` via `operator<<` and a range-for of `const Student&`

**Exit test for M4:** find present/absent roll numbers at both ends of the roster; the report matches a hand-computed summary of a 4-student test file.

## Milestone M5 — the menu, thin

- `main` holds only: load → loop { print menu → read validated choice → call one roster method } → save-on-exit
- **Menu actions are one-liners.** If a case block grows past ~5 lines, the logic belongs in a `Roster` method (the one-job rule, one last time)
- Validation of the *menu input itself* (non-numeric, out of range) is the Files/IO modules' stream-repair rhythm — unchanged by OOP, still required

**Exit test for M5:** the full add/find/list/report/save/load cycle, plus the refuse-everything path (missing file, malformed line, duplicate roll, bad menu input).

---

## The deliverable test table

| # | Scenario | Input / action | Expected |
| --- | --- | --- | --- |
| 1 | fresh start | no file present | message, empty roster, program continues |
| 2 | load contract file | Records module's `students.txt` | all records loaded, listed in roll order |
| 3 | duplicate refusal | add roll 101 (exists) | refused with message |
| 4 | mark guards | setMark quiz 2 = 101 | refused; unchanged |
| 5 | find binary | roll at each end + middle | found, correct student |
| 6 | find absent | roll between existing values | "not found" |
| 7 | report | the loaded class | class average/grade counts match hand computation |
| 8 | save round trip | save, relaunch, load | identical roster (spot-check 3 records) |
| 9 | malformed line | `101;BadName;abc;90;80` | load refused (or line rejected) — per your documented policy |
| 10 | derived data | change one mark, re-report | average/grade follow — no stale stored value |

## The write-up (half a page, the capstone rehearsal)

Answer four questions in prose:

1. **What did `private` change?** Name one bug from your *old* procedural version (or one the old design invited) that is now a compile error.
2. **What did the sorted invariant buy?** Trace why binary search was legal in M4 and wasn't guaranteed in the old system.
3. **What survived the refactor?** The file format, the menu, the guard chains, the algorithms — list which pieces moved *unchanged*, and say what that tells you about good procedural design.
4. **What would you compose next?** One paragraph: if Unit 16's capstone adds attendance or fees, does that become a new attribute, a composed class, or a new collection — and which relationship row (Lesson 3) says so?

## Reference skeleton

Deliberately sparse — the interface is given; the bodies are yours:

```cpp
class Student {
public:
    Student(const string& n, int roll);
    bool setMark(int quiz, int m);
    int mark(int quiz) const;
    double average() const;
    char grade() const;
    string toCSV() const;
    const string& getName() const;
    int getRollNo() const;
private:
    string name;
    int rollNo;
    int marks[3] = {-1, -1, -1};
};

class Roster {
public:
    bool add(const Student& s);          // keeps roll order; refuses duplicates
    const Student* findByRoll(int roll) const;   // binary search — M4
    bool load(const string& filename);
    bool save(const string& filename) const;
    void report() const;
    void printAll() const;
    int size() const;
private:
    vector<Student> students;            // sorted by rollNo at all times — M2's invariant
};

int main() {
    Roster roster;                        // owns everything; main owns the menu
    // load -> loop -> save-on-exit; each case a one-line call
}
```

**Three subtleties worth noticing (not fixing for you):**

1. `save` must write *what the roster holds now* — in roll order, which the sorted invariant gives you for free. The old system had to remember to sort before saving; the class forgets nothing.
2. `load` builds `Student` objects from *parsed, validated* fields — never by trusting the line. Decide where a malformed field refuses: the line, or the whole file (and write the decision in a comment — that's the format contract's amendment procedure).
3. The menu's "find then act" pattern (find by roll → present report → edit) uses the `const Student*` for *reading*, but edits must go through the **mutable** twin or a `Roster::update` method — handing out a non-const pointer to a vector element invites the dangling-alias problem the moment the vector reallocates. Choose the door deliberately.

## Grading

Self-assessed against the [Project rubric](../grading.md#project-rubrics)'s project row; this mini-project is Unit 16's capstone rehearsal — the Contact Management System will ask for the same structure with contacts instead of students, plus the Modern C++ Toolkit polish.

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
