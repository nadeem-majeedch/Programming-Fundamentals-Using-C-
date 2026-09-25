---
title: "Modular Programming Exercises — 15 Problems"
description: "Fifteen graded exercises in two parts — the header/source mechanics (declarations, guards, namespaces, includes) and building/design (staged builds, layout, modularity tests, cycles) — solutions in a separated section."
---

# Exercises — 15 problems

> [← Module home](index.md) · Attempt each in writing **before** opening its solution — the [course protocol](../how-to-study.md). Part A: [Lesson 1](lesson-1-headers-sources.md) mechanics. Part B: [Lesson 2](lesson-2-building-organizing.md) building and design.

## Part A — the header/source mechanics (E1–E8)

- **E1 ★ — Declare or define?** Classify each line — declaration, definition, or neither — and say what the linker does with each: `int add(int, int);` · `int add(int a, int b) { return a + b; }` · `extern int tally;` · `int tally = 0;` · `class Box { int size_; };`
- **E2 ★ — The guarded header.** Write `geometry.h` declaring `double circleArea(double r);` and `struct Point { double x, y; };` — twice: once with include guards, once with `#pragma once`. Then list the three lines that differ between the versions.
- **E3 ★ — The twice-included header.** `a.h` includes `common.h`; `main.cpp` includes both `a.h` and `common.h`. Write the paste sequence `main.cpp`'s TU receives with and without a guard in `common.h`, and the compiler verdict in each case (assume `common.h` defines `struct Config { int level; };`).
- **E4 ★ — Namespace placement.** Fix this header — two violations of the module's rules are hiding in it:
  ```cpp
  #pragma once
  using namespace std;
  #include <string>
  string trim(const string& s);
  }
  ```
- **E5 ★ — The class split.** Given the class declaration below, write the out-of-class definition of both methods as they belong in `counter.cpp` (namespace `util`):
  ```cpp
  namespace util {
  class Counter {
  public:
      explicit Counter(int start);
      int next();                       // post-increment style: returns then advances
  private:
      int value_;
  };
  }
  ```
- **E6 ★ — Own header first.** Explain, in two sentences, why `student.cpp` includes `"student.h"` before anything else — and what concrete failure this ordering catches that a casual include order hides.
- **E7 ★★ — Include-what-you-use.** `textutil.h` declares `std::string toUpper(const std::string&);` — and nothing else. Which standard headers must it include, and which popular extra include is *wrong* (and costs every includer compile time)? Then: `textutil.cpp`'s body uses `std::toupper` — which header does the **.cpp** add, and why not the header?
- **E8 ★★ — The forward declaration.** `report.h` must contain `void printSummary(const Course& c);` and `Course* findCourse(const std::string& title);` but must NOT include `course.h`. Write the complete `report.h` (guards, namespace `reports`), and state the one thing the header *cannot* do with `Course` that would force the include anyway.

## Part B — building and design (E9–E15)

- **E9 ★ — The staged build.** A project has `main.cpp`, `mathkit.cpp`, `mathkit.h`. Write the full one-shot command and the full staged build (both phases). Then state exactly which commands re-run after editing `mathkit.cpp` — and which after editing `mathkit.h`.
- **E10 ★ — The -I flag.** Headers move from the project root into `include/`; sources stay in `src/`. Write the one-shot build command, and explain in one sentence what breaks without `-Iinclude`.
- **E11 ★★ — Modularity tests.** A teammate's `helpers.h` declares: a string trimmer, a student-GPA calculator, and the program's menu printer. Apply the module's four modularity tests (one job; owns its data; swappable; stranger-usable) and write the verdict plus the proposed module split.
- **E12 ★★ — The cycle.** `teacher.h` includes `course.h`; `course.h` includes `teacher.h`. Both need each other's full class definitions (a teacher holds copies of course titles; a course stores its teacher's name *as a `Teacher` value*). Draw the cycle, then choose and justify a fix from Lesson 2 §5's three refactors — and write the resulting pair of headers.
- **E13 ★★ — Ownership across modules.** `main` creates `Student` objects; `Course::enrol(Student& s)` stores them. A teammate proposes `Course` should store `vector<unique_ptr<Student>>` "so it owns them safely." Write the verdict: what breaks (name the lifetime question), and which design the example project chose — with the one-sentence ownership rule.
- **E14 ★★ — The reusable module.** Take `textutil` from the [example project](example-project.md) and prove reusability three ways: (a) compile it alone; (b) write a two-line `stranger.cpp` in a *different* folder that uses `textutil::countWords`, with its build command; (c) list the properties of the header that made (b) possible without any other project file.
- **E15 ★★★ — The thin main.** A `main.cpp` has grown to 300 lines: file loading, a menu loop, statistics, and report printing, all inline. Redesign: name the modules, draw the dependency diagram (one-way), and write the *new* `main`'s full body — it should fit in a dozen lines. Which module owns the error net, and which owns none?

