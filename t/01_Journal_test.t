#!/usr/bin/perl


use strict;
use warnings;

use Test::More;
my $test_entries =  {};
use Data::Dumper;

BEGIN {
	use_ok("Abacus::Journal");
}

sub prepare_data {
	$test_entries->{'1'} = {
		id => '1',
		account => 'exp:admin:rent',
		amount => 241.23,
		curr => 'EUR',
		amount_b => 291.89,
		curr_b => 'USD',
		comment => 'exch/rate from oanda.com',
		tags => 'flat-H,ccenter:A',
	};

	$test_entries->{'2'} = {
	id => '2',
	account => 'exp:admin:rent',
	amount => 310.10,
	curr => 'EUR',
	amount_b => 375.22,
	curr_b => 'USD',
	comment => 'exch/rate from oanda.com',
	tags => 'flat-H,ccenter:B',
	};


	$test_entries->{'3'} = {
		id => '3',
		account => 'exp:bank:HB',
		amount => 14.23,
		curr => 'EUR',
		amount_b => 17.22,
		curr_b => 'USD',
		comment => 'outward payment fee',
		tags => '',
	};

	$test_entries->{'4'} = {
	id => '4',
	account => 'ass:bank:HB',
	amount => -565.56,
	curr => 'EUR',
	amount_b => -684.33,
	curr_b => 'USD',
	comment => 'via Net Banking',
	tags => 'cha:our,type:SEPA',
	};
}


can_ok("Abacus::Journal","new");
can_ok("Abacus::Journal","add_comment");
can_ok("Abacus::Journal","add_transaction");
can_ok("Abacus::Journal","add_entry");
can_ok("Abacus::Journal","add_rate");
can_ok("Abacus::Journal","validate_transaction");
can_ok("Abacus::Journal","tr_get_totals");

my $journal = Abacus::Journal->new();

my $tr_number_before = scalar $journal->{ent};

my $tr = $journal->new_transaction(
	date => '2013-05-11',
	narrative => 'rent payment for May',
	comment => 'will repeat monthly',
	status => 'posted',
	tags => 'budget:OK, user:24, payee:Co&Co/HSBC Amsterdam',
);

is ($tr_number_before, scalar $journal->{ent}, 'no new entries were added to the journal yet');

is(ref $tr, 'HASH', 'method add_transaction returns reference to hash');
is_deeply($journal->{cur_tr}, $tr, 'reference $journal->cur_tr is valid');

prepare_data;

for my $key (sort keys %$test_entries) {
		  	$journal->add_entry(%{$test_entries->{$key}});
}

my $new_entries_count = scalar @{$journal->{cur_tr}->{ent}};
is (scalar keys %$test_entries, $new_entries_count, 
    "number of new entries $new_entries_count");

$journal->validate_transaction;

__END__

