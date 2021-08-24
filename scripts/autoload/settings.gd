class_name Settings

extends Node

# * Signals

# Thrown when the colors are changed
signal colors_changed
# Thrown when the sound state is changed
signal sound_state_changed

# * Constants

# Settings menu scene
const MenuScene: PackedScene = preload("res://scenes/gui/settings_menu.tscn")

# * Variables

# Current theme being used
var _current_theme: Theme
# Color palettes available
var _palettes: Array
# Settings file path
var _path: String
# Current color palette selected
var _selected_palette: int
# Loaded settings file
var _settings_file: ConfigFile
# Current sound state, when false the game is muted
var _sound_state: bool

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_settings_file = ConfigFile.new()
	_path = "user://settings.cfg"
	var err = _settings_file.load(_path)
	assert(err == OK)
	_set_sound(! _settings_file.get_value("general", "mute"))
	_set_colors(
		_settings_file.get_value("general", "palette"),
		_settings_file.get_value("general", "color_palettes")
	)
	_current_theme = null  # TODO: Load default theme


# Return the current color palette
func get_colors() -> PoolColorArray:
	return _palettes[_selected_palette]


# Return a Control node to show the settings menu
func get_settings_menu() -> Node:
	# Instance the scene
	var menu = MenuScene.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	# Connect the menu ready signal
	menu.connect(
		"menu_ready", self, "_on_settings_menu_ready", [], CONNECT_DEFERRED
	)
	# Request ready to be run when added to the tree
	menu.request_ready()
	return menu


# Return the current sound state
func get_sound_state() -> bool:
	return _sound_state


# Sets a connection to the object and method given when updating the color
# palette and disconnects it when the object exits the tree
func request_color_updates(node: Node, method: String) -> void:
	# TODO: Implement with groups
	self.connect("colors_changed", node, method)
	# TODO: Disconnect


# Sets a connection to the object and method given when updating the sound
# settings and disconnects it when the object exits the tree
func request_sound_updates(node: Node, method: String) -> void:
	# TODO: Implement with groups
	self.connect("sound_state_changed", node, method)
	# TODO: Disconnect


# Loads the settings to the setting menu instance when it finishes loading
func _on_settings_menu_ready(menu: Control) -> void:
	menu.load_settings(
		{
			"palette": _selected_palette,
			"mute": ! _sound_state,
		}
	)
	menu.set_theme(_current_theme)
	menu.set_hooks(self, "_save_colors", "_save_sound", "_set_sound")


# Saves a color change to file
func _save_colors(selection: int) -> void:
	if _selected_palette != selection:
		_set_colors(selection, _palettes)
		_settings_file.set_value("general", "palette", _selected_palette)
		_settings_file.save(_path)


# Saves a sound state change to file
func _save_sound(on: bool) -> void:
	var prev_sound = ! _settings_file.get_value("general", "mute")
	# As the sound state changes on toggle, _sound_state is already
	# up to date, so there's no need to use _set_sound
	if prev_sound != on:
		_settings_file.set_value("general", "mute", ! _sound_state)
		_settings_file.save(_path)


# Sets the current color palette
func _set_colors(selected: int, available: Array) -> void:
	_selected_palette = selected
	_palettes = available
	emit_signal("colors_changed")


# Sets the sound state to on or off
func _set_sound(on: bool) -> void:
	_sound_state = on
	emit_signal("sound_state_changed")
