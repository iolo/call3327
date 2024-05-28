;# vim: set syntax=asm_ca65 ts=8 sts=8 sw=8 et :

.define EQU =
.define DFB .byte
.define DW .word
.define DS .res

;0067:
TXTBF = $67
;0074
HIMEMH = $74
;03EA:
DOSFET = $3EA
;03F6:
VEC = $3F6
;D64B:
BNEW = $D64B
;D43C:
WARMBS = $D43C

;----- NEXT OBJECT FILE NAME IS HAN.OBJO 
;0880:
        .ORG $0880
;0880:AD EA 03 11
        LDA DOSFET      ;CHECK IF DOS! 
;0883:C9 4C 12
        CMP #$4C        ;IS IT 'JMP'? 
;0885:F0 05 13
        BEQ NCHNG 
;0887:A9 60 14 
        LDA #$60        ;IF NOT,REPLACE WITH 'RETURN'
;0889:8D EA 03 15 
        STA DOSFET 
;088C:A9 80 16 
NCHNG:
        LDA #$80 
;088E:85 E8 17 
        STA $E8 
;0890:20 FF OC 18 
        JSR ENTRY       ;HANG INITIALIZE 
;0893:A9 FF 19 
        LDA #<ENTRY
;0895:8D F6 03 20 
        STA VEC 
;0898:A9 OC 21 
        LDA #>ENTRY
;089A:8D F7 03 22 
        STA VEC+1 
;089D:A2 00 23 
        LDX #0 
;089F:8E C3 08 24 
        STX SNDFLG 
;08A2:AO 40 25 
        LDY #$40        ;TXTBF START OF 48K VER.=$4000 
;08A4:A5 74 26 
        LDA HIMEMH 
;08A6:C9 41 27 
        CMP #$41        ;CHECK IF 16K VERS.? 
;08A8:BO 08 28 
        BCS VER48 
;08AA:A9 20 29 
        LDA #$20        ;THEN,REPLACE HIMEM=$20 
;08AC:85 74 30 
        STA HIMEMH 
;08AE:A2 OB 31 
        LDX #$0B        ;TXTBF START OF 16K VER.=END OF HANG 
;OBBO:AO 16 32 
        LDY #$16 
;08B2:86 67 33 
VER48:
        STX TXTBF       ;BASIC TEXT BUFF START 
;08B4:84 68 34 
        STY TXTBF+1 
;08B6:AO 00 35 
        LDY #0 
;08B8:98 36 
        TYA 
;08B9:91 67 37 
        STA (TXTBF),Y   ;CLEAR 1ST ENTRY 
;08BB:E6 67 38 
        INC TXTBF       ;POINT TO NEXT POS 
;08BD:20 4B D6 39 
        JSR BNEW        ;NEW! 
;08C0:4C 3C D4 40 
        JMP WARMBS      ;JMP TO BASIC 

;08C3: 42
SNDFLG:
        .res 1 
;08C4: 43 
        .res 59           ;OF NO USE! 

;************************
; CHARACTER PATTERN AREA 
; $08FF - $OCFE 
;************************
PATTERN:                ; .res 1023
        .byte $00, $00, $00, $00, $00, $00, $00, $00
        .byte $02, $02, $02, $02, $00, $00, $00, $00
        .byte $0a, $0a, $0a, $0a, $00, $00, $00, $00
        .byte $02, $02, $02, $02, $00, $00, $00, $00
        .byte $0a, $0a, $0a, $0a, $00, $00, $00, $00
        .byte $04, $04, $04, $04, $00, $00, $00, $00
        .byte $0a, $0a, $0a, $0a, $00, $00, $00, $00
        .byte $04, $04, $04, $04, $00, $00, $00, $00
        .byte $0a, $0a, $0a, $0a, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $08, $08, $bf, $00
        .byte $00, $00, $00, $00, $14, $14, $bf, $00
        .byte $00, $00, $00, $00, $00, $00, $bf, $08
        .byte $00, $00, $00, $00, $00, $00, $bf, $14
        .byte $00, $00, $00, $00, $00, $00, $bf, $00
        .byte $04, $04, $04, $04, $00, $00, $00, $00
        .byte $00, $27, $24, $24, $54, $0a, $00, $00
        .byte $00, $b9, $91, $91, $a9, $af, $00, $00
        .byte $00, $91, $b9, $91, $a9, $97, $00, $00
        .byte $00, $bf, $a4, $a7, $a1, $a7, $00, $00
        .byte $00, $77, $54, $57, $51, $77, $00, $00
        .byte $00, $57, $54, $77, $51, $77, $00, $00
        .byte $00, $27, $24, $27, $51, $4f, $00, $00
        .byte $00, $77, $04, $77, $11, $77, $00, $00
        .byte $00, $7f, $2c, $2f, $29, $7f, $00, $00
        .byte $00, $27, $74, $27, $51, $27, $00, $00
        .byte $00, $25, $25, $27, $55, $57, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $08, $1c, $3e, $7f
        .byte $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00
        .byte $08, $08, $08, $08, $08, $00, $08, $00
        .byte $14, $14, $14, $00, $00, $00, $00, $00
        .byte $14, $14, $3e, $14, $3e, $14, $14, $00
        .byte $08, $3c, $0a, $1c, $28, $1e, $08, $00
        .byte $06, $26, $10, $08, $04, $32, $30, $00
        .byte $04, $0a, $0a, $04, $2a, $12, $2c, $00
        .byte $08, $08, $08, $00, $00, $00, $00, $00
        .byte $08, $04, $02, $02, $02, $04, $08, $00
        .byte $08, $10, $20, $20, $20, $10, $08, $00
        .byte $08, $2a, $1c, $08, $1c, $2a, $08, $00
        .byte $00, $08, $08, $3e, $08, $08, $00, $00
        .byte $00, $00, $00, $00, $08, $08, $04, $00
        .byte $00, $00, $00, $3e, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $08, $00
        .byte $00, $20, $10, $08, $04, $02, $00, $00
        .byte $1c, $22, $32, $2a, $26, $22, $1c, $00
        .byte $08, $0c, $08, $08, $08, $08, $1c, $00
        .byte $1c, $22, $20, $18, $04, $02, $3e, $00
        .byte $3e, $20, $10, $18, $20, $22, $1c, $00
        .byte $10, $18, $14, $12, $3e, $10, $10, $00
        .byte $3e, $02, $1e, $20, $20, $22, $1c, $00
        .byte $38, $04, $02, $1e, $22, $22, $1c, $00
        .byte $3e, $20, $10, $08, $04, $04, $04, $00
        .byte $1c, $22, $22, $1c, $22, $22, $1c, $00
        .byte $1c, $22, $22, $3c, $20, $10, $0e, $00
        .byte $00, $00, $08, $00, $08, $00, $00, $00
        .byte $00, $00, $08, $00, $08, $08, $04, $00
        .byte $10, $08, $04, $02, $04, $08, $10, $00
        .byte $00, $00, $3e, $00, $3e, $00, $00, $00
        .byte $04, $08, $10, $20, $10, $08, $04, $00
        .byte $1c, $22, $10, $08, $08, $00, $08, $00
        .byte $1c, $22, $2a, $3a, $1a, $02, $3c, $00
        .byte $08, $14, $22, $22, $3e, $22, $22, $00
        .byte $1e, $22, $22, $1e, $22, $22, $1e, $00
        .byte $1c, $22, $02, $02, $02, $22, $1c, $00
        .byte $1e, $22, $22, $22, $22, $22, $1e, $00
        .byte $3e, $02, $02, $1e, $02, $02, $3e, $00
        .byte $3e, $02, $02, $1e, $02, $02, $02, $00
        .byte $3c, $02, $02, $02, $32, $22, $3c, $00
        .byte $22, $22, $22, $3e, $22, $22, $22, $00
        .byte $1c, $08, $08, $08, $08, $08, $1c, $00
        .byte $20, $20, $20, $20, $20, $22, $1c, $00
        .byte $22, $12, $0a, $06, $0a, $12, $22, $00
        .byte $02, $02, $02, $02, $02, $02, $3e, $00
        .byte $22, $36, $2a, $2a, $22, $22, $22, $00
        .byte $22, $22, $26, $2a, $32, $22, $22, $00
        .byte $1c, $22, $22, $22, $22, $22, $1c, $00
        .byte $1e, $22, $22, $1e, $02, $02, $02, $00
        .byte $1c, $22, $22, $22, $2a, $12, $2c, $00
        .byte $1e, $22, $22, $1e, $0a, $12, $22, $00
        .byte $1c, $22, $02, $1c, $20, $22, $1c, $00
        .byte $3e, $08, $08, $08, $08, $08, $08, $00
        .byte $22, $22, $22, $22, $22, $22, $1c, $00
        .byte $22, $22, $22, $22, $22, $14, $08, $00
        .byte $22, $22, $22, $22, $2a, $36, $22, $00
        .byte $22, $22, $14, $08, $14, $22, $22, $00
        .byte $22, $22, $14, $08, $08, $08, $08, $00
        .byte $3e, $20, $10, $08, $04, $02, $3e, $00
        .byte $3e, $06, $06, $06, $06, $06, $3e, $00
        .byte $00, $a1, $2a, $7f, $2a, $2a, $14, $00
        .byte $3e, $30, $30, $30, $30, $30, $3e, $00
        .byte $3e, $20, $20, $20, $20, $00, $00, $00
        .byte $be, $a8, $a8, $94, $00, $00, $00, $00
        .byte $02, $02, $02, $02, $3e, $00, $00, $00
        .byte $3e, $02, $02, $02, $3e, $00, $00, $00
        .byte $3e, $0a, $0a, $0a, $3e, $00, $00, $00
        .byte $3e, $20, $3e, $02, $3e, $00, $00, $00
        .byte $3e, $22, $22, $22, $3e, $00, $00, $00
        .byte $22, $22, $3e, $22, $3e, $00, $00, $00
        .byte $2a, $2a, $3e, $2a, $3e, $00, $00, $00
        .byte $08, $08, $08, $14, $22, $00, $00, $00
        .byte $14, $14, $2a, $49, $00, $00, $00, $00
        .byte $1c, $22, $22, $22, $1c, $00, $00, $00
        .byte $3e, $08, $08, $14, $22, $00, $00, $00
        .byte $bf, $94, $8a, $95, $a2, $00, $00, $00
        .byte $08, $3e, $08, $14, $22, $00, $00, $00
        .byte $be, $a0, $be, $a0, $90, $00, $00, $00
        .byte $3e, $00, $3e, $02, $3e, $00, $00, $00
        .byte $3e, $14, $14, $14, $3e, $00, $00, $00
        .byte $08, $3e, $1c, $22, $1c, $00, $00, $00
        .byte $02, $02, $02, $1e, $02, $02, $02, $02
        .byte $0a, $0a, $0a, $0e, $0a, $0a, $0a, $0a
        .byte $02, $02, $1e, $02, $02, $1e, $02, $02
        .byte $0a, $0a, $0e, $0a, $0a, $0e, $0a, $0a
        .byte $04, $04, $04, $07, $04, $04, $04, $04
        .byte $0a, $0a, $0a, $0b, $0a, $0a, $0a, $0a
        .byte $04, $04, $07, $04, $04, $07, $04, $04
        .byte $0a, $0a, $0b, $0a, $0a, $0b, $0a, $0a
        .byte $08, $08, $08, $bf, $00, $00, $00, $00
        .byte $14, $14, $14, $bf, $00, $00, $00, $00
        .byte $bf, $08, $08, $08, $08, $00, $00, $00
        .byte $bf, $14, $14, $14, $14, $00, $00, $00
        .byte $00, $00, $bf, $00, $00, $00, $00, $00
        .byte $04, $04, $04, $04, $04, $04, $04, $04
        .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

