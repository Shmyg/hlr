#!/usr/contrib/bin/perl -w

# Script to parse MML-file from HLR, extract SINGLE-numbered subsribers and
# output commands to recreate them as MULTI-numbered
# MML-file format is:
# sub1 type=single
# sub1 service
# sub2 type=multi
# sub2 service
# The task is to get all the single subscribers and change type for multi
# Two files are created:
# new_hlr.txt - coverted customers
# and restore_hlr.txt - to restore subscribers in initial state in case
# of any problems
# Acknowledgement: Adept
# $Id: get_single_subs.pl,v 1.1.1.1 2004/11/10 09:59:25 serge Exp $

$found=1;
$msin=1;
$phone_num=1;


# Check if the filename is provided
die "Incorrect usage: filename to process is missing\n" if ($#ARGV == -1);

# Check if the file is a regular file and is readable
die "$ARGV[0] is not a file or is not readable\n" unless -f $ARGV[0];

$filename=$ARGV[0];

# Opening datafile
open (IN,"$filename") or die "$!\n";

# This is the file for converted data
open (OUT,">new_hlr.txt") or die "$!\n";

# This is fallback solution - to restore all the customers
# in initial state in case of any problems
open (BACKUP,">restore_hlr.txt") or die "$!\n";

while(<IN>) {

 chomp;

 # Check if this is a command for single customer creation
 # with NDC=54 (employee)
 if (/<CRMSUB.*TELEPHON-54.*NDC=54.*SINGLE.*/) {

  # Check if string contains MSIN - there are some that don't
  if (/<CRMSUB:MSIN=([0-9]*)\,BSNBC=TELEPHON-([0-9]{6})\&.*/) { 

   $msin = $1;
   $phone_num = $2;

   # Creating command for customer deletion
   print OUT "<CANMSUB:MSIN=$msin;\n";
   print BACKUP "<CANMSUB:MSIN=$msin;\n";

   # Outputting changed command for customer creation
   # Check if there is baring for roaming - in this case command differs
   if (/BAROAM/) {
    /<CRMSUB:MSIN=([0-9]*)\,BSNBC=TELEPHON-([0-9]{6})\&.*,BAROAM=(.*),.*/;
    print OUT "<CRMSUB:MSIN=$msin,BSNBC=TELEPHON-$phone_num-TS11&TS21&TS22&GPRS,NDC=54,MSCAT=ORDINSUB,BAROAM=$3,NUMTYP=MULTI;\n";
   } else {
    print OUT "<CRMSUB:MSIN=$msin,BSNBC=TELEPHON-$phone_num-TS11&TS21&TS22&GPRS,NDC=54,MSCAT=ORDINSUB,NUMTYP=MULTI;\n";
   }
   
   # Simply adding line to backup file
   print BACKUP "$_\n";

   # Flagging that we should output all the services for this subscriber
   $found=0;
  }
  else {

   # This is check for the MSIN that don't have MSISDN
   /<CRMSUB:MSIN=([0-9]*)\,/;
   $msin = $1;
   print "There is a mistake for MSIN:$msin\n";
   $found=1;
  }
 } elsif (/<CRMSUB.*/) {

  # This is subscriber section beginning but it is not an employee
  $found=1;

 } elsif ($found==0) {

  # For all the service lines simply check the flag and if it is on -
  # outputting the line
  print OUT "$_\n";
  print BACKUP "$_\n";

 }
}

close(IN);
close(OUT);
close(BACKUP);
