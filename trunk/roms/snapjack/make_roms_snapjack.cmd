@ECHO OFF
copy/b sj1.c4 + sj2.d4 ..\..\build\cpu1.bin
copy/b sj3.e4 + sj4.h4 ..\..\build\cpu2.bin
copy/b sj5.j4 + sj6.k4 ..\..\build\cpu3.bin

..\..\sw\hex2rom -b ..\decrypt_l.bin     prom_decrypt_l 8l4s > ..\..\build\prom_decrypt_l.vhd
..\..\sw\hex2rom -b ..\decrypt_u.bin     prom_decrypt_u 8l4s > ..\..\build\prom_decrypt_u.vhd
..\..\sw\hex2rom -b 10-1.f4              prom_10_1      5l8s > ..\..\build\prom_10_1.vhd
..\..\sw\hex2rom -b 10-2.k1              prom_10_2      5l8s > ..\..\build\prom_10_2.vhd
..\..\sw\hex2rom -b 10-3.c4              prom_10_3      5l8s > ..\..\build\prom_10_3.vhd

..\..\sw\hex2rom -b ..\..\build\cpu1.bin rom_cpu1      13l8s > ..\..\build\cpu1.vhd
..\..\sw\hex2rom -b ..\..\build\cpu2.bin rom_cpu2      13l8s > ..\..\build\cpu2.vhd
..\..\sw\hex2rom -b ..\..\build\cpu3.bin rom_cpu3      13l8s > ..\..\build\cpu3.vhd

..\..\sw\hex2rom -b sj8.l7               rom_sprite_l  12l8s > ..\..\build\rom_sprite_l.vhd
..\..\sw\hex2rom -b sj7.m7               rom_sprite_u  12l8s > ..\..\build\rom_sprite_u.vhd
..\..\sw\hex2rom -b sj9.f7               rom_char_l    12l8s > ..\..\build\rom_char_l.vhd
..\..\sw\hex2rom -b sj0.h7               rom_char_u    12l8s > ..\..\build\rom_char_u.vhd
