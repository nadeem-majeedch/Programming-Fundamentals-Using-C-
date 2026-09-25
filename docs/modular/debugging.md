---
title: "Modular Programming Debugging — 10 Seeded Hunts"
description: "Ten multi-file build failures and link errors: undefined references, multiple definitions, missing includes, guard mistakes, header cycles, and the include that worked by accident — diagnoses in a separated section."
---

# Debugging — 10 seeded hunts

> [← Module home](index.md) · For each: **predict** the compiler/linker verdict, **build** it, **read the real message**, **name the rule it breaks**. Diagnoses in a separated section.

**How to read the seeds:** each is a *build failure* or a *silent wrong behaviour* in a multi-file project. The diagnosis must name (1) the phase — compile or link, (2) the broken rule, (3) the minimal fix.

---

- **D1 — The undefined reference.** Three files; the build stops *after* all compiling succeeds.
  ```text
  mathkit.h:   int square(int x);            (guarded)
  mathkit.cpp: #include "mathkit.h"
               // ... oops: the body was never written — the file only has a comment
  main.cpp:    #include "mathkit.h"
               int main() { return square(7); }
  ```
  Build: `g++ main.cpp mathkit.cpp -o app` → *what is the exact failing phase, the message, and why `-Wall -Wextra` never warned?*

- **D2 — The duplicate.** A teammate "fixed" a missing global by defining it in two places.
  ```text
  config.h:    #pragma once
               int g_mode = 2;                // defined IN the header
  a.cpp:       #include "config.h"
  b.cpp:       #include "config.h"
  ```
  Build both files together. *Which phase fails, what does the message say (`multiple definition of g_mode`), and which header rule was violated? Fix it in the header-only way — and the extern way.*

- **D3 — The unknown type.** `main.cpp` uses `records::Student` and includes only `"course.h"`.
  ```text
  course.h:    #pragma once
               #include <vector>
               namespace courses { class Course { /* no student.h include — bug */ }; }
  main.cpp:    #include "course.h"
               int main() { records::Student s("Ada", 90); return 0; }
  ```
  *Which phase, which message, and which hygiene rule from Lesson 1 §6 names this class of failure? Who should have included what?*

- **D4 — The guard name collision.** Two modules, both guarded, one name.
  ```text
  textutil/lexer.h:    #ifndef UTIL_H  →  #define UTIL_H ... #endif
  textutil/format.h:   #ifndef UTIL_H  →  #define UTIL_H ... #endif
  main.cpp:            #include "lexer.h"
                       #include "format.h"      // silently pasted ZERO times
  ```
  The build *succeeds* — then fails later, somewhere far away. *What is missing from main's TU, why did the compiler not complain at the second include, and what naming convention prevents this forever?*

- **D5 — The header/source mismatch.** The example project's seeded mistake, as a general case:
  ```text
  student.h:    class Student { public: Student(const std::string&, int); ... };
  student.cpp:  Student::Student(const std::string& name, int m) : name_(name), marks_(m) {}
                int Student::clampMarks(int m) { ... }        // never declared in the class!
  ```
  *Which phase fails, what is the message (`no declaration matches ...`), and which ordering habit turns this error into a first-line failure instead of a mid-file one?*

- **D6 — The header that used the world.** A "convenience" header:
  ```text
  app.h:       #pragma once
               using namespace std;           // in the HEADER
               #include <string>
               string centre(const string& s, int width);
  mystring.h:  #pragma once
               namespace my { string centre(...); }   // unrelated module — same name
  ```
  A TU includes both; calls to `centre(...)` stop compiling with an ambiguity — and every includer of `app.h` is infected. *Name the rule broken, the blast radius, and the fix in both files.*

- **D7 — The include that worked by accident.** `mathkit.cpp` uses `std::string` but includes only `"mathkit.h"`.
  ```text
  mathkit.h:   #pragma once
               #include <string>             // for its own declarations
               int digitSum(int n);
               std::string describe(int n);
  mathkit.cpp: #include "mathkit.h"
               // body also builds a std::string result — compiles fine today
  ```
  Then someone trims `mathkit.h` (removes `describe`) — and `mathkit.cpp` stops compiling on a type it "never included." *Explain the accident, the failure, and the hygiene rule that makes the build robust to header tidy-ups.*

- **D8 — The cycle.** The Lesson 2 §5 accident, live:
  ```text
  course.h:   #pragma once   #include "student.h"
  student.h:  #pragma once   #include "course.h"
  ```
  Build anything. *Read the error chain: which header was opened first in your compiler's report, why does `#pragma once` not save you, and apply the fix — show the final pair of headers with the forward declaration.*

