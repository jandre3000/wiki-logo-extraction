#!/bin/bash

# Adds inkspace to PATH. MacOS specific.
# This was used with the master-branch of inkscap
export PATH="$PATH:/Applications/Inkscape.app/Contents/MacOS/"

mkdir -p ./generated-logos
mkdir -p ./generated-logos/wikisource
mkdir -p ./generated-logos/wikisource/wordmarks

################
# Wikisource
################

for logoFile in ./original-logos/wikisource/*.svg; do

	wordmarkFileName=$( basename "$logoFile" | sed -e 's/logo/wordmark/' )
	wordmarkFilePath="./generated-logos/wikisource/wordmarks/$wordmarkFileName"

	inkscape \
		--with-gui  \
		--batch-process \
		--convert-dpi-method=scale-document \
		--select="g2492" \
		--verb="EditDelete;FitCanvasToDrawing;" \
		--export-area-snap \
		--export-plain-svg \
		--export-type=svg \
		--export-file=$wordmarkFilePath \
		$logoFile
done
