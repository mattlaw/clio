
package Clio::Server::HTTP;

use Moo;

use AnyEvent;
use Twiggy::Server;
use Plack::Request;
use Plack::Util;

use Data::Dumper;$Data::Dumper::Indent=1;

extends qw( Clio::Server );

with 'Clio::Role::UUIDMaker';

sub start {
    my $self = shift;

    my $config = $self->c->config;

    my $twiggy = Twiggy::Server->new(
        %{ $config->server_host_port }
    );

    $twiggy->run( $self->build_app );
}

sub build_app {
    my $self = shift;

    my $config = $self->c->config->ServerConfig;

    my $app = $self->to_app;
    if ( my $builder = $config->{Builder} ) {
        my $wrapper = Plack::Util::load_psgi($builder);

        $app = $wrapper->($app);
    }

    return $app;
}

sub to_app {
    my $self = shift;

    my $log = $self->c->log;

    sub {
        my ($env) = @_;

        my $req = Plack::Request->new( $env );
        print Dumper($env);

        if ( my $process = $self->c->process_manager->get_first_available ) {
            $log->debug("got process: ". $process->id );

            my $uuid = $self->create_uuid;

            $log->debug("new client(". $req->address .") id: $uuid");

            my $client = $self->clients_manager->new_client(
                id => $uuid,
                req => $req,
            );

            $client->attach_to_process( $process );

            return $client->respond;
        }

        return [ 503, [
            'Content-Type' => 'text/plain; charset=utf-8',
            'Access-Control-Allow-Origin' => '*',
        ], [ "No engines available" ] ];
    }
}

1;



