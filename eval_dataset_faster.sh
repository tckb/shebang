#!/bin/bash
#Author: tckb <Chandra.tungathurthi@rwth-aachen.de>
# Parallizing OSRA evaluation using GNU Parallel 
# Usuage ./eval_dataset_faster.sh  [ dataset directory with "images" dir and "sdf" dir]  

eval_dir=$1
checkingJar='/Users/tckb/Projects/Vishal/OSRAChem/dist/OSRAChem.jar'

pass=0
fail=0
unclear=0
total=0

echo "### Parallizing OSRA using PARALLEL"
ls $eval_dir/images/*.tif | parallel --eta --no-notice -j+50  'convert -resize 200% {.}.tif {.}_enh.tif ; osra {.}_enh.tif > {.}.sml;'
echo "### Finished"

rm $eval_dir/images/*_enh.tif

echo "### Comparing SMILE"

for f in  `ls $eval_dir/images/*.sml`
do 
	echo Checking $f ...

	smile=`cat $f`
	#echo $smile
	# echo smile for $f is `cat $f.sm` 
	file=`echo $f | awk '{split($0,array,"/")} END{print array[3]}'`
	sdfFile=$eval_dir/sdf/`echo $file | awk '{split($0,array,".")} END{print array[1]}'`.sdf;
	#echo $sdfFile

	echo Checking...
	java -jar $checkingJar "$smile" $sdfFile 1>$f.res
	res=`cat $f.res`
	#echo "result: "$res
	if [[ $res -eq 1 ]]; then
		pass=`expr $pass + 1`
	else
		if [[ $res -eq 0 ]]; then
			fail=`expr $fail + 1`
		else
			unclear=`expr $unclear + 1`
		fi
	fi
	total=`expr $total + 1`
	echo "## RES pass=$pass fail=$fail unclear=$unclear total=$total"

	rm $f.res
done
echo "### Finished"



