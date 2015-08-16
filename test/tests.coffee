describe "Keypress:", ->
    SHIFT = false

    listener = null

    beforeEach ->
        listener = new window.keypress.Listener()

    convert_readable_key_to_keycode = (keyname) ->
        for keycode, name of window.keypress._keycode_dictionary
            return keycode if name is keyname
        return

    event_for_key = (key) ->
        event = {}
        event.preventDefault = ->
            return
        event.shiftKey = SHIFT
        spyOn event, "preventDefault"
        key_code = convert_readable_key_to_keycode key
        event.keyCode = key_code
        return event

    on_keydown = (key) ->
        if key is "shift"
            SHIFT = true
        event = event_for_key key
        event.metaKey = "meta" in listener._keys_down or listener.get_meta_key() in listener._keys_down
        listener._receive_input event, true
        listener._bug_catcher event
        return event

    on_keyup = (key) ->
        if key is "shift"
            SHIFT = false
        event = event_for_key key
        listener._receive_input event, false
        return event

    press_key = (key) ->
        on_keydown key
        on_keyup key

    describe "A simple single key basic combo", ->
        afterEach ->
            listener.reset()

        it "just works", ->
            foo = 0
            listener.simple_combo ["a"], ->
                foo = 1
            press_key "a"
            expect(foo).toEqual(1)

        it "defaults to not preventing default", ->
            listener.simple_combo "a", null
            event = on_keydown "a"
            on_keyup "a"
            expect(event.preventDefault).not.toHaveBeenCalled()

        it "will prevent default keydown if we have an on_keydown function that doesn't return true", ->
            listener.simple_combo "a", ->
                return
            event = on_keydown "a"
            on_keyup "a"
            expect(event.preventDefault).toHaveBeenCalled()

        it "will not prevent default keydown if we have an on_keydown function that does return true", ->
            listener.simple_combo "a", ->
                return true
            event = on_keydown "a"
            on_keyup "a"
            expect(event.preventDefault).not.toHaveBeenCalled()

        it "will only prevent for the final event by default if we don't return true", ->
            listener.simple_combo "a b", ->
                return
            event = on_keydown "a"
            expect(event.preventDefault).not.toHaveBeenCalled()
            event = on_keydown "b"
            expect(event.preventDefault).toHaveBeenCalled()
            on_keyup "a"
            on_keyup "b"

    describe "Shift key helpers", ->
        key_handler = null
        beforeEach ->
            key_handler = jasmine.createSpy()
        afterEach ->
            listener.reset()

        it "evaluates keys as shifted to match combos", ->
            listener.simple_combo "!", key_handler
            on_keydown "shift"
            on_keydown "1"
            expect(key_handler).toHaveBeenCalled()
            on_keyup "shift"
            on_keyup "1"

        it "still fires the correct keyup even if you let off shift first", ->
            listener.register_combo(
                keys        : "a !"
                on_keydown  : key_handler
                on_keyup    : key_handler
            )
            on_keydown "shift"
            on_keydown "a"
            on_keydown "1"
            expect(key_handler).toHaveBeenCalled()
            on_keyup "shift"
            expect(key_handler.calls.length).toEqual(1)
            on_keyup "1"
            on_keyup "a"
            expect(key_handler.calls.length).toEqual(2)

    describe "Bug catcher", ->
        key_handler = null
        beforeEach ->
            key_handler = jasmine.createSpy()
        afterEach ->
            listener.reset()

        it "forces keyup on keys when cmd is held down", ->
            listener.register_combo(
                keys        : "cmd v"
                on_keydown  : key_handler
                on_keyup    : key_handler
            )
            on_keydown "cmd"
            on_keydown "v"
            expect(key_handler.calls.length).toEqual(2)
            on_keyup "v"
            on_keyup "cmd"

    describe "Keyup events with no relevant keydown event", ->
        key_handler = null
        beforeEach ->
            key_handler = jasmine.createSpy()
        afterEach ->
            listener.reset()

        it "won't fire the keyup when we alt-tab/cmd-tab in", ->
            listener.register_combo(
                keys        : "cmd"
                on_keyup    : key_handler
            )
            listener.register_combo(
                keys        : "alt"
                on_keyup    : key_handler
            )
            on_keyup "cmd"
            expect(key_handler).not.toHaveBeenCalled()
            on_keyup "alt"
            expect(key_handler).not.toHaveBeenCalled()

    describe "Explicit combo options", ->
        key_handler = null
        beforeEach ->
            key_handler = jasmine.createSpy()
        afterEach ->
            listener.reset()

        describe "keys", ->

            it "can take an array", ->
                listener.register_combo(
                    keys        : ["a"]
                    on_keydown  : key_handler
                )
                press_key "a"
                expect(key_handler).toHaveBeenCalled()

            it "can take a string", ->
                listener.register_combo(
                    keys        : "a"
                    on_keydown  : key_handler
                )
                press_key "a"
                expect(key_handler).toHaveBeenCalled()

        describe "on_keydown", ->

            it "receives the event and combo count as arguments", ->
                received_event = null
                listener.simple_combo "a", (event, count) ->
                    expect(count).toEqual(0)
                    received_event = event
                down_event = on_keydown "a"
                on_keyup "a"
                expect(received_event).toEqual(down_event)

            it "only fires when all of the keys have been pressed", ->
                listener.simple_combo "a b c", key_handler
                on_keydown "a"
                expect(key_handler).not.toHaveBeenCalled()
                on_keydown "b"
                expect(key_handler).not.toHaveBeenCalled()
                on_keydown "c"
                expect(key_handler).toHaveBeenCalled()
                on_keyup "a"
                on_keyup "b"
                on_keyup "c"

            it "will fire each time the final key is pressed", ->
                foo = 0
                listener.simple_combo "a b", ->
                    foo += 1
                on_keydown "a"
                on_keydown "b"
                on_keyup "b"
                on_keydown "b"
                expect(foo).toEqual(2)
                on_keyup "b"
                on_keyup "a"

            it "properly receives is_autorepeat", ->
                did_repeat = false
                listener.simple_combo "a", (event, count, is_autorepeat) ->
                    did_repeat = is_autorepeat
                on_keydown "a"
                expect(did_repeat).toBe(false)
                on_keydown "a"
                expect(did_repeat).toBe(true)
                on_keydown "a"
                expect(did_repeat).toBe(true)
                on_keyup "a"

        describe "on_keyup", ->

            it "fires properly", ->
                listener.register_combo(
                    keys        : "a"
                    on_keyup    : key_handler
                )
                press_key "a"
                expect(key_handler).toHaveBeenCalled()

            it "receives the event as its argument", ->
                received_event = null
                listener.register_combo(
                    keys        : "a"
                    on_keyup    : (event) ->
                        received_event = event
                )
                on_keydown "a"
                up_event = on_keyup "a"
                expect(received_event).toEqual(up_event)

            it "fires only after all keys are down and the first has been released", ->
                listener.register_combo(
                    keys        : "a b c"
                    on_keyup    : key_handler
                )
                on_keydown "a"
                on_keydown "b"
                on_keydown "c"
                expect(key_handler).not.toHaveBeenCalled()
                on_keyup "b"
                expect(key_handler).toHaveBeenCalled()
                on_keyup "c"
                expect(key_handler.calls.length).toEqual(1)
                on_keyup "a"
                expect(key_handler.calls.length).toEqual(1)

        describe "on_release", ->

            it "only fires after all of the keys have been released", ->
                listener.register_combo(
                    keys        : "a b c"
                    on_release  : key_handler
                )
                on_keydown "a"
                on_keydown "b"
                on_keydown "c"
                expect(key_handler).not.toHaveBeenCalled()
                on_keyup "b"
                expect(key_handler).not.toHaveBeenCalled()
                on_keyup "c"
                expect(key_handler).not.toHaveBeenCalled()
                on_keyup "a"
                expect(key_handler).toHaveBeenCalled()

        describe "this keyword", ->

            it "defaults to window", ->
                listener.simple_combo "a", ->
                    expect(this).toEqual(window)
                press_key "a"

            it "can be set to any arbitrary scope", ->
                my_scope = {}
                listener.register_combo(
                    keys        : "a"
                    this        : my_scope
                    on_keydown  : ->
                        expect(this).toEqual(my_scope)
                )
                press_key "a"

        describe "prevent_default", ->

            it "manual: only prevents on the key that activated the handler", ->
                listener.register_combo(
                    keys        : "a b c"
                    on_keydown  : (event) ->
                        event.preventDefault()
                    on_keyup    : (event) ->
                        event.preventDefault()
                    on_release  : (event) ->
                        event.preventDefault()
                )

                a_down_event = on_keydown "a"
                expect(a_down_event.preventDefault).not.toHaveBeenCalled()
                b_down_event = on_keydown "b"
                expect(b_down_event.preventDefault).not.toHaveBeenCalled()
                c_down_event = on_keydown "c"
                expect(c_down_event.preventDefault).toHaveBeenCalled()
                a_up_event = on_keyup "a"
                expect(a_up_event.preventDefault).toHaveBeenCalled()
                b_up_event = on_keyup "b"
                expect(b_up_event.preventDefault).not.toHaveBeenCalled()
                c_up_event = on_keyup "c"
                expect(c_up_event.preventDefault).toHaveBeenCalled()

            it "return any non-true value: only prevents the key that activated the handler", ->
                listener.register_combo(
                    keys        : "a b c"
                    on_keydown  : (event) ->
                        return false
                    on_keyup    : (event) ->
                        return false
                    on_release  : (event) ->
                        return false
                )

                a_down_event = on_keydown "a"
                expect(a_down_event.preventDefault).not.toHaveBeenCalled()
                b_down_event = on_keydown "b"
                expect(b_down_event.preventDefault).not.toHaveBeenCalled()
                c_down_event = on_keydown "c"
                expect(c_down_event.preventDefault).toHaveBeenCalled() # on_keydown
                a_up_event = on_keyup "a"
                expect(a_up_event.preventDefault).toHaveBeenCalled() # on_keyup
                b_up_event = on_keyup "b"
                expect(b_up_event.preventDefault).not.toHaveBeenCalled()
                c_up_event = on_keyup "c"
                expect(c_up_event.preventDefault).toHaveBeenCalled() # on_release

            it "property: prevents on all events related and only those related", ->
                listener.register_combo(
                    keys            : "a b c"
                    prevent_default : true
                    on_keydown      : ->
                    on_keyup        : ->
                    on_release      : ->
                )

                a_down_event = on_keydown "a"
                expect(a_down_event.preventDefault).toHaveBeenCalled()
                b_down_event = on_keydown "b"
                expect(b_down_event.preventDefault).toHaveBeenCalled()
                x_down_event = on_keydown "x"
                expect(x_down_event.preventDefault).not.toHaveBeenCalled()
                c_down_event = on_keydown "c"
                expect(c_down_event.preventDefault).toHaveBeenCalled()
                a_up_event = on_keyup "a"
                x_up_event = on_keyup "x"
                b_up_event = on_keyup "b"
                c_up_event = on_keyup "c"
                expect(a_up_event.preventDefault).toHaveBeenCalled()
                expect(x_up_event.preventDefault).not.toHaveBeenCalled()
                expect(b_up_event.preventDefault).toHaveBeenCalled()
                expect(c_up_event.preventDefault).toHaveBeenCalled()

        describe "prevent_repeat", ->

            it "allows multiple firings of the keydown event by default", ->
                listener.simple_combo "a", key_handler
                on_keydown "a"
                on_keydown "a"
                expect(key_handler.calls.length).toEqual(2)
                on_keyup "a"

            it "only fires the first time it is pressed down when true", ->
                listener.register_combo(
                    keys            : "a"
                    on_keydown      : key_handler
                    prevent_repeat  : true
                )
                on_keydown "a"
                on_keydown "a"
                expect(key_handler.calls.length).toEqual(1)
                on_keyup "a"

        describe "is_unordered", ->

            it "forces the order described by default", ->
                listener.register_combo(
                    keys        : "a b"
                    on_keydown  : key_handler
                )
                on_keydown "b"
                on_keydown "a"
                on_keyup "b"
                on_keyup "a"
                expect(key_handler).not.toHaveBeenCalled()
                on_keydown "a"
                on_keydown "b"
                on_keyup "a"
                on_keyup "b"
                expect(key_handler).toHaveBeenCalled()

            it "allows a user to press the keys in any order when is_unordered", ->
                listener.register_combo(
                    keys            : "a b"
                    on_keydown      : key_handler
                    is_unordered    : true
                )
                on_keydown "b"
                on_keydown "a"
                on_keyup "b"
                on_keyup "a"
                expect(key_handler).toHaveBeenCalled()

        describe "is_counting", ->

            it "calls the keydown handler with the count", ->
                last_count = 0
                listener.register_combo(
                    keys        : "tab x space"
                    is_counting : true
                    on_keydown  : (event, count) ->
                        last_count = count
                )
                on_keydown "tab"
                on_keydown "x"
                on_keydown "space"
                expect(last_count).toEqual(1)
                on_keyup "space"
                on_keydown "space"
                expect(last_count).toEqual(2)
                on_keyup "space"
                on_keyup "x"
                on_keyup "tab"

            it "does not increment count on keyup if we have keydown handler", ->
                last_count = 0
                listener.register_combo(
                    keys        : "tab space"
                    is_counting : true
                    on_keydown  : (event, count) ->
                        last_count = count
                    on_keyup    : (event, count) ->
                        last_count = count
                )
                on_keydown "tab"
                on_keydown "space"
                expect(last_count).toEqual(1)
                on_keyup "space"
                expect(last_count).toEqual(1)
                on_keyup "tab"

            it "resets the count even if the combo gets dropped", ->
                last_count = 0
                listener.register_combo(
                    keys        : "tab space"
                    is_counting : true
                    on_keydown  : (event, count) ->
                        last_count = count
                )
                listener.register_combo(
                    keys        : "tab space a"
                    on_keydown  : key_handler
                )
                on_keydown "tab"
                on_keydown "space"
                expect(last_count).toEqual(1)
                on_keydown "a"
                expect(key_handler).toHaveBeenCalled()
                on_keyup "a"
                on_keyup "space"
                on_keyup "tab"
                on_keydown "tab"
                on_keydown "space"
                expect(last_count).toEqual(1)
                on_keyup "space"
                on_keyup "tab"

        describe "is_sequence", ->

            it "properly registers a sequence", ->
                listener.register_combo(
                    keys        : "h i"
                    is_sequence : true
                    on_keydown  : key_handler
                )
                press_key "h"
                press_key "i"
                expect(key_handler).toHaveBeenCalled()

            it "only calls the keydown handler after the last key has been pressed", ->
                listener.register_combo(
                    keys        : "h i"
                    is_sequence : true
                    on_keydown  : key_handler
                )
                press_key "h"
                expect(key_handler).not.toHaveBeenCalled()
                press_key "i"
                expect(key_handler).toHaveBeenCalled()

            it "only calls the keyup handler after the last key has been released", ->
                listener.register_combo(
                    keys        : "h i"
                    is_sequence : true
                    on_keyup    : key_handler
                )
                press_key "h"
                expect(key_handler).not.toHaveBeenCalled()
                press_key "i"
                expect(key_handler).toHaveBeenCalled()

            it "completely ignores the on_release block", ->
                listener.register_combo(
                    keys        : "h i"
                    is_sequence : true
                    on_release  : key_handler
                )
                press_key "h"
                expect(key_handler).not.toHaveBeenCalled()
                press_key "i"
                expect(key_handler).not.toHaveBeenCalled()

            it "works with the prevent_default property", ->
                listener.register_combo(
                    keys            : "h i t"
                    is_sequence     : true
                    prevent_default : true
                    on_keydown      : key_handler
                )
                h_keydown = on_keydown "h"
                on_keyup "h"
                i_keydown = on_keydown "i"
                on_keyup "i"
                t_keydown = on_keydown "t"
                on_keyup "t"
                expect(key_handler).toHaveBeenCalled()
                expect(h_keydown.preventDefault).toHaveBeenCalled()
                expect(i_keydown.preventDefault).toHaveBeenCalled()
                expect(t_keydown.preventDefault).toHaveBeenCalled()

            it "will trigger overlapping sequences which are not exclusive", ->
                listener.register_combo(
                    keys        : "h i"
                    is_sequence : true
                    on_keydown  : key_handler
                )
                listener.register_combo(
                    keys            : "h i t"
                    is_sequence     : true
                    on_keydown      : key_handler
                )
                press_key "h"
                press_key "i"
                press_key "t"
                expect(key_handler.calls.length).toEqual(2)

            it "will not trigger overlapping exclusive sequences", ->
                listener.register_combo(
                    keys            : "h i"
                    is_sequence     : true
                    is_exclusive    : true
                    on_keydown      : key_handler
                )
                listener.register_combo(
                    keys            : "h i t"
                    is_sequence     : true
                    is_exclusive    : true
                    on_keydown      : key_handler
                )
                press_key "h"
                press_key "i"
                press_key "t"
                expect(key_handler.calls.length).toEqual(1)

            it "clears out sequence keys after matching an exclusive combo", ->
                listener.register_combo(
                    keys            : "h i"
                    is_sequence     : true
                    is_exclusive    : true
                    on_keydown      : key_handler
                )
                press_key "h"
                press_key "i"
                expect(listener._sequence.length).toEqual(0)

            it "does not clears out sequence keys for non-exclusives", ->
                listener.register_combo(
                    keys        : "h i"
                    is_sequence : true
                    on_keydown  : key_handler
                )
                press_key "h"
                press_key "i"
                expect(listener._sequence.length).toEqual(2)

            it "will default sequences to exclusive", ->
                combo = listener.sequence_combo("h i")
                expect(combo.is_exclusive).toBe(true)

        describe "is_exclusive", ->

            it "will fire all combos by default", ->
                listener.register_combo(
                    keys            : "a b"
                    on_keydown      : key_handler
                )
                listener.register_combo(
                    keys            : "a b c"
                    on_keydown      : key_handler
                )
                on_keydown "a"
                on_keydown "b"
                on_keydown "c"
                expect(key_handler.calls.length).toEqual(2)
                on_keyup "a"
                on_keyup "b"
                on_keyup "c"

            it "will not fire keydown for a less specific combo", ->
                fired = null
                listener.register_combo(
                    keys            : "a b"
                    is_exclusive    : true
                    on_keydown      : ->
                        fired = "smaller"
                        key_handler()
                )
                listener.register_combo(
                    keys            : "a b c"
                    is_exclusive    : true
                    on_keydown      : ->
                        fired = "bigger"
                        key_handler()
                )
                on_keydown "a"
                on_keydown "b"
                on_keydown "c"
                expect(key_handler.calls.length).toEqual(1)
                expect(fired).toEqual("bigger")
                on_keyup "a"
                on_keyup "b"
                on_keyup "c"

            it "will not fire keyup for a less specific combo", ->
                fired = null
                listener.register_combo(
                    keys            : "a b"
                    is_exclusive    : true
                    on_keyup        : ->
                        fired = "smaller"
                        key_handler()
                )
                listener.register_combo(
                    keys            : "a b c"
                    is_exclusive    : true
                    on_keyup        : ->
                        fired = "bigger"
                        key_handler()
                )
                on_keydown "a"
                on_keydown "b"
                on_keydown "c"
                on_keyup "c"
                on_keyup "b"
                on_keyup "a"
                expect(key_handler.calls.length).toEqual(1)
                expect(fired).toEqual("bigger")

            it "will fire a less specific combo if the bigger did NOT fire", ->
                fired = null
                listener.register_combo(
                    keys            : "a b"
                    is_exclusive    : true
                    on_keyup        : ->
                        fired = "smaller"
                        key_handler()
                )
                listener.register_combo(
                    keys            : "a b c"
                    is_exclusive    : true
                    on_keyup        : ->
                        fired = "bigger"
                        key_handler()
                )
                on_keydown "a"
                on_keydown "b"
                on_keyup "b"
                on_keyup "a"
                expect(key_handler.calls.length).toEqual(1)
                expect(fired).toEqual("smaller")

        describe "is_solitary", ->

            it "will not fire the combo if additional keys are pressed", ->
                listener.register_combo(
                    keys        : "a b"
                    is_solitary : true
                    on_keydown  : key_handler
                    on_keyup    : key_handler
                    on_release  : key_handler
                )
                on_keydown "a"
                on_keydown "x"
                on_keydown "b"
                on_keyup "a"
                on_keyup "x"
                on_keyup "b"
                expect(key_handler).not.toHaveBeenCalled()

            it "will not fire up if down was not fired", ->
                listener.register_combo(
                    keys        : "a b"
                    is_solitary : true
                    on_keydown  : key_handler
                    on_keyup    : key_handler
                    on_release  : key_handler
                )
                on_keydown "a"
                on_keydown "x"
                on_keydown "b"
                on_keyup "x"
                on_keyup "a"
                on_keyup "b"
                expect(key_handler).not.toHaveBeenCalled()


    describe "Keyboard Shortcuts", ->
        afterEach ->
            listener.reset()

        describe "Escape", ->
            it "works with 'escape' and 'esc'", ->
                count = 0
                handler = ->
                    count += 1
                listener.register_combo(
                    keys        : "escape"
                    on_keydown  : handler     
                )
                on_keydown "esc"
                expect(count).toEqual(1)
                listener.unregister_combo("esc")
                expect(listener.get_registered_combos().length).toEqual(0)
                listener.register_combo(
                    keys        : "esc"
                    on_keydown  : handler
                )
                on_keydown "esc"
                expect(count).toEqual(2)


