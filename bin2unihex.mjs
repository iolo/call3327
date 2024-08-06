import fs from 'node:fs';
import { parseRawFont, generateBdfChar, generateBdfFont } from './font.mjs';

const binFile = process.argv[2] || 'font.bin';
const hexFile = process.argv[3] || 'unifont.hex';

const data = fs.readFileSync(binFile);
const rawFont = parseRawFont({ data, width: 7, height: 8 });

function generateHexFont() {
  return rawFont.glyphs
    .map((glyph, i) => {
      const line = [];
      line.push(i.toString().toUpperCase().padStart(4, '0'));
      line.push(':');
      for (let y = 0; y < glyph.height; y += 1) {
        line.push(
          parseInt(glyph.bitmap[y].join(''), 2)
            .toString(16)
            .toUpperCase()
            .padStart(rawFont.bytesPerRow * 2, '0')
        );
      }
      return line.join('');
    })
    .join('\n');
}

fs.writeFileSync(hexFile, generateHexFont());
