extends Node2D

var _lock_x := 0.0

onready var _body := get_parent() as KinematicBody2D

func _ready() -> void:
	_lock_x = _body.global_position.x

func _physics_process(delta: float):
	pass
	#_body.global_position.x = _lock_x
