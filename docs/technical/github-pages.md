# GitHub Pages — Deployment & Site Operations (Technical)

> **Who this page is for:** repository maintainers and contributors.
> Students never need this page — the published website is self-explanatory
> and every student-facing page links back to the course home.
> This document is excluded from the published site (`docs/_config.yml`
> excludes `technical/`) and is read on GitHub.

---

## How deployment works

The course website is a **Jekyll site whose source lives in `docs/`**. It is
built and published automatically by GitHub Actions:

```text
push to main (docs/** or Gemfile or the workflow changed)
        │
        ▼
  .github/workflows/deploy.yml  (or a manual run: Actions → Deploy… → Run workflow)
        │
        ▼
  build job
    1. actions/checkout@v4          — fetch the repository
    2. ruby/setup-ruby@v1           — Ruby 3.2 + `bundle install` from the Gemfile
    3. actions/configure-pages@v5   — learns the Pages base URL
    4. jekyll build --source docs   — produces _site/ (JEKYLL_ENV=production)
    5. verify _site/index.html      — refuse to deploy a broken build
    6. actions/upload-pages-artifact@v3 — package _site/
        │
        ▼
  deploy job (needs: build)
    7. actions/deploy-pages@v4      — publish the artifact, reports the live URL
```

Properties of this setup:

- **Build from source every time.** Nothing is cached between deploys; a
  deploy can always be re-run safely.
- **One deployment at a time.** The `pages` concurrency group queues runs
  instead of cancelling a running deploy.
- **Skipped when unrelated files change.** The push trigger is filtered to
  site inputs (`docs/**`, `Gemfile*`, the workflow itself) so a README or
  lesson-independent change does not trigger a deploy. Use the manual
  `workflow_dispatch` run if you ever need to force one.
- **Fail fast.** The build runs with `--strict_front_matter` and the workflow
  verifies the homepage exists before uploading.

## One-time repository settings

1. **Settings → Pages → Build and deployment → Source: "GitHub Actions".**
   Until this is set, the deploy job cannot publish (it fails with a clear
   message — this is expected, not a bug).
2. Nothing else is required: the workflow declares its own permissions
   (`contents: read`, `pages: write`, `id-token: write`) and deploys into the
   `github-pages` environment, which GitHub creates automatically on first
   deploy.

## Workflow location and files

| Path | Role |
| --- | --- |
| `.github/workflows/deploy.yml` | The deployment workflow (build + deploy jobs) |
| `Gemfile` | Build gems: `jekyll` 3.9, `kramdown-parser-gfm` (needed for `input: GFM`), `jekyll-relative-links` |
| `docs/_config.yml` | Site configuration, plugin whitelist, published-site excludes |
| `docs/_layouts`, `docs/_includes`, `docs/assets/css` | The site's layout, navigation and stylesheet |
| `docs/_data/course.yml` | Module order used by the prev/next pager |

To change deployment behaviour, edit the workflow and push to `main` (the
workflow triggers on changes to itself).

## Expected Pages URL

For this repository the published site is a **project Pages site**:

```text
https://nadeem-majeedch.github.io/Programming-Fundamentals-Using-C-/
```

The exact URL is always visible after a deploy (Actions run summary, deploy
job → "Deploy to GitHub Pages" step) and in **Settings → Pages**.

**Why this matters for links:** on a project site every page lives under
`/Programming-Fundamentals-Using-C-/`. The workflow therefore passes
`steps.pages.outputs.base_path` as the Jekyll `--baseurl` (the path only —
never the full `base_url`), and the layout uses the `relative_url` filter
for header, stylesheet, and pager links — which is why navigation works at
both `…/repo/` and any custom domain, unchanged.

Contributor rule: **inside course Markdown, use relative links**
(`../roadmap/index.md`, `lesson-2.md`), never root-absolute ones
(`/roadmap/` — correct only with a custom domain). Root-absolute URLs are
reserved for the layout's `relative_url` expressions and the 404 page's
`<base>` fallback. The link checker (`tools/check-links.sh`) enforces
relative-link resolution across the course.

## How students access the website

- The site URL is shown in the repository's **About sidebar** once Pages is
  enabled (click the ⚙ next to *About* → check *Use your GitHub Pages
  website*), and the main `README.md` links to it in a single line.
- All content is reachable from the site home: Start-here box → Roadmap →
  modules → lessons, labs, projects, practice, quizzes.
- No account, enrolment, or JavaScript is required; every page works in a
  plain browser.

## Local preview

```bash
bundle install                                  # once, from the repository root
bundle exec jekyll serve --source docs --baseurl ""
# open http://localhost:4000
```

This uses the same Gemfile and configuration as CI, so a page that renders
locally renders identically after deploy (differences in plugin sets are the
classic exception — the whitelist in `docs/_config.yml` keeps them aligned).

## Troubleshooting

### The deploy job fails immediately

- *"GitHub Pages site failed … check your settings"* or 404 on the site URL:
  **Source is not "GitHub Actions"** — see *One-time repository settings*
  above. The very first deploy after switching the source is the one to watch.
- Permission/token errors: the workflow requests `pages: write` +
  `id-token: write`; organization policies can forbid OIDC tokens. In that
  rare case, an owner must adjust repository/org Actions policy.

### The build fails

- Read the **build job** log of the failing run; Jekyll errors name the file.
- `Unknown tag 'page'`-style or `input: GFM` errors mean the Gemfile plugins
  did not install — `kramdown-parser-gfm` must be present.
- Front-matter YAML errors are surfaced by `--strict_front_matter`; fix the
  named file (our `tools/check-anchors.sh` and link checker catch most
  content mistakes before push).

### The site deploys but is broken or empty

- **Styled but no content** — check that `docs/index.md` still exists and the
  workflow's homepage verification passed.
- **Unstyled or assets 404** — a `baseurl` mismatch: the build must use the
  `configure-pages` base URL (the workflow does; local previews pass
  `--baseurl ""`).
- **Some pages missing** — excluded by `docs/_config.yml` on purpose:
  `course-architecture.md`, `implementation-plan.md`, and everything in
  `docs/technical/`.

### Common 404 causes

1. **Pages disabled or Source not "GitHub Actions"** — the classic one.
2. **The deploy never ran** — pushes that touch no site inputs are filtered
   out by the workflow's `paths:` list; trigger a manual run if needed.
3. **Hand-typed `.md` addresses** — the site serves `.html` URLs; relative
   `.md` links are rewritten by `jekyll-relative-links`, but an address typed
   with `.md` is expected to 404.
4. **A page was renamed or deleted** — the site's 404 page offers recovery
   links (home, roadmap, syllabus, practice bank).
5. **Root-absolute links introduced into course Markdown** — they resolve
   only on a user-site or custom domain, not a project URL. Convert them to
   relative links and re-deploy.

### Post-deploy verification checklist

- [ ] Homepage loads at the project URL (not `/` of the user domain).
- [ ] Header navigation: Roadmap, Syllabus, Practice, Labs, Projects,
      Quizzes, Glossary, About — all load.
- [ ] A deep page (e.g. a session page two modules down) loads and its
      breadcrumbs and prev/next pager work — this proves `baseurl` is right.
- [ ] A quiz page's `<details>` answer blocks expand and render formatted.
- [ ] The browser console shows no missing-asset (404) requests.
