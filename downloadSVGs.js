/**
 * The api data is derived from the following query:
 * https://commons.wikimedia.org/w/api.php?action=query&format=json&prop=imageinfo&titles=Wikipedia%2F2.0&generator=images&utf8=1&formatversion=latest&iiprop=url&gimlimit=max&gimcontinue=9961151|Wikipedia-logo-v2-uk.png
 * which pulls all the images from https://commons.wikimedia.org/wiki/Wikipedia/2.0
 */
const data = require("./apiResponse2.json");
const Fs = require('fs')
const Path = require('path')
const Axios = require('axios')

/**
 * Cribbed from https://futurestud.io/tutorials/download-files-images-with-axios-in-node-js
 * @param {} param0
 */
async function downloadImage ({ url, title }) {
	const path = Path.resolve(__dirname, 'images', title)
	const writer = Fs.createWriteStream(path)

	const response = await Axios({
	  url,
	  method: 'GET',
	  responseType: 'stream'
	})

	response.data.pipe(writer)

	return new Promise((resolve, reject) => {
	  writer.on('finish', resolve)
	  writer.on('error', reject)
	})
}

const svgs = data.query.pages.filter( file => /^.*\.(svg|SVG)$/.test(file.title) );
const svgs_urls = svgs.map( svg => { return { url:svg.imageinfo[0].url, title:svg.title } } )

for ( let i=0; i <svgs_urls.length; i++ ) {
	console.log( svgs_urls[i])
	downloadImage( svgs_urls[i] )

}
