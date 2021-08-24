extends HBoxContainer

# * Signals
signal start_pressed
signal data_set(data)

# * Variables
var _page_tween: Tween
var _pad_left: VBoxContainer
var _pad_right: VBoxContainer
var _survey1: VBoxContainer
var _survey2: VBoxContainer
var _slider: Control
var _start_valence: float
var _start_arousal: float
var _target_valence: float
var _target_arousal: float

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_page_tween = $ChangePage
	_pad_left = $PadLeft
	_pad_right = $PadRight
	_survey1 = $Survey1
	_survey2 = $Survey2
	_slider = _survey2.get_node("Slider/SliderContainer/AffectiveSlider")
	_set_slider_pause(true)


# Changes the survey page
func _change_page() -> void:
	_page_tween.interpolate_method(
		_pad_left, "set_stretch_ratio", 1.0, 0.0, 2.0
	)
	_page_tween.interpolate_method(
		_pad_right, "set_stretch_ratio", 0.0, 1.0, 2.0
	)
	_page_tween.start()


# Sets the first answer
func _first_answer(valence: float, arousal: float) -> void:
	_start_valence = valence / 2
	_start_arousal = arousal
	_survey1.get_node("Question1").hide()
	_survey1.get_node("MoodButtons1").hide()
	_survey1.get_node("Question2").show()
	_survey1.get_node("MoodButtons2").show()


# Sets the second answer
func _second_answer(valence: float, arousal: float) -> void:
	_target_valence = valence
	_target_arousal = arousal
	if _target_arousal < 5:
		scene_switcher.set_path_mode(0)
	else:
		scene_switcher.set_path_mode(1)
	_set_slider_pause(false)
	_slider.change_valence(_start_valence)
	_change_page()


# Handles the start game press
func _start_game_pressed() -> void:
	save_data()
	emit_signal("start_pressed")


# Saves the current data to the main_menu
func save_data() -> void:
	var data = {}
	data["menu"] = true
	data["current_val"] = _start_valence
	data["current_diff"] = 0
	data["target_diff"] = 7
	emit_signal("data_set", data)


# Handles a change in the slider
func _slider_change(delta: float) -> void:
	_start_valence += (delta / 2)


# Pauses the slider processing: if pause is true, pauses
func _set_slider_pause(pause: bool) -> void:
	_slider.set_process(! pause)
	_slider.set_process_input(! pause)
	_slider.set_process_internal(! pause)
	_slider.set_process_unhandled_input(! pause)
	_slider.set_process_unhandled_key_input(! pause)
