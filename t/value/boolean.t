#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use Protocol::XMLRPC::Value::Boolean;

my $value = Protocol::XMLRPC::Value::Boolean->new(value => '0');
is($value->to_string, '<boolean>false</boolean>');

$value = Protocol::XMLRPC::Value::Boolean->new(value => '1');
is($value->to_string, '<boolean>true</boolean>');
