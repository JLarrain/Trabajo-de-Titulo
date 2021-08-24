extends HBoxContainer

# * Signals

# Thrown when the mute button is toggled, on is true when the sound is enabled
signal sound_changed(on)

# * Variables

# State of the mute toggle button
var _muted: bool
# State of the mute setting on file
var _saved_mute: bool
# Signal bypass, to avoid sending signals when loading
var _stop_signal: bool

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_muted = false
	_saved_mute = false
	_stop_signal = false
	$Toggle.connect("toggled", self, "toggle_muted")


# Returns true when the mute button is pressed
func get_muted() -> bool:
	return _muted


# Loads the saved mute setting and propagates it to the mute button
func load_muted(saved_setting: bool, omit_signal := false) -> void:
	_saved_mute = saved_setting
	# Don't signal audio nodes when loading the setting
	_stop_signal = omit_signal
	# Toggle the button if saved_mute is different from default
	if _saved_mute:
		$Toggle.pressed = true
	_stop_signal = false


# Restores the mute state to the setting saved in file
func restore_saved() -> void:
	# Toggle the state only if is different
	if _muted != _saved_mute:
		$Toggle.pressed = _saved_mute


# Toggles the current mute setting state and signals the change
func toggle_muted(_button_pressed := false) -> void:
	# Toggle the setting
	_muted = ! _muted
	# Send the signal if the node is not loading from file
	if ! _stop_signal:
		emit_signal("sound_changed", ! _muted)
