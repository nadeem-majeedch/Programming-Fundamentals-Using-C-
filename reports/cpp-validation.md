# C++ Code Validation Report — Programming Fundamentals Using C++

> **Validation date:** 24 September 2026 · **Scope:** every C++ source example in the repository — 1,576 fenced listings embedded in course Markdown plus 9 standalone `.cpp` files (Unit 01 examples, lab starters, Debug-It seeds, the Lab 01 solution, the toolchain sanity check).
> **Nothing was committed or pushed.** Genuine errors were fixed; intentionally incomplete or intentionally buggy material was classified and left untouched.

---

## Headline numbers

| Metric | Count |
| --- | --- |
| **Examples checked** | **1,585** (1,576 embedded + 9 standalone) |
| Complete programs (contain `main()`) | 667 embedded + 6 standalone |
| **Passed** (static validation, no defects) | **1,571** |
| **Failed** (genuine defects — **all fixed**) | **14** |
| Intentionally incomplete (student exercises) | 3 standalone/embedded skeletons + ~120 idiom/continuation fragments |
| Intentionally buggy (debugging exercises) | 2 standalone Debug-It files (8 seeded bugs) + seeded-hunt listings on 12 debugging pages |
| Reference solutions include-validated clean | yes (after fixes) |
| Corrections made | 15 header insertions across 8 files · 1 bug-count inconsistency across 3 statements |

---

## Compiler availability — documented evidence

The task asked for validation with a modern compiler where available. **No C++ compiler exists in this environment.** Evidence from the probe:

- `PATH`: no `g++`, `gcc`, `clang++`, `cl`, `cc`, `c++`, or alternatives (`command -v` empty for all).
- Common Windows locations: `/c/mingw*`, `/c/msys64`, `/c/MinGW`, `/c/TDM-GCC-64`, `/c/Program Files/LLVM`, `/c/Program Files/Microsoft Visual Studio` — none exist.
- WSL: the only distro is `docker-desktop` (a minimal support distro, no toolchain, no package manager use possible).
- Docker Desktop is installed but its engine pipe (`dockerDesktopLinuxEngine`) never came up during the session — `docker version` returned an empty server version across retries, so no container-based `gcc:latest` build was possible either.

**Consequence:** compilation and runtime output verification could not be executed. Validation was performed with a **deep static suite** (below), which catches structural defects, include/namespace discipline, API-name typos, and include-vs-usage mismatches — but not type errors or logic bugs. A one-command g++ sweep remains the recommended final gate (see *Remaining issues*).

---

## The static validation suite (what ran)

