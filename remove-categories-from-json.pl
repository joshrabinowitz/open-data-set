#!/usr/bin/env perl
#!/usr/bin/perl -w 

use strict;
use warnings;
use Getopt::Long; 
use File::Basename;
use File::Slurp;
use JSON qw(from_json to_json);
use Data::Dump qw(dump);
use Path::Tiny;

binmode(STDOUT, ":utf8");    # output utf8 to stdout correctly

my $prog = basename($0);
my $verbose;
#my $dryrun;

# Usage() : returns usage information
sub Usage {
    "$prog [--verbose] FROM.json TO.json\n";
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

    my ($from, $to) = (@ARGV);

    my $content = path($from)->slurp_utf8( ); # read utf8 correctly
    my $data = from_json( $content );
    for my $row (@$data) {
        delete( $row->{category} );
    }
    my $new_data = to_json( $data,  {pretty => 1} );
    path( $to )->spew_utf8( $new_data );
}
