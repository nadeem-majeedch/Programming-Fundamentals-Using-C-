# Student Experience Audit — Programming Fundamentals Using C++

> **Audit date:** 24 September 2026 · **Scope:** the entire student journey — main README, website homepage, Getting Started, roadmap, all 24 modules, practice/assessment systems.
> **Method:** a page-by-page walk of the course exactly as a never-programmed student would take it, combined with automated scans (concept-before-use detection across all 1,576 C++ listings, exercise/hint/solution inventories, link and anchor validators, navigation-order checks).
> **Nothing was committed or pushed.** Safe issues were fixed; judgment items are documented, not silently resolved.

---

## Verdict

**A complete beginner can start this course today and reach the capstone without an instructor.** The Day-1 path (README → Getting Started → first program → Lesson 1) is explicit, the try-first protocol is enforced everywhere, and every module ships explanations, examples, exercises, hints, solutions, and labs. The audit found **1 Critical, 2 High, and 3 Medium issues — all fixed in this session** — plus Low items documented below. Every defect was about *signposting* (what to study next, where units live), not about the teaching material itself, which is strong.

---

## Findings and fixes

| # | Severity | Issue | Status |
| --- | --- | --- | --- |
| 1 | **Critical** | README's "Start here → Week 1 → Lesson 1" chain listed all 22 modules **before** "Unit 01 · Lesson 1" — a student following it top-to-bottom would study 22 modules before their first line of C++, and the final link was the legacy duplicate of the Foundations lesson, not the maintained one | ✅ Fixed — chain now reaches **Unit 01 · Lesson 1** (the maintained Foundations lesson) third, immediately after Getting Started and Problem-Solving; the four enrichment modules are annotated *(after the course — enrichment)* |
| 2 | **High** | README told students Units 02–16 would be "published unit by unit" and that sessions/labs/quizzes "come alive as each unit lands", while the progress checklist had empty blocks "(published with Unit 02)" — materially false: all Units 02–15 are fully taught through the themed modules | ✅ Fixed — README now maps every unit (2–16) to its module, labs, quizzes, and project; progress checklist has real per-unit blocks; syllabus "🔜 coming" rows replaced with ✅ module links |
| 3 | **High** | Website homepage's module table ordered Strings → Pointers → Records → Files → Algorithms, contradicting the canonical order (Strings → Files → Pointers → Records; Algorithms before Strings) used by the syllabus, roadmap, and the site's own prev/next pager | ✅ Fixed — homepage table now matches the canonical reading order |
| 4 | **Medium** | Syllabus Unit 14 titled "Introduction to OOP: Classes" with Lab "Student Class Library", and Unit 15 Lab "Roster & Report Lab" — names that exist nowhere else; the real Unit-14 material is the Records bridge + first class labs (BankAccount, Student) and Unit 15's capstone lab is the Object-Oriented Mini Project | ✅ Fixed — titles, lab names, and session-topic table updated to match the modules students actually study |
| 5 | **Medium** | All 7 Unit-01 pages carried a "Legacy path — superseded" banner while the README, Getting Started, and roadmap all present Unit 01 as the live Week-1 material with its lab and quiz — a student opening Lesson 1 was told the very page they were sent to was dead | ✅ Fixed — banners now read "**Companion module:** the C++ Foundations module is the complete, enriched version — study these pages together" (accurate; the Foundations index itself says "alongside, not instead") |
| 6 | **Medium** | README's "Recommended learning sequence" schematic named pages that do not exist ("Unit 02 Lesson 1", "Unit 03 Lesson 1") | ✅ Fixed — schematic now names the real material (Foundations lessons 2–4, Iteration lessons 1–2, Algorithms lessons 2–3, Modern C++ + Modular) |
| 7 | Low | Unit-12 title appears as "File I/O" (syllabus, README) but the module is titled "File Handling" | 📋 Documented — both names are used naturally in teaching; a rename is cosmetic and was not worth churning 3 files |
| 8 | Low | Unit 02–04 lab names (Receipt Calculator, Interactive Grade Reporter, Decision Lab) exist as syllabus labels; students find the equivalent practice under the module labs (Foundations variations, I/O 5 scenarios, Decisions 8 scenarios) | 📋 Documented — README unit table now links both the module labs and the syllabus briefs so the mapping is explicit |
| 9 | Low | Compiler-level validation of all 1,576 C++ listings is impossible in this environment (no g++/clang/MSVC; WSL and Docker unusable) | 📋 Documented — deep static validation was performed instead (see `reports/cpp-validation.md`); the deploy runner has g++ preinstalled, so a CI compile gate is the recommended follow-up |
| 10 | Low | Enrichment modules (Inheritance, Robustness, STL, Templates) sit inside the site pager between core modules | 📋 Documented — each is labelled *(advanced / optional enrichment)* on the homepage, in the syllabus, and in its own index; the roadmap provides an explicit "Beyond Week 16" path. Acceptable design trade-off for linear pager navigation |

