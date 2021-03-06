#!usr/bin/perl
use strict;
use warnings;

my %gene;
my ($file1, $file2) =  @ARGV;
#input file first, output file second

open (LIST, "/group/im-lab/nas40t2/egamazon/annotation/gencode.v12.summary.gene") || die "nope: $!";

while (my $line = <LIST>) {
    chomp $line;
    my @line = split("\t", $line);
    my @dec = split(/\./, $line[4]);
    my $ens = $dec[0];
    print @dec;
    $gene{$ens} = $line[5];
}
close (LIST);

open(NEW, ">$file2") || die "nope: $!";

#my @file = `zcat ../haky/main/Transcriptome/GEUVADIS/E-GEUV-3/GD462.GeneQuantRPKM.50FN.samplename.resk10.txt.gz`;
#foreach my $line (@file) {
open (OBS, $file1) || die "nope: $!";
my $firstline = <OBS>;
print NEW ("Gene ",$firstline);
while (my $line = <OBS>) {
    chomp $line;
    my @line = split(" ", $line);
    my @id = split(/\./, $line[0]);
    my $ens = $id[0];
    if ($gene{$ens}) {
	print NEW (join (" ", $gene{$ens}, @line[1..$#line]), "\n");
    }
}
close (OBS);
close (NEW);
