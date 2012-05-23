#!/usr/bin/perl
package Ksrmod::KsrLib;

	use Exporter;
	@ISA = (Exporter);
	@EXPORT = qw(file_read file_write dir_read
					 lst_dir dir_fl_lst del_cr arr_prt arr_prt_b arr_prt_b_HTML
					 slt_st txt_html for_html get_get chk_hash chk_hash_b ad_spt
					 ad_spt_dot getLocal_time tr_eptime_to_date rnd_str);


######  Eulen-Perlライブラリ Ver0.92  #################################################################
### Document　──　各種サブルーチン（コマンド）
#
# file_read(引数1)
# 	…　引数1（文字列（ファイルアドレス））を配列に読み込んで返す。
#
# file_write(ファイル名, 書き込む内容(配列(リファレンスを渡すので　\@～の形に)))
# 	…　渡されたファイル名で書き込み内容のファイルを生成する。エンコードはUTF-8。
#
# file_write_over(ファイル名, 書き込む内容(配列(リファレンスを渡すので　\@～の形に)))
# 	…　渡されたファイル名を渡された配列内容で上書き。エンコードはUTF-8。
#
# file_write_add(ファイル名, 書き込む内容(文字列)
# 	…　渡されたファイル名に渡された文字列内容を追記する。エンコードはUTF-8。
#
# dir_read(引数1)
# 　…　指定ディレクトリを配列に読み込んで配列形式で返す(.と..を削除する)
#
# lst_dir(引数1)
# 　…　渡されたディレクトリ内の(サブ)ディレクトリ一覧を作成
# 		※：dir_readに依存
#
# dir_fl_lst(引数1)
# 　…　渡されたディレクトリ内のファイル一覧を作成
# 		※：dir_readに依存
#
# del_cr(引数1)
# 	…　引数1（文字列）から改行コードを削除して返す。
#
# arr_prt(引数1)
# 	…　引数1（配列）を標準出力する。主としてデバック用。
#
# arr_prt_b(引数1)
# 	…　引数1（配列）を標準出力する。ただし、各行に改行をつける。主としてデバック用。
#
# arr_prt_b_HTML(引数1)
# 	…　引数1（配列）を標準出力する。ただし、各行にHTML改行タグと改行をつける。
#
# slt_st(引数1,引数2)
# 　…　引数1（文字列）を区切りにして引数2（文字列）を分離し、それを配列にして返す。
#
# txt_html(引数1)
# 　…　引数1（文字列）をHTMLでそのまま表示する為に<pre>タグで囲むだけ。
#
# for_html
# 　…　htmlを出力するときの冒頭宣言部分　ってだけ。
#
# get_get
# 　…　GETメソッドで受け取ったデータを変数名と値に分離してハッシュに格納して返す
# 　　　ただし、環境変数がNullの場合は ハッシュ要素{'err'} に 'NULL'を格納して返す。
# 		※：slt_stに依存
#
# chk_hash(引数1)
# 	…　引数1（ハッシュ）のキー一覧を標準出力する。主としてデバック用。
#
# chk_hash_b(引数1)
# 	…　引数1（ハッシュ）のキー一覧を標準出力する。ただし、各行に改行をつける。主としてデバック用。
#
# ad_spt(引数1)
# 	…　渡された相対パスを/で分離し配列に格納する
# 	※：slt_stに依存
#
# ad_spt_dot(引数1)
# 	…　渡された相対パスを/で分離し、.を除いて配列に格納する
# 	※：slt_stに依存
#
# getLocal_time(引数なし)
#	…　現在の年月日時分秒を取得する（秒分時日月年の順に配列に返す
#
#
# tr_eptime_to_date(引数1)
#	…　渡されたエポック秒を年月日時分秒を取得する（秒分時日月年の順に配列に返す
#
# rnd_str(生成する文字列のバイト数 , 使用する文字の種類)
#	…　渡された文字数でかつ指定された文字を使ったランダムな文字列を返す
#
## EoDocument


#指定ファイルを配列に読み込んで配列形式で返す

sub file_read{
	my ($file) = shift;
	my @readlist = ();
	open my $fh, '<', $file
	  or die "Cannot open '$file': $!";

		flock($fh,2);
		do{
				@readlist = readline $fh;
			}
		until(eof $fh);
		flock($fh,8);
	close($fh);

	return @readlist;
}

