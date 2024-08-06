import fs from 'node:fs';
import { parseRawFont } from './font.mjs';

function convertBitmapToAsc(bitmap, on = '#', off = '-') {
  return bitmap
    .map((row) => row.join(''))
    .join('\n')
    .replaceAll('0', off)
    .replaceAll('1', on);
}

const binFile = process.argv[2] || 'font.bin';
const data = fs.readFileSync(binFile);
const rawFont = parseRawFont({ data, width: 7, height: 8 });

console.log(rawFont.glyphs.map((glyph, i) => i + ':\n' + convertBitmapToAsc(glyph.bitmap)).join('\n\n'));
