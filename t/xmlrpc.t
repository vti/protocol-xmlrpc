#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 20;

use Protocol::XMLRPC;
use Protocol::XMLRPC::Value::String;

my $xmlrpc = Protocol::XMLRPC->new(
    http_req_cb => sub {
        my ($self, $url, $method, $headers, $body, $cb) = @_;

        if ($url eq 'http://empty.com/') {
            is($body, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params></params></methodCall>');
            is($headers->{'Host'}, 'empty.com');
        }
        elsif ($url eq 'http://single.com/') {
            is($body, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><i4>1</i4></value></param></params></methodCall>');
            is($headers->{'Host'}, 'single.com');
        }
        elsif ($url eq 'http://object.com/') {
            is($body, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>1</string></value></param></params></methodCall>');
            is($headers->{'Host'}, 'object.com');
        }
        elsif ($url eq 'http://array.com/') {
            is($body, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><array><data><value><string>1</string></value></data></array></value></param></params></methodCall>');
            is($headers->{'Host'}, 'array.com');
        }
        elsif ($url eq 'http://struct.com/') {
            is($body, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><struct><member><name>foo</name><value><string>bar</string></value></member></struct></value></param></params></methodCall>');
            is($headers->{'Host'}, 'struct.com');
        }

        is($headers->{'Content-Type'}, 'text/xml');
        is($headers->{'User-Agent'}, 'Protocol-XMLRPC (Perl)');

        $cb->($self, 200, {}, '');
    }
);

$xmlrpc->call(
    'http://empty.com/' => 'foo.bar' => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'http://single.com/' => 'foo.bar' => [1] => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'http://object.com/' => 'foo.bar' => [Protocol::XMLRPC::Value::String->new(1)] => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'http://array.com/' => 'foo.bar' => [[Protocol::XMLRPC::Value::String->new(1)]] => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'http://struct.com/' => 'foo.bar' => [{foo => 'bar'}] => sub {
        my ($self, $method_response) = @_;
    }
);
