import fs from 'node:fs';

// 128*7*8 -> [128*1*8] -> [128][8][8]
// 128*14*16 -> [128*2*16] -> [128][16][16]
export function parseRawFont({ data, width = 8, height = 8 }) {
  const bytesPerRow = Math.floor((width + 8 - 1) / 8);
  const bytesPerGlyph = bytesPerRow * height;
  const glyphs = [];
  for (let i = 0, code = 0; i < data.length; i += bytesPerGlyph, code += 1) {
    const bitmap = [];
    for (let y = 0; y < height; y += 1) {
      const bits = [];
      for (let x = 0; x < width; x += 1) {
        const byteIndex = i + y * bytesPerRow + Math.floor(x / 8);
        const bitIndex = 7 - (x % 8);
        const byte = data[byteIndex];
        const bit = (byte >> (7 - bitIndex)) & 1;
        bits.push(bit);
      }
      bitmap.push(bits);
    }
    glyphs.push({ code, width, height, bitmap });
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
  YAE2: 4, // ㅒ
  EO2: 5, // ㅓ
  E2: 6, // ㅔ
  YEO2: 7, // ㅕ
  YE2: 8, // ㅖ
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
  YE: 0x78, // ㅖ
  O: 0x79, // ㅗ
  YO: 0x7a, // ㅛ
  U: 0x7b, // ㅜ
  YU: 0x7c, // ㅠ
  EU: 0x7d, // ㅡ
  YI: 0x7e, // ㅣ
};

// 초성
// 유니코드 한글 자모 코드 -> 글꼴 인덱스
// U+1100~U+1112
const CHOSEONG_BEGIN = 0x1100;
const CHOSEONG_END = 0x1112;
const CHOSEONG_COUNT = CHOSEONG_END - CHOSEONG_BEGIN + 1; // 19

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

export function generateChoseongGlyphs(font) {
  console.log('generate choseong glyphs...');
  const glyphs = [];
  for (let cho = 0; cho < CHOSEONG_COUNT; cho += 1) {
    const code = CHOSEONG_BEGIN + cho;
    console.log(`${cho}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
    const bitmap = font.glyphs[CHOSEONG[cho]].bitmap;
    glyphs.push({ code, width: 7, height: 8, bitmap });
  }
  return glyphs;
}

// 중성
// 유니코드 한글 자모 코드 -> 글꼴 인덱스
// U+1161~U+1175
const JUNGSEONG_BEGIN = 0x1161;
const JUNGSEONG_END = 0x1175;
const JUNGSEONG_COUNT = JUNGSEONG_END - JUNGSEONG_BEGIN + 1; // 21

// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20
// ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ ㅣ

function isVerticalVowel(jung) {
  return jung <= 7 && jung == 20;
}

function isHorizontalVowel(jung) {
  return jung == 8 || jung == 12 || jung == 13 || jung == 17 || jung == 18;
}

function isCompoundVowel(jung) {
  return jung == 9 || jung == 10 || jung == 11 || jung == 14 || jung == 15 || jung == 16 || jung == 19;
}

// 세로모음: 0=종성있는 글자용 세로모음, 1=종성없는 글자용 연장 세로모음
// 가로모음: 0=종성없는 글자용 가로모음, 1=종성있는 글자용 가로모음
// 복모음: 0=종성없는 글자용 가로모음, 1=종성있는 글자용 세로모음, 2=종성있는글자용 가로모음, 3=종성없는 글자용 연장 세로모음
export const JUNGSEONG = [
  [JAMO.A, JAMO.A2],
  [JAMO.AE, JAMO.AE2],
  [JAMO.YA, JAMO.YA2],
  [JAMO.YAE, JAMO.YAE2],
  [JAMO.EO, JAMO.EO2],
  [JAMO.E, JAMO.E2],
  [JAMO.YEO, JAMO.YEO2],
  [JAMO.YE, JAMO.YE2],
  [JAMO.O, JAMO.O2],
  [JAMO.O, JAMO.A, JAMO.O2, JAMO.A2],
  [JAMO.O, JAMO.AE, JAMO.O2, JAMO.AE2],
  [JAMO.O, JAMO.YI, JAMO.O2, JAMO.YI2],
  [JAMO.YO, JAMO.YO2],
  [JAMO.U, JAMO.U2],
  [JAMO.U, JAMO.EO, JAMO.U2, JAMO.EO2],
  [JAMO.U, JAMO.E, JAMO.U2, JAMO.EO],
  [JAMO.U, JAMO.YI, JAMO.U2, JAMO.YI2],
  [JAMO.YU, JAMO.YU2],
  [JAMO.EU, JAMO.EU2],
  [JAMO.EU, JAMO.YI, JAMO.EU2, JAMO.YI2],
  [JAMO.YI, JAMO.YI2],
];

export function generateJungseongGlyphs(font) {
  console.log('generate jungseong glyphs...');
  const glyphs = [];
  for (let jung = 0; jung < JUNGSEONG_COUNT; jung += 1) {
    const code = JUNGSEONG_BEGIN + jung;
    console.log(`${jung}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
    const glyphSet = JUNGSEONG[jung];
    let glyph;
    if (isCompoundVowel(jung)) {
      // 복모음: 종성있는 글자용 가로모음 + 종성있는 글자용 세로모음
      const bitmap = [];
      for (let y = 0; y < 8; y += 1) {
        bitmap[y] = [];
        for (let x = 0; x < 7; x += 1) {
          bitmap[y].push(font.glyphs[glyphSet[2]].bitmap[y][x] | font.glyphs[glyphSet[1]].bitmap[y][x]);
        }
      }
      glyph = { code, width: 14, height: 8, bitmap };
    } else {
      console.log(glyphSet);
      // 단모음: 종성있는 글자용 세로모음 or 종성없는 글자용 가로모음
      const bitmap = font.glyphs[glyphSet[0]].bitmap;
      glyph = { code, width: 7, height: 8, bitmap };
    }
    glyphs.push(glyph);
  }
  return glyphs;
}

// 종성
// 유니코드 한글 자모 코드 -> 글꼴 인덱스
// U+11A8~U+11C2
const JONGSEONG_BEGIN = 0x11a8;
const JONGSEONG_END = 0x11c2;
const JONGSEONG_COUNT = JONGSEONG_END - JONGSEONG_BEGIN + 1; // 27

// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
// ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ
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

export function generateJongseongGlyphs() {
  console.log('generate jongseong glyphs...');

  for (let jong = 0; jong < JONGSEONG_COUNT; jong += 1) {
    const code = JONGSEONG_BEGIN + jong;
    console.log(`${jong}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
  }
}

const SYLLABLE_BEGIN = 0xac00;
const SYLLABLE_END = 0xd7a3;
// 11172 = 19 * 21 * (27 + 1)
const SYLLABLE_COUNT = CHOSEONG_COUNT * JUNGSEONG_COUNT * (JONGSEONG_COUNT + 1);

export function generateSyllableGlyphs() {
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
  const bitmap = [];
  if (isVerticalVowel(jung)) {
  }
  // 14x16 or 7x16
  buf.push(code.toString(16));
  buf.push('[' + String.fromCharCode(code) + ']');
  buf.push('[' + String.fromCharCode(CHOSEONG_BEGIN + cho) + ']');
  buf.push('[' + String.fromCharCode(JUNGSEONG_BEGIN + jung) + ']');
  if (jong >= 0) {
    buf.push('[' + String.fromCharCode(JONGSEONG_BEGIN + jong) + ']');
  }
  console.log(buf.join(':'));
}
