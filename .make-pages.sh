#!/bin/bash

SCPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
# SCPT_DIR=/Volumes/Data/Courses/Choice/LectureNotes/AssetPricing/Handouts/EquityPremiumPuzzle/
jobName=EquityPremiumPuzzle

cmd="/bin/bash `kpsewhich tex4htMakeCFG.sh` $jobName"
echo "$cmd"
eval "$cmd"

rpl ',pic-tabular}' '}' *.cfg

econ_ark_theme=/tmp/econ-ark-html-theme
curl https://raw.githubusercontent.com/econ-ark/econ-ark-tools/master/Web/Styling/REMARKs-HTML/econ-ark-html-theme.css -o $econ_ark_theme.css
cp $econ_ark_theme.css page-style.css

cmd="[[ ! -e _config.yml ]] && echo 'theme: jekyll-theme-minimal' > _config.yml" 
echo "$cmd" ; eval "$cmd"

pdflatex $jobName
bibtex $jobName
pdflatex $jobName
pdflatex $jobName

cmd="source ~/.bash_profile ; make4ht --loglevel error --utf8 --config $jobName.cfg --format html5 $(basename $jobName) "'"svg"'"   "'"-cunihtf -utf8"'""

# compiling it with make4ht generates the $jobName.css file
echo "$cmd"
eval "$cmd"
cp $jobName.css $jobName-generated-by-make4ht.css 

# Update style files
css="cat page-style.css | cat - $jobName-generated-by-make4ht.css > $jobName-page-style.css && mv $jobName-page-style.css $jobName.css"

# Replace make4ht-generated css with augmented
eval "$css"
rm -f page-style.css && rm -f $jobName-generated-by-make4ht.css

cp $jobName.html index.html
