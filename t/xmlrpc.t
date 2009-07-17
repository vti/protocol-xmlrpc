#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Protocol::XMLRPC;
use Protocol::XMLRPC::Value::String;

my $xmlrpc = Protocol::XMLRPC->new(
    http_req_cb => sub {
        my ($self, $url, $args, $cb) = @_;

        my $status = 200;
        my $headers = {};

        my $body = '';

        if ($url eq '1') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params></params></methodCall>');
        }
        elsif ($url eq '2') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><i4>1</i4></value></param></params></methodCall>');
        }
        elsif ($url eq '3') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>1</string></value></param></params></methodCall>');
        }
        elsif ($url eq 'array') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>1</string></value></param></params></methodCall>');
        }
        elsif ($url eq 'struct') {
            is($args->{body}, '<?xml version="1.0"?><methodCall><methodName>foo.bar</methodName><params><param><value><string>1</string></value></param></params></methodCall>');
        }

        $cb->(
            $self, $url,
            {status => $status, headers => $headers, body => $body}
        );
    }
);

$xmlrpc->call(
    '1' => 'foo.bar' => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    '2' => 'foo.bar' => 1 => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    '3' => 'foo.bar' => Protocol::XMLRPC::Value::String->new(1) => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'array' => 'foo.bar' => [Protocol::XMLRPC::Value::String->new(1)] => sub {
        my ($self, $method_response) = @_;
    }
);

$xmlrpc->call(
    'struct' => 'foo.bar' => {foo => 'bar'} => sub {
        my ($self, $method_response) = @_;
    }
);
