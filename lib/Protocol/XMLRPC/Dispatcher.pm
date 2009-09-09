package Protocol::XMLRPC::Dispatcher;

use strict;
use warnings;

use Protocol::XMLRPC::MethodResponse;
use Protocol::XMLRPC::MethodCall;
use Protocol::XMLRPC::ValueFactory;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    $self->{methods} ||= {};
    $self->{message_corrupted}       ||= 'Method call is corrupted';
    $self->{message_unknown_method}  ||= 'Unknown method';
    $self->{message_wrong_prototype} ||= 'Wrong prototype';

    $self->{methods}->{'system.getCapabilities'} = {
        ret => 'struct',
        args    => [],
        handler => sub {
            return {
                name => 'introspect',
                specUrl =>
                  'http://xmlrpc-c.sourceforge.net/xmlrpc-c/introspection.html',
                specVersion => 1
            };
          }
    };

    $self->{methods}->{'system.listMethods'} = {
        ret => 'array',
        args    => [],
        handler => sub {
            return [sort keys %{$self->{methods}}];
          }
    };

    $self->{methods}->{'system.methodSignature'} = {
        ret => 'array',
        args    => ['string'],
        handler => sub {
            my ($name) = @_;

            if (my $method = $self->{methods}->{$name->value}) {
                return [$method->{ret}, @{$method->{args}}];
            }

            die $self->message_unknown_method;
          }
    };

    $self->{methods}->{'system.methodHelp'} = {
        ret => 'string',
        args    => ['string'],
        handler => sub {
            my ($name) = @_;

            if (my $method = $self->{methods}->{$name->value}) {
                return $method->{descr};
            }

            die $self->message_unknown_method;
          }
    };

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

    my $method_name = $method_call->name;

    my $method = $self->methods->{$method_name};

    unless ($method) {
        $method_response->fault(-1 => $self->message_unknown_method);
        return $cb->($method_response);
    }

    my $params = $method_call->params;

    my $args_count = @{$method->{args}};
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

    my $param;
    eval { $param = $method->{handler}->(@{$method_call->params}) };

    if ($@) {
        my ($error) = ($@ =~ m/^(.*?) at/m);
        $method_response->fault(-1 => $error || 'Internal error');
    }
    else {
        if (my $type = $method->{ret}) {
            $method_response->param(
                Protocol::XMLRPC::ValueFactory->build($type => $param));
        }
        else {
            $method_response->param($param);
        }
    }

    return $cb->($method_response);
}

1;
