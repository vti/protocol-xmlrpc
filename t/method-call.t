#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 8;

use Protocol::XMLRPC::MethodCall;

my $method_call = Protocol::XMLRPC::MethodCall->new(name => 'foo.bar');
is("$method_call", qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params></params></methodCall>|);

$method_call->add_param('foo');
is("$method_call", qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>foo</string></value></param></params></methodCall>|);

$method_call = Protocol::XMLRPC::MethodCall->new(name => 'foo.bar');
$method_call->add_param(123);
is("$method_call", qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><i4>123</i4></value></param></params></methodCall>|);

ok(not defined $method_call->parse());

$method_call = Protocol::XMLRPC::MethodCall->parse(qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>foo</string></value></param></params></methodCall>|);
ok($method_call);
is($method_call->name, 'foo.bar');

is(@{$method_call->params}, 1);
is($method_call->params->[0]->value, 'foo');
