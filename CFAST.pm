use warnings;
use strict;

package CFAST;

sub new {
    my $class = shift;
	
	my $line = shift;
	
	my @parts = unpack('(A8)*',$line);
	
	
    my $self = {
		"_ID" => $parts[1],
		"_PID" => $parts[2],
		"_TYPE" => $parts[3],
		"_EA" => $parts[4],
		"_EB" => $parts[5],
		"_GA" => $parts[7],
		"_GB" => $parts[8],
    };
    
    bless $self, $class;
    return $self;
}

sub getAssocNodes{
	my($self) = @_;
	return ($self->{"_GA"},$self->{"_GB"});
}

sub getGA{
	my($self) = @_;
	return $self->{"_GA"};
}

sub getGB{
	my($self) = @_;
	return $self->{"_GB"};
}

sub getEA{
	my($self) = @_;
	return $self->{"_EA"};
}

sub getEB{
	my($self) = @_;
	return $self->{"_EB"};
}

sub setEA{
	my($self, $EA) = @_;
	$self->{"_EA"} = $EA;
}

sub setEB{
	my($self, $EB) = @_;
	$self->{"_EB"} = $EB;
}

sub writeCFAST{
	my($self, $fh) = @_;
	print $fh "CFAST   ".$self->{"_ID"}.$self->{"_PID"}."ELEM    ".$self->{"_EA"}.$self->{"_EB"}."        ".$self->{"_GA"}.$self->{"_GA"}."\n";
}

1;