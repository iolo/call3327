const BYTES_PER_GLYPH = 8;
const ON = '#';
const OFF = '.';
const binFile = process.argv[2];//'fonts.bin';
const fs = require('fs');
const data = fs.readFileSync(binFile);
for (let i = 0; i < data.length; i += BYTES_PER_GLYPH) {
    console.log("Glyph " + (i / BYTES_PER_GLYPH));
    for (let j = 0; j < BYTES_PER_GLYPH; j += 1) {
        const byte = data[i + j].toString(2).padStart(8, '0');
        const bitmap = byte.split('').reverse().map(bit => bit === '0' ? OFF : ON).join('');
        console.log(bitmap);
    }
    console.log("");
}
