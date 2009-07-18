#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 12;

use Protocol::XMLRPC::ValueFactory;

my $value;

$value = Protocol::XMLRPC::ValueFactory->build();
ok(not defined $value);

$value = Protocol::XMLRPC::ValueFactory->build([]);
ok(not defined $value);

$value = Protocol::XMLRPC::ValueFactory->build({});
ok(not defined $value);

$value = Protocol::XMLRPC::ValueFactory->build(-1);
ok($value->isa('Protocol::XMLRPC::Value::Integer'));

$value = Protocol::XMLRPC::ValueFactory->build(1.2);
ok($value->isa('Protocol::XMLRPC::Value::Double'));

$value = Protocol::XMLRPC::ValueFactory->build('true');
ok($value->isa('Protocol::XMLRPC::Value::Boolean'));

$value = Protocol::XMLRPC::ValueFactory->build('false');
ok($value->isa('Protocol::XMLRPC::Value::Boolean'));

$value = Protocol::XMLRPC::ValueFactory->build('19980717T14:08:55');
ok($value->isa('Protocol::XMLRPC::Value::DateTime'));

$value = Protocol::XMLRPC::ValueFactory->build('Hello');
ok($value->isa('Protocol::XMLRPC::Value::String'));

$value = Protocol::XMLRPC::ValueFactory->build(['foo']);
ok($value->isa('Protocol::XMLRPC::Value::Array'));

$value = Protocol::XMLRPC::ValueFactory->build({foo => 'bar'});
ok($value->isa('Protocol::XMLRPC::Value::Struct'));

$value =
  Protocol::XMLRPC::ValueFactory->build(
    Protocol::XMLRPC::Value::String->new(1));
ok($value->isa('Protocol::XMLRPC::Value::String'));
