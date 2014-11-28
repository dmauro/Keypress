'use strict';

Tinytest.add('Instantiation', function (test) {
  var listener = new Keypress.Listener();
  listener.simple_combo('k', function() { alert('Test passed') });

  test.ok({message: 'Test passes if you see an alert when pressing k'});
});
