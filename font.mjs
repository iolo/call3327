import fs from 'node:fs';

// 128*7*8 -> [128*1*8] -> [128][8][8]
// 128*14*16 -> [128*2*16] -> [128][16][16]
export function parseRawFont({ data, width = 8, height = 8 }) {
  const bytesPerRow = Math.floor((width + 8 - 1) / 8);
  const bytesPerGlyph = bytesPerRow * height;
  const glyphs = [];
  for (let i = 0; i < data.length; i += bytesPerGlyph) {
    const bitmap = [];
    for (let y = 0; y < height; y += 1) {
      const bits = [];
      for (let x = 0; x < width; x += 1) {
        const byteIndex = i + Math.floor(x / 8) + y * bytesPerRow;
        const bitIndex = 7 - (x % 8);
        const byte = data[byteIndex];
        const bit = (byte >> (7 - bitIndex)) & 1;
        bits.push(bit);
      }
      bitmap.push(bits);
    }
    glyphs.push({ width, height, bitmap });
  }
  return { width, height, bytesPerRow, bytesPerGlyph, glyphs };
}

export function generateBdfFont({
  foundary = 'misc',
  family = 'call3327',
  weight = 'medium',
  slant = 'r',
  setWidth = 'normal',
  addStyle = '',
  pixelSize = 8,
  pointSize = 80,
  resolutionX = 96,
  resolutionY = 96,
  spacing = 'c',
  averageWidth = 80,
  charsetRegistry = 'iso10646',
  charsetEncoding = '1',
  fontBoundingBox = [7, 8, 0, 0],
  fontAscent = 8,
  fontDescent = 0,
  chars,
}) {
  const font =
    '-' +
    [
      foundary,
      family,
      weight,
      slant,
      setWidth,
      addStyle,
      pixelSize,
      pointSize,
      resolutionX,
      resolutionY,
      spacing,
      averageWidth,
      charsetRegistry,
      charsetEncoding,
    ].join('-');
  return `STARTFONT 2.1
FONT ${font}
SIZE ${pixelSize} ${resolutionX} ${resolutionY}
FONTBOUNDINGBOX ${fontBoundingBox.join(' ')}
STARTPROPERTIES 2
FONT_ASCENT ${fontAscent}
FONT_DESCENT ${fontDescent}
ENDPROPERTIES
CHARS ${chars.length}
${chars.join('\n')}
ENDFONT
`;
}

export function generateBdfChar(glyph, { encoding, swidth = [1000, 0], dwidth = [7, 0], bbx = [7, 8, 0, 0] }) {
  const width = bbx[0];
  const height = bbx[1];
  const bytesPerRow = Math.floor((width + 8 - 1) / 8);
  const bytesPerGlyph = bytesPerRow * height;
  const bitmap = glyph.bitmap
    .map((bits) =>
      parseInt(bits.join(''), 2)
        .toString(16)
        .toUpperCase()
        .padStart(bytesPerRow * 2, '0')
    )
    .join('\n');
  return `STARTCHAR U+${encoding.toString(16).padStart(4, '0')}
ENCODING ${encoding}
SWIDTH ${swidth.join(' ')}
DWIDTH ${dwidth.join(' ')}
BBX ${bbx.join(' ')}
BITMAP
${bitmap}
ENDCHAR
`;
}

// CALL3327 글꼴에서 한글 자모 글꼴 인덱스
export const JAMO = {
  // 받침없는 글자 세로모음 연장 글꼴 & 받침있는 글자의 가로모음 글꼴
  A2: 1, // ㅏ
  AE2: 2, // ㅐ
  YA2: 3, // ㅑ
  YE2: 4, // ㅒ
  EO2: 5, // ㅓ
  E2: 6, // ㅔ
  YEO2: 7, // ㅕ
  YAEO2: 8, // ㅖ
  O2: 9, // ㅗ
  YO2: 0xa, // ㅛ
  U2: 0xb, // ㅜ
  YU2: 0xc, // ㅠ
  EU2: 0xd, // ㅡ
  YI2: 0xe, // ㅣ
  // 가로모음이 없는 글자의 종성복자음
  G_S: 0xf, // ㄳ
  N_J: 0x10, // ㄵ
  N_H: 0x11, // ㄶ
  R_G: 0x12, // ㄺ
  R_M: 0x13, // ㄻ
  R_B: 0x14, // ㄼ
  R_S: 0x15, // ㄽ
  R_T: 0x16, // ㄾ
  R_P: 0x17, // ㄿ
  B_S: 0x19, // ㅄ
  // 기본 자모음 글꼴
  G: 0x5e, // ㄱ
  G_G: 0x5f, // ㄲ
  N: 0x60, // ㄴ
  D: 0x61, // ㄷ
  D_D: 0x62, // ㄸ
  R: 0x63, // ㄹ
  M: 0x64, // ㅁ
  B: 0x65, // ㅂ
  B_B: 0x66, // ㅃ
  S: 0x67, // ㅅ
  S_S: 0x68, // ㅆ
  NG: 0x69, // ㅇ
  J: 0x6a, // ㅈ
  J_J: 0x6b, // ㅉ
  C: 0x6c, // ㅊ
  K: 0x6d, // ㅋ
  T: 0x6e, // ㅌ
  P: 0x6f, // ㅍ
  H: 0x70, // ㅎ
  A: 0x71, // ㅏ
  AE: 0x72, // ㅐ
  YA: 0x73, // ㅑ
  YAE: 0x74, // ㅒ
  EO: 0x75, // ㅓ
  E: 0x76, // ㅔ
  YEO: 0x77, // ㅕ
  YAEO: 0x78, // ㅖ
  O: 0x79, // ㅗ
  YO: 0x7a, // ㅛ
  U: 0x7b, // ㅜ
  YU: 0x7c, // ㅠ
  EU: 0x7d, // ㅡ
  YI: 0x7e, // ㅣ
};

