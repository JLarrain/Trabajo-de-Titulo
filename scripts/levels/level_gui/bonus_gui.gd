extends Control

# * Signals
signal bonus_ready
signal bonus_used

# * Variables
const Location = LevelGui.Corners
export (Location) var location := Location.UPPER_RIGHT setget set_location, get_location
var load_speed := 1.0 setget set_load_speed, get_load_speed
var _anchors := {
	Location.UPPER_LEFT:
	{MARGIN_LEFT: 0, MARGIN_RIGHT: 0.133, MARGIN_TOP: 0, MARGIN_BOTTOM: 0.11},
	Location.UPPER_RIGHT:
	{MARGIN_LEFT: 0.867, MARGIN_RIGHT: 1, MARGIN_TOP: 0, MARGIN_BOTTOM: 0.11},
	Location.LOWER_LEFT:
	{MARGIN_LEFT: 0, MARGIN_RIGHT: 0.133, MARGIN_TOP: 0.89, MARGIN_BOTTOM: 1},
	Location.LOWER_RIGHT:
	{MARGIN_LEFT: 0.867, MARGIN_RIGHT: 1, MARGIN_TOP: 0.89, MARGIN_BOTTOM: 1},
}
var _bonuses: Array
var _current_load: int
var _disponibility: Array
var _load_tween: Tween
var _unload_tween: Tween

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_disponibility = [false, false, false]
	_bonuses = $Bonus.get_children()
	_current_load = -1
	_load_tween = $LoadTween
	_unload_tween = $UnloadTween


# Sets the variable location to the given value
func set_location(loc: int) -> void:
	if loc in Location.values():
		location = loc
		_update_anchors(location)


# Returns the value of the variable location
func get_location() -> int:
	return location


# Sets the variable load_speed to the given value
func set_load_speed(spd: float) -> void:
	load_speed = spd


# Returns the value of the variable load_speed
func get_load_speed() -> float:
	return load_speed


# Attempts to load a bonus
func load_bonus() -> void:
	_start_load_tween()


# Attempts to use a bonus, returns true if used
func use_bonus() -> bool:
	var result := false
	if true in _disponibility:
		result = true
	_start_unload_tween()
	return result


# Starts the loading animation for a bonus, if possible
func _start_load_tween() -> void:
	if not _load_tween.is_active():
		for i in range(_bonuses.size()):
			if not _disponibility[i]:
				_current_load = i
				_bonuses[i].start_load(_load_tween, load_speed)
				break


# Handles the ending of the loading animation
func _end_load_tween() -> void:
	_disponibility[_current_load] = true
	_current_load = -1
	emit_signal("bonus_ready")


# Starts the unloading animation for a bonus
func _start_unload_tween() -> void:
	var aux = range(_bonuses.size())
	aux.invert()
	for i in aux:
		if _disponibility[i]:
			_disponibility[i] = false
			_bonuses[i].start_unload(_unload_tween)
			emit_signal("bonus_used")
			break


# Changes the anchors according to the given location
func _update_anchors(selected_loc: int) -> void:
	var new_anchors = _anchors[selected_loc]
	var margins = [MARGIN_LEFT, MARGIN_RIGHT, MARGIN_TOP, MARGIN_BOTTOM]
	for margin in margins:
		self.set_anchor(margin, new_anchors[margin], true)
