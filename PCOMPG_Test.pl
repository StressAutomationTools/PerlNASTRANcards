use lib './module';
use warnings;
use strict;
use PCOMPG;
#this is a test program with limited error trapping. It should not be used for normal use.


sub safelyOpen{
	#prevents files from getting overwritten by checking first if a file with the 
	#same name already exists. If it does, a warning will be printed and the 
	#program will exit.
	my $file = $_[0];
	if(-e $file){
		print $file." already exists.\n";
		print "To protect the file from being overwritten, the program will now exit.\n";
		exit;
	}
	elsif(not $file){
		print "No filename was provided.\n";
		print "As no file could be created, the program will now exit\n";
		exit;
	}
	else{
		open(my $filehandle, ">", $file) or print "File could not be opened.\n" and die;
		return $filehandle;
	}
}

my ($files, $switchName, $PCOMPGfile) = @ARGV;

unless($switchName){
    print "No name specified for the switch file.\n";
    die;
}

unless($PCOMPGfile){
    print "No name for the PCOMPG output file.\n";
    die;
}

my @files;
if($files eq "bdfs"){
    @files = <*.bdf>;
}
elsif($files eq "dats"){
    @files = <*.dat>;
}
else{
    open(IPT, "<", $files) or die "Could not find file list\n";
    while(<IPT>){
        my $line = $_;
        chomp($line);
        unless($line eq ''){
            push(@files, $line);
        }
    }
    close(IPT);
}

#read pcomps
my @PCOMPGs;
foreach my $bdf (@files){
    open(IPT, "<", $bdf) or die;  
    my $collect = 0;
    my $card = "";
    while(<IPT>){
        if(m/^PCOMPG/){
            if($card){
                push(@PCOMPGs, new PCOMPG($card));
                $card = "";
            }
            $card = $card.$_;
            $collect = 1;
        }
        elsif(m/^\S/){
            if($card){
                push(@PCOMPGs, new PCOMPG($card));
                $card = "";
            }
            $collect = 0;
        }
        elsif($collect){
            $card = $card.$_;
        }
    }
    if($card){
        push(@PCOMPGs, new PCOMPG($card));
        $card = "";
    }
    close(IPT);
}

my %pcomps;
my $switch = safelyOpen($switchName);
my $OPT = safelyOpen($PCOMPGfile);
while(@PCOMPGs){
    my $pcomp = shift(@PCOMPGs);
    my $matchstring = PCOMPG::getMIDs($pcomp).PCOMPG::getTs($pcomp).PCOMPG::getTHETAs($pcomp).PCOMPG::getOUTs($pcomp);
    if($pcomps{$matchstring}){
        print $switch PCOMPG::getID($pcomp)."\t".PCOMPG::getID($pcomps{$matchstring})."\n";
    }
    else{
        $pcomps{$matchstring} = $pcomp;
        print $OPT PCOMPG::write($pcomp);
    }
}