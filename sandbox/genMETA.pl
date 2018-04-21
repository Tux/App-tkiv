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

use lib "sandbox";
use genMETA;
my $meta = genMETA->new (
    from    => "iv.pod",
    verbose => $opt_v,
    );

$meta->from_data (<DATA>);

if ($check) {
    $meta->check_encoding ();
    $meta->check_required ();
    $meta->check_minimum ([ "t", "examples", "iv", "Makefile.PL" ]);
    $meta->done_testing ();
    }
elsif ($opt_v) {
    $meta->print_yaml ();
    }
else {
    $meta->fix_meta ();
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
  perl:                 5.010
  Data::Peek:           0
  Getopt::Long:         2.27
  File::Copy:           0
  File::Temp:           0
  Tk:                   804.027
  Tk::Animation:        0
  Tk::Balloon:          0
  Tk::Bitmap:           0
  Tk::BrowseEntry:      0
  Tk::Dialog:           0
  Tk::DirTree:          0
  Tk::JPEG:             0
  Tk::Pane:             0
  Tk::Photo:            0
  Tk::Pixmap:           0
  Tk::PNG:              0
  Image::ExifTool:      0
recommends:
  Data::Peek:           0.48
  Getopt::Long:         2.5
  Image::ExifTool:      10.80
  Image::Info:          1.41
  Image::Size:          3.300
  Tk:                   804.034
  Tk::TIFF:             0.11
  X11::Protocol:        0.56
configure_requires:
  ExtUtils::MakeMaker:  0
test_requires:
  Test::Harness:        0
  Test::More:           0.88
test_recommends:
  Test::More:           1.302136
resources:
  license:              http://dev.perl.org/licenses/
  repository:           https://github.com/Tux/App-tkiv
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