describe "Keypress Functional components:", ->
    listener = null

    beforeEach ->
        listener = new window.keypress.Listener()

    afterEach ->
        listener.reset()

    describe "_is_array_in_array_sorted", ->

        it "case 1", ->
            result = window.keypress._is_array_in_array_sorted ["a", "b"], ["a", "b", "c"] 
            expect(result).toBe(true)

        it "case 2", ->
            result = window.keypress._is_array_in_array_sorted ["a", "b", "c"], ["a", "b"] 
            expect(result).toBe(false)

        it "case 3", ->
            result = window.keypress._is_array_in_array_sorted ["a", "b"], ["a", "x", "b"]
            expect(result).toBe(true)

        it "case 4", ->
            result = window.keypress._is_array_in_array_sorted ["b", "a"], ["a", "x", "b"]
            expect(result).toBe(false)

    describe "_fuzzy_match_combo_arrays", ->

        it "properly matches even with something else in the array", ->
            listener.register_combo(
                keys        : "a b"
            )
            foo = 0
            listener._fuzzy_match_combo_arrays ["a", "x", "b"], ->
                foo += 1
            expect(foo).toEqual(1)

        it "won't match a sorted combo that isn't in the same order", ->
            listener.register_combo(
                keys            : "a b"
                is_unordered    : false
            )
            foo = 0
            listener._fuzzy_match_combo_arrays ["b", "x", "a"], ->
                foo += 1
            expect(foo).toEqual(0)

        it "will match a sorted combo that is in the correct order", ->
            listener.register_combo(
                keys            : "a b"
                is_unordered    : false
            )
            foo = 0
            listener._fuzzy_match_combo_arrays ["a", "x", "b"], ->
                foo += 1
            expect(foo).toEqual(1)

