#!/usr/bin/env perl
#!/usr/bin/perl -w 
# vim: set ts=4 sw=4 expandtab showmatch

use strict;
use warnings;
use Getopt::Long; 
use File::Basename;
use JSON qw(from_json);
use Data::Dump qw(dump);
use Path::Tiny;

binmode(STDOUT, ":utf8");    # output utf8 to stdout correctly

my $prog = basename($0);
my $verbose;
#my $dryrun;

# Usage() : returns usage information
sub Usage {
    "$prog [--verbose] JSON_FILES\n";
    #"$prog [--verbose] [--dryrun]\n";
}

# call main()
main();

# main()
sub main {
    GetOptions(
        "verbose!" => \$verbose,
        #"dryrun!" => \$dryrun,
    ) or die Usage();

	my @htmls;
    for my $filename (@ARGV) {
        #print "reading $filename\n";
        my $content = path($filename)->slurp_utf8( ); # read utf8 correctly
        #print "converting json to data\n";
        my $data = from_json( $content ); 
        #print "converted\n";

        for my $row (@$data) {
            my ($name, $sku) = ($row->{name}, $row->{sku});
            if ($name) {
                my $title = $name;
                $title =~ s/['"]//g;
                print "insert into autocomplete set title='$title';\n";
            }
        }
    }
}

