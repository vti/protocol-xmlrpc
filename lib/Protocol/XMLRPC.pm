package Protocol::XMLRPC;
use Any::Moose;

use Protocol::XMLRPC::MethodResponse;

our $VERSION = '0.01';

# callbacks
has http_req_cb => (
    required => 1,
    isa      => 'CodeRef',
    is       => 'rw',
);

has user_agent => (
    isa     => 'Str',
    is      => 'rw',
    default => 'foo'
);

# debugging
has debug => (
    isa     => 'Int',
    is      => 'rw',
    default => sub { $ENV{PROTOCOL_XMLRPC_DEBUG} || 0 }
);

sub call {
    my $self = shift;
    my ($url, $method_call, $cb) = @_;

    my $headers =
      {'User-Agent' => $self->user_agent, 'Content-Type' => 'text/xml'};

    $self->http_req_cb->(
        $self, $url,
        {headers => $headers, body => "$method_call", method => 'POST'} =>
          sub {
            my ($self, $url, $args) = @_;

            my $status  = $args->{status};
            my $headers = $args->{headers};
            my $body    = $args->{body};

            return $cb->($self) unless $status == 200;

            return $cb->(
                $self, Protocol::XMLRPC::MethodResponse->new->parse($body)
            );
        }
    );
}

1;
