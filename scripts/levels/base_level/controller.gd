class_name Controller
extends Node2D

# * Signals

# * Variables
var _last_hr_progress: float
var _last_difficulty: float

# * Functions


# Called when the node enters the scene tree for the first time
func _ready() -> void:
	_last_hr_progress = 0.0
	_last_difficulty = 0.0
	add_to_group("controllers")


# Called when the difficulty is updated and should be overridden. By default
# only saves the new difficulty
func difficulty_updated(new_diff: float) -> void:
	_last_difficulty = new_diff


# Returns the current difficulty
func get_difficulty() -> float:
	return _last_difficulty


# Called when the heart rate progress is updated and should be overridden. By
# default only saves the heart rate progress
func hr_changed(new_hr_progress: float) -> void:
	_last_hr_progress = new_hr_progress


# Returns the current heart rate progress
func get_hr_progress() -> float:
	return _last_hr_progress


# Called when the main action is used and should be overridden. By default it
# does nothing
func main_used() -> void:
	pass


# Called when the secondary action is used and should be overridden. By default
# it does nothing
func secondary_used() -> void:
	pass


# Called when a bonus is used and should be overridden. By default it does
# nothing
func bonus_used() -> void:
	pass
