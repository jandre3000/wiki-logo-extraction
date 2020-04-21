#!/bin/bash

# Adds inkspace to PATH. MacOS specific.
# This was used with the master-branch of inkscap
export PATH="$PATH:/Applications/Inkscape.app/Contents/MacOS/"

mkdir -p ./generated-logos
mkdir -p ./generated-logos/wiktionary
mkdir -p ./generated-logos/wiktionary/wordmarks

extract_id_with_inkscape() {
	id=$1
	outputFile=$2
	inputFile=$3

	inkscape \
		--batch-process \
		--vacuum-defs \
		--convert-dpi-method="scale-viewbox" \
		--export-id=$id \
		--export-id-only \
		--export-area-snap \
		--export-plain-svg \
		--export-type=svg \
		--export-file=$outputFile \
		$inputFile
}

################
# Wiktionary
################

for logoFile in ./original-logos/wiktionary/*.svg; do

	fileContent=`./node_modules/.bin/svgo --pretty --config="./.svgo.pretty.yml" --input="$logoFile" --output=-`

	wordmarkLine=`echo "$fileContent" | grep -m 1 'fill:#4d4d4d;'`
	wordmarkId=`echo $wordmarkLine | grep -o 'id="[^"]*'`
	wordmarkId=${wordmarkId/'id="'/}

	wordmarkFilename=`basename $logoFile |  sed 's/\([A-Z]\)/-\1/g;s/^-//' |  tr '[:upper:]' '[:lower:]'`
	wordmarkFilePath="./generated-logos/wiktionary/wordmarks/$wordmarkFilename"

	if [ $wordmarkId ] && [[ ! -f "$wordmarkFilePath" ]]; then
		extract_id_with_inkscape $wordmarkId $wordmarkFilePath $logoFile
	fi

	taglineLine=`echo "$fileContent" | grep -m 1 'fill:#808080;'`
	taglineId=`echo $taglineLine | grep -o 'id="[^"]*'`
	taglineId=${taglineId/'id="'/}

	taglineFilename=`basename $logoFile |  sed 's/\([A-Z]\)/-\1/g;s/^-//' |  tr '[:upper:]' '[:lower:]'`
	taglineFilePath="./generated-logos/wiktionary/taglines/$taglineFilename"

	if [ $taglineId ] && [[ ! -f "$taglineFilePath" ]]; then
		extract_id_with_inkscape $taglineId $taglineFilePath $logoFile
	fi
done
