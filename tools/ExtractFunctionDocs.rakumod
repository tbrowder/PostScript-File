#---------------------------------------------------------------------
package tools::ExtractFunctionDocs;
#
# Copyright 2012 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created:  2 Feb 2012
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: Prepare docs for PostScript::File::Functions
#---------------------------------------------------------------------

our $VERSION = '2.20';

use 5.008;
use Moose 0.65; # attr fulfills requires

with(qw(Dist::Zilla::Role::FileMunger));

#=====================================================================

sub munge_files
{
  my ($self) = @_;

  # Find lib/PostScript/File/Functions.pm:
  my ($file) = grep { $_->name eq 'lib/PostScript/File/Functions.pm' }
                    @{ $self->zilla->files };

  $self->log_fatal("Can't find PostScript::File::Functions") unless $file;

  # Find the start of the PostScript functions:
  my $content = $file->content;

  $content =~ m/\n__DATA__\n/ or $self->log_fatal("No __DATA__ found");
  pos($content) = $+[0];

  # Extract the documentation for each function:
  my %function;

  while ($content =~ m!^%-+\n((?:%.*\n)+)\s*^/(\w+)\s*\{!mg) {
    my $name = $2;
    (my $docs = $1) =~ s/^% ?//mg;
    $docs =~ s/^[^:]+://;

    $function{$name} = "=head2 $name\n\n$docs";
  } # end while found a PostScript function

  # Assemble the documentation and insert it before final =cut:
  my $pod = join("\n", @function{ sort keys %function });

  $content =~ s/(?=^=cut\n+__DATA__\n)/$pod\n/m
      or $self->log_fatal("Can't insert POD");

  $file->content( $content );
} # end munge_files

#=====================================================================
# Package Return Value:

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__
