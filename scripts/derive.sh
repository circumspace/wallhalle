#!/bin/sh
# Builds everything Hugo cannot: thumbnails, previews, fitted wallpaper cuts,
# per-painting size data and donation QR codes. Runs before hugo in dev.sh
# and build.sh. Requires vips, yq (Go version) and qrencode; see README.
set -eu

cd "$(dirname "$0")/.."

ALLOWED_LICENSES="PD CC0 CC-BY-4.0"
# aspect,width,height,class. Classes name the display tier a full-size cut
# fits exactly; a cut that comes out smaller than its target keeps the class
# but is flagged full=false and does not count for the gallery filter.
# A crop box short of its target by at most this fraction is upscaled to the
# target and counts as full. 1% is invisible on a wallpaper and lets scans
# that miss a tier by a few pixels still fill the screen.
UPSCALE_TOLERANCE=0.01
VARIANTS="16:9,6144,3456,6k 16:9,6016,3384,6k 16:9,5120,2880,5k 16:9,3840,2160,4k 16:10,5120,3200,5k"

fm() { yq --front-matter=extract -r "$1" "$2"; }

stale() {
  out=$1; shift
  [ -e "$out" ] || return 0
  for dep in "$@"; do
    [ "$dep" -nt "$out" ] && return 0
  done
  return 1
}

dim() { vipsheader -f "$2" "$1"; }
bytes() { stat -c %s "$1"; }

fail=0
for md in content/paintings/*.md; do
  slug=$(basename "$md" .md)
  license=$(fm .license "$md")
  case " $ALLOWED_LICENSES " in
    *" $license "*) ;;
    *) echo "derive: $md: license '$license' is not allowed (allowed: $ALLOWED_LICENSES)" >&2; fail=1; continue ;;
  esac

  orig="originals/$(fm .original "$md")"
  if [ ! -s "$orig" ] || head -c 7 "$orig" | grep -q '^version'; then
    echo "derive: $md: $orig missing or an unfetched LFS pointer" >&2; fail=1; continue
  fi

  w=$(dim "$orig" width); h=$(dim "$orig" height)
  web="static/w/$slug"; dl="static/dl/$slug"
  mkdir -p "$web" "$dl"

  stale "$web/thumb.webp" "$orig" && vips thumbnail "$orig" "$web/thumb.webp[Q=82,strip]" 480
  stale "$web/preview.webp" "$orig" && vips thumbnail "$orig" "$web/preview.webp[Q=84,strip]" 1600
  stale "$web/preview.jpg" "$orig" && vips thumbnail "$orig" "$web/preview.jpg[Q=86,strip]" 1600
  stale "$dl/original.jpg" "$orig" && cp "$orig" "$dl/original.jpg"

  fx=$(fm '.focal[0] // 0.5' "$md"); fy=$(fm '.focal[1] // 0.5' "$md")
  variants=""
  seen=""
  for spec in $VARIANTS; do
    aspect=${spec%%,*}; rest=${spec#*,}; tw=${rest%%,*}; rest=${rest#*,}; th=${rest%,*}; class=${rest#*,}
    key=$(echo "$aspect" | tr ':' 'x')
    box=$(fm ".crops.\"$key\" // [] | join(\" \")" "$md")
    if [ -z "$box" ]; then
      box=$(awk -v W="$w" -v H="$h" -v a="$tw/$th" -v fx="$fx" -v fy="$fy" 'BEGIN {
        split(a, r, "/"); ar = r[1] / r[2];
        if (W / H > ar) { bh = H; bw = int(H * ar) } else { bw = W; bh = int(W / ar) }
        x = int(fx * W - bw / 2 + 0.5); y = int(fy * H - bh / 2 + 0.5);
        if (x < 0) x = 0; if (y < 0) y = 0;
        if (x + bw > W) x = W - bw; if (y + bh > H) y = H - bh;
        print x, y, bw, bh }')
    fi
    set -- $box; bx=$1; by=$2; bw=$3; bh=$4
    if awk -v bw="$bw" -v tw="$tw" -v tol="$UPSCALE_TOLERANCE" 'BEGIN { exit !(bw >= tw * (1 - tol)) }'; then
      ow=$tw; oh=$th; full=true
    else
      ow=$bw; oh=$bh; full=false
    fi
    upscale=$(awk -v a="$ow" -v b="$bw" 'BEGIN { s = a / b; if (s < 1) s = 1; printf "%.4f", s }')
    name="${ow}x${oh}.jpg"
    case " $seen " in *" $name "*) continue ;; esac
    seen="$seen $name"
    out="$dl/$name"
    if stale "$out" "$orig" "$md"; then
      echo "derive: $slug $aspect -> $name (box $bx,$by ${bw}x${bh})"
      tmp=$(mktemp -u).v
      vips extract_area "$orig" "$tmp" "$bx" "$by" "$bw" "$bh"
      if [ "$ow" -eq "$bw" ] && [ "$oh" -eq "$bh" ]; then
        vips copy "$tmp" "$out[Q=92,strip]"
      else
        vips resize "$tmp" "$out[Q=92,strip]" "$(awk -v a="$ow" -v b="$bw" 'BEGIN{print a/b}')" --vscale "$(awk -v a="$oh" -v b="$bh" 'BEGIN{print a/b}')"
      fi
      rm -f "$tmp"
    fi
    variants="$variants{\"aspect\":\"$aspect\",\"class\":\"$class\",\"full\":$full,\"upscale\":$upscale,\"file\":\"$name\",\"width\":$(dim "$out" width),\"height\":$(dim "$out" height),\"bytes\":$(bytes "$out")},"
  done

  for f in "$dl"/*.jpg; do
    n=$(basename "$f")
    case " original.jpg$seen " in *" $n "*) ;; *) rm -f "$f" ;; esac
  done

  mkdir -p data/derived
  printf '{"original":{"file":"original.jpg","width":%s,"height":%s,"bytes":%s},"variants":[%s]}\n' \
    "$w" "$h" "$(bytes "$orig")" "${variants%,}" > "data/derived/$slug.json"
done

cfg=config/_default/hugo.toml
mkdir -p static/qr
qr() {
  name=$1; prefix=$2
  value=$(yq -p toml -oy -r ".params.donate.$name // \"\"" "$cfg")
  out="static/qr/$name.svg"
  if [ -z "$value" ]; then rm -f "$out"; return 0; fi
  if stale "$out" "$cfg"; then
    qrencode -t SVG -l M -m 1 -o "$out" "$prefix$value"
  fi
}
qr bitcoin "bitcoin:"
qr bitcoin_sp "bitcoin:"
qr lightning "lightning:"
qr monero "monero:"

[ "$fail" -eq 0 ] || { echo "derive: failed" >&2; exit 1; }
