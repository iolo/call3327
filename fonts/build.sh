#!/bin/bash

node bin2bdf.sh
mkttf.sh --name CALL3327 font.bdf
fonttools ttLib --flavor woff -o CALL3327.woff CALL3327.ttf
fonttools ttLib --flavor woff2 -o CALL3327.woff2 CALL3327.ttf

node bin2bdf2.sh
mkttf.sh --name CALL3327_2 font2.bdf
fonttools ttLib --flavor woff -o CALL3327_2.woff CALL3327_2.ttf
fonttools ttLib --flavor woff2 -o CALL3327_2.woff2 CALL3327_2.ttf

node bin2bdf2s.sh
mkttf.sh --name CALL3327_2s font2s.bdf
fonttools ttLib --flavor woff -o CALL3327_2s.woff CALL3327_2s.ttf
fonttools ttLib --flavor woff2 -o CALL3327_2s.woff2 CALL3327_2s.ttf
