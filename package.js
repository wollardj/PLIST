Package.describe({
    name: 'wollardj:plist',
    summary: 'JSON-like interface for converting plist strings to javascript objects and back again.',
    version: '1.0.0',
    git: 'https://github.com/wollardj/PLIST.git'
});

Package.onUse(function(api) {
    api.versionsFrom('1.0.2.1');
    api.use([
        'standard-app-packages',
        'coffeescript'
    ]);
    api.addFiles([
        'lib/entities.js',
        'lib/sax.js',
        'lib/plist-parser.coffee',
        'lib/_Plist.coffee',
        'wollardj:plist.coffee'
    ], ['client', 'server']);

    api.export([
        'sax', // not sure why this needs an export...
        'PLIST'
    ], ['client', 'server'])
});
