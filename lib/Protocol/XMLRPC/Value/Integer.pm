package Protocol::XMLRPC::Value::Integer;
use Any::Moose;

extends 'Protocol::XMLRPC::Value';

has alias => (
    isa     => 'Str',
    is      => 'rw',
    default => 'i4'
);

has value => (
    isa => 'Int',
    is  => 'rw'
);

sub type {'integer'}

sub to_string {
    my $self = shift;

    my $value = $self->value;

    $value = int($value);

    my $alias = $self->alias;
    return "<$alias>$value</$alias>";
}

1;
__END__

=head1 NAME

Protocol::XMLRPC::Value::Integer - XML-RPC array

=head1 SYNOPSIS

    my $integer = Protocol::XMLRPC::Value::Integer->new(123);

=head1 DESCRIPTION

XML-RPC integer

=head1 ATTRIBUTES

=head2 C<alias>

XML-RPC integer can be represented as 'int' and 'i4'. This parameter is 'i4' by
default, but you can change it to 'int'.

=head1 METHODS

=head2 C<new>

Creates new L<Protocol::XMLRPC::Value::Integer> instance.

=head2 C<type>

Returns 'integer'.

=head2 C<value>

    my $integer = Protocol::XMLRPC::Value::Integer->new(1);
    # $integer->value returns 1

Returns serialized Perl5 scalar.

=head2 C<to_string>

    my $integer = Protocol::XMLRPC::Value::Integer->new(1);
    # $integer->to_string is now '<i4>1</i4>'

    my $integer = Protocol::XMLRPC::Value::Integer->new(1, alias => 'int');
    # $integer->to_string is now '<int>1</int>'

XML-RPC integer string representation.

=head1 AUTHOR

Viacheslav Tikhanovskii, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tikhanovskii.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
