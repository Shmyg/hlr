#!/usr/bin/perl -w

# Script to parse MML-file from HLR and extract all the customers and their
# services
#
# $Log: extract_services.pl,v $
# Revision 1.1  2008/05/15 09:36:48  shmyg
# *** empty log message ***
#

$found=1;
$services=0;

# Check if the filename is provided
die "Incorrect usage: filename to process is missing\n" if ($#ARGV == -1);

# Check if the file is a regular file and is readable
die "$ARGV[0] is not a file or is not readable\n" unless -f $ARGV[0];

$filename=$ARGV[0];

# Opening datafile
open (IN,"$filename") or die "$!\n";

# This is the file for converted data
open (OUT,">new_hlr.txt") or die "$!\n";

while(<IN>) {

 chomp;

  # Looking for phone number and msin
  #if (/<CR MSUB:MSIN=([0-9]*)\,BSNBC=TELEPHON-([0-9]{7})\&.*/) { 
  if (/<CR MSUB:MSIN=([0-9]*).*\,BSNBC=TELEPHON-([0-9]{7})-(TS.*)\,NDC=.*/) { 

   $services=$3;
   # Displaying phone number and msin
   print OUT "$1;$2;";
   $services =~ s/\&/;/g;
   print OUT "$services\n";

   # Flagging that we should output all the services for this subscriber
   $found=0;
  }
  elsif ($found==0) {

  # For all the service lines simply check the flag and if it is on -
  # outputting the line
  print OUT "$_\n";
  }
}

close(IN);
close(OUT);
