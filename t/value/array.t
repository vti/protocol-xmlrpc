#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 14;

use Protocol::XMLRPC::Value::String;
use Protocol::XMLRPC::Value::Integer;

my $class = 'Protocol::XMLRPC::Value::Array';

use_ok($class);

is($class->type, 'array');

my $value = $class->new();
$value->add_data(Protocol::XMLRPC::Value::String->new('bar'));
is($value->to_string, '<array><data><value><string>bar</string></value></data></array>');
is_deeply($value->value, ['bar']);

$value->add_data(Protocol::XMLRPC::Value::Integer->new(123));
is($value->to_string, '<array><data><value><string>bar</string></value><value><i4>123</i4></value></data></array>');
is_deeply($value->value, ['bar', 123]);

$value = $class->new(Protocol::XMLRPC::Value::Integer->new(123));
is($value->to_string, '<array><data><value><i4>123</i4></value></data></array>');
is_deeply($value->value, [123]);

$value = $class->new(
    Protocol::XMLRPC::Value::Integer->new(123),
    Protocol::XMLRPC::Value::String->new('foo')
);
is($value->to_string, '<array><data><value><i4>123</i4></value><value><string>foo</string></value></data></array>');
is_deeply($value->value, [123, 'foo']);

$value = $class->new(
    [   Protocol::XMLRPC::Value::Integer->new(123),
        Protocol::XMLRPC::Value::String->new('foo')
    ]
);
is($value->to_string,
    '<array><data><value><i4>123</i4></value><value><string>foo</string></value></data></array>'
);
is_deeply($value->value, [123, 'foo']);

$value = $class->new;
$value->add_data(1);
is($value->to_string,
    '<array><data><value><i4>1</i4></value></data></array>'
);
is_deeply($value->value, [1]);
