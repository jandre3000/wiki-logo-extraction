#!/usr/local/bin/bash

##
# Download logos
##

declare -A projectLogoPages

projectLogoPages[wiki]="Wikipedia/2.0"
projectLogoPages[wikiquote]="Wikiquote"
projectLogoPages[wikinews]="Wikinews"
projectLogoPages[wikibooks]="Wikibooks"
projectLogoPages[wikisource]="Category:SVG_Wikisource_logos"
projectLogoPages[wikiversity]="Category:Official_Wikiversity_logos"
projectLogoPages[wikivoyage]="Category:SVG_Wikivoyage_logos"
projectLogoPages[wiktionary]="Category:SVG_Wiktionary_logos"

for projectName in "${!projectLogoPages[@]}"
do
	mkdir -p ./original-logos/$projectName
	cd ./original-logos/$projectName
	logoListFile="../../api-data/${projectName}-logo-files.txt"

	if [ -s $logoListFile ]; then
		cat $logoListFile | while read logoFile
		do
			# File:Wikibooks logo en.svg > File:Wikibooks_logo_en.svg
			encodedLogoTitle=`echo $logoFile | tr ' ' '_'`
			# File:Wikibooks_logo_en.svg > Wikibooks_logo_en.svg
			logoFilename=${encodedLogoTitle/'File:'/}

			if [ ! -f "$logoFilename" ]; then
				echo "downloading '$encodedLogoTitle' -> ./original-logos/$projectName/$logoFilename"
				curl -LO --silent --fail --url "https://commons.wikimedia.org/wiki/Special:FilePath/$encodedLogoTitle"
				mv $encodedLogoTitle $logoFilename
			fi
		done
	fi
	cd -
done


