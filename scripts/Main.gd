extends Node

# * Signals
signal level_finished

# * Functions
var _data: Dictionary
var level_name := "main_menu"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_switcher.connect_current_scene()
	_data = {}
	_data["current_hr"] = -1.0


# Returns the configured data
func retrieve_data() -> Dictionary:
	print("Data retrieved:")
	print(_data)
	return _data


# Handles the game exit signal
func exit_game() -> void:
	get_tree().quit()


# Handles the game start signal
func start_game() -> void:
	emit_signal("level_finished")


# Returns the configured data
func _set_data(data: Dictionary) -> void:
	data["current_hr"] = _data["current_hr"]
	_data = data


# Configures hr updates
func config_hr() -> void:
	heart_connector.register_hrm(
		self, "_hr_placeholder", "update_hr", "_hr_placeholder"
	)


# Adjusts the current hr
func update_hr(tick: int) -> void:
	_data["current_hr"] = tick


# Works as a placeholder for scene_switcher calls
func set_start(_state: Dictionary) -> void:
	pass


# Works as a placeholder for unused hr signals
func _hr_placeholder(_val = false) -> void:
	pass
