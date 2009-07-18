#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;

my $class = 'Protocol::XMLRPC::Value::Boolean';

use_ok($class);

is($class->type, 'boolean');

my $value = $class->new('0');
is($value->to_string, '<boolean>0</boolean>');

$value = $class->new('false');
is($value->to_string, '<boolean>false</boolean>');

$value = $class->new('1');
is($value->to_string, '<boolean>1</boolean>');

$value = $class->new('true');
is($value->to_string, '<boolean>true</boolean>');
