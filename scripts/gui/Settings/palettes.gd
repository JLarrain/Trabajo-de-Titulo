extends HBoxContainer

# * Signals

# Sent when the selected palette is changed
signal palette_changed(pal_n)

# * Variables

# The amount _scroller has to move when changing between adjacent palettes
var _displacement_amount: float
# The node containing all the palette nodes
var _palette_container: HBoxContainer
# The previous value of _scrollbar maximum value
var _scroll_prev_max: float
# The hidden _scrollbar in _scroller
var _scrollbar: HScrollBar
# The node that graphically switches palette nodes
var _scroller: ScrollContainer
# The currently selected palette
var _selected_palette: int
# The total amount of palettes
var _total_palettes: int

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_selected_palette = 0
	_total_palettes = $ScrollContainer/Palettes.get_child_count()
	_scroller = $ScrollContainer
	_palette_container = $ScrollContainer/Palettes
	_scrollbar = _scroller.get_h_scrollbar()
	_displacement_amount = _scroller.get_size()[0]
	_scroll_prev_max = _scrollbar.get_max()
	_scrollbar.connect("changed", self, "_check_change")


# Sets the next palette as the selected palette,
# handling them as in a circular array
func next_palette() -> void:
	set_palette((_selected_palette + 1) % _total_palettes)


# Sets the previous palette as the selected palette
# handling them as in a circular array
func previous_palette() -> void:
	set_palette(posmod(_selected_palette - 1, _total_palettes))


# Sets the given palette as the selected palette, and omit
# the signal when is not needed
func set_palette(palette_n: int, omit_signal := false) -> void:
	# Update the current palette
	_selected_palette = palette_n
	# Set _scroller to show the selected palette
	_scroller.set_h_scroll(int(palette_n * _displacement_amount))
	# Send signal when appropiate
	if ! omit_signal:
		emit_signal("palette_changed", palette_n)


# Checks if the max_value of _scrollbar has changed,
# and if it has, updates the displacements
func _check_change() -> void:
	# As this is to compare when to resize pixels,
	# there's no need for more precision
	var epsilon: float = 0.1
	var new_val: float = _scrollbar.get_max()
	# If there is a relevant change, update the displacements
	if abs(_scroll_prev_max - new_val) > epsilon:
		_update_displacement()
	# Save the new value
	_scroll_prev_max = new_val


# Updates the displacement amount and palette sizes
func _update_displacement() -> void:
	# Get the current size of _scroller
	_displacement_amount = _scroller.get_size()[0]
	# Update the minimum size of _palette_container
	_palette_container.set_custom_minimum_size(
		Vector2(_displacement_amount * _total_palettes, 0)
	)
	# Update the size of _palette_container,
	# setting the update on the size of the palettes
	_palette_container.set_size(
		Vector2(_displacement_amount * _total_palettes, _scroller.get_size()[1])
	)
	# Fix any displacement errors caused in the resizing
	set_palette(_selected_palette, true)
