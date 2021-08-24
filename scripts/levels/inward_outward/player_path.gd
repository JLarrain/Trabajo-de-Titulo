extends PathFollow2D

# * Variables
# Speed to traverse the curve, relative to a second
var speed: float setget set_speed, get_speed
# Sprite for the player ball
var ball: AnimatedSprite
# Sprite for the pulsating effect
var pulse: Sprite
# Tween that controls the pulsating effect
var pulse_tween: Tween

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 0.25
	ball = $PlayerBall
	pulse = $Pulse
	pulse_tween = $PulseTween
	pulse_tween.interpolate_property(
		pulse,
		"scale",
		Vector2(0.04, 0.04),
		Vector2(0.12, 0.12),
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	pulse_tween.interpolate_property(
		pulse,
		"modulate:a",
		1.0,
		0.1,
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	pulse_tween.start()


#
func _process(delta: float) -> void:
	var delta_offset := delta * speed
	var current_offset := get_unit_offset()
	var new_offset := current_offset + delta_offset
	if new_offset > 1.0:
		new_offset = 2.0 - new_offset
		change_direction()
	elif new_offset < 0.0:
		new_offset = new_offset * -1
		change_direction()
	set_unit_offset(new_offset)


#
func set_speed(spd: float) -> void:
	speed = spd
	_change_pulse_speed(spd)


#
func get_speed() -> float:
	return speed


#
func change_direction() -> void:
	set_speed(speed * -1)


#
func reset_pulse() -> void:
	pulse_tween.reset_all()


#
func get_damaged() -> void:
	self.set_modulate(Color(1, 0, 0))
	ball.play("damaged")


#
func get_healed() -> void:
	self.set_modulate(Color(1, 1, 1))
	ball.play("default")


#
func _change_pulse_speed(spd: float) -> void:
	pulse_tween.set_speed_scale(abs(spd))
