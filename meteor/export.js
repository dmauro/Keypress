/*global Keypress:true*/  // Meteor.js creates a file-scope global for exporting. This comment prevents a potential JSHint warning.
Keypress = window.keypress;
delete window.Keypress;
