package Protocol::XMLRPC::Method;
use Any::Moose;

use Protocol::XMLRPC::Value::Double;
use Protocol::XMLRPC::Value::String;
use Protocol::XMLRPC::Value::Integer;
use Protocol::XMLRPC::Value::Array;
use Protocol::XMLRPC::Value::Boolean;
use Protocol::XMLRPC::Value::DateTime;
use Protocol::XMLRPC::Value::Struct;
use Protocol::XMLRPC::Value::Base64;

use XML::LibXML;

use overload '""' => sub { shift->to_string }, fallback => 1;

sub parse {
    my $class = shift;
    my ($xml) = @_;

    my $parser = XML::LibXML->new;
    my $doc;
    eval {$doc = $parser->parse_string($xml); };
    return if $@;

    return $class->_parse_document($doc);
}

sub _parse_document {
}

sub _parse_value {
    my $self = shift;
    my ($value) = @_;

    my @types = $value->childNodes;

    if (@types == 1 && !$types[0]->isa('XML::LibXML::Element')) {
        return Protocol::XMLRPC::Value::String->new($types[0]->textContent);
    }

    my ($type) = grep { $_->isa('XML::LibXML::Element') } @types;

    if ($type->getName eq 'string') {
        my $value = $type->textContent;

        return Protocol::XMLRPC::Value::String->new($value);
    }
    elsif ($type->getName eq 'i4' || $type->getName eq 'int') {
        my $value = $type->textContent;
        return unless $value =~ m/^(?:\+|-)?\d+$/;

        return Protocol::XMLRPC::Value::Integer->new($type->textContent,
            alias => $type->getName);
    }
    elsif ($type->getName eq 'double') {
        my $value = $type->textContent;
        return unless $value =~ m/^(?:\+|-)?\d+(?:\.\d+)?$/;

        return Protocol::XMLRPC::Value::Double->new($type->textContent);
    }
    elsif ($type->getName eq 'boolean') {
        my $value = $type->textContent;
        return unless $value =~ m/^(?:0|false|1|true)$/;

        return Protocol::XMLRPC::Value::Boolean->new($type->textContent);
    }
    elsif ($type->getName eq 'dateTime.iso8601') {
        my $value = $type->textContent;
        return
          unless $value =~ m/^(\d\d\d\d)(\d\d)(\d\d)T(\d\d):(\d\d):(\d\d)$/;

        return Protocol::XMLRPC::Value::DateTime->parse($type->textContent);
    }
    elsif ($type->getName eq 'base64') {
        my $value = $type->textContent;
        return unless $value =~ m/^[A-Za-z0-9\+\/=]+$/;

        return Protocol::XMLRPC::Value::Base64->parse($value);
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

1;
__END__

=head1 NAME

Protocol::XMLRPC::Method - methodCall and methodResponse base class

=head1 SYNOPSIS

    package Protocol::XMLRPC::MethodCall;
    use Any::Moose;

    extends 'Protocol::XMLRPC::Method';

    ...

    1;

=head1 DESCRIPTION

A base class for L<Protocol::XMLRPC::MethodCall> and
L<Protocol::XMLRPC::MethodCall>. Used internally.

=head1 METHODS

=head2 C<parse>

Parses xml.

=head1 AUTHOR

Viacheslav Tykhanovskyi, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tykhanovskyi.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
