extends Controller

# * Signals
signal off_screen
signal cube_collision
signal jump_set_complete

# * Variables
var _in_contact := false setget set_contact
var _character: RigidBody2D
var _spawn_pos: Position2D
var _jumping := false
var _current_jump_set: int
var _speed_fall := false
var _mask_red: bool
var _mask_blue: bool

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_character = $Character
	_spawn_pos = $PlayerSpawn
	_current_jump_set = 0
	_mask_red = true
	_mask_blue = false


# Handles off screen events
func handle_off_screen() -> void:
	_current_jump_set = 0
	_character.set_position(_spawn_pos.get_position())
	_character.set_linear_velocity(Vector2(0, 0))
	emit_signal("off_screen")


# Handles cube collision events
func handle_cube_collision() -> void:
	emit_signal("cube_collision")


# Called when the main action is used
func main_used() -> void:
	if _in_contact:
		_character.set_linear_velocity(Vector2(0, -800))
		_character.set_gravity_scale(10)
		_jumping = true
	.main_used()


# Called when the main action is used
func secondary_used() -> void:
	_mask_red = not _mask_red
	_mask_blue = not _mask_blue
	_character.set_collision_mask_bit(0, _mask_red)
	_character.set_collision_mask_bit(1, _mask_blue)
	if _mask_red:
		_character.set_modulate(Color(1, 0, 0))
	if _mask_blue:
		_character.set_modulate(Color(0, 0, 1))


# Receives a change in contact from the character
func _inform_contact(_body: Node, contact: bool) -> void:
	set_contact(contact)


# Sets the _in_contact constant
func set_contact(contact: bool) -> void:
	if contact:
		_current_jump_set += 1
		if _current_jump_set == 10:
			_current_jump_set = 0
			emit_signal("jump_set_complete")
	_in_contact = contact


func _physics_process(_delta: float) -> void:
	if _jumping:
		if _character.get_linear_velocity()[1] > 0.0:
			_character.set_gravity_scale(0.5)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("main_action"):
		_character.set_gravity_scale(5)
		_jumping = false
