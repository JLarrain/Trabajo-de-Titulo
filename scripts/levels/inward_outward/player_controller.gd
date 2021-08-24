extends Controller

# * Signals
signal damaged
signal healed

# * Variables
var _rail_system: RailSystem
var _base_player_speed: float
var _base_rotation_speed: float

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rail_system = $RailSystem
	_add_rail()
	_add_rail()
	_base_player_speed = _rail_system.get_player_speed()
	_base_rotation_speed = _rail_system.get_rot_speed()


# Called when the main action is used, reverts the movement directions
func main_used() -> void:
	_rail_system.toggle_direction()


# Called when the secondary action is used, removes a rail if possible
func secondary_used() -> void:
	_rail_system.remove_rail()


# Called when the difficulty is updated and should be overridden. By default
# only saves the new difficulty
func difficulty_updated(new_diff: float) -> void:
	.difficulty_updated(new_diff)
	# Move dificulty in 1 - 10+ scale
	var rot_speed_10 = _base_rotation_speed * 3.0
	var total_spd_variance = rot_speed_10 - _base_rotation_speed
	_rail_system.set_rot_speed(
		_base_rotation_speed + ((new_diff - 1.0) / 9) * total_spd_variance
	)


# Called when the heart rate progress is updated and should be overridden. By
# default only saves the heart rate progress
func hr_changed(new_hr_progress: float) -> void:
	.hr_changed(new_hr_progress)
	var spd_adjustment := 0.5
	var extra_spd := 0.0
	if new_hr_progress > 1.0:
		var extra_progress = new_hr_progress - 1.0
		extra_spd = (spd_adjustment * spd_adjustment * extra_progress)
		new_hr_progress = 1.0
	_rail_system.set_player_speed(
		_base_player_speed * ((spd_adjustment * new_hr_progress) + extra_spd)
	)


# Called when a bonus is used, adds a rail
func bonus_used() -> void:
	_add_rail()


# Adds a new rail for the player
func _add_rail() -> void:
	var rail = _rail_system.add_rail()
	rail.connect("ball_hit", self, "_get_damaged")
	rail.connect("ball_enabled", self, "_get_healed")


# Emits the damaged signal
func _get_damaged() -> void:
	emit_signal("damaged")


# Emits the healed signal
func _get_healed() -> void:
	emit_signal("healed")
