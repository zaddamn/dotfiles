#!/usr/bin/env python3
"""Generate fishbowl volume icons (vol-0.svg ... vol-200.svg, vol-muted.svg).

Rules:
  * 0..100  : water height is linear, 100 = water level with the rim.
  * 100..200: bowl stays exactly full (identical water), only the spill grows.
  * The bowl is identical (size/position) in every frame.
No dependencies. Usage: python3 generate_fishbowl_icons.py [output_dir]
"""
import math, os, sys

# ---- palette -------------------------------------------------------------
OUTLINE = "#5b7a91"
WATER = "#2a9dbc"
BRIGHT = "#5ec8e5"

# ---- bowl geometry (24x24 canvas) ---------------------------------------
TOP, BOTTOM = 4.0, 19.5          # interior top (rim) and bottom
STEPS = list(range(0, 201, 20))  # 0,20,...,200
WAVE_AMP = 0.45
STROKE = 1.2

# left half of the bowl contour as two cubic beziers (right side is mirrored)
LEFT_CURVES = [
    ((8, 4), (8, 6.2), (4.5, 7), (4.5, 11.5)),
    ((4.5, 11.5), (4.5, 16), (8, 19.5), (12, 19.5)),
]


def bez(p0, p1, p2, p3, t):
    u = 1 - t
    return (u**3*p0[0] + 3*u*u*t*p1[0] + 3*u*t*t*p2[0] + t**3*p3[0],
            u**3*p0[1] + 3*u*u*t*p1[1] + 3*u*t*t*p2[1] + t**3*p3[1])


def contour(n=24):
    pts = []
    for c in LEFT_CURVES:
        for i in range(n + 1):
            pts.append(bez(*c, i / n))
    return pts


def offset_contour(d):
    pts = contour()
    out = []
    for i in range(len(pts)):
        a = pts[max(i - 1, 0)]
        b = pts[min(i + 1, len(pts) - 1)]
        tx, ty = b[0] - a[0], b[1] - a[1]
        l = math.hypot(tx, ty) or 1
        tx, ty = tx / l, ty / l
        # contour runs downward; outward (left) normal is (-ty_abs..): rotate
        nx, ny = ty, -tx          # for downward travel (tx~0,ty>0) -> (+,0)
        out.append((pts[i][0] - nx * d, pts[i][1] - ny * d))
    return out


def clip_path(points_len, pts):
    """Return prefix of polyline pts with total length points_len."""
    out = [pts[0]]
    acc = 0.0
    for a, b in zip(pts, pts[1:]):
        seg = math.hypot(b[0] - a[0], b[1] - a[1])
        if acc + seg >= points_len:
            f = (points_len - acc) / seg
            out.append((a[0] + (b[0] - a[0]) * f, a[1] + (b[1] - a[1]) * f))
            return out
        out.append(b)
        acc += seg
    return out


def fmt(p):
    return f"{p[0]:.2f},{p[1]:.2f}"


def mirror(p):
    return (24 - p[0], p[1])


def interior_d():
    """Closed interior region (for the water clip), top at the rim line."""
    pts = contour()
    left = " ".join(fmt(p) for p in pts)
    right = " ".join(fmt(mirror(p)) for p in reversed(pts))
    return f"M{left} L{right} Z"


def outline_svg():
    pts = contour()
    left = "M" + " L".join(fmt(p) for p in pts)
    right = "M" + " L".join(fmt(mirror(p)) for p in pts)
    # rim lips + bowl sides + bottom joined through the bottom point
    return (f'<path d="M6.6,4 H8.6 M15.4,4 H17.4" />'
            f'<path d="{left} L{fmt(mirror(pts[-1]))}" />'
            f'<path d="{right}" />')


def water_svg(v):
    if v <= 0:
        return ""
    v = min(v, 100)
    y = BOTTOM - (v / 100.0) * (BOTTOM - TOP)
    a = WAVE_AMP if v < 100 else 0.0   # flat brim at 100 so it reads "exactly full"
    wave = (f"M2,{y:.2f} C6,{y - a * 2:.2f} 9,{y - a * 2:.2f} 12,{y:.2f} "
            f"S18,{y + a * 2:.2f} 22,{y:.2f}")
    fill = f"{wave} L22,21 L2,21 Z"
    parts = [f'<g clip-path="url(#in)"><path d="{fill}" fill="{WATER}" stroke="none"/>',
             f'<path d="{wave}" fill="none" stroke="{BRIGHT}" stroke-width="0.9"/></g>']
    return "".join(parts)


def spill_svg(v):
    if v <= 100:
        return ""
    s = (v - 100) / 100.0            # 0.2 .. 1.0
    out = []
    # main stream hugging the glass + a thinner outer stream from s >= 0.6
    specs = [(1.0, 0.9 + 0.7 * s, 4.0 + 15.0 * s)]
    if s >= 0.6:
        specs.append((2.3, 0.7, 3.0 + 9.0 * s))
    for off, w, length in specs:
        lip = [(8.7, 4.6), (8.2, 3.9), (7.6, 3.7), (7.1, 4.0)]
        body = offset_contour(off)[3:]
        pts = lip + body
        pts = clip_path(length, pts)
        d = "M" + " L".join(fmt(p) for p in pts)
        dm = "M" + " L".join(fmt(mirror(p)) for p in pts)
        for path, end in ((d, pts[-1]), (dm, mirror(pts[-1]))):
            out.append(f'<path d="{path}" stroke="{WATER}" stroke-width="{w:.2f}"/>')
            out.append(f'<path d="{path}" stroke="{BRIGHT}" stroke-width="{max(w * 0.35, 0.35):.2f}"/>')
            if s >= 0.4 and off == 1.0:
                out.append(f'<circle cx="{end[0]:.2f}" cy="{end[1]:.2f}" r="{w * 0.65:.2f}" '
                           f'fill="{WATER}" stroke="none"/>')
    return "".join(out)


def svg(v=None, muted=False):
    head = ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">'
            f'<defs><clipPath id="in"><path d="{interior_d()}"/></clipPath></defs>')
    common = 'fill="none" stroke-linecap="round" stroke-linejoin="round"'
    body = ""
    if not muted:
        body += water_svg(v)
    body += f'<g {common} stroke="{OUTLINE}" stroke-width="{STROKE}">{outline_svg()}</g>'
    if muted:
        body += (f'<path d="M5,5 L19,20" {common} stroke="{OUTLINE}" stroke-width="{STROKE}"/>')
    else:
        body += f'<g {common}>{spill_svg(v)}</g>'
    return head + body + "</svg>\n"


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("out", nargs="?", default="icons", help="output dir")
    ap.add_argument("--step", type=int, default=20, help="volume step (e.g. 5 or 1)")
    ap.add_argument("--value", type=float, help="write ONE frame for this volume (0-200)")
    ap.add_argument("-o", "--file", help="output file for --value")
    a = ap.parse_args()
    if a.value is not None:
        data = svg(max(0.0, min(200.0, a.value)))
        if a.file:
            with open(a.file, "w") as f:
                f.write(data)
        else:
            sys.stdout.write(data)
        return
    os.makedirs(a.out, exist_ok=True)
    vals = list(range(0, 201, a.step))
    for v in vals:
        with open(os.path.join(a.out, f"vol-{v}.svg"), "w") as f:
            f.write(svg(v))
    with open(os.path.join(a.out, "vol-muted.svg"), "w") as f:
        f.write(svg(muted=True))
    print(f"wrote {len(vals) + 1} icons to {a.out}/")


if __name__ == "__main__":
    main()
