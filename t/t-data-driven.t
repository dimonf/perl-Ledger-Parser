#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);

use lib "$Bin/../lib";
my $test_data_file = 'data-driven.dat';

#use Ledger::Parser;


BEGIN {
	use_ok("Ledger::Parser"); 
}

can_ok("Ledger::Parser",'parse');
can_ok("Ledger::Parser",'parse_file');


my $ledgerp = Ledger::Parser->new;
isa_ok($ledgerp,"Ledger::Parser");

ok(-r $test_data_file && -f $test_data_file,".. the data file '$test_data_file' is valid");

my $j;

sub test_parse {
    my %args = @_;

    ### test parsing ###
    eval {
			$j = $ledgerp->parse_file($args{ledger});
			#$j = $ledgerp->parse($args{ledger});
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
	
	done_testing() if $eval_err;
}

sub test_meta_istructions {
	#read comments from data file and extract testing instructions from there 
	#
	for my $entry  (@{$j->entries}) {
		next if !$entry->isa('Ledger::Comment');	
			my $comment = $entry->as_string;
	}

}


{
    ### test number of transactions ###
	 my %args=@_;
    if (defined $args{num_tx}) {
        is(scalar(@{$j->transactions}), $args{num_tx}, "num_tx");
    }

};

#my $ledger1 = read_file("$Bin/ledger1.dat");
test_parse (ledger=>$test_data_file);


done_testing();


=pod

=head1 OVERALL DESIGN

Data source contains scenario for testing. A data source file shall contain,
apart from legibleentries, comments with meta instructions to modify 
behavior of this test. 

=head1 META INSTRUCTIONS

Instructions may contain extra parameters that are passed to the test program.
