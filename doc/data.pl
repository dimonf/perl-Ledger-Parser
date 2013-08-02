use strict;
use warnings;

use GraphViz::Data::Structure;

my $tr_1 = {date => '2013-03-11',
		narrative => 'rent payment for May',
		comment => 'will be repeated every month',
		status => 'posted',
		tags => 'budget:OK,user:24'
		};

my $ent_1 =
		{account => 'exp:admin:rent',
		amount => 241.23,
		curr => 'EUR',
		amount_b => 303.12,
		curr_b => 'USD',
		narrative => 'rent payable',
		comment => '',
		tags => 'flat-H,ccenter:A',
		tr => $tr_1
		};

my $ent_2 = 
		{account => 'exp:admin:rent',
		amount => 324.33,
		curr => 'EUR',
		amount_b => 407.54,
		curr_b => 'USD',
		narrative => 'rent payable',
		comment => '',
		tags => 'flat-H,ccenter:B',
		tr => $tr_1
		};

my $ent_3 = 
		{account => 'ass:bank:HB',
		amount => 565.56,
		curr => 'EUR',
		amount_b => 710.66,
		curr_b => 'USD',
		narrative => 'paid to Co&Co / HSBC Amsterdam',
		comment => 'SWIFT was not available',
		tags => '',
		tr => $tr_1
		};

my $rates_EUR_USD_dates = [
					'2012-12-03',
					'2012-12-15',
					'2013-01-07',
					'2013-01-23'
		 		];
my $rates_EUR_USD_rates =  {
					'2012-12-03' => {d=>1.253, r=>0.798, dr=>1, rr=>0, ds=>$ent_2, rs=>241},
					'2012-12-15' => {d=>1.233, r=>0.728, dr=>1, rr=>0, ds=>$ent_1, rs=>124},
					'2013-01-07' => {d=>1.213, r=>0.801, dr=>0, rr=>0, ds=>89, rs=>141},
					'2013-01-23' => {d=>1.209, r=>0.829, dr=>1, rr=>0, ds=>$ent_3, rs=>159},
				};

my $rates = {
		EUR => {
			USD => {
				dates => $rates_EUR_USD_dates,
				rates => $rates_EUR_USD_rates,
			},
	 	},
};


my $transactions = [$tr_1];
my $entities = [$ent_1, $ent_2, $ent_3];

$tr_1->{entries} = $entities;

#bless - just for presentation purpose (GraphViz::Data::Structure prints out extra info)
bless($transactions,'Abacus::Transaction');
bless($entities,'Abacus::Entry');

my $journal = {
#	tr => [$transactions],
	ent => $entities 
};

my $gvds = GraphViz::Data::Structure->new($journal, Orientation => 'vertical',
shape=>'box');
$gvds->add($rates);

print $gvds->graph()->as_png('out.png');

=head1 SYNOPSIS 

currency module contains all functionality for storing, manipulation and acquiring rates (prices) for commodities. 

=cut

=head1 DATA STRUCTURE

To avoid uncertainty, for a given pair of currencies only there is only one combination {currency_a}->{currency_b} maintained, which unambiguosly represents the pair.  This is achieved by adhere to the following principle: C<$currency_a lt $currency_b> is always TRUE. It is important however, whenever possible, to avoid 1/rate conversion, which entails rounding. Thus, generally 2 values are stored under given currencies pair: direct and reverse rate

global var %gl_rates is of the following structure:

	$gl_rates->{currency_a}->{currency_b}->{
		'dates' => [--sorted array of YYYY-MM-DD--],
		'rates' => {'YYYY-MM-DD'->{d=>1.253, r=>0.798, dr=>0, rr=>0 ,ds=>N, rs=>N}, ... }}

=over1

		d - direct
		r - reverse
		dr - rank for direct rate
		rr - rank for reverse rate
		ds - source of direct rate (line number of data file)
		rs - source of reverse rate (line number of data file)

=back

	By default rank of a rate is determined by the source of the rate:

=over1

	0	-	explicitly defined by "P" directive (highest rank)
	1	-	defined within a transaction by @ 
	2	-	implicitly derived within a transaction from a) transaction amount, and b) equivalent in base 
			currency, denoted by @@
	11 - the same as 2, but for the rate, application of which is limited to the transaction scope
	12 - the same as 2, but for the rate, application of which is limited to the transaction scope

=back

Ranks 11 and 12 are given for rates, recorded within tranactions, by applying @ or @@ syntax, where the
number is negative. This means that the user intentionally wants to restrict use of the rate to the
transaction's scope. This rate is the last resort in global scope, if nothing suitable is found somewhere else.

=cut



=head2
	get_rate takes arguments:

=over 1

=item 1. $curr_b - 'base currency', which is evaluated in terms of the second argument: 

=item 2. $curr_p - 'price currency',

=item 3. $date - the function returns rate for the date, if available. The latest previous rate is served otherwise.

=back

or how many units of $curr_p can be exchanged for 1 unit of $curr_b:
$curr_b = EUR, $curr_p = USD, exch_rate = 1.35

=cut
