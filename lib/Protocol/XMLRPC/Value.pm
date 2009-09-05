package Protocol::XMLRPC::Value;

use strict;
use warnings;

use overload '""' => sub { shift->to_string }, fallback => 1;

sub new {
    my $class = shift;

    my $value; $value = shift if @_ % 2;

    my $self = {@_};
    bless $self, $class;

    $self->value($value) if defined $value;

    return $self;
}

sub value { defined $_[1] ? $_[0]->{value} = $_[1] : $_[0]->{value} }

sub to_string { '' }

1;
__END__

=head1 NAME

Protocol::XMLRPC::Value - a base class for scalar values

=head1 SYNOPSIS

    package Protocol::XMLRPC::Value::Boolean;

    use strict;
    use warnings;

    use base 'Protocol::XMLRPC::Value';

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

Viacheslav Tykhanovskyi, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tykhanovskyi.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
