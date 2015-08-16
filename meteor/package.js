// package metadata file for Meteor.js
'use strict';

var packageName = 'keypress:keypress';  // http://atmospherejs.com/keypress/keypress
var where = 'client';  // where to install: 'client' or 'server'. For both, pass nothing.

var packageJson = JSON.parse(Npm.require("fs").readFileSync('package.json'));

Package.describe({
  name: packageName,
  summary: 'Keypress (official): robust keyboard handling focused on games. Use Keypress, not window.keypress',
  version: packageJson.version,
  git: 'https://github.com/dmauro/Keypress.git'
});

Package.onUse(function (api) {
  api.versionsFrom('METEOR@1.0');
  api.export('Keypress');
  api.addFiles([
    'keypress.js',
    'meteor/export.js'
  ], where
  );
});

Package.onTest(function (api) {
  api.use(packageName, where);
  api.use('tinytest', where);

  api.addFiles('meteor/test.js', where);
});
