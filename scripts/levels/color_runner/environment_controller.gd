extends Controller

# * Signals

# * Variables
var _plat_manager: Node2D

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_plat_manager = $PlatformManager


# Called when the secondary action is used
func secondary_used() -> void:
	_plat_manager.switch_layers()
	.secondary_used()


# Called when the bonus action is used
func bonus_used() -> void:
	_plat_manager.bonus_tick()
	.bonus_used()


# Updates the movement speed according to the ponderator
func update_speed(ponderator: float) -> void:
	_plat_manager.set_speed(ponderator * _plat_manager.get_speed())
