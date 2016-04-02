Keypress
========
Version 2.1.4

Keypress is a robust keyboard input capturing Javascript utility
focused on input for games. For details and documentation, please
visit [http://dmauro.github.io/Keypress/](http://dmauro.github.io/Keypress/)

If you're using Keypress with Meteor, see the [Meteor notes](meteor/README.md).

Copyright 2016 David Mauro  
released under the Apache License, version 2.0


**What's new**
---------------

2.1.4

* Remove unexpected debugger
* Backup to e.key if there is no e.keyCode. Thanks [kvantetore](https://github.com/kvantetore). [Pull request #107](https://github.com/dmauro/Keypress/pull/107)

2.1.3

* Just fixing the bower JSON. Thanks [OleCordsen](https://github.com/OleCordsen). [Issue #101](https://github.com/dmauro/Keypress/issues/101)

2.1.2

* Added some simple jQuery proofing so you can pass in the result of a jQuery selector into the Listener's constructor. Thanks to [mallocator](https://github.com/mallocator) for the request. [Issue #89](https://github.com/dmauro/Keypress/issues/89)
* Changed the default behavior of how sequence combos behavior. Most people probably would have considered this a bug, so I'm not considering this API breaking. Thanks to [ronnyek](https://github.com/ronnyek) for pointing the problem out in [Issue #68](https://github.com/dmauro/Keypress/issues/68).
* Bower file cleaned up thanks to [kkirsche](https://github.com/kkirsche). [Pull request #97](https://github.com/dmauro/Keypress/pull/97)
* Keys in FF/Gecko - and = fixed thanks to [deanputney](https://github.com/deanputney). [Pull request #95](https://github.com/dmauro/Keypress/pull/95)

2.1.1

* Added [Meteor](https://www.meteor.com/) support. Thanks to [dandv](https://github.com/dandv). [Pull request #63](https://github.com/dmauro/Keypress/pull/63)

2.1.0

* Another fix for unregistering combos using an array of keys
* Added a destroy method to cleanup a listener. Thanks to [smerickson](https://github.com/smerickson) for submitting. [Pull request #51](https://github.com/dmauro/Keypress/pull/51)
* Fixed compatibility for '-'/'_' and '='/'+' keys in FireFox. Thanks to [simonsarris](https://github.com/simonsarris) for spotting the bug. [Issue #50](https://github.com/dmauro/Keypress/issues/50)
* Added [spm support](http://spmjs.io/package/keypress). Thanks to [sorrycc](https://github.com/sorrycc). [Pull request #52](https://github.com/dmauro/Keypress/pull/52)

2.0.3

* Fixed a bug unregistering combos using arrays of keys
* Added ie8 compatibility shim. Thanks to [barrkel](https://github.com/barrkel). [Issue #41](https://github.com/dmauro/Keypress/issues/41)
* Fixed a bug targetting the semicolon key in Firefox. Thanks to [mikekuehn](https://github.com/mikekuehn).
* Added commonJS module support. [Issue #45](https://github.com/dmauro/Keypress/issues/45)

2.0.2

* Fixed a bug that prevented combos from unregistering, and updated the docs for how to unregister properly. Thanks to [pelly](https://github.com/pelly) and [g00fy-](https://github.com/g00fy-). [Issue # 34](https://github.com/dmauro/Keypress/issues/34).
* Added [AMD](http://requirejs.org/docs/whyamd.html) support. [Issue #37](https://github.com/dmauro/Keypress/issues/37).

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