WNDLFT=$20 
;0021: 4 
WNDWDTH=$21 
;0022: 5 
WNDTOP=$22 
;0023: 6 
WNDBTM=$23 
;0024: 7 
CH=$24 
;0025: 8 
CV=$25 
;0028: 9 
BASL=$28 
;002A: 10
BAS2L=$2A 
;0035: 11
REGY=$35 
;0038: 12
KSW=$38 
;0036: 13
CSW=$36 
;004E: 14
RNDL=$4E 
;00EB: 15
REGX=$EB 
;00EC: 16 
PLOC=$EC 
;00EE: 17 
PATLOC=$EE 
;00FF: 18 
SACC=$FF 
;C000: 19 
KBD=$C000 
;C010: 20 
KBDSTB=$C010 
;C030: 21 
SPEAKER=$C030 
;C050: 22 
SCRSW=$C050 
;FBDD: 23 
BEEP=$FBDD 
;FC22: 24 
VTAB=$FC22 
;FC24: 25 
VTABZ=$FC24 
;FC42: 26 
CLREOP=$FC42 
;FC58: 27 
HOME=$FC58 
;FC70: 28 
SCROL=$FC70 
;FC9C: 29 
CLREOL=$FC9C 
;FCA8: 30 
MWAIT=$FCA8 
;FDED: 31 
COUT=$FDED

        .ORG $0CFF
;0CFF: 33 MUST BE AT $CFF
;0CFF:4C 08 OD 34 
ENTRY:
        JMP BEGIN       ;ENTRY OF '&' 
;0D02:4C 11 OD 35 
        JMP INIT 

;0D05:0A 37 
        .byte $0A 
;0D06:FF 38 
        .byte $FF 
;0D07:08 39 
        .byte $0B 

;0D08:20 11 OD 41 
BEGIN:
        JSR INIT 
;ODOB:A9 90 42 
        LDA #$90        ;HOME! 
;ODOD:20 ED FD 43 
        JSR COUT 
;0D10:60 44 
        RTS 

;0D11:AD 38 OD 46 
INIT:
        LDA NEWKSW      ;SET NEW KSW 
;0014:85 38 47 
        STA KSW 
;0D16:AD 39 OD 48 
        LDA NEWKSW+1 
;0D19:85 39 49 
        STA KSW+1 
;OD1B:AD 3A OD 50 
        LDA NEWCSW      ;SET NEW CSW 
;0D1E:85 36 51 
        STA CSW 
;OD20:AD 3B OD 52 
        LDA NEWCSW+1 
;0D23:85 37 53 
        STA CSW+1 

;0D25:20 EA 03 54 
        JSR DOSFET      ;DOS PATCHER 
;0D28:2C 52 CO 55 
        BIT SCRSW+2     ;FULL MODE S/W 
;0D2B:2C 57 CO 56 
        BIT SCRSW+7     ;HI-RES. MODE S/W 
;0D2E:20 AB 10 57 
        JSR CTRLZ       ;MODE INITIALIZE 
;0D31:20 C9 OF 58 
        JSR CHKPAG      ;CHECK PAGE 
;0D34:2C 50 CO 59 
        BIT SCRSW       ;GRAPHIC MODE S/W 
;0D37:60 60 
        RTS 

;0D38:53 OD 62
NEWKSW:
        .word HKSW         ;HANG KSW 
;0D3A:12 0E 63
NEWCSW:
        .word HCSW         ;HANG CSW 
;0D3C:0D 64 
        .byte $0D
;0D3D:00 65 
ESCFL:
        .byte 0          ;ESC FLAG
;OD3E:00 66 
        .byte 0 
;0D3F:20 67 
HGRAD:
        .byte $20        ;PAGE NO.
;0D40:00 68 
INVFLG:
        .byte 0          ;INVERSE FLAG 
;0D41:00 69 
POSFL:
        .byte 0          ;POSITION FLAG 
;0D42:00 70 
ADRFL:
        .byte 0          ;ADDRESS FLAG 
;0D43:00 71 
AUTO:
        .byte 0          ;AUTO CONNECT FLAG 
;0D44:00 72 
CTSFL:
        .byte 0 
;0D45:FF 08 73
PATBASE:
        .word PATTERN      ;PATTERN START 
;0D47:00 74
        .byte 0 
;0D48:00 75
        .byte 0 
;0D49:00 76
        .byte 0 
;0D4A:00 77 
        .byte 0 
;0D4B:00 78 
        .byte 0 
;0D4C:00 79 
        .byte 0 
;0D4D:00 80 
        .byte 0 
;0D4E:00 81 
        .byte 0 
;0D4F:00 82 
NORML0:
        .byte 0
;0D50:00 83 
HICH:
        .byte 0 
;0D51:00 84 
HICV:
        .byte 0 
;0D52:40 85 
KEMODE:
        .byte $40 

;0D53:91 28 87
HKSW:
        STA (BASL),Y    ;TEXT SCREEN DISP 
;0D55:86 EB 88
        STX REGX        ;SAVE X REG. 
;0D57:A5 28 89
        LDA BASL 
;0D59:85 2A 90
        STA BAS2L 
;0D5B:A5 29 91 
        LDA BASL+1 
;0D5D:09 1C 92 
        ORA #$1C        ;8TH SCAN LINE 
;0D5F:0D 3F OD 93 
        ORA HGRAD       ;CONSIDER PAGE 
;0D62:85 2B 94 
        STA BAS2L+1 
;0D64:A2 01 95 
        LDX #1 
;0D66:B1 2A 96 
        LDA (BAS2L),Y
;0D68:48 97 
        PHA 
;0D69:E6 4E 98 
RDKEY:
        INC RNDL        ;RANDOM SEED 
;0D6B:DO OB 99 
        BNE CONT1 
;0D6D:E6 4F 100 
        INC RNDL+1 
;OD6F:CA 101 
        DEX 
;OD70:DO 06 102 
        BNE CONT1 
;0D72:49 7F 103 
        EOR #$7F        ;FLASH UNDERLINE 

;0D74:91 2A 104 
        STA (BAS2L),Y
;0D76:A2 40 105 
        LDX #$40        ;FLASHING PERIOD 
;0D78:2C 00 CO 106 
CONT1:
        BIT KBD 
;0D7B:10 EC 107 
        BPL RDKEY
;0D7D:68 108 
        PLA 
;OD7E:91 2A 109 
        STA (BAS2L),Y
;0D80:BA 110 
        TSX 
;0D81:BD 04 01 111 
        LDA $104,X 
;0DB4:C9 F8 112 
        CMP #$F8 
;0D86:AD 00 CO 113 
        LDA KBD 
;0D89:2C 10 CO 114 
        BIT KBDSTB 
;0DBC:90 23 115 
        BCC RSTX 
;ODBE:48 116 
        PHA             ;KEY VAL.PUSH 
;0DBF:2C 3D OD 117 
        BIT ESCFL       ;CHECK IF ESC MODE! 
;0D92:30 33 118 
        BMI ONESC       ;THEN,ESC PROCESS 
;0D94:C9 9B 119 
        CMP #$9B        ;IS IT A ESC? 
;OD96:DO 07 120 
        BNE NOTESC 
;0D98:A9 80 121 
        LDA #$80        ;IN ESC MODE! 
;OD9A:8D 3D OD 122 
        STA ESCFL 
;OD9D:DO 11 123 
        BNE CONT2 
;0D9F:20 14 16 124 
NOTESC:
        JSR KPEENG 
;0DA2:2C 52 OD 125 
        BIT KEMODE      ;WHICH MODE?(K OR E) 
;0DA5:30 OD 126 
        BMI KORMOD 
;0DA7:C9 BD 127 
ENGMOD:
        CMP #$8D        ;IF CR? 
;ODA9:DO 05 128 
        BNE CONT2 
;ODAB:20 C2 11 129
        JSR HCLREOL
;ODAE:A4 24 130
CONT3:
        LDY CH 
;ODBO:68 131 
CONT2:
        PLA 
;0DB1:A6 EB 132 
RSTX:
        LDX REGX        ;RESTORE X 
;0DB3:60 133
        RTS 

;0DB4:C9 8D 135
KORMOD:
        CMP #$8D        ;IF CR? 
;0DB6:00 F8 136 
        BNE CONT2 
;ODB8:48 137 
        PHA 
;0DB9:A9 00 138 
        LDA #0 
;ODBB:8D 52 OD 139 
        STA KEMODE      ;RESET TO E-MODE 
;ODBE:8D 52 12 140 
        STA STATE 
;0DC1:68 141 
        PLA 
;ODC2:85 24 142 
        STA CH 
;0DC4:20 BC 0E 143 
        JSR KCTRLE 

;0DC7:C9 C9 145 
ONESC:
        CMP #$C9        ;'I'? 
;ODC9:90 0C 146
        BCC NIJKM 
;ODCB:C9 CD 147 
        CMP #$CD        ;'M'? 
;ODCD:FO 36 148 
        BEQ ESCMC 
;ODCF:BO 06 149 
        BCS NIJKM 
;0DD1:C9 CB 150 
        CMP #$CB         ;'K'?
;0DD3:FO 2B 151 
        BEQ ESCKA 
;0DD5:90 D9 152 
        BCC CONT2 
;0DD7:0E 3D OD 153 
NIJKM:
        ASL ESCFL       ;RESET ESC FLAG! 
;ODDA:C9 CO 154 
        CMP #$C0        ;'@'? 
;ODDC:DO 06 155 
        BNE NESC_

;ODDE:20 A5 11 156 
ESC_:
        JSR HIHOME      ;THEN,HOME
;0DE1:4C AE OD 157 
        JMP CONT3 
;ODE4:C9 C5 158 
NESC_:
        CMP #$C5        ;'E'?
;ODE6:DO 06 159 
        BNE NESCE 
;0DE8:20 C2 11 160 
ESCE:
        JSR HCLREOL     ;THEN,CLEAR END OF LINE
;ODEB:4C AE OD 161 
        JMP CONT3
;ODEE:C9 C6 162 
NESCE:
        CMP #$C6        ;'F'?
;ODFO:DO 06 163 
        BNE NESCF 
;0DF2:20 AF 11 164 
ESCF:
        JSR HCLREOP     ;THEN,CLEAR END OF PAGE
;0DF5:4C AE OD 165 
        JMP CONT3
;0DF8:C9 C3 166 
NESCF:
        CMP #$C3        ;'C'?
;ODFA:FO 09 167 
        BEQ ESCMC 
;ODFC:C9 C1 168 
        CMP #$C1        ;'A'? 
;ODFE:DO BO 169 
        BNE CONT2 
;0E00:C8 170 
ESCKA:
        INY             ;CH=CH+1
;0E01:C4 21 171 
        CPY WNDWDTH     ;OVER? 
;0E03:90 A9 172 
        BCC CONT3 
;0E05:A4 25 173 
ESCMC:
        LDY CV 
;0E07:C8 174 
        INY ;CV=CV+1 
;0E08:C4 23 175 
        CPY WNDBTM      ;OVER? 
;0E0A:90 A2 176 
        BCC CONT3 
;0E0C:20 56 11 177 
        JSR HSCROL      ;THEN,HI-SCROL 
;0E0F:4C AE OD 178 
        JMP CONT3 

;0E12:85 FF 180 
HCSW:
        STA SACC        ;SAVE ACC. 
;0E14:86 EB 181 
        STX REGX        ;SAVE X 
;0E16:84 35 182 
        STY REGY        ;SAVE Y 
;0E18:20 22 0E 183 
        JSR CHRPRO      ;CHR. PROCESSING! 
;0E1B:A4 35 184 
        LDY REGY        ;RESTORE Y
;0E1D:A6 EB 185 
        LDX REGX        ;RESTORE X 
;0E1F:A5 FF 186 
        LDA SACC        ;RESTORE ACC. 
;0E21:60 187 
        RTS 

;0E22:29 7F 189 
CHRPRO:
        AND #$7F        ;MASK BIT 7 
;0E24:2C 52 OD 190 
        BIT KEMODE      ;WHERE IN? 
