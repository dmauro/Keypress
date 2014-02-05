Keypress
========
Version 2.0.1

Keypress is a robust keyboard input capturing Javascript utility
focused on input for games. For details and documentation, please
visit [http://dmauro.github.io/Keypress/](http://dmauro.github.io/Keypress/)

Copyright 2014 David Mauro
released under the Apache License, version 2.0


**What's new**
---------------

2.0.1

* Fixed a big ole bug with meta/cmd combos. Thanks to [lexey111](https://github.com/lexey111). [Issue #29](https://github.com/dmauro/Keypress/issues/29).
* Fixed a bug with the Windows key being released on Windows systems. [Issue #27](https://github.com/dmauro/Keypress/issues/27).

2.0.0

* Keypress now has a listener class that must be instantiated. The functions that were previously in the global window.keypress object are now public methods of the window.keypress.Listener class.
* Each instance of a Keypress listener can be bound to a DOM element by passing in the element to the listener's constructor.
* Combos now default to being ordered (the property is now called is_unordered and is false by default).
* Combos' handlers preventDefault unless the handler returns true.
* The "combo" public method is now called "simple_combo".
* The basic combo helpers for simple, counting and sequence combos no longer have a third prevent_default optional parameter.
* Debugging console logs can be enabled by setting keypress.debug to true.
* All key event callbacks send a third argument specifying whether the event is firing again automatically because the key has remained pressed down.

1.0.9

* Fix escape key bug. Issue #17.
* Fix unregister bug. Issue #24.

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

* Put negative edge in sequences.
* See if we can do away with keyup_fired and count properties.
