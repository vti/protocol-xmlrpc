package Protocol::XMLRPC::Value::Array;
use Any::Moose;

has _data => (
    isa     => 'ArrayRef',
    is      => 'rw',
    default => sub { [] }
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub new {
    my $class = shift;

    my @values;

    if (@_ == 1) {
        @values = ref($_[0]) eq 'ARRAY' ? @{$_[0]} : ($_[0]);
    }
    else {
        @values = @_;
    }

    my $self = $class->SUPER::new;

    foreach my $value (@values) {
        $self->add_data($value);
    }

    return $self;
}

sub add_data {
    my $self = shift;
    my ($value) = @_;

    push @{$self->_data}, $value;
}

sub clone {
    my $self = shift;

    return ref($self)->new(_data => [@{$self->_data}]);
}

sub value {
    my $self = shift;

    return [map { $_->value } @{$self->_data}];
}

sub to_string {
    my $self = shift;

    my $string = '<array><data>';

    foreach my $data (@{$self->_data}) {
        my $value = $data->to_string;

        $string .= "<value>$value</value>";
    }

    $string .= '</data></array>';

    return $string;
}

1;
