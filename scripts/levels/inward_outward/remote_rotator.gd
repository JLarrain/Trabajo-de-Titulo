# * Signals
extends RemoteTransform2D

# * Variables
# Speed of rotation in proportion to a second, aka 1.0 => 1 rotation per second
export var speed := 0.5 setget set_speed, get_speed
# Parent of this node
var parent: PathFollow2D


# * Functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()


# Called on frame update
func _process(delta) -> void:
	parent.set_unit_offset(parent.get_unit_offset() + (delta * speed))


# Sets the speed of the rotation
func set_speed(spd: float) -> void:
	speed = spd


# Returns the current speed of the rotation
func get_speed() -> float:
	return speed
