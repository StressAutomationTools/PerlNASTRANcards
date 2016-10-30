use warnings;
use strict;

package PCOMP;

sub new {
    my $class = shift;
	
	my $line = shift;
	
	my @parts = unpack('(A8)*',$line);
	
	
    my $self = {
		"_ID"       => $parts[1],
		"_Z0"		=> $parts[2],
		"_NSM"		=> $parts[3],
		"_SB"		=> $parts[4],
		"_FT"		=> $parts[5],
		"_TREF"		=> $parts[6],
		"_GE"		=> $parts[7],
		"_LAM"		=> $parts[8],
    };
    bless $self, $class;
    return $self;
}
