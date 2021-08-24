class_name PlayerRail
extends Path2D

# * Signals
signal ball_hit
signal ball_enabled

# * Variables
export var speed := 0.25 setget set_rail_speed, get_rail_speed
var follower: PathFollow2D
export var offset := 0.0 setget set_offset, get_offset
var damage_timer: Timer

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	follower = $PlayerPath
	damage_timer = $DamageTimer
	follower.set_speed(speed)
	add_to_group("player_rails")


func _draw() -> void:
	var points = get_curve().tessellate(5, 2.0)
	draw_polyline(points, Color.white, 2.0, true)


#
func set_rail_speed(spd: float) -> void:
	speed = spd
	if follower:
		follower.set_speed(spd)


#
func get_rail_speed() -> float:
	var spd = speed
	if follower:
		spd = follower.get_speed()
		speed = spd
	return spd


#
func set_offset(off: float) -> void:
	offset = off
	if follower:
		follower.set_unit_offset(off)


#
func get_offset() -> float:
	var off = offset
	if follower:
		off = follower.get_unit_offset()
		offset = off
	return off


#
func change_direction() -> void:
	follower.change_direction()


#
func reset_pulse() -> void:
	follower.reset_pulse()


#
func _check_for_hits(area: Area2D) -> void:
	if area.is_in_group("enemies") and damage_timer.is_stopped():
		follower.get_damaged()
		damage_timer.start()
		emit_signal("ball_hit")


#
func _heal() -> void:
	emit_signal("ball_enabled")
	follower.get_healed()
