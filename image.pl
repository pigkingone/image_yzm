use 5.010;
use strict;
#use warnings;
use Time::HiRes qw/time/;
use Data::Dumper;


use Image::Magick;
use Picture_parse qw/convert_to_2 draw get_pix_gray/;	#get attribute from original Picture to gray or 2-value Picture
use Hilditch qw/hilditch/;  #thin the pic fram
use Noisy_rm qw/remove_noisy_width/; #remove the noise from pic





#==============================main=============================
open HAND,'>','log.txt' or die $!;#for log
&MAIN();
close HAND;#for log




#-------------------------------sub func------------------------
sub MAIN{

	#generate a arry for all of the pic
	my $cups = Image::Magick->new();

	#1.read pic
	#2.put the pic to the arr
	my $image = Image::Magick->new();
	my $x=$image->Read('24.bmp');
	warn $x if "$x";
	push(@$cups,$image);

	#1.get height,width of the image
	#2.put them into %pic_size
	my $h=$image->Get('height');
	my $w=$image->Get('columns');
	my %pic_size=(h=>$h,w=>$w);

	#1.changed to another pic of gray
	#2.put the pic to the arr
	my $tmp=$image->Clone();
	$tmp->Quantize(colorspace=>'gray');
	push(@$cups,$tmp);


	#get pixels from the gray Picture
	my $ref_pixs=&get_pix_gray($tmp,$pic_size{h},$pic_size{w});


	#storage the pixels to hash,for gray values control
	#note: hash{pix}=>1
	#begin{
	my %hash_tha;
	foreach my $pix (@$ref_pixs) {
		$hash_tha{$pix}=1;
	}

	my $t1=time();#start time
	foreach my $key (sort keys %hash_tha) {
		say "key>$key";
		$tmp=$image->Clone();
		my $ref_pixs_2=&convert_to_2($ref_pixs,$key);
		#@$ref_pixs_2=map{ if ($_==1) { 0; } else { if ($_==0) { 1; } } }@$ref_pixs_2;
		&Noisy_rm::remove_noisy_width($ref_pixs_2,$pic_size{h},$pic_size{w},2,-1);
		#&hilditch($ref_pixs_2,$pic_size{h},$pic_size{w});
		#@$ref_pixs_2=map{ if ($_==1) { 0; } else { if ($_==0) { 1; } } }@$ref_pixs_2;

		&draw($tmp,$ref_pixs_2,$pic_size{h},$pic_size{w});
		#say HAND "@$ref_pixs_2";

		push(@$cups,$tmp);
		last;
	}
	#}end

	my $t2=time();#end time
	my $t=$t2-$t1;#lost time
	say "$t";

	#show all of the pic's arry
	#my $win=$cups->Montage(geometry=>'128x160+8+4>',border=>'1');
	my $win=$cups->Montage(geometry=>'300+300+4>',border=>'1');
	$win->Write('win:');
}

