package Protocol::XMLRPC::ValueFactory;

use strict;
use warnings;

use Protocol::XMLRPC::Value::Double;
use Protocol::XMLRPC::Value::String;
use Protocol::XMLRPC::Value::Integer;
use Protocol::XMLRPC::Value::Array;
use Protocol::XMLRPC::Value::Boolean;
use Protocol::XMLRPC::Value::DateTime;
use Protocol::XMLRPC::Value::Struct;

sub build {
    my $class = shift;
    my ($value) = @_;

    return unless defined $value;

    if (ref($value) eq 'ARRAY') {
        return unless @$value;
        return Protocol::XMLRPC::Value::Array->new($value);
    }
    elsif (ref($value) eq 'HASH') {
        return unless %$value;
        return Protocol::XMLRPC::Value::Struct->new($value);
    }
    elsif (ref($value)) {
        return $value;
    }
    elsif ($value =~ m/^(?:\+|-)?\d+$/) {
        return Protocol::XMLRPC::Value::Integer->new($value);
    }
    elsif ($value =~ m/^(?:\+|-)?\d+\.\d+$/) {
        return Protocol::XMLRPC::Value::Double->new($value);
    }
    elsif ($value eq 'true' || $value eq 'false') {
        return Protocol::XMLRPC::Value::Boolean->new($value);
    } elsif ($value =~ m/^(\d\d\d\d)(\d\d)(\d\d)T(\d\d):(\d\d):(\d\d)$/) {
        return Protocol::XMLRPC::Value::DateTime->parse($value);
    }

    return Protocol::XMLRPC::Value::String->new($value);
}

1;
