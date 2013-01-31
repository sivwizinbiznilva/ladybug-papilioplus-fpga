#!/usr/bin/perl -w

use strict;

my $i;

if (scalar(@ARGV) != 1) {
    print(STDERR "Usage: $0 <l|u>\n");
    exit 1;
} else {
    if (!($ARGV[0] eq "l" || $ARGV[0] eq "u")) {
        print(STDERR "Argument must be l or u\n");
    }
}

for ($i = 0; $i < 256; $i++) {
    if ($ARGV[0] eq "l") {
        print(pack("C", $i & 0x0f));
    } elsif ($ARGV[0] eq "u") {
        print(pack("C", ($i & 0xf0) >> 4));
    }
}
