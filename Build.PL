use strict;
use warnings;

use Module::Build;

Module::Build->new(
    module_name   => 'Clio',
    version       => '1.0',
    dist_abstract => 'Command-line I/O',
    requires      => {
        'Moo'           => 0,
        'AnyEvent::Run' => 0,
        'Config::Any'   => 0,
        'Twiggy'        => 0,
        'Plack'         => 0,
        'Data::UUID'    => 0,
        'Log::Log4perl' => 0,
        'Log::Dispatch' => 0,
    },
    configure_requires => { 'Module::Build' => '0.38', },
    create_makefile_pl => 'small',
    license            => 'perl',
    resources          => {
        repository => {
            type => 'git',
            web  => 'https://github.com/ajgb/clio',
        },
    },
)->create_build_script;

