import fs from 'node:fs';

export function debug(...args) {
  console.log(...args);
}

export function initBitmap(width, height, value = 0) {
  return Array(height)
    .fill()
    .map(() => Array(width).fill(value));
}

export function drawBitmap(src, width, height, dest, destX = 0, destY = 0) {
  for (let y = 0, dy = destY; y < height; y++, dy++) {
    for (let x = 0, dx = destX; x < width; x++, dx++) {
      // always OR
      if (src[y][x]) {
        dest[dy][dx] = 1;
      }
    }
  }
}

export function scaleBitmap(src, width, height, dest, destX = 0, destY = 0, scaleX = 2, scaleY = 2, scanline = 0) {
  for (let y = 0, ny = destY; y < height; y++, ny += scaleY) {
    for (let x = 0, nx = destX; x < width; x++, nx += scaleX) {
      // always OR
      if (src[y][x]) {
        for (let sy = 0; sy < scaleY - scanline; sy++) {
          for (let sx = 0; sx < scaleX; sx++) {
            dest[ny + sy][nx + sx] = 1;
          }
        }
      }
    }
  }
}

export function asciiToBitmap(data, on = '#', off = '-') {
  return data.map((row) => parseInt(row.replaceAll(on, '1').replaceAll(off, '0'), 2));
}

export function bitmapToAscii(bitmap, on = '#', off = '-') {
  return bitmap.map((row) => row.map((bit) => (bit !== 0 ? on : off)).join(''));
}

// byte array -> 2-dim bit array
// [(1..8)x8] -> [1*8] -> [8][8]
// [(9..16)x16] -> [2*16] -> [16][16]
export function parseRawFont(data, width = 7, height = 8, halfPixel = 1) {
  const bytesPerRow = Math.floor((width + 8 - halfPixel) / 8);
  const bytesPerGlyph = bytesPerRow * height;
  const glyphs = [];
  const lsb = 0x01,
    msb = 0x80 >> halfPixel;
  for (let i = 0, code = 0; i < data.length; i += bytesPerGlyph, code++) {
    const bitmap = initBitmap(width, height);
    for (let y = 0; y < height; y++) {
      for (let xbyte = 0, x = 0; xbyte < bytesPerRow; xbyte++) {
        for (let bitmask = lsb; bitmask <= msb; bitmask <<= 1, x++) {
          if (data[i + y * bytesPerRow + xbyte] & bitmask) {
            bitmap[y][x] = 1;
          }
        }
      }
    }
    glyphs.push({ code, width, height, bitmap });
  }
  return { width, height, bytesPerRow, bytesPerGlyph, glyphs };
}

export function generateBdfFont({
  foundary = 'misc',
  family = 'CALL3327',
  weight = 'medium',
  slant = 'r',
  setWidth = 'normal',
  addStyle = '',
  pixelSize = 8,
  pointSize = 80,
  xRes = 75,
  yRes = 75,
  spacing = 'c',
  averageWidth = 70,
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
      xRes,
      yRes,
      spacing,
      averageWidth,
      charsetRegistry,
      charsetEncoding,
    ].join('-');
  return `STARTFONT 2.1
FONT ${font}
SIZE ${pixelSize} ${xRes} ${yRes}
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

export function generateBdfChar(glyph, { encoding, swidth, dwidth, bbx }) {
  const bytesPerRow = Math.floor((glyph.width + 8 - 1) / 8);
  const bytesPerGlyph = bytesPerRow * glyph.height;
  const bitmap = glyph.bitmap
    .map((bits) =>
      parseInt(bits.join('').padEnd(bytesPerRow * 8, '0', 2), 2)
        .toString(16)
        .toUpperCase()
        .padStart(bytesPerRow * 2, '0')
    )
    .join('\n');
  return `STARTCHAR U+${(encoding ?? glyph.code).toString(16).padStart(4, '0')}
ENCODING ${encoding ?? glyph.code}
SWIDTH ${(swidth ?? [glyph.width > 8 ? 1000 : 500, 0]).join(' ')}
DWIDTH ${(dwidth ?? [glyph.width, 0]).join(' ')}
BBX ${(bbx ?? [glyph.width, glyph.height, 0, 0]).join(' ')}
BITMAP
${bitmap}
ENDCHAR
`;
}

// 0xe000 ~ 0xf8ff : Private Use Area
export function generateReferenceGlyphs(font, baseCode = 0xe000) {
  return font.glyphs.map((glyph) => {
    return {
      code: glyph.code + baseCode,
      width: glyph.width,
      height: glyph.height,
      bitmap: glyph.bitmap,
    };
  });
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
  R_H: 0x18, // ㅀ
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

// 유니코드 초성 인덱스 -> 글꼴 인덱스
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
  debug('generate choseong glyphs...');
  const glyphs = [];
  for (let cho = 0; cho < CHOSEONG_COUNT; cho++) {
    const code = CHOSEONG_BEGIN + cho;
    debug(`${cho}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
    const bitmap = initBitmap(7, 16);
    drawBitmap(font.glyphs[CHOSEONG[cho]].bitmap, 7, 8, bitmap, 0, 0);
    glyphs.push({ code, width: 7, height: 16, bitmap });
  }
  return glyphs;
}

