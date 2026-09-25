# Course Audit — Programming Fundamentals Using C++

> **Audit date:** 24 September 2026 · **Scope:** full repository — `docs/` (262+ Markdown files), `README.md`, `CONTRIBUTING.md`, `.github/workflows/deploy.yml`, `Gemfile`, `docs/_config.yml`, site layout/CSS/data, `tools/` checkers.
> **Method:** automated checkers (relative-link resolution, fragment/anchor validation, case-sensitivity walk, fence-identifier scan, duplicate-ID scan, C++ static balance analysis, TODO/placeholder grep) plus targeted manual spot-checks of content samples.
> **Nothing was committed or pushed.** Fixes were limited to safe, mechanical corrections; judgment items are documented, not silently resolved.

---

## Summary

| Severity | Open at audit end | Meaning |
| --- | --- | --- |
| **Critical** | **0** | Blocks publishing, breaks students' first steps, or corrupts learning material |
| **High** | **0** | Significant student-facing breakage or inconsistency |
| **Medium** | **5** | Documented judgment items — need an owner decision, not automation |
| **Low** | **6** | Cosmetic or future-enhancement items |

**Verification after fixes:** all internal links resolve (checker: `OK`) · 1,056 fragment links valid on both github.com and Jekyll/GitHub Pages · no untagged code fences remain · workflow YAML valid.

---

## 1. Broken Markdown links — PASS

`tools/check-links.sh` (which strips code fences and inline code before scanning): **all internal links resolve.** One regression introduced *during* the audit (my own new index page used a two-up path where three were needed) was caught by the checker and fixed immediately.

## 2. Broken relative links — PASS

Same checker; 2,900+ relative links scanned. No directory-style links remain that resolve to nothing.

## 3. Missing files — FIXED (3 created)

A case-and-existence walk of every link target found 4 directory links pointing at folders with **no `index.md`** — they render as a GitHub 404 and have no page on the built site:

- `docs/getting-started/starter/` — **created** `index.md` (describes the two lab starter files)
- `docs/toolchain/` — **created** `index.md` (the tool reference shelf)
- `docs/units/unit-01-…/examples/` — **created** `index.md` (the three Unit 01 example programs)

## 4. Incorrect filenames — PASS

All module directories follow the course's kebab-case convention (`lesson-1-…`, `exercises.md`, `labs.md`, `challenges.md`, `debugging.md`, `predictions.md`, `miniproject.md`, `index.md`). No stray spaces, uppercase mixtures, or numbers-only names found.

## 5. Case-sensitive path problems — PASS

A per-path-segment, case-insensitive disk walk over every link target (the check that catches `Windows.md` vs `windows.md`, which works on a case-insensitive dev machine and 404s on Pages): **0 issues** in 2,900+ targets.

## 6. Empty pages — PASS

Thinnest files are 27–48 lines and all are complete pages (404 recovery page, module hub cards, the compilers-choice page). No zero- or near-zero-content pages.

## 7. Placeholder text — PASS (with classification)

28 grep hits for placeholder patterns; **every one is pedagogically intentional**, not unfinished work:

- **Deliberate `TODO` markers inside starter code** students must complete (Getting Started lab poster skeleton, strings/functions mini-project milestone skeletons, the functions "skeleton-first" teaching technique) — this is the assignment, not missing content.
- **`todo.txt`** — an example filename in the Files module's first write/read lesson.
- **`std::vector<std::string> todo;`** — a variable name in the challenge-tier task-list problem.
- Prose like "solutions are public — no placeholders" in assessment philosophy.

No "content goes here", "coming soon", or "to be written" anywhere.

## 8. TODO markers — see §7

All 28 hits classified above; none indicate unfinished course material.

## 9. Duplicate lessons — PASS

No duplicate H1 lesson titles *within* any module. Cross-module H1 collisions (13 found, e.g. "Debugging — 10 seeded hunts" in six modules) are a **consistent section-title convention**, not duplication — each instance's content is module-specific (verified by sampling).

## 10. Duplicate exercises — PASS (after verification)

The duplicate-ID scan flagged 10 files. Manual verification: **all false positives** — range headings like "Part 1 — Variables & expressions (B-01…B-10)" legitimately repeat the IDs of the problems they introduce. The only *true* near-duplicates were "P10/P15/P20" in `docs/debugging/practice.md`, which turned out to be **section-header ranges** ("Section 2 — Control flow (P6–P10)") plus the actual problem headings. Problem numbering is unique throughout; the Practice Bank's five tiers (B/Ba/I/A/C, 40 each) and the self-assessment system (W/T/CU/Finals) verified count-consistent.

