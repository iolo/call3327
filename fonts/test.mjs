import { initBitmap, scaleBitmap, asciiToBitmap, bitmapToAscii, parseRawFont } from './font.mjs';

//const b1 = initBitmap(16, 16);
const b1 = [
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
  [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
  [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
  [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
  [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
  [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
  [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
];
const b2 = initBitmap(32, 32);
//drawBitmap(b1, 7, 8, b2, 0, 0);
scaleBitmap(b1, 16, 16, b2, 0, 0, 2, 2, 1);
//console.log(b1);
console.log(bitmapToAscii(b1).join('\n'));
//console.log(b2);
console.log(bitmapToAscii(b2).join('\n'));


function testAll(str) {
  console.log(str);
  const data = asciiToBitmap(str);
  console.log(data);
  const font = parseRawFont(data, 7, 8);
  console.log(font);
  console.log(bitmapToAscii(font.glyphs[0].bitmap).join('\n'));
}

testAll([
`0--#####`,
`0-#-----`,
`0#------`,
`0-####--`,
`0-----#-`,
`0------#`,
`0-----#-`,
`0#####--`
]);
testAll([
`--#####0`,
`-#-----0`,
`#------0`,
`-####--0`,
`-----#-0`,
`------#0`,
`-----#-0`,
`#####--0`
]);
