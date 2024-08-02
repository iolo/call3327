const fs = require('fs');

const BYTES_PER_GLYPH = 8;

// Read binary file
const binFile = process.argv[2];
const bdfFile = process.argv[3];
const data = fs.readFileSync(binFile);

const chars =  data.length / BYTES_PER_GLYPH;
// Initialize BDF file content with font metadata
let bdfContent = `
STARTFONT 2.1
FONT -misc-call3327-medium-r-normal--16-160-75-75-c-160-iso10646-1
SIZE 16 96 96
FONTBOUNDINGBOX 16 16 0 0
STARTPROPERTIES 2
FONT_ASCENT 16
FONT_DESCENT 0
ENDPROPERTIES
CHARS ${chars}
`;

// Convert each byte to BDF glyph
for (let i = 0; i < data.length; i += BYTES_PER_GLYPH) {
  let bitmaps = [];
  console.log('-------' + String(i/8) + '--->' + String.fromCharCode(i/8));
  for (let j = 0; j < BYTES_PER_GLYPH; j += 1) {
    // byte to word = emit dots twice = horizontally scale 2x
    const byte = data[i + j];
    let word = 0;
    for (let k = 0; k < 7; k += 1) {
      const bit = byte & (0x01 << k);
      word <<= 2;
      if (bit) {
        word |= 0b11;
      }
    }
    if (byte & 0x80) {
      // half dot shift
      word <<= 1;
    } else {
      // full dot
      word <<= 2;
    }

    const bin = word.toString(2).padStart(16, '0').replaceAll('0', '.').replaceAll('1', '@');
    const hi = ((word >>> 8) & 0xff).toString(16).padStart(2, '0').toUpperCase();
    const lo = (word & 0xff).toString(16).padStart(2, '0').toUpperCase();
    console.log(bin, ':', hi, lo, (byte & 0x80) ? 'half' : '');

    // emit row
    bitmaps.push(hi);
    bitmaps.push(lo);
    // emit empty row = mimic scanline
    bitmaps.push('00');
    bitmaps.push('00');
  }
  // pixels = (swidth / 1000) * (resolution / 72)
  // resolution = 75 =~ 72, resolution / 72 = 1.0416666666666667 =~ 1
  // 500 / 1000 * 1 = 0.5,
  // 0.5 * globalWidth = 0.5 * 16 = 8 pixels
  const encoding = i / 8;
  bdfContent += `
STARTCHAR U+${encoding.toString(16).padStart(4, '0')}
ENCODING ${encoding}
SWIDTH 1000 0
DWIDTH 16 0
BBX 16 16 0 0
BITMAP
${bitmaps.join('\n')}
ENDCHAR
`;
}

bdfContent += 'ENDFONT\n';

// Write BDF file
fs.writeFileSync(bdfFile, bdfContent);