/*
- 초성 1벌: 좌표 0,0
- 중성 2벌
  - 종성 없음: 가로모음은 초성 아래에. 세로모음은 초성 옆에. 세로모음 연장. ex 가, 고, 과
  - 종성 있음: 가로모음은 초성과 겹칩. 세로모음은 초성 옆에. ex 곡, 곽, 곿
- 종성 2벌
  - 세로모음 없음: 한칸짜리 복자음 종성 사용. ex. 곡, 곣
  - 세로모음 있음: 두칸짜리 복자음 종성 사용. ex. 각, 갃, 곿
*/

// 초성
// 유니코드 한글 자모 코드 -> 글꼴 인덱스
// U+1100~U+1112
// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19
// NA ㄱ ㄲ ㄴ ㄷ ㄸ ㄹ ㅁ ㅂ ㅃ ㅅ ㅆ ㅇ ㅈ ㅉ ㅊ ㅋ ㅌ ㅍ ㅎ
export const CHOSEONG = [
  JAMO.G,
  JAMO.G_G,
  JAMO.N,
  JAMO.D,
  JAMO.D_D,
  JAMO.R,
  JAMO.M,
  JAMO.B,
  JAMO.B_B,
  JAMO.S,
  JAMO.S_S,
  JAMO.NG,
  JAMO.J,
  JAMO.J_J,
  JAMO.C,
  JAMO.K,
  JAMO.T,
  JAMO.P,
  JAMO.H,
];

const CHOSEONG_BEGIN = 0x1100;
const CHOSEONG_END = 0x1112;
const CHOSEONG_COUNT = CHOSEONG_END - CHOSEONG_BEGIN + 1; // 19

