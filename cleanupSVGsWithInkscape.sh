#!/bin/bash

export PATH="$PATH:/Applications/Inkscape.app/Contents/MacOS/"

for file in noglobes/*.svg
	do
		newFilePath=./inkscape-processing/$(basename "$file")

		actions="FitCanvasToDrawing; \
		EditSelectAll; \
		SelectionGroup; \
		ObjectRemoveTransform; \
		AlignVerticalTop; \
		SelectionUnGroup; \
		export-type:svg; \
		export-overwrite; \
		export-plain-svg; \
		export-do;"

		echo starting $file
		# upate old files from before Inkscape-0.9.2
		inkscape \
			--convert-dpi-method=scale-document \
			--vacuum-defs \
			--export-plain-svg \
			--export-file=$newFilePath \
		$file &&
		# crop and reposition the image with the inkscape GUI
		inkscape \
			--with-gui \
			--display=$DISPLAY \
			--batch-process \
			--actions="$actions" \
		$newFilePath

		echo finished $newFilePath
done
