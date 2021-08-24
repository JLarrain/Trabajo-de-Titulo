extends RigidBody2D

# * Signals
signal off_screen
signal cube_collision

# * Variables

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Handles cube collitions
func collide_with_cube() -> void:
	emit_signal("cube_collision")


# Notifies getting out of the screen
func off_screen() -> void:
	emit_signal("off_screen")


# Returns true always
func is_character() -> bool:
	return true
