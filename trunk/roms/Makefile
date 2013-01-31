.PHONY: clean
clean:
	rm -f hex/*bin hex/*hex hex/*vhd

.PHONY: hex_files
hex_files:
	cd hex; make all

.PHONY: ladybug
ladybug: clean lb_roms hex_files

.PHONY: lb_roms
lb_roms:
	./ladybug/copy_roms.sh

.PHONY: cosmic_avenger
cosmic_avenger: clean ca_roms hex_files

.PHONY: ca_roms
ca_roms:
	./cosmic_avenger/copy_roms.sh

.PHONY: dorodon
dorodon: clean do_roms hex_files

.PHONY: do_roms
do_roms:
	./dorodon/copy_roms.sh