#指定ファイル名で渡された配列を各行の内容としてファイルを生成する

sub file_write{
    my ( $f_name,
         $f_value ) = @_;
	if(open(ADFP,">> $f_name")){
		flock(ADFP,2);
			foreach my $tmp (@$f_value){
				print ADFP $tmp . "\n";
			}
		flock(ADFP,8);
	close(ADFP);
	}else{
		print '<br />fopne miss!!<br />';
	}
	return;
}

#指定ファイル名で渡された配列を各行の内容としてファイルを上書きする

sub file_write_over{
    my ( $f_name,
         $f_value ) = @_;
	if(open(ADFP,"> $f_name")){
		flock(ADFP,2);
			foreach my $tmp (@$f_value){
				print ADFP $tmp . "\n";
			}
		flock(ADFP,8);
	close(ADFP);
	}else{
		print '<br />fopne miss!!<br />';
	}
	return;
}

#指定ファイル名で渡された配列を各行の内容としてファイルを追記する

sub file_write_add{
    my ( $f_name,
         $f_value ) = @_;
	if(open(ADFP,">> $f_name")){
		flock(ADFP,2);
				print ADFP $f_value . "\n";
		flock(ADFP,8);
	close(ADFP);
	}else{
		print '<br />fopne miss!!<br />';
	}
	return;
}

# 指定ディレクトリを配列に読み込んで配列形式で返す(.と..を削除する)

sub dir_read{
	my ($dir) = @_;
	my @readlist = ();
	my @tmp_readlist = ();

	opendir DH, $dir or die "$dir:$!";
		do{
			@readlist = readdir DH;
		}until(eof DH);
	closedir DH;

	for(my $i = 0 ; $i < @readlist ; $i++){
		if($readlist[$i] eq '.'){
			splice(@readlist, $i, 1);
		}
		if($readlist[$i] eq '..'){
			splice(@readlist, $i, 1);
		}
	}

	@tmp_readlist = sort @readlist;

	return @tmp_readlist;
}

# 配列を全て表示
sub arr_prt{
	my @tempp = @_;

	foreach(@tempp){
		print $_;
	}
	return;
}
# 配列を全て表示(改行有り
sub arr_prt_b{
	my @tempp = @_;

	foreach(@tempp){
		print $_ . "\n";
	}
	return;
}

# 配列を全て表示(HTML改行有り
sub arr_prt_b_HTML{
	my @tempp = @_;

	foreach(@tempp){
		print $_ . "<br />\n";
	}
	return;
}

# 改行コードの削除
sub del_cr{
	my $temp = $_[0];
		$temp =~ s/\r//;
		$temp =~ s/\n//;
	return $temp;
}

# 文字列を渡された文字列を区切りにして分離
sub slt_st{
	my $spCode = $_[0];
	my $spDat  = $_[1];

		my @TmpAry = split(/$spCode/,"$spDat");

	return @TmpAry;
}

# 文字列をそのままHTMLで表示する為に<pre>タグで囲むだけ
sub txt_html{
	my $tmp = $_[0];
	$tmp = '<pre>' . $tmp . '</pre>';
	return $tmp;
}

# htmlを出力するときの冒頭宣言部分　ってだけ。
sub for_html {
	print "Content-type: text/html\n\n";
	return;
}

# GETメソッドで受け取ったデータを変数名と値に分離してハッシュに格納する
# 	※：slt_stに依存
sub get_get{
	my %temp;
	my @loop_tmp;	#付属する変数を=で分離せずにまとめて配列に格納
	my @spl_val;	#変数名と値に分離するときに使うTmp
	my $env_tmp = $ENV{'QUERY_STRING'};

	if($env_tmp eq ""){
		$temp{'err'} = 'NULL' ;
		return %temp;
	}

	@loop_tmp = split(/&/,"$env_tmp");

	foreach my $loop_tmp (@loop_tmp){
		@spl_val = split(/=/ , $loop_tmp);
		$temp{$spl_val[0]} = $spl_val[1] ;
	}

	return %temp;
}

# ハッシュのキーを一覧表示する
# 	※：arr_prtに依存
sub chk_hash{
	my %temp = @_;
	my @key = keys( %temp );

		&arr_prt(@key);

	return;
}

