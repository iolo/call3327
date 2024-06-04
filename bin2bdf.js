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
FONT -misc-fixed-medium-r-normal--16-120-75-75-c-70-iso10646-1
SIZE 16 75 75
FONTBOUNDINGBOX 16 16 0 -2
STARTPROPERTIES 2
FONT_ASCENT 14
FONT_DESCENT 2
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
SWIDTH 500 0
DWIDTH 8 0
BBX 8 8 0 0
BITMAP
${bitmaps.join('\n')}
ENDCHAR
`;
}

bdfContent += 'ENDFONT\n';

// Write BDF file
fs.writeFileSync(bdfFile, bdfContent);