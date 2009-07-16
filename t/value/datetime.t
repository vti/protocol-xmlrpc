#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Protocol::XMLRPC::Value::DateTime;

my $value = Protocol::XMLRPC::Value::DateTime->new(value => 1247754181);
is($value->to_string, '<dateTime.iso8601>20090716T14:23:01</dateTime.iso8601>');

$value = Protocol::XMLRPC::Value::DateTime->new(value => 0);
is($value->to_string, '<dateTime.iso8601>19700101T00:00:00</dateTime.iso8601>');

$value = Protocol::XMLRPC::Value::DateTime->new()->parse('19700101T00:00:00');
is($value->to_string, '<dateTime.iso8601>19700101T00:00:00</dateTime.iso8601>');
