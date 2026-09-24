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

- Mårten Eskil Winge: Thor's Fight with the Giants 3861x5713 (a 2003 Edda print scan on Commons; the Nationalmuseum file is 3062x4429). Portrait format, offered as two 4K slices. Hjalmar Parting from Orvar Odd 4094x3479 (Nationalmuseum TIFF via Commons, 4K). His other Norse pieces are too small on Commons: Kraka 3490 wide, Loke and Sigyn 2752, the Hammar-häntningen trilogy about 2880; the museum's own image host refuses direct downloads.

### Symbolism, Kircher's kin

- Arnold Böcklin: the Commons file "The Isle of the Dead - 1883 8901" (8256x5504) is a visitor's close-up of the boat, not the painting; it was in the catalogue for a day and is out. Die Toteninsel I 6784x4837 (Kunstmuseum Basel, 6K). Sacred Grove 6884x4800 (Basel, 6K). Spring Evening 6030x3091 (GAP). Odysseus und Polyphemus 7200x3151 (6K wide, height limits it to 5K). Battle of the Centaurs 6746x3596 (Basel, 6K). Play of the Nereides 6106x5213 (6K). The Met's 1880 version is CC0 but the Met serves around 4000 px.
- Franz von Stuck: Der Engel des Gerichts 7158x6485 (6K). Susanna im Bade 5972x4463. Luzifer is 4700 wide, 4K only.
- Fernand Khnopff: Caresses 8859x2883 (GAP, 5K only because of the height). Hypnos 5240x3493 (Petit Palais photo, check licence). Medusa 5056x3371 misses 5K by 13 px beyond the tolerance.
- Léon Spilliaert (died 1946, public domain since 2017): Strand met maan 9375x7227 (6K). De vuurtoren 10702x7706 (6K). Marine 7153x5280 (6K). Duinen 7553x5341 (6K). Marine met kielzog 7341x5625 (6K). MSK Gent uploads, ink and gouache on paper.
- Giovanni Segantini: Le due madri 6936x3725 (6K). Ploughing 8161x5089 (6K). Ritorno a casa 5598x2972.
- Isaac Levitan: Golden Autumn, Slobodka 7158x4465 (GAP, 6K).
- Carl Friedrich Lessing: Knight's Castle 7152x5055 (Alte Nationalgalerie photo, check uploader). Oak forest 9210x6822 and Waldlandschaft mit Wartturm 9189x6972 are Städel files, CC BY-SA.

### American West, for scale

- Albert Bierstadt: Sunrise, Yosemite Valley 12732x8815 (6K). View in the Yosemite Valley 10173x6596 (6K). Lake Lucerne 7104x4233 (GAP, NGA, 6K). Valley of the Yosemite 6301x3898 (GAP, 6K). A Storm in the Rocky Mountains, Mt. Rosalie 5736x3319. Alcatraz 6000x3991.
- Thomas Moran: An Indian Paradise 9828x7433 (Dallas, 6K). Valley of the Catawissa in Autumn 7566x4705 (6K). Grand Canyon of the Colorado River 5665x3192 (GAP). The Chasm of the Colorado 8069x2989 is too short for 5K.

### British school: portraiture and the Pre-Raphaelites

