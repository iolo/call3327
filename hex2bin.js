const HEX_PREFIX = '$'; // '0x'
const HEX_SEPARATOR = ',';
const hexFile = process.argv[2]; // 'font.hex'
const binFile = process.argv[3]; // 'font.bin'
const fs = require('fs');
const data = fs.readFileSync(hexFile,'utf8');
const hexes = data.split(HEX_SEPARATOR);
const bytes = [];
for (let i = 0; i < hexes.length; i+= 1) {
  const byte = parseInt(hexes[i].trim().substring(HEX_PREFIX.length), 16);
  if (!Number.isNaN(byte)) {
    bytes.push(byte);
  }
}
fs.writeFileSync(binFile, Buffer.from(bytes));