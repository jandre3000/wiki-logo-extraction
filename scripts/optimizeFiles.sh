#!/usr/local/bin/bash

export PATH="$PATH:/Applications/Inkscape.app/Contents/MacOS/"

mkdir -p ./optimized-logos

# https://askubuntu.com/questions/179898/how-to-round-decimals-using-bc-in-bash
round(){
	echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
};

##
# optimize files with SVGo
##
for generatedLogoFile in generated-logos/**/**/*.svg; do

	outputFile="${generatedLogoFile/generated-logos/optimized-logos}"

	canvasWidth=$(inkscape --query-width $generatedLogoFile)
	canvasHeight=$(inkscape --query-height $generatedLogoFile)

	roundedWidth=$(round $canvasWidth 0)
	roundedHeight=$(round $canvasHeight 0)

	resizedSVG=$(sed -e "s,width=\"[^\"]*\",width=\"$roundedWidth\","  -e "s,height=\"[^\"]*\",height=\"$roundedHeight\"," -e "s,viewBox=\"[^\"]*\",viewBox=\"0 0 $roundedWidth $roundedHeight\"," $generatedLogoFile)

	echo $resizedSVG | ./node_modules/.bin/svgo --config=.svgo.yml --input=- --output="$outputFile"
done
