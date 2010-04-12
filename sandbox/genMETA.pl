#!/pro/bin/perl

use strict;
use warnings;

use Getopt::Long qw(:config bundling nopermute);
my $check = 0;
my $opt_v = 0;
GetOptions (
    "c|check"		=> \$check,
    "v|verbose:1"	=> \$opt_v,
    ) or die "usage: $0 [--check]\n";

my $version;
open my $pm, "<", "iv.pod" or die "Cannot read iv";
while (<$pm>) {
    m/^our\s+.VERSION\s*=\s*"?([-0-9._]+)"?\s*;\s*$/ or next;
    $version = "$1";
    last;
    }
close $pm;
print STDERR "App::tkiv-$version is being analized and packaged\n";

my @yml;
while (<DATA>) {
    s/VERSION/$version/o;
    push @yml, $_;
    }

if ($check) {
    use YAML::Syck;
    use Test::YAML::Meta::Version;
    my $h;
    my $yml = join "", @yml;
    eval { $h = Load ($yml) };
    $@ and die "$@\n";
    $opt_v and print Dump $h;
    my $t = Test::YAML::Meta::Version->new (yaml => $h);
    $t->parse () and
	die join "\n", "Test::YAML::Meta reported errors:", $t->errors, "";

    use Parse::CPAN::Meta;
    eval { Parse::CPAN::Meta::Load ($yml) };
    $@ and die "$@\n";

    my $req_vsn = $h->{requires}{perl};
    print "Checking if $req_vsn is still OK as minimal version\n";
    use Test::MinimumVersion;
    all_minimum_version_ok ($req_vsn, { paths =>
	["t", "examples", "iv", "Makefile.PL" ]});
    }
elsif ($opt_v) {
    print @yml;
    }
else {
    my @my = glob <*/META.yml>;
    @my == 1 && open my $my, ">", $my[0] or die "Cannot update META.yml\n";
    print $my @yml;
    close $my;
    chmod 0644, $my[0];
    }

__END__
--- #YAML:1.0
name:                   App-tkiv
version:                VERSION
abstract:               An image viewer in Perl::Tk based on IrfanView
license:                perl
author:                 
  - H.Merijn Brand <h.m.brand@xs4all.nl>
generated_by:           Author
distribution_type:      module
provides:
  App::tkiv:
    file:               lib/App/tkiv.pm
    version:            VERSION
requires:                       
  perl:                 5.008004
  Data::Peek:           0
  Getopt::Long:         2.27
  File::Copy:           0
  Tk:                   804.027
  Tk::JPEG:             0
  Tk::PNG:              0
  Tk::Bitmap:           0
  Tk::Pixmap:           0
  Tk::Photo:            0
  Tk::Pane:             0
  Tk::DirTree:          0
  Tk::Dialog:           0
  Tk::Balloon:          0
  Tk::BrowseEntry:      0
  Tk::Animation:        0
  Image::ExifTool:      0
  Image::Size:          0
  Image::Info:          0
recommends:
  perl:                 5.010001
configure_requires:
  ExtUtils::MakeMaker:  0
build_requires:
  Test::Harness:        0
  Test::More:           0.88
resources:
  license:              http://dev.perl.org/licenses/
  repository:           http://repo.or.cz/w/App-tkiv.git
meta-spec:
  version:              1.4
  url:                  http://module-build.sourceforge.net/META-spec-v1.4.html
optional_features:
  opt_xeleven_protocol:
    description:        Use X11::Protocol to get the screen size
    requires:
      X11::Protocol:    0
  opt_format_tiff:
    description:        Support for TIFF
    requires:
      Tk::TIFF:         0
