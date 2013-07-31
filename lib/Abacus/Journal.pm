package Abacus::Journal;

use strict;
use warnings;

our $VERSION = "0.1";

sub new {
	my($_class) = @_;
	my $journal = {};
	bless($journal, $_class);
	$journal->_init();
	return $journal;
}

sub _init {
	my ($self) = @_;
	$self->{tr}=[];
}

sub add_comment {
	my ($self, $comment, $parent) = @_;

	$self->{comment} = $comment;
}


sub add_transaction {
	my ($self, $par);
	($self, %$par) = @_;
	my $tr = {};
	$tr->{date} = $par->{date};
	$tr->{date} = $par->{date};
	$tr->{narrative} = $par->{narrative};
	$tr->{comment} = $par->{comment};
	$tr->{status} = $par->{status};
	$tr;
}

sub add_posting {
}

sub add_rate {
}

sub validate_transaction {
	my ($self, $tr) = @_;
	(ref $tr eq 'HASH') || die "transaction must be a reference to hash";
	push ($self->{tr}, $tr);
}

1;
__END__

=head1 NAME

Abacus::Journal - data structure, representing book entries.

=head1 SYNOPSIS

  use Abacus::Journal;

  my $j = Abacus::Journal->new();

  $j
  #

=head1 DESCRIPTION

=head1 WORKING

we gonna:

=head4  print it out in valid ledger data text file
	
=head4  change values (eg base currencyt for a posting)


=head1 BUGS
