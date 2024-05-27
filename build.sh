#!/bin/bash
ca65 --debug-info --listing call3327.lst --target apple2 -o call3327.o call3327.s
ld65 -C apple2-asm.cfg -u __EXEHDR__ apple2.lib --start-addr 0x880 -o call3327.apple2 call3327.o
# ac -as call3327.dsk call3327 < call3327.apple2
# linapple --conf linapple.conf -b --d1 call3327.dsk
