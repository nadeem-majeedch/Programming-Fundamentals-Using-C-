#!/usr/bin/env bash
# check-anchors.sh — verify every `file.md#fragment` / same-page `#fragment`
# link resolves on BOTH github.com and the Jekyll-built GitHub Pages site.
#
# A fragment link is considered VALID only when one of these holds:
#   1. it points at an explicit anchor: <a name="frag"> or <a id="frag">
#      (GitHub prefixes it with user-content- and bridges #frag via JS;
#       Jekyll/kramdown passes the raw HTML through untouched)  — or
#   2. it points at a heading whose GitHub slug and kramdown slug are
#      IDENTICAL (safe everywhere: plain words, single hyphens, no
#      leading digits/emoji/punctuation).
#
# Slugs verified from source:
#   GitHub  : github-slugger — lowercase; remove chars other than
#             letters/digits/space/hyphen/underscore; spaces -> '-';
#             hyphens and underscores preserved as-is.
#   Jekyll  : kramdown basic_generate_id — strip LEADING non-LETTERS;
#             keep [a-zA-Z0-9 -]; spaces -> '-'; downcase; empty -> 'section'.
#
# Usage: bash tools/check-anchors.sh   (repo root; exit 1 on problems)

set -u
shopt -s nullglob

gh() { # github-slugger
    local t=${1,,}
    t=${t//[^a-z0-9 _-]/}
    t=${t// /-}
    printf '%s' "$t"
}
jy() { # kramdown basic_generate_id
    local t=${1,,}
    while [[ $t == [!a-z]* ]]; do t=${t:1}; done
    t=${t//[^a-z0-9 -]/}
    t=${t// /-}
    [[ -z $t ]] && t=section
    printf '%s' "$t"
}

declare -A ANCHOR BOTH GHONLY
files=()
while IFS= read -r f; do
    # Skip tooling/dependency trees (gem docs, vendored sources, caches):
    # they carry their own markdown with unrelated anchors.
    case $f in
        .freebuff/* | */.freebuff/* | vendor/* | */vendor/* \
            | node_modules/* | */node_modules/* | .bundle/* | */.bundle/*) continue ;;
    esac
    files+=("$f")
done < <(find . -path ./.git -prune -o -name '*.md' -print 2>/dev/null | sed 's|^\./||')

# ---- pass A: collect explicit anchors + heading slugs (keys relative to root) ----
for f in "${files[@]}"; do
    # explicit anchors
    while IFS= read -r a; do
        ANCHOR["$f|$a"]=1
    done < <(grep -o '<a [^>]*name="\([^"]*\)"' "$f" | sed 's/.*name="//; s/"$//' \
             ; grep -o '<a [^>]*id="\([^"]*\)"' "$f" | sed 's/.*id="//; s/"$//')
    # heading slugs
    while IFS= read -r h; do
        h=${h#"${h%%[![:space:]]*}"}; h=${h%"${h##*[![:space:]]}"}
        g=$(gh "$h"); j=$(jy "$h")
        [[ -z $g ]] && continue
        if [[ $g == "$j" ]]; then BOTH["$f|$g"]=1; else GHONLY["$f|$g"]=1; fi
    done < <(grep '^#\{1,6\} ' "$f" | sed 's/^#\{1,6\} *//')
done

# ---- pass B: scan every markdown link carrying a fragment ----
problems=0; total=0
for f in "${files[@]}"; do
    dir=${f%/*}; [[ $dir == "$f" ]] && dir=.
    while IFS= read -r link; do
        link=${link#*(}; link=${link%)}
        case $link in http*:*|mailto:*) continue ;; esac
        [[ $link != *#* ]] && continue
        target=${link%%#*}; frag=${link#*#}
        [[ -z $frag ]] && continue
        if [[ -z $target || $target == /* ]]; then
            rf=$f
        else
            abs=$(cd "$dir" 2>/dev/null && realpath -m "$target" 2>/dev/null)
            [[ -z $abs ]] && abs=$PWD/$dir/$target
            rf=${abs#"$PWD/"}
        fi
        total=$((total+1))
        [[ -n ${ANCHOR[$rf|$frag]:-} ]] && continue   # explicit anchor: valid everywhere
        if [[ -n ${BOTH[$rf|$frag]:-} ]]; then continue; fi   # stable heading slug
        problems=$((problems+1))
        if [[ -n ${GHONLY[$rf|$frag]:-} ]]; then
            echo "UNSTABLE $f -> $rf#$frag  (heading slug differs on Jekyll/Pages; add <a name> or reword heading)"
        else
            echo "MISSING  $f -> $rf#$frag  (no such anchor or stable heading)"
        fi
    done < <(grep -o '](\([^)]*#[^)]*\))' "$f" 2>/dev/null)
done

if [[ $problems -eq 0 ]]; then
    echo "anchors OK — $total fragment links checked; valid on github.com AND Jekyll/Pages"
    exit 0
fi
echo "$problems anchor problem(s) found"
exit 1
