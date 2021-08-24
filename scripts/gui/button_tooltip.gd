tool
extends HBoxContainer

# * Signals

# * Variables
# Button function text
export (String, MULTILINE) var button_text := "" setget set_button_text, get_button_text
# Button texture
export (Texture) var button_texture setget set_button_texture, get_button_texture
# Button texture's stretch ratio
export (float) var button_stretch_ratio setget set_button_stretch_ratio, get_button_stretch_ratio
# Button texture's TextureRect
var _texture_rect: TextureRect
# Button function's label
var _text_label: Label

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_text_label = $Effect
	_texture_rect = $ButtonTexture
	set_button_text(button_text)
	set_button_texture(button_texture)
	set_button_stretch_ratio(button_stretch_ratio)


# Sets the variable button_text to the given value
func set_button_text(text: String) -> void:
	if _text_label:
		_text_label.set_text(text)
	button_text = text


# Returns the value of the variable button_text
func get_button_text() -> String:
	return button_text


# Sets the variable button_texture to the given value
func set_button_texture(texture: Texture) -> void:
	if _texture_rect:
		_texture_rect.set_texture(texture)
	button_texture = texture


# Returns the value of the variable button_texture
func get_button_texture() -> Texture:
	return button_texture


# Sets the variable button_stretch_ratio to the given value
func set_button_stretch_ratio(ratio: float) -> void:
	if _texture_rect:
		_texture_rect.set_stretch_ratio(ratio)
	button_stretch_ratio = ratio


# Returns the value of the variable button_stretch_ratio
func get_button_stretch_ratio() -> float:
	return button_stretch_ratio
