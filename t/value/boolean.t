#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 16;

my $class = 'Protocol::XMLRPC::Value::Boolean';

use_ok($class);

is($class->type, 'boolean');

my $value = $class->new(\0);
ok(!$value->value);
ok($value->value == 0);
ok($value->value eq 'false');
is($value->to_string, '<boolean>false</boolean>');

$value = $class->new(0);
is($value->to_string, '<boolean>false</boolean>');

$value = $class->new('false');
ok(!$value->value);
is($value->to_string, '<boolean>false</boolean>');

$value = $class->new(\1);
ok($value->value);
ok($value->value == 1);
ok($value->value eq 'true');
is($value->to_string, '<boolean>true</boolean>');

$value = $class->new(1);
is($value->to_string, '<boolean>true</boolean>');

$value = $class->new('true');
ok($value->value);
is($value->to_string, '<boolean>true</boolean>');
