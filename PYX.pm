# $Id: PYX.pm,v 1.3 2000/03/18 22:26:53 matt Exp $

package XML::PYX;

use strict;
use vars qw($VERSION);

$VERSION = '0.02';

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
	package XML::Parser::PYX;

	use vars qw/$_PYX/;

	$XML::Parser::Built_In_Styles{PYX} = 1;

	sub Final {
		return $_PYX;
	}

	sub Char {
		my ($e, $t) = @_;
		$_PYX .= "-" . encode($t) . "\n";
	}

	sub Start {
		my ($e, $tag, @attr) = @_;
		$_PYX .= "($tag\n";

		while(@attr) {
			my ($key, $val) = (shift(@attr), shift(@attr));
			$_PYX .= "A$key " . encode($val) . "\n";
		}
	}

	sub End {
		my ($e, $tag) = @_;
		$_PYX .= ")$tag\n";
	}

	sub Proc {
		my ($e, $target, $data) = @_;
		$_PYX .= "?$target " . encode($data) . "\n";
	}

	sub encode {
		my $text = shift;
		$text =~ s/\n/\\n/g;
		return $text;
	}
}

1;
__END__

=head1 NAME

XML::PYX - XML to PYX generator

=head1 SYNOPSIS

  use XML::PYX;
  my $parser = XML::PYX::Parser->new;
  print $parser->parsefile($filename);

=head1 DESCRIPTION

After reading about PYX on XML.com, I thought it was a pretty cool idea,
so I built this, to generate PYX from XML using perl. See
http://www.xml.com/pub/2000/03/15/feature/index.html for an excellent
introduction.
		
=head1 HISTORY

=over 8

=item 0.01

Original version; created by h2xs 1.19

=back


=head1 AUTHOR

Matt Sergeant, matt@sergeant.org

=cut
