extends Controller

# * Signals

# * Variables
var _initial_time: float
var _spawn_system: SpawnerSystem

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_system = $SpawnerSystem
	_initial_time = _spawn_system.get_spawn_time()


# Called when the difficulty is updated and should be overridden. By default
# only saves the new difficulty
func difficulty_updated(new_diff: float) -> void:
	.difficulty_updated(new_diff)
	var base_speed = 1.0 / _initial_time
	var spawn_speed_10 = base_speed * 3.0
	var total_spd_variance = spawn_speed_10 - base_speed
	_spawn_system.set_spawn_time(
		1.0 / (base_speed + ((new_diff - 1.0) / 9) * total_spd_variance)
	)
