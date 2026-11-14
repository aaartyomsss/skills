#!/usr/bin/env bash
# Render diagrams in headless Chrome: fail on Mermaid errors, write a screenshot to look at.
# Accepts .html, or .md/.mmd (```mermaid blocks / raw Mermaid are wrapped in the template first).
# Needs a local Chrome/Chromium and network access (Mermaid loads from a CDN).
# usage: bash check.sh <file> [out.png|out.svg] [width]   (.svg exports the diagrams instead of a screenshot)
set -euo pipefail
[[ $# -ge 1 ]] || { sed -n '2,5p' "$0" >&2; exit 2; }
src=$(realpath "$1"); png=${2:-${TMPDIR:-/tmp}/$(basename "${src%.*}").png}; width=${3:-1400}
chrome=$(command -v google-chrome || command -v chromium || command -v chromium-browser) || { echo "no chrome/chromium found" >&2; exit 2; }

html=$src
if [[ $src != *.html ]]; then
  html=$(mktemp --suffix=.html)
  trap 'rm -f "$html"' EXIT
  if [[ $src == *.md ]]; then
    blocks=$(awk '/^```mermaid/{on=1; print "<figure><pre class=\"mermaid\">"; next} on&&/^```/{on=0; print "</pre></figure>"; next} on{gsub(/&/,"\\&amp;"); gsub(/</,"\\&lt;"); gsub(/>/,"\\&gt;"); print}' "$src")
  else
    blocks="<figure><pre class=\"mermaid\">$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' "$src")</pre></figure>"
  fi
  [[ -n $blocks ]] || { echo "FAIL: no mermaid blocks in $src" >&2; exit 1; }
  head -n "$(grep -n '<main>' "$(dirname "$0")/../template.html" | cut -d: -f1)" "$(dirname "$0")/../template.html" > "$html"
  printf '%s\n</main></body></html>\n' "$blocks" >> "$html"
fi

dom=$("$chrome" --headless=new --disable-gpu --virtual-time-budget=8000 --dump-dom "file://$html" 2>/dev/null)
if grep -qiE 'syntax error|parse error' <<<"$dom"; then echo "FAIL: mermaid syntax error" >&2; exit 1; fi
err=$(grep -o 'data-error="[^"]*"' <<<"$dom" || true)
[[ -z $err ]] || { echo "FAIL: mermaid ${err}" >&2; exit 1; }
if grep -q 'class="mermaid"' <<<"$dom" && ! grep -q 'data-rendered="true"' <<<"$dom"; then
  echo "FAIL: mermaid did not finish rendering (offline? bad import?)" >&2; exit 1
fi
# Mermaid renders some mistakes (e.g. a reserved word as node id) as an empty diagram without an error.
empty=$(grep -oE '<svg[^>]*id="mermaid-[^>]*' <<<"$dom" | grep -oE 'viewBox="[^"]*"' | awk -F'[" ]' '$4 < 40' | wc -l)
(( empty == 0 )) || { echo "FAIL: $empty diagram(s) rendered empty (reserved word as node id?)" >&2; exit 1; }
if [[ $png == *.svg ]]; then  # export rendered diagrams as standalone SVGs (out.svg, or out-1.svg, out-2.svg, ...)
  python3 -c '
import re, sys
dom, out = sys.stdin.read(), sys.argv[1]
svgs = []
for m in re.finditer(r"<svg[^>]*id=\"mermaid-", dom):
    depth, i = 0, m.start()
    for t in re.finditer(r"<svg\b|</svg>", dom[i:]):
        depth += 1 if t.group() != "</svg>" else -1
        if depth == 0: svgs.append(dom[i:i + t.end()]); break
for n, s in enumerate(svgs, 1):
    path = out if len(svgs) == 1 else out[:-4] + f"-{n}.svg"
    open(path, "w").write(s); print("OK:", path)
' "$png" <<<"$dom"
  exit
fi
"$chrome" --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=8000 --window-size="$width,2400" --screenshot="$png" "file://$html" 2>/dev/null
echo "OK: $png"
