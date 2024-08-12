import fs from 'node:fs';
import { parseRawFont, generateUnicodeGlyphs, generateBdfChar, generateBdfFont } from './font.mjs';

const binFile = process.argv[2] || 'font.bin';
const bdfFile = process.argv[3] || 'font.bdf';
const romFile = process.argv[4] || 'apple2e-rom-font.bin';

const font = parseRawFont(fs.readFileSync(binFile));
const romFont = parseRawFont(fs.readFileSync(romFile));

const glyphs = generateUnicodeGlyphs(font, romFont);

fs.writeFileSync(
  bdfFile,
  generateBdfFont({
    pixelSize: 16,
    pointSize: 160,
    averageWidth: 140,
    size: [16, 75, 75],
    fontBoundingBox: [14, 16, 0, 0],
    fontAscent: 15,
    fontDescent: 1,
    chars: glyphs.map(generateBdfChar),
  })
);
