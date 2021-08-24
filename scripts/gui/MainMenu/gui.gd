# * Signals
extends Control

# * Signals

# Thrown to request exit from the game
signal exit_requested
# Thrown to request start of the game
signal start_requested
# Thrown to request start of hr updates
signal request_hr

# * Constants

# The texture to display in the panel when it's hidden
const HiddenTexture: StreamTexture = \
	preload("res://art/textures/gui/transparent_panel/transparent.png")
# The texture to display in the panel when it's shown
const PanelTexture: StreamTexture = \
	preload("res://art/textures/gui/transparent_panel/panel.png")

# * Variables

# The margins on the menu, to be restored after displaying the settings
var _menu_margins: Array
# The non-panel gui nodes
var _non_panel_nodes: Array
# The panel node
var _panel: NinePatchRect
# The scan gui node
var _scan_gui: Control
# Survey node
var _survey: Control

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets the focus to the scan button by default
	$Menu/MenuOptions/Scan.grab_focus()
	_scan_gui = $Menu/ScanGui
	_panel = $Menu/Separator
	_survey = $InitialSurvey
	_non_panel_nodes = $Menu.get_children()
	_non_panel_nodes.erase(_panel)
	_non_panel_nodes.erase(_scan_gui)
	_menu_margins = []
	_save_margins()


# Adds the given content to the panel
func _add_content(content: Node) -> void:
	var content_container = _panel.get_child(0)
	content_container.add_child(content)


# Removes all the children added to the panel
# contents and hides the panel
func _clean_panel() -> void:
	var content_container = _panel.get_child(0)
	if _scan_gui.visible:
		if content_container.is_a_parent_of(_scan_gui):
			content_container.remove_child(_scan_gui)
			$Menu.add_child(_scan_gui)
		_scan_gui.hide()
	for child in content_container.get_children():
		content_container.remove_child(child)
		child.queue_free()
	_hide_panel()


# Hides the non-panel gui nodes
func _hide_extras() -> void:
	for node in _non_panel_nodes:
		node.hide()


# Hides the panel border
func _hide_panel() -> void:
	_panel.set_texture(HiddenTexture)


# Hides the settings menu
func _hide_settings() -> void:
	_clean_panel()
	_load_margins(_menu_margins)
	_show_extras()


# Loads the menu margins from a variable
func _load_margins(margins: Array) -> void:
	for margin in range(0, 4):
		$Menu.set_margin(margin, margins[margin])


# When a device is ready, hides the scan and shows the start game button
func _prepare_start() -> void:
	print("On prepare start")
	_clean_panel()
	$Menu/MenuOptions.hide_scan()
	$Menu/MenuOptions.show_start()
	emit_signal("request_hr")


# Sends a signal to exit the game
func _quit_game() -> void:
	heart_connector.exit_gracefully()
	emit_signal("exit_requested")


# Saves the current menu margins to a variable
func _save_margins() -> void:
	for margin in range(0, 4):
		_menu_margins.append($Menu.get_margin(margin))


# Shows the non-panel gui nodes
func _show_extras() -> void:
	for node in _non_panel_nodes:
		node.show()


# Shows the scan dialog
func _show_scan() -> void:
	var content_container = _panel.get_child(0)
	if not content_container.is_a_parent_of(_scan_gui):
		$Menu.remove_child(_scan_gui)
		content_container.add_child(_scan_gui)
	_scan_gui.show()
	_scan_gui.start_scan()


# Shows the panel border
func _show_panel() -> void:
	_panel.set_texture(PanelTexture)


# Shows the settings menu
func _show_settings() -> void:
	# Requests a settings node
	var menu = settings.get_settings_menu()
	# Hide non-panel nodes
	_hide_extras()
	_clean_panel()
	_load_margins([20, 20, -20, -20])
	_add_content(menu)
	# Show the settings in the panel
	menu.set_return_name("Main Menu")
	menu.set_return_hook(self, "_hide_settings")
	_show_panel()


# Starts the survey previous to the game
func _start_survey() -> void:
	$Menu.hide()
	_survey.show()


# Sends a signal to start the game
func _start_game() -> void:
	emit_signal("start_requested")
