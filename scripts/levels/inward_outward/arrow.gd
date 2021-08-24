extends Area2D

# * Signals

# * Variables
var tween: Tween
var trail: Sprite
var speed := 0.0 setget set_speed
var _delay: Array

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trail = $Trail
	tween = $TrailTween
	_delay = []
	tween.interpolate_property(
		trail, "offset:x", 15.0, 60.0, 1.0, Tween.TRANS_QUINT, Tween.EASE_IN
	)
	tween.start()
	add_to_group("enemies")


#
func _physics_process(delta: float) -> void:
	translate(Vector2(speed * delta, 0))


#
func set_speed(spd: float, delay := 1.0) -> void:
	if is_equal_approx(speed, 0.0):
		var timer = Timer.new()
		add_child(timer)
		timer.set_one_shot(true)
		_delay.append(spd)
		_delay.append(timer)
		timer.connect("timeout", self, "_delayed_start")
		timer.start(delay)
	else:
		speed = spd


# Eliminates this node when it leaves the screen
func _screen_exited():
	queue_free()


# Delays the start of the arrow
func _delayed_start() -> void:
	speed = _delay.pop_front()
	var timer = _delay.pop_front()
	remove_child(timer)
	timer.queue_free()
