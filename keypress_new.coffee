###
License agreements:
1) Feel free to modify the code.
2) Feel free to credit the author.
3) Keep being awesome.

Keypress
A keyboard input capturing utility in which any key can be a modifier key.
Requires jQuery
Author: David Mauro

Options available and defaults:
    keys            : []        - An array of the keys pressed together to activate combo
    count           : 0         - The number of times a counting combo has been pressed. Reset on release.
    allow_default   : false     - Allow the default key event to happen in addition to the combo.
    is_ordered      : false     - Unless this is set to true, the keys can be pressed down in any order
    is_counting     : false     - Makes this a counting combo (see documentation)
    is_sequence     : false     - Rather than a key combo, this is an ordered key sequence
    prevent_repeat  : false     - Prevent the combo from repeating when keydown is held.
    on_keyup        : null      - A function that is called when the combo is released
    on_keydown      : null      - A function that is called when the combo is pressed.
    on_release      : null      - A function that is called for counting combos when all keys are released.
###

_registered_combos = []
_sequence = []
_sequence_timer = null
_keys_down = []
_active_combos = []
_prevent_capture = false
_event_classname = "keypress_events"
_metakey = "ctrl"
_modifier_keys = ["meta", "alt", "option", "ctrl", "shift", "cmd"]
_valid_keys = []
_combo_defaults = {
    keys            : []
    count           : 0
}

_log_error = (msg) ->
    console.log msg

_compare_arrays = (a1, a2) ->
    # This will ignore the ordering of the arrays
    # and simply check if they have the same contents.
    return false unless a1.length is a2.length
    for item in a1
        continue if item in a2
        return false
    for item in a2
        continue if item in a1
        return false
    return true

_prevent_default = (e) ->
    # If we've pressed a combo, or if we are working towards
    # one, we should prevent the default keydown event.
    e.preventDefault()

_allow_key_repeat = (combo) ->
    return false if combo.prevent_repeat
    # Combos with keydown functions should be able to rapid fire
    # when holding down the key for an extended period
    return true if typeof combo.on_keydown is "function"

_keys_remain = (combo) ->
    for key in combo.keys
        if key in _keys_down
            keys_remain = true
            break
    return keys_remain

_fire = (event, combo) ->
    # Only fire this event if the function is defined
    combo["on_" + event]() if typeof combo["on_" + event] is "function"
    # We need to mark that keyup has already happened
    if event is "keyup"
        combo.keyup_fired = true

_match_combo_arrays = (potential_match, source_combo_array, allow_partial_match=false) ->
    for source_combo in source_combo_array
        continue if source_combo_array.is_sequence
        if source_combo.is_ordered
            return source_combo if potential_match.join("") is source_combo.keys.join("")
            return source_combo if allow_partial_match and potential_match.join("") is source_combo.keys.slice(0, potential_match.length).join("")
        else
            return source_combo if _compare_arrays potential_match, source_combo.keys
            return source_combo if allow_partial_match and _compare_arrays potential_match, source_combo.keys.slice(0, potential_match.length)
    return false

_cmd_bug_check = (combo_keys) ->
    # We don't want to allow combos to activate if the cmd key
    # is pressed, but cmd isn't in them. This is so they don't
    # accidentally rapid fire due to our hack-around for the cmd
    # key bug and having to fake keyups.
    if "cmd" in _keys_down and "cmd" not in combo_keys
        return false
    return true

_get_active_combo = (key) ->
    # Based on the keys_down and the key just pressed or released
    # (which should not be in keys_down), we determine if any
    # combo in registered_combos matches exactly.

    # First check that every key in keys_down maps to a combo
    keys_down = _keys_down.filter (down_key) ->
        down_key isnt key
    keys_down.push key
    perfect_match = _match_combo_arrays keys_down, _registered_combos
    return perfect_match if perfect_match and _cmd_bug_check keys_down

    # Then work our way back through a combination with each other key down in order
    # This will match a combo even if some other key that is not part of the combo
    # is being held down.
    potentials = []
    slice_up_array = (array) ->
        for i in [0...array.length]
            partial = array.slice()
            partial.splice i, 1
            continue unless partial.length
            fuzzy_match = _match_combo_arrays partial, _registered_combos
            potentials.push(fuzzy_match) if fuzzy_match and fuzzy_match not in potentials
            slice_up_array partial
        return
    slice_up_array keys_down

    # Return the combo with the longest keys array
    # But if two combos have the same length, dont' do anything and announce conflict.
    return false unless potentials.length
    if potentials.length > 1
        potentials.sort (a, b) ->
            b.keys.length - a.keys.length
        if potentials[0].length is potentials[1].length
            _log_error "Conflicting combos registered"
            return false;
    return potentials[0] if _cmd_bug_check potentials[0].keys

