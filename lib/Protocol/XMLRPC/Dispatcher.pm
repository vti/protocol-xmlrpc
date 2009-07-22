package Protocol::XMLRPC::Dispatcher;
use Any::Moose;

has methods => (
    isa     => 'HashRef',
    is      => 'rw',
    default => sub { {} }
);

has message_corrupted => (
    isa     => 'Str',
    is      => 'rw',
    default => 'Method call is corrupted'
);

has message_unknown_method => (
    isa     => 'Str',
    is      => 'rw',
    default => 'Unknown method'
);

has message_wrong_prototype => (
    isa     => 'Str',
    is      => 'rw',
    default => 'Wrong prototype'
);

use Protocol::XMLRPC::MethodResponse;
use Protocol::XMLRPC::MethodCall;

sub dispatch {
    my $self = shift;
    my ($xml, $cb) = @_;

    my $method_response = Protocol::XMLRPC::MethodResponse->new;

    my $method_call = Protocol::XMLRPC::MethodCall->parse($xml);
    unless ($method_call) {
        $method_response->param($self->message_corrupted);
        return $cb->($method_response);
    }

    my $method = $self->methods->{$method_call->name};

    unless ($method) {
        $method_response->param($self->message_unknown_method);
        return $cb->($method_response);
    }

    my $params = $method_call->params;

    if (my $args_count = @{$method->{args}}) {
        my $prototype =
          $method_call->name . '(' . join(', ', @{$method->{args}}) . ')';

        unless (@$params == $args_count) {
            $method_response->param($self->message_wrong_prototype);
            return $cb->($method_response);
        }

        for (my $count = 0; $count < $args_count; $count++) {
            next if $method->{args}->[$count] eq '*';

            if ($params->[$count]->type ne $method->{args}->[$count]) {
                $method_response->param($self->message_wrong_prototype);
                return $cb->($method_response);
            }
        }
    }

    $method_response->param($method->{handler}->(@{$method_call->params}));

    return $cb->($method_response);
}

1;
