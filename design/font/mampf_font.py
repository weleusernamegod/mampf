"""
Mampf-Schrift: eine Strichschrift, abgeleitet vom mampf-Logo.

Die Buchstaben bestehen wie im Logo nur aus geraden Linien, Halbkreisen und
runden Strich-Enden. Jeder Buchstabe wird hier als "Mittellinie" gezeichnet;
danach wird der Strich mit einer festen Dicke aufgeblasen und als Umriss in
eine Font-Datei geschrieben.

Ausführen (braucht fonttools, shapely, brotli):
    python3 -m venv /tmp/fontenv && /tmp/fontenv/bin/pip install fonttools shapely brotli
    /tmp/fontenv/bin/python mampf_font.py
Erzeugt im gleichen Ordner: Mampf-Light/Regular/Bold als .ttf und .woff2,
mampf-fonts.js für testen.html und kopiert Regular nach map/public/assets/fonts/.
"""
import math
import os

from fontTools.fontBuilder import FontBuilder
from fontTools.misc.timeTools import timestampNow
from fontTools.pens.ttGlyphPen import TTGlyphPen
from shapely.geometry import LineString, Point
from shapely.geometry.polygon import orient
from shapely.ops import unary_union

HERE = os.path.dirname(os.path.abspath(__file__))

# ---------------------------------------------------------------------------
# Masse (Font-Einheiten, 1000 pro Geviert). Verhältnisse wie im Logo:
# Buchstabe schmal und hoch, Bögen sind Halbkreise.
# ---------------------------------------------------------------------------
UPM = 1000
H = 460              # x-Höhe (Höhe von a, m, n ...)
W = 0.45 * H         # Buchstabenbreite (Mitte Strich bis Mitte Strich)
R = W / 2            # Radius der Bögen
ASC = 1.5 * H        # Oberlänge (b, d, h, l, Ziffern)
DESC = 0.45 * H      # Unterlänge (g, j, p, q, y)
GAP = 0.62 * W       # Abstand zwischen Buchstaben (Mitte zu Mitte)
DOT_Y = 1.42 * H     # Höhe der i- und Umlaut-Punkte

WEIGHTS = {          # Strichdicke relativ zur x-Höhe
    "Light": 0.12,   # ungefähr wie das Logo selbst (40 / 300)
    "Regular": 0.165,  # wie in den Slogan-Entwürfen
    "Bold": 0.22,
}

# Zusätzlicher Abstand links / rechts einzelner Buchstaben (in Buchstabenbreiten W).
# Gerade Striche nebeneinander wirken enger als Bögen, darum brauchen
# i, j, k, l etwas mehr Luft. Positive Werte = mehr Abstand.
SPACING = {
    "i": (0.12, 0.12),
    "j": (0.30, 0.12),
    "k": (0.12, 0.0),
    "l": (0.12, 0.12),
}


# ---------------------------------------------------------------------------
# Zeichen-Bausteine. Koordinaten: Grundlinie y=0, y nach oben.
# ---------------------------------------------------------------------------
def line(x1, y1, x2, y2):
    return ("path", [(x1, y1), (x2, y2)])


def arc(cx, cy, rx, ry, a0, a1, steps=None):
    """Ellipsenbogen von Winkel a0 nach a1 (Grad, mathematisch)."""
    n = steps or max(8, int(abs(a1 - a0) / 3))
    pts = []
    for i in range(n + 1):
        a = math.radians(a0 + (a1 - a0) * i / n)
        pts.append((cx + rx * math.cos(a), cy + ry * math.sin(a)))
    return ("path", pts)


def dot(x, y):
    return ("dot", x, y)


def arch(x, y, r=R):      # Bogen oben (wie bei n), linker Fuss bei (x, y)
    return arc(x + r, y, r, r, 180, 0)


def bowl(x, y, r=R):      # Bogen unten (wie bei u), linker Fuss bei (x, y)
    return arc(x + r, y, r, r, 180, 360)


def o_shape(x=0):
    return [arch(x, H - R), bowl(x, R), line(x, R, x, H - R), line(x + W, R, x + W, H - R)]


def descender_hook(x):    # Bogen unten an g / y, von rechts nach links
    return arc(x - R, DESC * -1 + R, R, R, 0, -180)


