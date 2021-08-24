extends Button

class_name SelfFocusingButton

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("mouse_entered", self, "ask_focus")


# When this button is hovered and isn't disabled, grabs the focus
func ask_focus() -> void:
	if ! disabled:
		grab_focus()
