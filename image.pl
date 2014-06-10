use 5.010;
$n='1a 2ba 3c';
say "@r,$#r,$n" if @r=$n=~/\d/g;
__END__
use 5.010;
use Image::Magick;
use Picture_parse qw/convert_to_2 draw get_pix_gray/;
use Hilditch qw/hilditch/;
use strict;
#use warnings;
use Time::HiRes qw/time/;
use Data::Dumper;


open HAND,'>','log.txt' or die $!;
#&hilditch;

&main();
sub main{
	#my($name,$ref_pix)=@_;
	my $image = Image::Magick->new();
	#my $x=$image->Read('333.PNG');
	#my $x=$image->Read('test.png');
	my $x=$image->Read('38.bmp');
	#my $x=$image->Read('24.bmp');
	warn $x if "$x";
	my $cups = Image::Magick->new();

	my $h=$image->Get('height');
	my $w=$image->Get('columns');
	my %pic_size=(h=>$h,w=>$w);

	my $tmp=$image->Clone();
	$tmp->Quantize(colorspace=>'gray');
	push(@$cups,$image);
	push(@$cups,$tmp);
	my $ref_pixs=&get_pix_gray($tmp,$pic_size{h},$pic_size{w});
	my %hash_tha;
	foreach my $pix (@$ref_pixs) {
		$hash_tha{$pix}=1;
	}

	my $t1=time();
	foreach my $key (sort keys %hash_tha) {
		say "key>$key";
		$tmp=$image->Clone();
		#$tmp->Quantize(colorspace=>'gray');
		my $ref_pixs_2=&convert_to_2($ref_pixs,$key);
		#@$ref_pixs_2=map{ if ($_==1) { 0; } else { if ($_==0) { 1; } } }@$ref_pixs_2;
		&remove_noisy($ref_pixs_2,$pic_size{h},$pic_size{w},3,3);
		#&hilditch($ref_pixs_2,$pic_size{h},$pic_size{w});

		&draw($tmp,$ref_pixs_2,$pic_size{h},$pic_size{w});
		#say HAND "@$ref_pixs_2";

		push(@$cups,$tmp);
		last;
	}

	my $t2=time();
	my $t=$t2-$t1;
	say "$t";

	#my $win=$cups->Montage(geometry=>'128x160+8+4>',border=>'1');
	my $win=$cups->Montage(geometry=>'300+300+4>',border=>'1');
	$win->Write('win:');
}
sub change_times {
	my($ref_row)=@_;


}
sub remove_noisy {
	my($ref_pix,$h,$w,$noisy_h,$noisy_w)=@_;
	
	my $count=0;
	my $times=0;
	my $tmp_y_change=0;
	my $tmp_pix=0;
	for (my $x = 0; $x < $w; $x++) {
		$count=0;
		$times=0;
		$tmp_pix=0;
		for (my $y = 0; $y < $h; $y++) {
			my $pix=$ref_pix->[$y*$w+$x];
			$tmp_y_change=0 if $y==0;
			if($pix==0 && $tmp_y_change==0 ){
				$count++;
			}
			else{
				$count=0;
				$tmp_pix=0;
				next;
			}
			if($count>0 && $count>=$noisy_h && $pix==1 && $tmp_y_change==0)
			{
				for (my $c = $count; $c > 0; $c--) {
					$ref_pix->[($y-$c)*$w+$x]=1;
				}

			}	

		}
		$tmp_y_change=1

	}
}
close HAND;