// 중성
// 유니코드 한글 자모 코드 -> 글꼴 인덱스
// U+1161~U+1175
const JUNGSEONG_BEGIN = 0x1161;
const JUNGSEONG_END = 0x1175;
const JUNGSEONG_COUNT = JUNGSEONG_END - JUNGSEONG_BEGIN + 1; // 21

// 유니코드 초성 인덱스 -> 글꼴 인덱스
// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20
// ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ ㅣ
// 세로모음: 0=세로모음, 1=연장 세로모음
// 가로모음: 0=종성없을때 가로모음, 1=종성있을때 가로모음
// 복모음: 0=종성없을때 가로모음, 1=종성있을때 가로모음, 2=세로모음, 3=연장 세로모음
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
  [JAMO.U, JAMO.E, JAMO.U2, JAMO.E2],
  [JAMO.U, JAMO.YI, JAMO.U2, JAMO.YI2],
  [JAMO.YU, JAMO.YU2],
  [JAMO.EU, JAMO.EU2],
  [JAMO.EU, JAMO.YI, JAMO.EU2, JAMO.YI2],
  [JAMO.YI, JAMO.YI2],
];

// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20
// ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ ㅣ
function isVerticalVowel(jung) {
  return jung <= 7 || jung == 20;
}

function isHorizontalVowel(jung) {
  return jung == 8 || jung == 12 || jung == 13 || jung == 17 || jung == 18;
}

function isCompoundVowel(jung) {
  return jung == 9 || jung == 10 || jung == 11 || jung == 14 || jung == 15 || jung == 16 || jung == 19;
}