;0E27:30 16 191 
        BMI INKOR 
;0E29:C9 20 192 
INENG:
        CMP #$20        ;DISPLAYABLE? 
;0E2B:90 03 193 
        BCC ECTRL 
;0E2D:4C 2A 11 194 
        JMP NORMOUT 
;0E30:09 1B 195 
ECTRL:
        CMP #$1B        ;IF ESC OR MORE? 
;0E32:B0 0A 196 
        BCS RTS1        ;THEN,RETURN 
;0E34:0A 197 
        ASL A           ;*2 
;0E35:AA 198 
        TAX 
;0E36:BD 86 0F 199 
        LDA ECTRLV+1,X  ;GET CTRL-VEC. 
;0E39:48 200 
        PHA 
;0E3A:BD 85 OF 201 
        LDA ECTRLV,X 
;0E3D:48 202 
        PHA 
;0E3E:60 203 
RTS1:
        RTS             ;GO THERE!

;0E3F:C9 01 205 
INKOR:
        CMP #1          ;CTRL-A IN KOREAN 
;0E41:00 OD 206 
        BNE NCTRLA 
;0E43:A9 00 207 
        LDA #0          ;RESET KEMODE 
;0E45:8D 52 OD 208 
        STA KEMODE 
;0E48:A9 20 209 
        LDA #$20        ;A BLANK! 
;0E4A:20 20 12 210 
        JSR KOROUT      ;DISP! 
;0E4D:C6 24 211 
        DEC CH 
;0E4F:60 212 
        RTS 

;0E50:C9 20 214 
NCTRLA:
        CMP #$20        ;DISPLAYABLE? 
;0E52:90 19 215 
        BCC CHKCTRL 
;0E54:4C 20 12 216 
        JMP KOROUT      ;THEN,DISP! 
;0E57:A5 24 218 
TPSAVE:
        LDA CH          ;CH TEMP.SAVE 
;0E59:8D 47 12 219 
        STA TEMPCH 
;0E5C:A5 25 220 
        LDA CV          ;CV TEMP.SAVE 
;0E5E:8D 46 12 221 
        STA TEMPCV 
;0E61:60 222
        RTS 

;0E62:AD 47 12 224 
TPLOAD:
        LDA TEMPCH      ;RESTORE CH 
;0E65:85 24 225 
        STA CH 
;0E67:AD 46 12 226 
        LDA TEMPCV      ;RESTORE CV 
;0E6A:85 25 227 
        STA CV 
;0E6C:60 228 
        RTS 
;0E6D:C9 1B 230 
CHKCTRL:
        CMP #$1B 
;0E6F:B0 OD 231 
        BCS RTS22 
;0E71:0A 232 
        ASL A           ;*2 
;0E72:AA 233 
        TAX 
;0E73:BD 80 0E 234 
        LDA KCTRLV+1,X  ;GET KCTRL-VEC. 
;0E76:48 235 
        PHA 
;0E77:BD 7F 0E 236 
        LDA KCTRLV,X 
;0E7A:48 237 
        PHA 
;0E7B:20 57 0E 238 
        JSR TPSAVE 
;0E7E:60 239 
RTS22:
        RTS 

;0E7F: 241 ***********************************
;0E7F: 242 *
;0E7F: 243 * CTRL-KEY JMP VECTOR IN KOREAN 
;0E7F: 244 * 
;0E7F: 245 *********************************** 

;0E7F:FC 0F 247 
KCTRLV:
        .word SIMRTN-1     ;CTRL-@ 
;0E81:FC 0F 248 
        .word SIMRTN-1     ;CTRL-A 
;0E83:FC 0F 249 
        .word SIMRTN-1     ;CTRL-B 
;0E85:B4 0E 250 
        .word SIMRTN1-1    ;CTRL-C 
;0E87:FC 0F 251 
        .word SIMRTN-1     ;CTRL-D 
;0E89:BB 0E 252 
        .word KCTRLE-1     ;CTRL-E 
;0E8B:CC 0E 253 
        .word KCTRLF-1     ;CTRL-F 
;0E8D:DC FB 254 
        .word BEEP-1       ;CTRL-6 
;0E8F:0C 0F 255 
        .word KCTRLH-1     ;CTRL-H 
;0E91:F7 0F 256 
        .word CTRLI-1      ;CTRL-I 
;0E93:B5 0E 257 
        .word KCTRLJ-1     ;CTRL-J 
;0E95:FC 0F 258 
        .word SIMRTN-1     ;CTRL-K 
;0E97:FC 0F 259 
        .word SIMRTN-1     ;CTRL-L 
;0E99:7D 0F 260 
        .word KCTRLM-1     ;CTRL-M 
;0E9B:1E 10 261 
        .word CTRLN-1      ;CTRL-N 
;0E9D:FC 0F 262 
        .word SIMRTN-1     ;CTRL-0 
;0E9F:24 10 263 
        .word CTRLP-1      ;CTRL-P 
;0EA1:2A 10 264 
        .word CTRLQ-1      ;CTRL-Q 
;0EA3:FC 0F 265 
        .word SIMRTN-1     ;CTRL-R 
;0EA5:37 10 266 
        .word CTRLS-1      ;CTRL-S 
;0EA7:2D 16 267 
        .word CTRLT-1      ;CTRL-T 
;0EA9:FC OF 268 
        .word SIMRTN-1     ;CTRL-U 
;0EAB:3D 10 269 
        .word CTRLV-1      ;CTRL-V 
;OEAD:69 10 270 
        .word CTRLW-1      ;CTRL-W 
;0EAF:FC OF 271 
        .word SIMRTN-1     ;CTRL-X 
;0EB1:88 10 272 
        .word CTRLY-1      ;CTRL-Y 
;0EB3:AA 10 273 
        .word CTRLZ-1      ;CTRL-Z 
;0EB5:60 275 
SIMRTN1:
        RTS 

;0EB6:20 DA 0E 277 
KCTRLJ:
        JSR LFOUT 
;0EB9:4C 70 FC 278 
        JMP SCROL 

;0EBC:A9 20 280 
KCTRLE:
        LDA #$20        ;A BLANK 
;0EBE:20 20 12 281 
        JSR KOROUT      ;DISP! 
;0EC1:20 C2 11 282 
        JSR HCLREOL     ;CLEAR CURRENT 
;0EC4:E6 25 283 
        INC CV          ;CV=CV+1 LINE 
;0EC6:20 C2 11 284 
        JSR HCLREOL     ;CLEAR NEXT LINE 
;0EC9:20 62 0E 285 
        JSR TPLOAD      ;RESTORE $24,5 
;0ECC:60 286 
        RTS 

;OECD:E6 25 288 
KCTRLF:
        INC CV          ;CV=CV+1
;0ECF:20 AF 11 289 
        JSR HCLREOP 
;0ED2:20 62 0E 290 
        JSR TPLOAD 
;0ED5:60 291 
        RTS 

;0ED6:A9 00 293 
ASCROL:
        LDA #0          ;CH=0 
;0ED8:85 24 294 
        STA CH 
;OEDA:E6 25 295 
LFOUT:
        INC CV          ;CV=CV+1 
;OEDC:E6 25 296 
        INC CV          ;CV=CV+1 
;OEDE:A5 25 297 
        LDA CV          ;CHECK CV! 
;0EE0:C9 17 298 
        CMP #$17 
;0EE2:F0 07 299 
        BEQ ATBTM 
;0EE4:90 OD 300 
        BCC NONEED 
;0EE6:C6 25 301 
        DEC CV          ;CV=CV-1 
;0EE8:20 56 11 302 
        JSR HSCROL 
;0EEB:C6 25 303 
ATBTM:
        DEC CV          ;CV=CV-1 

;0EED:20 56 11 304 
        JSR HSCROL 
;0EF0:20 70 FC 305 
        JSR SCROL 
;0EF3:60 306 
NONEED:
        RTS 

;0EF4:AC 00 CO 308 
KEYCHK:
        LDY KBD         ;READ KEYBOARD 
;0EF7:10 13 309 
        BPL RTS2 
;0EF9:CO 93 310 
        CPY #$93        ;CTRL-S? 
;0EFB:DO 0F 311 
        BNE RTS2 
;0EFD:2C 10 CO 312 
        BIT KBDSTB 
;0F00:AC 00 CO 313 
KWAIT:
        LDY KBD 
;0F03:10 FB 314 
        BPL KWAIT 
;0F05:C0 83 315 
        CPY #$83        ;CTRL-C? 
;0F07:F0 03 316 
        BEQ RTS2 
;0F09:2C 10 CO 317 
        BIT KBDSTB 
;OFOC:60 318 
RTS2:
        RTS 

;OFOD: 320 ***********************************************
;OFOD: 321 *
;OFOD: 322 * CTRL-H PROCESS IN KOREAN 
;OFOD: 323 *
;OFOD: 324 ***********************************************

;0F0D:AD 52 12 326 
KCTRLH:
        LDA STATE       ;GET CURRENT ST.NO 
;0F10:0A 327    
        ASL A ;*2 
;0F11:AA 328 
        TAX 
;0F12:BD 32 OF 329 
        LDA KCTRLHV+1,X 
;0F15:48 330 
        PHA 
;0F16:BD 31 OF 331 
        LDA KCTRLHV,X 
;0F19:48 332 
        PHA 
;0F1A:AE 52 12 333 
        LDX STATE 
;OF1D:BD 26 0F 334 
        LDA STCONV,X    ;GET NEW STATE NO.
;0F20:8D 52 12 335 
        STA STATE 
;0F23:A9 20 336 
        LDA #$20        ;A BLANK 
;0F25:60 337 
        RTS             ;GO THERE 

;0F26: 339 *************************************
;0F26: 340 * 
;0F26: 341 * STATE COVERSION TABLE 
;0F26: 342 * 
;0F26: 343 ***********************************

;0F26:00 345 
STCONV:
        .byte $00       ;(0)->(0)
;0F27:00 346 
        .byte $00       ;(1)->(0)
;0F28:01 347 
        .byte $01       ;(2)->(1)
;0F29:01 348 
        .byte $01       ;(3)->(1)
;0F2A:02 349 
        .byte $02       ;(4)->(2)
;0F2B:03 350 
        .byte $03       ;(5)->(3)
;0F2C:03 351 
        .byte $03       ;(6)->(3)
;0F2D:04 352 
        .byte $04       ;(7)->(4)
;0F2E:06 353 
        .byte $06       ;(8)->(6)"

;0F2F:06 354 
        .byte $06
;0F30:09 355 
        .byte $09

;0F31: 357  *******************************
;0F31: 358  *
;0F31: 359  * CTRL-H JMP VECTOR IN KOREAN 
;0F31: 360  *
;0F31: 361  *******************************

;0F31:46 0F 363 
KCTRLHV:
        .word WASIN0-1
;0F33:4D 14 364 
        .word WASIN1-1
;0F35:77 0F 365 
        .word WASIN25-1
;0F37:62 14 366 
        .word WASIN3-1
;0F39:76 14 367 
        .word WASIN4-1
;0F3B:77 0F 368 
        .word WASIN25-1
;OF3D:58 14 369 
        .word WASIN6-1
;0F3F:5C 0F 370 
        .word WASIN7-1
;0F41:65 0F 371 
        .word WASIN8-1
;0F43:6E 0F 372 
        .word WASWHAT-1    ;?
;0F45:58 14 373 
        .word WASIN6-1     ;?

;0F47:C6 24 375 
WASIN0:
        DEC CH          ;CH=CH-1
;0F49:10 06 376 
        BPL NO1
;OF4B:A9 27 377 
        LDA #$27        ;RIGHTMOST
;OF4D:85 24 378 
        STA CH
;OF4F:C6 25 379 
        DEC CV
;0F51:20 57 0E 380 
NO1:
        JSR TPSAVE      ;CH,V SAVE
;0F54:A9 AO 381 
        LDA #$A0
