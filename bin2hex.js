const binFile = process.argv[2];
const hexFile = process.argv[3];
const HEX_SEPARATOR = ',';
const HEX_PREFIX = '$'; // '0x'
const LINE_PREFIX = ''; // '\t.byte '
const LINE_SEPARATOR = '\n';
const BYTES_PER_GLYPH = 8;
const fs = require('fs');
const bytes = fs.readFileSync(binFile);
const hexLines = [];
const hexes = [];
for (let i = 0; i < bytes.length; i += BYTES_PER_GLYPH) {
    hexes.push(LINE_PREFIX);
    for (let j = 0; j < BYTES_PER_GLYPH; j += 1) {
        const hex = HEX_PREFIX + bytes[i + j].toString(16).padStart(2, '0');
        hexes.push(hex);
    }
    hexLines.push(hexes.join(HEX_SEPARATOR) + HEX_SEPARATOR);
    hexes.length = 0;
}
fs.writeFileSync(hexFile, hexLines.join(LINE_SEPARATOR) + LINE_SEPARATOR);