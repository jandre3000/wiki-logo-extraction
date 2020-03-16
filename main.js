const fs = require('fs'),
	Path = require('path'),
	svgFiles = fs.readdirSync( Path.resolve(__dirname, 'images') ),
	jsdom = require("jsdom"),
	{ JSDOM } = jsdom;

function getSVGFileString( name ) {
	const filePath = Path.resolve(__dirname, 'images', name);
	const svgString = fs.readFileSync( filePath ).toString();
	const svgStringWithoutFirstLine = svgString.substring(svgString.indexOf("\n") + 1);
	return svgStringWithoutFirstLine;
}

const dom = new JSDOM();
const body = dom.window.document.body;

svgFiles.forEach( file => {
	const svgString = getSVGFileString(file);

	body.innerHTML = svgString;

	const globe = body.querySelector('#wikiglobe')
	console.log( file );

	if ( globe ) {
		globe.remove();
		fs.writeFileSync(
			Path.join(__dirname, 'noglobes', `noglobe-${file}`),
`<?xml version="1.0" encoding="UTF-8" standalone="no"?>
${body.innerHTML}
`,
		'utf8' )
	}
})
