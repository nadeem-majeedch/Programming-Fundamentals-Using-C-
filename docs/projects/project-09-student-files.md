---
title: "Project 9 — The File-Based Student Management System"
description: "The full stack in one system: student records, per-student marks, computed grades, file persistence, reports, and a statistics layer — everything before OOP, integrated."
---

# Project 9 — The File-Based Student Management System

> [← Projects home](index.md) · [← Project 8](project-08-contacts.md) · Tier: Advanced · **Units first: 12–14** — files, records, and the records-module design sense

## Overview

The registrar's permanent record system: students (`students.csv`: `roll,name,programme`) with marks per student (`marks.csv`: `roll,m1,m2,m3`), joined in memory into full records with computed totals and grades. The menu manages both files: enrol students, enter marks, list with grades, class statistics, and a merit view. Two related files, one consistent system.

## Learning objectives

- manage **two related files** whose records join on a key
- compute derived fields (total, average, grade) as a pass over joined records
- keep referential integrity (marks without students are orphans — report them)
- produce a multi-report statistics layer over stored data

## Prerequisites

| Unit | What you need |
| --- | --- |
| [12](../files/index.md) | the load/mutate/save cycle, two-file thinking |
| [14 · records](../records/index.md) | nested-ish records, computed members |
| Project 8 | validation layers, views vs storage |

## Requirements

1. Two files, two contracts:
   - `students.csv`: `roll,name,programme` — rolls unique;
   - `marks.csv`: `roll,m1,m2,m3` — marks 0–100, roll must exist in `students.csv`.
   Each contract comment sits above its own load/save pair.
2. `struct StudentRecord { string roll, name, programme; int m[3]; int total; double average; char grade; bool hasMarks; };`
3. Menu: 1 list students · 2 enrol · 3 enter marks · 4 report card (one student) · 5 class statistics · 6 merit list · 0 save & quit.
4. Grades: A ≥ 240, B ≥ 210, C ≥ 180, D ≥ 150 (of 300), else F.
5. Marks for an unknown roll are refused; students without marks report `no marks yet` in listings.
6. Save writes both files; restart restores both.

## Functional requirements

| ID | Statement | Verified by |
| --- | --- | --- |
| F1 | enrol + enter marks + quit + restart preserves both | T1 |
| F2 | marks for an unknown roll are refused | T2 |
| F3 | report card shows all fields plus grade | T3 |
| F4 | class statistics cover every student with marks | T4 |
| F5 | merit list ranks students with marks; skips those without | T5 |
| F6 | orphan marks lines in `marks.csv` are skipped with a warning | T6 |

## Suggested data structures

- `vector<StudentRecord>` — one vector, joined at load: students first, then marks matched by roll.
- `findByRoll` — the join's engine and every operation's finder.
- Grade table as named constants inside `gradeFor`.

## Milestones

- **M1 — the students file.** Contract, loader, enrol, save. *Exit: T1 (students half) passes.*
- **M2 — the marks join.** Load marks by roll; the `hasMarks` flag; orphan refusal/skip. *Exit: T2, T6 pass.*
- **M3 — compute + report card.** The compute pass, gradeFor, the per-student view. *Exit: T3 passes.*
- **M4 — statistics + merit.** Class stats over marked students; the ranked view. *Exit: T4, T5 pass.*
- **M5 — the two-file restart.** Full persistence walk. *Exit: T1 passes end to end.*

## Tasks

1. Write both contracts, both loaders (students first), both savers.
2. Write the join pass: match marks lines to student records, set `hasMarks`.
3. Write the compute pass (total/average/grade) and `gradeFor`.
4. Write the four views (list, report card, statistics, merit).
5. Write enrol + enter-marks with their guards; assemble the menu.

## Test plan

| # | Scenario | Expected |
| --- | --- | --- |
| T1 | enrol 2, enter marks for 1, quit, restart | both students persist; one has marks, one reports `no marks yet` |
| T2 | enter marks for roll `X999` | refused: no such student |
| T3 | report card of the marked student | all fields, total/300, grade per table |
| T4 | class statistics with 2 marked students | count 2, class average, grade distribution |
| T5 | merit list with mixed marked/unmarked | only marked students ranked |
| T6 | `marks.csv` contains `GHOST,50,60,70` | warning at load; the line is skipped |

## Edge cases

- A student with marks whose *student* row was deleted — the join must handle the reverse orphan too (decide: drop the marks or refuse the deletion; document).
- Marks at the grade boundaries (240/210/180/150 totals) — one probe each.
- Two students with equal totals — the merit list's tie rule (first occurrence, or shared rank — choose and document).
- Empty either file — the system starts honestly and every view says so.

## Extension ideas

