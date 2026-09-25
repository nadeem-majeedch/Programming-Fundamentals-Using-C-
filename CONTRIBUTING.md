# How to Contribute

Thanks for helping improve **Programming Fundamentals Using C++**! This is a
free, open course used by self-studying students around the world, so even a
one-line fix matters.

## Report a typo, error, or broken link (fastest way to help)

1. Open a GitHub **Issue** on this repository.
2. Use a short, specific title, e.g. `Typo in session 1.2: "stament" → "statement"`.
3. In the body, include:
   - the **page path** (e.g. `docs/units/unit-01.../sessions/session-1.2.md`),
   - the **section heading** or quoted sentence,
   - what it says now vs. what it should say.

For a **broken link**, include the page and the link text; for a **compile
error** in an example, include the exact compiler command and the full error
message.

## Suggest new content

Open an Issue starting with `Suggestion:` — for example a new challenge
problem, a clearer explanation, or an extra exercise. Suggestions that help
beginners are especially welcome.

## Fix it yourself (pull request)

1. Fork the repository and create a branch.
2. Make your change. Please keep the course's existing style:
   - Markdown follows the conventions in `docs/course-architecture.md` §13;
   - C++ examples compile cleanly with
     `g++ -std=c++17 -Wall -Wextra file.cpp -o program`.
3. Run the validation checks before submitting:

   ```bash
   bash tools/check-links.sh     # every relative link resolves
   bash tools/check-anchors.sh   # every #fragment works on github.com AND GitHub Pages
   ```

   In-page fragment links are the subtle one: GitHub and Jekyll build
   different slug algorithms for headings (numbered headings and emoji
   headings differ most). The anchor checker only accepts fragments that are
   valid under BOTH — either a heading with an identical slug under both
   rules, or an explicit `<a name="..."></a>` placed above the target. Use
   explicit anchors for anything numbered or decorated.
4. Open a pull request describing what you changed and why.

## Website deployment (maintainers)

The course website is deployed automatically: a push to `main` that touches
`docs/**`, the `Gemfile`, or the workflow itself builds the Jekyll site and
publishes it with the official Pages actions (`.github/workflows/deploy.yml`).
You can also run it manually from **Actions → Deploy course website → Run
workflow**. Deployment mechanics, settings, expected URLs, and
troubleshooting live in `docs/technical/github-pages.md` (maintainers only —
not published on the student site). Content contributions need no deployment
knowledge: if your links pass `tools/check-links.sh`, the site will build.

## What we cannot accept

- Links to unverified or low-quality external resources (the course only
  links to established, free references).
- Solutions to quizzes/labs posted in Issues — please let students attempt
  them first! (Solutions already exist in the repo under `solution/` folders.)
- Reformatting whole files without a substantive reason.

## Attribution

Contributions are acknowledged in the repository's
[CHANGELOG](CHANGELOG.md) and GitHub's contributor graph. By contributing you
agree that your contributions are licensed under the repository's
[LICENSE](LICENSE) (MIT).
