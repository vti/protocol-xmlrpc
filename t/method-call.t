#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;

use Protocol::XMLRPC::MethodCall;

my $document = Protocol::XMLRPC::MethodCall->new(name => 'foo.bar');
is("$document", qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params></params></methodCall>|);

$document->add_param('foo');
is("$document", qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>foo</string></value></param></params></methodCall>|);

$document = Protocol::XMLRPC::MethodCall->new(name => 'foo.bar');
$document->add_param(123);
is("$document", qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><i4>123</i4></value></param></params></methodCall>|);

ok(not defined $document->parse());

$document = Protocol::XMLRPC::MethodCall->parse(qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>foo</string></value></param></params></methodCall>|);
ok($document);
is($document->name, 'foo.bar');