- Franz Xaver Winterhalter: Leonilla, Princess of Sayn-Wittgenstein 13542x9064 (Getty Open Content, 6K, the only wide-format portrait here). Portrait of a Lady 5371x7167 (Minneapolis, 5K); the Commons file page lists an anonymous artist, the museum attributes it to Winterhalter. The Städel Grunelius portrait is CC BY-SA; the Rijksmuseum and Amsterdam Museum files are 19th-century photographs and lithographs after the paintings.
- Joshua Reynolds: every candidate is portrait-shaped, so a 16:9 crop keeps a band of the composition. Lady Caroline Howard 8687x10967 (NGA, 6K), Self-portrait PRA 8493x11180 (GAP/RA, 6K), A Young Girl and Her Dog 7500x9153 (GAP, 6K), Cupid Untying the Zone of Venus 6896x8768 (Hermitage scan, 6K), Mrs Musters as Hebe 7051x11610 (GAP, 6K but the crop keeps a third of the height). Least cropped: The Ladies Waldegrave 5750x4918 (NGS, 5K). Miss Mary Pelham 5624x7076 (Dallas, 5K), Sir John Macpherson 5781x6976 (NGS, 5K). The Three Ladies Adorning a Term of Hymen 6779x5389 (GAP, 6K) is a Tate work, same disputed licence position as the Turner Tate files.
- J. M. W. Turner beyond the four in the catalogue: Met GAP watercolours at 6K (Sheerness as seen from the Nore 8032x5622, On the Washburn 7345x4633, Melrose 7124x4525, Schloss Rosenau 6972x5388) plus the Red Rigi 7480x4992, Val d'Aosta 6593x4935 and Saint Augustine's Gate, Canterbury 6164x4283; The Frick Collection's The Harbor of Dieppe 7499x5796 (GAP). Cleveland TIFFs: Flüelen from the Lake of Lucerne 6376x3900 (6K) and Solitude 5229x3780 (5K). The "(Barcelona) ... Tate Britain" batch by Didier Descouens (own work, PD/CC0) is about 40 camera photographs of Tate works, 5.1k to 11k wide, mostly watercolours with sheet edges to trim: The Burning of Rome 11012x6043, Mountains. S. Gothard 9027x5872, Duddon Sands 8828x5474, The New Moon 8136x6538, Jason 7927x5544, Apollo and Python 7793x4763, Going to the Ball 7641x5013, The Golden Bough 6994x4393. Not museum scans: check one download for glare and sharpness before relying on the batch.
- William Holman Hunt: The Finding of the Saviour in the Temple 8858x5428 (GAP, Birmingham, 6K), The Day in the Country 7231x4645 (GAP, 6K), May Morning on Magdalen College, Oxford 6788x5216 (GAP, 6K), Study for The Hireling Shepherd 6456x4072 (Cleveland TIFF, 6K, work on paper), The Miracle of the Sacred Fire 5384x3949 and The Triumph of the Innocents 5525x3333 (GAC, 5K). A Converted British Family 5647x4480 is PD but its only source is a dead blog link; the Fogg version is a visitor DSC photo. The large btv1b... file from the BnF is Julia Margaret Cameron's photograph of Hunt, not a work by him.
- John Everett Millais: Ophelia 7087x4820 and Hearts are Trumps 6264x4775 (GAP, both Tate, disputed position). Aeneas Shown the Body of Pallas 7348x5776 (Cleveland TIFF, 6K drawing). The Blind Girl 8858x12869 and The Woodman's Daughter 8267x11522 clear 6K as crops but are portrait-shaped, slice candidates. Leisure Hours 5172x3848 (Detroit, 5K), L'Enfant du Régiment 5442x4056 and Blow, Blow, Thou Winter Wind 5233x3623 (GAP, 5K), The Knight Errant 5248x3499 (CC0 photo of the Tate picture).
- Dante Gabriel Rossetti: the finished oils (Beata Beatrix, Proserpine, The Beloved, Ecce Ancilla Domini) only exist as Tate images; what qualifies is works on paper. Jane Morris 1870 6205x4930 (NGA, 6K), the GNAM Rome pastel of Jane Morris 7673x9913 (GAC, 6K crop, portrait-shaped), and the Birmingham GAP drawings at 6K: The Laboratory 6652x5429, Sir Launcelot in the Queen's Chamber 6556x4968, Sir Galahad at the ruined Chapel 6151x5256, King Arthur and the Weeping Queens 6241x5352, the Found head study 6035x5429; about ten more portrait-orientation drawings reach 5K. Elizabeth Siddal Resting 5898x7003 (Getty, CC0, 5K).

- James Ward: the Yale GAP batch alone clears 6K in a dozen paintings: Eagles 7555x4980, Lea Castle from above the Woods 7319x4621, Mr. Thompson's Wire Mill, Tintern 7501x4693, The Midday Meal 6673x4269, Man Struggling with a Boa Constrictor 6590x4662, Ryelands Sheep 6314x4758, Heath Ewe and Lambs 6372x4903, An Overshot Mill 6277x5047, A Young Boy with Dogs 6168x3937; An Overshot Mill in Wales, Aberdulais 11812x5365 (National Library of Wales scan) is the widest. Kenilworth Castle 7561x3247 is height-bound at 5K. His famous Gordale Scar is Tate.
- George Stubbs: same Yale GAP batch, 6K in the marquee works: A Horse Affrighted by a Lion 6698x5155, Labourers 7232x5508, Horses Fighting 7062x5166, The Farmer's Wife and the Raven 6871x4698, Phaeton with a Pair of Cream Ponies 7038x4585, A Lion Attacking a Horse 6378x4887, A Tiger and a Sleeping Leopard 6256x4861, A Repose after Shooting 6157x4919; 5K: Zebra 5972x4753, Pumpkin with a Stable-lad 5762x4686, Hound Coursing a Stag 5417x4278. The Commons Whistlejacket copy is 5004 px wide, just under the 5K tolerance. John Dixon's engraving after the tigress 9969x8188 is another print-after option.
- Edwin Landseer: The Monarch of the Glen 5209x5131 (National Galleries Scotland, 5K), Hector, Nero and Dash with Lory 9788x7887 (GAC, 6K), Cat's Paw 5029x5575 (Minneapolis, 5K), Ptarmigan in a Landscape 5425x4090 and A Highland Landscape 5460x4393 (Yale GAP, 5K), Titania and Bottom 5783x3474 (GAP; the painting is V&A, same UK-collection licence caveat as Tate). The Rijksmuseum mezzotints after him clear 6K (A Distinguished Member of the Humane Society 9094x7348, The Shepherd's Prayer 8704x5306) if prints-after count.
- James Northcote: Macbeth and the Witches 6457x5045 (GAP, 6K), Study for a Tiger and Monkeys 5779x5003 and Sir William Elford 5118x4073 (5K).
- Laura Herford is a dead end: the only two Commons scans of her work, The Little Emigrant (Suter Art Gallery), are 430 and 634 px wide; her watercolours sit in closed collections.

