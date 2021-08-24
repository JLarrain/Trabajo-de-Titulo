extends Node2D

# * Signals

# * Variables

var speed := -300.0 setget set_speed, get_speed
var _red_plats: Node2D
var _blue_plats: Node2D
var _front_is_red: bool
var _front_plats: Node2D
var _back_plats: Node2D
var _red_timer: Timer
var _blue_timer: Timer
var _red_layer: int
var _blue_layer: int
var _bonus_timer: Timer
var _bonus_ticks: int
const Platform := preload("res://scenes/levels/color_runner/platform.tscn")
const Cube := preload("res://scenes/levels/color_runner/cube.tscn")

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	_red_plats = $Red
	_blue_plats = $Blue
	_red_timer = $RedTimer
	_blue_timer = $BlueTimer
	_bonus_timer = $BonusTimer
	_bonus_ticks = 25
	_red_layer = 0
	_blue_layer = 1
	_red_plats.get_child(0).change_scale(15, 10)
	_blue_plats.get_child(0).change_scale(15, 15)
	_front_is_red = true
	_front_plats = _red_plats
	_back_plats = _blue_plats
	set_speed(speed)


# Switch the platforms in front for the ones in the back
func switch_layers() -> void:
	#remove_child(_back_plats)
	#add_child_below_node(_front_plats, _back_plats)
	#var _aux = _front_plats
	#_front_plats = _back_plats
	#_back_plats = _aux
	_front_is_red = (not _front_is_red)


# Executes the bonus until there's no ticks left
func bonus_tick() -> void:
	get_tree().call_group(
		"obstacles", "set_collision_layer_bit", _red_layer, not _front_is_red
	)
	get_tree().call_group(
		"obstacles", "set_collision_mask_bit", _red_layer, not _front_is_red
	)
	get_tree().call_group(
		"obstacles", "set_collision_layer_bit", _blue_layer, _front_is_red
	)
	get_tree().call_group(
		"obstacles", "set_collision_mask_bit", _blue_layer, _front_is_red
	)
	_bonus_ticks -= 1
	if _bonus_ticks > 0:
		_bonus_timer.start()
	else:
		_bonus_ticks = 25


# Creates a new platform, if red is true the platform is red, else is blue
func create_platform(red: bool) -> void:
	var _added_delay := randf() * 0.5
	var _sign := sign(randf() - 0.5)
	_added_delay *= _sign
	var _plats: Node2D
	var plat_len = (randi() % 10) + 6
	var plat_height = (randi() % 15) + 1
	var new_plat = Platform.instance()
	var timer: Timer
	var layer: int
	if red:
		timer = _red_timer
		_plats = _red_plats
		layer = _red_layer
	else:
		timer = _blue_timer
		_plats = _blue_plats
		layer = _blue_layer
	timer.start(3 + _added_delay)
	_plats.add_child(new_plat)
	new_plat.change_scale(plat_len, plat_height)
	new_plat.set_collision_layer_bit(layer, true)
	new_plat.set_linear_velocity(Vector2(speed, 0))
	if (randi() % 2) > 0:
		var cube = create_cube(plat_len, plat_height, layer)
		cube.set_linear_velocity(Vector2(speed, 0))
		_plats.add_child(cube)


# Creates an obstacle
func create_cube(plat_len: int, plat_height: int, layer: int) -> RigidBody2D:
	var cube = Cube.instance()
	var ponderator = 12
	var _sign := sign(randf() - 0.5)
	var _rand = randi() % (plat_len + 1)
	cube.set_position(
		Vector2(
			ponderator * _sign * (plat_len - _rand),
			ponderator * -1 * (plat_height + 1)
		)
	)
	cube.set_collision_layer_bit(layer, true)
	return cube


# Sets the variable speed to the given value
func set_speed(spd: float) -> void:
	var red_children := _red_plats.get_children()
	var blue_children := _blue_plats.get_children()
	speed = spd
	for child in red_children:
		child.set_linear_velocity(Vector2(speed, 0))
	for child in blue_children:
		child.set_linear_velocity(Vector2(speed, 0))


# Returns the value of the variable speed
func get_speed() -> float:
	return speed
