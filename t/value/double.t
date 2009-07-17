#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Protocol::XMLRPC::Value::Double;

my $value = Protocol::XMLRPC::Value::Double->new(12.12);
is($value->to_string, '<double>12.12</double>');

$value = Protocol::XMLRPC::Value::Double->new(-12.12);
is($value->to_string, '<double>-12.12</double>');

$value = Protocol::XMLRPC::Value::Double->new(-12.12);
is($value->to_string, '<double>-12.12</double>');