def build_glyphs():
    T, M, A, D = H, H / 2, ASC, -DESC
    g = {}

    g["a"] = (W, [arch(0, T - R), line(W, T - R, W, 0), line(0, T - R, 0, R), bowl(0, R)])
    g["b"] = (W, o_shape() + [line(0, A, 0, 0)])
    g["c"] = (W, [arch(0, T - R), line(0, T - R, 0, R), bowl(0, R)])
    g["d"] = (W, o_shape() + [line(W, A, W, 0)])
    g["e"] = (W, [arch(0, T - R), line(W, T - R, W, M), line(W, M, 0, M), line(0, T - R, 0, R), bowl(0, R)])
    fx, rf = 0.35 * W, 0.85 * R
    g["f"] = (fx + 0.7 * W, [line(fx, A - rf, fx, 0), arc(fx + rf, A - rf, rf, rf, 180, 0), line(0, T, fx + 0.6 * W, T)])
    g["g"] = (W, o_shape() + [line(W, R, W, D + R), descender_hook(W)])
    g["h"] = (W, [line(0, A, 0, 0), arch(0, T - R), line(W, T - R, W, 0)])
    g["i"] = (0, [line(0, T, 0, 0), dot(0, DOT_Y)])
    rj = 0.55 * R
    g["j"] = (0, [line(0, T, 0, D + R), arc(-rj, D + R, rj, rj, 0, -180), dot(0, DOT_Y)])
    g["k"] = (0.85 * W, [line(0, A, 0, 0), line(0.85 * W, T, 0, M - 0.1 * H), line(0.3 * W, M + 0.02 * H, 0.85 * W, 0)])
    g["l"] = (0, [line(0, A, 0, 0)])
    g["m"] = (2 * W, [line(0, T - R, 0, 0), arch(0, T - R), line(W, T - R, W, 0), arch(W, T - R), line(2 * W, T - R, 2 * W, 0)])
    g["n"] = (W, [line(0, T - R, 0, 0), arch(0, T - R), line(W, T - R, W, 0)])
    g["o"] = (W, o_shape())
    g["p"] = (W, o_shape() + [line(0, T - R, 0, D)])
    g["q"] = (W, o_shape() + [line(W, T - R, W, D)])
    g["r"] = (0.8 * W, [line(0, T - R, 0, 0), arc(R, T - R, R, R, 180, 90), line(R, T, 0.8 * W, T)])
    sx, q = 0.95 * W, H / 4
    g["s"] = (sx, [arc(sx / 2, T - q, sx / 2, q, 6, 270), arc(sx / 2, q, sx / 2, q, 90, -174)])
    tx, rt = 0.3 * W, 0.9 * R
    g["t"] = (tx + rt, [line(tx, T + 0.42 * H, tx, rt), arc(tx + rt, rt, rt, rt, 180, 270), line(0, T, tx + 0.55 * W, T)])
    g["u"] = (W, [line(0, T, 0, R), bowl(0, R), line(W, T, W, 0)])
    g["v"] = (W, [line(0, T, W / 2, 0), line(W / 2, 0, W, T)])
    g["w"] = (2 * W, [line(0, T, 0, R), bowl(0, R), line(W, T, W, R), bowl(W, R), line(2 * W, T, 2 * W, R)])
    g["x"] = (W, [line(0, T, W, 0), line(W, T, 0, 0)])
    g["y"] = (W, [line(0, T, 0, R), bowl(0, R), line(W, T, W, D + R), descender_hook(W)])
    g["z"] = (W, [line(0, T, W, T), line(W, T, 0, 0), line(0, 0, W, 0)])

    # Umlaute und Akzente
    g["adieresis"] = (W, g["a"][1] + [dot(0.15 * W, DOT_Y), dot(0.85 * W, DOT_Y)])
    g["odieresis"] = (W, g["o"][1] + [dot(0.15 * W, DOT_Y), dot(0.85 * W, DOT_Y)])
    g["udieresis"] = (W, g["u"][1] + [dot(0, DOT_Y), dot(W, DOT_Y)])
    acute = line(0.3 * W, T + 0.28 * H, 0.75 * W, T + 0.52 * H)
    grave = line(0.25 * W, T + 0.52 * H, 0.7 * W, T + 0.28 * H)
    g["eacute"] = (W, g["e"][1] + [acute])
    g["egrave"] = (W, g["e"][1] + [grave])
    g["agrave"] = (W, g["a"][1] + [grave])

    # Ziffern (so hoch wie die Oberlänge)
    C = A
    g["zero"] = (W, [arch(0, C - R), bowl(0, R), line(0, R, 0, C - R), line(W, R, W, C - R)])
    g["one"] = (W * 0.6, [line(W * 0.6, 0, W * 0.6, C), line(W * 0.6, C, 0, C - 0.4 * W)])
    two_top = arc(R, C - R, R, R, 180, -40)
    g["two"] = (W, [two_top, line(*two_top[1][-1], 0, 0), line(0, 0, W, 0)])
    q3 = C / 4
    g["three"] = (W, [arc(R, C - q3, R, q3, 160, -90), arc(R, q3, R, q3, 90, -160)])
    g["four"] = (W, [line(0.75 * W, 0, 0.75 * W, C), line(0.75 * W, C, 0, 0.35 * C), line(0, 0.35 * C, W, 0.35 * C)])
    q5 = 0.29 * C
    g["five"] = (W, [line(W, C, 0, C), line(0, C, 0, 2 * q5), line(0, 2 * q5, R, 2 * q5), arc(R, q5, R, q5, 90, -160)])
    h6 = 0.6 * C
    g["six"] = (W, [arch(0, h6 - R), bowl(0, R), line(0, R, 0, C - R), line(W, R, W, h6 - R), arc(R, C - R, R, R, 180, 30)])
    g["seven"] = (W, [line(0, C, W, C), line(W, C, 0.25 * W, 0)])
    g["eight"] = (W, [arc(R, 0.75 * C, 0.92 * R, 0.25 * C, 0, 360), arc(R, 0.27 * C, R, 0.27 * C, 0, 360)])
    b9 = 0.4 * C
    g["nine"] = (W, [arch(0, C - R), bowl(0, b9 + R), line(0, b9 + R, 0, C - R), line(W, R, W, C - R), arc(R, R, R, R, 0, -150)])

    # Satzzeichen
    g["question"] = (W, [arc(R, A - R, R, R, 180, -90), line(R, A - 2 * R, R, 0.32 * H), dot(R, 0)])
    g["exclam"] = (0, [line(0, A, 0, 0.32 * H), dot(0, 0)])
    g["period"] = (0, [dot(0, 0)])
    g["comma"] = (0, [line(0, 0, -0.15 * W, -0.25 * H)])
    g["colon"] = (0, [dot(0, 0), dot(0, 0.65 * H)])
    g["hyphen"] = (0.7 * W, [line(0, M, 0.7 * W, M)])
    g["quotesingle"] = (0, [line(0, A, 0, A - 0.25 * H)])
    g["quotedbl"] = (0.5 * W, [line(0, A, 0, A - 0.25 * H), line(0.5 * W, A, 0.5 * W, A - 0.25 * H)])
    g["slash"] = (0.8 * W, [line(0, D * 0.5, 0.8 * W, A)])
    g["space"] = (0.55 * W, [])
    return g


