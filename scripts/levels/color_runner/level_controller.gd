extends LevelController

# * Signals

# * Variables
var _world: Node2D
var _speed_step_ponderator: float

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_world = $World
	_speed_step_ponderator = 1.05


# Handles any level wide effects of the secondary action
func _on_secondary_pressed() -> void:
	._on_secondary_pressed()


# Adjust the hr parameters and notifies the controllers of the hr progress
func update_hr(tick: int) -> void:
	.update_hr(tick)
	var bonus_adjustment := 0.7
	var score_adjustment := 0.5
	var extra_bonus_speed := 0.0
	var extra_score_speed := 0.0
	var hr_target_progress = _hr_target_progress
	if hr_target_progress > 1.0:
		var extra_progress = hr_target_progress - 1.0
		extra_bonus_speed = (
			bonus_adjustment
			* bonus_adjustment
			* extra_progress
		)
		extra_score_speed = (
			score_adjustment
			* score_adjustment
			* extra_progress
		)
		hr_target_progress = 1.0
	level_gui.set_bonus_load_spd(
		1.0 + (hr_target_progress * bonus_adjustment) + extra_bonus_speed
	)
	level_gui.set_score_spd(
		1.0 + (hr_target_progress * score_adjustment) + extra_score_speed
	)


# Updates the score multiplier
func update_multiplier(up: bool) -> void:
	if up:
		level_gui.raise_multiplier()
	else:
		level_gui.lower_multiplier()


# Updates the speed of the score
func update_speed(up: bool) -> void:
	if up:
		level_gui.set_score_spd(
			level_gui.get_score_spd() * _speed_step_ponderator
		)
		$World/PlatformManager.update_speed(_speed_step_ponderator)
	else:
		level_gui.set_score_spd(
			level_gui.get_score_spd() / _speed_step_ponderator
		)
		$World/PlatformManager.update_speed(1 / _speed_step_ponderator)


# Adjusts the level difficulty according to a timer
func update_difficulty() -> void:
	.update_difficulty()
