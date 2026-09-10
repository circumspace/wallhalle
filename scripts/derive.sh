#!/bin/sh
# Builds everything Hugo cannot: thumbnails, previews, fitted wallpaper cuts,
# per-painting size data and donation QR codes. Runs before hugo in dev.sh
# and build.sh, and inside the cluster job with DERIVE_CUTS_ONLY set, which
# skips thumbnails, previews and QR codes because those are committed.
# Requires vips, yq (Go version) and qrencode; see README.
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

  # Outputs are rebuilt when the original changes or when the cut-relevant
  # front matter changes. The latter is tracked as a signature file, not as
  # the content page's mtime: pages inside the tools image get a fresh mtime
  # on every build, which would re-cut everything on every cluster run.
  sig=$(fm '{"original": .original, "focal": .focal, "trim": .trim, "crops": .crops, "slices": .slices}' "$md" | md5sum | cut -c1-32)
  stamp="$dl/.sig"
  if [ ! -e "$stamp" ]; then
    printf '%s\n' "$sig" > "$stamp"; touch -r "$orig" "$stamp"
  elif [ "$(cat "$stamp")" != "$sig" ]; then
    printf '%s\n' "$sig" > "$stamp"
  fi

  # `trim: [left, top, right, bottom]` in pixels shaves scan margins (book
  # edges, white borders) off the area cuts and previews are taken from.
  # The original file is never altered.
  tl=$(fm '.trim[0] // 0' "$md"); tt=$(fm '.trim[1] // 0' "$md")
  tr_=$(fm '.trim[2] // 0' "$md"); tb=$(fm '.trim[3] // 0' "$md")
  uw=$((w - tl - tr_)); uh=$((h - tt - tb))

  if [ -z "${DERIVE_CUTS_ONLY:-}" ]; then
    if stale "$web/thumb.webp" "$orig" "$stamp" || stale "$web/preview.webp" "$orig" "$stamp"; then
      tmp=$(mktemp -u).v
      vips extract_area "$orig" "$tmp" "$tl" "$tt" "$uw" "$uh"
      vips thumbnail "$tmp" "$web/thumb.webp[Q=82,strip]" 480
      vips thumbnail "$tmp" "$web/preview.webp[Q=84,strip]" 1600
      vips thumbnail "$tmp" "$web/preview.jpg[Q=86,strip]" 1600
      rm -f "$tmp"
    fi
  fi
  ext=${orig##*.}
  if stale "$dl/$slug-original.$ext" "$orig"; then
    ln -f "$orig" "$dl/$slug-original.$ext" 2>/dev/null || cp "$orig" "$dl/$slug-original.$ext"
  fi

  # A painting is cut once around its focal point, or once per entry of
  # `slices` for tall paintings that only work as several wide cuts. Each
  # slice names its files and gets its own 16:9 preview for the page.
  nslices=$(fm '.slices | length' "$md")
  variants=""
  seen=""
  i=0
  while [ "$i" -lt "${nslices:-0}" ] || [ "$i" -eq 0 ]; do
    if [ "${nslices:-0}" -gt 0 ]; then
      base=".slices[$i]"; slice=$(fm "$base.name" "$md"); prefix="$slice-"
    else
      base=""; slice=""; prefix=""
    fi
    fx=$(fm "$base.focal[0] // 0.5" "$md"); fy=$(fm "$base.focal[1] // 0.5" "$md")
    preview_done=""
    for spec in $VARIANTS; do
      aspect=${spec%%,*}; rest=${spec#*,}; tw=${rest%%,*}; rest=${rest#*,}; th=${rest%,*}; class=${rest#*,}
      key=$(echo "$aspect" | tr ':' 'x')
      box=$(fm "$base.crops.\"$key\" // [] | join(\" \")" "$md")
      if [ -z "$box" ]; then
        box=$(awk -v W="$uw" -v H="$uh" -v ox="$tl" -v oy="$tt" -v a="$tw/$th" -v fx="$fx" -v fy="$fy" 'BEGIN {
          split(a, r, "/"); ar = r[1] / r[2];
          if (W / H > ar) { bh = H; bw = int(H * ar) } else { bw = W; bh = int(W / ar) }
          x = int(fx * W - bw / 2 + 0.5); y = int(fy * H - bh / 2 + 0.5);
          if (x < 0) x = 0; if (y < 0) y = 0;
          if (x + bw > W) x = W - bw; if (y + bh > H) y = H - bh;
          print x + ox, y + oy, bw, bh }')
      fi
      set -- $box; bx=$1; by=$2; bw=$3; bh=$4
      if [ -n "$slice" ] && [ "$aspect" = "16:9" ] && [ -z "$preview_done" ] && [ -z "${DERIVE_CUTS_ONLY:-}" ]; then
        preview_done=1
        if stale "$web/${prefix}preview.webp" "$orig" "$stamp" || stale "$web/${prefix}thumb.webp" "$orig" "$stamp"; then
          tmp=$(mktemp -u).v
          vips extract_area "$orig" "$tmp" "$bx" "$by" "$bw" "$bh"
          vips thumbnail "$tmp" "$web/${prefix}preview.webp[Q=84,strip]" 1600
          vips thumbnail "$tmp" "$web/${prefix}preview.jpg[Q=86,strip]" 1600
          vips thumbnail "$tmp" "$web/${prefix}thumb.webp[Q=82,strip]" 480
          rm -f "$tmp"
        fi
      fi
      if awk -v bw="$bw" -v tw="$tw" -v tol="$UPSCALE_TOLERANCE" 'BEGIN { exit !(bw >= tw * (1 - tol)) }'; then
        ow=$tw; oh=$th; full=true
      else
        ow=$bw; oh=$bh; full=false
      fi
      upscale=$(awk -v a="$ow" -v b="$bw" 'BEGIN { s = a / b; if (s < 1) s = 1; printf "%.4f", s }')
      name="$slug-$prefix${ow}x${oh}.jpg"
      case " $seen " in *" $name "*) continue ;; esac
      seen="$seen $name"
      out="$dl/$name"
      if stale "$out" "$orig" "$stamp"; then
        echo "derive: $slug $slice $aspect -> $name (box $bx,$by ${bw}x${bh})"
        tmp=$(mktemp -u).v
        if ! cut_ok=$(
          vips extract_area "$orig" "$tmp" "$bx" "$by" "$bw" "$bh" &&
          if [ "$ow" -eq "$bw" ] && [ "$oh" -eq "$bh" ]; then
            vips copy "$tmp" "$out[Q=92,strip]"
          else
            vips resize "$tmp" "$out[Q=92,strip]" "$(awk -v a="$ow" -v b="$bw" 'BEGIN{print a/b}')" --vscale "$(awk -v a="$oh" -v b="$bh" 'BEGIN{print a/b}')"
          fi && echo ok
        ); then
          echo "derive: $slug $name: vips failed, cut skipped" >&2
          rm -f "$tmp" "$out"; fail=1; continue
        fi
        rm -f "$tmp"
      fi
      variants="$variants{\"slice\":\"$slice\",\"aspect\":\"$aspect\",\"class\":\"$class\",\"full\":$full,\"upscale\":$upscale,\"file\":\"$name\",\"width\":$(dim "$out" width),\"height\":$(dim "$out" height),\"bytes\":$(bytes "$out")},"
    done
    i=$((i + 1))
    [ "${nslices:-0}" -gt 0 ] || break
  done

  for f in "$dl"/*.jpg; do
    n=$(basename "$f")
    case " $slug-original.$ext$seen " in *" $n "*) ;; *) rm -f "$f" ;; esac
  done
  slice_names=" $(fm '.slices[].name' "$md" 2>/dev/null | tr '\n' ' ')"
  for f in "$web"/*-preview.* "$web"/*-thumb.webp; do
    [ -e "$f" ] || continue
    n=$(basename "$f"); n=${n%-preview.*}; n=${n%-thumb.webp}
    case "$slice_names" in *" $n "*) ;; *) rm -f "$f" ;; esac
  done

  mkdir -p data/derived
  printf '{"original":{"file":"%s-original.%s","width":%s,"height":%s,"bytes":%s},"variants":[%s]}\n' \
    "$slug" "$ext" "$w" "$h" "$(bytes "$orig")" "${variants%,}" > "data/derived/$slug.json"
done

for d in static/dl/* static/w/*; do
  [ -d "$d" ] || continue
  [ -e "content/paintings/$(basename "$d").md" ] || rm -rf "$d"
done
for j in data/derived/*.json; do
  [ -e "$j" ] || continue
  [ -e "content/paintings/$(basename "$j" .json).md" ] || rm -f "$j"
done

[ -z "${DERIVE_CUTS_ONLY:-}" ] || { [ "$fail" -eq 0 ] || { echo "derive: failed" >&2; exit 1; }; exit 0; }

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
