#!/usr/bin/env bash
# check-links.sh — verify that every relative link in the course Markdown
# points to a file that actually exists on disk.
#
# Usage:   bash tools/check-links.sh
# Exit:    0 = all links resolve, 1 = dead links found (print them first).
#
# Rule this enforces (course-architecture.md §2.10, §11):
#   "No dead links in a public course."
#
# Since the STL module, link extraction strips Markdown CODE before
# scanning: fenced ``` blocks are skipped and inline `...` spans are
# removed. C++ listings are full of `[](int a, int b)` lambda syntax that
# a raw ](...) scan misreads as a link — code is not prose, and course
# listings must stay copy-paste clean.
#
# Raw-HTML anchors are scanned too: course prose uses the occasional
# <a href="..."> inside banner <div>s, which the ](...) scanner never sees.
# That blind spot is how an escaping banner link (../../../ that climbed out
# of docs/) survived earlier passes. The HTML scan reports hrefs that are
# root-absolute ("/x" — never valid on a project Pages site) or resolve to
# a missing file; URL-form and #fragment hrefs are skipped here.

set -u

root="${1:-docs}"
broken=0
checked=0

md_files=$(find "$root" -type f -name '*.md' | sort)

for md in $md_files; do
    dir=$(dirname "$md")

    # Extract link targets from PROSE only:
    #   - skip lines inside ``` fences (toggle on delimiter lines)
    #   - strip inline code spans `...` before scanning for ](target)
    # Everything else matches the original grep-based extraction.
    targets=$(awk '
        { line = $0 }
        /^[[:space:]]*```/ { infence = !infence; next }
        infence            { next }
        {
            while (match(line, /`[^`]*`/))
                line = substr(line, 1, RSTART - 1) " " substr(line, RSTART + RLENGTH)
            rest = line
            while (match(rest, /\]\([^)]+\)/)) {
                print substr(rest, RSTART + 2, RLENGTH - 3)
                rest = substr(rest, RSTART + RLENGTH)
            }
            while (match(rest, /<a [^>]*href="[^"]*"[^>]*>/)) {
                tag = substr(rest, RSTART, RLENGTH)
                rest = substr(rest, RSTART + RLENGTH)
                if (match(tag, /href="[^"]*"/))
                    print substr(tag, RSTART + 6, RLENGTH - 7)
            }
        }
    ' "$md" | grep -vE '^(https?:|mailto:|#)' || true)

    for target in $targets; do
        # URL-form targets (scheme://) and bare fragments are out of scope here.
        # (http/https/mailto lines are already dropped by the grep above; this
        # catches any other scheme, e.g. ftp:// or protocol-relative //host/.)
        case $target in
            *"://"* | mailto:*) continue ;;
            "#"*) continue ;;
        esac

        # Raw-HTML anchors must not be root-absolute: "/x" resolves only on a
        # user site or custom domain, never under /<repo>/ on project Pages.
        case $target in
            /*)
                printf 'ROOT-ABSOLUTE HTML LINK: %s -> %s\n' "$md" "$target"
                broken=$((broken + 1))
                continue
                ;;
        esac

        # Strip fragment/query for filesystem lookup.
        path="${target%%#*}"
        path="${path%%\?*}"
        [ -z "$path" ] && continue

        # Percent-encoded spaces (%20) are common in markdown links.
        path=$(printf '%b' "${path//%20/ }")

        checked=$((checked + 1))
        if [ ! -e "$dir/$path" ]; then
            printf 'DEAD LINK: %s -> %s\n' "$md" "$target"
            broken=$((broken + 1))
        fi
    done
done

printf -- '---\nChecked %d relative link(s) in %s.\n' "$checked" "$root"

if [ "$broken" -gt 0 ]; then
    printf 'FAILED: %d dead link(s) found. Fix before publishing.\n' "$broken"
    exit 1
fi
printf 'OK: all internal links resolve.\n'
exit 0