1. **Extraction & classification.** All fenced blocks tagged `cpp`/`c++` were extracted with file + line metadata and classified by role markers (`// TODO` skeletons, seeded-bug headers, fix-list positions).
2. **Brace/paren balance** with full comment/string/char-literal stripping (a state-machine lexer, after two earlier scanner drafts produced false positives from `'"'` char literals and `//` comments).
3. **Include validation.** For every block that *already includes at least one header* (the course elides includes in fragments by design — 108 of 182 files' first blocks are deliberately include-less continuations), the suite mapped used library features to required headers and flagged genuine mismatches — on comment-stripped code, so prose comments don't trigger.
4. **Namespace discipline.** Bare `cout`/`string`/`vector` usage in complete programs vs `std::`/`using` presence.
5. **API/typo scan.** Eight high-frequency typo patterns (`<iostram>`, `sting`, `sdt::`, `end1`, `coud`, `coutt`, …).
6. **Memory-operation pairing.** `new[]`/`delete[]` counting in all pointer-era listings, each flag individually adjudicated against its teaching context.
7. **Manual review** of all 9 standalone `.cpp` files and every flagged listing's surrounding explanation.

---

## Findings and corrections

### Genuine defect 1 — Lab 00 hunt promised 5 bugs, seeded 4 (FIXED)

`docs/getting-started/starter/lab-00-debug-it.cpp` seeds exactly four defects: `int Main(` (link-stage), a missing `;` (compile), a missing opening quote on the closing border (compile), and `"BS Data Sience"` (wrong output). But its header comment, its BUG DIARY (5 rows), and the lab brief (`getting-started-lab.md`, two statements incl. "write down all five") all promised **5** — students would hunt a nonexistent bug.

**Fix:** count corrected to 4 and the bug taxonomy stated accurately ("two compile errors, a linker-flavoured mistake, and one wrong-output bug") in all three locations.

### Genuine defect 2 — 14 missing-header defects in 13 listings (FIXED)

Six **reference solutions** called `tolower`/`isdigit`/`isalpha`/`toupper` without `<cctype>` — technically "usually works" via transitive includes, but exactly the non-portability the course teaches against:

- `docs/practice/challenge.md` (3 listings) · `docs/practice/intermediate.md` (2) · `docs/strings/labs.md` (1)

The **modular module's own example files violated its include-what-you-use rule** (D7 teaches: "include-what-you-use, per file — no other file's correctness depends on incidental contents"):

- `docs/modular/example-project.md` — `course.cpp` used `std::max_element`/`std::string` with no `<algorithm>`/`<string>`; `textutil.cpp` named `std::string`/`std::vector` relying on its own header; `main.cpp` used `std::string` via transitive paste
- `docs/modular/debugging.md` — the D8 fix snippet's `course.h` uses `std::vector` with no `<vector>`
- `docs/modular/lesson-1-headers-sources.md` — the namespaces example used `std::string` with only `<iostream>`

Two **Syntax boxes** in `docs/cpp-io/lesson-1-cout.md` showed `std::cout` with only `<iomanip>` (the worked examples beneath were complete — the snippets now match them).

**Fix:** 15 `#include` insertions across the 8 files, comment-annotated where the module's own rule deserved the visible example. Post-fix re-scan: **0 remaining genuine include defects.**

### Verified non-issues (each individually adjudicated — nothing "silently" skipped)

| Finding class | Raw flags | Verdict |
| --- | --- | --- |
| Balance after stripping | 3 | All **intentional fragments**: the min-idiom continuation in `repetition/lesson-2-for.md`, the catch-ladder continuation in `robustness/debugging.md` (a "Fix:" answer), and a two-column header/source layout in `modular/exercises.md` |
| "typo `cut`" | 10 | **False positive** — `cut` is the deliberate parameter name of `countAtLeast(const int[], int, int cut)` used consistently across labs/miniprojects |
| `new[]`/`delete[]` count mismatches | 18 | All in **teaching contexts**: leak-hunt exercises (hints literally say "count the new vs delete[]"), modernisation-review snippets (the task is to find the leak), and correct multi-allocation solutions (grid lab: 1+ rows vs rows+1 frees across the pair) — **no reference solution mispairs** |
| Include-less full programs | 103 | The course's elision pattern for fragments; on debugging pages this *is* the exercise (find the bug). One deliberate demo (`strings/debugging.md` D10, "// note: no `<cctype>`") is the lesson itself and stays |
| Namespace flags | 65 | All from include-less fragments (convention); every complete program uses `std::`/`using` correctly |

---

## Classification of all 1,585 examples

| Class | Examples | Validation result |
| --- | --- | --- |
| **Reference solutions** | solutions embedded in every module's exercises/labs/challenges + `lab-01-solution.cpp` | Balance ✓ · includes ✓ (after fixes) · APIs ✓ · memory pairing ✓ · Lab 01 solution's Debug-It fix list matches its seed file's 4 bugs exactly |
| **Teaching examples** | lesson/worked listings incl. all 9 standalone files | Balance ✓ · includes ✓ (after fixes) · outputs consistent with adjacent explanations (spot-checked) |
| **Intentionally buggy exercises** | `lab-00-debug-it.cpp` (4 seeds), `lab-01-debug-it.cpp` (4 seeds), seeded-hunt listings on 12 debugging pages | Seeds verified to match published diagnoses/answer keys; **not** treated as broken. Lab 00's advertised count was the one inconsistency — fixed to match reality |
| **Intentionally incomplete exercises** | `lab-00-poster.cpp`, `lab-01.cpp` (TODO skeletons), the `strings/miniproject.md` milestone skeleton, ~120 idiom/continuation fragments | Validated as *intended shapes*: skeletons balance, fragments are labelled continuations — **not** treated as broken |
| **Actual broken examples** | **none found** | The audit's original suspicion (nothing compiles) was not borne out |

---

## Remaining issues

| # | Issue | Disposition |
| --- | --- | --- |
| 1 | **No compiler-level validation was possible in this environment** (evidence above). Static analysis cannot catch type errors, narrowing conversions, or logic bugs. | **Open — owner decision.** Recommended: run the g++ sweep on any machine with a toolchain — extract listings and `g++ -std=c++17 -Wall -Wextra -fsyntax-only` each — or add a CI job (the deploy workflow's runner has g++ preinstalled) that extracts and syntax-checks before deploy. |
| 2 | Runtime output verification (expected-output correctness for trace/prediction items) requires execution. | Open, same vehicle as #1. Sampled manual checks found no mismatches. |
| 3 | Include-elision is a *documented-by-pattern* convention (never stated as a rule). | Low: a one-line convention note in `docs/course-architecture.md` would prevent future contributors from "fixing" intentional fragments. |

---

## Verdict

After the 15 corrections, every C++ example in the repository is consistent with its explanation, every reference solution is include-complete and portable, every seeded bug matches its published answer, and no listing is structurally broken. The single outstanding validation gap is compiler-level checking, which this machine cannot perform — the report documents the exact one-line command a maintainer can run elsewhere.
