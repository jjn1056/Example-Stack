package Example::Stack;

use Moose;

has stack => (
  traits  => ['Array'],
  isa => 'ArrayRef[Int]',
  is => 'bare',
  default => sub { [] },
  handles => {
    push => 'push',
    pop => 'pop',
    sort => ['sort' =>
      sub { $_[0] <=> $_[1] }], },
);

has min_trace => (
  traits  => ['Array'],
  is => 'bare',
  default => sub { [] },
  handles => {
    push_min_trace => 'push',
    pop_min_trace => 'pop',
    min_fast => ['get'=>'-1'], },
);

around push => sub {
  my ($orig, $self, $pushed) = @_;
  if(!defined $self->min_fast ||
    $self->min_fast >= $pushed)
  {
    $self->push_min_trace($pushed);
  }
  return $self->$orig($pushed);
};

around pop => sub {
  my ($orig, $self) = @_;
  my $popped = $self->$orig;
  if($self->min_fast == $popped) {
    $self->pop_min_trace;
  }
  return $popped;
};

sub min_naive { (shift->sort)[0] }

__PACKAGE__->meta->make_immutable;

=head1 NAME

Example::Stack - Trying to write a min function that is fast on a Stack object

=head1 SYNOPSIS

    use Example::Stack;

    my $stack = Example::Stack->new;

    $stack->push($_) for (1,1,10);

    say $stack->pop; # 10
    $stack->push(100);
    say $stack->min; # 1;

=head1 DESCRIPTION

Create a classic stack object which defines an additional method called C<min>
that is a fast lookup of the minimum value in the stack.

=head1 METHODS

This class exposes the following public methods.

=head2 push

Pushes an Integer onto the stack.

=head2 pop

Pops a value of the stack

=head2 min_naive

Each time this method is called we do an ascending sort of ALL the items in
the stack and return the first, which is the smallest value.

=head2 min_fast

Returns the smallest item in the stack by using a system where we track the
smallest number history in a trace log.

=head1 SEE ALSO

The following modules or resources may be of interest.

L<Moose>

=head1 AUTHOR

    John Napiorkowski C<< <jjnapiork@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2012, John Napiorkowski C<< <jjnapiork@cpan.org> >>

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
