package Example::Stack;

use Moose;

has stack => (
  traits  => ['Array'],
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
