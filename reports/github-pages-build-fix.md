# GitHub Pages Build Fix — “Dependency Error: jekyll-coffeescript is missing”

**Date:** 2026-09-25
**Scope:** website build/deploy only. **No student-facing course content was
removed or restructured**; the content edits listed here are link repairs
found by the rebuilt site itself.

---

## 1. Original failure

The deploy workflow (.github/workflows/deploy.yml) ran successfully through
checkout, Ruby setup, `bundle install`, and `actions/configure-pages@v5`,
then failed at the Jekyll build step:

```text
bundle exec jekyll build --source docs --destination _site \
  --strict_front_matter --baseurl "/Programming-Fundamentals-Using-C-"

Dependency Error:
jekyll-coffeescript is missing
```

## 2. Root cause

**Not a Jekyll 3.10.0 regression.** The gemspecs of both Jekyll 3.9.x and
3.10.0 were checked (raw.githubusercontent.com): neither lists
`jekyll-coffeescript` as a runtime dependency (3.10.0 only adds `webrick`
and `csv`).

The actual cause was **self-inflicted configuration drift**:

- `docs/_config.yml` whitelisted **four** plugins:
  `jekyll-coffeescript`, `jekyll-gist`, `jekyll-github-metadata`,
  `jekyll-relative-links`.
- The `Gemfile` declared only **one** of them (`jekyll-relative-links`).

Jekyll **`require`s every whitelisted plugin at startup**. The first
undeclared gem in the list — `jekyll-coffeescript` — produced exactly the
reported error. (During triage a bare `gem "jekyll-coffeescript"` line had
been appended to the Gemfile as a band-aid; that would only have moved the
failure to `jekyll-gist` next.)

Why the whitelist looked plausible: the GitHub Pages **build server** does
ship all three gems (they appear on pages.github.com/versions, verified live
during this fix). But this repository does **not** build on that server —
it builds in GitHub Actions from its own Gemfile, so every whitelisted
plugin must be declared locally.

None of the three extra plugins is used by the site (a full-text scan of
`docs/` finds no `.coffee`, no `{% gist %}`, no `site.github`), so they were
removed from the whitelist rather than installed.

## 3. Files inspected

| File | Finding |
| --- | --- |
| `.github/workflows/deploy.yml` | Correct: `ruby/setup-ruby@v1` with `bundler-cache: true` installs from the root Gemfile; build flags preserved; `configure-pages` `base_path` output used for `--baseurl` |
| `Gemfile` | 3 declared gems vs 4 whitelisted plugins; stray unversioned `jekyll-coffeescript` line (band-aid) |
| `Gemfile.lock` | Did not exist (gitignored) — CI resolved fresh each run |
| `docs/_config.yml` | Plugin whitelist contained three undeclared, unused plugins |
| `.gitignore` | Excluded `Gemfile.lock` (nondeterministic builds) |
| `docs/` (282 files) | Structure intact; `technical/` and planning pages correctly excluded |
| pages.github.com/versions (live) | GitHub Pages currently ships **jekyll 3.10.0** (github-pages 232) — pinning `~> 3.9` would have *diverged* from Pages, not matched it |
| jekyll 3.9.5 / 3.10.0 gemspecs | Neither depends on jekyll-coffeescript |

## 4. Files changed

