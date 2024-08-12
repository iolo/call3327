import fs from 'node:fs';
import { bitmapToAscii, parseRawFont } from './font.mjs';

const binFile = process.argv[2] || 'font.bin';
const font = parseRawFont(fs.readFileSync(binFile));

for (const glyph of font.glyphs) {
  console.log(glyph.code + ':');
  console.log(bitmapToAscii(glyph.bitmap).join('\n'));
}
//console.log(font.glyphs.map((glyph, i) => i + ':\n' + bitmapToAscii(glyph.bitmap).join('\n')));
