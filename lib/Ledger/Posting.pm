package Ledger::Posting;

use 5.010;
use Ledger::Util;
use Log::Any '$log';
use Parse::Number::EN qw(parse_number_en);
use Moo;

# VERSION

my $reset_line = sub { $_[0]->lineref(undef) };

has account => (is => 'rw', trigger => $reset_line);
has amount => (is => 'rw', trigger => $reset_line); # [scalar, unit]
has comment => (is => 'rw', trigger => $reset_line); # [scalar, unit]
has is_virtual => (is => 'rw', trigger => $reset_line);
has virtual_must_balance => (is => 'rw', trigger => $reset_line);
has tx => (is => 'rw');
has lineref => (is => 'rw');

sub BUILD {
    my ($self, $args) = @_;
    my $amt = $self->amount;
    if (defined($amt) && !ref($amt)) {
        $self->amount( $self->_parse_amount($self->amount) );
    }
    # re-set here because of trigger
    if (!defined($self->lineref)) {
        $self->lineref($args->{lineref});
    }
}

sub _die {
    my ($self, $msg) = @_;
    $self->tx->journal->_die("Invalid posting: $msg");
}

sub _parse_amount {
    my ($self, $amt) = @_;
    $amt =~ $re_amount or $self->_die("Invalid amount syntax: $amt");
    my $number = $+{number};
    my $cmdity = $+{cmdity} // "";
    $number = parse_number_en(text => $+{number});
    [$number, $cmdity];
}

sub format_amount {
    my ($self, $amt) = @_;
    $amt //= $self->amount;
    $amt->[0] . (length($amt->[1]) ? " $amt->[1]" : "");
}

sub as_string {
    my ($self) = @_;
    if (defined $self->lineref) {
        ${$self->lineref};
    } else {
        my ($o, $c);
        if ($self->is_virtual) {
            if ($self->virtual_must_balance) {
                ($o, $c) = ("[", "]");
            } else {
                ($o, $c) = ("(", ")");
            }
        } else {
            ($o, $c) = ("", "");
        }

        " $o".$self->account.$c.
            ($self->amount ? "  ".$self->format_amount() : "").
                (defined($self->comment) ? " ;".$self->comment : "").
                    "\n";
    }
}

sub seq {
    # XXX
}

1;
# ABSTRACT: Represent a Ledger posting in a transaction
__END__

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 ATTRIBUTES

=head2 account => STR

=head2 amount => NUM

=head2 commodity => STR

=head2 tx => OBJECT

Pointer to transaction object.

=head2 lineref => REF TO STR


=head1 METHODS

=for Pod::Coverage BUILD

=head2 new(...)

=head2 $p->seq()

Sequence of this posting in the transaction (1 for first, 2 for second, and so
on).

=head2 $p->as_string()

=cut
