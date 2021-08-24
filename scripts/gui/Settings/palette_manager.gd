extends HBoxContainer

# * Variables

# The saved palette on file
var _saved_palette: int
# The currently selected palette
var _selected_palette: int

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_saved_palette = 0
	_selected_palette = 0


# Returns the currently selected palette
func get_selected() -> int:
	return _selected_palette


# Sets the selected and saved palettes when loading from file,
# and propagates their values to the palette selector
func load_palettes(palette_n: int, omit_signal := false) -> void:
	_set_selected(palette_n)
	_set_saved(palette_n)
	$Palettes.set_palette(palette_n, omit_signal)


# Sets the saved palette variable
func _set_saved(pal_n: int) -> void:
	_saved_palette = pal_n


# Sets the selected pallete variable
func _set_selected(pal_n: int) -> void:
	_selected_palette = pal_n
