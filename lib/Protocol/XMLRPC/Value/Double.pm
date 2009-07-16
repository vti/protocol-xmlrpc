package Protocol::XMLRPC::Value::Double;
use Any::Moose;

has value => (
    isa => 'Num',
    is  => 'rw'
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub to_string {
    my $self = shift;

    my $value = $self->value;

    return "<double>$value</double>";
}

1;
