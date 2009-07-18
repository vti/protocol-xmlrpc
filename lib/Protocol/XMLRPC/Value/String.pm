package Protocol::XMLRPC::Value::String;
use Any::Moose;

extends 'Protocol::XMLRPC::Value';

sub type {'string'}

sub to_string {
    my $self = shift;

    my $value = $self->value;

    $value =~ s/&/&amp;/g;
    $value =~ s/</&lt;/g;
    $value =~ s/>/&gt;/g;

    return "<string>$value</string>";
}

1;
