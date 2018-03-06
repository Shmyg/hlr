#!/usr/contrib/bin/perl -w

# Script to get all the subsribers from HLR dump file splitted for PP and PoP
# $Log: parse_disp_file.pl,v $
# Revision 1.1  2005/05/31 14:35:20  serge
# Added perl script to parse DISPMSUB results
#

$msin=1;
$phone_num=1;

# Check if the filename is provided
die "Incorrect usage: filename to process is missing\n" if ($#ARGV == -1);

# Check if the file is a regular file and is readable
die "$ARGV[0] is not a file or is not readable\n" unless -f $ARGV[0];

$filename=$ARGV[0];

# Opening all the files
open (IN,"$filename") or die "$!\n";
open (OUT,">subscriber_data.txt") or die "$!\n";

while(<IN>) {
 chomp;
 # Check if this is a command for single customer creation and contains MSIN
 if (/MSIN:  *([0-9]{10}).*/) { 
  $msin=$1;
 }
 if (/.*DISPMSUB.*SN=([0-9][0-9]*).*NDC=([0-9][0-9]).*/) {
  $phone_num=$2.$1;
  if ($msin != 1) {
  print "$msin $phone_num\n";
  $msin=1;
  }
 }
}

close(IN);
close(OUT);
