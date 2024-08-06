import fs from 'node:fs';
import {
  parseRawFont,
  generateBdfChar,
  generateBdfFont,
  generateChoseongGlyphs,
  generateJungseongGlyphs,
} from './font.mjs';

const binFile = process.argv[2] || 'font.bin';
const bdfFile = process.argv[3] || 'font.bdf';

const data = fs.readFileSync(binFile);
const font = parseRawFont({ data, width: 8, height: 8 });

const chars = font.glyphs.concat(generateChoseongGlyphs(font), generateJungseongGlyphs(font)).map((glyph) => {
  return generateBdfChar(glyph, {
    encoding: glyph.code,
    swidth: [1000, 0],
    dwidth: [glyph.width, 0],
    bbx: [glyph.width, glyph.height, 0, 0],
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
