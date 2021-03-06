#!usr/bin/perl

use strict;
use warnings;
my %refallele;
my %effallele;

my $dir2 = "/group/im-lab/nas40t2/hwheeler/PrediXcan_CV/GTEx_2014-06013_release/transfers/PrediXmod/DGN-WB/DGN-imputation/DGN-imputed-for-PrediXcan/";
opendir (SNP, $dir2) || die "Couldn't open : $!";
while (my $bim = readdir(SNP)) {
    if ($bim =~/bim/) {
	open (BIM, "$dir2$bim") || die "Can't open $bim files: $!";
	while (my $line = <BIM>) {
#my @file = `zcat /group/im-lab/nas40t2/egamazon/annotation/GTEx_genot_imputed_variants_info4_maf05_CR95_CHR_POSb37_ID_REF_ALT.txt.zip`;
	    my @line = split " ", $line;
	    my $rs = $line[1];
	    my $ref = $line[4];
	    my $eff = $line[5];
	    $refallele{$rs}= $ref;
	    $effallele{$rs}= $eff;
	}
    }
}


my $dir = "/group/im-lab/nas40t2/egamazon/DGN-eQTL/";
opendir (DIR, $dir) || die "Couldn't open: $!";
open (CIS, ">SNP_cis_0.05_DGNeQTL.txt") || die "nope: $!";
open (CIS1, ">SNP_cis_0.001_DGNeQTL.txt") || die "nope: $!";
open (CIS2, ">SNP_cis_0.0001_DGNeQTL.txt") || die "nope: $!";
open (CIS3, ">SNP_cis_0.00001_DGNeQTL.txt") || die "nope: $!";

open (TRA, ">SNP_trans_DGNeQTL.txt") || die "nope: $!";
open (TRA5, ">SNP_trans_0.00001_DGNeQTL.txt") || die "nope: $!";
open (TRA1, ">SNP_trans_0.000001_DGNeQTL.txt") || die "nope: $!";
open (TRA2, ">SNP_trans_0.0000001_DGNeQTL.txt") || die "nope: $!";
open (TRA3, ">SNP_trans_0.00000001_DGNeQTL.txt") || die "nope: $!";

while (my $filename = readdir(DIR)) {
    print ("$filename\n");
    open (FIL, "/group/im-lab/nas40t2/egamazon/DGN-eQTL/$filename") || die "Can't open files: $!";
    while (my $line = <FIL>) {
	if ($line =~ /SNP/) {
	    next;
	} else {
	    my @line = split "\t", $line;
	    my $rs = $line[0];
	    my $pvalue = ("%.10f\n", $line[4]);
	    if ($effallele{$rs}) {
		if ($filename =~/cis/) {
		    print CIS ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");
		    if ($pvalue < 0.001) {
			print CIS1 ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");	
			if ($pvalue < 0.0001) {
			    print CIS2 ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");
			    if ($pvalue < 0.00001) {
				print CIS3 ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");
			    }
			}
		    }
		} elsif ($filename =~/tra/) {
		    print TRA ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");
		    if ($pvalue < 0.00001) {
			print TRA5 ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");
			if ($pvalue < 0.000001) {
			    print TRA1 ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");
			    if ($pvalue < 0.0000001) {
				print TRA2 ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");
				if ($pvalue < 0.00000001) {
				    print TRA3 ("$line[1]\t$rs\t$refallele{$rs}\t$effallele{$rs}\t$line[2]\n");
				}
			    }
			}
                    }
		}
	    } else {
#		print ($filename);
#		print ("$rs\n");
	    }
	    
	}
    }
}
close (CIS);
close (TRA);
close (DIR);
close (FIL);

