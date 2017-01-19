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
use LWP::UserAgent;
use JSON qw(to_json);

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

    my $id = 0;
    my $baseurl = "http://localhost:9200";
    for my $filename (@ARGV) {
        #print "reading $filename\n";
        my $content = path($filename)->slurp_utf8( ); # read utf8 correctly
        #print "converting json to data\n";
        my $data = from_json( $content ); 
        #print "converted\n";

        for my $row (@$data) {  
            $id++;
            my ($name, $sku) = ($row->{name}, $row->{sku});
            if ($name) {
                #print "$name, $sku\n";
                my $title = $name;
                $title =~ s/['"]//g;
                my $json = to_json( { title=>$title } );
                post_json( $baseurl, $id, $json );
            }
        }
    }
}

sub post_json {
    my ($baseurl, $id, $json) = @_;
    my $url = "$baseurl/autocomplete/post/$id";
    my $cmd = qq{ curl -XPUT '$url' -d '$json' };
    print "$prog: running: $cmd\n";
    system( $cmd ) && die "$prog: post failed: $json: $!\n";
}
