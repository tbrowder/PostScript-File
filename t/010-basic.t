use Test;

plan 1;

use-ok('PostScript::File');
#use-ok('PostScript::File::Functions');
#use-ok('PostScript::File::Metrics');

=begin comment
  SKIP: {
    # RECOMMEND PREREQ: Font::AFM
    eval { require Font::AFM };
    skip "Font::AFM not installed", 1 if $@;

    use_ok('PostScript::File::Metrics::Loader');
}
=end comment
