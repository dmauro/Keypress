demo_2 = {}

demo_2.move_piece = (dir) ->
    grid_width = 12
    grid_height = 6
    x_amt = 0
    y_amt = 0
    switch dir
        when "NE"
            x_amt++
            y_amt--
            break
        when "N"
            y_amt--
            break
        when "SW"
            x_amt--
            y_amt++
            break
        when "S"
            y_amt++
            break
        when "SE"
            y_amt++
            x_amt++
            break
        when "E"
            x_amt++
            break
        when "NW"
            y_amt--
            x_amt--
            break
        when "W"
            x_amt--
            break
    pos = demo_2.piece.position()
    left = parseInt(pos.left, 10)/demo_2.unit_size
    top = parseInt(pos.top, 10)/demo_2.unit_size
    left += x_amt
    top += y_amt
    if 0 <= left < grid_width and 0 <= top < grid_height
        demo_2.piece.css(
            left    : left*demo_2.unit_size + "px"
            top     : top*demo_2.unit_size + "px"
        )

demo_2.combos = [
    keys        : "w"
    on_keyup    : ->
        demo_2.move_piece "N"
,
    keys        : "a"
    on_keyup    : ->
        demo_2.move_piece "W"
,
    keys        : "s"
    on_keyup    : ->
        demo_2.move_piece "S"
,
    keys        : "d"
    on_keyup    : ->
        demo_2.move_piece "E"
, 
    keys        : "w a"
    on_keyup    : ->
        demo_2.move_piece "NW"
,
    keys        : "w d"
    on_keyup    : ->
        demo_2.move_piece "NE"
,
    keys        : "s a"
    on_keyup    : ->
        demo_2.move_piece "SW"
,
    keys        : "s d"
    on_keyup    : ->
        demo_2.move_piece "SE"
]
for combo in demo_2.combos
    combo['is_exclusive'] = true


demo_3 = {}

demo_3.select_option = (index) ->
    $('#counting_list li').removeClass "active"
    $("#counting_list li:nth-child(#{index+1})").addClass "active"

demo_3.combos = [
    keys            : "tab space"
    is_counting     : true
    is_ordered      : true
    prevent_default : true
    is_exclusive    : true
    on_keydown      : (e, count) ->
        count = count%6
        demo_3.select_option count
,
    keys            : "tab"
    prevent_default : true
    is_exclusive    : true
    on_keydown      : ->
        demo_3.select_option 0
]


demo_4 = {}

demo_4.highlight = (node) ->
    node.addClass "highlight"
    setTimeout ->
        node.removeClass "highlight"
    , 1000

demo_4.ryu_position = (position, time) ->
    ryu = $('.examples .ryu')
    ryu.attr "class", "ryu"
    ryu.addClass position
    if time
        setTimeout ->
            demo_4.ryu_position "standing"
        , time

demo_4.combos = [
    keys            : "k e y"
    prevent_default : true
    is_sequence     : true
    on_keydown      : ->
        demo_4.highlight $('#sequence_combo span.key')
,
    keys            : "k e y p r e s s"
    prevent_default : true
    is_sequence     : true
    on_keydown      : ->
        demo_4.highlight $('#sequence_combo span.keypress')
,
    keys            : "shift j a v a shift s c r i p t"
    prevent_default : true
    is_sequence     : true
    on_keydown      : ->
        demo_4.highlight $('#sequence_combo span.javascript')
,
    keys            : "down right x"
    prevent_default : true
    is_sequence     : true
    on_keydown      : ->
        demo_4.ryu_position "hadoken", 1000
]

bind_keyboard = ->
    # KeyCode feedback near keyboard
    keyboard_msg_node = $('.keyboard .message')
    $('body').bind('keydown', (e) ->
        keyboard_msg_node.text "#{e.keyCode} keyDown"
    ).bind('keyup', (e) ->
        keyboard_msg_node.text "#{e.keyCode} keyUp"
    )

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
            keys : "print"
            on_keydown : (e) ->
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
                on_down key_nodes.pause_break
            on_keyup : ->
                on_up key_nodes.pause_break
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
                on_down key_nodes.num_enter
            on_keyup : ->
                on_up key_nodes.num_enter
        ,
            keys : "num_decimal"
            on_keydown : ->
                on_down key_nodes.num_decimal
            on_keyup : ->
                on_up key_nodes.num_decimal
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
            keypress.register_many demo_2.combos
            # Add the divs we need for the grid
            total_spots = 12*6
            total_spots += 1
            dom_string = ""
            for i in [0...total_spots]
                dom_string += "<div></div>"
            $('#movement_grid').empty().append(dom_string);
            # Set up movement
            demo_2.piece = $('#movement_grid div:first-of-type')
            demo_2.unit_size = parseInt demo_2.piece.outerWidth(), 10
        unwire  : ->
            keypress.unregister_many demo_2.combos
    demo_3  :
        wire    : ->
            keypress.register_many demo_3.combos
            list = $('#counting_list li')
            list.bind("click", ->
                list.removeClass "active"
                $(this).addClass "active"
            )
        unwire  : ->
            keypress.unregister_many demo_3.combos
            $('#counting_list li').unbind "click"
    demo_4  :
        wire    : ->
            keypress.register_many demo_4.combos
        unwire  : ->
            keypress.unregister_many demo_4.combos

unwire_demo = (demo_node) ->
    wire_demo demo_node, false

wire_demo = (demo_node, wiring=true) ->
    demo = demo_node.data "demo"
    demo_obj = demos[demo]
    return false unless demo_obj
    return demo_obj.wire() if wiring
    return demo_obj.unwire()

get_active_demo = ->
    return_node = false
    $('.examples .demo').each((_, node) ->
        node = $(node)
        if node.css("display") is "block"
            return_node = node
    )
    return return_node

activate_demo = (demo_name) ->
    demo = $(".examples .demo[data-demo=#{demo_name}]")
    return false unless demo.length
    active_demo = get_active_demo()
    return false if demo is active_demo
    if active_demo
        unwire_demo active_demo
        active_demo.css "display", "none"
    demo.css "display", "block"
    nav_node = $(".overview li a[data-demo=#{demo_name}]")
    $('.overview li a').removeClass "active"
    nav_node.addClass "active"
    wire_demo demo

activate_next_demo = ->
    active_demo = get_active_demo();
    next_demo = active_demo.next()
    if next_demo.length
        next_name = next_demo.data "demo"
    else
        next_name = "demo_1"
    activate_demo next_name

activate_prev_demo = ->
    active_demo = get_active_demo();
    next_demo = active_demo.prev()
    if next_demo.length
        next_name = next_demo.data "demo"
    else
        next_name = "demo_5"
    activate_demo next_name

bind_demos = ->
    $('body').delegate('a.demo_link', 'click', ->
        demo = $(this).data "demo"
        activate_demo demo
    )
    keypress.register_combo({
        keys            : "`",
        is_exclusive    : true,
        prevent_default : true,
        on_keydown      : activate_next_demo,
    });
    keypress.combo "1", ->
        activate_demo "demo_1"
    , true
    keypress.combo "2", ->
        activate_demo "demo_2"
    , true
    keypress.combo "3", ->
        activate_demo "demo_3"
    , true
    keypress.combo "4", ->
        activate_demo "demo_4"
    , true
    keypress.combo "5", ->
        activate_demo "demo_5"
    , true

bind_keyboard()
bind_demos()
activate_demo "demo_1"

# Fade out some keys on Mac
if navigator.userAgent.indexOf("Mac OS X") != -1
    $('#key_scroll_lock, #key_pause_break, #key_insert').css "opacity", 0.5
