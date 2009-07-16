package Protocol::XMLRPC::MethodCall;
use Any::Moose;

use Protocol::XMLRPC::Value::String;

has name => (
    required => 1,
    isa      => 'Str',
    is       => 'rw',
);

has _params => (
    isa     => 'ArrayRef',
    is      => 'rw',
    default => sub { [] }
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub add_param {
    my $self = shift;
    my $param = shift;

    push @{$self->_params},
      ref($param) ? $param : Protocol::XMLRPC::Value::String->new(value => $param);
}

sub to_string {
    my $self = shift;

    my $method_name = $self->name;

    my $string = qq|<?xml version="1.0"?><methodCall><methodName>$method_name</methodName>|;

    $string .= '<params>';

    foreach my $params (@{$self->_params}) {
        $string .= '<param><value>' . $params->to_string . "</value></param>";
    }

    $string .= '</params>';

    $string .= '</methodCall>';

    return $string;
}

1;
