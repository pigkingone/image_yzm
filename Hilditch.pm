package Hilditch;
use Exporter;
@ISA=qw/Exporter/;
@EXPORT=qw/hilditch/;

sub hilditch {
	my($ref_pix,$h,$w)=@_;
	#p4 p3 p2
	#p5 p0 p1
	#p6 p7 p8
	my @offset_8=([0,0],[1,0],[1,-1],
		[0,-1],[-1,-1],[-1,0],
		[-1,1],[0,1],[1,1]);

	my $grid_num=9;
	my $grid_ground=$grid_num-1;
	my $boundary=4;
	my ($px,$py,$sum)=(0)x3;
	my @node_4=(1,3,5,7);
	my @b=(0)x9;#3*3 grid for temp pix
	my @condition=(0)x6;#all is 6.   0..5
	my $ind=0;
	my $counter=0;


	do{
		$counter=0;
		for (my $y= 0; $y< $h; $y++) {
			for (my $x= 0; $x<$w; $x++) {

				my @condition=(0)x6;#all is 6.   0..5
				$ind=0;
				@b=(0)x9;
				for ($ind = 0; $ind < $grid_num; $ind++) {
					$px=$x+$offset_8[$ind][0];
					$py=$y+$offset_8[$ind][1];
					$b[$ind]=0;
					if (0<=$px && $w>$px and 0<=$py && $h>$py) {
						$b[$ind]=$ref_pix->[$px+$py*$w];
					}
				}

				# condition 1, must a foreground point
				$condition[0]=1 if 1==$b[0];

				# condition 2,boundary point
				# default,4 point
				$ind=0;
				$sum=0;
				for ($ind = 0; $ind < $boundary; $ind++) {
					$sum+=1-abs($b[$node_4[$ind]]);
				}
				$condition[1]=1 if 1<=$sum;

				# condition 3,endpoint
				# can't delete end point
				$ind=0;
				$sum=0;
				for ($ind = 1; $ind <= $grid_ground; $ind++) {
					$sum += abs($b[$ind]);
				}
				$condition[2]=1 if 2<=$sum;

				# condition 4,if there is only one point,cant delete
				# for example: ... . ...
				$ind=0;
				$sum=0;
				for ($ind = 1; $ind <= $grid_ground; $ind++) {
					$sum++ if $b[$ind]==1;
				}
				$condition[3]=1 if 1<=$sum;

				# condition 5,connection
				$condition[4]=1 if link_8(\@b)==1;


				# condition 5,if the width is '2',we just delete one line of them
				$ind=0;
				$sum=0;
				for ($ind = 1; $ind<= $grid_ground; $ind++) {
					if ($b[$ind] != -1) {
						$sum++;
					}
					else {
						my $copy=$b[$ind];
						$b[$ind]=0;
						$sum++ if link_8(\@b)==1;
						$b[$ind]=$copy;
					}

				}
				$condition[5]=1 if 8==$sum;

				$sum=0;
				$ind=0;
				for ($ind = 0; $ind < 6; $ind++) {
					$sum+=$condition[$ind];
				}
				if ($sum==6) {
					$ref_pix->[$x+$y*$w]=-1;
					$counter++;
				}
			}
		}
		if ($counter!=0) {

			for (my $y= 0; $y< $h; $y++) {

				for (my $x= 0; $x<$w; $x++) {

					$ref_pix->[$x+$y*$w]=0 if $ref_pix->[$x+$y*$w]==-1;

				}
			}

		}
	}while $counter!=0;
}

sub link_8 {

	my($ref_grid)=@_;
	my @data=(0)x10;
	my $data_num=10;
	my $bound_4=4;
	my @node_4=(1,3,5,7);
	my ($ind,$j,$sum)=(0)x3;

	for ($ind = 0; $ind < $data_num; $ind++) {
		$j=$ind;
		$j=1 if $ind==$data_num-1;
		if (1 == abs($ref_grid->[$j])) {
			$data[$ind]=1;
		}
		else {
			$data[$ind]=0;
		}
	}

	$ind=0;
	$j=0;
	for ($ind = 0; $ind < $bound_4; $ind++) {
		$j=$node_4[$ind];
		$sum+=$data[$j]-$data[$j]*$data[$j+1]*$data[$j+2];
	}

	return $sum;
}