_get_potential_combo = (key) ->
    # Check if we are working towards pressing a combo.
    # Used for preventing default on keys that might match
    # to a combo in the future.
    for combo in _registered_combos
        continue if combo.is_sequence
        return combo if key in combo.keys and _cmd_bug_check combo.keys
    return false

_add_to_active_combos = (combo) ->
    replaced = false
    # An active combo is any combo which the user has already entered.
    # We use this to track when a user has released the last key of a
    # combo for on_release, and to keep combos from 'overlapping'.
    if combo in _active_combos
        return false
    else if _active_combos.length
        # We have to check if we're replacing another active combo
        # So compare the combo.keys to all active combos' keys.
        for i in [0..._active_combos.length]
            active_keys = _active_combos[i].keys.slice()
            for active_key in active_keys
                is_match = true
                unless active_key in combo.keys
                    is_match = false
                    break
            if is_match
                # In this case we'll just replace it
                _active_combos.splice i, 1, combo
                replaced = true
                break
    unless replaced
        _active_combos.push combo
    return true

_remove_from_active_combos = (combo) ->
    for i in [0..._active_combos.length]
        active_combo = _active_combos[i]
        if active_combo is combo
            _active_combos.splice i, 1
            break
    return

_add_key_to_sequence = (key) ->
    _sequence.push key
    # Now check if they're working towards a sequence
    sequence_combo = _get_sequence true
    if sequence_combo
        # If we're working towards it, give them more time to keep going
        clearTimeout(_sequence_timer) if _sequence_timer
        _sequence_timer = setTimeout ->
            _sequence = []
        , sequence_combo.wait or 500
    else
        # If we're not working towards something, just clear it out
        _sequence = []

    return

_get_sequence = (allow_partial=false)->
    # Compare _sequence to all combos
    for combo in _registered_combos
        continue unless combo.is_sequence
        continue unless combo.keys.length is _sequence.length or allow_partial
        match = true
        for i in [0..._sequence.length]
            unless combo.keys[i] is _sequence[i]
                match = false
                break
        return combo if match
    return false

_key_down = (key, e) ->
    # Add the key to sequences
    _add_key_to_sequence key
    sequence_combo = _get_sequence()
    _fire "keydown", sequence_combo if sequence_combo

    # Find which combo we have pressed or might be working towards, and prevent default
    combo = _get_active_combo key
    if !combo
        potential_combo = _get_potential_combo key
    if (combo and !combo.allow_default) or (potential_combo and !potential_combo.allow_default)
        _prevent_default(e)

    # If we've already pressed this key, check that we want to fire
    # again, otherwise just add it to the keys_down list.
    if key in _keys_down
        return false unless _allow_key_repeat combo
    else
        _keys_down.push key

    # We're done now unless we have a match
    return false unless combo

    # Now we add this combo or replace it in _active_combos
    _add_to_active_combos combo, key

    # We reset the keyup_fired property because you should be
    # able to fire that again, if you've pressed the key down again
    combo.keyup_fired = false

    # Now we fire the keydown event
    _fire "keydown", combo
    return

_key_up = (key) ->
    # Check if we have a keyup firing
    sequence_combo = _get_sequence()
    _fire "keyup", sequence_combo if sequence_combo

    # Remove from the list
    return false unless key in _keys_down
    for i in [0..._keys_down.length]
        if key is _keys_down[i]
            _keys_down.splice i, 1
            break

    # When releasing we should only check if we
    # match from _active_combos so that we don't
    # accidentally fire for a combo that was a
    # smaller part of the one we actually wanted.
    for active_combo in _active_combos
        if key in active_combo.keys
            combo = active_combo
            break
    return unless combo

    # Check if any keys from this combo are still being held.
    keys_remaining = _keys_remain combo

    # Any unactivated combos will fire, unless it is a counting combo with no keys remaining.
    # We don't fire those because they will fire on_release on their last key release.
    if !combo.keyup_fired and (!combo.is_counting or (combo.is_counting and keys_remaining))
        _fire "keyup", combo
        combo.count += 1 if combo.is_counting

    # Store this for later cleanup
    active_combos_length = _active_combos.length

    # If this was the last key released of the combo, clean up.
    unless keys_remaining
        if combo.is_counting
            _fire "release", combo
            combo.count = 0
        _remove_from_active_combos combo

    # We also need to check other combos that might still be in active_combos
    # and needs to be removed from it.
    if active_combos_length > 1
        for active_combo in _active_combos
            continue if combo is active_combo
            unless _keys_remain active_combo
                _remove_from_active_combos active_combo
    return

