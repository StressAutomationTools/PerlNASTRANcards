use warnings;
use strict;

package CQUAD4;

sub new {
    my $class = shift;
	
	my $line = shift;
	
	my @parts = unpack('(A8)*',$line);
	
	
    my $self = {
		"_ID"         => $parts[1],
		"_Prop"       => $parts[2],
		"_AssocNode"  => [$parts[3],$parts[4],$parts[5],$parts[6]],
    };
    bless $self, $class;
    return $self;
}

sub getAssocNodes{
	my($self) = @_;
	return ($self->{"_AssocNode"});
}

1;