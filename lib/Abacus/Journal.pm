package Abacus::Journal;

use strict;
use warnings;
use Data::Dumper;

our $VERSION = "0.1";

sub new {
	my($_class) = @_;
	my $journal= {};
	bless($journal, $_class);
	$journal->_init();
	return $journal;
}

sub _init {
	my ($self) = @_;
	$self->{ent} = [];
	$self->{cur_tr} = '';
}

sub add_comment {
	my ($self, $comment, $parent) = @_;

	$self->{comment} = $comment;
}

sub add_transaction {
	my ($self, $par);
	($self, $par) = @_;
	$self->{cur_tr} = $par;
}

sub new_transaction {
	my ($self, $par);
	($self, %$par) = @_;
	my $tr = {};
  for my $key (qw(date narrative comment status tags)) {
    $tr->{$key} = $par->{$key};
  }
  $tr->{ent} = [];
  $self->add_transaction($tr);
}

sub add_entry{
  my ($self, $par);
  ($self, %$par) = @_;
  $self->{cur_tr} || die 'no current transaction to attach entry to';
  my $ent={};
  for my $key (qw/account amount curr amount_b curr_b comment/) {
		$ent->{$key} = $par->{$key};
  }

  push $self->{cur_tr}->{ent}, $ent; 
  #print Dumper ($self->{cur_tr});
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

=head1 DESCRIPTION

=head4 VARIABLES:

$cur_tr->{}	current transaction (static). A transaction can be selected and be processed (add/read/amend records). 


=head1 WORKING

we gonna:

=head4  print it out in valid ledger data text file
	
=head4  change values (eg base currencyt for a posting)


=head1 BUGS
