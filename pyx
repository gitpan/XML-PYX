#!/usr/bin/perl

use XML::PYX;

my $p = XML::PYX::Parser->new;

print $p->parsefile($ARGV[0]);

