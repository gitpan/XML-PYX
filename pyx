#!/usr/bin/perl

use XML::PYX;

my $p = XML::PYX::Parser::ToCSF->new;

$p->parsefile($ARGV[0]);

