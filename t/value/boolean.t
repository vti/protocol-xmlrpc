#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use Protocol::XMLRPC::Value::Boolean;

my $value = Protocol::XMLRPC::Value::Boolean->new('0');
is($value->to_string, '<boolean>0</boolean>');

$value = Protocol::XMLRPC::Value::Boolean->new('false');
is($value->to_string, '<boolean>false</boolean>');

$value = Protocol::XMLRPC::Value::Boolean->new('1');
is($value->to_string, '<boolean>1</boolean>');

$value = Protocol::XMLRPC::Value::Boolean->new('true');
is($value->to_string, '<boolean>true</boolean>');
