extends Node2D

# * Signals

# * Variables
var Rail := preload("res://scenes/levels/inward_outward/player_rail.tscn")
var n_rails: int
var rails: Array
var player_speed: float

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_speed = 0.2
	n_rails = 0
	rails = []


# Adds a playing rail
func add_rail() -> PlayerRail:
	n_rails += 1
	var rail = Rail.instance()
	var deg_dist := 360.0 / n_rails
	add_child(rail)
	rails.append(rail)
	for i in range(n_rails):
		_rotate_rail(rails[i], i * deg_dist)
	_propagate_offset()
	_propagate_speed()
	_reset_pulses()
	return rail


# Removes a playing rail
func remove_rail() -> void:
	if n_rails <= 2:
		return
	n_rails -= 1
	var rail = rails.pop_back()
	remove_child(rail)
	rail.queue_free()
	var deg_dist := 360.0 / n_rails
	for i in range(n_rails):
		_rotate_rail(rails[i], i * deg_dist)


# Changes the direction of movement
func toggle_direction() -> void:
	if not rails.empty():
		var current_speed = rails[0].get_rail_speed()
		get_tree().call_group_flags(
			SceneTree.GROUP_CALL_REALTIME,
			"player_rails",
			"set_rail_speed",
			current_speed * -1
		)


# Sets the player speed
func set_player_speed(spd: float) -> void:
	player_speed = abs(spd)
	_propagate_speed()


# Retrieves the player speed
func get_player_speed() -> float:
	return player_speed


# Sets the rotation of a rail
func _rotate_rail(rail: PlayerRail, degrees: float) -> void:
	rail.set_rotation_degrees(degrees)


# Propagates a change of speed to all rails
func _propagate_speed() -> void:
	if not rails.empty():
		var current_sign = sign(rails[0].get_rail_speed())
		get_tree().call_group_flags(
			SceneTree.GROUP_CALL_REALTIME,
			"player_rails",
			"set_rail_speed",
			player_speed * current_sign
		)


# Propagates the current offset to coordinate rails
func _propagate_offset() -> void:
	if not rails.empty():
		var offset = rails[0].get_offset()
		get_tree().call_group_flags(
			SceneTree.GROUP_CALL_REALTIME, "player_rails", "set_offset", offset
		)


# Propagates a reset of pulses to coordinate rails
func _reset_pulses() -> void:
	get_tree().call_group_flags(
		SceneTree.GROUP_CALL_REALTIME, "player_rails", "reset_pulse"
	)
