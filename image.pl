use 5.010;
use Image::Magick;
use Picture_parse qw/convert_to_2 draw get_pix_gray/;
use Hilditch qw/hilditch/;
use Noisy_rm qw/remove_noisy/;
use strict;
#use warnings;
use Time::HiRes qw/time/;
use Data::Dumper;


open HAND,'>','log.txt' or die $!;
#&hilditch;

&main();
sub main{
	my $image = Image::Magick->new();
	my $x=$image->Read('38.bmp');
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
		my $ref_pixs_2=&convert_to_2($ref_pixs,$key);
		#@$ref_pixs_2=map{ if ($_==1) { 0; } else { if ($_==0) { 1; } } }@$ref_pixs_2;
		&Noisy_rm::remove_noisy($ref_pixs_2,$pic_size{h},$pic_size{w},2,-1);
		#&hilditch($ref_pixs_2,$pic_size{h},$pic_size{w});
		#@$ref_pixs_2=map{ if ($_==1) { 0; } else { if ($_==0) { 1; } } }@$ref_pixs_2;

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

close HAND;
