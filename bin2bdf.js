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
FONT -misc-call3327-medium-r-normal--8-80-96-96-c-80-iso10646-1
SIZE 8 96 96
FONTBOUNDINGBOX 7 8 0 0
STARTPROPERTIES 2
FONT_ASCENT 8
FONT_DESCENT 0
ENDPROPERTIES
CHARS ${chars}
`;

// Convert each byte to BDF glyph
for (let i = 0; i < data.length; i += BYTES_PER_GLYPH) {
  let bitmaps = [];
  for (let j = 0; j < BYTES_PER_GLYPH; j += 1) {
    const byte = data[i + j].toString(2).padStart(8, '0');
    const bitmap = parseInt(byte.split('').reverse().join(''), 2)
        .toString(16).padStart(2, '0').toUpperCase();
    bitmaps.push(bitmap);
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
DWIDTH 7 0
BBX 7 8 0 0
BITMAP
${bitmaps.join('\n')}
ENDCHAR
`;
}

bdfContent += 'ENDFONT\n';

// Write BDF file
fs.writeFileSync(bdfFile, bdfContent);
