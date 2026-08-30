#!/bin/bash
# clean all
# rm master.dsk call3327.dsk ac.jar call3327.apple2 call3327.lst call3327.o

echo "Assemble using ga65..."
ca65 --debug-info --listing call3327.lst --target apple2 -o call3327.o call3327.s

echo "Linking using ld65..."
ld65 -C apple2-asm.cfg -u __EXEHDR__ apple2.lib --start-addr 0x880 -o call3327.apple2 call3327.o

if [[ ! -f master.dsk ]]; then
  echo "Download DOS 3.3 master diskette image..."
  curl -L -o master.dsk https://archive.org/download/011a_DOS_3.3_System_Master/011a_DOS_3.3_System_Master.dsk
fi

if [[ ! -f call3327.dsk ]]; then
  echo "Prepare new bootable diskette image..."
  cp master.dsk call3327.dsk
fi

if [[ ! -f ac.jar ]]; then
  echo "Download AppleCommander..."
  curl -L -o ac.jar https://github.com/AppleCommander/AppleCommander/releases/download/1.9.0/AppleCommander-ac-1.9.0.jar
fi

AC_CMD="java -jar ac.jar"
echo "Add CALL3327 to the diskette image using AppleCommander..."
${AC_CMD} -d call3327.dsk call3327
${AC_CMD} -as call3327.dsk call3327 < call3327.apple2
${AC_CMD} -d call3327.dsk fontdump.bas
${AC_CMD} -bas call3327.dsk fontdump.bas < fontdump.bas

echo "Good Luck and Have Fun with the diskette image:"
echo "linapple --conf linapple.conf -b --d1 call3327.dsk"
echo "or using your favorites emulator... or using ADTPro and a REAL machine!"
