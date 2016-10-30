use warnings;
use strict;

package GRID;

sub new {
    my $class = shift;
	
	my $line = shift;
	
	my @parts = unpack('(A8)*',$line);
	
	
    my $self = {
		"_ID" => $parts[1],
        "_X" => $parts[3],
        "_Y" => $parts[4],
        "_Z" => $parts[5],
		"_AssocElm" => [],
    };
    
    bless $self, $class;
    return $self;
}

sub getLocation{
	my($self) = @_;
	return [$self->{"_X"},$self->{"_Y"},$self->{"_Z"}];
}

sub addAssocElm{
	my($self,$EID) = @_;
	push(@{$self->{"_AssocElm"}},$EID);
}

sub getAssocElm{
	my($self) = @_;
	return @{$self->{"_AssocElm"}};
}

1;