package NightMoves::HAL;
use 5.24.0;
use Moo;
use experimental qw(signatures);

use MooX::HandlesVia;
use Types::Standard;

has links => (
    is => 'ro',
    lazy => 1,
    default => sub { {} },
    handles_via => 'Hash',
    handles => {
        link => 'accessor',
    },
);

has resources => (
    is => 'ro',
    lazy => 1,
    default => sub { [] },
    predicate => 'has_resources',
    handles_via => 'Array',
    handles => {
        add_resource => 'push',
    },
);

has state => (
    is => 'ro',
    lazy => 1,
    default => sub { {} },
    handles_via => 'Hash',
    handles => {
        set => 'set',
    },
);

sub TO_JSON($self) {

    my $data = $self->state;
    $data->{_links} = $self->links;
    $data->{embedded} = $self->resources if $self->has_resources;
    return $data;
}

sub digest($self) { sha1_hex($self->TO_JSON) }


1;
