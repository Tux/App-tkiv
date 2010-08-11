use strict;
use warnings;

require 5.008;

{   # Check if I have a perl that supports defined-or
    $a = undef;
    eval q{$a //= 1};
    defined $a or die "Your perl does not support defined-or operand (//)\n";
    }

use ExtUtils::MakeMaker;

my @exe = ("iv");

my %prereq_pm = (
    "Getopt::Long"	=> 2.27,
    "File::Copy"	=>    0,

    "Tk"		=>  804.027,
    "Tk::JPEG"		=>    0,
    "Tk::PNG"		=>    0,
    "Tk::TIFF"		=>    0,	# Only works with Tk-804.027_500 and up
    "Tk::Bitmap"	=>    0,
    "Tk::Pixmap"	=>    0,
    "Tk::Photo"		=>    0,
    "Tk::Pane"		=>    0,
    "Tk::DirTree"	=>    0,
    "Tk::Dialog"	=>    0,
    "Tk::Balloon"	=>    0,
    "Tk::BrowseEntry"	=>    0,
    "Tk::Animation"	=>    0,

    # Optional if $mw->screenwidth works reliable
    "X11::Protocol"	=>    0,

    # At least one of these should be available:
    "Image::ExifTool"	=>    0,
    "Image::Size"	=>    0,
    "Image::Info"	=>    0,
    );

my $n_image_mod = 0;
#our $mv;
foreach my $mod (keys %prereq_pm) {
    $prereq_pm{$mod} > 0 and next;	# Let MakeMaker decide
    my $mv = 0;
    eval "use $mod; \$mv = \$${mod}::VERSION";
    $mv and $prereq_pm{$mod} = $mv;
    $prereq_pm{$mod} eq "-1" and delete $prereq_pm{$mod};
    $prereq_pm{$mod} eq  "0" and die "Module $mod is required\n";
    $mod =~ m/^Image::/ && $mv and $n_image_mod++;
    }
$n_image_mod or
    die "At least one of @{[grep /^Image::/, keys %prereq_pm]} should be available\n";

my %wm = (
    NAME         => "App-tkiv",
    ABSTRACT     => "Image Viewer in Perl/Tk based on IrfanView",
    AUTHOR       => "H.Merijn Brand <h.merijn\@procura.nl>",
    VERSION_FROM => "iv.pod",
    EXE_FILES    => [ @exe ],
    PREREQ_FATAL => 0,
    PREREQ_PM    => \%prereq_pm,
    );
$ExtUtils::MakeMaker::VERSION > 6.30 and $wm{LICENSE} = "perl";

my $rv = WriteMakefile (%wm);

package MY;

sub postamble
{
    my $min_vsn = ($] >= 5.010 && -d "xt" && -d "tmp" && ($ENV{AUTOMATED_TESTING} || 0) != 1)
	? join "\n" =>
	    'test ::',
	    '	-@env TEST_FILES="xt/*.t" make -e test_dynamic',
	    ''
	: "";
    join "\n" =>
	'spellcheck:',
	'	pod-spell-check --aspell',
	'',
	'checkmeta:	spellcheck',
	'	perl sandbox/genMETA.pl -c',
	'',
	'fixmeta:	distmeta',
	'	perl sandbox/genMETA.pl',
	'',
	'tgzdist:	checkmeta fixmeta $(DISTVNAME).tar.gz distcheck',
	'	-@mv -f $(DISTVNAME).tar.gz $(DISTVNAME).tgz',
	'	-@cpants_lint.pl $(DISTVNAME).tgz',
	'	-@rm -f Debian_CPANTS.txt',
	'',
	$min_vsn;
    } # postamble

1;