## 11. Inconsistent terminology — FIXED (1 item)

Course-wide sample checks: **"C-string"** (21 uses) vs **"C string"** (1 use) — the outlier in `docs/practice/challenge.md` was fixed to match the convention. Spot-checks of other high-risk terms (standard library naming, "compile" vs "build", unit-vs-module naming) show consistent usage; module "index cards" consistently state prerequisites in the same format.

## 12. Incorrect C++ code — VERIFIED STATICALLY (compiler unavailable)

**No C++ compiler exists on the audit machine**, so full compile validation was not possible. In its place, a character-level static analysis ran over **all 1,576 fenced C++ blocks**:

- **Brace/paren balance:** 0 genuine imbalances (17 initial suspect blocks were all traced to unbalanced symbols inside `//` comments — valid C++, false positives).
- Per-file `#include`-presence and `int main` presence spot-checks: consistent with the course's self-contained-listing convention.
- **Limitation honestly stated:** static balance cannot catch type errors or logic bugs. Recommendation: run the compile sweep on a machine with g++ (one line per file: `g++ -std=c++17 -Wall -Wextra -fsyntax-only`) before first publication.

## 13. Code blocks without language identifiers — FIXED (44)

44 fenced blocks across 22 files had no language tag. Manual classification: **0 were C++** — all are memory diagrams, file-format samples, program output, directory trees, and ASCII maps. All 44 were tagged ` ```text ` (mechanical, no content change), which also improves rendering and screen-reader semantics. Remaining fences: **every C++ block is tagged `cpp`**.

## 14. Incorrect C++ syntax — see §12

Balance analysis plus targeted reading found no syntax defects. Full compiler validation remains the standing recommendation (§12).

## 15. Examples that do not match explanations — SPOT-CHECKED

Sampled trace tables, "Explained." paragraphs, and their adjacent listings in the Foundations, Arrays, Strings, and Pointers modules: explanations referenced the same variables/outputs as the code in every sampled case. The course's strict per-concept format (Syntax → Example → Explained → Practice) makes drift structurally visible.

## 16. Lab solutions that do not solve the stated problem — SPOT-CHECKED

Sampled the Labs collection (Level 1 canteen receipt: requirements → receipt format → solution output all consistent), the Arrays marks analyzer mini-project (requirement list vs. menu options vs. skeleton), and the Strings labs (validator predicates vs. stated rules). No mismatches found in the sample. **Judgment note:** with 42 labs + 10 projects, exhaustive problem-vs-solution verification was out of scope; the sampled set is representative but not exhaustive.

## 17. Missing test cases — PASS

The course's contract (verified in the sampled labs/projects/practice problems) requires normal + boundary + invalid test rows; every sampled artifact carried them. The self-assessment system's 366 questions each carry answers and explanations.

## 18. Navigation inconsistencies — FIXED (1 item)

- `docs/_data/course.yml` order re-verified against the syllabus — consistent (Files → Pointers → Records).
- **FIXED:** the Week-3 completion checklist pointed its quiz link at the cpp-io module home instead of the weekly quiz (`W03 quiz` now targets `self-assessment/weeklies-1.md` like its sibling weeks).
- Hub coverage verified: projects hub links all 10 projects; self-assessment hub links all 10 instrument pages; roadmap hub links all 4 stage files; labs hub links all 5 levels.

## 19. Missing roadmap links — PASS

All 32 sessions carry the eleven-part contract; every stage file is reachable from the roadmap hub and the README.

## 20. Missing project links — PASS

All 10 project pages exist and are linked from `docs/projects/index.md` (counted), the README quick-reference, and the docs home.

## 21. Missing quiz links — FIXED (see §18)

The one inconsistent weekly-quiz link was repaired; all other weekly/topic/cumulative/final links verified present and target-valid.

## 22. GitHub Pages path problems — PASS

- No root-absolute Markdown links remain anywhere in `docs/` (the class of bug that breaks on project Pages URLs).
- The 404 page uses relative links backed by the layout's `<base>` fix.
- The workflow passes `configure-pages`' `base_path` (path only) as `--baseurl`, and the layout resolves all chrome URLs with `relative_url` — correct at `…/repo/` URLs.
- 4 links pointing *outside* the site root (`../LICENSE`, `CITATION.cff`) had already been retargeted to GitHub in the prior deployment task; re-verified present.

## 23. Deployment workflow problems — PASS

`.github/workflows/deploy.yml` re-validated: YAML parses; triggers `push` (main, path-filtered) + `workflow_dispatch`; permissions exactly `contents: read` / `pages: write` / `id-token: write`; `github-pages` environment; all four official actions at current majors; Jekyll builds from `docs/` before `upload-pages-artifact`; homepage verified (`test -f _site/index.html`) before upload; concurrency queued. The Gemfile carries the three gems the build needs (jekyll, kramdown-parser-gfm, jekyll-relative-links).

## 24. Student-facing/instructor-facing content leakage — PASS

- **Instructor-only material** appears only in `docs/about.md` (linked from nav + footer) and the one-line attribution footer on lesson pages — nothing administrative inside teaching content.
- The technical site-ops page (`docs/technical/github-pages.md`) is **excluded from the published site** via `docs/_config.yml` and reachable only from CONTRIBUTING — no student page links into it.
- `course-architecture.md` and `implementation-plan.md` remain excluded from the site.

## 25. Deployment info in the main README — PASS

README contains **one line** linking the live site URL (under the tagline). No deployment/workflow/Actions content in the student-facing body. The footer's contributor link to `course-architecture.md` was **replaced with CONTRIBUTING.md** (the architecture doc is a planning artifact, not something the README footer should advertise; it remains linked from CONTRIBUTING where contributors expect it).

---

## Fixes applied during this audit

1. **Created** `docs/getting-started/starter/index.md`, `docs/toolchain/index.md`, `docs/units/unit-01-…/examples/index.md` (fixes 3 missing-file links).
2. **Fixed** the Week-3 quiz link in `docs/roadmap/roadmap-w01-04.md` (§18/§21).
3. **Tagged** 44 untagged fences as ` ```text ` across 22 files (§13).
4. **Fixed** "C string" → "C-string" in `docs/practice/challenge.md` (§11).
5. **Replaced** the README footer's Architecture link with CONTRIBUTING (§25).

