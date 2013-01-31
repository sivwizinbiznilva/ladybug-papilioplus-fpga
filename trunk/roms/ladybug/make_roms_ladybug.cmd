@ECHO OFF
copy/b lb1.cpu + lb2.cpu ..\..\build\cpu1.bin
copy/b lb3.cpu + lb4.cpu ..\..\build\cpu2.bin
copy/b lb5.cpu + lb6.cpu ..\..\build\cpu3.bin

..\..\sw\hex2rom -b ..\decrypt_l.bin     prom_decrypt_l 8l4s > ..\..\build\prom_decrypt_l.vhd
..\..\sw\hex2rom -b ..\decrypt_u.bin     prom_decrypt_u 8l4s > ..\..\build\prom_decrypt_u.vhd
..\..\sw\hex2rom -b 10-1.vid             prom_10_1      5l8s > ..\..\build\prom_10_1.vhd
..\..\sw\hex2rom -b 10-2.vid             prom_10_2      5l8s > ..\..\build\prom_10_2.vhd
..\..\sw\hex2rom -b 10-3.vid             prom_10_3      5l8s > ..\..\build\prom_10_3.vhd

..\..\sw\hex2rom -b ..\..\build\cpu1.bin rom_cpu1      13l8s > ..\..\build\cpu1.vhd
..\..\sw\hex2rom -b ..\..\build\cpu2.bin rom_cpu2      13l8s > ..\..\build\cpu2.vhd
..\..\sw\hex2rom -b ..\..\build\cpu3.bin rom_cpu3      13l8s > ..\..\build\cpu3.vhd

..\..\sw\hex2rom -b lb8.cpu              rom_sprite_l  12l8s > ..\..\build\rom_sprite_l.vhd
..\..\sw\hex2rom -b lb7.cpu              rom_sprite_u  12l8s > ..\..\build\rom_sprite_u.vhd
..\..\sw\hex2rom -b lb9.vid              rom_char_l    12l8s > ..\..\build\rom_char_l.vhd
..\..\sw\hex2rom -b lb10.vid             rom_char_u    12l8s > ..\..\build\rom_char_u.vhd
