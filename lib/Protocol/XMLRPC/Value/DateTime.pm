package Protocol::XMLRPC::Value::DateTime;
use Any::Moose;

extends 'Protocol::XMLRPC::Value';

has value => (
    isa => 'Int',
    is  => 'rw'
);

require Time::Local;

sub type {'datetime'}

sub parse {
    my $class = shift;
    my ($datetime) = @_;

    my ($year, $month, $mday, $hour, $minute, $second) =
      ($datetime =~ m/(\d\d\d\d)(\d\d)(\d\d)T(\d\d):(\d\d):(\d\d)/);

    my $epoch;

    # Prevent crash
    eval {
        $epoch =
          Time::Local::timegm($second, $minute, $hour, $mday, --$month, $year);
    };

    return if $@ || $epoch < 0;

    return $class->new($epoch);
}

sub to_string {
    my $self = shift;

    my $value = $self->value;

    my ($second, $minute, $hour, $mday, $month, $year, $wday) = gmtime($value);

    $year += 1900;
    $month++;

    #19980717T14:08:55
    $value =
        $year
      . sprintf('%02d', $month)
      . sprintf('%02d', $mday) . 'T'
      . sprintf('%02d', $hour) . ':'
      . sprintf('%02d', $minute) . ':'
      . sprintf('%02d', $second);

    return "<dateTime.iso8601>$value</dateTime.iso8601>";
}

1;
__END__

=head1 NAME

Protocol::XMLRPC::Value::DateTime - XML-RPC array

=head1 SYNOPSIS

    my $datetime = Protocol::XMLRPC::Value::DateTime->new(1234567890);
    my $datetime = Protocol::XMLRPC::Value::DateTime->parse('19980717T14:08:55');

=head1 DESCRIPTION

XML-RPC dateTime.iso8601

=head1 METHODS

=head2 C<new>

Creates new L<Protocol::XMLRPC::Value::DateTime> instance. Accepts unix epoch
time.

=head2 C<parse>

Parses dateTime.iso8601 string and creates a new L<Protocol::XMLRPC:::Value::Base64>
instance.

=head2 C<type>

Returns 'datetime'.

=head2 C<value>

    my $datetime = Protocol::XMLRPC::Value::DateTime->new(1234567890);
    # $datetime->value returns 20091302T23:31:30

Returns serialized Perl5 scalar.

=head2 C<to_string>

    my $datetime = Protocol::XMLRPC::Value::DateTime->new(1234567890);
    # $datetime->to_string is now '<dateTime.iso8601>20091302T23:31:30</dateTime.iso8601>'

XML-RPC datetime string representation.

=head1 AUTHOR

Viacheslav Tykhanovskyi, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tykhanovskyi.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
