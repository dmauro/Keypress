bind_keyboard = ->
    keys = $('.keyboard .key')
    key_nodes = {}
    $.each keys, (_, node) ->
        node = $(node)
        id = node.attr "id"
        name = id.substr 4
        key_nodes[name] = node

    on_down = (node) ->
        node.addClass "pressed"
    on_up = (node) ->
        node.removeClass "pressed"

    on_shift_down = (node) ->
        node.addClass "shift_pressed"
    on_shift_up = (node) ->
        node.removeClass "shift_pressed"

    window.onblur = ->
        # Make sure the alt tab keys don't stay pressed
        on_up key_nodes.left_cmd
        on_up key_nodes.right_cmd
        on_up key_nodes.tab
        on_up key_nodes.left_alt
        on_up key_nodes.right_alt

    combos = [
            keys : "`"
            on_keydown : ->
                on_down key_nodes.accent
            on_keyup : ->
                on_up key_nodes.accent
        ,
            keys : "~"
            on_keydown : ->
                on_shift_down key_nodes.accent
            on_keyup : ->
                on_shift_up key_nodes.accent
        ,
            keys : "1"
            on_keydown : ->
                on_down key_nodes.one
            on_keyup : ->
                on_up key_nodes.one
        ,
            keys : "!"
            on_keydown : ->
                on_shift_down key_nodes.one
            on_keyup : ->
                on_shift_up key_nodes.one
        ,
            keys : "2"
            on_keydown : ->
                on_down key_nodes.two
            on_keyup : ->
                on_up key_nodes.two
        ,
            keys : "@"
            on_keydown : ->
                on_shift_down key_nodes.two
            on_keyup : ->
                on_shift_up key_nodes.two
        ,
            keys : "3"
            on_keydown : ->
                on_down key_nodes.three
            on_keyup : ->
                on_up key_nodes.three
        ,
            keys : "#"
            on_keydown : ->
                on_shift_down key_nodes.three
            on_keyup : ->
                on_shift_up key_nodes.three
        ,
            keys : "4"
            on_keydown : ->
                on_down key_nodes.four
            on_keyup : ->
                on_up key_nodes.four
        ,
            keys : "$"
            on_keydown : ->
                on_shift_down key_nodes.four
            on_keyup : ->
                on_shift_up key_nodes.four
        ,
            keys : "5"
            on_keydown : ->
                on_down key_nodes.five
            on_keyup : ->
                on_up key_nodes.five
        ,
            keys : "%"
            on_keydown : ->
                on_shift_down key_nodes.five
            on_keyup : ->
                on_shift_up key_nodes.five
        ,
            keys : "6"
            on_keydown : ->
                on_down key_nodes.six
            on_keyup : ->
                on_up key_nodes.six
        ,
            keys : "^"
            on_keydown : ->
                on_shift_down key_nodes.six
            on_keyup : ->
                on_shift_up key_nodes.six
        ,
            keys : "7"
            on_keydown : ->
                on_down key_nodes.seven
            on_keyup : ->
                on_up key_nodes.seven
        ,
            keys : "&"
            on_keydown : ->
                on_shift_down key_nodes.seven
            on_keyup : ->
                on_shift_up key_nodes.seven
        ,
            keys : "8"
            on_keydown : ->
                on_down key_nodes.eight
            on_keyup : ->
                on_up key_nodes.eight
        ,
            keys : "*"
            on_keydown : ->
                on_shift_down key_nodes.eight
            on_keyup : ->
                on_shift_up key_nodes.eight
        ,
            keys : "9"
            on_keydown : ->
                on_down key_nodes.nine
            on_keyup : ->
                on_up key_nodes.nine
        ,
            keys : "("
            on_keydown : ->
                on_shift_down key_nodes.nine
            on_keyup : ->
                on_shift_up key_nodes.nine
        ,
            keys : "0"
            on_keydown : ->
                on_down key_nodes.zero
            on_keyup : ->
                on_up key_nodes.zero
        ,
            keys : ")"
            on_keydown : ->
                on_shift_down key_nodes.zero
            on_keyup : ->
                on_shift_up key_nodes.zero
        ,
            keys : "-"
            on_keydown : ->
                on_down key_nodes.hyphen
            on_keyup : ->
                on_up key_nodes.hyphen
        ,
            keys : "_"
            on_keydown : ->
                on_shift_down key_nodes.hyphen
            on_keyup : ->
                on_shift_up key_nodes.hyphen
        ,
            keys : "="
            on_keydown : ->
                on_down key_nodes.equals
            on_keyup : ->
                on_up key_nodes.equals
        ,
            keys : "+"
            on_keydown : ->
                on_shift_down key_nodes.equals
            on_keyup : ->
                on_shift_up key_nodes.equals
        ,
            keys : "backspace"
            on_keydown : ->
                on_down key_nodes.backspace
            on_keyup : ->
                on_up key_nodes.backspace
        ,
            keys : "tab"
            on_keydown : ->
                on_down key_nodes.tab
            on_keyup : ->
                on_up key_nodes.tab
        ,
            keys : "q"
            on_keydown : ->
                on_down key_nodes.q
            on_keyup : ->
                on_up key_nodes.q
        ,
            keys : "w"
            on_keydown : ->
                on_down key_nodes.w
            on_keyup : ->
                on_up key_nodes.w
        ,
            keys : "e"
            on_keydown : ->
                on_down key_nodes.e
            on_keyup : ->
                on_up key_nodes.e
        ,
            keys : "r"
            on_keydown : ->
                on_down key_nodes.r
            on_keyup : ->
                on_up key_nodes.r
        ,
            keys : "t"
            on_keydown : ->
                on_down key_nodes.t
            on_keyup : ->
                on_up key_nodes.t
        ,
            keys : "y"
            on_keydown : ->
                on_down key_nodes.y
            on_keyup : ->
                on_up key_nodes.y
        ,
            keys : "u"
            on_keydown : ->
                on_down key_nodes.u
            on_keyup : ->
                on_up key_nodes.u
        ,
            keys : "i"
            on_keydown : ->
                on_down key_nodes.i
            on_keyup : ->
                on_up key_nodes.i
        ,
            keys : "o"
            on_keydown : ->
                on_down key_nodes.o
            on_keyup : ->
                on_up key_nodes.o
        ,
            keys : "p"
            on_keydown : ->
                on_down key_nodes.p
            on_keyup : ->
                on_up key_nodes.p
        ,
            keys : "["
            on_keydown : ->
                on_down key_nodes.left_bracket
            on_keyup : ->
                on_up key_nodes.left_bracket
        ,
            keys : "{"
            on_keydown : ->
                on_shift_down key_nodes.left_bracket
            on_keyup : ->
                on_shift_up key_nodes.left_bracket
        ,
            keys : "]"
            on_keydown : ->
                on_down key_nodes.right_bracket
            on_keyup : ->
                on_up key_nodes.right_bracket
        ,
            keys : "}"
            on_keydown : ->
                on_shift_down key_nodes.right_bracket
            on_keyup : ->
                on_shift_up key_nodes.right_bracket
        ,
            keys : "\\"
            on_keydown : ->
                on_down key_nodes.backslash
            on_keyup : ->
                on_up key_nodes.backslash
        ,
            keys : "|"
            on_keydown : ->
                on_shift_down key_nodes.backslash
            on_keyup : ->
                on_shift_up key_nodes.backslash
        ,
            keys : "caps_lock"
            on_keydown : ->
                on_down key_nodes.caps_lock
            on_keyup : ->
                on_up key_nodes.caps_lock
        ,
            keys : "a"
            on_keydown : ->
                on_down key_nodes.a
            on_keyup : ->
                on_up key_nodes.a
        ,
            keys : "s"
            on_keydown : ->
                on_down key_nodes.s
            on_keyup : ->
                on_up key_nodes.s
        ,
            keys : "d"
            on_keydown : ->
                on_down key_nodes.d
            on_keyup : ->
                on_up key_nodes.d
        ,
            keys : "f"
            on_keydown : ->
                on_down key_nodes.f
            on_keyup : ->
                on_up key_nodes.f
        ,
            keys : "g"
            on_keydown : ->
                on_down key_nodes.g
            on_keyup : ->
                on_up key_nodes.g
        ,
            keys : "h"
            on_keydown : ->
                on_down key_nodes.h
            on_keyup : ->
                on_up key_nodes.h
        ,
            keys : "j"
            on_keydown : ->
                on_down key_nodes.j
            on_keyup : ->
                on_up key_nodes.j
        ,
            keys : "k"
            on_keydown : ->
                on_down key_nodes.k
            on_keyup : ->
                on_up key_nodes.k
        ,
            keys : "l"
            on_keydown : ->
                on_down key_nodes.l
            on_keyup : ->
                on_up key_nodes.l
        ,
            keys : ";"
            on_keydown : ->
                on_down key_nodes.semicolon
            on_keyup : ->
                on_up key_nodes.semicolon
        ,
            keys : ":"
            on_keydown : ->
                on_shift_down key_nodes.semicolon
            on_keyup : ->
                on_shift_up key_nodes.semicolon
        ,
            keys : "\'"
            on_keydown : ->
                on_down key_nodes.apostrophe
            on_keyup : ->
                on_up key_nodes.apostrophe
        ,
            keys : "\""
            on_keydown : ->
                on_shift_down key_nodes.apostrophe
            on_keyup : ->
                on_shift_up key_nodes.apostrophe
        ,
            keys : "enter"
            on_keydown : ->
                on_down key_nodes.enter
            on_keyup : ->
                on_up key_nodes.enter
        ,
            keys : "shift"
            on_keydown : ->
                on_down key_nodes.left_shift
                on_down key_nodes.right_shift
            on_keyup : ->
                on_up key_nodes.left_shift
                on_up key_nodes.right_shift
        ,
            keys : "z"
            on_keydown : ->
                on_down key_nodes.z
            on_keyup : ->
                on_up key_nodes.z
        ,
            keys : "x"
            on_keydown : ->
                on_down key_nodes.x
            on_keyup : ->
                on_up key_nodes.x
        ,
            keys : "c"
            on_keydown : ->
                on_down key_nodes.c
            on_keyup : ->
                on_up key_nodes.c
        ,
            keys : "v"
            on_keydown : ->
                on_down key_nodes.v
            on_keyup : ->
                on_up key_nodes.v
        ,
            keys : "b"
            on_keydown : ->
                on_down key_nodes.b
            on_keyup : ->
                on_up key_nodes.b
        ,
            keys : "n"
            on_keydown : ->
                on_down key_nodes.n
            on_keyup : ->
                on_up key_nodes.n
        ,
            keys : "m"
            on_keydown : ->
                on_down key_nodes.m
            on_keyup : ->
                on_up key_nodes.m
        ,
            keys : ","
            on_keydown : ->
                on_down key_nodes.comma
            on_keyup : ->
                on_up key_nodes.comma
        ,
            keys : "<"
            on_keydown : ->
                on_shift_down key_nodes.comma
            on_keyup : ->
                on_shift_up key_nodes.comma
        ,
            keys : "."
            on_keydown : ->
                on_down key_nodes.period
            on_keyup : ->
                on_up key_nodes.period
        ,
            keys : ">"
            on_keydown : ->
                on_shift_down key_nodes.period
            on_keyup : ->
                on_shift_up key_nodes.period
        ,
            keys : "/"
            on_keydown : ->
                on_down key_nodes.forwardslash
            on_keyup : ->
                on_up key_nodes.forwardslash
        ,
            keys : "?"
            on_keydown : ->
                on_shift_down key_nodes.forwardslash
            on_keyup : ->
                on_shift_up key_nodes.forwardslash
        ,
            keys : "ctrl"
            on_keydown : ->
                on_down key_nodes.left_ctrl
                on_down key_nodes.right_ctrl
            on_keyup : ->
                on_up key_nodes.left_ctrl
                on_up key_nodes.right_ctrl
        ,
            keys : "alt"
            on_keydown : ->
                on_down key_nodes.left_alt
                on_down key_nodes.right_alt
            on_keyup : ->
                on_up key_nodes.left_alt
                on_up key_nodes.right_alt
        ,
            keys : "cmd"
            on_keydown : ->
                on_down key_nodes.left_cmd
                on_down key_nodes.right_cmd
            on_keyup : ->
                on_up key_nodes.left_cmd
                on_up key_nodes.right_cmd
        ,
            keys : "space"
            on_keydown : ->
                on_down key_nodes.space
            on_keyup : ->
                on_up key_nodes.space
        ,
            keys : "up"
            on_keydown : ->
                on_down key_nodes.up
            on_keyup : ->
                on_up key_nodes.up
        ,
            keys : "down"
            on_keydown : ->
                on_down key_nodes.down
            on_keyup : ->
                on_up key_nodes.down
        ,
            keys : "left"
            on_keydown : ->
                on_down key_nodes.left
            on_keyup : ->
                on_up key_nodes.left
        ,
            keys : "right"
            on_keydown : ->
                on_down key_nodes.right
            on_keyup : ->
                on_up key_nodes.right
        ,
        #Next section
            # The print key doesn't actually work
            key : "print"
            on_keydown : ->
                on_down key_nodes.print
            on_keyup : ->
                on_up key_nodes.print
        ,
            keys : "scroll"
            on_keydown : ->
                on_down key_nodes.scroll_lock
            on_keyup : ->
                on_up key_nodes.scroll_lock
        ,
            keys : "pause"
            on_keydown : ->
                on_down key_nodes.pause
            on_keyup : ->
                on_up key_nodes.pause
        ,
            keys : "insert"
            on_keydown : ->
                on_down key_nodes.insert
            on_keyup : ->
                on_up key_nodes.insert
        ,
            keys : "home"
            on_keydown : ->
                on_down key_nodes.home
            on_keyup : ->
                on_up key_nodes.home
        ,
            keys : "pageup"
            on_keydown : ->
                on_down key_nodes.page_up
            on_keyup : ->
                on_up key_nodes.page_up
        ,
            keys : "delete"
            on_keydown : ->
                on_down key_nodes.delete
            on_keyup : ->
                on_up key_nodes.delete
        ,
            keys : "end"
            on_keydown : ->
                on_down key_nodes.end
            on_keyup : ->
                on_up key_nodes.end
        ,
            keys : "pagedown"
            on_keydown : ->
                on_down key_nodes.page_down
            on_keyup : ->
                on_up key_nodes.page_down
        ,
            keys : "num"
            on_keydown : ->
                on_down key_nodes.num_lock
            on_keyup : ->
                on_up key_nodes.num_lock
        ,
            keys : "num_divide"
            on_keydown : ->
                on_down key_nodes.divide
            on_keyup : ->
                on_up key_nodes.divide
        ,
            keys : "num_multiply"
            on_keydown : ->
                on_down key_nodes.multiply
            on_keyup : ->
                on_up key_nodes.multiply
        ,
            keys : "num_subtract"
            on_keydown : ->
                on_down key_nodes.subtract
            on_keyup : ->
                on_up key_nodes.subtract
        ,
            keys : "num_add"
            on_keydown : ->
                on_down key_nodes.add
            on_keyup : ->
                on_up key_nodes.add
        ,
            keys : "num_enter"
            on_keydown : ->
                on_down key_nodes.numpad_enter
            on_keyup : ->
                on_up key_nodes.numpad_enter
        ,
            keys : "num_decimal"
            on_keydown : ->
                on_down key_nodes.numpad_decimal
            on_keyup : ->
                on_up key_nodes.numpad_decimal
        ,
            keys : "num_0"
            on_keydown : ->
                on_down key_nodes.num_0
            on_keyup : ->
                on_up key_nodes.num_0
        ,
            keys : "num_1"
            on_keydown : ->
                on_down key_nodes.num_1
            on_keyup : ->
                on_up key_nodes.num_1
        ,
            keys : "num_2"
            on_keydown : ->
                on_down key_nodes.num_2
            on_keyup : ->
                on_up key_nodes.num_2
        ,
            keys : "num_3"
            on_keydown : ->
                on_down key_nodes.num_3
            on_keyup : ->
                on_up key_nodes.num_3
        ,
            keys : "num_4"
            on_keydown : ->
                on_down key_nodes.num_4
            on_keyup : ->
                on_up key_nodes.num_4
        ,
            keys : "num_5"
            on_keydown : ->
                on_down key_nodes.num_5
            on_keyup : ->
                on_up key_nodes.num_5
        ,
            keys : "num_6"
            on_keydown : ->
                on_down key_nodes.num_6
            on_keyup : ->
                on_up key_nodes.num_6
        ,
            keys : "num_7"
            on_keydown : ->
                on_down key_nodes.num_7
            on_keyup : ->
                on_up key_nodes.num_7
        ,
            keys : "num_8"
            on_keydown : ->
                on_down key_nodes.num_8
            on_keyup : ->
                on_up key_nodes.num_8
        ,
            keys : "num_9"
            on_keydown : ->
                on_down key_nodes.num_9
            on_keyup : ->
                on_up key_nodes.num_9


    ]
    keypress.register_many combos

