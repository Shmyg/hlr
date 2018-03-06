#!/usr/bin/perl -w

# Script to get all the subsribers from HLR dump file splitted for PP and PoP
# HLR dump format is:
# sub1 type=single
# sub1 service
# sub2 type=multi
# sub2 service
# Two files are created:
# pp_customers.txt - PrePaid customers
# pop_customers.txt - PostPaid customers
#
# $Log: split_customers.pl,v $
# Revision 1.3  2008/01/29 05:25:23  shmyg
# *** empty log message ***
#
# Revision 1.2  2005-05-31 14:35:20  serge
# Added perl script to parse DISPMSUB results
#

# Check if the filename is provided
die "Incorrect usage: filename to process is missing\n" if ($#ARGV == -1);

# Check if the file is a regular file and is readable
die "$ARGV[0] is not a file or is not readable\n" unless -f $ARGV[0];

$filename=$ARGV[0];

# Opening all the files
open (IN,"$filename") or die "$!\n";
open (PP,">pp_customers.txt") or die "$!\n";
open (POP,">pop_customers.txt") or die "$!\n";

while(<IN>) {
 chomp;
 # Check if this is a command for MULTI numbered customer creation
 if (/<CRMSUB:MSIN=([0-9]{10}),BSNBC=TELEPHON-([0-9]{7}).*NDC=([0-9]{2}).*MULTI.*/) { 
  print POP "$1;$2;$3;X\n";
 }
 elsif (/<CRMSUB:MSIN=([0-9]{10}),BSNBC=TELEPHON-([0-9]{7}).*NDC=([0-9]{2}).*SINGLE.*/) {
  print PP "$1;$2;$3;\n";
 }
}

close(IN);
close(PP);
close(POP);
