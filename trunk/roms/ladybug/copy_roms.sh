#!/bin/bash

cp ladybug/lb1.cpu  hex/cpu1.bin
cp ladybug/lb2.cpu  hex/cpu2.bin
cp ladybug/lb3.cpu  hex/cpu3.bin
cp ladybug/lb4.cpu  hex/cpu4.bin
cp ladybug/lb5.cpu  hex/cpu5.bin
cp ladybug/lb6.cpu  hex/cpu6.bin

cp ladybug/lb8.cpu  hex/sprite_l.bin
cp ladybug/lb7.cpu  hex/sprite_u.bin

cp ladybug/lb9.vid  hex/char_l.bin
cp ladybug/lb10.vid hex/char_u.bin

cp ladybug/10-1.vid hex/10-1.bin
cp ladybug/10-2.vid hex/10-2.bin
cp ladybug/10-3.vid hex/10-3.bin

./make_dummy_rom.pl l > hex/decrypt_l.bin
./make_dummy_rom.pl u > hex/decrypt_u.bin

cp ladybug/ram_init.bin hex/ram_init.bin
