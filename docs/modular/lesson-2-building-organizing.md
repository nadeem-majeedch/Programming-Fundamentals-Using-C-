---
title: "Lesson 2 — Building and Organizing"
description: "Separate compilation and the linker, compiling multiple files from the command line, object files, project layout, modular design and reusable modules, circular dependencies, and organizing classes and functions."
---

# Lesson 2 — building and organizing

> [← Module home](index.md) · [← Lesson 1 — the header/source split](lesson-1-headers-sources.md) · [Example project →](example-project.md)

## In this lesson you will learn

- **separate compilation** — how each `.cpp` becomes an object file and what the **linker** does with them
- to compile multi-file programs **from the command line** — one-shot and staged
- the **project layout** this course uses from the capstone onward
- **modular design**: how to decide what becomes a module, and what makes a module reusable
- **circular dependencies** — why they break builds and the two refactors that fix them
- how to organize **classes and functions** as a program grows

## 1. Separate compilation — the build, step by step

Lesson 1 said each `.cpp` compiles as a blind translation unit. Here is where the blindness gets paid off. Building a two-file program is two phases:

```text
                PHASE 1 — compile (per .cpp, independent)
main.cpp   ──► g++ -c ──►  main.o         (machine code + "IOUs": needs records::show)
student.cpp ─► g++ -c ──►  student.o      (machine code + the IOUs' fulfilment)

                PHASE 2 — link (one linker run)
main.o ─┐
        ├──►  g++ ──►  app                 (IOUs matched: every name resolves,
student.o ┘                                 or "undefined reference" is reported)
```

The **compiler** translates each `.cpp` to an **object file** (`.o`/`.obj`) — machine code with *holes* where outside names appear. The **linker** merges object files (and libraries), filling every hole with a definition from some other object. If a hole has no fill: **undefined reference** — the classic link error, met properly in hunt [D1](debugging.md). If a name has *two* fills: **multiple definition** — hunt [D2](debugging.md).

Why bother with two phases instead of compiling everything at once? **Recompilation is per-file.** Change `student.cpp`, and only `student.o` rebuilds — `main.o` is untouched (it never depended on `student.cpp`'s *contents*, only on `student.h`'s *promise*). In a hundred-file project this is the difference between a 2-second and a 2-minute build. This is the engineering payoff of the header/source split: **promises are cheap to re-read; deliveries are expensive to re-translate.**

## 2. The command line, both ways