demos =
    demo_1  :
        wire    : ->
            return
        unwire  : ->
            return
    demo_2  :
        wire    : ->
            keypress.keyup_combo "w", ->
                console.log "N"
            keypress.keyup_combo "a", ->
                console.log "W"
            keypress.keyup_combo "s", ->
                console.log "S"
            keypress.keyup_combo "d", ->
                console.log "E"
            keypress.keyup_combo "w a", ->
                console.log "NW"
            keypress.keyup_combo "w d", ->
                console.log "NE"
            keypress.keyup_combo "s a", ->
                console.log "SW"
            keypress.keyup_combo "s d", ->
                console.log "SE"
        unwire  : ->
            keypress.unregister_many ["w", "a", "s", "d", "w a", "w d", "s a", "s d"]
    demo_3  :
        wire    : ->
            return
        unwire  : ->
    demo_4  :
        wire    : ->
            return
        unwire  : ->

unwire_demo = (demo_node) ->
    wire_demo demo_node, false

wire_demo = (demo_node, wiring=true) ->
    demo = demo_node.data "demo"
    demo_obj = demos[demo]
    return false unless demo_obj
    return demo_obj.wire() if wiring
    return demo_obj.unwire()

get_active_demo = ->
    $('.examples .demo').each((_, node) ->
        node = $(node)
        return node if node.css("display") is "block"
    )

activate_demo = (demo_name) ->
    demo = $(".examples .demo[data-demo=#{demo_name}]")
    return false unless demo.length
    active_demo = get_active_demo()
    return false if demo is active_demo
    unwire_demo active_demo
    active_demo.css "display", "none"
    demo.css "display", "block"
    nav_node = $(".examples nav a[data-demo=#{demo_name}]")
    $('.examples nav a').removeClass "active"
    nav_node.addClass "active"
    wire_demo demo

bind_demos = ->
    $('body').delegate('a.demo_link', 'click', ->
        demo = $(this).data "demo"
        activate_demo demo
    )

$(->
    keypress.init()
    bind_keyboard()
    bind_demos()
    activate_demo "demo_1"
)
