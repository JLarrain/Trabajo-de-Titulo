class_name RailSystem
extends Node2D

# * Signals

# * Variables
var _remote_rotator: RemoteTransform2D
var _rails: Node2D

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_remote_rotator = $Circle/Follower/RemoteRotator
	_rails = $Rails


# Adds a playing rail
func add_rail() -> PlayerRail:
	return _rails.add_rail()


# Removes a playing rail
func remove_rail() -> void:
	_rails.remove_rail()


# Changes the direction of movement
func toggle_direction() -> void:
	_rails.toggle_direction()


# Sets the rotation speed to the given value
func set_rot_speed(spd: float) -> void:
	_remote_rotator.set_speed(spd)


# Returns the value of the rotation speed
func get_rot_speed() -> float:
	return _remote_rotator.get_speed()


# Sets the player_speed to the given value
func set_player_speed(spd: float) -> void:
	_rails.set_player_speed(spd)


# Returns the value of the player_speed
func get_player_speed() -> float:
	return _rails.get_player_speed()