;0F56:85 FF 382 
        STA SACC
;0F58:A9 20 383 
        LDA #$20        ;CHR.=BLANK!
;0F5A:4C 4E 14 384 
        JMP WASIN1      ;CV,CV+1 CLEAR!

;OF5D:AD 4C 12 386 
WASIN7:
        LDA P123B       ;GET C' OF 1ST
;0F60:20 77 14 387 
        JSR WASIN4      ;MAKE IT C OF 2ND
;0F63:4C 61 14 388 
        JMP LOWBLK

;OF66:AD 4C 12 390 
WASIN8:
        LDA P123B       ;GET C' OF 1ST
;0F69:20 59 14 391 
        JSR WASIN6      ;MAKE IT AS C OF 2ND
;0F6C:4C 61 14 392 
        JMP LOWBLK

;OF6F:AD 4C 12 394 
WASWHAT:
        LDA P123B
;0F72:20 59 14 395 
        JSR WASIN6
;0F75:4C 61 14 396 
        JMP LOWBLK

;0F78:20 59 14 398 
WASIN25:
        JSR WASIN6      ;DELETE V.V
;0F7B:4C 6B 14 399 
        JMP LOWBLK2

;0F7E:20 F4 0E 401 
KCTRLM:
        JSR KEYCHK      ;CHECK KEYBOARD
;0F81:20 D6 0E 402 
        JSR ASCROL
;0F84:60 403 
        RTS

;0F85: 405 ************************************************
;0F85: 406 *
;0F85: 407 * CTRL-CODE JMP VECTOR IN ENGLISH 
;0F85: 408 *
;0F85: 409 **************************************************

;0F85:FC OF 411 
ECTRLV:
        .word SIMRTN-1     ;CTRL-@ 
;OF87:FC 0F 412 
        .word SIMRTN-1     ;CTRL-A 
;0F89:FC OF 413 
        .word SIMRTN-1     ;CTRL-B 
;0F8B:BA 0F 414 
        .word LFCR-1       ;CTRL-C 
;OF8D:FC OF 415 
        .word SIMRTN-1     ;CTRL-D 
;OFBF:D6 0F 416 
        .word CTRLE-1      ;CTRL-E 
;0F91:DC 0F 417 
        .word CTRLF-1      ;CTRL-F 
;0F93:DC FB 418 
        .word BEEP-1       ;CTRL-6 
;0F95:E2 OF 419 
        .word CTRLH-1      ;CTRL-H 
;0F97:F7 OF 420 
        .word CTRLI-1      ;CTRL-I 
;0F99:38 11 421 
        .word CTRLJ-1      ;CTRL-J 
;OF9B:FD OF 422 
        .word CTRLK-1      ;CTRL-K 
;OF9D:FC 0F 423 
        .word SIMRTN-1     ;CTRL-L 
;0F9F:0B 10 424 
        .word CTRLM-1      ;CTRL-M 
;0FA1:1E 10 425 
        .word CTRLN-1      ;CTRL-N 
;0FA3:FC OF 426 
        .word SIMRTN-1     ;CTRL-O 
;0FA5:24 10 427 
        .word CTRLP-1      ;CTRL-P 
;0FA7:2A 10 428 
        .word CTRLQ-1      ;CTRL-Q 
;OFA9:FC 0F 429 
        .word SIMRTN-1     ;CTRL-R 
;OFAB:37 10 430 
        .word CTRLS-1      ;CTRL-S 
;OFAD:2D 16 431 
        .word CTRLT-1      ;CTRL-T 
;OFAF:FC 0F 432 
        .word SIMRTN-1     ;CTRL-U 
;0FB1:3D 10 433 
        .word CTRLV-1      ;CTRL-V 
;0FB3:69 10 434 
        .word CTRLW-1      ;CTRL-W 
;0FB5:FC 0F 435 
        .word SIMRTN-1     ;CTRL-X 
;0FB7:88 10 436 
        .word CTRLY-1      ;CTRL-Y 
;OFB9:AA 10 437 
        .word CTRLZ-1      ;CTRL-Z 

;OFBB:AD 50 OD 439
LFCR:
        LDA HICH 
;OFBE:C5 24 440 
        CMP CH 
;0FC0:85 24 441 
        STA CH 
;0FC2:F0 02 442 
        BEQ GOCR
;0FC4:B0 37 443 
        BCS SIMRTN 
;0FC6:4C 39 11 444 
GOCR:
        JMP CTRLJ 

;0FC9:2C 54 CO 446 
CHKPAG:
        BIT SCRSW+4     ;PAGE1 
;OFCC:AD 3F OD 447 
        LDA HGRAD       ;CHECK PAGE! 
;0FCF:C9 40 448 
        CMP #$40 
;OFD1:DO 2A 449 
        BNE SIMRTN 
;OFD3:2C 55 CO 450 
        BIT SCRSW+5     ;PA6E2 
;0FD6:60 451 
        RTS 

;0FD7:20 C2 11 453 
CTRLE:
        JSR HCLREOL     ;CLEAR END OF LINE 

;OFDA:4C 9C FC 454 
        JMP CLREOL 

;OFDD:20 AF 11 456 
CTRLF:
        JSR HCLREOP     ;CLEAR END OF PAGE 
;0FE0:4C 42 FC 457 
        JMP CLREOP 

;0FE3:C6 24 459 
CTRLH:
        DEC CH          ;CH=CH-1 
;0FE5:10 16 460 
        BPL SIMRTN      ;OVER RIGHT? 
;0FE7:A5 21 461 
        LDA WNDWDTH     ;THEN,CH=RIGHT-I 
;0FE9:85 24 462 
        STA CH 
;OFEB:C6 24 463 
        DEC CH 
;OFED:A5 22 464 
        LDA WNDTOP      ;CHECK IF TOP OVER? 
;0FEF:C5 25 465 
        CMP CV 
;OFF1:B0 0A 466 
        BCS SIMRTN 
;0FF3:C6 25 467 
        DEC CV          ;THEN,CV=TOP 
;0FF5:4C 22 FC 468 
        JMP VTAB 

;0FF8:A9 7F 470 
CTRLI:
        LDA #$7F        ;SET INVERSE 
;OFFA:8D 40 OD 471 
        STA INVFLG
;OFFD:60 472 
SIMRTN:
        RTS 

;OFFE:A9 80 474 
CTRLK:
        LDA #$80        ;SET KOR MODE 
;1000:8D 52 OD 475 
        STA KEMODE 
;1003:A5 25 476 
        LDA CV          ;CHECK CURRENT CV! 
;1005:C9 17 477 
        CMP #$17        ;BOTTOM LINE? 
;1007:DO F4 478 
        BNE SIMRTN 
;1009:4C EB 0E 479 
        JMP ATBTM 

;100C:20 F4 0E 481 
CTRLM:
        JSR KEYCHK 
;100F:A9 40 482 
        LDA #$40 
;1011:CD 52 OD 483 
        CMP KEMODE 
;1014:F0 06 484 
        BEQ SCRL1 
;1016:8D 52 OD 485 
        STA KEMODE 
;1019:4C D6 0E 486 
        JMP ASCROL 

;101C:4C 35 11 488 
SCRL1:
        JMP SCROL1 

;101F:A9 00 490 
CTRLN:
        LDA #0          ;SET NORMAL 
;1021:8D 40 OD 491 
        STA INVFLG
;1024:60 492 
        RTS 

;1025:20 A5 11 494 
CTRLP:
        JSR HIHOME      ;HOME! 
;1028:4C 58 FC 495 
        JMP HOME 

;102B:AD 50 OD 497 
CTRLQ:
        LDA HICH 
;102E:85 24 498 
        STA CH 
;1030:AD 51 OD 499 
        LDA HICV 
;1033:85 25 500 
        STA CV 
;1035:4C 24 FC 501 
        JMP VTABZ 

;1038:A9 CO 503 
CTRLS:
        LDA #$C0 
;103A:80 44 OD 504 
        STA CTSFL 
;103D:60 505 
        RTS 

;103E:A5 24 507 
CTRLV:
        LDA CH
;1040:65 20 508 
        ADC WNDLFT
;1042:C9 28 509 
        CMP #$28        ;OVER?
;1044:90 02 510 
        BCC NO2
;1046:A9 27 511 
        LDA #$27
;1048:85 20 512 
NO2:
        STA WNDLFT
;104A:38 513 
        SEC
;104B:A5 21 514 
        LDA WNDWDTH
;104D:E5 24 515 
        SBC CH
;104F:85 21 516 
        STA WNDWDTH
;1051:A9 00 517 
        LDA #0
;1053:85 24 518 
        STA CH
;1055:A5 25 519 
        LDA CV
;1057:C9 18 520 
        CMP #$18
;1059:90 02 521 
        BCC NO3
;105B:A9 17 522 
        LDA #$17
;105D:85 22 523 
NO3:
        STA WNDTOP
;105F:2C 4F OD 524 
        BIT NORML0
;1062:30 03 525 
        BMI GOVTAB
;1064:8D 51 OD 526 
        STA HICV
;1067:4C 22 FC 527 
GOVTAB:
        JMP VTAB

;106A:A5 24 529 
CTRLW:
        LDA CH
;106C:85 21 530 
        STA WNDWDTH
;106E:65 20 531 
        ADC WNDLFT
;1070:C9 28 532 
        CMP #$28
;1072:90 06 533 
        BCC NO4
;1074:A9 27 534 
        LDA #$27
;1076:E5 20 535 
        SBC WNDLFT
;1078:85 21 536 
        STA WNDWDTH
;107A:E6 21 537 
NO4:
        INC WNDWDTH
;107C:A5 25 538 
        LDA CV
;107E:C9 18 539 
        CMP #$18
;1080:90 02 540 
        BCC NO5
;1082:A9 17 541 
        LDA #$17
;1084:85 23 542 
NO5:
        STA WNDBTM
;1086:E6 23 543 
        INC WNDBTM
;1088:60 544 
        RTS

;1089:A5 20 546 
CTRLY:
        LDA WNDLFT      ;CH=WNDLFT+CH
;108B:65 24 547 
        ADC CH
;108D:85 24 548 
        STA CH
;108F:A9 00 549 
        LDA #0
;1091:85 20 550 
        STA WNDLFT      ;WNDLFT=0
;1093:85 22 551 
        STA WNDTOP      ;WNDTOP=0
;1095:2C 4F OD 552 
        BIT NORML0
;1098:30 06 553 
        BMI NO6
;109A:8D 50 OD 554 
        STA HICH
;109D:8D 51 OD 555 
        STA HICV
;10AO:A9 28 556
NO6:
        LDA #$28
;10A2:85 21 557 
        STA WNDWDTH

;10A4:A9 18 558 
        LDA #$18 
;10A6:85 23 559 
        STA WNDBTM 
;10A8:4C 22 FC 560 
        JMP VTAB 

;10AB:A9 00 562 
CTRLZ:
        LDA #0          ;CLEAR ALL MODE 
;10AD:AO 12 563 
        LDY #$12 
;10AF:99 3F OD 564 
CLR1:
        STA HGRAD,Y 
;10B2:88 565 
        DEY 
;10B3:10 FA 566 
        BPL CLR1 
;10B5:20 89 10 567 
        JSR CTRLY 
;10B8:A2 FF 568 
        LDX #<PATTERN
;10BA:A9 08 569 
        LDA #>PATTERN
;10BC:8E 45 OD 570 
        STX PATBASE 
;10BF:8D 46 OD 571 
        STA PATBASE+1 
;10C2:A9 20 572 
        LDA #$20        ;PAGE1 
;10C4:8D 3F OD 573 
        STA HGRAD 
;10C7:60 574 
        RTS 

;10C8: 576 ;*******************************************
;10C8: 577 ;
;10C8: 578 ; GET PATTERNS OF CHR. IN ACC. 
;10C8: 579 ; IF CODE=NX;PATTERN.L+X+B, 
;10C8: 580 ;             PATTERN.H+INT(N/2) 
;10C8: 581 ;            & DISPLAY THEM 
;10C8: 582 ;**************************************

