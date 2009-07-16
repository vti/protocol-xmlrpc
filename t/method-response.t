#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 30;

use Protocol::XMLRPC::MethodResponse;

my $res = Protocol::XMLRPC::MethodResponse->new();
ok(not defined $res->parse());

$res->parse(<<'');
<?xml version="1.0"?>
<methodResponse>
   <params>
      <param>
         <value>FooBar</value>
      </param>
      <param>
         <value><string>BarFoo</string></value>
      </param>
      <param>
         <value><i4>123</i4></value>
      </param>
      <param>
         <value><int>321</int></value>
      </param>
      <param>
         <value><dateTime.iso8601>19980717T14:08:55</dateTime.iso8601></value>
      </param>
      <param>
         <value>
            <array>
               <data>
                  <value><i4>12</i4></value>
                  <value><string>Foo</string></value>
                  <value><boolean>0</boolean></value>
                  <value><double>-31.2</double></value>
               </data>
            </array>
         </value>
      </param>
      <param>
         <value>
           <struct>
             <member>
                <name>fooBar</name>
                <value><i4>18</i4></value>
             </member>
             <member>
                <name>barFoo</name>
                <value>foo</value>
             </member>
           </struct>
         </value>
      </param>
   </params>
</methodResponse>

is(7, scalar @{$res->params});

my $string = $res->params->[0];
ok($string->isa('Protocol::XMLRPC::Value::String'));
is($string->value, 'FooBar');

$string = $res->params->[1];
ok($string->isa('Protocol::XMLRPC::Value::String'));
is($string->value, 'BarFoo');

my $integer = $res->params->[2];
ok($integer->isa('Protocol::XMLRPC::Value::Integer'));
is($integer->value, 123);

$integer = $res->params->[3];
ok($integer->isa('Protocol::XMLRPC::Value::Integer'));
is($integer->value, 321);

my $datetime = $res->params->[4];
ok($datetime->isa('Protocol::XMLRPC::Value::DateTime'));
is($datetime->value, '900684535');

my $array = $res->params->[5];
ok($array->isa('Protocol::XMLRPC::Value::Array'));
is(scalar @{$array->_data}, 4);
ok($array->_data->[0]->isa('Protocol::XMLRPC::Value::Integer'));
is($array->_data->[0]->value, '12');
ok($array->_data->[1]->isa('Protocol::XMLRPC::Value::String'));
is($array->_data->[1]->value, 'Foo');
ok($array->_data->[2]->isa('Protocol::XMLRPC::Value::Boolean'));
is($array->_data->[2]->value, '0');
ok($array->_data->[3]->isa('Protocol::XMLRPC::Value::Double'));
is($array->_data->[3]->value, '-31.2');

my $struct = $res->params->[6];
ok($struct->isa('Protocol::XMLRPC::Value::Struct'));
is(scalar @{$struct->_members} / 2, 2);
is($struct->_members->[0], 'fooBar');
ok($struct->_members->[1]->isa('Protocol::XMLRPC::Value::Integer'));
is($struct->_members->[1]->value, '18');
is($struct->_members->[2], 'barFoo');
ok($struct->_members->[3]->isa('Protocol::XMLRPC::Value::String'));
is($struct->_members->[3]->value, 'foo');
