#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use Protocol::XMLRPC::Value::Struct;
use Protocol::XMLRPC::Value::String;
use Protocol::XMLRPC::Value::Integer;

my $value = Protocol::XMLRPC::Value::Struct->new();
$value->add_member(foo => Protocol::XMLRPC::Value::String->new(value => 'bar'));
is($value->to_string, '<struct><member><name>foo</name><value><string>bar</string></value></member></struct>');
is($value->members, 2);

$value->add_member(bar => Protocol::XMLRPC::Value::Integer->new(value => 123));
is($value->to_string, '<struct><member><name>foo</name><value><string>bar</string></value></member><member><name>bar</name><value><i4>123</i4></value></member></struct>');
is($value->members, 4);
