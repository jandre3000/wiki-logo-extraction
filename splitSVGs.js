// returns a window with a document and an svg root node
const window = require('svgdom');
const document = window.document
//const SVG = require('svg.js');
const {SVG, registerWindow} = require('@svgdotjs/svg.js')
const fs = require('fs');
const Path = require('path');
const svgFiles = fs.readdirSync( Path.resolve(__dirname, 'images') );

function getSVGFileString( name ) {
	const filePath = Path.resolve(__dirname, 'images', name);
	return fs.readFileSync( filePath ).toString();
}

function createSVGFileString( width, height, content ){
	return `<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
	xmlns="http://www.w3.org/2000/svg"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:cc="http://creativecommons.org/ns#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
	xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
	version="1.1"
	viewBox="0 0 ${width} ${height}">
	${content}
</svg>`;

}

function getSVGElement( canvas, id ) {
	let el = canvas.findOne(id);

	if ( el ) {
		return {
			el: el,
			width: el.width(),
			height: el.height(),
		}
	}
}

registerWindow(window , document);

svgFiles.forEach( file => {
	let padding = 10;
	let canvas = SVG(document.documentElement);

	let svgString = getSVGFileString(file);

	document.documentElement.innerHTML = '';
	canvas.svg(svgString)

	/**
	 * WORDMARK PROCESSING
	 */

	let wordmark = getSVGElement(canvas, '#Wikipedia') || getSVGElement(canvas, '#wikipedia');

	if ( wordmark ) {

		canvas.viewbox( 0,0, wordmark.width + padding * 2, wordmark.height + padding * 2)

		wordmark.el.x(padding);
		wordmark.el.y(padding);

		let newSVGFile = createSVGFileString( wordmark.width + padding * 2, wordmark.height + padding * 2, wordmark.el.svg() );

		fs.writeFileSync(  Path.join(__dirname, 'wordmarks', `wordmark-${file}`), newSVGFile, 'utf8' )
	}

	/**
	 * TAGLINE PROCESSING
	 */

	let tagline = getSVGElement(canvas, '#The_Free_Encyclopedia')
		|| getSVGElement(canvas, '#the_free_encylopedia')
		|| getSVGElement(canvas, '#subline')
		|| getSVGElement(canvas, '#tagline')
		|| getSVGElement(canvas, '#text3378')
		|| getSVGElement(canvas, '#text3379');

	if ( tagline ) {

		canvas.viewbox( 0,0, tagline.width + padding * 2, tagline.height + padding * 2)

		tagline.el.x(padding);
		tagline.el.y(padding);

		let newSVGFile = createSVGFileString( tagline.width + padding * 2, tagline.height + padding * 2, tagline.el.svg() );

		fs.writeFileSync(  Path.join(__dirname, 'taglines', `tagline-${file}`), newSVGFile, 'utf8' )
	}


	/**
	 * NO-GLOBE PROCESSING
	 */

	let globe = canvas.findOne('#wikiglobe');
	let svg = canvas.findOne('svg');
	console.log( file );
	if ( globe ) {
		globe.remove();
		let newSVGFile = createSVGFileString( svg.width(), svg.height(), svg.svg() );
		fs.writeFileSync(  Path.join(__dirname, 'noglobes', `noglobe-${file}`), newSVGFile, 'utf8' )
	}
})