_receive_input = (e, is_keydown) ->
    # If we're not capturing input, we should
    # clear out _keys_down for good measure
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
    # TODO: MAKE SURE THE COMBO ISN'T ALREADY IN THERE

    # Convert "meta" to either "ctrl" or "cmd"
    # Don't explicity use the command key, it breaks
    # because it is the windows key in Windows, and
    # cannot be hijacked.
    for i in [0...combo.keys.length]
        key = combo.keys[i]
        if key is "meta" or key is "cmd"
            combo.keys.splice i, 1, _metakey
            if key is "cmd"
                _log_error "Warning: use the \"meta\" key rather than \"cmd\" for Windows compatibility"

    # Check that all keys in the combo are valid
    for key in combo.keys
        unless key in _valid_keys
            _log_error "Do not recognize the key \"#{key}\""
            return false

    # We can only allow a single non-modifier key
    # in combos that include the command key (this
    # includes 'meta') because of the keyup bug.
    if "meta" in combo.keys or "cmd" in combo.keys
        non_modifier_keys = combo.keys.slice()
        for mod_key in _modifier_keys
            if (i = non_modifier_keys.indexOf(mod_key)) > -1
                non_modifier_keys.splice(i, 1) 
        if non_modifier_keys.length > 1
            _log_error "META and CMD key combos cannot have more than 1 non-modifier keys", combo, non_modifier_keys
            return true
    return true

_decide_meta_key = ->
    # If the useragent reports Mac OS X, assume cmd is metakey
    if navigator.userAgent.indexOf("Mac OS X") != -1
        _metakey = "cmd"
    return

_bug_catcher = (e) ->
    # Force a keyup for non-modifier keys when command is held because they don't fire
    if "cmd" in _keys_down and _convert_key_to_readable(e.keyCode) not in ["cmd", "shift", "alt"]
        _receive_input e, false

###########################
# Public object and methods
###########################
window.keypress = {}

keypress.wire = ()->
    _decide_meta_key()
    $('body')
    .bind "keydown.#{_event_classname}", (e) ->
        _receive_input e, true
        _bug_catcher e
    .bind "keyup.#{_event_classname}", (e) ->
        _receive_input e, false
    $(window).bind "blur.#{_event_classname}", ->
        # This prevents alt+tab conflicts
        _keys_down = []
        _valid_combos = []

keypress.sequence = (string, callback) ->
    keys = string.split " "
    keypress.register_combo(
        keys        : keys
        on_keydown  : callback
        is_sequence : true
    )

keypress.combo = (keys_array, callback) ->
    # Shortcut for simple combos.
    keypress.register_combo(
        keys        : keys_array
        on_keydown  : callback
    )

keypress.register_many_combos = (combo_array) ->
    # Shortcut for assigning an array of combos.
    for combo in combo_array
        keypress.register_combo combo
    return true

keypress.register_combo = (combo) ->
    combo = $.extend true, {}, _combo_defaults, combo
    if _validate_combo combo
        _registered_combos.push combo
        return true

keypress.listen = ->
    _prevent_capture = false

keypress.stop_listening = ->
    _prevent_capture = true

_convert_key_to_readable = (k) ->
    return _keycode_dictionary[k]

_keycode_dictionary = 
    8   : "backspace"
    9   : "tab"
    13  : "enter"
    16  : "shift"
    17  : "ctrl"
    18  : "alt"
    19  : "pause"
    20  : "caps"
    27  : "escape"
    32  : "space"
    33  : "pageup"
    34  : "pagedown"
    35  : "end"
    36  : "home"
    37  : "left"
    38  : "up"
    39  : "right"
    40  : "down"
    45  : "insert"
    46  : "delete"
    49  : "1"
    50  : "2"
    51  : "3"
    52  : "4"
    53  : "5"
    54  : "6"
    55  : "7"
    56  : "8"
    57  : "9"
    65  : "a"
    66  : "b"
    67  : "c"
    68  : "d"
    69  : "e"
    70  : "f"
    71  : "g"
    72  : "h"
    73  : "i"
    74  : "j"
    75  : "k"
    76  : "l"
    77  : "m"
    78  : "n"
    79  : "o"
    80  : "p"
    81  : "q"
    82  : "r"
    83  : "s"
    84  : "t"
    85  : "u"
    86  : "v"
    87  : "w"
    88  : "x"
    89  : "y"
    90  : "z"
    91  : "cmd"
    92  : "cmd"
    186 : ";"
    187 : "="
    188 : ","
    189 : "-"
    190 : "."
    191 : "/"
    192 : "`"
    219 : "["
    220 : "\\"
    221 : "]"
    222 : "\'"
    224 : "cmd"

for _, key of _keycode_dictionary
    _valid_keys.push key
