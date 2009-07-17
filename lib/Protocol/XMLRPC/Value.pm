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
