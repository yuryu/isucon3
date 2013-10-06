use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/local/lib/perl5";
use lib "$FindBin::Bin/lib";
use File::Basename;

use Isucon3::Worker;

my $worker = Isucon3::Worker->new;
$worker->run;

