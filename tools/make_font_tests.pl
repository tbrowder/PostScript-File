#! /usr/bin/perl
#---------------------------------------------------------------------
# Copyright 2009 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# Create font tests
#---------------------------------------------------------------------

use strict;
use warnings;
use 5.008;

use autodie ':io';

my $testNum = 0x70;

my @fonts = qw(
  Courier
  Courier-Bold
  Courier-BoldOblique
  Courier-Oblique
  Helvetica
  Helvetica-Bold
  Helvetica-BoldOblique
  Helvetica-Oblique
  Times-Bold
  Times-BoldItalic
  Times-Italic
  Times-Roman
); # end @fonts

foreach my $font (@fonts) {
  my $fn = sprintf('%02X-%s.t', $testNum++, $font);
  print "Writing $fn\n";
  open(my $out, '>', $fn);

  print $out <<"END TEST";
#! /usr/bin/perl
#---------------------------------------------------------------------
# Compare pre-compiled $font metrics against Font::AFM
#---------------------------------------------------------------------

use strict;
use warnings;

use lib 't';
use Font_Test;

test_font('$font');
END TEST
}
