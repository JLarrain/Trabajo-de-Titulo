tool
extends Control

# * Signals

# Thrown when a drop in valence is indicated
signal valence_decreased
# Thrown when a rise in valence is indicated
signal valence_increased

# * Variables
# Locations to place this object
const Location = LevelGui.Edges
# Location where the object currently is
export (Location) var location := Location.TOP setget set_location, get_location
# True if this affective slider is in vertical position
export (bool) var vertical := false setget set_vertical
# Time to wait between inputs to be valid
export var input_sample_delay: float
# Scale modifier for use in the editor
export var scale_ponderator := 1.0 setget scale
# Anchor definitions for the different locations
var _anchors := {
	Location.TOP:
	{
		MARGIN_LEFT: 0.5,
		MARGIN_RIGHT: 0.5,
		MARGIN_TOP: 0.05,
		MARGIN_BOTTOM: 0.05
	},
	Location.BOTTOM:
	{
		MARGIN_LEFT: 0.5,
		MARGIN_RIGHT: 0.5,
		MARGIN_TOP: 0.95,
		MARGIN_BOTTOM: 0.95
	},
	Location.LEFT:
	{
		MARGIN_LEFT: 0.03,
		MARGIN_RIGHT: 0.03,
		MARGIN_TOP: 0.5,
		MARGIN_BOTTOM: 0.5
	},
	Location.RIGHT:
	{
		MARGIN_LEFT: 0.97,
		MARGIN_RIGHT: 0.97,
		MARGIN_TOP: 0.5,
		MARGIN_BOTTOM: 0.5
	},
}
# Accumulated time between inputs
var _acc_delta: float
# Gradient of this slider
var _grad: Gradient
# Color that represents high valence
var _high_color: Color setget change_higher_color
# Color that represents low valence
var _low_color: Color setget change_lower_color
# Light mask for the horizontal position
var _h_light: Light2D
# Light mask for the vertical position
var _v_light: Light2D
# Internal slider for the current valence of the user
var _slider: Slider
# Helper to defer the set_vertical call when executed before _ready
var _defer_vertical := false
# Helper to save value if set_vertical is called before _ready
var _vert_deferred: bool

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("affective_slider")
	
	_h_light = $GradSprite/HLight
	_v_light = $GradSprite/VLight
	_acc_delta = 0.0
	_grad = $GradSprite.texture.gradient
	_slider = $Slider
	if _defer_vertical:
		set_vertical(_vert_deferred)
		_defer_vertical = false
	if not Engine.editor_hint:
		update_colors()
		settings.request_color_updates(self, "update_colors")


# Receives valence input
func _process(delta: float) -> void:
	_acc_delta += delta
#	if _acc_delta >= input_sample_delay:
#		var previous_slider_val = _slider.value
#		if Input.is_action_pressed("valence_up"):
#			_slider.value += 1
#			if not is_equal_approx(previous_slider_val, _slider.value):
#				emit_signal("valence_increased")
#			_acc_delta = 0.0
#		if Input.is_action_pressed("valence_down"):
#			_slider.value -= 1
#			if not is_equal_approx(previous_slider_val, _slider.value):
#				emit_signal("valence_decreased")
#			_acc_delta = 0.0


func valence_up_used() -> void:
	print("VAL_UP")
	if _acc_delta >= input_sample_delay:
		print("VAL_UP_TRUE")
		var previous_slider_val = _slider.value
		
		_slider.value += 1
		
		print("VAL_UP previous_slider_val: %s" % previous_slider_val)
		print("VAL_UP _slider.value: %s" % _slider.value)
		
		if not is_equal_approx(previous_slider_val, _slider.value):
			emit_signal("valence_increased")
		_acc_delta = 0.0


func valence_down_used() -> void:
	print("VAL_DOWN")
	if _acc_delta >= input_sample_delay:
		print("VAL_DOWN_TRUE")
		var previous_slider_val = _slider.value
		
		_slider.value -= 1
		
		print("VAL_DOWN previous_slider_val: %s" % previous_slider_val)
		print("VAL_DOWN _slider.value: %s" % _slider.value)
		
		if not is_equal_approx(previous_slider_val, _slider.value):
			emit_signal("valence_decreased")
		_acc_delta = 0.0


# Changes the valence on the slider, without sending signals
func change_valence(slider_pos: float) -> void:
	_slider.value = (slider_pos * 2)


# Change both colors representing valence
func change_colors(low: Color, high: Color):
	_low_color = low
	_high_color = high
	_apply_colors()


# Change the color representing higher valence
func change_higher_color(color: Color):
	_high_color = color
	_apply_colors()


# Change the color representing lower valence
func change_lower_color(color: Color):
	_low_color = color
	_apply_colors()


# Set the scale keeping aspect ratio
func scale(scale: float) -> void:
	set_scale(Vector2(scale, scale))
	scale_ponderator = scale


# Override from native function to allow for positioning by center point
func set_position(pos: Vector2, center := true) -> void:
	if center:
		var current_size = get_size()
		pos[0] -= (current_size[0] / 2)
		pos[1] -= (current_size[1] / 2)
	.set_position(pos)


# Rotate the control to or from vertical position
func set_vertical(vert: bool) -> void:
	if not is_inside_tree():
		_defer_vertical = true
		_vert_deferred = vert

	elif vertical != vert:
		if vert:
			_h_light.set_enabled(false)
			set_rotation_degrees(-90)
			_v_light.set_enabled(true)
		else:
			_v_light.set_enabled(false)
			set_rotation_degrees(0)
			_h_light.set_enabled(true)
		vertical = vert


# Sets the variable location to the given value
func set_location(loc: int) -> void:
	if loc in Location.values():
		location = loc
		_update_anchors(location)
	if location == Location.TOP or location == Location.BOTTOM:
		set_vertical(false)
	else:
		set_vertical(true)


# Returns the value of the variable location
func get_location() -> int:
	return location


# Updates the colors according to the current colors in settings
func update_colors() -> void:
	var _new_colors = settings.get_colors()
	change_colors(_new_colors[0], _new_colors[1])


# Apply the currently selected colors
func _apply_colors() -> void:
	if _grad != null:
		_grad.set_color(0, _low_color)
		_grad.set_color(2, _high_color)


# Changes the anchors according to the given location
func _update_anchors(selected_loc: int) -> void:
	var new_anchors = _anchors[selected_loc]
	var margins = [MARGIN_LEFT, MARGIN_RIGHT, MARGIN_TOP, MARGIN_BOTTOM]
	for margin in margins:
		self.set_anchor(margin, new_anchors[margin], true)


# Executes set_vertical after the _ready call if needed
func _defer_set_vertical(vert: bool) -> void:
	set_vertical(vert)
