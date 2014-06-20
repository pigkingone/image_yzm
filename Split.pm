package Split_pic;
use 5.010;
use Exporter;
@ISA=qw/Exporter/;
@EXPORT=qw/split_by_width/;


sub split_by_width{

	#$ref_pix:	pixels of the pic
	#$char_count:	how much to split?
	#$h,$w:	height,width of the pic
	my($ref_pix,$char_count,$h,$w)=@_;

	my ($char_w,$left_x,$right_x)=(undef,undef,undef);
	

	for (my $x = 0; $x < $w; $x++) {
		for (my $y = 0; $y < $h; $y++) {
			#code
			if ($ref_pix->[$x*$h+$y]==0 && !defined $left_x) {
				$left_x=$x;
			}
		}
	}


	$char_w=int($right_x-$left_x/$char_count);
	

}
