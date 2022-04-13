extends Node2D

signal points_changed
signal drank_alcohol
signal started

export(GameMode.Name) var mode := GameMode.Name.Nick

export(NodePath) var _player_path := NodePath()
export(NodePath) var _nick_backgrounds_path := NodePath()
export(NodePath) var _stelios_backgrounds_path := NodePath()
export(NodePath) var _level_generator_path := NodePath()
export(NodePath) var _level_animations_path := NodePath()
export(NodePath) var _birthday_dudes_path := NodePath()

onready var _player := NodE.get_node_with_error(self, _player_path, Player) as Player
onready var _nick_backgrounds := get_node(_nick_backgrounds_path)
onready var _stelios_backgrounds := get_node(_stelios_backgrounds_path)

onready var _music := $Music as AudioStreamPlayer

onready var _level_generator := get_node(_level_generator_path)
onready var _level_animations := NodE.get_node_with_error(
	self, _level_animations_path, AnimationPlayer
) as AnimationPlayer

onready var _birthday_dudes := NodE.get_node_with_error(self, _birthday_dudes_path, Node2D) as Node2D

var total_points := 0

func _ready() -> void:
	_player.set_mode(mode)
	
	if mode == GameMode.Name.Nick:
		ObjEct.group_call(_nick_backgrounds.get_children(), 'set', ['visible', true])
		ObjEct.group_call(_stelios_backgrounds.get_children(), 'set', ['visible', false])
	
	elif mode == GameMode.Name.Stelios:
		ObjEct.group_call(_nick_backgrounds.get_children(), 'set', ['visible', false])
		ObjEct.group_call(_stelios_backgrounds.get_children(), 'set', ['visible', true])
	
	_level_generator.init_mode(mode)
	
	_birthday_dudes.init_mode(mode)
	
	var item_pickup := NodE.get_child(_player, ItemPickUp) as ItemPickUp
	assert(item_pickup)
	
	item_pickup.connect('scored', self, '_on_player_scored')
	
	var controller := Components.controller(_player)
	controller.connect('jump_just_pressed', self, '_on_jump_just_pressed', [], CONNECT_ONESHOT)

func _on_jump_just_pressed() -> void:
	_music.play()
	
	yield(get_tree().create_timer(1.0), 'timeout')
	_level_animations.play('level1')
	
	emit_signal('started')

func _on_player_scored(type: int, points: int) -> void:
	if type == PickUpItem.Type.Alcohol:
		emit_signal('drank_alcohol')
	
	total_points += points
	emit_signal('points_changed')
