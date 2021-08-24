class_name SpawnerSystem
extends Node2D

# * Signals

# * Variables
var spawners: Array
var enemy_speed: float
const Enemy := preload("res://scenes/levels/inward_outward/arrow.tscn")
var timer: Timer

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	spawners.append($Spawner1)
	spawners.append($Spawner2)
	enemy_speed = 200.0
	timer = $Timer
	timer.start()


# Called to spawn an enemy with a certain speed
func spawn_enemy(spd = enemy_speed) -> void:
	var index = randi() % spawners.size()
	var spawner = spawners[index]
	var real_spd = spd
	if (index % 2) > 0:
		real_spd *= -1
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.hide()
	spawner.spawn(enemy, real_spd)


# Sets the variable enemy_speed to the given value
func set_enemy_speed(spd: float) -> void:
	enemy_speed = spd


# Returns the value of the variable enemy_speed
func get_enemy_speed() -> float:
	return enemy_speed


# Sets the spawn time between enemies to the given value
func set_spawn_time(secs: float) -> void:
	timer.set_wait_time(secs)


# Returns the current spawn time between enemies
func get_spawn_time() -> float:
	return timer.get_wait_time()
