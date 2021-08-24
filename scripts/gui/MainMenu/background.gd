extends TextureRect

# * Variables

# The speed of a color cycle
export var cycle_speed: float
# The gradient node
var _grad: Gradient
# Iteration array for the offsets and colors
var _iter: Array
# The gradient offsets
var _offsets: PoolRealArray

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_grad = texture.gradient
	_offsets = _grad.get_offsets()
	settings.request_color_updates(self, "update_colors")
	_iter = range(0, _offsets.size())
	update_colors()


# Animate the background
func _process(delta: float) -> void:
	var distance: float = delta * cycle_speed
	var _first_offset: float = _offsets[0]
	# If the first offset goes below -1.0,
	# change the colors to make a fluid animation
	if _first_offset - distance < -1.0:
		var colors: PoolColorArray = _grad.get_colors()
		colors.append(colors[1])
		colors.remove(0)
		_offsets.append(_offsets[-1] + 1.0)
		_offsets.remove(0)
		_grad.set_colors(colors)
	# Calculate new offsets
	for i in _iter:
		_offsets[i] -= distance
	_grad.set_offsets(_offsets)


# Updates the colors of the _gradient
func update_colors() -> void:
	var colors = settings.get_colors()
	for i in _iter:
		_grad.set_color(i % _offsets.size(), colors[i % colors.size()])
