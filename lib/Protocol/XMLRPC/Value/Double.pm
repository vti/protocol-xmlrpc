package Protocol::XMLRPC::Value::Double;
use Any::Moose;

extends 'Protocol::XMLRPC::Value';

has value => (
    isa => 'Num',
    is  => 'rw'
);

sub type {'double'}

sub to_string {
    my $self = shift;

    my $value = $self->value;

    return "<double>$value</double>";
}

1;