# ハッシュのキーを一覧表示する
# 	※：arr_prt_bに依存
sub chk_hash_b{
	my %temp = @_;
	my @key = keys( %temp );

		&arr_prt_b(@key);

	return;
}


# 渡されたディレクトリ内の(サブ)ディレクトリ一覧を作成
# 	※：dir_readに依存
sub lst_dir{
	my $tmp_ad = $_[0];
	my @tmp_list = &dir_read($tmp_ad);
	my $tmp_sq_ad;
	my @dir_list = ();
	my @tmp_dir_list = ();

	for(my $i = 0 ; $i < @tmp_list ; $i++){

		$tmp_sq_ad = $tmp_ad . '/' . $tmp_list[$i];

		if(-d $tmp_sq_ad){
			push(@dir_list, $tmp_list[$i]);
		}
	}

	@tmp_dir_list = sort @dir_list;

	return @tmp_dir_list;
}

# 渡されたディレクトリ内のファイル一覧を作成
# 	※：dir_readに依存
sub dir_fl_lst{
	my $tmp_ad = $_[0];
	my @tmp_list = &dir_read($tmp_ad);
	my $tmp_sq_ad;
	my @dir_list = ();
	my @tmp_dir_list = ();

	for(my $i = 0 ; $i < @tmp_list ; $i++){
		$tmp_sq_ad = $tmp_ad . $tmp_list[$i];

		if(-d $tmp_sq_ad){

		}else{
			push(@dir_list, $tmp_list[$i]);
		}
	}

	@tmp_dir_list = sort @dir_list;

	foreach my $tmp_dir_list (@tmp_dir_list){
		$tmp_dir_list = &del_cr($tmp_dir_list);
	}

	return @tmp_dir_list;
}

# 渡された相対パスを/で分離し配列に格納する
# 	※：slt_stに依存
sub ad_spt{
	my $tmp_ad = $_[0];
	my @ad_lst = &slt_st('/',$tmp_ad);

	return @ad_lst;
}

# 渡された相対パスを/で分離し.を除いて配列に格納する
# 	※：slt_stに依存
sub ad_spt_dot{
	my $tmp_ad = $_[0];
	my @ad_lst = &slt_st('/',$tmp_ad);

	for(my $i = 0 ; $i < @ad_lst ; $i++){
		if($ad_lst[$i] eq '.'){
			splice(@ad_lst, $i, 1);
		}
		if($ad_lst[$i] eq '..'){
			splice(@ad_lst, $i, 1);
		}
	}

	return @ad_lst;
}

sub getLocal_time{
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
	    #秒   分    時     日     月    年     曜日   年初か 夏時間を
	    #                                             らの   適用して
	    #                                             経過日 いるか

	$year += 1900; # localtime関数からは1900年から数えた年が返却される。
	$mon++; # 月は0から始まるので、表示するときは1を加える。

	my @tmp = ($sec, $min, $hour, $mday, $mon, $year);
	return @tmp;
}

sub tr_eptime_to_date{
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($_[0]);
	    #秒   分    時     日     月    年     曜日   年初か 夏時間を
	    #                                             らの   適用して
	    #                                             経過日 いるか

	$year += 1900; # localtime関数からは1900年から数えた年が返却される。
	$mon++; # 月は0から始まるので、表示するときは1を加える。

	my @tmp = ($sec, $min, $hour, $mday, $mon, $year);
	return @tmp;
}


sub rnd_str{
	my $str_len = shift;
	my $char_type = shift;

	my @chars = '';
	push @chars, ('a'..'z') if $char_type =~ /a-z/;
	push @chars, ('A'..'Z') if $char_type =~ /A-Z/;
	push @chars, (0..9) if $char_type =~ /0-9/;

	my $rand_str = '';
	$rand_str .= $chars[int(rand($#chars+1))] for (1..$str_len);

	return $rand_str;
}

sub splice_2D {
	my $lrr = shift; 	# リファレンスのリストのリストへのリファレンス!
	my ($x_lo, $x_hi,
		$y_lo, $y_hi) = @_;
	return map {
		[ @{ $lrr->[$_] } [ $y_lo .. $y_hi ] ]
	} $x_lo .. $x_hi;
}

1;