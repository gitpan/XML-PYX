#!/usr/bin/perl

use XML::PYX;

my $p = XML::PYX::Parser::ToCSF->new;

defined $ARGV[0] && $p->parsefile($ARGV[0]) || $p->parse(\*STDIN);

