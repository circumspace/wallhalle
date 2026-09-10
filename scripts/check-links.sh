#!/bin/sh
# Verifies that every /dl/, /w/ and /qr/ reference in the built site
# resolves. Local mode needs public/ from hugo and checks /dl/ links
# against the derived size data (the cuts themselves are not in git) and
# /w/ and /qr/ links against static/. Live mode HEADs every reference on
# a deployed site:
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
      case "$r" in
        /dl/*)
          slug=$(printf '%s' "$r" | cut -d/ -f3); file=$(printf '%s' "$r" | cut -d/ -f4)
          grep -q "\"file\":\"$file\"" "data/derived/$slug.json" 2>/dev/null || { echo "dead: $r"; fail=1; } ;;
        *) [ -e "static$r" ] || { echo "dead: $r"; fail=1; } ;;
      esac ;;
    --live)
      code=$(curl -s -o /dev/null -I -w '%{http_code}' "$base$r")
      [ "$code" = "200" ] || { echo "dead ($code): $r"; fail=1; } ;;
    *) echo "check-links: unknown mode $mode" >&2; exit 2 ;;
  esac
done
echo "check-links: $(printf '%s\n' "$refs" | wc -l | tr -d ' ') references checked, $( [ "$fail" -eq 0 ] && echo all resolve || echo dead links found)"
exit $fail
