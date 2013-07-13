#!/usr/local/bin/perl
use Tie::File;
use File::Copy;

my($ifname) = $ARGV[0];

tie @array, 'Tie::File', $ifname or die;

splice @array,0,1;

chomp($array[$#array]);

untie @array;


