#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use Protocol::XMLRPC::Value::Array;
use Protocol::XMLRPC::Value::String;
use Protocol::XMLRPC::Value::Integer;

my $value = Protocol::XMLRPC::Value::Array->new();
$value->add_data(Protocol::XMLRPC::Value::String->new(value => 'bar'));
is($value->to_string, '<array><data><value><string>bar</string></value></data></array>');
is($value->data, 1);

$value->add_data(Protocol::XMLRPC::Value::Integer->new(value => 123));
is($value->to_string, '<array><data><value><string>bar</string></value><value><i4>123</i4></value></data></array>');
is($value->data, 2);
