package Protocol::XMLRPC::Value::Base64;
use Any::Moose;

extends 'Protocol::XMLRPC::Value';

require MIME::Base64;

sub type {'base64'}

sub to_string {
    my $self = shift;

    my $value = $self->value;

    $value = MIME::Base64::encode_base64($value);

    return "<base64>$value</base64>";
}

1;
