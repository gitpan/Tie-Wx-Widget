use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Tie::Wx::Widget',
    AUTHOR              => q{Herbert Breunung <lichtkind@cpan.org>},
    VERSION_FROM        => 'lib/Tie/Wx/Widget.pm',
    ABSTRACT_FROM       => 'lib/Tie/Wx/Widget.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Tie::Scalar' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Tie-Wx-Widget-*' },
);