### French neoclassicism, David and Labille-Guiard

- Jacques-Louis David: the deepest pool on this list. 6K: Marat assassiné 16134x20762 (GAP, Brussels; portrait format, one band), The Emperor Napoleon in His Study 16304x26731 (NGA, Kress; portrait format), Serment de l'armée, distribution des aigles 12152x7586 (Versailles), The Intervention of the Sabine Women 10464x7396 (uploader's own scan, PD, check first), Le Serment des Horaces 10051x7794 and Léonidas aux Thermopyles 9655x7124 (2025 photographs of the Louvre pictures by Shonagon, PD, check first), The Combat of Diomedes 7391x3533 and Le serment du Jeu de Paume 7319x4000 (GAP), The Prisoner 6395x4344 (Cleveland TIFF). 5K: The Death of Socrates 5526x3744 and Lavoisier and His Wife 5589x3714 (Met, open access), Cupid and Psyche 5905x4400 (Cleveland TIFF; the 5000 px 1962.37 version falls short), Apelles Painting Campaspe 6000x4235, The Sabine Women INV 3691 5932x4341, Orpheus and Eurydice 5069x3400 (MSK Gent, CC0, exactly on the line). The NGA file G-001335 is workshop of Rouget and the Carnavalet G.39334 an aquatint by Jazet, both out; the Met caps its David copies at 5000 px (4K only).
- Adélaïde Labille-Guiard: Portrait of a Man 5167x6258 (Dallas, 5K). The Met's Self-Portrait with Two Pupils is 5000 px wide, 4K only. Portrait présumé de la comtesse de Maussion 6000x4000 (Cognacq-Jay, CC0) is an oval canvas; a 16:9 crop fights the corners, check first.

### Outside the period, pulled for the mood

- Albrecht Dürer: Der Weiher im Walde 4235x3000 (British Museum, GAP) and Trient von Norden gesehen 4557x3020 (Kunsthalle Bremen, GAP), both 4K after trimming the mount; Lot and His Daughters 7301x9191 (NGA, CC0) as two 6K slices. Feast of the Rose Garlands 4285x3625 and the Landauer Altar 4969x5434 remain as 4K options.
- Jean Delville (public domain in the EU since 2024): La roue du monde 5142x6732 (KMSKA TIFF) as three 5K slices. Painted 1940, so its US status is unclear. L'École de Platon is 4123x1913, too short; the Royal Library of Belgium holds his drawings at 6K sizes.
- Gustave Moreau: not yet. The one large file on Commons, "Saint Sebastian Succoured" 7297x9196, shows a seated woman while the Google Arts record it cites is a 27x33 cm landscape watercolour; the file is mislabeled and parked in `incoming/` until identified. His own museum publishes nothing open; Harvard's La chimère 4265x5139 and L'Apparition 4060x4845 are the remaining 4K-slice options.
- Fidus (public domain since 2019): Lichtgebet 4682x6931 (Deutsches Historisches Museum) is the only clean scan; skipped for now.

## Dead ends at 5K

- Alexander Kircher and Hermann Hendrich: nothing above 3300 px on Commons. Kircher's known works are in private hands and Austrian regional museums; the Belvedere collection search is the one lead.
- Arkhip Kuindzhi: no museum-grade file above 5000 px on Commons; Tretyakov and Russian Museum do not publish open files.
- Akseli Gallen-Kallela: Commons copies stop at about 5000 px (Aino triptych 8066x4042 is the exception). Use the Finnish National Gallery site directly.
- Caspar David Friedrich's Hamburg and Berlin works: source images are CC BY-NC-SA, and the Commons copies are visitor photographs.
- Georg Pezolt: nothing reaches 4K under an accepted license. His one painting in an open collection, Italienische Landschaft mit Pilgern (Belvedere inv. 7916, from the KHM in 1987, PD), tops out at 3508x2222 on Commons; the Belvedere's IIIF master is 1772x1122. The Pinakothek's Taormina mit Blick auf den Ätna is CC BY-SA. The two Dorotheum lots on Commons fall below 4K after trimming: the Rottmann lithograph after Pezolt is a 5000x3765 sheet with a 20x27 cm image, the Karolinenbrücke pencil drawing is 3372x2288. The 7360px "Pezold" files on Commons are August Pezold (1794-1859), a different painter; the Estonian History Museum publishes those watercolours as PD at 6K sizes.
- Thomas Hill: his two 6K-capable files on Commons are photos of the paintings under CC BY-SA, rejected — Great Canyon of the Sierra 7619x4484 (Crocker) and Mount Tallac from Lake Tahoe 7554x4810 (de Young/FAMSF). The one open 6K option is the Prang chromolithograph after his Yosemite Valley, 7902x4838 (LOC, PD) — a print-after like the Wellcome mezzotints.
