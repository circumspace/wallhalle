# wallpaintr

A static gallery of museum scans of paintings, offered as wallpapers for 5k and 6k screens. Downloads are free. Visitors can donate in Bitcoin and Monero; a Lightning slot exists and stays hidden until an address is configured.

The name is preliminary. It appears in `config/_default/hugo.toml` (`title`) and nowhere else in this repo.

## Running locally

Everything runs in a container built from `Containerfile.dev` (Alpine with hugo, vips, qrencode, yq). Nothing needs installing on the host beyond podman or docker.

```sh
./dev.sh     # derive images, then hugo server on http://localhost:1313 with live reload
./build.sh   # derive images, then hugo --minify into public/
```

`hugo server` runs with `--poll` because file change notifications do not cross the podman volume mount on macOS; without it, edits to layouts are missed until a restart.

`scripts/derive.sh` does the image work Hugo cannot do well at 5k+ sizes. It is incremental: an output is rebuilt only when its source file or the painting's content file is newer. The first run over the 8 sample paintings takes about a minute; later runs are seconds.

## Adding a painting

1. Put the source file in `originals/` under a slug name, e.g. `originals/artist-title.jpg`. The directory is tracked by Git LFS; bytes are never modified.
2. Create `content/paintings/artist-title.md`:

   ```yaml
   ---
   title: The Deluge
   artist: John Martin
   year: 1834
   medium: oil on canvas
   institution: Yale Center for British Art
   source: https://commons.wikimedia.org/wiki/File:...
   license: PD
   original: artist-title.jpg
   focal: [0.5, 0.5]
   ---
   ```

3. Set `focal` by hand: x and y as fractions of width and height. Each fitted cut is the largest box of its aspect ratio placed around that point and clamped to the image. To override one aspect entirely, add an explicit box in source pixels:

   ```yaml
   crops:
     16x9: [0, 400, 7119, 4004]   # x y width height
   ```

4. Run `./dev.sh` and check the cuts on the painting page.

## What derive.sh produces

| Path | Content |
|---|---|
| `static/w/<slug>/thumb.webp` | 480px wide, gallery grid |
| `static/w/<slug>/preview.webp`, `preview.jpg` | 1600px wide, painting page |
| `static/dl/<slug>/original.jpg` | byte-identical copy of the source |
| `static/dl/<slug>/<w>x<h>.jpg` | fitted cuts, see the tier table below |
| `data/derived/<slug>.json` | real pixel sizes and byte counts, read by the download table |
| `static/qr/<name>.svg` | QR codes for the configured donation addresses |

Cut targets and the display tier each one fills exactly:

| Tier | Aspect | Size | Displays |
|---|---|---|---|
| 6K | 16:9 | 6144x3456 | Dell U3224KB |
| 6K | 16:9 | 6016x3384 | Apple Pro Display XDR |
| 5K | 16:9 | 5120x2880 | Apple Studio Display, iMac 27, LG UltraFine 5K |
| 5K | 16:10 | 5120x3200 | no shipping display; kept because it costs nothing and 16:10 laptops scale it cleanly |
| 4K | 16:9 | 3840x2160 | everything UHD |

Only 16:9 exists at 5K and above among conventional monitors. 3:2 and 4:3 panels top out far below 5K, and the 16:10 laptops (MacBook Pro 3456x2234, Dell XPS 3840x2400) sit under the 5K line. The two 5K-class shapes not covered are ultrawide 5120x2160 (21:9) and 5120x1440 (32:9); they crop most of a painting away and are not offered.

A crop box that misses its target by at most 1% (`UPSCALE_TOLERANCE` in `scripts/derive.sh`) is upscaled to the target, counts as full, and its page shows the factor. Beyond that nothing is upscaled: when the crop box is smaller than the target, the file is emitted at the box's native size, flagged `full: false` in the JSON, and named by its real dimensions; two targets that collapse to the same box produce one file. The gallery filter (All / 6K / 5K / 4K) counts only full-size cuts, so a painting is listed under 5K only if at least one 5K target came out at exactly that size.

All of these paths are generated and gitignored.

## Licenses

`license` must be one of `PD`, `CC0`, `CC-BY-4.0`. Any other value fails the build. NonCommercial licenses are excluded on purpose: the site accepts donations, and whether that counts as commercial use is not a question worth arguing with a rights holder. CC BY works need the attribution line, which every painting page renders from `artist`, `title`, `year`, `medium`, `institution`, `source` and `license`.

## Donations

Addresses live in `config/_default/hugo.toml` under `[params.donate]`. They are public data. An empty value hides that row and removes its QR code. `bitcoin_sp` is for a BIP-352 silent payment address; `lightning` takes a Lightning Address (`user@domain`).

## Open items

- The Kircher painting (`alexander-kircher-toteninsel`) has no recorded source or institution. The file arrived without provenance.
- Institution and source fields for the other samples were filled from the original filenames and should be checked against the museum pages.
- `content/impressum.md` is a placeholder.
- Growth watch point: 8 paintings produce about 120 MB of downloads. The container image that will eventually serve the site carries all of it.

## Not in this repo yet

Dockerfile and nginx config, CI publishing to GHCR, and the cluster manifests. The deployment pattern is the one used by the blog and website repos: static tree baked into `nginxinc/nginx-unprivileged`, tagged `<epoch>-<sha>`, picked up by Flux image automation.
