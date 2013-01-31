@ECHO OFF
..\..\sw\hex2rom -b dorodon.bp3          prom_decrypt_l 8l4s > ..\..\build\prom_decrypt_l.vhd
..\..\sw\hex2rom -b dorodon.bp4          prom_decrypt_u 8l4s > ..\..\build\prom_decrypt_u.vhd
..\..\sw\hex2rom -b dorodon.bp1          prom_10_1      5l8s > ..\..\build\prom_10_1.vhd
..\..\sw\hex2rom -b dorodon.bp0          prom_10_2      5l8s > ..\..\build\prom_10_2.vhd
..\..\sw\hex2rom -b dorodon.bp2          prom_10_3      5l8s > ..\..\build\prom_10_3.vhd
                                         
..\..\sw\hex2rom -b dorodon.0            rom_cpu1      13l8s > ..\..\build\cpu1.vhd
..\..\sw\hex2rom -b dorodon.1            rom_cpu2      13l8s > ..\..\build\cpu2.vhd
..\..\sw\hex2rom -b dorodon.2            rom_cpu3      13l8s > ..\..\build\cpu3.vhd
                                         
..\..\sw\hex2rom -b dorodon.4            rom_sprite_l  12l8s > ..\..\build\rom_sprite_l.vhd
..\..\sw\hex2rom -b dorodon.3            rom_sprite_u  12l8s > ..\..\build\rom_sprite_u.vhd
..\..\sw\hex2rom -b dorodon.5            rom_char_l    12l8s > ..\..\build\rom_char_l.vhd
..\..\sw\hex2rom -b dorodon.6            rom_char_u    12l8s > ..\..\build\rom_char_u.vhd
