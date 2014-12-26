SAX parser from https://raw.githubusercontent.com/isaacs/sax-js/master/lib/sax.js
plist-parser from https://raw.githubusercontent.com/jacobbudin/plist-parser/master/src/plist-parser.coffee
XMLEntities...
	npm install -g browserify
	git clone https://github.com/mdevils/node-html-entities.git
	browserify node-html-entities/lib/xml-entities.js --standalone XmlEntities -o entities.js
	rm -r node-html-entities
