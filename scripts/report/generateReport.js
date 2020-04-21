
const siteMatrix = require( './siteMatrix.json' );
const tableData = [];
const glob = require( 'glob' );
const fs = require( 'fs' );
const templateFile = fs.readFileSync('./scripts/report/reportTemplate.hbs', 'utf8');
const Handlebars = require( 'handlebars' );
const template = Handlebars.compile( templateFile );

Object
.entries( siteMatrix.sitematrix )
.forEach( entry => {

	if ( !entry[1].site ) {
		return;
	}

	const lang = entry[1].code;

	entry[1].site.forEach( site => {
		if ( site.closed !== true ) {
			if ( !tableData[site.code] ) {
				tableData[site.code] = {};
			}
			tableData[site.code][lang] = { original: false, wordmark: false, tagline: false}
		}
	} )
} )

for ( project in tableData) {

	tableData[project]['totals'] = {
		'originals': 0,
		'wordmarks': 0,
		'taglines': 0
	};

	for ( lang in tableData[project] ) {
		const original = glob.sync( `./original-logos/${project}/*-${lang}.svg` )[0];
		const wordmark = glob.sync( `./generated-logos/${project}/wordmarks/*-${lang}.svg` )[0];
		const tagline = glob.sync( `./generated-logos/${project}/taglines/*-${lang}.svg` )[0];
		if ( project === 'wikiversity' ) {
			console.log( original, lang )
		}
		tableData[project][lang]['original'] = original
		tableData[project][lang]['wordmark'] = wordmark
		tableData[project][lang]['tagline'] = tagline

		tableData[project]['totals']['originals'] += Boolean( original );
		tableData[project]['totals']['wordmarks'] += Boolean( wordmark );
		tableData[project]['totals']['taglines'] += Boolean( tagline );

	}

	tableData[project]['totals']['wordmarksPer'] = parseInt( tableData[project]['totals']['wordmarks'] /  tableData[project]['totals']['originals'] * 100);
	tableData[project]['totals']['taglinesPer'] = parseInt(tableData[project]['totals']['taglines'] /  tableData[project]['totals']['originals'] * 100);

}

const templateOutput = template( tableData );

fs.writeFileSync('./report.html', templateOutput, 'utf8' )
