#!/bin/bash
# Bash script to generate latex table stub from csv file
# Author: tckb<chandra.tungathurthi@rwth-aachen.de>
# Usage: ./gen_latex.sh table.csv

# prepare Latex
echo "[ generating tex for table $1 ... "
preamble_ltx="
%###	Author: tckb<chandra.tungathurthi@rwth-aachen.de>	###\n
%###	Created on `date`				###\n

\\documentclass[11pt]{article}\n
\\usepackage[landscape]{geometry}\n
\\usepackage{tabu}\n
\\usepackage{longtable}\n
\\usepackage{array}\n
\\\\renewcommand{\\\\arraystretch}{2}
\\\\newcolumntype{L}[1]{>{\\\\raggedright\\let\\\\newline\\\arraybackslash\\hspace{0pt}}m{#1}}\n
\\\\newcolumntype{C}[1]{>{\\\\centering\\let\\\\newline\\\arraybackslash\\hspace{0pt}}m{#1}}\n
\\\\newcolumntype{R}[1]{>{\\\\raggedleft\\let\\\\newline\\\arraybackslash\\hspace{0pt}}m{#1}}\n
\\\\tabulinesep=1.5mm\n
\\\\begin{document}\n\n"
close_ltx="\n\n\\end{document}\n"
ltx_data=$preamble_ltx
rand=$RANDOM
tex_name=`echo $1 |sed 's/\./_/g'`.tex
table_file=$1

# column information
ltx_data=$ltx_data" \\\\begin{center}\n"
ltx_data=$ltx_data" \\\\begin{table}\n\\\\caption{yourcaption}\n"
ltx_data=$ltx_data" \\\\begin{longtabu}{ |"
c=0
while read  line
do
	echo "[line: $line]"
	# header information
	if [[ $c -eq 0 ]]; then
		 #count number of columns in the file
		nc=`echo $line | awk '{split($0,arr,","); print length(arr)}'`
		echo "[No of cols : $nc]"
		while [[ $c -lt $nc ]]; do
			ltx_data=$ltx_data"L{4cm} |"
			c=`expr c=$c+1`
		done
		ltx_data=$ltx_data"}\n \\hline \\hline \n \\\\rowfont{\\\\bfseries}\n"
	fi
	# col information
	ltx_data=$ltx_data`echo $line | sed 's/,/ \& /g'`"\\\\\\  \\hline\n"
	ltx_data=`echo $ltx_data | sed -e 's#_#\\\\textunderscore#g'`
	#ltx_data=`echo $ltx_data | sed -e 's/#/ /g'`


done < $table_file

ltx_data=$ltx_data$tble_data"\\end{longtabu}\n\\label{tab:yourtable}\n\\\\end{table}\\end{center}\n"$close_ltx

echo -e $ltx_data > $tex_name
echo ".. done ]"
echo "[ tex file saved at $tex_name ]"
echo "[ Tex source ]"
cat $tex_name
echo "[ EOF ]"
echo -e "[ Compliing tex file ]\n" 
xelatex $tex_name 
# remove the junk files
rm *.aux
rm *.log 
echo -e  "\n[ openning pdf file ]" 
open `echo $1 |sed 's/\./_/g'`.pdf




