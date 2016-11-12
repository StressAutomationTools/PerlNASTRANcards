use warnings;
use strict;

package PCOMPG;

sub symetricExpand {
    my $input = $_[0];
    my @parts = split(",", $input);
    my @expanded = @parts;
    while(@parts){
        push(@expanded, pop(@parts));
    }
    my $expanded = "";
    while(@expanded){
        $expanded = $expanded.shift(@expanded).",";
    }
    return $expanded;
}

sub new {
    my $class = shift(@_);
    #gets Array reference in (Processed to be short card format)
    my $lineRef = shift(@_);
    my @lines = split("\n", $lineRef);
    
    #first line is not a ply
    my @parts;
    my $line = shift(@lines);
    my @fields = unpack('(A8)*',$line);
    #ID
    if($fields[1] =~ m/(\d+)/){
        $parts[1] = $1;
    }
    #Z0
    if(not $fields[2]){
        $parts[2] = "";
    }
    else{
        $parts[2] = $fields[2];
    }
    #NSM
    if(not $fields[3]){
        $parts[3] = "";
    }
    else{
        $parts[3] = $fields[3];
    }
    #SB
    if(not $fields[4]){
        $parts[4] = "";
    }
    else{
        $parts[4] = $fields[4];
    }
    #FT
    if(not $fields[5]){
        $parts[5] = '';
    }
    else{
        $parts[5] = $fields[5];
    }
    #TREF
    if(not $fields[6]){
        $parts[6] = '';
    }
    else{
        $parts[6] = $fields[5];
    }
    #GE
    if(not $fields[7]){
        $parts[7] = '';
    }
    else{
        $parts[7] = $fields[7];
    }
    #LAM
    if(not $fields[8]){
        $parts[8] = '';
    }
    else{
        $parts[8] = $fields[8];
    }
    #plies
    my $MID = "";
    my $T = "";
    my $THETA = "";
    my $SOUT = "";
    $parts[9] = "";
    $parts[10] = "";
    $parts[11] = "";
    $parts[12] = "";
    while(@lines){
        my $line = shift(@lines);
        my @fields = unpack('(A8)*',$line);
        if($fields[2] =~ m/(\d+)/){
            $MID = $1;
        }
        if($fields[3] =~ m/(\S+)/){
            $T = $1;
        }
        if($fields[4] =~ m/(\S+)/){
            #only +-45, 90 and 0 allowed, all others will be converted to these angles
            if($1 > -22.5 and $1 < 22.5){
                $THETA = 0;
            }
            elsif($1 >= 22.5 and $1 <= 67.5){
                $THETA = 45;
            }
            elsif($1 < 67.5 and $1 < 112.5){
                $THETA = 90;
            }
            elsif($1 >= -67.5 and $1 <= -22.5){
                $THETA = -45;
            }
            elsif($1 < -67.5 and $1 > -112.5){
                $THETA = 90;
            }
            else{
                print "Could not identify the angle $1\n";
            }
        }
        if($fields[5] =~ m/(\w+)/){
            $SOUT = $1;
        }
        $parts[9] = $parts[9].$MID.",";
        $parts[10] = $parts[10].$T.",";
        $parts[11] = $parts[11].$THETA.",";
        $parts[12] = $parts[12].$SOUT.",";
    }
    my $self = {
		"_ID"       => $parts[1],
		"_Z0"       => $parts[2],
		"_NSM"      => $parts[3],
		"_SB"       => $parts[4],
		"_FT"       => $parts[5],
		"_TREF"     => $parts[6],
		"_GE"       => $parts[7],
		"_LAM"      => $parts[8],
		"_MIDs"     => $parts[9],
		"_Ts"       => $parts[10],
		"_THETAs"   => $parts[11],
		"_SOUTs"    => $parts[12],
    };
    #Expand symetric
    if($self->{"_LAM"} eq "SYM"){
        #reset the card
        $self->{"_LAM"} = "";
        #MIDs
        $self->{"_MIDs"} = symetricExpand($self->{"_MIDs"});
        #Ts
        $self->{"_Ts"} = symetricExpand($self->{"_Ts"});
        #THETAs
        $self->{"_THETAs"} = symetricExpand($self->{"_THETAs"});
        #SOUTs
        $self->{"_SOUTs"} = symetricExpand($self->{"_SOUTs"});
    }
    bless $self, $class;
    return $self;
}

sub write{
    my($self) = @_;
    my $outputstring = "PCOMPG  ".pack('(A8)',$self->{"_ID"}).pack('(A8)',$self->{"_Z0"});
    $outputstring = $outputstring.pack('(A8)',$self->{"_NSM"}).pack('(A8)',$self->{"_SB"}).pack('(A8)',$self->{"_FT"});
    $outputstring = $outputstring.pack('(A8)',$self->{"_TREF"}).pack('(A8)',$self->{"_GE"}).pack('(A8)',$self->{"_LAM"})."\n";
    my $ply = 1;
    my @MIDs = split(",",$self->{"_MIDs"});
    my @Ts = split(",",$self->{"_Ts"});
    my @THETAs = split(",",$self->{"_THETAs"});
    my @SOUTs = split(",",$self->{"_SOUTs"});
    my $plyID = 1;
    while(@MIDs){
        $outputstring = $outputstring."        ".pack('(A8)',$plyID++).pack('(A8)',shift(@MIDs)).pack('(A8)',shift(@Ts));
        $outputstring = $outputstring.pack('(A8)',shift(@THETAs).".").pack('(A8)',shift(@SOUTs))."\n";
    }
    return $outputstring;
}

sub getMIDs{
    my($self) = @_;
    return $self->{"_MIDs"};
}

sub getTs{
    my($self) = @_;
    return $self->{"_Ts"};
}

sub getTHETAs{
    my($self) = @_;
    return $self->{"_THETAs"};
}

sub getOUTs{
    my($self) = @_;
    return $self->{"_SOUTs"};
}

sub getID{
    my($self) = @_;
    return $self->{"_ID"};
}

1;