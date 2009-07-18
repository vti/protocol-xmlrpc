package Protocol::XMLRPC::MethodResponse;
use Any::Moose;

extends 'Protocol::XMLRPC::Method';

use Protocol::XMLRPC::ValueFactory;

has _param => (
    is      => 'rw'
);

has _fault => (
    isa     => 'Protocol::XMLRPC::Value::Struct',
    is      => 'rw'
);

sub new {
    my $class = shift;

    my $param;

    if (@_ == 1) {
        $param = shift;
    }

    my $self = $class->SUPER::new(@_);

    $self->param($param) if defined $param;

    return $self;
}

sub new_fault {
    my $class = shift;
    my ($code, $string) = @_;

    my $self = $class->new();

    $self->_fault(
        Protocol::XMLRPC::Value::Struct->new(
            faultCode   => $code,
            faultString => $string
        )
    );

    return $self;
}

sub param {
    my $self = shift;

    if (@_) {
        $self->_param(Protocol::XMLRPC::ValueFactory->build(@_));
    }
    else {
        return $self->_param;
    }
}

sub fault {
    my $self = shift;

    return unless $self->_fault;

    return $self->_fault->value->{faultString};
}

sub fault_code {
    my $self = shift;

    return unless defined $self->_fault;

    return $self->_fault->value->{faultCode};
}

sub _parse_document {
    my $class = shift;
    my ($doc) = @_;

    my ($method_response) = $doc->getElementsByTagName('methodResponse');
    return unless $method_response;

    if (my ($params) = $method_response->getElementsByTagName('params')) {
        my ($param) = $params->getElementsByTagName('param');
        return unless $param;

        my ($value) = $param->getElementsByTagName('value');
        return unless $value;

        $param = $class->_parse_value($value);
        return unless $param;

        return $class->new(_param => $param);
    }
    elsif (my ($fault) = $method_response->getElementsByTagName('fault')) {
        my ($value) = $fault->getElementsByTagName('value');

        my $struct = $class->_parse_value($value);
        return unless $struct;

        return $class->new(_fault => $struct);
    }

    return;
}

sub to_string {
    my $self = shift;

    my $string = qq|<?xml version="1.0"?><methodResponse>|;

    if ($self->fault) {
        $string .= '<fault>';

        my $struct = $self->_fault;

        $string .= "<value>$struct</value>";

        $string .= '</fault>';
    }
    elsif (my $param = $self->_param) {
        $string .= '<params>';

        $string .= "<param><value>$param</value></param>";

        $string .= '</params>';
    }

    $string .= '</methodResponse>';

    return $string;
}

1;
