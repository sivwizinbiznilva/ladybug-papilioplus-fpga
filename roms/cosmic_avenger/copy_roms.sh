#!/bin/bash

cp cosmic_avenger/1  hex/cpu1.bin
cp cosmic_avenger/2  hex/cpu2.bin
cp cosmic_avenger/3  hex/cpu3.bin
cp cosmic_avenger/4  hex/cpu4.bin
cp cosmic_avenger/5  hex/cpu5.bin
cp cosmic_avenger/6  hex/cpu6.bin

cp cosmic_avenger/8  hex/sprite_l.bin
cp cosmic_avenger/8  hex/sprite_u.bin

cp cosmic_avenger/9  hex/char_l.bin
cp cosmic_avenger/0  hex/char_u.bin

cp cosmic_avenger/k9.bpr hex/10-1.bin
cp cosmic_avenger/t8.bpr hex/10-2.bin
cp cosmic_avenger/h9.bpr hex/10-3.bin

./make_dummy_rom.pl l > hex/decrypt_l.bin
./make_dummy_rom.pl u > hex/decrypt_u.bin

cp cosmic_avenger/ram_init.bin hex/ram_init.bin
