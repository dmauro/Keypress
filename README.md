Keypress
========
Version 1.0.6

Keypress is a robust keyboard input capturing Javascript utility
focused on input for games. For details and documentation, please
visit [http://dmauro.github.io/Keypress/](http://dmauro.github.io/Keypress/)

Copyright 2012 David Mauro
released under the Apache License, version 2.0

-----------------------------------------------------------------

**What's new**
---------------

1.0.6

* Fixed a bug with exclusive combos not properly excluding each other in some cases.
* Feature added to allow for combos that do not fire if unrelated keys are also pressed ("is_solitary" boolean).

-----------------------------------------------------------------

TODO
----

* Make ordered combos the default.
* Find a good testing solution.
* Add is_solitary property.
* Put negative edge in sequences.
* Document the "on_release" callback
* Document the "is_solitary" feature
* Improve is_exclusive performance
