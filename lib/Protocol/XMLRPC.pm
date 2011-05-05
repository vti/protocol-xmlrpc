package Protocol::XMLRPC;

use strict;
use warnings;

use Protocol::XMLRPC::MethodCall;
use Protocol::XMLRPC::MethodResponse;

require Carp;

our $VERSION = '0.09';

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    Carp::croak('http_req_cb is required') unless $self->{http_req_cb};

    return $self;
}

sub http_req_cb {
    defined $_[1] ? $_[0]->{http_req_cb} = $_[1] : $_[0]->{http_req_cb};
}

sub call {
    my $self = shift;
    my ($url, $method_name, $args, $cb, $error_cb) = @_;

    if (!defined $cb) {
        ($cb, $args) = ($args, []);
    }
    elsif (ref($args) ne 'ARRAY' && !defined $error_cb) {
        ($cb, $error_cb, $args) = ($args, $cb, []);
    }

    my $method_call = Protocol::XMLRPC::MethodCall->new(name => $method_name);
    foreach my $arg (@$args) {
        $method_call->add_param($arg);
    }

    my $host = $url;
    $host =~ s|^http(s)?://||;
    $host =~ s|/.*$||;

    my $headers = {
        'Content-Type' => 'text/xml',
        'User-Agent'   => 'Protocol-XMLRPC (Perl)',
        'Host'         => $host
    };

    $self->http_req_cb->(
        $self, $url, 'POST', $headers, "$method_call" =>
          sub {
            my ($self, $status, $headers, $body) = @_;

            unless ($status && $status == 200) {
                return $error_cb ? $error_cb->($self) : $cb->($self);
            }

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

    $xmlrpc->call(
        'http://example.com/xmlrpc' => 'plus' => [1, 2] => sub {
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
implementation. You provide callback subroutine for posting method requests.
L<LWP>, L<Mojo::Client> etc can be used for this purpose.

XML-RPC defines different parameters types. Perl5 has only strings,
because of this types are guessed, but you can pass explicit type if guessing is
wrong for you. Read more about parameter creation at
L<Protocol::XMLRPC::ValueFactory>.

=head1 ATTRIBUTES

=head2 C<http_req_cb>

    my $xmlrpc = Protocol::XMLRPC->new(
        http_req_cb => sub {
            my ($self, $url, $method, $headers, $body, $cb) = @_;

            ...

            $cb->($self, $status, $headers, $body);

A callback for sending request to the xmlrpc server. Don't forget that
User-Agent and Host headers are required by XML-RPC specification. Default
values are provided, but you are advised to change them.

Request callback is called with:

=over

=item * B<self> L<Protocol::XMLRPC> instance

=item * B<url> server url (for example 'http://example.com/xmlrpc')

=item * B<method> request method

=item * B<headers> request headers hash reference

=item * B<body> request body to send. Holds L<Protocol::XMLRPC::MethodCall>
string representation.

=item * B<cb> callback that must be called after response was received

=back

Response callback must be called with:

=over

=item * B<self> L<Protocol::XMLRPC> instance

=item * B<status> response status (200, 404 etc)

=item * B<headers> response headers hash reference

=item * B<body> response body

=back

=head1 METHODS

=head2 C<new>

    my $xmlrpc = Protocol::XMLRPC->new(http_req_cb => sub { ... });

Creates L<Protocol::XMLRPC> instance. Argument B<http_req_cb> is required.

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

Viacheslav Tykhanovskyi, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009-2011, Viacheslav Tykhanovskyi.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
