package NightMoves::Resource::Beers;
use 5.24.0;
use Moo;
use experimental qw(signatures);

use JSON::MaybeXS ();
use NightMoves::HAL;
use Scalar::Util qw(blessed);
use Web::Machine::Util qw(bind_path);
use Try::Tiny;

extends qw(Web::Machine::Resource);

has schema => (
    isa => sub ($s) { blessed $s && $s->isa('NightMoves::DB') },
    is => 'ro',
    required => 1,
    handles => {
        beer_rs => ['resultset', 'Beer'],
    }
);

has beer_id => (
    is => 'ro',
    lazy => 1,
    builder => '_build_beer_id',
);

sub _build_beer_id($self) {
   my $req = $self->request;
   my ($beer_id) = bind_path('/:id', $req->path);
   return $beer_id;
}

has resource => (
    isa => sub ($s)  { blessed $s && $s->isa('NightMoves::HAL') },
    is => 'ro',
    lazy => 1,
    builder => '_build_resource',
    handles => [qw(add_resource set link)],
);

sub _build_resource { NightMoves::HAL->new() }

has json_encoder => (
    is      => 'bare',
    lazy    => 1,
    builder => '_build_json_encoder',
    handles => {
        encode_json => 'encode',
        decode_json => 'decode',
    },
);

sub _build_json_encoder {
    my $self = shift;

    JSON::MaybeXS->new(
        utf8            => 1,
        allow_blessed   => 1,
        convert_blessed => 1,
        pretty          => $self->request->param('pretty') // 0
    );

}

sub allowed_methods { [ qw(GET HEAD POST PUT DELETE) ] }
sub content_types_accepted { [ { 'application/json' => 'from_json' } ] }
sub content_types_provided { [ { 'application/json' => 'to_json' } ] }

sub resource_exists ($self) {

    if ($self->beer_id) {
        my $beer = $self->beer_rs->find(
            { id => $self->beer_id },
            { result_class => 'DBIx::Class::ResultClass::HashRefInflator' }
        );
        $self->set($_ => $beer->{$_}) for keys %$beer;
        return 1;
    }

    if (my @beers = $self->beer_rs->search(
        { tap_id => { '!=', undef } },
        { result_class => 'DBIx::Class::ResultClass::HashRefInflator' }
        )->all) {
        $self->add_resource($_) for @beers;
        return 1;
    }

    return;
}

sub allow_missing_post { 1 }
sub post_is_create { 1 }
sub create_path_after_handler { 1 }

sub create_path ($self) {  $self->resource->state->{id}; }

sub from_json ($self) {
    my $req = $self->request;
    my $content = $req->content;
    my $data = $self->decode_json($content);
    my $beer = $self->beer_rs->create($data);
    $self->set(id => $beer->id);
    $self->set(name => $beer->name);
}

sub to_json {
    my $self = shift;

    $self->encode_json($self->resource);
}

1;
