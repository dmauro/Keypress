bind_keyboard = ->
    console.log "binding keyboard"
    pressed_class = "pressed"

    key_nodes =
        tilda   : $('#key_tilda')
        one     : $('#key_1')
        two     : $('#key_2')
        three   : $('#key_3')
        four    : $('#key_4')
        five    : $('#key_5')
        six     : $('#key_6')
        seven   : $('#key_7')
        eight   : $('#key_8')
        nine    : $('#key_9')
        zero    : $('#key_0')

    r = keypress.register_combo

    r
        keys : "`"
        on_keydown : ->
            console.log "keydown"
            key_nodes.tilda.addClass pressed_class
        on_keyup : ->
            key_nodes.tilda.removeClass pressed_class
    r
        keys : "1"
        on_keydown : ->
            console.log "one"

    keypress.combo("s w", ->
        console.log("s")
    )

$(->
    bind_keyboard()
)
