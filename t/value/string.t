#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Protocol::XMLRPC::Value::String;

my $document = Protocol::XMLRPC::Value::String->new(value => '1 > 2 & 3');
is($document->to_string, '<string>1 &gt; 2 &amp; 3</string>');