function generateChoseongGlyphs() {
  const outputGlyphs = [];
  for (let i = 0; i < CHOSEONG_COUNT; i += 1) {
    const code = CHOSEONG_BEGIN + i;
    const bitmap = inputGlyphs[CHOSUNG[i]];
    console.log(`${i}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
    glyphs.push(generateBdfChar({ encoding, swidth: [1000, 0], dwidth: [7, 0], bbx: [7, 8, 0, 0], bitmap }));
  }
  return outputGlyphs;
}

// 중성
// 유니코드 한글 자모 코드 -> 글꼴 인덱스
// U+1161~U+1175
// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21
// NA ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅛ ㅜ ㅠ ㅡ ㅣ ㅘ ㅙ ㅚ ㅝ ㅞ ㅟ ㅢ
export const JUNGSEONG = [
  // 종성이 있는 경우
  // 가로모음은 초성과 겹침
  JAMO.A,
  JAMO.AE,
  JAMO.YA,
  JAMO.YE,
  JAMO.EO,
  JAMO.E,
  JAMO.YEO,
  JAMO.YAE,
  JAMO.O2,
  JAMO.YO2,
  JAMO.U2,
  JAMO.YU2,
  JAMO.EU2,
  JAMO.YI2,
  // 복모음
  [JAMO.O2, JAMO.A],
  [JAMO.O2, JAMO.AE],
  [JAMO.O2, JAMO.YI],
  [JAMO.U2, JAMO.EO],
  [JAMO.U2, JAMO.E],
  [JAMO.U2, JAMO.YI],
  [JAMO.EU2, JAMO.YI],
];

// 종성이 없는 경우
// 세로모음은 연장 글꼴 사용
const JUNGSEONG_2 = [
  [JAMO.A, JAMO.A2],
  [JAMO.AE, JAMO.AE2],
  [JAMO.YA, JAMO.YA2],
  [JAMO.YE, JAMO.YE2],
  [JAMO.EO, JAMO.EO2],
  [JAMO.E, JAMO.E2],
  [JAMO.YEO, JAMO.YEO2],
  [JAMO.YAE, JAMO.YAE2],
  [JAMO.O],
  [JAMO.YO],
  [JAMO.U],
  [JAMO.YU],
  // 복모음
  [JAMO.O, JAMO.A, JAMO.A2],
  [JAMO.O, JAMO.AE, JAMO.AE2],
  [JAMO.O, JAMO.YI, JAMO.YI2],
  [JAMO.U, JAMO.EO, JAMO.EO2],
  [JAMO.U, JAMO.E, JAMO.EO],
  [JAMO.U, JAMO.YI, JAMO.YI2],
  [JAMO.EU, JAMO.YI, JAMO.YI2],
];

const JUNGSEONG_BEGIN = 0x1161;
const JUNGSEONG_END = 0x1175;
const JUNGSEONG_COUNT = JUNGSEONG_END - JUNGSEONG_BEGIN + 1; // 21

function generateJungseongGlyphs() {
  for (let i = 0; i < JUNGSEONG_COUNT; i += 1) {
    const code = JUNGSEONG_BEGIN + i;
    console.log(`${i}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
  }
}

// 종성
// 유니코드 한글 자모 코드 -> 글꼴 인덱스
// U+11A8~U+11C2
// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27
// NA ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ
const JONGSEONG = [
  // 세로모음 없음
  // 한칸짜리 종성 사용
  [JAMO.G],
  [JAMO.G, JAMO.G],
  [JAMO.G, JAMO.S],
  [JAMO.N],
  [JAMO.N, JAMO.J],
  [JAMO.N, JAMO.H],
  [JAMO.D],
  [JAMO.R],
  [JAMO.R, JAMO.G],
  [JAMO.R, JAMO.M],
  [JAMO.R, JAMO.B],
  [JAMO.R, JAMO.S],
  [JAMO.R, JAMO.T],
  [JAMO.R, JAMO.P],
  [JAMO.B, JAMO.S],
  [JAMO.M],
  [JAMO.B],
  [JAMO.B, JAMO.S],
  [JAMO.S],
  [JAMO.S, JAMO.S],
  [JAMO.NG],
  [JAMO.J],
  [JAMO.C],
  [JAMO.K],
  [JAMO.T],
  [JAMO.P],
  [JAMO.H],
];

// 세로모음 있음
const JONGSEONG_2 = [
  JAMO.G,
  JAMO.G_G,
  JAMO.G_S,
  JAMO.N,
  JAMO.N_J,
  JAMO.N_H,
  JAMO.D,
  JAMO.R,
  JAMO.R_G,
  JAMO.R_M,
  JAMO.R_B,
  JAMO.R_S,
  JAMO.R_T,
  JAMO.R_P,
  JAMO.B_S,
  JAMO.M,
  JAMO.B,
  JAMO.B_S,
  JAMO.S,
  JAMO.S_S,
  JAMO.NG,
  JAMO.J,
  JAMO.C,
  JAMO.K,
  JAMO.T,
  JAMO.P,
  JAMO.H,
];

const JONGSEONG_BEGIN = 0x11a8;
const JONGSEONG_END = 0x11c2;
const JONGSEONG_COUNT = JONGSEONG_END - JONGSEONG_BEGIN + 1; // 27

function generateJongseongGlyphs() {
  for (let i = 0; i < JONGSEONG_COUNT; i += 1) {
    const code = JONGSEONG_BEGIN + i;
    console.log(`${i}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
  }
}

const SYLLABLE_BEGIN = 0xac00;
const SYLLABLE_END = 0xd7a3;
// 11172 = 19 * 21 * (27 + 1)
const SYLLABLE_COUNT = CHOSEONG_COUNT * JUNGSEONG_COUNT * (JONGSEONG_COUNT + 1);

function generateSyllableGlyphs() {
  for (let cho = 0; cho < CHOSEONG_COUNT; cho += 1) {
    for (let jung = 0; jung < JUNGSEONG_COUNT; jung += 1) {
      generateSyllableGlyph(cho, jung, -1);
      for (let jong = 0; jong < JONGSEONG_COUNT; jong += 1) {
        generateSyllableGlyph(cho, jung, jong);
      }
    }
  }
}

function generateSyllableGlyph(cho, jung, jong) {
  const code =
    SYLLABLE_BEGIN + cho * JUNGSEONG_COUNT * (JONGSEONG_COUNT + 1) + jung * (JONGSEONG_COUNT + 1) + (jong + 1);
  const buf = [];
  buf.push(code.toString(16));
  buf.push('[' + String.fromCharCode(code) + ']');
  buf.push('[' + String.fromCharCode(CHOSEONG_BEGIN + cho) + ']');
  buf.push('[' + String.fromCharCode(JUNGSEONG_BEGIN + jung) + ']');
  if (jong >= 0) {
    buf.push('[' + String.fromCharCode(JONGSEONG_BEGIN + jong) + ']');
  }
  console.log(buf.join(':'));
}
