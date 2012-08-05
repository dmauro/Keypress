###
License agreements:
1) Feel free to modify the code.
2) Feel free to credit the author.
3) Keep being awesome.

Keypress
A keyboard input capturing utility in which any key can be a modifier key.
Requires jQuery
Author: David Mauro
###

_registered_combos = []
_keys_down = []
_valid_combos = []
_prevent_capture = false
_prevented_previous_keypress = false
_event_classname = "keypress_events"
_metakey = "ctrl"
_combo_defaults = {
    keys            : []
    count           : 0
    is_ordered      : false
    is_repeating    : false
    on_down         : null
    on_release      : ->
        return
}

_remove_val_from_array = (array, value) ->
    return false unless array and value?
    array[t..t] = [] if (t = array.indexOf(value)) > -1
    return array

_combine_arrays = ->
    array = []
    for a in arguments
        for value in a
            array.push value
    return array

_compare_arrays = (a1, a2) ->
    ###
    This will ignore the ordering of the arrays
    and simply check if they have the same contents.

    This isn't perfect as for example these two 
    arrays would evaluate as being the same:
    ["apple", "orange", "orange"], ["orange", "apple", "apple"]
    But it will serve for now.
    ###
    return false unless a1.length is a2.length
    for item in a1
        continue if item in a2
        return false
    for item in a2
        continue if item in a1
        return false
    return true

_match_combos = (potential_match=_keys_down, source=_registered_combos, allow_partial_match=false) ->
    for source_combo in source
        if source_combo.is_ordered
            return source_combo if potential_match.join("") is source_combo.keys.join("")
            return source_combo if allow_partial_match and potential_match.join("") is source_combo.keys.slice(0, potential_match.length).join("")
        else
            return source_combo if _compare_arrays potential_match, source_combo.keys
            return source_combo if allow_partial_match and _compare_arrays potential_match, source_combo.keys.slice(0, potential_match.length)
    return false

_prevent_default = (e) ->
    ###
    This only happens if we have pressed a registered
    key combo, or if we're working towards one.
    ###
    _prevented_previous_keypress = true
    e.preventDefault()

_key_down = (key, e) ->
    # Prevent hold to repeat key errors
    should_make_new = true
    for key_down in _keys_down
        should_make_new = false if key_down is key
    unless should_make_new
        _prevent_default(e) if _prevented_previous_keypress
        return

    _prevented_previous_keypress = false

    # Add key to keys down
    _keys_down.push key

    # We check to find out if this key press maps to an input object
    # First we should check if this is an exact duplicate match
    match = _match_combos _keys_down, _valid_combos
    if !match
        _match = null
        # Work our way back through a combination with each other key down in order
        for i in [1.._keys_down.length]
            potential_match = _keys_down.slice -i
            _match = _match_combos(potential_match) or _match
        # Then check the list of valid inputs for a combo
        for valid_combo in _valid_combos
            continue if valid_combo.is_activated
            potential_combo = _combine_arrays valid_combo.keys, [key]
            _match = _match_combos(potential_combo) or _match
        # We have to clone and add it if it's not a duplicate
        if _match
            match = $.extend true, {}, _match
            _valid_combos.push match
            _prevent_default e
        else
            # We need to check if we're working towards a combo
            # so that we can prevent default if we are
            for combo in _registered_combos
                compare_keys = combo.keys.slice(0, _keys_down.length)
                if _compare_arrays _keys_down, compare_keys
                    _prevent_default e
                    return
    else
        # Otherwise just reset it
        match.is_activated = false
        _prevent_default e

    return unless match

    # Make sure counting combos increment on keydown
    if match.is_repeating
        match.count += 1
        match.on_down match.count
    # And execute on_down behavior if any
    else
        match.on_down() if typeof match.on_down is "function"

    # Check to see if we replaced any other inputs
    # TODO: We need a better check to find out if this input
    # replaces another. It could be replacing it if only some
    # of the keys match.
    return unless match.keys.length > 1
    prev_keys = _remove_val_from_array $.extend(true, [], match.keys), key
    replaced = _match_combos prev_keys, _valid_combos, true
    return if replaced is match
    return unless replaced
    _remove_val_from_array _valid_combos, replaced
    return

