package Protocol::XMLRPC::Value::Integer;
use Any::Moose;

has value => (
    isa => 'Int',
    is  => 'rw'
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub to_string {
    my $self = shift;

    my $value = $self->value;

    $value = int($value);

    return "<i4>$value</i4>";
}

1;
