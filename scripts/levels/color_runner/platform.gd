extends RigidBody2D

# * Signals

# * Variables
var _sprite: Sprite
var _shape: CollisionShape2D

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_sprite = $Sprite
	_shape = $CollisionShape2D


# Returns false always
func is_character() -> bool:
	return false


# Changes the scale of the platform
func change_scale(x: float, y: float) -> void:
	_sprite.apply_scale(Vector2(x, y))
	_shape.apply_scale(Vector2(x, y))


# Eliminates this node when it leaves the screen
func _screen_exited():
	queue_free()
