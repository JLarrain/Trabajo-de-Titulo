class_name LevelGui
extends Control

# * Signals
# Signals a valence change. Is true if valence is up.
signal valence_change(up)
# Signals the use of a bonus
signal bonus_used

# * Variables
enum Corners { UPPER_LEFT, UPPER_RIGHT, LOWER_LEFT, LOWER_RIGHT }
enum Edges { LEFT, RIGHT, TOP, BOTTOM }
export (Edges) var slider_location := Edges.RIGHT setget set_slider_location, get_slider_location
export (Corners) var bonus_location := Corners.UPPER_RIGHT setget set_bonus_location, get_bonus_location
export (Corners) var score_location := Corners.UPPER_LEFT setget set_score_location, get_score_location
export (String) var level_name := "" setget set_level_name, get_level_name
export (String, MULTILINE) var level_flavor_text := "" setget set_level_flavor_text, get_level_flavor_text
export (String, MULTILINE) var bonus_action_text := "" setget set_bonus_action_text, get_bonus_action_text
export (String, MULTILINE) var main_action_text := "" setget set_main_action_text, get_main_action_text
export (String, MULTILINE) var second_action_text := "" setget set_second_action_text, get_second_action_text
var active := false setget set_active, get_active
var _pause_layer: CanvasLayer
var _intro_layer: CanvasLayer
var _slider: Control
var _bonus: Control
var _score: Control
var _current_multiplier: int

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_slider = $AffectiveSlider
	_bonus = $BonusGui
	_score = $ScorePanel
	_pause_layer = $PauseLayer
	_intro_layer = $IntroLayer
	set_level_name(level_name)
	set_level_flavor_text(level_flavor_text)
	set_main_action_text(main_action_text)
	set_second_action_text(second_action_text)
	set_bonus_action_text(bonus_action_text)
	_current_multiplier = 1
	_slider.connect("valence_increased", self, "valence_up")
	_slider.connect("valence_decreased", self, "valence_down")
	_bonus.connect("bonus_used", self, "_propagate_bonus")
	set_slider_location(slider_location)
	set_bonus_location(bonus_location)
	set_score_location(score_location)
	show_intro_layer()


# Shows the introduction layer
func show_intro_layer() -> void:
	if _intro_layer:
		_intro_layer.set_layer(20)


# Hides the introduction layer
func hide_intro_layer() -> void:
	if _intro_layer:
		_intro_layer.set_layer(-20)


# Sets the initial valence for the slider
func set_initial_valence(valence: float) -> void:
	print("initial valence: " + str(valence))
	_slider.change_valence(valence)


# Sets the variable slider_location to the given value
func set_slider_location(loc: int) -> void:
	slider_location = loc
	if is_inside_tree():
		if slider_location != _slider.location:
			_slider.set_location(loc)


# Returns the value of the variable slider_location
func get_slider_location() -> int:
	return slider_location


# Sets the variable bonus_location to the given value
func set_bonus_location(loc: int) -> void:
	bonus_location = loc
	if is_inside_tree():
		if bonus_location != _bonus.get_location():
			_bonus.set_location(loc)


# Returns the value of the variable bonus_location
func get_bonus_location() -> int:
	return bonus_location


# Sets the variable score_location to the given value
func set_score_location(loc: int) -> void:
	score_location = loc
	if is_inside_tree():
		if score_location != _score.get_location():
			_score.set_location(loc)


# Returns the value of the variable score_location
func get_score_location() -> int:
	return score_location


# Handles a valence increase
func valence_up() -> void:
	emit_signal("valence_change", true)
	_bonus.load_bonus()


# Handles a valence decrease
func valence_down() -> void:
	emit_signal("valence_change", false)
	_bonus.load_bonus()


# Attempts to use a bonus, returns true if it was used
func apply_bonus() -> bool:
	return _bonus.use_bonus()


# Sets the variable active to the given value
func set_active(on: bool) -> void:
	active = on
	_score.set_active(on)
	if _intro_layer:
		hide_intro_layer()
		remove_intro()


# Returns the value of the variable active
func get_active() -> bool:
	return active


# Propagates the bonus_used signal
func _propagate_bonus() -> void:
	emit_signal("bonus_used")


# Raises the current multiplier
func raise_multiplier() -> void:
	_current_multiplier += 1
	if _current_multiplier > 1:
		_score.raise_multiplier()


# Lowers the current multiplier
func lower_multiplier() -> void:
	if _current_multiplier > 1:
		_score.lower_multiplier()
	_current_multiplier -= 1


# Shows the pause screen
func show_pause() -> void:
	_pause_layer.set_layer(128)


# Hides the pause screen
func hide_pause() -> void:
	_pause_layer.set_layer(-128)


# Removes the intro screen
func remove_intro() -> void:
	if _intro_layer:
		_intro_layer.queue_free()


# Returns the current load speed for the bonus
func get_bonus_load_spd() -> float:
	return _bonus.get_load_speed()


# Sets a new load speed for the bonus
func set_bonus_load_spd(spd: float) -> void:
	_bonus.set_load_speed(spd)


# Returns the current load speed for the bonus
func get_score_spd() -> float:
	return _score.get_score_spd()


# Sets a new load speed for the bonus
func set_score_spd(spd: float) -> void:
	_score.set_score_spd(spd)


# Sets the text of a variable in the intro screen
func set_intro_screen_text(text: String, target_path: String, button := false):
	if _intro_layer:
		var target_node = _intro_layer.get_node(target_path)
		if button:
			target_node.set_button_text(text)
		else:
			target_node.set_text(text)


# Gets the text of a variable in the intro screen
func get_intro_screen_text(target_path: String, button := false) -> String:
	var text := ""
	if _intro_layer:
		var target_node = _intro_layer.get_node(target_path)
		if button:
			target_node.get_button_text()
		else:
			target_node.get_text()
	return text


# Sets the variable level_name to the given value
func set_level_name(lvl_name: String) -> void:
	set_intro_screen_text(lvl_name, "Panel/PanelLayout/LevelName")
	level_name = lvl_name


# Returns the value of the variable level_name
func get_level_name() -> String:
	return level_name


# Sets the variable level_flavor_text to the given value
func set_level_flavor_text(flavor_text: String) -> void:
	set_intro_screen_text(flavor_text, "Panel/PanelLayout/LevelFlavorText")
	level_flavor_text = flavor_text


# Returns the value of the variable level_flavor_text
func get_level_flavor_text() -> String:
	return level_flavor_text


# Sets the variable bonus_action_text to the given value
func set_bonus_action_text(action_text: String) -> void:
	set_intro_screen_text(
		action_text, "Panel/PanelLayout/LevelButtons/BonusAction", true
	)
	bonus_action_text = action_text


# Returns the value of the variable bonus_action_text
func get_bonus_action_text() -> String:
	return bonus_action_text


# Sets the variable main_action_text to the given value
func set_main_action_text(action_text: String) -> void:
	set_intro_screen_text(
		action_text, "Panel/PanelLayout/LevelButtons/PrimaryAction", true
	)
	main_action_text = action_text


# Returns the value of the variable main_action_text
func get_main_action_text() -> String:
	return main_action_text


# Sets the variable second_action_text to the given value
func set_second_action_text(action_text: String) -> void:
	set_intro_screen_text(
		action_text, "Panel/PanelLayout/LevelButtons/SecondaryAction", true
	)
	second_action_text = action_text


# Returns the value of the variable second_action_text
func get_second_action_text() -> String:
	return second_action_text
