#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

use Protocol::XMLRPC;
use Protocol::XMLRPC::Value::String;

my $xmlrpc = Protocol::XMLRPC->new(
    http_req_cb => sub {
        my ($self, $url, $args, $cb) = @_;

        my $status = 200;
        my $headers = {};

        my $body = '';

        if ($url eq 'empty') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params></params></methodCall>');
        }
        elsif ($url eq 'single') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><i4>1</i4></value></param></params></methodCall>');
        }
        elsif ($url eq 'object') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>1</string></value></param></params></methodCall>');
        }
        elsif ($url eq 'array') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><array><data><value><string>1</string></value></data></array></value></param></params></methodCall>');
        }
        elsif ($url eq 'struct') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><struct><member><name>foo</name><value><string>bar</string></value></member></struct></value></param></params></methodCall>');
        }

        $cb->(
            $self, $url,
            {status => $status, headers => $headers, body => $body}
        );
    }
);

$xmlrpc->call(
    'empty' => 'foo.bar' => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'single' => 'foo.bar' => [1] => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'object' => 'foo.bar' => [Protocol::XMLRPC::Value::String->new(1)] => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'array' => 'foo.bar' => [[Protocol::XMLRPC::Value::String->new(1)]] => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'struct' => 'foo.bar' => [{foo => 'bar'}] => sub {
        my ($self, $method_response) = @_;
    }
);
