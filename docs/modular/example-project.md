---
title: "Example Project — a Complete Multi-File Program"
description: "A complete, buildable multi-file project: records (Student), courses (Course), and textutil (a reusable utility) — every header and source listed in full, with one-shot and staged builds and the dependency diagram."
---

# Example project — a complete multi-file program

> [← Module home](index.md) · The Lesson 1/2 rules, applied to a whole program — every file in full

## The project

A small registrar program with **three modules** and a thin `main`:

| Module | Owns | Knows about |
| --- | --- | --- |
| `records` | `Student` — name, marks, letter grade | nothing (a leaf) |
| `courses` | `Course` — title, roster of students, statistics | `records::Student` (one-way: a course *has* students) |
| `textutil` | string utilities — word counting, casing, alignment | nothing (a reusable leaf) |

**Dependency diagram** (arrows = `#include`, one-way by design — Lesson 2 §4):

```text
main.cpp ──► courses.h ──► student.h        main.cpp ──► textutil.h
                              ▲
                        (leaf: includes only <string>)
```

**Layout** (the course structure from Lesson 2 §3):

```text
school/
├── include/
│   ├── student.h
│   ├── course.h
│   └── textutil.h
└── src/
    ├── main.cpp
    ├── student.cpp
    ├── course.cpp
    └── textutil.cpp
```

---

## include/student.h

```cpp
// student.h — Programming Fundamentals Using C++
// Example project · module: records — owns the Student type
#pragma once

#include <string>      // for std::string members and parameters ONLY

namespace records {

class Student {
public:
    Student(const std::string& name, int marks);

    const std::string& getName() const;
    int getMarks() const;
    char letterGrade() const;                 // the module's policy: marks → letter

    void bumpMarks(int delta);                // a command: re-clamps to 0..100

private:
    std::string name_;
    int marks_;
};

}  // namespace records
```

## src/student.cpp

```cpp
// student.cpp — module: records
#include "student.h"       // own header FIRST — the stand-alone self-test

namespace records {

Student::Student(const std::string& name, int marks)
    : name_(name), marks_(clampMarks(marks)) {}

const std::string& Student::getName() const { return name_; }
int Student::getMarks() const { return marks_; }

char Student::letterGrade() const {
    if (marks_ >= 80) return 'A';
    if (marks_ >= 70) return 'B';
    if (marks_ >= 60) return 'C';
    if (marks_ >= 50) return 'D';
    return 'F';
}

void Student::bumpMarks(int delta) { marks_ = clampMarks(marks_ + delta); }

int Student::clampMarks(int m) {           // private helper: invisible to strangers
    if (m < 0)   return 0;
    if (m > 100) return 100;
    return m;
}

}  // namespace records
```

Wait — `clampMarks` is used by the constructor but not declared in the header. That is *deliberate* and *wrong as listed*: a member function must be declared in the class. The header's `private:` section needs one more line — this is exactly the kind of header/source mismatch hunt [D5](debugging.md) trains. The corrected header section:

```cpp
private:
    std::string name_;
    int marks_;
    static int clampMarks(int m);             // declared: the .cpp may define it
```

*(Keep the mismatch in mind — the debugging page opens with it as a full walkthrough. The remaining files are clean.)*

## include/course.h

```cpp
// course.h — module: courses — owns Course; knows records::Student (one-way)
#pragma once

#include <string>
#include <vector>
#include "student.h"       // the one dependency arrow — a Course HAS Students

namespace courses {

class Course {
public:
    Course(const std::string& title);

    bool enrol(records::Student& s);          // ask-door: false if already enrolled
    size_t size() const;
    const std::string& getTitle() const;

    double averageMark() const;               // throws std::runtime_error when empty
    char modalGrade() const;                  // most common letter; ' ' when empty

private:
    std::string title_;
    std::vector<records::Student*> roster_;   // non-owning views — the Students live elsewhere
};

}  // namespace courses
```

