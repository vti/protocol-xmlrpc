#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 14;

use Protocol::XMLRPC::Value::String;
use Protocol::XMLRPC::Value::Integer;

my $class = 'Protocol::XMLRPC::Value::Struct';

use_ok($class);

is($class->type, 'struct');

my $value = $class->new();
$value->add_member(foo => Protocol::XMLRPC::Value::String->new('bar'));
is($value->to_string, '<struct><member><name>foo</name><value><string>bar</string></value></member></struct>');
is_deeply($value->value, {foo => 'bar'});

$value->add_member(bar => Protocol::XMLRPC::Value::Integer->new(123));
is($value->to_string, '<struct><member><name>foo</name><value><string>bar</string></value></member><member><name>bar</name><value><i4>123</i4></value></member></struct>');
is_deeply($value->value, {foo => 'bar', bar => 123});

$value = $class->new(bar => Protocol::XMLRPC::Value::Integer->new(123));
is($value->to_string, '<struct><member><name>bar</name><value><i4>123</i4></value></member></struct>');
is_deeply($value->value, {bar => 123});

$value = $class->new(
    foo => Protocol::XMLRPC::Value::Integer->new(321),
    bar => Protocol::XMLRPC::Value::Integer->new(123)
);
like($value->to_string, qr|<member><name>foo</name><value><i4>321</i4></value></member>|);
like($value->to_string, qr|<member><name>bar</name><value><i4>123</i4></value></member>|);

is_deeply($value->value, {foo => 321, bar => 123});

$value = $class->new(
    {   foo => Protocol::XMLRPC::Value::Integer->new(321),
        bar => Protocol::XMLRPC::Value::Integer->new(123)
    }
);
like($value->to_string, qr|<member><name>foo</name><value><i4>321</i4></value></member>|);
like($value->to_string, qr|<member><name>bar</name><value><i4>123</i4></value></member>|);
is_deeply($value->value, {foo => 321, bar => 123});
