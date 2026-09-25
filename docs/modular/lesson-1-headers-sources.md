---
title: "Lesson 1 — The Header/Source Split"
description: "Declarations vs definitions, why headers exist, the translation-unit story, include guards and #pragma once, namespaces, and the include-what-you-use rule."
---

# Lesson 1 — the header/source split

> [← Module home](index.md) · [Lesson 2 — Building and organizing →](lesson-2-building-organizing.md)

## In this lesson you will learn

- the difference between a **declaration** and a **definition** — the distinction the whole module stands on
- why programs split into **header files** and **source files**
- what the compiler actually sees: **translation units**
- **include guards** and `#pragma once` — and why one of them is a rule and the other a courtesy
- **namespaces** — naming that scales past one file
- the **include-what-you-use** hygiene rule

## 1. Declarations vs definitions — the one distinction

You have used the distinction since Unit 07 without the vocabulary:

```cpp
int add(int a, int b);              // DECLARATION (prototype): announces the shape

int add(int a, int b) {             // DEFINITION: the actual body — exists once
    return a + b;
}
```

A **declaration** tells the compiler *a name exists and what type it has* — enough to type-check calls against. A **definition** supplies *the thing itself* — the function body, the variable's storage, the class's members. The rule from which the whole module follows:

> **Declare many times; define once.**

Every rule about headers, includes, and linkers in this module is this sentence wearing different clothes:

| Entity | Declaration | Definition | Defined once? |
| --- | --- | --- | --- |
| Function | prototype | the body | yes — two bodies = linker error |
| Variable | `extern int counter;` | `int counter = 0;` | yes |
| Class | — | the class body | per translation unit (see §3 — guards) |
| Function *template* | — | in the header | special case: [Generics module](../generics/lesson-2-templates.md)'s rule |
| `constexpr` value | — | in the header (implicitly `inline`) | per-TU copies folded away |

The class row deserves a pause, because it *looks* like a contradiction: a class body in a header is included in several `.cpp` files — isn't that "defined many times"? The C++ rule is subtler: **class definitions may repeat across translation units, but must be identical** — the compiler stitches the per-file views together at link time. That is *exactly* why a class's full body lives in the header and its out-of-class method definitions live in one `.cpp`: bodies may not repeat; class shapes may.

## 2. Why split? The two-file story

Watch the problem build itself. Three files, one function:

```text
main.cpp        needs add(...)        → writes the prototype itself
statistics.cpp  needs add(...)        → writes the prototype again (typing mistake: float)
report.cpp      needs add(...)        → writes it again (another slight difference)
```

Three *independent copies* of one promise — one of them already wrong. The fix is not discipline ("type carefully!"); it is **one file that holds the promise, included by all three**:

```text
mathkit.h     → the declarations (the promise)
mathkit.cpp   → the definitions (the delivery)
main.cpp, statistics.cpp, report.cpp  → #include "mathkit.h"  (one copy, one truth)
```

That is the entire header/source system:

- **`.h` (or `.hpp`) — the header:** *what* the module offers. Declarations: function prototypes, class definitions, constants. No function bodies (the template/`constexpr` exceptions aside).
- **`.cpp` — the source:** *how* it works. The definitions: function bodies, variable storage, out-of-class method implementations.

A reader of `mathkit.h` gets the module's *contract* — the same document the compiler type-checks against. This is why the functions module's prototypes were worth writing: a header is a prototype file with enforcement.

## 3. What the compiler actually sees: translation units

The preprocessor's `#include` is literally **copy-and-paste**: `#include "mathkit.h"` pastes the header's text into the `.cpp` at that line. The compiler then compiles each pasted-together `.cpp` as one **translation unit** (TU) — and *never sees* the other `.cpp` files at all.

```text
main.cpp:                 statistics.cpp:
  #include "mathkit.h"      #include "mathkit.h"
  ┌─────────────────┐       ┌─────────────────┐
  │ mathkit.h (copy)│       │ mathkit.h (copy)│      ← each TU carries its own copy
  │ main's code     │       │ stats' code     │
  └─────────────────┘       └─────────────────┘
        TU 1                      TU 2            compiled separately, blind to each other
```

Two consequences drive everything:

1. **A TU that never included a header it needs fails to compile** — "what's a `Student`?" (Hunt [D3](debugging.md).)
2. **A header included twice in one TU is pasted twice** — and a class definition pasted twice *in one TU* *is* a redefinition error. Which is why the next section exists.

## 4. Include guards and #pragma once

The classic mistake: `mathkit.h` includes `textutil.h`, and `main.cpp` includes *both*. `main`'s TU receives `textutil.h` twice — every class in it redefined. The standard fix, **include guards**:

```cpp
// textutil.h — the guarded header
#ifndef TEXTUTIL_H          // if this name is not defined yet...
#define TEXTUTIL_H          // ...define it and let the content through

#include <string>

int countWords(const std::string& text);
std::string toUpper(const std::string& text);

#endif                      // TEXTUTIL_H — always comment the #endif
```

The mechanics: first inclusion — `TEXTUTIL_H` undefined → define it → content pasted. Second inclusion — already defined → the `#ifndef` skips to `#endif` → content pasted **zero times**. Idempotent by construction. The guard name must be **unique across the project** (`PROJECT_PATH_FILE_H` is the convention — `TEXTUTIL_H`, not `UTIL_H`, which two teammates will independently invent).