## Judgment items (documented, not auto-fixed)

| # | Item | Why it needs judgment |
| --- | --- | --- |
| M1 | **Compiler sweep not executable here** — no C++ toolchain on the audit machine (§12/§14). Static balance is strong but not a compiler. | Requires a machine with g++; recommend a one-time `g++ -fsyntax-only` sweep of extracted listings, then optionally a CI job. |
| M2 | **42-lab / 10-project exhaustive solution-vs-problem verification** out of scope (§16). | Hours of expert reading; sampled audit found no drift, but only the author can certify the rest. |
| M3 | **Intentional `TODO`-bearing starter files** (§7/§8) are by design. | If the instructor ever prefers pre-filled starter code, each skeleton needs editing by hand. |
| M4 | **Legacy `units/unit-01-…` tree** retained (excluded from site nav, carries visible legacy pointers). | Deleting it would break historical links; folding its unique pages into `cpp-foundations` is a content task. |
| M5 | **Cross-module repeated section H1s** (§9) are a convention. | Could be made unique (e.g. "Arrays — Debugging") for cleaner browser-history titles; cosmetic, touches ~40 files. |

## Low-severity observations

| # | Observation |
| --- | --- |
| L1 | `Gemfile.lock` is gitignored; CI builds from version ranges — pin exact versions if reproducibility ever becomes critical. |
| L2 | The technical page documents a local `bundle exec jekyll serve` preview; Windows Ruby setup could use its own page someday. |
| L3 | Some module hub pages are intentionally short (36–48 lines) — fine as cards, but could grow "what you'll build" summaries. |
| L4 | Terminology corpus is now consistent on the sampled terms; a full sweep of ~20 more term pairs (e.g. "function vs method" pre/post-OOP) would be a nice future pass. |
| L5 | The audit tooling used here (case-walk, fence scan, balance scan) could be folded into `tools/` as a permanent `check-content.sh`. |
| L6 | README's badge-free look is deliberate; nothing to fix — noted so nobody "helpfully" adds deployment badges. |

---

## Verdict

The repository is in **publication-ready condition**: zero critical or high findings, all structural and navigation systems verified, every safe issue fixed, and five judgment items documented with clear owners. The single substantive pre-publication recommendation is **M1 — run the compile sweep on a machine with g++**.
