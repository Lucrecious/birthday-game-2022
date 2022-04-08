extends Node2D

signal points_changed
signal started

export(NodePath) var _player_path := NodePath()
export(NodePath) var _level_generator_path := NodePath()
export(NodePath) var _level_animations_path := NodePath()

onready var _player := get_node(_player_path)
onready var _level_generator := get_node(_level_generator_path)
onready var _level_animations := NodE.get_node_with_error(
	self, _level_animations_path, AnimationPlayer
) as AnimationPlayer

var total_points := 0

func _ready() -> void:
	var item_pickup := NodE.get_child(_player, ItemPickUp) as ItemPickUp
	assert(item_pickup)
	
	item_pickup.connect('scored', self, '_on_player_scored')
	
	var controller := Components.controller(_player)
	controller.connect('jump_just_pressed', self, '_on_jump_just_pressed', [], CONNECT_ONESHOT)

func _on_jump_just_pressed() -> void:
	yield(get_tree().create_timer(1.0), 'timeout')
	_level_animations.play('level1')
	
	emit_signal('started')

func _on_player_scored(type: int, points: int) -> void:
	total_points += points
	emit_signal('points_changed')
