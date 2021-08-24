extends RigidBody2D

# * Signals

# * Variables

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Returns false always
func is_character() -> bool:
	return false


# Eliminates this node when it leaves the screen
func _screen_exited():
	queue_free()


# Handles a collision
func handle_collision(node: Node2D) -> void:
	if node.is_character():
		node.collide_with_cube()
		queue_free()