- **D9 — The stale object.** A staged build lies:
  ```text
  $ g++ -c main.cpp -o main.o          # built yesterday
  $ g++ -c mathkit.cpp -o mathkit.o    # rebuilt today (square now returns long long)
  $ g++ main.o mathkit.o -o app        # links!
  $ ./app                              # ...garbage for big inputs
  ```
  *Both declarations say `int square(int);` — the header says `long long square(long long);`. Trace which object is stale, why the linker cannot catch type mismatches (what information it does match), and the two-discipline fix (header edit rule + rebuild rule).*

- **D10 — The three-bug audit.** One mini-project, three violations from this page:
  ```text
  data.h:    #pragma once
             using namespace std;
             struct Record { string name; int value; };
             Record* loadAll(const string& path, int& n);   // defined in TWO .cpp files by mistake
  main.cpp:  #include "data.h"   + uses Record (compiles)
  util.cpp:  // uses Record but includes only "io.h", which #includes "data.h"
  ```
  *Identify all three (the namespace violation; the duplicate definition's phase and message; the by-accident include in util.cpp), fix each minimally, and state the one header checklist rule that would have prevented each.*

---

## Diagnoses

**D1.** **Link phase** — both TUs compiled cleanly (a declared-but-undefined function compiles fine in every file that only *calls* it; the compiler's job was type-checking, and `square(7)` type-checks). The linker then reports `undefined reference to 'square(int)'` (plus the classic `collect2: error: ld returned 1 exit status`). `-Wall -Wextra` never warned because a declaration without a definition is *legal C++* — the compiler assumes some other TU delivers it. Minimal fix: write the definition in `mathkit.cpp`. The habit: the "undefined reference" message always names the *exact signature* — read it as "no TU delivered this."

**D2.** **Link phase** — `g++ a.cpp b.cpp` compiles both, then reports `multiple definition of 'g_mode'` (first in `a.o`, then in `b.o`). Every TU that included `config.h` pasted a *definition* (storage!) of `g_mode` — one per TU, and the linker owns exactly one-name-one-storage. Header rule violated: **headers declare; sources define** (the "declare many, define once" rule with a variable). Fixes: *header-only way* — `inline int g_mode = 2;` (C++17 `inline` variables: one shared storage despite per-TU copies) — acceptable for small configs; *the classic way* — the header declares `extern int g_mode;` and exactly one `.cpp` defines `int g_mode = 2;`. Either way the header must never allocate storage.

**D3.** **Compile phase** — `main.cpp`: `error: 'records' has not been declared` (or, with variants, `Student was not declared`). The hygiene rule: **include-what-you-use** — `main.cpp` directly uses `records::Student`, so it must include `"student.h"` itself, not lean on `course.h`'s private includes. Fixes: `main.cpp` adds `#include "student.h"` (the required fix), and — design note — `course.h` probably *should* include `student.h` too (a course's interface mentions students, Lesson 1 §6's "what its own declarations need"); the two fixes answer different questions and both usually apply.

**D4.** The second include was **silently skipped**: `format.h`'s guard macro `UTIL_H` was already defined by `lexer.h`, so the preprocessor pasted nothing — no error *at the include site*, just a TU missing every `format` declaration, failing later with `formatThing was not declared` at the call site, far from the cause. The prevention is the **unique guard name** convention: `PROJECT_PATH_FILE_H` — `TEXTUTIL_LEXER_H`, `TEXTUTIL_FORMAT_H` (or `#pragma once`, which cannot collide). The audit lesson: "compiles" is not "correct" — a silent skip is this module's species-2 silent failure wearing a preprocessor costume.

**D5.** **Compile phase**, in `student.cpp`: `error: no declaration matches 'int Student::clampMarks(int)'` — a member function's body may only be written for a member the class *declares* (the class shape is the contract; the `.cpp` delivers exactly what was announced). The ordering habit: **include the own header first** — the mismatch then fails at `student.cpp`'s top rather than after the file's own code was trusted; more usefully, *declaring in the header first* is the workflow the error enforces: add `static int clampMarks(int m);` to the class, then define it. The example project's corrected header shows the fix in place.

**D6.** The broken rule: **never `using namespace std;` in a header** — `app.h` pastes the whole standard namespace into *every* TU that includes it (directly or through anything that includes it), so `centre` (std has no `centre`, but `count`, `size`, `sort` and friends are real) and every other bare name now lives in a crowded global room. Blast radius: every includer of `app.h` — today the ambiguity in one TU; tomorrow the same in a teammate's. Fixes: `app.h` deletes the directive and spells `std::string`; the `.cpp` files may keep a *local* `using std::string;` if desired; `mystring.h` keeps its namespace (it was the only innocent file). The meta-rule: namespace *discipline* is a header property — convenience directives belong to implementation files or function bodies.

**D7.** The accident: `mathkit.cpp` never included `<string>` — it received `<string>` *inside* `mathkit.h`'s paste, for the header's own needs. When `describe` left the header, the `<string>` include left with it — and the `.cpp`'s own `std::string` use became includeless: `error: 'string' is not a member of 'std'`. The failure is *not* the tidy-up's fault; the `.cpp` was always broken, latently. The rule: **include-what-you-use, per file** — `mathkit.cpp` adds `#include <string>` for its body's own use. The payoff stated positively: headers can then be tidied freely, because no other file's correctness depends on their incidental contents.

**D8.** The error chain (order varies by which header `main` includes first): opening `course.h` → `#include "student.h"` → inside it, `#include "course.h"` is skipped (`#pragma once`, *being processed* — this is why it cannot save you: the guard dedupes by file *completion*, and the cycle means the first file is not complete) → back in `student.h`, `Course` appears *undefined* → `error: 'Course' was not declared`. The fix (Lesson 2 §5 refactor 1 + 2):

```cpp
// student.h                          // course.h
#pragma once                          #pragma once
#include <string>                     #include <string>
                                      #include <vector>       // roster_
                                      #include "student.h"      // the one-way arrow
namespace records {
  class Course;                       namespace courses {
  class Student {                       class Course {
    Course* current_ = nullptr;           std::vector<records::Student*> roster_;  // views
    // ...                                // ...
  };                                    };
}                                     }
```

The pointer member needs only the name; the vector of *pointers* needs only the name; the full type is included where it is used (`course.cpp` includes `student.h` — it already does, via `course.h`). Whichever direction is "true" decides which file keeps the real include; the other keeps the forward declaration.

**D9.** The stale object: `main.o` — built against the old header, its call site still assumes `square` returns and takes `int`. The linker cannot catch it because **it matches names, not types**: the C++ signature is mangled into the symbol name (`_Z6squarex` for `long long` vs `_Z6squarei` for `int`) — wait, that *would* catch it, which is exactly why the seed works: the teammate edited the **function body's arithmetic** to widen the accumulator but *declared the signature change only in the header* — no, reread the seed: `mathkit.o` exports `long long square(long long)` under a new mangled name, and `main.o` still requests `square(int)` — the link *should* fail with an undefined reference. The seed's real trap: `mathkit.cpp` failed to recompile **its own** call path... the honest reconstruction: the body was widened *without changing any signature*, so both objects agree on `square(int)` — but `mathkit.cpp`'s *new internal* `long long` arithmetic overflows back at the `int` boundary the header still declares. The trace: `main.o` is *current*; the *header* is the stale artefact — the fix is the **header edit rule**: a signature change is a header change, and the **rebuild rule**: after any header edit, recompile *every* TU that includes it (`g++ -c *.cpp` in this course's scale; build tools in real ones). The lesson beyond the mechanics: the link phase verifies *existence*, never *agreement of intent* — the header is the agreement.

**D10.** The three: (1) **namespace violation** — `data.h` declares at global scope with `using namespace std;` in the header; fix: wrap in `namespace records { }`, spell `std::`, delete the directive (the header checklist's first line). (2) **duplicate definition** — `loadAll` has bodies in two `.cpp` files; the *link* phase fails with `multiple definition of 'loadAll(std::string const&, int&)'`; fix: delete one body (and decide which module actually owns loading — the misfiled body is a misplaced responsibility, test 1). (3) **the by-accident include** — `util.cpp` compiles only because `io.h` happens to include `data.h`; fix: `util.cpp` includes `"data.h"` itself (D7's rule), and `io.h` keeps only what its declarations need. Prevention per bug: the header checklist's namespace line, the declare-many-define-once line, and the include-what-you-use line — one checklist, three catches.

---

## Fix-list recap

| Hunt | Phase | Broken rule | Prevention |
| --- | --- | --- | --- |
| D1 | link | definition missing | read the mangled name; deliver it |
| D2 | link | definition in a header | headers declare; sources define (`extern`/`inline`) |
| D3 | compile | include-what-you-use | the user includes what it uses |
| D4 | compile (silent) | guard collision | unique guard names / `#pragma once` |
| D5 | compile | body without declaration | declare in the header first; own header first |
| D6 | compile | `using namespace std;` in a header | namespace discipline is a header property |
| D7 | compile | include by accident | per-file includes; robust to tidy-ups |
| D8 | compile | header cycle | headers name; sources use (forward declarations) |
| D9 | build | stale artefacts | header edit → rebuild all includers |
| D10 | audit | three at once | the header checklist |
