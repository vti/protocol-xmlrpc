package Protocol::XMLRPC::MethodCall;
use Any::Moose;

extends 'Protocol::XMLRPC::Method';

use Protocol::XMLRPC::ValueFactory;

has name => (
    required => 1,
    isa      => 'Str',
    is       => 'rw',
);

has params => (
    isa     => 'ArrayRef',
    is      => 'rw',
    default => sub { [] }
);

sub add_param {
    my $self = shift;
    my $param = shift;

    my $value = Protocol::XMLRPC::ValueFactory->build($param);
    return unless $value;

    push @{$self->params}, $value;
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
                push @{$self->params}, $param;
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

    foreach my $params (@{$self->params}) {
        $string .= '<param><value>' . $params->to_string . "</value></param>";
    }

    $string .= '</params>';

    $string .= '</methodCall>';

    return $string;
}

1;
__END__

=head1 NAME

Protocol::XMLRPC::MethodCall - XML-RPC methodCall request

=head1 SYNOPSIS

    my $method_call = Protocol::XMLRPC::MethodCall->new(name => 'foo.bar');
    $method_call->add_param(1);

    $method_call = Protocol::XMLRPC::MethodCall->parse(...);

=head1 DESCRIPTION

XML-RPC methodCall request object.

=head1 ATTRIBUTES

=head2 C<params>

Holds method call name.

=head2 C<params>

Holds array reference of all passed params as objects.

=head1 METHODS

=head2 C<new>

Creates a new L<Protocol::XMLRPC::MethodCall> instance. Name is required.

=head2 C<parse>

    my $method_call = Protocol::XMLRPC::MethodCall->parse('<?xml ...');

Creates a new L<Protocol::XMLRPC::MethodCall> from xml.

=head2 C<add_param>

    $method_call->add_param(1);
    $method_call->add_param(Protocol::XMLRPC::Value::String->new('foo'));

Adds param. Tries to guess a type if a Perl5 scalar/arrayref/hashref was passed
instead of an object.

=head2 C<to_string>

    my $method_call = Protocol::XMLRPC::MethodCall->new(name => 'foo.bar');
    $method_call->add_param('baz');
    # <?xml version="1.0"?>
    # <methodCall>
    #    <methodName>foo.bar</methodName>
    #    <params>
    #       <param>
    #          <value><string>baz</string></value>
    #       </param>
    #    </params>
    # </methodCall>

L<Protocol::XMLRPC::MethodCall> string representation.

=head1 AUTHOR

Viacheslav Tykhanovskyi, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tykhanovskyi.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
