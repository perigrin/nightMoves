#!/usr/bin/env perl
use 5.24.0;

use lib qw(lib);

use Plack::Builder;
use NightMoves::DB;
use NightMoves::Resource::Beers;
use Web::Machine;

my $db_file = $ENV{BEER_DB} // 'beer.db';
my $schema = NightMoves::DB->connect("dbi:SQLite:dbname=$db_file", '','', { sqlite_unicode => 1});

# deploy the database if the file is new;
$schema->deploy unless -e $db_file;

builder {
    enable "SimpleLogger", level => "warn";

    mount '/beer' => Web::Machine->new(
		resource      => 'NightMoves::Resource::Beers',
		resource_args => [
			schema => $schema,
		],
	)->to_app;
};

