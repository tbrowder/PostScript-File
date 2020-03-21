#---------------------------------------------------------------------
package tools::FixupPSFilePOD;
#
# Copyright 2012 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created:  8 Feb 2012
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: Prepare docs for PostScript::File
#---------------------------------------------------------------------

our $VERSION = '2.20';

use 5.008;
use Moose 0.65; # attr fulfills requires

with(qw(Dist::Zilla::Role::FileMunger));

#=====================================================================

sub munge_files
{
  my ($self) = @_;

  # Find lib/PostScript/File.pm:
  my ($file) = grep { $_->name eq 'lib/PostScript/File.pm' }
                    @{ $self->zilla->files };

  $self->log_fatal("Can't find PostScript::File") unless $file;

  my $content = $file->content;

  #-------------------------------------------------------------------
  # Pod::Coverage doesn't recognize the way I've documented attribute
  # accessors.  Build a Pod::Coverage section that lists them:

  my %attr;

  while ($content =~ m!^=attr(?:-\S+)? (\w+)(?: \(attribute\))?\n((?:\n| .+\n)+)!mg) {
    my $name = $1;
    my $example = $2;

    $attr{$1} = 1 while $example =~ /\b([gs]et_$name)/g;
  } # end while found an attribute

  # Append the list of documented methods:
  my $pod = join("\n", sort keys %attr );

  $content .= "\n=for Pod::Coverage\n$pod\n";

  #-------------------------------------------------------------------
  # Sort methods while ignoring prefix:

  my @methods;

  while ($content =~ m!^=method(?:-\S+)? (\w+)!mg) {
    my $name = $1;
    my $key  = $1;

    $key .= "_$1" if $key =~ s/^(add_(?:to_)?|as_|[gs]et_|has_)//;

    push @methods, [ $key, $name ];
  } # end while found an attribute

  $pod = join("\n", map { $_->[1] } sort { $a->[0] cmp $b->[0] } @methods);

  $content .= "\n=for Pod::Loom-sort_method\n$pod\n";

  #-------------------------------------------------------------------
  # Return the modified file:

  $file->content( $content );
} # end munge_files

#=====================================================================
# Package Return Value:

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__
