#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;

my $class = 'Protocol::XMLRPC::Value::Integer';

use_ok($class);

is($class->type, 'int');

my $value = $class->new('12');
is($value->to_string, '<i4>12</i4>');

$value = $class->new('12', alias => 'int');
is($value->to_string, '<int>12</int>');

$value = $class->new('-12');
is($value->to_string, '<i4>-12</i4>');

$value = $class->new('-00012');
is($value->to_string, '<i4>-12</i4>');
