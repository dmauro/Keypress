describe "Keypress:", ->
    convert_readable_key_to_keycode = (keyname) ->
        for keycode, name of window._keycode_dictionary
            return keycode if name is keyname
        return

    event_for_key = (key) ->
        event = {}
        event.preventDefault = ->
            return
        spyOn event, "preventDefault"
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
                console.log key_handler.calls.length
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

