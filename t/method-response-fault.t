#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Protocol::XMLRPC::MethodResponse;

my $res = Protocol::XMLRPC::MethodResponse->new();
ok(not defined $res->parse());

$res->parse(<<'');
<?xml version="1.0"?>
<methodResponse>
   <fault>
      <value>
         <struct>
            <member>
               <name>faultCode</name>
               <value><int>4</int></value>
            </member>
            <member>
               <name>faultString</name>
               <value><string>Too many parameters.</string></value>
            </member>
          </struct>
      </value>
   </fault>
</methodResponse>

is($res->fault_code, 4);
is($res->fault, 'Too many parameters.');