;10C8:0A 584 
NORDISP:
        ASL A 
;10C9:26 EF 585 
        ROL PATLOC+1 
;10CB:0A 586 
        ASL A 
;10CC:26 EF 587 
        ROL PATLOC+1 
;10CE:0A 588 
        ASL A 
;10CF:26 EF 589 
        ROL PATLOC+1 
;10D1:18 590 CLC 
;10D2:6D 45 OD 591 
        ADC PATBASE 
;10D5:85 EE 592 
        STA PATLOC 
;10D7:A5 EF 593 
        LDA PATLOC+1 
;10D9:29 07 594 
        AND #7 
;10DB:6D 46 OD 595 
        ADC PATBASE+1 
;10DE:85 EF 596 
        STA PATLOC+1 

;10E0:20 00 12 598 
        JSR BASCALC1 
;10E3:65 24 599 
        ADC CH 
;10E5:85 2A 600 
        STA BAS2L 
;10E7:85 EC 601 
        STA PLOC 
;10E9:A5 2B 602 
        LDA BAS2L+1 
;10EB:4D 42 OD 603 
        EOR ADRFL 
;10EE:85 ED 604 
        STA PLOC+1 
;10F0:A4 24 605 
        LDY CH 
;10F2:A5 FF 606 
        LDA SACC 
;10F4:91 28 607 
        STA (BASL),Y
;10F6:A2 00 608 
        LDX #0

;10F8:A0 00 609 
        LDY #0 
;10FA:B1 EE 610 
DISPCON:
        LDA (PATLOC),Y  ;GET PATTERN 
;10FC:4D 40 OD 611 
        EOR INVFLG
;10FF:2C 41 OD 612 
        BIT POSFL 
;1102:10 11 613 
        BPL NO7 
;1104:70 OD 614 
        BVS DOEOR 
;1106:2C 40 OD 615 
        BIT INVFLG 
;1109:70 04 616 
        BVS DOAND 
;110B:01 EC 617 
        ORA (PLOC,X)
;110D:50 06 618 
        BVC NO7         ;GOTO 
;110F:21 EC 619 
DOAND:
        AND (PLOC,X) 
;1111:70 02 620 
        BVS NO7 
;1113:41 EC 621 
DOEOR:
        EOR (PLOC,X) 
;1115:81 2A 622 
NO7:
        STA (BAS2L,X) 
;1117:08 623 
        INY 
;1118:CO 08 624 
        CPY #8          ;8 SCAN LINE ALL? 
;111A:BO OD 625 
        BCS RTS4 
;111C:A5 2B 626 
        LDA BAS2L+1 
;111E:69 04 627 
        ADC #4          ;ADDR+$400 
;1120:85 2B 628 
        STA BAS2L+1 
;1122:4D 42 OD 629 
        EOR ADRFL 
;1125:85 ED 630 
        STA PLOC+1 
;1127:90 D1 631 
        BCC DISPCON 
;1129:60 632
RTS4:
        RTS 

;112A:20 C8 10 634 
NORMOUT:
        JSR NORDISP     ;DISP. A CHR. 
;112D:E6 24 635 
        INC CH          ;CH=CH+1 
;112F:A5 24 636 
        LDA CH 
;1131:C5 21 637 
        CMP WNDWDTH
;1133:90 20 638 
        BCC RTS5 
;1135:A9 00 639 
SCROL1:
        LDA #0
;1137:85 24 640 
        STA CH 
;1139:E6 25 641 
CTRLJ:
        INC CV          ;CV=CV+1 
;113B:A5 25 642 
        LDA CV          ;CHECK IF BOTTOM! 
;113D:C5 23 643 
        CMP WNDBTM 
;113F:90 11 644 
        BCC NOVER 
;1141:2C 43 OD 645 
        BIT AUTO        ;AUTO HOME FLAG? 
;1144:70 08 646 
        BVS AUTDON 
;1146:C6 25 647 
        DEC CV 
;1148:20 56 11 648 
        JSR HSCROL 
;114B:4C 70 FC 649 
        JMP SCROL 

;114E:A5 22 651 
AUTDON:
        LDA WNDTOP 
;1150:85 25 652 
        STA CV 
;1152:20 24 FC 653
NOVER:
        JSR VTABZ 
;1155:60 654 
RTS5:
        RTS 

;1156:A5 22 656 
HSCROL:
        LDA WNDTOP      ;FROM TOP! 
;1158:48 657 
        PHA 
;1159:20 02 12 658 
        JSR BASCALC 

;115C:A5 2A 659 
LOOP1:
        LDA BAS2L 
;115E:85 EC 660 
        STA PLOC        ;MAKE DESTINE. 
;1160:A5 2B 661 
        LDA BAS2L+1 
;1162:29 E3 662 
        AND #$E3 
;1164:85 ED 663 
        STA PLOC+1 
;1166:68 664 
        PLA 
;1167:18 665 
        CLC 
;1168:69 01 666 
        ADC #1          ;NEXT 
;116A:C5 23 667 
        CMP WNDBTM 
;116C:B0 22 668 
        BCS UPALL       ;ALL EXCEPT BOTTOM? 
;116E:48 669 
        PHA             ;SAVE FOR NEXT SCROL 
;116F:20 02 12 670 
        JSR BASCALC     ;MAKE SOURCE 
;1172:A2 07 671 
        LDX #7          ;8 TIMES 
;1174:A4 21 672 
LOOP2:
        LDY WNDWDTH 
;1176:88 673 
        DEY 
;1177:B1 2A 674 
SCRL:
        LDA (BAS2L),Y   ;FROM 
;1179:91 EC 675 
        STA (PLOC),Y    ;TO 
;117B:88 676 
        DEY 
;117C:10 F9 677 
        BPL SCRL 
;117E:CA 678 
        DEX 
;117F:30 DB 679 
        BMI LOOP1 
;1181:18 680 
        CLC 
;1182:A5 2B 681 
        LDA BAS2L+1 
;1184:69 04 682 
        ADC #4          ;NEXT SCAN LINE ADDR 
;1186:85 2B 683 
        STA BAS2L+1 
;1188:A5 ED 684 
        LDA PLOC+1 
;118A:69 04 685 
        ADC #4          ;NEXT SCAN LINE 
;118C:85 ED 686 
        STA PLOC+1 
;118E:DO E4 687 
        BNE LOOP2       ;GOTO 
;1190:AD 41 OD 688 
UPALL:
        LDA POSFL       ;BOTTOM LINE CLEA 
;1193:48 689 
        PHA 
;1194:A5 23 690 
        LDA WNDBTM 
;1196:E9 01 691 
        SBC #1 
;1198:A0 00 692 
        LDY #0 
;119A:8C 41 OD 693 
        STY POSFL 
;119D:20 C6 11 694 
        JSR HCLREOL1
;11A0:68 695 
        PLA 
;11A1:8D 41 OD 696 
        STA POSFL 
;11A4:60 697 
        RTS 

;11A5:A5 22 699
HIHOME:
        LDA WNDTOP      ;HI-GRAPHIC HOME 
;11A7:85 25 700 
        STA CV          ;FROM TOP 
;11A9:A0 00 701 
        LDY #0 
;11AB:84 24 702 
        STY CH 
;11AD:F0 04 703 
        BEQ HCLREOP1    ;GOTO
;11AF:A4 24 705 
HCLREOP:
        LDY CH          ;CLEAR END OF PAG 
;11B1:A5 25 706 
        LDA CV 
;11B3:48 707 
HCLREOP1:
        PHA 
;11B4:20 C6 11 708 
        JSR HCLREOL1    ;CLEAR A LINE 
;11B7:68 709
        PLA 

;11B8:18 710 
        CLC 
;11B9:69 01 711 
        ADC #1 
;11BB:C5 23 712 
        CMP WNDBTM 
;11BD:AO 00 713 
        LDY #0 
;11BF:90 F2 714 
        BCC HCLREOP1 
;11C1:60 715 
        RTS 

;11C2:A4 24 717 
HCLREOL:
        LDY CH          ;CLEAR END OF LINE 
;11C4:A5 25 718 
        LDA CV 
;11C6:84 EE 719 
HCLREOL1:
        STY PATLOC 
;11C8:20 02 12 720 
        JSR BASCALC 
;11CB:A2 07 721 
        LDX #7 
;11CD:AD 40 OD 722 
LOOP3:
        LDA INVFLG 
;11D0:2C 41 OD 723 
        BIT POSFL 
;11D3:10 15 724 
        BPL NO8
;11D5:A5 2A 725 
        LDA BAS2L 
;11D7:85 EC 726 
        STA PLOC 
;11D9:A5 2B 727 
        LDA BAS2L+1 
;11DB:4D 42 OD 728 
        EOR ADRFL 
;11DE:85 ED 729 
        STA PLOC+1 
;11E0:B1 EC 730 
        LDA (PLOC),Y
;11E2:2C 41 OD 731 
        BIT POSFL 
;11E5:50 03 732 
        BVC NO8
;11E7:4D 40 OD 733 
        EOR INVFLG
;11EA:91 2A 734
NO8:
        STA (BAS2L),Y
;11EC:C8 735 
        INY 
;11ED:C4 21 736 
        CPY WNDWDTH 
;11EF:90 DC 737 
        BCC LOOP3 
;11F1:CA 738 
        DEX 
;11F2:30 0B 739 
        BMI RTS7 
;11F4:A4 EE 740 
        LDY PATLOC 
;11F6:A5 2B 741 
        LDA BAS2L+1 
;11F8:18 742 
        CLC 
;11F9:69 04 743 
        ADC #4 
;11FB:85 2B 744 
        STA BAS2L+1 
;11FD:DO CE 745 
        BNE LOOP3 
;11FF:60 746 
RTS7:
        RTS 

;1200:A5 25 748 
BASCALC1:
        LDA CV 

;1202: 750 *****************************************************
;1202: 751 * 
;1202: 752 * BASE CALCULATION:CV IN ACC.->BAS2L, +1 
;1202: 753 * 
;1202: 754 *****************************************************

;1202:4A 756 
BASCALC:
        LSR A           ;/2 
;1203:AA 757 
        TAX 
;1204:29 03 758 
        AND #3 
;1206:0D 3F OD 759 
        ORA HGRAD
;1209:85 2B 760 
        STA BAS2L+1 
;120B:BD 14 12 761 
        LDA BASETBL,X 
;120E:6A 762 
        ROR A 
;120F:65 20 763 
        ADC WNDLFT 
;1211:85 2A 764 
        STA BAS2L 
;1213:60 765 
        RTS 

;1214:00 767 
BASETBL:
        .byte $00         ;FOR 0,1 
;1215:00 768 
        .byte $00         ;FOR 2,3 
;1216:00 769 
        .byte $00         ;FOR 4,5 
;1217:00 770 
        .byte $00         ;FOR 6, 7 
;1218:50 771 
        .byte $50         ;FOR 8,9 
;1219:50 772 
        .byte $50         ;FOR a,b 
;121A:50 773 
        .byte $50         ;FOR c,d 
;121B:50 774 
        .byte $50         ;FOR E,F 
;121C:A0 775 
        .byte $A0         ;FOR 10,11 
;121D:AO 776 
        .byte $A0         ;FOR 12,13 
;121E:A0 777 
        .byte $A0         ;FOR 14,15 
;121F:A0 778 
        .byte $A0         ;FOR 16,17 

;1220:38 780 
KOROUT:
        SEC 
;1221:E9 20 781 
        SBC #$20        ;SUBTRACT BASE CODE 
;1223:AA 782 
        TAX 
;1224:BD DB 12 783 
        LDA CONVTBL,X 
;1227:85 EF 784 
        STA PATLOC+1 
;1229:BD 9B 12 785 
        LDA TYPETBL,X   ;GET CHR.TYPE 
