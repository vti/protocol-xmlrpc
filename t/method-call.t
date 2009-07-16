#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use Protocol::XMLRPC::MethodCall;

my $document = Protocol::XMLRPC::MethodCall->new(name => 'foo.bar');
is($document->to_string, qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params></params></methodCall>|);

$document->add_param('foo');
is($document->to_string, qq|<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>foo</string></value></param></params></methodCall>|);
