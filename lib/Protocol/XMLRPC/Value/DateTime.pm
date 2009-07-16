package Protocol::XMLRPC::Value::DateTime;
use Any::Moose;

has value => (
    isa => 'Int',
    is  => 'rw'
);

use overload '""' => sub { shift->to_string }, fallback => 1;

require Time::Local;

sub parse {
    my $self = shift;
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

    $self->value($epoch);

    return $self;
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
