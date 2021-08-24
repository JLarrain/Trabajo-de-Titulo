extends SelfFocusingButton

class_name ButtonId

# * Signals
# Thrown when the button is pressed
signal pressed_id(id)

# * Variables
# Id of the button
export (int) var id: int setget set_id, get_id

# * Functions


# Returns the id saved
func get_id() -> int:
	return id


# Sets the button id
func set_id(new_id: int) -> void:
	id = new_id


# Emits the custom signal on press
func _on_self_press() -> void:
	emit_signal("pressed_id", id)
