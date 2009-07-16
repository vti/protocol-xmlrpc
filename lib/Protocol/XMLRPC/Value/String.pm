package Protocol::XMLRPC::Value::String;
use Any::Moose;

has value => (
    isa => 'Str',
    is  => 'rw'
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub to_string {
    my $self = shift;

    my $value = $self->value;

    $value =~ s/&/&amp;/g;
    $value =~ s/</&lt;/g;
    $value =~ s/>/&gt;/g;

    return "<string>$value</string>";
}

1;