**`#pragma once`** is the non-standard-but-universal shortcut that does the same job by file identity instead of a macro name:

```cpp
// textutil.h — the same header, pragma style
#pragma once

#include <string>

int countWords(const std::string& text);
```

Every major compiler supports it; it cannot suffer a name collision; its one honest weakness is philosophical — "same file" is a filesystem judgement (symlinks and mirrored copies can outsmart it, rarely).

**The course's rule:** **`#pragma once` at the top of every header — and know how include guards work, because you will read them in every professional codebase you ever open.** (Consistency matters more than the choice; a project that mixes both on one file is the smell — see [tasks T2](tasks.md).)

## 5. Namespaces — naming that scales

Two modules, one name — inevitable the moment files multiply:

```cpp
// records.h     → struct Student { ... };      (domain)
// solutions.h   → struct Student { ... };      (a solver's local type)
```

The **namespace** partitions names so both survive:

```cpp
// 01_namespaces.cpp — partitions, not prefixes.
// Compile: g++ -std=c++17 -Wall -Wextra 01_namespaces.cpp -o namespaces

#include <iostream>
#include <string>          // the body names std::string

namespace records {
    struct Student { std::string name; int marks; };
    void show(const Student& s) { std::cout << s.name << " " << s.marks << "\n"; }
}

namespace solutions {
    struct Student { int id; double gpa; };          // a different Student, no clash
}

int main() {
    records::Student s{"Aisha", 91};                 // qualified: the partition is the name
    solutions::Student t{42, 3.7};
    records::show(s);
    std::cout << t.gpa << "\n";
}
```

The rules this course endorses:

- **Every module's declarations live in a namespace named after the module** (`records`, `textutil`, `finance`) — qualified access (`records::Student`) is self-documenting: the reader sees which module speaks.
- **`using namespace std;` retires in headers, now, permanently.** In a header, it pastes the *entire standard namespace into every TU that includes the header* — the collision the namespace exists to prevent, re-imported globally. In `.cpp` files it was a course convenience; in headers it is a bug. (Hunt [D6](debugging.md).)
- **Never create `using namespace` for your own modules just to avoid typing the qualifier** — the qualifier *is* the documentation.
- **`std::` is spelled out in headers**; a `using std::string;` at the top of a `.cpp` is acceptable local convenience.

The Standard Library's own names live in `std` — the same mechanism, the same reason.

## 6. Include-what-you-use

The last hygiene rule, and the one teammates will thank you for: **every file includes the headers for everything it directly uses** — no more, no less.

- *No more:* a header that includes `<iostream>` but never does I/O makes every includer compile the world. Compile time is a shared resource.
- *No less:* a file that compiles only because a header *happened* to include its needs will break the day that header tidies itself. This is the sneakiest bug class in the module (hunt [D7](debugging.md)): *the include that worked by accident.*

The tool for finding the balance: delete an include, compile, read the errors — each error names a type whose true home you then include. The header itself includes only what its *own* declarations need (`<string>` for a `std::string` parameter; the headers of types used in its interface).

## 7. The header checklist

A header that follows every rule in this lesson:

```cpp
// student.h — the shape every header in this course follows
#pragma once                    // or include guards, consistently

#include <string>               // for std::string members/parameters ONLY

namespace records {             // the module's partition

class Student {                 // the contract: full class definition here
public:
    Student(const std::string& name, int marks);
    const std::string& getName() const;
    int getMarks() const;
private:
    std::string name_;          // trailing underscore = the course's member mark
    int marks_;
};

}                               // namespace records
```

and its source:

```cpp
// student.cpp — the delivery
#include "student.h"            // its own header FIRST — proves it stands alone

namespace records {

Student::Student(const std::string& name, int marks) : name_(name), marks_(marks) {}
const std::string& Student::getName() const { return name_; }
int Student::getMarks() const { return marks_; }

}                               // namespace records
```

The `#include "student.h"` **first in its own `.cpp`** is a self-test: if `student.cpp` fails to compile, the header does not stand alone — it was silently depending on something its includer used to provide (hunt [D7]'s prevention, performed for free).

## Recap

- **Declare many, define once** — the rule beneath every other rule.
- Headers hold the contract (declarations, class shapes); sources hold the delivery (bodies).
- `#include` is copy-paste; each `.cpp` is a translation unit compiled blind to the rest.
- `#pragma once` (or guards, consistently) makes headers safe to include twice.
- Namespaces partition module names; `using namespace std;` never appears in a header.
- Include what you use — and include your own header first, as a free self-test.

## Practice

1. Take any two-prototype program from the functions module and split it: `mathkit.h` + `mathkit.cpp` + `main.cpp`, compile with `g++ -std=c++17 -Wall -Wextra main.cpp mathkit.cpp -o app`. Then *deliberately* include `mathkit.h` twice in `main.cpp` (once directly, once via another header) — with and without the guard. Record both outcomes.
2. Write two namespaces each containing a `print(const std::string&)`, include both in one file, and call each with full qualification. Then add `using namespace` for one of them — and describe what just got ambiguous if someone adds a same-named function to the other.
3. Audit `student.h` above: list every line that would change if the course had chosen include guards instead of `#pragma once`. (There are exactly three.)

→ Continue to [Lesson 2 — building and organizing](lesson-2-building-organizing.md).

— *Engr. Dr. Muhammad Nadeem Majeed, Professor, Department of Data Science (PUCIT), University of the Punjab, Lahore* · [About the instructor](../about.md)
