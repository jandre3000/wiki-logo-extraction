#!/usr/local/bin/bash

mkdir -p ./frequent-ids
projects=( wikibooks wikinews wiki wikiquote wikisource wikiversity wikivoyage wiktionary )

for projectName in ${projects[*]}; do
	grep -ohr \
		'id=".*"' \
		./original-logos/$projectName/*.svg \
		| sort | uniq -c | sort -r \
		> ./frequent-ids/$projectName-ids.txt
done
