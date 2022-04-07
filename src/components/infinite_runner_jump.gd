class_name InfiniteRunnerJump
extends Node2D

signal floor_left
signal floor_hit

export(float) var units := 1.0
export(float) var jump_height := 1.0
export(float) var gravity_up := 1.0
export(float) var gravity_down := 1.0
export(int) var coyote_msec := 200

var velocity := Vector2.ZERO

onready var _body := get_parent() as KinematicBody2D
onready var _controller := Components.controller(get_parent())

var _on_floor := false
var _jump_pressed := false

func _ready() -> void:
	_controller.connect('jump_just_pressed', self, '_on_jump_just_pressed')
	_controller.connect('jump_just_released', self, '_on_jump_just_released')

func _on_jump_just_pressed() -> void:
	if _jump_pressed:
		return
	
	var running_on_coyote_time := (OS.get_ticks_msec() - _msec_last_on_floor) < coyote_msec
	
	if not _on_floor and not running_on_coyote_time:
		return
	
	_jump_pressed = true
	
	velocity.y = -_get_impulse()

func _on_jump_just_released() -> void:
	if _on_floor:
		return
	
	if velocity.y > 0:
		return
	
	velocity.y /= 2.5

func _get_impulse() -> float:
	var h := jump_height
	var g := gravity_up
	var v0 := 0.0
	
	var initial_velocity := sqrt(v0*v0 + 2*g*h)
	
	return initial_velocity

var _msec_last_on_floor := -coyote_msec * 2.0

func _physics_process(delta: float) -> void:
	var gravity := gravity_down
	if velocity.y < 0:
		gravity = gravity_up
	
	velocity.y += gravity * delta
	
	var collider := _body.move_and_collide(velocity * units * delta)
	
	var previous_on_floor := _on_floor
	
	if collider:
		_on_floor = true
		velocity.y = 0
	else:
		_on_floor = false
	
	if previous_on_floor != _on_floor:
		if previous_on_floor and not _on_floor:
			_msec_last_on_floor = OS.get_ticks_msec()
			emit_signal('floor_left')
		
		if not previous_on_floor and _on_floor:
			_jump_pressed = false
			emit_signal('floor_hit')
	
	