_key_up = (key) ->
    return unless key in _keys_down
    _keys_down = _remove_val_from_array _keys_down, key

    # Was this key part of a combo
    for valid_combo in _valid_combos
        if key in valid_combo.keys
            matched_combo = valid_combo
            break

    # We're done if this key isn't in a valid combo
    return if !matched_combo

    # Check if this is the last key of the combo being released
    keys_remain = false
    for key in matched_combo.keys
        if key in _keys_down
            keys_remain = true
            break

    # Counter increment or just release and mark activated, if not already activated
    unless matched_combo.is_activated
        if matched_combo.is_repeating
            matched_combo.on_release() unless keys_remain
        else
            matched_combo.on_release()
            matched_combo.is_activated = true

    # Wipe the input if this was the last key of the combo
    unless keys_remain
        _valid_combos = _remove_val_from_array _valid_combos, matched_combo
    return

_receive_input = (e, is_keydown) ->
    # Check that we're capturing input
    if _prevent_capture
        if _keys_down.length
            _keys_down = []
        return
    # Catch tabbing out of a non-capturing state
    if !is_keydown and !_keys_down.length
        return
    key = _convert_key_to_readable e.keyCode
    return unless key
    if is_keydown
        _key_down key, e
    else
        _key_up key

_validate_combo = (combo) ->
    # Convert "meta" to either "ctrl" or "cmd"
    for i in [0...combo.keys.length]
        key = combo.keys[i]
        if key is "meta"
            combo.keys.splice i, 1, _metakey

    # TODO: Error check the combo
    # Check that if is_repeating, it has an on_down
    # Check that the keys in keys are all valid

    # TODO: Check that meta or command keys
    # don't have a length over 2

    # TODO: Don't allow explicit command combos
    # because they break on Windows
    return true

_decide_meta_key = ->
    # If the useragent reports Mac OS X, assume cmd is metakey
    if navigator.userAgent.indexOf("Mac OS X") != -1
        _metakey = "cmd"
    return


# Public object and methods

window.keypress = {}

keypress.wire = ()->
    _decide_meta_key()
    $('body')
    .bind "keydown.#{_event_classname}", (e) ->
        _receive_input e, true
        # Spoof a keyup for keys when command is held because they don't fire
        # Cannot use command key with more than 1 key
        if "cmd" in _keys_down and _convert_key_to_readable(e.keyCode) != "cmd"
            _receive_input e, false
    .bind "keyup.#{_event_classname}", (e) ->
        _receive_input e, false
    $(window).bind "blur.#{_event_classname}", ->
        # This prevents alt+tab conflicts
        _keys_down = []
        _valid_combos = []

keypress.combo = (keys_array, on_release) ->
    # Shortcut for simple combos.
    keypress.register_combo(
        keys        : keys_array
        on_release  : on_release
    )

keypress.register_many_combos = (combo_array) ->
    # Shortcut for assigning an array of combos.
    for combo in combo_array
        keypress.register_combo combo
    return true

keypress.register_combo = (combo) ->
    $.extend true, {}, _combo_defaults, combo
    if _validate_combo combo
        _registered_combos.push combo
        return true

keypress.listen = ->
    _prevent_capture = false

keypress.stop_listening = ->
    _prevent_capture = true

# Putting this down here because it's so damn long

_convert_key_to_readable = (k) ->
    switch k
        when 9
            return "tab"
            break
        when 13
            return "enter"
            break
        when 16
            return "shift"
            break
        when 17
            return "ctrl"
            break
        when 18
            return "alt"
            break
        when 27
            return "escape"
            break
        when 32
            return "space"
            break
        when 37
            return "left"
            break
        when 38
            return "up"
            break
        when 39
            return "right"
            break
        when 40
            return "down"
            break
        when 49
            return "1"
            break
        when 50
            return "2"
            break
        when 51
            return "3"
            break
        when 52
            return "4"
            break
        when 53
            return "5"
            break
        when 65
            return "a"
            break
        when 67
            return "c"
            break
        when 68
            return "d"
            break
        when 69
            return "e"
            break
        when 70
            return "f"
            break
        when 81
            return "q"
            break
        when 82
            return "r"
            break
        when 83
            return "s"
            break
        when 84
            return "t"
            break
        when 87
            return "w"
            break
        when 88
            return "x"
            break
        when 90
            return "z"
            break
        when 91
            return "cmd"
            break
        when 224
            return "cmd"
            break
    return false