1. Delete a student (with the referential decision from the edge cases, implemented).
2. Update marks (re-enter overwrites — with a confirm prompt).
3. Export `report.csv` in merit order (Project 3 of the syllabus's output-artifact idea).

## Grading / self-assessment

[Shared rubric](index.md#the-shared-rubric-each-project-page-adds-its-specifics) plus:

- [ ] Both contracts exist as comments and both file pairs honour them (+1)
- [ ] No marks row can attach to a nonexistent student (+1)
- [ ] A restart after any sequence restores both files exactly (+1)

## Hints

1. Load students first, marks second, join in memory — the marks loader can then *check* rolls against the already-loaded vector.
2. `hasMarks` distinguishes "no marks yet" from "marks totaling zero" — without it the two states lie about each other.
3. The compute pass runs *after* the join and *before* any view — views never compute; they read computed fields.

## Complete reference solution

```cpp
// registrar.cpp — Programming Fundamentals Using C++
// Project 9 · The File-Based Student Management System
// Build: g++ -std=c++17 -Wall -Wextra registrar.cpp -o registrar

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <iomanip>
#include <stdexcept>
using namespace std;

// Contract students.csv: "roll,name,programme" — rolls unique, no commas in fields.
// Contract marks.csv:    "roll,m1,m2,m3"   — marks 0..100; roll must exist in students.csv.
// Each comment governs its own load/save pair; change them together.

struct StudentRecord {
    string roll, name, programme;
    int m[3] = {0, 0, 0};
    int total = 0;
    double average = 0.0;
    char grade = '-';
    bool hasMarks = false;
};

const int GRADE_A = 240, GRADE_B = 210, GRADE_C = 180, GRADE_D = 150;

char gradeFor(int total) {
    if (total >= GRADE_A) return 'A';
    if (total >= GRADE_B) return 'B';
    if (total >= GRADE_C) return 'C';
    if (total >= GRADE_D) return 'D';
    return 'F';
}

StudentRecord* findByRoll(vector<StudentRecord>& students, const string& roll) {
    for (StudentRecord& s : students)
        if (s.roll == roll) return &s;
    return nullptr;
}

int loadStudents(const string& path, vector<StudentRecord>& out) {
    ifstream in(path);
    if (!in) return 0;
    string line;
    int skipped = 0;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
        if (c2 == string::npos) { ++skipped; continue; }
        StudentRecord s;
        s.roll = line.substr(0, c1);
        s.name = line.substr(c1 + 1, c2 - c1 - 1);
        s.programme = line.substr(c2 + 1);
        if (s.roll.empty() || s.name.empty() || findByRoll(out, s.roll)) { ++skipped; continue; }
        out.push_back(s);
    }
    return skipped;
}

void saveStudents(const string& path, const vector<StudentRecord>& students) {
    ofstream out(path);
    for (const StudentRecord& s : students)
        out << s.roll << "," << s.name << "," << s.programme << "\n";
}

int loadMarks(const string& path, vector<StudentRecord>& students, vector<string>& orphans) {
    ifstream in(path);
    if (!in) return 0;
    string line;
    int skipped = 0;
    while (getline(in, line)) {
        if (line.empty()) continue;
        size_t c1 = line.find(',');
        size_t c2 = (c1 == string::npos) ? string::npos : line.find(',', c1 + 1);
        size_t c3 = (c2 == string::npos) ? string::npos : line.find(',', c2 + 1);
        size_t c4 = (c3 == string::npos) ? string::npos : line.find(',', c3 + 1);
        if (c4 == string::npos) { ++skipped; continue; }
        try {
            string roll = line.substr(0, c1);
            int m1 = stoi(line.substr(c1 + 1, c2 - c1 - 1));
            int m2 = stoi(line.substr(c2 + 1, c3 - c2 - 1));
            int m3 = stoi(line.substr(c3 + 1, c4 - c4 - 1));
            StudentRecord* s = findByRoll(students, roll);       // the join, enforced here
            if (!s) { orphans.push_back(roll); continue; }
            if (m1 < 0 || m1 > 100 || m2 < 0 || m2 > 100 || m3 < 0 || m3 > 100) { ++skipped; continue; }
            s->m[0] = m1; s->m[1] = m2; s->m[2] = m3;
            s->hasMarks = true;
        } catch (const exception&) {
            ++skipped;
        }
    }
    return skipped;
}

void saveMarks(const string& path, const vector<StudentRecord>& students) {
    ofstream out(path);
    for (const StudentRecord& s : students)
        if (s.hasMarks)
            out << s.roll << "," << s.m[0] << "," << s.m[1] << "," << s.m[2] << "\n";
}

void computeAll(vector<StudentRecord>& students) {              // views never compute
    for (StudentRecord& s : students) {
        if (!s.hasMarks) continue;
        s.total = s.m[0] + s.m[1] + s.m[2];
        s.average = s.total / 3.0;
        s.grade = gradeFor(s.total);
    }
}

void printCard(const StudentRecord& s) {
    cout << "  " << s.roll << " " << s.name << " (" << s.programme << ")\n";
    if (!s.hasMarks) { cout << "    no marks yet\n"; return; }
    cout << "    marks: " << s.m[0] << " " << s.m[1] << " " << s.m[2]
         << " — total " << s.total << "/300, grade " << s.grade << "\n";
}

int main() {
    const string STUDENTS = "students.csv", MARKS = "marks.csv";
    vector<StudentRecord> students;
    vector<string> orphans;

    int skippedStudents = loadStudents(STUDENTS, students);
    int skippedMarks = loadMarks(MARKS, students, orphans);
    for (const string& roll : orphans)
        cout << "warning: marks for unknown roll " << roll << " skipped\n";
    if (skippedStudents || skippedMarks)
        cout << "Skipped " << skippedStudents << " student line(s), "
             << skippedMarks << " marks line(s)\n";
    computeAll(students);
    cout << "Loaded " << students.size() << " students\n";

    int choice;
    do {
        cout << "\n1 List · 2 Enrol · 3 Enter marks · 4 Report card · "
                "5 Statistics · 6 Merit · 0 Save & quit: ";
        cin >> choice;
        cin.ignore(1000, '\n');

        if (choice == 1) {
            for (const StudentRecord& s : students) printCard(s);
        } else if (choice == 2) {
            StudentRecord s;
            cout << "Roll: ";       getline(cin, s.roll);
            if (findByRoll(students, s.roll)) { cout << "Refused: roll exists\n"; continue; }
            cout << "Name: ";       getline(cin, s.name);
            cout << "Programme: ";  getline(cin, s.programme);
            students.push_back(s);
            cout << "Enrolled\n";
        } else if (choice == 3) {
            cout << "Roll: ";
            string roll; getline(cin, roll);
            StudentRecord* s = findByRoll(students, roll);
            if (!s) { cout << "Refused: no such student\n"; continue; }
            cout << "Three marks (0-100): ";
            cin >> s->m[0] >> s->m[1] >> s->m[2];
            while (s->m[0] < 0 || s->m[0] > 100 || s->m[1] < 0 || s->m[1] > 100
                   || s->m[2] < 0 || s->m[2] > 100) {
                cout << "All marks are 0-100: ";
                cin >> s->m[0] >> s->m[1] >> s->m[2];
            }
            s->hasMarks = true;
            computeAll(students);                                // recompute after mutation
            cout << "Recorded — grade " << s->grade << "\n";
        } else if (choice == 4) {
            cout << "Roll: ";
            string roll; getline(cin, roll);
            StudentRecord* s = findByRoll(students, roll);
            if (s) printCard(*s);
            else   cout << "No such student\n";
        } else if (choice == 5) {
            int marked = 0;
            long long grand = 0;
            int dist[5] = {0, 0, 0, 0, 0};                       // A B C D F
            for (const StudentRecord& s : students) {
                if (!s.hasMarks) continue;
                ++marked;
                grand += s.total;
                switch (s.grade) {
                    case 'A': ++dist[0]; break;
                    case 'B': ++dist[1]; break;
                    case 'C': ++dist[2]; break;
                    case 'D': ++dist[3]; break;
                    default:  ++dist[4]; break;
                }
            }
            if (marked == 0) { cout << "No marks recorded yet\n"; continue; }
            cout << "Marked students: " << marked << "\n";
            cout << "Class average: " << fixed << setprecision(2)
                 << static_cast<double>(grand) / marked << "\n";
            cout << "Grades: A:" << dist[0] << " B:" << dist[1] << " C:" << dist[2]
                 << " D:" << dist[3] << " F:" << dist[4] << "\n";
        } else if (choice == 6) {
            vector<StudentRecord> ranked;
            for (const StudentRecord& s : students)
                if (s.hasMarks) ranked.push_back(s);
            sort(ranked.begin(), ranked.end(),
                 [](const StudentRecord& a, const StudentRecord& b) { return a.total > b.total; });
            int rank = 1;
            for (const StudentRecord& s : ranked)
                cout << "  " << rank++ << ". " << s.name << " (" << s.roll
                     << ") total " << s.total << " grade " << s.grade << "\n";
            if (ranked.empty()) cout << "  nobody has marks yet\n";
        } else if (choice != 0) {
            cout << "Invalid choice\n";
        }
    } while (choice != 0);

    saveStudents(STUDENTS, students);
    saveMarks(MARKS, students);
    cout << "Saved " << students.size() << " students — goodbye\n";
    return 0;
}
```

## Explanation of important design decisions

- **The join is enforced at load, not assumed.** `loadMarks` calls `findByRoll` on every line — an orphan (marks for a ghost roll) is *impossible in memory* and *reported from the file*. Referential integrity is the two-file system's defining risk; putting the check in the join pass means every later operation can trust it.
- **Computed fields are computed once, in one pass.** `computeAll` fills total/average/grade after the join and after every marks mutation; the four views only read. The alternative — computing inside each view — would re-implement `gradeFor`'s table per view and drift.
- **`hasMarks` makes "not yet" representable.** A student exists before their marks do; without the flag, zero-valued marks would impersonate "no marks yet". The distinction drives the listing (`no marks yet`), the statistics (marked only), and the merit filter — one flag, three honest behaviours.
- **Deletion is deliberately absent.** The edge case (marks whose student vanishes) is a real design question — the extension asks you to implement it *with* the referential decision made explicitly. Leaving deletion out of the core keeps the first build's invariants provable; adding it knowingly is the lesson.

[← Project 8](project-08-contacts.md) · [Projects home](index.md) · Next: [Project 10 — The Integrated OOP Management System](project-10-oop-system.md)

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