# Welche Tasten auf welchen Buchstaben zeigen (Grossbuchstaben = Kleinbuchstaben,
# wie im Logo gibt es nur Kleinbuchstaben).
def build_cmap(glyph_names):
    cmap = {}
    for c in "abcdefghijklmnopqrstuvwxyz":
        cmap[ord(c)] = c
        cmap[ord(c.upper())] = c
    extra = {
        "ä": "adieresis", "Ä": "adieresis", "ö": "odieresis", "Ö": "odieresis",
        "ü": "udieresis", "Ü": "udieresis", "é": "eacute", "É": "eacute",
        "è": "egrave", "È": "egrave", "à": "agrave", "À": "agrave",
        "0": "zero", "1": "one", "2": "two", "3": "three", "4": "four",
        "5": "five", "6": "six", "7": "seven", "8": "eight", "9": "nine",
        "?": "question", "!": "exclam", ".": "period", ",": "comma", ":": "colon",
        "-": "hyphen", "'": "quotesingle", "’": "quotesingle", '"': "quotedbl",
        "/": "slash", " ": "space", " ": "space",
    }
    for ch, name in extra.items():
        cmap[ord(ch)] = name
    return {k: v for k, v in cmap.items() if v in glyph_names}


# ---------------------------------------------------------------------------
# Striche -> Umrisse
# ---------------------------------------------------------------------------
def outline(strokes, sw, shift):
    shapes = []
    for s in strokes:
        if s[0] == "dot":
            shapes.append(Point(s[1] + shift, s[2]).buffer(sw * 0.62, quad_segs=24))
        else:
            pts = [(x + shift, y) for x, y in s[1]]
            shapes.append(LineString(pts).buffer(sw / 2, quad_segs=24, cap_style="round", join_style="round"))
    if not shapes:
        return []
    geom = unary_union(shapes).simplify(0.4)
    polys = [geom] if geom.geom_type == "Polygon" else list(geom.geoms)
    return [orient(p, sign=-1.0) for p in polys]  # TrueType: aussen im Uhrzeigersinn


def draw_polys(polys, pen):
    def ring(coords):
        pts = []
        for x, y in list(coords)[:-1]:
            p = (round(x), round(y))
            if not pts or pts[-1] != p:
                pts.append(p)
        if len(pts) > 1 and pts[0] == pts[-1]:
            pts.pop()
        if len(pts) < 3:
            return
        pen.moveTo(pts[0])
        for p in pts[1:]:
            pen.lineTo(p)
        pen.closePath()
    for p in polys:
        ring(p.exterior.coords)
        for hole in p.interiors:
            ring(hole.coords)


