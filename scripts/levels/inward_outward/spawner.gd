extends Path2D

# * Signals

# * Variables
var sampler: PathFollow2D
var rng: RandomNumberGenerator

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sampler = $Sampler
	rng = RandomNumberGenerator.new()
	rng.randomize()


# Spawns a new enemy
func spawn(enemy, spd: float) -> void:
	sampler.set_unit_offset(rng.randf())
	enemy.set_position(sampler.position)
	if spd < 0:
		enemy.rotate(PI)
	enemy.set_speed(spd)
	enemy.show()