---

## The 25-point evaluation

| # | Question | Verdict | Evidence from the walk |
| --- | --- | --- | --- |
| 1 | Can a complete beginner understand where to start? | ✅ Yes | Homepage: "Start here — 30 minutes to your first program" (3 numbered steps). README: welcome → who-for → prerequisites → start chain ending in a clickable Lesson 1. Getting Started: "three small steps" with time budgets |
| 2 | Are prerequisites clearly stated? | ✅ Yes | README prerequisites table (a computer, nothing else); "No mathematics beyond basic arithmetic… no prior CS knowledge is assumed"; every roadmap session lists prerequisites ("none — this is the start"); every module index states what you need |
| 3 | Is the learning sequence logical? | ✅ Yes (after fix) | Canonical order enforced: Getting Started → Problem-Solving → Foundations → I/O → Decisions → Iteration → Functions → Arrays → Algorithms → Strings → Files → Pointers → Records → OOP; homepage, pager, syllabus, and roadmap now all agree |
| 4 | Are concepts introduced before being used? | ✅ Yes | Automated scan of all C++ listings in every module before their owner: **0** uses of vectors, structs, classes, references-as-parameters, or `new`/`delete` before they are taught; the only exceptions live in explicitly advanced/enrichment modules |
| 5 | Does difficulty increase gradually? | ✅ Yes | Problem-Solving's 20 scenarios are "progressively harder"; Practice Bank tiers B → C → I → A → Challenge; every exercise set is graded; challenges carry ★/★★/★★★; sessions build ("Session 1.2 prerequisites: Session 1.1") |
| 6 | Are explanations understandable without an instructor? | ✅ Yes | Lesson 1 defines a program via a rice recipe ("a computer follows steps *exactly*; it cannot 'taste'"), explains the compiler as a translator, tabulates every flag of the compile command, and promises every term will be defined before use — the glossary collects them |
| 7 | Are examples sufficient? | ✅ Yes | 1,576 C++ listings across the course; every concept follows "plain-language explanation → syntax → worked example → explanation → practice pointer"; examples are designed to be typed, modified, and broken |
| 8 | Are there enough exercises? | ✅ Yes | Per-module sets (e.g. Iteration 36, Arrays 36, Functions 30, Strings 30, Foundations 24 + 10 predictions + 10 debug hunts) plus the 200-problem Practice Bank and 10 challenge sets per module |
| 9 | Are labs realistic? | ✅ Yes | Labs are domain scenarios (billing, student records, inventory, banking, library, temperature, travel, utility bills, hospital-record-style generic scenarios), not bare math drills; the 42-lab collection spans 5 levels from beginner to integrated |
| 10 | Are solutions available for self-study? | ✅ Yes | Every lab has a complete solution + explanation; quiz answer keys with explanations; practice problems have reference solutions; the course "never leaves you stuck" |
| 11 | Are hints available before solutions? | ✅ Yes | Practice Bank uses numbered hint ladders (①②③) before each solution; debug hunts use a 3-step hint ladder (reread → error catalogue → solution); lab briefs separate student tasks from solutions |
| 12 | Are challenge problems provided? | ✅ Yes | Every module has a challenge set (e.g. 15 in Iteration and Arrays, 10 elsewhere); the Practice Bank's Challenge tier adds 40; extensions listed on every lab |
| 13 | Are there enough debugging activities? | ✅ Yes | Every module has a 10-hunt debugging page; dedicated Debugging & Testing module (20 broken programs + challenge lab); each unit's "Debug It" seeded-bug file; verified seed counts match the published fix lists |
| 14 | Are there enough projects? | ✅ Yes | 10 complete project briefs (calculator → integrated OOP system) with milestones, test plans, edge cases, rubrics, hints, reference solutions, design notes; 3 flagship projects mapped to rehearsals |
| 15 | Are students taught how to test their programs? | ✅ Yes | Problem-Solving teaches test cases, edge cases, and trace tables in Week 0; the Debugging module teaches boundary/invalid-input/regression testing and assertions; every lab carries a testing checklist |
| 16 | Are common beginner mistakes explained? | ✅ Yes | Each module has a "mistakes gallery" (mixing `cin`/`getline`, `>` vs `>=` boundaries, off-by-one, integer division, uninitialized `max`, file open checks…); compiler-error catalogue for the classic first errors |
| 17 | Is the navigation intuitive? | ✅ Yes (after fixes) | Site header spans the whole course; breadcrumbs; prev/next module pager driven by canonical order; every page links module home and course home; roadmap links the exact material per session |
| 18 | Are internal links working? | ✅ Yes | **3,052 relative links** verified resolving; **1,063 fragment anchors** valid under both GitHub and Jekyll slug rules; case-sensitivity walk clean |
| 19 | Is the website mobile-friendly? | ✅ Yes | Viewport meta present; `@media (max-width: 640px)` layout adaptations; wide tables scroll without dragging code blocks; system fonts keep pages light |
| 20 | Is instructor information appropriately separated? | ✅ Yes | One "About the instructor" section in the README footer (3 lines) + `docs/about.md`; no biography, contact, or administrative material inside lessons |
| 21 | Is deployment info kept off the student homepage? | ✅ Yes | README body contains zero deployment content (one line carries the live-site URL); workflow/technical docs live in `docs/technical/` and are excluded from the published site; planning docs excluded too |
| 22 | Can students complete the course without instructor intervention? | ✅ Yes | Every unit: reading → examples → exercises → hints → solutions → lab with rubric → quiz with explained key; scoring bands tell students when to move on (≥ 90%) or revisit; two practice finals with post-exam worksheets |
| 23 | Does the course progress beginner → advanced? | ✅ Yes | Six syllabus stages (Foundations → Capstone) plus a defined "Beyond Week 16" enrichment path (inheritance, exceptions, modern C++, STL, templates, multi-file projects) |
| 24 | Are there unnecessary advanced topics too early? | ✅ No | The scan found zero forward references in core-sequence code; templates, exceptions, and the STL are quarantined in labelled enrichment modules; inheritance is deliberately excluded from the core OOP module ("no inheritance by design") |
| 25 | Are there gaps in fundamental C++ knowledge? | ✅ No significant gaps | All fundamentals covered: structure, types, operators/conversion, I/O, decisions, loops, functions, arrays/vectors, algorithms, strings, files, pointers/dynamic memory, records/enums, classes, and the modern toolkit; modules that teach each are linked from every roadmap week |