---

## Solutions

*(Attempt first — the solutions give reasoning and representative code, not the only shape.)*

**E1.** Declaration: `int add(int, int);` and `extern int tally;` — shapes announced, no body/storage; the linker expects the definition *elsewhere*. Definition: the function body, `int tally = 0;` (storage allocated — **this** is what fills the linker's hole), and the class body (per-TU shape; methods still need definitions). Neither: —. The linker verdicts: a call to `add` in a TU with only the declaration produces an *undefined reference* unless some TU defines it; two TUs defining `int tally = 0;` produce *multiple definition*; the class definition repeating across TUs is legal (identical-shape rule, Lesson 1 §1).

**E2.**

```cpp
// guard version                          // pragma version
#ifndef GEOMETRY_H                        #pragma once
#define GEOMETRY_H
...declarations...                        ...declarations...
#endif  // GEOMETRY_H
```

Three lines differ: `#ifndef GEOMETRY_H` (gone), `#define GEOMETRY_H` (gone), `#endif` (gone) — replaced by the single `#pragma once`. Same protection, different mechanism: macro-identity vs file-identity.

**E3.** *Without a guard:* `main.cpp`'s TU receives `common.h` **twice** — first via `#include "a.h"`, again via `#include "common.h"`: `struct Config` is defined twice **in one TU** → compiler error: *redefinition of `struct Config`*. *With the guard:* first paste defines `COMMON_H`; second paste's `#ifndef` skips to `#endif` — zero content — one `Config`, clean compile. (Two different TUs each carrying one copy is always fine; the guard's job is repeats *within* a TU.)

**E4.** The two violations: (1) `using namespace std;` in a header — pastes the whole standard namespace into every includer's TU, re-importing the collision risk namespaces exist to prevent (Lesson 1 §5's header rule); (2) the stray closing `}` — a namespace was never opened (and the intended one is missing entirely). Fixed:

```cpp
#pragma once
#include <string>

namespace textutil {
std::string trim(const std::string& s);
}
```

**E5.**

```cpp
#include "counter.h"

namespace util {

Counter::Counter(int start) : value_(start) {}

int Counter::next() {
    int current = value_;      // return-then-advance: the post-increment contract
    ++value_;
    return current;
}

}  // namespace util
```

Every definition is qualified with `Counter::` and wrapped in the namespace — the class shape lives in the header; the delivery lives once, here.

**E6.** Including the own header first makes the `.cpp` *prove* the header stands alone: if the header secretly depends on a type or include some earlier includer happened to provide, the `.cpp` fails immediately at its first line instead of failing later — in a stranger's file that includes the header in a different order. It converts an order-dependent time bomb into a same-day, first-line error (Lesson 1 §6's rule, operationalised).

**E7.** The header needs `<string>` only — the `std::string` in the signature is the only standard name it uses. The popular wrong extra: `<iostream>` (habit, not need) — every includer of `textutil.h` would compile the whole I/O machinery for a header that never prints. The `.cpp` adds `<cctype>` for `std::toupper` — a body-only dependency belongs in the body's file; putting it in the header would tax includers for an implementation detail.

**E8.**

```cpp
// report.h
#pragma once

#include <string>

namespace courses { class Course; }        // forward declaration: the name, not the insides

namespace reports {

void printSummary(const courses::Course& c);
courses::Course* findCourse(const std::string& title);

}
```

