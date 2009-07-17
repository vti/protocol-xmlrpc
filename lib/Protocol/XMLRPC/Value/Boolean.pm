package Protocol::XMLRPC::Value::Boolean;
use Any::Moose;

extends 'Protocol::XMLRPC::Value';

sub to_string {
    my $self = shift;

    my $value = $self->value;

    return "<boolean>$value</boolean>";
}

1;
