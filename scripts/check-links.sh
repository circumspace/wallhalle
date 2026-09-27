#!/bin/sh
# Verifies that every /dl/, /w/ and /qr/ reference in the built site
# resolves. Local mode needs public/ from hugo. Thumbnails, previews and
# cuts are not in git, so /w/ and /dl/ links are checked against the
# derived size data (a painting with a JSON has its thumbnail and preview,
# a slice listed in it has its own) and /qr/ links against static/. Live
# mode HEADs every reference on a deployed site:
#   scripts/check-links.sh
#   scripts/check-links.sh --live https://wallhalle.circum.space
set -eu
cd "$(dirname "$0")/.."
mode=${1:-local}
base=${2:-}
[ -d public ] || { echo "check-links: public/ missing, run hugo first" >&2; exit 2; }

refs=$(grep -rhoE '(href|src|srcset)=("[^"]*"|[^ >]+)' public \
  | sed -E 's/^[a-z]+=//; s/^"//; s/"$//' | tr ' ,' '\n\n' \
  | grep -E '^(https?://[^/]+)?/(dl|w|qr)/' | sed -E 's#^https?://[^/]+##' | sort -u)

fail=0
for r in $refs; do
  case "$mode" in
    local)
      slug=$(printf '%s' "$r" | cut -d/ -f3); file=$(printf '%s' "$r" | cut -d/ -f4)
      json="data/derived/$slug.json"
      case "$r" in
        /dl/*) grep -q "\"file\":\"$file\"" "$json" 2>/dev/null ;;
        /w/*)
          case "$file" in
            thumb.webp|preview.webp|preview.jpg) [ -e "$json" ] ;;
            *-thumb.webp|*-preview.webp|*-preview.jpg)
              slice=${file%-thumb.webp}; slice=${slice%-preview.*}
              grep -q "\"slice\":\"$slice\"" "$json" 2>/dev/null ;;
            *) false ;;
          esac ;;
        *) [ -e "static$r" ] ;;
      esac || { echo "dead: $r"; fail=1; } ;;
    --live)
      code=$(curl -s -o /dev/null -I -w '%{http_code}' "$base$r")
      [ "$code" = "200" ] || { echo "dead ($code): $r"; fail=1; } ;;
    *) echo "check-links: unknown mode $mode" >&2; exit 2 ;;
  esac
done
echo "check-links: $(printf '%s\n' "$refs" | wc -l | tr -d ' ') references checked, $( [ "$fail" -eq 0 ] && echo all resolve || echo dead links found)"
exit $fail
