package Noisy_rm;
use 5.010;
use Exporter;
@ISA=qw/Exporter/;
@EXPORT=qw/remove_noisy/;

open HAND,'>','log.txt' or die $!;
sub remove_noisy {
	my($ref_pix,$h,$w,$noisy_h,$noisy_w)=@_;

	my $ref_hash_inds_h;
	my $ref_hash_inds_w;
	if ($noisy_h>0) {
		$ref_hash_inds_h=&remove_noisy_height($ref_pix,$h,$w,$noisy_h);
	}

	if ($noisy_w>0) {
		$ref_hash_inds_w=&remove_noisy_width($ref_pix,$h,$w,$noisy_w)
	}
	
	my @inds;
	foreach my $ind_h (keys %$ref_hash_inds_h) {
		foreach my $ind_w (keys %$ref_hash_inds_w) {
			#say $ind_w
			push @inds,$ind_w
			if $ind_w==$ind_h and $ind_h ne '' and $ind_w ne '';
			$ref_pix->[$ind_w]=1;
		}
			$ref_pix->[$ind_h]=1;

	}

	#foreach my $ind (@inds) {
		#$ref_pix->[$ind]=1;
	#}
}
sub remove_noisy_width{
	my($ref_pix,$h,$w,$noisy_w)=@_;
	my %hash_ind;
	
	my $count=0;
	my $change=0;
	my $last_count=-1;
	for (my $y = 0; $y < $h; $y++) {
		$count=0;
		for (my $x = 0; $x < $w; $x++) {
			my $pix=$ref_pix->[$x*$h+$y];
			$change=0 if $x==0;
			if($pix==0 && $change==0 ){
				$count++;
			}
			else{
				$count=0;
			}
			#say $pix if $pix>0;
			#say HAND "count:$count,noisy_h:$noisy_w,pix:$pix,tmp_y_change:$change";
			if($last_count>0 && $last_count<=$noisy_w&&$pix==1&& $change==0)
			{
				for (my $c = $last_count; $c > 0; $c--) {
					my $ind=($x-$c)*$h+$y;
					#$ref_pix->[$ind]=1;
					$hash_ind{$ind}=1;
					#say HAND "ind>$ind";
					#say HAND "x,y,c>$x,$y,$c";
				}

			}	

			$last_count=$count if $change==0;

		}
		$change=1

	}
	return \%hash_ind;
}
sub remove_noisy_height {
	my($ref_pix,$h,$w,$noisy_h)=@_;
	
	my %hash_ind;
	my $count=0;
	my $tmp_y_change=0;
	my $last_count=-1;
	my $pix=-1;
	my $last_pix=-1;
	for (my $x = 0; $x < $w; $x++) {
		$count=0;
		for (my $y = 0; $y < $h; $y++) {
			$pix=$ref_pix->[$y*$w+$x];
			$tmp_y_change=0 if $y==0;
			if($pix==0 && $tmp_y_change==0 ){
				$count++;
			}
			else{
				$count=0;
			}
			#say $pix if $pix>0;
			#say HAND "count:$count,noisy_h:$noisy_h,pix:$pix,tmp_y_change:$tmp_y_change";
			if($last_count>0 && $last_count<=$noisy_h && $pix==1 && (last_pix==1 || last_pix==-1 || last_pix==-1 || last_pix==1) && $tmp_y_change==0)
			{
				for (my $c = $last_count; $c > 0; $c--) {
					my $ind=($y-$c)*$w+$x;
					#$ref_pix->[$ind]=1;
					$hash_ind{$ind}=1;
					#say HAND "ind>$ind";
					#say HAND "x,y,c>$x,$y,$c";
				}

			}	

			$last_count=$count if $tmp_y_change==0;
			$last_pix=-1;
		}
		$tmp_y_change=1;
		$last_pix=-1;

	}
	return \%hash_ind;
}

close HAND;
1;
