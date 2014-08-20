#!/bin/bash 
# Bash script to generate Latex script for embedding media
# Author: tckb <chandra.tungathurthi@rwth-aachen.de>
echo "### Bash script to generate Latex script for embedding media onto a pdf ###"

# prepare Latex
preamble_ltx="
%###	Latex source to embedding media on to pdf file		###\n
%###	Author: tckb<chandra.tungathurthi@rwth-aachen.de>	###\n
%###	Created on `date` by gen_latex.sh					###\n

\\documentclass[11pt]{amsart}\n
\\usepackage{geometry}          \n     
\\geometry{landscape}  \n
\\usepackage{lastpage}\n
\\usepackage{fancyhdr}  \n           
\\usepackage{graphicx}\n
\\usepackage{pdfpages}\n
\\usepackage[english]{babel}\n
\\usepackage{media9}\n
\\\\begin{document}\n\n"

close_ltx="\n\n\\end{document}\n"
ltx_data=$preamble_ltx

# Procedure

# Ask for number of pages in the original pdf
echo "Enter the source pdf file:"
read orgin_pdf_source


echo "Enter the number of pages in $orgin_pdf_source :"
read nr_orgin_pdf_source
`
# ask at what pages embedding is needed, seperate by spaces(comma?)
echo "Enter the page numbers where embedding is required (increasing order,space seperated): "
read nr_media_srcs 
media_src_pages=($nr_media_srcs)

page_start=1
curr_page=1
mp_cntr=0
curr_media_page=${media_src_pages[$mp_cntr]}
while [ $curr_page -le $nr_orgin_pdf_source ]; do
	
	if [ $curr_page -eq ${media_src_pages[$mp_cntr]} ]; then
		echo "Enter the media source for page-$curr_page:"
		read media_src
		if  ( $curr_page -eq 1 ) || ($curr_page -eq $nr_orgin_pdf_source) ; then
			ltx_split="\\includepdf[pages={$page_start-$(($curr_page - 1))}]{$orgin_pdf_source}\n
		 	\n % ### Embedding media: $media_src @ page-$curr_page  ###\n"
		 else
		 	ltx_split="% ### Embedding media: $media_src @ page-$curr_page  ###\n"
		fi

		 

		 ltx_audio="\\includepdf[pages={$curr_page},pagecommand={
		 \\\\vspace*{1.5cm} \n 
		 \\\\centering{\n
		 \\includemedia[\nlabel=media-page-$curr_page,\n
		 activate=pagevisible,\n
		 width=\\linewidth, height=10pt,\n
		 addresource=$media_src, \n
		 transparent=true,\n
		 flashvars={autoPlay=false&source=$media_src&loop=false}\n
		 	]{}{APlayer.swf} \n
		 }}]{$orgin_pdf_source}\n
		 % ### ---- ###\n"

		ltx_video="\\includepdf[pages={$curr_page},pagecommand={
			\\\\vspace*{\\\\fill}\n 
			\\\\centering{\n 
			 \\includemedia[\n 
 			label=media-page-$curr_page,\n 
   			 activate=pageopen,\n 
  			width=0.7\paperwidth, height=0.6\paperheight,\n 
  			addresource=$media_src,\n 
 			flashvars={autoPlay=false&src=$media_src&loop=false}\n 
 			]{\\\\fbox{Play}}{StrobeMediaPlayback.swf}\n 
			}}]{$orgin_pdf_source}\n
			% ### ---- ###\n"

		echo "Is this video file ? (Yes - 1 | No /I don't know/ I dont care - X )"
		read isVideo

		if [[ isVideo -eq 1 ]]; then
			ltx_data="$ltx_data$ltx_split$ltx_video"
		else
			echo ">>I'm considering it has an audio"
			ltx_data="$ltx_data$ltx_split$ltx_audio"
		fi

		page_start=$curr_page 
		mp_cntr=$(($mp_cntr +1))
	fi
curr_page=$(($curr_page +1))
done
ltx_split="\\includepdf[pages={$(($page_start +1))-$nr_orgin_pdf_source}]{$orgin_pdf_source}\n"
ltx_data="$ltx_data$ltx_split$close_ltx"
echo "Generating latex source..."
tex_name="gen_latex_src-$RANDOM.tex"

echo -e $ltx_data > $tex_name
echo "...done"
echo "tex file saved at $tex_name"
echo "Opening $tex_name for editing... "
open $tex_name
