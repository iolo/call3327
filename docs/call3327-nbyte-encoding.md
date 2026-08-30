# call3327-nbyte-encoding

CALL 3327 is a ancient Korean input/output program for Apple II series computers.

## encoding

CALL 3327 use a variable-length encoding scheme - N-byte encodings - for Korean Hangul syllables.

`<ascii>* <SI> (<jamo>|<non-jamo-ascii>)* <SO> <ascii>*`

- SI=\x0a=^K(ctrl+K)
- SO=\x01=^A(ctrl+A)

ex.

`ABC\x0aGKSRMF\x01123` == `ABCㅎㅏㄴㄱㅡㄹ123` == `ABC한글123`
`ABC\x0aGKS123RMF\x01456` == `ABCㅎㅏㄴㄱㅡㄹ123` == `ABC한123글123`

## Jamo(korean consonant/vowel) code

- Q ㅂ
- W ㅈ
- E ㄷ
- R ㄱ
- T ㅅ
- Y ㅛ
- U ㅕ
- I ㅑ
- O ㅐ
- P ㅔ
- A ㅁ
- S ㄴ
- D ㅇ
- F ㄹ
- G ㅎ
- H ㅗ
- J ㅓ
- K ㅏ
- L ㅣ
- Z ㅋ
- X ㅌ
- C ㅊ
- V ㅍ
- B ㅠ
- N ㅜ
- M ㅡ
- `;` ㅒ
- `+` ㅖ
- `<` ㅆ
- `>` ㅉ
- `:` ₩ (KRW)
- `*` ㅃ
- `-` ㄲ
- `=` ㄸ

NOTE: case-sensitive. ex. `K`=ㅏ, `k`=non-jamo-ascii(lowercase 'k')

![call3327-keyboard-layout.png]()

## Convert other encodings(UTF-8, EUC-KR, CP949, ...) to CALL 3327 N-byte encoding

It's simple and straightforward:

1. separate Hangul syllables to Jamos
2. convert them to CALL 3327 N-byte encoding.

See also: https://raw.githubusercontent.com/iolo/kakalabeth/refs/heads/main/utf8_to_3327.js

## Convert CALL 3327 N-byte encoding to other encodings (UTF-8, EUC-KR, CP949, ...)

It's a bit complicate:
**N-bytes** of Jamo(korean consonant/vowel)s are combined to form complete Hangul syllables.
So, a kind of state machine is needed to combine Jamos to Hangul syllables.

- state0. initial state(empty)
  - + C(ㄱ): go to state 1 with C(ㄱ).
  - + V(ㅏ): V without choseong=N/A.[^1] emit a Jamo('ㅏ') and state in state0.
  - + non-jamo-ascii: emit non-jamo-ascii and stay in state0
- state1. C(ㄱ)
  - + C[^2]
    - valid: C+C(ㄱ+ㄱ)=ㄲ; stay in state1 with combined C(ㄲ)
    - invalid: C+C(ㄱ+ㄴ)=N/A; emit a Jamo('ㄱ') and stay in state1 with C(ㄴ)
  - + V(ㅏ): go to state2 with C+V(ㄱ+ㅏ)
  - + non-jamo-ascii: emit C(ㄱ) and emit non-jamo-ascii and go to state0
- state2. C+V(ㄱ+ㅏ)
  - + C(ㄴ): go to state3 with C+V+C(ㄱ+ㅏ+ㄴ)
  - + V[^3]
    - valid: V+V(ㅗ+ㅏ)=ㅘ; state in state2 with C+V(ㄱ+ㅘ)
    - invalid: V+V(ㅏ+ㅏ)=N/A; emit a syllable('가') and emit a Jamo('ㅏ') and go to state0.
  - + non-jamo-ascii: emit C+V(ㄱ+ㅏ) as a syllable('가') and emit non-jamo-ascii and go to state0
- state3: C+V+C(ㄱ+ㅏ+ㄴ)
  - + C[^4]
    - valid: C+C(ㄴ+ㅈ)=ㄵ; go to state4 with C+V+C+C(ㄱ+ㅏ+ㄴ+ㅈ)
    - invalid: C+C(ㄴ+ㄴ)=N/A; emit a syllable('간') and go to state1 with new C(ㄴ)
  - + V(ㅗ): emit C+V(ㄱ+ㅏ) as a syllable('가') and go to state2 with new C+V(ㄴ+ㅗ)
  - + non-jamo-ascii: emit C+V+C(ㄱ+ㅏ+ㄴ) as a syllable('간') and emit non-jamo-ascii and go to state0
- state4: C+V+C+C(ㄱ+ㅏ+ㄴ+ㅈ)
  - + C(ㄷ): emit C+V+C+C(ㄱ+ㅏ+ㄴ+ㅈ) as a syllable('갅') and go to state1 with new C(ㄷ)
  - + V(ㅣ): emit C+V+C(ㄱ+ㅏ+ㄱ) as a syllable('간') and go to state2 with new C+V(ㅈ+ㅣ)

[^1] NOTE: CALL 3327 N-byte encoding support syllables without choseong(initial consonant), but UTF-8 didn't.
So, those N-byte sequence should be converted to a sequence of Hangul Jamos.

[^2] NOTE: valid double consonants for choseong(initial consonant).

- ㄱ+ㄱ= ㄲ
- ㄷ+ㄷ= ㄸ
- ㅂ+ㅂ= ㅃ
- ㅅ+ㅅ= ㅆ
- ㅈ+ㅈ= ㅉ

[^3] NOTE: valid pairs of vowels for jungseong(medial vowel)

- ㅗ+ㅏ=ㅘ
- ㅗ+ㅐ=ㅙ
- ㅗ+ㅣ=ㅚ
- ㅜ+ㅓ=ㅝ
- ㅜ+ㅔ=ㅞ
- ㅜ+ㅣ=ㅟ
- ㅡ+ㅣ=ㅢ

[^4] NOTE: valid pairs of consonants for jongseong(final consonant)

- ㄱ+ㄱ=ㄲ
- ㄱ+ㅅ=ㄳ
- ㄴ+ㅈ=ㄵ
- ㄴ+ㅎ=ㄶ
- ㄹ+ㄱ=ㄺ
- ㄹ+ㅁ=ㄻ
- ㄹ+ㅂ=ㄼ
- ㄹ+ㅅ=ㄽ
- ㄹ+ㅌ=ㅀ
- ㄹ+ㅍ=ㅄ
- ㅂ+ㅅ=ㅄ
- ㅅ+ㅅ=ㅆ

[^5] NOTE: Sometimes, a syllable couldn't be determined until the next character(Jamo, non-jamo-ascii, or SO) is received, so the state machine should keep the current state until syllables are completed.

