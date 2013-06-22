describe "Keypress:", ->
    SHIFT = false

    convert_readable_key_to_keycode = (keyname) ->
        for keycode, name of window._keycode_dictionary
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
        window._receive_input event, true
        window._bug_catcher event
        return event

    on_keyup = (key) ->
        if key is "shift"
            SHIFT = false
        event = event_for_key key
        window._receive_input event, false
        return event

    press_key = (key) ->
        on_keydown key
        on_keyup key

    describe "A simple single key basic combo", ->
        afterEach ->
            keypress.reset()

        it "just works", ->
            foo = 0
            keypress.combo ["a"], ->
                foo = 1
            press_key "a"
            expect(foo).toEqual(1)

        it "can prevent default", ->
            keypress.combo "a", null, true
            event = on_keydown "a"
            on_keyup "a"
            expect(event.preventDefault).toHaveBeenCalled()

        it "defaults to not preventing default", ->
            keypress.combo "a", null
            event = on_keydown "a"
            on_keyup "a"
            expect(event.preventDefault).not.toHaveBeenCalled()

    describe "Shift key helpers", ->
        key_handler = null
        beforeEach ->
            key_handler = jasmine.createSpy()
        afterEach ->
            keypress.reset()

        it "evaluates keys as shifted to match combos", ->
            keypress.combo "!", key_handler
            on_keydown "shift"
            on_keydown "1"
            expect(key_handler).toHaveBeenCalled()
            on_keyup "shift"
            on_keyup "1"

        it "still fires the correct keyup even if you let off shift first", ->
            keypress.register_combo(
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


    describe "Explicit combo options", ->
        key_handler = null
        beforeEach ->
            key_handler = jasmine.createSpy()
        afterEach ->
            keypress.reset()

        describe "keys", ->

            it "can take an array", ->
                keypress.register_combo(
                    keys        : ["a"]
                    on_keydown  : key_handler
                )
                press_key "a"
                expect(key_handler).toHaveBeenCalled()

            it "can take a string", ->
                keypress.register_combo(
                    keys        : "a"
                    on_keydown  : key_handler
                )
                press_key "a"
                expect(key_handler).toHaveBeenCalled()

        describe "on_keydown", ->

            it "receives the event and combo count as arguments", ->
                received_event = null
                keypress.combo "a", (event, count) ->
                    expect(count).toEqual(0)
                    received_event = event
                down_event = on_keydown "a"
                on_keyup "a"
                expect(received_event).toEqual(down_event)

            it "only fires when all of the keys have been pressed", ->
                keypress.combo "a b c", key_handler
                on_keydown "a"
                expect(key_handler).not.toHaveBeenCalled()
                on_keydown "b"
                expect(key_handler).not.toHaveBeenCalled()
                on_keydown "c"
                expect(key_handler).toHaveBeenCalled()
                on_keyup "a"
                on_keyup "b"
                on_keyup "c"

            # DO A TEST FOR PRESSING THE LAST KEYDOWN MULTIPLE TIMES

        describe "on_keyup", ->

            it "fires properly", ->
                keypress.register_combo(
                    keys        : "a"
                    on_keyup    : key_handler
                )
                press_key "a"
                expect(key_handler).toHaveBeenCalled()

            it "receives the event as its argument", ->
                received_event = null
                keypress.register_combo(
                    keys        : "a"
                    on_keyup    : (event) ->
                        received_event = event
                )
                on_keydown "a"
                up_event = on_keyup "a"
                expect(received_event).toEqual(up_event)

            it "fires only after all keys are down and the first has been released", ->
                keypress.register_combo(
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
                keypress.register_combo(
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
                keypress.combo "a", ->
                    expect(this).toEqual(window)
                press_key "a"

            it "can be set to any arbitrary scope", ->
                my_scope = {}
                keypress.register_combo(
                    keys        : "a"
                    this        : my_scope
                    on_keydown  : ->
                        expect(this).toEqual(my_scope)
                )
                press_key "a"

        describe "prevent_default", ->

            it "manual: only prevents on the key that activated the handler", ->
                keypress.register_combo(
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

            it "return false: only prevents the key that activated the handler", ->
                keypress.register_combo(
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
                expect(c_down_event.preventDefault).toHaveBeenCalled()
                a_up_event = on_keyup "a"
                expect(a_up_event.preventDefault).toHaveBeenCalled()
                b_up_event = on_keyup "b"
                expect(b_up_event.preventDefault).not.toHaveBeenCalled()
                c_up_event = on_keyup "c"
                expect(c_up_event.preventDefault).toHaveBeenCalled()

            it "property: prevents on all events related and only those related", ->
                keypress.register_combo(
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
                ### We don't prevent on keyup and release. Something to consider
                expect(a_up_event.preventDefault).toHaveBeenCalled()
                expect(x_up_event.preventDefault).not.toHaveBeenCalled()
                expect(b_up_event.preventDefault).toHaveBeenCalled()
                expect(c_up_event.preventDefault).toHaveBeenCalled()
                ###

        describe "prevent_repeat", ->

            it "allows multiple firings of the keydown event by default", ->
                keypress.combo "a", key_handler
                on_keydown "a"
                on_keydown "a"
                expect(key_handler.calls.length).toEqual(2)
                on_keyup "a"

            it "only fires the first time it is pressed down when true", ->
                keypress.register_combo(
                    keys            : "a"
                    on_keydown      : key_handler
                    prevent_repeat  : true
                )
                on_keydown "a"
                on_keydown "a"
                expect(key_handler.calls.length).toEqual(1)
                on_keyup "a"

        describe "is_ordered", ->

            it "allows a user to press the keys in any order by default", ->
                keypress.combo "a b", key_handler
                on_keydown "b"
                on_keydown "a"
                on_keyup "b"
                on_keyup "a"
                expect(key_handler).toHaveBeenCalled()

            it "forces the order described when set to true", ->
                keypress.register_combo(
                    keys        : "a b"
                    on_keydown  : key_handler
                    is_ordered  : true
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

        describe "is_counting", ->

            it "calls the keydown handler with the count", ->
                last_count = 0
                keypress.register_combo(
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
                keypress.register_combo(
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
                keypress.register_combo(
                    keys        : "tab space"
                    is_counting : true
                    on_keydown  : (event, count) ->
                        last_count = count
                )
                keypress.register_combo(
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
                keypress.register_combo(
                    keys        : "h i"
                    is_sequence : true
                    on_keydown  : key_handler
                )
                press_key "h"
                press_key "i"
                expect(key_handler).toHaveBeenCalled()

            it "works with the prevent_default property", ->
                keypress.register_combo(
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

            it "will trigger overlapping sequences", ->
                keypress.register_combo(
                    keys        : "h i"
                    is_sequence : true
                    on_keydown  : key_handler
                )
                keypress.register_combo(
                    keys            : "h i t"
                    is_sequence     : true
                    on_keydown      : key_handler
                )
                press_key "h"
                press_key "i"
                press_key "t"
                expect(key_handler.calls.length).toEqual(2)

        describe "is_exclusive", ->

            it "will fire both all combos by default", ->
                keypress.register_combo(
                    keys            : "a b"
                    on_keydown      : key_handler
                )
                keypress.register_combo(
                    keys            : "a b c"
                    on_keydown      : key_handler
                )
                on_keydown "c"
                on_keydown "a"
                on_keydown "b"
                expect(key_handler.calls.length).toEqual(2)
                on_keyup "a"
                on_keyup "b"
                on_keyup "c"

            it "will not fire keydown for a less specific combo that is also exclusive", ->
                fired = null
                keypress.register_combo(
                    keys            : "a b"
                    is_exclusive    : true
                    on_keydown      : ->
                        fired = "smaller"
                        key_handler()
                )
                keypress.register_combo(
                    keys            : "a b c"
                    is_exclusive    : true
                    on_keydown      : ->
                        fired = "bigger"
                        key_handler()
                )
                on_keydown "c"
                on_keydown "a"
                on_keydown "b"
                expect(key_handler.calls.length).toEqual(1)
                expect(fired).toEqual("bigger")
                on_keyup "a"
                on_keyup "b"
                on_keyup "c"

            it "will not fire keyup for a less specific combo that is also exclusive", ->
                fired = null
                keypress.register_combo(
                    keys            : "a b"
                    is_exclusive    : true
                    on_keyup        : ->
                        fired = "smaller"
                        key_handler()
                )
                keypress.register_combo(
                    keys            : "a b c"
                    is_exclusive    : true
                    on_keyup        : ->
                        fired = "bigger"
                        key_handler()
                )
                on_keydown "c"
                on_keydown "a"
                on_keydown "b"
                on_keyup "c"
                on_keyup "b"
                on_keyup "a"
                expect(key_handler.calls.length).toEqual(1)
                expect(fired).toEqual("bigger")

        describe "is_solitary", ->

            it "will not fire the combo if additional keys are pressed", ->
                keypress.register_combo(
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
                keypress.register_combo(
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


describe "Keypress Functional components:", ->
    afterEach ->
        keypress.reset()

    describe "_is_array_in_array_sorted", ->

        it "case 1", ->
            result = window._is_array_in_array_sorted ["a", "b"], ["a", "b", "c"] 
            expect(result).toBe(true)

        it "case 2", ->
            result = window._is_array_in_array_sorted ["a", "b", "c"], ["a", "b"] 
            expect(result).toBe(false)

        it "case 3", ->
            result = window._is_array_in_array_sorted ["a", "b"], ["a", "x", "b"]
            expect(result).toBe(true)

        it "case 4", ->
            result = window._is_array_in_array_sorted ["b", "a"], ["a", "x", "b"]
            expect(result).toBe(false)

    describe "_fuzzy_match_combo_arrays", ->

        it "properly matches even with something else in the array", ->
            keypress.register_combo(
                keys        : "a b"
            )
            foo = 0
            window._fuzzy_match_combo_arrays ["b", "x", "a"], ->
                foo += 1
            expect(foo).toEqual(1)

        it "won't match a sorted combo that isn't in the same order", ->
            keypress.register_combo(
                keys        : "a b"
                is_ordered  : true
            )
            foo = 0
            window._fuzzy_match_combo_arrays ["b", "x", "a"], ->
                foo += 1
            expect(foo).toEqual(0)

        it "will match a sorted combo that is in the correct order", ->
            keypress.register_combo(
                keys        : "a b"
                is_ordered  : true
            )
            foo = 0
            window._fuzzy_match_combo_arrays ["a", "x", "b"], ->
                foo += 1
            expect(foo).toEqual(1)