| File | Change |
| --- | --- |
| `Gemfile` | Restored the 3-gem set; `jekyll ~> 3.10` (Pages parity — Pages itself ships 3.10.0); documented the whitelist/Gemfile lockstep rule |
| `docs/_config.yml` | Plugin whitelist trimmed to exactly `jekyll-relative-links` (the only non-default plugin the site uses); lockstep rule documented |
| `Gemfile.lock` | **New, committed** — pins all 23 gems (jekyll 3.10.0, kramdown-parser-gfm 1.1.0, jekyll-relative-links 0.8.0, …), platforms `x86_64-linux` + `x64-mingw32`; local and CI builds now resolve identical versions |
| `.gitignore` | `Gemfile.lock` removed from the ignore list (it is now a tracked source file) |
| `tools/check-links.sh` | Now also scans raw-HTML `<a href>` anchors (fence/comment aware), with a dedicated ROOT-ABSOLUTE check — closes the blind spot that hid the banner links |
| `tools/check-anchors.sh` | Skips tooling directories (`.freebuff/`, `vendor/`, `node_modules/`, `.bundle/`) so dependency trees cannot pollute results |
| `docs/units/unit-01…/` (7 files) | Companion-module banners rewritten from raw HTML anchors to markdown links inside `<div class="note" markdown="1">`; 5 files had an escaping `../../../` path (corrected to `../../`), 2 `sessions/` files keep `../../../` (one directory deeper) |
| `docs/about.md`, `docs/faq.md`, `docs/glossary.md`, `docs/getting-started/getting-started-lesson.md` (2 links), `docs/toolchain/compiler-errors.md` | 6 links to repository-root files (`../CONTRIBUTING.md`, `../../README.md`, `../../CONTRIBUTING.md`) resolved on disk but 404 on the published site; converted to absolute `github.com/…/blob/main/…` URLs (same pattern `docs/course-completion-checklist.md` already used) |
| `docs/syllabus.md` (1), `docs/cpp-io/labs.md` (2), `docs/how-to-study.md` (1) | Link text wrapped across a newline (`[…\n…](target.md)`) slipped past link rewriting and lost the site baseurl in the rendered HTML; link text placed on one line |
| `CHANGELOG.md` | [Unreleased] → Fixed entry added |
| `docs/technical/github-pages.md` | Gem table updated (3.10 + Gemfile.lock), reproducibility note, new troubleshooting entries (Dependency Error lockstep rule; baseurl-lost-in-render diagnosis) |

**Not changed:** `.github/workflows/deploy.yml` (already correct — verified,
not assumed), build flags, layout stack, navigation, course content structure.

## 5. Exact dependency / configuration correction

```ruby
# Gemfile (final)
source "https://rubygems.org"

gem "jekyll", "~> 3.10"
gem "kramdown-parser-gfm", "~> 1.1"
gem "jekyll-relative-links", "~> 0.7"
```

```yaml
# docs/_config.yml (final)
plugins:
  - jekyll-relative-links
```

Rule encoded in both files: **the plugin whitelist and the Gemfile must stay
in lockstep** — Jekyll requires every whitelisted plugin at startup.

`Gemfile.lock` is committed, so GitHub Actions (`ruby/setup-ruby@v1` →
`bundle install`) and any local machine resolve the **exact same gem
versions**; the lock records both `x86_64-linux` (CI) and `x64-mingw32`
(Windows dev) platforms, and `BUNDLED WITH 2.2.33` (CI’s setup-ruby picks a
compatible bundler automatically for lockfiles of this generation).

## 6. Local build result

This machine has **no system Ruby** (none installed, none on PATH) and the
Docker daemon is unreachable, so a hermetic local toolchain was assembled —
entirely inside the gitignored `.freebuff/` scratch area, no administrator
rights, no repository pollution:

- Portable RubyInstaller **Ruby 3.0.7 (x64-mingw32)** unpacked to
  `.freebuff/ruby/` (chosen because Ruby ≤ 3.0 has prebuilt Windows binaries
  for the native gems; Ruby 3.1+ would require a compiler).
- The **exact locked gem versions** from the committed `Gemfile.lock` were
  installed into a sandboxed `GEM_HOME` (`.freebuff/gems`).
- Two gems that are only needed by `jekyll serve`’s file-watcher and have no
  compiler-free Windows builds (`http_parser.rb 0.8.1`, `ffi 1.17.4`) are
  present as **local stubs that raise if ever loaded** — a `jekyll build`
  never loads them (CI installs the real gems on Linux).

