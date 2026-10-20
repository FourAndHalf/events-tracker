"""Derives every app icon / splash asset from assets/icon/app_icon.png.

app_icon.png is the source of truth: a light mark on a dark rounded square.
It has no alpha channel (the "transparent" checkerboard around the square is
baked into the pixels), so the rounded square is cut out with an analytic,
anti-aliased mask fitted to its measured edges.

Outputs (all next to this script):
  icon.png             legacy launcher icon: the rounded square, clear corners
  icon_foreground.png  adaptive-icon foreground: the mark only, transparent
  icon_monochrome.png  Android 13+ themed icon: the mark as a white silhouette
  splash_logo.png      in-app splash / header logo: the rounded square

Run from this directory with: python3 generate_icon.py
"""
import numpy as np
from PIL import Image, ImageDraw

SOURCE = "app_icon.png"
CANVAS = 1024

# Rounded square inside the source, measured from its edges (inclusive px).
SQUARE = (80, 79, 1173, 1157)
RADIUS = 259

# Luminance band turning the mark-vs-background contrast into a soft alpha:
# at/below LUM_LO is background, at/above LUM_HI is fully the mark.
LUM_LO = 64
LUM_HI = 88
# Ignore a margin just inside the square's edge so its rim never reads as mark.
EDGE_MARGIN = 40

# Size of the mark's longer side as a fraction of the 1024 canvas. The
# foreground is inset a further 16% by ic_launcher.xml, so it stays inside
# the adaptive-icon safe zone.
FOREGROUND_SCALE = 0.86
MONOCHROME_SCALE = 0.86
SPLASH_SIZE = 480


def _square_mask(size, box, radius, ss=4):
    """Anti-aliased rounded-rect mask, drawn at `ss`x and downsampled."""
    w, h = size
    big = Image.new("L", (w * ss, h * ss), 0)
    x0, y0, x1, y1 = box
    ImageDraw.Draw(big).rounded_rectangle(
        (x0 * ss, y0 * ss, (x1 + 1) * ss - 1, (y1 + 1) * ss - 1),
        radius=radius * ss,
        fill=255,
    )
    return big.resize(size, Image.LANCZOS)


def _cut_square(src):
    """The rounded square with transparent corners, cropped and padded square."""
    rgba = src.convert("RGBA")
    rgba.putalpha(_square_mask(src.size, SQUARE, RADIUS))
    x0, y0, x1, y1 = SQUARE
    cropped = rgba.crop((x0, y0, x1 + 1, y1 + 1))
    side = max(cropped.size)
    out = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    out.paste(cropped, ((side - cropped.width) // 2, (side - cropped.height) // 2))
    return out


def _extract_mark(src):
    """The light mark on transparency, cropped tight to its content."""
    rgb = np.asarray(src.convert("RGB")).astype(np.float32)
    lum = rgb.mean(axis=2)
    alpha = np.clip((lum - LUM_LO) / (LUM_HI - LUM_LO), 0, 1)
    x0, y0, x1, y1 = SQUARE
    inner = np.asarray(
        _square_mask(
            src.size,
            (x0 + EDGE_MARGIN, y0 + EDGE_MARGIN, x1 - EDGE_MARGIN, y1 - EDGE_MARGIN),
            RADIUS - EDGE_MARGIN,
        )
    ).astype(np.float32) / 255
    alpha *= inner
    rgba = np.dstack([rgb, alpha * 255]).astype(np.uint8)
    mark = Image.fromarray(rgba, "RGBA")
    return mark.crop(mark.getchannel("A").getbbox())


def _place(mark, scale, monochrome=False):
    longer = max(mark.size)
    factor = CANVAS * scale / longer
    resized = mark.resize(
        (round(mark.width * factor), round(mark.height * factor)), Image.LANCZOS
    )
    if monochrome:
        white = Image.new("RGBA", resized.size, (255, 255, 255, 255))
        white.putalpha(resized.getchannel("A"))
        resized = white
    out = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
    out.paste(
        resized,
        ((CANVAS - resized.width) // 2, (CANVAS - resized.height) // 2),
        resized,
    )
    return out


def background_hex(src):
    """Median colour of the square's dark background, for the adaptive icon."""
    rgb = np.asarray(src.convert("RGB")).astype(int)
    x0, y0, x1, y1 = SQUARE
    region = rgb[y0 + EDGE_MARGIN : y1 - EDGE_MARGIN, x0 + EDGE_MARGIN : x1 - EDGE_MARGIN]
    dark = region[region.mean(axis=2) < LUM_LO]
    r, g, b = np.median(dark, axis=0).astype(int)
    return f"#{r:02X}{g:02X}{b:02X}"


def main():
    src = Image.open(SOURCE)
    square = _cut_square(src)
    mark = _extract_mark(src)

    square.resize((CANVAS, CANVAS), Image.LANCZOS).save("icon.png")
    _place(mark, FOREGROUND_SCALE).save("icon_foreground.png")
    _place(mark, MONOCHROME_SCALE, monochrome=True).save("icon_monochrome.png")
    square.resize((SPLASH_SIZE, SPLASH_SIZE), Image.LANCZOS).save("splash_logo.png")
    print("Wrote icon.png, icon_foreground.png, icon_monochrome.png, splash_logo.png")
    print("Adaptive background colour:", background_hex(src))


if __name__ == "__main__":
    main()
