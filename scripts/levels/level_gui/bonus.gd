extends TextureProgress

# * Variables
var _start_color: Color
var _end_color: Color

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_color = Color(0.0, 0.0, 1.0)
	_end_color = Color(0.1, 0.83, 0.56)


# Starts the load animation
func start_load(tween: Tween, spd: float) -> void:
	tween.interpolate_property(
		self,
		"value",
		0,
		100,
		10 * (1.0 / spd),
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.connect(
		"tween_completed", self, "_end_load", [tween], CONNECT_ONESHOT
	)
	tween.start()


# Manages the load ending
func _end_load(_object, _str, tween) -> void:
	tween.remove(self)
	set_tint_progress(_end_color)


# Starts the unload animation
func start_unload(tween: Tween) -> void:
	set_tint_progress(_start_color)
	tween.interpolate_property(
		self, "value", 100, 0, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		self,
		"tint_progress",
		_end_color,
		_start_color,
		0.8,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.connect(
		"tween_completed", self, "_end_unload", [tween], CONNECT_ONESHOT
	)
	tween.start()


# Manages the unload ending
func _end_unload(_object, _str, tween) -> void:
	tween.remove(self)
