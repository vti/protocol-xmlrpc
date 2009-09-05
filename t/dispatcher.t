#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

use Protocol::XMLRPC::Dispatcher;
use Protocol::XMLRPC::MethodCall;

my $dispatcher = Protocol::XMLRPC::Dispatcher->new(
    methods => {
        plus => {
            args    => [qw/integer integer/],
            handler => sub { $_[0]->value + $_[1]->value; }
        }
    }
);

my $method_response;

$dispatcher->dispatch(
    'foo' => sub {
        my $res = shift;

        is($res->fault_string, 'Method call is corrupted');
    }
);

my $req = Protocol::XMLRPC::MethodCall->new(name => 'foo');
$dispatcher->dispatch(
    "$req" => sub {
        my $res = shift;

        is($res->fault_string, 'Unknown method');
    }
);

$req = Protocol::XMLRPC::MethodCall->new(name => 'plus');
$req->add_param(1);
$dispatcher->dispatch(
    "$req" => sub {
        my $res = shift;

        is($res->fault_string, 'Wrong prototype');
    }
);

$req = Protocol::XMLRPC::MethodCall->new(name => 'plus');
$req->add_param('foo');
$req->add_param('bar');
$dispatcher->dispatch(
    "$req" => sub {
        my $res = shift;

        is($res->fault_string, 'Wrong prototype');
    }
);

$req = Protocol::XMLRPC::MethodCall->new(name => 'plus');
$req->add_param(1);
$req->add_param(2);
$dispatcher->dispatch(
    "$req" => sub {
        my $res = shift;

        is($res->param->value, 3);
    }
);
