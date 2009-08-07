package Protocol::XMLRPC::Value::Boolean;
use Any::Moose;

extends 'Protocol::XMLRPC::Value';

sub type {'boolean'}

sub to_string {
    my $self = shift;

    my $value = $self->value;

    return "<boolean>$value</boolean>";
}

1;
__END__

=head1 NAME

Protocol::XMLRPC::Value::Boolean - XML-RPC array

=head1 SYNOPSIS

    my $true  = Protocol::XMLRPC::Value::Boolean->new(1);
    my $true  = Protocol::XMLRPC::Value::Boolean->new('true');
    my $false = Protocol::XMLRPC::Value::Boolean->new(0);
    my $false = Protocol::XMLRPC::Value::Boolean->new('false');

=head1 DESCRIPTION

XML-RPC boolean

=head1 METHODS

=head2 C<new>

Creates new L<Protocol::XMLRPC::Value::Boolean> instance.

=head2 C<type>

Returns 'boolean'.

=head2 C<value>

    my $boolean = Protocol::XMLRPC::Value::Boolean->new(1);
    # $boolean->value returns 1

    my $boolean = Protocol::XMLRPC::Value::Boolean->new('false');
    # $boolean->value returns 'false'

Returns serialized Perl5 boolean.

=head2 C<to_string>

    my $boolean = Protocol::XMLRPC::Value::Boolean->new(1);
    # $boolean->to_string is now '<boolean>1</boolean>'

XML-RPC boolean string representation.

=head1 AUTHOR

Viacheslav Tykhanovskyi, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tykhanovskyi.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
