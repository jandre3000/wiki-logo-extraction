// returns a window with a document and an svg root node
const window = require('svgdom')
const document = window.document
const {SVG, registerWindow} = require('@svgdotjs/svg.js')
const fs = require('fs')
const process = require('process')
const inputFile = process.argv[2]
const file = fs.readFileSync(inputFile, 'utf8')

// register window and document
registerWindow(window , document)

// create canvas
const canvas = SVG(document.documentElement)

canvas.svg( file );

const fileContents = canvas.first();

if ( !fileContents ) {
	return;
}

const lastChildIndex = fileContents.children().length - 1;
const lastChildContent = fileContents.children()[lastChildIndex].svg();

fileContents.clear()
fileContents.svg( lastChildContent )

// remove certain remaining IDs for WikiQuote
fileContents.find( '#g5717').remove()
fileContents.find('#g3164').remove()
fileContents.find('#g846').remove()
fileContents.find('#g2719').remove()

exportContent = fileContents.svg().replace( 'xmlns:svg="http://www.w3.org/2000/svg"', 'xmlns="http://www.w3.org/2000/svg"' )
process.stdout.write(
`<?xml version="1.0" encoding="UTF-8" standalone="no"?>
${exportContent}

`
);
