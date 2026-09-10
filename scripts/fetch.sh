#!/bin/sh
# Downloads missing originals. For every painting whose original is absent,
# the `download` front matter field is fetched if set, otherwise `source` must
# be a Wikimedia Commons file page and the file behind it is fetched through
# the Commons API. Existing originals are never touched.
set -eu
cd "$(dirname "$0")/.."

UA="wallhalle-fetch/1 (static wallpaper gallery; contact via repo)"
fm() { yq --front-matter=extract -r "$1" "$2"; }

fail=0
for md in content/paintings/*.md; do
  orig="originals/$(fm .original "$md")"
  [ -s "$orig" ] && continue
  url=$(fm '.download // ""' "$md")
  if [ -z "$url" ]; then
    source=$(fm .source "$md")
    case "$source" in
      https://commons.wikimedia.org/wiki/File:*) ;;
      *) echo "fetch: $md: no download field and source is not a Commons file page" >&2; fail=1; continue ;;
    esac
    title=$(printf '%s' "${source#https://commons.wikimedia.org/wiki/File:}" | tr '_' ' ' | sed 's/%\([0-9A-Fa-f][0-9A-Fa-f]\)/\\x\1/g')
    title=$(printf '%b' "$title")
    url=$(curl -sG -A "$UA" --retry 4 --retry-delay 5 --retry-all-errors https://commons.wikimedia.org/w/api.php \
      --data-urlencode "titles=File:$title" -d action=query -d prop=imageinfo -d iiprop=url -d format=json \
      | yq -p json -oy -r '.query.pages[].imageinfo[0].url // ""')
    if [ -z "$url" ]; then echo "fetch: $md: Commons returned no file URL for '$title' (missing file or throttled)" >&2; fail=1; continue; fi
  fi
  echo "fetch: $orig <- $url"
  if ! curl -sfL -A "$UA" --retry 4 --retry-delay 10 --retry-all-errors -o "$orig.part" "$url"; then
    echo "fetch: $md: download failed after retries" >&2; rm -f "$orig.part"; fail=1; continue
  fi
  mv "$orig.part" "$orig"
  sleep 2
done
[ "$fail" -eq 0 ] || { echo "fetch: some downloads failed" >&2; exit 1; }
