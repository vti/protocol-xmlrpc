#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Protocol::XMLRPC::Value::Integer;

my $value = Protocol::XMLRPC::Value::Integer->new(value => '12');
is($value->to_string, '<i4>12</i4>');

$value = Protocol::XMLRPC::Value::Integer->new(value => '-12');
is($value->to_string, '<i4>-12</i4>');

$value = Protocol::XMLRPC::Value::Integer->new(value => '-00012');
is($value->to_string, '<i4>-12</i4>');
