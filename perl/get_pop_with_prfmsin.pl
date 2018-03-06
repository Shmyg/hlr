#!/usr/bin/perl -w

# Script to parse MML-file from HLR, extract MULTI-numbered subsribers 
# having profile associated to them
# MML-file format is:
# sub1 type=single
# sub1 service
# sub2 type=multi
# sub2 service
# The task is to get all the POP subscribers (NUMTYP=MULTI) and check if they
# have profile asssigned to them (because they must not)
# Two files are created:
# new_hlr.txt - coverted customers
# $Id: get_pop_with_prfmsin.pl,v 1.1 2008/05/15 09:36:49 shmyg Exp $

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

while(<IN>) {

 chomp;

 # Check if this is a command for single customer creation
 if (/<CRMSUB.*TELEPHON.*PRFMSIN.*MULTI.*/) {

  # Check if string contains MSIN - there are some that don't
  if (/<CRMSUB:MSIN=([0-9]*)\,BSNBC=TELEPHON-([0-9]{7})\&.*/) { 

   $msin = $1;
   $phone_num = $2;

   # Creating command for customer deletion
   print OUT "$msin;$phone_num\n";

   
  }
 }
}

close(IN);
close(OUT);
