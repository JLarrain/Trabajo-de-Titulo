extends Node

# * Signals

# * Variables
const _path_prefix := "res://scenes/levels/%s"
var _path: String
var _next_scene
var _prev_scene
var _next_state: Dictionary
var _path_list: PoolStringArray
var _path_number: int
const _ref_path_list := [
	"main_menu", "bubble/bubble"
]

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_path = ""
	_next_scene = null
	_path_list = _ref_path_list
	_path_number = 0


# Sets the path mode
func set_path_mode(mode: int) -> void:
	if (mode == 0) or (mode == 1):
		_path_list = _ref_path_list
		if mode == 1:
			var aux := _path_list[1]
			_path_list[1] = _path_list[2]
			_path_list[2] = aux


# Sets the scene change to start
func scene_change() -> void:
	_path_number += 1
	_path_number %= _path_list.size()
	_path = _path_prefix % _path_list[_path_number]
	_path += ".tscn"
	_preload_scene()
	_load_scene()


# Connects the current scene's finish signal to this node
func connect_current_scene() -> void:
	var _current_scene = get_tree().get_current_scene()
	_current_scene.connect(
		"level_finished", self, "scene_change", [], Object.CONNECT_ONESHOT
	)


# Preloads the scene in the given path
func _preload_scene() -> void:
	_next_scene = load(_path)


# Loads an already preloaded scene, returning the given path
func _load_scene() -> String:
	_next_state = _retrieve_state()
	call_deferred("_deferred_load")
	return _path


# Frees the current scene when it's safe
func _deferred_load() -> void:
	_prev_scene = get_tree().get_current_scene()
	get_tree().change_scene_to(_next_scene)


# Finished the loading of a scene after changing
func finish_load(node: Node) -> void:
	node.call_deferred(
		"connect",
		"level_finished",
		self,
		"scene_change",
		[],
		Object.CONNECT_ONESHOT
	)
	_load_previous_state(node)


# Retrieves the state of the current scene
func _retrieve_state() -> Dictionary:
	var _current_scene = get_tree().get_current_scene()
	var state = _current_scene.retrieve_data()
	var result = {}
	if not state.empty():
		if not state["menu"]:
			result["current_val"] = state["current_val"]
			var diff_raise = state["current_diff"] - state["base_diff"]
			var target_raise = state["target_diff"] - state["base_diff"]
			var raise_achieved = diff_raise / target_raise
			result["base_diff"] = state["current_diff"] - (diff_raise / 3)
			result["target_diff"] = (
				result["base_diff"]
				+ (target_raise * raise_achieved * 1.1)
			)
			result["current_hr"] = state["current_hr"]
		else:
			result["current_val"] = state["current_val"]
			result["base_diff"] = state["current_diff"]
			result["target_diff"] = state["target_diff"]
			result["current_hr"] = state["current_hr"]
	return result


# Loads the saved state from a previous scene
func _load_previous_state(scene) -> void:
	if not _next_state.empty():
		scene.call_deferred("set_start", _next_state)
