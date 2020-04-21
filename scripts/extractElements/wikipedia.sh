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

#########################
# Extract Wikipedia logos
#
# Strategy:
#########################

for logoFile in ./original-logos/wiki/*.svg; do

	mkdir -p ./generated-logos/wiki
	mkdir -p ./generated-logos/wiki/wordmarks
	mkdir -p ./generated-logos/wiki/taglines

	wordmarkFileName=$( basename "$logoFile" | sed -e 's/logo/wordmark/' )
	wordmarkFilePath="./generated-logos/wiki/wordmarks/$wordmarkFileName"

	taglineFileName=$( basename "$logoFile" | sed -e 's/logo/tagline/' )
	taglineFilePath="./generated-logos/wiki/taglines/$taglineFileName"

	if [ ! -f "$wordmarkFilePath" ]; then
		if grep -q 'id="Wikipedia"' "$logoFile"; then
			extract_id_with_inkscape "Wikipedia" $wordmarkFilePath $logoFile
		elif grep -q 'id="wikipedia"' "$logoFile"; then
			extract_id_with_inkscape "wikipedia" $wordmarkFilePath $logoFile
		fi
	fi

	if [ ! -f "$taglineFilePath" ]; then
		if grep -q 'id="tagline"' "$logoFile"; then
			extract_id_with_inkscape "tagline" $taglineFilePath $logoFile
		elif grep -q 'id="The_Free_Encyclopedia"' "$logoFile"; then
			extract_id_with_inkscape "The_Free_Encyclopedia" $taglineFilePath $logoFile
		elif grep -q 'id="the_free_encyclopedia"' "$logoFile"; then
			extract_id_with_inkscape "the_free_encyclopedia" $taglineFilePath $logoFile
		fi
	fi
done
