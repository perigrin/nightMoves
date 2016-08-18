package NightMoves::DB::Result::Beer;
use DBIx::Class::Candy
  -perl5     => v24,
  -autotable => v1,
  -experimental => ['signatures'];

primary_column id => {
    data_type => 'int',
    auto_increment => 1,
    is_numeric => 1,
};

column name => {
    data_type => 'varchar',
    size => 45,
    retrieve_on_insert => 1,
};

column tap_id => {
    data_type => 'int',
    is_nullable => 1,
    is_numeric => 1,
    retrieve_on_insert => 1,
};

column style => {
    data_type => 'varchar',
    size => 60,
    is_nullable => 1,
};

column IBU => {
    data_type => 'float',
    is_nullable => 1,
    is_numeric => 1,
};

column SRM => {
    data_type => 'float',
    is_nullable => 1,
    is_numeric => 1,
};

column brewery => {
    data_type => 'varchar',
    size => 60,
    is_nullable => 1,
};

unique_constraint([qw(name tap_id)]);

1;
