#!perl

use 5.010;
use strict;
use warnings;
use File::Slurp;
use Test::More 0.96;
use FindBin qw($Bin);

use lib "$Bin/../lib";

use Ledger::Parser;


my $ledgerp = Ledger::Parser->new;

sub test_parse {
    my %args = @_;
    my $j;

    ### test parsing ###
    eval {
        $j = $ledgerp->parse($args{ledger});
    };

    my $eval_err = $@;

    if ($args{dies}) {
        ok($eval_err, "dies");
    } else {
        ok(!$eval_err, "doesn't die") or do {
            diag $eval_err;
            return;
        };
    }

    ### test number of transactions ###
    if (defined $args{num_tx}) {
        is(scalar(@{$j->transactions}), $args{num_tx}, "num_tx");
    }

    if ($args{posttest}) {
        $args{posttest}->($j);
    }
}

my $ledger1 = read_file("$Bin/ledger1.dat");
test_parse
    ledger=>$ledger1,
    num_tx => 4,
    posttest => sub {
        my ($j) = @_;
        my $txs = $j->transactions;

        is(ref($txs), 'ARRAY', 'transactions() returns array');

        my $tx0 = $txs->[0];

        is_deeply($tx0->balance, [], 'balance()');

        ok($tx0->is_balanced, 'is_balanced()');

        # XXX test tx1 comment, tx2 comment


        # XXX test post comment
    };

done_testing();


=pod

=head1 OVERALL DESIGN

Data source contains scenario for testing. A data source file shall contain, apart from legible
entries, comments with meta instructions to modify behavior of this test. 

=head1 META INSTRUCTIONS

Instructions may contain extra parameters that are passed to the test program.