export function generateJungseongGlyphs(font) {
  debug('generate jungseong glyphs...');
  const glyphs = [];
  for (let jung = 0; jung < JUNGSEONG_COUNT; jung++) {
    const code = JUNGSEONG_BEGIN + jung;
    debug(`${jung}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
    const glyphSet = JUNGSEONG[jung];
    const horizontalVowel = isHorizontalVowel(jung);
    const bitmap = initBitmap(horizontalVowel ? 7 : 14, 16);
    if (horizontalVowel) {
      // [  ]
      // [ㅗ]
      drawBitmap(font.glyphs[glyphSet[0]].bitmap, 7, 8, bitmap, 0, 8);
    } else if (isVerticalVowel(jung)) {
      // [  ][ㅏ]
      // [  ][ㅣ]
      drawBitmap(font.glyphs[glyphSet[0]].bitmap, 7, 8, bitmap, 7, 0);
      drawBitmap(font.glyphs[glyphSet[1]].bitmap, 7, 8, bitmap, 7, 8);
    } else if (isCompoundVowel(jung)) {
      // [  ][ㅏ]
      // [ㅗ][ㅣ]
      drawBitmap(font.glyphs[glyphSet[0]].bitmap, 7, 8, bitmap, 0, 8);
      drawBitmap(font.glyphs[glyphSet[1]].bitmap, 7, 8, bitmap, 7, 0);
      drawBitmap(font.glyphs[glyphSet[3]].bitmap, 7, 8, bitmap, 7, 8);
    }
    glyphs.push({ code, width: horizontalVowel ? 7 : 14, height: 16, bitmap });
  }
  return glyphs;
}

// 종성
// 유니코드 한글 자모 코드 -> 글꼴 인덱스
// U+11A8~U+11C2
const JONGSEONG_BEGIN = 0x11a8;
const JONGSEONG_END = 0x11c2;
const JONGSEONG_COUNT = JONGSEONG_END - JONGSEONG_BEGIN + 1; // 27

// 유니코드 종성 인덱스 -> 글꼴 인덱스
// 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
// ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ
const JONGSEONG = [
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
  JAMO.R_H,
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

const COMPOUND_JONGSEONG = {
  [JAMO.G_G]: [JAMO.G, JAMO.G],
  [JAMO.G_S]: [JAMO.G, JAMO.S],
  [JAMO.N_J]: [JAMO.N, JAMO.J],
  [JAMO.N_H]: [JAMO.N, JAMO.H],
  [JAMO.R_G]: [JAMO.R, JAMO.G],
  [JAMO.R_M]: [JAMO.R, JAMO.M],
  [JAMO.R_B]: [JAMO.R, JAMO.B],
  [JAMO.R_S]: [JAMO.R, JAMO.S],
  [JAMO.R_T]: [JAMO.R, JAMO.T],
  [JAMO.R_P]: [JAMO.R, JAMO.P],
  [JAMO.R_H]: [JAMO.R, JAMO.H],
  [JAMO.B_S]: [JAMO.B, JAMO.S],
  [JAMO.S_S]: [JAMO.S, JAMO.S],
};

function isComboundJongseong(jong) {
  // 쌍자음 종성(ㄲ, ㅆ)은 단자음처럼 한글자로 표시
  return jong === 2 || jong === 4 || jong === 5 || (jong >= 8 && jong <= 14) || jong === 17;
}

export function generateJongseongGlyphs(font) {
  debug('generate jongseong glyphs...');
  const glyphs = [];
  for (let jong = 0; jong < JONGSEONG_COUNT; jong++) {
    const code = JONGSEONG_BEGIN + jong;
    debug(`${jong}:${code.toString(16)}:[${String.fromCharCode(code)}]`);
    const bitmap = initBitmap(7, 16);
    drawBitmap(font.glyphs[JONGSEONG[jong]].bitmap, 7, 8, bitmap, 0, 8);
    glyphs.push({ code, width: 7, height: 16, bitmap });
  }
  return glyphs;
}

const SYLLABLE_BEGIN = 0xac00;
const SYLLABLE_END = 0xd7a3;
const SYLLABLE_COUNT = CHOSEONG_COUNT * JUNGSEONG_COUNT * (JONGSEONG_COUNT + 1); // 11172 = 19 * 21 * (27 + 1)

export function generateSyllableGlyphs(font) {
  const glyphs = [];
  for (let cho = 0; cho < CHOSEONG_COUNT; cho++) {
    for (let jung = 0; jung < JUNGSEONG_COUNT; jung++) {
      // 종성 없는 글자
      glyphs.push(generateSyllableGlyph(font, cho, jung, -1));
      for (let jong = 0; jong < JONGSEONG_COUNT; jong++) {
        // 종성 있는 글자
        glyphs.push(generateSyllableGlyph(font, cho, jung, jong));
      }
    }
  }
  return glyphs;
}

function generateSyllableGlyph(font, cho, jung, jong) {
  const code =
    SYLLABLE_BEGIN + cho * JUNGSEONG_COUNT * (JONGSEONG_COUNT + 1) + jung * (JONGSEONG_COUNT + 1) + (jong + 1);
  debug(
    [
      code.toString(16),
      '[' + String.fromCharCode(code) + ']',
      '[' + String.fromCharCode(CHOSEONG_BEGIN + cho) + ']',
      '[' + String.fromCharCode(JUNGSEONG_BEGIN + jung) + ']',
      '[' + String.fromCharCode(jong === -1 ? 0x2003 : JONGSEONG_BEGIN + jong) + ']',
    ].join(':')
  );

  const horizontalVowel = isHorizontalVowel(jung);
  const verticalVowel = isVerticalVowel(jung);
  const compoundVowel = isCompoundVowel(jung);

  // 가로모음이면 반각, 세로모음 or 복모음이면 전각
  const bitmap = initBitmap(horizontalVowel ? 7 : 14, 16);

  // 초성은 좌상귀
  drawBitmap(font.glyphs[CHOSEONG[cho]].bitmap, 7, 8, bitmap, 0, 0);

  const jungJamo = JUNGSEONG[jung];
  if (jong === -1) {
    // 종성없음
    if (horizontalVowel) {
      // [ㄱ][xx]
      // {ㅗ}[xx]
      drawBitmap(font.glyphs[jungJamo[0]].bitmap, 7, 8, bitmap, 0, 8);
    } else if (verticalVowel) {
      // [ㄱ]{ㅏ}
      // [  ][  ]
      drawBitmap(font.glyphs[jungJamo[0]].bitmap, 7, 8, bitmap, 7, 0);
      // [ㄱ][ㅏ]
      // [  ]{ㅣ}
      drawBitmap(font.glyphs[jungJamo[1]].bitmap, 7, 8, bitmap, 7, 8);
    } else if (compoundVowel) {
      // [ㄱ][ㅏ]
      // {ㅗ}[ㅣ]
      drawBitmap(font.glyphs[jungJamo[0]].bitmap, 7, 8, bitmap, 0, 8);
      // [ㄱ]{ㅏ}
      // [ㅗ][ㅣ]
      drawBitmap(font.glyphs[jungJamo[1]].bitmap, 7, 8, bitmap, 7, 0);
      // [ㄱ][ㅏ]
      // [ㅗ]{ㅣ}
      drawBitmap(font.glyphs[jungJamo[3]].bitmap, 7, 8, bitmap, 7, 8);
    }
  } else {
    // 종성있음
    if (horizontalVowel) {
      // {고}
      // [??]
      drawBitmap(font.glyphs[jungJamo[1]].bitmap, 7, 8, bitmap, 0, 0);
    } else if (verticalVowel) {
      // 우상귀
      // [ㄱ]{ㅏ}
      // [??][??]
      drawBitmap(font.glyphs[jungJamo[0]].bitmap, 7, 8, bitmap, 7, 0);
    } else if (compoundVowel) {
      // {고}[ㅏ]
      // [??][??
      drawBitmap(font.glyphs[jungJamo[2]].bitmap, 7, 8, bitmap, 0, 0);
      // [고]{ㅏ}
      // [??][??]
      drawBitmap(font.glyphs[jungJamo[1]].bitmap, 7, 8, bitmap, 7, 0);
    }

    const jongJamo = JONGSEONG[jong];
    const compoundJongseong = isComboundJongseong(jong);
    if (horizontalVowel || !compoundJongseong) {
      // 주의: 쌍자음 종성(ㄲ,ㅆ)도 단자음 종성처럼 한글자로 표시
      // [고] or [고] or [ㄱ][ㅏ] or [고][ㅏ] or [ㄱ][ㅏ] or [고][ㅏ]
      // {ㄱ}    {ㄳ}    {ㄱ}[  ]    {ㄱ}[  ]    {ㄲ}[  ]    {ㄲ}[  ]
      drawBitmap(font.glyphs[jongJamo].bitmap, 7, 8, bitmap, 0, 8);
    } else {
      const compoundJongJamo = COMPOUND_JONGSEONG[jongJamo];
      // [ㄱ][ㅏ] or [고][ㅏ]
      // {ㄱ}[ㅅ]    {ㄱ}[ㅅ]
      drawBitmap(font.glyphs[compoundJongJamo[0]].bitmap, 7, 8, bitmap, 0, 8);
      // [ㄱ][ㅏ] or [고][ㅏ]
      // [ㄱ]{ㅅ}    [ㄱ]{ㅅ}
      drawBitmap(font.glyphs[compoundJongJamo[1]].bitmap, 7, 8, bitmap, 7, 8);
    }
  }

  return { code, width: horizontalVowel ? 7 : 14, height: 16, bitmap };
}

// APPLE //e & //c && //c+ 롬 폰트
// MouseText는 유니코드 v13(ISO10646-2020)이후에 추가됨
export const APPLE2E_ROM_FONT_MAP =
  '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_' +
  ' !"#$%&\'()*+,-./0123456789:;<=>?' +
  '________________________________' + // MouseText(//e enhanced or later) or custom
  '`abcdefghijklmnopqrstuvwxyz{|}~\u007f';

export function generateAsciiGlyphs(font) {
  debug('generate ascii glyphs...');
  const glyphs = [];
  for (let code = 0; code < 0x80; code++) {
    debug(`${code}:${code.toString(16)}:[${code >= 0x20 ? String.fromCharCode(code) : ''}]`);
    const index = APPLE2E_ROM_FONT_MAP.indexOf(String.fromCharCode(code));
    if (index !== -1) {
      const bitmap = initBitmap(7, 16);
      drawBitmap(font.glyphs[index].bitmap, 7, 8, bitmap, 0, 0);
      glyphs.push({ code, width: 7, height: 16, bitmap });
    } else {
      debug('not found:', code);
    }
  }
  return glyphs;
}

export function generateUnicodeGlyphs(font, romFont) {
  return [].concat(
    generateAsciiGlyphs(romFont),
    generateChoseongGlyphs(font),
    generateJungseongGlyphs(font),
    generateJongseongGlyphs(font),
    generateSyllableGlyphs(font),
    generateReferenceGlyphs(font)
  );
}