;122C:85 EE 786 
        STA PATLOC 
;122E:20 57 0E 787 
        JSR TPSAVE 
;1231:AD 52 12 788 
        LDA STATE 
;1234:0A 789 
        ASL A 
;1235:0A 790 
        ASL A 
;1236:0A 791 
        ASL A           ;*8 
;1237:18 792 
        CLC 
;1238:65 EE 793 
        ADC PATLOC 
;123A:AA 794 
        TAX 
;123B:BD 54 12 795 
        LDA PROCS+1,X
;123E:48 796 
        PHA 
;123F:BD 53 12 797 
        LDA PROCS,X 
;1242:48 798 
        PHA 
;1243:A5 EF 799 
        LDA PATLOC+1    ;ACC.=CODE 
;1245:60 800 
        RTS 

;1246: 802 
TEMPCV:
        .res 1 
;1247: 803 
TEMPCH:
        .res 1 
;1248:00 804 
        .byte $00 
;1249:00 805 
        .byte $00 
;124A:00 806 
P1239:
        .byte $00 
;124B:00 807 
P123A:
        .byte $00 
;124C:00 808 
P123B:
        .byte $00

;124D:00 809 
P123C:
        .byte $00 
;124E:00 810 
P123D:
        .byte $00 
;124F:00 811 
P123E:
        .byte $00 
;1250:00 812 
P123F:
        .byte $00 
;1251:00 813 
P1240:
        .byte $00 
;1252:00 814 
STATE:
        .byte $00         ;AUTOMATA STATE 

;1253: 816 ***********************
;1253: 817 *
;1253: 818 * KOREAN PROCESSING PROCEDURE 
;1253: 819 * ON CONSONANT 
;1253: 820 * ON VERT.VOWEL 
;1253: 821 * ON HOR.VOWEL 
;1253: 822 * ON SYMBOL 
;1253: 823 *
;1253: 824 **************************

;1253:2E 13 826 
PROCS:
        .word ST0C-1
;1255:36 13 827 
        .word ST0VV-1
;1257:3C 13 828 
        .word ST0HV-1
;1259:42 13 829 
        .word ST0S-1

;125B:4D 13 831
        .word ST1CS-1 
;125D:53 13 832 
        .word ST1VV-1 
;125F:5B 13 833 
        .word ST1HV-1 
;1261:40 13 834 
        .word ST1CS-1 

;1263:63 13 836 
        .word ST25C-1 
;1265:6B 13 837 
        .word ST25VV-1 
;1267:71 13 838 
        .word ST2HV-1 
;1269:79 13 839 
        .word ST25S-1 

;126B:87 13 841 
        .word ST3C-1 
;126D:8F 13 842 
        .word ST3VV-1 
;126F:4D 13 843 
        .word ST1CS-1 
;1271:97 13 844 
        .word ST3S-1 

;1273:A2 13 846 
        .word ST4C-1 
;1275:B8 13 847 
        .word ST47VV-1 
;1277:C3 13 848 
        .word ST47HV-1 
;1279:CE 13 849 
        .word ST4S-1 

;127B:63 13 851 
        .word ST25C-1 
;127D:6B 13 852 
        .word ST25VV-1 
;127F:6B 13 853 
        .word ST25VV-1 
;1281:79 13 854 
        .word ST25S-1 

;1283:DF 13 856 
        .word ST6C-1 
;1285:F2 13 857 
        .word ST68VV-1 
;1287:FD 13 858 
        .word ST68HV-1 
;1289:08 14 859 
        .word ST6S-1 

;128B:16 14 861 
        .word ST7C-1 
;128D:B8 13 862 
        .word ST47VV-1 
;128F:C3 13 863 
        .word ST47HV-1 
;1291:29 14 864 
        .word ST7S-1 

;1293:3C 14 866 
        .word ST8C-1
;1295:F2 13 867 
        .word ST68VV-1 
;1297:FD 13 868 
        .word ST68HV-1 
;1299:34 14 869 
        .word ST8S-1 

;129B: 871 ******************************
;129B: 872 *
;129B: 873 * CHR.TYPE TABLE: (0):CONSONANT 
;129B: 874 * (2) : VERT.VOWEL 
;129B: 875 * (4) :HOR.VOWEL 
;129B: 876 * (6):SYMBOL,NUMERICS 
;129B: 877 *
;129B: 878 **************************** 

;129B:06 880 
TYPETBL:
        .byte $06         ;SPC. 
;129C:06 881 
        .byte $06         ;!
;129D:06 882 
        .byte $06         ;"
;129E:06 883 
        .byte $06         ;#
;129F:06 884 
        .byte $06         ;$
;12AO:06 885 
        .byte $06         ;%
;12A1:06 886 
        .byte $06         ;&
;12A2:06 887
        .byte $06         ;'
;12A3:06 888 
        .byte $06         ;{ 
;12A4:06 889 
        .byte $06         ;}
;12A5:00 890 
        .byte $00         ;+(DBL.CON.1) 
;12A6:02 891 
        .byte $02         ;+(K.V.YE) 
;12A7:06 892 
        .byte $06         ;, 
;12A8:00 893 
        .byte $00         ;-(DBL.CON.2) 
;12A9:06 894 
        .byte $06         ;. 
;12AA:06 895 
        .byte $06         ;/ 
;12AB:06 06 06 896 
        .byte $06,$06,$06,$06,$06 ;0,1,2,3,4
;12AE:06 06
;12B0:06 06 06 897 
        .byte $06,$06,$06,$06,$06 ;5,6,7,8,9 
;12B3:06 06
;12B5:06 898 
        .byte $06         ;: 
;12B6:02 899 
        .byte $02         ;;(K.V.YAE) 
;12B7:00 900 
        .byte $00         ;<(DBL.CON.3) 
;12B8:00 901 
        .byte $00         ;=(DBL.CON.4) 
;12B9:00 902 
        .byte $00         ;>(DBL.CON.5) 
;12BA:06 06 903 
        .byte $06,$06 ;?,@ 
;12BC:00 904 
        .byte $00         ;A(CON.)
;12BD:04 905 
        .byte $04         ;B(K.V.YOO) 
;12BE:00 906 
        .byte $00         ;C(CON.) 
;12BF:00 907 
        .byte $00         ;D(CON.) 
;12C0:00 908 
        .byte $00         ;E(CON.) 
;12C1:00 909 
        .byte $00         ;F(CON.) 
;12C2:00 910 
        .byte $00         ;G(CON.) 
;12C3:04 911 
        .byte $04         ;H(K.V.O) 
;12C4:02 912 
        .byte $02         ;I(K.V.YA) 
;12C5:02 913 
        .byte $02         ;J(K.V.EO) 
;12C6:02 914 
        .byte $02         ;K(K.V.A) 
;12C7:02 915 
        .byte $02         ;L(K.V.YEE) 
;12C8:04 916 
        .byte $04         ;M(K.V.EU) 
;12C9:04 917 
        .byte $04         ;N(K.V.WOO) 
;12CA:02 918 
        .byte $02         ;0(K.V.AE) 
;12CB:02 919 
        .byte $02         ;P(K. V.E) 
;12CC:00 920 
        .byte $00         ;Q(CON.) 
;12CD:00 921 
        .byte $00         ;R(CON.) 
;12CE:00 922 
        .byte $00         ;S(CON.)
;12CF:00 923 
        .byte $00         ;T(CON.)
;12D0:02 924 
        .byte $02         ;U(K.V.YEO) 
;12D1:00 925 
        .byte $00         ;V(CON.) 
;12D2:00 926 
        .byte $00         ;W(CON.) 
;12D3:00 927 
        .byte $00         ;X(CON.) 
;12D4:04 928 
        .byte $04         ;Y(K.V.YO) 
;12D5:00 929 
        .byte $00         ;Z(CON.)
;12D6:06 930 
        .byte $06         ;LEFT SQB 
;1207:06 931 
        .byte $06         ;INV SLSH 
;12D8:06 932 
        .byte $06         ;RIGHT SQB 
;12D9:06 933 
        .byte $06         ;^ 
;12DA:06 934 
        .byte $06 


;12DB: 936 ************************
;12DB: 937 *
;12DB: 938 * CODE CONVERSION TABLE 
;12DB: 939 * 
;12DB: 940 ************************

;12DB:20 21 22 942 
CONVTBL:
        .byte $20,$21,$22,$23 
;12DE:23 
;12DF:24 25 26 943 
        .byte $24,$25,$26,$27 
;12E2:27 
;12E3:28 29 66 944 
        .byte $28,$29,$66,$78 
;12E6:78 
;12E7:2C 5F 2E 945 
        .byte $2C,$5F,$2E,$2F 
;12EA:2F 
;12EB:30 31 32 946 
        .byte $30,$31,$32,$33 
;12EE:33 
;12EF:34 35 36 947 
        .byte $34,$35,$36,$37 
;12F2:37 
;12F3:38 39 5C 948 
        .byte $38,$39,$5C,$74 
;12F6:74 
;12F7:68 62 6B 949 
        .byte $68,$62,$6B,$3F 
;12FA:3F 
;12FB:40 64 7C 950 
        .byte $40,$64,$7C,$6C 
;12FE:6C 
;12FF:69 61 63 951 
        .byte $69,$61,$63,$70
;1302:70 
;1303:79 73 75 952 
        .byte $79,$73,$75,$71 
;1306:71 
;1307:7E 7D 7B 953 
        .byte $7E,$7D,$7B,$72 
;130A:72 
;130B:76 65 5E 954 
        .byte $76,$65,$5E,$60 
;130E:60 
;130F:67 77 6F 955 
        .byte $67,$77,$6F,$6A 
;1312:6A 
;1313:6E 7A 6D 956 
        .byte $6E,$7A,$6D,$5B 
;1316:5B 
;1317:5C 5D 5E 957 
        .byte $5C,$5D,$5E,$5F 
;131A:5F 


;131B: 959 *******************************
;131B: 960 * COMPLEX CONSONANT I.D. LISTS 
;131B: 961 * IF 0,CANNOT BE COMBINED! 
;131B: 962 * IF NOT 0,ENTRY IS NEW CODE 
;131B: 963 *
;131B: 964 *******************************

;131B:00 966 
CPLXCN:
        .byte $00 
;131C:12 967 
        .byte $12 
;131D:00 968 
        .byte $00 
;131E:00 969 
        .byte $00 
;131F:00 970 
        .byte $00 
;1320:0F 971 
        .byte $0F 
;1321:00 972 
        .byte $00 
;1322:13 973 
        .byte $13 
;1323:14 974 
        .byte $14 
;1324:10 975 
        .byte $10 
;1325:15 976 
        .byte $15 
;1326:00 977 
        .byte $00 
;1327:19 978 
        .byte $19 
;1328:00 979 
        .byte $00 
;1329:00 980 
        .byte $00 
;132A:00 981 
        .byte $00 
;132B:11 982 
        .byte $11 
;132C:16 983 
        .byte $16 
;132D:17 984 
        .byte $17 
;132E:18 985 
        .byte $18 


;132F:20 4E 14 987 
ST0C:
        JSR WASIN1      ;CON IN ACC.OUT
;1332:A9 01 988 
        LDA #1          ;NEXT STATE 
;1334:4C 4A 14 989 
        JMP CONTPRO 

;1337:20 FF 14 991 
ST0VV:
        JSR VVDSP       ;V.V.DISP.
;133A:4C E8 15 992 
        JMP ESFTFB1     ;BEEP&CLEAR COND.BF.ALL! 

;133D:20 4E 14 994 
ST0HV:
        JSR WASIN1      ;DISP.H.V AT UPPER

;1340:4C EB 15 995 
        JMP ESFTFB1     ;BEEP&CLEAR COND.BF. ALL! 
;1343:20 4E 14 997 
ST0S:
        JSR WASIN1      ;CV,CH<-ACC:CV+1, CH<-BLANK
