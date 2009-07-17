#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 10;

use Protocol::XMLRPC::Value::Array;
use Protocol::XMLRPC::Value::String;
use Protocol::XMLRPC::Value::Integer;

my $value = Protocol::XMLRPC::Value::Array->new();
$value->add_data(Protocol::XMLRPC::Value::String->new('bar'));
is($value->to_string, '<array><data><value><string>bar</string></value></data></array>');
is_deeply($value->value, ['bar']);

$value->add_data(Protocol::XMLRPC::Value::Integer->new(123));
is($value->to_string, '<array><data><value><string>bar</string></value><value><i4>123</i4></value></data></array>');
is_deeply($value->value, ['bar', 123]);

$value =
  Protocol::XMLRPC::Value::Array->new(
    Protocol::XMLRPC::Value::Integer->new(123));
is($value->to_string, '<array><data><value><i4>123</i4></value></data></array>');
is_deeply($value->value, [123]);

$value = Protocol::XMLRPC::Value::Array->new(
    Protocol::XMLRPC::Value::Integer->new(123),
    Protocol::XMLRPC::Value::String->new('foo')
);
is($value->to_string, '<array><data><value><i4>123</i4></value><value><string>foo</string></value></data></array>');
is_deeply($value->value, [123, 'foo']);

$value = Protocol::XMLRPC::Value::Array->new(
    [   Protocol::XMLRPC::Value::Integer->new(123),
        Protocol::XMLRPC::Value::String->new('foo')
    ]
);
is($value->to_string,
    '<array><data><value><i4>123</i4></value><value><string>foo</string></value></data></array>'
);
is_deeply($value->value, [123, 'foo']);
