#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

my $class = 'Protocol::XMLRPC::Value::String';

use_ok($class);

is($class->type, 'string');

my $document = $class->new('1 > 2 & 3');
is($document->to_string, '<string>1 &gt; 2 &amp; 3</string>');
