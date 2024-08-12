import fs from 'node:fs';
import {
  parseRawFont,
  generateUnicodeGlyphs,
  initBitmap,
  scaleBitmap,
  generateBdfChar,
  generateBdfFont,
} from './font.mjs';

const binFile = process.argv[2] || 'font.bin';
const bdfFile = process.argv[3] || 'font2s.bdf';
const romFile = process.argv[4] || 'apple2e-rom-font.bin';

const font = parseRawFont(fs.readFileSync(binFile));

const romFont = parseRawFont(fs.readFileSync(romFile));

const glyphs = generateUnicodeGlyphs(font, romFont);

// scale 2x with scanline
for (const glyph of glyphs) {
  const bitmap = initBitmap(glyph.width * 2, glyph.height * 2);
  scaleBitmap(glyph.bitmap, glyph.width, glyph.height, bitmap, 0, 0, 2, 2, 1);
  glyph.bitmap = bitmap;
  glyph.width = glyph.width * 2;
  glyph.height = glyph.height * 2;
}

fs.writeFileSync(
  bdfFile,
  generateBdfFont({
    family: 'CALL3327_2s',
    pixelSize: 32,
    pointSize: 320,
    averageWidth: 140,
    size: [32, 75, 75],
    fontBoundingBox: [14, 32, 0, 0],
    fontAscent: 32,
    fontDescent: 0,
    chars: glyphs.map((glyph) => generateBdfChar(glyph, { swidth: [glyph.width > 14 ? 1000 : 500] })),
  })
);
