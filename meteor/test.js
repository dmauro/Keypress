'use strict';

Tinytest.addAsync('Press "k" to pass the test', function (test, done) {
  var listener = new Keypress.Listener();
  listener.simple_combo('k', function() {
    test.ok({message: 'Test passed if you pressed "k"'});
    done();
  });
});
