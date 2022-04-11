class_name Player
extends KinematicBody2D

export(NodePath) var _nick_sprite_path := NodePath()
export(NodePath) var _stelios_sprite_path := NodePath()

onready var _nick_sprite := get_node(_nick_sprite_path) as Node2D
onready var _stelios_sprite := get_node(_stelios_sprite_path) as Node2D

func set_mode(mode: int) -> void:
	if mode == GameMode.Name.Nick:
		_nick_sprite.visible = true
		_stelios_sprite.visible = false
		return
	
	if mode == GameMode.Name.Stelios:
		_nick_sprite.visible = false
		_stelios_sprite.visible = true
		return
