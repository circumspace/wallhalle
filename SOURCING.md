# Sourcing high-resolution scans

Working list of where to find paintings that fill 5K and 6K screens, and which painters have such scans available under a license the build accepts (PD, CC0, CC BY 4.0). Pixel sizes below were read from the Wikimedia Commons API on 2026-09-09; museum sites often hold larger files than the Commons copy.

## Minimum sizes

With the 1% upscale tolerance in `scripts/derive.sh`, a 16:9 cut needs a crop box of at least:

| Tier | Width | Height |
|---|---|---|
| 6K (6144x3456) | 6084 | 3422 |
| 5K (5120x2880) | 5069 | 2851 |
| 4K (3840x2160) | 3802 | 2139 |

Width is the usual limit for landscape paintings. Height bites on wide panoramas (Khnopff's Caresses at 8859x2883 makes 5K only just).

## Search method

Commons search understands file dimensions. This query returns files at least 5000 px wide and 2800 px high for a term:

```
https://commons.wikimedia.org/w/index.php?search=Bierstadt+filew%3A%3E5000+fileh%3A%3E2800&ns6=1
```

Swap `5000` for `6084` to see 6K candidates only. The same filter works in the API with `generator=search` and `prop=imageinfo&iiprop=size`, which is how the numbers below were collected.

Prefer files uploaded by or from the holding museum: names carrying "Google Art Project", an inventory number (`NG.M.`, `KMS`, `SK-A-`, `B2015.`, `1965.233`) or the museum name. Files named like `DSC2249.jpg`, `anagoria`, `WUS0xxxx` or `..., 02.jpg` are visitor photographs of framed paintings: glare, perspective, frame edges, and the photographer usually licenses them CC BY-SA, which the build rejects.

## Institutions

| Source | License | Resolution | Notes |
|---|---|---|---|
| Google Art Project uploads on Commons | PD (faithful reproduction) | 5k to 30k | Largest single pool. Search `"Google Art Project" <painter>`. |
| Cleveland Museum of Art | CC0 | `images.full` in the API, 7k to 15k | Commons copies are downsized to 5000 px. Use `https://openaccess-api.clevelandart.org/api/artworks/?q=<title>` and take `images.full.url`. |
| Nasjonalmuseet Oslo | PD works free | Commons uploads 8k to 12k | The museum's own API caps at 4000 px, but their Commons batch (`NG.M.xxxxx` files) is full size. |
| Statens Museum for Kunst | CC0 | 6k to 13k | `KMS` files on Commons; also open.smk.dk. |
| Yale Center for British Art | PD, open access | TIFF full size | Martin, Turner, Danby, Grimshaw, Cole. Download link under each object. |
| National Gallery of Art Washington | CC0 | 3k to 6k | Cole's Voyage of Life, Turner, Church. Sizes vary per object. |
| Getty Open Content | PD | 6k to 10k | Turner (Conway Castle 9510 wide), Friedrich's A Walk at Dusk. |
| Rijksmuseum | PD / CC0 | up to 10k+ | Dutch romantics (Koekkoek, Schelfhout, Nuijen); also holds Khnopff portraits. |
| Finnish National Gallery | CC0 | website larger than Commons | Gallen-Kallela, Halonen, Järnefelt. Commons copies are around 5000 px; download from kansallisgalleria.fi. |
| Belvedere Vienna | CC0 | unverified | Download button per object; check pixel size before relying on it. |
| Smithsonian American Art Museum | CC0 | 5k to 8k | Moran Chasm of the Colorado 8069x2989. The Aurora Borealis file on Commons is a visitor photo of the framed painting, and the museum itself serves only 3000x1996. |
| Indianapolis, Dallas, Minneapolis, Albright-Knox | CC0 uploads on Commons | 5k to 10k | Bierstadt, Moran, Grimshaw. |
| Wellcome Collection | CC BY 4.0 | 3k to 6k | Mezzotints after Martin; the CC BY attribution line is already rendered. |

Not usable under the current allowlist:

- Hamburger Kunsthalle and Staatliche Museen zu Berlin: CC BY-NC-SA. This blocks Friedrich's Wanderer, Eismeer, Mönch am Meer from the source. Other Friedrichs exist elsewhere, see below.
- Tate: CC BY-NC-ND on their images. Commons hosts some Turners as PD-Art; UK museums dispute that position. Your call, flagged per file below.
- Städel Museum: CC BY-SA 4.0. Lessing's `SM` files come from there. Allowing SA would mean the cuts carry BY-SA too.
- Louvre / RMN, Tretyakov, Russian Museum: no open license on their own sites. Bryullov and Aivazovsky are covered by Google Art Project copies instead.

## Leads by theme, files at or above 5K

Sizes are the Commons file, width x height. "6K" marks files that clear 6084x3422.

### Apocalypse and the sublime (Martin's circle)

- Thomas Cole: The Course of Empire, all five, 7784 to 8917 wide (6K). Expulsion from the Garden of Eden 6001x4337 (GAP). The Architect's Dream 7615x4679 (GAP, 6K). Voyage of Life Old Age 5100x3431 (NGA, 5K with tolerance).
- Frederic Edwin Church: Cotopaxi 8322x5357 (GAP, 6K). Rainy Season in the Tropics 9777x6482 (GAP, 6K). Niagara 27911x12955 (6K). Heart of the Andes 6400x3503 (6K). Twilight in the Wilderness 7673x4791 via the Cleveland API (6K). The Meteor of 1860 6000x3408. Home by the Lake 7079x4684. Lower Falls Rochester 6780x4495.
- Karl Bryullov: The Last Day of Pompeii 30000x21059 (GAP, 6K).
- Ivan Aivazovsky: The Ninth Wave 5815x3840. Wellengang auf hoher See 8083x5132 (6K). Reval 6000x4349. Storm 1887 5024x3520 (short of 5K). Check each file's source; several are Russian Museum GAP uploads.
- J. M. W. Turner: Dort or Dordrecht 8377x5603 (Yale, GAP, 6K). The Burning of the Houses of Lords and Commons 15155x11254 (Cleveland, 6K). Conway Castle 9510x6672 and Longships Lighthouse 6444x4188 (Getty, 6K). Snow Storm, Steam-Boat off a Harbour's Mouth 7247x5448 and The Fighting Temeraire 6000x4455 are Tate and National Gallery London works, licence position disputed.
- Francis Danby: Shipwreck 5081x3921 (GAP, 5K with tolerance). Funeral Procession 6409x4006 (6K). The Painter's Holiday 6475x4531 (6K). Hampstead Heath Sunset 5803x4315. His Deluge is at Tate.
- Gustave Doré: Scottish Highlands 7729x4583 (GAP, 6K). L'aube, souvenir des Alpes 6979x4739 (6K). Vallée des larmes 6924x4859 (6K). Torrent in the Highlands 5686x3184 (Indianapolis). Brand van Rome (MSK Gent) was tried and dropped: the scan carries a colour chart and a white margin, and the picture is too dark and small to read as a wallpaper.

### Northern romanticism, night and ice

- Caspar David Friedrich, outside the NC-SA museums: Northern Sea in the Moonlight 6699x4700 (GAP, National Gallery Prague, 6K). A Walk at Dusk 7166x5533 (Getty, 6K). Der einsame Baum 8688x6773 (check the uploader, the painting is in Berlin). Summer 7064x4816 (Neue Pinakothek, 6K). Mann und Frau in Betrachtung des Mondes 5987x4678. Neumond über dem Riesengebirge 5155x3708.
- Peder Balke: Coastal Landscape 10223x6680 (Nasjonalmuseet, 6K). From North Cape 8350x6762 (6K). A Waterfall 6229x4539 (GAP, 6K). Stormy Sea 5506x4223. Nordlys over fire menn i robåt 5533x4620. Stetind in Fog is portrait format.
- Johan Christian Dahl: View from Stalheim 12169x9411 (6K). Shipwreck on the Coast of Norway 8115x5133 (GAP, 6K). View of Dresden by Moonlight 7162x3786 (6K). The Elbe on a foggy Morning 8402x5032 (6K). The Watzmann 8092x6053 (6K). Eruption of Vesuvius 6720x4480 is a visitor photo.
- Knud Baade: Winter 12716x9093 (Nasjonalmuseet, 6K). His moonlit coasts are the closest Norwegian match to Kircher.
- Theodor Kittelsen: Soria Moria Palace 10232x6752 (Nasjonalmuseet, 6K). Far, far away Soria Moria Palace shimmered like Gold 7546x4955 (GAP, 6K). The Ash Lad and the Troll 6081x4010. Many are illustrations on paper.
- Vilhelm Hammershøi: Landskab i månelys 5932x4656. Unge ege 8206x5837 (SMK, 6K). Artemis 13201x10077 (6K). Mostly interiors and portraits otherwise.
- John Atkinson Grimshaw (moonlit streets and docks): A House in a Clearing 10275x6598 (Minneapolis, 6K). The Lady of Shalott 6224x4137 (GAP, 6K). Whitby Harbor 5608x3449 (Yale). Boar Lane, Leeds 5552x3635. Liverpool Docks at Night 5281x3474 (York, check uploader).

- Mårten Eskil Winge: Thor's Fight with the Giants 3861x5713 (a 2003 Edda print scan on Commons; the Nationalmuseum file is 3062x4429). Portrait format, offered as two 4K slices.

### Symbolism, Kircher's kin

- Arnold Böcklin: The Isle of the Dead 1883 8256x5504 (Berlin version, check uploader, 6K). Die Toteninsel I 6784x4837 (Kunstmuseum Basel, 6K). Sacred Grove 6884x4800 (Basel, 6K). Spring Evening 6030x3091 (GAP). Odysseus und Polyphemus 7200x3151 (6K wide, height limits it to 5K). Battle of the Centaurs 6746x3596 (Basel, 6K). Play of the Nereides 6106x5213 (6K). The Met's 1880 version is CC0 but the Met serves around 4000 px.
- Franz von Stuck: Der Engel des Gerichts 7158x6485 (6K). Susanna im Bade 5972x4463. Luzifer is 4700 wide, 4K only.
- Fernand Khnopff: Caresses 8859x2883 (GAP, 5K only because of the height). Hypnos 5240x3493 (Petit Palais photo, check licence). Medusa 5056x3371 misses 5K by 13 px beyond the tolerance.
- Léon Spilliaert (died 1946, public domain since 2017): Strand met maan 9375x7227 (6K). De vuurtoren 10702x7706 (6K). Marine 7153x5280 (6K). Duinen 7553x5341 (6K). Marine met kielzog 7341x5625 (6K). MSK Gent uploads, ink and gouache on paper.
- Giovanni Segantini: Le due madri 6936x3725 (6K). Ploughing 8161x5089 (6K). Ritorno a casa 5598x2972.
- Isaac Levitan: Golden Autumn, Slobodka 7158x4465 (GAP, 6K).
- Carl Friedrich Lessing: Knight's Castle 7152x5055 (Alte Nationalgalerie photo, check uploader). Oak forest 9210x6822 and Waldlandschaft mit Wartturm 9189x6972 are Städel files, CC BY-SA.

### American West, for scale

- Albert Bierstadt: Sunrise, Yosemite Valley 12732x8815 (6K). View in the Yosemite Valley 10173x6596 (6K). Lake Lucerne 7104x4233 (GAP, NGA, 6K). Valley of the Yosemite 6301x3898 (GAP, 6K). A Storm in the Rocky Mountains, Mt. Rosalie 5736x3319. Alcatraz 6000x3991.
- Thomas Moran: An Indian Paradise 9828x7433 (Dallas, 6K). Valley of the Catawissa in Autumn 7566x4705 (6K). Grand Canyon of the Colorado River 5665x3192 (GAP). The Chasm of the Colorado 8069x2989 is too short for 5K.

## Dead ends at 5K

- Alexander Kircher and Hermann Hendrich: nothing above 3300 px on Commons. Kircher's known works are in private hands and Austrian regional museums; the Belvedere collection search is the one lead.
- Arkhip Kuindzhi: no museum-grade file above 5000 px on Commons; Tretyakov and Russian Museum do not publish open files.
- Akseli Gallen-Kallela: Commons copies stop at about 5000 px (Aino triptych 8066x4042 is the exception). Use the Finnish National Gallery site directly.
- Caspar David Friedrich's Hamburg and Berlin works: source images are CC BY-NC-SA, and the Commons copies are visitor photographs.
