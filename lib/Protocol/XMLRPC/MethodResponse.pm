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

    my $self = $class->new();

    $self->fault(@_);

    return $self;
}

sub fault {
    my $self = shift;

    if (@_) {
        my ($code, $string) = @_;

        $self->_fault(
            Protocol::XMLRPC::Value::Struct->new(
                faultCode   => $code,
                faultString => $string
            )
        );

        return $self;
    }

    return $self->_fault;
}

sub fault_string {
    my $self = shift;

    return unless $self->_fault;

    return $self->_fault->members->{faultString}->value;
}

sub fault_code {
    my $self = shift;

    return unless $self->_fault;

    return $self->_fault->members->{faultCode}->value;
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
        return unless $struct && $struct->type eq 'struct';

        return $class->new(_fault => $struct);
    }

    return;
}

sub to_string {
    my $self = shift;

    my $string = qq|<?xml version="1.0"?><methodResponse>|;

    if (defined $self->fault) {
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
    else {
        die '<params /> or <fault /> is required';
    }

    $string .= '</methodResponse>';

    return $string;
}

1;
__END__

=head1 NAME

Protocol::XMLRPC::MethodResponse - XML-RPC methodResponse response

=head1 SYNOPSIS

    my $method_response = Protocol::XMLRPC::MethodResponse->new;
    $method_response->param(1);

    $method_response = Protocol::XMLRPC::MethodResponse->parse(...);

=head1 DESCRIPTION

XML-RPC methodResponse response object.

=head1 ATTRIBUTES

=head2 C<param>

Hold method response parameter as object.

=head1 METHODS

=head2 C<new>

Creates a new L<Protocol::XMLRPC::MethodResponse> instance.

=head2 C<new_fault>

    my $method_response =
      Protocol::XMLRPC::MethodResponse->new_fault(255 => 'Unknown error');

Creates a new L<Protocol::XMLRPC::MethodResponse> instance with a fault.

=head2 C<parse>

    my $method_response = Protocol::XMLRPC::MethodResponse->parse('<?xml ...');

Creates a new L<Protocol::XMLRPC::MethodResponse> from xml.

=head2 C<param>

    $method_response->param(1);
    $method_response->param(Protocol::XMLRPC::Value::String->new('foo'));
    my $param = $method_response->param;

Set/get parameter. Tries to guess a type if a Perl5 scalar/arrayref/hashref was passed
instead of an object.

=head2 C<fault>

    $method_response->fault(255 => 'Unknown error');
    my $fault = $method_response->fault;

Set/get XML-RPC fault struct.

=head2 C<fault_code>

Shortcut for $method_response->fault->members->{faultCode}->value.

=head2 C<fault_string>

Shortcut for $method_response->fault->members->{faultString}->value.

=head2 C<to_string>

    # normal response
    my $method_response = Protocol::XMLRPC::MethodResponse->new;
    $method_response->param('baz');
    # <?xml version="1.0"?>
    # <methodResponse>
    #    <params>
    #       <param>
    #          <value><string>baz</string></value>
    #       </param>
    #    </params>
    # </methodResponse>

    # fault response
    my $method_response = Protocol::XMLRPC::MethodResponse->new;
    $method_response->fault(255 => 'Unknown method');
    # or
    my $method_response =
      Protocol::XMLRPC::MethodResponse->new_fault(255 => 'Unknown method');
    # <?xml version="1.0"?>
    # <methodResponse>
    #    <fault>
    #       <value>
    #          <struct>
    #             <member>
    #                <name>faultCode</name>
    #                <value><int>255</int></value>
    #             </member>
    #             <member>
    #                <name>faultString</name>
    #                <value><string>Unknown method</string></value>
    #             </member>
    #          </struct>
    #       </value>
    #    </fault>
    # </methodResponse>

L<Protocol::XMLRPC::MethodResponse> string representation.

=head1 AUTHOR

Viacheslav Tikhanovskii, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tikhanovskii.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
