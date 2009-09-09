#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 21;

use Protocol::XMLRPC::MethodResponse;

ok(not defined Protocol::XMLRPC::MethodResponse->parse);

my $xml = qq|<?xml version="1.0"?><methodResponse><params><param><value>FooBar</value></param></params></methodResponse>|;
my $res = Protocol::XMLRPC::MethodResponse->parse($xml);
is($res->param->value, 'FooBar');
is("$res", qq|<?xml version="1.0"?><methodResponse><params><param><value><string>FooBar</string></value></param></params></methodResponse>|);

$xml = qq|<?xml version="1.0"?><methodResponse><params><param><value><string>BarFoo</string></value></param></params></methodResponse>|;
$res = Protocol::XMLRPC::MethodResponse->parse($xml);
is($res->param->value, 'BarFoo');
is("$res", $xml);

$xml = q|<?xml version="1.0"?><methodResponse><params><param><value><i4>123</i4></value></param></params></methodResponse>|;
$res = Protocol::XMLRPC::MethodResponse->parse($xml);
is($res->param->value, '123');
is("$res", $xml);

$xml = qq|<?xml version="1.0"?><methodResponse><params><param><value><int>321</int></value></param></params></methodResponse>|;
$res = Protocol::XMLRPC::MethodResponse->parse($xml);
is($res->param->value, '321');
is("$res", $xml);

$xml = qq|<?xml version="1.0"?><methodResponse><params><param><value><dateTime.iso8601>19980717T14:08:55</dateTime.iso8601></value></param></params></methodResponse>|;
$res = Protocol::XMLRPC::MethodResponse->parse($xml);
is($res->param->value, '900684535');
is("$res", $xml);

$xml = qq|<?xml version="1.0"?><methodResponse><params><param><value><array><data><value><i4>12</i4></value><value><string>Foo</string></value><value><boolean>0</boolean></value><value><double>-31.2</double></value></data></array></value></param></params></methodResponse>|;
$res = Protocol::XMLRPC::MethodResponse->parse($xml);
is_deeply($res->param->value, [12, 'Foo', 0, -31.2]);
is("$res", $xml);

$xml = qq|<?xml version="1.0"?><methodResponse><params><param><value><struct><member><name>fooBar</name><value><i4>18</i4></value></member><member><name>barFoo</name><value>foo</value></member></struct></value></param></params></methodResponse>|;
$res = Protocol::XMLRPC::MethodResponse->parse($xml);
is_deeply($res->param->value, {fooBar => 18, barFoo => 'foo'});
is("$res", qq|<?xml version="1.0"?><methodResponse><params><param><value><struct><member><name>fooBar</name><value><i4>18</i4></value></member><member><name>barFoo</name><value><string>foo</string></value></member></struct></value></param></params></methodResponse>|);

$res = Protocol::XMLRPC::MethodResponse->new(123);
is("$res", qq|<?xml version="1.0"?><methodResponse><params><param><value><i4>123</i4></value></param></params></methodResponse>|);
is($res->param->value, 123);

$res = Protocol::XMLRPC::MethodResponse->new([]);
is("$res", qq|<?xml version="1.0"?><methodResponse><params><param><value><array><data></data></array></value></param></params></methodResponse>|);
is_deeply($res->param->value, []);

$res = Protocol::XMLRPC::MethodResponse->new({});
is("$res", qq|<?xml version="1.0"?><methodResponse><params><param><value><struct></struct></value></param></params></methodResponse>|);
is_deeply($res->param->value, {});
