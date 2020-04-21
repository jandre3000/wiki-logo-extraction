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
# Extract Wikibooks logos
#
# Strategy:
#########################

for logoFile in ./original-logos/wikibooks/*.svg; do
	mkdir -p ./generated-logos/wikibooks
	mkdir -p ./generated-logos/wikibooks/wordmarks
	mkdir -p ./generated-logos/wikibooks/taglines

	wordmarkFileName=$( basename "$logoFile" | sed -e 's/logo/wordmark/' )
	wordmarkFilePath="./generated-logos/wikibooks/wordmarks/$wordmarkFileName"

	taglineFileName=$( basename "$logoFile" | sed -e 's/logo/tagline/' )
	taglineFilePath="./generated-logos/wikibooks/taglines/$taglineFileName"

	if [[ ! -f "$wordmarkFilePath" ]]; then
		if grep -q 'id="g2700"' "$logoFile"; then
			extract_id_with_inkscape "g2700" $wordmarkFilePath $logoFile
		fi
	fi

	if [[ ! -f "$taglineFilePath" ]]; then
		if grep -q 'id="text2406"' "$logoFile"; then
			extract_id_with_inkscape "text2406" $taglineFilePath $logoFile
		fi
	fi
done