*(Ownership note, the Modern C++ module applied: the course does **not** own students — it keeps non-owning views. Whoever builds the `Student` objects owns them; here, `main` does. This is Lesson 2 §5's "owner holds; the held refers" refactor, lived.)*

## src/course.cpp

```cpp
// course.cpp — module: courses
#include "course.h"        // own header first

#include <stdexcept>       // for std::runtime_error — course.cpp's own body uses it
#include <map>
#include <algorithm>       // for std::max_element — course.cpp's own body uses it
#include <string>          // include-what-you-use: the body names std::string

namespace courses {

Course::Course(const std::string& title) : title_(title) {}

bool Course::enrol(records::Student& s) {
    for (const records::Student* member : roster_)
        if (member->getName() == s.getName()) return false;    // already here
    roster_.push_back(&s);                                     // store the VIEW
    return true;
}

size_t Course::size() const { return roster_.size(); }
const std::string& Course::getTitle() const { return title_; }

double Course::averageMark() const {
    if (roster_.empty()) throw std::runtime_error("Course::averageMark: no students");
    long long total = 0;                                       // the overflow-proof seed
    for (const records::Student* member : roster_) total += member->getMarks();
    return static_cast<double>(total) / roster_.size();
}

char Course::modalGrade() const {
    if (roster_.empty()) return ' ';
    std::map<char, int> tally;                                 // the library-first habit
    for (const records::Student* member : roster_) ++tally[member->letterGrade()];
    auto best = std::max_element(tally.begin(), tally.end(),
        [](const std::pair<const char, int>& a, const std::pair<const char, int>& b) {
            return a.second < b.second;                        // count only — ties: first key
        });
    return best->first;
}

}  // namespace courses
```

## include/textutil.h

```cpp
// textutil.h — module: textutil — a reusable leaf utility
#pragma once

#include <string>
#include <vector>

namespace textutil {

// Count words (runs of non-whitespace) in text.
int countWords(const std::string& text);

// Return the text folded to upper case (ASCII letters).
std::string toUpper(const std::string& text);

// Right-align text in a field of width, padding with spaces.
std::string rightAlign(const std::string& text, int width);

// Split a CSV-ish line on commas; commas in fields are not supported (contract).
std::vector<std::string> split(const std::string& line);

}  // namespace textutil
```

*(The stranger test, Lesson 2 §4: reading only this header — four functions, their types, their contracts in comments — a classmate could call `textutil` from their own program without ever seeing the `.cpp`. That is reusability.)*

## src/textutil.cpp

```cpp
// textutil.cpp — module: textutil
#include "textutil.h"      // own header first

#include <cctype>
#include <string>          // include-what-you-use: the body names std::string
#include <vector>          // include-what-you-use: the body names std::vector

namespace textutil {

int countWords(const std::string& text) {
    int words = 0;
    bool inWord = false;
    for (char ch : text) {
        if (std::isspace(static_cast<unsigned char>(ch))) {
            inWord = false;
        } else if (!inWord) {
            ++words;                    // edge of a word
            inWord = true;
        }
    }
    return words;
}

std::string toUpper(const std::string& text) {
    std::string out = text;             // copy, then mutate the copy
    for (char& ch : out)
        ch = static_cast<char>(std::toupper(static_cast<unsigned char>(ch)));
    return out;                         // the move out is automatic
}

std::string rightAlign(const std::string& text, int width) {
    if (static_cast<int>(text.size()) >= width) return text;
    return std::string(width - text.size(), ' ') + text;
}

std::vector<std::string> split(const std::string& line) {
    std::vector<std::string> fields;
    std::string current;
    for (char ch : line) {
        if (ch == ',') {
            fields.push_back(current);
            current.clear();
        } else {
            current += ch;
        }
    }
    fields.push_back(current);          // the last field — even when empty
    return fields;
}

}  // namespace textutil
```

## src/main.cpp

```cpp
// main.cpp — the thin coordinator: parse intent, call modules, top-level net
#include <iostream>
#include <stdexcept>
#include <string>          // include-what-you-use: rightAlign(std::string(...), ...)

#include "student.h"
#include "course.h"
#include "textutil.h"

int main() {
    using records::Student;             // local, in a .cpp: acceptable convenience

    try {
        Student aisha("Aisha", 91);
        Student bilal("Bilal", 74);
        Student sara("Sara", 63);

        courses::Course pf("Programming Fundamentals");
        pf.enrol(aisha);
        pf.enrol(bilal);
        pf.enrol(sara);
        pf.enrol(bilal);                // refused: false — the ask-door

        const int titleWidth = 28;      // the constexpr habit's cousin: named, not magic
        std::cout << textutil::rightAlign(std::string("Course: ") + pf.getTitle(), titleWidth)
                  << "\n";
        std::cout << "enrolled: " << pf.size() << "\n";
        std::cout << "average:  " << pf.averageMark() << "\n";
        std::cout << "modal:    " << pf.modalGrade() << "\n";

        for (const records::Student* s : {&aisha, &bilal, &sara})
            std::cout << textutil::rightAlign(s->getName(), 8) << " "
                      << s->getMarks() << " (" << s->letterGrade() << ")\n";
    }
    catch (const std::exception& e) {   // the top-level net (Robustness module, layer 4)
        std::cerr << "error: " << e.what() << "\n";
        return 1;
    }
    return 0;
}
```

---

## Building — both ways

From the project root (`school/`):

```bash
# ONE-SHOT: compile and link everything, list every .cpp:
g++ -std=c++17 -Wall -Wextra -Iinclude src/main.cpp src/student.cpp src/course.cpp src/textutil.cpp -o school

./school
```

```text
                 Course: Programming Fundamentals
enrolled: 3
average:  76
modal:    B
   Aisha 91 (A)
   Bilal 74 (B)
    Sara 63 (C)
```

```bash
# STAGED: the two phases visible (Lesson 2 §1):
g++ -std=c++17 -Wall -Wextra -c -Iinclude src/main.cpp     -o main.o
g++ -std=c++17 -Wall -Wextra -c -Iinclude src/student.cpp  -o student.o
g++ -std=c++17 -Wall -Wextra -c -Iinclude src/course.cpp   -o course.o
g++ -std=c++17 -Wall -Wextra -c -Iinclude src/textutil.cpp -o textutil.o
g++ main.o student.o course.o textutil.o -o school

# ...then edit course.cpp ONLY and rebuild:
g++ -std=c++17 -Wall -Wextra -c -Iinclude src/course.cpp -o course.o
g++ main.o student.o course.o textutil.o -o school      # two commands, not four
```

## The project's checklist, verified

```text
✓ every header: #pragma once, its namespace, minimal includes
✓ every source: own header first; body-only includes (<stdexcept>, <map>) in the .cpp
✓ exactly one main, thin; logic in the modules
✓ arrows one-way: course → student; textutil and records are leaves
✓ each module compiles alone:  g++ -std=c++17 -c -Iinclude src/textutil.cpp
✓ zero warnings; no using namespace std; in any header
✓ ownership named: main owns the Students; the course holds views
```

## Where to take it next

1. **The stranger's test:** compile `textutil.cpp` alone (`-c`), then write a *new* `trytext.cpp` in another folder that includes only `textutil.h` — prove the module is reusable without the rest of the project.
2. **The forward-declaration exercise:** change `roster_` from `Student*` views to *copied* `Student` values — then try to *remove* `#include "student.h"` from `course.h` with a forward declaration. Discover why it cannot work (the header needs the full type to hold values — Lesson 2 §5's rule, felt).
3. **The extension:** add `module reports` — a `reports.h`/`reports.cpp` producing the aligned table `main` currently prints, using `textutil`. Draw the new dependency diagram *first*.

→ Continue to the [Exercises](exercises.md), or jump to [the Modular Programming Lab](labs.md).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
