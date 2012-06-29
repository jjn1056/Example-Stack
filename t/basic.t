use Test::Most;
use Example::Stack;

ok my $stack = Example::Stack->new;

$stack->push($_) for (1,1,10);

is $stack->pop, 10;
is $stack->pop, 1;
is $stack->pop, 1;

$stack->push($_) for (10,1,1);
is $stack->min_naive, 1; # 10,1,1
is $stack->min_fast, 1; # 10,1,1

is $stack->pop, 1;  # 10,1
is $stack->min_naive, 1;
is $stack->min_fast, 1;

is $stack->pop, 1;  # 10
is $stack->min_naive, 10;
is $stack->min_fast, 10;

$stack->push(5); # 10,5 
$stack->push(1); # 10,5,1 
$stack->push(11); # 10,5,1,11
$stack->push(1); # 10,5,1,11,1

is $stack->min_naive, 1;
is $stack->min_fast, 1;
is $stack->pop, 1; # 10,5,1,11
is $stack->min_naive, 1;
is $stack->min_fast, 1;

is $stack->pop, 11; # 10,5,1
is $stack->pop, 1; # 10,5
is $stack->min_naive, 5;
is $stack->min_fast, 5;

done_testing;
