class_name BirthdayDude
extends Area2D

export(AudioStream) var _nick: AudioStream = null
export(AudioStream) var _stelios: AudioStream = null

onready var _birthday_audio := NodE.get_child_with_error(self, AudioStreamPlayer) as AudioStreamPlayer
onready var _sprite_head := get_node('Head') as Sprite
onready var _head_position_hint := $HeadHint as Position2D

func _ready() -> void:
	connect('body_entered', self, '_on_body_entered', [], CONNECT_ONESHOT)
	
	var head_position := _head_position_hint.to_local(_sprite_head.global_position)
	_sprite_head.get_parent().remove_child(_sprite_head)
	_head_position_hint.add_child(_sprite_head)
	_sprite_head.position = head_position

func init_mode(mode: int) -> void:
	if mode == GameMode.Name.Nick:
		_birthday_audio.stream = _nick
	elif mode == GameMode.Name.Stelios:
		_birthday_audio.stream = _stelios

func _on_body_entered(body: PhysicsBody2D) -> void:
	_birthday_audio.play()
