#!/bin/bash

cp dorodon/dorodon.0   hex/cpu1.bin
cp dorodon/dorodon.1   hex/cpu2.bin
cp dorodon/dorodon.2   hex/cpu3.bin
touch                  hex/cpu4.bin
touch                  hex/cpu5.bin
touch                  hex/cpu6.bin

cp dorodon/dorodon.4   hex/sprite_l.bin
cp dorodon/dorodon.3   hex/sprite_u.bin

cp dorodon/dorodon.5   hex/char_l.bin
cp dorodon/dorodon.6   hex/char_u.bin

cp dorodon/dorodon.bp1 hex/10-1.bin
cp dorodon/dorodon.bp0 hex/10-2.bin
cp dorodon/dorodon.bp2 hex/10-3.bin

cp dorodon/dorodon.bp3 hex/decrypt_l.bin
cp dorodon/dorodon.bp4 hex/decrypt_u.bin

cp dorodon/ram_init.bin hex/ram_init.bin
