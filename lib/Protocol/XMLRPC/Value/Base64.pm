package Protocol::XMLRPC::Value::Base64;
use Any::Moose;

has value => (
    isa => 'Str',
    is  => 'rw'
);

use overload '""' => sub { shift->to_string }, fallback => 1;

require MIME::Base64;

sub to_string {
    my $self = shift;

    my $value = $self->value;

    $value = MIME::Base64::encode_base64($value);

    return "<base64>$value</base64>";
}

1;
