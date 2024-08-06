import fs from 'node:fs';
import { parseRawFont, generateBdfChar, generateBdfFont } from './font.mjs';

const binFile = process.argv[2] || 'font.bin';
const bdfFile = process.argv[3] || 'font.bdf';

const data = fs.readFileSync(binFile);
const rawFont = parseRawFont({ data, width: 8, height: 8 });

const chars = rawFont.glyphs.map((glyph, i) => {
  return generateBdfChar(glyph, {
    encoding: i,
    swidth: [1000, 0],
    dwidth: [7, 0],
    bbx: [7, 8, 0, 0],
  });
});

fs.writeFileSync(
  bdfFile,
  generateBdfFont({
    pixelSize: 8,
    pointSize: 80,
    averageWidth: 70,
    size: [8, 96, 96],
    fontBoundingBox: [7, 8, 0, 0],
    fontAscent: 8,
    fontDescent: 0,
    chars,
  })
);
