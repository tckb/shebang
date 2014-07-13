# 	fileOrg Ver-0.1
#	Author : tckb <tckb.504@gmail.com>
#	License: GNU General Public License v2
#		Copyleft 2009
#	

#!/bin/bash

pic_list=( *.jpg *.png *.gif *.jpeg *.JPEG  *.JPG ) 
video_list=( *.mpg *.avi *.mpeg *.mp4 *.ogv *.flv )
music_list=( *.mp3 *.ogg )
doc_list=( *.doc *.docx *.txt *.pdf *.odt )

pic_dir="$HOME/Pictures" # change as per ur need
video_dir="$HOME/Videos" # change as per ur need
music_dir="$HOME/Music"  # change as per ur need
doc_dir="$HOME/Documents" #change as per ur need
log_file="$HOME/.fileOrg.log"


pic_cntr=0;
vd_cntr=0;
ms_cntr=0;
dc_cntr=0;

echo " ---------------------------------------------" >>$log_file 
echo " 			fileOrg Ver-0.1		    " >>$log_file
echo "		Author: tckb<tckb.504@gmail.com>    " >>$log_file
echo " ---------------------------------------------" >>$log_file

echo ">>Log started @ `date` " >>$log_file
echo " " >>$log_file



echo '----Pictures----' >>$log_file



for a in `ls ${pic_list[@]} 2>/dev/null`
	do
		echo "moving" $a ">>>" $pic_dir/$a  >>$log_file
		`mv "$a" $pic_dir/`
		pic_cntr=`expr $pic_cntr + 1`  
	done

echo ----Videos---- >>$log_file

for a in `ls ${video_list[@]} 2>/dev/null`
        do

                echo "moving" $a ">>>"  $video_dir/$a >>$log_file
                `mv $a $video_dir/`
		 vd_cntr=`expr $vd_cntr + 1`
        done

echo ----Music---- >>$log_file

for a in `ls ${music_list[@]} 2>/dev/null`
        do

                echo "moving" $a " >>>"  $music_dir/$a >>$log_file
                `mv $a $music_dir/`
		 ms_cntr=`expr $ms_cntr + 1`
        done


echo ----Documents---- >>$log_file

for a in `ls ${doc_list[@]} 2>/dev/null`
        do

                echo "moving" $a " >>>"  $doc_dir/$a >>$log_file
                `mv $a $doc_dir/`
		 dc_cntr=`expr $dc_cntr + 1`
        done

total=`expr $pic_cntr + $ms_cntr + $vd_cntr + $dc_cntr`
echo ==== Result ==== >>$log_file

echo No of pics moved : $pic_cntr >>$log_file
echo No of videos moved : $vd_cntr >>$log_file
echo No of music  moved : $ms_cntr >>$log_file
echo No of documents moved : $dc_cntr >>$log_file
echo -------------------------- >>$log_file
echo Total files moved : $total>>$log_file

# /usr/bin/notify-send -t 50 -u low -i info fileOrg "$total files have been moved, Please check the log file"
echo "---- End of Log ----" >>$log_file

if [ $total -ne 0 ] ; then
/usr/bin/notify-send -t 50 -u normal -i info fileOrg-0.1 "$total files have been moved, Please check the log file for more details"
fi

