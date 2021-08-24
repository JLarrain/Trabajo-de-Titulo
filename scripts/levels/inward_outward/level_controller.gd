extends LevelController

# * Signals

# * Variables

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$World/PlayerController.connect("damaged", self, "_damaged")
	$World/PlayerController.connect("healed", self, "_healed")


# Handles any level wide effects of the secondary action
func _on_secondary_pressed() -> void:
	level_gui.lower_multiplier()
	._on_secondary_pressed()


# Lowers the multiplier when a ball is damaged
func _damaged() -> void:
	level_gui.lower_multiplier()


# Raises the multiplier when a ball is healed
func _healed() -> void:
	level_gui.raise_multiplier()


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


# Adjusts the level difficulty according to a timer
func update_difficulty() -> void:
	.update_difficulty()
