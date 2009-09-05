package Protocol::XMLRPC::Dispatcher;

use strict;
use warnings;

use Protocol::XMLRPC::MethodResponse;
use Protocol::XMLRPC::MethodCall;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    $self->{methods} ||= {};
    $self->{message_corrupted}       ||= 'Method call is corrupted';
    $self->{message_unknown_method}  ||= 'Unknown method';
    $self->{message_wrong_prototype} ||= 'Wrong prototype';

    return $self;
}

sub methods { defined $_[1] ? $_[0]->{methods} = $_[1] : $_[0]->{methods} }

sub message_corrupted {
    defined $_[1]
      ? $_[0]->{message_corrupted} = $_[1]
      : $_[0]->{message_corrupted};
}

sub message_unknown_method {
    defined $_[1]
      ? $_[0]->{message_unknown_method} = $_[1]
      : $_[0]->{message_unknown_method};
}

sub message_wrong_prototype {
    defined $_[1]
      ? $_[0]->{message_wrong_prototype} = $_[1]
      : $_[0]->{message_wrong_prototype};
}

sub dispatch {
    my $self = shift;
    my ($xml, $cb) = @_;

    my $method_response = Protocol::XMLRPC::MethodResponse->new;

    my $method_call = Protocol::XMLRPC::MethodCall->parse($xml);
    unless ($method_call) {
        $method_response->fault(-1 => $self->message_corrupted);
        return $cb->($method_response);
    }

    my $method = $self->methods->{$method_call->name};

    unless ($method) {
        $method_response->fault(-1 => $self->message_unknown_method);
        return $cb->($method_response);
    }

    my $params = $method_call->params;

    if (my $args_count = @{$method->{args}}) {
        my $prototype =
          $method_call->name . '(' . join(', ', @{$method->{args}}) . ')';

        unless (@$params == $args_count) {
            $method_response->fault(-1 => $self->message_wrong_prototype);
            return $cb->($method_response);
        }

        for (my $count = 0; $count < $args_count; $count++) {
            next if $method->{args}->[$count] eq '*';

            if ($params->[$count]->type ne $method->{args}->[$count]) {
                $method_response->fault(-1 => $self->message_wrong_prototype);
                return $cb->($method_response);
            }
        }
    }

    my $param;
    #eval {die};
    eval { $param = $method->{handler}->(@{$method_call->params}) };

    if ($@) {
        my ($error) = ($@ =~ m/^(.*?) at/m);
        $method_response->fault(-1 => $error || 'Internal error');
    }
    else {
        $method_response->param($param);
    }

    return $cb->($method_response);
}

1;
