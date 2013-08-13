#!/usr/bin/perl -w

my($ifname)=$ARGV[0];
my %duplicates;
open(IDATA, $ifname)
	or print("open failed.\n"), exit 3;
open(ODATA, ">temp1.dat")
	or print("open failed.\n"), exit 3;

while (<IDATA>) {
	if (!$duplicates{$_}) {
		print ODATA $_;
	}
	$duplicates{$_}++;
}
system("mv temp1.dat $ifname");
