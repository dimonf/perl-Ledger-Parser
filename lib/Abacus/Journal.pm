package Abacus::Journal;

use strict;
use warnings;
use Data::Dumper;

our $VERSION = "0.1";
our $int_ind = 0; 

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

sub new_transaction {
	my ($self, $par);
	($self, %$par) = @_;
	my $tr = {};
  for my $key (qw(date id narrative comment status tags)) {
    $tr->{$key} = $par->{$key};
  }
  $tr->{int_ind} = ++$int_ind;
  #$tr->{ent} = [];
  $self->add_transaction($tr);
}

sub add_transaction {
	my ($self, $par);
	($self, $par) = @_;
	$self->{cur_tr} = $par;
}

sub add_entry{
  #adds entry to a stack $self->{curr_tr}->{ent}
  #
  my ($self, $par);
  ($self, $par) = @_;
  my $ent={};

  for my $key (qw/account amount curr amount_b curr_b comment tr/) {
		$ent->{$key} = $par->{$key};
  }
	$ent->{tr} = $self->{cur_tr} unless $ent->{tr};
  defined $ent->{tr} || die 'unable to determine transaction for an entry being added';

  #print Dumper($ent);
  push @{$self->{cur_tr}->{ent}}, $ent; 
}

sub validate_transaction {
  # validate AND actually add ALL entries of a transaction into $self->{ent}
	#part of validation take place in tr_get_totals
  my ($self, $par);
	($self,%$par) = @_;
	my $t = $self->tr_get_totals;
	$t->{$t->{base_curr}} == 0 || die "balance in base currency is not 0!";
  #print "working\n", Dumper($self->{cur_tr}->{ent});
   push (@{$self->{ent}}, @{$self->{cur_tr}->{ent}}) if $par->{post}
}

sub tr_get_totals {
  #returns hash with total for each currency in transaction.
  #adds base_curr key to indicate base currency, eg:
  # {"USD"=>1.00, "EUR"=>0.00, base_curr=>"EUR"}
	my ($self) = shift;
	my %t;
	for my $ent (@{$self->{cur_tr}->{ent}}) {
			  #print Dumper ($ent);
		$t{$ent->{curr}} += $ent->{amount};
		$t{$ent->{curr_b}} += $ent->{amount_b};

		if  (! $t{base_curr} ) {
			$t{base_curr} = $ent->{curr_b} if $ent->{curr_b};
		} elsif ($ent->{curr_b}) {
			#validation: there must be only one base currency throughout a transaction
			$t{base_curr} eq $ent->{curr_b} || die 'more than one base currency in use'
		}
		for my $k (keys %t) {
			$k eq 'base_curr' || ($t{$k} = sprintf "%.2f", $t{$k});
		}

	}	  
	\%t;
}

sub print_journal {
  my ($self) = @_;
  my $cur_tr;
  #print Dumper($self->{ent});
  #die 'remove me';
  
  for my $ent ($self->{ent}) {
    #print Dumper($ent);
    if ($cur_tr != $ent->{tr}) {
        $cur_tr = $ent->{tr};
        $self->print_tr($ent->{tr});
    }
    $self->print_ent($ent);
  }
}

sub print_tr {
  my($self, %p) = @_;
  print "\n$p{date} $p{id} $p{narrative} $p{status} $p{tags};$p{comment} ";
}


sub print_ent {
  my ($self, %e) = @_;
  print "$e{id} $e{account} $e{curr} $e{amount} $e{curr_b} $e{amount_b} $e{comment} $e{tags}";
}

sub add_rate {
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
