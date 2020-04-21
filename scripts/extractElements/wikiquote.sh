#!/bin/bash

# Adds inkspace to PATH. MacOS specific.
# This was used with the master-branch of inkscape
export PATH="$PATH:/Applications/Inkscape.app/Contents/MacOS/"

extract_id_with_inkscape() {
	id=$1
	outputFile=$2
	inputFile=$3

	inkscape \
		--vacuum-defs \
		--convert-dpi-method=scale-document \
		--export-id=$id \
		--export-id-only \
		--export-area-snap \
		--export-plain-svg \
		--export-type=svg \
		--export-file=$outputFile \
		$inputFile
}

mkdir -p ./generated-logos
mkdir -p ./generated-logos/wikiquote
mkdir -p ./generated-logos/wikiquote/wordmarks

########################
# Extract Wikiquote logos
#
# Strategy: For each wikiquote logo file,
# use the extractlastElement.js script to return the last element
# in the original file as a string. Copy that string into a new file.
# Use Inkscape to convert it to a "plain" SVG, and use Inkscape again
# to crop the size of the SVG to the content.
########################

for logoFile in ./original-logos/wikiquote/*.svg; do

 	wordmarkFileName=$( basename "$logoFile" | sed -e 's/logo/wordmark/' )
 	wordmarkFilePath="./generated-logos/wikiquote/wordmarks/$wordmarkFileName"

 	svgString=`node ./scripts/extractLastElement.js $logoFile`

 	echo "$svgString" > "$wordmarkFilePath"

 	inkscape \
 		--convert-dpi-method=scale-document \
		--export-plain-svg \
 		--export-overwrite \
 		$wordmarkFilePath & wait

	inkscape \
		--with-gui \
		--batch-process \
		--display=$DISPLAY \
		--export-plain-svg \
		--export-overwrite \
		--verb="FitCanvasToDrawing" \
		$wordmarkFilePath
done
