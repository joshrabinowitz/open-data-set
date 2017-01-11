#!/usr/bin/env perl
#!/usr/bin/perl -w 
# vim: set ts=4 sw=4 expandtab showmatch

use strict;
use warnings;
use Getopt::Long; 
use File::Basename;
use File::Slurp;
use JSON qw(from_json);
use Data::Dump qw(dump);
use Path::Tiny;

binmode(STDOUT, ":utf8");    # output utf8 to stdout correctly

my $prog = basename($0);
my $verbose;
#my $dryrun;

# Usage() : returns usage information
sub Usage {
    "$prog [--verbose]\n";
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
		print "reading $filename\n";
        my $content = path($filename)->slurp_utf8( $filename ); # read utf8 correctly
		print "converting json to data\n";
        my $data = from_json( $content ); #, { utf8  => 1 } );
		print "converted\n";

        for my $row (@$data) {
            my ($name, $sku) = ($row->{name}, $row->{sku});
            if ($name) {
				print "$name, $sku\n";
				my $html_filename = "$sku.html";
                path( "html/$html_filename" )->spew_utf8( create_sku_html( $sku, $name ) );
				push( @htmls, $html_filename );
            }
        }
		path( "html/index.html" )->spew_utf8( create_index_html( \@htmls ) );
    }
}

sub create_index_html {
	my $htmls = shift;
	my $content = qq{
	<HTML>
		<HEAD> 
			<TITLE>index</TITLE> 
		</HEAD> 
		<BODY>
	};
	# append link to each data page
	for my $f (@$htmls) {
		$content .= qq{<a href="$f">$f</a>\n};
	}
	$content .= qq{
		</BODY>
		</HTML> 
	};
	return $content;
}
sub create_sku_html {
    my ($sku, $name) = @_;
    my $html = qq{
<HTML>
	<HEAD> 
		<TITLE>$name</TITLE> 
	</HEAD> 
	<BODY>
		$name<br>
		SKU: $sku<br>
	</BODY>
</HTML> 
    };
}
