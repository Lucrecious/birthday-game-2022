class_name ScrollMove
extends Node

export(float) var speed_pixels := 100.0
export(Vector2) var direction := Vector2.ZERO

onready var _body := get_parent()

var enabled := false

func _ready() -> void:
	set_physics_process(false)
	enable()

func enable() -> void:
	if enabled:
		return
	
	enabled = true
	set_physics_process(true)

func disable() -> void:
	if not enabled:
		return
	
	enabled = false
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	_body.position += direction * speed_pixels * delta
