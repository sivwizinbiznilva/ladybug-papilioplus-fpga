@ECHO OFF
copy/b 1 + 2 ..\..\build\cpu1.bin
copy/b 3 + 4 ..\..\build\cpu2.bin
copy/b 5 + 6 ..\..\build\cpu3.bin

..\..\sw\hex2rom -b ..\decrypt_l.bin     prom_decrypt_l 8l4s > ..\..\build\prom_decrypt_l.vhd
..\..\sw\hex2rom -b ..\decrypt_u.bin     prom_decrypt_u 8l4s > ..\..\build\prom_decrypt_u.vhd
..\..\sw\hex2rom -b k9.bpr               prom_10_1      5l8s > ..\..\build\prom_10_1.vhd
..\..\sw\hex2rom -b t8.bpr               prom_10_2      5l8s > ..\..\build\prom_10_2.vhd
..\..\sw\hex2rom -b h9.bpr               prom_10_3      5l8s > ..\..\build\prom_10_3.vhd

..\..\sw\hex2rom -b ..\..\build\cpu1.bin rom_cpu1      13l8s > ..\..\build\cpu1.vhd
..\..\sw\hex2rom -b ..\..\build\cpu2.bin rom_cpu2      13l8s > ..\..\build\cpu2.vhd
..\..\sw\hex2rom -b ..\..\build\cpu3.bin rom_cpu3      13l8s > ..\..\build\cpu3.vhd

..\..\sw\hex2rom -b 8                    rom_sprite_l  12l8s > ..\..\build\rom_sprite_l.vhd
..\..\sw\hex2rom -b 8                    rom_sprite_u  12l8s > ..\..\build\rom_sprite_u.vhd
..\..\sw\hex2rom -b 9                    rom_char_l    12l8s > ..\..\build\rom_char_l.vhd
..\..\sw\hex2rom -b 0                    rom_char_u    12l8s > ..\..\build\rom_char_u.vhd