All examples use `g++` (the [Getting Started](../getting-started/compiler-setup/online-compilers.md) module's compiler); every flag below works the same on Windows/Linux/macOS g++ or MinGW.

**The one-shot build** — what you have done all course, now with many files:

```bash
# compile AND link in one command:
g++ -std=c++17 -Wall -Wextra main.cpp student.cpp course.cpp textutil.cpp -o school

./school          # run (Windows: school.exe, or .\school.exe)
```

List **every `.cpp`** — never a header (headers are included, not compiled). The command hides the two phases; it runs them for you and deletes the intermediate `.o` files.

**The staged build** — the two phases, made visible:

```bash
# PHASE 1: compile each source to an object file (-c = compile only, do not link)
g++ -std=c++17 -Wall -Wextra -c main.cpp       -o main.o
g++ -std=c++17 -Wall -Wextra -c student.cpp    -o student.o
g++ -std=c++17 -Wall -Wextra -c course.cpp     -o course.o
g++ -std=c++17 -Wall -Wextra -c textutil.cpp   -o textutil.o

# PHASE 2: link the objects into the executable
g++ main.o student.o course.o textutil.o -o school
```

Now edit `course.cpp` only, and the rebuild is:

```bash
g++ -std=c++17 -Wall -Wextra -c course.cpp -o course.o
g++ main.o student.o course.o textutil.o -o school
```

Four commands become two — the economy that motivates build tools (`make`), which watch timestamps and run exactly the stale steps. This course stays at the command line; the capstone's build is one command away from this section.

**The header-search flag**, needed the day headers move into a folder:

```bash
g++ -std=c++17 -Wall -Wextra -Iinclude src/*.cpp -o school
#                              └── #include "student.h" now searches include/ first
```

**The object/pointer note for the lab:** the same staged build works unchanged for programs using classes from several modules — `main.o` needs only the headers it included; the linker pulls the rest from the other objects. Nothing about linking cares which file *defined* a class's methods — only that exactly one object does.

## 3. Project layout — the course's structure

From this module to the capstone, projects follow one shape:

```text
school/
├── include/                 ← ALL headers: the public contracts
│   ├── student.h
│   ├── course.h
│   └── textutil.h
├── src/                     ← ALL sources: the deliveries
│   ├── main.cpp             (thin: parses intent, calls modules)
│   ├── student.cpp
│   ├── course.cpp
│   └── textutil.cpp
├── data/                    ← input files (students.txt, courses.txt)
├── tests/                   ← the Debugging module's regression harnesses
│   └── test_student.cpp
└── Makefile / build notes   ← the build recipe (or this page's commands)
```

The two-folder split (`include/` + `src/`) is the discipline of Lesson 1 made visible: **contracts in one place, deliveries in another.** A consumer of your module needs only `include/`; a builder needs both. Alternative — headers beside their sources (`src/student.h` + `src/student.cpp`) — is equally standard for single-purpose projects; the course uses the split because it makes the "what does this module *offer*" question answerable by opening one folder. (Both appear in [tasks T5](tasks.md) — you will migrate between them.)

Naming conventions worth adopting early: files named after their module (`student.*`, `textutil.*`), one class-or-cluster per module, `main.cpp` thin.

## 4. Modular design — deciding what becomes a module

The design question is not "how many files?" but "**which responsibilities are independent enough to own their own file?**" The tests, in order:

1. **One job, stated in a sentence.** "Manage student records" ✓. "Utilities and students and menus" ✗ — that is three sentences (the OOP module's one-job rule, applied to files).
2. **Knows its own data.** A module's functions operate on types the module owns (`records` owns `Student`). If two "modules" both manipulate one type, one module is missing.
3. **Swappable in principle.** Could the module be replaced without rewriting the rest? (`textutil` could become a better tokenizer; `records` could persist differently.) If every change drags the whole program along, the boundaries are wrong.
4. **A stranger could use it.** Could a classmate take your module and call it from *their* program, reading only the header? That is **reusability** — the property that turns code into a toolkit.

The dependency picture — who includes whom — is the design's x-ray:

```text
main.cpp ──► records.h ──► (nothing: records is a leaf)
main.cpp ──► course.h ──► student.h        (a Course HAS Students — one-way)
main.cpp ──► textutil.h ──► (nothing: a utility leaf)
```

**Arrows point one way.** `course.h` may know about `student.h` (a course *contains* students — the composition relation from the OOP module); `student.h` must never know about `course.h`. The moment arrows run both ways, the next section applies.

### The reusable-module test, formalised

A module is reusable when: (a) its header reads as a complete contract (a stranger needs no other file); (b) it uses *its own* namespace; (c) it has **no `main`**, no interactive prompts unless its job is interaction, no global state; (d) it compiles alone: `g++ -c textutil.cpp` succeeds with no other project file. Condition (d) is the free test — try it on every module you write.

## 5. Circular dependencies — the two-way street

The classic accident, caught live:

```text
course.h:  #include "student.h"     // a Course records the Student who enrolled
student.h: #include "course.h"      // a Student remembers the Course they joined
```

With `#pragma once`, this deadlocks *logically*: whichever header the compiler opens first includes the other, which skips itself (already being processed) and proceeds to use a type **not yet defined** — "Student was not declared", with the include chain in the error making no sense to a beginner. Even when it compiles (via creative ordering), the two files can never change independently again — the design itself is welded.

**The refactors that break cycles, in order of preference:**

1. **Forward declarations** — for pointers and references only. `student.h` needs to *name* `Course`, not *use its insides*:

```cpp
// student.h
#pragma once
#include <string>

namespace records {
class Course;                                  // forward declaration: the NAME only

class Student {
public:
    void enrol(Course& c);                     // reference parameter: name is enough
private:
    Course* current_ = nullptr;                // pointer to it: name is enough
};
}
```

The definition moves to the `.cpp` (`#include "course.h"` there — where the *full* type is genuinely used). The header dependency disappears; the cycle never forms. The rule: **headers may name; only sources may use.**

2. **Redesign the dependency** — ask which direction is *true*. If students and courses both need each other, usually one *owns* and one *refers*: the course owns its roster (a `vector<Student>`); a student's "my course" is a view (a pointer/reference) established at enrolment *by the course*, not held in the header. The OOP module's composition-vs-association question, asked one level up: **which object's lifetime governs the other's? The owner holds; the held refers.**

3. **Extract the shared part** — if both genuinely need the same *data*, that data is a third module (`enrolment.h`) both include. Two arrows into a leaf; no cycle.

## 6. Organizing classes and functions as the program grows

The scaling pattern, from one file to many, as the course's programs have lived it:

| Scale | Shape | Example from the course |
| --- | --- | --- |
| 1 program | one `.cpp`: prototypes on top, `main` below | Units 01–06 |
| one domain | `domain.h` + `domain.cpp` + `main.cpp` | the first split ([the lab](labs.md), stage 1) |
| several domains | one module per responsibility + thin `main` | [the example project](example-project.md) |
| a toolkit | domain modules + a utility module strangers can reuse | `textutil` here; the capstone's reports |

The placement rules that keep the shape as it grows:

- **Classes:** declaration in the module's header (full definition — Lesson 1's class row); method bodies *out-of-class* in the `.cpp`, qualified (`Student::Student(...)`). Small one-line accessors may live in-class (they are implicitly `inline`) — the OOP module's habit, unchanged.
- **Free functions:** public helpers → declared in the header, defined in the `.cpp`; private helpers → defined in the `.cpp` (undeclared in the header — invisible to strangers; or in an unnamed namespace, the local-private idiom the course mentions and leaves to a later course).
- **`main`:** exists exactly once, in exactly one `.cpp`, and stays *thin* — parse intent, call modules, handle the top-level net (the Robustness module's layer four). Logic in `main` is a design smell the way logic in a constructor was: it cannot be called from tests or reused.
- **Constants:** `constexpr` in the header of the module that owns them (the Modern C++ module's habit); module-private constants in the `.cpp`.
- **Testability:** every module compiles alone (§4's rule d) — which is exactly what makes `tests/test_student.cpp` able to include one header and exercise one module.

## 7. The build checklist

A multi-file project that follows every rule in the module:

```text
✓ every header: #pragma once, its own namespace, includes only what its declarations need
✓ every source: includes its own header FIRST, then what its body uses
✓ exactly one main, thin
✓ dependency arrows one-way (or broken with forward declarations)
✓ each module compiles alone: g++ -c src/xxx.cpp -Iinclude
✓ whole project builds: g++ -std=c++17 -Wall -Wextra -Iinclude src/*.cpp -o app
✓ zero warnings, zero `using namespace std;` in headers
```

## Recap

- The compiler translates each `.cpp` blind; the **linker** fills the name holes — undefined/multiple definitions are linker verdicts, not compiler ones.
- **Staged builds** (`-c` then link) make recompilation per-file — the header/source split's engineering payoff.
- **Layout:** contracts in `include/`, deliveries in `src/`, one thin `main`, modules by responsibility.
- **Modularity tests:** one job; owns its data; swappable; a stranger could use it; compiles alone.
- **Cycles break** with forward declarations (headers may name; sources use), honest ownership direction, or a shared leaf module.
- Classes: header declares, `.cpp` delivers; `main` stays thin; modules stay independently compilable.

## Practice

1. Build the [example project](example-project.md) both ways — one-shot and staged. Then edit *one* `.cpp` and rebuild staged, listing exactly which commands you needed. That list is your project's build recipe.
2. Draw the dependency diagram (boxes = modules, arrows = includes) for the example project. Then add a feature: "each course keeps a letter-grade distribution" — decide which module changes, and redraw. If your answer needed two new arrows, reconsider.
3. Create a deliberate cycle: make `student.h` include `course.h` and vice versa. Compile. Read the error carefully — *which* header was opened first changes the message. Fix with a forward declaration and confirm the build.

→ Continue to the [complete example project](example-project.md).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
