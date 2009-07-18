package Protocol::XMLRPC;
use Any::Moose;

use Protocol::XMLRPC::MethodCall;
use Protocol::XMLRPC::MethodResponse;

our $VERSION = '0.01';

has http_req_cb => (
    required => 1,
    isa      => 'CodeRef',
    is       => 'rw',
);

sub call {
    my $self = shift;
    my ($url, $method_name, $args, $cb) = @_;

    ($cb, $args) = ($args, []) unless $cb;

    my $method_call = Protocol::XMLRPC::MethodCall->new(name => $method_name);
    foreach my $arg (@$args) {
        $method_call->add_param($arg);
    }

    $self->http_req_cb->(
        $self, $url, "$method_call" =>
          sub {
            my ($self, $status, $body) = @_;

            return $cb->($self) unless $status && $status == 200;

            return $cb->(
                $self, Protocol::XMLRPC::MethodResponse->parse($body)
            );
        }
    );
}

1;
__END__

=head1 NAME

Protocol::XMLRPC - Asynchronous, web framework agnostic XML-RPC implementation

=head1 SYNOPSIS

    my $xmlrpc = Protocol::XMLRPC->new(
        http_req_cb => sub {

            ...

            $cb->(..);
        }
    );

    $xmlrpc->call('http://example.com/xmlrpc' => 'plus' => [1, 2] => sub {
            my ($self, $method_response) = @_;

            if (!$method_response) {
                print "internal error\n";
            }
            elsif ($method_response->fault) {
                print 'error: ', $method_response->fault, "\n";
            }
            else {
                print $method_response->param->value, "\n";
            }
        }
    );

=head1 DESCRIPTION

L<Protocol::XMLRPC> is asynchronous, web framework agnostic XML-RPC
implementation. You provide callback subrouting for posting method request. You
can use L<LWP>, L<Mojo::Client> etc for this purpose.

Perl doesn't have scalar types, because of this parameters types are guessed,
but you can pass explicit type if guessing is wrong for you. Read more about
parameter creation at L<Protocol::XMLRPC::ValueFactory>.

=head1 ATTRIBUTES

=head2 C<http_req_cb>

    my $xmlrpc = Protocol::XMLRPC->new(
        http_req_cb => sub {
            my ($self, $url, $headers, $body, $cb) = @_;

            ...

            $cb->($self, $status, $headers, $body);

A callback for sending request to the xmlrpc server.  Don't forget that
User-Agent and Host headers are required by XML-RPC specification. Reqeust
method must be POST also.

Callback receives these parameters:

=head3 C<self>

L<Protocol::XMLRPC> instance.

=head3 C<url>

Server url (for example 'http://example.com/xmlrpc').

=head3 C<body>

Request body to send. Holds L<Protocol::XMLRPC::MethodCall> string
representation.

=head3 C<cb>

Callback that must be called after response was received. Must be provided with
L<Protocol::XMLRPC> instance, response status and body.

=head1 METHODS

=head2 C<new>

    my $xmlrpc = Protocol::XMLRPC->new(http_req_cb => sub { ... });

Creates L<Protocol::XMLRPC> instance. Argument b<http_req_cb> is required.

=head2 C<call>

    $xmlrpc->call(
        'http://example.com/xmlrpc' => 'plus' => [1, 2] => sub {
            my ($self, $method_response) = @_;

            ...
        }
    );

Creates L<Protocol::XMLRPC::MethodCall> object with provided parameters and
calls http_req_cb with url and body. Upon response parses and created
L<Protocol::XMLRPC::MethodResponse> object and calls provided callback.

Parameter are optional. But must be provided as an array reference. Parameters
types are guessed (more about that in L<Protocol::XMLRPC::ValueFactory>). If you
must pass parameter which type cannot be easily guesed, for example you want to
pass 1 as a string, you can pass value instance instead of a value.

    $xmlrpc->call(
        'http://example.com/xmlrpc' => 'getPost' =>
          [Protocol::XMLRPC::Value::String->new(1)] => sub {
            my ($self, $method_response) = @_;

            ...
        }
    );

=head1 DEVELOPMENT

=head2 Repository

    http://github.com/vti/protocol-xmlrpc/commits/master

=head1 AUTHOR

Viacheslav Tikhanovskii, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tikhanovskii.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
