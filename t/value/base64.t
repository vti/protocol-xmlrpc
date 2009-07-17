#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Protocol::XMLRPC::Value::Base64;

my $value = Protocol::XMLRPC::Value::Base64->new('foo');
is($value->to_string, "<base64>Zm9v\n</base64>");
