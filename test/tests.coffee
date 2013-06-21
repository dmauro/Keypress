describe "Keypress:", ->
    convert_readable_key_to_keycode = (keyname) ->
        for keycode, name of window._keycode_dictionary
            return keycode if name is keyname
        return

    event_for_key = (key) ->
        event = {}
        key_code = convert_readable_key_to_keycode key
        event.keyCode = key_code
        return event

    on_keydown = (key) ->
        event = event_for_key key
        window._receive_input event, true
        window._bug_catcher event
        return event

    on_keyup = (key) ->
        event = event_for_key key
        window._receive_input event
        return event

    press_key = (key) ->
        on_keydown key
        on_keyup key

    describe "A simple single key basic combo", ->
        afterEach ->
            keypress.reset()

        it "just works.", ->
            foo = 0
            keypress.combo ["a"], ->
                foo = 1
            press_key "a"
            expect(foo).toEqual(1)

        it "can take a string instead of array for keys.", ->
            foo = 0
            keypress.combo "a", ->
                foo = 1
            press_key "a"
            expect(foo).toEqual(1)

