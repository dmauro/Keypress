Keypress
========
Version 1.0.8

Keypress is a robust keyboard input capturing Javascript utility
focused on input for games. For details and documentation, please
visit [http://dmauro.github.io/Keypress/](http://dmauro.github.io/Keypress/)

Copyright 2013 David Mauro
released under the Apache License, version 2.0


**What's new**
---------------

1.0.8

* Ensure that on_release is called for all combos, not just counting combos.
* Fix bug that was causing is_ordered to be ignored.
* Fixed an edge case for a counting combo's count not being reset.
* Improve how key events are bound

1.0.7

* Fixed combo matching to prevent performance issues as more keys are pressed.

1.0.6

* Fixed a bug with exclusive combos not properly excluding each other in some cases.
* Feature added to allow for combos that do not fire if unrelated keys are also pressed ("is_solitary" boolean).



TODO
----

* Add debugging option to control errors that get logged.
* Improve keypress.combo defaults: this should be geared towards stealing meta+keystroke shortcuts from the browser.
* Make instance based so users can instantiate multiple Keypresses.
* Put negative edge in sequences.
* See if we can do away with keyup_fired and count properties.
