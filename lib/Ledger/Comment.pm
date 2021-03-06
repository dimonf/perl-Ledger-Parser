package Ledger::Comment;
BEGIN {
  $Ledger::Comment::VERSION = '0.10';
}

use 5.010;
use Log::Any '$log';
use Moo;

# VERSION

has journal => (is => 'rw');
has parent   => (is => 'rw'); 
has line_start => (is => 'rw');
has line_end => (is => 'rw');

sub BUILD {
  my ($self, $args) = @_;
}

sub as_string {
    my ($self) = @_;

    join "",  @{$self->jourinal->get_raw_lines(
	 	line_start => $self->line_start,
		line_end => $self->line_end)};
}

1;
# ABSTRACT: Represent comment or other non-parsable lines


=pod

=head1 NAME

Ledger::Comment - Represent comment or other non-parsable lines

=head1 VERSION

version 0.03

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 journal => OBJ

Pointer to L<Ledger::Journal> object

=head2 parent => OBJ

Pointer to  L<Ledger::Transaction> object. May be undef if comment is not
within a transaction

=head2 line_start => integer

=head2 line_end => integer

=head1 METHODS

=head2 new(...)

=head2 $c->as_string()

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

