#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use Protocol::XMLRPC;
use Protocol::XMLRPC::MethodCall;

my $xmlrpc = Protocol::XMLRPC->new(
    http_req_cb => sub {
        my ($self, $url, $args, $cb) = @_;

        my $status = 200;
        my $headers = {};

        my $body = '';

        if ($url eq 'http://foo.bar.com/') {
            $body =<<'';
<?xml version="1.0"?>
<methodResponse>
   <params>
      <param>
         <value><string>South Dakota</string></value>
         </param>
      </params>
</methodResponse>

        }

        $cb->(
            $self, $url,
            {status => $status, headers => $headers, body => $body}
        );
    }
);

my $method_call = Protocol::XMLRPC::MethodCall->new(name => 'foo.bar');

$xmlrpc->call(
    'http://foo.bar.com/' => $method_call => sub {
        my ($self, $method_response) = @_;

        ok($method_response);
        ok($method_response->isa('Protocol::XMLRPC::MethodResponse'));
    }
);
