# Build dependencies for the course website (source: docs/).
#
# Exactly the gems the site needs — nothing else:
#   * jekyll                  — the site generator itself, pinned to the same
#                               major.minor GitHub Pages builds with (see the
#                               "jekyll" entry at pages.github.com/versions)
#   * kramdown-parser-gfm     — required by Jekyll 3.x + kramdown 2.x for
#                               `input: GFM` in docs/_config.yml
#   * jekyll-relative-links   — converts the course's relative .md links to
#                               .html URLs on the built site
#
# KEEP THE PLUGIN WHITELIST IN LOCKSTEP WITH THIS FILE: Jekyll `require`s
# every plugin listed in docs/_config.yml at startup, so a whitelist entry
# without a matching `gem` line here breaks the build with
# "Dependency Error: <plugin> is missing". (That is exactly what happened
# with jekyll-coffeescript/jekyll-gist/jekyll-github-metadata: they were
# whitelisted but never declared, and no course page uses them — they were
# removed from the whitelist rather than installed.)
#
# Gemfile.lock is committed so local builds and GitHub Actions resolve the
# exact same gem versions; regenerate it (`bundle install`) whenever this
# file changes.
#
# If you ever want strict parity with the Pages build server's full plugin
# set instead, replace the three lines below with:
#     gem "github-pages", group: :jekyll_plugins
source "https://rubygems.org"

gem "jekyll", "~> 3.10"
gem "kramdown-parser-gfm", "~> 1.1"
gem "jekyll-relative-links", "~> 0.7"
