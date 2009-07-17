package Protocol::XMLRPC::Value::Struct;
use Any::Moose;

has _members => (
    isa     => 'ArrayRef',
    is      => 'rw',
    default => sub { [] }
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub new {
    my $class = shift;

    my %values;

    if (@_ == 1) {
        %values = ref($_[0]) eq 'HASH' ? %{$_[0]} : ($_[0]);
    }
    else {
        %values = @_;
    }

    my $self = $class->SUPER::new;

    foreach my $key (keys %values) {
        $self->add_member($key => $values{$key});
    }

    return $self;
}

sub add_member {
    my $self = shift;
    my ($key, $value) = @_;

    push @{$self->_members},
      (   $key => ref($value)
        ? $value
        : Protocol::XMLRPC::Value::String->new(value => $value));
}

sub value {
    my $self = shift;

    my $hash = {};
    for (my $i = 0; $i < @{$self->_members}; $i += 2) {
        my $name = $self->_members->[$i];
        my $value = $self->_members->[$i + 1]->value;

        $hash->{$name} = $value;
    }

    return $hash;
}

sub to_string {
    my $self = shift;

    my $string = '<struct>';

    for (my $i = 0; $i < @{$self->_members}; $i += 2) {
        my $name = $self->_members->[$i];
        my $value = $self->_members->[$i + 1]->to_string;

        $string .= "<member><name>$name</name><value>$value</value></member>";
    }

    $string .= '</struct>';

    return $string;
}

1;