;1346:20 6D 15 998 
        JSR SFTFB1      ;SHIFT COND.BF. 1 TIME 
;1349:A9 00 999 
        LDA #0          ;NEXT STATE 
;134B:4C 4A 14 1000 
        JMP CONTPRO 
;134E:20 59 14 1002 
ST1CS:
        JSR WASIN6      ;DISP.IT!
;1351:4C F1 15 1003 
        JMP ECONDCL1    ;BEEP&CLEAR COND. BF.ALL! 

;1354:20 0A 15 1005 
ST1VV:
        JSR DISPVV      ;DISP V.V 
;1357:A9 02 1006 
        LDA #2          ;NEXT STATE 
;1359:4C 4A 14 1007 
        JMP CONTPRO 

;135C:20 63 14 1009 
ST1HV:
        JSR WASIN3      ;H.V DISP. AT LOW C.V POS 
;135F:A9 03 1010 
        LDA #3          ;NEXT STATE 
;1361:4C 4A 14 1011 
        JMP CONTPRO 

;1364:20 77 14 1013 
ST25C:
        JSR WASIN4      ;CHECK CH & DISP.C 
;1367:A9 04 1014 
        LDA #4          ;NEXT STATE 
;1369:4C 4A 14 1015 
        JMP CONTPRO 

;136C:20 15 15 1017 
ST25VV:
        JSR DISPVV1     ;V.V DISP. 
;136F:4C E5 15 1018 
        JMP ESFTFB3     ;BEEP&CLEAR 

;1372:20 63 14 1020 
ST2HV:
        JSR WASIN3      ;H.V DISP. 
;1375:A9 05 1021 
        LDA #5          ;NEXT STATE 
;1377:4C 4A 14 1022
        JMP CONTPRO

;137A:20 77 14 1024 
ST25S:
        JSR WASIN4      ;DISP.SYMBOL 
;137D:20 AB 15 1025 
        JSR SFTFB2      ;ADJUST COND.BF 
;1380:20 60 15 1026 
        JSR SFTFB1 
;1383:A9 00 1027 
        LDA #0          ;NEXT STATE 
;1385:4C 4A 14 1028 
        JMP CONTPRO 

;1388:20 59 14 1030 
ST3C:
        JSR WASIN6      ;C DISP! $123A <-C 
;138B:A9 06 1031 
        LDA #6          ;NEXT STATE 
;138D:4C 4A 14 1032 
        JMP CONTPRO 

;1390:20 0A 15 1034 
ST3VV:
        JSR DISPVV      ;V.V DISP&SET $123A,C WITH V.V 
;1393:A9 05 1035 
        LDA #5          ;NEXT STATE 
;1395:4C 4A 14 1036 
        JMP CONTPRO 

;1398:20 59 14 1038 
ST3S:
        JSR WASIN6      ;DISP SYM& SET $123A WITH SYM 
;139B:20 AB 15 1039 
        JSR SFTFB2      ;FONT BF2 - > BF1 
;139E:A9 00 1040 
        LDA #0          ;NEXT STATE 
;13AO:4C 4A 14 1041 
        JMP CONTPRO 
;13A3:48 1043 
ST4C:
        PHA             ;C SAVE 
;13A4:20 2B 15 1044 
        JSR MOVPOS 
;13A7:20 6B 14 1045 
        JSR LOWBLK2     ;BLANK $123C 
;13AA:AD 4E 12 1046 
        LDA P123D       ;C OF 2ND - > C' OF 1ST 

;13AD:20 63 14 1047 
        JSR WASIN3      ;P123D -> P123B& P123B DISP.
;13B0:68 1048 i
        PLA             ;RESTORE C 
;13B1:20 77 14 1049 
        JSR WASIN4      ;DISP IT!& C-> P123D 
;13B4:A9 07 1050 
        LDA #7          ;NEXT STATE 
;13B6:4C 4A 14 1051 
        JMP CONTPRO 
;13B9:20 20 15 1053 
ST47VV:
        JSR DISPVV2     ;V->P123E 
;13BC:20 AB 15 1054 
        JSR SFTFB2      ;V.V^0F->P1240 
;13BF:A9 02 1055 
        LDA #2          ;NEXT STATE 
;13C1:4C 4A 14 1056 
        JMP CONTPRO 

;13C4:20 B5 14 1058 
ST47HV:
        JSR HVDSP        ;H.V - > P123F&DISP 
;13C7:20 AB 15 1059 
        JSR SFTFB2      ;COND. B.F2->B.F.1& CLR BF2 
;13CA:A9 03 1060 
        LDA #3          ;NEXT STATE 
;13CC:4C 4A 14 1061 
        JMP CONTPRO 
;13CF:48 1063 
ST4S:
        PHA             ;SYM.SAVE 
;13D0:20 2B 15 1064 
        JSR MOVPOS 
;13D3:AD 4E 12 1065 
        LDA P123D       ;LOAD C OF 2ND. 
;13D6:20 63 14 1066 
        JSR WASIN3      ;P123D->P123B 
;13D9:20 6B 14 1067 
        JSR LOWBLK2     ;P123C<-BLANK 
;13DC:68 1068 
        PLA             ;RESTORE SYM. 
;13DD:4C 7A 13 1069 
        JMP ST25S       ;DISP.SYMBOL 

;13E0:48 1071 
ST6C:
        PHA             ;SAVE C 
;13E1:20 2B 15 1072 
        JSR MOVPOS      ;P123A<-P123B+P123A 
;13E4:AD 4B 12 1073 
        LDA P123A       ;GET C OF 2ND. 
;13E7:20 63 14 1074 
        JSR WASIN3      ;P123A->P123B 
;13EA:68 1075 
        PLA             ;RESTORE C 