def build_font(style, ratio):
    sw = ratio * H
    glyphs = build_glyphs()
    order = [".notdef"] + list(glyphs.keys())
    cmap = build_cmap(set(order))

    fb = FontBuilder(UPM, isTTF=True)
    fb.setupGlyphOrder(order)
    fb.setupCharacterMap(cmap)

    tt_glyphs, metrics = {}, {}
    # .notdef: einfaches Rechteck
    pen = TTGlyphPen(None)
    nd_w = int(W + GAP)
    for (x0, y0, x1, y1), cw in (((50, 0, nd_w - 50, int(ASC)), True), ((90, 40, nd_w - 90, int(ASC) - 40), False)):
        pts = [(x0, y0), (x0, y1), (x1, y1), (x1, y0)] if cw else [(x0, y0), (x1, y0), (x1, y1), (x0, y1)]
        pen.moveTo(pts[0]); [pen.lineTo(p) for p in pts[1:]]; pen.closePath()
    tt_glyphs[".notdef"] = pen.glyph()
    metrics[".notdef"] = (nd_w, 50)

    for name, (adv, strokes) in glyphs.items():
        extra_l, extra_r = (v * W for v in SPACING.get(name, (0, 0)))
        pen = TTGlyphPen(None)
        polys = outline(strokes, sw, GAP / 2 + extra_l)
        draw_polys(polys, pen)
        glyph = pen.glyph()
        tt_glyphs[name] = glyph
        lsb = int(min(p.bounds[0] for p in polys)) if polys else 0
        metrics[name] = (int(round(adv + GAP + extra_l + extra_r)), lsb)

    fb.setupGlyf(tt_glyphs)
    fb.setupHorizontalMetrics(metrics)
    ascent = int(round(DOT_Y + sw * 0.62 + 20))
    descent = int(round(DESC + sw / 2 + 20))
    fb.setupHorizontalHeader(ascent=ascent, descent=-descent)
    weight_class = {"Light": 300, "Regular": 400, "Bold": 700}[style]
    fb.setupNameTable({
        "familyName": "Mampf",
        "styleName": style,
        "uniqueFontIdentifier": f"Mampf-{style}-1.0",
        "fullName": f"Mampf {style}",
        "psName": f"Mampf-{style}",
        "version": "Version 1.000",
        "copyright": "mampf.io",
    })
    fb.setupOS2(
        version=4,
        sTypoAscender=ascent, sTypoDescender=-descent, sTypoLineGap=0,
        usWinAscent=ascent, usWinDescent=descent,
        sxHeight=int(H), sCapHeight=int(ASC), usWeightClass=weight_class,
        fsSelection={"Bold": 0x20, "Regular": 0x40}.get(style, 0) | 0x80,  # Bold/Regular + USE_TYPO_METRICS
    )
    fb.setupPost()
    fb.setupHead(unitsPerEm=UPM, macStyle=1 if style == "Bold" else 0,
                 created=timestampNow(), modified=timestampNow())

    base = os.path.join(HERE, f"Mampf-{style}")
    fb.save(base + ".ttf")
    fb.font.flavor = "woff2"
    fb.font.save(base + ".woff2")
    return base


def write_test_js():
    """Schreibt mampf-fonts.js: die WOFF2-Dateien als Text, für testen.html."""
    import base64
    import time
    data = {}
    for style in WEIGHTS:
        with open(os.path.join(HERE, f"Mampf-{style}.woff2"), "rb") as f:
            data[style] = base64.b64encode(f.read()).decode()
    with open(os.path.join(HERE, "mampf-fonts.js"), "w") as f:
        f.write("// Automatisch erzeugt von mampf_font.py, nicht von Hand ändern.\n")
        f.write(f"window.MAMPF_FONTS_BUILT = {time.strftime('%H:%M:%S')!r};\n")
        f.write("window.MAMPF_FONTS = {\n")
        for style, b64 in data.items():
            f.write(f'  "{style}": "{b64}",\n')
        f.write("};\n")


if __name__ == "__main__":
    for style, ratio in WEIGHTS.items():
        print("gebaut:", build_font(style, ratio) + ".ttf / .woff2")
    write_test_js()
    print("gebaut: mampf-fonts.js (für testen.html)")
    # Die Website braucht Regular für die Sprüche unter dem Logo (assets/slogan.js)
    import shutil
    web = os.path.join(HERE, "..", "..", "map", "public", "assets", "fonts")
    os.makedirs(web, exist_ok=True)
    shutil.copy(os.path.join(HERE, "Mampf-Regular.woff2"), web)
    print("kopiert: Mampf-Regular.woff2 -> map/public/assets/fonts/")
