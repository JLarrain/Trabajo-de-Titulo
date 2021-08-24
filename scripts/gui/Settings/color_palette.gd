extends HBoxContainer

# * Variables

# The name of the palette
export var palette_name: String = "Standard" setget set_palette_name, \
		get_palette_name
# The color representing the hyped state
export var hyped_color: Color = Color(1.0, 0, 0) setget \
		set_hyped_color, get_hyped_color
# The color representing the relaxed state
export var relaxed_color: Color = Color(0, 0, 1.0) setget \
		set_relaxed_color, get_relaxed_color

# * Functions


# Returns an array with the colors of the palette, hyped first
func get_colors() -> PoolColorArray:
	var color_array = PoolColorArray()
	color_array.append(hyped_color)
	color_array.append(relaxed_color)
	return color_array


# Returns the palette hyped color
func get_hyped_color() -> Color:
	return hyped_color


# Returns the palette name
func get_palette_name() -> String:
	return palette_name


# Returns the palette relaxed color
func get_relaxed_color() -> Color:
	return relaxed_color


# Sets the palette hyped color to the given color
func set_hyped_color(color: Color) -> void:
	hyped_color = color
	$Color2/Color.set_frame_color(color)


# Sets the palette name to the given string
func set_palette_name(name: String) -> void:
	palette_name = name
	$Name.set_text(name)


# Sets the palette relaxed color to the given color
func set_relaxed_color(color: Color) -> void:
	relaxed_color = color
	$Color1/Color.set_frame_color(color)
