package Protocol::XMLRPC::MethodCall;
use Any::Moose;

extends 'Protocol::XMLRPC::Method';

use Protocol::XMLRPC::ValueFactory;

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

sub add_param {
    my $self = shift;
    my $param = shift;

    my $value = Protocol::XMLRPC::ValueFactory->build($param);
    return unless $value;

    push @{$self->_params}, $value;
}

sub params {
    my $self = shift;

    return @{$self->_params};
}

sub _parse_document {
    my $class = shift;
    my ($doc) = @_;

    my ($method_call) = $doc->getElementsByTagName('methodCall');
    return unless $method_call;

    my ($name) = $method_call->getElementsByTagName('methodName');
    return unless $name;

    my $self = $class->new(name => $name->textContent);

    if (my ($params) = $method_call->getElementsByTagName('params')) {
        my @params = $params->getElementsByTagName('param');
        foreach my $param (@params) {
            my ($value) = $param->getElementsByTagName('value');

            if (my $param = $self->_parse_value($value)) {
                push @{$self->_params}, $param;
            }
            else {
                return;
            }
        }
    }

    return $self;
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
