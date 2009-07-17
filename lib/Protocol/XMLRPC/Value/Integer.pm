package Protocol::XMLRPC::Value::Integer;
use Any::Moose;

extends 'Protocol::XMLRPC::Value';

has alias => (
    isa     => 'Str',
    is      => 'rw',
    default => 'i4'
);

has value => (
    isa => 'Int',
    is  => 'rw'
);

sub to_string {
    my $self = shift;

    my $value = $self->value;

    $value = int($value);

    my $alias = $self->alias;
    return "<$alias>$value</$alias>";
}

1;
