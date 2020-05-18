#!/usr/local/bin/bash

export PATH="$PATH:/Applications/Inkscape.app/Contents/MacOS/"

mkdir -p ./optimized-logos

# https://askubuntu.com/questions/179898/how-to-round-decimals-using-bc-in-bash
round(){
	echo "$1" | awk '{print ($1-int($1)>0)?int($1)+1:int($1)}'
	#echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
};

##
# optimize files with SVGo
##
for generatedLogoFile in generated-logos/**/**/*.svg; do

	outputFile="$(basename $generatedLogoFile |  tr "[:upper:]" "[:lower:]" | sed -e "s,generated-logos,optimized-logos,"  -e "s,-v2-,-," )"
	outputPath="./optimized-logos/$outputFile"
	canvasWidth=$(inkscape --query-width $generatedLogoFile)
	canvasHeight=$(inkscape --query-height $generatedLogoFile)

	roundedWidth=$(round $canvasWidth)
	roundedHeight=$(round $canvasHeight)

	resizedSVG=$(sed -e "s,width=\"[^\"]*\",width=\"$roundedWidth\","  -e "s,height=\"[^\"]*\",height=\"$roundedHeight\"," -e "s,viewBox=\"[^\"]*\",viewBox=\"0 0 $roundedWidth $roundedHeight\"," $generatedLogoFile)

	echo $resizedSVG | ./node_modules/.bin/svgo --config=.svgo.yml --input=- --output="$outputPath"
done

for handmadeLogoFile in hand-made-logos/**/**/*.svg; do
	outputFile="$(basename $handmadeLogoFile | tr '[:upper:]' '[:lower:]' )"
	outputPath="./optimized-logos/$outputFile"
	./node_modules/.bin/svgo --config=.svgo.yml --input="$handmadeLogoFile" --output="$outputPath"
done