---

## Pedagogical progression analysis

**Concept-before-use (automated).** All C++ listings in every module *earlier* than a concept's owner module were scanned for that concept: `std::vector`, `struct`, `class`, reference parameters, `new`/`delete`, `try`/`catch`/`throw`, `template`, `<algorithm>` calls. **Zero hits** in the core sequence. The 10 `try`/`catch` occurrences outside the robustness module all live in the explicitly-advanced Generics/Modern C++/Modular modules, whose students have already met the fundamentals. This is the strongest quantitative evidence that the course never uses a tool before teaching it.

**Scaffolding in the first lesson (manual).** Lesson 1 moves from a recipe analogy → "computers follow steps exactly" → machine code → the compiler as translator → the three-step edit–compile–run loop → a first program whose every line is then tabulated (`g++`, `-std=c++17`, `-Wall -Wextra`, `-o`). Nothing is named before it is defined; the tone explicitly de-panics errors ("the compiler politely telling you about suspicious code"). This is model teaching for absolute beginners.

**Difficulty ramp (structural).** Three independent ramps agree: module lesson order, Practice Bank tiers, and the 42-lab levels. Challenges never appear before their unit's lab; projects are scheduled at Weeks 5/10/16 with rehearsal projects preceding each.

**Self-study integrity.** The "Try It Yourself Before Looking at the Solution" protocol is stated in Week 0 and re-invoked by every module; hints always precede solutions; answers use hidden `<details>` blocks so a page can be read without spoilers.

---

## Student-walkthrough highlights

- **Minute 0 (README):** one-line promise, "who this is for" table, prerequisites, a journey diagram, and (after the fix) a start chain that reaches Lesson 1 on the third click.
- **Week 0:** Getting Started offers per-OS compiler guides, an online-compiler escape hatch for locked-down machines, a sanity-check program, a 12-scenario troubleshooting guide, Lab 00 (build a poster + hunt seeded bugs), and a 10+5 exercise set — all before any C++ syntax is demanded.
- **First lesson:** the student is told what everything is *before* typing it, and the lesson's example is the same `sanity-check.cpp` they already ran — the course connects its own dots.
- **Any module page:** objectives, lessons, exercise counts, lab lists, quiz links — with the try-first protocol at the top.
- **Assessment:** weekly quizzes W01–W16, topic tests, cumulative tests, two practice finals — each question difficulty-labelled with a hidden, explained key.

---

## Post-fix validation

- ✅ `tools/check-links.sh`: 3,052 relative links, all resolve
- ✅ `tools/check-anchors.sh`: 1,063 fragments valid on github.com **and** Jekyll/Pages
- ✅ No "superseded"/"coming soon" wording remains anywhere a student can reach
- ✅ Every new README/syllabus link target verified on disk
- ✅ `reports/` and `docs/technical/` remain outside the published site

## Remaining recommendations

1. Add a CI compile gate for the 1,576 listings using the deploy runner's g++ (`-fsyntax-only` sweep) — the one validation layer this environment could not perform.
2. Optionally align the Unit-12 title ("File I/O" vs "File Handling") across syllabus/README/module — cosmetic.
3. After first deploy, walk the post-deploy checklist in `docs/technical/github-pages.md` (homepage, a two-modules-deep page, a `<details>` quiz page).
