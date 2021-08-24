extends Control

# * Variables
const Location = LevelGui.Corners
enum Mode { AUTO_ADD, MANUAL_ADD }
export (Location) var location := Location.UPPER_LEFT setget set_location, get_location
export (Mode) var score_mode := Mode.AUTO_ADD setget set_score_mode, get_score_mode
var score := 0 setget set_score, get_score
var active := false setget set_active, get_active
var multiplier := 1
var _acc_delta := 0.0
var _auto_score := 10
var _auto_score_secs := 1.0
var _max_multiplier := 30
var _score_gui: Label
var _multiplier_gui: Label
var _anchors := {
	Location.UPPER_LEFT:
	{MARGIN_LEFT: 0, MARGIN_RIGHT: 0.11, MARGIN_TOP: 0, MARGIN_BOTTOM: 0.1},
	Location.UPPER_RIGHT:
	{MARGIN_LEFT: 0.89, MARGIN_RIGHT: 1, MARGIN_TOP: 0, MARGIN_BOTTOM: 0.1},
	Location.LOWER_LEFT:
	{MARGIN_LEFT: 0, MARGIN_RIGHT: 0.11, MARGIN_TOP: 0.9, MARGIN_BOTTOM: 1},
	Location.LOWER_RIGHT:
	{MARGIN_LEFT: 0.89, MARGIN_RIGHT: 1, MARGIN_TOP: 0.9, MARGIN_BOTTOM: 1},
}

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_score_gui = $PointsLabel
	_multiplier_gui = $BonusLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		if score_mode == Mode.AUTO_ADD:
			_acc_delta += delta
			if _acc_delta > _auto_score_secs:
				_acc_delta -= _auto_score_secs
				score += multiplier * _auto_score
		_score_gui.set_text(str(score))
		_multiplier_gui.set_text(str(multiplier))


# Sets the variable active to the given value
func set_active(state: bool) -> void:
	active = state


# Returns the value of the variable active
func get_active() -> bool:
	return active


# Sets the variable location to the given value
func set_location(loc: int) -> void:
	if loc in Location.values():
		location = loc
		_update_anchors(location)


# Returns the value of the variable location
func get_location() -> int:
	return location


# Sets the variable mode to the given value
func set_score_mode(new_mode: int) -> void:
	if new_mode in Mode.values():
		score_mode = new_mode


# Returns the value of the variable mode
func get_score_mode() -> int:
	return score_mode


# Sets the variable score to the given value
func set_score(points: int) -> void:
	score = points


# Returns the value of the variable score
func get_score() -> int:
	return score


# Sets the variable score to the given value
func set_score_spd(spd: float) -> void:
	_auto_score_secs = 1.0 / spd


# Returns the value of the variable score
func get_score_spd() -> float:
	return 1.0 / _auto_score_secs


# Adds points manually to the current score
func add_score(points: int) -> void:
	if active:
		score += points


# Raises the current multiplier
func raise_multiplier() -> void:
	if multiplier < _max_multiplier:
		multiplier += 1


# Lowers the current multiplier
func lower_multiplier() -> void:
	if multiplier > 1:
		multiplier -= 1


# Changes the anchors according to the given location
func _update_anchors(selected_loc: int) -> void:
	var new_anchors = _anchors[selected_loc]
	var margins = [MARGIN_LEFT, MARGIN_RIGHT, MARGIN_TOP, MARGIN_BOTTOM]
	for margin in margins:
		self.set_anchor(margin, new_anchors[margin], true)