The forcing event: any line that needs the full type — `c.getAverage()`, `sizeof(Course)`, holding a `Course` *value* member, or inheriting from it. References and pointers need only the name (Lesson 2 §5's "headers may name; sources use").

**E9.** One-shot: `g++ -std=c++17 -Wall -Wextra main.cpp mathkit.cpp -o app`. Staged: `g++ -std=c++17 -Wall -Wextra -c main.cpp -o main.o` · `g++ -std=c++17 -Wall -Wextra -c mathkit.cpp -o mathkit.o` · `g++ main.o mathkit.o -o app`. After editing `mathkit.cpp`: recompile `mathkit.o`, relink — two commands. After editing `mathkit.h`: **both** objects are stale (every TU that pasted the header changed), so recompile both, relink — three commands. The asymmetry is the whole economy of separate compilation.

**E10.** `g++ -std=c++17 -Wall -Wextra -Iinclude src/main.cpp src/mathkit.cpp -o app`. Without `-Iinclude`, `#include "mathkit.h"` is searched relative to the *including file* (`src/`) and the include directory — the header isn't there, so the build dies with `fatal error: mathkit.h: No such file or directory` before a single type is checked. The flag adds `include/` to the preprocessor's search path.

**E11.** Verdict: fails test 1 (three jobs in one sentence) and therefore tests 2–4. The split: `textutil`-style module for the trimmer (a leaf utility, stranger-usable); a `records`/`academics` module owning the GPA calculation (it knows the scale policy — that is *its* data's meaning); the menu printer is *presentation* — it belongs in the application layer beside `main` (it changes for every program that reuses the other two). The meta-lesson: mixed-kind modules ("helpers") are the file-shaped version of the god-class the OOP module audited.

**E12.** The cycle: `teacher.h ──► course.h ──► teacher.h`. Both want the *other's full type as a value member* — that is the tell. Fix choice: **redesign the dependency direction** (refactor 2). Truth-test: a course *has one* teacher (stable association); a teacher *teaches many* courses (a derived view). So `course.h` may include `teacher.h` (a `const Teacher&` member or a name string is enough — the honest version stores the teacher's name or a reference); `teacher.h` keeps only a **forward declaration** of `Course` plus, if it needs the list, a `std::vector<std::string>` of titles it was constructed with. Result:

```cpp
// teacher.h                       // course.h
#pragma once                        #pragma once
#include <string>                   #include <string>
#include <vector>                   #include "teacher.h"     // the one legal arrow
namespace school {                  namespace school {
  class Course;  // forward           class Course {
  class Teacher {                       ...
    std::vector<std::string>            ...
      taughtTitles_;                   private:
  };                                     const Teacher* teacher_;   // or a name string
}                                     };
                                      }
```

Refactor 1 (forward declarations) alone cannot hold *values* — refactor 3 (a shared leaf) would fit if both needed the same *data*; here the lifetime question settles it: the teacher does not own the courses.

**E13.** Verdict: rejected — the proposal breaks the lifetime question. If `Course` owns students via `unique_ptr`, then *enrolling* must move the student *out of main's ownership* (or the two structures fight over one object — the double-free family the Modern C++ module's D-hunts excavated). Worse: two courses enrolling one student is now impossible *and* the student's independent lifetime (drop the course → student dies?) becomes nonsense. The example project's choice: **main owns the `Student` objects; the course holds non-owning views** (`Student*`/`Student&`), with the ask-door `enrol` refusing duplicates. One-sentence rule: **the owner is whoever's lifetime governs the object's — containers and scopes own; associations view.**

**E14.** (a) `g++ -std=c++17 -Wall -Wextra -c textutil.cpp` — succeeds with no other project file: it needs only its own header and `<cctype>`. (b)

```text
stranger/
└── trytext.cpp     #include "textutil.h"
                    int main() { return textutil::countWords("one two three"); }
```

Build: `g++ -std=c++17 -I../school/include trytext.cpp ../school/src/textutil.cpp -o try` — the stranger pulls one module's source plus its header and nothing else. (c) The header's reusable properties: complete contract (all four functions declared with types and contract comments); own namespace (`textutil::` — no collision with the stranger's names); minimal includes (`<string>`, `<vector>` only); no application types, no `main`, no globals; pragma-protected.

**E15.** Modules and diagram:

```text
main.cpp ──► loader.h ──► (leaf: <string>, <vector>, student.h)
main.cpp ──► stats.h   ──► (leaf over the data types)
main.cpp ──► report.h  ──► textutil.h (leaf)
main.cpp ──► menu.h    ──► stats.h, report.h (the interaction layer)
```

The new thin main:

```cpp
int main() {
    try {
        auto students = loader::load("students.txt");     // owns the data
        menu::run(students);                              // menu drives stats/report
    }
    catch (const std::exception& e) {                     // the app-level net lives HERE
        std::cerr << "error: " << e.what() << "\n";
        return 1;
    }
    return 0;
}
```

Error-net ownership: **`main` owns the top-level net** (the Robustness module's layer 4 — the app layer decides fate); **modules own none** — they throw typed failures upward (loader throws `FileError`; stats refuses empty input) and never catch-and-continue. The twelve-line `main` is the deliverable's proof: if it grew again, a module is missing.
