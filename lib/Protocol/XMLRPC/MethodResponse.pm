package Protocol::XMLRPC::MethodResponse;
use Any::Moose;

use Protocol::XMLRPC::Value::Double;
use Protocol::XMLRPC::Value::String;
use Protocol::XMLRPC::Value::Integer;
use Protocol::XMLRPC::Value::Array;
use Protocol::XMLRPC::Value::Boolean;
use Protocol::XMLRPC::Value::DateTime;
use Protocol::XMLRPC::Value::Struct;

use XML::LibXML;

has params => (
    isa     => 'ArrayRef',
    is      => 'rw',
    default => sub { [] }
);

has fault_code => (
    isa     => 'Int',
    is      => 'rw',
    default => 0
);

has fault => (
    isa     => 'Str',
    is      => 'rw',
    default => ''
);

use overload '""' => sub { shift->to_string }, fallback => 1;

sub parse {
    my $self = shift;
    my ($xml) = @_;

    my $parser = XML::LibXML->new;
    my $doc;
    eval {$doc = $parser->parse_string($xml); };
    return if $@;

    my ($method_response) = $doc->getElementsByTagName('methodResponse');
    return unless $method_response;

    if (my ($params) = $method_response->getElementsByTagName('params')) {
        my @params = $params->getElementsByTagName('param');
        foreach my $param (@params) {
            my ($value) = $param->getElementsByTagName('value');

            if (my $param = $self->_parse_value($value)) {
                push @{$self->params}, $param;
            }
            else {
                return;
            }
        }
    }

    if (my ($fault) = $method_response->getElementsByTagName('fault')) {
        my ($value) = $fault->getElementsByTagName('value');

        if (my $struct = $self->_parse_value($value)) {
            my %values = $struct->members;
            $self->fault_code($values{faultCode}->value);
            $self->fault($values{faultString}->value);
        }
        else {
            return;
        }
    }

    return $self;
}

sub _parse_value {
    my $self = shift;
    my ($value) = @_;

    my @types = $value->childNodes;

    if (@types == 1 && !$types[0]->isa('XML::LibXML::Element')) {
        return Protocol::XMLRPC::Value::String->new(
            value => $types[0]->textContent);
    }

    my ($type) = grep { $_->isa('XML::LibXML::Element') } @types;

    if ($type->getName eq 'string') {
        return
          Protocol::XMLRPC::Value::String->new(
            value => $type->textContent);
    }
    elsif ($type->getName eq 'i4' || $type->getName eq 'int') {
        return
          Protocol::XMLRPC::Value::Integer->new(
            value => $type->textContent);
    }
    elsif ($type->getName eq 'double') {
        return
          Protocol::XMLRPC::Value::Double->new(
            value => $type->textContent);
    }
    elsif ($type->getName eq 'boolean') {
        return
          Protocol::XMLRPC::Value::Boolean->new(
            value => $type->textContent);
    }
    elsif ($type->getName eq 'dateTime.iso8601') {
        return
          Protocol::XMLRPC::Value::DateTime->new()
          ->parse($type->textContent);
    }
    elsif ($type->getName eq 'struct') {
        my $struct = Protocol::XMLRPC::Value::Struct->new;

        my @members = $type->getElementsByTagName('member');
        foreach my $member (@members) {
            my ($name) = $member->getElementsByTagName('name');
            my ($value) = $member->getElementsByTagName('value');

            if (my $param = $self->_parse_value($value)) {
                $struct->add_member($name->textContent => $param);
            }
            else {
                last;
            }
        }

        return $struct;
    }
    elsif ($type->getName eq 'array') {
        my $array = Protocol::XMLRPC::Value::Array->new;

        my ($data) = $type->getElementsByTagName('data');

        my (@values) = grep {$_->isa('XML::LibXML::Element')} $data->childNodes;
        foreach my $value (@values) {
            if (my $param = $self->_parse_value($value)) {
                $array->add_data($param);
            }
            else {
                last;
            }
        }

        return $array;
    }

    return;
}

sub to_string {
    my $self = shift;
}

1;
