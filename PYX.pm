# $Id: PYX.pm,v 1.6 2000/03/19 17:42:20 matt Exp $

package XML::PYX;

use strict;
use vars qw($VERSION);

$VERSION = '0.04';

sub encode {
	my $text = shift;
	$text =~ s/\n/\\n/g;
	return $text;
}

{
	package XML::PYX::Parser;
	use vars qw/@ISA/;
	
	use XML::Parser;

	@ISA = 'XML::Parser';

	sub new {
		my ($class, %args) = (@_, 'Style' => 'PYX');
		if ($args{Validating}) {
			require XML::Checker::Parser;
			@ISA = 'XML::Checker::Parser';
		}
		$class->SUPER::new(%args);
	}
}

{
	package XML::PYX::Parser::ToCSF;
	use vars qw/@ISA/;
	
	use XML::Parser;
	
	@ISA = 'XML::Parser';
	
	sub new {
		my ($class, %args) = (@_, 'Style' => 'PYX_CSF');
		if ($args{Validating}) {
			require XML::Checker::Parser;
			@ISA = 'XML::Checker::Parser';
		}
		$class->SUPER::new(%args);
	}
}

{
	package XML::Parser::PYX;

	use vars qw/$_PYX/;

	$XML::Parser::Built_In_Styles{PYX} = 1;

	sub Final {
		return $_PYX;
	}

	sub Char {
		my ($e, $t) = @_;
		$_PYX .= "-" . XML::PYX::encode($t) . "\n";
	}

	sub Start {
		my ($e, $tag, @attr) = @_;
		$_PYX .= "($tag\n";

		while(@attr) {
			my ($key, $val) = (shift(@attr), shift(@attr));
			$_PYX .= "A$key " . XML::PYX::encode($val) . "\n";
		}
	}

	sub End {
		my ($e, $tag) = @_;
		$_PYX .= ")$tag\n";
	}

	sub Proc {
		my ($e, $target, $data) = @_;
		$_PYX .= "?$target " . XML::PYX::encode($data) . "\n";
	}
}

{
	package XML::Parser::PYX_CSF;

	$XML::Parser::Built_In_Styles{PYX_CSF} = 1;

	sub Char {
		my ($e, $t) = @_;
		print "-" , XML::PYX::encode($t) , "\n";
	}

	sub Start {
		my ($e, $tag, @attr) = @_;
		print "($tag\n";

		while(@attr) {
			my ($key, $val) = (shift(@attr), shift(@attr));
			print "A$key " , XML::PYX::encode($val) , "\n";
		}
	}

	sub End {
		my ($e, $tag) = @_;
		print ")$tag\n";
	}

	sub Proc {
		my ($e, $target, $data) = @_;
		print "?$target " , XML::PYX::encode($data) , "\n";
	}
}

1;
__END__

=head1 NAME

XML::PYX - XML to PYX generator

=head1 SYNOPSIS

  use XML::PYX;
  my $parser = XML::PYX::Parser->new;
  my $string = $parser->parsefile($filename);

=head1 DESCRIPTION

After reading about PYX on XML.com, I thought it was a pretty cool idea,
so I built this, to generate PYX from XML using perl. See
http://www.xml.com/pub/2000/03/15/feature/index.html for an excellent
introduction.

The package contains 2 usable packages, and 3 utilities that 
are probably currently more use than the module:

	pyx - a XML to PYX converter using XML::Parser
	pyxv - a Validating XML to PYX converter using XML::Checker::Parser
	pyxw - a PYX to XML converter

All these utilities can be pipelined together, so you can have:

	pyx test.xml | grep -v "^-" | pyxw > new.xml

Which should remove all text from an XML file (leaving only tags).

The 2 packages are XML::PYX::Parser and XML::PYX::Parser::ToCSF. The
former is a direct subclass of XML::Parser that simply returns a PYX
string on a call to parse or parsefile. The latter stands for B<To
Currently Selected Filehandle>. Instead of returning a string, it sends
output directly to the currently selected filehandle. This is much better
for pipelined utilities for obvious reasons.

=head1 AUTHOR

Matt Sergeant, matt@sergeant.org

=cut
