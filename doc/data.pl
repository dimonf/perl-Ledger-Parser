use strict;
use warnings;

use GraphViz::Data::Structure;
use GraphViz::Data::Grapher;

my $tr = {
		02423 => {date => '2013-03-11',
		narrative => 'rent payment for May',
		comment => 'will be repeated every month',
		status => 'posted',
		tags => 'budget:OK,user:24'
		}
	};

my $ent = [
		{account => 'exp:admin:rent',
		amount => 241.23,
		curr => 'EUR',
		amount_b => 303.12,
		curr_b => 'USD',
		narrative => 'rent payable',
		comment => '',
		tags => 'flat-H,ccenter:A',
		tr => '02423'
		},
		{account => 'exp:admin:rent',
		amount => 324.33,
		curr => 'EUR',
		amount_b => 407.54,
		curr_b => 'USD',
		narrative => 'rent payable',
		comment => '',
		tags => 'flat-H,ccenter:B',
		tr => '02423'
		},
		{account => 'ass:bank:HB',
		amount => 565.56,
		curr => 'EUR',
		amount_b => 710.66,
		curr_b => 'USD',
		narrative => 'paid to Co&Co / HSBC Amsterdam',
		comment => 'SWIFT was not available',
		tags => '',
		tr => '02423'
		}
	];

bless($tr,'Abacus::Transaction');
bless($ent,'Abacus::Entry');

my $journal = {
	tr => $tr,
	ent => $ent
};

my $gvds = GraphViz::Data::Structure->new($journal, Orientation => 'vertical',
shape=>'box');
print $gvds->graph()->as_png('out.png');

#my $graph = GraphViz::Data::Grapher->new($journal, Orientation => 'vertical');
#print $graph->as_png("out-grapher.png");
