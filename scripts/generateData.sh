#!/usr/local/bin/bash

##
# Generates a list of logo files available on Commons
# via the API. Files are generated per-project and stored
# in ../original-logos/api/{project}-logo-files.txt
##

declare -A projectLogoPages

projectLogoPages[wikipedia]="Category:SVG_Localized_Wikipedia_globe_logos,_v2"
projectLogoPages[wikiquote]="Category:SVG_Wikiquote_logos"
projectLogoPages[wikinews]="Category:SVG_Wikinews_logos"
projectLogoPages[wikibooks]="Category:SVG_Wikibooks_logos"
projectLogoPages[wikisource]="Category:SVG_Wikisource_logos"
projectLogoPages[wikiversity]="Category:Official_Wikiversity_logos"
projectLogoPages[wikivoyage]="Category:SVG_Wikivoyage_logos"
projectLogoPages[wiktionary]="Category:SVG_Wiktionary_logos"

mkdir -p ./api-data
cd ./api-data

for projectName in "${!projectLogoPages[@]}"
do
	pageTitle=${projectLogoPages[$projectName]}
	responseFile="api-response-${projectName}.json"
	logoListFile="${projectName}-logo-files.txt"

	if [ ! -f $responseFile ]; then
		# TODO: you don't need the generator. Image titles are enough.
		if [[ "$pageTitle" == *Category* ]]; then
			curl --get \
				-d 'action=query' \
				-d 'format=json' \
				-d 'list=categorymembers' \
				-d "cmtitle=$pageTitle" \
				-d 'cmlimit=max' \
				--output $responseFile \
				--url https://commons.wikimedia.org/w/api.php
		else
			curl --get \
				-d 'action=query' \
				-d 'format=json' \
				-d 'prop=imageinfo' \
				-d "titles=$pageTitle" \
				-d 'generator=images' \
				-d 'utf8=1' \
				-d 'formatversion=latest' \
				-d 'iiprop=url' \
				-d 'gimlimit=max' \
				--output $responseFile \
				--url https://commons.wikimedia.org/w/api.php # gimcontinue=9961151|Wikipedia-logo-v2-uk.png
		fi
	fi

	if [ ! -f $logoListFile ]; then
		if [[ $projectName == "wiktionary" ]]; then
			cat $responseFile | tr ',' '\n' | grep -io File:.*.svg | sort | uniq > $logoListFile
		else
			cat $responseFile | tr ',' '\n' | grep -io File:.*.logo.*.svg | sort | uniq > $logoListFile
		fi
	fi

done

cd -
