extends VBoxContainer

# * Signals

# Thrown when a color palette change is saved to file
signal colors_changed(palette_n)
# Thrown when the back button is pressed
signal exit_pressed
# Thrown when the menu is ready to be used
signal menu_ready(menu)
# Thrown when a sound change is saved
signal sound_saved(on)
# Thrown when the mute toggle is changed
signal sound_changed(on)

# * Variables

# Back button node
var _back_button: Button
# Text of the back button
export var _back_text: String = "Back"
# Current loaded mute value from file
var _loaded_mute: bool
# Current loaded palette fron file
var _loaded_palette: int
# Mute sound manager node
var _mute: HBoxContainer
# Color palette manager node
var _palettes: HBoxContainer
# Save button node
var _save_button: Button

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_palettes = $"Config/Color Palettes"
	_mute = $Config/Mute
	_back_button = $Back/BackContainer/BackButton
	_save_button = $Back/SaveContainer/SaveButton
	_set_back_text("  " + _back_text + "  ")
	emit_signal("menu_ready", self)


# Loads settings saved in the config file, given through a dict
func load_settings(config: Dictionary) -> void:
	for key in config.keys():
		match key:
			# Load the selected palette
			"palette":
				_loaded_palette = config[key]
				_palettes.load_palettes(config[key], true)
			# Load the mute configuration
			"mute":
				_loaded_mute = config[key]
				_mute.load_muted(config[key], true)
			# Omit any extra variables
			_:
				print("Key %s not implemented in settings menu." % str(key))


# Propagates the sound_changed signal up
func propagate_sound_change(on: bool) -> void:
	emit_signal("sound_changed", on)


# Sets hooks to the settings manager, so it receives any updates
func set_hooks(
	settings_node: Node,
	save_colors: String,
	save_sound: String,
	set_sound: String
) -> void:
	self.connect("colors_changed", settings_node, save_colors)
	self.connect("sound_saved", settings_node, save_sound)
	self.connect("sound_changed", settings_node, set_sound)


# Sets the hook for the exit signal
func set_return_hook(node: Node, method: String) -> void:
	self.connect("exit_pressed", node, method)


# Sets the text on the back button to be "Back to <previous interface>"
func set_return_name(name: String) -> void:
	_set_back_text("Back to " + name)


# Sets the given theme to be used on this menu
func set_theme(_theme: Theme) -> void:
	# TODO: IMPLEMENT
	pass


# Notifies the exiting of this menu
func _exit_menu() -> void:
	# Restore the mute setting if its change wasn't saved
	_mute.restore_saved()
	# Notifies the menu exiting
	emit_signal("exit_pressed")


# Give focus to a button on its request
func _request_focus(btn: Button) -> void:
	btn.grab_focus()


# Saves changed settings on save button press
func _save_changes() -> void:
	if _mute.get_muted() != _loaded_mute:
		_loaded_mute = _mute.get_muted()
		emit_signal("sound_saved", ! _loaded_mute)
	if _palettes.get_selected() != _loaded_palette:
		_loaded_palette = _palettes.get_selected()
		emit_signal("colors_changed", _loaded_palette)


# Sets the text on the back button
func _set_back_text(text: String) -> void:
	_back_button.set_text("  " + text + "  ")