describe "APIs behave as expected:", ->
    listener = null

    beforeEach ->
        listener = new window.keypress.Listener()

    afterEach ->
        listener.reset()

    describe "unregister_many", ->
        it "unregisters the combos registered by register_many", () ->
            combos1 = [ {
                keys : "shift s",
            }, {
                keys : "shift r",
            }]
            combos2 = [ {
                keys : "alt s"
            }, {
                keys : "alt r"
            }]

            registered1 = listener.register_many(combos1)
            registered2 = listener.register_many(combos2)
            expect(listener.get_registered_combos().length).toEqual(4)
            listener.unregister_many(registered2)
            expect(listener.get_registered_combos().length).toEqual(2)
            expect(listener.get_registered_combos()[0].keys).toEqual(["shift", "s"])
            expect(listener.get_registered_combos()[1].keys).toEqual(["shift", "r"])



    describe "unregister_combo", ->

        it "unregisters string", ->
            listener.register_combo(
                keys : "shift s"
            )
            count = listener.get_registered_combos().length
            expect(count).toEqual(1)
            listener.unregister_combo("shift s")
            count = listener.get_registered_combos().length
            expect(count).toEqual(0)

        it "unregisters array", ->
            listener.register_combo(
                keys : "shift s"
            )
            count = listener.get_registered_combos().length
            expect(count).toEqual(1)
            listener.unregister_combo(["shift", "s"])
            count = listener.get_registered_combos().length
            expect(count).toEqual(0)

        it "unregisters array out of order", ->
            listener.register_combo(
                keys            : "shift s"
                is_unordered    : true
            )
            count = listener.get_registered_combos().length
            expect(count).toEqual(1)
            listener.unregister_combo(["s", "shift"])
            count = listener.get_registered_combos().length
            expect(count).toEqual(0)

        it "does not unregister if the combo is ordered and not unregistered with the same ordering", ->
            listener.register_combo(
                keys            : "shift s"
                is_unordered    : false
            )
            count = listener.get_registered_combos().length
            expect(count).toEqual(1)
            listener.unregister_combo("s shift")
            count = listener.get_registered_combos().length
            expect(count).toEqual(1)

        it "unregisters if the combo is unordered and not unregistered with the same ordering", ->
            listener.register_combo(
                keys            : "shift s"
                is_unordered    : true
            )
            count = listener.get_registered_combos().length
            expect(count).toEqual(1)
            listener.unregister_combo("shift s")
            count = listener.get_registered_combos().length
            expect(count).toEqual(0)

        it "unregisters a combo passed in directly", ->
            combo = listener.register_combo(
                keys            : "shift s"
                is_unordered    : true
            )
            count = listener.get_registered_combos().length
            expect(count).toEqual(1)
            listener.unregister_combo(combo)
            count = listener.get_registered_combos().length
            expect(count).toEqual(0)
