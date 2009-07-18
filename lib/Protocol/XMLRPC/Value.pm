package Protocol::XMLRPC::Value;
use Any::Moose;

has value => (
    isa => 'Str',
    is  => 'rw'
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub new {
    my $class = shift;

    my $value;

    $value = shift if @_ % 2;

    my $self = $class->SUPER::new(@_);

    $self->value($value) if defined $value;

    return $self;
}

sub to_string {
    return '';
}

1;
__END__

=head1 NAME

Protocol::XMLRPC::Value - a base class for scalar values

=head1 SYNOPSIS

    package Protocol::XMLRPC::Value::Boolean;
    use Any::Moose;

    extends 'Protocol::XMLRPC::Value';

    ...

    1;

=head1 DESCRIPTION

This is a base class for all scalar types. Used internally.

=head1 ATTRIBUTES

=head2 C<value>

Hold parameter value.

=head1 METHODS

=head2 C<new>

Returns new L<Protocol::XMLRPC::Value> instance.

=head2 C<to_string>

String representation.

=head1 AUTHOR

Viacheslav Tikhanovskii, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tikhanovskii.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
