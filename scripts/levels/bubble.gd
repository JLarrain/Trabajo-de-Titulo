extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _heart_rate = -1
var _bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	
	add_to_group("bubble")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$b1.visible = false
	$b2.visible = false
	$b3.visible = false
	$b4.visible = false
	$b5.visible = false
	$b6.visible = false
	$def.visible = false
	
#	60 -> 120
#	defecto
	if _heart_rate == -1:
		if _bool:
			_bool = false
			print("Nvl : def")
		$b1.visible = false
		$b2.visible = false
		$b3.visible = false
		$b4.visible = false
		$b5.visible = false
		$b6.visible = false
		$def.visible = true
#	nivel 1
	elif _heart_rate <= 60:
		if _bool:
			_bool = false
			print("Nvl : 1")
		$b1.visible = true
		$b2.visible = false
		$b3.visible = false
		$b4.visible = false
		$b5.visible = false
		$b6.visible = false
		$def.visible = false
#	nivel 2
	elif _heart_rate > 60 and _heart_rate <= 75:
		if _bool:
			_bool = false
			print("Nvl : 2")
		$b1.visible = false
		$b2.visible = true
		$b3.visible = false
		$b4.visible = false
		$b5.visible = false
		$b6.visible = false
		$def.visible = false
#	nivel 3
	elif _heart_rate > 75 and _heart_rate <= 90:
		if _bool:
			_bool = false
			print("Nvl : 3")
		$b1.visible = false
		$b2.visible = false
		$b3.visible = true
		$b4.visible = false
		$b5.visible = false
		$b6.visible = false
		$def.visible = false
#	nivel 4
	elif _heart_rate > 90 and _heart_rate <= 105:
		if _bool:
			_bool = false
			print("Nvl : 4")
		$b1.visible = false
		$b2.visible = false
		$b3.visible = false
		$b4.visible = true
		$b5.visible = false
		$b6.visible = false
		$def.visible = false
#	nivel 5
	elif _heart_rate > 105 and _heart_rate <= 120:
		if _bool:
			_bool = false
			print("Nvl : 5")
		$b1.visible = false
		$b2.visible = false
		$b3.visible = false
		$b4.visible = false
		$b5.visible = true
		$b6.visible = false
		$def.visible = false
#	nivel 6
	elif _heart_rate > 120:
		if _bool:
			_bool = false
			print("Nvl : 6")
		$b1.visible = false
		$b2.visible = false
		$b3.visible = false
		$b4.visible = false
		$b5.visible = false
		$b6.visible = true
		$def.visible = false
		
	
func hrm_tick_bubble(hr: int) -> void:
	_heart_rate = hr
#	print("PUMP : %s" % hr)
	_bool = true
	