```text
$ bundle exec jekyll build --source docs --destination _site \
      --strict_front_matter --baseurl "/Programming-Fundamentals-Using-C-"
Configuration file: docs/_config.yml
            Source: docs
       Destination: _site
 Incremental build: disabled. Enable with --incremental
      Generating...
                    done in 5.72 seconds.
 Auto-regeneration: disabled. Use --watch to enable.
```

**Exit code 0.** Three full clean rebuilds were run (after each round of
link fixes) with identical results.

## 7. Generated site verification

`_site/` — **264 HTML pages, 274 files total.**

| Check | Result |
| --- | --- |
| `_site/index.html` exists | ✅ (workflow’s `test -f` gate will pass) |
| Homepage is the student course | ✅ `<title>Programming Fundamentals Using C++ · …</title>`, `<h1>Programming Fundamentals Using C++</h1>`, “Start here”, 16-week roadmap, module table — not a technical/deployment page |
| Excluded pages absent | ✅ no `course-architecture.html`, `implementation-plan.html`, `technical/` in output |
| Baseurl handling | ✅ **site-wide scan: every internal `href` starts with `/Programming-Fundamentals-Using-C-/`** (this scan caught and drove the fixes for 10 baseurl-less links during verification) |
| No `.md` URLs left in rendered HTML | ✅ only the 8 intentional absolute GitHub blob URLs remain |
| Stylesheet | ✅ `/Programming-Fundamentals-Using-C-/assets/css/course.css`, file present on disk |
| Navigation / pager / footer | ✅ `site-nav`, breadcrumbs, prev/next pager, `site-footer` present on deep pages (e.g. unit-01 session 1.2) |
| Unit-01 companion banners | ✅ render as proper links to `/Programming-Fundamentals-Using-C-/cpp-foundations/` |
| 404 page | ✅ `<base href="/Programming-Fundamentals-Using-C-/">` fallback intact |
| `tools/check-links.sh` | ✅ `Checked 3077 relative link(s) in docs. OK: all internal links resolve.` |
| `tools/check-anchors.sh` | ✅ `anchors OK — 1045 fragment links checked; valid on github.com AND Jekyll/Pages` |

## 8. Remaining warnings (non-blocking)

1. **“Ruby Sass has reached end-of-life”** notice when the `sass` gem
   installs. Benign: jekyll 3.x uses the pure-Ruby converter
   (`jekyll-sass-converter 1.5.2`), the site ships one plain-CSS file, and
   the same `sass 3.7.4` is what the Pages toolchain pins.
2. **Local Ruby is 3.0.7 vs CI’s 3.2** (workflow). The build-path gem set is
   pure Ruby (two serve-only native gems stubbed locally only), so results
   are equivalent; CI is unchanged and authoritative.
3. **`Gemfile.lock` discipline:** regenerate it (`bundle install`) whenever
   the Gemfile changes; CI’s `bundler-cache: true` fails loudly on drift —
   intentional, that is the reproducibility guard working.
4. **GitHub Pages also ships default plugins** (jekyll-sitemap, jekyll-feed,
   jekyll-seo-tag, …). They are deliberately *not* whitelisted — the custom
   layout needs none of them, and keeping the whitelist minimal makes
   local/CI/Pages builds identical.

---

## BUILD STATUS: PASS

- **Exact command:**
  `bundle exec jekyll build --source docs --destination _site --strict_front_matter --baseurl "/Programming-Fundamentals-Using-C-"`
  (run via `bundle exec` against the committed `Gemfile` + `Gemfile.lock`;
  all original flags preserved)
- **Generated output directory:** `_site/` (264 HTML pages / 274 files;
  homepage verified as the student course)
- **Workflow files involved:** `.github/workflows/deploy.yml` (unchanged —
  verified correct), with `Gemfile`, `Gemfile.lock`, `docs/_config.yml`
  feeding its build step
- **Remaining non-blocking warnings:** the four listed above (Sass EOL
  notice, local/CI Ruby minor-version difference, lockfile discipline,
  intentional Pages-plugin non-whitelist) — none affects the build, the
  deployed site, or students
