#!/usr/bin/env bash
# Convert a white paper from Markdown to LaTeX in the Overby style.
#
#     tools/md2tex.sh drafts/<title>/<name>.md            writes <name>.tex beside it
#     tools/md2tex.sh drafts/<title>/<name>.md out.tex
#
# The Markdown is the source people read on GitHub and edit; the .tex is what
# CI compiles (see .github/workflows/latex-build.yml), so regenerate it after
# every edit to the Markdown and commit both. Needs pandoc.
#
# The Markdown follows the shape of the existing papers:
#
#     # <Title>
#     ### <Version line>
#     **Author:** <name>
#     ---
#     ## Abstract
#     ...
#     ## 1. First section
#
# Headings carry their own numbers, so LaTeX does not add another set. Keep to
# ASCII and em dashes in the text: characters such as arrows and mathematical
# symbols are not available to pdflatex without extra packages and would fail
# the CI build.
set -euo pipefail

# Titles contain em dashes. Without a UTF-8 locale (a bare CI container, say)
# the shell hands pandoc mangled bytes on its command line, so insist on one.
export LC_ALL=C.UTF-8

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "usage: $0 PAPER.md [OUT.tex]" >&2
    exit 2
fi
if ! command -v pandoc >/dev/null 2>&1; then
    echo "pandoc is required: https://pandoc.org/installing.html" >&2
    exit 2
fi

md=$1
tex=${2:-${md%.md}.tex}
here=$(cd "$(dirname "$0")" && pwd)

title=$(sed -n 's/^# //p' "$md" | head -1)
version=$(sed -n 's/^### //p' "$md" | head -1)
author=$(sed -n 's/^\*\*Author:\*\* *//p' "$md" | head -1)
if [ -z "$title" ] || [ -z "$version" ] || [ -z "$author" ]; then
    echo "$md needs a '# title' line, a '### version' line and an '**Author:**' line" >&2
    exit 1
fi

body=$(mktemp)
meta=$(mktemp)
trap 'rm -f "$body" "$meta"' EXIT
# Everything from the first level-two heading on: the abstract and the sections.
awk '/^## /{found=1} found' "$md" > "$body"

# Metadata goes in a file, read as UTF-8 and quoted, rather than on the command
# line: a title may contain quotes or a colon.
yaml() { printf "'%s'" "${1//\'/\'\'}"; }
{
    printf 'title: %s\n' "$(yaml "$title")"
    printf 'subtitle: %s\n' "$(yaml "$version")"
    printf 'author: %s\n' "$(yaml "$author")"
    printf 'date: %s\n' "$(yaml '\today')"
} > "$meta"

pandoc "$body" --from markdown --standalone --toc --toc-depth=2 \
    --metadata-file="$meta" \
    --include-in-header="$here/overby-preamble.tex" \
    -V documentclass=article -V fontsize=12pt -V geometry:margin=1in \
    -V colorlinks=true -V linkcolor=blue -V urlcolor=blue -V citecolor=blue \
    -V papersize=letter \
    -o "$tex"

# Note where it came from, as the existing converted papers do.
{ printf '%% Overby Industries White Paper\n%% Source: converted from %s by tools/md2tex.sh. Edit the Markdown, then regenerate.\n' "$(basename "$md")"; cat "$tex"; } > "$tex.tmp"
mv "$tex.tmp" "$tex"
echo "wrote $tex"
