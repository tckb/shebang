#!/bin/bash
# Bash script to generate latex table stub from csv file
# Author: tckb<chandra.tungathurthi@rwth-aachen.de>
# Usage: ./gen_latex.sh table.csv

# prepare Latex
echo "[ generating tex for table $1 ... "
preamble_ltx="
%###	Author: tckb<chandra.tungathurthi@rwth-aachen.de>	###\n
%###	Created on `date` by gen_latex.sh					###\n

\\documentclass[11pt]{article}\n
\\\\begin{document}\n\n"
close_ltx="\n\n\\end{document}\n"
ltx_data=$preamble_ltx
rand=$RANDOM
tex_name="gen_latex_src-$rand.tex"
table_file=$1

# column information
ltx_data=$ltx_data" \\\\begin{center}\n"
ltx_data=$ltx_data" \\\\begin{tabular}{ |"
c=0
while read -r line
do
	# header information
	if [[ $c -eq 0 ]]; then
		 #count number of columns in the file
		nc=`echo $line | awk '{split($0,arr,","); print length(arr)}'`
		while [[ $c -lt $nc ]]; do
			ltx_data=$ltx_data"l |"
			c=`expr c=$c+1`
		done
		ltx_data=$ltx_data"}\n \\hline \\hline \n"
	fi
	# col information
	ltx_data=$ltx_data`echo $line | sed 's/,/ \& /g'`"\\\\\\  \\hline\n"
done < $table_file

ltx_data=$ltx_data$tble_data"\\end{tabular}\n\\end{center}"$close_ltx

echo -e $ltx_data > $tex_name
echo ".. done ]"
echo "[ tex file saved at $tex_name ]"
echo -e "[ Compliing tex file ]\n" 
xelatex $tex_name 
# remove the junk files
rm "gen_latex_src-$rand.aux" "gen_latex_src-$rand.log"
echo -e  "\n[ openning pdf file ]" 
open "gen_latex_src-$rand.pdf"




