
CPU_ROM_1   = cpu1.bin
#CPU_ROM_1   = ../../sw/cpu_ram_test/cpu_ram_test.bin

.PHONY: all
all: hex_files vhdl_files

.PHONY: hex_files
hex_files: cpu1-6.hex char_l.hex char_u.hex \
           10-1.hex 10-2.hex 10-3.hex rom_l.hex rom_u.hex ram_init.hex \
           decrypt_l.hex decrypt_u.hex

.PHONY: vhdl_files
vhdl_files: prom_10_1.vhd prom_10_2.vhd prom_10_3.vhd \
            prom_decrypt_l.vhd prom_decrypt_u.vhd
#            rom_cpu.vhd \
#            rom_char_l.vhd rom_char_u.vhd \
#            rom_sprite_l.vhd rom_sprite_u.vhd

FILTER_HEX = egrep '^:......0[01]'


##############################################################################
# Prepare the binary data
##############################################################################
#
# Concatenate the CPU ROMs to one single file.
#
cpu1-6.bin: $(CPU_ROM_1) cpu2.bin cpu3.bin cpu4.bin cpu5.bin cpu6.bin
	cat $(CPU_ROM_1) cpu2.bin cpu3.bin cpu4.bin cpu5.bin cpu6.bin > cpu1-6.bin
#
# Combine the sprite binaries, target is a 16-bit data bus, thus the bytes
# have to be interleaved.
#   sprite_l.bin -> even address
#   sprite_u.bin -> odd address
#
sprite.bin:
	srec_cat -o sprite.bin -Binary sprite_l.bin -Binary -Un_Split 2 0 \
                               sprite_u.bin -Binary -Un_Split 2 1
#
# Combine the character binaries, target is a 16-bit data bus, thus the bytes
# have to be interleaved.
#  char_l.bin -> even address
#  char_u.bin -> odd address
#
char.bin:
	srec_cat -o char.bin -Binary char_l.bin  -Binary -Un_Split 2 0 \
                             char_u.bin -Binary -Un_Split 2 1
#
# Generate 2*4096 bytes of fill data (may contain arbitrary data).
#
fill_cpu.bin:
	dd if=/dev/zero of=fill_cpu.bin bs=4096 count=2
#
# Concatenate all binaries to one single file.
#
rom.bin: cpu1-6.bin sprite.bin char.bin fill_cpu.bin
	cat cpu1-6.bin fill_cpu.bin char.bin sprite.bin > rom.bin
#
##############################################################################


##############################################################################
# Binary to Intel HEX format conversion
##############################################################################
#
10-1.hex: 10-1.bin
	srec_cat -o - -Intel 10-1.bin -Binary   | $(FILTER_HEX) > 10-1.hex
10-2.hex: 10-2.bin
	srec_cat -o - -Intel 10-2.bin -Binary   | $(FILTER_HEX) > 10-2.hex
10-3.hex: 10-3.bin
	srec_cat -o - -Intel 10-3.bin -Binary   | $(FILTER_HEX) > 10-3.hex
decrypt_l.hex: decrypt_l.bin
	srec_cat -o - -Intel decrypt_l.bin -Binary   | $(FILTER_HEX) > decrypt_l.hex
decrypt_u.hex: decrypt_u.bin
	srec_cat -o - -Intel decrypt_u.bin -Binary   | $(FILTER_HEX) > decrypt_u.hex
#
# The next files are for simulation purpose only, not required for final
# FPGA implementation.
#
cpu1-6.hex: cpu1-6.bin
	srec_cat -o - -Intel cpu1-6.bin -Binary | $(FILTER_HEX) > cpu1-6.hex
char_l.hex: char_l.bin
	srec_cat -o - -Intel char_l.bin -Binary | $(FILTER_HEX) > char_l.hex
char_u.hex: char_u.bin
	srec_cat -o - -Intel char_u.bin -Binary | $(FILTER_HEX) > char_u.hex
rom_l.hex: rom.bin
	srec_cat -o - -Intel rom.bin -Binary -Split 2 0 | $(FILTER_HEX) > rom_l.hex
rom_u.hex: rom.bin
	srec_cat -o - -Intel rom.bin -Binary -Split 2 1 | $(FILTER_HEX) > rom_u.hex

ram_init.hex: ram_init.bin
	srec_cat -o - -Intel ram_init.bin -Binary | $(FILTER_HEX) > ram_init.hex
#
##############################################################################


##############################################################################
# Convert PROM binaries to VHDL RTL code.
##############################################################################
#
prom_10_1.vhd: 10-1.bin
	hex2rom -b 10-1.bin prom_10_1 5l8s > prom_10_1.vhd
prom_10_2.vhd: 10-2.bin
	hex2rom -b 10-2.bin prom_10_2 5l8s > prom_10_2.vhd
prom_10_3.vhd: 10-3.bin
	hex2rom -b 10-3.bin prom_10_3 5l8s > prom_10_3.vhd
prom_decrypt_l.vhd: decrypt_l.bin
	hex2rom -b decrypt_l.bin prom_decrypt_l 8l4s > prom_decrypt_l.vhd
prom_decrypt_u.vhd: decrypt_u.bin
	hex2rom -b decrypt_u.bin prom_decrypt_u 8l4s > prom_decrypt_u.vhd
#rom_cpu.vhd: cpu1-6.bin
#	hex2rom -b cpu1-6.bin rom_cpu 15l8s > rom_cpu.vhd
#rom_char_l.vhd: char_l.bin
#	hex2rom -b char_l.bin rom_char_l 12l8s > rom_char_l.vhd
#rom_char_u.vhd: char_u.bin
#	hex2rom -b char_u.bin rom_char_u 12l8s > rom_char_u.vhd
#rom_sprite_l.vhd: sprite_l.bin
#	hex2rom -b sprite_l.bin rom_sprite_l 12l8s > rom_sprite_l.vhd
#rom_sprite_u.vhd: sprite_u.bin
#	hex2rom -b sprite_u.bin rom_sprite_u 12l8s > rom_sprite_u.vhd
#
##############################################################################
