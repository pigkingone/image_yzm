package Picture_parse;
use Exporter;
@ISA=qw/Exporter/;
@EXPORT=qw/convert_to_2 draw get_pix_gray/;

#input: 1.ref_gray,arr of gray. 2.tha
#return: ref of values,whose vlues are betwen 0 and 1
sub convert_to_2 {
	my($ref_gray,$tha)=@_;

	my @pixs_s=map { 
			if ($_>$tha) { 1; }else{0;}
			}  @$ref_gray ;
	return \@pixs_s;
}

#input: 1.image object. 2.arr of pixs. 3.height,width of picture
#return:no
sub draw{
	my($image,$ref_pixs,$h,$w)=@_;
	my $ind=0;
	
	my $ref_black=[0,0,0];
	my $ref_white=[255,255,255];
	for (my $tmp_h = 0; $tmp_h < $h; $tmp_h++) {
		
		for (my $tmp_w = 0; $tmp_w < $w; $tmp_w++) {
			my $ref_color;
			if($ref_pixs->[$ind]==0)
			{
				$ref_color=$ref_black;
			}
			elsif($ref_pixs->[$ind]==1){
				$ref_color=$ref_white;
			}
			else{
				die "err data";
			
			}
			$image->SetPixel(x=>$tmp_w,y=>$tmp_h,color=>$ref_color);
			$ind++;
		}
	}

}


#input: 1.image object. 3.height,width of picture
#return:ref of arr, that value is gray
sub get_pix_gray {
	my ($image,$h,$w)=@_;
	$image->Quantize(colorspace=>'gray');
	my @gray;
	for (my $tmp_h = 0; $tmp_h < $h; $tmp_h++) {
		for (my $tmp_w= 0; $tmp_w<$w; $tmp_w++) {
			my @pixs=$image->GetPixel(channel=>'Gray',x=>$tmp_w,y=>$tmp_h);
			push(@gray,$pixs[0]);
		}
	}
return \@gray;
}
1;
