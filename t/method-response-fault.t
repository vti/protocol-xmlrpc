#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use Protocol::XMLRPC::MethodResponse;

ok(not defined Protocol::XMLRPC::MethodResponse->parse());

my $xml =qq|<?xml version="1.0"?><methodResponse><fault><value><struct><member><name>faultCode</name><value><int>4</int></value></member><member><name>faultString</name><value><string>Too many parameters.</string></value></member></struct></value></fault></methodResponse>|;
my $res = Protocol::XMLRPC::MethodResponse->parse($xml);
is($res->fault_code, 4);
is($res->fault, 'Too many parameters.');
is("$res", $xml);
