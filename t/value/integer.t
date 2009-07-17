#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use Protocol::XMLRPC::Value::Integer;

my $value = Protocol::XMLRPC::Value::Integer->new('12');
is($value->to_string, '<i4>12</i4>');

$value = Protocol::XMLRPC::Value::Integer->new('12', alias => 'int');
is($value->to_string, '<int>12</int>');

$value = Protocol::XMLRPC::Value::Integer->new('-12');
is($value->to_string, '<i4>-12</i4>');

$value = Protocol::XMLRPC::Value::Integer->new('-00012');
is($value->to_string, '<i4>-12</i4>');
