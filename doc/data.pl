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



my $transactions = [$tr_1];
my $entities = [$ent_1, $ent_2, $ent_3];

$tr_1->{entries} = $entities;

#bless - just for presentation purpose (GraphViz::Data::Structure prints out extra info)
bless($transactions,'Abacus::Transaction');
bless($entities,'Abacus::Entry');

my $journal = {
#	tr => [$transactions],
	ent => [$entities] 
};

my $gvds = GraphViz::Data::Structure->new($journal, Orientation => 'vertical',
shape=>'box');
print $gvds->graph()->as_png('out.png');