;13EB:20 59 14 1076 
        JSR WASIN6      ;DISP.IT(ACC. ->P123A 
;13EE:A9 08 1077 
        LDA #8          ;NEXT STATE 
;13F0:4C 4A 14 1078 
        JMP CONTPRO 

;13F3:20 15 15 1080 
ST68VV:
        JSR DISPVV1     ;V.V DISP. (V. V ->P123D,V.V^OF->P123F 
;13F6:20 6D 15 1081 
        JSR SFTFB1      ;SHFT COND.BF 
;13F9:A9 02 1082 
        LDA #2          ;NEXT STATE 
;13FB:4C 4A 14 1083 
        JMP CONTPRO 
;13FE:20 6D 14 1085 
ST68HV:
        JSR HVDSP1      ;H. V->P123C 
;1401:20 60 15 1086 
        JSR SFTFB1      ;SHFT COND.BF 
;1404:A9 03 1087 
        LDA #3          ;NEXT STATE 
;1406:4C 4A 14 1088 
        JMP CONTPRO 
;1409:48 1090 
ST6S:
        PHA             ;SAVE SYMBOL 
;140A:20 2B 15 1091 
        JSR MOVPOS      ;P123A<-P123A+ P123B(H.V) 

;140D:AD 4B 12 1092 
        LDA P123A       ;GET C OF 2ND. 
;1410:20 63 14 1093 
        JSR WASIN3      ;P123A->P123B 
;1413:68 1094 
        PLA             ;RESTORE SYMBOL 
;1414:4C 98 13 1095 
        JMP ST3S

;1417:48 1097
ST7C:
        PHA             ;SAVE C
;1418:AD 4E 12 1098 
        LDA P123D       ;LOAD C OF 2ND. 

;141B:20 6D 14 1099 
        JSR HVDSP1      ;->P123C 
;141E:68 1100 
        PLA             ;RESTORE C 
;141F:20 77 14 1101 
        JSR WASIN4      ;->P123D 
;1422:20 AB 15 1102 
        JSR SFTFB2      ;COND.BF2->B.F1 
;1425:A9 01 1103 
        LDA #1          ;NEXT STATE 
;1427:4C 4A 14 1104 
        JMP CONTPRO 

;142A:48 1106 
ST7S:
        PHA             ;SAVE SYMBOL 
;142B:AD 4E 12 1107 
        LDA P123D       ;LOAD C OF 2ND. & 
;142E:20 6D 14 1108 
        JSR HVDSP1      ;->P123C 
;1431:68 1109 
        PLA             ;RESTORE SYM 
;1432:4C 7A 13 1110 
        JMP ST25S 

;1435:48 1112 
ST8S:
        PHA             ;SAVE SYM 
;1436:20 46 15 1113 
        JSR CHKCPLX     ;CHECK COMPLEX (CPLX->P123B&DSP) 
;1439:68 1114 
        PLA             ;RESTORE SYM 
;143A:4C 98 13 1115 
        JMP ST3S 
;143D:48 1117 
ST8C:
        PHA             ;SAVE C 
;143E:20 46 15 1118 
        JSR CHKCPLX     ;IF CPLX,CPLX->P123B 
;1441:68 1119 
        PLA 
;1442:20 59 14 1120 
        JSR WASIN6      ;C->P123A & DSP. 
;1445:20 6D 15 1121 
        JSR SFTFB1      ;SHFT COND.BF2,1 
;1448:A9 01 1122 
        LDA #1          ;NEXT STATE 

;144A:8D 52 12 1124 
CONTPRO:
        STA STATE       ;RECORD STATE 
;144D:60 1125 
        RTS 

;144E:48 1127 
WASIN1:
        PHA             ;CURRENT CHR.PUSH 
;144F:8D 4A 12 1128 
        STA P1239 
;1452:20 61 14 1129 
        JSR LOWBLK      ;LOW CLEAR&RESTORE CV 
;1455:68 1130 
        PLA 
;1456:4C F8 14 1131 
        JMP OUTGEN      ;UPPER HALF. 

;1459:E6 24 1133 
WASIN6:
        INC CH          ;CH=CH+1 
;145B:8D 4B 12 1134 
        STA P123A       ;C->P123A 
;145E:4C F8 14 1135 
        JMP OUTGEN      ;DISP. IT! 

;1461:A9 20 1137 
LOWBLK:
        LDA #$20        ;BLANK
;1463:E6 25 1138 
WASIN3:
        INC CV          ;LOWER POS.
;1465:8D 4C 12 1139 
        STA P123B       ;CHR.SAVE 
;1468:4C F8 14 1140 
        JMP OUTGEN      ;DISP. IT! 

;146B:A9 20 1142 
LOWBLK2:
        LDA #$20        ;BLANK 
;146D:E6 25 1143 
HVDSP1:
        INC CV          ;LOWER POS. 
;146F:E6 24 1144 
        INC CH 
;1471:8D 4D 12 1145 
        STA P123C       ;LOWER V.V 
;1474:4C F8 14 1146 
        JMP OUTGEN      ;DISP.IT! 

;1477:48 1148 
WASIN4:
        PHA             ;CURRENT C->P123D 
;1478:8D 4E 12 1149 
        STA P123D 
;147B:A5 24 1150 
        LDA CH

;147D:C9 24 1151 
        CMP #$24 
;147F:10 08 1152 
        BPL NXT1 
;1481:E6 24 1153 
        INC CH 
;1483:E6 24 1154 
        INC CH 
;1485:68 1155 
        PLA 
;1486:4C F8 14 1156 
        JMP OUTGEN 
;1489:E6 25 1157 
NXT1:
        INC CV 
;148B:E6 25 1158 
        INC CV 
;148D:A9 00 1159 
        LDA #0 
;148F:85 24 1160 
        STA CH 
;1491:68 1161 
        PLA 
;1492:4C F8 14 1162 
        JMP OUTGEN      ;DISP. IT! 

;1495:48 1164 
VVDSP2:
        PHA 
;1496:80 4F 12 1165 
        STA P123E 
;1499:A5 24 1166 
        LDA CH 
;149B:C9 24 1167 
        CMP #$24 
;149D:10 0A 1168 
        BPL NXT2 
;149F:E6 24 1169 
        INC CH 
;14A1:E6 24 1170 
        INC CH 
;14A3:E6 24 1171 
        INC CH 
;14A5:68 1172 
        PLA 
;14A6:4C F8 14 1173 
        JMP OUTGEN 
;14A9:E6 25 1174 
NXT2:
        INC CV 
;14AB:E6 25 1175 
        INC CV 
;14AD:A9 01 1176 
        LDA #1 
;14AF:85 24 1177 
        STA CH 
;14B1:68 1178 
        PLA 
;14B2:4C FB 14 1179 
        JMP OUTGEN

;14B5:48 1181 
HVDSP:
        PHA             ;SAVE LOW CODE OF H.V 
;14B6:8D 50 12 1182 
        STA P123F 
;14B9:A5 24 1183 
        LDA CH 
;14BB:C9 24 1184 
        CMP #$24 
;14BD:10 0A 1185 
        BPL NXT3 
;14BF:E6 24 1186 
        INC CH 
;14C1:E6 24 1187 
        INC CH 
;14C3:E6 25 1188 
        INC CV 
;14C5:68 1189 
        PLA 
;14C6:4C F8 14 1190 
        JMP OUTGEN 

;14C9:E6 25 1192 
NXT3:
        INC CV 
;14CB:E6 25 1193 
        INC CV 
;14CD:E6 25 1194 
        INC CV 
;14CF:A9 00 1195 
        LDA #0 
;14D1:85 24 1196 
        STA CH 
;14D3:68 1197 
        PLA 
;14D4:4C F8 14 1198 
        JMP OUTGEN 

;14D7:48 1200 
LVVDSP:
        PHA 
;14D8:8D 51 12 1201 
        STA P1240 
;14DB:A5 24 1202 
        LDA CH

;14DD:C9 24 1203 
        CMP #$24 
;14DF:10 0C 1204 
        BPL NXT4 
;14E1:E6 24 1205 
        INC CH 
;14E3:E6 24 1206 
        INC CH 
;14E5:E6 24 1207 
        INC CH 
;14E7:E6 25 1208 
        INC CV 
;14E9:68 1209 
        PLA 
;14EA:4C F8 14 1210 
        JMP OUTGEN 

;14ED:E6 25 1212 
NXT4:
        INC CV
;14EF:E6 25 1213 
        INC CV 
;14F1:E6 25 1214 
        INC CV 
;14F3:A9 01 1215 
        LDA #1 
;14F5:85 24 1216 
        STA CH 
;14F7:68 1217 
        PLA 
;14F8:20 C8 10 1218 
OUTGEN:
        JSR NORDISP 
;14FB:20 62 0E 1219 
        JSR TPLOAD 
;14FE:60 1220 RTS51 
        RTS 

;14FF:48 1222 
VVDSP:
        PHA             ;V.V SAVE 
;1500:20 4E 14 1223
        JSR WASIN1      ;CLR LOW&DSP.UPPER
;1503:68 1224 
        PLA 
;1504:29 0F 1225 
        AND #$0F 
;1506:20 63 14 1226 
        JSR WASIN3      ;MAKE LOWER 
;1509:60 1227 
        RTS 

;150A:48 1229 
DISPVV:
        PHA             ;SAVE V.V 
;150B:20 59 14 1230 
        JSR WASIN6      ;LOE CLR & UP DSP. 
;150E:68 1231 
        PLA 
;150F:29 0F 1232 
        AND #$0F        ;LEAVE LOW
;1511:20 6D 14 1233 
        JSR HVDSP1 
;1514:60 1234 
        RTS 

;1515:48 1236 
DISPVV1:
        PHA             ;SAVE V.V 
;1516:20 77 14 1237 
        JSR WASIN4      ;DISP UPPER 
;1519:68 1238 
        PLA 
;151A:29 OF 1239 
        AND #$0F         ;LEAVE LOW OF V.V
;151C:20 B5 14 1240 
        JSR HVDSP 
;151F:60 1241 
        RTS 

;1520:48 1243 
DISPVV2:
        PHA             ;SAVE V.V 
;1521:20 95 14 1244 
        JSR VVDSP2      ;V.V DSP(V.V ->P123E) 
;1524:68 1245 
        PLA
;1525:29 OF 1246
        AND #$0F        ;V.V^OF 
;1527:20 D7 14 1247 
        JSR LVVDSP      ;LOW DSP & LOW ->P1240 
;152A:60 1248 
        RTS 
        
;152B:A9 80 1250 
MOVPOS:
        LDA #$80        ;TEMP MODE CHANGE 
;152D:8D 41 OD 1251 
        STA POSFL 
;1530:A9 00 1252 
        LDA #0 
;1532:80 42 OD 1253 
        STA ADRFL 
;1535:AD 4C 12 1254 
        LDA P123B 

;1538:29 0F 1255 
        AND #$0F 
;153A:20 C8 10 1256 
        JSR NORDISP 
;153D:20 62 0E 1257 
        JSR TPLOAD 
;1540:A9 00 1258 
        LDA #0 
;1542:80 41 OD 1259 
        STA POSFL 
;1545:60 1260 
        RTS 

;1546:AD 4C 12 1262 
CHKCPLX:
        LDA P123B       ;1ST CON. 
;1549:85 EE 1263 
        STA PATLOC 
;154B:AD 4B 12 1264 
        LDA P123A       ;2ND CON. 
;154E:C9 6A 1265 
        CMP #$6A        ;CHECK 2ND IF W 
;1550:00 02 1266 
        BNE NOCOS 
;1552:C6 EE 1267 
        DEC PATLOC 
;1554:18 1268 
NOCOS:
        CLC 
;1555:65 EE 1269 
        ADC PATLOC 
;1557:38 1270 
        SEC 
;1558:E9 CO 1271 
        SBC #$C0
;155A:AA 1272 
        TAX 
;155B:C9 14 1273 
        CMP #$14        ;FILTERING! 
;155D:BO 07 1274 
        BCS NOCOMB 
;155F:BD 1B 13 1275 
        LDA CPLXCN,X 
;1562:09 00 1276 
        CMP #0          ;IF 0,CANNOT BE COMBINED! 
;1564:DO 04 1277 
        BNE GOCPLX
;1566:20 DD FB 1278 
NOCOMB:
        JSR BEEP 
;1569:60 1279 
        RTS 

;156A:4C 63 14 1281 
GOCPLX:
        JMP WASIN3 

;156D:A5 24 1283 
SFTFB1:
        LDA CH 
;156F:C9 25 1284 
        CMP #$25 
;1571:10 05 1285 
        BPL NO9 
;1573:E6 24 1286 
        INC CH 
;1575:4C 7B 15 1287 
        JMP SFTBFA 
;1578:20 D6 0E 1288 
NO9:
        JSR ASCROL

;157B: 1290 ************************************
;157B: 1291 *
;157B: 1292 * CONDITION BUFFER ADJUST: 
;157B: 1293 * (9)<-(A)<-(D)<-(E) 
;157B: 1294 * (B)<-(C)<-(F)<-(0) 
;157B: 1295 * 
;1578: 1296 ********************************

;157B:AD 4B 12 1298 
SFTBFA:
        LDA P123A 
;157E:8D 4A 12 1299 
        STA P1239 
;1581:AD 4D 12 1300 
        LDA P123C 
;1584:80 4C 12 1301 
        STA P123B 
;1587:AD 4E 12 1302 
        LDA P123D 
;158A:80 4B 12 1303 
        STA P123A 
;158D:AD 50 12 1304 
        LDA P123F 
;1590:8D 4D 12 1305 
        STA P123C 
;1593:AD 4F 12 1306 
        LDA P123E 

;1596:80 4E 12 1307 
        STA P123D
;1599:AD 51 12 1308 
        LDA P1240
;159C:8D 50 12 1309 
        STA P123F
;159F:A9 00 1310 
        LDA #0
;15A1:8D 50 12 1311 
        STA P123F
;15A4:80 51 12 1312 
        STA P1240
;15A7:20 22 FC 1313 
        JSR VTAB
;15AA:60 1314 
        RTS

;15AB:A5 24 1316 
SFTFB2:
        LDA CH
;15AD:C9 24 1317 
        CMP #$24
;15AF : 10 07 1318 
        BPL NO10
;15B1:E6 24 1319 
        INC CH
;15B3:E6 24 1320 
        INC CH
;15B5:4C BB 15 1321 
        JMP SFTBFB
;15B8:20 D6 0E 1322 
NO10:
        JSR ASCROL

;15BB: 1324 ***********************************
;15BB: 1325 *
;15BB: 1326 * CONDITION BUFFER ADJUST1:
;15BB: 1327 * (9)<-(D)<-0, (A)<-(E)<-0
;15BB: 1328 * (B)<-(F)<-0,(C)<-(0)<-0
;15BB: 1329 *
;15BB: 1330 *********************************

;15BB:AD 4E 12 1332 
SFTBFB:
        LDA P123D
;15BE:8D 4A 12 1333 
        STA P1239
;15C1:AD 50 12 1334 
        LDA P123F
;15C4:8D 4C 12 1335 
        STA P123B
;15C7:AD 4F 12 1336 
        LDA P123E
;15CA:8D 4B 12 1337 
        STA P123A
;15CD:AD 51 12 1338 
        LDA P1240
;1500:80 4D 12 1339 
        STA P123C
;15D3:A9 00 1340 
        LDA #0
;1505:80 4E 12 1341 
        STA P123D
;15D8:8D 4F 12 1342 
        STA P123E
;15DB:8D 50 12 1343 
        STA P123F
;15DE:8D 51 12 1344 
        STA P1240
;15E1:20 22 FC 1345 
        JSR VTAB
;15E4:60 1346 
        RTS

;15E5:20 AB 15 1348 
ESFTFB3:
        JSR SFTFB2
;15E8:20 6D 15 1349 
ESFTFB1:
        JSR SFTFB1
;15EB:4C F4 15 1350 
        JMP ECONDCLR
;15EE:20 AB 15 1352 
        JSR SFTFB2
;15F1:20 AB 15 1353 
ECONDCL1:
        JSR SFTFB2

;15F4: 1355 ********************************
;15F4: 1356 *
;15F4: 1357 * CLEAR ALL OF CONDITION BUFFER
;15F4: 1358 *
;15F4: 1359 ;*******************************

;15F4:20 DD FB 1361 
ECONDCLR:
        JSR BEEP 
;15F7:A9 00 1362 
        LDA #0 
;15F9:8D 4A 12 1363 
        STA P1239 
;15FC:8D 4B 12 1364 
        STA P123A 
;15FF:8D 4C 12 1365 
        STA P123B 
;1602:8D 4D 12 1366 
        STA P123C 
;1605:8D 4E 12 1367 
        STA P123D 
;1608:8D 4F 12 1368 
        STA P123E 
;160B:8D 50 12 1369 
        STA P123F 
;160E:8D 51 12 1370 
        STA P1240 
;1611:4C 4A 14 1371 
        JMP CONTPRO 
;1614:2C C3 08 1372
KPEENG:
        BIT SNDFLG 
;1617:10 14 1373 
        BPL NSOUND 
;1619:48 1374 
        PHA 
;161A:A9 10 1375 
        LDA #$10 
;161C:20 A8 FC 1376 
        JSR MWAIT 
;161F:A0 CO 1377 
        LDY #$C0 
;1621:A9 08 1378 
KPEE1:
        LDA #8
;1623:20 AB FC 1379 
        JSR MWAIT 

;1626:AD 30 CO 1380 
        LDA SPEAKER 
;1629:88 1381 
        DEY 
;162A: DO F5 1382 
        BNE KPEE1 
;162C:68 1383 
        PLA 
;162D:60 1384 
NSOUND:
        RTS 

;162E:A9 80 1386 
CTRLT:
        LDA #$80        ;TOGGLE SOUND 
;1630:4D C3 08 1387 
        EOR SNDFLG
;1633:8D C3 08 1388
        STA SNDFLG 
;1636:60 1389 
        RTS 

;*** SUCCESSFUL ASSEMBLY: NO ERRORS 
