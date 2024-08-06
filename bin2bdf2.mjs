import fs from 'node:fs';
import { parseRawFont, generateBdfChar, generateBdfFont } from './font.mjs';

const binFile = process.argv[2] || 'font.bin';
const bdfFile = process.argv[3] || 'font2.bdf';

const data = fs.readFileSync(binFile);
const rawFont = parseRawFont({ data, width: 8, height: 8 });

const chars = rawFont.glyphs.map((glyph, i) => {
  const width = 14;//glyph.width * 2;
  const height = 16;//glyph.height * 2;
  const bitmap = [];
  for (let y = 0; y < glyph.height; y += 1) {
    const bits = [];
    for (let x = 0; x < glyph.width; x += 1) {
      const bit = glyph.bitmap[y][x];
      bits.push(bit);
      // 가로 2배 확대
      bits.push(bit);
    }
    bitmap.push(bits);
    // 세로 2배 확대
    bitmap.push(bits);
  }

  return generateBdfChar(
    { width, height, bitmap },
    {
      encoding: i,
      swidth: [1000, 0],
      dwidth: [width, 0],
      bbx: [width, height, 0, 0],
    }
  );
});

fs.writeFileSync(
  bdfFile,
  generateBdfFont({
    pixelSize: 16,
    pointSize: 160,
    averageWidth: 160,
    size: [16, 96, 96],
    fontBoundingBox: [14, 16, 0, 0],
    fontAscent: 16,
    fontDescent: 0,
    chars,
  })
);
