package Protocol::XMLRPC::Value::Boolean;
use Any::Moose;

has value => (
    isa => 'Bool',
    is  => 'rw'
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub to_string {
    my $self = shift;

    my $value = $self->value ? 'true' : 'false';

    return "<boolean>$value</boolean>";
}

1;
