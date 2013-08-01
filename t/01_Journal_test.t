#!/usr/bin/perl


use strict;
use warnings;

use Test::More;

BEGIN {
	use_ok("Abacus::Journal");
}

can_ok("Abacus::Journal","new");
can_ok("Abacus::Journal","add_comment");
can_ok("Abacus::Journal","add_transaction");
can_ok("Abacus::Journal","add_posting");
can_ok("Abacus::Journal","add_rate");
can_ok("Abacus::Journal","validate_transaction");

my $journal = Abacus::Journal->new();

my $tr = $journal->add_transaction(
	date => '2011-09-01',
	narrative => 'test one',
	comment => 'something about it',
	status => 'A');

is(ref $tr, 'HASH', 'method add_transaction returns reference to hash');

$journal->add_posting(
  transaction => $tr,
  account => 'a:bb:02',
  amount => 243.21,
  curr => 'EUR',
  amount_b => 301.12,
  curr_b => 'USD');
