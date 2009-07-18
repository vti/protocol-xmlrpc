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
    }
    elsif ($value =~ m/^(\d\d\d\d)(\d\d)(\d\d)T(\d\d):(\d\d):(\d\d)$/) {
        return Protocol::XMLRPC::Value::DateTime->parse($value);
    }

    return Protocol::XMLRPC::Value::String->new($value);
}

1;
__END__

=head1 NAME

Protocol::XMLRPC::ValueFactory - value objects factory

=head1 SYNOPSIS

    my $array    = Protocol::XMLRPC::ValueFactory->build([...]);
    my $struct   = Protocol::XMLRPC::ValueFactory->build({...});
    my $integer  = Protocol::XMLRPC::ValueFactory->build(1);
    my $double   = Protocol::XMLRPC::ValueFactory->build(1.2);
    my $datetime = Protocol::XMLRPC::ValueFactory->build('19980717T14:08:55');
    my $boolean  = Protocol::XMLRPC::ValueFactory->build('true');
    my $string   = Protocol::XMLRPC::ValueFactory->build('foo');

=head1 DESCRIPTION

This is a value object factory. Used internally. In synopsis you can see what
types can be guessed.

=head1 ATTRIBUTES

=head1 METHODS

=head2 C<build>

Builds new value object. If no instance was provided tries to guess type.

=head1 AUTHOR

Viacheslav Tikhanovskii, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tikhanovskii.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
